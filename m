Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3879D7DE0B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 16:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732187AbfHAOic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 10:38:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36248 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732171AbfHAOib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 10:38:31 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1htCDX-0000mC-7j; Thu, 01 Aug 2019 16:38:07 +0200
Message-Id: <20190801143658.074833024@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 01 Aug 2019 16:32:54 +0200
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
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 4/5] posix-cpu-timers: Defer timer handling to task_work
References: <20190801143250.370326052@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Running posix cpu timers in hard interrupt context has a few downsides:

 - For PREEMPT_RT it cannot work as the expiry code needs to take sighand
   lock, which is a 'sleeping spinlock' in RT

 - For fine grained accounting it's just wrong to run this in context of
   the timer interrupt because that way a process specific cpu time is
   accounted to the timer interrupt.

There is no real hard requirement to run the expiry code in hard interrupt
context. The posix CPU timers are an approximation anyway, so having them
expired and evaluated in task work context does not really make them worse.

Make it conditional on a selectable config switch as this requires that
task work is handled in KVM.

The available tests pass and no problematic difference has been observed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
---
 include/linux/sched.h          |    3 +++
 kernel/time/Kconfig            |    5 +++++
 kernel/time/posix-cpu-timers.c |   26 +++++++++++++++++++++++++-
 3 files changed, 33 insertions(+), 1 deletion(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -880,6 +880,9 @@ struct task_struct {
 	struct task_cputime		cputime_expires;
 	struct list_head		cpu_timers[3];
 #endif
+#ifdef CONFIG_POSIX_CPU_TIMERS_TASK_WORK
+	struct callback_head		cpu_timer_work;
+#endif
 
 	/* Process credentials: */
 
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -52,6 +52,11 @@ config GENERIC_CLOCKEVENTS_MIN_ADJUST
 config GENERIC_CMOS_UPDATE
 	bool
 
+# Select to handle posix CPU timers from task_work
+# and not from the timer interrupt context
+config POSIX_CPU_TIMERS_TASK_WORK
+	bool
+
 if GENERIC_CLOCKEVENTS
 menu "Timers subsystem"
 
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -14,6 +14,7 @@
 #include <linux/tick.h>
 #include <linux/workqueue.h>
 #include <linux/compat.h>
+#include <linux/task_work.h>
 #include <linux/sched/deadline.h>
 
 #include "posix-timers.h"
@@ -1127,7 +1128,7 @@ static inline int fastpath_timer_check(s
 	return 0;
 }
 
-static void __run_posix_cpu_timers(struct task_struct *tsk)
+static void handle_posix_cpu_timers(struct task_struct *tsk)
 {
 	struct k_itimer *timer, *next;
 	unsigned long flags;
@@ -1178,6 +1179,29 @@ static void __run_posix_cpu_timers(struc
 	}
 }
 
+#ifdef CONFIG_POSIX_CPU_TIMERS_TASK_WORK
+
+static void posix_cpu_timers_work(struct callback_head *work)
+{
+	handle_posix_cpu_timers(current);
+}
+
+static void __run_posix_cpu_timers(struct task_struct *tsk)
+{
+	/* FIXME: Init it proper in fork or such */
+	init_task_work(&tsk->cpu_timer_work, posix_cpu_timers_work);
+	task_work_add(tsk, &tsk->cpu_timer_work, true);
+}
+
+#else
+
+static void __run_posix_cpu_timers(struct task_struct *tsk)
+{
+	handle_posix_cpu_timers(tsk);
+}
+
+#endif
+
 /*
  * This is called from the timer interrupt handler.  The irq handler has
  * already updated our counts.  We need to check if any timers fire now.


