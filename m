Return-Path: <kvm+bounces-9923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73955867941
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:59:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF1EB1F273CD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41DB312F39B;
	Mon, 26 Feb 2024 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eARcu9Ue"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC0B1493BB;
	Mon, 26 Feb 2024 14:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958324; cv=none; b=g8E64MszClTn9Tnm0WqNSN7K9p5ENXXT1+btnGfbfwBk+R4s9D2mmsV+7rI6lTezUFb9fhWF9D6/lTvTjrEqxNrnEQGciflCJR3Rxn6Fe3qVHIKatm9dCEpZZBQYqinu3AH5UJyDGYiCecP4BWOtI5cZval2XFuQKdkfLqqJlDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958324; c=relaxed/simple;
	bh=SLhgYKuPHi8csFeflHgabtrSknwIG69hI70qF43PcK4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OQTI1XJz8m85lOf3/3g57stDplpq75kLcMePI2XLXYPZuz2GbKrGNDYKwOmCA8i9ZFXFdVHULkdWj3+THrZIvQ68pTqXcix8VxtZHg0Fnxeaq1/I5OVK6B61lfyMM0WWTfnYC6xl32zAD8bVhkheTYYN8mabn8hVr6KZa9eB/LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eARcu9Ue; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5d42e7ab8a9so2024215a12.3;
        Mon, 26 Feb 2024 06:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958322; x=1709563122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ug0/Ozbtd//lDi/KPWyH65r/e2ls8s75iPqWftOikEI=;
        b=eARcu9UecBxp4ADxwPiN3N0XTXACqZZa1oSw3VyGzupHxOW/NDcdjKzH8H3J6WOPyL
         /rNcjgJjTxb7G0nZA3nC+3xAEWQA0tLVRuof85f625mNYJVB1STasd1ZcEundo21jT69
         a93gM+z9K2MeRLPSZTnn+QcTMzcc2y1KgaW4rkpnphWeVJcA7rxcxTgcqhLdEnYpuQYp
         S+JFyfSHjdKFB8BdxCajBFwNaeiTF6KiRb6qjhiqw4RQFQp3M3PY66H3NU3yxDArj2mL
         IjLHSoRB/fr4XHPYQEaYdW5TRVVq/swqzcfb8PeaWp6m03Z6m2dG5+prXXrfXyOGXM7w
         Ajxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958322; x=1709563122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ug0/Ozbtd//lDi/KPWyH65r/e2ls8s75iPqWftOikEI=;
        b=lgy8TFthO9KXk9Xt5zHL8earQWaU3tJ7hNLt85V5kMG+EF99bC8V4Ot4tRIwZKJQhy
         lYfllIn3cOYQIlVwxrbvyRkzMeNffVBwPMjmwH9ZTIG1xSmjseTN9x+vfIz8wsAkagbp
         78rBl3frmJJefLATok5RkiTLJ3NmsXvu7lCVb+I+cr3HRdN0h9oF2nCo3xyIsp8HjZGG
         2vojgVuQnPUhAS8bAqpzTmcoWf7Bxw4OWV3TFwUvm1TmTdYbDtFA2O0tuZlbhuId+Ix7
         rzgBIACiPI/fjPlj7NbAZxCkEPJlpXy521vOw/2UaPlCW1XkC0oLbhHSszogagpHgzZZ
         nTVw==
X-Forwarded-Encrypted: i=1; AJvYcCX07f/gSdbfq/Ua636k/cJNLLkqHZxWHrIy/vvpWwy7c0xxdeiQSldFs7/vHNVF0reZISBVWwWsbh9i5wfdCcmsZnfx
X-Gm-Message-State: AOJu0YzMomc1YQW45v9KRQ2YAOPmj4AviZxDPnJnnsqZlPBDemBBR04F
	26BJZPePoUSn5QeLxP+kKd+o6i/VkiHh6Ac+e4xzbZNe2d3B83rQNziaHpoA
