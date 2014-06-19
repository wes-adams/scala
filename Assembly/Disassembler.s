## 
##	
## Disassembler program 
##
## Wes Adams	
##
## wadams33.gatech.edu
##
##			
## 							 
		
	.data
       .globl binary_code		
binary_code: 
	.word 0x0c10000d  
	.word 0x2010ffff  
	.word 0x3c11ffff  
	.word 0x22310000  
	.word 0x3c12ff00 	
	.word 0x22527fff  
	.word 0x02329824  
	.word 0x3c141001  
	.word 0x22940004  
	.word 0x8e95fffc  
	.word 0x02b3b02a  
	.word 0xae960000  
	.word 0x06600002  
	.word 0x03e00008  
	.word 0xae930004  
	.word 0x03e00008  
	
	# delimiter
	.word 0x00000000
	.word 0x00000000
	
dollar:
	.asciiz "$"
space:	
	.asciiz " "
caret:	
	.asciiz "\n"	
lparen:	
	.asciiz "("
rparen:	
	.asciiz ")"
minus:	
	.asciiz "-"			
Ilw:	
	.asciiz "lw   "	  
	
Iaddi:	
	.asciiz "addi   "	  
	
Ibltz:	
	.asciiz "bltz   "	  
	
Isw:	
	.asciiz "sw   "	  
	
Ijal:	
	.asciiz "jal  "	  
	
Iand:	
	.asciiz "and   "	  
			
unsupport:	
	.asciiz "Unsupported opcode !!\n"	
pend:
	.asciiz "Done!\n"

	.align 5
scratchmem:	
	.space 8192
		
# Standard startup code.  Invoke the routine main with no arguments.

	.text
	.globl __start
__start: jal main
	addu $0, $0, $0		# Nop
	addiu $v0, $0, 10
	syscall			# syscall 10 (exit)


	.globl main
main:
	addu $25, $0, $31	# Save return PC, if you try to use $25, back it up before you use it

	
	
#================================================================================

					la		$t0,		binary_code
					addi	$t1,		$0,		0
					addi	$s0,		$0,		35			# 0x23			lw
					addi	$s1,		$0,		8			# 0x08			addi
					addi	$s2,		$0,		1			# 0x01			bltz
					addi	$s3,		$0,		38			# 0x26			sw
					addi	$s4,		$0,		3			# 0x03			jal
					addi	$s5,		$0,		0			# 0x00			and
					
#================================================================================

loop:				lw		$t3,		binary_code($t1)	# $t3 <- 32-bit code
					srl		$t4,		$t3,		26		# $t4 <- opcode
					beq		$t3,		$0,			zero	# end of list
					beq		$t4,		$s0,		lw_		# - Testing known opcodes
					beq		$t4,		$s1,		addi_	# -	Testing known opcodes
					beq		$t4,		$s2,		bltz_	# -	Testing known opcodes
					beq		$t4,		$s3,		sw_		# - Testing known opcodes
					beq		$t4,		$s4,		jal_	# -	Testing known opcodes
					beq		$t4,		$s5,		and_	# - Testing known opcodes
			
#================================================================================				

inval_:				jal		print_unsupport_
					addi	$t1,		$t1,		4		# increment counter
					j		loop
			
#================================================================================			

lw_:				jal		print_lw_
					jal		print_dollar_
					
					sll		$s6,		$t3,		6		# - Clear off opcode, leaving only rs rt & offset
					srl		$s6,		$s6,		6		# - Clear off opcode, leaving only rs rt & offset
					srl		$s6,		$s6,		21		# - Clear off offset and rt, leaving only rs
#					sll		$s6,		$s6,		21		# - Clear off offset and rt, leaving only rs
					jal		print_int_
					jal		print_space_
					
					sll		$s6,		$t3,		11		# - Clear off opcode and rs, leaving only rt and offset
					srl		$s6,		$s6,		11		# - Clear off opcode and rs, leaving only rt and offset
					srl		$s6,		$s6,		16		# - Clear off offset, leaving only rt
