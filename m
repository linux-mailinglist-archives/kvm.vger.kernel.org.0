Return-Path: <kvm+bounces-36280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF37A19702
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 17:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 995B03A639C
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA4D215178;
	Wed, 22 Jan 2025 16:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uei4xiTm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BABA2144C9
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 16:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737564968; cv=none; b=HN/V+7C2PrCzGzlOP0dgXj8G5/05GNra3Kt/8MrWMbyk0Sz5uI5EMkt0znT/SlsRQdubz/cD1mLwa2yBqyEPLajoTPkU90oOIY0E2PUjmIl+KTZoFMVY7MoEvJGiclfpH9zJ5haARsA8yjFJnTYkMn1qQ0nqKnaP4hpKNeZHsxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737564968; c=relaxed/simple;
	bh=QmkwEShntUj5J96NRhuPFqL63fgaI1e9QejrasBkOwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sgBCqArBDmvyujpsrAOocQzHUY7NPxts+PMAflPHeJz8eJPIs/M0rllr4361KG7QXUHrjkqo1c/NTaVvzCuBAWhUYjdGTwx7YNDJa0kGyCAdLssj+H5OewQSO/oV/ksrXp5dzzFPrC2RwMmOaUOSpObj1iA/G1qw6rDAv9Uvi1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uei4xiTm; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a814c54742so214335ab.1
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 08:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737564966; x=1738169766; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=icCRR271vrBC9N7udpBpj/cJleRwlRI4RicptcMovPo=;
        b=uei4xiTmnG3daZP1lguvvLZxMstyqjup/YFF9csRBNG8NyZIsvJela6eM7cCOjpoMA
         jjI51W5uijxAbFeplvREhhYnLX4KotgvWIl/vc+mTiA0yWSIjFlUYJ4Sr3lkv/FapSKX
         SxBfGa4N0z/crxKU5gQ9H2NtxcET76brpOkFb+aP4p7dGs0jDxeV7i+KYzNv8NtffJxz
         1+wd7HfWd5B5q8SbJXic1HPa6TaBbAtLYh97oNh/t/30XdnWMCIdNorOpgkGnsZmJTcI
         YEfKz1y1pcyroy4nqnQ1jk/T+zeXyIFuiGgHVRmBFvFNyuHQWQqXk6LtaoxM+1qyC9us
         VJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737564966; x=1738169766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=icCRR271vrBC9N7udpBpj/cJleRwlRI4RicptcMovPo=;
        b=YttcfzK3rRRmPRHsyHOqy+9NcOp/prCUT6mTQSU8tPAVezMoqq3Qz8A3at/+UurDW+
         DjejOvuTa0Ztqb3d7e+n0WmezedeI5yqYuKYHffUUpxUJbwRgjwkuPQBFkAVh5FEYfp4
         q8WdjFXAXrmcOrXsL71Q0CRp5XAg4QvXZ49tRdq7LJDN+nsvFwJTjlyYz9jm1RQuJfQG
         rAvsC6NgJtGMq0eYq4FbDKwEuqBV5IegUNd9iOQXUeA6uVDg1CkHw6xRhCyUfsMmSRqH
         14KJjbJPAlo73UbmQj9uinJkBvHIQQovGTnfzDTlcJ6Q1raPXvhuEvYlIn9+k0b4KUbf
         wMTA==
X-Forwarded-Encrypted: i=1; AJvYcCVNIRSgaUNjXAX+8YKB46zQN62ncIiqjUpOnpZtEWwPi7MD6BhnAfK1Ui5EJOxBnATsoPI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvUmrsbRxvVNRvwzcGG5sdvlmAda343wgimx8A69lRYD5DYe+h
	wVRQlp8eWGdEpBNgJdKI6omB7aes0wQu9KNINOL6InkVlcgLybpOABo8+aUJOsdw6OJYUdIXBQm
	dXUXSMeDRlTC3yXjqw6tSm5t3hvk2eQyvno89
