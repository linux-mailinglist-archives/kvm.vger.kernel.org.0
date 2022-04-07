Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD2C4F89DE
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 00:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiDGUzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 16:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiDGUzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 16:55:43 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B459413F4B
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 13:52:43 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id c15so8990856ljr.9
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 13:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qbARCnioEc3V8RI3dJES88p0ny3ov+sdBeoUOJp9UDs=;
        b=lTt/NTu12uZJ3mjVGEeCVtk+aDk8j/3OXwiJqniEcQIWTTriCLMYKTeCq/r+81Hh46
         dfsqqA6kFlu2ovbEr7OrA/aSWQG+25EQNgrOmO/ZZEF7l1wi4cztgnkAUIH+9j7vm3MY
         TZyl2JHsBPtCE/zE4PDVA7MDgAsSycd/ykdx+VIRKciOLGPlEyoYMCwsyaASpa+K5xkL
         T1Gj6/Dv09yLEhCgek8p8A+yye/sroQ4gdiPZHKTNyWRoW5iNP2ohbOCAfUUGwl24+ig
         uwUnD7J1xCsBK/XvOs8rP5yVddR9ymisFvLOYyQ2GVoPX1PNVtRgDGZYpjGBRKcsILO0
         xVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qbARCnioEc3V8RI3dJES88p0ny3ov+sdBeoUOJp9UDs=;
        b=yL7pLeWBS5t6YEkx8YDfPtpGCYdpwb4mnWHYxnGNBpZArKTJKLga/Dq58rrYBV/imn
         3jCwIqsXO7KKTFGGjhdKhtY4m+R1Nffz7Ntde751B5oYvzbd1aipkMpnhtyaxCSRHXxP
         3Ih0maxr77nmGtrQsfNycrcLwmFRl5QcJy5WTFa188zGuc7dVggpaldP+UdWYQ4Cputu
         WmPmyy4IUUQ7k1Ot3g594fNaR9/KfGzqvxAJBg1rUY0EKc9nmvqD8ddCOqsVNo0MWGRa
         D6SKfFiZikI4w3AJ+NLtOVZkgnLN/kS6pmgkjydblV/qKDblQ3+Lav+Uq9utwhyjQcN6
         Dh9Q==
X-Gm-Message-State: AOAM531S9ojuKqVJUqd4kgj2C0aEPVdqCSeSOb0FEI2A0zpES2b46RTr
        +wWLlccKaqYSKF69I9jkt3plowZF/IZozGr45AUOdQ==
X-Google-Smtp-Source: ABdhPJzsVIHAecwu8ID5FvW7bysSgpl7IR0tFFV4J6JWqzEYN5ClgwAgSPS/HCR65UatxRWRVpeS/HjtCRut5rmy/94=
X-Received: by 2002:a2e:390c:0:b0:248:1b88:d6c4 with SMTP id
 g12-20020a2e390c000000b002481b88d6c4mr9474049lja.49.1649364761562; Thu, 07
 Apr 2022 13:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220401233737.3021889-1-dmatlack@google.com> <20220401233737.3021889-4-dmatlack@google.com>
 <Yk89/g2Unn2exRfz@google.com>
