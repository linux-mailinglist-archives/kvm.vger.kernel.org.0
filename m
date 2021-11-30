Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDFA46409C
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 22:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbhK3Vtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 16:49:40 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:56964 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233416AbhK3Vsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 16:48:46 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msAvH-0006HM-HW; Tue, 30 Nov 2021 22:44:23 +0100
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
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 29/29] KVM: Dynamically allocate "new" memslots from the get-go
Date:   Tue, 30 Nov 2021 22:41:42 +0100
Message-Id: <78c28a71d1bf19c14151ef8bddb72250a1896826.1638304316.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638304315.git.maciej.szmigiero@oracle.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Allocate the "new" memslot for !DELETE memslot updates straight away
instead of filling an intermediate on-stack object and forcing
kvm_set_memslot() to juggle the allocation and do weird things like reuse
the old memslot object in MOVE.

In the MOVE case, this results in an "extra" memslot allocation due to
allocating both the "new" slot and the "invalid" slot, but that's a
temporary and not-huge allocation, and MOVE is a relatively rare memslot
operation.

Regarding MOVE, drop the open-coded management of the gfn tree with a
call to kvm_replace_memslot(), which already handles the case where
new->base_gfn != old->base_gfn.  This is made possible by virtue of not
having to copy the "new" memslot data after erasing the old memslot from
the gfn tree.  Using kvm_replace_memslot(), and more specifically not
reusing the old memslot, means the MOVE case now does hva tree and hash
list updates, but that's a small price to pay for simplifying the code
and making MOVE align with all the other flavors of updates.  The "extra"
updates are firmly in the noise from a performance perspective, e.g. the
"move (in)active area" selfttests show a (very, very) slight improvement.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 virt/kvm/kvm_main.c | 178 +++++++++++++++++++-------------------------
 1 file changed, 77 insertions(+), 101 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8295d87c07b5..b0360afb127b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1505,23 +1505,25 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 	 * new and KVM isn't using a ring buffer, allocate and initialize a
 	 * new bitmap.
 	 */
