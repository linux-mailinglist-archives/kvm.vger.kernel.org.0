Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3374598EA
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 01:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhKWAGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 19:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhKWAG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 19:06:29 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D44C061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 16:03:22 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id w22so25701688ioa.1
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 16:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=stWiZiGTSwVid2A/+7YAxsYrikFxsEbDB3/dzoejbFQ=;
        b=qcKqjgkT4AGeJfHMYD5GQqfScLC2NbkBovmOvHm7Lot2171iQWFksNz2Kg+RrlgYHb
         P/kki5ZFOeDf5xoEY7B+yJvShN99hNjQy5Lj9Umh279Ht1mQmJWl0EIXiQfdFhH3KBnE
         01xFKmTfkAqTKJ7mOXXrnUzS8I+xBhw8h9i47dTdUuYjTtO0Ao5HdyONdxTgooTZXsAm
         Qv6vXKA6/tZgQX6AoY/pMAKlJrXQYRVjqPHVDFjSc81qdCE4kVl3IIk8ddsUDCjkxama
         nx24rmeV0N7WtRRJO5/8dKy/GyJ5uQ7oXVfufJ35u2gokQ4pccak7dgdNjQpArY9W10e
         rwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=stWiZiGTSwVid2A/+7YAxsYrikFxsEbDB3/dzoejbFQ=;
        b=glZADR+hMMJ2WENF/IsovZnuawa3v5pKEh6WgfBzxpfT4UR0+jveuRw0oh36iSnH7+
         jXy9JOp6SK9BC4A/I1aCNYMkoIQrsNJ6Gu9v1tFlb4p+N128ng3iVh8sQsFKETRMNzIg
         P6lWkm3M0zRbTfyAPREh20oqHHXPRamhfCATjTTAFW0faCTp/tw/07hGlzjEFkKwv0Kn
         px9jI2bue8E/zDhU0aMgD4LiFRedeGowA/wSwQ6QvbZVQFCUTVh59E/NVphIGa/aQOUw
         4BMcRqfg0eV37Q5mggrfTe6gvR+ry6MrTj8EygVKUJMtDi18hRlrLPR3ey46uu+6VwaS
         mP4w==
X-Gm-Message-State: AOAM530MkmaXltpaztMA1PTrjn8HbxcM8hJHpI/zBWXl8e4tkmusXqnQ
        VXuUO2Dnt9a+vchjiPVJDOc/X8PfOR5KXAqTOdvp8g==
X-Google-Smtp-Source: ABdhPJw1AijdwZkEvl/S8oatNZnkSQ8pCA1IN2sjD9iTcR1ADb99iHRm79ZAe/AtDCgKnIcoNfgJbPPjIDk5cg6nahk=
X-Received: by 2002:a5d:9d92:: with SMTP id ay18mr1082492iob.130.1637625801802;
 Mon, 22 Nov 2021 16:03:21 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-16-seanjc@google.com>
 <CANgfPd8Kz41FpvooznGW2VLp8GZFei28FCjonr2+YEZoturi0A@mail.gmail.com> <YZwi+TzVLQi5YlIX@google.com>
In-Reply-To: <YZwi+TzVLQi5YlIX@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 16:03:10 -0800
Message-ID: <CANgfPd8s=8SY2R_Cg+gytU6VU2PhOqkOwtq9fAdXCgp+GRpmQg@mail.gmail.com>
Subject: Re: [PATCH 15/28] KVM: x86/mmu: Take TDP MMU roots off list when
 invalidating all roots
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

On Mon, Nov 22, 2021 at 3:08 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Nov 22, 2021, Ben Gardon wrote:
> > On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > Take TDP MMU roots off the list of roots when they're invalidated instead
> > > of walking later on to find the roots that were just invalidated.  In
> > > addition to making the flow more straightforward, this allows warning
> > > if something attempts to elevate the refcount of an invalid root, which
> > > should be unreachable (no longer on the list so can't be reached by MMU
> > > notifier, and vCPUs must reload a new root before installing new SPTE).
> > >
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> >
> > There are a bunch of awesome little cleanups and unrelated fixes
> > included in this commit that could be factored out.
> >
> > I'm skeptical of immediately moving the invalidated roots into another
> > list as that seems like it has a lot of potential for introducing
> > weird races.
>
> I disagree, the entire premise of fast invalidate is that there can't be races,
> i.e. mmu_lock must be held for write.  IMO, it's actually the opposite, as the only
> reason leaving roots on the per-VM list doesn't have weird races is because slots_lock
> is held.  If slots_lock weren't required to do a fast zap, which is feasible for the
> TDP MMU since it doesn't rely on the memslots generation, then it would be possible
> for multiple calls to kvm_tdp_mmu_zap_invalidated_roots() to run in parallel.  And in
> that case, leaving roots on the per-VM list would lead to a single instance of a
> "fast zap" zapping roots it didn't invalidate.  That's wouldn't be problematic per se,
> but I don't like not having a clear "owner" of the invalidated root.

