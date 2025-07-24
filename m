Return-Path: <kvm+bounces-53330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DDF2B0FF64
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 05:59:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CCE3583267
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 03:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D613A1E991B;
	Thu, 24 Jul 2025 03:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JhnpE6me"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566348F58
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 03:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753329567; cv=none; b=MrAD6ZiXzLMhiysRJR+NyZJlcOxKv91MHyken3cUJTWyCpq3XV3Cv1kiCyUhR0I4Uo48z53I9dVdc4DOtiVrnk5VKZF5T7RLG8usRtYJJ09kY4IebCyHdiYal2bjfV6GGAfnufLnrRKc8Qb35lxFDAEzIG38o3z0bp7HrWWbQJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753329567; c=relaxed/simple;
	bh=JAO+MTZWBGw0bodOXjnFjlLQMEbvpnY9t5FE7uEya1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YFaypXTMvrUbNMXMF0bPvIbfcrdXwZueUb8Y1UYv6J/8jmYgcfPuJTCT+Jzdc+xd1LCNSRCqFt6BXAKu+JXiK7BrE8XdxNWUnxImEPUoj/TvPSJuR9VFuZP8Xr2kOo7n/cAnE2fI7UOvARFKsi7UC3bUs3glPkMLVhhJFdaP+3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JhnpE6me; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-60b86fc4b47so3833a12.1
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 20:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753329564; x=1753934364; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSYGWTpdbhpm+Ovtvz9Kwx47zsYMfiWYGfwZyQftDyY=;
        b=JhnpE6mepbbsIrsBwBQo4b2amrZ+0Ik54lRTTAAgV8LkpdEQxrwdnFY/Pb82v0GL0O
         giDaep8AoEmUTjle8BL/GmJ8ozAt0OCzGXd1JrUlo+XsmZDF4pWT0wJMD4BseZjLYCzZ
         JTAqM0F9LZ6wpGbIEV6u8D9ChjpQN0ptqYz91Xg9LN+uVHyTQ0EkDsHqCnj385LyElI9
         4JTU5k8utEEhunfPGBFrt1+zLa+6fdTuPF+KaqlrHPMRPnkpyr7E16yszdGeNIlDC+Js
         Nk8D2+jnk7lrg255RtNJw6KBwyRRjXDRfBDQmaY6h+8XdP6RGLIHtW6YFAwFz72dTEdt
         +IBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753329564; x=1753934364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jSYGWTpdbhpm+Ovtvz9Kwx47zsYMfiWYGfwZyQftDyY=;
        b=lTq2N3RZ4gV9VFhJnPZBsCvQK+l3jHxB5D8iAFv7VLH88xKXtWnmb3IvStRXnj4aER
         u5uy43PGbX4LWxkZN0XmFoRlA61QfcczbGmeyICjLcd0DOFjzvP2KJGzXyxQf6UQ9myg
         guSfxjnVq5mYkd/c8Y7Tew14nZAuxN/7IWRHZYUEIGg9z6gOPM19sPcOhVdu57lRvxOr
         WMB/GX26atiXKltAv9vbcfy2TwcvEykWtabXpJShGf5EyTeomgh4Aj+39ovUiF2Gpkvh
         5ofegbIHOOhRAxeFaUq59G65dhh70VSTf6hRy1g5k7b0ydofxAQ3+RnAoCrS9MlF5xlo
         UwLg==
X-Forwarded-Encrypted: i=1; AJvYcCX7V+jWu8jFMz0N6dH8QzAXY0bvme7nbMQlhfXe+tWPt07oJReJO3eBRYMFMZ0+eh38Ra4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtXROgg2Uw5v0qRZg8YrFAjeEdVDi1hlZguYVORz48sOkYHFk9
	OnhbzLIvlgo85V6N7cgWdUaMo7ZE90UY/u0hRG++Q5v3wvroJo4f2GPMfeyoSpMEKj2BOASbaD1
	ifFEftWy0x8l+eZKIAtkaq4QvSzZ6o9vjBDDcFOR/spw34SrFkd3o1Cdtmfw=
