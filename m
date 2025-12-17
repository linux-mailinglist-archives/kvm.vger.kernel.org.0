Return-Path: <kvm+bounces-66123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 08271CC72AB
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B384312E93C
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A28346E7A;
	Wed, 17 Dec 2025 10:12:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53629347BB5;
	Wed, 17 Dec 2025 10:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966368; cv=none; b=Z8DcSeQ08aoSnmPuHL9SwoJlHPGR/zr7JSLRinUjOEOCG5F4FjTYGXD2QPmbhnRFXxGW6iF3VleEBxpVcIbexhHPSKi1o73LeJZuf5Z3t6L+YAQR05A+A7fCqsEZdIT4nkXzlmEmywbChGrLZd8vtkYYIHWQjHXF6R90B2n/JmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966368; c=relaxed/simple;
	bh=qNzSKwJjNAJJrvxbKy+qBPMe0J6bOpP2diEBstcAGug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ManIwXikWOOJB9bE7fORbLEibXzySqThgN+P4LyQJyNqkzoqoq62onXtw2NuLgLnbzcFPErZGJj586LKx2x3+EbEF014+pWCJU3+BHvao4rJX3QMIJdZjPbzj6CeM1bQ9sYYGf641w0JVPcSWdXtwhFMpbwoyVuoHeOwG+qCiPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BDD21684;
	Wed, 17 Dec 2025 02:12:37 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 47F6C3F73B;
	Wed, 17 Dec 2025 02:12:40 -0800 (PST)
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
Subject: [PATCH v12 12/46] arm64: RMI: Allocate/free RECs to match vCPUs
Date: Wed, 17 Dec 2025 10:10:49 +0000
Message-ID: <20251217101125.91098-13-steven.price@arm.com>
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
explicitly requests this e.g. by performing a PSCI call).

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v11:
 * Remove the KVM_ARM_VCPU_REC feature. User space no longer needs to
   configure each VCPU separately, RECs are created on the first VCPU
   run of the guest.
Changes since v9:
 * Size the aux_pages array according to the PAGE_SIZE of the host.
Changes since v7:
 * Add comment explaining the aux_pages array.
 * Rename "undeleted_failed" variable to "should_free" to avoid a
   confusing double negative.
Changes since v6:
 * Avoid reporting the KVM_ARM_VCPU_REC feature if the guest isn't a
   realm guest.
 * Support host page size being larger than RMM's granule size when
   allocating/freeing aux granules.
Changes since v5:
 * Separate the concept of vcpu_is_rec() and
   kvm_arm_vcpu_rec_finalized() by using the KVM_ARM_VCPU_REC feature as
   the indication that the VCPU is a REC.
Changes since v2:
 * Free rec->run earlier in kvm_destroy_realm() and adapt to previous patches.
---
 arch/arm64/include/asm/kvm_emulate.h |   2 +-
 arch/arm64/include/asm/kvm_host.h    |   3 +
 arch/arm64/include/asm/kvm_rmi.h     |  21 +++
 arch/arm64/kvm/arm.c                 |  10 +-
 arch/arm64/kvm/reset.c               |   1 +
 arch/arm64/kvm/rmi.c                 | 185 +++++++++++++++++++++++++++
 6 files changed, 219 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index e7e9364ae118..f884bac43c06 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -716,7 +716,7 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
 
 static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
 {
-	return false;
+	return kvm_is_realm(vcpu->kvm);
 }
 
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index da913fee70b6..5a24227088c1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -900,6 +900,9 @@ struct kvm_vcpu_arch {
 
 	/* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
 	struct vncr_tlb	*vncr_tlb;
+
+	/* Realm meta data */
+	struct realm_rec rec;
 };
 
 /*
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index e4534af06d96..dbb4b97d5d42 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -65,6 +65,26 @@ struct realm {
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
+	/*
+	 * REC_PARAMS_AUX_GRANULES is the maximum number of 4K granules that
+	 * the RMM can require. The array is sized to be large enough for the
+	 * maximum number of host sized pages that could be required.
+	 */
+	struct page *aux_pages[(REC_PARAMS_AUX_GRANULES * SZ_4K) >> PAGE_SHIFT];
+	struct rec_run *run;
+};
+
 void kvm_init_rmi(void);
 u32 kvm_realm_ipa_limit(void);
 
@@ -72,6 +92,7 @@ int kvm_init_realm_vm(struct kvm *kvm);
 int kvm_activate_realm(struct kvm *kvm);
 void kvm_destroy_realm(struct kvm *kvm);
 void kvm_realm_destroy_rtts(struct kvm *kvm);
