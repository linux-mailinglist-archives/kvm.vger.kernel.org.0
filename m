Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9230B7038A5
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242422AbjEORd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243682AbjEORdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99EF15266
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:31:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40BC362D44
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F46C4339C;
        Mon, 15 May 2023 17:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684171885;
        bh=RXRBnjOeKdT2FlHPCMXlg3l54aSn1jvK9uAr9Zxd6Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUwgUkXgKaAcLERzCe/C9NzYAXuE36/wCwiofqiJsnL+xlOdPNgK7FTTrRDrRwPN+
         8kBKBl3qEu/ZZbA7HJPLhSMlH0fQmstorKVUPgzvUDv/WIT5y+6DZblW9xfOjBl4eM
         MOY65K2TkY0FLBFdLVMYqc9ap/Szj7d+Bq4Yll2S+PTRaA2j3Rv+TGOFi07aDcC8dN
         wQ9pHmyXh2eJNmcp8wSOZVAv/IGKUof+OGipoCmmTschcrT4TkKYT3fIixczBbrKx1
         aLwn/51+a8340ZXGKpS4JLEE/OFeUILeahDe3/1pgBqjYwtWwvwov174laDvJy1uxe
         dR1svIHTsh+3A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc2d-00FJAF-EN;
        Mon, 15 May 2023 18:31:23 +0100
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
Subject: [PATCH v10 01/59] KVM: arm64: Move VTCR_EL2 into struct s2_mmu
Date:   Mon, 15 May 2023 18:30:05 +0100
Message-Id: <20230515173103.1017669-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We currently have a global VTCR_EL2 value for each guest, even
if the guest uses NV. This implies that the guest's own S2 must
fit in the host's. This is odd, for multiple reasons:

- the PARange values and the number of IPA bits don't necessarily
  match: you can have 33 bits of IPA space, and yet you can only
  describe 32 or 36 bits of PARange

- When userspace set the IPA space, it creates a contract with the
  kernel saying "this is the IPA space I'm prepared to handle".
  At no point does it constraint the guest's own IPA space as
  long as the guest doesn't try to use a [I]PA outside of the
  IPA space set by userspace

- We don't even try to ide the value of ID_AA64MMFR0_EL1.PARange.

And then there is the consequence of the above: if a guest tries
to create a S2 that has for input address something that is larger
than the IPA space defined by the host, we inject a fatal exception.

This is no good. For all intent and purposes, a guest should be
able to have the S2 it really wants, as long as the *output* address
of that S2 isn't outside of the IPA space.

For that, we need to have a per-s2_mmu VTCR_EL2 setting, which
allows us to represent the full PARange. Move the vctr field into
the s2_mmu structure, which has no impact whatsoever, except for NV.

Note that once we are able to override ID_AA64MMFR0_EL1.PARange
from userspace, we'll also be able to restrict the size of the
shadow S2 that NV uses.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       | 13 ++++++++++---
 arch/arm64/include/asm/kvm_mmu.h        |  8 ++++----
 arch/arm64/include/asm/stage2_pgtable.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  8 ++++----
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  4 ++--
 arch/arm64/kvm/hyp/pgtable.c            |  2 +-
 arch/arm64/kvm/mmu.c                    | 13 +++++++------
 arch/arm64/kvm/pkvm.c                   |  2 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c   |  3 ++-
 9 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ec3e69090c6e..f2e3b5889f8b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -156,6 +156,16 @@ struct kvm_s2_mmu {
 	phys_addr_t	pgd_phys;
 	struct kvm_pgtable *pgt;
 
+	/*
+	 * VTCR value used on the host. For a non-NV guest (or a NV
+	 * guest that runs in a context where its own S2 doesn't
+	 * apply), its T0SZ value reflects that of the IPA size.
+	 *
+	 * For a shadow S2 MMU, T0SZ reflects the PARange exposed to
+	 * the guest.
+	 */
+	u64	vtcr;
+
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
 
@@ -188,9 +198,6 @@ struct kvm_protected_vm {
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
-	/* VTCR_EL2 value for this VM */
-	u64    vtcr;
-
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 27e63c111f78..346754b2f3b0 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -150,9 +150,9 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
  */
 #define KVM_PHYS_SHIFT	(40)
 
-#define kvm_phys_shift(kvm)		VTCR_EL2_IPA(kvm->arch.vtcr)
-#define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
-#define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
+#define kvm_phys_shift(mmu)		VTCR_EL2_IPA((mmu)->vtcr)
+#define kvm_phys_size(mmu)		(_AC(1, ULL) << kvm_phys_shift(mmu))
+#define kvm_phys_mask(mmu)		(kvm_phys_size(mmu) - _AC(1, ULL))
 
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
@@ -296,7 +296,7 @@ static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
 static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu,
 					  struct kvm_arch *arch)
 {
-	write_sysreg(arch->vtcr, vtcr_el2);
+	write_sysreg(mmu->vtcr, vtcr_el2);
 	write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
 
 	/*
diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index c8dca8ae359c..23d27623e478 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -21,13 +21,13 @@
  * (IPA_SHIFT - 4).
  */
 #define stage2_pgtable_levels(ipa)	ARM64_HW_PGTABLE_LEVELS((ipa) - 4)
-#define kvm_stage2_levels(kvm)		VTCR_EL2_LVLS(kvm->arch.vtcr)
+#define kvm_stage2_levels(mmu)		VTCR_EL2_LVLS((mmu)->vtcr)
 
 /*
  * kvm_mmmu_cache_min_pages() is the number of pages required to install
  * a stage-2 translation. We pre-allocate the entry level page table at
  * the VM creation.
  */
-#define kvm_mmu_cache_min_pages(kvm)	(kvm_stage2_levels(kvm) - 1)
+#define kvm_mmu_cache_min_pages(mmu)	(kvm_stage2_levels(mmu) - 1)
 
 #endif	/* __ARM64_S2_PGTABLE_H_ */
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2e9ec4a2a4a3..07766e33cc32 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -129,8 +129,8 @@ static void prepare_host_vtcr(void)
 	parange = kvm_get_parange(id_aa64mmfr0_el1_sys_val);
 	phys_shift = id_aa64mmfr0_parange_to_phys_shift(parange);
 
-	host_mmu.arch.vtcr = kvm_get_vtcr(id_aa64mmfr0_el1_sys_val,
-					  id_aa64mmfr1_el1_sys_val, phys_shift);
+	host_mmu.arch.mmu.vtcr = kvm_get_vtcr(id_aa64mmfr0_el1_sys_val,
+					      id_aa64mmfr1_el1_sys_val, phys_shift);
 }
 
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot);
@@ -235,7 +235,7 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
 	unsigned long nr_pages;
 	int ret;
 
