Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F193130CF
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 12:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbhBHL1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 06:27:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12151 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbhBHLXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 06:23:51 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZ3WW1s5Tz165PY;
        Mon,  8 Feb 2021 19:21:43 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 19:22:56 +0800
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
Subject: [RFC PATCH 3/4] KVM: arm64: Install the block entry before unmapping the page mappings
Date:   Mon, 8 Feb 2021 19:22:49 +0800
Message-ID: <20210208112250.163568-4-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210208112250.163568-1-wangyanan55@huawei.com>
References: <20210208112250.163568-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM needs to coalesce the normal page mappings into a block mapping,
we currently invalidate the old table entry first followed by invalidation
of TLB, then unmap the page mappings, and install the block entry at last.

It will cost a long time to unmap the numerous page mappings, which means
there will be a long period when the table entry can be found invalid.
If other vCPUs access any guest page within the block range and find the
table entry invalid, they will all exit from guest with a translation fault
which is not necessary. And KVM will make efforts to handle these faults,
especially when performing CMOs by block range.

So let's quickly install the block entry at first to ensure uninterrupted
memory access of the other vCPUs, and then unmap the page mappings after
installation. This will reduce most of the time when the table entry is
invalid, and avoid most of the unnecessary translation faults.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 78a560446f80..308c36b9cd21 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -434,6 +434,7 @@ struct stage2_map_data {
 	kvm_pte_t			attr;
 
 	kvm_pte_t			*anchor;
+	kvm_pte_t			*follow;
 
 	struct kvm_s2_mmu		*mmu;
 	struct kvm_mmu_memory_cache	*memcache;
@@ -553,15 +554,14 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
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
 
@@ -614,20 +614,18 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
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
2.23.0

