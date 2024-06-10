Return-Path: <kvm+bounces-19196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8CA19022E4
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 15:45:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D87EE1C21FAB
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 13:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFC5514373A;
	Mon, 10 Jun 2024 13:42:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842A712FF63;
	Mon, 10 Jun 2024 13:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718026973; cv=none; b=T/CXM0k1eTyPez0CFeLEGPGOyMzR4VqnChKhYkUYEdugS/co4hDq44y+RXkUD4Iu0AeBu4XBzs7X1InWNGAgtRPeVZrejG3Xlox0Zz2ILUFwF27cm8/yo4fjxLF72pnTQ/pgpAKrBgpuMl9UtVTUVXGD+c/2qgW8B65IfycAFx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718026973; c=relaxed/simple;
	bh=yzaFdHoXIsJQIbQOkuic9g909yIoFvarnCXBDBuPqAA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ohxg5ew4gQlnglhekhG2S2gtzl9AApHhbwtHU0GHiMTR+MU1qrdm9PTDXQ1TuiWkmftQ6UEeZeByNP1dTnT25Y2Y0cR5cRt72HeAbcvKhB9Ld0R8iDlB29vKSxutHNy5u8gHSkqD41OIVZiekR3ss9xNhEnUK8JwHyDK90cnAX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 737C51692;
	Mon, 10 Jun 2024 06:43:15 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 687EA3F58B;
	Mon, 10 Jun 2024 06:42:47 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 09/43] arm64: RME: ioctls to create and configure realms
Date: Mon, 10 Jun 2024 14:41:28 +0100
Message-Id: <20240610134202.54893-10-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610134202.54893-1-steven.price@arm.com>
References: <20240610134202.54893-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the KVM_CAP_ARM_RME_CREATE_RD ioctl to create a realm. This involves
delegating pages to the RMM to hold the Realm Descriptor (RD) and for
the base level of the Realm Translation Tables (RTT). A VMID also need
to be picked, since the RMM has a separate VMID address space a
dedicated allocator is added for this purpose.

KVM_CAP_ARM_RME_CONFIG_REALM is provided to allow configuring the realm
before it is created. Configuration options can be classified as:

 1. Parameters specific to the Realm stage2 (e.g. IPA Size, vmid, stage2
    entry level, entry level RTTs, number of RTTs in start level, LPA2)
    Most of these are not measured by RMM and comes from KVM book
    keeping.

 2. Parameters controlling "Arm Architecture features for the VM". (e.g.
    SVE VL, PMU counters, number of HW BRPs/WPs), configured by the VMM
    using the "user ID register write" mechanism. These will be
    supported in the later patches.

 3. Parameters are not part of the core Arm architecture but defined
    by the RMM spec (e.g. Hash algorithm for measurement,
    Personalisation value). These are programmed via
    KVM_CAP_ARM_RME_CONFIG_REALM.

For the IPA size there is the possibility that the RMM supports a
different size to the IPA size supported by KVM for normal guests. At
the moment the 'normal limit' is exposed by KVM_CAP_ARM_VM_IPA_SIZE and
the IPA size is configured by the bottom bits of vm_type in
KVM_CREATE_VM. This means that it isn't easy for the VMM to discover
what IPA sizes are supported for Realm guests. Since the IPA is part of
the measurement of the realm guest the current expectation is that the
VMM will be required to pick the IPA size demanded by attestation and
therefore simply failing if this isn't available is fine. An option
would be to expose a new capability ioctl to obtain the RMM's maximum
IPA size if this is needed in the future.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v2:
 * Improved commit description.
 * Improved return failures for rmi_check_version().
 * Clear contents of PGD after it has been undelegated in case the RMM
   left stale data.
 * Minor changes to reflect changes in previous patches.
---
 arch/arm64/include/asm/kvm_emulate.h |   5 +
 arch/arm64/include/asm/kvm_rme.h     |  19 ++
 arch/arm64/kvm/arm.c                 |  18 ++
 arch/arm64/kvm/mmu.c                 |  15 +-
 arch/arm64/kvm/rme.c                 | 283 +++++++++++++++++++++++++++
 5 files changed, 338 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index bedc8344e082..56526594e3b5 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -612,6 +612,11 @@ static inline enum realm_state kvm_realm_state(struct kvm *kvm)
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
diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index 69af5c3a1e44..209cd99f03dd 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -6,6 +6,8 @@
 #ifndef __ASM_KVM_RME_H
 #define __ASM_KVM_RME_H
 
+#include <uapi/linux/kvm.h>
+
 /**
  * enum realm_state - State of a Realm
  */
@@ -46,11 +48,28 @@ enum realm_state {
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
 
 void kvm_init_rme(void);
+u32 kvm_realm_ipa_limit(void);
+
+int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
+int kvm_init_realm_vm(struct kvm *kvm);
+void kvm_destroy_realm(struct kvm *kvm);
 
 #endif
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cf136316afd5..d3cdc775d001 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -143,6 +143,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->slots_lock);
 		break;
