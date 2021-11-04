Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B89444C80
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhKDAay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbhKDA33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:29:29 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2158AC06120A
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:51 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h10-20020a63df4a000000b002a6ba425b58so2357508pgj.17
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3Oix+myx2pXtaS6qqrhKXXYNSd1duRmSeNBjYBf01G8=;
        b=T7Li7ANfcPjBCbj9+DKfUi7E9HMHRR8t88UjyTqohCm/C++BNDUxZXBn8j2DcZEMpA
         mGH99sOh4E8WZVeHdeK5wa0d8OLkGRmOX4YXznGdWL6AB9m9J3jtSowWUg1EyEutLwr5
         fkW1iLLRMw7OXqnk0p24PkMbV7hX3G2oA1DSKGJbgsR2aHpCbSNVMPsjMTDk/W+ZDEp/
         b64dLnClxvtc2rQaa2CAN6FFezvBplkeeQHRAO6rLRDw6CPgh8y6I646/QDdI6sBQQy5
         uSFKdlP01SbOENjWGmAGklxMJ4DGwF5mxZUiawv9p04MF/m4dQOPwzlzNNQs9/4alG9t
         x1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3Oix+myx2pXtaS6qqrhKXXYNSd1duRmSeNBjYBf01G8=;
        b=qTJhmE800YrPRVammu7NSxlbuJZV0xGdygJWoZ28FS4ASl3pv01JbTUe80SMYCrwNp
         /i4BC9b5mHna6UeG2eeQXtMLFrqDmtlysnqaXavLtTG/ZpYr+UzERy+eFIqcMZ7Xn1la
         WeZG9AhAUokjLM/cyHitv4QNn3bdVpF06FEc7+HcYtZ7Kzf4f9klo0JcrTcktzoPppEC
         GO1U3UwLWa8hzWwA+NFm+UAO07YSjvNEM9uXZILD721V1HOpzR2qEsyQVytDiN0I8Ywc
         Kx0lQJbHnzYD6DGqmHJKmoqjEzT9UqZ1pkKmfS6TLlM4v7FuqJ4N8Iq4DQQtPZBF+R7q
         DEoA==
X-Gm-Message-State: AOAM533rYFXx52NgFuz540zU+24fij+J3ZC3nwk+Gr6iAQOQ9QPHKiOD
        Ls4C3ykk9YVKoDnbnEX3BsViEhQI8Mc=
X-Google-Smtp-Source: ABdhPJxLsPJIYgU5iZvZVjIfCmGT4IcCcexgXJGOXXxz+DqiMhdzOwQbPPyTYzjNKnPa760AvzYmQj7kGXY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:114c:b0:47b:b98b:2210 with SMTP id
 b12-20020a056a00114c00b0047bb98b2210mr48415016pfm.75.1635985610490; Wed, 03
 Nov 2021 17:26:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:31 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-31-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 30/30] KVM: Dynamically allocate "new" memslots from the get-go
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 virt/kvm/kvm_main.c | 178 +++++++++++++++++++-------------------------
 1 file changed, 77 insertions(+), 101 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5cc0b50faa8c..b413082c081d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1488,23 +1488,25 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
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
@@ -1591,16 +1593,16 @@ static void kvm_copy_memslot(struct kvm_memory_slot *dest,
 
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
@@ -1627,20 +1629,15 @@ static void kvm_invalidate_memslot(struct kvm *kvm,
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
@@ -1649,65 +1646,36 @@ static void kvm_delete_memslot(struct kvm *kvm,
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
 	/*
-	 * The memslot's gfn is changing, remove it from the inactive tree, it
-	 * will be re-added with its updated gfn. Because its range is
-	 * changing, an in-place replace is not possible.
+	 * Replace the old memslot in the inactive slots, and then swap slots
+	 * and replace the current INVALID with the new as well.
 	 */
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
-	/*
-	 * Clear the INVALID flag so that the invalid_slot is now a perfect
-	 * copy of the old slot.  Return it for cleanup in the caller.
-	 */
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
@@ -1715,19 +1683,9 @@ static int kvm_set_memslot(struct kvm *kvm,
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
@@ -1752,9 +1710,19 @@ static int kvm_set_memslot(struct kvm *kvm,
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
@@ -1764,11 +1732,12 @@ static int kvm_set_memslot(struct kvm *kvm,
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
 
@@ -1780,16 +1749,20 @@ static int kvm_set_memslot(struct kvm *kvm,
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
@@ -1834,8 +1807,7 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region *mem)
 {
-	struct kvm_memory_slot *old;
-	struct kvm_memory_slot new;
+	struct kvm_memory_slot *old, *new;
 	struct kvm_memslots *slots;
 	enum kvm_mr_change change;
 	unsigned long npages;
@@ -1884,11 +1856,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
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
@@ -1921,14 +1889,22 @@ int __kvm_set_memory_region(struct kvm *kvm,
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
 
-	return kvm_set_memslot(kvm, old, &new, change);
+	new->as_id = as_id;
+	new->id = id;
+	new->base_gfn = base_gfn;
+	new->npages = npages;
+	new->flags = mem->flags;
+	new->userspace_addr = mem->userspace_addr;
+
+	r = kvm_set_memslot(kvm, old, new, change);
+	if (r)
+		kfree(new);
+	return r;
 }
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
 
-- 
2.33.1.1089.g2158813163f-goog

