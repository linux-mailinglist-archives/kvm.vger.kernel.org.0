Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84D54E37FE
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 05:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbiCVEfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 00:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236452AbiCVEfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 00:35:15 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1025C13D
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 21:33:48 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id x2so936428plm.7
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 21:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QzWGSD8UrxP1f488j7vfk2OAd1BpAj3BCn1BSo8jkbU=;
        b=VCZ9jgOsRaUTNxPQPKMsb/x0cISlxSHI4hrW2++0MV1jMhPccmoX0V4a7ERe1UmMtY
         6Xi8Apdkr/zxodCh7nxLeNVnMhkXQPtZWxUnFIki7jXii2CahNqLKsJhwxkp7ifJVOOg
         AqNTaZbgUulznb9mqZaWogOCVSnvvQSDsh92zkdblQBdu8H5Igr6L/GzPzCHBmwSrK4Q
         dhTCZJfYGJW5gO+gRIb0E3Umt9EhPOb2eN4SYe48Q6vlos4KLt6ZcGrf6NtiTxpiKhYs
         fx5vGQeJtERQ/U/7cLCl1xiyvGsbDmG3pIGsHjgOx9J/dDq52wDNsTkHJ2H5ReoGdLw1
         wo+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QzWGSD8UrxP1f488j7vfk2OAd1BpAj3BCn1BSo8jkbU=;
        b=dH1IMTciTUYIiX4d5wMHCJnf7zamvneD+YB9lPYl79eQ8/R1biGIQhauITVlPG5maF
         8J8xwH2i69HYLQVgPNIgh85sNZRMBvCJYoK3D7C7TZIG0zxy9tYffwfLUY9zs3cFxczT
         cLkMgNbD8ts8C+aGJEM00/CDFkcztVGMwJ06Ftv0C0QDB1C6h3RZ1TuC86hrB6p9qVMP
         8euvPZehb9XeZKuIuGNNmq3McDJxyXqb/Gdo736lNWThj7u+Gur32nXATaANOnLtWCar
         b1wpFSPf/7OA2L9G8Ar51HUXC9zzlLuT4QU/3C6kfQWgNmnJT3XaZ1zp+af/BHi/jxb8
         b5Qg==
X-Gm-Message-State: AOAM530dMmWd1JiOI6Sg6NQbddiEe+IXOnlvZCk0L+akoQNwJ3W0/2x7
        5VZka+MVdqxJ4RbI/sxkS72Jkg==
X-Google-Smtp-Source: ABdhPJzSFads7Dv7ssnbi+i9tB6K0ifPoMBy4Hbgf3TwQpszieaSEBCcgepghZ4446BEAy+7gbdi+w==
X-Received: by 2002:a17:903:40cf:b0:154:6a5f:95c5 with SMTP id t15-20020a17090340cf00b001546a5f95c5mr5854902pld.100.1647923627344;
        Mon, 21 Mar 2022 21:33:47 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id b9-20020a056a000cc900b004f7ac2189e2sm21981311pfv.191.2022.03.21.21.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 21:33:46 -0700 (PDT)
Date:   Tue, 22 Mar 2022 04:33:43 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgorden@google.com>
Subject: Re: [PATCH 3/4] KVM: x86/mmu: explicitly check nx_hugepage in
 disallowed_hugepage_adjust()
Message-ID: <YjlRp+TAD/xKHOyW@google.com>
References: <20220321002638.379672-1-mizhang@google.com>
 <20220321002638.379672-4-mizhang@google.com>
 <CALzav=dU5TPfhp1=n+zo+AcPkL4rpWCRpMCL91vE5z20R+mmjg@mail.gmail.com>
 <CALzav=fFK1725dVBc=N181qP-Nua8M0rsKhXm1=zTRmG2Msjgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=fFK1725dVBc=N181qP-Nua8M0rsKhXm1=zTRmG2Msjgg@mail.gmail.com>
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

On Mon, Mar 21, 2022, David Matlack wrote:
> On Mon, Mar 21, 2022 at 3:00 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Sun, Mar 20, 2022 at 5:26 PM Mingwei Zhang <mizhang@google.com> wrote:
> > >
> > > Add extra check to specify the case of nx hugepage and allow KVM to
> > > reconstruct large mapping after dirty logging is disabled. Existing code
> > > works only for nx hugepage but the condition is too general in that does
> > > not consider other usage case (such as dirty logging).
> >
> > KVM calls kvm_mmu_zap_collapsible_sptes() when dirty logging is
> > disabled. Why is that not sufficient?
> 
> Ahh I see, kvm_mmu_zap_collapsible_sptes() only zaps the leaf SPTEs.
> Could you add a blurb about this in the commit message for future
> reference?
> 

will do.

> >
> > > Moreover, existing
> > > code assumes that a present PMD or PUD indicates that there exist 'smaller
> > > SPTEs' under the paging structure. This assumption may no be true if
> > > consider the zapping leafs only behavior in MMU.
> >
> > Good point. Although, that code just got reverted. Maybe say something like:
> >
> >   This assumption may not be true in the future if KVM gains support
> > for zapping only leaf SPTEs.
> 
> Nevermind, support for zapping leaf SPTEs already exists for zapping
> collapsible SPTEs.
>
> 
> 
> >
> > >
> > > Missing the check causes KVM incorrectly regards the faulting page as a NX
> > > huge page and refuse to map it at desired level. And this leads to back
> > > performance in shadow mmu and potentiall TDP mmu.
> >
> > s/potentiall/potentially/

Thanks for that.
> >
> > >
> > > Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
> > > Cc: stable@vger.kernel.org
> > >
> > > Reviewed-by: Ben Gardon <bgardon@google.com>
> > > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 14 ++++++++++++--
> > >  1 file changed, 12 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 5628d0ba637e..4d358c273f6c 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -2919,6 +2919,16 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
> > >             cur_level == fault->goal_level &&
> > >             is_shadow_present_pte(spte) &&
> > >             !is_large_pte(spte)) {
> > > +               struct kvm_mmu_page *sp;
> > > +               u64 page_mask;
> > > +               /*
> > > +                * When nx hugepage flag is not set, there is no reason to
> > > +                * go down to another level. This helps demand paging to
> > > +                * generate large mappings.
> > > +                */
> > > +               sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> > > +               if (!sp->lpage_disallowed)
> > > +                       return;
> > >                 /*
> > >                  * A small SPTE exists for this pfn, but FNAME(fetch)
> > >                  * and __direct_map would like to create a large PTE
> > > @@ -2926,8 +2936,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
> > >                  * patching back for them into pfn the next 9 bits of
> > >                  * the address.
> > >                  */
> > > -               u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
> > > -                               KVM_PAGES_PER_HPAGE(cur_level - 1);
> > > +               page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
> > > +                       KVM_PAGES_PER_HPAGE(cur_level - 1);
> > >                 fault->pfn |= fault->gfn & page_mask;
> > >                 fault->goal_level--;
> > >         }
> > > --
> > > 2.35.1.894.gb6a874cedc-goog
> > >
