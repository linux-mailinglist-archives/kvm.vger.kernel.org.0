Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C685303F17
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404951AbhAZNns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:43:48 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11890 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404906AbhAZNnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 08:43:40 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DQ7DK2k0Kz7bPZ;
        Tue, 26 Jan 2021 21:41:05 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 21:42:09 +0800
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
Subject: [RFC PATCH v1 4/5] KVM: arm64: Add handling of coalescing tables into a block mapping
Date:   Tue, 26 Jan 2021 21:42:01 +0800
Message-ID: <20210126134202.381996-5-wangyanan55@huawei.com>
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

If migration of a VM with hugepages is canceled midway, KVM will adjust
the stage-2 table mappings back to block mappings. We currently use BBM
to replace the table entry with a block entry. Take adjustment of 1G block
mapping as an example, with BBM procedures, we have to invalidate the old
table entry of level 1 first, flush TLB and unmap the old table mappings,
right before installing the new block entry.

So there will be a bit long period when the table entry of level 1 is
invalid before installation of block entry, if other vCPUs access any
guest page within the 1G range during this period and find the table
entry invalid, they will all exit from guest with an translation fault.
Actually, these translation faults are not necessary, because the block
mapping will be built later. Besides, KVM will try to build 1G block
mappings for these translation faults, and will perform cache maintenance
operations, page table walk, etc.

Approaches of TTRem level 1,2 ensure that there will be not a moment when
the old table entry is invalid before installation of the new block entry,
so no unnecessary translation faults will be caused. But level-2 method
will possibly lead to a TLB conflict which is bothering, so we use nT both
at level-1 and level-2 case to avoid handling TLB conflict aborts.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c8b959e3951b..ab1c94985ed0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -49,6 +49,8 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
+#define KVM_PTE_LEAF_BLOCK_S2_NT	BIT(16)
+
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
@@ -502,6 +504,39 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	return 0;
 }
 
+static int stage2_coalesce_tables_into_block(u64 addr, u32 level,
+					     kvm_pte_t *ptep,
+					     struct stage2_map_data *data)
+{
+	u32 ttrem_level = data->ttrem_level;
+	u64 granule = kvm_granule_size(level), phys = data->phys;
+	kvm_pte_t new = kvm_init_valid_leaf_pte(phys, data->attr, level);
+
+	switch (ttrem_level) {
+	case TTREM_LEVEL0:
+		kvm_set_invalid_pte(ptep);
+
+		/*
+		 * Invalidate the whole stage-2, as we may have numerous leaf
+		 * entries below us which would otherwise need invalidating
+		 * individually.
+		 */
+		kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
+		smp_store_release(ptep, new);
+		data->phys += granule;
+		return 0;
+	case TTREM_LEVEL1:
+	case TTREM_LEVEL2:
+		WRITE_ONCE(*ptep, new | KVM_PTE_LEAF_BLOCK_S2_NT);
+		kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
+		WRITE_ONCE(*ptep, new & ~KVM_PTE_LEAF_BLOCK_S2_NT);
+		data->phys += granule;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 				     kvm_pte_t *ptep,
 				     struct stage2_map_data *data)
-- 
2.19.1

