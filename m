Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948B967E369
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbjA0Lc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbjA0LcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:32:10 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 362D280020;
        Fri, 27 Jan 2023 03:30:37 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4D1A15DB;
        Fri, 27 Jan 2023 03:30:40 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.16])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51AB53F64C;
        Fri, 27 Jan 2023 03:29:56 -0800 (PST)
From:   Steven Price <steven.price@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: [RFC PATCH 06/28] arm64: RME: ioctls to create and configure realms
Date:   Fri, 27 Jan 2023 11:29:10 +0000
Message-Id: <20230127112932.38045-7-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127112932.38045-1-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the KVM_CAP_ARM_RME_CREATE_FD ioctl to create a realm. This involves
delegating pages to the RMM to hold the Realm Descriptor (RD) and for
the base level of the Realm Translation Tables (RTT). A VMID also need
to be picked, since the RMM has a separate VMID address space a
dedicated allocator is added for this purpose.

KVM_CAP_ARM_RME_CONFIG_REALM is provided to allow configuring the realm
before it is created.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_rme.h |  14 ++
 arch/arm64/kvm/arm.c             |  19 ++
 arch/arm64/kvm/mmu.c             |   6 +
 arch/arm64/kvm/reset.c           |  33 +++
 arch/arm64/kvm/rme.c             | 357 +++++++++++++++++++++++++++++++
 5 files changed, 429 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index c26bc2c6770d..055a22accc08 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -6,6 +6,8 @@
 #ifndef __ASM_KVM_RME_H
 #define __ASM_KVM_RME_H
 
