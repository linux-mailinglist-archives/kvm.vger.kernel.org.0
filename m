Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DF87494F9
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 07:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbjGFF3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 01:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjGFF3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 01:29:38 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27291BCF
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 22:29:36 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2b5c2433134so3526921fa.0
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 22:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688621375; x=1691213375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FaztYOK3CeeSOgdOjNlGUDoiqmvgCpcAtf+Kjtl/Zxo=;
        b=oLDUHC7o8LLIpKQ47Bka4IhCDsnUOJ8PJa0mHtGy5+xmtH0ph+DN7fT2bOCyxUZ/OK
         voaasNoiVitwlvc6GdEXWSG+xw+zAyvNt5YIOkZ1Gv4N8GPo9GksM1sfnehNwooTJ6MC
         TIGRcSt6tw1MrfY6kMBuzzrrO3OFxrZGWrz+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688621375; x=1691213375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FaztYOK3CeeSOgdOjNlGUDoiqmvgCpcAtf+Kjtl/Zxo=;
        b=AsDeP1d6zVdiJu/isyUl1WQVubpNxLj0RXMvJDcDV7BMqn7orIbMMdhOgtxXcSdi5J
         strW3Gb59oixHBRiCH9Y6h6g9QV7M9wJ5rcVCQRAgbqxoce3JUNg4LcN8sjbJBUyvurr
         QX0KrL7k1nNA+WkxeulASk1xuFsW5pAJ9pdRcBG3RuY50L8IB4d7zgL4Q6HSPbtt0RkJ
         niIJtXzBcYFmGCswqAbIrbp6z4oMFmly9iJ02MPJrjr+35Ew33LciZSAgH8mt+mgC2AK
         Ne59QOLzJr+81UAPxqFw6oXqmxFY7HTxLEdhRcYpFDBwJEbxWrVuiNZknq+5OoY83Q+k
         q8uA==
X-Gm-Message-State: ABy/qLYknG8FRQ2XA7ApF4FOd7MmzvZBDcpq+7/P21Xnldms/N1hfrda
        vcRFxYMfmv6sjrLGJ3ZthSaAEABDFkIn+bAun92LZw==
X-Google-Smtp-Source: APBJJlFoQbGHquM/8F8vHFVN0DzDyQkinz8d9jngOAhWJR4+2GRUPIv/nW729Pai2dwCQYTiCsN6nZl/3HDPmf9AC/g=
X-Received: by 2002:a05:651c:107b:b0:2b6:d7d2:1a65 with SMTP id
 y27-20020a05651c107b00b002b6d7d21a65mr1632317ljm.18.1688621375279; Wed, 05
 Jul 2023 22:29:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-3-stevensd@google.com>
 <20230705031002.xrxk42hli6oavtlt@linux.intel.com> <CAD=HUj6-VbznOOtn5WJee7Of_nh33ygg7_ph2G=hgnvNk_Cbsw@mail.gmail.com>
 <20230705105343.iounmlflfued7lco@linux.intel.com>
In-Reply-To: <20230705105343.iounmlflfued7lco@linux.intel.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Thu, 6 Jul 2023 14:29:24 +0900
Message-ID: <CAD=HUj5ezWt7rLAv2qOpFsMHyFU87Hqtw_p8pWNF5+oxbLhxDg@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 5, 2023 at 7:53=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel.com=
> wrote:
>
> On Wed, Jul 05, 2023 at 06:22:59PM +0900, David Stevens wrote:
> > On Wed, Jul 5, 2023 at 12:10=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.inte=
l.com> wrote:
> > >
> > > > @@ -2514,35 +2512,26 @@ static bool hva_to_pfn_fast(unsigned long a=
ddr, bool write_fault,
> > > >   * The slow path to get the pfn of the specified host virtual addr=
ess,
> > > >   * 1 indicates success, -errno is returned if error is detected.
> > > >   */
> > > > -static int hva_to_pfn_slow(unsigned long addr, bool *async, bool w=
rite_fault,
> > > > -                        bool interruptible, bool *writable, kvm_pf=
n_t *pfn)
> > > > +static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t =
*pfn)
> > > >  {
> > > > -     unsigned int flags =3D FOLL_HWPOISON;
> > > > +     unsigned int flags =3D FOLL_HWPOISON | FOLL_GET | foll->flags=
;
> > > >       struct page *page;
> > > >       int npages;
> > > >
> > > >       might_sleep();
> > > >
> > > > -     if (writable)
> > > > -             *writable =3D write_fault;
> > > > -
> > > > -     if (write_fault)
> > > > -             flags |=3D FOLL_WRITE;
> > > > -     if (async)
> > > > -             flags |=3D FOLL_NOWAIT;
> > > > -     if (interruptible)
> > > > -             flags |=3D FOLL_INTERRUPTIBLE;
> > > > -
> > > > -     npages =3D get_user_pages_unlocked(addr, 1, &page, flags);
> > > > +     npages =3D get_user_pages_unlocked(foll->hva, 1, &page, flags=
);
> > > >       if (npages !=3D 1)
> > > >               return npages;
> > > >
> > > > +     foll->writable =3D (foll->flags & FOLL_WRITE) && foll->allow_=
write_mapping;
> > > > +
> > > >       /* map read fault as writable if possible */
> > > > -     if (unlikely(!write_fault) && writable) {
> > > > +     if (unlikely(!foll->writable) && foll->allow_write_mapping) {
> > >
> > > I guess !foll->writable should be !(foll->flags & FOLL_WRITE) here.
> >
> > The two statements are logically equivalent, although I guess using
> > !(foll->flags & FOLL_WRITE) may be a little clearer, if a little more
> > verbose.
>
> Well, as the comment says, we wanna try to map the read fault as writable
> whenever possible. And __gfn_to_pfn_memslot() will only set the FOLL_WRIT=
E
> for write faults. So I guess using !foll->writable will not allow this.
> Did I miss anything?

We just set the foll->writable out parameter to be equal to
((foll->flags & FOLL_WRITE) && foll->allow_write_mapping). Taking a =3D
foll->flags & FOLL_WRITE and b =3D foll->allow_write_mapping, we have
!(a && b) && b -> (!a || !b) && b -> (!a && b) || (!b && b) -> !a &&
b.

-David