That's a good point, the potential interleaving of zap_alls would be gross.

My mental model for the invariant here was "roots that are still in
use are on the roots list," but I can see how "the roots list contains
all valid, in-use roots" could be a more useful invariant.

>
> > I'm not sure it actually solves a problem either. Part of
> > the motive from the commit description "this allows warning if
> > something attempts to elevate the refcount of an invalid root" can be
> > achieved already without moving the roots into a separate list.
>
> Hmm, true in the sense that kvm_tdp_mmu_get_root() could be converted to a WARN,
> but that would require tdp_mmu_next_root() to manually skip invalid roots.
> kvm_tdp_mmu_get_vcpu_root_hpa() is naturally safe because page_role_for_level()
> will never set the invalid flag.
>
> I don't care too much about adding a manual check in tdp_mmu_next_root(), what I don't
> like is that a WARN in kvm_tdp_mmu_get_root() wouldn't be establishing an invariant
> that invalidated roots are unreachable, it would simply be forcing callers to check
> role.invalid.

That makes sense.

>
> > Maybe this would seem more straightforward with some of the little
> > cleanups factored out, but this feels more complicated to me.
> > > @@ -124,6 +137,27 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
> > >  {
> > >         struct kvm_mmu_page *next_root;
> > >
> > > +       lockdep_assert_held(&kvm->mmu_lock);
> > > +
> > > +       /*
> > > +        * Restart the walk if the previous root was invalidated, which can
> > > +        * happen if the caller drops mmu_lock when yielding.  Restarting the
> > > +        * walke is necessary because invalidating a root also removes it from
> >
> > Nit: *walk
> >
> > > +        * tdp_mmu_roots.  Restarting is safe and correct because invalidating
> > > +        * a root is done if and only if _all_ roots are invalidated, i.e. any
> > > +        * root on tdp_mmu_roots was added _after_ the invalidation event.
> > > +        */
> > > +       if (prev_root && prev_root->role.invalid) {
> > > +               kvm_tdp_mmu_put_root(kvm, prev_root, shared);
> > > +               prev_root = NULL;
> > > +       }
> > > +
> > > +       /*
> > > +        * Finding the next root must be done under RCU read lock.  Although
> > > +        * @prev_root itself cannot be removed from tdp_mmu_roots because this
> > > +        * task holds a reference, its next and prev pointers can be modified
> > > +        * when freeing a different root.  Ditto for tdp_mmu_roots itself.
> > > +        */
> >
> > I'm not sure this is correct with the rest of the changes in this
> > patch. The new version of invalidate_roots removes roots from the list
> > immediately, even if they have a non-zero ref-count.
>
> Roots don't have to be invalidated to be removed, e.g. if the last reference is
> put due to kvm_mmu_reset_context().  Or did I misunderstand?

Ah, sorry that was kind of a pedantic comment. I think the comment
should say "@prev_root itself cannot be removed from tdp_mmu_roots
because this task holds the MMU lock (in read or write mode)"
With the other changes in the patch, holding a reference on a root
provides protection against it being freed, but not against it being
removed from the roots list.

>
> > >         rcu_read_lock();
> > >
> > >         if (prev_root)
> > > @@ -230,10 +264,13 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> > >         root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
> > >         refcount_set(&root->tdp_mmu_root_count, 1);
> > >
> > > -       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > > -       list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
> > > -       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > > -
> > > +       /*
> > > +        * Because mmu_lock must be held for write to ensure that KVM doesn't
> > > +        * create multiple roots for a given role, this does not need to use
> > > +        * an RCU-friendly variant as readers of tdp_mmu_roots must also hold
> > > +        * mmu_lock in some capacity.
> > > +        */
> >
> > I doubt we're doing it now, but in principle we could allocate new
> > roots with mmu_lock in read + tdp_mmu_pages_lock. That might be better
> > than depending on the write lock.
>
> We're not, this function does lockdep_assert_held_write(&kvm->mmu_lock) a few
> lines above.  I don't have a preference between using mmu_lock.read+tdp_mmu_pages_lock
> versus mmu_lock.write, but I do care that the current code doesn't incorrectly imply
> that it's possible for something else to be walking the roots while this runs.

That makes sense. It seems like it'd be pretty easy to let this run
under the read lock, but I'd be fine with either way. I agree both
options are an improvement.

>
> Either way, this should definitely be a separate patch, pretty sure I just lost
> track of it.
>
> > > +       list_add(&root->link, &kvm->arch.tdp_mmu_roots);
> > >  out:
> > >         return __pa(root->spt);
> > >  }
