Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF72474E499
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 04:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjGKC7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 22:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjGKC7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 22:59:31 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0802E59
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 19:59:21 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2b703c900e3so79924981fa.1
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 19:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1689044360; x=1691636360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DBmSxEV9koNvPnH4f6fQb1MyHlXgygw1qw/AWmL9NU=;
        b=jbRRZbz4ynuhPqqeV5apPzs0jqkJtDi55aZFCp3oS1Ky8RkTvPlwMnB4q/fiemRBoQ
         /nqmDMG2P1A6auw8vdVkBVLFNlCCKg5J2gfTl+c6qkohrCouZIFJFDxXVd83G/CNdJVI
         qpp4LD8m9YAEdXqPmRzBi1781HakxZf9US60Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689044360; x=1691636360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+DBmSxEV9koNvPnH4f6fQb1MyHlXgygw1qw/AWmL9NU=;
        b=Ix75mEWrPHu4TmNjv2dejsqQvfrqRs0jkn/Nu52iK7SE16Ml/rI6uE2jN+Cmg3AgzG
         6PmHFO8wo9vpwCTwpVIavvr2jmqei0ntmMd69CSjZL46sfv7S/e3CV669At3ngOEOWGm
         479xBNjInvRooiSjVd3iLnLm8fTORaLgZCyjSXvTND3k3G/2TzzE5EegNt2vK+wYQ46s
         Zs2LVZB2kfzxRyYCwwiu8deZke8WjlHL/vNgSCJmW962+nkoWdf1WtiAWoBLYQ/lBV3k
         faxtwzQAd+Lzk97MuaXvuF2BmpGbUuL8r0Zqdh7c0zNj/vK1aNeS9t8mbjWPd7xE5TwE
         EZ+Q==
X-Gm-Message-State: ABy/qLat3BdaO0E15WwWz//sB6X/9groMybX5eLky+fWqwoBy7JRuutK
        Wml8KG/z+jyix/BTIcSdEA/PpNmXFK6tOGXQrj+ZWA==
X-Google-Smtp-Source: APBJJlFhZxK1fGMNnOjl8Qk8f7Az5wy8Xg34SBiq6VLsMfXYX+pfTJMvsTItHqfjvno05fAVxl0LMgHzDd+1uLzcle4=
X-Received: by 2002:a2e:7e12:0:b0:2b7:1b63:4657 with SMTP id
 z18-20020a2e7e12000000b002b71b634657mr5157080ljc.37.1689044359940; Mon, 10
 Jul 2023 19:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <20230705101800.ut4c6topn6ylwczs@linux.intel.com> <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
 <20230706155805.GD3894444@ls.amr.corp.intel.com> <CAD=HUj6GiK3TSSe7UY8C2Jd+3tjZNBa-TLgk-UodyL=E+qKavg@mail.gmail.com>
 <20230710163448.GE3894444@ls.amr.corp.intel.com>
In-Reply-To: <20230710163448.GE3894444@ls.amr.corp.intel.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Tue, 11 Jul 2023 11:59:08 +0900
Message-ID: <CAD=HUj6ZEzVEFgn_J_9EPNMj5i-N=MSc0xZF8FweqrgTxUks0g@mail.gmail.com>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 11, 2023 at 1:34=E2=80=AFAM Isaku Yamahata <isaku.yamahata@gmai=
l.com> wrote:
>
> On Fri, Jul 07, 2023 at 10:35:02AM +0900,
> David Stevens <stevensd@chromium.org> wrote:
>
> > > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > > > index e44ab512c3a1..b1607e314497 100644
> > > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > >
> > > > > ...
> > > > >
> > > > > > @@ -2937,6 +2943,7 @@ static int mmu_set_spte(struct kvm_vcpu *=
vcpu, struct kvm_memory_slot *slot,
> > > > > >       bool host_writable =3D !fault || fault->map_writable;
> > > > > >       bool prefetch =3D !fault || fault->prefetch;
> > > > > >       bool write_fault =3D fault && fault->write;
> > > > > > +     bool is_refcounted =3D !fault || fault->is_refcounted_pag=
e;
> > > > >
> > > > > Just wonder, what if a non-refcounted page is prefetched?  Or is =
it possible in
> > > > > practice?
> > > >
> > > > Prefetching is still done via gfn_to_page_many_atomic, which sets
> > > > FOLL_GET. That's fixable, but it's not something this series curren=
tly
> > > > does.
> > >
> > > So if we prefetch a page, REFCOUNTED bit is cleared unconditionally w=
ith this
> > > hunk.  kvm_set_page_{dirty, accessed} won't be called as expected for=
 prefetched
> > > spte.  If I read the patch correctly, REFCOUNTED bit in SPTE should r=
epresent
> > > whether the corresponding page is ref-countable or not, right?
> > >
> > > Because direct_pte_prefetch_many() is for legacy KVM MMU and FNAME(pr=
efetch_pte)
> > > is shadow paging, we need to test it with legacy KVM MMU or shadow pa=
ging to hit
> > > the issue, though.
> > >
> >
> > direct_pte_prefetch_many and prefetch_gpte both pass NULL for the
> > fault parameter, so is_refcounted will evaluate to true. So the spte's
> > refcounted bit will get set in that case.
>
> Oops, my bad.  My point is "unconditionally".  Is the bit always set for
> non-refcountable pages?  Or non-refcountable pages are not prefeched?

The bit is never set for non-refcounted pages, and is always set for
refcounted pages. The current series never prefetches non-refcounted
pages, since it continues to use the gfn_to_page_many_atomic API.

-David
