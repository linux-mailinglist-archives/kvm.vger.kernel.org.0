Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB7F43D7C4
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 01:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhJ0X4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 19:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhJ0X4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Oct 2021 19:56:53 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9335C061745
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 16:54:27 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g184so4564400pgc.6
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 16:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xhttgZaRcXKhN8bT5rGKDM9G1nNGHoVSJvvEjSamdmo=;
        b=F1aF0RJfL4T5AfgY+pQ8Y9pf3c/UZ0dt/vfbynnJstQRjRvVdVcB6p0ENa0xiB88YU
         1xpUaYFd7v0Dg3QAVzBzyQGhk71h/xPvyDaJqOoZTOlcyLYWWt4YDBpLIkW5JAIwuT9d
         qNg5sr4YYLYm+GndjsfzlutqXqUviuqqju+2R2r1mfyYFUZzjRcv2e4Yz/1KJfvmIOXx
         wlrKG8QG+bfnX1TXnG394wXIxFrqhOPgPAcMmzKbV4u6K2bfsij68FlW2NhxFmZLxBBQ
         xUWJulra+q698mHmhQ0Bw7h7QYELYq+W7kZ8DQOspY8kJG6zI1ZFgMb2y0Vl0XUkTFzf
         GxIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xhttgZaRcXKhN8bT5rGKDM9G1nNGHoVSJvvEjSamdmo=;
        b=OtJvgGi+OVX0wm0Mv1sqy2qbuB7FmJaQrQmJx7TR7UT2ZckiwjzxPQIv4Im9FTauGI
         YftOjPARY1FkkehGdx7666r2sF+rv1emx9hCenWUwSTGYBtSEaTj0RpPOdRrumD08I37
         vwYVcZpPjCJdHrAoX6XZ8xsr5i1iVh7SO9KmPA1jCFJGhwM/zWVOUivbiMKg7bGSHIWu
         CCsQNB4CSOEfHLnII23bxBL3Z+Fro5vNlXqm0Ot93J/9B4s2IGsA5b/078m8ranKn+7l
         jNUscojznXm/to67i6t0n63pjdmx++Y/5BwvCXk0Cpqapl021tEtOFLZqmtY9uLkkEgP
         ORxA==
X-Gm-Message-State: AOAM532IpLgoWjP0cOu1TGWFJnrIXS42k6IfFAXmsNN1/UMgFWNwQEI5
        uADrejoCsGkA0hZe012Z5oZASA==
X-Google-Smtp-Source: ABdhPJyr5wiSDd4cKYlqvfX3Ehy9Lb1emsU9nXT5Gv26AHxKR5IBWeeX/MVAaWaCbgWowikyPl9a/g==
X-Received: by 2002:a63:9550:: with SMTP id t16mr641809pgn.318.1635378867042;
        Wed, 27 Oct 2021 16:54:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f7sm1048335pfv.152.2021.10.27.16.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 16:54:26 -0700 (PDT)
Date:   Wed, 27 Oct 2021 23:54:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
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
Subject: Re: [PATCH v5 11/13] KVM: Keep memslots in tree-based structures
 instead of array-based ones
Message-ID: <YXnmrqhvc4mzxZfn@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <0c35c60b524dd264cc6abb6a48bc253958f99673.1632171479.git.maciej.szmigiero@oracle.com>
 <YXie8z7w4AiFx4bP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXie8z7w4AiFx4bP@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 27, 2021, Sean Christopherson wrote:
> I'll get a series for the fix posted tomorrow, and hopefully reply with my thoughts
> for this patch too.

Knew I should have hedged.  I got a series compiling, but it's completed untested
otheriwse.  I do have input for this patch though.

The cleanups I have prepped allow for a few things:

  1. Dropping the copy of the old memslot, thus freeing up "old" to be a pointer
     to the actual old memslot.

  2. Folding the existing kvm_delete_memslot() into __kvm_set_memory_region() to
     free up the name for a helper to kvm_set_memslot().

  3. Handling the dirty bitmap and memslot freeing in generic versions of prepare
     and commit.  This is related to #1.

And then for this patch, there is a hard invariant that we can rely on to make
the code easier to follow, and that is: KVM can never directly modify a slot that
is in the active memslots tree(s).  That invariant means there is no need to track
the active vs. inactive memslots, because all helpers simply retrieve the inactive
memslot on-demand.

And doling out the work to helpers also mostly eliminates the need to track the
inactive vs. active slot.  There's still some slightly twisty logic, especially for
the MOVE case (which nobody uses, *sigh*).  If we really want, even that mess can
be cleaned up by pre-allocating an extra memslot, but I don't think it's worth the
effort so long as things are well documented.

