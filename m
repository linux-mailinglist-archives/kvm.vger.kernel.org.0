Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C97418DAD7
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgCTWFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:05:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37483 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgCTWEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:14 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk1-0004TP-M1; Fri, 20 Mar 2020 23:03:45 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 256901039FD;
        Fri, 20 Mar 2020 23:03:45 +0100 (CET)
Message-Id: <20200320180032.614150506@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 18:59:58 +0100
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
Subject: [RESEND][patch V3 02/23] rcu: Add comments marking transitions
 between RCU watching and not
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

From: "Paul E. McKenney" <paulmck@kernel.org>

It is not as clear as it might be just where in RCU's idle entry/exit
code RCU stops and starts watching the current CPU.  This commit therefore
adds comments calling out the transitions.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20200313024046.27622-2-paulmck@kernel.org

---
 kernel/rcu/tree.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -224,7 +224,9 @@ void rcu_softirq_qs(void)
 
 /*
  * Record entry into an extended quiescent state.  This is only to be
- * called when not already in an extended quiescent state.
+ * called when not already in an extended quiescent state, that is,
+ * RCU is watching prior to the call to this function and is no longer
+ * watching upon return.
  */
 static void rcu_dynticks_eqs_enter(void)
 {
@@ -237,7 +239,7 @@ static void rcu_dynticks_eqs_enter(void)
 	 * next idle sojourn.
 	 */
 	seq = atomic_add_return(RCU_DYNTICK_CTRL_CTR, &rdp->dynticks);
-	/* Better be in an extended quiescent state! */
+	// RCU is no longer watching.  Better be in extended quiescent state!
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) &&
 		     (seq & RCU_DYNTICK_CTRL_CTR));
 	/* Better not have special action (TLB flush) pending! */
@@ -247,7 +249,8 @@ static void rcu_dynticks_eqs_enter(void)
 
 /*
  * Record exit from an extended quiescent state.  This is only to be
- * called from an extended quiescent state.
+ * called from an extended quiescent state, that is, RCU is not watching
+ * prior to the call to this function and is watching upon return.
  */
 static void rcu_dynticks_eqs_exit(void)
 {
@@ -260,6 +263,7 @@ static void rcu_dynticks_eqs_exit(void)
 	 * critical section.
 	 */
 	seq = atomic_add_return(RCU_DYNTICK_CTRL_CTR, &rdp->dynticks);
+	// RCU is now watching.  Better not be in an extended quiescent state!
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) &&
 		     !(seq & RCU_DYNTICK_CTRL_CTR));
 	if (seq & RCU_DYNTICK_CTRL_MASK) {
@@ -562,6 +566,7 @@ static void rcu_eqs_enter(bool user)
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) &&
 		     rdp->dynticks_nesting == 0);
 	if (rdp->dynticks_nesting != 1) {
+		// RCU will still be watching, so just do accounting and leave.
 		rdp->dynticks_nesting--;
 		return;
 	}
@@ -574,7 +579,9 @@ static void rcu_eqs_enter(bool user)
 	rcu_prepare_for_idle();
 	rcu_preempt_deferred_qs(current);
 	WRITE_ONCE(rdp->dynticks_nesting, 0); /* Avoid irq-access tearing. */
+	// RCU is watching here ...
 	rcu_dynticks_eqs_enter();
+	// ... but is no longer watching here.
 	rcu_dynticks_task_enter();
 }
 
@@ -654,7 +661,9 @@ static __always_inline void rcu_nmi_exit
 	if (irq)
 		rcu_prepare_for_idle();
 
+	// RCU is watching here ...
 	rcu_dynticks_eqs_enter();
+	// ... but is no longer watching here.
 
 	if (irq)
 		rcu_dynticks_task_enter();
@@ -729,11 +738,14 @@ static void rcu_eqs_exit(bool user)
 	oldval = rdp->dynticks_nesting;
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && oldval < 0);
 	if (oldval) {
+		// RCU was already watching, so just do accounting and leave.
 		rdp->dynticks_nesting++;
 		return;
 	}
 	rcu_dynticks_task_exit();
+	// RCU is not watching here ...
 	rcu_dynticks_eqs_exit();
+	// ... but is watching here.
 	rcu_cleanup_after_idle();
 	trace_rcu_dyntick(TPS("End"), rdp->dynticks_nesting, 1, atomic_read(&rdp->dynticks));
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
@@ -810,7 +822,9 @@ static __always_inline void rcu_nmi_ente
 		if (irq)
 			rcu_dynticks_task_exit();
 
+		// RCU is not watching here ...
 		rcu_dynticks_eqs_exit();
+		// ... but is watching here.
 
 		if (irq)
 			rcu_cleanup_after_idle();
@@ -819,9 +833,16 @@ static __always_inline void rcu_nmi_ente
 	} else if (irq && tick_nohz_full_cpu(rdp->cpu) &&
 		   rdp->dynticks_nmi_nesting == DYNTICK_IRQ_NONIDLE &&
 		   READ_ONCE(rdp->rcu_urgent_qs) && !rdp->rcu_forced_tick) {
+		// We get here only if we had already exited the extended
+		// quiescent state and this was an interrupt (not an NMI).
+		// Therefore, (1) RCU is already watching and (2) The fact
+		// that we are in an interrupt handler and that the rcu_node
+		// lock is an irq-disabled lock prevents self-deadlock.
+		// So we can safely recheck under the lock.
 		raw_spin_lock_rcu_node(rdp->mynode);
-		// Recheck under lock.
 		if (rdp->rcu_urgent_qs && !rdp->rcu_forced_tick) {
+			// A nohz_full CPU is in the kernel and RCU
+			// needs a quiescent state.  Turn on the tick!
 			rdp->rcu_forced_tick = true;
 			tick_dep_set_cpu(rdp->cpu, TICK_DEP_BIT_RCU);
 		}

