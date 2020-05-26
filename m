Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5619F199F75
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgCaTvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:51:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39527 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgCaTvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 15:51:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id e9so4297977wme.4
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XS70HuyfnfDWUuokOJC2p9A8chTyL8w8PwgHYlhSinM=;
        b=HG+FWu/E8Ecjv6NCw/SlluIZgoabFwyvTqQCPXh4OSDAAtmcc32hA4ifWzb5qCrKNk
         KXKnsLbBLp3f9dXhv7JIux+nxgJY+BmzAB6de4eWuvQAAm3Rc4anKPIOTy4jL6NAVpcR
         1kQqbUdVZ7evLLXeZd97GWf8ogrmRnH8FhwhOVXiXuKL//9rbPflf4MXLvGOeCQowI8I
         CWlL6fdKHrK57ocNgE/w+QlFgQEYxea6WoHqTIm4+va09jOaVDSld/YRGirrH01kI9IR
         4YSKS4l8NEEejTkYyO+vBRtIVLemdsgRE65VC2WV3CZsUBsUWKGnBsxbF8i1Vg7rNIRk
         waGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XS70HuyfnfDWUuokOJC2p9A8chTyL8w8PwgHYlhSinM=;
        b=pLDcnCiMeMNzlab4tcMHvE1z8pPT5tM97u5lAv7Mi+h7VCp+YvvCoktQ7erUBHXNON
         dlnBoDAUhpknxtYt67uxcK9zeJmEn3y3Np5ySr3GTiwDEMotDk1yzGlCcjYUrrJro4ml
         f6AXH98jV+Gj1iFP4lteKk8k1tOAdDuPx5IfdtJI450e8PLFIfP7oitgi0mXrM9s+Xrb
         IdmacIDDEoSosj6xfovrWPO33G/nlkyRYeZYfr82lXAYxGdPSE4Z1FAl6rhj9VxAOkdi
         ASDUbpRGVXcEtXnUF7tMrVgd9KHnf+/3HMBzwPl9JX7JLILp/yqU7656JpsEnRKLLENf
         cz/Q==
X-Gm-Message-State: AGi0PuaePbVfGfmCRrh2rPrJmJk0ES5SNiSfwmoEgVhp58lmOVR8RL3j
        3XjoYCJswXmYm/CtNRJqEnrUQwwAXV4=
X-Google-Smtp-Source: APiQypJjFe8Hj0rgwaQRTKOFyXBechsIEwi+QswqQWl6WGepmgzDXKr0TIKA4qXLMtzz5gs+1tfWIQ==
X-Received: by 2002:a1c:7412:: with SMTP id p18mr488519wmc.11.1585684275471;
        Tue, 31 Mar 2020 12:51:15 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id v7sm25598576wrs.96.2020.03.31.12.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 12:51:14 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH] KVM: SVM: Split svm_vcpu_run inline assembly to a separate file.
Date:   Tue, 31 Mar 2020 21:51:08 +0200
Message-Id: <20200331195108.71490-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The compiler (GCC) does not like the situation, where there is inline
assembly block that clobbers all available machine registers in the
middle of the function. This situation can be found in function
svm_vcpu_run in file kvm/vmx.c and results in many register spills and
fills to/from stack frame.

This patch fixes the issue with the same approach as was done for
VMX some time ago. The big inline assembly is moved to a separate
assembly .S file, taking into account all ABI requirements.

There are two main benefits of the above approach:

* elimination of several register spills and fills to/from stack
frame, and consequently smaller function .text size. The binary size
of svm_vcpu_run is lowered from 2019 to 1626 bytes.

* more efficient access to a register save array. Currently, register
save array is accessed as:

    7b00:    48 8b 98 28 02 00 00     mov    0x228(%rax),%rbx
    7b07:    48 8b 88 18 02 00 00     mov    0x218(%rax),%rcx
    7b0e:    48 8b 90 20 02 00 00     mov    0x220(%rax),%rdx

