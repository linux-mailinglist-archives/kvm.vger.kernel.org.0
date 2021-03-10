Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE2C333913
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 10:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhCJJoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 04:44:10 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13901 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbhCJJnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 04:43:37 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DwRtg0c5szkX1y;
        Wed, 10 Mar 2021 17:42:03 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Mar 2021 17:43:23 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        "Julien Thierry" <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Quentin Perret <qperret@google.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <wanghaibin.wang@huawei.com>, <zhukeqian1@huawei.com>,
        <yuzenghui@huawei.com>, Yanan Wang <wangyanan55@huawei.com>
Subject: [RFC PATCH v2 2/3] KVM: arm64: Install the block entry before unmapping the page mappings
Date:   Wed, 10 Mar 2021 17:43:18 +0800
Message-ID: <20210310094319.18760-3-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210310094319.18760-1-wangyanan55@huawei.com>
References: <20210310094319.18760-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM needs to coalesce the existing normal page mappings into a block
mapping, we currently follow the following steps successively:
1) invalidate the table entry in the PMD/PUD table
2) flush TLB by VMID
3) unmap the old sub-level tables
4) install the new block entry to the PMD/PUD table

It will cost a long time to unmap the old page mappings in step 3, which
means there will be a long period when the PMD/PUD table entry could be
found invalid (step 1, 2, 3). So the other vcpus have a really big chance
to trigger unnecessary translations if they access any page within the
block and find the table entry invalid.

So let's quickly install the block entry at first to ensure uninterrupted
memory access of the other vcpus, and then unmap the page mappings after
installation. This will reduce most of the time when the table entry is
invalid, and avoid most of the unnecessary translation faults.

After this patch the steps can be like:
1) invalidate the table entry in the PMD/PUD table
2) flush TLB by VMID
3) install the new block entry to the PMD/PUD table
4) unmap the old sub-level tables

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 44 ++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 829a34eea526..b40b1f1615c7 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -434,6 +434,7 @@ struct stage2_map_data {
 	kvm_pte_t			attr;
 
 	kvm_pte_t			*anchor;
+	kvm_pte_t			*follow;
 
 	struct kvm_s2_mmu		*mmu;
 	struct kvm_mmu_memory_cache	*memcache;
@@ -545,6 +546,24 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	return 0;
 }
 
+static void stage2_coalesce_tables_into_block(u64 addr, u32 level,
+					      kvm_pte_t *ptep,
+					      struct stage2_map_data *data)
+{
+	u64 granule = kvm_granule_size(level), phys = data->phys;
+	kvm_pte_t new = kvm_init_valid_leaf_pte(phys, data->attr, level);
+
+	kvm_set_invalid_pte(ptep);
+
+	/*
+	 * Invalidate the whole stage-2, as we may have numerous leaf entries
+	 * below us which would otherwise need invalidating individually.
+	 */
+	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
+	smp_store_release(ptep, new);
+	data->phys += granule;
+}
+
 static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 				     kvm_pte_t *ptep,
 				     struct stage2_map_data *data)
@@ -555,15 +574,14 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 	if (!kvm_block_mapping_supported(addr, end, data->phys, level))
 		return 0;
 
-	kvm_set_invalid_pte(ptep);
-
 	/*
-	 * Invalidate the whole stage-2, as we may have numerous leaf
-	 * entries below us which would otherwise need invalidating
-	 * individually.
+	 * If we need to coalesce existing table entries into a block here,
+	 * then install the block entry first and the sub-level page mappings
+	 * will be unmapped later.
 	 */
-	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
 	data->anchor = ptep;
+	data->follow = kvm_pte_follow(*ptep);
+	stage2_coalesce_tables_into_block(addr, level, ptep, data);
 	return 0;
 }
 
@@ -616,20 +634,18 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep,
 				      struct stage2_map_data *data)
 {
-	int ret = 0;
-
 	if (!data->anchor)
 		return 0;
 
-	free_page((unsigned long)kvm_pte_follow(*ptep));
-	put_page(virt_to_page(ptep));
-
-	if (data->anchor == ptep) {
+	if (data->anchor != ptep) {
+		free_page((unsigned long)kvm_pte_follow(*ptep));
+		put_page(virt_to_page(ptep));
+	} else {
+		free_page((unsigned long)data->follow);
 		data->anchor = NULL;
-		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
-- 
2.19.1

