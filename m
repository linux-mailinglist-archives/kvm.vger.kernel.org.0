Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A232F60E9
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 13:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbhANMOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 07:14:49 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11385 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbhANMOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 07:14:47 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DGjrD6PJFz7VLh;
        Thu, 14 Jan 2021 20:13:00 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Thu, 14 Jan 2021 20:13:53 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Quentin Perret <qperret@google.com>,
        <wanghaibin.wang@huawei.com>, <yezengruan@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: [PATCH v3 1/3] KVM: arm64: Adjust partial code of hyp stage-1 map and guest stage-2 map
Date:   Thu, 14 Jan 2021 20:13:48 +0800
Message-ID: <20210114121350.123684-2-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210114121350.123684-1-wangyanan55@huawei.com>
References: <20210114121350.123684-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Procedures of hyp stage-1 map and guest stage-2 map are quite different,
but they are tied closely by function kvm_set_valid_leaf_pte().
So adjust the relative code for ease of code maintenance in the future.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 55 ++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bdf8e55ed308..a11ac874bc2a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -170,10 +170,9 @@ static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp)
 	smp_store_release(ptep, pte);
 }
 
-static bool kvm_set_valid_leaf_pte(kvm_pte_t *ptep, u64 pa, kvm_pte_t attr,
-				   u32 level)
+static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
 {
-	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(pa);
+	kvm_pte_t pte = kvm_phys_to_pte(pa);
 	u64 type = (level == KVM_PGTABLE_MAX_LEVELS - 1) ? KVM_PTE_TYPE_PAGE :
 							   KVM_PTE_TYPE_BLOCK;
 
@@ -181,12 +180,7 @@ static bool kvm_set_valid_leaf_pte(kvm_pte_t *ptep, u64 pa, kvm_pte_t attr,
 	pte |= FIELD_PREP(KVM_PTE_TYPE, type);
 	pte |= KVM_PTE_VALID;
 
-	/* Tolerate KVM recreating the exact same mapping. */
-	if (kvm_pte_valid(old))
-		return old == pte;
-
-	smp_store_release(ptep, pte);
-	return true;
+	return pte;
 }
 
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
@@ -341,12 +335,17 @@ static int hyp_map_set_prot_attr(enum kvm_pgtable_prot prot,
 static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				    kvm_pte_t *ptep, struct hyp_map_data *data)
 {
+	kvm_pte_t new, old = *ptep;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
 
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return false;
 
-	WARN_ON(!kvm_set_valid_leaf_pte(ptep, phys, data->attr, level));
+	/* Tolerate KVM recreating the exact same mapping */
+	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
+	if (old != new && !WARN_ON(kvm_pte_valid(old)))
+		smp_store_release(ptep, new);
+
 	data->phys += granule;
 	return true;
 }
@@ -465,27 +464,30 @@ static bool stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				       kvm_pte_t *ptep,
 				       struct stage2_map_data *data)
 {
+	kvm_pte_t new, old = *ptep;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
+	struct page *page = virt_to_page(ptep);
 
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return false;
 
-	/*
-	 * If the PTE was already valid, drop the refcount on the table
-	 * early, as it will be bumped-up again in stage2_map_walk_leaf().
-	 * This ensures that the refcount stays constant across a valid to
-	 * valid PTE update.
-	 */
-	if (kvm_pte_valid(*ptep))
-		put_page(virt_to_page(ptep));
+	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
+	if (kvm_pte_valid(old)) {
+		/* Tolerate KVM recreating the exact same mapping */
+		if (old == new)
+			goto out;
 
-	if (kvm_set_valid_leaf_pte(ptep, phys, data->attr, level))
-		goto out;
+		/*
+		 * There's an existing different valid leaf entry, so perform
+		 * break-before-make.
+		 */
+		kvm_set_invalid_pte(ptep);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
+		put_page(page);
+	}
 
-	/* There's an existing valid leaf entry, so perform break-before-make */
-	kvm_set_invalid_pte(ptep);
-	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
-	kvm_set_valid_leaf_pte(ptep, phys, data->attr, level);
+	smp_store_release(ptep, new);
+	get_page(page);
 out:
 	data->phys += granule;
 	return true;
@@ -527,7 +529,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	}
 
 	if (stage2_map_walker_try_leaf(addr, end, level, ptep, data))
-		goto out_get_page;
+		return 0;
 
 	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
@@ -551,9 +553,8 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	}
 
 	kvm_set_table_pte(ptep, childp);
-
-out_get_page:
 	get_page(page);
+
 	return 0;
 }
 
-- 
2.19.1

