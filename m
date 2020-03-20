Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDBE818DACD
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgCTWFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:05:22 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37484 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbgCTWEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:15 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk2-0004Te-Sk; Fri, 20 Mar 2020 23:03:47 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 5F3ED1039FF;
        Fri, 20 Mar 2020 23:03:46 +0100 (CET)
Message-Id: <20200320180033.092520097@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:03 +0100
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
Subject: [RESEND][patch V3 07/23] lockdep: Prepare for noinstr sections
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

From: Peter Zijlstra <peterz@infradead.org>

Lockdep is invoked after RCU stopped watching or before it restarted
watching from the low level entry/exit code.

lockdep_hardirqs_on() is part of the irq-state tracking; it is the
callback that indicates we're about to enable IRQs. But because of
this, lockdep has co-opted this callback to do lock state updates. All
(still) held locks will get marked with ENABLED_HARDIRQ, which then
also looks for cycles connecting to USED_IN_HARDIRQ for IRQ recursion
deadlocks.

This results in quite a lot of lockdep code getting ran, but worse, it
will want to do stack-traces for the lock state changes. Stack traces
require RCU.

Because code that requires RCU must not run after we've shut down RCU,
and shutting down RCU itself requires locks in some circumstances,
split this into two parts:

  - lockdep_hardirqs_on_prepare() -- updates the held lock state
  - lockdep_hardirqs_on() -- does the irq state tracking

This allows running the lock state changes and stack-traces with RCU
enaabled, while doing the IRQ state change later. Of course, this
opens a window where the lock stack can change. Therefore
lockdep_hardirqs_on_prepare() will snapshot the chain_key and
lockdep_hardirqs_on() will validate it still matches. This ensures
that, even when interleaved code uses locks, the actual lock state
didn't change between these two calls.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqflags.h        |    2 +
 include/linux/sched.h           |    1 
 kernel/locking/lockdep.c        |   66 +++++++++++++++++++++++++++++-----------
 kernel/trace/trace_preemptirq.c |    2 +
 lib/debug_locks.c               |    2 -
 5 files changed, 55 insertions(+), 18 deletions(-)

--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -19,11 +19,13 @@
 #ifdef CONFIG_PROVE_LOCKING
   extern void trace_softirqs_on(unsigned long ip);
   extern void trace_softirqs_off(unsigned long ip);
+  extern void lockdep_hardirqs_on_prepare(unsigned long ip);
   extern void lockdep_hardirqs_on(unsigned long ip);
   extern void lockdep_hardirqs_off(unsigned long ip);
 #else
   static inline void trace_softirqs_on(unsigned long ip) { }
   static inline void trace_softirqs_off(unsigned long ip) { }
