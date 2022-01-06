Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085F948695E
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 19:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242553AbiAFSFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 13:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242313AbiAFSE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 13:04:59 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4331C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 10:04:58 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id s4so5402657ljd.5
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 10:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9RQQVXb3K9QFJLleNkPTlG/NLsCLRB3opm8DeLxYYGY=;
        b=S0K+FCvYWj/psmL45Ty9DDDb3i4p94xySv+dTRaHKP4X0Aw2X+aeZebCUPiVfG/X/f
         CRfmvkRm4zlK426bPMqEDaZkZiajzjgFX9X2Lt/pjBEcUFZOeHfg3dy8E7EaF4ap60vx
         jk0PSnLVOMeW/SPTAUKpJXeEFY55OICvNCltxI4njQp4DX1TgO9nEIzK8gNnjP5q5yt+
         XcXWwq5hwwyObtks3KyLj7seTkypx3B9FI0z9x9ZkTwcEQrBSr9X+PqzEQiXCnWbwCXp
         Xa6k5zmidWFnyKJWnjnvM75XRrin7ZRwNh8z6DVwa+dMXd8S/TBoeKMPn1W9Ilhns9dI
         z49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9RQQVXb3K9QFJLleNkPTlG/NLsCLRB3opm8DeLxYYGY=;
        b=e6uubORuRNl9OD9Fuml9nVgLnd3Av+L7aJDWFD7NM5trKIsG2nEVBJb4R5WNTf8JfG
         UbqR88iIdPU6NCZ53kHnvTkNQ2G2uRFge9lzt9CwHVcnvGQMU/kYOPlHTpeTssLnSbcV
         d5BuoXlbdGVXZuYqrHdCgtwpYTRHLVIuXLoFBnvKEqrapwe6JcqUamMoynJma1ucT0SV
         oxnvZ6eaGjnOnt3qDhPqRnc7A44H4ez82j5ubQLqdEayUdJDEIfiGIkT+BQw+df1lWcs
         4rZla3hCBTisH1cMqYllHJOkCIa4Mvu7tPUB2NschG+lUS55Y9D0R7hywHHR5L1BO/Za
         Vupw==
X-Gm-Message-State: AOAM532LwxRrs7bMCg1FHnJDMWSgPczHXgwzfS4Z2ApWaLNM07HJoQ/X
        9ki2CJglAxR84Grs5FO5xaMZkua9rI9rP8tNYWy9Lg==
X-Google-Smtp-Source: ABdhPJxu9xuXZ/Mg0lUT+cPt4g0uw/JLU6BOWisPMwQpOmnObzvc+5+GkZILxlbaB6SIZZsCG/+YwACpLvTkf6Kyi+E=
X-Received: by 2002:a2e:b893:: with SMTP id r19mr39653197ljp.464.1641492296882;
 Thu, 06 Jan 2022 10:04:56 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-4-dmatlack@google.com>
 <YdY9x7nNtMs0kyvm@google.com>
In-Reply-To: <YdY9x7nNtMs0kyvm@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 6 Jan 2022 10:04:30 -0800
Message-ID: <CALzav=dEVE3CUd-Oh_UovAApgca8hvK8wUAKuttDH_fdv9U2sA@mail.gmail.com>
Subject: Re: [PATCH v1 03/13] KVM: x86/mmu: Automatically update
 iter->old_spte if cmpxchg fails
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 5, 2022 at 4:54 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Dec 13, 2021, David Matlack wrote:
> > Consolidate a bunch of code that was manually re-reading the spte if the
> > cmpxchg fails. There is no extra cost of doing this because we already
> > have the spte value as a result of the cmpxchg (and in fact this
> > eliminates re-reading the spte), and none of the call sites depend on
> > iter->old_spte retaining the stale spte value.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 50 ++++++++++++++++----------------------
> >  1 file changed, 21 insertions(+), 29 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index b69e47e68307..656ebf5b20dc 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -492,16 +492,22 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> >   * and handle the associated bookkeeping.  Do not mark the page dirty
> >   * in KVM's dirty bitmaps.
> >   *
> > + * If setting the SPTE fails because it has changed, iter->old_spte will be
> > + * updated with the updated value of the spte.
>
> First updated=>refreshed, second updated=>current?  More below.
>
> > + *
> >   * @kvm: kvm instance
> >   * @iter: a tdp_iter instance currently on the SPTE that should be set
> >   * @new_spte: The value the SPTE should be set to
> >   * Returns: true if the SPTE was set, false if it was not. If false is returned,
> > - *       this function will have no side-effects.
> > + *          this function will have no side-effects other than updating
>
> s/updating/setting
>
> > + *          iter->old_spte to the latest value of spte.
>
> Strictly speaking, "latest" may not be true if yet another thread modifies the
> SPTE.  Maybe this?
>
>                 iter->old_spte to the last known value of the SPTE.
>
> >   */
> >  static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
> >                                          struct tdp_iter *iter,
> >                                          u64 new_spte)
> >  {
> > +     u64 old_spte;
> > +
> >       lockdep_assert_held_read(&kvm->mmu_lock);
> >
> >       /*
> > @@ -515,9 +521,15 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
> >        * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
> >        * does not hold the mmu_lock.
> >        */
> > -     if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
> > -                   new_spte) != iter->old_spte)
> > +     old_spte = cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte, new_spte);
>
> To make this a bit easier to read, and to stay under 80 chars, how about
> opportunistically doing this as well?
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 656ebf5b20dc..64f1369f8638 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -506,6 +506,7 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
>                                            struct tdp_iter *iter,
>                                            u64 new_spte)
>  {
> +       u64 *sptep = rcu_dereference(iter->sptep);
>         u64 old_spte;
>
>         lockdep_assert_held_read(&kvm->mmu_lock);
> @@ -521,7 +522,7 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
>          * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
>          * does not hold the mmu_lock.
>          */
> -       old_spte = cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte, new_spte);
> +       old_spte = cmpxchg64(sptep, iter->old_spte, new_spte);
>         if (old_spte != iter->old_spte) {
>                 /*
>                  * The cmpxchg failed because the spte was updated by another
>
> > +     if (old_spte != iter->old_spte) {
> > +             /*
> > +              * The cmpxchg failed because the spte was updated by another
> > +              * thread so record the updated spte in old_spte.
> > +              */
>
> Hmm, this is a bit awkward.  I think it's the double use of "updated" and the
> somewhat ambiguous reference to "old_spte".  I'd also avoid "thread", as this
> requires interference from not only a different task, but a different logical CPU
> since iter->old_spte is refreshed if mmu_lock is dropped and reacquired.  And
> "record" is an odd choice of word since it sounds like storing the current value
> is only for logging/debugging.
>
> Something like this?
>
>                 /*
>                  * The entry was modified by a different logical CPU, refresh
>                  * iter->old_spte with the current value so the caller operates
>                  * on fresh data, e.g. if it retries tdp_mmu_set_spte_atomic().
>                  */
>
> Nits aside,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Thanks for the review. I'll incorporate these into v2 (which I'm
holding off on until you have a chance to finish reviewing v1).

>
> > +             iter->old_spte = old_spte;
> >               return false;
> > +     }
> >
> >       __handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> >                             new_spte, iter->level, true);