In-Reply-To: <Yk89/g2Unn2exRfz@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 7 Apr 2022 13:52:15 -0700
Message-ID: <CALzav=fDZhTEXyHFPEe5YnQAfUMggzAi_Z_8hNxV-qpiHb6FPA@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: Split huge pages mapped by the TDP MMU
 on fault
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 7, 2022 at 12:39 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 01, 2022, David Matlack wrote:
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++++++++++++++++++++++------------
> >  1 file changed, 25 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 9263765c8068..5a2120d85347 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1131,6 +1131,10 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
> >       return 0;
> >  }
> >
> > +static int tdp_mmu_split_huge_page_atomic(struct kvm_vcpu *vcpu,
> > +                                       struct tdp_iter *iter,
> > +                                       bool account_nx);
> > +
> >  /*
> >   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
> >   * page tables and SPTEs to translate the faulting guest physical address.
> > @@ -1140,6 +1144,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >       struct kvm_mmu *mmu = vcpu->arch.mmu;
> >       struct tdp_iter iter;
> >       struct kvm_mmu_page *sp;
> > +     bool account_nx;
> >       int ret;
> >
> >       kvm_mmu_hugepage_adjust(vcpu, fault);
> > @@ -1155,28 +1160,22 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >               if (iter.level == fault->goal_level)
> >                       break;
> >
> > +             account_nx = fault->huge_page_disallowed &&
> > +                          fault->req_level >= iter.level;
> > +
> >               /*
> >                * If there is an SPTE mapping a large page at a higher level
> > -              * than the target, that SPTE must be cleared and replaced
> > -              * with a non-leaf SPTE.
> > +              * than the target, split it down one level.
> >                */
> >               if (is_shadow_present_pte(iter.old_spte) &&
> >                   is_large_pte(iter.old_spte)) {
> > -                     if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> > +                     if (tdp_mmu_split_huge_page_atomic(vcpu, &iter, account_nx))
>
> As Ben brought up in patch 2, this conflicts in nasty ways with Mingwei's series
> to more preciesly check sp->lpage_disallowed.  There's apparently a bug in that
> code when using shadow paging, but assuming said bug isn't a blocking issue, I'd
> prefer to land this on top of Mingwei's series.
>
> With a bit of massaging, I think we can make the whole thing a bit more
> straightforward.  This is what I ended up with (compile tested only, your patch 2
> dropped, might split moving the "init" to a prep patch).   I'll give it a spin,
> and assuming it works and Mingwei's bug is resolved, I'll post this and Mingwei's
> series as a single thing.

Sean and I spoke offline. I'll wait for Mingwei to send another
version of his patches and then send a v2 of my series on top of that.

>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 99 ++++++++++++++++++--------------------
>  1 file changed, 48 insertions(+), 51 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f046af20f3d6..b0abf14570ea 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1126,6 +1126,9 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>         return 0;
>  }
>
> +static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
> +                                  struct kvm_mmu_page *sp, bool shared);
> +
>  /*
>   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
>   * page tables and SPTEs to translate the faulting guest physical address.
> @@ -1136,7 +1139,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>         struct kvm *kvm = vcpu->kvm;
>         struct tdp_iter iter;
>         struct kvm_mmu_page *sp;
> -       int ret;
> +       bool account_nx;
> +       int ret, r;
>
>         kvm_mmu_hugepage_adjust(vcpu, fault);
>
> @@ -1151,57 +1155,50 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                 if (iter.level == fault->goal_level)
>                         break;
>
> -               /*
> -                * If there is an SPTE mapping a large page at a higher level
> -                * than the target, that SPTE must be cleared and replaced
> -                * with a non-leaf SPTE.
> -                */
> +               /* Nothing to do if there's already a shadow page installed. */
>                 if (is_shadow_present_pte(iter.old_spte) &&
> -                   is_large_pte(iter.old_spte)) {
> -                       if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> -                               break;
> -
> -                       /*
> -                        * The iter must explicitly re-read the spte here
> -                        * because the new value informs the !present
> -                        * path below.
> -                        */
> -                       iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
> +                   !is_large_pte(iter.old_spte))
> +                       continue;
> +
> +               /*
> +                * If the SPTE has been frozen by another thread, just give up
> +                * and retry to avoid unnecessary page table alloc and free.
> +                */
> +               if (is_removed_spte(iter.old_spte))
> +                       break;
> +
> +               /*
> +                * The SPTE is either invalid or points at a huge page that
> +                * needs to be split.
> +                */
> +               sp = tdp_mmu_alloc_sp(vcpu);
> +               tdp_mmu_init_child_sp(sp, &iter);
> +
> +               account_nx = fault->huge_page_disallowed &&
> +                            fault->req_level >= iter.level;
> +
> +               sp->lpage_disallowed = account_nx;
> +               /*
> +                * Ensure lpage_disallowed is visible before the SP is marked
> +                * present (or not-huge), as mmu_lock is held for read.  Pairs
> +                * with the smp_rmb() in disallowed_hugepage_adjust().
> +                */
> +               smp_wmb();
> +
> +               if (!is_shadow_present_pte(iter.old_spte))
> +                       r = tdp_mmu_link_sp(kvm, &iter, sp, true);
> +               else
> +                       r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
> +
> +               if (r) {
> +                       tdp_mmu_free_sp(sp);
> +                       break;
>                 }
>
> -               if (!is_shadow_present_pte(iter.old_spte)) {
> -                       bool account_nx = fault->huge_page_disallowed &&
> -                                         fault->req_level >= iter.level;
> -
> -                       /*
> -                        * If SPTE has been frozen by another thread, just
> -                        * give up and retry, avoiding unnecessary page table
> -                        * allocation and free.
> -                        */
> -                       if (is_removed_spte(iter.old_spte))
> -                               break;
> -
> -                       sp = tdp_mmu_alloc_sp(vcpu);
> -                       tdp_mmu_init_child_sp(sp, &iter);
> -
> -                       sp->lpage_disallowed = account_nx;
> -                       /*
> -                        * Ensure lpage_disallowed is visible before the SP is
> -                        * marked present, as mmu_lock is held for read.  Pairs
> -                        * with the smp_rmb() in disallowed_hugepage_adjust().
> -                        */
> -                       smp_wmb();
> -
> -                       if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
> -                               tdp_mmu_free_sp(sp);
> -                               break;
> -                       }
> -
> -                       if (account_nx) {
> -                               spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -                               __account_huge_nx_page(kvm, sp);
> -                               spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> -                       }
> +               if (account_nx) {
> +                       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +                       __account_huge_nx_page(kvm, sp);
> +                       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>                 }
>         }
>
> @@ -1472,8 +1469,6 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>         const int level = iter->level;
>         int ret, i;
>
> -       tdp_mmu_init_child_sp(sp, iter);
> -
>         /*
>          * No need for atomics when writing to sp->spt since the page table has
>          * not been linked in yet and thus is not reachable from any other CPU.
> @@ -1549,6 +1544,8 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>                                 continue;
>                 }
>
> +               tdp_mmu_init_child_sp(sp, &iter);
> +
>                 if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
>                         goto retry;
>
>
> base-commit: f06d9d4f3d89912c40c57da45d64b9827d8580ac
> --
>