+  static inline void lockdep_hardirqs_on_prepare(unsigned long ip) { }
   static inline void lockdep_hardirqs_on(unsigned long ip) { }
   static inline void lockdep_hardirqs_off(unsigned long ip) { }
 #endif
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -976,6 +976,7 @@ struct task_struct {
 	unsigned int			hardirq_disable_event;
 	int				hardirqs_enabled;
 	int				hardirq_context;
+	u64				hardirq_chain_key;
 	unsigned long			softirq_disable_ip;
 	unsigned long			softirq_enable_ip;
 	unsigned int			softirq_disable_event;
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3370,9 +3370,6 @@ static void __trace_hardirqs_on_caller(u
 {
 	struct task_struct *curr = current;
 
-	/* we'll do an OFF -> ON transition: */
-	curr->hardirqs_enabled = 1;
-
 	/*
 	 * We are going to turn hardirqs on, so set the
 	 * usage bit for all held locks:
@@ -3384,16 +3381,13 @@ static void __trace_hardirqs_on_caller(u
 	 * bit for all held locks. (disabled hardirqs prevented
 	 * this bit from being set before)
 	 */
-	if (curr->softirqs_enabled)
+	if (curr->softirqs_enabled) {
 		if (!mark_held_locks(curr, LOCK_ENABLED_SOFTIRQ))
 			return;
-
-	curr->hardirq_enable_ip = ip;
-	curr->hardirq_enable_event = ++curr->irq_events;
-	debug_atomic_inc(hardirqs_on_events);
+	}
 }
 
-void lockdep_hardirqs_on(unsigned long ip)
+void lockdep_hardirqs_on_prepare(unsigned long ip)
 {
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
@@ -3429,20 +3423,59 @@ void lockdep_hardirqs_on(unsigned long i
 	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
 		return;
 
+	current->hardirq_chain_key = current->curr_chain_key;
+
 	current->lockdep_recursion = 1;
 	__trace_hardirqs_on_caller(ip);
 	current->lockdep_recursion = 0;
 }
-NOKPROBE_SYMBOL(lockdep_hardirqs_on);
 
+void noinstr lockdep_hardirqs_on(unsigned long ip)
+{
+	struct task_struct *curr = current;
+
+	if (unlikely(!debug_locks || curr->lockdep_recursion))
+		return;
+
+	if (curr->hardirqs_enabled) {
+		/*
+		 * Neither irq nor preemption are disabled here
+		 * so this is racy by nature but losing one hit
+		 * in a stat is not a big deal.
+		 */
+		__debug_atomic_inc(redundant_hardirqs_on);
+		return;
+	}
+
+	/*
+	 * We're enabling irqs and according to our state above irqs weren't
+	 * already enabled, yet we find the hardware thinks they are in fact
+	 * enabled.. someone messed up their IRQ state tracing.
+	 */
+	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
+		return;
+
+	/*
+	 * Ensure the lock stack remained unchanged between
+	 * lockdep_hardirqs_on_prepare() and lockdep_hardirqs_on().
+	 */
+	DEBUG_LOCKS_WARN_ON(current->hardirq_chain_key !=
+			    current->curr_chain_key);
+
+	/* we'll do an OFF -> ON transition: */
+	curr->hardirqs_enabled = 1;
+	curr->hardirq_enable_ip = ip;
+	curr->hardirq_enable_event = ++curr->irq_events;
+	debug_atomic_inc(hardirqs_on_events);
+}
 /*
  * Hardirqs were disabled:
  */
-void lockdep_hardirqs_off(unsigned long ip)
+void noinstr lockdep_hardirqs_off(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-	if (unlikely(!debug_locks || current->lockdep_recursion))
+	if (unlikely(!debug_locks || curr->lockdep_recursion))
 		return;
 
 	/*
@@ -3463,7 +3496,6 @@ void lockdep_hardirqs_off(unsigned long
 	} else
 		debug_atomic_inc(redundant_hardirqs_off);
 }
-NOKPROBE_SYMBOL(lockdep_hardirqs_off);
 
 /*
  * Softirqs will be enabled:
@@ -4007,8 +4039,8 @@ static void print_unlock_imbalance_bug(s
 	dump_stack();
 }
 
-static int match_held_lock(const struct held_lock *hlock,
-					const struct lockdep_map *lock)
+static noinstr int match_held_lock(const struct held_lock *hlock,
+				   const struct lockdep_map *lock)
 {
 	if (hlock->instance == lock)
 		return 1;
@@ -4293,7 +4325,7 @@ static int
 	return 0;
 }
 
-static nokprobe_inline
+static __always_inline
 int __lock_is_held(const struct lockdep_map *lock, int read)
 {
 	struct task_struct *curr = current;
@@ -4506,7 +4538,7 @@ void lock_release(struct lockdep_map *lo
 }
 EXPORT_SYMBOL_GPL(lock_release);
 
-int lock_is_held_type(const struct lockdep_map *lock, int read)
+noinstr int lock_is_held_type(const struct lockdep_map *lock, int read)
 {
 	unsigned long flags;
 	int ret = 0;
--- a/kernel/trace/trace_preemptirq.c
+++ b/kernel/trace/trace_preemptirq.c
@@ -39,6 +39,7 @@ void trace_hardirqs_on(void)
 		this_cpu_write(tracing_irq_cpu, 0);
 	}
 
+	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
 EXPORT_SYMBOL(trace_hardirqs_on);
@@ -79,6 +80,7 @@ NOKPROBE_SYMBOL(trace_hardirqs_off);
 		this_cpu_write(tracing_irq_cpu, 0);
 	}
 
+	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -36,7 +36,7 @@ EXPORT_SYMBOL_GPL(debug_locks_silent);
 /*
  * Generic 'turn off all lock debugging' function:
  */
-int debug_locks_off(void)
+noinstr int debug_locks_off(void)
 {
 	if (debug_locks && __debug_locks_off()) {
 		if (!debug_locks_silent) {

