Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B276D822F
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238936AbjDEPlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238932AbjDEPlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:41:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB794C20
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 799A363EDA
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E16DC433D2;
        Wed,  5 Apr 2023 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680709257;
        bh=tnYNvzJonISHgSOHNoBUrnmPX/XDh86aiSUNtkqFOSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGM7ghyxECovs1w81Bop6wCEbZ72AZERPFXDAYhEhSnQEE5lpMSJrw5gHVE+0yfiC
         98yDegeRDPVmhDuDsEC5Hqip0P4TMU/44db4ub+OI82XGXiKmgsQz2uwLF7QPk4hCg
         9aRXKj/VPJtc5QPxzMc4b+c9ZHyfQUoR+FErNSklv9jWVk2wKXcvOaXihPtPIJnx3J
         NAER+0e6PjugXZESgAlBwBiClKfMZVKNDnlcLOOu8fAmt9qQ6Oh98tqIcgZAsqIWLS
         pPUgzhJ3CEvZR83UDZvhYKDJpgkUcbZgvsuanEORsXbPiZvREuPa0ZdMuoemBsWG0m
         PayZe1FzcxWjg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pk5FP-0062PV-3T;
        Wed, 05 Apr 2023 16:40:31 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
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
Subject: [PATCH v9 15/50] KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
Date:   Wed,  5 Apr 2023 16:39:33 +0100
Message-Id: <20230405154008.3552854-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230405154008.3552854-1-maz@kernel.org>
References: <20230405154008.3552854-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 arch/arm64/include/asm/kvm_host.h   |  40 ++++++
 arch/arm64/include/asm/kvm_mmu.h    |   9 ++
 arch/arm64/include/asm/kvm_nested.h |   7 +
 arch/arm64/kvm/arm.c                |  18 ++-
 arch/arm64/kvm/mmu.c                |  77 +++++++---
 arch/arm64/kvm/nested.c             | 210 ++++++++++++++++++++++++++++
 6 files changed, 337 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 633a7c0750bb..fefd5156049e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -159,8 +159,40 @@ struct kvm_s2_mmu {
 	int __percpu *last_vcpu_ran;
 
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
+	u64	vttbr;
+	u64	vtcr;
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
+	return !(mmu->vttbr & 1);
+}
+
 struct kvm_arch_memory_slot {
 };
 
@@ -187,6 +219,14 @@ struct kvm_protected_vm {
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
 	/* VTCR_EL2 value for this VM */
 	u64    vtcr;
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 27e63c111f78..cbb198ebd2a0 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -119,6 +119,7 @@ alternative_cb_end
 #include <asm/mmu_context.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
+#include <asm/kvm_nested.h>
 
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
@@ -170,6 +171,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 			     void **haddr);
 void __init free_hyp_pgds(void);
 
+void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
@@ -311,5 +313,12 @@ static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
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
index f2820c82e956..f9c57b37de0a 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -59,6 +59,13 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 	return ttbr0 & ~GENMASK_ULL(63, 48);
 }
 
+extern void kvm_init_nested(struct kvm *kvm);
+extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
+extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
+extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
+extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
+extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
+
 extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 			    u64 control_bit);
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4c5e9dfbf83a..2fc529519ae7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -36,9 +36,10 @@
 #include <asm/virt.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/kvm_pkvm.h>
-#include <asm/kvm_emulate.h>
 #include <asm/sections.h>
 
 #include <kvm/arm_hypercalls.h>
@@ -128,6 +129,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
 
+	kvm_init_nested(kvm);
+
 	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		return ret;
@@ -390,6 +393,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_s2_mmu *mmu;
 	int *last_ran;
 
+	if (vcpu_has_nv(vcpu))
+		kvm_vcpu_load_hw_mmu(vcpu);
+
 	mmu = vcpu->arch.hw_mmu;
 	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
@@ -440,9 +446,12 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
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
 
@@ -1172,8 +1181,13 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.target = phys_target;
 
+	/* Prepare for nested if required */
+	ret = kvm_vcpu_init_nested(vcpu);
+
 	/* Now we know what it is, we can reset it. */
-	ret = kvm_reset_vcpu(vcpu);
+	if (!ret)
+		ret = kvm_reset_vcpu(vcpu);
+
 	if (ret) {
 		vcpu->arch.target = -1;
 		bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3b9d4d24c361..b2612763abc1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -217,7 +217,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
  * does.
  */
 /**
- * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
+ * __unmap_stage2_range -- Clear stage2 page table entries to unmap a range
  * @mmu:   The KVM stage-2 MMU pointer
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
@@ -240,7 +240,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 				   may_block));
 }
 
-static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
+void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
 {
 	__unmap_stage2_range(mmu, start, size, true);
 }
@@ -711,21 +711,9 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
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
+static int kvm_init_ipa_range(struct kvm *kvm, unsigned long type)
 {
 	u32 kvm_ipa_limit = get_kvm_ipa_limit();
-	int cpu, err;
-	struct kvm_pgtable *pgt;
 	u64 mmfr0, mmfr1;
 	u32 phys_shift;
 
@@ -752,7 +740,53 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm->arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
 
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
+	 * We only initialise the IPA range on the canonical MMU, so
+	 * the type is meaningless in all other situations.
+	 */
+	if (&kvm->arch.mmu == mmu) {
+		err = kvm_init_ipa_range(kvm, type);
+		if (err)
+			return err;
+	}
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
@@ -777,6 +811,10 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
+
+	if (&kvm->arch.mmu != mmu)
+		kvm_init_nested_s2_mmu(mmu);
+
 	return 0;
 
 out_destroy_pgtable:
@@ -822,7 +860,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 
 		if (!(vma->vm_flags & VM_PFNMAP)) {
 			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
-			unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
+			kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -1875,11 +1913,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 {
 }
 
-void kvm_arch_flush_shadow_all(struct kvm *kvm)
-{
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
-}
-
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
@@ -1887,7 +1920,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	write_lock(&kvm->mmu_lock);
-	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 315354d27978..8b21925bf086 100644
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
 
@@ -16,6 +18,214 @@
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
+	if (!test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features))
+		return 0;
+
+	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
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
+	mutex_unlock(&kvm->lock);
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
+		    vttbr == mmu->vttbr &&
+		    vtcr == mmu->vtcr)
+			return mmu;
+
+		if (!nested_stage2_enabled &&
+		    !mmu->nested_stage2_enabled &&
+		    get_vmid(vttbr) == get_vmid(mmu->vttbr))
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
+		kvm_unmap_stage2_range(s2_mmu, 0, kvm_phys_size(kvm));
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
+	s2_mmu->vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2) & ~VTTBR_CNP_BIT;
+	s2_mmu->vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
+	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_VM;
+
+out:
+	atomic_inc(&s2_mmu->refcnt);
+	return s2_mmu;
+}
+
+void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
+{
+	mmu->vttbr = 1;
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
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
+}
+
 /*
  * Our emulated CPU doesn't support all the possible features. For the
  * sake of simplicity (and probably mental sanity), wipe out a number
-- 
2.34.1