#					sll		$s6,		$s6,		16		# - Clear off offset, leaving only rt
					jal		print_int_
					jal		print_space_
					
					sll		$s6,		$t3,		16		# - Clear off opcode rs & rt, leaving only offset
					srl		$s6,		$s6,		16		# - Clear off opcode rs & rt, leaving only offset
					jal		print_signed_int_
					
					jal		print_caret_
					addi	$t1,		$t1,		4		# increment counter
					j		loop
			
addi_:				jal		print_addi_
					jal		print_dollar_
					
					sll		$s6,		$t3,		6		# - Clear off opcode, leaving only rs rt & offset
					srl		$s6,		$s6,		6		# - Clear off opcode, leaving only rs rt & offset
					srl		$s6,		$s6,		21		# - Clear off offset and rt, leaving only rs
#					sll		$s6,		$s6,		21		# - Clear off offset and rt, leaving only rs
					jal		print_int_
					jal		print_space_
					
					jal		print_dollar_
					
					sll		$s6,		$t3,		11		# - Clear off opcode and rs, leaving only rt and offset
					srl		$s6,		$s6,		11		# - Clear off opcode and rs, leaving only rt and offset
					srl		$s6,		$s6,		16		# - Clear off offset, leaving only rt
#					sll		$s6,		$s6,		16		# - Clear off offset, leaving only rt
					jal		print_int_
					jal		print_space_
					
					sll		$s6,		$t3,		16		# - Clear off opcode rs & rt, leaving only offset
					srl		$s6,		$s6,		16		# - Clear off opcode rs & rt, leaving only offset
					jal		print_signed_int_
					
					jal		print_caret_
					addi	$t1,		$t1,		4		# increment counter
					j		loop
					
bltz_:				jal		print_bltz_
					jal		print_dollar_
					
					sll		$s6,		$t3,		6		# - Clear off opcode, leaving only rs rt & offset
					srl		$s6,		$s6,		6		# - Clear off opcode, leaving only rs rt & offset
					srl		$s6,		$s6,		21		# - Clear off offset and rt, leaving only rs
#					sll		$s6,		$s6,		21		# - Clear off offset and rt, leaving only rs
					jal		print_int_
					jal		print_space_
					
					jal		print_dollar_
					
					sll		$s6,		$t3,		11		# - Clear off opcode and rs, leaving only rt and offset
					srl		$s6,		$s6,		11		# - Clear off opcode and rs, leaving only rt and offset
					srl		$s6,		$s6,		16		# - Clear off offset, leaving only rt
#					sll		$s6,		$s6,		16		# - Clear off offset, leaving only rt
					jal		print_int_
					jal		print_space_
					
					sll		$s6,		$t3,		16		# - Clear off opcode rs & rt, leaving only offset
					srl		$s6,		$s6,		16		# - Clear off opcode rs & rt, leaving only offset
					jal		print_signed_int_
					
					jal		print_caret_
					addi	$t1,		$t1,		4		# increment counter
					j		loop
					
sw_:				jal		print_sw_
					jal		print_dollar_
					
					sll		$s6,		$t3,		6		# - Clear off opcode, leaving only rs rt & offset
					srl		$s6,		$s6,		6		# - Clear off opcode, leaving only rs rt & offset
					srl		$s6,		$s6,		21		# - Clear off offset and rt, leaving only rs
#					sll		$s6,		$s6,		21		# - Clear off offset and rt, leaving only rs
					jal		print_int_
					jal		print_space_
					
					jal		print_dollar_
					
					sll		$s6,		$t3,		11		# - Clear off opcode and rs, leaving only rt and offset
					srl		$s6,		$s6,		11		# - Clear off opcode and rs, leaving only rt and offset
					srl		$s6,		$s6,		16		# - Clear off offset, leaving only rt
#					sll		$s6,		$s6,		16		# - Clear off offset, leaving only rt
					jal		print_int_
					jal		print_space_
					
					sll		$s6,		$t3,		16		# - Clear off opcode rs & rt, leaving only offset
					srl		$s6,		$s6,		16		# - Clear off opcode rs & rt, leaving only offset
					jal		print_signed_int_
					
					jal		print_caret_
					addi	$t1,		$t1,		4		# increment counter
					j		loop

