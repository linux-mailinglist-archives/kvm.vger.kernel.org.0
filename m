Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFA43EBD02
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhHMUCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:02:33 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:50396 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234638AbhHMUCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:02:30 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mEcwY-00044G-GV; Fri, 13 Aug 2021 21:34:14 +0200
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
Subject: [PATCH v4 08/13] KVM: Resolve memslot ID via a hash table instead of via a static array
Date:   Fri, 13 Aug 2021 21:33:21 +0200
Message-Id: <a2b1444b0539b1448b89ad92fa87d8c2b7ccb0a0.1628871413.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628871411.git.maciej.szmigiero@oracle.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Memslot ID to the corresponding memslot mappings are currently kept as
indices in static id_to_index array.
The size of this array depends on the maximum allowed memslot count
(regardless of the number of memslots actually in use).

This has become especially problematic recently, when memslot count cap was
removed, so the maximum count is now full 32k memslots - the maximum
allowed by the current KVM API.

Keeping these IDs in a hash table (instead of an array) avoids this
problem.

Resolving a memslot ID to the actual memslot (instead of its index) will
also enable transitioning away from an array-based implementation of the
whole memslots structure in a later commit.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 include/linux/kvm_host.h | 16 +++++------
 virt/kvm/kvm_main.c      | 61 +++++++++++++++++++++++++++++++---------
 2 files changed, 55 insertions(+), 22 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6d0bbd6c8554..d1279d599f2a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -29,6 +29,7 @@
 #include <linux/refcount.h>
 #include <linux/nospec.h>
 #include <linux/notifier.h>
+#include <linux/hashtable.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -426,6 +427,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
 
 struct kvm_memory_slot {
+	struct hlist_node id_node;
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long *dirty_bitmap;
@@ -528,7 +530,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 struct kvm_memslots {
 	u64 generation;
 	/* The mapping table from slot id to the index in memslots[]. */
-	short id_to_index[KVM_MEM_SLOTS_NUM];
+	DECLARE_HASHTABLE(id_hash, 7);
 	atomic_t last_used_slot;
 	int used_slots;
 	struct kvm_memory_slot memslots[];
@@ -795,16 +797,14 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
 static inline
 struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 {
-	int index = slots->id_to_index[id];
 	struct kvm_memory_slot *slot;
 
-	if (index < 0)
-		return NULL;
-
-	slot = &slots->memslots[index];
+	hash_for_each_possible(slots->id_hash, slot, id_node, id) {
+		if (slot->id == id)
+			return slot;
+	}
 
-	WARN_ON(slot->id != id);
-	return slot;
+	return NULL;
 }
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 272bc86a0e69..143dc95f496e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -839,15 +839,13 @@ static void kvm_destroy_pm_notifier(struct kvm *kvm)
 
 static struct kvm_memslots *kvm_alloc_memslots(void)
 {
-	int i;
 	struct kvm_memslots *slots;
 
 	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
 	if (!slots)
 		return NULL;
 
-	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
-		slots->id_to_index[i] = -1;
+	hash_init(slots->id_hash);
 
 	return slots;
 }
@@ -1248,14 +1246,16 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 /*
  * Delete a memslot by decrementing the number of used slots and shifting all
  * other entries in the array forward one spot.
+ * @memslot is a detached dummy struct with just .id and .as_id filled.
  */
 static inline void kvm_memslot_delete(struct kvm_memslots *slots,
 				      struct kvm_memory_slot *memslot)
 {
 	struct kvm_memory_slot *mslots = slots->memslots;
+	struct kvm_memory_slot *oldslot = id_to_memslot(slots, memslot->id);
 	int i;
 
-	if (WARN_ON(slots->id_to_index[memslot->id] == -1))
+	if (WARN_ON(!oldslot))
 		return;
 
 	slots->used_slots--;
@@ -1263,12 +1263,13 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
 	if (atomic_read(&slots->last_used_slot) >= slots->used_slots)
 		atomic_set(&slots->last_used_slot, 0);
 
-	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
+	for (i = oldslot - mslots; i < slots->used_slots; i++) {
+		hash_del(&mslots[i].id_node);
 		mslots[i] = mslots[i + 1];
-		slots->id_to_index[mslots[i].id] = i;
+		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
 	}
+	hash_del(&mslots[i].id_node);
 	mslots[i] = *memslot;
-	slots->id_to_index[memslot->id] = -1;
 }
 
 /*
@@ -1286,30 +1287,46 @@ static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
  * itself is not preserved in the array, i.e. not swapped at this time, only
  * its new index into the array is tracked.  Returns the changed memslot's
  * current index into the memslots array.
+ * The memslot at the returned index will not be in @slots->id_hash by then.
+ * @memslot is a detached struct with desired final data of the changed slot.
  */
 static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
 					    struct kvm_memory_slot *memslot)
 {
 	struct kvm_memory_slot *mslots = slots->memslots;
+	struct kvm_memory_slot *mmemslot = id_to_memslot(slots, memslot->id);
 	int i;
 
-	if (slots->id_to_index[memslot->id] == -1 || !slots->used_slots)
+	if (!mmemslot || !slots->used_slots)
 		return -1;
 
+	/*
+	 * The loop below will (possibly) overwrite the target memslot with
+	 * data of the next memslot, or a similar loop in
+	 * kvm_memslot_move_forward() will overwrite it with data of the
+	 * previous memslot.
+	 * Then update_memslots() will unconditionally overwrite and re-add
+	 * it to the hash table.
+	 * That's why the memslot has to be first removed from the hash table
+	 * here.
+	 */
+	hash_del(&mmemslot->id_node);
+
 	/*
 	 * Move the target memslot backward in the array by shifting existing
 	 * memslots with a higher GFN (than the target memslot) towards the
 	 * front of the array.
 	 */
-	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots - 1; i++) {
+	for (i = mmemslot - mslots; i < slots->used_slots - 1; i++) {
 		if (memslot->base_gfn > mslots[i + 1].base_gfn)
 			break;
 
 		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
 
 		/* Shift the next memslot forward one and update its index. */
+		hash_del(&mslots[i + 1].id_node);
 		mslots[i] = mslots[i + 1];
-		slots->id_to_index[mslots[i].id] = i;
+		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
 	}
 	return i;
 }
@@ -1320,6 +1337,10 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
  * is not preserved in the array, i.e. not swapped at this time, only its new
  * index into the array is tracked.  Returns the changed memslot's final index
  * into the memslots array.
+ * The memslot at the returned index will not be in @slots->id_hash by then.
+ * @memslot is a detached struct with desired final data of the new or
+ * changed slot.
+ * Assumes that the memslot at @start index is not in @slots->id_hash.
  */
 static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
 					   struct kvm_memory_slot *memslot,
@@ -1335,8 +1356,9 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
 		WARN_ON_ONCE(memslot->base_gfn == mslots[i - 1].base_gfn);
 
 		/* Shift the next memslot back one and update its index. */
+		hash_del(&mslots[i - 1].id_node);
 		mslots[i] = mslots[i - 1];
-		slots->id_to_index[mslots[i].id] = i;
+		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
 	}
 	return i;
 }
