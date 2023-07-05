Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426D97480BB
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 11:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjGEJXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 05:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjGEJXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 05:23:13 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7E6E5
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 02:23:12 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b6ff1ada5dso6827921fa.2
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 02:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688548990; x=1691140990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hevL1MlnabH6U4eIyVNZqX1Q6T1jS/bGfgvHOxnvxFk=;
        b=UjRgjsVBiY8D2AXveR2isxaEiF6+iOKVwJC0ezqlGCKd5u2QVdG+ntqDaxNfYIhHYh
         7tH2XGdL93OCAOdZMYBp4jJVQHAKzpFSXh4XiPwkMuh2gMxkUrjGMC/CYge/PDTC6reF
         FsTwGWH8uIYJu0RFz24ORez/tyH0bQ20ps1Vc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688548990; x=1691140990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hevL1MlnabH6U4eIyVNZqX1Q6T1jS/bGfgvHOxnvxFk=;
        b=keYVOqHDdqi1x8tRMBTPjNfEFG+qTVbPemYscQol5QMX6uLrnaKIwp/lhQp2UBjKY/
         yuYOvyhSOWozL59AqnQWQ9JYtgIHoamuHfZABqa3KDHi/T2nYabS1V+K8UKbUubzUOKX
         CDiHYz7nG1RcvBRbMRjpBPDv44r0f0mHXuRCTaXHmWJb1qv3tII+xKwT1oNF/V/fFw5L
         QiCABQF4PVtDTaXitTnjKx8ZeGzh5jRmN7TqA+zTw/WIEegq7eheOD9iWylD0TVVxZRT
         IKfg+Lxtrh+wjjhWjAooO1ri5Aejn5BVBK84AdPY/J+G4zdTxyn5e3aMri2Jllw4A7oY
         0eeQ==
X-Gm-Message-State: ABy/qLZ+tWE6oxXmqCAS/2VcmxW9NiTM/ZX9nACySEo9qwBn5a3ibvOY
        9fT29zduFheUK4QbJKpVMVYMq4RQ1wCJ/7iCOQ1iRw==
X-Google-Smtp-Source: APBJJlHALNKpgop8uXo+YA22FSE0sRA/ZaoE9VV+TBwKPxNA104VYZCTQrddq5ETUv0WC+BnXxDNFCP/AZDkp5bMkgw=
X-Received: by 2002:a05:651c:8e:b0:2b6:e283:32cb with SMTP id
 14-20020a05651c008e00b002b6e28332cbmr6846475ljq.23.1688548990474; Wed, 05 Jul
 2023 02:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-3-stevensd@google.com>
 <20230705031002.xrxk42hli6oavtlt@linux.intel.com>
In-Reply-To: <20230705031002.xrxk42hli6oavtlt@linux.intel.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Wed, 5 Jul 2023 18:22:59 +0900
Message-ID: <CAD=HUj6-VbznOOtn5WJee7Of_nh33ygg7_ph2G=hgnvNk_Cbsw@mail.gmail.com>
Subject: Re: [PATCH v7 2/8] KVM: Introduce __kvm_follow_pfn function
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 5, 2023 at 12:10=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel.co=
m> wrote:
>
> > @@ -2514,35 +2512,26 @@ static bool hva_to_pfn_fast(unsigned long addr,=
 bool write_fault,
> >   * The slow path to get the pfn of the specified host virtual address,
> >   * 1 indicates success, -errno is returned if error is detected.
> >   */
> > -static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write=
_fault,
> > -                        bool interruptible, bool *writable, kvm_pfn_t =
*pfn)
> > +static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn=
)
> >  {
> > -     unsigned int flags =3D FOLL_HWPOISON;
> > +     unsigned int flags =3D FOLL_HWPOISON | FOLL_GET | foll->flags;
> >       struct page *page;
> >       int npages;
> >
> >       might_sleep();
> >
> > -     if (writable)
> > -             *writable =3D write_fault;
> > -
> > -     if (write_fault)
> > -             flags |=3D FOLL_WRITE;
> > -     if (async)
> > -             flags |=3D FOLL_NOWAIT;
> > -     if (interruptible)
> > -             flags |=3D FOLL_INTERRUPTIBLE;
> > -
> > -     npages =3D get_user_pages_unlocked(addr, 1, &page, flags);
> > +     npages =3D get_user_pages_unlocked(foll->hva, 1, &page, flags);
> >       if (npages !=3D 1)
> >               return npages;
> >
> > +     foll->writable =3D (foll->flags & FOLL_WRITE) && foll->allow_writ=
e_mapping;
> > +
> >       /* map read fault as writable if possible */
> > -     if (unlikely(!write_fault) && writable) {
> > +     if (unlikely(!foll->writable) && foll->allow_write_mapping) {
>
> I guess !foll->writable should be !(foll->flags & FOLL_WRITE) here.

The two statements are logically equivalent, although I guess using
!(foll->flags & FOLL_WRITE) may be a little clearer, if a little more
verbose.

> >               struct page *wpage;
> >
> > -             if (get_user_page_fast_only(addr, FOLL_WRITE, &wpage)) {
> > -                     *writable =3D true;
> > +             if (get_user_page_fast_only(foll->hva, FOLL_WRITE, &wpage=
)) {
> > +                     foll->writable =3D true;
> >                       put_page(page);
> >                       page =3D wpage;
> >               }
> > @@ -2572,23 +2561,23 @@ static int kvm_try_get_pfn(kvm_pfn_t pfn)
> >       return get_page_unless_zero(page);
> >  }
> >
> ...
>
> > +kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn=
_t gfn,
> > +                            bool atomic, bool interruptible, bool *asy=
nc,
> > +                            bool write_fault, bool *writable, hva_t *h=
va)
> > +{
> > +     kvm_pfn_t pfn;
> > +     struct kvm_follow_pfn foll =3D {
> > +             .slot =3D slot,
> > +             .gfn =3D gfn,
> > +             .flags =3D 0,
> > +             .atomic =3D atomic,
> > +             .allow_write_mapping =3D !!writable,
> > +     };
> > +
> > +     if (write_fault)
> > +             foll.flags |=3D FOLL_WRITE;
> > +     if (async)
> > +             foll.flags |=3D FOLL_NOWAIT;
> > +     if (interruptible)
> > +             foll.flags |=3D FOLL_INTERRUPTIBLE;
> > +
> > +     pfn =3D __kvm_follow_pfn(&foll);
> > +     if (pfn =3D=3D KVM_PFN_ERR_NEEDS_IO) {
>
> Could we just use KVM_PFN_ERR_FAULT and foll.flags here? I.e.,
>         if (pfn =3D=3D KVM_PFN_ERR_FAULT && (foll.flags & FOLL_NOWAIT))?
> Setting pfn to KVM_PFN_ERR_NEEDS_IO just to indicate an async fault
> seems unnecessary.

There are the cases where the fault does not fall within a vma or when
the target vma's flags don't support the fault's access permissions.
In those cases, continuing to try to resolve the fault won't cause
problems per-se, but it's wasteful and a bit confusing. Having
hva_to_pfn detect whether or not it may be possible to resolve the
fault asynchronously and return KVM_PFN_ERR_NEEDS_IO if so seems like
a good idea. It also matches what the existing code does.

-David
