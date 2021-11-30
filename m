Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FF6464334
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 00:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345679AbhK3XbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 18:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345689AbhK3X3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 18:29:40 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B1DC06139A
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:26:16 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id k23so44367854lje.1
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c1iunsIsqbP1DVcP15+xF24AkX3xbX9gzIuoBlEsnCA=;
        b=a543LQatxHOE2an6jAsw3Ldy9gXgo9QnKpDcP7U/P1pqKMiNPocAMMPbQWcc4kRpqt
         36dHry+TCHvAx9f1Ep67LJUKb+Blq+pSEsakkZJ9Ef3faXYgF5H4E3uhAhIhFVAAGbId
         IqaNTt5IsQb4iLICJtfh51kNAOjz4kMphumTE3nOuCOhmT+lJVD2WD0bzcgsWGfUjqQ7
         t7o4Xpgzypfesn+uRUp3830/48PJ/rvuMujhHa38ZnAlzS+Uf2/91YpUBIyNcdUc1kcb
         UqZmZDopm/M4j+KAIeDzSm6WgFWzj5/5vG2XeHKUM6fhgDoeTDek2tGMx0PbWknAy/Ae
         OHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c1iunsIsqbP1DVcP15+xF24AkX3xbX9gzIuoBlEsnCA=;
        b=nn81XbFlU5Xos0fHu29KYsCM4MEEvXPJvvLBwV0Elo8OYlQJVtN4gDKivqDcqBCN4D
         d4/qLwCV9YWmHBX85CI4t3c+D4vTsifSMOghxN6mMlhdBhE94ypd5ZZW3uQF+YNVlk8D
         +KRmW0nz3qTcSBp6EQjMmSxAfOnTXqmNvBK1S4UbPsBU3Ssx9+u/YLYCv9o37g1Aljm9
         r8vuouri42rVJhb+51SaoBLU/umfXIcNvt4vF4S48HDO/m6ol7TZMbM+esPvyIX+6Y+S
         kxQyVfFmaaT5oslBjL7oQfeVGj92SO9jGgAhLjDq4c/QjITDCWdnEZ2VETDdkf0u8C6W
         Ok1w==
X-Gm-Message-State: AOAM533++AbFg0G0pH+utUZK/vNefayWdzDXGC817iyXvoftsGYMuxZz
        oNuix9THm66tM9Est5aSaWPcMgN82TOJ/rzzdlhMgw==
X-Google-Smtp-Source: ABdhPJz+3IqWzgsef4m4HDUQxm8IdkXEU+rSKglHTNJMUf780elZh3AG+md+pDoHCtiJme8dlydmfzgxph9OjNTzeGE=
X-Received: by 2002:a2e:8895:: with SMTP id k21mr1943553lji.331.1638314774124;
 Tue, 30 Nov 2021 15:26:14 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-4-dmatlack@google.com>
 <CANgfPd_uoM930c1LsQbRX_JRz9+ofnCxzHs6t9O6a7LSCYCaYg@mail.gmail.com>
