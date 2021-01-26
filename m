Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15249303E5F
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403964AbhAZNQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:16:01 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11507 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391845AbhAZMrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 07:47:13 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQ5yX1G7wzjDdr;
        Tue, 26 Jan 2021 20:44:04 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 20:45:07 +0800
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
Subject: [RFC PATCH 7/7] kvm: arm64: Start up SW/HW combined dirty log
Date:   Tue, 26 Jan 2021 20:44:44 +0800
Message-ID: <20210126124444.27136-8-zhukeqian1@huawei.com>
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

We do not enable hardware dirty at start (do not add DBM bit). When
an arbitrary PT occurs fault, we execute soft tracking for this PT
and enable hardware tracking for its nearby PTs (Add DBM bit for
nearby 64PTs). Then when sync dirty log, we have known all PTs with
hardware dirty enabled, so we do not need to scan all PTs.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |   6 ++
 arch/arm64/kvm/arm.c              | 125 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c              |   7 +-
 arch/arm64/kvm/reset.c            |   8 +-
 4 files changed, 141 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8fcfab0c2567..e9ea5b546326 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -99,6 +99,8 @@ struct kvm_s2_mmu {
 };
 
 struct kvm_arch_memory_slot {
+	#define HWDBM_GRANULE_SHIFT 6  /* 64 pages per bit */
+	unsigned long *hwdbm_bitmap;
 };
 
 struct kvm_arch {
@@ -565,6 +567,10 @@ struct kvm_vcpu_stat {
 	u64 exits;
 };
 
+int kvm_arm_init_hwdbm_bitmap(struct kvm_memory_slot *memslot);
+void kvm_arm_destroy_hwdbm_bitmap(struct kvm_memory_slot *memslot);
+void kvm_arm_enable_nearby_hwdbm(struct kvm *kvm, gfn_t gfn);
+
 int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 04c44853b103..9e05d45fa6be 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1257,9 +1257,134 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
+static unsigned long kvm_hwdbm_bitmap_bytes(struct kvm_memory_slot *memslot)
+{
+	unsigned long nbits = DIV_ROUND_UP(memslot->npages, 1 << HWDBM_GRANULE_SHIFT);
+
+	return ALIGN(nbits, BITS_PER_LONG) / 8;
+}
+
+static unsigned long *kvm_second_hwdbm_bitmap(struct kvm_memory_slot *memslot)
+{
+	unsigned long len = kvm_hwdbm_bitmap_bytes(memslot);
+
+	return (void *)memslot->arch.hwdbm_bitmap + len;
+}
+
+/*
+ * Allocate twice space. Refer kvm_arch_sync_dirty_log() to see why the
+ * second space is needed.
+ */
+int kvm_arm_init_hwdbm_bitmap(struct kvm_memory_slot *memslot)
+{
+	unsigned long bytes = 2 * kvm_hwdbm_bitmap_bytes(memslot);
+
+	if (!system_supports_hw_dbm())
+		return 0;
+
+	if (memslot->arch.hwdbm_bitmap) {
+		/* Inherited from old memslot */
+		bitmap_clear(memslot->arch.hwdbm_bitmap, 0, bytes * 8);
+	} else {
+		memslot->arch.hwdbm_bitmap = kvzalloc(bytes, GFP_KERNEL_ACCOUNT);
+		if (!memslot->arch.hwdbm_bitmap)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void kvm_arm_destroy_hwdbm_bitmap(struct kvm_memory_slot *memslot)
+{
+	if (!memslot->arch.hwdbm_bitmap)
+		return;
+
+	kvfree(memslot->arch.hwdbm_bitmap);
+	memslot->arch.hwdbm_bitmap = NULL;
+}
+
+/* Add DBM for nearby pagetables but do not across memslot */
+void kvm_arm_enable_nearby_hwdbm(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *memslot;
+
+	memslot = gfn_to_memslot(kvm, gfn);
+	if (memslot && kvm_slot_dirty_track_enabled(memslot) &&
+	    memslot->arch.hwdbm_bitmap) {
+		unsigned long rel_gfn = gfn - memslot->base_gfn;
+		unsigned long dbm_idx = rel_gfn >> HWDBM_GRANULE_SHIFT;
+		unsigned long start_page, npages;
+
+		if (!test_and_set_bit(dbm_idx, memslot->arch.hwdbm_bitmap)) {
+			start_page = dbm_idx << HWDBM_GRANULE_SHIFT;
+			npages = 1 << HWDBM_GRANULE_SHIFT;
+			npages = min(memslot->npages - start_page, npages);
+			kvm_stage2_set_dbm(kvm, memslot, start_page, npages);
+		}
+	}
+}
+
+/*
+ * We have to find a place to clear hwdbm_bitmap, and clear hwdbm_bitmap means
+ * to clear DBM bit of all related pgtables. Note that between we clear DBM bit
+ * and flush TLB, HW dirty log may occur, so we must scan all related pgtables
+ * after flush TLB. Giving above, it's best choice to clear hwdbm_bitmap before
+ * sync HW dirty log.
+ */
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
+	unsigned long *second_bitmap = kvm_second_hwdbm_bitmap(memslot);
+	unsigned long start_page, npages;
+	unsigned int end, rs, re;
+	bool has_hwdbm = false;
+
+	if (!memslot->arch.hwdbm_bitmap)
+		return;
 
+	end = kvm_hwdbm_bitmap_bytes(memslot) * 8;
+	bitmap_clear(second_bitmap, 0, end);
+
+	spin_lock(&kvm->mmu_lock);
+	bitmap_for_each_set_region(memslot->arch.hwdbm_bitmap, rs, re, 0, end) {
+		has_hwdbm = true;
+
+		/*
+		 * Must clear bitmap before clear DBM bit. During we clear DBM
+		 * (it releases the mmu spinlock periodly), SW dirty tracking
+		 * has chance to add DBM which overlaps what we are clearing. So
+		 * if we clear bitmap after clear DBM, we will face a situation
+		 * that bitmap is cleared but DBM are lefted, then we may have
+		 * no chance to scan these lefted pgtables anymore.
+		 */
+		bitmap_clear(memslot->arch.hwdbm_bitmap, rs, re - rs);
+
+		/* Record the bitmap cleared */
+		bitmap_set(second_bitmap, rs, re - rs);
+
+		start_page = rs << HWDBM_GRANULE_SHIFT;
+		npages = (re - rs) << HWDBM_GRANULE_SHIFT;
+		npages = min(memslot->npages - start_page, npages);
+		kvm_stage2_clear_dbm(kvm, memslot, start_page, npages);
+	}
+	spin_unlock(&kvm->mmu_lock);
+
+	if (!has_hwdbm)
+		return;
+
+	/*
+	 * Ensure vcpu write-actions that occur after we clear hwdbm_bitmap can
+	 * be catched by guest memory abort handler.
+	 */
+	kvm_flush_remote_tlbs(kvm);
+
+	spin_lock(&kvm->mmu_lock);
+	bitmap_for_each_set_region(second_bitmap, rs, re, 0, end) {
+		start_page = rs << HWDBM_GRANULE_SHIFT;
+		npages = (re - rs) << HWDBM_GRANULE_SHIFT;
+		npages = min(memslot->npages - start_page, npages);
+		kvm_stage2_sync_dirty(kvm, memslot, start_page, npages);
+	}
+	spin_unlock(&kvm->mmu_lock);
 }
 
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2f8c6770a4dc..1a8702035ddd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -939,6 +939,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
+
+		/* Put here with high probability that nearby PTEs are valid */
+		if (!ret && vma_pagesize == PAGE_SIZE && writable)
+			kvm_arm_enable_nearby_hwdbm(kvm, gfn);
 	} else {
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
@@ -1407,11 +1411,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	spin_unlock(&kvm->mmu_lock);
 out:
 	mmap_read_unlock(current->mm);
-	return ret;
+	return ret ? : kvm_arm_init_hwdbm_bitmap(memslot);
 }
 
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
+	kvm_arm_destroy_hwdbm_bitmap(slot);
 }
 
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 47f3f035f3ea..231d11009db7 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -376,11 +376,11 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
 
 	/*
-	 * Enable the Hardware Access Flag management, unconditionally
-	 * on all CPUs. The features is RES0 on CPUs without the support
-	 * and must be ignored by the CPUs.
+	 * Enable the Hardware Access Flag and Dirty State management
+	 * unconditionally on all CPUs. The features are RES0 on CPUs
+	 * without the support and must be ignored by the CPUs.
 	 */
-	vtcr |= VTCR_EL2_HA;
+	vtcr |= VTCR_EL2_HA | VTCR_EL2_HD;
 
 	/* Set the vmid bits */
 	vtcr |= (kvm_get_vmid_bits() == 16) ?
-- 
2.19.1

