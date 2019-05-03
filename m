Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D753312DF2
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfECMpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:45:11 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60148 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbfECMpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:45:11 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD82D1682;
        Fri,  3 May 2019 05:45:10 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A3EEF3F220;
        Fri,  3 May 2019 05:45:07 -0700 (PDT)
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
Subject: [PATCH 08/56] arm64/sve: Enable SVE state tracking for non-task contexts
Date:   Fri,  3 May 2019 13:43:39 +0100
Message-Id: <20190503124427.190206-9-marc.zyngier@arm.com>
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

The current FPSIMD/SVE context handling support for non-task (i.e.,
KVM vcpu) contexts does not take SVE into account.  This means that
only task contexts can safely use SVE at present.

In preparation for enabling KVM guests to use SVE, it is necessary
to keep track of SVE state for non-task contexts too.

This patch adds the necessary support, removing assumptions from
the context switch code about the location of the SVE context
storage.

When binding a vcpu context, its vector length is arbitrarily
specified as SVE_VL_MIN for now.  In any case, because TIF_SVE is
presently cleared at vcpu context bind time, the specified vector
length will not be used for anything yet.  In later patches TIF_SVE
will be set here as appropriate, and the appropriate maximum vector
length for the vcpu will be passed when binding.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Julien Grall <julien.grall@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/fpsimd.h |  3 ++-
 arch/arm64/kernel/fpsimd.c      | 20 +++++++++++++++-----
 arch/arm64/kvm/fpsimd.c         |  5 ++++-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 964adc9f312d..df7a14305222 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -56,7 +56,8 @@ extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
 
 extern void fpsimd_bind_task_to_cpu(void);
-extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state);
+extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
+				     void *sve_state, unsigned int sve_vl);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 extern void fpsimd_flush_cpu_state(void);
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index b219796a4081..8a93afa78600 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -121,6 +121,8 @@
  */
 struct fpsimd_last_state_struct {
 	struct user_fpsimd_state *st;
+	void *sve_state;
+	unsigned int sve_vl;
 };
 
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
@@ -241,14 +243,15 @@ static void task_fpsimd_load(void)
  */
 void fpsimd_save(void)
 {
-	struct user_fpsimd_state *st = __this_cpu_read(fpsimd_last_state.st);
+	struct fpsimd_last_state_struct const *last =
+		this_cpu_ptr(&fpsimd_last_state);
 	/* set by fpsimd_bind_task_to_cpu() or fpsimd_bind_state_to_cpu() */
 
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
 		if (system_supports_sve() && test_thread_flag(TIF_SVE)) {
-			if (WARN_ON(sve_get_vl() != current->thread.sve_vl)) {
+			if (WARN_ON(sve_get_vl() != last->sve_vl)) {
 				/*
 				 * Can't save the user regs, so current would
 				 * re-enter user with corrupt state.
@@ -258,9 +261,11 @@ void fpsimd_save(void)
 				return;
 			}
 
-			sve_save_state(sve_pffr(&current->thread), &st->fpsr);
+			sve_save_state((char *)last->sve_state +
+						sve_ffr_offset(last->sve_vl),
+				       &last->st->fpsr);
 		} else
-			fpsimd_save_state(st);
+			fpsimd_save_state(last->st);
 	}
 }
 
@@ -1034,6 +1039,8 @@ void fpsimd_bind_task_to_cpu(void)
 		this_cpu_ptr(&fpsimd_last_state);
 
 	last->st = &current->thread.uw.fpsimd_state;
+	last->sve_state = current->thread.sve_state;
+	last->sve_vl = current->thread.sve_vl;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	if (system_supports_sve()) {
@@ -1047,7 +1054,8 @@ void fpsimd_bind_task_to_cpu(void)
 	}
 }
 
-void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st)
+void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
+			      unsigned int sve_vl)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1055,6 +1063,8 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st)
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	last->st = st;
+	last->sve_state = sve_state;
+	last->sve_vl = sve_vl;
 }
 
 /*
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index aac7808ce216..1cf4f0269471 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/thread_info.h>
 #include <linux/kvm_host.h>
+#include <asm/fpsimd.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_mmu.h>
@@ -85,7 +86,9 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
-		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs);
+		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs,
+					 NULL, SVE_VL_MIN);
+
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
 		clear_thread_flag(TIF_SVE);
 	}
-- 
2.20.1

