Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02EA45351BD
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 17:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348039AbiEZP56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 11:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbiEZP54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 11:57:56 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C177E60043
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:57:55 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id z7so3564162ybf.7
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vw/Z0MTuWn6e5jQEzUWaV6QYfzZaWvqRsRp1agJKyw4=;
        b=S9LhIA14NROGEwwJ+ujpEYnhkzl8zYc0ZWijDxo27R5l17Dfo0AxKuwY6TytzrM6+v
         ekV3USG9J3mXyb6YlaLsDZYxwKjicMLOWNLeWdG/DgGf/iAhuEN8SUP1lc2eMmWFR8ad
         lFLzrX6bHf4x8oKn4WZ1XCvnUV6qaWAqSowv+U4lF+S/rXt/LLyfrSv36r+fhN6v+xbx
         df+iKtR52liGmvTrU37JbMYNX7CHfj6hbXGAEXKIGn5/mOtGl1de8wKcXwb7DzsuitnC
         bk7Cip0OoDMHQmYqJSTk5+cXA2aIJBAONPCS0jpgLpCn93yZIc+D0HsbXhCTKTwuRtye
         afmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vw/Z0MTuWn6e5jQEzUWaV6QYfzZaWvqRsRp1agJKyw4=;
        b=1TMTm300h/lS0bBFEuv8J/SvKw5YpRlbg3NG89VsIV9AQDkwB5nSLOPkh/azqeM1+H
         lJ1Nwvmsv9DT3vVcsQC1HBoTQ0GfJ4rKvzrRsc5PoNDIHVvyBYxOvxqEfV/c+gbos4Vu
         A/zRGVtjKT5WhgIJEnSmlQgCDFlEh7zaxHcp2v8deZdnNITuXf8sCgRFLSJk4GtlkIGF
         RFRRBh+CopKBuz3aCMO6YbCwzKlb4njZsWSr8BUU+6DTj0j+RUb91d8PFQMD5g1emCXk
         C3fcX387KQL0CQ0ibcVuI5VLS6T7qGAGZKEw6IF4Voll29CdMnHSyxBGvMkH1vmvR289
         4zIw==
X-Gm-Message-State: AOAM532nZNw3ju5cNt401AthOHUALm9GZb2MhxgF+f4xLzW9OnfEoIdt
        z7/A5z1sp5aEcGBQW7liZTgeQX/WcjxMdbgo+MKdEA==
X-Google-Smtp-Source: ABdhPJxmWAHI1nt6cm3n3IiJY4Zm2kQRc8lv9dLvw5VG4huitwTOPwcVy1yVyB6cHJUqY+iG5WKxUWmu6P6NlQPs0t4=
X-Received: by 2002:a25:69c7:0:b0:64f:674a:87d6 with SMTP id
 e190-20020a2569c7000000b0064f674a87d6mr28768174ybc.301.1653580674612; Thu, 26
 May 2022 08:57:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220525230904.1584480-1-bgardon@google.com> <20220526013010.ag4jzs7bbt5mudrg@yy-desk-7060>
In-Reply-To: <20220526013010.ag4jzs7bbt5mudrg@yy-desk-7060>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 26 May 2022 08:57:43 -0700
Message-ID: <CANgfPd-uAXu6aCoEji2BeiHWJnw-PrictuQLOYqLKrQ47WFydw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/MMU: Zap non-leaf SPTEs when disabling dirty logging
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
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

