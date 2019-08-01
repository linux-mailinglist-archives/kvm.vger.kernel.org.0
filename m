Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4454D7DE09
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 16:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbfHAOi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 10:38:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36235 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732157AbfHAOi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 10:38:26 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1htCDW-0000m4-17; Thu, 01 Aug 2019 16:38:06 +0200
Message-Id: <20190801143657.887648487@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 01 Aug 2019 16:32:52 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: [patch 2/5] x86/kvm: Handle task_work on VMENTER/EXIT
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

Use the newly provided notify_resume_pending() and
tracehook_handle_notify_resume() to solve this similar to the existing
handling of SIGPENDING.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: kvm@vger.kernel.org
Cc: Radim Krcmar <rkrcmar@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -52,6 +52,7 @@
 #include <linux/irqbypass.h>
 #include <linux/sched/stat.h>
 #include <linux/sched/isolation.h>
+#include <linux/tracehook.h>
 #include <linux/mem_encrypt.h>
 
 #include <trace/events/kvm.h>
@@ -7972,7 +7973,8 @@ static int vcpu_enter_guest(struct kvm_v
 		kvm_x86_ops->sync_pir_to_irr(vcpu);
 
 	if (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
-	    || need_resched() || signal_pending(current)) {
+	    || need_resched() || signal_pending(current)
+	    || notify_resume_pending()) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		smp_wmb();
 		local_irq_enable();
@@ -8172,6 +8174,10 @@ static int vcpu_run(struct kvm_vcpu *vcp
 			++vcpu->stat.signal_exits;
 			break;
 		}
+
+		if (notify_resume_pending())
+			tracehook_handle_notify_resume();
+
 		if (need_resched()) {
 			srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 			cond_resched();


