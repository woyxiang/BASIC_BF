#INCLUDE "crt.bi"
DIM SHARED src AS STRING
DIM SHARED lenSrc AS INTEGER
DIM SHARED pc AS INTEGER
DIM SHARED vPtr AS INTEGER
DIM SHARED buffer(30000) AS UBYTE
DIM SHARED stack(30000) AS INTEGER
DIM SHARED stackPtr AS INTEGER

SUB get_source()
    DIM AS STRING lineInput
    DIM AS INTEGER fileNumber
    DIM AS STRING filePath
    IF COMMAND(1) <> "" THEN
        filePath = COMMAND(1)
        fileNumber = FREEFILE
        OPEN filePath FOR INPUT AS #fileNumber
        WHILE NOT EOF(fileNumber)
            LINE INPUT #fileNumber, lineInput
            src += lineInput
        WEND
        CLOSE #fileNumber
        lenSrc = LEN(src)
    ELSE
        PRINT "Please provide the path to the Brainfuck source code file."
        END
    END If
END SUB

SUB interpret()
    WHILE pc <= lenSrc
        SELECT CASE MID(src, pc, 1)
            CASE ">"
                vPtr += 1
            CASE "<"
                vPtr -= 1
            CASE "+"
                buffer(vPtr) += 1
            CASE "-"
                buffer(vPtr) -= 1
            CASE "."
                PRINT CHR(buffer(vPtr));
            CASE ","
                buffer(vPtr) = ASC(INPUT(1))
            CASE "["
                IF buffer(vPtr) = 0 THEN
                    DIM level AS INTEGER = 1
                    DO
                        pc += 1
                        IF MID(src, pc, 1) = "[" THEN level += 1
                        IF MID(src, pc, 1) = "]" THEN level -= 1
                    LOOP UNTIL level = 0
                ELSE
                    stack(stackPtr) = pc
                    stackPtr += 1
                END IF
            CASE "]"
                IF buffer(vPtr) <> 0 THEN
                    pc = stack(stackPtr - 1)
                ELSE
                    stackPtr -= 1
                END IF
        END SELECT
        pc += 1
    WEND
END SUB

get_source()
interpret()