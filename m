Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D355E45AC90
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 20:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbhKWTit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 14:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234924AbhKWTis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 14:38:48 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B37BC061714
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 11:35:40 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id p23so52717iod.7
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 11:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ucNIn3z++wzCwtlfmsvcWdlPYzoFbmTEmF2M6hyhBwI=;
        b=tQMnoa4+qz/Z41aGmrjYClQCD8PCyRPzy1m/yn/nNwokdqmFLe/IrZvJCbXJfRiBqE
         eLNWKs0BUE9eP6cpHfSQICVBQ6JZpExv02I70DyjsfWGRm1BHaOOAqlc0n86bkOs3z6v
         HhS4++Y5Qz5T4jtC7PS39Q7k8FgeC7Lxh2B5uUDmX41J4XGfG1z+E0+uPDFkzCu3wcfD
         nszKuyqDLcSnI07R4wGuUO3glVzTHEnV4VM2NNVkJAkWeIAEFJJJU7krQ49ORwzuzLzr
         jmEKzmE0zSqnOUoj1K/WImOCvF5pnXvBdzy3lfMMkUqJR5Dd9pJaKTj9B2X92Z+8sH6V
         psFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ucNIn3z++wzCwtlfmsvcWdlPYzoFbmTEmF2M6hyhBwI=;
        b=ogafspy7et8k6P9gjNuHpkbXMZr87U1z44nP/78OjTePom2j3av5dF5R5aR/R1Zy4O
         ucbgXUdP3YfFt5r122DTbfDr99E10kjDdTWQ2W+f7xsvht1OLD/HQ6GZgXlMCtVVWN6i
         4HrvaZJ/CP/42N/55Lfu4TLi2l5wrW2KpmJoBSd2k59Hf7t6xlMdYddYyFbqwrCl7CBB
         vGwP21HqrnxjXxCcdGR6JDGEm0QmkaM5qwL/qAp8Dbd3A2bkYOs8Bs1bbkGDUx4Y/bNo
         Sor1KAxnVF9+671/88uTi9LL2da5/nKfHc7p4GDTHBr+hmu38UpTH4CNF8v8kXABSWhJ
         UTKw==
X-Gm-Message-State: AOAM531J/t8JGl/xXHKWF/rEZkM7hNH4Uxbs6RTlysxesx5wdgbk/dV5
        tStxHIwG4J0CShG/DrIZf4XfTMHGPnO4uSli0ZVH9GaALGM=
X-Google-Smtp-Source: ABdhPJz1Q5be47A5QaEz2ud5Vd/DaXz1jSr4PV8Oat5SPte2Qr/URb8mmYQb+i9Xn23rPMixU/RtwZdGaRaE9QnluWc=
X-Received: by 2002:a5d:8049:: with SMTP id b9mr8671820ior.41.1637696139607;
 Tue, 23 Nov 2021 11:35:39 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-20-seanjc@google.com>
 <CANgfPd83h4dXa-bFY96dkwHfJsdqu65BAzbqztgEhiRcHFquJw@mail.gmail.com> <YZxA1VAs5FNbjmH9@google.com>
In-Reply-To: <YZxA1VAs5FNbjmH9@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 23 Nov 2021 11:35:28 -0800
Message-ID: <CANgfPd9CdP-4aYkM7SCtCtV+v4T3HsyG6F8tLu=FCBz1nt=htg@mail.gmail.com>
Subject: Re: [PATCH 19/28] KVM: x86/mmu: Zap only the target TDP MMU shadow
 page in NX recovery
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 5:16 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Nov 22, 2021, Ben Gardon wrote:
> > On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
> > > @@ -755,6 +759,26 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
> > >         return false;
> > >  }
> > >
> > > +bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> > > +{
> > > +       u64 old_spte;
> > > +
> > > +       rcu_read_lock();
> > > +
> > > +       old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
> > > +       if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte))) {
> > > +               rcu_read_unlock();
> > > +               return false;
> > > +       }
> > > +
> > > +       __tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
> > > +                          sp->gfn, sp->role.level + 1, true, true);
> > > +
> > > +       rcu_read_unlock();
> > > +
> > > +       return true;
> > > +}
> > > +
> >
> > Ooooh this makes me really nervous. There are a lot of gotchas to
> > modifying SPTEs in a new context without traversing the paging
> > structure like this. For example, we could modify an SPTE under an
> > invalidated root here. I don't think that would be a problem since
> > we're just clearing it, but it makes the code more fragile.
>
> Heh, it better not be a problem, because there are plently of flows in the TDP MMU
> that can modify SPTEs under an invalidated root, e.g. fast_page_fault(),
> tdp_mmu_zap_leafs(), kvm_age_gfn(), kvm_test_age_gfn(), etc...  And before the
> patch that introduced is_page_fault_stale(), kvm_tdp_mmu_map() was even installing
> SPTEs into an invalid root!  Anything that takes a reference to a root and yields
> (or never takes mmu_lock) can potentially modify a SPTE under an invalid root.

