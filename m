Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC79359323
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 05:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhDIDiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 23:38:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16855 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbhDIDiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 23:38:11 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FGkK51gGJz9xh4;
        Fri,  9 Apr 2021 11:34:49 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 9 Apr 2021 11:36:56 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Alexandru Elisei" <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Quentin Perret <qperret@google.com>,
        <wanghaibin.wang@huawei.com>, <zhukeqian1@huawei.com>,
        <yuzenghui@huawei.com>, Yanan Wang <wangyanan55@huawei.com>
Subject: [PATCH v4 1/2] KVM: arm64: Move CMOs from user_mem_abort to the fault handlers
Date:   Fri, 9 Apr 2021 11:36:51 +0800
Message-ID: <20210409033652.28316-2-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210409033652.28316-1-wangyanan55@huawei.com>
References: <20210409033652.28316-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We currently uniformly permorm CMOs of D-cache and I-cache in function
user_mem_abort before calling the fault handlers. If we get concurrent
guest faults(e.g. translation faults, permission faults) or some really
unnecessary guest faults caused by BBM, CMOs for the first vcpu are
necessary while the others later are not.

By moving CMOs to the fault handlers, we can easily identify conditions
where they are really needed and avoid the unnecessary ones. As it's a
time consuming process to perform CMOs especially when flushing a block
range, so this solution reduces much load of kvm and improve efficiency
of the page table code.

So let's move both clean of D-cache and invalidation of I-cache to the
map path and move only invalidation of I-cache to the permission path.
Since the original APIs for CMOs in mmu.c are only called in function
user_mem_abort, we now also move them to pgtable.c.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 31 ---------------
 arch/arm64/kvm/hyp/pgtable.c     | 68 +++++++++++++++++++++++++-------
 arch/arm64/kvm/mmu.c             | 23 ++---------
 3 files changed, 57 insertions(+), 65 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 90873851f677..c31f88306d4e 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -177,37 +177,6 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
 }
 
-static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
-{
-	void *va = page_address(pfn_to_page(pfn));
-
-	/*
-	 * With FWB, we ensure that the guest always accesses memory using
-	 * cacheable attributes, and we don't have to clean to PoC when
-	 * faulting in pages. Furthermore, FWB implies IDC, so cleaning to
-	 * PoU is not required either in this case.
-	 */
-	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
-		return;
-
-	kvm_flush_dcache_to_poc(va, size);
-}
-
-static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
-						  unsigned long size)
-{
-	if (icache_is_aliasing()) {
-		/* any kind of VIPT cache */
-		__flush_icache_all();
-	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
-		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
-		void *va = page_address(pfn_to_page(pfn));
-
-		invalidate_icache_range((unsigned long)va,
-					(unsigned long)va + size);
-	}
-}
-
 void kvm_set_way_flush(struct kvm_vcpu *vcpu);
 void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled);
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4d177ce1d536..0e811c86fd06 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -464,6 +464,43 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 	return 0;
 }
 
+static bool stage2_pte_cacheable(kvm_pte_t pte)
+{
+	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
+	return memattr == PAGE_S2_MEMATTR(NORMAL);
+}
+
+static bool stage2_pte_executable(kvm_pte_t pte)
+{
+	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
+}
+
+static void stage2_flush_dcache(void *addr, u64 size)
+{
+	/*
+	 * With FWB, we ensure that the guest always accesses memory using
+	 * cacheable attributes, and we don't have to clean to PoC when
+	 * faulting in pages. Furthermore, FWB implies IDC, so cleaning to
+	 * PoU is not required either in this case.
+	 */
+	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
+		return;
+
+	__flush_dcache_area(addr, size);
+}
+
+static void stage2_invalidate_icache(void *addr, u64 size)
+{
+	if (icache_is_aliasing()) {
+		/* Flush any kind of VIPT icache */
+		__flush_icache_all();
+	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
+		/* PIPT or VPIPT at EL2 */
+		invalidate_icache_range((unsigned long)addr,
+					(unsigned long)addr + size);
+	}
+}
+
 static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep,
 				      struct stage2_map_data *data)
@@ -495,6 +532,13 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		put_page(page);
 	}
 
+	/* Perform CMOs before installation of the new PTE */
+	if (stage2_pte_cacheable(new))
+		stage2_flush_dcache(__va(phys), granule);
+
+	if (stage2_pte_executable(new))
+		stage2_invalidate_icache(__va(phys), granule);
+
 	smp_store_release(ptep, new);
 	get_page(page);
 	data->phys += granule;
@@ -651,20 +695,6 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
-static void stage2_flush_dcache(void *addr, u64 size)
-{
-	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
-		return;
-
-	__flush_dcache_area(addr, size);
-}
-
-static bool stage2_pte_cacheable(kvm_pte_t pte)
-{
-	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
-	return memattr == PAGE_S2_MEMATTR(NORMAL);
-}
-
 static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
@@ -743,8 +773,16 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * but worst-case the access flag update gets lost and will be
 	 * set on the next access instead.
 	 */
-	if (data->pte != pte)
+	if (data->pte != pte) {
+		/*
+		 * Invalidate the instruction cache before updating
+		 * if we are going to add the executable permission.
+		 */
+		if (!stage2_pte_executable(*ptep) && stage2_pte_executable(pte))
+			stage2_invalidate_icache(kvm_pte_follow(pte),
+						 kvm_granule_size(level));
 		WRITE_ONCE(*ptep, pte);
+	}
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 77cb2d28f2a4..1eec9f63bc6f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -609,16 +609,6 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
-static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
-{
-	__clean_dcache_guest_page(pfn, size);
-}
-
-static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
-{
-	__invalidate_icache_guest_page(pfn, size);
-}
-
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 {
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
@@ -882,13 +872,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
-	if (fault_status != FSC_PERM && !device)
-		clean_dcache_guest_page(pfn, vma_pagesize);
-
-	if (exec_fault) {
+	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
-		invalidate_icache_guest_page(pfn, vma_pagesize);
-	}
 
 	if (device)
 		prot |= KVM_PGTABLE_PROT_DEVICE;
@@ -1144,10 +1129,10 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	trace_kvm_set_spte_hva(hva);
 
 	/*
-	 * We've moved a page around, probably through CoW, so let's treat it
-	 * just like a translation fault and clean the cache to the PoC.
+	 * We've moved a page around, probably through CoW, so let's treat
+	 * it just like a translation fault and the map handler will clean
+	 * the cache to the PoC.
 	 */
-	clean_dcache_guest_page(pfn, PAGE_SIZE);
 	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pfn);
 	return 0;
 }
-- 
2.19.1

