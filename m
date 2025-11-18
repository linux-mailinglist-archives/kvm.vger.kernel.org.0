Return-Path: <kvm+bounces-63606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FAC9C6BDE5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3B7CE368433
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078E5309F1B;
	Tue, 18 Nov 2025 22:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="plB1W6l+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC993702F8
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504991; cv=none; b=C0TngPK8+uprDHowJuAMmJ/ruZGoGW/tgf/OwB08XVjdmK7QQ2HA5X+L0XqLjGJumtIRDGN7O/FIDo6n8UlEedhIvVbbLBvxkZYWwsXuafJ7ofdvjftjL6CRsG6FZ1kenrZJr+8eweIVNWS4BVBA+Vy15QlPxcbkdOL+/ysdmKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504991; c=relaxed/simple;
	bh=L5NQD2nPKZ6LQfoSJLfrfvmHC+Bf4NqaUyhiPjDujC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tGJeb71RJkofBMoFjGx4yR5XU9JB0BIzPg4kl2/8brodyEI/Il8lxMWykuIiEEs8il6/2QvmssH3nkleQH3e2ZrX6HtoV1QoR+8WxoewkTuhq93qgEJy39vD2ATO+iDMnYRbAZhgGJhaMwcxEEI0buC1m4eXlyussMexDtaCowI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=plB1W6l+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343daf0f488so7304924a91.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763504988; x=1764109788; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UR/UiRBGaXeOcEGTaK7f4Tp0RFu7bFA33F9OkLJf3mo=;
        b=plB1W6l+PauDIytvh2Anx0MsavQ7fMK4G+vtBjuamp8gnAlmqS+2Q7dGb1LM5W64mi
         awQ7sNIkJzQ5eiJg65tibDqIhYzKq1I8WE9ZnLo9iFBm3qVMfcLlLFcdg28p5dT8LfOS
         EkDmY8A8LQJ7/FIShoiYxu3brzdhCXEmZzvOsBDsRpQyoDvhCitgpGlFjJUIFuitIPm7
         wQUHdQRAHMJXv1y7oNPersRYxKzDfGUpp94Zim8PBxnAWnbGLLhaM59u0aL+xtzAZU3t
         y0E1/5mF0nVnYuVWgqZcJsjkOzm95MroV9d5bKqgdTNnfhk46po8IJlR+NNBz+oMxjyg
         mYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763504988; x=1764109788;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UR/UiRBGaXeOcEGTaK7f4Tp0RFu7bFA33F9OkLJf3mo=;
        b=QRWuDiPwvw2OMAt1ACVJ/fRatVtge7aBTQWemJeoqgVpRNvc6vjizf4rNqyU9gIChN
         3m9VmGM9gtWxYtekVKYs2QNLPqlhBgpkRbhpLirTYMW3jzJT+P999faWphng7TOeNCF4
         +9g0Utd2FSLBtaZAsFVW+4UHiWbrkrcy7HyFQZ5hM/9ODWrMsEPCvfq5h6SzlLRmy4LM
         qHhCOWlhXEVDVSBy8c8sYlmfLp0x0xdlCQpNWTagIKthmPG+EhWdDTDjEq2bVwt371Dn
         bnDx19c5xu5MhhelW5yi1hiDxqATl/oPIpONkPJAqDuOqSmeIYiGDn4y9Mt9Cqs3jNKJ
         PTXg==
X-Forwarded-Encrypted: i=1; AJvYcCXEDIbm3VMXfzSlHqHwsCwY1rLo7Gtfax1CnXU52N7fjrpAAYrciA2RZXVvkCLG7icL3q0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaSJQopilJxHVggmWcDgmuubG/976z9PwnFRhK1pvv6nUraWEj
	irOFuGedh79JT4NgOczfL3d4vTCGXwNnowDDZi/JSkbNgfL3s8G4ogdvNRRhvcjiJ26Vy4o5KuU
	SeGoEqg==
