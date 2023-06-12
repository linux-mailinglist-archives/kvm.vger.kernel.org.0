Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB54C72C8D4
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 16:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237611AbjFLOlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 10:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbjFLOlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 10:41:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA649A8
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 07:41:19 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb85b2bac4eso6597659276.0
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 07:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686580879; x=1689172879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r96CKlC+BBXhesVFXxXqygeyQq0poKy+xHh5QJBs4Hs=;
        b=y5PvZbyvq4ur+SImkmV6DIR+nXay4q20zUtWROecR8NkFyPCbRlfzlSXb08VHyg/vM
         dOWUJGqoSQckjKNyaz+pnvlIbc/677Wf4OzrLTPm1+LO4/mptCVJ4e/Uk+aHgUwJ+qSO
         6q3pBgeV/DXdB2SrpAoZHsul6MRWS/ngRQx7PvnfSncRT+IhtiBjR2O5HaFqcuUji5y/
         DOi2db5ZPa4WjG6g0fnovTI6kQ3PEcYEB8tswr99owkyAhvk3/tSEErpWrgDXQt9LTPZ
         /nTtyzShFuyCqIkJg63tnvrN+wl2h1zgCd7ffB+m3fyoqhO7Xk893eGC+g3501H5ycqW
         mSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686580879; x=1689172879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r96CKlC+BBXhesVFXxXqygeyQq0poKy+xHh5QJBs4Hs=;
        b=FRyWRkni1sSaFkH+YyR5huiG9LS4g8nf6qaGwm2iQZlG0JplRHmrXYLnEvXE4x6LPC
         ObcQBkkoYEwB12x1p2Rcgs/JRJFQ61+Nliwvhgg4hJknaofB0SEtTrAeIxtH402y2WQR
         9QmoJnWuw3Gz/BJ3H8iMr5BlvPFjS+ZtIL5HJoXYbVbmRIqNAtIF7iq4p2ceyqtPscZV
         e3AaW+IoEZsIpHHYWeoO/pVb6XdIa9sx9It80q/Z2qKfz1p4JdtDMmswvMlJsxIml/ae
         kkPoo1GI7qX0gCD9ZVXPhW68JeLIvKu+J3EKKErAFpftrK2jjQ2FSYfn+CrmAvkBrR4Q
         iu9g==
X-Gm-Message-State: AC+VfDz3pDdEeD2HzbmqQHvf+rCdPjIl1ER4wmg0WZvx/YiMk+o6Ndto
        TFPHDFTqM0C14dCT0ziP+67YNHvn9hU=
X-Google-Smtp-Source: ACHHUZ6zdAuLarXFuermSwK+q6naBdSNEG8tLfWV/XWK13b5XH60U7w3+nxNcTpXxK1HrGqXhuWbcHMQm9g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bc2:0:b0:ba6:e7ee:bb99 with SMTP id
 185-20020a250bc2000000b00ba6e7eebb99mr5041142ybl.12.1686580879112; Mon, 12
 Jun 2023 07:41:19 -0700 (PDT)
Date:   Mon, 12 Jun 2023 07:41:16 -0700
In-Reply-To: <20230608090348.414990-1-gshan@redhat.com>
Mime-Version: 1.0
References: <20230608090348.414990-1-gshan@redhat.com>
Message-ID: <ZIcujNKVosLeQEqR@google.com>
Subject: Re: [PATCH] KVM: Avoid illegal stage2 mapping on invalid memory slot
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        oliver.upton@linux.dev, maz@kernel.org, hshuai@redhat.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023, Gavin Shan wrote:
> We run into guest hang in edk2 firmware when KSM is kept as running
> on the host. The edk2 firmware is waiting for status 0x80 from QEMU's
> pflash device (TYPE_PFLASH_CFI01) during the operation for sector
> erasing or buffered write. The status is returned by reading the
> memory region of the pflash device and the read request should
> have been forwarded to QEMU and emulated by it. Unfortunately, the
> read request is covered by an illegal stage2 mapping when the guest
> hang issue occurs. The read request is completed with QEMU bypassed and
> wrong status is fetched.
> 
> The illegal stage2 mapping is populated due to same page mering by
> KSM at (C) even the associated memory slot has been marked as invalid
> at (B).
> 
>   CPU-A                    CPU-B
>   -----                    -----
>                            ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION)
>                            kvm_vm_ioctl_set_memory_region
>                            kvm_set_memory_region
>                            __kvm_set_memory_region
>                            kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE)
>                              kvm_invalidate_memslot
>                                kvm_copy_memslot
>                                kvm_replace_memslot
>                                kvm_swap_active_memslots        (A)
>                                kvm_arch_flush_shadow_memslot   (B)
>   same page merging by KSM
>   kvm_mmu_notifier_change_pte
>   kvm_handle_hva_range
>   __kvm_handle_hva_range       (C)
> 
> Fix the issue by skipping the invalid memory slot at (C) to avoid the
> illegal stage2 mapping. Without the illegal stage2 mapping, the read
> request for the pflash's status is forwarded to QEMU and emulated by
> it. The correct pflash's status can be returned from QEMU to break
> the infinite wait in edk2 firmware.
> 
> Cc: stable@vger.kernel.org # v5.13+
> Fixes: 3039bcc74498 ("KVM: Move x86's MMU notifier memslot walkers to generic code")

