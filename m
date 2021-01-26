Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88B9303F45
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404847AbhAZNtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:49:49 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11447 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404868AbhAZNnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 08:43:01 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DQ7Db06DfzjCXQ;
        Tue, 26 Jan 2021 21:41:19 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 21:42:10 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <yezengruan@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: [RFC PATCH v1 5/5] KVM: arm64: Adapt page-table code to new handling of coalescing tables
Date:   Tue, 26 Jan 2021 21:42:02 +0800
Message-ID: <20210126134202.381996-6-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210126134202.381996-1-wangyanan55@huawei.com>
References: <20210126134202.381996-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With new handling of coalescing tables, we can install the block entry
before unmap of the old table mappings. So make the installation in
stage2_map_walk_table_pre(), and elide the installation from function
stage2_map_walk_table_post().

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index ab1c94985ed0..fb755aac4384 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -436,6 +436,7 @@ struct stage2_map_data {
 	kvm_pte_t			attr;
 
 	kvm_pte_t			*anchor;
+	kvm_pte_t			*follow;
 
 	struct kvm_s2_mmu		*mmu;
 	struct kvm_mmu_memory_cache	*memcache;
@@ -550,13 +551,13 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 	kvm_set_invalid_pte(ptep);
 
 	/*
-	 * Invalidate the whole stage-2, as we may have numerous leaf
-	 * entries below us which would otherwise need invalidating
-	 * individually.
+	 * If there is an existing table entry and block mapping is needed here,
+	 * then set the anchor and replace it with a block entry. The sub-level
+	 * mappings will later be unmapped lazily.
 	 */
-	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
 	data->anchor = ptep;
-	return 0;
+	data->follow = kvm_pte_follow(*ptep);
+	return stage2_coalesce_tables_into_block(addr, level, ptep, data);
 }
 
 static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
@@ -608,20 +609,18 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
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

