Return-Path: <kvm+bounces-30119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0622B9B709E
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 865851F22960
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 23:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803B5217644;
	Wed, 30 Oct 2024 23:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fR2rnDr4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7DA2141CA
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 23:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730331727; cv=none; b=TZMKtClddNsTlYekRe9Vj6Sh04W0d5VS/SRLJQD75z54R6Q3I7/QAj8LFaer/48cfGk4XNtYQgq2dL9c/qj327F0qdI6RFgovWdy8jy4DqMLIPYGhVIAUAVnvS3kXsYIAeqBkPXojscJQKqaExEaeekDBDo4Q+BkGx1fteARPeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730331727; c=relaxed/simple;
	bh=2MJym9fqZM1RK3makNlLiRE4YbazRsZfQFy92F2Fg1g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IDV9Dy0RfEH0VsOL4gWzxkgjalCaOsCC3HDdLFM2BTKmoXIF6TV8KaZ0CtzoBENUDxBTgFxE5B2gHsHJpxfKwfY29QG9uIkAOcTMFli2zE1jw+u6yRHm/TkJMUoxcNgqxjn/cIgDS+3WtFxW7RwLSjsx0wAJMCuuudvCcEYMLZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fR2rnDr4; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7edcfbf0a25so299630a12.1
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 16:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730331725; x=1730936525; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eHK7C1e2fWTbohs5+ABIPSJ/CVLY4Eyu0LTRW50oNYY=;
        b=fR2rnDr4b51jenJ257jV1io7Pk+Lp1gVsnruJaLrMkHqLhJDyuEwVlGnds9IWP3aA3
         PAQ8+yCzJL/EjNUOWpNAROsnAO1KZLXAvMLQkp3r2gPqlhGnz4uPh2/FFmkyydokwMUu
         ovGyhLo1XBLtLyCaCukPCS4R2yGv/IzYLhZOO5fXxqOEhxO6qU1PXZ1VD/7gemtTFMwF
         F+2PFhmIWZ+YAicRZO7lHnoxAclghNj6Y62SIv9zckEX+qRRr3ABCaJA381tQiC2KrND
         P/rRRtIk8SsKGySKyl8T2P1gg5zMZ9evLamLT3cClTXuTKnGt61YK23mxCy+qfruptZ+
         NvwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730331725; x=1730936525;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eHK7C1e2fWTbohs5+ABIPSJ/CVLY4Eyu0LTRW50oNYY=;
        b=aaHG+fQg96ZB1xB6fsQuF57iUZFAWb9F1nF2sj9GkXA3AHp4Q53j8TaQKH7s91NUob
         /YrMX8h0bM0K23f8CLi6AWKXEw2LWPvD1KTlZfliekbxBdBLs29Zc9lPCA1tnkKkmJ1y
         CdX/MANSXk/L49q6zvYCx2xw4SLd9xY3slQpE0RrWsOyPYkfqyfwQzY0LC0eN47v8OmY
         cOZpic1s2ipUSew4plmU1DHjISbPqInRlL38pfYOE2YZxnpY3NkjlGz+AxKhqVLXfB7U
         qO/QW8/J45sw6rNFYvKPM0H0wsE6vuQx5FrvajWCq1deB9M5MDw+THBvxnmoHGvXMnGI
         +1xQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwYlk8XzC2QpNVFrsjMuw7XSqVqBJqRX7BLZbgHJg//1Dd1Otd9uCjMy+ysWbfcnbiWBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkQ6uuxzaxCWgybg9XEkdAHpoqq7oLfjscMvP1/gcLIU3vZ59r
	QltL/DeQhQIowFtosuiiot7Tp46K7ymAcYejwsBEcC5od1DoWbT/Z1AhvOuB7lW+D2GPgSXik6z
	yVA==
X-Google-Smtp-Source: AGHT+IH5+A2yNg2ZWst6d+9pk2e6XW+W2j397MeByyS2sxhLX29ea3vCR+zaxcTjobdIcFlZERuYogOzepU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:7157:0:b0:7d4:fd0a:ef3b with SMTP id
 41be03b00d2f7-7edd77fa33cmr39023a12.0.1730331724994; Wed, 30 Oct 2024
 16:42:04 -0700 (PDT)
Date: Wed, 30 Oct 2024 16:42:03 -0700
In-Reply-To: <CAHVum0di0z1G7qDfexErzi_f99_T_fTPbZM0s2=TYFCQ8K5pBg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com> <20240823235648.3236880-5-dmatlack@google.com>
 <CAHVum0ffQFnu2-uGYCsxQJt4HxmC+dTKP=StzRJgHxajJ7tYoA@mail.gmail.com>
 <Zwa-9mItmmiKeVsd@google.com> <CAHVum0di0z1G7qDfexErzi_f99_T_fTPbZM0s2=TYFCQ8K5pBg@mail.gmail.com>
