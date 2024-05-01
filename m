Return-Path: <kvm+bounces-16363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E714E8B8F2D
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 19:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 174331C213F6
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 17:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B470113C669;
	Wed,  1 May 2024 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KJ/tdbuA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC621386A0
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714585479; cv=none; b=s4g6DEB9NGS06aJ4YXZ0ZTmXT/3B7Q0NzjMySzJ33adsiKxj7Pg8rNVLzKoBS2eFEO1h56Z5+I8GYFe/Khb9946bjz9Y8FPOx1c3oR3j/m5QIW/7ycIHJ5LX06LIuqgFDdEattNtjG9UdBo5OJEI9+ZFD/bEePOzC2Pm5leShB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714585479; c=relaxed/simple;
	bh=v3enCvAplcrQ4cwOxDbhFJqukTTawzuTb94s+VDDEG8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jEOkIGN3ol1JW6dwRuNL82ZomRRaakxzszgm9xVwFbvR4MZEGGUiTnmnZ08vpSUHISgGAy8VB5L0BgDySLYRwp3nRAe0AwKOINLCcj+eLL2ckfXyPM+aNlpLJvNCp/KjrEYIqOLD8AluUfNs/nd/+ngNBB9mp7jssdIkNbp7vQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KJ/tdbuA; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a559b919303so900037966b.1
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 10:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714585476; x=1715190276; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k4IV5MUpcWstax6ntK82tb+sL5JFIt+jl6TpQDKHYAY=;
        b=KJ/tdbuADaCz4crloVoTX94jcQM+1tZ4wO6NmrGraFZFOu7DIv2s9+lH/FLJjrNVxv
         2zytiW86b1K6wLFQn1nwViioeWcI4PTDCJkcjZX1eq+9ET6snFHYHcyKsA8fONhcgfPE
         LMQysJ3FD8Ukm48RTh9acYTfz8BnTOObS5EnRN4HlZH9++D5uTeM4jye467cCmGBgm8N
         h0GJMKrOsXsaZ3K+jS1k6j0iC/wgfXuKf/AE+cZ9IPIkYMJ8WDw/yEmvHaKTAxQ6w0ux
         si31Nh4NV3QBpsVGgJ4AbFdaLZN6Q/3y+ooMNzJatNoGyZv6L0qDB8zQ2SpHIonCYQ18
         v9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714585476; x=1715190276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k4IV5MUpcWstax6ntK82tb+sL5JFIt+jl6TpQDKHYAY=;
        b=OwksjvmPuKE58e6FO5j/QM6M4Y74TlkRBYDrf514xOVTZQxruRCFqIx7Yv4SivqoEE
         Gscq6ATzr1LHmjoB4drvDTLuWeBbWirBG8X3chcbVNAf/0aZl1QgDmGU3dn/Z6IegSZL
         muX7/MJRhQiFPL09j0FNyr5L+yJFS994141jIK7Pd+oE2KSLmagDYby9VXlcdAisTn4j
         +KEsoRgR58Ht+ssG9kYLZjBzvouOU2jwt6gWcIJkLcEqKZoD6WqE78C6PeqN2fDTNHCV
         fYVnFkmLQvlWM7+cEKpxAss0p8lTvUigjORyFMI40PrTf9sRau7HKTqMIQBoBN6msS7U
         imkg==
X-Forwarded-Encrypted: i=1; AJvYcCX/jvVv0aWfwGqGg3Y5c/GIGWKRMKeFJ5SHPkloioNiFMEysO+08BTxa2QEFYoYMIcovF+w9dn2U8qA3ravs7XvlYOC
X-Gm-Message-State: AOJu0Yx1xFAW3btELZ/WaSld1Kyb8dIUR1ArHX+BQQEA8w4k23RvLADM
	G7YP0pfPKt5cVIYb9NyFPk7e4i2e7j8IuTHsUqDovy9BS0KWMb2nn3kjNlEbUctuTMydgkpGXW7
	I9tjsZ//EoY6GKBEunn7Cz82XR4asLvL+0qVb
