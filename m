Return-Path: <kvm+bounces-15608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 688B58ADE04
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 09:11:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E34B91F22A4C
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 07:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF9F62E646;
	Tue, 23 Apr 2024 07:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UxwdONSb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A99286A6
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 07:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713856275; cv=none; b=Xpbi/XgPfyD3q0r1Fm6oJb7P/YEh2Jl8LTPAz8Li+xbJSJnaLqNBS0acTZf1FunAMVvwxyOWbJ6GQNJrpjkAhWdo8F2cdpiIAd7p4qJQRr/xJGvFG/y0bX9cxlEo5vTKc35oNu0V0ZNtQqdj8YJ6WeUL3m+Cu+jtk5oORDzpOdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713856275; c=relaxed/simple;
	bh=odE74ndxuyqdY3zgEI2iBLhV5SqQKMi+It1xd49Jl98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y72C3ucfkmtPGNhVNKdYRDJWjcZVlFlXjOm8ouerfs9v50wN4/cXuJEdh6ea3J4SXBjG+ywzI75BMl6GV+i97zX4gnTbdctK9CUKT1+IZr/OWKg5duesbCu6s+glyK5fdOBZdxytMFuLm8VDkKn/AfTPjbP8ORyCIfSDRtqzmCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UxwdONSb; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a587831809eso60523366b.1
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 00:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713856272; x=1714461072; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGIN4Ae0OYLnSEhk4UefjxOz9LixYc6tJtQMSyoUMoA=;
        b=UxwdONSbMTg2l1kKabfGwpzhysSRNl6scJJi/aYdeYuE0U3PzgVvgeKNLw+hWfa1km
         BNApFu63iLMg5IWdJOpSKFeO9huotYICME/ZmJ5CByadJU59vhkTT/+yBV6C+587a3jj
         J9dKXAN/n06lSzLA+J/UCVXXwoKCR+dCfPNBOFAgwQxf5ROIWt/FHSUlxIOrvewSgG8y
         Ff8Dbor7h8q+jqSeHQ196Hft/3vJvYpdVqBvNZKgHzRucfN8svdULMDm7caDn78XgBnk
         Gxp8jh58oTJFj0tBeoiS5OAjNNnaLD4U+xYlrcp0e8SS45KgVfKRoGqhyRL5My08cBcQ
         r+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713856272; x=1714461072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OGIN4Ae0OYLnSEhk4UefjxOz9LixYc6tJtQMSyoUMoA=;
        b=frdy3iFxrUqExq6dQvOCjfJWWHtcnylW91WmtjMrVEJTROojhuWyqXD2mCJCEinHtP
         XXk0S/pJ9wgStVPLIZerxOPHt/OxB5WzN3OacgnPdta/ow3tail8I6OhBs+TAKXH1Q5D
         ub5TkyZ88BJusf37FPjjvg6HKwQJmHm5y9a5QOhKzxveW8CJHBy4Asr3blyVj5C8P+tk
         dsMjwtW8SBpLCrN90h7opfN466BfTzYquX5xATI4ZyAUkW0RJeihh4lorYL6FJDORzmO
         PdpC8GwnMxQLHJ0sl5BgJ+9SdU0P7R7jtS1QzvErsNpUoq57FoZvUsQxjabrEqm62U9O
         gBuw==
X-Forwarded-Encrypted: i=1; AJvYcCUrO4uX73gF85ts3p0Dwc6xJ8M9TwwrZ0iynQu9mzPasRDJToSnOgfVZgxAPEe1CyUN2W0dajva93s4rV8vaUa/mJ8p
X-Gm-Message-State: AOJu0YzYykf32lgCNueBhoaFqnkScjss4Ktf3vM/W23pzUrtsh71+qy4
	D3Jy3UfBlS5e/8OXp7th2LBEIRu0xlRZUDB9HCC8caE25Hu+RrQKMf1N0bsBDs6unyfaVuFJJ39
	zGUltWVHuJqpCEjrYWJPQxFaj8OYP5g0QBqGx
