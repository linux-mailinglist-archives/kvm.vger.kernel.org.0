Return-Path: <kvm+bounces-33600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 033389EEEBD
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 17:01:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA28928E89A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 16:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6697322E9E0;
	Thu, 12 Dec 2024 15:57:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5C722D4C6;
	Thu, 12 Dec 2024 15:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019047; cv=none; b=p4P4AZ7vQwCF+hK7PGQUynV4MNbIIfdCufD7ny5IyQkn+eOTzihxCenvTSvpfz1Z2yG0x8Lp+sg2cfYzYX436BZ7tn+J8sbAounkabEwwruLn1o2pY6WWQ2PzI31hg2HwyB/PUGAKtG5rGbtg55tbghKAUZjLvCYFBaZ8cNL0uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019047; c=relaxed/simple;
	bh=DpOUMHWypvVB/LmKU+4Ns9gch3Siq8GOzTqd0hedSNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgPweLtbunY5j4MI4LZndROwQdoI6tYRhWbStlOWyBPP0o2wlBI2nEaDiZMexV3i5ee2/DP+lwvWvQ/83C5Jgve8HXTQS6k1SogbUNgOVP+AckEDCCVFBuMjVFBKrlw6r/OqRhvbSNJtPMOvaPhhvMWqJfYD7sb5DeaO4Rndv4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6E611762;
	Thu, 12 Dec 2024 07:57:53 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.39.50])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B3743F720;
	Thu, 12 Dec 2024 07:57:22 -0800 (PST)
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v6 12/43] arm64: RME: Allocate/free RECs to match vCPUs
Date: Thu, 12 Dec 2024 15:55:37 +0000
Message-ID: <20241212155610.76522-13-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241212155610.76522-1-steven.price@arm.com>
References: <20241212155610.76522-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM maintains a data structure known as the Realm Execution Context
(or REC). It is similar to struct kvm_vcpu and tracks the state of the
virtual CPUs. KVM must delegate memory and request the structures are
created when vCPUs are created, and suitably tear down on destruction.

RECs must also be supplied with addition pages - auxiliary (or AUX)
granules - for storing the larger registers state (e.g. for SVE). The
number of AUX granules for a REC depends on the parameters with which
the Realm was created - the RMM makes this information available via the
RMI_REC_AUX_COUNT call performed after creating the Realm Descriptor (RD).

Note that only some of register state for the REC can be set by KVM, the
rest is defined by the RMM (zeroed). The register state then cannot be
changed by KVM after the REC is created (except when the guest
explicitly requests this e.g. by performing a PSCI call). The RMM also
requires that the VMM creates RECs in ascending order of the MPIDR.

See Realm Management Monitor specification (DEN0137) for more information:
https://developer.arm.com/documentation/den0137/

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v5:
 * Separate the concept of vcpu_is_rec() and
   kvm_arm_vcpu_rec_finalized() by using the KVM_ARM_VCPU_REC feature as
   the indication that the VCPU is a REC.
Changes since v2:
 * Free rec->run earlier in kvm_destroy_realm() and adapt to previous patches.
---
 arch/arm64/include/asm/kvm_emulate.h |   7 ++
 arch/arm64/include/asm/kvm_host.h    |   3 +
 arch/arm64/include/asm/kvm_rme.h     |  18 ++++
 arch/arm64/kvm/arm.c                 |   9 ++
 arch/arm64/kvm/reset.c               |  11 ++
 arch/arm64/kvm/rme.c                 | 144 +++++++++++++++++++++++++++
 6 files changed, 192 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 27f54a7778aa..ec2b6d9c9c07 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -722,7 +722,14 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
 
 static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
 {
+	if (static_branch_unlikely(&kvm_rme_is_available))
+		return vcpu_has_feature(vcpu, KVM_ARM_VCPU_REC);
 	return false;
 }
 
