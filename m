Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139563AB1C4
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 12:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhFQLAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 07:00:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4837 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbhFQLAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 07:00:43 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5JnS1xHjzXgmf;
        Thu, 17 Jun 2021 18:53:32 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 18:58:32 +0800
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 18:58:32 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Quentin Perret" <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, <wanghaibin.wang@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: [PATCH v7 4/4] KVM: arm64: Move guest CMOs to the fault handlers
Date:   Thu, 17 Jun 2021 18:58:24 +0800
Message-ID: <20210617105824.31752-5-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210617105824.31752-1-wangyanan55@huawei.com>
References: <20210617105824.31752-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500023.china.huawei.com (7.185.36.83)
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
of the stage-2 page table code.

We can imagine two specific scenarios which will gain much benefit:
1) In a normal VM startup, this solution will improve the efficiency of
handling guest page faults incurred by vCPUs, when initially populating
stage-2 page tables.
2) After live migration, the heavy workload will be resumed on the
destination VM, however all the stage-2 page tables need to be rebuilt
at the moment. So this solution will ease the performance drop during
resuming stage.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 38 +++++++++++++++++++++++++++++-------
 arch/arm64/kvm/mmu.c         | 37 ++++++++++++++---------------------
 2 files changed, 46 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index d99789432b05..760c551f61da 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -577,12 +577,24 @@ static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
 	mm_ops->put_page(ptep);
 }
 
+static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
+{
+	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
+	return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
+}
+
+static bool stage2_pte_executable(kvm_pte_t pte)
+{
+	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
+}
+
 static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep,
 				      struct stage2_map_data *data)
 {
 	kvm_pte_t new, old = *ptep;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
+	struct kvm_pgtable *pgt = data->mmu->pgt;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
@@ -606,6 +618,14 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
 	}
 
+	/* Perform CMOs before installation of the guest stage-2 PTE */
+	if (mm_ops->clean_invalidate_dcache && stage2_pte_cacheable(pgt, new))
+		mm_ops->clean_invalidate_dcache(kvm_pte_follow(new, mm_ops),
+						granule);
+
+	if (mm_ops->invalidate_icache && stage2_pte_executable(new))
+		mm_ops->invalidate_icache(kvm_pte_follow(new, mm_ops), granule);
+
 	smp_store_release(ptep, new);
 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ptep);
@@ -798,12 +818,6 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
-static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
-{
-	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
-	return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
-}
-
 static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
@@ -874,6 +888,7 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 {
 	kvm_pte_t pte = *ptep;
 	struct stage2_attr_data *data = arg;
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
 	if (!kvm_pte_valid(pte))
 		return 0;
@@ -888,8 +903,17 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * but worst-case the access flag update gets lost and will be
 	 * set on the next access instead.
 	 */
-	if (data->pte != pte)
+	if (data->pte != pte) {
+		/*
+		 * Invalidate instruction cache before updating the guest
+		 * stage-2 PTE if we are going to add executable permission.
+		 */
+		if (mm_ops->invalidate_icache &&
+		    stage2_pte_executable(pte) && !stage2_pte_executable(*ptep))
+			mm_ops->invalidate_icache(kvm_pte_follow(pte, mm_ops),
+						  kvm_granule_size(level));
 		WRITE_ONCE(*ptep, pte);
+	}
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b980f8a47cbb..c9f002d74ab4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -434,14 +434,16 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 }
 
 static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
-	.zalloc_page		= stage2_memcache_zalloc_page,
-	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
-	.free_pages_exact	= free_pages_exact,
-	.get_page		= kvm_host_get_page,
-	.put_page		= kvm_host_put_page,
-	.page_count		= kvm_host_page_count,
-	.phys_to_virt		= kvm_host_va,
-	.virt_to_phys		= kvm_host_pa,
+	.zalloc_page			= stage2_memcache_zalloc_page,
+	.zalloc_pages_exact		= kvm_host_zalloc_pages_exact,
+	.free_pages_exact		= free_pages_exact,
+	.get_page			= kvm_host_get_page,
+	.put_page			= kvm_host_put_page,
+	.page_count			= kvm_host_page_count,
+	.phys_to_virt			= kvm_host_va,
+	.virt_to_phys			= kvm_host_pa,
+	.clean_invalidate_dcache	= clean_dcache_guest_page,
+	.invalidate_icache		= invalidate_icache_guest_page,
 };
 
 /**
@@ -1012,15 +1014,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
-	if (fault_status != FSC_PERM && !device)
-		clean_dcache_guest_page(page_address(pfn_to_page(pfn)),
-					vma_pagesize);
-
-	if (exec_fault) {
+	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
-		invalidate_icache_guest_page(page_address(pfn_to_page(pfn)),
-					     vma_pagesize);
-	}
 
 	if (device)
 		prot |= KVM_PGTABLE_PROT_DEVICE;
@@ -1218,12 +1213,10 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	WARN_ON(range->end - range->start != 1);
 
 	/*
-	 * We've moved a page around, probably through CoW, so let's treat it
-	 * just like a translation fault and clean the cache to the PoC.
-	 */
-	clean_dcache_guest_page(page_address(pfn_to_page(pfn), PAGE_SIZE);
-
-	/*
+	 * We've moved a page around, probably through CoW, so let's treat
+	 * it just like a translation fault and the map handler will clean
+	 * the cache to the PoC.
+	 *
 	 * The MMU notifiers will have unmapped a huge PMD before calling
 	 * ->change_pte() (which in turn calls kvm_set_spte_gfn()) and
 	 * therefore we never need to clear out a huge PMD through this
-- 
2.23.0

