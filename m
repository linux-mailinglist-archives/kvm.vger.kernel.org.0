Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A37B303E81
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404649AbhAZNPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:15:43 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11505 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391786AbhAZMqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 07:46:01 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQ5yR0rkWzjDdn;
        Tue, 26 Jan 2021 20:43:59 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 20:45:04 +0800
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
Subject: [RFC PATCH 4/7] kvm: arm64: Add some HW_DBM related pgtable interfaces
Date:   Tue, 26 Jan 2021 20:44:41 +0800
Message-ID: <20210126124444.27136-5-zhukeqian1@huawei.com>
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

This adds set_dbm, clear_dbm and sync_dirty interfaces in pgtable
layer. (1) set_dbm: Set DBM bit for last level PTE of a specified
range. TLBI is completed. (2) clear_dbm: Clear DBM bit for last
level PTE of a specified range. TLBI is not acted. (3) sync_dirty:
Scan last level PTE of a specific range. Log dirty if PTE is writable.

Besides, save the dirty state of PTE if it's invalided by map or
unmap.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 45 ++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 70 ++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 52ab38db04c7..8984b5227cfc 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -204,6 +204,51 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
  */
 int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
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
  * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0f8a319f16fe..b6f0d2f3aee4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -43,6 +43,7 @@
 
 #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
 
+#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
 
 struct kvm_pgtable_walk_data {
@@ -485,6 +486,11 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 	return 0;
 }
 
+static bool stage2_pte_writable(kvm_pte_t pte)
+{
+	return pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+}
+
 static bool stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				       kvm_pte_t *ptep,
 				       struct stage2_map_data *data)
@@ -509,6 +515,11 @@ static bool stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	/* There's an existing valid leaf entry, so perform break-before-make */
 	kvm_set_invalid_pte(ptep);
 	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
+
+	/* Save the possible hardware dirty info */
+	if ((level == KVM_PGTABLE_MAX_LEVELS - 1) && stage2_pte_writable(*ptep))
+		mark_page_dirty(data->mmu->kvm, addr >> PAGE_SHIFT);
+
 	kvm_set_valid_leaf_pte(ptep, phys, data->attr, level);
 out:
 	data->phys += granule;
@@ -547,6 +558,10 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		if (kvm_pte_valid(pte))
 			put_page(page);
 
+		/*
+		 * HW DBM is not working during page merging, so we don't
+		 * need to save possible hardware dirty info here.
+		 */
 		return 0;
 	}
 
@@ -707,6 +722,10 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, addr, level);
 	put_page(virt_to_page(ptep));
 
+	/* Save the possible hardware dirty info */
+	if ((level == KVM_PGTABLE_MAX_LEVELS - 1) && stage2_pte_writable(*ptep))
+		mark_page_dirty(mmu->kvm, addr >> PAGE_SHIFT);
+
 	if (need_flush) {
 		stage2_flush_dcache(kvm_pte_follow(pte),
 				    kvm_granule_size(level));
@@ -792,6 +811,30 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 					NULL, NULL);
 }
 
+int kvm_pgtable_stage2_set_dbm(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	int ret;
+	u64 offset;
+
+	ret = stage2_update_leaf_attrs(pgt, addr, size,
+				       KVM_PTE_LEAF_ATTR_HI_S2_DBM, 0, BIT(3),
+				       NULL, NULL);
+	if (!ret)
+		return ret;
+
+	for (offset = 0; offset < size; offset += PAGE_SIZE)
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, 3);
+
+	return 0;
+}
+
+int kvm_pgtable_stage2_clear_dbm(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	return stage2_update_leaf_attrs(pgt, addr, size,
+					0, KVM_PTE_LEAF_ATTR_HI_S2_DBM, BIT(3),
+					NULL, NULL);
+}
+
 kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
@@ -844,6 +887,33 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	return ret;
 }
 
+static int stage2_sync_dirty_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+				    enum kvm_pgtable_walk_flags flag,
+				    void * const arg)
+{
+	kvm_pte_t pte = *ptep;
+	struct kvm *kvm = arg;
+
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	if ((level == KVM_PGTABLE_MAX_LEVELS - 1) && stage2_pte_writable(pte))
+		mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+
+	return 0;
+}
+
+int kvm_pgtable_stage2_sync_dirty(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_sync_dirty_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= pgt->mmu->kvm,
+	};
+
+	return kvm_pgtable_walk(pgt, addr, size, &walker);
+}
+
 static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
-- 
2.19.1

