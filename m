Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F36A170DE1
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 02:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgB0Bck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 20:32:40 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:45766 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728091AbgB0Bck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 20:32:40 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9E4164813647382ACC57;
        Thu, 27 Feb 2020 09:32:37 +0800 (CST)
Received: from localhost (10.173.228.206) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 27 Feb 2020
 09:32:30 +0800
From:   Jay Zhou <jianjay.zhou@huawei.com>
To:     <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <peterx@redhat.com>,
        <sean.j.christopherson@intel.com>, <wangxinxin.wang@huawei.com>,
        <weidong.huang@huawei.com>, <jianjay.zhou@huawei.com>,
        <liu.jinsong@huawei.com>
Subject: [PATCH v4] KVM: x86: enable dirty log gradually in small chunks
Date:   Thu, 27 Feb 2020 09:32:27 +0800
Message-ID: <20200227013227.1401-1-jianjay.zhou@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.228.206]
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
v4:
  * tweak the names, put the sub-cap definition into uapi and check
    against x86 [Peter]

v3:
  * add kvm_manual_dirty_log_init_set helper, add testcase on top and
    keep old behavior for KVM_MEM_READONLY [Peter]
  * tweak logic at enabling KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 [Sean, Peter]

v2:
  * add new bit to KVM_ENABLE_CAP for KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 [Paolo]
  * support non-PML path [Peter]
  * delete the unnecessary ifdef and make the initialization of bitmap
    more clear [Sean]
  * document the new bits and tweak the testcase

 Documentation/virt/kvm/api.rst  | 16 +++++++++++++---
 arch/x86/include/asm/kvm_host.h |  6 +++++-
 arch/x86/kvm/mmu/mmu.c          |  7 ++++---
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 arch/x86/kvm/x86.c              | 21 +++++++++++++++++----
 include/linux/kvm_host.h        | 11 ++++++++++-
 include/uapi/linux/kvm.h        |  3 +++
 virt/kvm/kvm_main.c             | 24 +++++++++++++++++-------
 8 files changed, 71 insertions(+), 20 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 97a72a5..2ef29e7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5704,10 +5704,20 @@ and injected exceptions.
 :Architectures: x86, arm, arm64, mips
 :Parameters: args[0] whether feature should be enabled or not
 
-With this capability enabled, KVM_GET_DIRTY_LOG will not automatically
-clear and write-protect all pages that are returned as dirty.
+Valid flags are::
+
+  #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE   (1 << 0)
+  #define KVM_DIRTY_LOG_INITIALLY_SET           (1 << 1)
+
+With KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE set, KVM_GET_DIRTY_LOG will not
+automatically clear and write-protect all pages that are returned as dirty.
 Rather, userspace will have to do this operation separately using
 KVM_CLEAR_DIRTY_LOG.
+With KVM_DIRTY_LOG_INITIALLY_SET set, all the bits of the dirty bitmap
+will be initialized to 1 when created, dirty logging will be enabled
+gradually in small chunks using KVM_CLEAR_DIRTY_LOG.  However, the
+KVM_DIRTY_LOG_INITIALLY_SET depends on KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE,
+it can not be set individually and supports x86 only for now.
 
 At the cost of a slightly more complicated operation, this provides better
 scalability and responsiveness for two reasons.  First,
@@ -5716,7 +5726,7 @@ than requiring to sync a full memslot; this ensures that KVM does not
 take spinlocks for an extended period of time.  Second, in some cases a
 large amount of time can pass between a call to KVM_GET_DIRTY_LOG and
 userspace actually using the data in the page.  Pages can be modified
-during this time, which is inefficint for both the guest and userspace:
+during this time, which is inefficient for both the guest and userspace:
 the guest will incur a higher penalty due to write protection faults,
 while userspace can see false reports of dirty pages.  Manual reprotection
 helps reducing this time, improving guest performance and reducing the
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 40a0c0f..cfec4f4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -49,6 +49,9 @@
 
 #define KVM_IRQCHIP_NUM_PINS  KVM_IOAPIC_NUM_PINS
 
+#define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
+					KVM_DIRTY_LOG_INITIALLY_SET)
+
 /* x86-specific vcpu->requests bit members */
 #define KVM_REQ_MIGRATE_TIMER		KVM_ARCH_REQ(0)
 #define KVM_REQ_REPORT_TPR_ACCESS	KVM_ARCH_REQ(1)
