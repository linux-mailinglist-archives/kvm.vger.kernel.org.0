Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D73B165642
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 05:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgBTE2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 23:28:43 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10656 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727370AbgBTE2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 23:28:43 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 308414037D832686A4A8;
        Thu, 20 Feb 2020 12:28:39 +0800 (CST)
Received: from localhost (10.133.205.84) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 12:28:31 +0800
From:   Jay Zhou <jianjay.zhou@huawei.com>
To:     <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <peterx@redhat.com>,
        <wangxinxin.wang@huawei.com>, <weidong.huang@huawei.com>,
        <jianjay.zhou@huawei.com>, <sean.j.christopherson@intel.com>,
        <liu.jinsong@huawei.com>
Subject: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
Date:   Thu, 20 Feb 2020 12:28:28 +0800
Message-ID: <20200220042828.27464-1-jianjay.zhou@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.205.84]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It could take kvm->mmu_lock for an extended period of time when
enabling dirty log for the first time. The main cost is to clear
all the D-bits of last level SPTEs. This situation can benefit from
manual dirty log protect as well, which can reduce the mmu_lock
time taken. The sequence is like this:

1. Initialize all the bits of the dirty bitmap to 1 when enabling
   dirty log for the first time
2. Only write protect the huge pages
3. KVM_GET_DIRTY_LOG returns the dirty bitmap info
4. KVM_CLEAR_DIRTY_LOG will clear D-bit for each of the leaf level
   SPTEs gradually in small chunks

Under the Intel(R) Xeon(R) Gold 6152 CPU @ 2.10GHz environment,
I did some tests with a 128G windows VM and counted the time taken
of memory_global_dirty_log_start, here is the numbers:

VM Size        Before    After optimization
128G           460ms     10ms

Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
---
v2:
  * add new bit to KVM_ENABLE_CAP for KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 [Paolo]
  * support non-PML path [Peter]
  * delete the unnecessary ifdef and make the initialization of bitmap
    more clear [Sean]
  * document the new bits and tweak the testcase

 Documentation/virt/kvm/api.rst               | 23 +++++++++++++++++------
 arch/x86/kvm/mmu/mmu.c                       |  8 ++++++--
 arch/x86/kvm/vmx/vmx.c                       |  3 ++-
 include/linux/kvm_host.h                     |  7 ++++++-
 tools/testing/selftests/kvm/dirty_log_test.c |  3 ++-
 virt/kvm/kvm_main.c                          | 25 ++++++++++++++++++-------
 6 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 97a72a5..1afd310 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1267,9 +1267,11 @@ pages in the host.
 The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
 KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
 writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
-use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
-to make a new slot read-only.  In this case, writes to this memory will be
-posted to userspace as KVM_EXIT_MMIO exits.
+use it.  It will be different if the KVM_DIRTY_LOG_INITIALLY_SET flag of
+KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 is set.  For more information, see the
+description of the capability.  The latter can be set, if KVM_CAP_READONLY_MEM
+capability allows it, to make a new slot read-only.  In this case, writes to
+this memory will be posted to userspace as KVM_EXIT_MMIO exits.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
@@ -5704,10 +5706,19 @@ and injected exceptions.
 :Architectures: x86, arm, arm64, mips
 :Parameters: args[0] whether feature should be enabled or not
 
-With this capability enabled, KVM_GET_DIRTY_LOG will not automatically
+Valid flags are::
+
+  #define KVM_DIRTY_LOG_MANUAL_PROTECT (1 << 0)
+  #define KVM_DIRTY_LOG_INITIALLY_SET (1 << 1)
+
+With KVM_DIRTY_LOG_MANUAL_PROTECT set, KVM_GET_DIRTY_LOG will not automatically
 clear and write-protect all pages that are returned as dirty.
 Rather, userspace will have to do this operation separately using
-KVM_CLEAR_DIRTY_LOG.
+KVM_CLEAR_DIRTY_LOG.  With KVM_DIRTY_LOG_INITIALLY_SET set, all the bits of
+the dirty bitmap will be initialized to 1 when created, dirty logging will be
+enabled gradually in small chunks using KVM_CLEAR_DIRTY_LOG ioctl.  However,
+the KVM_DIRTY_LOG_INITIALLY_SET depends on KVM_DIRTY_LOG_MANUAL_PROTECT, it
+can not be set individually and supports x86 only for now.
 
 At the cost of a slightly more complicated operation, this provides better
 scalability and responsiveness for two reasons.  First,
@@ -5716,7 +5727,7 @@ than requiring to sync a full memslot; this ensures that KVM does not
 take spinlocks for an extended period of time.  Second, in some cases a
 large amount of time can pass between a call to KVM_GET_DIRTY_LOG and
 userspace actually using the data in the page.  Pages can be modified