X-Google-Smtp-Source: AGHT+IHmFbJBB+6VdoPL7S61I+zWD/b66M8dOZUr2V5eQrVF+O410IIAKimyG9Bva56zt/zGd2prMg==
X-Received: by 2002:a17:90a:bd0a:b0:299:489f:fd2d with SMTP id y10-20020a17090abd0a00b00299489ffd2dmr4509515pjr.20.1708958321604;
        Mon, 26 Feb 2024 06:38:41 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id nr14-20020a17090b240e00b00299332505d7sm1426793pjb.26.2024.02.26.06.38.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:38:41 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Andy Lutomirski <luto@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 60/73] x86/pvm: Add event entry/exit and dispatch code
Date: Mon, 26 Feb 2024 22:36:17 +0800
Message-Id: <20240226143630.33643-61-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

In PVM, it does not use IDT-based event delivery and instead utilizes a
specific event delivery method similar to FRED.

For user mode events, stack switching and GSBASE switching are done
directly by the hypervisor. The default stack in the entry is already
the task stack, and user mode states are saved in the shared PVCS
structure. In order to avoid modifying the "vector" in the PVCS for
direct switching of the syscall event, the syscall event still uses
MSR_LSTAR as the entry.

For supervisor mode events with vector < 32, old states are saved in the
current stack. And for events with vector >=32, old states are saved in
the PVCS, since the entry is irq disabled and old states will be saved
into stack before enabling irq.  Additionally, there is no #DF for PVM
guests, as the hypervisor will treat it as a triple fault directly.
Finally, no IST is needed.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Co-developed-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/entry/Makefile         |   1 +
 arch/x86/entry/entry_64_pvm.S   | 152 +++++++++++++++++++++++++++
 arch/x86/include/asm/pvm_para.h |   8 ++
 arch/x86/kernel/pvm.c           | 181 ++++++++++++++++++++++++++++++++
 4 files changed, 342 insertions(+)
 create mode 100644 arch/x86/entry/entry_64_pvm.S

diff --git a/arch/x86/entry/Makefile b/arch/x86/entry/Makefile
index 55dd3f193d99..d9cb970dfe06 100644
--- a/arch/x86/entry/Makefile
+++ b/arch/x86/entry/Makefile
@@ -20,6 +20,7 @@ obj-y				+= vsyscall/
 obj-$(CONFIG_PREEMPTION)	+= thunk_$(BITS).o
 obj-$(CONFIG_IA32_EMULATION)	+= entry_64_compat.o syscall_32.o
 obj-$(CONFIG_X86_X32_ABI)	+= syscall_x32.o
+obj-$(CONFIG_PVM_GUEST) 	+= entry_64_pvm.o
 
 ifeq ($(CONFIG_X86_64),y)
 	obj-y += 		entry_64_switcher.o
