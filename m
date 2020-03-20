Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08A9418DAC3
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgCTWFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:05:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37523 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbgCTWFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:05:00 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk3-0004Tn-Lj; Fri, 20 Mar 2020 23:03:47 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 228851039FD;
        Fri, 20 Mar 2020 23:03:47 +0100 (CET)
Message-Id: <20200320180033.373450806@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:06 +0100
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
Subject: [RESEND][patch V3 10/23] x86/entry: Move irq tracing on syscall entry
 to C-code
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

Now that the C entry points are safe, move the irq flags tracing code into
the entry helper:

    - Invoke lockdep before calling into context tracking

    - Use the safe __trace_hardirqs_on() trace function after context
      tracking established state and RCU is watching.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/entry/common.c          |   21 +++++++++++++++++++--
 arch/x86/entry/entry_32.S        |   12 ------------
 arch/x86/entry/entry_64.S        |    2 --
 arch/x86/entry/entry_64_compat.S |   18 ------------------
 4 files changed, 19 insertions(+), 34 deletions(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -39,19 +39,36 @@
 #include <trace/events/syscalls.h>
 
 #ifdef CONFIG_CONTEXT_TRACKING
-/* Called on entry from user mode with IRQs off. */
+/**
+ * enter_from_user_mode - Establish state when coming from user mode
+ *
+ * Syscall entry disables interrupts, but user mode is traced as interrupts
+ * enabled. Also with NO_HZ_FULL RCU might be idle.
+ *
+ * 1) Tell lockdep that interrupts are disabled
+ * 2) Invoke context tracking if enabled to reactivate RCU
+ * 3) Trace interrupts off state
+ */
 __visible noinstr void enter_from_user_mode(void)
 {
 	enum ctx_state state = ct_state();
 
+	lockdep_hardirqs_off(CALLER_ADDR0);
 	user_exit_irqoff();
 
 	instr_begin();
 	CT_WARN_ON(state != CONTEXT_USER);
+	__trace_hardirqs_off();
 	instr_end();
 }
 #else
-static inline void enter_from_user_mode(void) {}
+static __always_inline void enter_from_user_mode(void)
+{
+	lockdep_hardirqs_off(CALLER_ADDR0);
+	instr_begin();
+	__trace_hardirqs_off();
+	instr_end();
+}
 #endif
 
 static __always_inline void exit_to_user_mode(void)
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -960,12 +960,6 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	jnz	.Lsysenter_fix_flags
 .Lsysenter_flags_fixed:
 
-	/*
-	 * User mode is traced as though IRQs are on, and SYSENTER
-	 * turned them off.
-	 */
-	TRACE_IRQS_OFF
-
 	movl	%esp, %eax
 	call	do_fast_syscall_32
 	/* XEN PV guests always use IRET path */
@@ -1075,12 +1069,6 @@ SYM_FUNC_START(entry_INT80_32)
 
 	SAVE_ALL pt_regs_ax=$-ENOSYS switch_stacks=1	/* save rest */
 
-	/*
-	 * User mode is traced as though IRQs are on, and the interrupt gate
-	 * turned them off.
-	 */
-	TRACE_IRQS_OFF
-
 	movl	%esp, %eax
 	call	do_int80_syscall_32
 .Lsyscall_32_done:
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -167,8 +167,6 @@ SYM_INNER_LABEL(entry_SYSCALL_64_after_h
 
 	PUSH_AND_CLEAR_REGS rax=$-ENOSYS
 
-	TRACE_IRQS_OFF
-
 	/* IRQs are off. */
 	movq	%rax, %rdi
 	movq	%rsp, %rsi
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -129,12 +129,6 @@ SYM_FUNC_START(entry_SYSENTER_compat)
 	jnz	.Lsysenter_fix_flags
 .Lsysenter_flags_fixed:
 
-	/*
-	 * User mode is traced as though IRQs are on, and SYSENTER
-	 * turned them off.
-	 */
-	TRACE_IRQS_OFF
-
 	movq	%rsp, %rdi
 	call	do_fast_syscall_32
 	/* XEN PV guests always use IRET path */
@@ -247,12 +241,6 @@ SYM_INNER_LABEL(entry_SYSCALL_compat_aft
 	pushq   $0			/* pt_regs->r15 = 0 */
 	xorl	%r15d, %r15d		/* nospec   r15 */
 
-	/*
-	 * User mode is traced as though IRQs are on, and SYSENTER
-	 * turned them off.
-	 */
-	TRACE_IRQS_OFF
-
 	movq	%rsp, %rdi
 	call	do_fast_syscall_32
 	/* XEN PV guests always use IRET path */
@@ -403,12 +391,6 @@ SYM_CODE_START(entry_INT80_compat)
 	xorl	%r15d, %r15d		/* nospec   r15 */
 	cld
 
-	/*
-	 * User mode is traced as though IRQs are on, and the interrupt
-	 * gate turned them off.
-	 */
-	TRACE_IRQS_OFF
-
 	movq	%rsp, %rdi
 	call	do_int80_syscall_32
 .Lsyscall_32_done:

