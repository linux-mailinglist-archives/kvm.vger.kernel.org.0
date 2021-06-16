Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDB23A9699
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 11:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhFPJzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 05:55:06 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7333 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbhFPJy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 05:54:57 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G4gPG679yz6y9c;
        Wed, 16 Jun 2021 17:48:50 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:52:49 +0800
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:52:49 +0800
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
Subject: [PATCH v6 4/4] KVM: arm64: Move guest CMOs to the fault handlers
Date:   Wed, 16 Jun 2021 17:52:00 +0800
Message-ID: <20210616095200.38008-5-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210616095200.38008-1-wangyanan55@huawei.com>
References: <20210616095200.38008-1-wangyanan55@huawei.com>
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
 arch/arm64/kvm/hyp/pgtable.c | 37 +++++++++++++++++++++++++++++-------
 arch/arm64/kvm/mmu.c         | 21 +++++++-------------
 2 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index d99789432b05..b7b40abe78e8 100644
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
@@ -606,6 +618,13 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
 	}
 
+	/* Perform CMOs before installation of the guest stage-2 PTE */
+	if (mm_ops->flush_dcache && stage2_pte_cacheable(pgt, new))
+		mm_ops->flush_dcache(mm_ops->phys_to_virt(phys), granule);
+
+	if (mm_ops->flush_icache && stage2_pte_executable(new))
+		mm_ops->flush_icache(mm_ops->phys_to_virt(phys), granule);
+
 	smp_store_release(ptep, new);
 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ptep);
@@ -798,12 +817,6 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
@@ -874,6 +887,7 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 {
 	kvm_pte_t pte = *ptep;
 	struct stage2_attr_data *data = arg;
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
 	if (!kvm_pte_valid(pte))
 		return 0;
@@ -888,8 +902,17 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * but worst-case the access flag update gets lost and will be
 	 * set on the next access instead.
 	 */
-	if (data->pte != pte)
+	if (data->pte != pte) {
+		/*
+		 * Invalidate instruction cache before updating the guest
+		 * stage-2 PTE if we are going to add executable permission.
+		 */
+		if (mm_ops->flush_icache &&
+		    stage2_pte_executable(pte) && !stage2_pte_executable(*ptep))
+			mm_ops->flush_icache(kvm_pte_follow(pte, mm_ops),
+					     kvm_granule_size(level));
 		WRITE_ONCE(*ptep, pte);
+	}
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b980f8a47cbb..6d97a435a635 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -442,6 +442,8 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.page_count		= kvm_host_page_count,
 	.phys_to_virt		= kvm_host_va,
 	.virt_to_phys		= kvm_host_pa,
+	.flush_dcache		= clean_dcache_guest_page,
+	.flush_icache		= invalidate_icache_guest_page,
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

