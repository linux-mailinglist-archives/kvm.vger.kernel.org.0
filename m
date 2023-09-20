Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EC07A8D27
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 21:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjITTvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 15:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjITTvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 15:51:07 -0400
Received: from out-218.mta0.migadu.com (out-218.mta0.migadu.com [IPv6:2001:41d0:1004:224b::da])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF29A3
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 12:51:00 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695239458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=StOBBduZhWznhRh47grr17G/cGCpfNWRT0uF7YdH2CI=;
        b=dVH+BMxf3625PGnYYF/7CHiO/yCguj+ke3hTxHx3SJrgYqzgXJKrqv16Yoi6W2sYSmQDwf
        1zgZoTUJlULqM6C4c/AtpruOg8tMUAALXDWpaTWF3aYk8V59B48GjCGORz7mxquC0ZDIwD
        58vSWQ49EWVqqWf3qrTwusdQhu4PFss=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 8/8] KVM: arm64: Get rid of vCPU-scoped feature bitmap
Date:   Wed, 20 Sep 2023 19:50:36 +0000
Message-ID: <20230920195036.1169791-9-oliver.upton@linux.dev>
In-Reply-To: <20230920195036.1169791-1-oliver.upton@linux.dev>
References: <20230920195036.1169791-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vCPU-scoped feature bitmap was left in place a couple of releases
ago in case the change to VM-scoped vCPU features broke anyone. Nobody
has complained and the interop between VM and vCPU bitmaps is pretty
gross. Throw it out.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h | 13 ++++++-------
 arch/arm64/include/asm/kvm_host.h    |  3 ---
 arch/arm64/include/asm/kvm_nested.h  |  3 ++-
 arch/arm64/kvm/arm.c                 |  9 ++++-----
 arch/arm64/kvm/hypercalls.c          |  2 +-
 arch/arm64/kvm/reset.c               |  6 +++---
 include/kvm/arm_pmu.h                |  2 +-
 include/kvm/arm_psci.h               |  2 +-
 8 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3d6725ff0bf6..965b4cd8c247 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -54,6 +54,11 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
 int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
 int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
 
+static inline bool vcpu_has_feature(const struct kvm_vcpu *vcpu, int feature)
+{
+	return test_bit(feature, vcpu->kvm->arch.vcpu_features);
+}
+
 #if defined(__KVM_VHE_HYPERVISOR__) || defined(__KVM_NVHE_HYPERVISOR__)
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
@@ -62,7 +67,7 @@ static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 #else
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
-	return test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features);
+	return vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
 }
 #endif
 
@@ -565,12 +570,6 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 		vcpu_set_flag((v), e);					\
 	} while (0)
 
-
-static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
-{
-	return test_bit(feature, vcpu->arch.features);
-}
-
 static __always_inline void kvm_write_cptr_el2(u64 val)
 {
 	if (has_vhe() || has_hvhe())
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cb2cde7b2682..c3a17888f183 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -574,9 +574,6 @@ struct kvm_vcpu_arch {
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
-	/* feature flags */
-	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
-
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
 	u64 vsesr_el2;
 
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index fa23cc9c2adc..6cec8e9c6c91 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -2,13 +2,14 @@
 #ifndef __ARM64_KVM_NESTED_H
 #define __ARM64_KVM_NESTED_H
 
+#include <asm/kvm_emulate.h>
 #include <linux/kvm_host.h>
 
 static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 {
 	return (!__is_defined(__KVM_NVHE_HYPERVISOR__) &&
 		cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
-		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
+		vcpu_has_feature(vcpu, KVM_ARM_VCPU_HAS_EL2));
 }
 
 extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 32360a5f3779..30b7e8e7b668 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -367,7 +367,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
-	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
 
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
@@ -1263,7 +1262,8 @@ static bool kvm_vcpu_init_changed(struct kvm_vcpu *vcpu,
 {
 	unsigned long features = init->features[0];
 
-	return !bitmap_equal(vcpu->arch.features, &features, KVM_VCPU_MAX_FEATURES);
+	return !bitmap_equal(vcpu->kvm->arch.vcpu_features, &features,
+			     KVM_VCPU_MAX_FEATURES);
 }
 
 static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
@@ -1276,15 +1276,14 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	mutex_lock(&kvm->arch.config_lock);
 
 	if (test_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags) &&
-	    !bitmap_equal(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES))
+	    kvm_vcpu_init_changed(vcpu, init))
 		goto out_unlock;
 
-	bitmap_copy(vcpu->arch.features, &features, KVM_VCPU_MAX_FEATURES);
+	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
 
 	/* Now we know what it is, we can reset it. */
 	kvm_reset_vcpu(vcpu);
 
-	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
 	set_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags);
 	vcpu_set_flag(vcpu, VCPU_INITIALIZED);
 	ret = 0;
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 7fb4df0456de..1b79219c590c 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -554,7 +554,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	{
 		bool wants_02;
 
-		wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
+		wants_02 = vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2);
 
 		switch (val) {
 		case KVM_ARM_PSCI_0_1:
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 96ef9b7e74d4..5bb4de162cab 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -208,14 +208,14 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		kvm_arch_vcpu_put(vcpu);
 
 	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
-		if (test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features))
+		if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE))
 			kvm_vcpu_enable_sve(vcpu);
 	} else {
 		kvm_vcpu_reset_sve(vcpu);
 	}
 
-	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
-	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_ADDRESS) ||
+	    vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_GENERIC))
 		kvm_vcpu_enable_ptrauth(vcpu);
 
 	if (vcpu_el1_is_32bit(vcpu))
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 31029f4f7be8..3546ebc469ad 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -77,7 +77,7 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_resync_el0(void);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
-	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
+	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
 
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 6e55b9283789..e8fb624013d1 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -26,7 +26,7 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
 	 * revisions. It is thus safe to return the latest, unless
 	 * userspace has instructed us otherwise.
 	 */
-	if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features)) {
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2)) {
 		if (vcpu->kvm->arch.psci_version)
 			return vcpu->kvm->arch.psci_version;
 
-- 
2.42.0.515.g380fc7ccd1-goog