That's true, I don't think there's really a problem with this commit,
just a different way of dealing with the PTs.


>
> Checking the paging structures for this flow wouldn't change anything.  Invalidating
> a root doesn't immediately zap SPTEs, it just marks the root invalid.  The other
> subtle gotcha is that kvm_reload_remote_mmus() doesn't actually gaurantee all vCPUs
> will have dropped the invalid root or performed a TLB flush when mmu_lock is dropped,
> those guarantees are only with respect to re-entering the guest!
>
> All of the above is no small part of why I don't want to walk the page tables:
> it's completely misleading as walking the page tables doesn't actually provide any
> protection, it's holding RCU that guarantees KVM doesn't write memory it doesn't own.

That's a great point. I was thinking about the RCU protection being
sort of passed down through the RCU dereferences from the root of the
paging structure to whatever SPTE we modify, but since we protect the
SPs with RCU too, dereferencing from them is just as good, I suppose.

>
> > Another approach to this would be to do in-place promotion / in-place
> > splitting once the patch sets David and I just sent out are merged.  That
> > would avoid causing extra page faults here to bring in the page after this
> > zap, but it probably wouldn't be safe if we did it under an invalidated root.
>
> I agree that in-place promotion would be better, but if we do that, I think a logical
> intermediate step would be to stop zapping unrelated roots and entries.  If there's
> a bug that is exposed/introduced by not zapping other stuff, I would much rather it
> show up when KVM stops zapping other stuff, not when KVM stops zapping other stuff
> _and_ promotes in place.  Ditto for if in-place promotion introduces a bug.

That makes sense. I think this is a good first step.

>
> > I'd rather avoid this extra complexity and just tolerate the worse
> > performance on the iTLB multi hit mitigation at this point since new
> > CPUs seem to be moving past that vulnerability.
>
> IMO, it reduces complexity, especially when looking at the series as a whole, which
> I fully realize you haven't yet done :-)  Setting aside the complexities of each
> chunk of code, what I find complex with the current TDP MMU zapping code is that
> there are no precise rules for what needs to be done in each situation.  I'm not
> criticizing how we got to this point, I absolutely think that hitting everything
> with a big hammer to get the initial version stable was the right thing to do.
>
> But a side effect of the big hammer approach is that it makes reasoning about things
> more difficult, e.g. "when is it safe to modify a SPTE versus when is it safe to insert
> a SPTE into the paging structures?" or "what needs to be zapped when the mmu_notifier
> unmaps a range?".
>
> And I also really want to avoid another snafu like the memslots with passthrough
> GPUs bug, where using a big hammer (zap all) when a smaller hammer (zap SPTEs for
> the memslot) _should_ work allows bugs to creep in unnoticed because they're hidden
> by overzealous zapping.
>
> > If you think this is worth the complexity, it'd be nice to do a little
> > benchmarking to make sure it's giving us a substantial improvement.
>
> Performance really isn't a motivating factor.  Per the changelog, the motivation
> is mostly to allow later patches to simplify zap_gfn_range() by having it zap only
> leaf SPTEs, and now that I've typed it up, also all of the above :-)

That makes sense, and addresses all my concerns. Carry on.
Thanks for writing all that up.