X-Google-Smtp-Source: AGHT+IEdVVrTb7Zgs76FxcoRst8fi50Xits/93UMcuS3YKQMepe35H6XK3g97W1kPj+TBrSHq/3jFIHOcy+3gL+GTq0=
X-Received: by 2002:a17:907:9850:b0:a55:59e6:13f5 with SMTP id
 jj16-20020a170907985000b00a5559e613f5mr2475844ejc.26.1714585475945; Wed, 01
 May 2024 10:44:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZirPGnSDUzD-iWwc@google.com> <77913327-2115-42b5-850a-04ef0581faa7@linux.intel.com>
 <CAL715WJCHJD_wcJ+r4TyWfvmk9uNT_kPy7Pt=CHkB-Sf0D4Rqw@mail.gmail.com>
 <ff4a4229-04ac-4cbf-8aea-c84ccfa96e0b@linux.intel.com> <CAL715WJKL5__8RU0xxUf0HifNVQBDRODE54O2bwOx45w67TQTQ@mail.gmail.com>
 <5f5bcbc0-e2ef-4232-a56a-fda93c6a569e@linux.intel.com> <ZiwEoZDIg8l7-uid@google.com>
 <CAL715WJ4jHmto3ci=Fz5Bwx2Y=Hiy1MoFCpcUhz-C8aPMqYskw@mail.gmail.com>
 <b9095b0d-72f0-4e54-8d2e-f965ddff06bb@linux.intel.com> <CAL715WKm0X9NJxq8SNGD5EJomzY4DDSiwLb1wMMgcgHqeZ64BA@mail.gmail.com>
 <Zi_cle1-5SZK2558@google.com>
In-Reply-To: <Zi_cle1-5SZK2558@google.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Wed, 1 May 2024 10:43:58 -0700
Message-ID: <CAL715WJbYNqm2SXiTgqWHs34DtRfdFE7Hx48X_4ASHyQXeaPzA@mail.gmail.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Sean Christopherson <seanjc@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@linux.intel.com>, 
	maobibo <maobibo@loongson.cn>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 29, 2024 at 10:44=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Sat, Apr 27, 2024, Mingwei Zhang wrote:
> > On Sat, Apr 27, 2024 at 5:59=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.in=
tel.com> wrote:
> > >
> > >
> > > On 4/27/2024 11:04 AM, Mingwei Zhang wrote:
> > > > On Fri, Apr 26, 2024 at 12:46=E2=80=AFPM Sean Christopherson <seanj=
c@google.com> wrote:
> > > >> On Fri, Apr 26, 2024, Kan Liang wrote:
> > > >>>> Optimization 4
> > > >>>> allows the host side to immediately profiling this part instead =
of
> > > >>>> waiting for vcpu to reach to PMU context switch locations. Doing=
 so
> > > >>>> will generate more accurate results.
> > > >>> If so, I think the 4 is a must to have. Otherwise, it wouldn't ho=
ner the
> > > >>> definition of the exclude_guest. Without 4, it brings some random=
 blind
> > > >>> spots, right?
> > > >> +1, I view it as a hard requirement.  It's not an optimization, it=
's about
> > > >> accuracy and functional correctness.
> > > > Well. Does it have to be a _hard_ requirement? no?
>
> Assuming I understand how perf_event_open() works, which may be a fairly =
big
> assumption, for me, yes, this is a hard requirement.
>
> > > > The irq handler triggered by "perf record -a" could just inject a
> > > > "state". Instead of immediately preempting the guest PMU context, p=
erf
> > > > subsystem could allow KVM defer the context switch when it reaches =
the
> > > > next PMU context switch location.
>
> FWIW, forcefully interrupting the guest isn't a hard requirement, but pra=
ctically
> speaking I think that will yield the simplest, most robust implementation=
.
>
> > > > This is the same as the preemption kernel logic. Do you want me to
> > > > stop the work immediately? Yes (if you enable preemption), or No, l=
et
> > > > me finish my job and get to the scheduling point.
>
> Not really.  Task scheduling is by its nature completely exclusive, i.e. =
it's
> not possible to concurrently run multiple tasks on a single logical CPU. =
 Given
> a single CPU, to run task B, task A _must_ be scheduled out.
>
> That is not the case here.  Profiling the host with exclude_guest=3D1 isn=
't mutually
> exclusive with the guest using the PMU.  There's obviously the additional=
 overhead