X-Google-Smtp-Source: AGHT+IE6fJwKvlBE0hK0aFw71XDa4QQAaKTfb/p3rYL/f5EnaEuqB5QGP3T5ZirLW5OD/d6MZszHeMugdtt7hHSmSA0=
X-Received: by 2002:a17:906:5056:b0:a4e:3fad:b973 with SMTP id
 e22-20020a170906505600b00a4e3fadb973mr7096623ejk.65.1713856272124; Tue, 23
 Apr 2024 00:11:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
 <Zhn9TGOiXxcV5Epx@google.com> <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
 <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com> <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
 <Zh1mKoHJcj22rKy8@google.com> <CAL715WJf6RdM3DQt995y4skw8LzTMk36Q2hDE34n3tVkkdtMMw@mail.gmail.com>
 <Zh2uFkfH8BA23lm0@google.com> <4d60384a-11e0-2f2b-a568-517b40c91b25@loongson.cn>
 <ZiaX3H3YfrVh50cs@google.com> <d8f3497b-9f63-e30e-0c63-253908d40ac2@loongson.cn>
 <d980dd10-e4c4-4774-b107-77b320cec9f9@linux.intel.com> <b5e97aa1-7683-4eff-e1e3-58ac98a8d719@loongson.cn>
 <1ec7a21c-71d0-4f3e-9fa3-3de8ca0f7315@linux.intel.com> <5279eabc-ca46-ee1b-b80d-9a511ba90a36@loongson.cn>
 <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
 <86d1f6d1-197a-ecd9-3349-a64da9ea9789@loongson.cn> <729c4b30-163c-4115-a380-14ece533a8b9@linux.intel.com>
In-Reply-To: <729c4b30-163c-4115-a380-14ece533a8b9@linux.intel.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Tue, 23 Apr 2024 00:10:35 -0700
Message-ID: <CAL715W+BpyX3EeKr=3ipMH8W30wmhMkxg2Fx2OET9cvQ480cgg@mail.gmail.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: maobibo <maobibo@loongson.cn>, Sean Christopherson <seanjc@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, peterz@infradead.org, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, jmattson@google.com, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024 at 11:45=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.intel=
.com> wrote:
>
>
> On 4/23/2024 2:08 PM, maobibo wrote:
> >
> >
> > On 2024/4/23 =E4=B8=8B=E5=8D=8812:23, Mingwei Zhang wrote:
> >> On Mon, Apr 22, 2024 at 8:55=E2=80=AFPM maobibo <maobibo@loongson.cn> =
wrote:
> >>>
> >>>
> >>>
> >>> On 2024/4/23 =E4=B8=8A=E5=8D=8811:13, Mi, Dapeng wrote:
> >>>>
> >>>> On 4/23/2024 10:53 AM, maobibo wrote:
> >>>>>
> >>>>>
> >>>>> On 2024/4/23 =E4=B8=8A=E5=8D=8810:44, Mi, Dapeng wrote:
> >>>>>>
> >>>>>> On 4/23/2024 9:01 AM, maobibo wrote:
> >>>>>>>
> >>>>>>>
> >>>>>>> On 2024/4/23 =E4=B8=8A=E5=8D=881:01, Sean Christopherson wrote:
> >>>>>>>> On Mon, Apr 22, 2024, maobibo wrote:
> >>>>>>>>> On 2024/4/16 =E4=B8=8A=E5=8D=886:45, Sean Christopherson wrote:
> >>>>>>>>>> On Mon, Apr 15, 2024, Mingwei Zhang wrote:
> >>>>>>>>>>> On Mon, Apr 15, 2024 at 10:38=E2=80=AFAM Sean Christopherson
> >>>>>>>>>>> <seanjc@google.com> wrote:
> >>>>>>>>>>>> One my biggest complaints with the current vPMU code is that
> >>>>>>>>>>>> the roles and
> >>>>>>>>>>>> responsibilities between KVM and perf are poorly defined,
> >>>>>>>>>>>> which
> >>>>>>>>>>>> leads to suboptimal
> >>>>>>>>>>>> and hard to maintain code.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Case in point, I'm pretty sure leaving guest values in PMCs
> >>>>>>>>>>>> _would_ leak guest
> >>>>>>>>>>>> state to userspace processes that have RDPMC permissions, as
> >>>>>>>>>>>> the PMCs might not
> >>>>>>>>>>>> be dirty from perf's perspective (see
> >>>>>>>>>>>> perf_clear_dirty_counters()).
> >>>>>>>>>>>>
> >>>>>>>>>>>> Blindly clearing PMCs in KVM "solves" that problem, but in
> >>>>>>>>>>>> doing so makes the
> >>>>>>>>>>>> overall code brittle because it's not clear whether KVM
> >>>>>>>>>>>> _needs_
> >>>>>>>>>>>> to clear PMCs,
> >>>>>>>>>>>> or if KVM is just being paranoid.
> >>>>>>>>>>>
> >>>>>>>>>>> So once this rolls out, perf and vPMU are clients directly to
> >>>>>>>>>>> PMU HW.
> >>>>>>>>>>
> >>>>>>>>>> I don't think this is a statement we want to make, as it opens=
 a
