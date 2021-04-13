Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB1E35E19A
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245612AbhDMOdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:33:49 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:49720 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245740AbhDMOdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 10:33:32 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lWJkX-0003zd-7K; Tue, 13 Apr 2021 16:10:41 +0200
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
Subject: [PATCH v2 4/8] KVM: Introduce memslots hva tree
Date:   Tue, 13 Apr 2021 16:10:10 +0200
Message-Id: <03be687278c659220d5e354eb980bbf59dc8faa0.1618322003.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1618322001.git.maciej.szmigiero@oracle.com>
References: <cover.1618322001.git.maciej.szmigiero@oracle.com>
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
 arch/arm64/kvm/Kconfig              |  1 +
 arch/arm64/kvm/mmu.c                | 10 +++++++---
 arch/mips/kvm/Kconfig               |  1 +
 arch/mips/kvm/mmu.c                 | 10 +++++++---
 arch/powerpc/kvm/Kconfig            |  1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 10 +++++++---
 arch/powerpc/kvm/book3s_pr.c        | 10 +++++++---
 arch/s390/kvm/Kconfig               |  1 +
 arch/x86/kvm/Kconfig                |  1 +
 arch/x86/kvm/mmu/mmu.c              | 11 +++++++---
 arch/x86/kvm/mmu/tdp_mmu.c          | 13 +++++++++---
 include/linux/kvm_host.h            |  8 ++++++++
 virt/kvm/kvm_main.c                 | 31 +++++++++++++++++++++++++----
 13 files changed, 86 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 3964acf5451e..f075e9939a2a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -40,6 +40,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select TASKSTATS
 	select TASK_DELAY_ACCT
