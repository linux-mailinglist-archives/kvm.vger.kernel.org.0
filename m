Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D057883EE
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 11:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244270AbjHYJhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 05:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244091AbjHYJgo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 05:36:44 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D991FD4
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 02:36:42 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RXFF41TH3z6D8Wp;
        Fri, 25 Aug 2023 17:35:52 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 25 Aug 2023 10:36:33 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
        <will@kernel.org>, <catalin.marinas@arm.com>,
        <oliver.upton@linux.dev>
CC:     <james.morse@arm.com>, <suzuki.poulose@arm.com>,
        <yuzenghui@huawei.com>, <zhukeqian1@huawei.com>,
        <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable interfaces
Date:   Fri, 25 Aug 2023 10:35:23 +0100
Message-ID: <20230825093528.1637-4-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Keqian Zhu <zhukeqian1@huawei.com>

This adds set_dbm, clear_dbm and sync_dirty interfaces in pgtable
layer. (1) set_dbm: Set DBM bit for last level PTE of a specified
range. TLBI is completed. (2) clear_dbm: Clear DBM bit for last
level PTE of a specified range. TLBI is not acted. (3) sync_dirty:
Scan last level PTE of a specific range. Log dirty if PTE is writeable.

Besides, save the dirty state of PTE if it's invalided by map or
unmap.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 45 +++++++++++++
 arch/arm64/kernel/image-vars.h       |  2 +
 arch/arm64/kvm/hyp/pgtable.c         | 98 ++++++++++++++++++++++++++++
 3 files changed, 145 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 3f96bdd2086f..a12add002b89 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -578,6 +578,51 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
  */
 int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
+/**
+ * kvm_pgtable_stage2_clear_dbm() - Clear DBM of guest stage-2 address range
+ *                                  without TLB invalidation (only last level).
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Intermediate physical address from which to clear DBM,
+ * @size:	Size of the range.
+ *
+ * The offset of @addr within a page is ignored and @size is rounded-up to
+ * the next page boundary.
+ *
+ * Note that it is the caller's responsibility to invalidate the TLB after
+ * calling this function to ensure that the disabled HW dirty are visible
+ * to the CPUs.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_clear_dbm(struct kvm_pgtable *pgt, u64 addr, u64 size);
+
+/**
+ * kvm_pgtable_stage2_set_dbm() - Set DBM of guest stage-2 address range to
+ *                                enable HW dirty (only last level).
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Intermediate physical address from which to set DBM.
+ * @size:	Size of the range.
+ *
+ * The offset of @addr within a page is ignored and @size is rounded-up to
+ * the next page boundary.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_set_dbm(struct kvm_pgtable *pgt, u64 addr, u64 size);
+
+/**
+ * kvm_pgtable_stage2_sync_dirty() - Sync HW dirty state into memslot.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Intermediate physical address from which to sync.
+ * @size:	Size of the range.
+ *
+ * The offset of @addr within a page is ignored and @size is rounded-up to
+ * the next page boundary.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_sync_dirty(struct kvm_pgtable *pgt, u64 addr, u64 size);
+
 /**
  * kvm_pgtable_stage2_wrprotect() - Write-protect guest stage-2 address range
  *                                  without TLB invalidation.
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 35f3c7959513..2ca600e3d637 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -68,6 +68,8 @@ KVM_NVHE_ALIAS(__hyp_stub_vectors);
 KVM_NVHE_ALIAS(vgic_v2_cpuif_trap);
 KVM_NVHE_ALIAS(vgic_v3_cpuif_trap);
 
+KVM_NVHE_ALIAS(mark_page_dirty);
+
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 /* Static key checked in GIC_PRIO_IRQOFF. */
 KVM_NVHE_ALIAS(gic_nonsecure_priorities);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 1e65b8c97059..d7a46a00a7f6 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -9,6 +9,7 @@
 
 #include <linux/bitfield.h>
 #include <asm/kvm_pgtable.h>
+#include <asm/kvm_mmu.h>
 #include <asm/stage2_pgtable.h>
 
 
@@ -42,6 +43,7 @@
 
 #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
 
+#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
 
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
@@ -764,8 +766,44 @@ static bool stage2_pte_is_locked(kvm_pte_t pte)
 	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
 }
 
