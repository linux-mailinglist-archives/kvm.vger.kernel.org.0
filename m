Return-Path: <kvm+bounces-16184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D523C8B6053
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 19:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E98F2827CA
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE7E127B57;
	Mon, 29 Apr 2024 17:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C5uPYOGk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1175B1272B2
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 17:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714412696; cv=none; b=fJsk9lNQVmiCTqFsYIwqQvtcpHFp0yrYwWB/1zc8Pk9oC/6EUUvyYl1/ClxNCOO7ya6xf6eeavtTTe8u8Xhblf/6mvYFkvBrokZvio6ubBwcfTNXXUlkvOOfJzIRV2nHG9J7kWXJMTvxu7OFuS1/bJ57lywnkDLf59dTzNYaBQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714412696; c=relaxed/simple;
	bh=M+hPaOfpbSDmiTxqIHMuAh/MaygUIjMhfEd6gP+70+g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZAjtj1lovlgJUsawIMD4YA4uQN3U584ETejmI6Pu6kHX0aY4hKzQfAiua7hFdeuot0d0MjR2wcHQHyXgGbqXbzCzSFYCGgZfv8heGsSCCnv4048iGEQfG15TWPgZ/zzOTHWa+HIafq36JvkgBMYRg8c6QlTBCtdCNRvYu0XDUbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C5uPYOGk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2abc5b4f3c7so5485715a91.0
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 10:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714412694; x=1715017494; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lxUOdGqUOpgMyAfxcS2HMVyNcgXEt2XbMeaSH7+ZMzY=;
        b=C5uPYOGk2Nnk0Z68OFl6GzqQ/lK56UjKUGwSjnxyubr8ap70MbrISKeQrlYYs9ACjR
         Ux1DkKh3CmEz07u4G2Bl9ib54gt4ue5RUFQSe6zlBmqGAXSD7jYe0n9KXNHN+HSW7lNy
         7ea07OmM2UXUcwdXKmmRrlKq4GJO6mTQOc73P03P1rrfaER5Rm4h30HTolB7uUY+L5D0
         JPdbUbzTxZA1cC1bhT2S0wwyYJzZUWCiONT4T6iKYxMFNzh3hs1z+kO8Bqu+3MIvpeWR
         hn7n3FCoCyd5Pq0jsa83js3WoYelOwUjN3h/orlmdPpNvCg+GVEY9VWD1U5cUjCddtYp
         LSpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714412694; x=1715017494;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lxUOdGqUOpgMyAfxcS2HMVyNcgXEt2XbMeaSH7+ZMzY=;
        b=vbwDhLlKhDQytsuCc/Sa5m/KDQ1tDFMfOX6+wLkoRS1hAGu2M0nG5NQFyIT+uUmGtP
         W6HCRzir6Es8SJMVRKIubm4O7OeeGuLxCUBt5vmazAZT/18g0xLzAP1zW6fSbv/8VZOy
         cR8vU8mMCu9tLkoNSC0tWd/HIYp/dZYMCpL5jL4v7wdSQepQ3N6sur50eX34JegFlcCT
         oTTySYRXUDgOyLIPc3x5e62cxV+pcGYzdb8TGJV2YPojURewrKaf9bYt1I+FuxzU3d53
         bVXyUIemUE/mCXQPn8RerKuM4icEXwAXdYZ22b+q0fBuR1HgVsXsZd/CXjpny0ZfDtUP
         SkTA==
X-Forwarded-Encrypted: i=1; AJvYcCW8o/hPT1CJSqNP85sVwDbPweWiYPvJn2T8WpZL9dYYYgtoiBrhjtf9SEBfa7aYjxjlc7FJyim/h9zMt3MoUfNwxK4G
X-Gm-Message-State: AOJu0Yz+95CtxCypLEo/Bj15+LuV3FT+be8p3Jen7YTkzfyreiCLWIpl
	U4Z2PkrWHZtda7N+NktUfDqZK18IgR0b7qn6LCOd7hSF+bI/1G4AHOWL/EowK2O/JkkY+SLjQ2/
	pXA==
X-Google-Smtp-Source: AGHT+IF5+EWfN0BUbR1MuaU8UwhODKvZD1uv+EdSDr1sqUfHafKEE/Jal4pwloCQ+NRceuIXxDz+glkcR1U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3652:b0:2a7:82a8:2ac0 with SMTP id
 nh18-20020a17090b365200b002a782a82ac0mr33070pjb.1.1714412694436; Mon, 29 Apr
 2024 10:44:54 -0700 (PDT)
Date: Mon, 29 Apr 2024 10:44:53 -0700
In-Reply-To: <CAL715WKm0X9NJxq8SNGD5EJomzY4DDSiwLb1wMMgcgHqeZ64BA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZirPGnSDUzD-iWwc@google.com> <77913327-2115-42b5-850a-04ef0581faa7@linux.intel.com>
 <CAL715WJCHJD_wcJ+r4TyWfvmk9uNT_kPy7Pt=CHkB-Sf0D4Rqw@mail.gmail.com>
 <ff4a4229-04ac-4cbf-8aea-c84ccfa96e0b@linux.intel.com> <CAL715WJKL5__8RU0xxUf0HifNVQBDRODE54O2bwOx45w67TQTQ@mail.gmail.com>
 <5f5bcbc0-e2ef-4232-a56a-fda93c6a569e@linux.intel.com> <ZiwEoZDIg8l7-uid@google.com>
 <CAL715WJ4jHmto3ci=Fz5Bwx2Y=Hiy1MoFCpcUhz-C8aPMqYskw@mail.gmail.com>
 <b9095b0d-72f0-4e54-8d2e-f965ddff06bb@linux.intel.com> <CAL715WKm0X9NJxq8SNGD5EJomzY4DDSiwLb1wMMgcgHqeZ64BA@mail.gmail.com>