+	case KVM_CAP_ARM_RME:
+		if (!kvm_is_realm(kvm))
+			return -EINVAL;
+		mutex_lock(&kvm->lock);
+		r = kvm_realm_enable_cap(kvm, cap);
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		break;
 	}
@@ -202,6 +209,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
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
@@ -260,6 +274,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_unshare_hyp(kvm, kvm + 1);
 
 	kvm_arm_teardown_hypercalls(kvm);
+	kvm_destroy_realm(kvm);
 }
 
 static bool kvm_has_full_ptr_auth(void)
@@ -407,6 +422,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
 		r = BIT(0);
 		break;
+	case KVM_CAP_ARM_RME:
+		r = static_key_enabled(&kvm_rme_is_available);
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8bcab0cc3fe9..19df60fee8c8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -872,6 +872,10 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	struct kvm_pgtable *pgt;
 	u64 mmfr0, mmfr1;
 	u32 phys_shift;
+	u32 ipa_limit = kvm_ipa_limit;
+
+	if (kvm_is_realm(kvm))
+		ipa_limit = kvm_realm_ipa_limit();
 
 	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
 		return -EINVAL;
@@ -880,12 +884,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	if (is_protected_kvm_enabled()) {
 		phys_shift = kvm_ipa_limit;
 	} else if (phys_shift) {
-		if (phys_shift > kvm_ipa_limit ||
+		if (phys_shift > ipa_limit ||
 		    phys_shift < ARM64_MIN_PARANGE_BITS)
 			return -EINVAL;
 	} else {
 		phys_shift = KVM_PHYS_SHIFT;
-		if (phys_shift > kvm_ipa_limit) {
+		if (phys_shift > ipa_limit) {
 			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
 				     current->comm);
 			return -EINVAL;
@@ -1014,6 +1018,13 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	struct kvm_pgtable *pgt = NULL;
 
 	write_lock(&kvm->mmu_lock);
+	if (kvm_is_realm(kvm) &&
+	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
+	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
+		/* Tearing down RTTs will be added in a later patch */
+		write_unlock(&kvm->mmu_lock);
+		return;
+	}
 	pgt = mmu->pgt;
 	if (pgt) {
 		mmu->pgd_phys = 0;
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 418685fbf6ed..4d21ec5f2910 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -5,9 +5,20 @@
 
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 #include <asm/rmi_cmds.h>
 #include <asm/virt.h>
 
+#include <asm/kvm_pgtable.h>
+
+static unsigned long rmm_feat_reg0;
+
+static bool rme_supports(unsigned long feature)
+{
+	return !!u64_get_bits(rmm_feat_reg0, feature);
+}
+
 static int rmi_check_version(void)
 {
 	struct arm_smccc_res res;
@@ -36,6 +47,272 @@ static int rmi_check_version(void)
 	return 0;
 }
 
+u32 kvm_realm_ipa_limit(void)
+{
+	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
+}
+
+static int get_start_level(struct realm *realm)
+{
+	return 4 - stage2_pgtable_levels(realm->ia_bits);
+}
+
+static int realm_create_rd(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+	struct realm_params *params = realm->params;
+	void *rd = NULL;
+	phys_addr_t rd_phys, params_phys;
+	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+	int i, r;
+
+	if (WARN_ON(realm->rd) || WARN_ON(!realm->params))
+		return -EEXIST;
+
+	rd = (void *)__get_free_page(GFP_KERNEL);
+	if (!rd)
+		return -ENOMEM;
+
+	rd_phys = virt_to_phys(rd);
+	if (rmi_granule_delegate(rd_phys)) {
+		r = -ENXIO;
+		goto free_rd;
+	}
+
+	for (i = 0; i < pgt->pgd_pages; i++) {
+		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
+
+		if (rmi_granule_delegate(pgd_phys)) {
+			r = -ENXIO;
+			goto out_undelegate_tables;
+		}
+	}
+
+	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
+
+	params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
+	params->rtt_level_start = get_start_level(realm);
+	params->rtt_num_start = pgt->pgd_pages;
+	params->rtt_base = kvm->arch.mmu.pgd_phys;
+	params->vmid = realm->vmid;
+
+	params_phys = virt_to_phys(params);
+
+	if (rmi_realm_create(rd_phys, params_phys)) {
+		r = -ENXIO;
+		goto out_undelegate_tables;
+	}
+
+	realm->rd = rd;
+
+	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
+		WARN_ON(rmi_realm_destroy(rd_phys));
+		goto out_undelegate_tables;
+	}
+
+	return 0;
+
+out_undelegate_tables:
+	while (--i >= 0) {
+		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
+
+		WARN_ON(rmi_granule_undelegate(pgd_phys));
+	}
+	WARN_ON(rmi_granule_undelegate(rd_phys));
+free_rd:
+	free_page((unsigned long)rd);
+	return r;
+}
+
+/* Protects access to rme_vmid_bitmap */
+static DEFINE_SPINLOCK(rme_vmid_lock);
+static unsigned long *rme_vmid_bitmap;
+
+static int rme_vmid_init(void)
+{
+	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
+
+	rme_vmid_bitmap = bitmap_zalloc(vmid_count, GFP_KERNEL);
+	if (!rme_vmid_bitmap) {
+		kvm_err("%s: Couldn't allocate rme vmid bitmap\n", __func__);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int rme_vmid_reserve(void)
+{
+	int ret;
+	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
+
+	spin_lock(&rme_vmid_lock);
+	ret = bitmap_find_free_region(rme_vmid_bitmap, vmid_count, 0);
+	spin_unlock(&rme_vmid_lock);
+
+	return ret;
+}
+
+static void rme_vmid_release(unsigned int vmid)
+{
+	spin_lock(&rme_vmid_lock);
+	bitmap_release_region(rme_vmid_bitmap, vmid, 0);
+	spin_unlock(&rme_vmid_lock);
+}
+
+static int kvm_create_realm(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+	int ret;
+
+	if (!kvm_is_realm(kvm))
+		return -EINVAL;
+	if (kvm_realm_is_created(kvm))
+		return -EEXIST;
+
+	ret = rme_vmid_reserve();
+	if (ret < 0)
+		return ret;
+	realm->vmid = ret;
+
+	ret = realm_create_rd(kvm);
+	if (ret) {
+		rme_vmid_release(realm->vmid);
+		return ret;
+	}
+
+	WRITE_ONCE(realm->state, REALM_STATE_NEW);
+
+	/* The realm is up, free the parameters.  */
+	free_page((unsigned long)realm->params);
+	realm->params = NULL;
+
+	return 0;
+}
+
+static int config_realm_hash_algo(struct realm *realm,
+				  struct kvm_cap_arm_rme_config_item *cfg)
+{
+	switch (cfg->hash_algo) {
+	case KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256:
+		if (!rme_supports(RMI_FEATURE_REGISTER_0_HASH_SHA_256))
+			return -EINVAL;
+		break;
+	case KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512:
+		if (!rme_supports(RMI_FEATURE_REGISTER_0_HASH_SHA_512))
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+	realm->params->hash_algo = cfg->hash_algo;
+	return 0;
+}
+
+static int kvm_rme_config_realm(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	struct kvm_cap_arm_rme_config_item cfg;
+	struct realm *realm = &kvm->arch.realm;
+	int r = 0;
+
+	if (kvm_realm_is_created(kvm))
+		return -EBUSY;
+
+	if (copy_from_user(&cfg, (void __user *)cap->args[1], sizeof(cfg)))
+		return -EFAULT;
+
+	switch (cfg.cfg) {
+	case KVM_CAP_ARM_RME_CFG_RPV:
+		memcpy(&realm->params->rpv, &cfg.rpv, sizeof(cfg.rpv));
+		break;
+	case KVM_CAP_ARM_RME_CFG_HASH_ALGO:
+		r = config_realm_hash_algo(realm, &cfg);
+		break;
+	default:
+		r = -EINVAL;
+	}
+
+	return r;
+}
+
+int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	int r = 0;
+
+	if (!kvm_is_realm(kvm))
+		return -EINVAL;
+
+	switch (cap->args[0]) {
+	case KVM_CAP_ARM_RME_CONFIG_REALM:
+		r = kvm_rme_config_realm(kvm, cap);
+		break;
+	case KVM_CAP_ARM_RME_CREATE_RD:
+		r = kvm_create_realm(kvm);
+		break;
+	default:
+		r = -EINVAL;
+		break;
+	}
+
+	return r;
+}
+
+void kvm_destroy_realm(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+	int i;
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
+		if (WARN_ON(rmi_granule_undelegate(rd_phys)))
+			return;
+		free_page((unsigned long)realm->rd);
+		realm->rd = NULL;
+	}
+
+	rme_vmid_release(realm->vmid);
+
+	for (i = 0; i < pgt->pgd_pages; i++) {
+		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
+
+		if (WARN_ON(rmi_granule_undelegate(pgd_phys)))
+			return;
+
+		clear_page(phys_to_virt(pgd_phys));
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
+	struct realm_params *params;
+
+	params = (struct realm_params *)get_zeroed_page(GFP_KERNEL);
+	if (!params)
+		return -ENOMEM;
+
+	kvm->arch.realm.params = params;
+	return 0;
+}
+
 void kvm_init_rme(void)
 {
 	if (PAGE_SIZE != SZ_4K)
@@ -46,5 +323,11 @@ void kvm_init_rme(void)
 		/* Continue without realm support */
 		return;
 
+	if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
+		return;
+
+	if (rme_vmid_init())
+		return;
+
 	/* Future patch will enable static branch kvm_rme_is_available */
 }
-- 
2.34.1


