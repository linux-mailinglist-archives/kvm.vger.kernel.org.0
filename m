Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DB3667F32
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbjALT3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbjALT2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:28:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F349D3E0C9
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:22:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81D986216E
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4130C433EF;
        Thu, 12 Jan 2023 19:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551340;
        bh=yFb7Sms7hOdtWlzrhGCrWfVeKKIiqUolcZEpReh2218=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfpoqpVvx1Upze1xj26lD2DMPbrjMLraBZeivKHF2GIlu5qH60zFWIJzMcoqvRUCw
         PABqblU1I4reWkE3lYEb2ffcHgyFasfU3Lt3AOgOKAIe61MQnviCRRh8fMmwtDxJ4D
         0FRtMP7owK6XO4/DjwtFmClgyq3mNtHlFFLNn7HgSjUg/mj9574lvpJ/0vLZmhkibK
         obQg4pNzkIi9RiwH4dfSiyjhRgRygCRHKhwIPhcBj+JX9hzuZR1bV2yBdl6QzkkkFQ
         oKKXS1GJ/zI0XepR3aoZaTTzXtNR4F8/Hf5a2OKvokpXg9leMarijxUBxDsE6fMqkU
         7Bx31hjzqaWlA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG379-001IWu-GY;
        Thu, 12 Jan 2023 19:19:52 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v7 34/68] KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
Date:   Thu, 12 Jan 2023 19:18:53 +0000
Message-Id: <20230112191927.1814989-35-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 arch/arm64/include/asm/kvm_host.h   |  35 +++++
 arch/arm64/include/asm/kvm_mmu.h    |   9 ++
 arch/arm64/include/asm/kvm_nested.h |   7 +
 arch/arm64/kvm/arm.c                |  18 ++-
 arch/arm64/kvm/mmu.c                |  77 +++++++----
 arch/arm64/kvm/nested.c             | 196 ++++++++++++++++++++++++++++
 6 files changed, 318 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 70eab7a6386b..4d4315149f04 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -159,8 +159,35 @@ struct kvm_s2_mmu {
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
+	 */
+	u64	vttbr;
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
 
@@ -187,6 +214,14 @@ struct kvm_protected_vm {
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
index 2890d57bec30..1eb626703a4f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -117,6 +117,7 @@ alternative_cb_end
 #include <asm/mmu_context.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
+#include <asm/kvm_nested.h>
 
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
@@ -166,6 +167,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 			     void **haddr);
 void free_hyp_pgds(void);
 
+void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
@@ -307,5 +309,12 @@ static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
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
index f2820c82e956..e3bcb351aae1 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -59,6 +59,13 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 	return ttbr0 & ~GENMASK_ULL(63, 48);
 }
 
+extern void kvm_init_nested(struct kvm *kvm);
+extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
+extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
+extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr);
+extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
+extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
+
 extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 			    u64 control_bit);
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3fd8f37830f2..c0c1a46a078b 100644
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
@@ -138,6 +139,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
 
+	kvm_init_nested(kvm);
+
 	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		return ret;
@@ -397,6 +400,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_s2_mmu *mmu;
 	int *last_ran;
 
+	if (vcpu_has_nv(vcpu))
+		kvm_vcpu_load_hw_mmu(vcpu);
+
 	mmu = vcpu->arch.hw_mmu;
 	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
@@ -447,9 +453,12 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
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
 
@@ -1179,8 +1188,13 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 
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
index a3ee3b605c9b..e8434bd385fa 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -216,7 +216,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
  * does.
  */
 /**
- * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
+ * __unmap_stage2_range -- Clear stage2 page table entries to unmap a range
  * @mmu:   The KVM stage-2 MMU pointer
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
@@ -239,7 +239,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 				   may_block));
 }
 
-static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
+void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
 {
 	__unmap_stage2_range(mmu, start, size, true);
 }
@@ -691,21 +691,9 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
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
 
@@ -732,7 +720,53 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
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
@@ -757,6 +791,10 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
+
+	if (&kvm->arch.mmu != mmu)
+		kvm_init_nested_s2_mmu(mmu);
+
 	return 0;
 
 out_destroy_pgtable:
@@ -802,7 +840,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 
 		if (!(vma->vm_flags & VM_PFNMAP)) {
 			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
-			unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
+			kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -1846,11 +1884,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
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
@@ -1858,7 +1891,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	write_lock(&kvm->mmu_lock);
-	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f7ec27c27a4f..5514116429af 100644
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
 
@@ -16,6 +18,200 @@
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
+struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr)
+{
+	bool nested_stage2_enabled = hcr & HCR_VM;
+	int i;
+
+	/* Don't consider the CnP bit for the vttbr match */
+	vttbr = vttbr & ~VTTBR_CNP_BIT;
+
+	/*
+	 * Two possibilities when looking up a S2 MMU context:
+	 *
+	 * - either S2 is enabled in the guest, and we need a context that
+         *   is S2-enabled and matches the full VTTBR (VMID+BADDR), which
+         *   makes it safe from a TLB conflict perspective (a broken guest
+         *   won't be able to generate them),
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
+		    vttbr == mmu->vttbr)
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
+	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+	u64 hcr= vcpu_read_sys_reg(vcpu, HCR_EL2);
+	struct kvm_s2_mmu *s2_mmu;
+	int i;
+
+	s2_mmu = lookup_s2_mmu(kvm, vttbr, hcr);
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
+	 */
+	s2_mmu->vttbr = vttbr & ~VTTBR_CNP_BIT;
+	s2_mmu->nested_stage2_enabled = hcr & HCR_VM;
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

