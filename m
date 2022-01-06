Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AFD486D6A
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 23:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245297AbiAFW5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 17:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245250AbiAFW47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 17:56:59 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3059C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 14:56:58 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id h7so9106990lfu.4
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 14:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4eSqHjrRGcY8phwpy0mSb6byCpQPEfmWynmuJ1KBJ30=;
        b=SR7Gym6q4oHMy300iS4KobnFIGj+z4Um506rP1Zkv0PVK783XGBjU+TNnh0jqNYSDk
         RWDYcONyzR0Bub2OlS0eS+bgCuqkFv+DcRAKebcWGAc6qCNb4o6TgKI3POwEcN9bnWGs
         GEZ3qAgOMayBJDcYk57EpNvk7uCjR1TIHlGT7XZ5/VvlW+zrKnl2d8+Ebrj0vKMK4Lku
         LuOG+XlT/7lNtXhsVtvwIK+MzVvKJ8NuA4cjjUnpXd5Wsjz+jKWkmJ/zxnQHrZgg1Hr8
         fiL32io48VbCwfs7CfkRw8XxmYl6Jo3G6h/ZO0vLJJNQ+GTpGYBjhBvapWSovAba/awJ
         /n4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4eSqHjrRGcY8phwpy0mSb6byCpQPEfmWynmuJ1KBJ30=;
        b=BnjXj6tyrtbJF8uQOdMVmRIDfD0es1CG4R5wileZmRVXRpUons6/bCsBUpcOYWGX/H
         KwjW573Rp38G/Zfjsvb+lpzC+y0jdpGoVoFaXMo1g/ASnLNKnVItT2FR7Hf3TnEhzylp
         IPrFDltUpYAip+WLs3PNgp7pRrk7rZYs5tv6WQ5rQ6RNVfkzoamw6XS+0pEnEhx7/3oU
         JbdK8TMxsLyshfkuo0M/xf0ekbKam7A1ejGsOO9I5cK+YVWmXi4+68IOzbSOWm94P1Op
         ZIz4FxX5AORxdY+8CO400XY2bOFRZtwSXGEi+xVbC8Ro0TzeaunI6B9Pt7xxl1P6r7KR
         O9eg==
X-Gm-Message-State: AOAM532zSGZRgyd8KLHeWwn1ImNj2xneriNlk7CVE3MsgozWT58pPRdR
        JgHjP6uD3Rz7nJvj2dlHyyMSKt6s6ecVuLyyVw7boQ==
X-Google-Smtp-Source: ABdhPJzDvwpClpu1wgrI9JADQuaMVWBUf5iAsT1rck122oNEba6jt+imbBnpFRcoJI2vWAr3AGCJY6aenh10xYdXjhg=
X-Received: by 2002:a2e:854a:: with SMTP id u10mr38301889ljj.361.1641509816747;
 Thu, 06 Jan 2022 14:56:56 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-5-dmatlack@google.com>
 <YddNIMWaARotqOSZ@google.com>
In-Reply-To: <YddNIMWaARotqOSZ@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 6 Jan 2022 14:56:30 -0800
Message-ID: <CALzav=cW9jB49gdKa6xYVy-7Jh1PK8NLChwPMNwK_bK-55a=3w@mail.gmail.com>
Subject: Re: [PATCH v1 04/13] KVM: x86/mmu: Factor out logic to atomically
 install a new page table
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

