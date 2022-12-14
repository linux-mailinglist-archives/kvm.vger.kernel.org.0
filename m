Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB3864C111
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 01:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiLNAPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 19:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238135AbiLNAOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 19:14:53 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD2729360
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 16:12:29 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id pv25so5500068qvb.1
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 16:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8b5WecLz6ilBB8EW+pZrrbCkPphDzyvb2ZEZHud8SYQ=;
        b=lEyLKj1qb43Cid0n7/PIPiHIcAYXLprGcR4kUQ+r7d9F69GNPAqUYGInIf95DtSFFf
         ss8dF706t++3sJZpm2mAYlReOwWCwxPEsqfmndv8GSXWPYJd+FCGQriGo65LNzyo1RVE
         RGDw/fR4YlZOV17x81AafRWabC8E+wiFS8lFWNzBUGryfY1QAgtDKqJL9gp+wIm4Ckb3
         dMU4J0KydTH8dCuX8uKunomy6djuU+arcoZ83R7Rzgc9SwJs1NTPfwW/GtERbt5aXbfK
         PPCfiLkM13M9CDItTmii+JlQFa/Ze7/FCz+Ewxq613SGYJIuB6NfOVzQ+FPCuwjR8gnk
         l1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8b5WecLz6ilBB8EW+pZrrbCkPphDzyvb2ZEZHud8SYQ=;
        b=RgC9CnvUUkAyTkVV0Ovy3tDQ0Z5Vf1fhiideRYy0+q5cAOzE8Rfddv+jluIi8gy5wN
         9N97dR4Ekpl5wRBs48lFEXYI3UTatd6JxGRR6TElJR6SZnamnWSt2fTagwlDro4SGbqx
         SPcb/BCxqAg3hcVMRd0m3mxeRDq5j77TPSTztkIExbn2CAxosXIj6suuIReaJO5w7+NL
         dSMovYcAn26ibRnXvz6D2b4U8YWSGwuHYlHK27AY43KM9LLUvhGt9r/CNBVAR9Dr1eHi
         7PUw3i6eiXfeuT007W/Aay5iS+V7x8gSuI6fLaBulcqHmyiL4RO+SLWy50C9ZYYD8IQb
         rYQg==
X-Gm-Message-State: ANoB5pmD5zjx/3aIk3xFsrt8I9WS3X5Y7Ptmc/QaLJg6gJpgMb1Ny48A
        j6ZuyMCgqsFtdspio9n+YdOTX7n8uozhg6KeSvArJw==
X-Google-Smtp-Source: AA0mqf63NrQvYcrTfaMb50nqIk0ayolFkYEbfKkh8gP/nYsRcRSMuOC7Eqwo/V4aTIYyIrw5xFS56k641S/0xiItwvU=
X-Received: by 2002:a0c:e6a9:0:b0:4bb:892a:fc11 with SMTP id
 j9-20020a0ce6a9000000b004bb892afc11mr68783673qvn.28.1670976748276; Tue, 13
 Dec 2022 16:12:28 -0800 (PST)
MIME-Version: 1.0
References: <20221206173601.549281-1-bgardon@google.com> <20221206173601.549281-3-bgardon@google.com>
 <Y5O+/1CYivRishFE@google.com>
In-Reply-To: <Y5O+/1CYivRishFE@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 13 Dec 2022 16:12:17 -0800
Message-ID: <CANgfPd8-i=B_c60MFn6symaqpUMXqu+HHJFDkQm8OuzOLnHQ+A@mail.gmail.com>
Subject: Re: [PATCH 2/7] KVM: x86/MMU: Move rmap_iterator to rmap.h
To:     David Matlack <dmatlack@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 9, 2022 at 3:04 PM David Matlack <dmatlack@google.com> wrote:
>
> On Tue, Dec 06, 2022 at 05:35:56PM +0000, Ben Gardon wrote:
> > In continuing to factor the rmap out of mmu.c, move the rmap_iterator
> > and associated functions and macros into rmap.(c|h).
> >
> > No functional change intended.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c  | 76 -----------------------------------------
> >  arch/x86/kvm/mmu/rmap.c | 61 +++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/mmu/rmap.h | 18 ++++++++++
> >  3 files changed, 79 insertions(+), 76 deletions(-)
> >
> [...]
> > diff --git a/arch/x86/kvm/mmu/rmap.h b/arch/x86/kvm/mmu/rmap.h
> > index 059765b6e066..13b265f3a95e 100644
> > --- a/arch/x86/kvm/mmu/rmap.h
> > +++ b/arch/x86/kvm/mmu/rmap.h
> > @@ -31,4 +31,22 @@ void free_pte_list_desc(struct pte_list_desc *pte_list_desc);
> >  void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head);
> >  unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
> >
> > +/*
> > + * Used by the following functions to iterate through the sptes linked by a
> > + * rmap.  All fields are private and not assumed to be used outside.
> > + */
> > +struct rmap_iterator {
> > +     /* private fields */
> > +     struct pte_list_desc *desc;     /* holds the sptep if not NULL */
> > +     int pos;                        /* index of the sptep */
> > +};
> > +
> > +u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
> > +                 struct rmap_iterator *iter);
> > +u64 *rmap_get_next(struct rmap_iterator *iter);
> > +
> > +#define for_each_rmap_spte(_rmap_head_, _iter_, _spte_)                      \
> > +     for (_spte_ = rmap_get_first(_rmap_head_, _iter_);              \
> > +          _spte_; _spte_ = rmap_get_next(_iter_))
> > +
>
> I always found these function names and kvm_rmap_head confusing since
> they are about iterating through the pte_list_desc data structure. The
> rmap (gfn -> list of sptes) is a specific application of the
> pte_list_desc structure, but not the only application. There's also
> parent_ptes in struct kvm_mmu_page, which is not an rmap, just a plain
> old list of ptes.
>
> While you are refactoring this code, what do you think about doing the
> following renames?
>
>   struct kvm_rmap_head  -> struct pte_list_head
>   struct rmap_iterator  -> struct pte_list_iterator
>   rmap_get_first()      -> pte_list_get_first()
>   rmap_get_next()       -> pte_list_get_next()
>   for_each_rmap_spte()  -> for_each_pte_list_entry()
>
> Then we can reserve the term "rmap" just for the actual rmap
> (slot->arch.rmap), and code that deals with sp->parent_ptes will become
> a lot more clear IMO (because it will not longer mention rmap).
>
> e.g. We go from this:
>
>   struct rmap_iterator iter;
>   u64 *sptep;
>
>   for_each_rmap_spte(&sp->parent_ptes, &iter, sptep) {
>      ...
>   }
>
> To this:
>
>   struct pte_list_iterator iter;
>   u64 *sptep;
>
>   for_each_pte_list_entry(&sp->parent_ptes, &iter, sptep) {
>      ...
>   }

I like this suggestion, and I do think it'll make things more
readable. It's going to be a huge patch to rename all the instances of
kvm_rmap_head, but it's probably worth it.
