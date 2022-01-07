Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B3E487C20
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240904AbiAGSZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240891AbiAGSZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 13:25:05 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB99C061574
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 10:25:04 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id x7so18528809lfu.8
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 10:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e3PBTuFVIea0n/HtgiNldjYwcSXImunWqetUZ2e3eCM=;
        b=maBN7XCFZvkquFEtXKRCrHeiS1qTbU2vse75dWCUJLSjWoECWevXwZ60f1BsDJcpba
         02e/rPm7AMSTiLWrJCaPgn5k9xYA7y7LvRtEigsruF3CwBFmhiJWbpXs+4/tZbdI6Rp4
         KwLrULX4FBly4JzFKDtDgHXQQMHoU0gNwn08ncbjvzjgJkO7lqrO7jUuAJCTe9XqSd2S
         dBzUCz2AJDv8YDncbRvn4BsfMBVaKzTx1kC1mlm+MiB0hi1k1vDku6/bjmGb8hEEx982
         OQMGFGM2Ug4qg9vzd368UkxSSY+3ztgjdLJnYOyvsbgPN1b2mmFPXwJWJ6027GCqzWY7
         JnZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e3PBTuFVIea0n/HtgiNldjYwcSXImunWqetUZ2e3eCM=;
        b=t6BnCMrpSR1g1wuN34i64ZP4YLiqEIxPm4cenSHYaZY1B9Y65i3tFmDC7TfBzIHy0z
         AlllQWg8jQu/nGgefTWuz9Tygugf1A0nTygAg+Rsx2iY7vR6fUX/0AyflqHHiIJggLDO
         sn3FJCc3lVfognozPxR236e6hbB6n6ggL2oNhs+seL6sPerWnbJDny+JUGn8Ea9oYnmK
         kclTUXhUy1eLZWBHKTi6kkznyorhWEqH5p+Xyj7w6e7FAYIeP6GG0oYZtA3BWGYlg2s+
         qttDzS0U8QEVCZ+8Ge4wFqUDkkHiT3p7xk7UZEq9OI9oZF16BKdZNtZ15E3AmvLtkabJ
         qsXQ==
X-Gm-Message-State: AOAM531YFq7QMb9jp2BVFHtn1cQPEQSUAApyHZSljc455FeziYT72NDL
        YOeD74GwldAGStxwfvEciEgpFaHYfV1qoq4J5+fZoQ==
X-Google-Smtp-Source: ABdhPJxnk0GHwJ1dhzeG/KMJmQweG+0hWiomFVCl7X6qdJrkvGyJi/p8VFpOCxGa9fzp0KEbgoGOqav0eYYdCSAGqT8=
X-Received: by 2002:a2e:9659:: with SMTP id z25mr51457510ljh.16.1641579902829;
 Fri, 07 Jan 2022 10:25:02 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-5-dmatlack@google.com>
 <YddNIMWaARotqOSZ@google.com> <CALzav=cW9jB49gdKa6xYVy-7Jh1PK8NLChwPMNwK_bK-55a=3w@mail.gmail.com>
In-Reply-To: <CALzav=cW9jB49gdKa6xYVy-7Jh1PK8NLChwPMNwK_bK-55a=3w@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 7 Jan 2022 10:24:36 -0800
Message-ID: <CALzav=coNhq-+Q1c3+H5xyFMYVLNgE=w=hgSWFeUQyNANOLxFQ@mail.gmail.com>
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

