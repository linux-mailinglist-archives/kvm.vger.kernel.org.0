Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB11303E5C
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404096AbhAZNPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:15:36 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11506 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391788AbhAZMp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 07:45:59 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQ5yR1m3szjDds;
        Tue, 26 Jan 2021 20:43:59 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 20:45:03 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <xiexiangyou@huawei.com>, <zhengchuan@huawei.com>,
        <yubihong@huawei.com>
Subject: [RFC PATCH 3/7] kvm: arm64: Add level_apply parameter for stage2_attr_walker
Date:   Tue, 26 Jan 2021 20:44:40 +0800
Message-ID: <20210126124444.27136-4-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210126124444.27136-1-zhukeqian1@huawei.com>
References: <20210126124444.27136-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to change PTEs of some specific levels, the level_apply
parameter can be used as a level mask.

This has no fuctional change for current code.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4915ba35f93b..0f8a319f16fe 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -734,6 +734,7 @@ struct stage2_attr_data {
 	kvm_pte_t	attr_clr;
 	kvm_pte_t	pte;
 	u32		level;
+	u32		level_apply;
 };
 
 static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
@@ -743,6 +744,9 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	kvm_pte_t pte = *ptep;
 	struct stage2_attr_data *data = arg;
 
+	if (!(data->level_apply & BIT(level)))
+		return 0;
+
 	if (!kvm_pte_valid(pte))
 		return 0;
 
@@ -753,14 +757,15 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 
 static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 				    u64 size, kvm_pte_t attr_set,
-				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte,
-				    u32 *level)
+				    kvm_pte_t attr_clr, u32 level_apply,
+				    kvm_pte_t *orig_pte, u32 *level)
 {
 	int ret;
 	kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
 	struct stage2_attr_data data = {
 		.attr_set	= attr_set & attr_mask,
 		.attr_clr	= attr_clr & attr_mask,
+		.level_apply	= level_apply,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_attr_walker,
@@ -783,7 +788,7 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	return stage2_update_leaf_attrs(pgt, addr, size, 0,
-					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
+					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W, -1,
 					NULL, NULL);
 }
 
@@ -791,7 +796,7 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
 	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				 &pte, NULL);
+				 -1, &pte, NULL);
 	dsb(ishst);
 	return pte;
 }
@@ -800,7 +805,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
 	stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
-				 &pte, NULL);
+				 -1, &pte, NULL);
 	/*
 	 * "But where's the TLBI?!", you scream.
 	 * "Over in the core code", I sigh.
@@ -813,7 +818,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
 bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
-	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL);
+	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, -1, &pte, NULL);
 	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
 }
 
@@ -833,7 +838,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_X)
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
-	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level);
+	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, -1, NULL, &level);
 	if (!ret)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
 	return ret;
-- 
2.19.1

