Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8503EBCEA
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhHMUBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:01:02 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:50246 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230440AbhHMUBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:01:01 -0400
X-Greylist: delayed 1591 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Aug 2021 16:01:01 EDT
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mEcwd-00044w-Q6; Fri, 13 Aug 2021 21:34:19 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/13] KVM: Use interval tree to do fast hva lookup in memslots
Date:   Fri, 13 Aug 2021 21:33:22 +0200
Message-Id: <6246ee89e0940b4efa8d6f0ff51057ea0a438e62.1628871413.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628871411.git.maciej.szmigiero@oracle.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

The current memslots implementation only allows quick binary search by gfn,
quick lookup by hva is not possible - the implementation has to do a linear
scan of the whole memslots array, even though the operation being performed
might apply just to a single memslot.

This significantly hurts performance of per-hva operations with higher
memslot counts.

Since hva ranges can overlap between memslots an interval tree is needed
for tracking them.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/arm64/kvm/Kconfig   |  1 +
 arch/mips/kvm/Kconfig    |  1 +
 arch/powerpc/kvm/Kconfig |  1 +
 arch/s390/kvm/Kconfig    |  1 +
 arch/x86/kvm/Kconfig     |  1 +
 include/linux/kvm_host.h |  3 +++
 virt/kvm/kvm_main.c      | 48 ++++++++++++++++++++++++++++++++++------
 7 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a4eba0908bfa..ebca62882228 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
+	select INTERVAL_TREE
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index a77297480f56..91d197bee9c0 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -27,6 +27,7 @@ config KVM
 	select KVM_MMIO
 	select MMU_NOTIFIER
 	select SRCU
+	select INTERVAL_TREE
 	help
 	  Support for hosting Guest kernels.
 
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index e45644657d49..519d6d3642a5 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select KVM_VFIO
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
+	select INTERVAL_TREE
 
 config KVM_BOOK3S_HANDLER
 	bool
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 67a8e770e369..2e84d3922f7c 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -33,6 +33,7 @@ config KVM
 	select HAVE_KVM_NO_POLL
 	select SRCU
 	select KVM_VFIO
+	select INTERVAL_TREE
 	help
 	  Support hosting paravirtualized guest machines using the SIE
 	  virtualization capability on the mainframe. This should work
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ac69894eab88..572325ec8085 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -43,6 +43,7 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
 	select SRCU
+	select INTERVAL_TREE
 	select HAVE_KVM_PM_NOTIFIER if PM
 	help
 	  Support hosting fully virtualized guest machines using hardware
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d1279d599f2a..27ece967ab48 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -30,6 +30,7 @@
 #include <linux/nospec.h>
 #include <linux/notifier.h>
 #include <linux/hashtable.h>
