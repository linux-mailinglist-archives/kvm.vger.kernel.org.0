Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A241018DADD
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgCTWEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:04:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37466 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgCTWEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:12 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk5-0004To-0y; Fri, 20 Mar 2020 23:03:49 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 5EF5E1039FF;
        Fri, 20 Mar 2020 23:03:47 +0100 (CET)
Message-Id: <20200320180033.481570410@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:07 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paul McKenney <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [RESEND][patch V3 11/23] x86/entry: Move irq flags tracing to
 prepare_exit_to_usermode()
References: <20200320175956.033706968@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is another step towards more C-code and less convoluted ASM.

Similar to the entry path.

 1) invoke the tracer and the preparatory lockdep step
 2) invoke context tracking which might turn off RCU
 3) invoke the final lockdep step

Annotate the code sections in exit_to_user_mode() accordingly so objtool
won't complain about the tracer and lockdep invocation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V3: Convert it to noinstr

V2: New patch simplifying the conversion and addressing Alex' review
    comment of redundant tracing.
---
 arch/x86/entry/common.c          |   17 +++++++++++++++++
 arch/x86/entry/entry_32.S        |   12 ++++--------
 arch/x86/entry/entry_64.S        |    4 ----
 arch/x86/entry/entry_64_compat.S |   14 +++++---------
 4 files changed, 26 insertions(+), 21 deletions(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -71,10 +71,27 @@ static __always_inline void enter_from_u
 }
 #endif
 
+/**
+ * exit_to_user_mode - Fixup state when exiting to user mode
+ *
+ * Syscall exit enables interrupts, but the kernel state is interrupts
+ * disabled when this is invoked. Also tell RCU about it.
+ *
+ * 1) Trace interrupts on state
+ * 2) Invoke context tracking if enabled to adjust RCU state
+ * 3) Clear CPU buffers if CPU is affected by MDS and the migitation is on.
+ * 4) Tell lockdep that interrupts are enabled
+ */
 static __always_inline void exit_to_user_mode(void)
 {
+	instr_begin();
+	__trace_hardirqs_on();
+	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	instr_end();
+
 	user_enter_irqoff();
 	mds_user_clear_cpu_buffers();
+	lockdep_hardirqs_on(CALLER_ADDR0);
 }
 
 static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -811,8 +811,7 @@ SYM_CODE_START(ret_from_fork)
 	/* When we fork, we trace the syscall return in the child, too. */
 	movl    %esp, %eax
 	call    syscall_return_slowpath
-	STACKLEAK_ERASE
-	jmp     restore_all
+	jmp     .Lsyscall_32_done
 
 	/* kernel thread */
 1:	movl	%edi, %eax
@@ -855,7 +854,7 @@ SYM_CODE_START_LOCAL(ret_from_exception)
 	TRACE_IRQS_OFF
 	movl	%esp, %eax
 	call	prepare_exit_to_usermode
-	jmp	restore_all
+	jmp	restore_all_switch_stack
 SYM_CODE_END(ret_from_exception)
 
 SYM_ENTRY(__begin_SYSENTER_singlestep_region, SYM_L_GLOBAL, SYM_A_NONE)
@@ -968,8 +967,7 @@ SYM_FUNC_START(entry_SYSENTER_32)
 
 	STACKLEAK_ERASE
 
-/* Opportunistic SYSEXIT */
-	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
+	/* Opportunistic SYSEXIT */
 
 	/*
 	 * Setup entry stack - we keep the pointer in %eax and do the
@@ -1072,11 +1070,9 @@ SYM_FUNC_START(entry_INT80_32)
 	movl	%esp, %eax
 	call	do_int80_syscall_32
 .Lsyscall_32_done:
-
 	STACKLEAK_ERASE
 
-restore_all:
-	TRACE_IRQS_ON
+restore_all_switch_stack:
 	SWITCH_TO_ENTRY_STACK
 	CHECK_AND_APPLY_ESPFIX
 
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -172,8 +172,6 @@ SYM_INNER_LABEL(entry_SYSCALL_64_after_h
 	movq	%rsp, %rsi
 	call	do_syscall_64		/* returns with IRQs disabled */
 
-	TRACE_IRQS_ON			/* return enables interrupts */
-
 	/*
 	 * Try to use SYSRET instead of IRET if we're returning to
 	 * a completely clean 64-bit userspace context.  If we're not,
@@ -340,7 +338,6 @@ SYM_CODE_START(ret_from_fork)
 	UNWIND_HINT_REGS
 	movq	%rsp, %rdi
 	call	syscall_return_slowpath	/* returns with IRQs disabled */
-	TRACE_IRQS_ON			/* user mode is traced as IRQS on */
 	jmp	swapgs_restore_regs_and_return_to_usermode
 
 1:
@@ -617,7 +614,6 @@ SYM_CODE_START_LOCAL(common_interrupt)
 .Lretint_user:
 	mov	%rsp,%rdi
 	call	prepare_exit_to_usermode
-	TRACE_IRQS_ON
 
 SYM_INNER_LABEL(swapgs_restore_regs_and_return_to_usermode, SYM_L_GLOBAL)
 #ifdef CONFIG_DEBUG_ENTRY
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -132,8 +132,8 @@ SYM_FUNC_START(entry_SYSENTER_compat)
 	movq	%rsp, %rdi
 	call	do_fast_syscall_32
 	/* XEN PV guests always use IRET path */
-	ALTERNATIVE "testl %eax, %eax; jz .Lsyscall_32_done", \
-		    "jmp .Lsyscall_32_done", X86_FEATURE_XENPV
+	ALTERNATIVE "testl %eax, %eax; jz swapgs_restore_regs_and_return_to_usermode", \
+		    "jmp swapgs_restore_regs_and_return_to_usermode", X86_FEATURE_XENPV
 	jmp	sysret32_from_system_call
 
 .Lsysenter_fix_flags:
@@ -244,8 +244,8 @@ SYM_INNER_LABEL(entry_SYSCALL_compat_aft
 	movq	%rsp, %rdi
 	call	do_fast_syscall_32
 	/* XEN PV guests always use IRET path */
-	ALTERNATIVE "testl %eax, %eax; jz .Lsyscall_32_done", \
-		    "jmp .Lsyscall_32_done", X86_FEATURE_XENPV
+	ALTERNATIVE "testl %eax, %eax; jz swapgs_restore_regs_and_return_to_usermode", \
+		    "jmp swapgs_restore_regs_and_return_to_usermode", X86_FEATURE_XENPV
 
 	/* Opportunistic SYSRET */
 sysret32_from_system_call:
@@ -254,7 +254,7 @@ SYM_INNER_LABEL(entry_SYSCALL_compat_aft
 	 * stack. So let's erase the thread stack right now.
 	 */
 	STACKLEAK_ERASE
-	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
+
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
 	movq	EFLAGS(%rsp), %r11	/* pt_regs->flags (in r11) */
@@ -393,9 +393,5 @@ SYM_CODE_START(entry_INT80_compat)
 
 	movq	%rsp, %rdi
 	call	do_int80_syscall_32
-.Lsyscall_32_done:
-
-	/* Go back to user mode. */
-	TRACE_IRQS_ON
 	jmp	swapgs_restore_regs_and_return_to_usermode
 SYM_CODE_END(entry_INT80_compat)

