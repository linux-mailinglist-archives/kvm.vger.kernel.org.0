Return-Path: <kvm+bounces-16374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CB0258B90AA
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 22:36:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 613911F22AA8
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 20:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2942D1649D1;
	Wed,  1 May 2024 20:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FohSaX+p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E113C537FB
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 20:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714595796; cv=none; b=kPNJRuwJNOATHLEIOn50HF4izMknWxZHyH1tUuleEZVjQ/SbBclv5WrbUpqdDKjyEq2UZlIU5L0UrlE8bVIhMrBHKqYOOYUC7w+aY04NIJbJPsdP3mRRozYGHwz5WBELAgM++dU+OxbKSaJ2t7ir4EuhT8p6MMRllB6vILiwi1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714595796; c=relaxed/simple;
	bh=CZ+1HcLUExAb6ySEYUXpONpcatEAnu4JCOSJlhyZEdM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HIXU4TUA/DuD5509oZG9r5LlDIPQTzJgBYOY8nbzFMCe0co9b6AwulqU6y0OgrePUOplqKnYe54fs/KUoPm8h4YiNFiXScypcahrSRfRZzeIbhfjaz58cHT2vdqkvPWmycGgy9G1+twXFDm4AxasR7021ur5CzJjOMNm47T3cpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FohSaX+p; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61e0949fc17so9959357b3.0
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 13:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714595794; x=1715200594; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HoqEk2d89pzrIsVW2yhRLPcbk87IRHxiIo5sAWdVlus=;
        b=FohSaX+p/gHXG6zLC8UucV9GzTAS0UZhiUvlDqpzByYy1Zvgcwssn+9grHZKlR77Qa
         6LSskw99w2flR3zqLaSJMDm7fuY345NcOHueq/kerme/INHe5zi2c3A5X5LuRouiU78i
         qen/axYlgVB6hAeoatHlbdUUQIFnJu/8bCyN+Nyu8Po+nBBlhiNR9S+qngexNabD7DGQ
         LondwNsjvJOJIHxKYFxF3FJrsl7CGYeK8i8APiXJpo5Mh8XFI5mh9Mn2v7liL0oZztz4
         5l0dyXNOJ1+UNMUpD4c9mM3uWs+A9dqm6AYlBE7F0j1xkRWwC3dtD/vH1MFl06a1BIV0
         ssEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714595794; x=1715200594;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HoqEk2d89pzrIsVW2yhRLPcbk87IRHxiIo5sAWdVlus=;
        b=iZ81+/QR/UPqB0ZQWFF774qvar0LsadO3cV0TAi4MaumthMwnytTVCBqFMIvyhpZs6
         WY6i7CbIDvidYmyeNd4mRfTM/EiOjjG0/lVKZqosKy1RRJi2KW3muVessPiMeC1uBNQC
         fbAPztFIuH3U5seGc/bTBnrXubqZ38UMJ5xpj5JtHXmdsnvj6/Ny/PxK9GCOdFciNTcC
         VZSstyh57L8f9ZGv6xtBeEdakL3SjQEJ+iKfkHfhHP3a9e3sqJOvCfborz072OfFP4fW
         GPm25D5xVRdspVIUPaB1XOWNTWER3xJOmpNOe2sfg+3XkDL+pMVWYWowHBk6h4pZetpj
         58tg==
X-Forwarded-Encrypted: i=1; AJvYcCXO/yODt6mrSM/buJbqC9yQPZnCMivWWqIVdHrlNO1PKH1h+MIpd4zYsAeAVOnQTulTneoBL1eNXC528XauTOaASveR
X-Gm-Message-State: AOJu0YzXN9uf4wIs5V26Pt/8KDTaNPn0hIHcmE1OLbaGGG1JRWqIwITm
	CV/NeUXeczJkDgbY1e1kE1lVaIRSxUWh+Ao+gvl+vTCrzQbM0GXp64cjXlZiKcMTazZxG4JthEu
	duQ==
X-Google-Smtp-Source: AGHT+IGBl505/z0XBb88u3lR/7JlRlWZqwWbuFXHJgVFCCMMlH1u96V0iZ5bQhdv/H411OBPpCC2caAJc9I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4fc5:0:b0:61b:982:4da0 with SMTP id
 d188-20020a814fc5000000b0061b09824da0mr825560ywb.0.1714595793888; Wed, 01 May
 2024 13:36:33 -0700 (PDT)
Date: Wed, 1 May 2024 13:36:32 -0700
In-Reply-To: <CAL715WJbYNqm2SXiTgqWHs34DtRfdFE7Hx48X_4ASHyQXeaPzA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAL715WJCHJD_wcJ+r4TyWfvmk9uNT_kPy7Pt=CHkB-Sf0D4Rqw@mail.gmail.com>
 <ff4a4229-04ac-4cbf-8aea-c84ccfa96e0b@linux.intel.com> <CAL715WJKL5__8RU0xxUf0HifNVQBDRODE54O2bwOx45w67TQTQ@mail.gmail.com>
 <5f5bcbc0-e2ef-4232-a56a-fda93c6a569e@linux.intel.com> <ZiwEoZDIg8l7-uid@google.com>
 <CAL715WJ4jHmto3ci=Fz5Bwx2Y=Hiy1MoFCpcUhz-C8aPMqYskw@mail.gmail.com>
 <b9095b0d-72f0-4e54-8d2e-f965ddff06bb@linux.intel.com> <CAL715WKm0X9NJxq8SNGD5EJomzY4DDSiwLb1wMMgcgHqeZ64BA@mail.gmail.com>
 <Zi_cle1-5SZK2558@google.com> <CAL715WJbYNqm2SXiTgqWHs34DtRfdFE7Hx48X_4ASHyQXeaPzA@mail.gmail.com>
