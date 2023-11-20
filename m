Return-Path: <kvm+bounces-2088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 769B87F1405
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:12:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A4191C21647
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 683491DDC0;
	Mon, 20 Nov 2023 13:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GgPeZVQ1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F270E1CFA4;
	Mon, 20 Nov 2023 13:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38660C433CB;
	Mon, 20 Nov 2023 13:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485855;
	bh=+qy5IGbjKwHQ0MASCEvZNzNzb90T6xMUuPrwsOo6mFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgPeZVQ1Nn1qcCqD817Jng2xzJMgx+DBVlrYz/eXtT7EGZx08Gh28ORdei8M5x9Q4
	 f5ukUZGBvjqecb7JdvbXSk/S3VABslZPJY7M0+LAfO9Y2I3EKGbFy4vvJ/iNv9cncI
	 P07mFYctUybm0+5Zo0dvH3SGFZXEP3vHz+tIERW6eSWiV+jf3Dui7BbcvYzhWOuAul
	 Jw4pEixXVb5mJmwKUs6ailR7ZT3235jZheiRbGt/0Z6quVAmmppgpxVkLnKB2x9bQ8
	 rWFATKpJGiLgrWKStH97zZxAS2LNok3oq4y+PcCUZJqaYC2l4IfvwEWoUCrnBBbTUf
	 0gBwwtnYipQSA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543B-00EjnU-BV;
	Mon, 20 Nov 2023 13:10:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 17/43] KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
Date: Mon, 20 Nov 2023 13:10:01 +0000
Message-Id: <20231120131027.854038-18-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add Stage-2 mmu data structures for virtual EL2 and for nested guests.
We don't yet populate shadow Stage-2 page tables, but we now have a
framework for getting to a shadow Stage-2 pgd.

We allocate twice the number of vcpus as Stage-2 mmu structures because
that's sufficient for each vcpu running two translation regimes without
having to flush the Stage-2 page tables.

Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h   |  41 ++++++
 arch/arm64/include/asm/kvm_mmu.h    |   9 ++
 arch/arm64/include/asm/kvm_nested.h |   7 +
 arch/arm64/kvm/arm.c                |  12 ++
 arch/arm64/kvm/mmu.c                |  78 ++++++++---
 arch/arm64/kvm/nested.c             | 207 ++++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c              |   6 +
 7 files changed, 338 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f17fb7c42973..eb96fe9b686e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -188,8 +188,40 @@ struct kvm_s2_mmu {
 	uint64_t split_page_chunk_size;
 
 	struct kvm_arch *arch;
+
+	/*
+	 * For a shadow stage-2 MMU, the virtual vttbr used by the
+	 * host to parse the guest S2.
+	 * This either contains:
+	 * - the virtual VTTBR programmed by the guest hypervisor with
+         *   CnP cleared
+	 * - The value 1 (VMID=0, BADDR=0, CnP=1) if invalid
+	 *
+	 * We also cache the full VTCR which gets used for TLB invalidation,
+	 * taking the ARM ARM's "Any of the bits in VTCR_EL2 are permitted
+	 * to be cached in a TLB" to the letter.
+	 */
+	u64	tlb_vttbr;
+	u64	tlb_vtcr;
+
+	/*
+	 * true when this represents a nested context where virtual
+	 * HCR_EL2.VM == 1
+	 */
+	bool	nested_stage2_enabled;
+
+	/*
+	 *  0: Nobody is currently using this, check vttbr for validity
+	 * >0: Somebody is actively using this.
+	 */
+	atomic_t refcnt;
 };
 
+static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
+{
+	return !(mmu->tlb_vttbr & 1);
+}
+
 struct kvm_arch_memory_slot {
 };
 
@@ -241,6 +273,14 @@ static inline u16 kvm_mpidr_index(struct kvm_mpidr_data *data, u64 mpidr)
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
+	/*
+	 * Stage 2 paging state for VMs with nested S2 using a virtual
+	 * VMID.
+	 */
+	struct kvm_s2_mmu *nested_mmus;
+	size_t nested_mmus_size;
+	int nested_mmus_next;
+
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 
@@ -1186,6 +1226,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
 void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu);
 
 int __init kvm_set_ipa_limit(void);
+u32 kvm_get_pa_bits(struct kvm *kvm);
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 49e0d4b36bd0..5c6fb2fb8287 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -119,6 +119,7 @@ alternative_cb_end
 #include <asm/mmu_context.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