X-Gm-Gg: ASbGncvbZoh5RXuzGKEZKP4+q3/TykfeQ/DBlNMlxtZWj06sqQZmYkQlMDvQpbxD6vX
	kHMoVD6fsJg+bEXAyMNgpKomJ2PeM06mII5W5djLV0k7u4hy1978RDtaNIsYRKfobrSYkRiERnL
	/vXw/UM9ovL8u9ZlZ2EQY9e06b2n5p0XJ/ox2fyLcksYCSMMuHa3f/X6wQdc3k+5KwklAIVJa70
	OhytcA=
X-Google-Smtp-Source: AGHT+IEXhgJrVL306lIer9BDPgdmNrh/+4bdImXsm6BnRlQhLDcDJiS91a67uKNqkS3DmtbRvcbzX+VS0LpgNKSJ7BA=
X-Received: by 2002:a05:6402:b68:b0:60e:2e88:13b4 with SMTP id
 4fb4d7f45d1cf-614cce2dc64mr31169a12.3.1753329563350; Wed, 23 Jul 2025
 20:59:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f156887a-a747-455f-a06e-9029ba58b8cc@amd.com> <aG2GRzQPMM3tmMZc@google.com>
In-Reply-To: <aG2GRzQPMM3tmMZc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 23 Jul 2025 20:59:11 -0700
X-Gm-Features: Ac12FXwYxLOv1WVFe2OcOo6XVqu8Wf4WPji9s651moa4x6HYlGjj71kF4abl-4o
Message-ID: <CALMp9eQep3H-OtqmLe3O2MsOT-Vx4y0-LordKgN+pkp04VLSWw@mail.gmail.com>
Subject: Re: KVM Unit Test Suite Regression on AMD EPYC Turin (Zen 5)
To: Sean Christopherson <seanjc@google.com>
Cc: Srikanth Aithal <sraithal@amd.com>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 8, 2025 at 1:58=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Tue, Jul 08, 2025, Srikanth Aithal wrote:
> > Hello all,
> > KVM unit test suite for SVM is regressing on the AMD EPYC Turin platfor=
m
> > (Zen 5) for a while now, even on latest linux-next[https://git.kernel.o=
rg/pub/scm/linux/kernel/git/next/linux-next.git/tag/?h=3D
> > next-20250704]. The same seem to work fine with linux-next tag
> > next-20250505.
> > The TSC delay test fails intermittently (approximately once in three ru=
ns)
> > with an unexpected result (expected: 50, actual: 49). This test passed
> > consistently on earlier tags (e.g., next-20250505) and on non-Turin
> > platforms.
>
> Stating the obvious to some extent, I suspect it's something to do with T=
urin,
> not a KVM issue.  This fails on our Turin hosts as far back as v6.12, i.e=
. long
> before next-20250505 (I haven't bothered checking earlier builds), and AF=
AICT
> the KUT test isn't doing anything to actually stress KVM itself.  I.e. I =
would
> expect KVM bugs to manifest as blatant, 100% reproducible failures, not r=
andom
> TSC slop.

I think the final test case is broken, actually.

The test case is:

    svm_tsc_scale_run_testcase(50, 0.0001, rdrand());

So, guest_tsc_delay_value is (u64)((50 << 24) * 0.0001), which is
83886. Note that this is 83886.080000000002 truncated.

If L2 exits after 83886 scaled TSC cycles, the "duration" spent in L2
will be (u64)(83886 / 0.0001) >> 24, which is 49. To get up to 50, we
have to accumulate an additional (0.080000000002 / 0.0001 =3D
800.0000000199999) cycles between the two rdtsc() operations
bracketing the svm_vmrun() in L1 .

The test probably passes on other CPUs because emulated VMRUN and
#VMEXIT add those 800 cycles.

Instead of truncating ((50 << 24) * 0.0001), I think we should
calculate guest_tsc_delay_value as ceil((50 << 24) * 0.0001).
Something like this:

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 9358c1f0383a..1bfe11045bd1 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -891,6 +891,8 @@ static void svm_tsc_scale_run_testcase(u64 duration,
        u64 start_tsc, actual_duration;

        guest_tsc_delay_value =3D (duration << TSC_SHIFT) * tsc_scale;
+       if (guest_tsc_delay_value < (duration << TSC_SHIFT) * tsc_scale)
+               guest_tsc_delay_value++;

        test_set_guest(svm_tsc_scale_guest);
        vmcb->control.tsc_offset =3D tsc_offset;

Even then, equality of duration and actual_duration is only guaranteed
if there are no significant delays during the measurement.

