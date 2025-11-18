Return-Path: <kvm+bounces-63608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE99C6BE22
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:39:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9294E35B404
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEEA72D9EEA;
	Tue, 18 Nov 2025 22:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MuDsBCzq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B0B370307
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763505518; cv=none; b=hUXubUKYg1dVWfIep0D4+vr2gnXC08GaynXEBYpv/A4VWZoLPIeBSUqQIephiVmu1vicfoWDvPl8RLeui0Yeka4mbHpB66pUKZUhOHZu0DVVBWW73ARV/+QX6+BSI3CWRqRn9L/Wp09gxuZp5BNdWY+JtBLSK0orG/EhT1HiNMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763505518; c=relaxed/simple;
	bh=VRQR8Auqu70Zhj2wXzVeoI8PqaGXujH7luE4AdWi9BI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C3PDrxJbFOHxu4M3dN7XkswvkQzT5pjg3AZOfJR8Z6dkQjx1MXX0m16J+El3s2cs2acKGqT5CF1xbDiUg9KzztijQViKxdewh2b0I5YaXaV7teH02bTNELANg4qAGFpAPALWBS/DMhv/RiXtxGtU+72ruk/rfc0ZtOhOfAHX1Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MuDsBCzq; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297d50cd8c4so188552775ad.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763505516; x=1764110316; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zy+tgKZ0gPVNy1sx0MggDqMEdw6RN8AAYkr0tC916nk=;
        b=MuDsBCzqDAnThQGEdhTLpQW8vg8ENueXMm0nbEuQ3Esagnt2ffcaWBMapyOlrKuZ2X
         2miw19kIMNoVrpaEdQan2qpf9dxq++CiQ/ndnypwReyRFI9dAB7K6U3mPVisTonIgKrI
         gXM6JhoSYZM71elJLVSgtJRZkE5e4SYevkI+6vkVxJScRQPFC+LxmdJE5gk88Ht7x9x7
         Tl0KlvS6B7rBh8kc2DSEIeh7QQuEyui4ubhsBl4f/UVSlLmCmb3Q70abSuqy3cJPdrP6
         NIfsb7r7yeuSy4hZqmY5q+cD6jjQSH/YVYgOwiouq8tHUrx8HyTnOSzU+YpdoFMzkxRR
         PJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763505516; x=1764110316;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zy+tgKZ0gPVNy1sx0MggDqMEdw6RN8AAYkr0tC916nk=;
        b=dCOORBD3Xo4R0jDQCUhjNw03/AovR600a6IU36RdfQn/CMMbRkYfwDJib4/UpdF4Vq
         +JHMwA9cFfPh6fGeJHZIFHt9n1fe5VS9BM2y7yPDxLgDTXZAWK6PHl5aiSP8Ig3yJr9W
         dBGRamC/7iowkp95q3rhQfiPfB4L1ut/cCrTfezM/SakEKHvL31q9p9mg222ywX7Z5nU
         m1tpHh28k5sPZ7eOBjE7xjNLpLeouYVIDnB1GYrNT4nDx8Jt/jt0g00IuegcqnUWFXNM
         ahG4FWr98juYx/qZNSBOzZjJ1Gt6Ty5mjlgKgfGVgnfQEdF6fND28n7CayhlS2lsKLaM
         VexA==
X-Forwarded-Encrypted: i=1; AJvYcCWmvLdPFAKYgjhvjBogxYYQkckkHukLBBYDVbMmRGzo+7zM/tTMCYzNiopnHbPcL2KhziU=@vger.kernel.org
X-Gm-Message-State: AOJu0YykcXipQo0pXbeGPy+sYlCuABgDEqvgFN96VlOUT9UpXVQUASB/
	9U/XSJr6bGHsb3+LLPi97oAH8OFYcjD2UQLCsbnbdy87f7FrSU97ekBWp/4hkI9KKV4PsSwAZQU
	XNbmlQw==