+#include <asm/kvm_nested.h>
 
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
@@ -171,6 +172,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr);
 void __init free_hyp_pgds(void);
 
+void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
 void kvm_uninit_stage2_mmu(struct kvm *kvm);
@@ -339,5 +341,12 @@ static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
 {
 	return container_of(mmu->arch, struct kvm, arch);
 }
+
+static inline u64 get_vmid(u64 vttbr)
+{
+	return (vttbr & VTTBR_VMID_MASK(kvm_get_vmid_bits())) >>
+		VTTBR_VMID_SHIFT;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index aa085f2f1947..f421ad294e68 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -60,6 +60,13 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 	return ttbr0 & ~GENMASK_ULL(63, 48);
 }
 
+extern void kvm_init_nested(struct kvm *kvm);
+extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
+extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
+extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
+extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
+extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
+
 extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
 extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b65df612b41b..2e76892c1a56 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -147,6 +147,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	mutex_unlock(&kvm->lock);
 #endif
 
+	kvm_init_nested(kvm);
+
 	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		return ret;
@@ -429,6 +431,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_s2_mmu *mmu;
 	int *last_ran;
 
+	if (vcpu_has_nv(vcpu))
+		kvm_vcpu_load_hw_mmu(vcpu);
+
 	mmu = vcpu->arch.hw_mmu;
 	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
@@ -479,9 +484,12 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
+	if (vcpu_has_nv(vcpu))
+		kvm_vcpu_put_hw_mmu(vcpu);
 	kvm_arm_vmid_clear_active();
 
 	vcpu_clear_on_unsupported_cpu(vcpu);
+
 	vcpu->cpu = -1;
 }
 
@@ -1336,6 +1344,10 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu)
 		ret = kvm_arm_set_default_pmu(kvm);
 
