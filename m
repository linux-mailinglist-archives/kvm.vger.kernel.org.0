Return-Path: <kvm+bounces-30063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD8AE9B694D
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 17:36:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CC5C1F22363
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 16:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1AF21500A;
	Wed, 30 Oct 2024 16:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aSAPuoDz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8FF2144C3
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 16:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730306194; cv=none; b=UNWv1It+tXS1vvYBYvwKPPnohg2P5ANEOQmB6V3ik2F1+VLFjT8SpEddlcfjpHfvlcl8VzqdNT8qicyN/9XxvaIEBvUG1jjaEE/UBf+HVx5nGHq6OphUM3SoY9rD5D48GryBF4MmPl0dGMs+jeueTHojfQsl6SZUuWxKQEojraE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730306194; c=relaxed/simple;
	bh=zCHrmiaT0aQkEzgBzKBRTHVHsnCbnwygmYP/jN0u0D8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PtlHaZrceBHfE3W9Z26x6YO8j4uhX/3OJy9VF3hISx60OJNMoZV9Hz7pWa2avUDOiJVBRqn+FPZtCfhR85o6Ks2b0uPaCM8uL0aZyQhQD5cg9ysPCcGHABGGRM6dC8cQYRZM0D8kWIqAAGyMhzDkGI6YUz+BhLVoi9cMA1KA2l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aSAPuoDz; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-460a8d1a9b7so338541cf.1
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 09:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730306191; x=1730910991; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ohhnavrPr5+YUgso4iG8u5sjXey4qTkemT4mrkrez4=;
        b=aSAPuoDz0UR0ea5xI1iz5ZFeLgpnhvrv8xfS0PMaYhFKtGzucvKFkyxM30Hv5glE+b
         qrQMC51Hn9aRaGxbfa8jF7zwMwzpgb++DucM7cN9+NZHybf1LujW06SHGmBvV8J45TUG
         REgKSB4b6guIgeHM6LO7Vd5gnvwQ8nIIiYvCYVX6BpGK/5eRyAg1n80IzluKrTDdM4KM
         tFtyyfx+Oq2dnCWv7TMT25zfkhldPSdUE23tntsTBhT75AxI2BfkKU4sLeyjWJMRWg4l
         rGJpYUL/nxGDVjQkw+M7iFlv4vaviS7zJbibSgduVRoBOPNi0I0Ot7VPCF5IGx8gRYOc
         6bwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730306191; x=1730910991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ohhnavrPr5+YUgso4iG8u5sjXey4qTkemT4mrkrez4=;
        b=UCfIrUtiz7NIIhJOWBiE6K2G3Y+CjNjUNPfbHEfC2eCZe3U1KYywh4TTqllMEO0rPM
         2YvL3kCGmuHl8jJsTuanfUDN8PEcADjl2fBzBfX/MqcbkiseGQIk3fWhyRb0cSTZx3lu
         GhQoQ42Q66UG/aHef9PX9P4+2YeQ+sbPiaLcgqvI3bS9XYSUSsLPxXHaiSCSMnbM4wS8
         KpLw38BgYRkSQYDg8ODR1iXhC+sSckL7Poxdfw4ZY7m5uqUk+X1eqgDaxXeG4YzsmR6d
         l+dSkvp8vS2F/ak+iJnEJFhVSc97hb9MGTNcpnFIh2Hsu00HcakGwy26e1lII/NNkR4u
         i5NA==
X-Forwarded-Encrypted: i=1; AJvYcCWhzz7F3fFwUoJp7yJWxESbyr5mBdxFm+O0nFewf97JY9sYdqyfmfoUTqHpvl5RpdOgBYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPWNTY9nuaudTnYJHKnIz6+aAka1hCavjx28h6VnRKU6jmfzTZ
	i01V07j3qNhpNKG2BYH73JGRoEtdXo8WElNsBwd8F4sYtPu9fAM0npKpTyIDCcIshETi3cV6BsF
	QHi8Uu5yZE93Q5gpzJ88t3OGut3t0hAjvhm+H
X-Gm-Gg: ASbGncsuF1qdGfElkYwcsCpQiQOeWDlr1FVa2mttpdpvhHwlz6cB9NXrmNXtjDist4k
	KcjUHLBFFm0m/+gPdH8DqV8ZjzdUm1G988uBGDwk7G/A+fVuzvqm+m8a1nguUxQ==
