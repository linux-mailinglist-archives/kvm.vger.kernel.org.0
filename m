Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250AD42ED40
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236886AbhJOJMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236907AbhJOJMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 05:12:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89686611ED;
        Fri, 15 Oct 2021 09:10:15 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mbJED-00GvHX-JT; Fri, 15 Oct 2021 10:10:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: [PATCH 5/5] KVM: arm64: Drop vcpu->arch.has_run_once for vcpu->pid
Date:   Fri, 15 Oct 2021 10:08:22 +0100
Message-Id: <20211015090822.2994920-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211015090822.2994920-1-maz@kernel.org>
References: <20211015090822.2994920-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the transition to kvm_arch_vcpu_run_pid_change() to handle
the "run once" activities, it becomes obvious that has_run_once
is now an exact shadow of vcpu->pid.

Replace vcpu->arch.has_run_once with a new vcpu_has_run_once()
helper that directly checks for vcpu->pid, and get rid of the
now unused field.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 5 ++---
 arch/arm64/kvm/arm.c              | 8 +++-----
 arch/arm64/kvm/vgic/vgic-init.c   | 2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d7107d627c54..e0de761ecbf2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -366,9 +366,6 @@ struct kvm_vcpu_arch {
 	int target;
 	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
 
-	/* Detect first run of a vcpu */
-	bool has_run_once;
-
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
 	u64 vsesr_el2;
 
@@ -605,6 +602,8 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
+#define vcpu_has_run_once(vcpu)	!!rcu_access_pointer((vcpu)->pid)
+
 #ifndef __KVM_NVHE_HYPERVISOR__
 #define kvm_call_hyp_nvhe(f, ...)						\
 	({								\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5bcdf8073854..ebcb1adf80fb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -350,7 +350,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
+	if (vcpu_has_run_once(vcpu) && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
@@ -600,7 +600,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	if (likely(vcpu->arch.has_run_once))
+	if (likely(vcpu_has_run_once(vcpu)))
 		return 0;
 
 	kvm_arm_vcpu_init_debug(vcpu);
@@ -631,8 +631,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		static_branch_inc(&userspace_irqchip_in_use);
 	}
 
-	vcpu->arch.has_run_once = true;
-
 	return ret;
 }
 
@@ -1123,7 +1121,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * need to invalidate the I-cache though, as FWB does *not*
 	 * imply CTR_EL0.DIC.
 	 */
-	if (vcpu->arch.has_run_once) {
+	if (vcpu_has_run_once(vcpu)) {
 		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
 			stage2_unmap_vm(vcpu->kvm);
 		else
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 340c51d87677..8d89ca15f613 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -91,7 +91,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		return ret;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu->arch.has_run_once)
+		if (vcpu_has_run_once(vcpu))
 			goto out_unlock;
 	}
 	ret = 0;
-- 
2.30.2