On Thu, Jan 6, 2022 at 2:56 PM David Matlack <dmatlack@google.com> wrote:
>
> On Thu, Jan 6, 2022 at 12:12 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Dec 13, 2021, David Matlack wrote:
> > > Factor out the logic to atomically replace an SPTE with an SPTE that
> > > points to a new page table. This will be used in a follow-up commit to
> > > split a large page SPTE into one level lower.
> > >
> > > Opportunistically drop the kvm_mmu_get_page tracepoint in
> > > kvm_tdp_mmu_map() since it is redundant with the identical tracepoint in
> > > alloc_tdp_mmu_page().
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 48 +++++++++++++++++++++++++++-----------
> > >  1 file changed, 34 insertions(+), 14 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 656ebf5b20dc..dbd07c10d11a 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -950,6 +950,36 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> > >       return ret;
> > >  }
> > >
> > > +/*
> > > + * tdp_mmu_install_sp_atomic - Atomically replace the given spte with an
> > > + * spte pointing to the provided page table.
> > > + *
> > > + * @kvm: kvm instance
> > > + * @iter: a tdp_iter instance currently on the SPTE that should be set
> > > + * @sp: The new TDP page table to install.
> > > + * @account_nx: True if this page table is being installed to split a
> > > + *              non-executable huge page.
> > > + *
> > > + * Returns: True if the new page table was installed. False if spte being
> > > + *          replaced changed, causing the atomic compare-exchange to fail.
> >
> > I'd prefer to return an int with 0/-EBUSY on success/fail.  Ditto for the existing
> > tdp_mmu_set_spte_atomic().  Actually, if you add a prep patch to make that happen,
> > then this can be:
> >
> >         u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
> >         int ret;
> >
> >         ret = tdp_mmu_set_spte_atomic(kvm, iter, spte);
> >         if (ret)
> >                 return ret;
> >
> >         tdp_mmu_link_page(kvm, sp, account_nx);
> >         return 0;
>
> Will do.
>
> >
> >
> >
> > > + *          If this function returns false the sp will be freed before
> > > + *          returning.
> >
> > Uh, no it's not?  The call to tdp_mmu_free_sp() is still done by kvm_tdp_mmu_map().
>
> Correct. I missed cleaning up this comment after I pulled the
> tdp_mmu_free_sp() call up a level from where it was in the RFC.
>
> >
> > > + */
> > > +static bool tdp_mmu_install_sp_atomic(struct kvm *kvm,
> >
> > Hmm, so this helper is the only user of tdp_mmu_link_page(), and _that_ helper
> > is rather tiny.  And this would also be a good opportunity to clean up the
> > "(un)link_page" verbiage, as the bare "page" doesn't communicate to the reader
> > that it's for linking shadow pages, e.g. not struct page.
> >
> > So, what about folding in tdp_mmu_link_page(), naming this helper either
> > tdp_mmu_link_sp_atomic() or tdp_mmu_link_shadow_page_atomic(), and then renaming
> > tdp_mmu_unlink_page() accordingly?  And for bonus points, add a blurb in the
> > function comment like:
> >
> >         * Note the lack of a non-atomic variant!  The TDP MMU always builds its
> >         * page tables while holding mmu_lock for read.
>
> Sure, I'll include that cleanup as part of the next version of this series.

While I'm here how do you feel about renaming alloc_tdp_mmu_page() to
tdp_mmu_alloc_sp()? First to increase consistency that "tdp_mmu" is a
prefix before the verb, and to clarify that we are allocating a shadow
page.
>
> >
> > > +                                   struct tdp_iter *iter,
> > > +                                   struct kvm_mmu_page *sp,
> > > +                                   bool account_nx)
> > > +{
> > > +     u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
> > > +
> > > +     if (!tdp_mmu_set_spte_atomic(kvm, iter, spte))
> > > +             return false;
> > > +
> > > +     tdp_mmu_link_page(kvm, sp, account_nx);
> > > +
> > > +     return true;
> > > +}
> > > +
> > >  /*
> > >   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
> > >   * page tables and SPTEs to translate the faulting guest physical address.
> > > @@ -959,8 +989,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > >       struct kvm_mmu *mmu = vcpu->arch.mmu;
> > >       struct tdp_iter iter;
> > >       struct kvm_mmu_page *sp;
> > > -     u64 *child_pt;
> > > -     u64 new_spte;
> > >       int ret;
> > >
> > >       kvm_mmu_hugepage_adjust(vcpu, fault);
> > > @@ -996,6 +1024,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > >               }
> > >
> > >               if (!is_shadow_present_pte(iter.old_spte)) {
> > > +                     bool account_nx = fault->huge_page_disallowed &&
> > > +                                       fault->req_level >= iter.level;
> > > +
> > >                       /*
> > >                        * If SPTE has been frozen by another thread, just
> > >                        * give up and retry, avoiding unnecessary page table
> > > @@ -1005,18 +1036,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > >                               break;
> > >
> > >                       sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
> > > -                     child_pt = sp->spt;
> > > -
> > > -                     new_spte = make_nonleaf_spte(child_pt,
> > > -                                                  !shadow_accessed_mask);
> > > -
> > > -                     if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
> > > -                             tdp_mmu_link_page(vcpu->kvm, sp,
> > > -                                               fault->huge_page_disallowed &&
> > > -                                               fault->req_level >= iter.level);
> > > -
> > > -                             trace_kvm_mmu_get_page(sp, true);
> > > -                     } else {
> > > +                     if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx)) {
> > >                               tdp_mmu_free_sp(sp);
> > >                               break;
> > >                       }
> > > --
> > > 2.34.1.173.g76aa8bc2d0-goog
> > >
