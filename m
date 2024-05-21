Return-Path: <kvm+bounces-17860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 45CB58CB45A
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 21:42:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6DD61F232CB
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 19:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F382148FE2;
	Tue, 21 May 2024 19:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H++AB3KB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC76414884F
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 19:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716320518; cv=none; b=UuskQBR8Wm7PARD2fqFQm3tlUu5Z3UHO8q1WAZwn2rw5wAeyzXxulnzk4mM16Qal06lrEBvVFV+XxmqEQnCCfo/ZrmB3hQ/ZDHbSVg7THQNgou/TPNJo+mPGYlXa/P/0JRnnSxtUYtrrWnxJ0HarRXXnN5jfCArWFV7AP80uFg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716320518; c=relaxed/simple;
	bh=OkQAloYfrjTCxI5R61W0c2HsONW8mx2kyCdips0XuGE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rTHcYms/t15z6Mzs7ejAKdhQ44131f0r7gY9htgez+RZi3b4Q/3CU70uME0WZMA5EK+gKeyC5H1ivHuMkfU/eOHxwQ1mrQ3RCq2G7gqmr9/xAslHAyVaFb7YEOYNeLrxyE+AzRSSd6/VVK9bT5l0IiQPB8uC8tx/AqM6Ewe9M/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H++AB3KB; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61d21cf3d3bso230522037b3.3
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 12:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716320516; x=1716925316; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x8oREZii6ILX8aejuabYEPwCdXSrhy5LDRM76AphFvk=;
        b=H++AB3KBPh3sNnMRTk8x+NITyxJYiid702ZPW4tIPhTsaZN7ZD7OLmv4VmbM9EffQ2
         yWaov4Gj4QWoSesa3aZLEEENd0rngCQ9GWKg/IEIRSiVuEAkM7PuO6hIeSechp+VzBZD
         T9uiGndYBIuvmdnZnVeufP3gyxK+Xe0X+nIufBTG5JCwhLJ7yfZiZkVvNoukRZL/llcF
         yJrq6fnL5Jsso1E0hL562zYXoHcq50rO9d7ReiC9XrsW2J6Lx42/hS26wz2tzkDK0Lh2
         lF8i0SjkRgq1Q15iPxo21N+8CXzzZJ0Le4rffbipKGEw7hVnbCIRd4/yhaT0w5o3JWXU
         EbfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716320516; x=1716925316;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x8oREZii6ILX8aejuabYEPwCdXSrhy5LDRM76AphFvk=;
        b=PavBJtJOBueb7DAexH9UvHpl4wHv/yu3ILyruuzF51aml9VsVTHEsXhYRv6BJuVerc
         K83e28FsZdEnlFqp5eVjQ8Y4rpqoMOuypulBlvnbVpWbdRJps+ME92lhaicwZrjxc/dC
         3QGB+b2s+rbcVSXcvLURCOUbrH5dmZoayzUQlhUD25adCR+w+/W5Im0+BzQwapKRdvuO
         xUR67k6sUO9gQ9xjPxDuWjP6MC5Rm/8EzTs8FhpdaZaC0+1gt0HwNRWsFgrEnSb3Ffn7
         5N4iJGp445iNf4KGb8tFFLH/YkCBwhD+I838PoUZOVt62vWO1N6/LT96HJRIWSUOlm42
         rhOw==
X-Gm-Message-State: AOJu0Yx83l48O+Y5qqVSdW2Phj37YS72ecQQqQEyZcqyGa4Pb0/WD/6J
	aRWtZfQSShL27X0p4LEWs8x9tYsnJi4mRyc2rx66/aR2ZfTuupl/wrYZ6yruE7JXE53nEHtlEBV
	GVQ==
X-Google-Smtp-Source: AGHT+IFefbvs2I1EQ32c2X0kJBRZBGDz5Zyylw9IDVbAgBVa7oHYjQIOg9MAgGkxQ7qEMWctcYVnwMFMLV4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1007:b0:dee:7bdf:3fc8 with SMTP id
 3f1490d57ef6-df4e0a7f43fmr3991276.2.1716320515927; Tue, 21 May 2024 12:41:55
 -0700 (PDT)
