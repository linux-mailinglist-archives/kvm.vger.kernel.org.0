Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3292118DAB3
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgCTWET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:04:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37495 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727405AbgCTWEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:16 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk8-0004Tk-BW; Fri, 20 Mar 2020 23:03:52 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id DA32C1039FC;
        Fri, 20 Mar 2020 23:03:46 +0100 (CET)
Message-Id: <20200320180033.280833846@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:05 +0100
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
Subject: [RESEND][patch V3 09/23] x86/entry/common: Protect against instrumentation
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

Mark the various syscall entries with noinstr to protect them against
instrumentation and add the noinstr_begin()/end() annotations to mark the
parts of the functions which are safe to call out into instrumentable code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/entry/common.c |  133 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 89 insertions(+), 44 deletions(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -42,13 +42,24 @@
 /* Called on entry from user mode with IRQs off. */
 __visible noinstr void enter_from_user_mode(void)
 {
-	CT_WARN_ON(ct_state() != CONTEXT_USER);
+	enum ctx_state state = ct_state();
+
 	user_exit_irqoff();
+
+	instr_begin();
+	CT_WARN_ON(state != CONTEXT_USER);
+	instr_end();
 }
 #else
 static inline void enter_from_user_mode(void) {}
 #endif
 
+static __always_inline void exit_to_user_mode(void)
+{
+	user_enter_irqoff();
+	mds_user_clear_cpu_buffers();
+}
+
 static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
 {
 #ifdef CONFIG_X86_64
@@ -178,8 +189,7 @@ static void exit_to_usermode_loop(struct
 	}
 }
 
-/* Called with IRQs disabled. */
-__visible inline void prepare_exit_to_usermode(struct pt_regs *regs)
+static void __prepare_exit_to_usermode(struct pt_regs *regs)
 {
 	struct thread_info *ti = current_thread_info();
 	u32 cached_flags;
@@ -218,10 +228,14 @@ static void exit_to_usermode_loop(struct
 	 */
 	ti->status &= ~(TS_COMPAT|TS_I386_REGS_POKED);
 #endif
+}
 
-	user_enter_irqoff();
-
-	mds_user_clear_cpu_buffers();
+__visible noinstr void prepare_exit_to_usermode(struct pt_regs *regs)
+{
+	instr_begin();
+	__prepare_exit_to_usermode(regs);
+	instr_end();
+	exit_to_user_mode();
 }
 
 #define SYSCALL_EXIT_WORK_FLAGS				\
@@ -250,11 +264,7 @@ static void syscall_slow_exit_work(struc
 		tracehook_report_syscall_exit(regs, step);
 }
 
-/*
- * Called with IRQs on and fully valid regs.  Returns with IRQs off in a
- * state such that we can immediately switch to user mode.
- */
-__visible inline void syscall_return_slowpath(struct pt_regs *regs)
+static void __syscall_return_slowpath(struct pt_regs *regs)
 {
 	struct thread_info *ti = current_thread_info();
 	u32 cached_flags = READ_ONCE(ti->flags);
@@ -275,15 +285,29 @@ static void syscall_slow_exit_work(struc
 		syscall_slow_exit_work(regs, cached_flags);
 
 	local_irq_disable();
-	prepare_exit_to_usermode(regs);
+	__prepare_exit_to_usermode(regs);
+}
+
+/*
+ * Called with IRQs on and fully valid regs.  Returns with IRQs off in a
+ * state such that we can immediately switch to user mode.
+ */
+__visible noinstr void syscall_return_slowpath(struct pt_regs *regs)
+{
+	instr_begin();
+	__syscall_return_slowpath(regs);
+	instr_end();
+	exit_to_user_mode();
 }
 
 #ifdef CONFIG_X86_64
-__visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
+__visible noinstr void do_syscall_64(unsigned long nr, struct pt_regs *regs)
 {
 	struct thread_info *ti;
 
 	enter_from_user_mode();
+	instr_begin();
+
 	local_irq_enable();
 	ti = current_thread_info();
 	if (READ_ONCE(ti->flags) & _TIF_WORK_SYSCALL_ENTRY)
@@ -300,8 +324,10 @@ static void syscall_slow_exit_work(struc
 		regs->ax = x32_sys_call_table[nr](regs);
 #endif
 	}
+	__syscall_return_slowpath(regs);
 
-	syscall_return_slowpath(regs);
+	instr_end();
+	exit_to_user_mode();
 }
 #endif
 
@@ -309,10 +335,10 @@ static void syscall_slow_exit_work(struc
 /*
  * Does a 32-bit syscall.  Called with IRQs on in CONTEXT_KERNEL.  Does
  * all entry and exit work and returns with IRQs off.  This function is
- * extremely hot in workloads that use it, and it's usually called from
+ * ex2tremely hot in workloads that use it, and it's usually called from
  * do_fast_syscall_32, so forcibly inline it to improve performance.
  */
-static __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs)
+static void do_syscall_32_irqs_on(struct pt_regs *regs)
 {
 	struct thread_info *ti = current_thread_info();
 	unsigned int nr = (unsigned int)regs->orig_ax;
@@ -349,27 +375,62 @@ static __always_inline void do_syscall_3
 #endif /* CONFIG_IA32_EMULATION */
 	}
 
-	syscall_return_slowpath(regs);
+	__syscall_return_slowpath(regs);
 }
 
 /* Handles int $0x80 */
-__visible void do_int80_syscall_32(struct pt_regs *regs)
+__visible noinstr void do_int80_syscall_32(struct pt_regs *regs)
 {
 	enter_from_user_mode();
+	instr_begin();
+
 	local_irq_enable();
 	do_syscall_32_irqs_on(regs);
+
+	instr_end();
+	exit_to_user_mode();
+}
+
+static bool __do_fast_syscall_32(struct pt_regs *regs)
+{
+	int res;
+
+	/* Fetch EBP from where the vDSO stashed it. */
+	if (IS_ENABLED(CONFIG_X86_64)) {
+		/*
+		 * Micro-optimization: the pointer we're following is
+		 * explicitly 32 bits, so it can't be out of range.
+		 */
+		res = __get_user(*(u32 *)&regs->bp,
+			 (u32 __user __force *)(unsigned long)(u32)regs->sp);
+	} else {
+		res = get_user(*(u32 *)&regs->bp,
+		       (u32 __user __force *)(unsigned long)(u32)regs->sp);
+	}
+
+	if (res) {
+		/* User code screwed up. */
+		regs->ax = -EFAULT;
+		local_irq_disable();
+		__prepare_exit_to_usermode(regs);
+		return false;
+	}
+
+	/* Now this is just like a normal syscall. */
+	do_syscall_32_irqs_on(regs);
+	return true;
 }
 
 /* Returns 0 to return using IRET or 1 to return using SYSEXIT/SYSRETL. */
-__visible long do_fast_syscall_32(struct pt_regs *regs)
+__visible noinstr long do_fast_syscall_32(struct pt_regs *regs)
 {
 	/*
 	 * Called using the internal vDSO SYSENTER/SYSCALL32 calling
 	 * convention.  Adjust regs so it looks like we entered using int80.
 	 */
-
 	unsigned long landing_pad = (unsigned long)current->mm->context.vdso +
-		vdso_image_32.sym_int80_landing_pad;
+					vdso_image_32.sym_int80_landing_pad;
+	bool success;
 
 	/*
 	 * SYSENTER loses EIP, and even SYSCALL32 needs us to skip forward
@@ -379,33 +440,17 @@ static __always_inline void do_syscall_3
 	regs->ip = landing_pad;
 
 	enter_from_user_mode();
+	instr_begin();
 
 	local_irq_enable();
+	success = __do_fast_syscall_32(regs);
 
-	/* Fetch EBP from where the vDSO stashed it. */
-	if (
-#ifdef CONFIG_X86_64
-		/*
-		 * Micro-optimization: the pointer we're following is explicitly
-		 * 32 bits, so it can't be out of range.
-		 */
-		__get_user(*(u32 *)&regs->bp,
-			    (u32 __user __force *)(unsigned long)(u32)regs->sp)
-#else
-		get_user(*(u32 *)&regs->bp,
-			 (u32 __user __force *)(unsigned long)(u32)regs->sp)
-#endif
-		) {
-
-		/* User code screwed up. */
-		local_irq_disable();
-		regs->ax = -EFAULT;
-		prepare_exit_to_usermode(regs);
-		return 0;	/* Keep it simple: use IRET. */
-	}
+	instr_end();
+	exit_to_user_mode();
 
-	/* Now this is just like a normal syscall. */
-	do_syscall_32_irqs_on(regs);
+	/* If it failed, keep it simple: use IRET. */
+	if (!success)
+		return 0;
 
 #ifdef CONFIG_X86_64
 	/*