X-Gm-Gg: ASbGncsKJCEAG+gNSJ0FgssxyTnW1dBltqZ0E1Ur3qlTd2S9BsYjh+xRDXNuFCqrTWh
	xVBvzHpcKg0wXKCAbOBXYRu6GoIws14z6DPCqBsTv8kVVV32XYNE=
X-Google-Smtp-Source: AGHT+IGaOgPKfS/YVT3k8WPmHvvVYO8f5U6OjtZR32bbHafIFmrlz/i3oTdf17NZ/fGZXNH9WzCtDOyYFEiWLVqB+eQ=
X-Received: by 2002:a05:6e02:a:b0:3a0:a459:8eca with SMTP id
 e9e14a558f8ab-3cfb2d3d71emr4319265ab.10.1737564966224; Wed, 22 Jan 2025
 08:56:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANDhNCq5_F3HfFYABqFGCA1bPd_+xgNj-iDQhH4tDk+wi8iZZg@mail.gmail.com>
 <CABgObfbWqcorZC+1Hjh7SQtn69LE-Wng-wBKOq=tqh00_3R6dw@mail.gmail.com>
In-Reply-To: <CABgObfbWqcorZC+1Hjh7SQtn69LE-Wng-wBKOq=tqh00_3R6dw@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 22 Jan 2025 08:55:55 -0800
X-Gm-Features: AWEUYZkhfa5ajFltg3yMj9kC7opv7xJSxzpYUYEe-HKWQ1cDH_zwz_T_rH-Rh0Q
Message-ID: <CALMp9eTcsDcnm2cqWW-tjLJEXb5PeoLUr-Pk=0oOH=_3oowREg@mail.gmail.com>
Subject: Re: BUG: Occasional unexpected DR6 value seen with nested
 virtualization on x86
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: John Stultz <jstultz@google.com>, Sean Christopherson <seanjc@google.com>, kvm <kvm@vger.kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Frederic Weisbecker <fweisbec@gmail.com>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, 
	"Team, Android" <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 1:01=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> Il mer 22 gen 2025, 07:07 John Stultz <jstultz@google.com> ha scritto:
> >
> > I then cut down and ported the bionic test out so it could build under
> > a standard debian environment:
> > https://github.com/johnstultz-work/bionic-ptrace-reproducer
> >
> > Where I was able to reproduce the same problem in a debian VM (after
> > running the test in a loop for a short while).
>
>
> Thanks, that's nice to have.
>
> > Now, here's where it is odd. I could *not* reproduce the problem on
> > bare metal hardware, *nor* could I reproduce the problem in a virtual
> > environment.  I can *only* reproduce the problem with nested
> > virtualization (running the VM inside a VM).
>
> Typically in that case the best thing to do is turn it into a
> kvm-unit-test or selftest (though that's often an endeavor of its own,
> as it requires distilling the Linux kernel and userspace code into a
> guest that runs without an OS). But what you've done is already a good
> step.

Just run the kvm-unit-tests 'x86/debug' test in a loop inside an L1
VM. It will eventually fail. Maybe not the same bug, but we can hope.
:)

> > I have reproduced this on my intel i12 NUC using the same v6.12 kernel
> > on metal + virt + nested environments.  It also reproduced on the NUC
> > with v5.15 (metal) + v6.1 (virt) + v6.1(nested).
>
> Good that you can use a new kernel. Older kernels are less reliable
> with nested virt (especially since the one that matters the most is
> the metal one).
>
> Paolo
>
> > I've tried to do some tracing in the arch/x86/kvm/x86.c logic, but
> > I've not yet directly correlated anything on the hosts to the point
> > where we read the zero DR6 value in the nested guest.
> >
> > But I'm not very savvy around virtualization or ptrace watchpoints or
> > low level details around intel DB6 register, so I wanted to bring this
> > up on the list to see if folks had suggestions or ideas to further
> > narrow this down?  Happy to test things as it's pretty simple to
> > reproduce here.
> >
> > Many thanks to Alex Bennee and Jim Mattson for their testing
> > suggestions to help narrow this down so far.
> >
> > thanks
> > -john
> >
>

