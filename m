Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6F819201E
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 05:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgCYE0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 00:26:50 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12190 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbgCYE0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 00:26:49 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3ACB7F133C3423769A02;
        Wed, 25 Mar 2020 12:26:44 +0800 (CST)
Received: from linux-kDCJWP.huawei.com (10.175.104.212) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 25 Mar 2020 12:26:37 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jay Zhou <jianjay.zhou@huawei.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH 3/3] KVM/arm64: Only set bits of dirty bitmap with valid translation entries
Date:   Wed, 25 Mar 2020 12:24:23 +0800
Message-ID: <20200325042423.12181-4-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200325042423.12181-1-zhukeqian1@huawei.com>
References: <20200325042423.12181-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.212]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM_DIRTY_LOG_INITIALLY_SET is enabled, we can only report these
pages that have valid translation entries to userspace, then userspace
don't need to do zero-check on other pages during VM migration.

Under the Huawei Kunpeng 920 2.6GHz platform, I did some tests on 128G
Linux VMs with different page size.

About the time of enabling dirty log: The memory pressure is 127GB.
Page size   Before      After
   4K        1.8ms      341ms
   2M        1.8ms       4ms
   1G        1.8ms       2ms

About the time of migration: The memory pressure is 3GB and the migration
bandwidth is 500MB/s.
Page size   Before    After
   4K        21s       6s
   2M        21s       6s
   1G        21s       7s

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 virt/kvm/arm/mmu.c | 161 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 137 insertions(+), 24 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 6c84de442a0e..0c7a5faf8609 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1413,34 +1413,85 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 	return false;
 }
 
+enum s2_operation {
+	S2_OP_WP,  /* write protect page tables */
+	S2_OP_MD,  /* mark dirty bitmap in memslot */
+};
+
 /**
- * stage2_wp_ptes - write protect PMD range
+ * mark_range_dirty - mark a range of dirty bitmap
+ * @kvm:	kvm instance for the VM
+ * @addr:	range start address
+ * @end:	range end address
+ *
+ * note: addr and end should belong to the same memslot.
+ */
+static void mark_range_dirty(struct kvm *kvm,
+			     phys_addr_t addr,
+			     phys_addr_t end)
+{
+	gfn_t gfn;
+	unsigned int start, nbits;
+	struct kvm_memory_slot *memslot = NULL;
+
+	gfn = addr >> PAGE_SHIFT;
+	memslot = gfn_to_memslot(kvm, gfn);
+
+	if (memslot && memslot->dirty_bitmap) {
+		start = gfn - memslot->base_gfn;
+		nbits = DIV_ROUND_UP(end, PAGE_SIZE) - gfn;
+		bitmap_set(memslot->dirty_bitmap, start, nbits);
+	}
+}
+
+/**
+ * stage2_op_ptes - do an operation on PMD range
+ * @kvm:	kvm instance for the VM
+ * @op: 	the operation wanted
  * @pmd:	pointer to pmd entry
  * @addr:	range start address
  * @end:	range end address
  */
