Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0500B72E666
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241177AbjFMO6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235221AbjFMO6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:58:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05B1BB
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:58:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bc5281cc3f6so3567910276.2
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686668324; x=1689260324;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K+0kD4PW2dGvQpmF8P/dLcdDL49MrQOe0Bs/vjodXCo=;
        b=s2yBwT/46quu0M19ZvyZP44LoDcCKdMQJ+XCkKZbDNyv+8ckqdNWOyCvkG8VjAfgN7
         uoiWalI4a8yp5SOMD6vH553yZNIzDjAkzQ239tTAj6IhyfEhQKiz0ZFgNzkAZQ5Rg4lc
         vY8AZ7Tq6at3vgdO6nOz88vcWuNRmK2AHw7CqKwZOS1ZzhUPpLOdCFFQAg7usWc0KIXA
         IsEx7XaFzEoUxWZWK33CoQkBNI/vMlBuybEkOvNtPBfghXhuvaE2IIoqd4OJub7loHTY
         Cv2lqA2gqJqOXdrTezHH/eKF4JQ8DTBI9CPHbQhTu+Kb9VEboFZiAKVm64JJAwJFxidO
         pGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686668324; x=1689260324;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K+0kD4PW2dGvQpmF8P/dLcdDL49MrQOe0Bs/vjodXCo=;
        b=Bl8OsLqbTzzQaoMsxJ68017wbKl0QYU+lOdr4MFVJ0Ja9Hc7Jw622SA2UBBN+O+Kxv
         X2Q4vasf0qoWXqb7PSqhvpJ7yFKKbKWKuKKf5LSRJ6Vxj+jsaiXUZxzUy96k9g6xxTE0
         hShqTeb47ztRfA+bEfPEgZudr1gwbTk8RH1W8JBnP7QhKW2lZuh16LEj//BUNF11MF8s
         k0cmi2qQyd+L5eJJil0Lr4ReNwgZWE9WtanjylHJiRZdyWAzS+ml+X68b1cKWjvzO9BF
         f1QiHwMBJFbZLKNQiFZYHtl7wE0N5DfUIKb6EvVLiZuCqPHauKR4vBbhmjAp6iVKjONh
         lb1g==
X-Gm-Message-State: AC+VfDxbw9VmwHKoL7zSY7HtzeY4RAWlPnoBEQvyuNlOgMC/QNkvMqcZ
        odebhfiKs5UvLBxOH8sjwCD28UpktmA=
X-Google-Smtp-Source: ACHHUZ45bwZa/PJKAhYeklX7zhd5j76j407QtmxG6njgLhIsPRNiUhLcNEOwpA1xPza96/WjN2Xmwx93NXE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:352:b0:bcd:f98e:f5f with SMTP id
 e18-20020a056902035200b00bcdf98e0f5fmr765169ybs.13.1686668324159; Tue, 13 Jun
 2023 07:58:44 -0700 (PDT)
Date:   Tue, 13 Jun 2023 07:58:42 -0700
In-Reply-To: <6e335f13-01bd-2972-ead2-3081819aa151@redhat.com>
Mime-Version: 1.0
References: <20230608090348.414990-1-gshan@redhat.com> <ZIcujNKVosLeQEqR@google.com>
 <6e335f13-01bd-2972-ead2-3081819aa151@redhat.com>
Message-ID: <ZIiEIkn1lFU7Vr1z@google.com>
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