and passing ia pointer to a register array as an argument to a function one gets:

  12:    48 8b 48 08              mov    0x8(%rax),%rcx
  16:    48 8b 50 10              mov    0x10(%rax),%rdx
  1a:    48 8b 58 18              mov    0x18(%rax),%rbx

As a result, the total size, considering that the new function size is 229
bytes, gets lowered by 164 bytes.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/Makefile      |   2 +-
 arch/x86/kvm/svm.c         |  92 +--------------------
 arch/x86/kvm/svm_vmenter.S | 162 +++++++++++++++++++++++++++++++++++++
 3 files changed, 166 insertions(+), 90 deletions(-)
 create mode 100644 arch/x86/kvm/svm_vmenter.S

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index b19ef421084d..30b2c9e8a588 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -13,7 +13,7 @@ kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
-kvm-amd-y		+= svm.o pmu_amd.o
+kvm-amd-y		+= svm.o svm_vmenter.o pmu_amd.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
 obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bef0ba35f121..2c2bc1f79ec7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5714,6 +5714,8 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	svm_complete_interrupts(svm);
 }
 
+bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
+
 static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -5768,95 +5770,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	local_irq_enable();
 
-	asm volatile (
-		"push %%" _ASM_BP "; \n\t"
-		"mov %c[rbx](%[svm]), %%" _ASM_BX " \n\t"
-		"mov %c[rcx](%[svm]), %%" _ASM_CX " \n\t"
-		"mov %c[rdx](%[svm]), %%" _ASM_DX " \n\t"
-		"mov %c[rsi](%[svm]), %%" _ASM_SI " \n\t"
-		"mov %c[rdi](%[svm]), %%" _ASM_DI " \n\t"
-		"mov %c[rbp](%[svm]), %%" _ASM_BP " \n\t"
-#ifdef CONFIG_X86_64
-		"mov %c[r8](%[svm]),  %%r8  \n\t"
-		"mov %c[r9](%[svm]),  %%r9  \n\t"
-		"mov %c[r10](%[svm]), %%r10 \n\t"
-		"mov %c[r11](%[svm]), %%r11 \n\t"
-		"mov %c[r12](%[svm]), %%r12 \n\t"
-		"mov %c[r13](%[svm]), %%r13 \n\t"
-		"mov %c[r14](%[svm]), %%r14 \n\t"
-		"mov %c[r15](%[svm]), %%r15 \n\t"
-#endif
-
-		/* Enter guest mode */
-		"push %%" _ASM_AX " \n\t"
-		"mov %c[vmcb](%[svm]), %%" _ASM_AX " \n\t"
-		__ex("vmload %%" _ASM_AX) "\n\t"
-		__ex("vmrun %%" _ASM_AX) "\n\t"
-		__ex("vmsave %%" _ASM_AX) "\n\t"
-		"pop %%" _ASM_AX " \n\t"
-
-		/* Save guest registers, load host registers */
-		"mov %%" _ASM_BX ", %c[rbx](%[svm]) \n\t"
-		"mov %%" _ASM_CX ", %c[rcx](%[svm]) \n\t"
-		"mov %%" _ASM_DX ", %c[rdx](%[svm]) \n\t"
-		"mov %%" _ASM_SI ", %c[rsi](%[svm]) \n\t"
-		"mov %%" _ASM_DI ", %c[rdi](%[svm]) \n\t"
-		"mov %%" _ASM_BP ", %c[rbp](%[svm]) \n\t"
-#ifdef CONFIG_X86_64
-		"mov %%r8,  %c[r8](%[svm]) \n\t"
-		"mov %%r9,  %c[r9](%[svm]) \n\t"
-		"mov %%r10, %c[r10](%[svm]) \n\t"
-		"mov %%r11, %c[r11](%[svm]) \n\t"
-		"mov %%r12, %c[r12](%[svm]) \n\t"
-		"mov %%r13, %c[r13](%[svm]) \n\t"
-		"mov %%r14, %c[r14](%[svm]) \n\t"
-		"mov %%r15, %c[r15](%[svm]) \n\t"
-		/*
-		* Clear host registers marked as clobbered to prevent
-		* speculative use.
-		*/
-		"xor %%r8d, %%r8d \n\t"
-		"xor %%r9d, %%r9d \n\t"
-		"xor %%r10d, %%r10d \n\t"
-		"xor %%r11d, %%r11d \n\t"
-		"xor %%r12d, %%r12d \n\t"
-		"xor %%r13d, %%r13d \n\t"
-		"xor %%r14d, %%r14d \n\t"
-		"xor %%r15d, %%r15d \n\t"
-#endif
-		"xor %%ebx, %%ebx \n\t"
-		"xor %%ecx, %%ecx \n\t"
-		"xor %%edx, %%edx \n\t"
-		"xor %%esi, %%esi \n\t"
-		"xor %%edi, %%edi \n\t"
-		"pop %%" _ASM_BP
-		:
-		: [svm]"a"(svm),
-		  [vmcb]"i"(offsetof(struct vcpu_svm, vmcb_pa)),
-		  [rbx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RBX])),
-		  [rcx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RCX])),
-		  [rdx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RDX])),
-		  [rsi]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RSI])),
-		  [rdi]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RDI])),
-		  [rbp]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RBP]))
-#ifdef CONFIG_X86_64
-		  , [r8]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R8])),
-		  [r9]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R9])),
-		  [r10]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R10])),
-		  [r11]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R11])),
-		  [r12]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R12])),
-		  [r13]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R13])),
-		  [r14]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R14])),
-		  [r15]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R15]))
-#endif
-		: "cc", "memory"
-#ifdef CONFIG_X86_64
-		, "rbx", "rcx", "rdx", "rsi", "rdi"
-		, "r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15"
-#else
-		, "ebx", "ecx", "edx", "esi", "edi"
-#endif
-		);
+	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
 	/* Eliminate branch target predictions from guest mode */
 	vmexit_fill_RSB();
