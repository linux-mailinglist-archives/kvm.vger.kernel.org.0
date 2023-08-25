Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794457883F3
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 11:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242472AbjHYJiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 05:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244390AbjHYJhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 05:37:40 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7E31FD5
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 02:37:29 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RXFB336bSz67Q86;
        Fri, 25 Aug 2023 17:33:15 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 25 Aug 2023 10:37:18 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
        <will@kernel.org>, <catalin.marinas@arm.com>,
        <oliver.upton@linux.dev>
CC:     <james.morse@arm.com>, <suzuki.poulose@arm.com>,
        <yuzenghui@huawei.com>, <zhukeqian1@huawei.com>,
        <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 8/8] KVM: arm64: Start up SW/HW combined dirty log
Date:   Fri, 25 Aug 2023 10:35:28 +0100
Message-ID: <20230825093528.1637-9-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
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

When a user has enabled HW DBM support for live migration,set the
HW DBM bit for nearby pages(64 pages) for a write faulting page.
We track the DBM set pages in a separate bitmap and uses that during
sync dirty log avoiding a full scan of PTEs.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |   6 ++
 arch/arm64/kvm/arm.c              | 125 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c      |  10 +--
 arch/arm64/kvm/mmu.c              |  11 ++-
 4 files changed, 144 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 17ac53150a1d..5f0be57eebc4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -181,6 +181,8 @@ struct kvm_s2_mmu {
 };
 
 struct kvm_arch_memory_slot {
+	#define HWDBM_GRANULE_SHIFT 6  /* 64 pages per bit */
+	unsigned long *hwdbm_bitmap;
 };
 
 /**
@@ -901,6 +903,10 @@ struct kvm_vcpu_stat {
 	u64 exits;
 };
 
+int kvm_arm_init_hwdbm_bitmap(struct kvm *kvm, struct kvm_memory_slot *memslot);
+void kvm_arm_destroy_hwdbm_bitmap(struct kvm_memory_slot *memslot);
+void kvm_arm_enable_nearby_hwdbm(struct kvm *kvm, gfn_t gfn);
+
 void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0dbf2cda40d7..ab1e2da3bf0d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1540,9 +1540,134 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
+int kvm_arm_init_hwdbm_bitmap(struct kvm *kvm, struct kvm_memory_slot *memslot)
+{
+	unsigned long bytes = 2 * kvm_hwdbm_bitmap_bytes(memslot);
+
+	if (!kvm->arch.mmu.hwdbm_enabled)
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
+
+	end = kvm_hwdbm_bitmap_bytes(memslot) * 8;
+	bitmap_clear(second_bitmap, 0, end);
+
+	write_lock(&kvm->mmu_lock);
+	for_each_set_bitrange(rs, re, memslot->arch.hwdbm_bitmap, end) {
+		has_hwdbm = true;
 
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
+	write_unlock(&kvm->mmu_lock);
+
+	if (!has_hwdbm)
+		return;
+
+	/*
+	 * Ensure vcpu write-actions that occur after we clear hwdbm_bitmap can
+	 * be catched by guest memory abort handler.
+	 */
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
+
+	read_lock(&kvm->mmu_lock);
+	for_each_set_bitrange(rs, re, second_bitmap, end) {
+		start_page = rs << HWDBM_GRANULE_SHIFT;
+		npages = (re - rs) << HWDBM_GRANULE_SHIFT;
+		npages = min(memslot->npages - start_page, npages);
+		kvm_stage2_sync_dirty(kvm, memslot, start_page, npages);
+	}
+	read_unlock(&kvm->mmu_lock);
 }
 
 static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4552bfb1f274..330912d647c7 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -651,10 +651,10 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 
 #ifdef CONFIG_ARM64_HW_AFDBM
 	/*
-	 * Enable the Hardware Access Flag management, unconditionally
-	 * on all CPUs. In systems that have asymmetric support for the feature
-	 * this allows KVM to leverage hardware support on the subset of cores
-	 * that implement the feature.
+	 * Enable the Hardware Access Flag management and Dirty State management,
+	 * unconditionally on all CPUs. In systems that have asymmetric support for
+	 * the feature this allows KVM to leverage hardware support on the subset of
+	 * cores that implement the feature.
 	 *
 	 * The architecture requires VTCR_EL2.HA to be RES0 (thus ignored by
 	 * hardware) on implementations that do not advertise support for the
@@ -663,7 +663,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	 * HAFDBS. Here be dragons.
 	 */
 	if (!cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
-		vtcr |= VTCR_EL2_HA;
+		vtcr |= VTCR_EL2_HA | VTCR_EL2_HD;
 #endif /* CONFIG_ARM64_HW_AFDBM */
 
 	/* Set the vmid bits */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 34251932560e..b2fdcd762d70 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1569,14 +1569,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
 	 * kvm_pgtable_stage2_map() should be called to change block size.
 	 */
-	if (fault_status == ESR_ELx_FSC_PERM && vma_pagesize == fault_granule)
+	if (fault_status == ESR_ELx_FSC_PERM && vma_pagesize == fault_granule) {
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
-	else
+		/* Try to enable HW DBM for nearby pages */
+		if (!ret && vma_pagesize == PAGE_SIZE && writable)
+			kvm_arm_enable_nearby_hwdbm(kvm, gfn);
+	} else {
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     memcache,
 					     KVM_PGTABLE_WALK_HANDLE_FAULT |
 					     KVM_PGTABLE_WALK_SHARED);
+	}
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
@@ -2046,11 +2050,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	} while (hva < reg_end);
 
 	mmap_read_unlock(current->mm);
-	return ret;
+	return ret ? : kvm_arm_init_hwdbm_bitmap(kvm, new);
 }
 
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
+	kvm_arm_destroy_hwdbm_bitmap(slot);
 }
 
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
-- 
2.34.1