X-Google-Smtp-Source: AGHT+IE+dfs7eNsuFTxQQeiSE4NnJoYpQePri1Jg6uJsYnULe6wfX04VQ950XQk+qr4yFhmuBz/Ze78KwLU=
X-Received: from plbbh3.prod.google.com ([2002:a17:902:a983:b0:295:fdf4:5ad4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1211:b0:295:565b:c691
 with SMTP id d9443c01a7336-2986a6d2365mr200022405ad.17.1763505515942; Tue, 18
 Nov 2025 14:38:35 -0800 (PST)
Date: Tue, 18 Nov 2025 14:38:34 -0800
In-Reply-To: <aRzzWrghCDzdKGKD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f156887a-a747-455f-a06e-9029ba58b8cc@amd.com> <aG2GRzQPMM3tmMZc@google.com>
 <CALMp9eQep3H-OtqmLe3O2MsOT-Vx4y0-LordKgN+pkp04VLSWw@mail.gmail.com> <aRzzWrghCDzdKGKD@google.com>
Message-ID: <aRz1aiQl3TedzVvm@google.com>
Subject: Re: KVM Unit Test Suite Regression on AMD EPYC Turin (Zen 5)
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Srikanth Aithal <sraithal@amd.com>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025, Sean Christopherson wrote:
> On Wed, Jul 23, 2025, Jim Mattson wrote:
> > On Tue, Jul 8, 2025 at 1:58=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > On Tue, Jul 08, 2025, Srikanth Aithal wrote:
> > > > Hello all,
> > > > KVM unit test suite for SVM is regressing on the AMD EPYC Turin pla=
tform
> > > > (Zen 5) for a while now, even on latest linux-next[https://git.kern=
el.org/pub/scm/linux/kernel/git/next/linux-next.git/tag/?h=3D
> > > > next-20250704]. The same seem to work fine with linux-next tag
> > > > next-20250505.
> > > > The TSC delay test fails intermittently (approximately once in thre=
e runs)
> > > > with an unexpected result (expected: 50, actual: 49). This test pas=
sed
> > > > consistently on earlier tags (e.g., next-20250505) and on non-Turin
> > > > platforms.
> > >
> > > Stating the obvious to some extent, I suspect it's something to do wi=
th Turin,
> > > not a KVM issue.  This fails on our Turin hosts as far back as v6.12,=
 i.e. long
> > > before next-20250505 (I haven't bothered checking earlier builds), an=
d AFAICT
> > > the KUT test isn't doing anything to actually stress KVM itself.  I.e=
. I would
> > > expect KVM bugs to manifest as blatant, 100% reproducible failures, n=
ot random
> > > TSC slop.
> >=20
> > I think the final test case is broken, actually.
> >=20
> > The test case is:
> >=20
> >     svm_tsc_scale_run_testcase(50, 0.0001, rdrand());
> >=20
> > So, guest_tsc_delay_value is (u64)((50 << 24) * 0.0001), which is
> > 83886. Note that this is 83886.080000000002 truncated.
> >=20
> > If L2 exits after 83886 scaled TSC cycles, the "duration" spent in L2
> > will be (u64)(83886 / 0.0001) >> 24, which is 49. To get up to 50, we
> > have to accumulate an additional (0.080000000002 / 0.0001 =3D
> > 800.0000000199999) cycles between the two rdtsc() operations
> > bracketing the svm_vmrun() in L1 .
> >=20
> > The test probably passes on other CPUs because emulated VMRUN and
> > #VMEXIT add those 800 cycles.
> >=20
> > Instead of truncating ((50 << 24) * 0.0001), I think we should
> > calculate guest_tsc_delay_value as ceil((50 << 24) * 0.0001).
> > Something like this:
> >=20
> > diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> > index 9358c1f0383a..1bfe11045bd1 100644
> > --- a/x86/svm_tests.c
> > +++ b/x86/svm_tests.c
> > @@ -891,6 +891,8 @@ static void svm_tsc_scale_run_testcase(u64 duration=
,
> >         u64 start_tsc, actual_duration;
> >=20
> >         guest_tsc_delay_value =3D (duration << TSC_SHIFT) * tsc_scale;
> > +       if (guest_tsc_delay_value < (duration << TSC_SHIFT) * tsc_scale=
)
> > +               guest_tsc_delay_value++;
> >=20
> >         test_set_guest(svm_tsc_scale_guest);
> >         vmcb->control.tsc_offset =3D tsc_offset;
> >=20
> > Even then, equality of duration and actual_duration is only guaranteed
> > if there are no significant delays during the measurement.
>=20
> Wrote a changelog and applied this to kvm-x86 next.  Thanks Jim!
>=20
> [1/1] x86/svm: Account for numerical rounding errors in TSC scaling test
>       https://github.com/kvm-x86/linux/commit/5465145a

Gah, my alias is hardcoded to point at linux, the actual commit is:

  https://github.com/kvm-x86/kvm-unit-tests/commit/5465145a