+	/* Prepare for nested if required */
+	if (!ret)
+		ret = kvm_vcpu_init_nested(vcpu);
+
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d87c8fcc4c24..588ce46c0ad0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -305,7 +305,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
  * does.
  */
 /**
- * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
+ * __unmap_stage2_range -- Clear stage2 page table entries to unmap a range
  * @mmu:   The KVM stage-2 MMU pointer
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
@@ -328,7 +328,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 				   may_block));
 }
 
-static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
+void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
 {
 	__unmap_stage2_range(mmu, start, size, true);
 }
@@ -853,21 +853,9 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.icache_inval_pou	= invalidate_icache_guest_page,
 };
 
-/**
- * kvm_init_stage2_mmu - Initialise a S2 MMU structure
- * @kvm:	The pointer to the KVM structure
- * @mmu:	The pointer to the s2 MMU structure
- * @type:	The machine type of the virtual machine
- *
- * Allocates only the stage-2 HW PGD level table(s).
- * Note we don't need locking here as this is only called when the VM is
- * created, which can only be done once.
- */
-int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type)
+static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 {
 	u32 kvm_ipa_limit = get_kvm_ipa_limit();
-	int cpu, err;
-	struct kvm_pgtable *pgt;
 	u64 mmfr0, mmfr1;
 	u32 phys_shift;
 
@@ -894,11 +882,58 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	mmu->vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
 
+	return 0;
+}
+
+/**
+ * kvm_init_stage2_mmu - Initialise a S2 MMU structure
+ * @kvm:	The pointer to the KVM structure
+ * @mmu:	The pointer to the s2 MMU structure
+ * @type:	The machine type of the virtual machine
+ *
+ * Allocates only the stage-2 HW PGD level table(s).
+ * Note we don't need locking here as this is only called in two cases:
+ *
+ * - when the VM is created, which can't race against anything
+ *
+ * - when secondary kvm_s2_mmu structures are initialised for NV
+ *   guests, and the caller must hold kvm->lock as this is called on a
+ *   per-vcpu basis.
+ */
+int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type)
+{
+	int cpu, err;
+	struct kvm_pgtable *pgt;
+
+	/*
+	 * If we already have our page tables in place, and that the
+	 * MMU context is the canonical one, we have a bug somewhere,
+	 * as this is only supposed to ever happen once per VM.
+	 *
+	 * Otherwise, we're building nested page tables, and that's
+	 * probably because userspace called KVM_ARM_VCPU_INIT more
+	 * than once on the same vcpu. Since that's actually legal,
+	 * don't kick a fuss and leave gracefully.
+	 */
 	if (mmu->pgt != NULL) {
+		if (&kvm->arch.mmu != mmu)
+			return 0;
+
 		kvm_err("kvm_arch already initialized?\n");
 		return -EINVAL;
 	}
 
+	/*
+	 * We only initialise the IPA range on the canonical MMU, so
+	 * the type is meaningless in all other situations.
+	 */
+	if (&kvm->arch.mmu != mmu)
+		type = kvm_get_pa_bits(kvm);
+
+	err = kvm_init_ipa_range(mmu, type);
+	if (err)
+		return err;
+
 	pgt = kzalloc(sizeof(*pgt), GFP_KERNEL_ACCOUNT);
 	if (!pgt)
 		return -ENOMEM;
@@ -923,6 +958,10 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
+
+	if (&kvm->arch.mmu != mmu)
+		kvm_init_nested_s2_mmu(mmu);
+
 	return 0;
 
 out_destroy_pgtable:
@@ -974,7 +1013,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 
 		if (!(vma->vm_flags & VM_PFNMAP)) {
 			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
-			unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
+			kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -2054,11 +2093,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 {
 }
 
-void kvm_arch_flush_shadow_all(struct kvm *kvm)
-{
-	kvm_uninit_stage2_mmu(kvm);
-}
-
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
@@ -2066,7 +2100,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	write_lock(&kvm->mmu_lock);
-	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 66d05f5d39a2..c5752ab8c3fe 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -7,7 +7,9 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_arm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
 #include <asm/sysreg.h>
 
@@ -16,6 +18,211 @@
 /* Protection against the sysreg repainting madness... */
 #define NV_FTR(r, f)		ID_AA64##r##_EL1_##f
 
+void kvm_init_nested(struct kvm *kvm)
+{
+	kvm->arch.nested_mmus = NULL;
+	kvm->arch.nested_mmus_size = 0;
+}
+
+int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_s2_mmu *tmp;
+	int num_mmus;
+	int ret = -ENOMEM;
+
+	if (!test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->kvm->arch.vcpu_features))
+		return 0;
+
+	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
+		return -EINVAL;
+
+	/*
+	 * Let's treat memory allocation failures as benign: If we fail to
+	 * allocate anything, return an error and keep the allocated array
+	 * alive. Userspace may try to recover by intializing the vcpu
+	 * again, and there is no reason to affect the whole VM for this.
+	 */
+	num_mmus = atomic_read(&kvm->online_vcpus) * 2;
+	tmp = krealloc(kvm->arch.nested_mmus,
+		       num_mmus * sizeof(*kvm->arch.nested_mmus),
+		       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (tmp) {
+		/*
+		 * If we went through a realocation, adjust the MMU
+		 * back-pointers in the previously initialised
+		 * pg_table structures.
+		 */
+		if (kvm->arch.nested_mmus != tmp) {
+			int i;
+
+			for (i = 0; i < num_mmus - 2; i++)
+				tmp[i].pgt->mmu = &tmp[i];
+		}
+
+		if (kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 1], 0) ||
+		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2], 0)) {
+			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
+			kvm_free_stage2_pgd(&tmp[num_mmus - 2]);
+		} else {
+			kvm->arch.nested_mmus_size = num_mmus;
+			ret = 0;
+		}
+
+		kvm->arch.nested_mmus = tmp;
+	}
+
+	return ret;
+}
+
+/* Must be called with kvm->mmu_lock held */
+struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu)
+{
+	bool nested_stage2_enabled;
+	u64 vttbr, vtcr, hcr;
+	struct kvm *kvm;
+	int i;
+
+	kvm = vcpu->kvm;
+
+	vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+	vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
+	hcr = vcpu_read_sys_reg(vcpu, HCR_EL2);
+
+	nested_stage2_enabled = hcr & HCR_VM;
+
+	/* Don't consider the CnP bit for the vttbr match */
+	vttbr = vttbr & ~VTTBR_CNP_BIT;
+
+	/*
+	 * Two possibilities when looking up a S2 MMU context:
+	 *
+	 * - either S2 is enabled in the guest, and we need a context that is
+         *   S2-enabled and matches the full VTTBR (VMID+BADDR) and VTCR,
+         *   which makes it safe from a TLB conflict perspective (a broken
+         *   guest won't be able to generate them),
+	 *
+	 * - or S2 is disabled, and we need a context that is S2-disabled
+         *   and matches the VMID only, as all TLBs are tagged by VMID even
+         *   if S2 translation is disabled.
+	 */
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (!kvm_s2_mmu_valid(mmu))
+			continue;
+
+		if (nested_stage2_enabled &&
+		    mmu->nested_stage2_enabled &&
+		    vttbr == mmu->tlb_vttbr &&
+		    vtcr == mmu->tlb_vtcr)
+			return mmu;
+
+		if (!nested_stage2_enabled &&
+		    !mmu->nested_stage2_enabled &&
+		    get_vmid(vttbr) == get_vmid(mmu->tlb_vttbr))
+			return mmu;
+	}
+	return NULL;
+}
+
+/* Must be called with kvm->mmu_lock held */
+static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_s2_mmu *s2_mmu;
+	int i;
+
+	s2_mmu = lookup_s2_mmu(vcpu);
+	if (s2_mmu)
+		goto out;
+
+	/*
+	 * Make sure we don't always search from the same point, or we
+	 * will always reuse a potentially active context, leaving
+	 * free contexts unused.
+	 */
+	for (i = kvm->arch.nested_mmus_next;
+	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
+	     i++) {
+		s2_mmu = &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
+
+		if (atomic_read(&s2_mmu->refcnt) == 0)
+			break;
+	}
+	BUG_ON(atomic_read(&s2_mmu->refcnt)); /* We have struct MMUs to spare */
+
+	/* Set the scene for the next search */
+	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
+
+	if (kvm_s2_mmu_valid(s2_mmu)) {
+		/* Clear the old state */
+		kvm_unmap_stage2_range(s2_mmu, 0, kvm_phys_size(s2_mmu));
+		if (atomic64_read(&s2_mmu->vmid.id))
+			kvm_call_hyp(__kvm_tlb_flush_vmid, s2_mmu);
+	}
+
+	/*
+	 * The virtual VMID (modulo CnP) will be used as a key when matching
+	 * an existing kvm_s2_mmu.
+	 *
+	 * We cache VTCR at allocation time, once and for all. It'd be great
+	 * if the guest didn't screw that one up, as this is not very
+	 * forgiving...
+	 */
+	s2_mmu->tlb_vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2) & ~VTTBR_CNP_BIT;
+	s2_mmu->tlb_vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
+	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_VM;
+
+out:
+	atomic_inc(&s2_mmu->refcnt);
+	return s2_mmu;
+}
+
+void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
+{
+	mmu->tlb_vttbr = 1;
+	mmu->nested_stage2_enabled = false;
+	atomic_set(&mmu->refcnt, 0);
+}
+
+void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
+{
+	if (is_hyp_ctxt(vcpu)) {
+		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+	} else {
+		write_lock(&vcpu->kvm->mmu_lock);
+		vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
+		write_unlock(&vcpu->kvm->mmu_lock);
+	}
+}
+
+void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu) {
+		atomic_dec(&vcpu->arch.hw_mmu->refcnt);
+		vcpu->arch.hw_mmu = NULL;
+	}
+}
+
+void kvm_arch_flush_shadow_all(struct kvm *kvm)
+{
+	int i;
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		WARN_ON(atomic_read(&mmu->refcnt));
+
+		if (!atomic_read(&mmu->refcnt))
+			kvm_free_stage2_pgd(mmu);
+	}
+	kfree(kvm->arch.nested_mmus);
+	kvm->arch.nested_mmus = NULL;
+	kvm->arch.nested_mmus_size = 0;
+	kvm_uninit_stage2_mmu(kvm);
+}
+
 /*
  * Our emulated CPU doesn't support all the possible features. For the
  * sake of simplicity (and probably mental sanity), wipe out a number
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 5bb4de162cab..e106ea01598f 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -266,6 +266,12 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
+u32 kvm_get_pa_bits(struct kvm *kvm)
+{
+	/* Fixed limit until we can configure ID_AA64MMFR0.PARange */
+	return kvm_ipa_limit;
+}
+
 u32 get_kvm_ipa_limit(void)
 {
 	return kvm_ipa_limit;
-- 
2.39.2


