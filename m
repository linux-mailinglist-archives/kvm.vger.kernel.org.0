Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE15212572
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 15:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgGBN5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 09:57:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7357 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729412AbgGBN5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 09:57:09 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C489A4599281558D6B9C;
        Thu,  2 Jul 2020 21:56:15 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 21:56:05 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Steven Price <steven.price@arm.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <liangpeng10@huawei.com>, <zhengxiang9@huawei.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v2 4/8] KVM: arm64: Save stage2 PTE dirty status if it is covered
Date:   Thu, 2 Jul 2020 21:55:52 +0800
Message-ID: <20200702135556.36896-5-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200702135556.36896-1-zhukeqian1@huawei.com>
References: <20200702135556.36896-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_set_pte is called to replace a target PTE with a desired one.
We always do this without changing the desired one, but if dirty
status set by hardware is covered, let caller know it.

There are two types of operations will change PTE and may cover
dirty status set by hardware.

1. Stage2 PTE unmapping: Page table merging (revert of huge page
table dissolving), kvm_unmap_hva_range() and so on.

2. Stage2 PTE changing: including user_mem_abort(), kvm_mmu_notifier
_change_pte() and so on.

All operations above will invoke kvm_set_pte() finally. We should
save the dirty status into memslot bitmap.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  5 ++++
 arch/arm64/kvm/mmu.c             | 42 ++++++++++++++++++++++++++++----
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index a1b6131d980c..adb5c8edb29e 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -295,6 +295,11 @@ static inline bool kvm_mmu_hw_dbm_enabled(struct kvm *kvm)
 	return arm_mmu_hw_dbm_supported() && !!(kvm->arch.vtcr & VTCR_EL2_HD);
 }
 
+static inline bool kvm_s2pte_dbm(pte_t *ptep)
+{
+	return !!(READ_ONCE(pte_val(*ptep)) & PTE_DBM);
+}
+
 #define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
 
 #ifdef __PAGETABLE_PMD_FOLDED
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ab8a6ceecbd8..d0c34549ef3b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -194,10 +194,26 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
 	put_page(virt_to_page(pmd));
 }
 
-static inline void kvm_set_pte(pte_t *ptep, pte_t new_pte)
+/**
+ * @ret: true if dirty status set by hardware is covered.
+ */
+static inline bool kvm_set_pte(pte_t *ptep, pte_t new_pte)
 {
-	WRITE_ONCE(*ptep, new_pte);
-	dsb(ishst);
+	pteval_t old_pteval;
+	bool old_logging, new_no_write;
+
+	old_logging = IS_ENABLED(CONFIG_ARM64_HW_AFDBM) &&
+		arm_mmu_hw_dbm_supported() && kvm_s2pte_dbm(ptep);
+	new_no_write = pte_none(new_pte) || kvm_s2pte_readonly(&new_pte);
+
+	if (!old_logging || !new_no_write) {
+		WRITE_ONCE(*ptep, new_pte);
+		dsb(ishst);
+		return false;
+	}
+
+	old_pteval = xchg(&pte_val(*ptep), pte_val(new_pte));
+	return !kvm_s2pte_readonly(&__pte(old_pteval));
 }
 
 static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
@@ -260,15 +276,23 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 {
 	phys_addr_t start_addr = addr;
 	pte_t *pte, *start_pte;
+	bool dirty_covered;
+	int idx;
 
 	start_pte = pte = pte_offset_kernel(pmd, addr);
 	do {
 		if (!pte_none(*pte)) {
 			pte_t old_pte = *pte;
 
-			kvm_set_pte(pte, __pte(0));
+			dirty_covered = kvm_set_pte(pte, __pte(0));
 			kvm_tlb_flush_vmid_ipa(kvm, addr);
 
+			if (dirty_covered) {
+				idx = srcu_read_lock(&kvm->srcu);
+				mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+				srcu_read_unlock(&kvm->srcu, idx);
+			}
+
 			/* No need to invalidate the cache for device mappings */
 			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
 				kvm_flush_dcache_pte(old_pte);
@@ -1354,6 +1378,8 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	pte_t *pte, old_pte;
 	bool iomap = flags & KVM_S2PTE_FLAG_IS_IOMAP;
 	bool logging_active = flags & KVM_S2_FLAG_LOGGING_ACTIVE;
+	bool dirty_covered;
+	int idx;
 
 	VM_BUG_ON(logging_active && !cache);
 
@@ -1419,8 +1445,14 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 		if (pte_val(old_pte) == pte_val(*new_pte))
 			return 0;
 
-		kvm_set_pte(pte, __pte(0));
+		dirty_covered = kvm_set_pte(pte, __pte(0));
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
+
+		if (dirty_covered) {
+			idx = srcu_read_lock(&kvm->srcu);
+			mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+			srcu_read_unlock(&kvm->srcu, idx);
+		}
 	} else {
 		get_page(virt_to_page(pte));
 	}
-- 
2.19.1

