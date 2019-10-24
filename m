Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D34FE3FFE
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 01:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387642AbfJXXHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 19:07:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:23483 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387581AbfJXXHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 19:07:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 16:07:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; 
   d="scan'208";a="202445872"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 24 Oct 2019 16:07:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v3 14/15] KVM: Terminate memslot walks via used_slots
Date:   Thu, 24 Oct 2019 16:07:43 -0700
Message-Id: <20191024230744.14543-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191024230744.14543-1-sean.j.christopherson@intel.com>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor memslot handling to treat the number of used slots as the de
facto size of the memslot array, e.g. return NULL from id_to_memslot()
when an invalid index is provided instead of relying on npages==0 to
detect an invalid memslot.  Rework the sorting and walking of memslots
in advance of dynamically sizing memslots to aid bisection and debug,
e.g. with luck, a bug in the refactoring will bisect here and/or hit a
WARN instead of randomly corrupting memory.

Alternatively, a global null/invalid memslot could be returned, i.e. so
callers of id_to_memslot() don't have to explicitly check for a NULL
memslot, but that approach runs the risk of introducing difficult-to-
debug issues, e.g. if the global null slot is modified.  Constifying
the return from id_to_memslot() to combat such issues is possible, but
would require a massive refactoring of arch specific code and would
still be susceptible to casting shenanigans.

Add function comments to update_memslots() and search_memslots() to
explicitly (and loudly) state how memslots are sorted.

No functional change intended.