diff --git a/arch/x86/entry/entry_64_pvm.S b/arch/x86/entry/entry_64_pvm.S
new file mode 100644
index 000000000000..256baf86a9f3
--- /dev/null
+++ b/arch/x86/entry/entry_64_pvm.S
@@ -0,0 +1,152 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/asm-offsets.h>
+#include <asm/percpu.h>
+#include <asm/pvm_para.h>
+
+#include "calling.h"
+
+/* Construct struct pt_regs on stack */
+.macro PUSH_IRET_FRAME_FROM_PVCS has_cs_ss:req is_kernel:req
+	.if \has_cs_ss == 1
+		movl	PER_CPU_VAR(pvm_vcpu_struct + PVCS_user_ss), %ecx
+		andl	$0xff, %ecx
+		pushq	%rcx				/* pt_regs->ss */
+	.elseif \is_kernel == 1
+		pushq	$__KERNEL_DS
+	.else
+		pushq	$__USER_DS
+	.endif
+
+	pushq	PER_CPU_VAR(pvm_vcpu_struct + PVCS_rsp) /* pt_regs->sp */
+	movl	PER_CPU_VAR(pvm_vcpu_struct + PVCS_eflags), %ecx
+	pushq	%rcx					/* pt_regs->flags */
+
+	.if \has_cs_ss == 1
+		movl	PER_CPU_VAR(pvm_vcpu_struct + PVCS_user_cs), %ecx
+		andl	$0xff, %ecx
+		pushq	%rcx				/* pt_regs->cs */
+	.elseif \is_kernel == 1
+		pushq	$__KERNEL_CS
+	.else
+		pushq	$__USER_CS
+	.endif
+
+	pushq	PER_CPU_VAR(pvm_vcpu_struct + PVCS_rip) /* pt_regs->ip */
+
+	/* set %rcx, %r11 per PVM event handling specification */
+	movq	PER_CPU_VAR(pvm_vcpu_struct + PVCS_rcx), %rcx
+	movq	PER_CPU_VAR(pvm_vcpu_struct + PVCS_r11), %r11
+.endm
+
+.code64
+.section .entry.text, "ax"
+
+SYM_CODE_START(entry_SYSCALL_64_pvm)
+	UNWIND_HINT_ENTRY
+	ENDBR
+
+	PUSH_IRET_FRAME_FROM_PVCS has_cs_ss=0 is_kernel=0
+
+	jmp	entry_SYSCALL_64_after_hwframe
+SYM_CODE_END(entry_SYSCALL_64_pvm)
+
+/*
+ * The new RIP value that PVM event delivery establishes is
+ * MSR_PVM_EVENT_ENTRY for vector events that occur in user mode.
+ */
+	.align 64
+SYM_CODE_START(pvm_user_event_entry)
+	UNWIND_HINT_ENTRY
+	ENDBR
+
+	PUSH_IRET_FRAME_FROM_PVCS has_cs_ss=1 is_kernel=0
+	/* pt_regs->orig_ax: errcode and vector */
+	pushq	PER_CPU_VAR(pvm_vcpu_struct + PVCS_event_errcode)
+
+	PUSH_AND_CLEAR_REGS
+	movq	%rsp, %rdi	/* %rdi -> pt_regs */
+	call	pvm_event
+
+SYM_INNER_LABEL(pvm_restore_regs_and_return_to_usermode, SYM_L_GLOBAL)
+	POP_REGS
+
+	/* Copy %rcx, %r11 to the PVM CPU structure. */
+	movq	%rcx, PER_CPU_VAR(pvm_vcpu_struct + PVCS_rcx)
+	movq	%r11, PER_CPU_VAR(pvm_vcpu_struct + PVCS_r11)
+
+	/* Copy the IRET frame to the PVM CPU structure. */
+	movq	1*8(%rsp), %rcx		/* RIP */
+	movq	%rcx, PER_CPU_VAR(pvm_vcpu_struct + PVCS_rip)
+	movq	2*8(%rsp), %rcx		/* CS */
+	movw	%cx, PER_CPU_VAR(pvm_vcpu_struct + PVCS_user_cs)
+	movq	3*8(%rsp), %rcx		/* RFLAGS */
+	movl	%ecx, PER_CPU_VAR(pvm_vcpu_struct + PVCS_eflags)
+	movq	4*8(%rsp), %rcx		/* RSP */
+	movq	%rcx, PER_CPU_VAR(pvm_vcpu_struct + PVCS_rsp)
+	movq	5*8(%rsp), %rcx		/* SS */
+	movw	%cx, PER_CPU_VAR(pvm_vcpu_struct + PVCS_user_ss)
+	/*
+	 * We are on the trampoline stack.  All regs are live.
+	 * We can do future final exit work right here.
+	 */
+	STACKLEAK_ERASE_NOCLOBBER
+
+	addq	$6*8, %rsp
+SYM_INNER_LABEL(pvm_retu_rip, SYM_L_GLOBAL)
+	ANNOTATE_NOENDBR
+	syscall
+SYM_CODE_END(pvm_user_event_entry)
+
+/*
+ * The new RIP value that PVM event delivery establishes is
+ * MSR_PVM_EVENT_ENTRY + 256 for events with vector < 32
+ * that occur in supervisor mode.
+ */
+	.org pvm_user_event_entry+256, 0xcc
+SYM_CODE_START(pvm_kernel_exception_entry)
+	UNWIND_HINT_ENTRY
+	ENDBR
+
+	/* set %rcx, %r11 per PVM event handling specification */
+	movq	6*8(%rsp), %rcx
+	movq	7*8(%rsp), %r11
+
+	PUSH_AND_CLEAR_REGS
+	movq	%rsp, %rdi	/* %rdi -> pt_regs */
+	call	pvm_event
+
+	jmp pvm_restore_regs_and_return_to_kernel
+SYM_CODE_END(pvm_kernel_exception_entry)
+
+/*
+ * The new RIP value that PVM event delivery establishes is
+ * MSR_PVM_EVENT_ENTRY + 512 for events with vector >= 32
+ * that occur in supervisor mode.
+ */
+	.org pvm_user_event_entry+512, 0xcc
+SYM_CODE_START(pvm_kernel_interrupt_entry)
+	UNWIND_HINT_ENTRY
+	ENDBR
+
+	/* Reserve space for rcx/r11 */
+	subq	$16, %rsp
+
+	PUSH_IRET_FRAME_FROM_PVCS has_cs_ss=0 is_kernel=1
+	/* pt_regs->orig_ax: errcode and vector */
+	pushq	PER_CPU_VAR(pvm_vcpu_struct + PVCS_event_errcode)
+
+	PUSH_AND_CLEAR_REGS
+	movq	%rsp, %rdi	/* %rdi -> pt_regs */
+	call	pvm_event
+
+SYM_INNER_LABEL(pvm_restore_regs_and_return_to_kernel, SYM_L_GLOBAL)
+	POP_REGS
+
+	movq	%rcx, 6*8(%rsp)
+	movq	%r11, 7*8(%rsp)
+SYM_INNER_LABEL(pvm_rets_rip, SYM_L_GLOBAL)
+	ANNOTATE_NOENDBR
+	syscall
+SYM_CODE_END(pvm_kernel_interrupt_entry)
diff --git a/arch/x86/include/asm/pvm_para.h b/arch/x86/include/asm/pvm_para.h
index ff0bf0fe7dc4..c344185a192c 100644
--- a/arch/x86/include/asm/pvm_para.h
+++ b/arch/x86/include/asm/pvm_para.h
@@ -5,6 +5,8 @@
 #include <linux/init.h>
 #include <uapi/asm/pvm_para.h>
 