Message-ID: <Zi_cle1-5SZK2558@google.com>
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

On Sat, Apr 27, 2024, Mingwei Zhang wrote:
> On Sat, Apr 27, 2024 at 5:59=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.inte=
l.com> wrote:
> >
> >
> > On 4/27/2024 11:04 AM, Mingwei Zhang wrote:
> > > On Fri, Apr 26, 2024 at 12:46=E2=80=AFPM Sean Christopherson <seanjc@=
google.com> wrote:
> > >> On Fri, Apr 26, 2024, Kan Liang wrote:
> > >>>> Optimization 4
> > >>>> allows the host side to immediately profiling this part instead of
> > >>>> waiting for vcpu to reach to PMU context switch locations. Doing s=
o
> > >>>> will generate more accurate results.
> > >>> If so, I think the 4 is a must to have. Otherwise, it wouldn't hone=
r the
> > >>> definition of the exclude_guest. Without 4, it brings some random b=
lind
> > >>> spots, right?
> > >> +1, I view it as a hard requirement.  It's not an optimization, it's=
 about
> > >> accuracy and functional correctness.
> > > Well. Does it have to be a _hard_ requirement? no?

Assuming I understand how perf_event_open() works, which may be a fairly bi=
g
assumption, for me, yes, this is a hard requirement.

> > > The irq handler triggered by "perf record -a" could just inject a
> > > "state". Instead of immediately preempting the guest PMU context, per=
f
> > > subsystem could allow KVM defer the context switch when it reaches th=
e
> > > next PMU context switch location.

FWIW, forcefully interrupting the guest isn't a hard requirement, but pract=
ically
speaking I think that will yield the simplest, most robust implementation.

> > > This is the same as the preemption kernel logic. Do you want me to
> > > stop the work immediately? Yes (if you enable preemption), or No, let
> > > me finish my job and get to the scheduling point.

Not really.  Task scheduling is by its nature completely exclusive, i.e. it=
's
not possible to concurrently run multiple tasks on a single logical CPU.  G=
iven
a single CPU, to run task B, task A _must_ be scheduled out.

That is not the case here.  Profiling the host with exclude_guest=3D1 isn't=
 mutually
exclusive with the guest using the PMU.  There's obviously the additional o=
verhead
of switching PMU context, but the two uses themselves are not mutually excl=
usive.

And more importantly, perf_event_open() already has well-established ABI wh=
ere it
can install events across CPUs.  And when perf_event_open() returns, usersp=
ace can
rely on the event being active and counting (assuming it wasn't disabled by=
 default).

> > > Implementing this might be more difficult to debug. That's my real
> > > concern. If we do not enable preemption, the PMU context switch will
> > > only happen at the 2 pairs of locations. If we enable preemption, it
> > > could happen at any time.

Yes and no.  I agree that swapping guest/host state from IRQ context could =
lead
to hard to debug issues, but NOT doing so could also lead to hard to debug =
issues.
And even worse, those issues would likely be unique to specific kernel and/=
or
system configurations.

E.g. userspace creates an event, but sometimes it randomly doesn't count co=
rrectly.
Is the problem simply that it took a while for KVM to get to a scheduling p=
oint,
or is there a race lurking?  And what happens if the vCPU is the only runna=
ble task
on its pCPU, i.e. never gets scheduled out?

Mix in all of the possible preemption and scheduler models, and other sourc=
es of
forced rescheduling, e.g. RCU, and the number of factors to account for bec=
omes
quite terrifying.

> > IMO I don't prefer to add a switch to enable/disable the preemption. I
> > think current implementation is already complicated enough and
> > unnecessary to introduce an new parameter to confuse users. Furthermore=
,
> > the switch could introduce an uncertainty and may mislead the perf user
> > to read the perf stats incorrectly.

+1000.

> > As for debug, it won't bring any difference as long as no host event is=
 created.
> >
> That's ok. It is about opinions and brainstorming. Adding a parameter
> to disable preemption is from the cloud usage perspective. The
> conflict of opinions is which one you prioritize: guest PMU or the
> host PMU? If you stand on the guest vPMU usage perspective, do you
> want anyone on the host to shoot a profiling command and generate
> turbulence? no. If you stand on the host PMU perspective and you want
> to profile VMM/KVM, you definitely want accuracy and no delay at all.

Hard no from me.  Attempting to support two fundamentally different models =
means
twice the maintenance burden.  The *best* case scenario is that usage is ro=
ughly
a 50/50 spit.  The worst case scenario is that the majority of users favor =
one
model over the other, thus resulting in extremely limited tested of the min=
ority
model.

KVM already has this problem with scheduler preemption models, and it's pai=
nful.
The overwhelming majority of KVM users run non-preemptible kernels, and so =
our
test coverage for preemtible kernels is abysmal.

E.g. the TDP MMU effectively had a fatal flaw with preemptible kernels that=
 went
unnoticed for many kernel releases[*], until _another_ bug introduced with =
dynamic
preemption models resulted in users running code that was supposed to be sp=
ecific
to preemtible kernels.

[* https://lore.kernel.org/kvm/ef81ff36-64bb-4cfe-ae9b-e3acf47bff24@proxmox=
.com