-	if (!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
-		new->dirty_bitmap = NULL;
-	else if (old->dirty_bitmap)
-		new->dirty_bitmap = old->dirty_bitmap;
-	else if (!kvm->dirty_ring_size) {
-		r = kvm_alloc_dirty_bitmap(new);
-		if (r)
-			return r;
+	if (change != KVM_MR_DELETE) {
+		if (!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
+			new->dirty_bitmap = NULL;
+		else if (old && old->dirty_bitmap)
+			new->dirty_bitmap = old->dirty_bitmap;
+		else if (!kvm->dirty_ring_size) {
+			r = kvm_alloc_dirty_bitmap(new);
+			if (r)
+				return r;
 
-		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
-			bitmap_set(new->dirty_bitmap, 0, new->npages);
+			if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+				bitmap_set(new->dirty_bitmap, 0, new->npages);
+		}
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, old, new, change);
 
 	/* Free the bitmap on failure if it was allocated above. */
-	if (r && new->dirty_bitmap && !old->dirty_bitmap)
+	if (r && new && new->dirty_bitmap && old && !old->dirty_bitmap)
 		kvm_destroy_dirty_bitmap(new);
 
 	return r;
@@ -1608,16 +1610,16 @@ static void kvm_copy_memslot(struct kvm_memory_slot *dest,
 
 static void kvm_invalidate_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *old,
-				   struct kvm_memory_slot *working_slot)
+				   struct kvm_memory_slot *invalid_slot)
 {
 	/*
 	 * Mark the current slot INVALID.  As with all memslot modifications,
 	 * this must be done on an unreachable slot to avoid modifying the
 	 * current slot in the active tree.
 	 */
-	kvm_copy_memslot(working_slot, old);
-	working_slot->flags |= KVM_MEMSLOT_INVALID;
-	kvm_replace_memslot(kvm, old, working_slot);
+	kvm_copy_memslot(invalid_slot, old);
+	invalid_slot->flags |= KVM_MEMSLOT_INVALID;
+	kvm_replace_memslot(kvm, old, invalid_slot);
 
 	/*
 	 * Activate the slot that is now marked INVALID, but don't propagate
@@ -1644,20 +1646,15 @@ static void kvm_invalidate_memslot(struct kvm *kvm,
 	 * above.  Writers are required to retrieve memslots *after* acquiring
 	 * slots_arch_lock, thus the active slot's data is guaranteed to be fresh.
 	 */
-	old->arch = working_slot->arch;
+	old->arch = invalid_slot->arch;
 }
 
 static void kvm_create_memslot(struct kvm *kvm,
-			       const struct kvm_memory_slot *new,
-			       struct kvm_memory_slot *working)
+			       struct kvm_memory_slot *new)
 {
-	/*
-	 * Add the new memslot to the inactive set as a copy of the
-	 * new memslot data provided by userspace.
-	 */
-	kvm_copy_memslot(working, new);
-	kvm_replace_memslot(kvm, NULL, working);
-	kvm_activate_memslot(kvm, NULL, working);
+	/* Add the new memslot to the inactive set and activate. */
+	kvm_replace_memslot(kvm, NULL, new);
+	kvm_activate_memslot(kvm, NULL, new);
 }
 
 static void kvm_delete_memslot(struct kvm *kvm,
@@ -1666,65 +1663,36 @@ static void kvm_delete_memslot(struct kvm *kvm,
 {
 	/*
 	 * Remove the old memslot (in the inactive memslots) by passing NULL as
-	 * the "new" slot.
+	 * the "new" slot, and for the invalid version in the active slots.
 	 */
 	kvm_replace_memslot(kvm, old, NULL);
-
-	/* And do the same for the invalid version in the active slot. */
 	kvm_activate_memslot(kvm, invalid_slot, NULL);
-
-	/* Free the invalid slot, the caller will clean up the old slot. */
-	kfree(invalid_slot);
 }
 
-static struct kvm_memory_slot *kvm_move_memslot(struct kvm *kvm,
-						struct kvm_memory_slot *old,
-						const struct kvm_memory_slot *new,
-						struct kvm_memory_slot *invalid_slot)
+static void kvm_move_memslot(struct kvm *kvm,
+			     struct kvm_memory_slot *old,
+			     struct kvm_memory_slot *new,
+			     struct kvm_memory_slot *invalid_slot)
 {
-	struct kvm_memslots *slots = kvm_get_inactive_memslots(kvm, old->as_id);
-
-	/*
-	 * The memslot's gfn is changing, remove it from the inactive tree, it
-	 * will be re-added with its updated gfn. Because its range is
-	 * changing, an in-place replace is not possible.
-	 */
-	kvm_erase_gfn_node(slots, old);
-
-	/*
-	 * The old slot is now fully disconnected, reuse its memory for the
-	 * persistent copy of "new".
-	 */
-	kvm_copy_memslot(old, new);
-
-	/* Re-add to the gfn tree with the updated gfn */
-	kvm_insert_gfn_node(slots, old);
-
-	/* Replace the current INVALID slot with the updated memslot. */
-	kvm_activate_memslot(kvm, invalid_slot, old);
-
 	/*
-	 * Clear the INVALID flag so that the invalid_slot is now a perfect
-	 * copy of the old slot.  Return it for cleanup in the caller.
+	 * Replace the old memslot in the inactive slots, and then swap slots
+	 * and replace the current INVALID with the new as well.
 	 */
-	WARN_ON_ONCE(!(invalid_slot->flags & KVM_MEMSLOT_INVALID));
-	invalid_slot->flags &= ~KVM_MEMSLOT_INVALID;
-	return invalid_slot;
+	kvm_replace_memslot(kvm, old, new);
+	kvm_activate_memslot(kvm, invalid_slot, new);
 }
 
 static void kvm_update_flags_memslot(struct kvm *kvm,
 				     struct kvm_memory_slot *old,
-				     const struct kvm_memory_slot *new,
-				     struct kvm_memory_slot *working_slot)
+				     struct kvm_memory_slot *new)
 {
 	/*
 	 * Similar to the MOVE case, but the slot doesn't need to be zapped as
 	 * an intermediate step. Instead, the old memslot is simply replaced
 	 * with a new, updated copy in both memslot sets.
 	 */
-	kvm_copy_memslot(working_slot, new);
-	kvm_replace_memslot(kvm, old, working_slot);
-	kvm_activate_memslot(kvm, old, working_slot);
+	kvm_replace_memslot(kvm, old, new);
+	kvm_activate_memslot(kvm, old, new);
 }
 
 static int kvm_set_memslot(struct kvm *kvm,
@@ -1732,19 +1700,9 @@ static int kvm_set_memslot(struct kvm *kvm,
 			   struct kvm_memory_slot *new,
 			   enum kvm_mr_change change)
 {
-	struct kvm_memory_slot *working;
+	struct kvm_memory_slot *invalid_slot;
 	int r;
 
-	/*
-	 * Modifications are done on an unreachable slot.  Any changes are then
-	 * (eventually) propagated to both the active and inactive slots.  This
-	 * allocation would ideally be on-demand (in helpers), but is done here
-	 * to avoid having to handle failure after kvm_prepare_memory_region().
-	 */
-	working = kzalloc(sizeof(*working), GFP_KERNEL_ACCOUNT);
-	if (!working)
-		return -ENOMEM;
-
 	/*
 	 * Released in kvm_swap_active_memslots.
 	 *
@@ -1769,9 +1727,19 @@ static int kvm_set_memslot(struct kvm *kvm,
 	 * (and without a lock), a window would exist between effecting the
 	 * delete/move and committing the changes in arch code where KVM or a
 	 * guest could access a non-existent memslot.
+	 *
+	 * Modifications are done on a temporary, unreachable slot.  The old
+	 * slot needs to be preserved in case a later step fails and the
+	 * invalidation needs to be reverted.
 	 */
-	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
-		kvm_invalidate_memslot(kvm, old, working);
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+		invalid_slot = kzalloc(sizeof(*invalid_slot), GFP_KERNEL_ACCOUNT);
+		if (!invalid_slot) {
+			mutex_unlock(&kvm->slots_arch_lock);
+			return -ENOMEM;
+		}
+		kvm_invalidate_memslot(kvm, old, invalid_slot);
+	}
 
 	r = kvm_prepare_memory_region(kvm, old, new, change);
 	if (r) {
@@ -1781,11 +1749,12 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 * in the inactive slots.  Changing the active memslots also
 		 * release slots_arch_lock.
 		 */
-		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
-			kvm_activate_memslot(kvm, working, old);
-		else
+		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+			kvm_activate_memslot(kvm, invalid_slot, old);
+			kfree(invalid_slot);
+		} else {
 			mutex_unlock(&kvm->slots_arch_lock);
-		kfree(working);
+		}
 		return r;
 	}
 
@@ -1797,16 +1766,20 @@ static int kvm_set_memslot(struct kvm *kvm,
 	 * old slot is detached but otherwise preserved.
 	 */
 	if (change == KVM_MR_CREATE)
-		kvm_create_memslot(kvm, new, working);
+		kvm_create_memslot(kvm, new);
 	else if (change == KVM_MR_DELETE)
-		kvm_delete_memslot(kvm, old, working);
+		kvm_delete_memslot(kvm, old, invalid_slot);
 	else if (change == KVM_MR_MOVE)
-		old = kvm_move_memslot(kvm, old, new, working);
+		kvm_move_memslot(kvm, old, new, invalid_slot);
 	else if (change == KVM_MR_FLAGS_ONLY)
-		kvm_update_flags_memslot(kvm, old, new, working);
+		kvm_update_flags_memslot(kvm, old, new);
 	else
 		BUG();
 
+	/* Free the temporary INVALID slot used for DELETE and MOVE. */
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
+		kfree(invalid_slot);
+
 	/*
 	 * No need to refresh new->arch, changes after dropping slots_arch_lock
 	 * will directly hit the final, active memsot.  Architectures are
@@ -1840,8 +1813,7 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region *mem)
 {
-	struct kvm_memory_slot *old;
-	struct kvm_memory_slot new;
+	struct kvm_memory_slot *old, *new;
 	struct kvm_memslots *slots;
 	enum kvm_mr_change change;
 	unsigned long npages;
@@ -1890,11 +1862,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if (WARN_ON_ONCE(kvm->nr_memslot_pages < old->npages))
 			return -EIO;
 
-		memset(&new, 0, sizeof(new));
-		new.id = id;
-		new.as_id = as_id;
-
-		return kvm_set_memslot(kvm, old, &new, KVM_MR_DELETE);
+		return kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE);
 	}
 
 	base_gfn = (mem->guest_phys_addr >> PAGE_SHIFT);
@@ -1927,14 +1895,22 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	    kvm_check_memslot_overlap(slots, id, base_gfn, base_gfn + npages))
 		return -EEXIST;
 
-	new.as_id = as_id;
-	new.id = id;
-	new.base_gfn = base_gfn;
-	new.npages = npages;
-	new.flags = mem->flags;
-	new.userspace_addr = mem->userspace_addr;
+	/* Allocate a slot that will persist in the memslot. */
+	new = kzalloc(sizeof(*new), GFP_KERNEL_ACCOUNT);
+	if (!new)
+		return -ENOMEM;
+
+	new->as_id = as_id;
+	new->id = id;
+	new->base_gfn = base_gfn;
+	new->npages = npages;
+	new->flags = mem->flags;
+	new->userspace_addr = mem->userspace_addr;
 
-	return kvm_set_memslot(kvm, old, &new, change);
+	r = kvm_set_memslot(kvm, old, new, change);
+	if (r)
+		kfree(new);
+	return r;
 }
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
 
