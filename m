Return-Path: <kvm+bounces-66118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A800FCC7212
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:41:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E2331303D253
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD73342503;
	Wed, 17 Dec 2025 10:12:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED70340A72;
	Wed, 17 Dec 2025 10:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966342; cv=none; b=MWBjwHmTNnl9feub9WlNpfzvvPkXoaHqIHeviB1e8Mumo1Fg1CRBvtzTHa0vAPAxZCiTjDXudzKrUg91kOLm8zO6/G1B9X0Dhn5LMKZznCQNC+IIQlQl7X/HYZHTWUCLsgKfecBphw9vgjiGWeIZjKi/q8vl12oh1bmyS2U6z2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966342; c=relaxed/simple;
	bh=ilL8u7c9JdDC8BAm2fPHjF+lg4x5hxNDVti6cqt8VjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHHkKkZxzYXfBg3eXgA8qEkY52KxD0stpK0+pJpfH8NGNw6ey6sdlkEb5/Ytl2vI+NFOyRR3c1ATdNIkgUJ9+kNcrLvMDMGplLDwA6BaehmejH+OrbOy4e3wtYqYDoDMN4pStcPDrdRZqJs7RvlbtADMeivLT6ZkC4DUICLGqqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CB0F14BF;
	Wed, 17 Dec 2025 02:12:13 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 321C83F73B;
	Wed, 17 Dec 2025 02:12:16 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v12 07/46] arm64: RMI: Basic infrastructure for creating a realm.
Date: Wed, 17 Dec 2025 10:10:44 +0000
Message-ID: <20251217101125.91098-8-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the skeleton functions for creating and destroying a realm.
The IPA size requested is checked against what the RMM supports.

The actual work of constructing the realm will be added in future
patches.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v11:
 * Major rework to drop the realm configuration and make the
   construction of realms implicit rather than driven by the VMM
   directly.
 * The code to create RDs, handle VMIDs etc is moved to later patches.
Changes since v10:
 * Rename from RME to RMI.
 * Move the stage2 cleanup to a later patch.
Changes since v9:
 * Avoid walking the stage 2 page tables when destroying the realm -
   the real ones are not accessible to the non-secure world, and the RMM
   may leave junk in the physical pages when returning them.
 * Fix an error path in realm_create_rd() to actually return an error value.
Changes since v8:
 * Fix free_delegated_granule() to not call kvm_account_pgtable_pages();
   a separate wrapper will be introduced in a later patch to deal with
   RTTs.
 * Minor code cleanups following review.
Changes since v7:
 * Minor code cleanup following Gavin's review.
Changes since v6:
 * Separate RMM RTT calculations from host PAGE_SIZE. This allows the
   host page size to be larger than 4k while still communicating with an
   RMM which uses 4k granules.
Changes since v5:
 * Introduce free_delegated_granule() to replace many
   undelegate/free_page() instances and centralise the comment on
   leaking when the undelegate fails.
 * Several other minor improvements suggested by reviews - thanks for
   the feedback!
Changes since v2:
 * Improved commit description.
 * Improved return failures for rmi_check_version().
 * Clear contents of PGD after it has been undelegated in case the RMM
   left stale data.
 * Minor changes to reflect changes in previous patches.
---
 arch/arm64/include/asm/kvm_emulate.h |  5 ++
 arch/arm64/include/asm/kvm_rmi.h     | 18 +++++++
 arch/arm64/kvm/arm.c                 | 11 ++++
 arch/arm64/kvm/mmu.c                 | 11 ++--
 arch/arm64/kvm/rmi.c                 | 81 ++++++++++++++++++++++++++++
 5 files changed, 123 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 67f75678e489..e7e9364ae118 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -709,6 +709,11 @@ static inline enum realm_state kvm_realm_state(struct kvm *kvm)
 	return READ_ONCE(kvm->arch.realm.state);
 }
 
+static inline bool kvm_realm_is_created(struct kvm *kvm)
+{
+	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
+}
+
 static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
 {
 	return false;
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 3506f50b05cd..7f06aa5b0550 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -6,6 +6,8 @@
 #ifndef __ASM_KVM_RMI_H
 #define __ASM_KVM_RMI_H
 
+#include <asm/rmi_smc.h>
+
 /**
  * enum realm_state - State of a Realm
  */
@@ -46,11 +48,27 @@ enum realm_state {
  * struct realm - Additional per VM data for a Realm
  *
  * @state: The lifetime state machine for the realm
+ * @rd: Kernel mapping of the Realm Descriptor (RD)
+ * @params: Parameters for the RMI_REALM_CREATE command
+ * @num_aux: The number of auxiliary pages required by the RMM
+ * @vmid: VMID to be used by the RMM for the realm
+ * @ia_bits: Number of valid Input Address bits in the IPA
  */
 struct realm {
 	enum realm_state state;
+
+	void *rd;
+	struct realm_params *params;
+
+	unsigned long num_aux;
+	unsigned int vmid;
+	unsigned int ia_bits;
 };
 
 void kvm_init_rmi(void);
+u32 kvm_realm_ipa_limit(void);
+
+int kvm_init_realm_vm(struct kvm *kvm);
+void kvm_destroy_realm(struct kvm *kvm);
 
 #endif /* __ASM_KVM_RMI_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a537f56f97db..4ce3ad1d69b0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -207,6 +207,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
 
+	/* Initialise the realm bits after the generic bits are enabled */
+	if (kvm_is_realm(kvm)) {
+		ret = kvm_init_realm_vm(kvm);
+		if (ret)
+			goto err_free_cpumask;
+	}
+
 	return 0;
 
 err_free_cpumask:
@@ -266,6 +273,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_unshare_hyp(kvm, kvm + 1);
 
 	kvm_arm_teardown_hypercalls(kvm);
+	kvm_destroy_realm(kvm);
 }
 
 static bool kvm_has_full_ptr_auth(void)
@@ -427,6 +435,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		else
 			r = kvm_supports_cacheable_pfnmap();
 		break;
+	case KVM_CAP_ARM_RMI:
+		r = static_key_enabled(&kvm_rmi_is_available);
+		break;
 
 	default:
 		r = 0;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 48d7c372a4cd..d91e7eb2c8d3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -872,12 +872,16 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.icache_inval_pou	= invalidate_icache_guest_page,
 };
 