-during this time, which is inefficint for both the guest and userspace:
+during this time, which is inefficient for both the guest and userspace:
 the guest will incur a higher penalty due to write protection faults,
 while userspace can see false reports of dirty pages.  Manual reprotection
 helps reducing this time, improving guest performance and reducing the
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 87e9ba2..f9c120e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5865,8 +5865,12 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	bool flush;
 
 	spin_lock(&kvm->mmu_lock);
-	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
-				      false);
+	if (kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET)
+		flush = slot_handle_large_level(kvm, memslot,
+						slot_rmap_write_protect, false);
+	else
+		flush = slot_handle_all_level(kvm, memslot,
+						slot_rmap_write_protect, false);
 	spin_unlock(&kvm->mmu_lock);
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3be25ec..fcc585a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7201,7 +7201,8 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 static void vmx_slot_enable_log_dirty(struct kvm *kvm,
 				     struct kvm_memory_slot *slot)
 {
-	kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
+	if (!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET))
+		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
 	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e89eb67..a555b52 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -39,6 +39,11 @@
 #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
 #endif
 
+#define KVM_DIRTY_LOG_MANUAL_PROTECT (1 << 0)
+#define KVM_DIRTY_LOG_INITIALLY_SET (1 << 1)
+#define KVM_DIRTY_LOG_MANUAL_CAPS (KVM_DIRTY_LOG_MANUAL_PROTECT | \
+				KVM_DIRTY_LOG_INITIALLY_SET)
+
 /*
  * The bit 16 ~ bit 31 of kvm_memory_region::flags are internally used
  * in kvm, other bits are visible for userspace which are defined in
@@ -493,7 +498,7 @@ struct kvm {
 #endif
 	long tlbs_dirty;
 	struct list_head devices;
-	bool manual_dirty_log_protect;
+	u64 manual_dirty_log_protect;
 	struct dentry *debugfs_dentry;
 	struct kvm_stat_data **debugfs_stat_data;
 	struct srcu_struct srcu;
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 5614222..2a493c1 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -317,10 +317,11 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	host_bmap_track = bitmap_alloc(host_num_pages);
 
 #ifdef USE_CLEAR_DIRTY_LOG
+	int ret = kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
 	struct kvm_enable_cap cap = {};
 
 	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
-	cap.args[0] = 1;
+	cap.args[0] = ret;
 	vm_enable_cap(vm, &cap);
 #endif
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70f03ce..f2631d0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -862,7 +862,7 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
  * Allocation size is twice as large as the actual dirty bitmap size.
  * See x86's kvm_vm_ioctl_get_dirty_log() why this is needed.
  */
-static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
+static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 {
 	unsigned long dirty_bytes = 2 * kvm_dirty_bitmap_bytes(memslot);
 
@@ -1094,8 +1094,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	/* Allocate page dirty bitmap if needed */
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
-		if (kvm_create_dirty_bitmap(&new) < 0)
+		if (kvm_alloc_dirty_bitmap(&new))
 			goto out_free;
+
+		if (kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET)
+			bitmap_set(new.dirty_bitmap, 0, new.npages);
 	}
 
 	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
@@ -1255,7 +1258,7 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 
 	n = kvm_dirty_bitmap_bytes(memslot);
 	*flush = false;
-	if (kvm->manual_dirty_log_protect) {
+	if (kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_MANUAL_PROTECT) {
 		/*
 		 * Unlike kvm_get_dirty_log, we always return false in *flush,
 		 * because no flush is needed until KVM_CLEAR_DIRTY_LOG.  There
@@ -3310,9 +3313,6 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_IOEVENTFD_ANY_LENGTH:
 	case KVM_CAP_CHECK_EXTENSION_VM:
 	case KVM_CAP_ENABLE_CAP_VM:
-#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
-#endif
 		return 1;
 #ifdef CONFIG_KVM_MMIO
 	case KVM_CAP_COALESCED_MMIO:
@@ -3320,6 +3320,10 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_COALESCED_PIO:
 		return 1;
 #endif
+#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
+		return KVM_DIRTY_LOG_MANUAL_CAPS;
+#endif
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
 	case KVM_CAP_IRQ_ROUTING:
 		return KVM_MAX_IRQ_ROUTES;
@@ -3348,7 +3352,14 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 	switch (cap->cap) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
-		if (cap->flags || (cap->args[0] & ~1))
+		if (cap->flags ||
+		    (cap->args[0] & ~KVM_DIRTY_LOG_MANUAL_CAPS) ||
+		    /* The capability of KVM_DIRTY_LOG_INITIALLY_SET depends
+		     * on KVM_DIRTY_LOG_MANUAL_PROTECT, it should not be
+		     * set individually
+		     */
+		    ((cap->args[0] & KVM_DIRTY_LOG_MANUAL_CAPS) ==
+			KVM_DIRTY_LOG_INITIALLY_SET))
 			return -EINVAL;
 		kvm->manual_dirty_log_protect = cap->args[0];
 		return 0;
-- 
1.8.3.1