X-Google-Smtp-Source: AGHT+IHn/8d0et5POMDaR9LBwlh/WjSxa7F5aGP4HsqMVLOgiA1YOIcsSxqDCiWkCpLqUh9Jy9U8sF/mO98=
X-Received: from pjboe3.prod.google.com ([2002:a17:90b:3943:b0:340:d583:8695])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f4f:b0:33b:bed8:891c
 with SMTP id 98e67ed59e1d1-343fa527eb0mr20659650a91.23.1763504988037; Tue, 18
 Nov 2025 14:29:48 -0800 (PST)
Date: Tue, 18 Nov 2025 14:29:46 -0800
In-Reply-To: <CALMp9eQep3H-OtqmLe3O2MsOT-Vx4y0-LordKgN+pkp04VLSWw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f156887a-a747-455f-a06e-9029ba58b8cc@amd.com> <aG2GRzQPMM3tmMZc@google.com>
 <CALMp9eQep3H-OtqmLe3O2MsOT-Vx4y0-LordKgN+pkp04VLSWw@mail.gmail.com>
Message-ID: <aRzzWrghCDzdKGKD@google.com>
Subject: Re: KVM Unit Test Suite Regression on AMD EPYC Turin (Zen 5)
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Srikanth Aithal <sraithal@amd.com>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2025, Jim Mattson wrote:
> On Tue, Jul 8, 2025 at 1:58=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Tue, Jul 08, 2025, Srikanth Aithal wrote:
> > > Hello all,
> > > KVM unit test suite for SVM is regressing on the AMD EPYC Turin platf=
orm
> > > (Zen 5) for a while now, even on latest linux-next[https://git.kernel=
.org/pub/scm/linux/kernel/git/next/linux-next.git/tag/?h=3D
> > > next-20250704]. The same seem to work fine with linux-next tag
> > > next-20250505.
> > > The TSC delay test fails intermittently (approximately once in three =
runs)
> > > with an unexpected result (expected: 50, actual: 49). This test passe=
d
> > > consistently on earlier tags (e.g., next-20250505) and on non-Turin
> > > platforms.
> >
> > Stating the obvious to some extent, I suspect it's something to do with=
 Turin,
> > not a KVM issue.  This fails on our Turin hosts as far back as v6.12, i=
.e. long
> > before next-20250505 (I haven't bothered checking earlier builds), and =
AFAICT
> > the KUT test isn't doing anything to actually stress KVM itself.  I.e. =
I would
> > expect KVM bugs to manifest as blatant, 100% reproducible failures, not=
 random
> > TSC slop.
>=20
> I think the final test case is broken, actually.
>=20
> The test case is:
>=20
>     svm_tsc_scale_run_testcase(50, 0.0001, rdrand());
>=20
> So, guest_tsc_delay_value is (u64)((50 << 24) * 0.0001), which is
> 83886. Note that this is 83886.080000000002 truncated.
>=20
> If L2 exits after 83886 scaled TSC cycles, the "duration" spent in L2
> will be (u64)(83886 / 0.0001) >> 24, which is 49. To get up to 50, we
> have to accumulate an additional (0.080000000002 / 0.0001 =3D
> 800.0000000199999) cycles between the two rdtsc() operations
> bracketing the svm_vmrun() in L1 .
>=20
> The test probably passes on other CPUs because emulated VMRUN and
> #VMEXIT add those 800 cycles.
>=20
> Instead of truncating ((50 << 24) * 0.0001), I think we should
> calculate guest_tsc_delay_value as ceil((50 << 24) * 0.0001).
> Something like this:
>=20
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 9358c1f0383a..1bfe11045bd1 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -891,6 +891,8 @@ static void svm_tsc_scale_run_testcase(u64 duration,
>         u64 start_tsc, actual_duration;
>=20
>         guest_tsc_delay_value =3D (duration << TSC_SHIFT) * tsc_scale;
> +       if (guest_tsc_delay_value < (duration << TSC_SHIFT) * tsc_scale)
> +               guest_tsc_delay_value++;
>=20
>         test_set_guest(svm_tsc_scale_guest);
>         vmcb->control.tsc_offset =3D tsc_offset;
>=20
> Even then, equality of duration and actual_duration is only guaranteed
> if there are no significant delays during the measurement.

Wrote a changelog and applied this to kvm-x86 next.  Thanks Jim!

[1/1] x86/svm: Account for numerical rounding errors in TSC scaling test
      https://github.com/kvm-x86/linux/commit/5465145a