+	select INTERVAL_TREE
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4b7e1e327337..4b0ac98a5a53 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1073,21 +1073,25 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 			     void *data)
 {
 	struct kvm_memslots *slots;
+	struct interval_tree_node *node;
 	struct kvm_memory_slot *memslot;
 	int ret = 0;
 
+	if (end == start || WARN_ON(end < start))
+		return 0;
+
 	slots = kvm_memslots(kvm);
 
 	/* we only care about the pages that the guest sees */
-	kvm_for_each_memslot(memslot, slots) {
+	kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 		unsigned long hva_start, hva_end;
 		gfn_t gpa;
 
+		memslot = container_of(node, struct kvm_memory_slot,
+				       hva_node);
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
 
 		gpa = hva_to_gfn_memslot(hva_start, memslot) << PAGE_SHIFT;
 		ret |= handler(kvm, gpa, (u64)(hva_end - hva_start), data);
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 032b3fca6cbb..5ba260f38e75 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -27,6 +27,7 @@ config KVM
 	select KVM_MMIO
 	select MMU_NOTIFIER
 	select SRCU
+	select INTERVAL_TREE
 	help
 	  Support for hosting Guest kernels.
 
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 3dabeda82458..0c7c48f08ec2 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -449,21 +449,25 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 			     void *data)
 {
 	struct kvm_memslots *slots;
+	struct interval_tree_node *node;
 	struct kvm_memory_slot *memslot;
 	int ret = 0;
 
+	if (end == start || WARN_ON(end < start))
+		return 0;
+
 	slots = kvm_memslots(kvm);
 
 	/* we only care about the pages that the guest sees */
-	kvm_for_each_memslot(memslot, slots) {
+	kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 		unsigned long hva_start, hva_end;
 		gfn_t gfn, gfn_end;
 
+		memslot = container_of(node, struct kvm_memory_slot,
+				       hva_node);
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
 
 		/*
 		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
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
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index bb6773594cf8..fca2a978617c 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -763,18 +763,22 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 	int ret;
 	int retval = 0;
 	struct kvm_memslots *slots;
+	struct interval_tree_node *node;
 	struct kvm_memory_slot *memslot;
 
+	if (end == start || WARN_ON(end < start))
+		return 0;
+
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots) {
+	kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 		unsigned long hva_start, hva_end;
 		gfn_t gfn, gfn_end;
 
+		memslot = container_of(node, struct kvm_memory_slot,
+				       hva_node);
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
 		/*
 		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
 		 * {gfn, gfn+1, ..., gfn_end-1}.
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 913944dc3620..d0a7127403f0 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -431,18 +431,22 @@ static void do_kvm_unmap_hva(struct kvm *kvm, unsigned long start,
 	long i;
 	struct kvm_vcpu *vcpu;
 	struct kvm_memslots *slots;
+	struct interval_tree_node *node;
 	struct kvm_memory_slot *memslot;
 
+	if (end == start || WARN_ON(end < start))
+		return;
+
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots) {
+	kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 		unsigned long hva_start, hva_end;
 		gfn_t gfn, gfn_end;
 
+		memslot = container_of(node, struct kvm_memory_slot,
+				       hva_node);
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
 		/*
 		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
 		 * {gfn, gfn+1, ..., gfn_end-1}.
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
index a788d5120d4d..59225775e4f5 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,6 +46,7 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
 	select SRCU
+	select INTERVAL_TREE
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 762314b04a39..75fa497aa27f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1430,17 +1430,22 @@ static __always_inline int kvm_handle_hva_range(struct kvm *kvm,
 	int ret = 0;
 	int i;
 
+	if (end == start || WARN_ON(end < start))
+		return 0;
+
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		struct interval_tree_node *node;
+
 		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(memslot, slots) {
+		kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 			unsigned long hva_start, hva_end;
 			gfn_t gfn_start, gfn_end;
 
+			memslot = container_of(node, struct kvm_memory_slot,
+					       hva_node);
 			hva_start = max(start, memslot->userspace_addr);
 			hva_end = min(end, memslot->userspace_addr +
 				      (memslot->npages << PAGE_SHIFT));
-			if (hva_start >= hva_end)
-				continue;
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
 			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ccf0d774a181..69683028763c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -889,18 +889,25 @@ static __always_inline int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm,
 	int ret = 0;
 	int as_id;
 
+	if (end == start || WARN_ON(end < start))
+		return 0;
+
 	for (as_id = 0; as_id < KVM_ADDRESS_SPACE_NUM; as_id++) {
 		for_each_tdp_mmu_root_yield_safe(kvm, root, as_id) {
+			struct interval_tree_node *node;
+
 			slots = __kvm_memslots(kvm, as_id);
-			kvm_for_each_memslot(memslot, slots) {
+			kvm_for_each_hva_range_memslot(node, slots,
+						       start, end - 1) {
 				unsigned long hva_start, hva_end;
 				gfn_t gfn_start, gfn_end;
 
+				memslot = container_of(node,
+						       struct kvm_memory_slot,
+						       hva_node);
 				hva_start = max(start, memslot->userspace_addr);
 				hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
-				if (hva_start >= hva_end)
-					continue;
 				/*
 				 * {gfn(page) | page intersects with [hva_start, hva_end)} =
 				 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e4aadb9875e9..b8196cbd2c6f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -27,6 +27,7 @@
 #include <linux/rcuwait.h>
 #include <linux/refcount.h>
 #include <linux/nospec.h>
+#include <linux/interval_tree.h>
 #include <linux/hashtable.h>
 #include <asm/signal.h>
 
@@ -352,6 +353,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 
 struct kvm_memory_slot {
 	struct hlist_node id_node;
+	struct interval_tree_node hva_node;
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long *dirty_bitmap;
@@ -453,6 +455,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
  */
 struct kvm_memslots {
 	u64 generation;
+	struct rb_root_cached hva_tree;
 	/* The mapping table from slot id to the index in memslots[]. */
 	DECLARE_HASHTABLE(id_hash, 7);
 	atomic_t lru_slot;
@@ -673,6 +676,11 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
 	return __kvm_memslots(vcpu->kvm, as_id);
 }
 
+#define kvm_for_each_hva_range_memslot(node, slots, start, last)	     \
+	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
+	     node;							     \
+	     node = interval_tree_iter_next(node, start, last))	     \
+
 static inline
 struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8f0b49d937d1..37b44cde9ae7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -662,6 +662,7 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
 	if (!slots)
 		return NULL;
 
+	slots->hva_tree = RB_ROOT_CACHED;
 	hash_init(slots->id_hash);
 
 	return slots;
@@ -988,10 +989,14 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
 		atomic_set(&slots->lru_slot, 0);
 
 	for (i = dmemslot - mslots; i < slots->used_slots; i++) {
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
@@ -1011,7 +1016,8 @@ static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
  * itself is not preserved in the array, i.e. not swapped at this time, only
  * its new index into the array is tracked.  Returns the changed memslot's
  * current index into the memslots array.
- * The memslot at the returned index will not be in @slots->id_hash by then.
+ * The memslot at the returned index will not be in @slots->hva_tree or
+ * @slots->id_hash by then.
  * @memslot is a detached struct with desired final data of the changed slot.
  */
 static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
@@ -1029,6 +1035,7 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
 	 * update_memslots() will unconditionally overwrite and re-add the
 	 * target memslot so it has to be removed here first
 	 */
+	interval_tree_remove(&mmemslot->hva_node, &slots->hva_tree);
 	hash_del(&mmemslot->id_node);
 
 	/*
@@ -1043,8 +1050,11 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
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
@@ -1056,10 +1066,12 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
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
@@ -1075,8 +1087,11 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
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
@@ -1149,6 +1164,11 @@ static void update_memslots(struct kvm_memslots *slots,
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
@@ -1230,9 +1250,12 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 
 	memcpy(slots, old, old_size);
 
+	slots->hva_tree = RB_ROOT_CACHED;
 	hash_init(slots->id_hash);
-	kvm_for_each_memslot(memslot, slots)
+	kvm_for_each_memslot(memslot, slots) {
+		interval_tree_insert(&memslot->hva_node, &slots->hva_tree);
 		hash_add(slots->id_hash, &memslot->id_node, memslot->id);
+	}
 
 	return slots;
 }