On Wed, May 25, 2022 at 6:30 PM Yuan Yao <yuan.yao@linux.intel.com> wrote:
>
> On Wed, May 25, 2022 at 11:09:04PM +0000, Ben Gardon wrote:
> > When disabling dirty logging, zap non-leaf parent entries to allow
> > replacement with huge pages instead of recursing and zapping all of the
> > child, leaf entries. This reduces the number of TLB flushes required.
> >
> > Currently disabling dirty logging with the TDP MMU is extremely slow.
> > On a 96 vCPU / 96G VM backed with gigabyte pages, it takes ~200 seconds
> > to disable dirty logging with the TDP MMU, as opposed to ~4 seconds with
> > the shadow MMU. This patch reduces the disable dirty log time with the
> > TDP MMU to ~3 seconds.
> >
> > Testing:
> > Ran KVM selftests and kvm-unit-tests on an Intel Haswell. This
> > patch introduced no new failures.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_iter.c |  9 +++++++++
> >  arch/x86/kvm/mmu/tdp_iter.h |  1 +
> >  arch/x86/kvm/mmu/tdp_mmu.c  | 38 +++++++++++++++++++++++++++++++------
> >  3 files changed, 42 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> > index 6d3b3e5a5533..ee4802d7b36c 100644
> > --- a/arch/x86/kvm/mmu/tdp_iter.c
> > +++ b/arch/x86/kvm/mmu/tdp_iter.c
> > @@ -145,6 +145,15 @@ static bool try_step_up(struct tdp_iter *iter)
> >       return true;
> >  }
> >
> > +/*
> > + * Step the iterator back up a level in the paging structure. Should only be
> > + * used when the iterator is below the root level.
> > + */
> > +void tdp_iter_step_up(struct tdp_iter *iter)
> > +{
> > +     WARN_ON(!try_step_up(iter));
> > +}
> > +
> >  /*
> >   * Step to the next SPTE in a pre-order traversal of the paging structure.
> >   * To get to the next SPTE, the iterator either steps down towards the goal
> > diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> > index f0af385c56e0..adfca0cf94d3 100644
> > --- a/arch/x86/kvm/mmu/tdp_iter.h
> > +++ b/arch/x86/kvm/mmu/tdp_iter.h
> > @@ -114,5 +114,6 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
> >                   int min_level, gfn_t next_last_level_gfn);
> >  void tdp_iter_next(struct tdp_iter *iter);
> >  void tdp_iter_restart(struct tdp_iter *iter);
> > +void tdp_iter_step_up(struct tdp_iter *iter);
> >
> >  #endif /* __KVM_X86_MMU_TDP_ITER_H */
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 841feaa48be5..7b9265d67131 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1742,12 +1742,12 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
> >       gfn_t start = slot->base_gfn;
> >       gfn_t end = start + slot->npages;
> >       struct tdp_iter iter;
> > +     int max_mapping_level;
> >       kvm_pfn_t pfn;
> >
> >       rcu_read_lock();
> >
> >       tdp_root_for_each_pte(iter, root, start, end) {
> > -retry:
> >               if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
> >                       continue;
> >
> > @@ -1755,15 +1755,41 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
> >                   !is_last_spte(iter.old_spte, iter.level))
> >                       continue;
> >
> > +             /*
> > +              * This is a leaf SPTE. Check if the PFN it maps can
> > +              * be mapped at a higher level.
> > +              */
> >               pfn = spte_to_pfn(iter.old_spte);
> > -             if (kvm_is_reserved_pfn(pfn) ||
> > -                 iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
> > -                                                         pfn, PG_LEVEL_NUM))
> > +
> > +             if (kvm_is_reserved_pfn(pfn))
> >                       continue;
> >
> > +             max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
> > +                             iter.gfn, pfn, PG_LEVEL_NUM);
> > +
> > +             WARN_ON(max_mapping_level < iter.level);
> > +
> > +             /*
> > +              * If this page is already mapped at the highest
> > +              * viable level, there's nothing more to do.
> > +              */
> > +             if (max_mapping_level == iter.level)
> > +                     continue;
> > +
> > +             /*
> > +              * The page can be remapped at a higher level, so step
> > +              * up to zap the parent SPTE.
> > +              */
> > +             while (max_mapping_level > iter.level)
> > +                     tdp_iter_step_up(&iter);
>
> So the benefit from this is:
> Before: Zap 512 ptes in 4K level page table do TLB flush 512 times.
> Now: Zap higher level 1 2MB level pte do TLB flush 1 time, event
>      it also handles all 512 lower level 4K ptes, but just atomic operation
>      there, see handle_removed_pt().
>
> Is my understanding correct ?

Yes, that's exactly right.

>
> > +
> >               /* Note, a successful atomic zap also does a remote TLB flush. */
> > -             if (tdp_mmu_zap_spte_atomic(kvm, &iter))
> > -                     goto retry;
> > +             tdp_mmu_zap_spte_atomic(kvm, &iter);
> > +
> > +             /*
> > +              * If the atomic zap fails, the iter will recurse back into
> > +              * the same subtree to retry.
> > +              */
> >       }
> >
> >       rcu_read_unlock();
> > --
> > 2.36.1.124.g0e6072fb45-goog
> >