diff --git a/arch/x86/kvm/svm_vmenter.S b/arch/x86/kvm/svm_vmenter.S
new file mode 100644
index 000000000000..42ec664b0b5a
--- /dev/null
+++ b/arch/x86/kvm/svm_vmenter.S
@@ -0,0 +1,162 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/linkage.h>
+#include <asm/asm.h>
+#include <asm/bitsperlong.h>
+#include <asm/kvm_vcpu_regs.h>
+
+#define WORD_SIZE (BITS_PER_LONG / 8)
+
+/* Intentionally omit RAX as it's context switched by hardware */
+#define VCPU_RCX	__VCPU_REGS_RCX * WORD_SIZE
+#define VCPU_RDX	__VCPU_REGS_RDX * WORD_SIZE
+#define VCPU_RBX	__VCPU_REGS_RBX * WORD_SIZE
+/* Intentionally omit RSP as it's context switched by hardware */
+#define VCPU_RBP	__VCPU_REGS_RBP * WORD_SIZE
+#define VCPU_RSI	__VCPU_REGS_RSI * WORD_SIZE
+#define VCPU_RDI	__VCPU_REGS_RDI * WORD_SIZE
+
+#ifdef CONFIG_X86_64
+#define VCPU_R8		__VCPU_REGS_R8  * WORD_SIZE
+#define VCPU_R9		__VCPU_REGS_R9  * WORD_SIZE
+#define VCPU_R10	__VCPU_REGS_R10 * WORD_SIZE
+#define VCPU_R11	__VCPU_REGS_R11 * WORD_SIZE
+#define VCPU_R12	__VCPU_REGS_R12 * WORD_SIZE
+#define VCPU_R13	__VCPU_REGS_R13 * WORD_SIZE
+#define VCPU_R14	__VCPU_REGS_R14 * WORD_SIZE
+#define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
+#endif
+
+	.text
+
+/**
+ * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
+ * @vmcb_pa:	unsigned long
+ * @regs:	unsigned long * (to guest registers)
+ */
+SYM_FUNC_START(__svm_vcpu_run)
+	push %_ASM_BP
+	mov  %_ASM_SP, %_ASM_BP
+#ifdef CONFIG_X86_64
+	push %r15
+	push %r14
+	push %r13
+	push %r12
+#else
+	push %edi
+	push %esi
+#endif
+	push %_ASM_BX
+
+	/* Save @regs. */
+	push %_ASM_ARG2
+
+	/* Save @vmcb_pa. */
+	push %_ASM_ARG1
+
+	/* Move @regs to RAX. */
+	mov %_ASM_ARG2, %_ASM_AX
+
+	/* Load guest registers. */
+	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
+	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
+	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
+	mov VCPU_RBP(%_ASM_AX), %_ASM_BP
+	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
+	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
+#ifdef CONFIG_X86_64
+	mov VCPU_R8 (%_ASM_AX),  %r8
+	mov VCPU_R9 (%_ASM_AX),  %r9
+	mov VCPU_R10(%_ASM_AX), %r10
+	mov VCPU_R11(%_ASM_AX), %r11
+	mov VCPU_R12(%_ASM_AX), %r12
+	mov VCPU_R13(%_ASM_AX), %r13
+	mov VCPU_R14(%_ASM_AX), %r14
+	mov VCPU_R15(%_ASM_AX), %r15
+#endif
+
+	/* "POP" @vmcb_pa to RAX. */
+	pop %_ASM_AX
+
+	/* Enter guest mode */
+1:	vmload %_ASM_AX
+	jmp 3f
+2:	cmpb $0, kvm_rebooting
+	jne 3f
+	ud2
+	_ASM_EXTABLE(1b, 2b)
+
+3:	vmrun %_ASM_AX
+	jmp 5f
+4:	cmpb $0, kvm_rebooting
+	jne 5f
+	ud2
+	_ASM_EXTABLE(3b, 4b)
+
+5:	vmsave %_ASM_AX
+	jmp 7f
+6:	cmpb $0, kvm_rebooting
+	jne 7f
+	ud2
+	_ASM_EXTABLE(5b, 6b)
+7:
+	/* "POP" @regs to RAX. */
+	pop %_ASM_AX
+
+	/* Save all guest registers.  */
+	mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
+	mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
+	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
+	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
+	mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
+	mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
+#ifdef CONFIG_X86_64
+	mov %r8,  VCPU_R8 (%_ASM_AX)
+	mov %r9,  VCPU_R9 (%_ASM_AX)
+	mov %r10, VCPU_R10(%_ASM_AX)
+	mov %r11, VCPU_R11(%_ASM_AX)
+	mov %r12, VCPU_R12(%_ASM_AX)
+	mov %r13, VCPU_R13(%_ASM_AX)
+	mov %r14, VCPU_R14(%_ASM_AX)
+	mov %r15, VCPU_R15(%_ASM_AX)
+#endif
+
+	/*
+	 * Clear all general purpose registers except RSP and RAX to prevent
+	 * speculative use of the guest's values, even those that are reloaded
+	 * via the stack.  In theory, an L1 cache miss when restoring registers
+	 * could lead to speculative execution with the guest's values.
+	 * Zeroing XORs are dirt cheap, i.e. the extra paranoia is essentially
+	 * free.  RSP and RAX are exempt as they are restored by hardware
+	 * during VM-Exit.
+	 */
+	xor %ecx, %ecx
+	xor %edx, %edx
+	xor %ebx, %ebx
+	xor %ebp, %ebp
+	xor %esi, %esi
+	xor %edi, %edi
+#ifdef CONFIG_X86_64
+	xor %r8d,  %r8d
+	xor %r9d,  %r9d
+	xor %r10d, %r10d
+	xor %r11d, %r11d
+	xor %r12d, %r12d
+	xor %r13d, %r13d
+	xor %r14d, %r14d
+	xor %r15d, %r15d
+#endif
+
+	pop %_ASM_BX
+
+#ifdef CONFIG_X86_64
+	pop %r12
+	pop %r13
+	pop %r14
+	pop %r15
+#else
+	pop %esi
+	pop %edi
+#endif
+	pop %_ASM_BP
+	ret
+SYM_FUNC_END(__svm_vcpu_run)
-- 
2.25.1

