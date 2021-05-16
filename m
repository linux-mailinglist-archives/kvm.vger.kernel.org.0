Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7C7382140
	for <lists+kvm@lfdr.de>; Sun, 16 May 2021 23:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhEPVqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 May 2021 17:46:35 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:54396 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234296AbhEPVqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 May 2021 17:46:30 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1liOZE-0007z9-Ak; Sun, 16 May 2021 23:44:56 +0200
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
Subject: [PATCH v3 3/8] KVM: Resolve memslot ID via a hash table instead of via a static array
Date:   Sun, 16 May 2021 23:44:29 +0200
Message-Id: <4a4867419344338e1419436af1e1b0b8f2405517.1621191551.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621191549.git.maciej.szmigiero@oracle.com>
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
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
 virt/kvm/kvm_main.c      | 58 ++++++++++++++++++++++++++++++----------
 2 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3c40c7d32f7e..d3a35646dfd8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -27,6 +27,7 @@
 #include <linux/rcuwait.h>
 #include <linux/refcount.h>
 #include <linux/nospec.h>
+#include <linux/hashtable.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -356,6 +357,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
 
 struct kvm_memory_slot {
+	struct hlist_node id_node;
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long *dirty_bitmap;
@@ -458,7 +460,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 struct kvm_memslots {
 	u64 generation;
 	/* The mapping table from slot id to the index in memslots[]. */
-	short id_to_index[KVM_MEM_SLOTS_NUM];
+	DECLARE_HASHTABLE(id_hash, 7);
 	atomic_t lru_slot;
 	int used_slots;
 	struct kvm_memory_slot memslots[];
@@ -680,16 +682,14 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
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
index 6b4feb92dc79..50f9bc9bb1e0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -781,15 +781,13 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 
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
@@ -1097,14 +1095,16 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 /*
  * Delete a memslot by decrementing the number of used slots and shifting all
  * other entries in the array forward one spot.
+ * @memslot is a detached dummy struct with just .id and .as_id filled.
  */
 static inline void kvm_memslot_delete(struct kvm_memslots *slots,
 				      struct kvm_memory_slot *memslot)
 {
 	struct kvm_memory_slot *mslots = slots->memslots;
+	struct kvm_memory_slot *dmemslot = id_to_memslot(slots, memslot->id);
 	int i;
 
-	if (WARN_ON(slots->id_to_index[memslot->id] == -1))
+	if (WARN_ON(!dmemslot))
 		return;
 
 	slots->used_slots--;
@@ -1112,12 +1112,13 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
 	if (atomic_read(&slots->lru_slot) >= slots->used_slots)
 		atomic_set(&slots->lru_slot, 0);
 
-	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
+	for (i = dmemslot - mslots; i < slots->used_slots; i++) {
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
@@ -1135,31 +1136,41 @@ static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
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
 
-	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
+	if (WARN_ON_ONCE(!mmemslot) ||
 	    WARN_ON_ONCE(!slots->used_slots))
 		return -1;
 
+	/*
+	 * update_memslots() will unconditionally overwrite and re-add the
+	 * target memslot so it has to be removed here first
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
@@ -1170,6 +1181,10 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
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
@@ -1185,8 +1200,9 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
 		WARN_ON_ONCE(memslot->base_gfn == mslots[i - 1].base_gfn);
 
 		/* Shift the next memslot back one and update its index. */
+		hash_del(&mslots[i - 1].id_node);
 		mslots[i] = mslots[i - 1];
-		slots->id_to_index[mslots[i].id] = i;
+		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
 	}
 	return i;
 }
@@ -1231,6 +1247,9 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
  * most likely to be referenced, sorting it to the front of the array was
  * advantageous.  The current binary search starts from the middle of the array
  * and uses an LRU pointer to improve performance for all memslots and GFNs.
+ *
+ * @memslot is a detached struct, not a part of the current or new memslot
+ * array.
  */
 static void update_memslots(struct kvm_memslots *slots,
 			    struct kvm_memory_slot *memslot,
@@ -1247,12 +1266,16 @@ static void update_memslots(struct kvm_memslots *slots,
 			i = kvm_memslot_move_backward(slots, memslot);
 		i = kvm_memslot_move_forward(slots, memslot, i);
 
+		if (i < 0)
+			return;
+
 		/*
 		 * Copy the memslot to its new position in memslots and update
 		 * its index accordingly.
 		 */
 		slots->memslots[i] = *memslot;
-		slots->id_to_index[memslot->id] = i;
+		hash_add(slots->id_hash, &slots->memslots[i].id_node,
+			 memslot->id);
 	}
 }
 
@@ -1316,6 +1339,7 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 {
 	struct kvm_memslots *slots;
 	size_t old_size, new_size;
+	struct kvm_memory_slot *memslot;
 
 	old_size = sizeof(struct kvm_memslots) +
 		   (sizeof(struct kvm_memory_slot) * old->used_slots);
@@ -1326,8 +1350,14 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 		new_size = old_size;
 
 	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
-	if (likely(slots))
-		memcpy(slots, old, old_size);
+	if (unlikely(!slots))
+		return NULL;
+
+	memcpy(slots, old, old_size);
+
+	hash_init(slots->id_hash);
+	kvm_for_each_memslot(memslot, slots)
+		hash_add(slots->id_hash, &memslot->id_node, memslot->id);
 
 	return slots;
 }