On Tue, Jun 13, 2023, Gavin Shan wrote:
> Hi Sean,
> 
> On 6/13/23 12:41 AM, Sean Christopherson wrote:
> > > Fixes: 3039bcc74498 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
> > 
> > This Fixes isn't correct.  That change only affected x86, which doesn't have this
> > bug.  And looking at commit cd4c71835228 ("KVM: arm64: Convert to the gfn-based MMU
> > notifier callbacks"), arm64 did NOT skip invalid slots

...

> > Unless I'm missing something, this goes all the way back to initial arm64 support
> > added by commit d5d8184d35c9 ("KVM: ARM: Memory virtualization setup").
> > 
> 
> The fixes tag was sorted out based on 'git-bisect', not static code analysis. I
> agree it should be d5d8184d35c9 ("KVM: ARM: Memory virtualization setup") from
> the code. From the 'git-bisect', we found the issue disappears when the head is
> commit 3039bcc74498 ("KVM: Move x86's MMU notifier memslot walkers to generic code").
> And yes, the fixes tag should be cd4c71835228 ("KVM: arm64: Convert to the gfn-based
> MMU notifier callbacks").

No, just because bisect points at a commit doesn't mean that's the commit that
introduced a bug.  It's not uncommon for a completely valid change to expose a
pre-existing bug, which is what I suspect happened here, e.g. after switching to
the generic framework, clean_dcache_guest_page() is called *after* retrieving the
memslot, versus clean_dcache_guest_page() being called before walking memslots.

Blaming the correct commit matters, both so that it's clear to future readers what
went wrong, and also so that people maintaining older kernels at least are aware
that there kernel may be affected.  E.g. a fix in generic KVM obviously won't
backport to 5.10, but someone who cares deeply about a 5.10-based kernel on arm64
could manually port the fix to KVM arm64 code.

> I'm declined to fix the issue only for ARM64,

I never suggested that an ARM-only fix be made, in fact I explicitly suggested
the exact opposite.

> more details are given below. If we're going to limit the issue to ARM64 and
> fix it for ARM64 only, the fixes tag should be the one as you pointed. Lets
> correct it in next revision with:

For a generic fix, just blame multiple commits, e.g. the guilty arm64, RISC-V,
and MIPS commits, which at a glance are the affected architectures.  At one point
in time, x86 was also likely affected, but that's probably not worth more than a
brief mention in the changelog as I don't see any value in tracking down a very
theoretical window of time where x86 was affected.

>   Cc: stable@vger.kernel.org # v3.9+
>   Fixes: d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
> 
> > > Reported-by: Shuai Hu <hshuai@redhat.com>
> > > Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
> > > Signed-off-by: Gavin Shan <gshan@redhat.com>
> > > ---
> > >   virt/kvm/kvm_main.c | 3 +++
> > >   1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 479802a892d4..7f81a3a209b6 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -598,6 +598,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
> > >   			unsigned long hva_start, hva_end;
> > >   			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
> > > +			if (slot->flags & KVM_MEMSLOT_INVALID)
> > > +				continue;
> > 
> > Skipping the memslot will lead to use-after-free.  E.g. if an invalidate_range_start()
> > comes along between installing the invalid slot and zapping SPTEs, KVM will
> > return from kvm_mmu_notifier_invalidate_range_start() without having dropped all
> > references to the range.
> > 
> > I.e.
> > 
> > 	kvm_copy_memslot(invalid_slot, old);
> > 	invalid_slot->flags |= KVM_MEMSLOT_INVALID;
> > 	kvm_replace_memslot(kvm, old, invalid_slot);
> > 
> > 	/*
> > 	 * Activate the slot that is now marked INVALID, but don't propagate
> > 	 * the slot to the now inactive slots. The slot is either going to be
> > 	 * deleted or recreated as a new slot.
> > 	 */
> > 	kvm_swap_active_memslots(kvm, old->as_id);
> > 
> > 
> > ==> invalidate_range_start()
> > 
> > 	/*
> > 	 * From this point no new shadow pages pointing to a deleted, or moved,
> > 	 * memslot will be created.  Validation of sp->gfn happens in:
> > 	 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
> > 	 *	- kvm_is_visible_gfn (mmu_check_root)
> > 	 */
> > 	kvm_arch_flush_shadow_memslot(kvm, old);
> > 
> > And even for change_pte(), skipping the memslot is wrong, as KVM would then fail
> > unmap the prior SPTE.  Of course, that can't happen in the current code base
> > because change_pte() is wrapped with invalidate_range_{start,end}(), but that's
> > more of a bug than a design choice (see c13fda237f08 "KVM: Assert that notifier
> > count is elevated in .change_pte()" for details).  That's also why this doesn't
> > show up on x86; x86 installs a SPTE for the change_pte() notifier iff an existing
> > SPTE is present, which is never true due to the invalidation.
> > 
> 
> Right, those architectural dependencies are really something I worried about.

The zap case isn't a architecture specific, that's true for all KVM architectures.

> It's safe to skip the invalid memory slots for ARM64,

No, it's not.  The problematic window where an invalidation can be incorrectly
skipped is very tiny, and would have zero chance of being seen without something
generating invalidations, e.g. page migration.  But that doesn't mean there's no
bug.

> but it may be unsafe to do so for other architectures. You've listed the
> potential risks to do so for x86. It might be risky with PowerPC's reverse
> mapping stuff either. I didn't look into the code for the left architectures.
> In order to escape from the architectural conflicts, I would move the check
> and skip the invalid memory slot in arch/arm64/kvm/mmu.c::kvm_set_spte_gfn(),
> something like below. In this way, the guest hang issue in ARM64 guest is
> fixed. We may have similar issue on other architectures, but we can figure
> out the fix when we have to.  Sean, please let me know if you're happy with
> this?
> 
> arch/arm64/kvm/mmu.c::kvm_set_spte_gfn()
> ----------------------------------------
> 
> bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> {
>         kvm_pfn_t pfn = pte_pfn(range->pte);
> 
>         if (!kvm->arch.mmu.pgt)
>                 return false;
> 
>         /*
>          * The memory slot can become invalid temporarily or permanently
>          * when it's being moved or deleted. Avoid the stage2 mapping so
>          * that all the read and write requests to the region of the memory
>          * slot can be forwarded to VMM and emulated there.
>          */
>          if (range->slot->flags & KVM_MEMSLOT_INVALID)
>              return false;

Please no.  (a) it papers over common KVM's reliance on the SPTE being zapped by
invalidate_range_start(), and (b) it leaves the same bug in RISC-V (which copy+pasted
much of arm64's MMU code) and in MIPS (which also installs SPTEs in its callback).

>          WARN_ON(range->end - range->start != 1);
> 
>          :
> }
> 
> > I'd honestly love to just delete the change_pte() callback, but my opinion is more
> > than a bit biased since we don't use KSM.  Assuming we keep change_pte(), the best
> > option is probably to provide a wrapper around kvm_set_spte_gfn() to skip the
> > memslot, but with a sanity check and comment explaining the dependency on there
> > being no SPTEs due to the invalidation.  E.g.
> > 
> 
> It's good idea, but I'm afraid other architectures like PowerPC will still be
> affected.

I don't follow.  PPC unmaps in response to a PTE change, but that's effectively
dead code due to change_pte() being wrapped with invalidate_range_{start,end}().

> So I would like to limit this issue to ARM64 and fix it in its
> kvm_set_spte_gfn() variant, as above. One question about "we don't use KSM":
> could you please share more information about this? I'm blindly guessing
> you're saying KSM isn't used in google cloud?

Yeah, we == Google/GCE.  Sorry, should have clarified that.