-static void stage2_wp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
+static void stage2_op_ptes(struct kvm *kvm,
+			   enum s2_operation op,
+			   pmd_t *pmd,
+			   phys_addr_t addr,
+			   phys_addr_t end)
 {
 	pte_t *pte;
 
 	pte = pte_offset_kernel(pmd, addr);
 	do {
-		if (!pte_none(*pte)) {
+		if (pte_none(*pte))
+			continue;
+
+		switch (op) {
+		case S2_OP_WP:
 			if (!kvm_s2pte_readonly(pte))
 				kvm_set_s2pte_readonly(pte);
+			break;
+		case S2_OP_MD:
+			mark_range_dirty(kvm, addr, addr + PAGE_SIZE);
+			break;
+		default:
+			break;
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
 
 /**
- * stage2_wp_pmds - write protect PUD range
- * kvm:		kvm instance for the VM
+ * stage2_op_pmds - do an operation on PUD range
+ * @kvm:	kvm instance for the VM
+ * @op: 	the operation wanted
  * @pud:	pointer to pud entry
  * @addr:	range start address
  * @end:	range end address
  */
-static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
-			   phys_addr_t addr, phys_addr_t end)
+static void stage2_op_pmds(struct kvm *kvm,
+			   enum s2_operation op,
+			   pud_t *pud,
+			   phys_addr_t addr,
+			   phys_addr_t end)
 {
 	pmd_t *pmd;
 	phys_addr_t next;
@@ -1449,25 +1500,40 @@ static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
 
 	do {
 		next = stage2_pmd_addr_end(kvm, addr, end);
-		if (!pmd_none(*pmd)) {
-			if (pmd_thp_or_huge(*pmd)) {
+		if (pmd_none(*pmd))
+			continue;
+
+		if (pmd_thp_or_huge(*pmd)) {
+			switch (op) {
+			case S2_OP_WP:
 				if (!kvm_s2pmd_readonly(pmd))
 					kvm_set_s2pmd_readonly(pmd);
-			} else {
-				stage2_wp_ptes(pmd, addr, next);
+				break;
+			case S2_OP_MD:
+				mark_range_dirty(kvm, addr, next);
+				break;
+			default:
+				break;
 			}
+		} else {
+			stage2_op_ptes(kvm, op, pmd, addr, next);
 		}
 	} while (pmd++, addr = next, addr != end);
 }
 
 /**
- * stage2_wp_puds - write protect PGD range
+ * stage2_op_puds - do an operation on PGD range
+ * @kvm:	kvm instance for the VM
+ * @op: 	the operation wanted
  * @pgd:	pointer to pgd entry
  * @addr:	range start address
  * @end:	range end address
  */
-static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd,
-			    phys_addr_t addr, phys_addr_t end)
+static void  stage2_op_puds(struct kvm *kvm,
+			    enum s2_operation op,
+			    pgd_t *pgd,
+			    phys_addr_t addr,
+			    phys_addr_t end)
 {
 	pud_t *pud;
 	phys_addr_t next;
@@ -1475,24 +1541,38 @@ static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd,
 	pud = stage2_pud_offset(kvm, pgd, addr);
 	do {
 		next = stage2_pud_addr_end(kvm, addr, end);
-		if (!stage2_pud_none(kvm, *pud)) {
-			if (stage2_pud_huge(kvm, *pud)) {
+		if (stage2_pud_none(kvm, *pud))
+			continue;
+
+		if (stage2_pud_huge(kvm, *pud)) {
+			switch (op) {
+			case S2_OP_WP:
 				if (!kvm_s2pud_readonly(pud))
 					kvm_set_s2pud_readonly(pud);
-			} else {
-				stage2_wp_pmds(kvm, pud, addr, next);
+				break;
+			case S2_OP_MD:
+				mark_range_dirty(kvm, addr, next);
+				break;
+			default:
+				break;
 			}
+		} else {
+			stage2_op_pmds(kvm, op, pud, addr, next);
 		}
 	} while (pud++, addr = next, addr != end);
 }
 
 /**
- * stage2_wp_range() - write protect stage2 memory region range
+ * stage2_op_range() - do an operation on stage2 memory region range
  * @kvm:	The KVM pointer
+ * @op: 	The operation wanted
  * @addr:	Start address of range
  * @end:	End address of range
  */
-static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
+static void stage2_op_range(struct kvm *kvm,
+			    enum s2_operation op,
+			    phys_addr_t addr,
+			    phys_addr_t end)
 {
 	pgd_t *pgd;
 	phys_addr_t next;
@@ -1513,7 +1593,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 			break;
 		next = stage2_pgd_addr_end(kvm, addr, end);
 		if (stage2_pgd_present(kvm, *pgd))
-			stage2_wp_puds(kvm, pgd, addr, next);
+			stage2_op_puds(kvm, op, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
@@ -1543,11 +1623,44 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	stage2_wp_range(kvm, start, end);
+	stage2_op_range(kvm, S2_OP_WP, start, end);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
 
+/**
+ * kvm_mmu_md_memory_region() - mark dirty bitmap for memory slot
+ * @kvm:	The KVM pointer
+ * @slot:	The memory slot to mark dirty
+ *
+ * Called to mark dirty bitmap after memory region KVM_MEM_LOG_DIRTY_PAGES
+ * operation is called and kvm_dirty_log_manual_protect_and_init_set is
+ * true. After this function returns, a bit of dirty bitmap is set if its
+ * corresponding page table (including PUD, PMD and PTEs) is present.
+ *
+ * Afterwards read of dirty page log can be called and present PUD, PMD and
+ * PTEs can be write protected by userspace manually.
+ *
+ * Acquires kvm_mmu_lock. Called with kvm->slots_lock mutex acquired,
+ * serializing operations for VM memory regions.
+ */
+static void kvm_mmu_md_memory_region(struct kvm *kvm, int slot)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
+	phys_addr_t start, end;
+
+	if (WARN_ON_ONCE(!memslot))
+		return;
+
+	start = memslot->base_gfn << PAGE_SHIFT;
+	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+
+	spin_lock(&kvm->mmu_lock);
+	stage2_op_range(kvm, S2_OP_MD, start, end);
+	spin_unlock(&kvm->mmu_lock);
+}
+
 /**
  * kvm_mmu_write_protect_pt_masked() - write protect dirty pages
  * @kvm:	The KVM pointer
@@ -1567,7 +1680,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
-	stage2_wp_range(kvm, start, end);
+	stage2_op_range(kvm, S2_OP_WP, start, end);
 }
 
 /*
@@ -2274,7 +2387,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 			 * write protect any pages because they're reported
 			 * as dirty here.
 			 */
-			bitmap_set(new->dirty_bitmap, 0, new->npages);
+			kvm_mmu_md_memory_region(kvm, mem->slot);
 		}
 	}
 }
-- 
2.19.1