> of switching PMU context, but the two uses themselves are not mutually ex=
clusive.
>
> And more importantly, perf_event_open() already has well-established ABI =
where it
> can install events across CPUs.  And when perf_event_open() returns, user=
space can
> rely on the event being active and counting (assuming it wasn't disabled =
by default).
>
> > > > Implementing this might be more difficult to debug. That's my real
> > > > concern. If we do not enable preemption, the PMU context switch wil=
l
> > > > only happen at the 2 pairs of locations. If we enable preemption, i=
t
> > > > could happen at any time.
>
> Yes and no.  I agree that swapping guest/host state from IRQ context coul=
d lead
> to hard to debug issues, but NOT doing so could also lead to hard to debu=
g issues.
> And even worse, those issues would likely be unique to specific kernel an=
d/or
> system configurations.
>
> E.g. userspace creates an event, but sometimes it randomly doesn't count =
correctly.
> Is the problem simply that it took a while for KVM to get to a scheduling=
 point,
> or is there a race lurking?  And what happens if the vCPU is the only run=
nable task
> on its pCPU, i.e. never gets scheduled out?
>
> Mix in all of the possible preemption and scheduler models, and other sou=
rces of
> forced rescheduling, e.g. RCU, and the number of factors to account for b=
ecomes
> quite terrifying.
>
> > > IMO I don't prefer to add a switch to enable/disable the preemption. =
I
> > > think current implementation is already complicated enough and
> > > unnecessary to introduce an new parameter to confuse users. Furthermo=
re,
> > > the switch could introduce an uncertainty and may mislead the perf us=
er
> > > to read the perf stats incorrectly.
>
> +1000.
>
> > > As for debug, it won't bring any difference as long as no host event =
is created.
> > >
> > That's ok. It is about opinions and brainstorming. Adding a parameter
> > to disable preemption is from the cloud usage perspective. The
> > conflict of opinions is which one you prioritize: guest PMU or the
> > host PMU? If you stand on the guest vPMU usage perspective, do you
> > want anyone on the host to shoot a profiling command and generate
> > turbulence? no. If you stand on the host PMU perspective and you want
> > to profile VMM/KVM, you definitely want accuracy and no delay at all.
>
> Hard no from me.  Attempting to support two fundamentally different model=
s means
> twice the maintenance burden.  The *best* case scenario is that usage is =
roughly
> a 50/50 spit.  The worst case scenario is that the majority of users favo=
r one
> model over the other, thus resulting in extremely limited tested of the m=
inority
> model.
>
> KVM already has this problem with scheduler preemption models, and it's p=
ainful.
> The overwhelming majority of KVM users run non-preemptible kernels, and s=
o our
> test coverage for preemtible kernels is abysmal.
>
> E.g. the TDP MMU effectively had a fatal flaw with preemptible kernels th=
at went
> unnoticed for many kernel releases[*], until _another_ bug introduced wit=
h dynamic
> preemption models resulted in users running code that was supposed to be =
specific
> to preemtible kernels.
>
> [* https://lore.kernel.org/kvm/ef81ff36-64bb-4cfe-ae9b-e3acf47bff24@proxm=
ox.com
>

I hear your voice, Sean.

In our cloud, we have a host-level profiling going on for all cores
periodically. It will be profiling X seconds every Y minute. Having
the host-level profiling using exclude_guest is fine, but stopping the
host-level profiling is a no no. Tweaking the X and Y is theoretically
possible, but highly likely out of the scope of virtualization. Now,
some of the VMs might be actively using vPMU at the same time. How can
we properly ensure the guest vPMU has consistent performance? Instead
of letting the VM suffer from the high overhead of PMU for X seconds
of every Y minute?

Any thought/help is appreciated. I see the logic of having preemption
there for correctness of the profiling on the host level. Doing this,
however, negatively impacts the above business usage.

One of the things on top of the mind is that: there seems to be no way
for the perf subsystem to express this: "no, your host-level profiling
is not interested in profiling the KVM_RUN loop when our guest vPMU is
actively running".

Thanks.
-Mingwei

-Mingwei