In-Reply-To: <CANgfPd_uoM930c1LsQbRX_JRz9+ofnCxzHs6t9O6a7LSCYCaYg@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 30 Nov 2021 15:25:47 -0800
Message-ID: <CALzav=fKJEbDUnYJKN8PCTE7v8TkPBO7JOZFzjy23Spa35FDcQ@mail.gmail.com>
Subject: Re: [RFC PATCH 03/15] KVM: x86/mmu: Automatically update
 iter->old_spte if cmpxchg fails
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 10:52 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Fri, Nov 19, 2021 at 3:58 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Consolidate a bunch of code that was manually re-reading the spte if the
> > cmpxchg fails. There is no extra cost of doing this because we already
> > have the spte value as a result of the cmpxchg (and in fact this
> > eliminates re-reading the spte), and none of the call sites depend on
> > iter->old_spte retaining the stale spte value.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 56 ++++++++++++--------------------------
> >  1 file changed, 18 insertions(+), 38 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 377a96718a2e..cc9fe33c9b36 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -492,16 +492,22 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> >   * and handle the associated bookkeeping.  Do not mark the page dirty
> >   * in KVM's dirty bitmaps.
> >   *
> > + * If setting the SPTE fails because it has changed, iter->old_spte will be
> > + * updated with the updated value of the spte.
> > + *
> >   * @kvm: kvm instance
> >   * @iter: a tdp_iter instance currently on the SPTE that should be set
> >   * @new_spte: The value the SPTE should be set to
> >   * Returns: true if the SPTE was set, false if it was not. If false is returned,
> > - *         this function will have no side-effects.
> > + *          this function will have no side-effects other than updating
> > + *          iter->old_spte to the latest value of spte.
> >   */
> >  static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
> >                                            struct tdp_iter *iter,
> >                                            u64 new_spte)
> >  {
> > +       u64 old_spte;
> > +
> >         lockdep_assert_held_read(&kvm->mmu_lock);
> >
> >         /*
> > @@ -515,9 +521,11 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
> >          * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
> >          * does not hold the mmu_lock.
> >          */
> > -       if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
> > -                     new_spte) != iter->old_spte)
> > +       old_spte = cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte, new_spte);
>
> This probably deserves a comment:
>
> /*
>  * If the old_spte values differ, the cmpxchg failed. Update
> iter->old_spte with the value inserted by
>  * another thread.
>  */

Will do.

>
> > +       if (old_spte != iter->old_spte) {
> > +               iter->old_spte = old_spte;
> >                 return false;
> > +       }
> >
> >         __handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> >                               new_spte, iter->level, true);
> > @@ -747,14 +755,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> >                 if (!shared) {
> >                         tdp_mmu_set_spte(kvm, &iter, 0);
> >                         flush = true;
> > -               } else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
> > -                       /*
> > -                        * The iter must explicitly re-read the SPTE because
> > -                        * the atomic cmpxchg failed.
> > -                        */
> > -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
>
> I think kernel style is to include the curly braces on the else if, if
> the if had them.

You are correct! Will fix in v1.

>
>
> > +               } else if (!tdp_mmu_zap_spte_atomic(kvm, &iter))
> >                         goto retry;
> > -               }
> >         }
> >
> >         rcu_read_unlock();
> > @@ -978,13 +980,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                     is_large_pte(iter.old_spte)) {
> >                         if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> >                                 break;
> > -
> > -                       /*
> > -                        * The iter must explicitly re-read the spte here
> > -                        * because the new value informs the !present
> > -                        * path below.
> > -                        */
> > -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> >                 }
> >
> >                 if (!is_shadow_present_pte(iter.old_spte)) {
> > @@ -1190,14 +1185,9 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> >
> >                 new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
> >
> > -               if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte)) {
> > -                       /*
> > -                        * The iter must explicitly re-read the SPTE because
> > -                        * the atomic cmpxchg failed.
> > -                        */
> > -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> > +               if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
> >                         goto retry;
> > -               }
> > +
> >                 spte_set = true;
> >         }
> >
> > @@ -1258,14 +1248,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> >                                 continue;
> >                 }
> >
> > -               if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte)) {
> > -                       /*
> > -                        * The iter must explicitly re-read the SPTE because
> > -                        * the atomic cmpxchg failed.
> > -                        */
> > -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> > +               if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
> >                         goto retry;
> > -               }
> > +
> >                 spte_set = true;
> >         }
> >
> > @@ -1391,14 +1376,9 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
> >                                                             pfn, PG_LEVEL_NUM))
> >                         continue;
> >
> > -               if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
> > -                       /*
> > -                        * The iter must explicitly re-read the SPTE because
> > -                        * the atomic cmpxchg failed.
> > -                        */
> > -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> > +               if (!tdp_mmu_zap_spte_atomic(kvm, &iter))
> >                         goto retry;
> > -               }
> > +
> >                 flush = true;
> >         }
> >
> > --
> > 2.34.0.rc2.393.gf8c9666880-goog
> >