+#ifndef __ASSEMBLY__
+
 #ifdef CONFIG_PVM_GUEST
 #include <asm/irqflags.h>
 #include <uapi/asm/kvm_para.h>
@@ -72,4 +74,10 @@ static inline bool pvm_kernel_layout_relocate(void)
 }
 #endif /* CONFIG_PVM_GUEST */
 
+void entry_SYSCALL_64_pvm(void);
+void pvm_user_event_entry(void);
+void pvm_retu_rip(void);
+void pvm_rets_rip(void);
+#endif /* !__ASSEMBLY__ */
+
 #endif /* _ASM_X86_PVM_PARA_H */
diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index 9cdfbaa15dbb..9399e45b3c13 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -11,14 +11,195 @@
 #define pr_fmt(fmt) "pvm-guest: " fmt
 
 #include <linux/mm_types.h>
+#include <linux/nospec.h>
 
 #include <asm/cpufeature.h>
 #include <asm/cpu_entry_area.h>
+#include <asm/desc.h>
 #include <asm/pvm_para.h>
+#include <asm/traps.h>
+
+DEFINE_PER_CPU_PAGE_ALIGNED(struct pvm_vcpu_struct, pvm_vcpu_struct);
 
 unsigned long pvm_range_start __initdata;
 unsigned long pvm_range_end __initdata;
 