X-Google-Smtp-Source: AGHT+IFBqNAhnZpINWYimOajsOUR5Hu7mWheBmruaCmzYI1pEkwMAvJVmKH+JkRRcQ8aMk7aGSnF9I1hvN2lZQ7/bOk=
X-Received: by 2002:a05:622a:cb:b0:461:3083:dbac with SMTP id
 d75a77b69052e-46166cf428fmr8624631cf.5.1730306190820; Wed, 30 Oct 2024
 09:36:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241028234533.942542-1-rananta@google.com> <868qu63mdo.wl-maz@kernel.org>
 <CAJHc60x3sGdi2_mg_9uxecPYwZMBR11m1oEKPEH4RTYaF8eHdQ@mail.gmail.com>
 <865xpa3fwe.wl-maz@kernel.org> <CAJHc60xQNeTwSBuPhrKO_JBuikqZ7R=BM5rkWht3YwieVXwkHg@mail.gmail.com>
 <87iktat2y8.wl-maz@kernel.org>
In-Reply-To: <87iktat2y8.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 30 Oct 2024 09:36:19 -0700
Message-ID: <CAJHc60w7edpTSG2VA52m96BP6Eayg2jEc=9nt_b_kJFnOoQxfw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Get rid of userspace_irqchip_in_use
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 1:22=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Wed, 30 Oct 2024 00:16:48 +0000,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > On Tue, Oct 29, 2024 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> =
wrote:
> > >
> > > On Tue, 29 Oct 2024 17:06:09 +0000,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > > On Tue, Oct 29, 2024 at 9:27=E2=80=AFAM Marc Zyngier <maz@kernel.or=
g> wrote:
> > > > >
> > > > > On Mon, 28 Oct 2024 23:45:33 +0000,
> > > > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > > > >
> > > > > Did you have a chance to check whether this had any negative impa=
ct on
> > > > > actual workloads? Since the entry/exit code is a bit of a hot spo=
t,
> > > > > I'd like to make sure we're not penalising the common case (I onl=
y
> > > > > wrote this patch while waiting in an airport, and didn't test it =
at
> > > > > all).
> > > > >
> > > > I ran the kvm selftests, kvm-unit-tests and booted a linux guest to
> > > > test the change and noticed no failures.
> > > > Any specific test you want to try out?
> > >
> > > My question is not about failures (I didn't expect any), but
> > > specifically about *performance*, and whether checking the flag
> > > without a static key can lead to any performance drop on the hot path=
.
> > >
> > > Can you please run an exit-heavy workload (such as hackbench, for
> > > example), and report any significant delta you could measure?
> >
> > Oh, I see. I ran hackbench and micro-bench from kvm-unit-tests (which
> > also causes a lot of entry/exits), on Ampere Altra with kernel at
> > v6.12-rc1, and see no significant difference in perf.
>
> Thanks for running this stuff.
>
> > timer_10ms                          231040.0                          9=
02.0
> > timer_10ms                         234120.0                            =
914.0
>
> This seems to be the only case were we are adversely affected by this
> change.
Hmm, I'm not sure how much we want to trust this comparison. For
instance, I just ran micro-bench again a few more times and here are
the outcomes of timer_10ms for each try with the patch:

Tries                                             total ns
               avg ns
---------------------------------------------------------------------------=
--------
1_timer_10ms                             231840.0                          =
905.0
2_timer_10ms                             234560.0                          =
916.0
3_timer_10ms                             227440.0                          =
888.0
4_timer_10ms                             236640.0                          =
924.0
5_timer_10ms                             231200.0                          =
903.0

Here's a few on the baseline:

Tries                                             total ns
               avg ns
---------------------------------------------------------------------------=
--------
1_timer_10ms                             231080.0                          =
902.0
2_timer_10ms                             238040.0                          =
929.0
3_timer_10ms                             231680.0                          =
905.0
4_timer_10ms                             229280.0                          =
895.0
5_timer_10ms                             228520.0                          =
892.0


> In the grand scheme of thins, that's noise. But this gives us
> a clear line of sight for the removal of the in-kernel interrupts back
> to userspace.
Sorry, I didn't follow you completely on this part.

Thank you.
Raghavendra