+#include <uapi/linux/kvm.h>
+
 enum realm_state {
 	REALM_STATE_NONE,
 	REALM_STATE_NEW,
@@ -15,8 +17,20 @@ enum realm_state {
 
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
 
 int kvm_init_rme(void);
+u32 kvm_realm_ipa_limit(void);
+
+int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
+int kvm_init_realm_vm(struct kvm *kvm);
+void kvm_destroy_realm(struct kvm *kvm);
 
 #endif
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d97b39d042ab..50f54a63732a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -103,6 +103,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
 		break;
+	case KVM_CAP_ARM_RME:
+		if (!static_branch_unlikely(&kvm_rme_is_available))
+			return -EINVAL;
+		mutex_lock(&kvm->lock);
+		r = kvm_realm_enable_cap(kvm, cap);
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -172,6 +179,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	 */
 	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
 
+	/* Initialise the realm bits after the generic bits are enabled */
+	if (kvm_is_realm(kvm)) {
+		ret = kvm_init_realm_vm(kvm);
+		if (ret)
+			goto err_free_cpumask;
+	}
+
 	return 0;
 
 err_free_cpumask:
@@ -204,6 +218,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_destroy_vcpus(kvm);
 
 	kvm_unshare_hyp(kvm, kvm + 1);
+
+	kvm_destroy_realm(kvm);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
@@ -300,6 +316,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		r = system_has_full_ptr_auth();
 		break;
+	case KVM_CAP_ARM_RME:
+		r = static_key_enabled(&kvm_rme_is_available);
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 31d7fa4c7c14..d0f707767d05 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -840,6 +840,12 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	struct kvm_pgtable *pgt = NULL;
 
 	write_lock(&kvm->mmu_lock);
+	if (kvm_is_realm(kvm) &&
+	    kvm_realm_state(kvm) != REALM_STATE_DYING) {
+		/* TODO: teardown rtts */
+		write_unlock(&kvm->mmu_lock);
+		return;
+	}
 	pgt = mmu->pgt;
 	if (pgt) {
 		mmu->pgd_phys = 0;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index e0267f672b8a..c165df174737 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -395,3 +395,36 @@ int kvm_set_ipa_limit(void)
 
 	return 0;
 }
+
+int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
+{
+	u64 mmfr0, mmfr1;
+	u32 phys_shift;
+	u32 ipa_limit = kvm_ipa_limit;
+
+	if (kvm_is_realm(kvm))
+		ipa_limit = kvm_realm_ipa_limit();
+
+	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+		return -EINVAL;
+
+	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
+	if (phys_shift) {
+		if (phys_shift > ipa_limit ||
+		    phys_shift < ARM64_MIN_PARANGE_BITS)
+			return -EINVAL;
+	} else {
+		phys_shift = KVM_PHYS_SHIFT;
+		if (phys_shift > ipa_limit) {
+			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
+				     current->comm);
+			return -EINVAL;
+		}
+	}
+
+	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	kvm->arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index f6b587bc116e..9f8c5a91b8fc 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -5,9 +5,49 @@
 
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 #include <asm/rmi_cmds.h>
 #include <asm/virt.h>
 
+/************ FIXME: Copied from kvm/hyp/pgtable.c **********/
+#include <asm/kvm_pgtable.h>
+
+struct kvm_pgtable_walk_data {
+	struct kvm_pgtable		*pgt;
+	struct kvm_pgtable_walker	*walker;
+
+	u64				addr;
+	u64				end;
+};
+
+static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
+{
+	u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
+	u64 mask = BIT(pgt->ia_bits) - 1;
+
+	return (addr & mask) >> shift;
+}
+
+static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
+{
+	struct kvm_pgtable pgt = {
+		.ia_bits	= ia_bits,
+		.start_level	= start_level,
+	};
+
+	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
+}
+
+/******************/
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
@@ -33,8 +73,319 @@ static int rmi_check_version(void)
 	return 0;
 }
 
+static unsigned long create_realm_feat_reg0(struct kvm *kvm)
+{
+	unsigned long ia_bits = VTCR_EL2_IPA(kvm->arch.vtcr);
+	u64 feat_reg0 = 0;
+
+	int num_bps = u64_get_bits(rmm_feat_reg0,
+				   RMI_FEATURE_REGISTER_0_NUM_BPS);
+	int num_wps = u64_get_bits(rmm_feat_reg0,
+				   RMI_FEATURE_REGISTER_0_NUM_WPS);
+
+	feat_reg0 |= u64_encode_bits(ia_bits, RMI_FEATURE_REGISTER_0_S2SZ);
+	feat_reg0 |= u64_encode_bits(num_bps, RMI_FEATURE_REGISTER_0_NUM_BPS);
+	feat_reg0 |= u64_encode_bits(num_wps, RMI_FEATURE_REGISTER_0_NUM_WPS);
+
+	return feat_reg0;
+}
+
+u32 kvm_realm_ipa_limit(void)
+{
+	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
+}
+
+static u32 get_start_level(struct kvm *kvm)
+{
+	long sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, kvm->arch.vtcr);
+
+	return VTCR_EL2_TGRAN_SL0_BASE - sl0;
+}
+
+static int realm_create_rd(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+	struct realm_params *params = realm->params;
+	void *rd = NULL;
+	phys_addr_t rd_phys, params_phys;
+	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+	unsigned int pgd_sz;
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
+		goto out;
+	}
+
+	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level);
+	for (i = 0; i < pgd_sz; i++) {
+		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
+
+		if (rmi_granule_delegate(pgd_phys)) {
+			r = -ENXIO;
+			goto out_undelegate_tables;
+		}
+	}
+
+	params->rtt_level_start = get_start_level(kvm);
+	params->rtt_num_start = pgd_sz;
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
+	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.vtcr);
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
+out:
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
+	if (!kvm_is_realm(kvm) || kvm_realm_state(kvm) != REALM_STATE_NONE)
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
+	realm->params->measurement_algo = cfg->hash_algo;
+	return 0;
+}
+
+static int config_realm_sve(struct realm *realm,
+			    struct kvm_cap_arm_rme_config_item *cfg)
+{
+	u64 features_0 = realm->params->features_0;
+	int max_sve_vq = u64_get_bits(rmm_feat_reg0,
+				      RMI_FEATURE_REGISTER_0_SVE_VL);
+
+	if (!rme_supports(RMI_FEATURE_REGISTER_0_SVE_EN))
+		return -EINVAL;
+
+	if (cfg->sve_vq > max_sve_vq)
+		return -EINVAL;
+
+	features_0 &= ~(RMI_FEATURE_REGISTER_0_SVE_EN |
+			RMI_FEATURE_REGISTER_0_SVE_VL);
+	features_0 |= u64_encode_bits(1, RMI_FEATURE_REGISTER_0_SVE_EN);
+	features_0 |= u64_encode_bits(cfg->sve_vq,
+				      RMI_FEATURE_REGISTER_0_SVE_VL);
+
+	realm->params->features_0 = features_0;
+	return 0;
+}
+
+static int kvm_rme_config_realm(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	struct kvm_cap_arm_rme_config_item cfg;
+	struct realm *realm = &kvm->arch.realm;
+	int r = 0;
+
+	if (kvm_realm_state(kvm) != REALM_STATE_NONE)
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
+	case KVM_CAP_ARM_RME_CFG_SVE:
+		r = config_realm_sve(realm, &cfg);
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
+	switch (cap->args[0]) {
+	case KVM_CAP_ARM_RME_CONFIG_REALM:
+		r = kvm_rme_config_realm(kvm, cap);
+		break;
+	case KVM_CAP_ARM_RME_CREATE_RD:
+		if (kvm->created_vcpus) {
+			r = -EBUSY;
+			break;
+		}
+
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
+	unsigned int pgd_sz;
+	int i;
+
+	if (realm->params) {
+		free_page((unsigned long)realm->params);
+		realm->params = NULL;
+	}
+
+	if (kvm_realm_state(kvm) == REALM_STATE_NONE)
+		return;
+
+	WRITE_ONCE(realm->state, REALM_STATE_DYING);
+
+	rme_vmid_release(realm->vmid);
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
+	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level);
+	for (i = 0; i < pgd_sz; i++) {
+		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
+
+		if (WARN_ON(rmi_granule_undelegate(pgd_phys)))
+			return;
+	}
+
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
+	params->features_0 = create_realm_feat_reg0(kvm);
+	kvm->arch.realm.params = params;
+	return 0;
+}
+
 int kvm_init_rme(void)
 {
+	int ret;
+
 	if (PAGE_SIZE != SZ_4K)
 		/* Only 4k page size on the host is supported */
 		return 0;
@@ -43,6 +394,12 @@ int kvm_init_rme(void)
 		/* Continue without realm support */
 		return 0;
 
+	ret = rme_vmid_init();
+	if (ret)
+		return ret;
+
+	WARN_ON(rmi_features(0, &rmm_feat_reg0));
+
 	/* Future patch will enable static branch kvm_rme_is_available */
 
 	return 0;
-- 
2.34.1