jal_:				jal		print_jal_
					sll		$s6,		$t3,		6		# - Clear off opcode, leaving only target
					srl		$s6,		$s6,		6		# - Clear off opcode, leaving only target
					jal		print_int_
					jal		print_caret_
					addi	$t1,		$t1,		4		# increment counter
					j		loop
					
and_:				jal		print_and_
					jal		print_dollar_
					
					sll		$s6,		$t3,		6		# - Clear off opcode, leaving only rs rt & offset
					srl		$s6,		$s6,		6		# - Clear off opcode, leaving only rs rt & offset
					srl		$s6,		$s6,		21		# - Clear off offset and rt, leaving only rs
#					sll		$s6,		$s6,		21		# - Clear off offset and rt, leaving only rs
					jal		print_int_
					jal		print_space_
					
					jal		print_dollar_
					
					sll		$s6,		$t3,		11		# - Clear off opcode and rs, leaving only rt and offset
					srl		$s6,		$s6,		11		# - Clear off opcode and rs, leaving only rt and offset
					srl		$s6,		$s6,		16		# - Clear off offset, leaving only rt
#					sll		$s6,		$s6,		16		# - Clear off offset, leaving only rt
					jal		print_int_
					jal		print_space_
					
					sll		$s6,		$t3,		16		# - Clear off opcode rs & rt, leaving only offset
					srl		$s6,		$s6,		16		# - Clear off opcode rs & rt, leaving only offset
					jal		print_signed_int_
					
					jal		print_caret_
					addi	$t1,		$t1,		4		# increment counter
					j		loop
					
zero:				j		Exit

#================================================================================			
#					PRINTING SUBROUTINES

print_int_:			li		$v0,		1					# prepare to print int		
					add		$a0,		$0,			$s6		# $s6 <- int to be printed
					syscall
					jr		$ra
					
print_signed_int_:	srl		$t6,		$s6,		15		# prepare to analyze sign bit
					bgtz	$t6,		negate_				# if sign bit = 1, branch to negate
print_s_int_:		li		$v0,		1					# prepare to print int		
					add		$a0,		$0,			$s6		# $s6 <- int to be printed
					syscall
					jr		$ra
negate_:			li		$v0,		4					# prepare to print
					la		$a0,		minus
					syscall
					sll		$s6,		$s6,		1		# - remove sign bit before printing
					srl		$s6,		$s6,		1		# - remove sign bit before printing
					j		print_s_int_	
					

print_dollar_:		li		$v0,		4					# prepare to print
					la		$a0,		dollar
					syscall
					jr		$ra
					
print_space_:		li		$v0,		4					# prepare to print
					la		$a0,		space
					syscall
					jr		$ra
					
print_neg_:			li		$v0,		4					# prepare to print
					la		$a0,		minus
					syscall
					jr		$ra
		
print_caret_:		li		$v0,		4					# prepare to print
					la		$a0,		caret
					syscall
					jr		$ra
					
print_lparen_:		li		$v0,		4					# prepare to print
					la		$a0,		lparen
					syscall
					jr		$ra
					
print_rparen_:		li		$v0,		4					# prepare to print
					la		$a0,		rparen
					syscall
					jr		$ra
					
print_lw_:			li		$v0,		4					# prepare to print
					la		$a0,		Ilw
					syscall
					jr		$ra
					
print_addi_:		li		$v0,		4					# prepare to print
					la		$a0,		Iaddi
					syscall
					jr		$ra
					
print_bltz_:		li		$v0,		4					# prepare to print
					la		$a0,		Ibltz
					syscall
					jr		$ra
					
print_sw_:			li		$v0,		4					# prepare to print
					la		$a0,		Isw
					syscall
					jr		$ra

print_jal_:			li		$v0,		4					# prepare to print
					la		$a0,		Ijal
					syscall
					jr		$ra
					
print_and_:			li		$v0,		4					# prepare to print
					la		$a0,		Iand
					syscall
					jr		$ra
					
print_unsupport_:	li		$v0,		4					# prepare to print
					la		$a0,		unsupport
					syscall
					jr		$ra
					
print_done_:		li		$v0,		4					# prepare to print
					la		$a0,		pend
					syscall
					jr		$ra
					
#================================================================================					

Exit:

	li $v0, 4
	la $a0, pend
	syscall
	jr $25	