+#include <linux/interval_tree.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -428,6 +429,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 
 struct kvm_memory_slot {
 	struct hlist_node id_node;
+	struct interval_tree_node hva_node;
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long *dirty_bitmap;
@@ -529,6 +531,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
  */
 struct kvm_memslots {
 	u64 generation;
+	struct rb_root_cached hva_tree;
 	/* The mapping table from slot id to the index in memslots[]. */
 	DECLARE_HASHTABLE(id_hash, 7);
 	atomic_t last_used_slot;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 143dc95f496e..1be05acab3ed 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -481,6 +481,12 @@ static void kvm_null_fn(void)
 }
 #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
 
+/* Iterate over each memslot intersecting [start, last] (inclusive) range */
+#define kvm_for_each_memslot_in_hva_range(node, slots, start, last)	     \
+	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
+	     node;							     \
+	     node = interval_tree_iter_next(node, start, last))	     \
+
 static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 						  const struct kvm_hva_range *range)
 {
@@ -490,6 +496,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	struct kvm_memslots *slots;
 	int i, idx;
 
+	if (WARN_ON_ONCE(range->end <= range->start))
+		return 0;
+
 	/* A null handler is allowed if and only if on_lock() is provided. */
 	if (WARN_ON_ONCE(IS_KVM_NULL_FN(range->on_lock) &&
 			 IS_KVM_NULL_FN(range->handler)))
@@ -498,15 +507,17 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	idx = srcu_read_lock(&kvm->srcu);
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		struct interval_tree_node *node;
+
 		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(slot, slots) {
+		kvm_for_each_memslot_in_hva_range(node, slots,
+						  range->start, range->end - 1) {
 			unsigned long hva_start, hva_end;
 
+			slot = container_of(node, struct kvm_memory_slot, hva_node);
 			hva_start = max(range->start, slot->userspace_addr);
 			hva_end = min(range->end, slot->userspace_addr +
 						  (slot->npages << PAGE_SHIFT));
-			if (hva_start >= hva_end)
-				continue;
 
 			/*
 			 * To optimize for the likely case where the address
@@ -845,6 +856,7 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
 	if (!slots)
 		return NULL;
 
+	slots->hva_tree = RB_ROOT_CACHED;
 	hash_init(slots->id_hash);
 
 	return slots;
@@ -1264,10 +1276,14 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
 		atomic_set(&slots->last_used_slot, 0);
 
 	for (i = oldslot - mslots; i < slots->used_slots; i++) {
+		interval_tree_remove(&mslots[i].hva_node, &slots->hva_tree);
 		hash_del(&mslots[i].id_node);
+
 		mslots[i] = mslots[i + 1];
+		interval_tree_insert(&mslots[i].hva_node, &slots->hva_tree);
 		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
 	}
+	interval_tree_remove(&mslots[i].hva_node, &slots->hva_tree);
 	hash_del(&mslots[i].id_node);
 	mslots[i] = *memslot;
 }
@@ -1287,7 +1303,8 @@ static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
  * itself is not preserved in the array, i.e. not swapped at this time, only
  * its new index into the array is tracked.  Returns the changed memslot's
  * current index into the memslots array.
- * The memslot at the returned index will not be in @slots->id_hash by then.
+ * The memslot at the returned index will not be in @slots->hva_tree or
+ * @slots->id_hash by then.
  * @memslot is a detached struct with desired final data of the changed slot.
  */
 static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
@@ -1310,6 +1327,7 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
 	 * That's why the memslot has to be first removed from the hash table
 	 * here.
 	 */
+	interval_tree_remove(&mmemslot->hva_node, &slots->hva_tree);
 	hash_del(&mmemslot->id_node);
 
 	/*
@@ -1324,8 +1342,11 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
 		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
 
 		/* Shift the next memslot forward one and update its index. */
+		interval_tree_remove(&mslots[i + 1].hva_node, &slots->hva_tree);
 		hash_del(&mslots[i + 1].id_node);
+
 		mslots[i] = mslots[i + 1];
+		interval_tree_insert(&mslots[i].hva_node, &slots->hva_tree);
 		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
 	}
 	return i;
@@ -1337,10 +1358,12 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
  * is not preserved in the array, i.e. not swapped at this time, only its new
  * index into the array is tracked.  Returns the changed memslot's final index
  * into the memslots array.
- * The memslot at the returned index will not be in @slots->id_hash by then.
+ * The memslot at the returned index will not be in @slots->hva_tree or
+ * @slots->id_hash by then.
  * @memslot is a detached struct with desired final data of the new or
  * changed slot.
- * Assumes that the memslot at @start index is not in @slots->id_hash.
+ * Assumes that the memslot at @start index is not in @slots->hva_tree or
+ * @slots->id_hash.
  */
 static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
 					   struct kvm_memory_slot *memslot,
@@ -1356,8 +1379,11 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
 		WARN_ON_ONCE(memslot->base_gfn == mslots[i - 1].base_gfn);
 
 		/* Shift the next memslot back one and update its index. */
+		interval_tree_remove(&mslots[i - 1].hva_node, &slots->hva_tree);
 		hash_del(&mslots[i - 1].id_node);
+
 		mslots[i] = mslots[i - 1];
+		interval_tree_insert(&mslots[i].hva_node, &slots->hva_tree);
 		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
 	}
 	return i;
@@ -1430,6 +1456,11 @@ static void update_memslots(struct kvm_memslots *slots,
 		 * its index accordingly.
 		 */
 		slots->memslots[i] = *memslot;
+		slots->memslots[i].hva_node.start = memslot->userspace_addr;
+		slots->memslots[i].hva_node.last = memslot->userspace_addr +
+			(memslot->npages << PAGE_SHIFT) - 1;
+		interval_tree_insert(&slots->memslots[i].hva_node,
+				     &slots->hva_tree);
 		hash_add(slots->id_hash, &slots->memslots[i].id_node,
 			 memslot->id);
 	}
@@ -1552,9 +1583,12 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 
 	kvm_copy_memslots(slots, old);
 
+	slots->hva_tree = RB_ROOT_CACHED;
 	hash_init(slots->id_hash);
-	kvm_for_each_memslot(memslot, slots)
+	kvm_for_each_memslot(memslot, slots) {
+		interval_tree_insert(&memslot->hva_node, &slots->hva_tree);
 		hash_add(slots->id_hash, &memslot->id_node, memslot->id);
+	}
 
 	return slots;
 }