+static noinstr void pvm_bad_event(struct pt_regs *regs, unsigned long vector,
+				  unsigned long error_code)
+{
+	irqentry_state_t irq_state = irqentry_nmi_enter(regs);
+
+	instrumentation_begin();
+
+	/* Panic on events from a high stack level */
+	if (!user_mode(regs)) {
+		pr_emerg("PANIC: invalid or fatal PVM event;"
+			 "vector %lu error 0x%lx at %04lx:%016lx\n",
+			 vector, error_code, regs->cs, regs->ip);
+		die("invalid or fatal PVM event", regs, error_code);
+		panic("invalid or fatal PVM event");
+	} else {
+		unsigned long flags = oops_begin();
+		int sig = SIGKILL;
+
+		pr_alert("BUG: invalid or fatal FRED event;"
+			 "vector %lu error 0x%lx at %04lx:%016lx\n",
+			 vector, error_code, regs->cs, regs->ip);
+
+		if (__die("Invalid or fatal FRED event", regs, error_code))
+			sig = 0;
+
+		oops_end(flags, regs, sig);
+	}
+	instrumentation_end();
+	irqentry_nmi_exit(regs, irq_state);
+}
+
+DEFINE_IDTENTRY_RAW(pvm_exc_debug)
+{
+	/*
+	 * There's no IST on PVM. but we still need to sipatch
+	 * to the correct handler.
+	 */
+	if (user_mode(regs))
+		noist_exc_debug(regs);
+	else
+		exc_debug(regs);
+}
+
+#ifdef CONFIG_X86_MCE
+DEFINE_IDTENTRY_RAW(pvm_exc_machine_check)
+{
+	/*
+	 * There's no IST on PVM, but we still need to dispatch
+	 * to the correct handler.
+	 */
+	if (user_mode(regs))
+		noist_exc_machine_check(regs);
+	else
+		exc_machine_check(regs);
+}
+#endif
+
+static noinstr void pvm_exception(struct pt_regs *regs, unsigned long vector,
+				  unsigned long error_code)
+{
+	/* Optimize for #PF. That's the only exception which matters performance wise */
+	if (likely(vector == X86_TRAP_PF)) {
+		exc_page_fault(regs, error_code);
+		return;
+	}
+
+	switch (vector) {
+	case X86_TRAP_DE: return exc_divide_error(regs);
+	case X86_TRAP_DB: return pvm_exc_debug(regs);
+	case X86_TRAP_NMI: return exc_nmi(regs);
+	case X86_TRAP_BP: return exc_int3(regs);
+	case X86_TRAP_OF: return exc_overflow(regs);
+	case X86_TRAP_BR: return exc_bounds(regs);
+	case X86_TRAP_UD: return exc_invalid_op(regs);
+	case X86_TRAP_NM: return exc_device_not_available(regs);
+	case X86_TRAP_DF: return exc_double_fault(regs, error_code);
+	case X86_TRAP_TS: return exc_invalid_tss(regs, error_code);
+	case X86_TRAP_NP: return exc_segment_not_present(regs, error_code);
+	case X86_TRAP_SS: return exc_stack_segment(regs, error_code);
+	case X86_TRAP_GP: return exc_general_protection(regs, error_code);
+	case X86_TRAP_MF: return exc_coprocessor_error(regs);
+	case X86_TRAP_AC: return exc_alignment_check(regs, error_code);
+	case X86_TRAP_XF: return exc_simd_coprocessor_error(regs);
+#ifdef CONFIG_X86_MCE
+	case X86_TRAP_MC: return pvm_exc_machine_check(regs);
+#endif
+#ifdef CONFIG_X86_CET
+	case X86_TRAP_CP: return exc_control_protection(regs, error_code);
+#endif
+	default: return pvm_bad_event(regs, vector, error_code);
+	}
+}
+
+static noinstr void pvm_handle_INT80_compat(struct pt_regs *regs)
+{
+#ifdef CONFIG_IA32_EMULATION
+	if (ia32_enabled()) {
+		int80_emulation(regs);
+		return;
+	}
+#endif
+	exc_general_protection(regs, 0);
+}
+
+typedef void (*idtentry_t)(struct pt_regs *regs);
+
+#define SYSVEC(_vector, _function) [_vector - FIRST_SYSTEM_VECTOR] = sysvec_##_function
+
+#define pvm_handle_spurious_interrupt ((idtentry_t)(void *)spurious_interrupt)
+
+static idtentry_t pvm_sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
+	[0 ... NR_SYSTEM_VECTORS-1] = pvm_handle_spurious_interrupt,
+
+	SYSVEC(ERROR_APIC_VECTOR,		error_interrupt),
+	SYSVEC(SPURIOUS_APIC_VECTOR,		spurious_apic_interrupt),
+	SYSVEC(LOCAL_TIMER_VECTOR,		apic_timer_interrupt),
+	SYSVEC(X86_PLATFORM_IPI_VECTOR,		x86_platform_ipi),
+
+#ifdef CONFIG_SMP
+	SYSVEC(RESCHEDULE_VECTOR,		reschedule_ipi),
+	SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,	call_function_single),
+	SYSVEC(CALL_FUNCTION_VECTOR,		call_function),
+	SYSVEC(REBOOT_VECTOR,			reboot),
+#endif
+#ifdef CONFIG_X86_MCE_THRESHOLD
+	SYSVEC(THRESHOLD_APIC_VECTOR,		threshold),
+#endif
+#ifdef CONFIG_X86_MCE_AMD
+	SYSVEC(DEFERRED_ERROR_VECTOR,		deferred_error),
+#endif
+#ifdef CONFIG_X86_THERMAL_VECTOR
+	SYSVEC(THERMAL_APIC_VECTOR,		thermal),
+#endif
+#ifdef CONFIG_IRQ_WORK
+	SYSVEC(IRQ_WORK_VECTOR,			irq_work),
+#endif
+#ifdef CONFIG_HAVE_KVM
+	SYSVEC(POSTED_INTR_VECTOR,		kvm_posted_intr_ipi),
+	SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	kvm_posted_intr_wakeup_ipi),
+	SYSVEC(POSTED_INTR_NESTED_VECTOR,	kvm_posted_intr_nested_ipi),
+#endif
+};
+
+/*
+ * some pointers in pvm_sysvec_table are actual spurious_interrupt() who
+ * expects the second argument to be the vector.
+ */
+typedef void (*idtentry_x_t)(struct pt_regs *regs, int vector);
+
+static __always_inline void pvm_handle_sysvec(struct pt_regs *regs, unsigned long vector)
+{
+	unsigned int index = array_index_nospec(vector - FIRST_SYSTEM_VECTOR,
+						NR_SYSTEM_VECTORS);
+	idtentry_x_t func = (void *)pvm_sysvec_table[index];
+
+	func(regs, vector);
+}
+
+__visible noinstr void pvm_event(struct pt_regs *regs)
+{
+	u32 error_code = regs->orig_ax;
+	u64 vector = regs->orig_ax >> 32;
+
+	/* Invalidate orig_ax so that syscall_get_nr() works correctly */
+	regs->orig_ax = -1;
+
+	if (vector < NUM_EXCEPTION_VECTORS)
+		pvm_exception(regs, vector, error_code);
+	else if (vector >= FIRST_SYSTEM_VECTOR)
+		pvm_handle_sysvec(regs, vector);
+	else if (unlikely(vector == IA32_SYSCALL_VECTOR))
+		pvm_handle_INT80_compat(regs);
+	else
+		common_interrupt(regs, vector);
+}
+
 void __init pvm_early_setup(void)
 {
 	if (!pvm_range_end)
-- 
2.19.1.6.gb485710b