+void kvm_destroy_rec(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 542df37b9e82..512d0ec9de60 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -529,6 +529,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
 
+	vcpu->arch.rec.mpidr = INVALID_HWID;
+
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
 	/* Set up the timer */
@@ -1502,7 +1504,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 	return -EINVAL;
 }
 
-static unsigned long system_supported_vcpu_features(void)
+static unsigned long system_supported_vcpu_features(struct kvm *kvm)
 {
 	unsigned long features = KVM_VCPU_VALID_FEATURES;
 
@@ -1540,7 +1542,7 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 			return -ENOENT;
 	}
 
-	if (features & ~system_supported_vcpu_features())
+	if (features & ~system_supported_vcpu_features(vcpu->kvm))
 		return -EINVAL;
 
 	/*
@@ -1562,6 +1564,10 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
 		return -EINVAL;
 
+	/* Realms are incompatible with AArch32 */
+	if (vcpu_is_rec(vcpu))
+		return -EINVAL;
+
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 959532422d3a..4bbf58892928 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -161,6 +161,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
 	kfree(vcpu->arch.vncr_tlb);
 	kfree(vcpu->arch.ccsidr);
+	kvm_destroy_rec(vcpu);
 }
 
 static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 98929382c365..27ecd7d9f757 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -229,9 +229,188 @@ static int realm_ensure_created(struct kvm *kvm)
 	return -ENXIO;
 }
 
+static void free_rec_aux(struct page **aux_pages,
+			 unsigned int num_aux)
+{
+	unsigned int i, j;
+	unsigned int page_count = 0;
+
+	for (i = 0; i < num_aux;) {
+		struct page *aux_page = aux_pages[page_count++];
+		phys_addr_t aux_page_phys = page_to_phys(aux_page);
+		bool should_free = true;
+
+		for (j = 0; j < PAGE_SIZE && i < num_aux; j += RMM_PAGE_SIZE) {
+			if (WARN_ON(rmi_granule_undelegate(aux_page_phys)))
+				should_free = false;
+			aux_page_phys += RMM_PAGE_SIZE;
+			i++;
+		}
+		/* Only free if all the undelegate calls were successful */
+		if (should_free)
+			__free_page(aux_page);
+	}
+}
+
+static int alloc_rec_aux(struct page **aux_pages,
+			 u64 *aux_phys_pages,
+			 unsigned int num_aux)
+{
+	struct page *aux_page;
+	int page_count = 0;
+	unsigned int i, j;
+	int ret;
+
+	for (i = 0; i < num_aux;) {
+		phys_addr_t aux_page_phys;
+
+		aux_page = alloc_page(GFP_KERNEL);
+		if (!aux_page) {
+			ret = -ENOMEM;
+			goto out_err;
+		}
+
+		aux_page_phys = page_to_phys(aux_page);
+		for (j = 0; j < PAGE_SIZE && i < num_aux; j += RMM_PAGE_SIZE) {
+			if (rmi_granule_delegate(aux_page_phys)) {
+				ret = -ENXIO;
+				goto err_undelegate;
+			}
+			aux_phys_pages[i++] = aux_page_phys;
+			aux_page_phys += RMM_PAGE_SIZE;
+		}
+		aux_pages[page_count++] = aux_page;
+	}
+
+	return 0;
+err_undelegate:
+	while (j > 0) {
+		j -= RMM_PAGE_SIZE;
+		i--;
+		if (WARN_ON(rmi_granule_undelegate(aux_phys_pages[i]))) {
+			/* Leak the page if the undelegate fails */
+			goto out_err;
+		}
+	}
+	__free_page(aux_page);
+out_err:
+	free_rec_aux(aux_pages, i);
+	return ret;
+}
+
+static int kvm_create_rec(struct kvm_vcpu *vcpu)
+{
+	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
+	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
+	struct realm *realm = &vcpu->kvm->arch.realm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	unsigned long rec_page_phys;
+	struct rec_params *params;
+	int r, i;
+
+	if (rec->run)
+		return -EBUSY;
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
+	if (!rec->run) {
+		/* Nothing to do if the VCPU hasn't been finalized */
+		return;
+	}
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
 int kvm_activate_realm(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
 	int ret;
 
 	if (!kvm_is_realm(kvm))
@@ -257,6 +436,12 @@ int kvm_activate_realm(struct kvm *kvm)
 		return -EOPNOTSUPP;
 	}
 
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret = kvm_create_rec(vcpu);
+		if (ret)
+			return ret;
+	}
+
 	ret = rmi_realm_activate(virt_to_phys(realm->rd));
 	if (ret)
 		return -ENXIO;
-- 
2.43.0