Date: Tue, 21 May 2024 12:41:54 -0700
In-Reply-To: <ZkwQQZ22ImN6fXTM@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520022002.1494056-1-tao1.su@linux.intel.com>
 <ZkthpjnKRD1Jpj2A@google.com> <ZkwQQZ22ImN6fXTM@linux.bj.intel.com>
Message-ID: <Zkz5Ak0PQlAN8DxK@google.com>
Subject: Re: [PATCH] KVM: x86: Advertise AVX10.1 CPUID to userspace
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024, Tao Su wrote:
> On Mon, May 20, 2024 at 07:43:50AM -0700, Sean Christopherson wrote:
> > On Mon, May 20, 2024, Tao Su wrote:
> > > @@ -1162,6 +1162,22 @@ static inline int __do_cpuid_func(struct kvm_c=
puid_array *array, u32 function)
> > >  			break;
> > >  		}
> > >  		break;
> > > +	case 0x24: {
> > > +		u8 avx10_version;
> > > +		u32 vector_support;
> > > +
> > > +		if (!kvm_cpu_cap_has(X86_FEATURE_AVX10)) {
> > > +			entry->eax =3D entry->ebx =3D entry->ecx =3D entry->edx =3D 0;
> > > +			break;
> > > +		}
> > > +		avx10_version =3D min(entry->ebx & 0xff, 1);
> >=20
> > Taking the min() of '1' and anything else is pointless.  Per the spec, =
the version
> > can never be 0.
> >=20
> >   CPUID.(EAX=3D24H, ECX=3D00H):EBX[bits 7:0]  Reports the Intel AVX10 C=
onverged Vector ISA version. Integer (=E2=89=A5 1)
> >=20
> > And it's probably too late, but why on earth is there an AVX10 version =
number?
> > Version numbers are _awful_ for virtualization; see the constant vPMU p=
roblems
> > that arise from bundling things under a single version number..  Y'all =
carved out
> > room for sub-leafs, i.e. there's a ton of room for "discrete feature bi=
ts", so
> > why oh why is there a version number?
> >=20
>=20
> Per the spec, AVX10 wants to reduce the number of CPUID feature flags req=
uired
> to be checked, which may simplify application development. Application on=
ly
> needs to check the version number that can know whether hardware supports=
 an
> instruction.

I get that, but it royally hoses virtualization.  Bundling multiple feature=
s
under a single flag is annoying, e.g. it makes it impossible to selectively
advertise features, but I can appreciate that there are situations where ha=
ving
one feature but not another is nonsensical.

Incrementing version numbers are a whole other level of bad though.  E.g. i=
f
AVX10.2 has a feature that shouldn't be enumerated to guests for whatever r=
eason,
then KVM can't enumerate any "later" features either, because the only way =
to hide
the problematic AVX10.2 feature is to set the version to AVX10.1 or lower.

FWIW, unlike the PMU, which is a bit of a disaster due to version numbers, =
I don't
expect AVX to be problematic in practice.  E.g. most AVX features are just =
passed
through and don't have virtualization controls.  I just think it's a terrib=
le
tradeoff.  E.g. if features really need to be bundled together, I don't see=
 how
application development is meaningfully more difficult if enumeration is do=
ne
via a multi-purpose CPUID flag, versus a version number.

> There's indeed a sub-leaf for enumerating discrete CPUID feature bits, bu=
t
> the sub-leaf is only in the rare case.
>=20
> AVX10.2 (version number =3D=3D 2) is the initial and fully-featured versi=
on of

So what's AVX10.1?

> AVX10, we may need to advertise AVX10.2 in the future. Is keeping min() m=
ore
> flexible to control the advertised version number? E.g.
>=20
>     avx10_version =3D min(entry->ebx & 0xff, 2);
>=20
> can advertise AVX10.2 to userspace.

I'm not worried about flexibility at this point, as much as I'm worried abo=
ut
having sensible code.  E.g. if we know AVX10.2 is coming (or already here?)=
, why
not set KVM's supported min version to 2 from the get-go?