@@ -1381,6 +1403,9 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
  * most likely to be referenced, sorting it to the front of the array was
  * advantageous.  The current binary search starts from the middle of the array
  * and uses an LRU pointer to improve performance for all memslots and GFNs.
+ *
+ * @memslot is a detached struct, not a part of the current or new memslot
+ * array.
  */
 static void update_memslots(struct kvm_memslots *slots,
 			    struct kvm_memory_slot *memslot,
@@ -1405,7 +1430,8 @@ static void update_memslots(struct kvm_memslots *slots,
 		 * its index accordingly.
 		 */
 		slots->memslots[i] = *memslot;
-		slots->id_to_index[memslot->id] = i;
+		hash_add(slots->id_hash, &slots->memslots[i].id_node,
+			 memslot->id);
 	}
 }
 
@@ -1513,6 +1539,7 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 {
 	struct kvm_memslots *slots;
 	size_t new_size;
+	struct kvm_memory_slot *memslot;
 
 	if (change == KVM_MR_CREATE)
 		new_size = kvm_memslots_size(old->used_slots + 1);
@@ -1520,8 +1547,14 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 		new_size = kvm_memslots_size(old->used_slots);
 
 	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
-	if (likely(slots))
-		kvm_copy_memslots(slots, old);
+	if (unlikely(!slots))
+		return NULL;
+
+	kvm_copy_memslots(slots, old);
+
+	hash_init(slots->id_hash);
+	kvm_for_each_memslot(memslot, slots)
+		hash_add(slots->id_hash, &memslot->id_node, memslot->id);
 
 	return slots;
 }