Anyway, the twisty logic is mostly a matter of documentation; IMO it's actually
advantageous to not swap pointers as the different naming and behavior highlights
the differences between each type of change, especially with respect to side
effects.

I'll post the full series tomorrow (this part is unlikely to be tested, but the
prep work will be tested).  Below is the meat of kvm_set_memslot().  Again,
compile tested only, there's a 99.999999% chance it's buggy.

As for naming, "working" was the least awful name I could come up with.  I also
considered "scratch" and "tmp".  I'm definitely open to other names.

And finally, ignore my comments on the other patch about using memcpy().  KVM
copies memslot structs all over the place without memcpy(), i.e. I was being
paranoid and/or delusional :-)

static void kvm_invalidate_memslot(struct kvm *kvm,
				   struct kvm_memory_slot *old,
				   struct kvm_memory_slot *working_slot)
{
	/*
	 * Mark the current slot INVALID.  As with all memslot modifications,
	 * this must be done on an unreachable slot to avoid modifying the
	 * current slot in the active tree.
	 */
	kvm_copy_memslot(working_slot, old);
	working_slot->flags |= KVM_MEMSLOT_INVALID;
	kvm_replace_memslot(kvm, old, working_slot);

	/*
	 * Activate the slot that is now marked INVALID, but don't propagate
	 * the slot to the now inactive slots. The slot is either going to be
	 * deleted or recreated as a new slot.
	 */
	kvm_swap_active_memslots(kvm, old->as_id);

	/*
	 * From this point no new shadow pages pointing to a deleted, or moved,
	 * memslot will be created.  Validation of sp->gfn happens in:
	 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
	 *	- kvm_is_visible_gfn (mmu_check_root)
	 */
	kvm_arch_flush_shadow_memslot(kvm, old);

	/* Was released by kvm_swap_active_memslots, reacquire. */
	mutex_lock(&kvm->slots_arch_lock);

	/*
	 * Copy the arch-specific field of the newly-installed slot back to the
	 * old slot as the arch data could have changed between releasing
	 * slots_arch_lock in install_new_memslots() and re-acquiring the lock
	 * above.  Writers are required to retrieve memslots *after* acquiring
	 * slots_arch_lock, thus the active slot's data is guaranteed to be fresh.
	 */
	old->arch = working_slot->arch;
}

static void kvm_create_memslot(struct kvm *kvm,
			       const struct kvm_memory_slot *new,
			       struct kvm_memory_slot *working)
{
	/*
	 * Add the new memslot to the inactive set as a copy of the
	 * new memslot data provided by userspace.
	 */
	kvm_copy_memslot(working, new);
	kvm_replace_memslot(kvm, NULL, working);
	kvm_activate_memslot(kvm, NULL, working);
}

static void kvm_delete_memslot(struct kvm *kvm,
			       struct kvm_memory_slot *old,
			       struct kvm_memory_slot *invalid_slot)
{
	/*
	 * Remove the old memslot (in the inactive memslots) by passing NULL as
	 * the "new" slot.
	 */
	kvm_replace_memslot(kvm, old, NULL);

	/* And do the same for the invalid version in the active slot. */
	kvm_activate_memslot(kvm, invalid_slot, NULL);

	/* Free the invalid slot, the caller will clean up the old slot. */
	kfree(invalid_slot);
}

static struct kvm_memory_slot *kvm_move_memslot(struct kvm *kvm,
						struct kvm_memory_slot *old,
						const struct kvm_memory_slot *new,
						struct kvm_memory_slot *invalid_slot)
{
	struct kvm_memslots *slots = kvm_get_inactive_memslots(kvm, old->as_id);

	/*
	 * The memslot's gfn is changing, remove it from the inactive tree, it
	 * will be re-added with its updated gfn. Because its range is
	 * changing, an in-place replace is not possible.
	 */
	kvm_memslot_gfn_erase(slots, old);

	/*
	 * The old slot is now fully disconnected, reuse its memory for the
	 * persistent copy of "new".
	 */
	kvm_copy_memslot(old, new);

	/* Re-add to the gfn tree with the updated gfn */
	kvm_memslot_gfn_insert(slots, old);

	/* Replace the current INVALID slot with the updated memslot. */
	kvm_activate_memslot(kvm, invalid_slot, old);