This Fixes isn't correct.  That change only affected x86, which doesn't have this
bug.  And looking at commit cd4c71835228 ("KVM: arm64: Convert to the gfn-based MMU
notifier callbacks"), arm64 did NOT skip invalid slots

        slots = kvm_memslots(kvm);

        /* we only care about the pages that the guest sees */
        kvm_for_each_memslot(memslot, slots) {
                unsigned long hva_start, hva_end;
                gfn_t gpa;

                hva_start = max(start, memslot->userspace_addr);
                hva_end = min(end, memslot->userspace_addr +
                                        (memslot->npages << PAGE_SHIFT));
                if (hva_start >= hva_end)
                        continue;

                gpa = hva_to_gfn_memslot(hva_start, memslot) << PAGE_SHIFT;
                ret |= handler(kvm, gpa, (u64)(hva_end - hva_start), data);
        }

#define kvm_for_each_memslot(memslot, slots)                            \
        for (memslot = &slots->memslots[0];                             \
             memslot < slots->memslots + slots->used_slots; memslot++)  \
                if (WARN_ON_ONCE(!memslot->npages)) {                   \
                } else

Unless I'm missing something, this goes all the way back to initial arm64 support
added by commit d5d8184d35c9 ("KVM: ARM: Memory virtualization setup").

> Reported-by: Shuai Hu <hshuai@redhat.com>
> Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 479802a892d4..7f81a3a209b6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -598,6 +598,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  			unsigned long hva_start, hva_end;
>  
>  			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
> +			if (slot->flags & KVM_MEMSLOT_INVALID)
> +				continue;

Skipping the memslot will lead to use-after-free.  E.g. if an invalidate_range_start()
comes along between installing the invalid slot and zapping SPTEs, KVM will
return from kvm_mmu_notifier_invalidate_range_start() without having dropped all
references to the range.

I.e.

	kvm_copy_memslot(invalid_slot, old);
	invalid_slot->flags |= KVM_MEMSLOT_INVALID;
	kvm_replace_memslot(kvm, old, invalid_slot);

	/*
	 * Activate the slot that is now marked INVALID, but don't propagate
	 * the slot to the now inactive slots. The slot is either going to be
	 * deleted or recreated as a new slot.
	 */
	kvm_swap_active_memslots(kvm, old->as_id);


==> invalidate_range_start()

	/*
	 * From this point no new shadow pages pointing to a deleted, or moved,
	 * memslot will be created.  Validation of sp->gfn happens in:
	 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
	 *	- kvm_is_visible_gfn (mmu_check_root)
	 */
	kvm_arch_flush_shadow_memslot(kvm, old);

And even for change_pte(), skipping the memslot is wrong, as KVM would then fail
unmap the prior SPTE.  Of course, that can't happen in the current code base
because change_pte() is wrapped with invalidate_range_{start,end}(), but that's
more of a bug than a design choice (see c13fda237f08 "KVM: Assert that notifier
count is elevated in .change_pte()" for details).  That's also why this doesn't
show up on x86; x86 installs a SPTE for the change_pte() notifier iff an existing
SPTE is present, which is never true due to the invalidation.

I'd honestly love to just delete the change_pte() callback, but my opinion is more
than a bit biased since we don't use KSM.  Assuming we keep change_pte(), the best
option is probably to provide a wrapper around kvm_set_spte_gfn() to skip the
memslot, but with a sanity check and comment explaining the dependency on there
being no SPTEs due to the invalidation.  E.g.

---
 virt/kvm/kvm_main.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 479802a892d4..b4987b49fac3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -686,6 +686,24 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 
 	return __kvm_handle_hva_range(kvm, &range);
 }
+
+static bool kvm_change_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	/*
+	 * Skipping invalid memslots is correct if and only change_pte() is
+	 * surrounded by invalidate_range_{start,end}(), which is currently
+	 * guaranteed by the primary MMU.  If that ever changes, KVM needs to
+	 * unmap the memslot instead of skipping the memslot to ensure that KVM
+	 * doesn't hold references to the old PFN.
+	 */
+	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
+
+        if (range->slot->flags & KVM_MEMSLOT_INVALID)
+		return false;
+
+	return kvm_set_spte_gfn(kvm, range);
+}
+
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long address,
@@ -707,7 +725,7 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
 		return;
 
-	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
+	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_change_spte_gfn);
 }
 
 void kvm_mmu_invalidate_begin(struct kvm *kvm, unsigned long start,

base-commit: 94cdeebd82111d7b7da5bd4da053eed9e0f65d72
--