Message-ID: <ZjKn0HKKJrWTT4E8@google.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@linux.intel.com>, 
	maobibo <maobibo@loongson.cn>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 01, 2024, Mingwei Zhang wrote:
> On Mon, Apr 29, 2024 at 10:44=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Sat, Apr 27, 2024, Mingwei Zhang wrote:
> > > That's ok. It is about opinions and brainstorming. Adding a parameter
> > > to disable preemption is from the cloud usage perspective. The
> > > conflict of opinions is which one you prioritize: guest PMU or the
> > > host PMU? If you stand on the guest vPMU usage perspective, do you
> > > want anyone on the host to shoot a profiling command and generate
> > > turbulence? no. If you stand on the host PMU perspective and you want
> > > to profile VMM/KVM, you definitely want accuracy and no delay at all.
> >
> > Hard no from me.  Attempting to support two fundamentally different mod=
els means
> > twice the maintenance burden.  The *best* case scenario is that usage i=
s roughly
> > a 50/50 spit.  The worst case scenario is that the majority of users fa=
vor one
> > model over the other, thus resulting in extremely limited tested of the=
 minority
> > model.
> >
> > KVM already has this problem with scheduler preemption models, and it's=
 painful.
> > The overwhelming majority of KVM users run non-preemptible kernels, and=
 so our
> > test coverage for preemtible kernels is abysmal.
> >
> > E.g. the TDP MMU effectively had a fatal flaw with preemptible kernels =
that went
> > unnoticed for many kernel releases[*], until _another_ bug introduced w=
ith dynamic
> > preemption models resulted in users running code that was supposed to b=
e specific
> > to preemtible kernels.
> >
> > [* https://lore.kernel.org/kvm/ef81ff36-64bb-4cfe-ae9b-e3acf47bff24@pro=
xmox.com
> >
>=20
> I hear your voice, Sean.
>=20
> In our cloud, we have a host-level profiling going on for all cores
> periodically. It will be profiling X seconds every Y minute. Having
> the host-level profiling using exclude_guest is fine, but stopping the
> host-level profiling is a no no. Tweaking the X and Y is theoretically
> possible, but highly likely out of the scope of virtualization. Now,
> some of the VMs might be actively using vPMU at the same time. How can
> we properly ensure the guest vPMU has consistent performance? Instead
> of letting the VM suffer from the high overhead of PMU for X seconds
> of every Y minute?
>=20
> Any thought/help is appreciated. I see the logic of having preemption
> there for correctness of the profiling on the host level. Doing this,
> however, negatively impacts the above business usage.
>=20
> One of the things on top of the mind is that: there seems to be no way
> for the perf subsystem to express this: "no, your host-level profiling
> is not interested in profiling the KVM_RUN loop when our guest vPMU is
> actively running".

For good reason, IMO.  The KVM_RUN loop can reach _far_ outside of KVM, esp=
ecially
when IRQs and NMIs are involved.  I don't think anyone can reasonably say t=
hat
profiling is never interested in what happens while a task in KVM_RUN.  E.g=
. if
there's a bottleneck in some memory allocation flow that happens to be trig=
gered
in the greater KVM_RUN loop, that's something we'd want to show up in our p=
rofiling
data.

And if our systems our properly configured, for VMs with a mediated/passthr=
ough
PMU, 99.99999% of their associated pCPU's time should be spent in KVM_RUN. =
 If
that's our reality, what's the point of profiling if KVM_RUN is out of scop=
e?

We could make the context switching logic more sophisticated, e.g. trigger =
a
context switch when control leaves KVM, a la the ASI concepts, but that's a=
ll but
guaranteed to be overkill, and would have a very high maintenance cost.

But we can likely get what we want (low observed overhead from the guest) w=
hile
still context switching PMU state in vcpu_enter_guest().  KVM already handl=
es the
hottest VM-Exit reasons in its fastpath, i.e without triggering a PMU conte=
xt
switch.  For a variety of reason, I think we should be more aggressive and =
handle
more VM-Exits in the fastpath, e.g. I can't think of any reason KVM can't h=
andle
fast page faults in the fastpath.

If we handle that overwhelming majority of VM-Exits in the fastpath when th=
e guest
is already booted, e.g. when vCPUs aren't taking a high number of "slow" VM=
-Exits,
then the fact that slow VM-Exits trigger a PMU context switch should be a n=
on-issue,
because taking a slow exit would be a rare operation.

I.e. rather than solving the overhead problem by moving around the context =
switch
logic, solve the problem by moving KVM code inside the "guest PMU" section.=
  It's
essentially a different way of doing the same thing, with the critical diff=
erence
being that only hand-selected flows are excluded from profiling, i.e. only =
the
flows that need to be blazing fast and should be uninteresting from a profi=
ling
perspective are excluded.

