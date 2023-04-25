Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FD56ED953
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 02:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbjDYA05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 20:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjDYA0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 20:26:55 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FE355AA
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 17:26:54 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63b27afef94so6169648b3a.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 17:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682382414; x=1684974414;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y0GPAfq/j4MMCYY86VsVn6XSmEmWKaT+hC5gEQAEWk0=;
        b=sRYyfK3bSX8g4lhgYnedgFn1fFqLheztmVjxU9hGPDp5YUEp21SDreqifcis7RDfR2
         MSr3PpTwIw13MYHkmSAjSrfx5nGZymVG8W/K2GpkQKQ2EMGm9ya9SgSyxE4MewAR+vnE
         NajUdfe94j47kx2RR8RgG1/0pxHgNLuyNL26Y8K1xT8cIpb3O5gawV4ogvEDQXDrg0Au
         WdFrniMaqlYqkUW+jE1ShVEVreohZfjr0tra6mY5NUGfsCDlr0UyYHYNVQxPS9LuMElY
         aGGFLVuuRlXxZ/sXHtdywNcCZmGl7lJWxHZBq1r2kxxY+WGMNyNptHZAxwgRu5O5oBSX
         etuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682382414; x=1684974414;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y0GPAfq/j4MMCYY86VsVn6XSmEmWKaT+hC5gEQAEWk0=;
        b=CovgVoEAymu/PO45O/5aRWsUKtZLmsiOLQ0qP5lD3R71kbE8AeW2HDti3y+PAHwCjS
         mjrg041xaRMWSstlfXG+XvLZ8UgNp9kZBoh80riN1OI6vsT6cWW6Qh0Srw42DRGO69bS
         OIJPzLtJA5761+tN60K7vhAqq7Fl02xDgTkwRndVmkL27e4eRhWG5r5IlR9da1gmZEfE
         cJrlnj/btwOF25u11benby3jYDFVnkm2BdAKYjbwgHf7M/yVyyVy7hP+6scy3tWCQRm0
         6ZEL8IoQmH4rp2uat7F4EhqTtktqJ3BaRVh4lGpPWvzJCPHV3orK1LptGGTzUMaxZi5s
         ivzA==
X-Gm-Message-State: AAQBX9cVaSHeghUAYDKcbCVB5UPt7da3wNVxhcfyG7r93StGWJZQPkrk
        CL1t9T3aRwA6wHI6ZWfT25sXgXtgkp8=
X-Google-Smtp-Source: AKy350aI9KacLpcTntdEX1t+hfE6tIu7SRzJPK26wBgjP1Z3PO7Z4GKT2vF6R3sPyluoW2IYzKiT3vpf03c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a53:b0:63d:46f0:2370 with SMTP id
 h19-20020a056a001a5300b0063d46f02370mr6654126pfv.6.1682382413946; Mon, 24 Apr
 2023 17:26:53 -0700 (PDT)
Date:   Mon, 24 Apr 2023 17:26:52 -0700
In-Reply-To: <B6EEF84A-CCEA-44D7-B5AA-EA40073C81D4@gmail.com>
Mime-Version: 1.0
References: <ZEBHTw3+DcAnPc37@x1n> <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com> <ZEboGH28IVKPZ2vo@google.com>
 <B6EEF84A-CCEA-44D7-B5AA-EA40073C81D4@gmail.com>
