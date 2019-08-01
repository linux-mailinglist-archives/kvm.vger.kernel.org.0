Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5857D7DE0D
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 16:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732132AbfHAOiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 10:38:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36213 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729084AbfHAOiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 10:38:20 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1htCDV-0000lz-DQ; Thu, 01 Aug 2019 16:38:05 +0200
Message-Id: <20190801143657.785902257@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 01 Aug 2019 16:32:51 +0200
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
Subject: [patch 1/5] tracehook: Provide TIF_NOTIFY_RESUME handling for KVM
References: <20190801143250.370326052@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TIF_NOTITY_RESUME is evaluated on return to user space along with other TIF
flags.

>From the kernels point of view a VMENTER is more or less equivalent to
return to user space which means that at least a subset of TIF flags needs
to be evaluated and handled.

Currently KVM handles only TIF_SIGPENDING and TIF_NEED_RESCHED, but
TIF_NOTIFY_RESUME is ignored. So pending task_work etc, is completely
ignored until the vCPU thread actually goes all the way back into
userspace/qemu.

Provide notify_resume_pending() and tracehook_handle_notify_resume() so
this can be handled similar to SIGPENDING.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/tracehook.h |   15 +++++++++++++++
 kernel/task_work.c        |   19 +++++++++++++++++++
 2 files changed, 34 insertions(+)

--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -163,6 +163,21 @@ static inline void set_notify_resume(str
 #endif
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+/**
+ * notify_resume_pending - Check whether current has TIF_NOTIFY_RESUME set
+ */
+static inline bool notify_resume_pending(void)
+{
+	return test_thread_flag(TIF_NOTIFY_RESUME);
+}
+
+void tracehook_handle_notify_resume(void);
+#else
+static inline bool notify_resume_pending(void) { return false; }
+static inline void tracehook_handle_notify_resume(void) { }
+#endif
+
 /**
  * tracehook_notify_resume - report when about to return to user mode
  * @regs:		user-mode registers of @current task
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -116,3 +116,22 @@ void task_work_run(void)
 		} while (work);
 	}
 }
+
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+/**
+ * tracehook_handle_notify_resume - Notify resume handling for virt
+ *
+ * Called with interrupts and preemption enabled from VMENTER/EXIT.
+ */
+void tracehook_handle_notify_resume(void)
+{
+	local_irq_disable();
+	while (test_and_clear_thread_flag(TIF_NOTIFY_RESUME)) {
+		local_irq_enable();
+		tracehook_notify_resume(NULL);
+		local_irq_disable();
+	}
+	local_irq_enable();
+}
+EXPORT_SYMBOL_GPL(tracehook_handle_notify_resume);
+#endif