Tested-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/kvm/book3s_hv.c |   2 +-
 arch/x86/kvm/x86.c           |  14 +--
 include/linux/kvm_host.h     |  18 ++-
 virt/kvm/arm/mmu.c           |   9 +-
 virt/kvm/kvm_main.c          | 220 ++++++++++++++++++++++++++---------
 5 files changed, 189 insertions(+), 74 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 14906f7c12c5..444c76091f17 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4405,7 +4405,7 @@ static int kvm_vm_ioctl_get_dirty_log_hv(struct kvm *kvm,
 	slots = kvm_memslots(kvm);
 	memslot = id_to_memslot(slots, log->slot);
 	r = -ENOENT;
-	if (!memslot->dirty_bitmap)
+	if (!memslot || !memslot->dirty_bitmap)
 		goto out;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 71f579f63951..6d1cb2211fe1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9465,9 +9465,9 @@ void kvm_arch_sync_events(struct kvm *kvm)
 int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 {
 	int i, r;
-	unsigned long hva;
+	unsigned long hva, uninitialized_var(old_npages);
 	struct kvm_memslots *slots = kvm_memslots(kvm);
-	struct kvm_memory_slot *slot, old;
+	struct kvm_memory_slot *slot;
 
 	/* Called with kvm->slots_lock held.  */
 	if (WARN_ON(id >= KVM_MEM_SLOTS_NUM))
@@ -9475,7 +9475,7 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 
 	slot = id_to_memslot(slots, id);
 	if (size) {
-		if (slot->npages)
+		if (slot && slot->npages)
 			return -EEXIST;
 
 		/*
@@ -9487,13 +9487,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 		if (IS_ERR((void *)hva))
 			return PTR_ERR((void *)hva);
 	} else {
-		if (!slot->npages)
+		if (!slot || !slot->npages)
 			return 0;
 
-		hva = 0;
+		hva = slot->userspace_addr;
+		old_npages = slot->npages;
 	}
 
-	old = *slot;
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		struct kvm_userspace_memory_region m;
 
@@ -9508,7 +9508,7 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 	}
 
 	if (!size)
-		vm_munmap(old.userspace_addr, old.npages * PAGE_SIZE);
+		vm_munmap(hva, old_npages * PAGE_SIZE);
 
 	return 0;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a19807a4a5ad..b5d4133a11e1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -579,10 +579,11 @@ static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
 	BUG();
 }
 
-#define kvm_for_each_memslot(memslot, slots)	\
-	for (memslot = &slots->memslots[0];	\
-	      memslot < slots->memslots + KVM_MEM_SLOTS_NUM && memslot->npages;\
-		memslot++)
+#define kvm_for_each_memslot(memslot, slots)				\
+	for (memslot = &slots->memslots[0];				\
+	     memslot < slots->memslots + slots->used_slots; memslot++)	\
+		if (WARN_ON_ONCE(!memslot->npages)) {			\
+		} else
 
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
@@ -643,12 +644,15 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
 	return __kvm_memslots(vcpu->kvm, as_id);
 }
 
-static inline struct kvm_memory_slot *
-id_to_memslot(struct kvm_memslots *slots, int id)
+static inline
+struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 {
 	int index = slots->id_to_index[id];
 	struct kvm_memory_slot *slot;
 
+	if (index < 0)
+		return NULL;
+
 	slot = &slots->memslots[index];
 
 	WARN_ON(slot->id != id);
@@ -994,6 +998,8 @@ bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
  * used in non-modular code in arch/powerpc/kvm/book3s_hv_rm_mmu.c.
  * gfn_to_memslot() itself isn't here as an inline because that would
  * bloat other code too much.
+ *
+ * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
  */
 static inline struct kvm_memory_slot *
 search_memslots(struct kvm_memslots *slots, gfn_t gfn)
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index f3241b268d49..7ea3321cabb8 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1536,8 +1536,13 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
-	phys_addr_t start = memslot->base_gfn << PAGE_SHIFT;
-	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+	phys_addr_t start, end;
+
+	if (WARN_ON_ONCE(!memslot))
+		return;
+
+	start = memslot->base_gfn << PAGE_SHIFT;
+	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
 	stage2_wp_range(kvm, start, end);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0192dccfcec1..7bc88375cf53 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -535,7 +535,7 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
 		return NULL;
 
 	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
-		slots->id_to_index[i] = slots->memslots[i].id = i;
+		slots->id_to_index[i] = slots->memslots[i].id = -1;
 
 	return slots;
 }
@@ -807,63 +807,162 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 }
 
 /*
- * Insert memslot and re-sort memslots based on their GFN,
- * so binary search could be used to lookup GFN.
- * Sorting algorithm takes advantage of having initially
- * sorted array and known changed memslot position.
+ * Delete a memslot by decrementing the number of used slots and shifting all
+ * other entries in the array forward one spot.
+ */
+static inline void kvm_memslot_delete(struct kvm_memslots *slots,
+				      struct kvm_memory_slot *memslot)
+{
+	struct kvm_memory_slot *mslots = slots->memslots;
+	int i;
+
+	if (WARN_ON(slots->id_to_index[memslot->id] == -1))
+		return;
+
+	slots->used_slots--;
+
+	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
+		mslots[i] = mslots[i + 1];
+		slots->id_to_index[mslots[i].id] = i;
+	}
+	mslots[i] = *memslot;
+	slots->id_to_index[memslot->id] = -1;
+}
+
+/*
+ * "Insert" a new memslot by incrementing the number of used slots.  Returns
+ * the new slot's initial index into the memslots array.
+ */
+static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
+{
+	return slots->used_slots++;
+}
+
+/*
+ * Move a changed memslot backwards in the array by shifting existing slots
+ * with a higher GFN toward the front of the array.  Note, the changed memslot
+ * itself is not preserved in the array, i.e. not swapped at this time, only
+ * its new index into the array is tracked.  Returns the changed memslot's
+ * current index into the memslots array.
+ */
+static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
+					    struct kvm_memory_slot *memslot)
+{
+	struct kvm_memory_slot *mslots = slots->memslots;
+	int i;
+
+	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
+	    WARN_ON_ONCE(!slots->used_slots))
+		return -1;
+
+	/*
+	 * Move the target memslot backward in the array by shifting existing
+	 * memslots with a higher GFN (than the target memslot) towards the
+	 * front of the array.
+	 */
+	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots - 1; i++) {
+		if (memslot->base_gfn > mslots[i + 1].base_gfn)
+			break;
+
+		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
+
+		/* Shift the next memslot forward one and update its index. */
+		mslots[i] = mslots[i + 1];
+		slots->id_to_index[mslots[i].id] = i;
+	}
+	return i;
+}
+
+/*
+ * Move a changed memslot forwards in the array by shifting existing slots with
+ * a lower GFN toward the back of the array.  Note, the changed memslot itself
+ * is not preserved in the array, i.e. not swapped at this time, only its new
+ * index into the array is tracked.  Returns the changed memslot's final index
+ * into the memslots array.
+ */
+static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
+					   struct kvm_memory_slot *memslot,
+					   int start)
+{
+	struct kvm_memory_slot *mslots = slots->memslots;
+	int i;
+
+	for (i = start; i > 0; i--) {
+		if (memslot->base_gfn < mslots[i - 1].base_gfn)
+			break;
+
+		WARN_ON_ONCE(memslot->base_gfn == mslots[i - 1].base_gfn);
+
+		/* Shift the next memslot back one and update its index. */
+		mslots[i] = mslots[i - 1];
+		slots->id_to_index[mslots[i].id] = i;
+	}
+	return i;
+}
+
+/*
+ * Re-sort memslots based on their GFN to account for an added, deleted, or
+ * moved memslot.  Sorting memslots by GFN allows using a binary search during
+ * memslot lookup.
+ *
+ * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!  I.e. the entry
+ * at memslots[0] has the highest GFN.
+ *
+ * The sorting algorithm takes advantage of having initially sorted memslots
+ * and knowing the position of the changed memslot.  Sorting is also optimized
+ * by not swapping the changed memslot and instead only shifting other memslots
+ * and tracking the new index for the changed memslot.  Only once its final
+ * index is known is the updated memslot copied into its position in the array.
+ *
+ *  - When deleting a memslot, the deleted memslot simply needs to be moved to
+ *    the end of the array.
+ *
+ *  - When creating a memslot, the algorithm "inserts" the new memslot at the
+ *    end of the array and then moves it forward to its correct location.
+ *
+ *  - When moving a memslot, the algorithm first moves the updated memslot
+ *    backward to handle the scenario where the memslot's GFN was changed to a
+ *    lower value.  update_memslots() then falls through and runs the same flow
+ *    as creating a memslot to move the memslot forward to handle the scenario
+ *    where its GFN was changed to a higher value.
+ *
+ * Note, slots are sorted from highest->lowest instead of lowest->highest for
+ * historical reasons.  Originally, invalid memslots were denoted by having
+ * GFN=0, thus sorting from highest->lowest naturally sorted invalid memslots
+ * to the end of the array.  The current algorithm uses dedicated logic to
+ * delete a memslot and thus does not rely on invalid memslots having GFN=0.
+ *
+ * The other historical motiviation for highest->lowest was to improve the
+ * performance of memslot lookup.  KVM originally used a linear search starting
+ * at memslots[0].  On x86, the largest memslot usually has one of the highest,
+ * if not *the* highest, GFN, as the bulk of the guest's RAM is located in a
+ * single memslot above the 4gb boundary.  As the largest memslot is also the
+ * most likely to be referenced, sorting it to the front of the array was
+ * advantageous.  The current binary search starts from the middle of the array
+ * and uses an LRU pointer to improve performance for all memslots and GFNs.
  */
 static void update_memslots(struct kvm_memslots *slots,
-			    struct kvm_memory_slot *new,
+			    struct kvm_memory_slot *memslot,
 			    enum kvm_mr_change change)
 {
-	int id = new->id;
-	int i = slots->id_to_index[id];
-	struct kvm_memory_slot *mslots = slots->memslots;
+	int i;
 
-	WARN_ON(mslots[i].id != id);
-	switch (change) {
-	case KVM_MR_CREATE:
-		slots->used_slots++;
-		WARN_ON(mslots[i].npages || !new->npages);
-		break;
-	case KVM_MR_DELETE:
-		slots->used_slots--;
-		WARN_ON(new->npages || !mslots[i].npages);
-		break;
-	default:
-		break;
-	}
+	if (change == KVM_MR_DELETE) {
+		kvm_memslot_delete(slots, memslot);
+	} else {
+		if (change == KVM_MR_CREATE)
+			i = kvm_memslot_insert_back(slots);
+		else
+			i = kvm_memslot_move_backward(slots, memslot);
+		i = kvm_memslot_move_forward(slots, memslot, i);
 
-	while (i < KVM_MEM_SLOTS_NUM - 1 &&
-	       new->base_gfn <= mslots[i + 1].base_gfn) {
-		if (!mslots[i + 1].npages)
-			break;
-		mslots[i] = mslots[i + 1];
-		slots->id_to_index[mslots[i].id] = i;
-		i++;
+		/*
+		 * Copy the memslot to its new position in memslots and update
+		 * its index accordingly.
+		 */
+		slots->memslots[i] = *memslot;
+		slots->id_to_index[memslot->id] = i;
 	}
-
-	/*
-	 * The ">=" is needed when creating a slot with base_gfn == 0,
-	 * so that it moves before all those with base_gfn == npages == 0.
-	 *
-	 * On the other hand, if new->npages is zero, the above loop has
-	 * already left i pointing to the beginning of the empty part of
-	 * mslots, and the ">=" would move the hole backwards in this
-	 * case---which is wrong.  So skip the loop when deleting a slot.
-	 */
-	if (new->npages) {
-		while (i > 0 &&
-		       new->base_gfn >= mslots[i - 1].base_gfn) {
-			mslots[i] = mslots[i - 1];
-			slots->id_to_index[mslots[i].id] = i;
-			i--;
-		}
-	} else
-		WARN_ON_ONCE(i != slots->used_slots);
-
-	mslots[i] = *new;
-	slots->id_to_index[mslots[i].id] = i;
 }
 
 static int check_memory_region_flags(const struct kvm_userspace_memory_region *mem)
@@ -1042,8 +1141,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	 * when the memslots are re-sorted by update_memslots().
 	 */
 	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
-	old = *tmp;
-	tmp = NULL;
+	if (tmp) {
+		old = *tmp;
+		tmp = NULL;
+	} else {
+		memset(&old, 0, sizeof(old));
+		old.id = id;
+	}
 
 	if (!mem->memory_size)
 		return kvm_delete_memslot(kvm, mem, &old, as_id);
@@ -1161,7 +1265,7 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 
 	slots = __kvm_memslots(kvm, as_id);
 	*memslot = id_to_memslot(slots, id);
-	if (!(*memslot)->dirty_bitmap)
+	if (!(*memslot) || !(*memslot)->dirty_bitmap)
 		return -ENOENT;
 
 	kvm_arch_sync_dirty_log(kvm, *memslot);
@@ -1219,10 +1323,10 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 
 	slots = __kvm_memslots(kvm, as_id);
 	memslot = id_to_memslot(slots, id);
+	if (!memslot || !memslot->dirty_bitmap)
+		return -ENOENT;
 
 	dirty_bitmap = memslot->dirty_bitmap;
-	if (!dirty_bitmap)
-		return -ENOENT;
 
 	kvm_arch_sync_dirty_log(kvm, memslot);
 
@@ -1330,10 +1434,10 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 
 	slots = __kvm_memslots(kvm, as_id);
 	memslot = id_to_memslot(slots, id);
+	if (!memslot || !memslot->dirty_bitmap)
+		return -ENOENT;
 
 	dirty_bitmap = memslot->dirty_bitmap;
-	if (!dirty_bitmap)
-		return -ENOENT;
 
 	n = ALIGN(log->num_pages, BITS_PER_LONG) / 8;
 
-- 
2.22.0

