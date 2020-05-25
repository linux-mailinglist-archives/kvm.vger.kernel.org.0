Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470AF1E0CDB
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 13:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390206AbgEYLZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 07:25:33 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47108 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390175AbgEYLZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 07:25:17 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8C55850255F4F8827112;
        Mon, 25 May 2020 19:25:14 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.173.221.230) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Mon, 25 May 2020 19:25:04 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <zhengxiang9@huawei.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Peng Liang <liangpeng10@huawei.com>
Subject: [RFC PATCH 3/7] KVM: arm64: Traverse page table entries when sync dirty log
Date:   Mon, 25 May 2020 19:24:02 +0800
Message-ID: <20200525112406.28224-4-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200525112406.28224-1-zhukeqian1@huawei.com>
References: <20200525112406.28224-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For hardware management of dirty state, dirty state is stored in
page table entries. We have to traverse page table entries when
sync dirty log.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 virt/kvm/arm/arm.c                |   6 +-
 virt/kvm/arm/mmu.c                | 127 ++++++++++++++++++++++++++++++
 3 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 32c8a675e5a4..916617d3fed6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -480,6 +480,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
 
 void force_vm_exit(const cpumask_t *mask);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
+int kvm_mmu_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
 
 int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		int exception_index);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 48d0ec44ad77..975311fa3a27 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1191,7 +1191,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
-
+#ifdef CONFIG_ARM64_HW_AFDBM
+	if (kvm_hw_dbm_enabled()) {
+		kvm_mmu_sync_dirty_log(kvm, memslot);
+	}
+#endif
 }
 
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index dc97988eb2e0..ff8df9702e04 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2266,6 +2266,133 @@ int kvm_mmu_init(void)
 	return err;
 }
 
+#ifdef CONFIG_ARM64_HW_AFDBM
+/**
+ * stage2_sync_dirty_log_ptes() - synchronize dirty log from PMD range
+ * @kvm:        The KVM pointer
+ * @pmd:	pointer to pmd entry
+ * @addr:	range start address
+ * @end:	range end address
+ */
+static void stage2_sync_dirty_log_ptes(struct kvm *kvm, pmd_t *pmd,
+				       phys_addr_t addr, phys_addr_t end)
+{
+	pte_t *pte;
+
+	pte = pte_offset_kernel(pmd, addr);
+	do {
+		if (!pte_none(*pte) && !kvm_s2pte_readonly(pte)) {
+			mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+		}
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+}
+
+/**
+ * stage2_sync_dirty_log_pmds() - synchronize dirty log from PUD range
+ * @kvm:	The KVM pointer
+ * @pud:	pointer to pud entry
+ * @addr:	range start address
+ * @end:	range end address
+ */
+static void stage2_sync_dirty_log_pmds(struct kvm *kvm, pud_t *pud,
+				       phys_addr_t addr, phys_addr_t end)
+{
+	pmd_t *pmd;
+	phys_addr_t next;
+
+	pmd = stage2_pmd_offset(kvm, pud, addr);
+	do {
+		next = stage2_pmd_addr_end(kvm, addr, end);
+		if (!pmd_none(*pmd) && !pmd_thp_or_huge(*pmd)) {
+			stage2_sync_dirty_log_ptes(kvm, pmd, addr, next);
+		}
+	} while (pmd++, addr = next, addr != end);
+}
+
+/**
+ * stage2_sync_dirty_log_puds() - synchronize dirty log from PGD range
+ * @kvm:	The KVM pointer
+ * @pgd:	pointer to pgd entry
+ * @addr:	range start address
+ * @end:	range end address
+ */
+static void stage2_sync_dirty_log_puds(struct kvm *kvm, pgd_t *pgd,
+				       phys_addr_t addr, phys_addr_t end)
+{
+	pud_t *pud;
+	phys_addr_t next;
+
+	pud = stage2_pud_offset(kvm, pgd, addr);
+	do {
+		next = stage2_pud_addr_end(kvm, addr, end);
+		if (!stage2_pud_none(kvm, *pud) && !stage2_pud_huge(kvm, *pud)) {
+			stage2_sync_dirty_log_pmds(kvm, pud, addr, next);
+		}
+	} while (pud++, addr = next, addr != end);
+}
+
+/**
+ * stage2_sync_dirty_log_range() - synchronize dirty log from stage2 memory
+ * region range
+ * @kvm:	The KVM pointer
+ * @addr:	Start address of range
+ * @end:	End address of range
+ */
+static void stage2_sync_dirty_log_range(struct kvm *kvm, phys_addr_t addr,
+					phys_addr_t end)
+{
+	pgd_t *pgd;
+	phys_addr_t next;
+
+	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
+	do {
+		/*
+		 * Release kvm_mmu_lock periodically if the memory region is
+		 * large. Otherwise, we may see kernel panics with
+		 * CONFIG_DETECT_HUNG_TASK, CONFIG_LOCKUP_DETECTOR,
+		 * CONFIG_LOCKDEP. Additionally, holding the lock too long
+		 * will also starve other vCPUs. We have to also make sure
+		 * that the page tables are not freed while we released
+		 * the lock.
+		 */
+		cond_resched_lock(&kvm->mmu_lock);
+		if (!READ_ONCE(kvm->arch.pgd))
+			break;
+		next = stage2_pgd_addr_end(kvm, addr, end);
+		if (stage2_pgd_present(kvm, *pgd))
+			stage2_sync_dirty_log_puds(kvm, pgd, addr, next);
+	} while (pgd++, addr = next, addr != end);
+}
+
+/**
+ * kvm_mmu_sync_dirty_log() - synchronize dirty log from stage2 entries for
+ * memory slot
+ * @kvm:	The KVM pointer
+ * @slot:	The memory slot to synchronize dirty log
+ *
+ * Called to synchronize dirty log (marked by hw) after memory region
+ * KVM_GET_DIRTY_LOG operation is called. After this function returns
+ * all dirty log information (for that hw will modify page tables during
+ * this routine, it is true only when guest is stopped, but it is OK
+ * because we won't miss dirty log finally.) are collected into memslot
+ * dirty_bitmap. Afterwards dirty_bitmap can be copied to userspace.
+ *
+ * Acquires kvm_mmu_lock. Called with kvm->slots_lock mutex acquired,
+ * serializing operations for VM memory regions.
+ */
+int kvm_mmu_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+{
+	phys_addr_t start = memslot->base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+
+	spin_lock(&kvm->mmu_lock);
+	stage2_sync_dirty_log_range(kvm, start, end);
+	spin_unlock(&kvm->mmu_lock);
+
+	return 0;
+}
+#endif /* CONFIG_ARM64_HW_AFDBM */
+
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_userspace_memory_region *mem,
 				   struct kvm_memory_slot *old,
-- 
2.19.1

