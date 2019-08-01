Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72F77DE0E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 16:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732161AbfHAOiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 10:38:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36227 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731467AbfHAOiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 10:38:24 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1htCDW-0000m7-KX; Thu, 01 Aug 2019 16:38:06 +0200
Message-Id: <20190801143657.980489544@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 01 Aug 2019 16:32:53 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: [patch 3/5] posix-cpu-timers: Split run_posix_cpu_timers()
References: <20190801143250.370326052@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split run_posix_cpu_timers() into two pieces, the hard interrupt context
part and the actual timer evaluation/expiry part.

The hard interrupt context part contains only the lockless fast path check
and for now calls the expiry part as before.

No functional change. Preparatory change to move the expiry part into task
context.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>

---
 kernel/time/posix-cpu-timers.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1127,25 +1127,11 @@ static inline int fastpath_timer_check(s
 	return 0;
 }
 
-/*
- * This is called from the timer interrupt handler.  The irq handler has
- * already updated our counts.  We need to check if any timers fire now.
- * Interrupts are disabled.
- */
-void run_posix_cpu_timers(struct task_struct *tsk)
+static void __run_posix_cpu_timers(struct task_struct *tsk)
 {
-	LIST_HEAD(firing);
 	struct k_itimer *timer, *next;
 	unsigned long flags;
-
-	lockdep_assert_irqs_disabled();
-
-	/*
-	 * The fast path checks that there are no expired thread or thread
-	 * group timers.  If that's so, just return.
-	 */
-	if (!fastpath_timer_check(tsk))
-		return;
+	LIST_HEAD(firing);
 
 	if (!lock_task_sighand(tsk, &flags))
 		return;
@@ -1193,6 +1179,25 @@ void run_posix_cpu_timers(struct task_st
 }
 
 /*
+ * This is called from the timer interrupt handler.  The irq handler has
+ * already updated our counts.  We need to check if any timers fire now.
+ * Interrupts are disabled.
+ */
+void run_posix_cpu_timers(struct task_struct *tsk)
+{
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * The fast path checks that there are no expired thread or thread
+	 * group timers.  If that's so, just return.
+	 */
+	if (!fastpath_timer_check(tsk))
+		return;
+
+	__run_posix_cpu_timers(tsk);
+}
+
+/*
  * Set one of the process-wide special case CPU timers or RLIMIT_CPU.
  * The tsk->sighand->siglock must be held by the caller.
  */


