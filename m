Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7462FFF03
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 10:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbhAVIjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 03:39:53 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11179 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbhAVIiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 03:38:02 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DMXdn4gT6zl8Rv;
        Fri, 22 Jan 2021 16:35:41 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Fri, 22 Jan 2021 16:37:01 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: [RFC PATCH] kvm: arm64: Try stage2 block mapping for host device MMIO
Date:   Fri, 22 Jan 2021 16:36:50 +0800
Message-ID: <20210122083650.21812-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MMIO region of a device maybe huge (GB level), try to use block
mapping in stage2 to speedup both map and unmap.

Especially for unmap, it performs TLBI right after each invalidation
of PTE. If all mapping is of PAGE_SIZE, it takes much time to handle
GB level range.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 15 +++++++++++++++
 arch/arm64/kvm/mmu.c                 | 12 ++++++++----
 3 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 52ab38db04c7..2266ac45f10c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -82,6 +82,17 @@ struct kvm_pgtable_walker {
 	const enum kvm_pgtable_walk_flags	flags;
 };
 
+/**
+ * kvm_supported_pgsize() - Get the max supported page size of a mapping.
+ * @pgt:	Initialised page-table structure.
+ * @addr:	Virtual address at which to place the mapping.
+ * @end:	End virtual address of the mapping.
+ * @phys:	Physical address of the memory to map.
+ *
+ * The smallest return value is PAGE_SIZE.
+ */
+u64 kvm_supported_pgsize(struct kvm_pgtable *pgt, u64 addr, u64 end, u64 phys);
+
 /**
  * kvm_pgtable_hyp_init() - Initialise a hypervisor stage-1 page-table.
  * @pgt:	Uninitialised page-table structure to initialise.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bdf8e55ed308..ab11609b9b13 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -81,6 +81,21 @@ static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
 	return IS_ALIGNED(addr, granule) && IS_ALIGNED(phys, granule);
 }
 
+u64 kvm_supported_pgsize(struct kvm_pgtable *pgt, u64 addr, u64 end, u64 phys)
+{
+	u32 lvl;
+	u64 pgsize = PAGE_SIZE;
+
+	for (lvl = pgt->start_level; lvl < KVM_PGTABLE_MAX_LEVELS; lvl++) {
+		if (kvm_block_mapping_supported(addr, end, phys, lvl)) {
+			pgsize = kvm_granule_size(lvl);
+			break;
+		}
+	}
+
+	return pgsize;
+}
+
 static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
 {
 	u64 shift = kvm_granule_shift(level);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7d2257cc5438..80b403fc8e64 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -499,7 +499,8 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable)
 {
-	phys_addr_t addr;
+	phys_addr_t addr, end;
+	unsigned long pgsize;
 	int ret = 0;
 	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
 	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
@@ -509,21 +510,24 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 
 	size += offset_in_page(guest_ipa);
 	guest_ipa &= PAGE_MASK;
+	end = guest_ipa + size;
 
-	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
+	for (addr = guest_ipa; addr < end; addr += pgsize) {
 		ret = kvm_mmu_topup_memory_cache(&cache,
 						 kvm_mmu_cache_min_pages(kvm));
 		if (ret)
 			break;
 
+		pgsize = kvm_supported_pgsize(pgt, addr, end, pa);
+
 		spin_lock(&kvm->mmu_lock);
-		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
+		ret = kvm_pgtable_stage2_map(pgt, addr, pgsize, pa, prot,
 					     &cache);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
 			break;
 
-		pa += PAGE_SIZE;
+		pa += pgsize;
 	}
 
 	kvm_mmu_free_memory_cache(&cache);
-- 
2.19.1