> >>>>>>>>>> discussion
> >>>>>>>>>> that we won't win.  Nor do I think it's one we *need* to make.
> >>>>>>>>>> KVM doesn't need
> >>>>>>>>>> to be on equal footing with perf in terms of owning/managing P=
MU
> >>>>>>>>>> hardware, KVM
> >>>>>>>>>> just needs a few APIs to allow faithfully and accurately
> >>>>>>>>>> virtualizing a guest PMU.
> >>>>>>>>>>
> >>>>>>>>>>> Faithful cleaning (blind cleaning) has to be the baseline
> >>>>>>>>>>> implementation, until both clients agree to a "deal" between
> >>>>>>>>>>> them.
> >>>>>>>>>>> Currently, there is no such deal, but I believe we could have
> >>>>>>>>>>> one via
> >>>>>>>>>>> future discussion.
> >>>>>>>>>>
> >>>>>>>>>> What I am saying is that there needs to be a "deal" in place
> >>>>>>>>>> before this code
> >>>>>>>>>> is merged.  It doesn't need to be anything fancy, e.g. perf ca=
n
> >>>>>>>>>> still pave over
> >>>>>>>>>> PMCs it doesn't immediately load, as opposed to using
> >>>>>>>>>> cpu_hw_events.dirty to lazily
> >>>>>>>>>> do the clearing.  But perf and KVM need to work together from
> >>>>>>>>>> the
> >>>>>>>>>> get go, ie. I
> >>>>>>>>>> don't want KVM doing something without regard to what perf doe=
s,
> >>>>>>>>>> and vice versa.
> >>>>>>>>>>
> >>>>>>>>> There is similar issue on LoongArch vPMU where vm can directly
> >>>>>>>>> pmu
> >>>>>>>>> hardware
> >>>>>>>>> and pmu hw is shard with guest and host. Besides context switch
> >>>>>>>>> there are
> >>>>>>>>> other places where perf core will access pmu hw, such as tick
> >>>>>>>>> timer/hrtimer/ipi function call, and KVM can only intercept
> >>>>>>>>> context switch.
> >>>>>>>>
> >>>>>>>> Two questions:
> >>>>>>>>
> >>>>>>>>    1) Can KVM prevent the guest from accessing the PMU?
> >>>>>>>>
> >>>>>>>>    2) If so, KVM can grant partial access to the PMU, or is it a=
ll
> >>>>>>>> or nothing?
> >>>>>>>>
> >>>>>>>> If the answer to both questions is "yes", then it sounds like
> >>>>>>>> LoongArch *requires*
> >>>>>>>> mediated/passthrough support in order to virtualize its PMU.
> >>>>>>>
> >>>>>>> Hi Sean,
> >>>>>>>
> >>>>>>> Thank for your quick response.
> >>>>>>>
> >>>>>>> yes, kvm can prevent guest from accessing the PMU and grant parti=
al
> >>>>>>> or all to access to the PMU. Only that if one pmu event is grante=
d
> >>>>>>> to VM, host can not access this pmu event again. There must be pm=
u
> >>>>>>> event switch if host want to.
> >>>>>>
> >>>>>> PMU event is a software entity which won't be shared. did you
> >>>>>> mean if
> >>>>>> a PMU HW counter is granted to VM, then Host can't access the PMU =
HW
> >>>>>> counter, right?
> >>>>> yes, if PMU HW counter/control is granted to VM. The value comes fr=
om
> >>>>> guest, and is not meaningful for host.  Host pmu core does not know
> >>>>> that it is granted to VM, host still think that it owns pmu.
> >>>>
> >>>> That's one issue this patchset tries to solve. Current new mediated
> >>>> x86
> >>>> vPMU framework doesn't allow Host or Guest own the PMU HW resource
> >>>> simultaneously. Only when there is no !exclude_guest event on host,
> >>>> guest is allowed to exclusively own the PMU HW resource.
> >>>>
> >>>>
> >>>>>
> >>>>> Just like FPU register, it is shared by VM and host during differen=
t
> >>>>> time and it is lately switched. But if IPI or timer interrupt uses
> >>>>> FPU
> >>>>> register on host, there will be the same issue.
> >>>>
> >>>> I didn't fully get your point. When IPI or timer interrupt reach, a
> >>>> VM-exit is triggered to make CPU traps into host first and then the
> >>>> host
> >>> yes, it is.
> >>
> >> This is correct. And this is one of the points that we had debated
> >> internally whether we should do PMU context switch at vcpu loop
> >> boundary or VM Enter/exit boundary. (host-level) timer interrupt can
> >> force VM Exit, which I think happens every 4ms or 1ms, depending on
> >> configuration.
> >>
> >> One of the key reasons we currently propose this is because it is the
> >> same boundary as the legacy PMU, i.e., it would be simple to propose
> >> from the perf subsystem perspective.
> >>
> >> Performance wise, doing PMU context switch at vcpu boundary would be
> >> way better in general. But the downside is that perf sub-system lose
> >> the capability to profile majority of the KVM code (functions) when
> >> guest PMU is enabled.
> >>
> >>>
> >>>> interrupt handler is called. Or are you complaining the executing
> >>>> sequence of switching guest PMU MSRs and these interrupt handler?
> >>> In our vPMU implementation, it is ok if vPMU is switched in vm exit
> >>> path, however there is problem if vPMU is switched during vcpu thread
> >>> sched-out/sched-in path since IPI/timer irq interrupt access pmu
> >>> register in host mode.
> >>
> >> Oh, the IPI/timer irq handler will access PMU registers? I thought
> >> only the host-level NMI handler will access the PMU MSRs since PMI is
> >> registered under NMI.
> >>
> >> In that case, you should disable  IRQ during vcpu context switch. For
> >> NMI, we prevent its handler from accessing the PMU registers. In
> >> particular, we use a per-cpu variable to guard that. So, the
> >> host-level PMI handler for perf sub-system will check the variable
> >> before proceeding.
> >
> > perf core will access pmu hw in tick timer/hrtimer/ipi function call,
> > such as function perf_event_task_tick() is called in tick timer, there
> > are  event_function_call(event, __perf_event_xxx, &value) in file
> > kernel/events/core.c.
> >
> > https://lore.kernel.org/lkml/20240417065236.500011-1-gaosong@loongson.c=
n/T/#m15aeb79fdc9ce72dd5b374edd6acdcf7a9dafcf4
> >
>
> Just go through functions (not sure if all),  whether
> perf_event_task_tick() or the callbacks of event_function_call() would
> check the event->state first, if the event is in
> PERF_EVENT_STATE_INACTIVE, the PMU HW MSRs would not be touched really.
> In this new proposal, all host events with exclude_guest attribute would
> be put on PERF_EVENT_STATE_INACTIVE sate if guest own the PMU HW
> resource. So I think it's fine.
>

Is there any event in the host still having PERF_EVENT_STATE_ACTIVE?
If so, hmm, it will reach perf_pmu_disable(event->pmu), which will
access the global ctrl MSR.