-	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
+	nr_pages = kvm_pgtable_stage2_pgd_size(mmu->vtcr) >> PAGE_SHIFT;
 	ret = hyp_pool_init(&vm->pool, hyp_virt_to_pfn(pgd), nr_pages, 0);
 	if (ret)
 		return ret;
@@ -295,7 +295,7 @@ int __pkvm_prot_finalize(void)
 		return -EPERM;
 
 	params->vttbr = kvm_get_vttbr(mmu);
-	params->vtcr = host_mmu.arch.vtcr;
+	params->vtcr = mmu->vtcr;
 	params->hcr_el2 |= HCR_VM;
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index a06ece14a6d8..28d17e91346b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -288,7 +288,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 {
 	hyp_vm->host_kvm = host_kvm;
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
-	hyp_vm->kvm.arch.vtcr = host_mmu.arch.vtcr;
+	hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
 }
 
 static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
@@ -468,7 +468,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 	}
 
 	vm_size = pkvm_get_hyp_vm_size(nr_vcpus);
-	pgd_size = kvm_pgtable_stage2_pgd_size(host_mmu.arch.vtcr);
+	pgd_size = kvm_pgtable_stage2_pgd_size(host_mmu.arch.mmu.vtcr);
 
 	ret = -ENOMEM;
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5282cb9ca4cf..028cebd6ff3e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1237,7 +1237,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      kvm_pgtable_force_pte_cb_t force_pte_cb)
 {
 	size_t pgd_sz;
-	u64 vtcr = mmu->arch->vtcr;
+	u64 vtcr = mmu->vtcr;
 	u32 ia_bits = VTCR_EL2_IPA(vtcr);
 	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
 	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3b9d4d24c361..c934c911c702 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -750,7 +750,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
-	kvm->arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
+	mmu->vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
 
 	if (mmu->pgt != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
@@ -915,7 +915,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	phys_addr_t addr;
 	int ret = 0;
 	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
-	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+	struct kvm_pgtable *pgt = mmu->pgt;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
 				     KVM_PGTABLE_PROT_R |
 				     (writable ? KVM_PGTABLE_PROT_W : 0);
@@ -928,7 +929,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 
 	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
 		ret = kvm_mmu_topup_memory_cache(&cache,
-						 kvm_mmu_cache_min_pages(kvm));
+						 kvm_mmu_cache_min_pages(mmu));
 		if (ret)
 			break;
 
@@ -1252,7 +1253,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (fault_status != ESR_ELx_FSC_PERM ||
 	    (logging_active && write_fault)) {
 		ret = kvm_mmu_topup_memory_cache(memcache,
-						 kvm_mmu_cache_min_pages(kvm));
+						 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
 		if (ret)
 			return ret;
 	}
@@ -1569,7 +1570,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	}
 
 	/* Userspace should not be able to register out-of-bounds IPAs */
-	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));
+	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->arch.hw_mmu));
 
 	if (fault_status == ESR_ELx_FSC_ACCESS) {
 		handle_access_fault(vcpu, fault_ipa);
@@ -1823,7 +1824,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 * Prevent userspace from creating a memory region outside of the IPA
 	 * space addressable by the KVM guest IPA space.
 	 */
-	if ((new->base_gfn + new->npages) > (kvm_phys_size(kvm) >> PAGE_SHIFT))
+	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
 		return -EFAULT;
 
 	hva = new->userspace_addr;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index cf56958b1492..1032690c20d1 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -118,7 +118,7 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 	if (host_kvm->created_vcpus < 1)
 		return -EINVAL;
 
-	pgd_sz = kvm_pgtable_stage2_pgd_size(host_kvm->arch.vtcr);
+	pgd_sz = kvm_pgtable_stage2_pgd_size(host_kvm->arch.mmu.vtcr);
 
 	/*
 	 * The PGD pages will be reclaimed using a hyp_memcache which implies
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 35cfa268fd5d..a6294ec3714c 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -27,7 +27,8 @@ int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
 	if (addr + size < addr)
 		return -EINVAL;
 
-	if (addr & ~kvm_phys_mask(kvm) || addr + size > kvm_phys_size(kvm))
+	if (addr & ~kvm_phys_mask(&kvm->arch.mmu) ||
+	    (addr + size) > kvm_phys_size(&kvm->arch.mmu))
 		return -E2BIG;
 
 	return 0;
-- 
2.34.1