On Thu, Jan 6, 2022 at 12:12 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Dec 13, 2021, David Matlack wrote:
> > Factor out the logic to atomically replace an SPTE with an SPTE that
> > points to a new page table. This will be used in a follow-up commit to
> > split a large page SPTE into one level lower.
> >
> > Opportunistically drop the kvm_mmu_get_page tracepoint in
> > kvm_tdp_mmu_map() since it is redundant with the identical tracepoint in
> > alloc_tdp_mmu_page().
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 48 +++++++++++++++++++++++++++-----------
> >  1 file changed, 34 insertions(+), 14 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 656ebf5b20dc..dbd07c10d11a 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -950,6 +950,36 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> >       return ret;
> >  }
> >
> > +/*
> > + * tdp_mmu_install_sp_atomic - Atomically replace the given spte with an
> > + * spte pointing to the provided page table.
> > + *
> > + * @kvm: kvm instance
> > + * @iter: a tdp_iter instance currently on the SPTE that should be set
> > + * @sp: The new TDP page table to install.
> > + * @account_nx: True if this page table is being installed to split a
> > + *              non-executable huge page.
> > + *
> > + * Returns: True if the new page table was installed. False if spte being
> > + *          replaced changed, causing the atomic compare-exchange to fail.
>
> I'd prefer to return an int with 0/-EBUSY on success/fail.  Ditto for the existing
> tdp_mmu_set_spte_atomic().  Actually, if you add a prep patch to make that happen,
> then this can be:
>
>         u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
>         int ret;
>
>         ret = tdp_mmu_set_spte_atomic(kvm, iter, spte);
>         if (ret)
>                 return ret;
>
>         tdp_mmu_link_page(kvm, sp, account_nx);
>         return 0;

Will do.

>
>
>
> > + *          If this function returns false the sp will be freed before
> > + *          returning.
>
> Uh, no it's not?  The call to tdp_mmu_free_sp() is still done by kvm_tdp_mmu_map().

Correct. I missed cleaning up this comment after I pulled the
tdp_mmu_free_sp() call up a level from where it was in the RFC.

>
> > + */
> > +static bool tdp_mmu_install_sp_atomic(struct kvm *kvm,
>
> Hmm, so this helper is the only user of tdp_mmu_link_page(), and _that_ helper
> is rather tiny.  And this would also be a good opportunity to clean up the
> "(un)link_page" verbiage, as the bare "page" doesn't communicate to the reader
> that it's for linking shadow pages, e.g. not struct page.
>
> So, what about folding in tdp_mmu_link_page(), naming this helper either
> tdp_mmu_link_sp_atomic() or tdp_mmu_link_shadow_page_atomic(), and then renaming
> tdp_mmu_unlink_page() accordingly?  And for bonus points, add a blurb in the
> function comment like:
>
>         * Note the lack of a non-atomic variant!  The TDP MMU always builds its
>         * page tables while holding mmu_lock for read.

Sure, I'll include that cleanup as part of the next version of this series.

>
> > +                                   struct tdp_iter *iter,
> > +                                   struct kvm_mmu_page *sp,
> > +                                   bool account_nx)
> > +{
> > +     u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
> > +
> > +     if (!tdp_mmu_set_spte_atomic(kvm, iter, spte))
> > +             return false;
> > +
> > +     tdp_mmu_link_page(kvm, sp, account_nx);
> > +
> > +     return true;
> > +}
> > +
> >  /*
> >   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
> >   * page tables and SPTEs to translate the faulting guest physical address.
> > @@ -959,8 +989,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >       struct kvm_mmu *mmu = vcpu->arch.mmu;
> >       struct tdp_iter iter;
> >       struct kvm_mmu_page *sp;
> > -     u64 *child_pt;
> > -     u64 new_spte;
> >       int ret;
> >
> >       kvm_mmu_hugepage_adjust(vcpu, fault);
> > @@ -996,6 +1024,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >               }
> >
> >               if (!is_shadow_present_pte(iter.old_spte)) {
> > +                     bool account_nx = fault->huge_page_disallowed &&
> > +                                       fault->req_level >= iter.level;
> > +
> >                       /*
> >                        * If SPTE has been frozen by another thread, just
> >                        * give up and retry, avoiding unnecessary page table
> > @@ -1005,18 +1036,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                               break;
> >
> >                       sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
> > -                     child_pt = sp->spt;
> > -
> > -                     new_spte = make_nonleaf_spte(child_pt,
> > -                                                  !shadow_accessed_mask);
> > -
> > -                     if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
> > -                             tdp_mmu_link_page(vcpu->kvm, sp,
> > -                                               fault->huge_page_disallowed &&
> > -                                               fault->req_level >= iter.level);
> > -
> > -                             trace_kvm_mmu_get_page(sp, true);
> > -                     } else {
> > +                     if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx)) {
> >                               tdp_mmu_free_sp(sp);
> >                               break;
> >                       }
> > --
> > 2.34.1.173.g76aa8bc2d0-goog
> >
