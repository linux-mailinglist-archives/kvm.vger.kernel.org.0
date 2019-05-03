Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9F612DE3
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbfECMou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:44:50 -0400
Received: from foss.arm.com ([217.140.101.70]:60006 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbfECMou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:44:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC1D0374;
        Fri,  3 May 2019 05:44:49 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95A253F220;
        Fri,  3 May 2019 05:44:46 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 02/56] arm64: fpsimd: Always set TIF_FOREIGN_FPSTATE on task state flush
Date:   Fri,  3 May 2019 13:43:33 +0100
Message-Id: <20190503124427.190206-3-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

This patch updates fpsimd_flush_task_state() to mirror the new
semantics of fpsimd_flush_cpu_state() introduced by commit
d8ad71fa38a9 ("arm64: fpsimd: Fix TIF_FOREIGN_FPSTATE after
invalidating cpu regs").  Both functions now implicitly set
TIF_FOREIGN_FPSTATE to indicate that the task's FPSIMD state is not
loaded into the cpu.

As a side-effect, fpsimd_flush_task_state() now sets
TIF_FOREIGN_FPSTATE even for non-running tasks.  In the case of
non-running tasks this is not useful but also harmless, because the
flag is live only while the corresponding task is running.  This
function is not called from fast paths, so special-casing this for
the task == current case is not really worth it.

Compiler barriers previously present in restore_sve_fpsimd_context()
are pulled into fpsimd_flush_task_state() so that it can be safely
called with preemption enabled if necessary.

Explicit calls to set TIF_FOREIGN_FPSTATE that accompany
fpsimd_flush_task_state() calls and are now redundant are removed
as appropriate.

fpsimd_flush_task_state() is used to get exclusive access to the
representation of the task's state via task_struct, for the purpose
of replacing the state.  Thus, the call to this function should
happen before manipulating fpsimd_state or sve_state etc. in
task_struct.  Anomalous cases are reordered appropriately in order
to make the code more consistent, although there should be no
functional difference since these cases are protected by
local_bh_disable() anyway.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Julien Grall <julien.grall@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 25 +++++++++++++++++++------
 arch/arm64/kernel/signal.c |  5 -----
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 5ebe73b69961..62c37f0ac946 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -550,7 +550,6 @@ int sve_set_vector_length(struct task_struct *task,
 		local_bh_disable();
 
 		fpsimd_save();
-		set_thread_flag(TIF_FOREIGN_FPSTATE);
 	}
 
 	fpsimd_flush_task_state(task);
@@ -816,12 +815,11 @@ asmlinkage void do_sve_acc(unsigned int esr, struct pt_regs *regs)
 	local_bh_disable();
 
 	fpsimd_save();
-	fpsimd_to_sve(current);
 
 	/* Force ret_to_user to reload the registers: */
 	fpsimd_flush_task_state(current);
-	set_thread_flag(TIF_FOREIGN_FPSTATE);
 
+	fpsimd_to_sve(current);
 	if (test_and_set_thread_flag(TIF_SVE))
 		WARN_ON(1); /* SVE access shouldn't have trapped */
 
@@ -894,9 +892,9 @@ void fpsimd_flush_thread(void)
 
 	local_bh_disable();
 
+	fpsimd_flush_task_state(current);
 	memset(&current->thread.uw.fpsimd_state, 0,
 	       sizeof(current->thread.uw.fpsimd_state));
-	fpsimd_flush_task_state(current);
 
 	if (system_supports_sve()) {
 		clear_thread_flag(TIF_SVE);
@@ -933,8 +931,6 @@ void fpsimd_flush_thread(void)
 			current->thread.sve_vl_onexec = 0;
 	}
 
-	set_thread_flag(TIF_FOREIGN_FPSTATE);
-
 	local_bh_enable();
 }
 
@@ -1043,12 +1039,29 @@ void fpsimd_update_current_state(struct user_fpsimd_state const *state)
 
 /*
  * Invalidate live CPU copies of task t's FPSIMD state
+ *
+ * This function may be called with preemption enabled.  The barrier()
+ * ensures that the assignment to fpsimd_cpu is visible to any
+ * preemption/softirq that could race with set_tsk_thread_flag(), so
+ * that TIF_FOREIGN_FPSTATE cannot be spuriously re-cleared.
+ *
+ * The final barrier ensures that TIF_FOREIGN_FPSTATE is seen set by any
+ * subsequent code.
  */
 void fpsimd_flush_task_state(struct task_struct *t)
 {
 	t->thread.fpsimd_cpu = NR_CPUS;
+
+	barrier();
+	set_tsk_thread_flag(t, TIF_FOREIGN_FPSTATE);
+
+	barrier();
 }
 
+/*
+ * Invalidate any task's FPSIMD state that is present on this cpu.
+ * This function must be called with softirqs disabled.
+ */
 void fpsimd_flush_cpu_state(void)
 {
 	__this_cpu_write(fpsimd_last_state.st, NULL);
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 867a7cea70e5..a9b0485df074 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -296,11 +296,6 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 	 */
 
 	fpsimd_flush_task_state(current);
-	barrier();
-	/* From now, fpsimd_thread_switch() won't clear TIF_FOREIGN_FPSTATE */
-
-	set_thread_flag(TIF_FOREIGN_FPSTATE);
-	barrier();
 	/* From now, fpsimd_thread_switch() won't touch thread.sve_state */
 
 	sve_alloc(current);
-- 
2.20.1