Message-ID: <ZyLES2Ai4CC4W-0s@google.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: Recover TDP MMU huge page mappings
 in-place instead of zapping
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2024, Vipin Sharma wrote:
> On Wed, Oct 9, 2024 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, Oct 09, 2024, Vipin Sharma wrote:
> > > On Fri, Aug 23, 2024 at 4:57=E2=80=AFPM David Matlack <dmatlack@googl=
e.com> wrote:
> > > > +static u64 modify_spte_protections(u64 spte, u64 set, u64 clear)
> > > >  {
> > > >         bool is_access_track =3D is_access_track_spte(spte);
> > > >
> > > >         if (is_access_track)
> > > >                 spte =3D restore_acc_track_spte(spte);
> > > >
> > > > -       spte &=3D ~shadow_nx_mask;
> > > > -       spte |=3D shadow_x_mask;
> > > > +       spte =3D (spte | set) & ~clear;
> > >
> > > We should add a check here WARN_ON_ONCE(set & clear) because if both
> > > have a common bit set to 1 then the result  will be different between=
:
> > > 1. spte =3D (spt | set) & ~clear
> > > 2. spte =3D (spt | ~clear) & set
> > >
> > > In the current form, 'clear' has more authority in the final value of=
 spte.
> >
> > KVM_MMU_WARN_ON(), overlapping @set and @clear is definitely something =
that should
> > be caught during development, i.e. we don't need to carry the WARN_ON_O=
NCE() in
> > production kernels
> >
> > > > +u64 make_huge_spte(struct kvm *kvm, u64 small_spte, int level)
> > > > +{
> > > > +       u64 huge_spte;
> > > > +
> > > > +       if (KVM_BUG_ON(!is_shadow_present_pte(small_spte), kvm))
> > > > +               return SHADOW_NONPRESENT_VALUE;
> > > > +
> > > > +       if (KVM_BUG_ON(level =3D=3D PG_LEVEL_4K, kvm))
> > > > +               return SHADOW_NONPRESENT_VALUE;
> > > > +
> > >
> > > KVM_BUG_ON() is very aggressive. We should replace it with WARN_ON_ON=
CE()
> >
> > I'm tempted to say KVM_MMU_WARN_ON() here too.
>=20
> I am fine with KVM_MMU_WARN_ON() here. Callers should check for the
> value they provided and returned from this API and if it's important
> to them in Production then decide on next steps accordingly.

Coming back to this, I opted to match the behavior of make_small_spte() and=
 do:

	KVM_BUG_ON(!is_shadow_present_pte(small_spte) || level =3D=3D PG_LEVEL_4K,=
 kvm);

As explained in commit 3d4415ed75a57, the scenario is meant to be impossibl=
e.
If the check fails in production, odds are good there's SPTE memory corrupt=
ion
and we _want_ to kill the VM.

    KVM: x86/mmu: Bug the VM if KVM tries to split a !hugepage SPTE
   =20
    Bug the VM instead of simply warning if KVM tries to split a SPTE that =
is
    non-present or not-huge.  KVM is guaranteed to end up in a broken state=
 as
    the callers fully expect a valid SPTE, e.g. the shadow MMU will add an
    rmap entry, and all MMUs will account the expected small page.  Returni=
ng
    '0' is also technically wrong now that SHADOW_NONPRESENT_VALUE exists,
    i.e. would cause KVM to create a potential #VE SPTE.
   =20
    While it would be possible to have the callers gracefully handle failur=
e,
    doing so would provide no practical value as the scenario really should=
 be
    impossible, while the error handling would add a non-trivial amount of
    noise.

There's also no need to return SHADOW_NONPRESENT_VALUE.  KVM_BUG_ON() ensur=
es
all vCPUs are kicked out of the guest, so while the return SPTE may be a bi=
t
nonsensical, it will never be consumed by hardware.  Theoretically, KVM cou=
ld
wander down a weird path in the future, but again, the most likely scenario=
 is
that there was host memory corruption, so potential weird paths are the lea=
st of
KVM's worries at that point.

More importantly, in the _current_ code, returning SHADOW_NONPRESENT_VALUE =
happens
to be benign, but that's 100% due to make_huge_spte() only being used by th=
e TDP
MMU.  If the shaduw MMU ever started using make_huge_spte(), returning a !p=
resent
SPTE would be all but guaranteed to cause fatal problems.