+static bool stage2_pte_writeable(kvm_pte_t pte)
+{
+	return pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+}
+
+static void kvm_update_hw_dbm(const struct kvm_pgtable_visit_ctx *ctx,
+			      kvm_pte_t new)
+{
+	kvm_pte_t old_pte, pte = ctx->old;
+
+	/* Only set DBM if page is writeable */
+	if ((new & KVM_PTE_LEAF_ATTR_HI_S2_DBM) && !stage2_pte_writeable(pte))
+		return;
+
+	/* Clear DBM walk is not shared, update */
+	if (!kvm_pgtable_walk_shared(ctx)) {
+		WRITE_ONCE(*ctx->ptep, new);
+		return;
+	}
+
+	do {
+		old_pte = pte;
+		pte = new;
+
+		if (old_pte == pte)
+			break;
+
+		pte = cmpxchg_relaxed(ctx->ptep, old_pte, pte);
+	} while (pte != old_pte);
+}
+
 static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
 {
+	if (kvm_pgtable_walk_hw_dbm(ctx)) {
+		kvm_update_hw_dbm(ctx, new);
+		return true;
+	}
+
 	if (!kvm_pgtable_walk_shared(ctx)) {
 		WRITE_ONCE(*ctx->ptep, new);
 		return true;
@@ -952,6 +990,11 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	    stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
+	/* Save the possible hardware dirty info */
+	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) &&
+	    stage2_pte_writeable(ctx->old))
+		mark_page_dirty(kvm_s2_mmu_to_kvm(pgt->mmu), ctx->addr >> PAGE_SHIFT);
+
 	stage2_make_pte(ctx, new);
 
 	return 0;
@@ -1125,6 +1168,11 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 */
 	stage2_unmap_put_pte(ctx, mmu, mm_ops);
 
+	/* Save the possible hardware dirty info */
+	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) &&
+	    stage2_pte_writeable(ctx->old))
+		mark_page_dirty(kvm_s2_mmu_to_kvm(mmu), ctx->addr >> PAGE_SHIFT);
+
 	if (need_flush && mm_ops->dcache_clean_inval_poc)
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
 					       kvm_granule_size(ctx->level));
@@ -1230,6 +1278,30 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 	return 0;
 }
 
+int kvm_pgtable_stage2_set_dbm(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	int ret;
+	u64 offset;
+
+	ret = stage2_update_leaf_attrs(pgt, addr, size, KVM_PTE_LEAF_ATTR_HI_S2_DBM, 0,
+				       NULL, NULL, KVM_PGTABLE_WALK_HW_DBM |
+				       KVM_PGTABLE_WALK_SHARED);
+	if (!ret)
+		return ret;
+
+	for (offset = 0; offset < size; offset += PAGE_SIZE)
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr + offset, 3);
+
+	return 0;
+}
+
+int kvm_pgtable_stage2_clear_dbm(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	return stage2_update_leaf_attrs(pgt, addr, size,
+					0, KVM_PTE_LEAF_ATTR_HI_S2_DBM,
+					NULL, NULL, KVM_PGTABLE_WALK_HW_DBM);
+}
+
 int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	return stage2_update_leaf_attrs(pgt, addr, size, 0,
@@ -1329,6 +1401,32 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	return ret;
 }
 
+static int stage2_sync_dirty_walker(const struct kvm_pgtable_visit_ctx *ctx,
+				    enum kvm_pgtable_walk_flags visit)
+{
+	kvm_pte_t pte = READ_ONCE(*ctx->ptep);
+	struct kvm *kvm = ctx->arg;
+
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) && stage2_pte_writeable(pte))
+		mark_page_dirty(kvm, ctx->addr >> PAGE_SHIFT);
+
+	return 0;
+}
+
+int kvm_pgtable_stage2_sync_dirty(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_sync_dirty_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= kvm_s2_mmu_to_kvm(pgt->mmu),
+	};
+
+	return kvm_pgtable_walk(pgt, addr, size, &walker);
+}
+
 static int stage2_flush_walker(const struct kvm_pgtable_visit_ctx *ctx,
 			       enum kvm_pgtable_walk_flags visit)
 {
-- 
2.34.1