-static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
+static int kvm_init_ipa_range(struct kvm *kvm,
+			      struct kvm_s2_mmu *mmu, unsigned long type)
 {
 	u32 kvm_ipa_limit = get_kvm_ipa_limit();
 	u64 mmfr0, mmfr1;
 	u32 phys_shift;
 
+	if (kvm_is_realm(kvm))
+		kvm_ipa_limit = kvm_realm_ipa_limit();
+
 	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
 		return -EINVAL;
 
@@ -974,7 +978,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 		return -EINVAL;
 	}
 
-	err = kvm_init_ipa_range(mmu, type);
+	err = kvm_init_ipa_range(kvm, mmu, type);
 	if (err)
 		return err;
 
@@ -1113,7 +1117,8 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	write_unlock(&kvm->mmu_lock);
 
 	if (pgt) {
-		kvm_stage2_destroy(pgt);
+		if (!kvm_is_realm(kvm))
+			kvm_stage2_destroy(pgt);
 		kfree(pgt);
 	}
 }
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 629ace10cacc..c2b13fecfd11 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -5,9 +5,18 @@
 
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 #include <asm/rmi_cmds.h>
 #include <asm/virt.h>
 
+#include <asm/kvm_pgtable.h>
+
+static unsigned long rmm_feat_reg0;
+
+#define RMM_PAGE_SHIFT		12
+#define RMM_PAGE_SIZE		BIT(RMM_PAGE_SHIFT)
+
 static int rmi_check_version(void)
 {
 	struct arm_smccc_res res;
@@ -47,6 +56,75 @@ static int rmi_check_version(void)
 	return 0;
 }
 
+u32 kvm_realm_ipa_limit(void)
+{
+	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
+}
+
+static int free_delegated_granule(phys_addr_t phys)
+{
+	if (WARN_ON(rmi_granule_undelegate(phys))) {
+		/* Undelegate failed: leak the page */
+		return -EBUSY;
+	}
+
+	free_page((unsigned long)phys_to_virt(phys));
+
+	return 0;
+}
+
+void kvm_destroy_realm(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
+	int i;
+
+	write_lock(&kvm->mmu_lock);
+	kvm_stage2_unmap_range(&kvm->arch.mmu, 0,
+			       BIT(realm->ia_bits - 1), true);
+	write_unlock(&kvm->mmu_lock);
+
+	if (realm->params) {
+		free_page((unsigned long)realm->params);
+		realm->params = NULL;
+	}
+
+	if (!kvm_realm_is_created(kvm))
+		return;
+
+	WRITE_ONCE(realm->state, REALM_STATE_DYING);
+
+	if (realm->rd) {
+		phys_addr_t rd_phys = virt_to_phys(realm->rd);
+
+		if (WARN_ON(rmi_realm_destroy(rd_phys)))
+			return;
+		free_delegated_granule(rd_phys);
+		realm->rd = NULL;
+	}
+
+	for (i = 0; i < pgd_size; i += RMM_PAGE_SIZE) {
+		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
+
+		if (WARN_ON(rmi_granule_undelegate(pgd_phys)))
+			return;
+	}
+
+	WRITE_ONCE(realm->state, REALM_STATE_DEAD);
+
+	/* Now that the Realm is destroyed, free the entry level RTTs */
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
+}
+
+int kvm_init_realm_vm(struct kvm *kvm)
+{
+	kvm->arch.realm.params = (void *)get_zeroed_page(GFP_KERNEL);
+
+	if (!kvm->arch.realm.params)
+		return -ENOMEM;
+	return 0;
+}
+
 void kvm_init_rmi(void)
 {
 	/* Only 4k page size on the host is supported */
@@ -57,5 +135,8 @@ void kvm_init_rmi(void)
 	if (rmi_check_version())
 		return;
 
+	if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
+		return;
+
 	/* Future patch will enable static branch kvm_rmi_is_available */
 }
-- 
2.43.0


