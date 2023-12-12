Return-Path: <kvm+bounces-4123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2295480E158
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 03:21:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D3A71C21716
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 02:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B36D1FC5;
	Tue, 12 Dec 2023 02:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AVSHXp03"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7063B5
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 18:21:42 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1d339f898a0so57445ad.3
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 18:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702347702; x=1702952502; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4OSQ0+CxvAwQ+j1iPdWpWeAVyvf5e+mUT1407P9+KdQ=;
        b=AVSHXp03CmxZrm7ViQTpSMQSLT6Ud9ICfpv//3DmLJylwMeveTo94K+wgumbzu2Qoa
         IPIHEENVkt8ilRFbwGpWmlF81TaB8CGTQurkJvzZ6SA/7F96nBilTCNBktE6hZhaxsKS
         23IAK/LW60kD1bYrkgXvWaQEcW1tb0a33NJdMlRTbWWMyTOcO8P0VC7tGgaG+4DcsXXh
         bV66Fm9d4ZGL/BLYqaTGQCYFfIpi1rchCGf2pI9RDtPha0x2N/6GyzaxmJbbbZ8PBoPr
         Xzm2v00bLJrd7JAtvDpO3WnHzBa1jPrByWpYZtXVGzw0yE8dHPcRbS7CnH6utEF4l0xT
         vT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702347702; x=1702952502;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4OSQ0+CxvAwQ+j1iPdWpWeAVyvf5e+mUT1407P9+KdQ=;
        b=aKEC0VjgFCQDToOwYAH7+fBizfljgTeJ01lM5+JW7ft3mX72YAMvabHks/NrxbDRh7
         Ei+7GYlfCCOsLs4/Q7BlV0SnBdQPRy5F6S4wMQs7RC9QFlhL4VAOdpxibqTKrrZaU6ij
         9k546bmS/1URPpW8c7R1hVGC79OWN+AlG9ctVqYWT8cONkLXLJGbKa0iLSuoTmKn8+qc
         Sr62DJ9L/1aacbMQ5Rxd9a6e4SqlzA2KYf/8MZPWKLZ8ew45wXgPHr2WEQq9sFiZOWjz
         bMPX7pPq4JU2EHfUjlsAzsTK380WG+9AhgpjR3aHAkZ8v18CEMtU/dLclI3vUyK7+k6J
         618w==
X-Gm-Message-State: AOJu0YzZkL5IKmH4WTx/lc9Hi9LOndJJ43Xx86uDgGH8VpqFEd6XfoQS
	KFsI0cMeTVUwoe7EQybY6Wy/sM5LmbQ=
X-Google-Smtp-Source: AGHT+IHdOsYGsoWCm8uyCA8qxisPuNhOF2q/ZEZkAdNvR3f0Oj9wJqNGOwsljcCj5NH140QB+/01lkr2al8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f54a:b0:1d0:5d31:4672 with SMTP id
 h10-20020a170902f54a00b001d05d314672mr44837plf.5.1702347702132; Mon, 11 Dec
 2023 18:21:42 -0800 (PST)
Date: Mon, 11 Dec 2023 18:21:40 -0800
In-Reply-To: <b028a431-92e0-4440-adf9-6b855edb88c0@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231030141728.1406118-1-nik.borisov@suse.com>
 <ZT_UtjWSKCwgBxb_@google.com> <b028a431-92e0-4440-adf9-6b855edb88c0@suse.com>
Message-ID: <ZXfDtIful3mjgPTA@google.com>
Subject: Re: [PATCH] KVM: x86: User mutex guards to eliminate __kvm_x86_vendor_init()
From: Sean Christopherson <seanjc@google.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 09, 2023, Nikolay Borisov wrote:
>=20
>=20
> On 30.10.23 =D0=B3. 18:07 =D1=87., Sean Christopherson wrote:
> > On Mon, Oct 30, 2023, Nikolay Borisov wrote:
> > > Current separation between (__){0,1}kvm_x86_vendor_init() is
> > > superfluos as
> >=20
> > superfluous
> >=20
> > But this intro is actively misleading.=C2=A0 The double-underscore vari=
ant
> > most definitely
> > isn't superfluous, e.g. it eliminates the need for gotos reduces the
> > probability
> > of incorrect error codes, bugs in the error handling, etc.=C2=A0 It _be=
comes_
> > superflous
> > after switching to guard(mutex).
> >=20
> > IMO, this is one of the instances where the then solution problem
> > appoach is
> > counter-productive.=C2=A0 If there are no objections, I'll massage the =
change
> > log to
> > the below when applying (for 6.8, in a few weeks).
> >=20
> >  =C2=A0Use the recently introduced guard(mutex) infrastructure acquire =
and
> >  =C2=A0automatically release vendor_module_lock when the guard goes out=
 of
> > scope.
> >  =C2=A0Drop the inner __kvm_x86_vendor_init(), its sole purpose was to =
simplify
> >  =C2=A0releasing vendor_module_lock in error paths.
> >=20
> >  =C2=A0No functional change intended.
> >=20
> > > the the underscore version doesn't have any other callers.
> > >=20
>=20
>=20
> Has this fallen through the cracks as I don't see it in 6.7?

As above, I have this tagged for inclusion in 6.8, not 6.7.  Though admitte=
dly,
this one did actually fall through the cracks as I moved it to the wrong ma=
ilbox
when Paolo usurped the thread for unrelated guest_memfd stuff.  Anyways, I =
do
plan on grabbing this for 6.8, I'm just buried in non-upstream stuff right =
now.

