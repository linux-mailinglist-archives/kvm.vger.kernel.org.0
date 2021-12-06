Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3814246A64B
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349521AbhLFUAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 15:00:38 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:50440 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349022AbhLFUA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 15:00:27 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1muK6D-0000yS-Eu; Mon, 06 Dec 2021 20:56:33 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
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
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 21/29] KVM: Resolve memslot ID via a hash table instead of via a static array
Date:   Mon,  6 Dec 2021 20:54:27 +0100
Message-Id: <117fb2c04320e6cd6cf34f205a72eadb0aa8d5f9.1638817640.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638817637.git.maciej.szmigiero@oracle.com>
References: <cover.1638817637.git.maciej.szmigiero@oracle.com>
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

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 include/linux/kvm_host.h | 25 +++++++----
 virt/kvm/kvm_main.c      | 95 +++++++++++++++++++++++++++++++---------
 2 files changed, 91 insertions(+), 29 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 86562ffb6ea4..f3be79fb7d74 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -29,6 +29,7 @@
 #include <linux/refcount.h>
 #include <linux/nospec.h>
 #include <linux/notifier.h>
+#include <linux/hashtable.h>
 #include <linux/xarray.h>
 #include <asm/signal.h>
 
@@ -428,6 +429,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
 
 struct kvm_memory_slot {
+	struct hlist_node id_node;
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long *dirty_bitmap;
@@ -529,8 +531,15 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
  */
 struct kvm_memslots {
 	u64 generation;
-	/* The mapping table from slot id to the index in memslots[]. */
-	short id_to_index[KVM_MEM_SLOTS_NUM];
+	/*
+	 * The mapping table from slot id to the index in memslots[].
+	 *
+	 * 7-bit bucket count matches the size of the old id to index array for
+	 * 512 slots, while giving good performance with this slot count.
+	 * Higher bucket counts bring only small performance improvements but
+	 * always result in higher memory usage (even for lower memslot counts).
+	 */
+	DECLARE_HASHTABLE(id_hash, 7);
 	atomic_t last_used_slot;
 	int used_slots;
 	struct kvm_memory_slot memslots[];
@@ -798,16 +807,14 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
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
index bbc0110224f3..f2eca32fbca8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -869,15 +869,13 @@ static void kvm_destroy_pm_notifier(struct kvm *kvm)
 
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
@@ -1276,17 +1274,48 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 	return 0;
 }
 
+static void kvm_replace_memslot(struct kvm_memslots *slots,
+				struct kvm_memory_slot *old,
+				struct kvm_memory_slot *new)
+{
+	/*
+	 * Remove the old memslot from the hash list, copying the node data
+	 * would corrupt the list.
+	 */
+	if (old) {
+		hash_del(&old->id_node);
+
+		if (!new)
+			return;
+
+		/* Copy the source *data*, not the pointer, to the destination. */
+		*new = *old;
+	}
+
+	/* (Re)Add the new memslot. */
+	hash_add(slots->id_hash, &new->id_node, new->id);
+}
+
+static void kvm_shift_memslot(struct kvm_memslots *slots, int dst, int src)
+{
+	struct kvm_memory_slot *mslots = slots->memslots;
+
+	kvm_replace_memslot(slots, &mslots[src], &mslots[dst]);
+}
+
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
@@ -1294,12 +1323,17 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
 	if (atomic_read(&slots->last_used_slot) >= slots->used_slots)
 		atomic_set(&slots->last_used_slot, 0);
 
-	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
-		mslots[i] = mslots[i + 1];
-		slots->id_to_index[mslots[i].id] = i;
-	}
+	/*
+	 * Remove the to-be-deleted memslot from the list _before_ shifting
+	 * the trailing memslots forward, its data will be overwritten.
+	 * Defer the (somewhat pointless) copying of the memslot until after
+	 * the last slot has been shifted to avoid overwriting said last slot.
+	 */
+	kvm_replace_memslot(slots, oldslot, NULL);
+
+	for (i = oldslot - mslots; i < slots->used_slots; i++)
+		kvm_shift_memslot(slots, i, i + 1);
 	mslots[i] = *memslot;
-	slots->id_to_index[memslot->id] = -1;
 }
 
 /*
@@ -1317,30 +1351,39 @@ static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
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
+	struct kvm_memory_slot *oldslot = id_to_memslot(slots, memslot->id);
 	int i;
 
-	if (slots->id_to_index[memslot->id] == -1 || !slots->used_slots)
+	if (!oldslot || !slots->used_slots)
 		return -1;
 
+	/*
+	 * Delete the slot from the hash table before sorting the remaining
+	 * slots, the slot's data may be overwritten when copying slots as part
+	 * of the sorting proccess.  update_memslots() will unconditionally
+	 * rewrite the entire slot and re-add it to the hash table.
+	 */
+	kvm_replace_memslot(slots, oldslot, NULL);
+
 	/*
 	 * Move the target memslot backward in the array by shifting existing
 	 * memslots with a higher GFN (than the target memslot) towards the
 	 * front of the array.
 	 */
-	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots - 1; i++) {
+	for (i = oldslot - mslots; i < slots->used_slots - 1; i++) {
 		if (memslot->base_gfn > mslots[i + 1].base_gfn)
 			break;
 
 		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
 
-		/* Shift the next memslot forward one and update its index. */
-		mslots[i] = mslots[i + 1];
-		slots->id_to_index[mslots[i].id] = i;
+		kvm_shift_memslot(slots, i, i + 1);
 	}
 	return i;
 }
@@ -1351,6 +1394,10 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
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
@@ -1365,9 +1412,7 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
 
 		WARN_ON_ONCE(memslot->base_gfn == mslots[i - 1].base_gfn);
 
-		/* Shift the next memslot back one and update its index. */
-		mslots[i] = mslots[i - 1];
-		slots->id_to_index[mslots[i].id] = i;
+		kvm_shift_memslot(slots, i, i - 1);
 	}
 	return i;
 }
@@ -1412,6 +1457,9 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
  * most likely to be referenced, sorting it to the front of the array was
  * advantageous.  The current binary search starts from the middle of the array
  * and uses an LRU pointer to improve performance for all memslots and GFNs.
+ *
+ * @memslot is a detached struct, not a part of the current or new memslot
+ * array.
  */
 static void update_memslots(struct kvm_memslots *slots,
 			    struct kvm_memory_slot *memslot,
@@ -1436,7 +1484,7 @@ static void update_memslots(struct kvm_memslots *slots,
 		 * its index accordingly.
 		 */
 		slots->memslots[i] = *memslot;
-		slots->id_to_index[memslot->id] = i;
+		kvm_replace_memslot(slots, NULL, &slots->memslots[i]);
 	}
 }
 
@@ -1529,6 +1577,7 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 {
 	struct kvm_memslots *slots;
 	size_t new_size;
+	struct kvm_memory_slot *memslot;
 
 	if (change == KVM_MR_CREATE)
 		new_size = kvm_memslots_size(old->used_slots + 1);
@@ -1536,8 +1585,14 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 		new_size = kvm_memslots_size(old->used_slots);
 
 	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
-	if (likely(slots))
-		memcpy(slots, old, kvm_memslots_size(old->used_slots));
+	if (unlikely(!slots))
+		return NULL;
+
+	memcpy(slots, old, kvm_memslots_size(old->used_slots));
+
+	hash_init(slots->id_hash);
+	kvm_for_each_memslot(memslot, slots)
+		hash_add(slots->id_hash, &memslot->id_node, memslot->id);
 
 	return slots;
 }