@@ -1312,7 +1315,8 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
-				      struct kvm_memory_slot *memslot);
+				      struct kvm_memory_slot *memslot,
+				      int start_level);
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 87e9ba2..a4e70eb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5860,13 +5860,14 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
 }
 
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
-				      struct kvm_memory_slot *memslot)
+				      struct kvm_memory_slot *memslot,
+				      int start_level)
 {
 	bool flush;
 
 	spin_lock(&kvm->mmu_lock);
-	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
-				      false);
+	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
+				start_level, PT_MAX_HUGEPAGE_LEVEL, false);
 	spin_unlock(&kvm->mmu_lock);
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3be25ec..c32627d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7201,7 +7201,8 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 static void vmx_slot_enable_log_dirty(struct kvm *kvm,
 				     struct kvm_memory_slot *slot)
 {
-	kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
+	if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
+		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
 	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb5d64e..6df65da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9956,7 +9956,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 {
 	/* Still write protect RO slot */
 	if (new->flags & KVM_MEM_READONLY) {
-		kvm_mmu_slot_remove_write_access(kvm, new);
+		kvm_mmu_slot_remove_write_access(kvm, new, PT_PAGE_TABLE_LEVEL);
 		return;
 	}
 
@@ -9991,10 +9991,23 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * See the comments in fast_page_fault().
 	 */
 	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
-		if (kvm_x86_ops->slot_enable_log_dirty)
+		if (kvm_x86_ops->slot_enable_log_dirty) {
 			kvm_x86_ops->slot_enable_log_dirty(kvm, new);
-		else
-			kvm_mmu_slot_remove_write_access(kvm, new);
+		} else {
+			int level =
+				kvm_dirty_log_manual_protect_and_init_set(kvm) ?
+				PT_DIRECTORY_LEVEL : PT_PAGE_TABLE_LEVEL;
+
+			/*
+			 * If we're with initial-all-set, we don't need
+			 * to write protect any small page because
+			 * they're reported as dirty already.  However
+			 * we still need to write-protect huge pages
+			 * so that the page split can happen lazily on
+			 * the first write to the huge page.
+			 */
+			kvm_mmu_slot_remove_write_access(kvm, new, level);
+		}
 	} else {
 		if (kvm_x86_ops->slot_disable_log_dirty)
 			kvm_x86_ops->slot_disable_log_dirty(kvm, new);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e89eb67..f5e6e73 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -360,6 +360,10 @@ static inline unsigned long *kvm_second_dirty_bitmap(struct kvm_memory_slot *mem
 	return memslot->dirty_bitmap + len / sizeof(*memslot->dirty_bitmap);
 }
 
+#ifndef KVM_DIRTY_LOG_MANUAL_CAPS
+#define KVM_DIRTY_LOG_MANUAL_CAPS KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE
+#endif
+
 struct kvm_s390_adapter_int {
 	u64 ind_addr;
 	u64 summary_addr;
@@ -493,7 +497,7 @@ struct kvm {
 #endif
 	long tlbs_dirty;
 	struct list_head devices;
-	bool manual_dirty_log_protect;
+	u64 manual_dirty_log_protect;
 	struct dentry *debugfs_dentry;
 	struct kvm_stat_data **debugfs_stat_data;
 	struct srcu_struct srcu;
@@ -527,6 +531,11 @@ struct kvm {
 #define vcpu_err(vcpu, fmt, ...)					\
 	kvm_err("vcpu%i " fmt, (vcpu)->vcpu_id, ## __VA_ARGS__)
 
+static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
+{
+	return !!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET);
+}
+
 static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
 {
 	return srcu_dereference_check(kvm->buses[idx], &kvm->srcu,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a..d8499d9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1628,4 +1628,7 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
 
+#define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
+#define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70f03ce..700ef86 100644
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
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			bitmap_set(new.dirty_bitmap, 0, new.npages);
 	}
 
 	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
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
@@ -3347,11 +3351,17 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 {
 	switch (cap->cap) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
-		if (cap->flags || (cap->args[0] & ~1))
+	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2: {
+		u64 allowed_options = KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE;
+
+		if (cap->args[0] & KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE)
+			allowed_options = KVM_DIRTY_LOG_MANUAL_CAPS;
+
+		if (cap->flags || (cap->args[0] & ~allowed_options))
 			return -EINVAL;
 		kvm->manual_dirty_log_protect = cap->args[0];
 		return 0;
+	}
 #endif
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
-- 
1.8.3.1