+static inline bool kvm_arm_vcpu_rec_finalized(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.rec.mpidr != INVALID_HWID;
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8482638dce3b..220195c727ef 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -789,6 +789,9 @@ struct kvm_vcpu_arch {
 
 	/* Per-vcpu CCSIDR override or NULL */
 	u32 *ccsidr;
+
+	/* Realm meta data */
+	struct realm_rec rec;
 };
 
 /*
diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index 32bdedf1d866..62d4a63d3035 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -6,6 +6,7 @@
 #ifndef __ASM_KVM_RME_H
 #define __ASM_KVM_RME_H
 
+#include <asm/rmi_smc.h>
 #include <uapi/linux/kvm.h>
 
 /**
@@ -65,6 +66,21 @@ struct realm {
 	unsigned int ia_bits;
 };
 
+/**
+ * struct realm_rec - Additional per VCPU data for a Realm
+ *
+ * @mpidr: MPIDR (Multiprocessor Affinity Register) value to identify this VCPU
+ * @rec_page: Kernel VA of the RMM's private page for this REC
+ * @aux_pages: Additional pages private to the RMM for this REC
+ * @run: Kernel VA of the RmiRecRun structure shared with the RMM
+ */
+struct realm_rec {
+	unsigned long mpidr;
+	void *rec_page;
+	struct page *aux_pages[REC_PARAMS_AUX_GRANULES];
+	struct rec_run *run;
+};
+
 void kvm_init_rme(void);
 u32 kvm_realm_ipa_limit(void);
 
@@ -72,6 +88,8 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int kvm_init_realm_vm(struct kvm *kvm);
 void kvm_destroy_realm(struct kvm *kvm);
 void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
+int kvm_create_rec(struct kvm_vcpu *vcpu);
+void kvm_destroy_rec(struct kvm_vcpu *vcpu);
 
 #define RMM_RTT_BLOCK_LEVEL	2
 #define RMM_RTT_MAX_LEVEL	3
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 73016e1e0067..2d97147651be 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -525,6 +525,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
 
+	vcpu->arch.rec.mpidr = INVALID_HWID;
+
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
 	/* Set up the timer */
@@ -1467,6 +1469,9 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
 		clear_bit(KVM_ARM_VCPU_HAS_EL2, &features);
 
+	if (!static_branch_unlikely(&kvm_rme_is_available))
+		clear_bit(KVM_ARM_VCPU_REC, &features);
+
 	return features;
 }
 
@@ -1506,6 +1511,10 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
 		return -EINVAL;
 
+	/* RME is incompatible with AArch32 */
+	if (test_bit(KVM_ARM_VCPU_REC, &features))
+		return -EINVAL;
+
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 470524b31951..16a5d11fc75a 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -137,6 +137,11 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
 			return -EPERM;
 
 		return kvm_vcpu_finalize_sve(vcpu);
+	case KVM_ARM_VCPU_REC:
+		if (!kvm_is_realm(vcpu->kvm) || !vcpu_is_rec(vcpu))
+			return -EINVAL;
+
+		return kvm_create_rec(vcpu);
 	}
 
 	return -EINVAL;
@@ -147,6 +152,11 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 	if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
 		return false;
 
+	if (kvm_is_realm(vcpu->kvm) &&
+	    !(vcpu_is_rec(vcpu) && kvm_arm_vcpu_rec_finalized(vcpu) &&
+	      READ_ONCE(vcpu->kvm->arch.realm.state) == REALM_STATE_ACTIVE))
+		return false;
+
 	return true;
 }
 
@@ -159,6 +169,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
 	kfree(sve_state);
 	kfree(vcpu->arch.ccsidr);
+	kvm_destroy_rec(vcpu);
 }
 
 static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 5e719235dd77..ad984706f68c 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -426,6 +426,150 @@ void kvm_destroy_realm(struct kvm *kvm)
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
 
