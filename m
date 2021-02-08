Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD7F3130C9
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 12:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhBHL0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 06:26:35 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12463 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbhBHLXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 06:23:43 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DZ3Wj6PCFzjJyB;
        Mon,  8 Feb 2021 19:21:53 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 19:22:54 +0800
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
Subject: [RFC PATCH 2/4] KVM: arm64: Add an independent API for coalescing tables
Date:   Mon, 8 Feb 2021 19:22:48 +0800
Message-ID: <20210208112250.163568-3-wangyanan55@huawei.com>
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

Process of coalescing page mappings back to a block mapping is different
from normal map path, such as TLB invalidation and CMOs, so here add an
independent API for this case.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2f4f87021980..78a560446f80 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -525,6 +525,24 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
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
-- 
2.23.0