Message-ID: <ZEceTNvdaLKJPTZ5@google.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From:   Sean Christopherson <seanjc@google.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Anish Moorthy <amoorthy@google.com>, Peter Xu <peterx@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023, Nadav Amit wrote:
> Feel free to tell me to shut up, as it is none of my business, and I migh=
t be
> missing a lot of context. Yet, it never stopped me before. :)
>=20
> > On Apr 24, 2023, at 1:35 PM, Sean Christopherson <seanjc@google.com> wr=
ote:
> >=20
> > On Mon, Apr 24, 2023, Nadav Amit wrote:
> >>=20
> >>> On Apr 24, 2023, at 10:54 AM, Anish Moorthy <amoorthy@google.com> wro=
te:
> >>> Sean did mention that he wanted KVM_CAP_MEMORY_FAULT_INFO in general,
> >>> so I'm guessing (some version of) that will (eventually :) be merged
> >>> in any case.
> >>=20
> >> It certainly not my call. But if you ask me, introducing a solution fo=
r
> >> a concrete use-case that requires API changes/enhancements is not
> >> guaranteed to be the best solution. It may be better first to fully
> >> understand the existing overheads and agree that there is no alternati=
ve
> >> cleaner and more general solution with similar performance.
> >=20
> > KVM already returns -EFAULT for these situations, the change I really w=
ant to land
> > is to have KVM report detailed information about why the -EFAULT occurr=
ed.  I'll be
> > happy to carry the code in KVM even if userspace never does anything be=
yond dumping
> > the extra information on failures.
>=20
> I thought that the change is to inform on page-faults through a new inter=
face
> instead of the existing uffd-file-based one. There is already another int=
erface
> (signals) and I thought (but did not upstream) io-uring. You now suggest =
yet
> another one.

There are two capabilities proposed in this series: one to provide more inf=
ormation
when KVM encounters a fault it can't resolve, and another to tell KVM to ki=
ck out
to userspace instead of attempting to resolve a fault when a given address =
couldn't
be resolved with fast gup.  I'm talking purely about the first one: providi=
ng more
information when KVM exits.

As for the second, my plan is to try and stay out of the way and let people=
 that
actually deal with the userspace side of things settle on an approach.  Fro=
m the
KVM side, supporting the "don't wait to resolve faults" flag is quite simpl=
e so
long as KVM punts the heavy lifting to userspace, e.g. identifying _why_ th=
e address
isn't mapped with the appropriate permissions.

> I am not sure it is very clean. IIUC, it means that you would still need =
in
> userspace to monitor uffd, as qemu (or whatever-kvm-userspace-counterpart=
-you-
> use) might also trigger a page-fault. So userspace becomes more complicat=
ed,
> and the ordering of different events/page-faults reporting becomes even m=
ore
> broken.
>=20
> At the same time, you also break various assumptions of userfaultfd. I do=
n=E2=80=99t
> immediately find some functionality that would break, but I am not very
> confident about it either.
>=20
> >=20
> >> Considering the mess that KVM async-PF introduced, I would be very car=
eful
> >> before introducing such API changes. I did not look too much on the de=
tails,
> >> but some things anyhow look slightly strange (which might be since I a=
m
> >> out-of-touch with KVM). For instance, returning -EFAULT on from KVM_RU=
N? I
> >> would have assumed -EAGAIN would be more appropriate since the invocat=
ion did
> >> succeed.
> >=20
> > Yeah, returning -EFAULT is somewhat odd, but as above, that's pre-exist=
ing
> > behavior that's been around for many years.
>=20
> Again, it is none of my business, but don=E2=80=99t you want to gradually=
 try to fix
> the interface so maybe on day you would be able to deprecate it?
>
> IOW, if you already introduce a new interface which is enabled with a new
> flag, which would require userspace change, then you can return the more
> appropriate error-code.

In a perfect world, yes.  But unfortunately, the relevant plumbing in KVM i=
s quite
brittle (understatement) with respect to returning "0", and AFAICT, returni=
ng
-EFAULT instead of 0 is nothing more than an odditity.  E.g. at worst, it c=
ould be
suprising to users writing a new VMM from scratch.

But I hadn't thought about returning a _different_ error code.  -EAGAIN isn=
't
obviously better though, e.g. my understanding is that -EAGAIN typically me=
ans that
retrying will succeed, but in pretty much every case where KVM returns -EFA=
ULT,
simply trying again will never succeed.  It's not even guaranteed to be app=
ropriate
in the "don't wait to resolve faults" case, because KVM won't actually know=
 why
an address isn't accessible, e.g. it could be because the page needs to be =
faulted
in, but it could also be a due to a guest bug that resulted in a permission
violation.

All in all, returning -EFAULT doesn't seem egregious.  I can't recall a sin=
gle complaint
about returning -EFAULT instead of -XYZ, just complaints about not KVM prov=
iding any
useful information.  So absent a concrete need for returning something othe=
r than
-EFAULT, I'm definitely inclined to maintain the status quo, even though it=
's imperfect.