+static void free_rec_aux(struct page **aux_pages,
+			 unsigned int num_aux)
+{
+	unsigned int i;
+
+	for (i = 0; i < num_aux; i++)
+		free_delegated_granule(page_to_phys(aux_pages[i]));
+}
+
+static int alloc_rec_aux(struct page **aux_pages,
+			 u64 *aux_phys_pages,
+			 unsigned int num_aux)
+{
+	int ret;
+	unsigned int i;
+
+	for (i = 0; i < num_aux; i++) {
+		struct page *aux_page;
+		phys_addr_t aux_page_phys;
+
+		aux_page = alloc_page(GFP_KERNEL);
+		if (!aux_page) {
+			ret = -ENOMEM;
+			goto out_err;
+		}
+		aux_page_phys = page_to_phys(aux_page);
+		if (rmi_granule_delegate(aux_page_phys)) {
+			__free_page(aux_page);
+			ret = -ENXIO;
+			goto out_err;
+		}
+		aux_pages[i] = aux_page;
+		aux_phys_pages[i] = aux_page_phys;
+	}
+
+	return 0;
+out_err:
+	free_rec_aux(aux_pages, i);
+	return ret;
+}
+
+int kvm_create_rec(struct kvm_vcpu *vcpu)
+{
+	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
+	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
+	struct realm *realm = &vcpu->kvm->arch.realm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	unsigned long rec_page_phys;
+	struct rec_params *params;
+	int r, i;
+
+	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_NEW)
+		return -ENOENT;
+
+	/*
+	 * The RMM will report PSCI v1.0 to Realms and the KVM_ARM_VCPU_PSCI_0_2
+	 * flag covers v0.2 and onwards.
+	 */
+	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2))
+		return -EINVAL;
+
+	BUILD_BUG_ON(sizeof(*params) > PAGE_SIZE);
+	BUILD_BUG_ON(sizeof(*rec->run) > PAGE_SIZE);
+
+	params = (struct rec_params *)get_zeroed_page(GFP_KERNEL);
+	rec->rec_page = (void *)__get_free_page(GFP_KERNEL);
+	rec->run = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!params || !rec->rec_page || !rec->run) {
+		r = -ENOMEM;
+		goto out_free_pages;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(params->gprs); i++)
+		params->gprs[i] = vcpu_regs->regs[i];
+
+	params->pc = vcpu_regs->pc;
+
+	if (vcpu->vcpu_id == 0)
+		params->flags |= REC_PARAMS_FLAG_RUNNABLE;
+
+	rec_page_phys = virt_to_phys(rec->rec_page);
+
+	if (rmi_granule_delegate(rec_page_phys)) {
+		r = -ENXIO;
+		goto out_free_pages;
+	}
+
+	r = alloc_rec_aux(rec->aux_pages, params->aux, realm->num_aux);
+	if (r)
+		goto out_undelegate_rmm_rec;
+
+	params->num_rec_aux = realm->num_aux;
+	params->mpidr = mpidr;
+
+	if (rmi_rec_create(virt_to_phys(realm->rd),
+			   rec_page_phys,
+			   virt_to_phys(params))) {
+		r = -ENXIO;
+		goto out_free_rec_aux;
+	}
+
+	rec->mpidr = mpidr;
+
+	free_page((unsigned long)params);
+	return 0;
+
+out_free_rec_aux:
+	free_rec_aux(rec->aux_pages, realm->num_aux);
+out_undelegate_rmm_rec:
+	if (WARN_ON(rmi_granule_undelegate(rec_page_phys)))
+		rec->rec_page = NULL;
+out_free_pages:
+	free_page((unsigned long)rec->run);
+	free_page((unsigned long)rec->rec_page);
+	free_page((unsigned long)params);
+	return r;
+}
+
+void kvm_destroy_rec(struct kvm_vcpu *vcpu)
+{
+	struct realm *realm = &vcpu->kvm->arch.realm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	unsigned long rec_page_phys;
+
+	if (!vcpu_is_rec(vcpu))
+		return;
+
+	free_page((unsigned long)rec->run);
+
+	rec_page_phys = virt_to_phys(rec->rec_page);
+
+	/*
+	 * The REC and any AUX pages cannot be reclaimed until the REC is
+	 * destroyed. So if the REC destroy fails then the REC page and any AUX
+	 * pages will be leaked.
+	 */
+	if (WARN_ON(rmi_rec_destroy(rec_page_phys)))
+		return;
+
+	free_rec_aux(rec->aux_pages, realm->num_aux);
+
+	free_delegated_granule(rec_page_phys);
+}
+
 int kvm_init_realm_vm(struct kvm *kvm)
 {
 	struct realm_params *params;
-- 
2.43.0


