Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620917495EB
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 08:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbjGFGty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 02:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjGFGtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 02:49:53 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B5310E
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 23:49:52 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2b6b98ac328so4180611fa.0
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 23:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688626190; x=1691218190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r5eWkSj4KC5nS3P+RLvcZXPptH23EBW7FjX/9bZ4xeY=;
        b=ja4IOO3xVZ6/Tc75u/mIiFFibtnYxJ3DyQJiezKFRO1BT/i/tInsQdPBwqV1K6c8OB
         NzrTW0CCdwtJDcyKr+K7eaRAfl7gSY3EPoTgo/V1gOdfqehluk6JZK6F4LvwA1z4DQCk
         aCMPhrABaGhAhTIgENGDgkn/PB5cEiYnULzWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688626190; x=1691218190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r5eWkSj4KC5nS3P+RLvcZXPptH23EBW7FjX/9bZ4xeY=;
        b=M6gTYjRrI8/FG+kt+g4haF8MT0aI5o2KsP78PVrjMJjlhyHXlOVvSSzkWE1AGmdBdN
         9ENZXNupJxBXo5IJe9II1bev8/M8ZY1tz4eDxLrOkSHsm67FtsXGoPTyDyDRPGkqgwSi
         Cd+4MWc7imSXVev2/9iAKV7dwmTazHDiMvqcZgIvQ0KCFBhThhhlxDnn51IX+KlrNYDz
         r+yait/S5zaaF3Fhcr9erLnqTUNexMf+1Q51A0aNa8txLmJ4Pz1U9ocNC+mrnlcvUSpS
         Xcd3T9Qw7LACQWzw9NPxfC1YvVqO0CaxY/rQ6pGts1LLrF+lILK5wYw2UGNr5qNWED1O
         LftQ==
X-Gm-Message-State: ABy/qLYxKR9UZmoVG24uO2DJjvCJsOKmz/g9IUdbsjbavlcUBAbWikEl
        twYDfMIjxlGe+ZXUbJA7L2/woAgRQA/LBwL6MGjn9A==
X-Google-Smtp-Source: APBJJlF7htU9Rd6ty5mPrsHjdKtTcK7sc+s+47FH3YkpHGjHXvbMbW6eRVcyDM6GyWvtGpLRUG3fOJ+jUV4yvf2Vv+s=
X-Received: by 2002:a2e:b60d:0:b0:2b6:bb08:91c4 with SMTP id
 r13-20020a2eb60d000000b002b6bb0891c4mr609674ljn.42.1688626190310; Wed, 05 Jul
 2023 23:49:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-4-stevensd@google.com>
 <20230705161914.00004070.zhi.wang.linux@gmail.com>
In-Reply-To: <20230705161914.00004070.zhi.wang.linux@gmail.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Thu, 6 Jul 2023 15:49:39 +0900
Message-ID: <CAD=HUj5cbzjrc0KD7xcibtRMRCzoJRJAzt7jTHSXUSpzyAYbdg@mail.gmail.com>
Subject: Re: [PATCH v7 3/8] KVM: Make __kvm_follow_pfn not imply FOLL_GET
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 5, 2023 at 10:19=E2=80=AFPM Zhi Wang <zhi.wang.linux@gmail.com>=
 wrote:
>
> On Tue,  4 Jul 2023 16:50:48 +0900
> David Stevens <stevensd@chromium.org> wrote:
>
> > From: David Stevens <stevensd@chromium.org>
> >
> > Make it so that __kvm_follow_pfn does not imply FOLL_GET. This allows
> > callers to resolve a gfn when the associated pfn has a valid struct pag=
e
> > that isn't being actively refcounted (e.g. tail pages of non-compound
> > higher order pages). For a caller to safely omit FOLL_GET, all usages o=
f
> > the returned pfn must be guarded by a mmu notifier.
> >
> > This also adds a is_refcounted_page out parameter to kvm_follow_pfn tha=
t
> > is set when the returned pfn has an associated struct page with a valid
> > refcount. Callers that don't pass FOLL_GET should remember this value
> > and use it to avoid places like kvm_is_ad_tracked_page that assume a
> > non-zero refcount.
> >
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  include/linux/kvm_host.h | 10 ++++++
> >  virt/kvm/kvm_main.c      | 67 +++++++++++++++++++++-------------------
> >  virt/kvm/pfncache.c      |  2 +-
> >  3 files changed, 47 insertions(+), 32 deletions(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index ef2763c2b12e..a45308c7d2d9 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1157,6 +1157,9 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_=
memory_slot *slot, gfn_t gfn,
> >  void kvm_release_page_clean(struct page *page);
> >  void kvm_release_page_dirty(struct page *page);
> >
> > +void kvm_set_page_accessed(struct page *page);
> > +void kvm_set_page_dirty(struct page *page);
> > +
> >  struct kvm_follow_pfn {
> >       const struct kvm_memory_slot *slot;
> >       gfn_t gfn;
> > @@ -1164,10 +1167,17 @@ struct kvm_follow_pfn {
> >       bool atomic;
> >       /* Allow a read fault to create a writeable mapping. */
> >       bool allow_write_mapping;
> > +     /*
> > +      * Usage of the returned pfn will be guared by a mmu notifier. Mu=
st
>                                               ^guarded
> > +      * be true if FOLL_GET is not set.
> > +      */
> > +     bool guarded_by_mmu_notifier;
> >
> It seems no one sets the guraded_by_mmu_notifier in this patch. Is
> guarded_by_mmu_notifier always equal to !foll->FOLL_GET and set by the
> caller of __kvm_follow_pfn()?

Yes, this is the case.

> If yes, do we have to use FOLL_GET to resolve GFN associated with a tail =
page?
> It seems gup can tolerate gup_flags without FOLL_GET, but it is more like=
 a
> temporary solution. I don't think it is a good idea to play tricks with
> a temporary solution, more like we are abusing the toleration.

I'm not sure I understand what you're getting at. This series never
calls gup without FOLL_GET.

This series aims to provide kvm_follow_pfn as a unified API on top of
gup+follow_pte. Since one of the major clients of this API uses an mmu
notifier, it makes sense to support returning a pfn without taking a
reference. And we indeed need to do that for certain types of memory.

> Is a flag like guarded_by_mmu_notifier (perhaps a better name) enough to
> indicate a tail page?

What do you mean by to indicate a tail page? Do you mean to indicate
that the returned pfn refers to non-refcounted page? That's specified
by is_refcounted_page.

-David