	/*
	 * Clear the INVALID flag so that the invalid_slot is now a perfect
	 * copy of the old slot.  Return it for cleanup in the caller.
	 */
	WARN_ON_ONCE(!(invalid_slot->flags & KVM_MEMSLOT_INVALID));
	invalid_slot->flags &= ~KVM_MEMSLOT_INVALID;
	return invalid_slot;
}

static void kvm_update_flags_memslot(struct kvm *kvm,
				     struct kvm_memory_slot *old,
				     const struct kvm_memory_slot *new,
				     struct kvm_memory_slot *working_slot)
{
	/*
	 * Similar to the MOVE case, but the slot doesn't need to be
	 * zapped as an intermediate step. Instead, the old memslot is
	 * simply replaced with a new, updated copy in both memslot sets.
	 *
	 * Since the memslot gfn is unchanged, kvm_copy_replace_memslot()
	 * and kvm_memslot_gfn_replace() can be used to switch the node
	 * in the gfn tree instead of removing the old and inserting the
	 * new as two separate operations. Replacement is a single O(1)
	 * operation versus two O(log(n)) operations for remove+insert.
	 */
	kvm_copy_memslot(working_slot, new);
	kvm_replace_memslot(kvm, old, working_slot);
	kvm_activate_memslot(kvm, old, working_slot);
}


static int kvm_set_memslot(struct kvm *kvm,
			   struct kvm_memory_slot *old,
			   struct kvm_memory_slot *new,
			   enum kvm_mr_change change)
{
	struct kvm_memory_slot *working;
	int r;

	/*
	 * Modifications are done on an unreachable slot.  Any changes are then
	 * (eventually) propagated to both the active and inactive slots.  This
	 * allocation would ideally be on-demand (in helpers), but is done here
	 * to avoid having to handle failure after kvm_prepare_memory_region().
	 */
	working = kzalloc(sizeof(*working), GFP_KERNEL_ACCOUNT);
	if (!working)
		return -ENOMEM;

	/*
	 * Released in kvm_swap_active_memslots.
	 *
	 * Must be held from before the current memslots are copied until
	 * after the new memslots are installed with rcu_assign_pointer,
	 * then released before the synchronize srcu in kvm_swap_active_memslots.
	 *
	 * When modifying memslots outside of the slots_lock, must be held
	 * before reading the pointer to the current memslots until after all
	 * changes to those memslots are complete.
	 *
	 * These rules ensure that installing new memslots does not lose
	 * changes made to the previous memslots.
	 */
	mutex_lock(&kvm->slots_arch_lock);

	/*
	 * Invalidate the old slot if it's being deleted or moved.  This is
	 * done prior to actually deleting/moving the memslot to allow vCPUs to
	 * continue running by ensuring there are no mappings or shadow pages
	 * for the memslot when it is deleted/moved.  Without pre-invalidation
	 * (and without a lock), a window would exist between effecting the
	 * delete/move and committing the changes in arch code where KVM or a
	 * guest could access a non-existent memslot.
	 */
	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
		kvm_invalidate_memslot(kvm, old, working);

	r = kvm_prepare_memory_region(kvm, old, new, change);
	if (r) {
		/*
		 * For DELETE/MOVE, revert the above INVALID change.  No
		 * modifications required since the original slot was preserved
		 * in the inactive slots.  Changing the active memslots also
		 * releases slots_arch_lock.
		 */
		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
			kvm_activate_memslot(kvm, working, old);
		else
			mutex_unlock(&kvm->slots_arch_lock);
		kfree(working);
		return r;
	}

	/*
	 * For DELETE and MOVE, the working slot is now active as the INVALID
	 * version of the old slot.  MOVE is particularly special as it reuses
	 * the old slot and returns a copy of the old slot (in working_slot).
	 * For CREATE, there is no old slot.  For DELETE and FLAGS_ONLY, the
	 * old slot is detached but otherwise preserved.
	 */
	if (change == KVM_MR_CREATE)
		kvm_create_memslot(kvm, new, working);
	else if (change == KVM_MR_DELETE)
		kvm_delete_memslot(kvm, old, working);
	if (change == KVM_MR_MOVE)
		old = kvm_move_memslot(kvm, old, new, working);
	else if (change == KVM_MR_FLAGS_ONLY)
		kvm_update_flags_memslot(kvm, old, new, working);
	else
		BUG();

	/*
	 * No need to refresh new->arch, changes after dropping slots_arch_lock
	 * will directly hit the final, active memsot.  Architectures are
	 * responsible for knowing that new->arch may be stale.
	 */
	kvm_commit_memory_region(kvm, old, new, change);

	return 0;
}
