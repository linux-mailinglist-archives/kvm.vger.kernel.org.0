Return-Path: <kvm+bounces-15601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E08E8ADCCC
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 06:24:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60E821C21B5D
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 04:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994DE1F941;
	Tue, 23 Apr 2024 04:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4D4xuL6R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E9C1CAA2
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 04:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713846256; cv=none; b=WU6y8vlNILvooUw6K+RwTZiAuBVP1+IwzYHsWSU+KxzUajbrKaIXaLzqJIgxNTK9IwLrGpCjaJG3kVMyoEsajndddffzKvOzmOF1JGdrNn5T9lvCDeF9MusmRtsETE1Iq20Ue6IW+BZi6OyKJ3hFMfhPLcDWhH0F+nxTP8BNAuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713846256; c=relaxed/simple;
	bh=d5MJ4e2a30eG+jDYKNT7mG9Gc/6eaI9RNoBEMPFEkhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bp/s/QfFGBnxzB72GJEefy+WeZRAPQnwijZPFZrlRqbPez/SbPQFnNjzHbIo8Y/iZAG0SkFTzDqapzp89HER282hy7FTbLT6aiI9TLq7Ti5wIf7+77zpMlHMvlb9+H/xtpsPeSxLpUtZxBLGcaH6I9oRYwBC1M2abvBm+7CXlbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4D4xuL6R; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a5872419e31so110726666b.3
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 21:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713846253; x=1714451053; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5buiYtGazihCB3jxFyzdy4lm+my6nJSrcsNRV34lvg0=;
        b=4D4xuL6RrYLKJ57dqdUwtENAhUfshdUvkani8En8wSqDPC0KoCmvI5pbPdReqeO/Y3
         L6ugBUuH4yXYkeV1WTasxv6Hu5CwdabCypnv+rKWRAjDmMysqpMTZxn2gTUQqRP0Nb5F
         frSFwcJcPwXYztG9qaV8PCcxT+ipd4wJea9rn6bMQMiWAvQXXugrQ0NSkyWsv6sPlHq6
         2hgI4NpVDGo3iDRfvWHBmus/5V79Agsd1lTPQ0GUgCzQsQHoHcbuKSpeKqJOTouohybv
         mu/5cto2ZZmiuufZNCSdnPaItJgr5t73FZ7mHE/FSxg8xDYG0Y1kDyTdkoWMzVZifzZq
         4riQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713846253; x=1714451053;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5buiYtGazihCB3jxFyzdy4lm+my6nJSrcsNRV34lvg0=;
        b=wM4yPVdCwDdm2vN8r+U8YewOj1cmzn2gV9LigNrmn7bVWlaaszf291fJ0HECxSFTVH
         F9kg+XxCQjQDT0EBk/dQRKqOCh9U3YACA/t7UtDu0/+ZNUuRYU6keEpJ5LKR5Vks11cl
         qx6/jp9QS2/1p/nehxAujeF0/2eSGLkczd+gx3FvFzLfl5DpP/k6zRQ/qpX3qGcTjSbT
         CKgSogmd7Wk/Pn9S7wCR4hRj8avc74TUxl0wkua0ceNXyTviDF5RpWLWYhKXr2CBkumO
         JZMHtSha2DVyBjkUUEgHvVz/fubKetqJrj8kBXujHDuVXqix3ZBxg4W3qCbXBtDCSoVz
         PTsQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6w38Exba2Tl6x23PLeMJhpmfwddON4n53Xgg5Ni8zg8nEjHSovJar7Sq5b3+tN2Oe21fxOHnxuv4/wsIQoUpdWJ/X
X-Gm-Message-State: AOJu0YyzzZxDOFXM3XmNtPfLJ1O/d86DStsStBV+XUN6LWbJWHNo31e8
	cyTdeAyGtnVgvmO2y3O0BAnk6LuDlpKj5tCXZ/1HOruvp12wDmQbZR4v93/U9cgaWoS1hSrnCZm
	fX1rEjZSXDvjsXLgVOzpWxEkqhliKuKx+Os4P
X-Google-Smtp-Source: AGHT+IHdQXEwcHFSFhDGbTnONtQWhrAzJUB2mFSVSfODjnpVeSXfLG85RA6SDmD2hbWEVfwX2h852zzj28HGLIv+UH0=
X-Received: by 2002:a17:906:4e82:b0:a55:b67a:c3ad with SMTP id
 v2-20020a1709064e8200b00a55b67ac3admr2904085eju.73.1713846252447; Mon, 22 Apr
 2024 21:24:12 -0700 (PDT)
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
In-Reply-To: <5279eabc-ca46-ee1b-b80d-9a511ba90a36@loongson.cn>
From: Mingwei Zhang <mizhang@google.com>
Date: Mon, 22 Apr 2024 21:23:35 -0700
Message-ID: <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: maobibo <maobibo@loongson.cn>
Cc: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>, Sean Christopherson <seanjc@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, peterz@infradead.org, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, jmattson@google.com, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024 at 8:55=E2=80=AFPM maobibo <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2024/4/23 =E4=B8=8A=E5=8D=8811:13, Mi, Dapeng wrote:
> >
> > On 4/23/2024 10:53 AM, maobibo wrote:
> >>
> >>
> >> On 2024/4/23 =E4=B8=8A=E5=8D=8810:44, Mi, Dapeng wrote:
> >>>
> >>> On 4/23/2024 9:01 AM, maobibo wrote:
> >>>>
> >>>>
> >>>> On 2024/4/23 =E4=B8=8A=E5=8D=881:01, Sean Christopherson wrote:
> >>>>> On Mon, Apr 22, 2024, maobibo wrote:
> >>>>>> On 2024/4/16 =E4=B8=8A=E5=8D=886:45, Sean Christopherson wrote:
> >>>>>>> On Mon, Apr 15, 2024, Mingwei Zhang wrote:
> >>>>>>>> On Mon, Apr 15, 2024 at 10:38=E2=80=AFAM Sean Christopherson
> >>>>>>>> <seanjc@google.com> wrote:
> >>>>>>>>> One my biggest complaints with the current vPMU code is that
> >>>>>>>>> the roles and
> >>>>>>>>> responsibilities between KVM and perf are poorly defined, which
> >>>>>>>>> leads to suboptimal
> >>>>>>>>> and hard to maintain code.
> >>>>>>>>>
> >>>>>>>>> Case in point, I'm pretty sure leaving guest values in PMCs
> >>>>>>>>> _would_ leak guest
> >>>>>>>>> state to userspace processes that have RDPMC permissions, as
> >>>>>>>>> the PMCs might not
> >>>>>>>>> be dirty from perf's perspective (see
> >>>>>>>>> perf_clear_dirty_counters()).
> >>>>>>>>>
> >>>>>>>>> Blindly clearing PMCs in KVM "solves" that problem, but in
> >>>>>>>>> doing so makes the
> >>>>>>>>> overall code brittle because it's not clear whether KVM _needs_
> >>>>>>>>> to clear PMCs,
> >>>>>>>>> or if KVM is just being paranoid.
> >>>>>>>>
> >>>>>>>> So once this rolls out, perf and vPMU are clients directly to
> >>>>>>>> PMU HW.
> >>>>>>>
> >>>>>>> I don't think this is a statement we want to make, as it opens a
> >>>>>>> discussion
> >>>>>>> that we won't win.  Nor do I think it's one we *need* to make.
> >>>>>>> KVM doesn't need
> >>>>>>> to be on equal footing with perf in terms of owning/managing PMU
> >>>>>>> hardware, KVM
> >>>>>>> just needs a few APIs to allow faithfully and accurately
> >>>>>>> virtualizing a guest PMU.
> >>>>>>>
> >>>>>>>> Faithful cleaning (blind cleaning) has to be the baseline
> >>>>>>>> implementation, until both clients agree to a "deal" between the=
m.
> >>>>>>>> Currently, there is no such deal, but I believe we could have
> >>>>>>>> one via
> >>>>>>>> future discussion.
> >>>>>>>
> >>>>>>> What I am saying is that there needs to be a "deal" in place
> >>>>>>> before this code
> >>>>>>> is merged.  It doesn't need to be anything fancy, e.g. perf can
> >>>>>>> still pave over
> >>>>>>> PMCs it doesn't immediately load, as opposed to using
> >>>>>>> cpu_hw_events.dirty to lazily
> >>>>>>> do the clearing.  But perf and KVM need to work together from the
> >>>>>>> get go, ie. I
> >>>>>>> don't want KVM doing something without regard to what perf does,
> >>>>>>> and vice versa.
> >>>>>>>
> >>>>>> There is similar issue on LoongArch vPMU where vm can directly pmu
> >>>>>> hardware
> >>>>>> and pmu hw is shard with guest and host. Besides context switch
> >>>>>> there are
> >>>>>> other places where perf core will access pmu hw, such as tick
> >>>>>> timer/hrtimer/ipi function call, and KVM can only intercept
> >>>>>> context switch.
> >>>>>
> >>>>> Two questions:
> >>>>>
> >>>>>   1) Can KVM prevent the guest from accessing the PMU?
> >>>>>
> >>>>>   2) If so, KVM can grant partial access to the PMU, or is it all
> >>>>> or nothing?
> >>>>>
> >>>>> If the answer to both questions is "yes", then it sounds like
> >>>>> LoongArch *requires*
> >>>>> mediated/passthrough support in order to virtualize its PMU.
> >>>>
> >>>> Hi Sean,
> >>>>
> >>>> Thank for your quick response.
> >>>>
> >>>> yes, kvm can prevent guest from accessing the PMU and grant partial
> >>>> or all to access to the PMU. Only that if one pmu event is granted
> >>>> to VM, host can not access this pmu event again. There must be pmu
> >>>> event switch if host want to.
> >>>
> >>> PMU event is a software entity which won't be shared. did you mean if
> >>> a PMU HW counter is granted to VM, then Host can't access the PMU HW
> >>> counter, right?
> >> yes, if PMU HW counter/control is granted to VM. The value comes from
> >> guest, and is not meaningful for host.  Host pmu core does not know
> >> that it is granted to VM, host still think that it owns pmu.
> >
> > That's one issue this patchset tries to solve. Current new mediated x86
> > vPMU framework doesn't allow Host or Guest own the PMU HW resource
> > simultaneously. Only when there is no !exclude_guest event on host,
> > guest is allowed to exclusively own the PMU HW resource.
> >
> >
> >>
> >> Just like FPU register, it is shared by VM and host during different
> >> time and it is lately switched. But if IPI or timer interrupt uses FPU
> >> register on host, there will be the same issue.
> >
> > I didn't fully get your point. When IPI or timer interrupt reach, a
> > VM-exit is triggered to make CPU traps into host first and then the hos=
t
> yes, it is.

This is correct. And this is one of the points that we had debated
internally whether we should do PMU context switch at vcpu loop
boundary or VM Enter/exit boundary. (host-level) timer interrupt can
force VM Exit, which I think happens every 4ms or 1ms, depending on
configuration.

One of the key reasons we currently propose this is because it is the
same boundary as the legacy PMU, i.e., it would be simple to propose
from the perf subsystem perspective.

Performance wise, doing PMU context switch at vcpu boundary would be
way better in general. But the downside is that perf sub-system lose
the capability to profile majority of the KVM code (functions) when
guest PMU is enabled.

>
> > interrupt handler is called. Or are you complaining the executing
> > sequence of switching guest PMU MSRs and these interrupt handler?
> In our vPMU implementation, it is ok if vPMU is switched in vm exit
> path, however there is problem if vPMU is switched during vcpu thread
> sched-out/sched-in path since IPI/timer irq interrupt access pmu
> register in host mode.

Oh, the IPI/timer irq handler will access PMU registers? I thought
only the host-level NMI handler will access the PMU MSRs since PMI is
registered under NMI.

In that case, you should disable  IRQ during vcpu context switch. For
NMI, we prevent its handler from accessing the PMU registers. In
particular, we use a per-cpu variable to guard that. So, the
host-level PMI handler for perf sub-system will check the variable
before proceeding.

>
> In general it will be better if the switch is done in vcpu thread
> sched-out/sched-in, else there is requirement to profile kvm
> hypervisor.Even there is such requirement, it is only one option. In
> most conditions, it will better if time of VM context exit is small.
>
Performance wise, agree, but there will be debate on perf
functionality loss at the host level.

Maybe, (just maybe), it is possible to do PMU context switch at vcpu
boundary normally, but doing it at VM Enter/Exit boundary when host is
profiling KVM kernel module. So, dynamically adjusting PMU context
switch location could be an option.

> >
> >
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>>
> >>>>
> >>>>>
> >>>>>> Can we add callback handler in structure kvm_guest_cbs?  just like
> >>>>>> this:
> >>>>>> @@ -6403,6 +6403,7 @@ static struct perf_guest_info_callbacks
> >>>>>> kvm_guest_cbs
> >>>>>> =3D {
> >>>>>>          .state                  =3D kvm_guest_state,
> >>>>>>          .get_ip                 =3D kvm_guest_get_ip,
> >>>>>>          .handle_intel_pt_intr   =3D NULL,
> >>>>>> +       .lose_pmu               =3D kvm_guest_lose_pmu,
> >>>>>>   };
> >>>>>>
> >>>>>> By the way, I do not know should the callback handler be triggered
> >>>>>> in perf
> >>>>>> core or detailed pmu hw driver. From ARM pmu hw driver, it is
> >>>>>> triggered in
> >>>>>> pmu hw driver such as function kvm_vcpu_pmu_resync_el0,
> >>>>>> but I think it will be better if it is done in perf core.
> >>>>>
> >>>>> I don't think we want to take the approach of perf and KVM guests
> >>>>> "fighting" over
> >>>>> the PMU.  That's effectively what we have today, and it's a mess
> >>>>> for KVM because
> >>>>> it's impossible to provide consistent, deterministic behavior for
> >>>>> the guest.  And
> >>>>> it's just as messy for perf, which ends up having wierd, cumbersome
> >>>>> flows that
> >>>>> exists purely to try to play nice with KVM.
> >>>> With existing pmu core code, in tick timer interrupt or IPI function
> >>>> call interrupt pmu hw may be accessed by host when VM is running and
> >>>> pmu is already granted to guest. KVM can not intercept host
> >>>> IPI/timer interrupt, there is no pmu context switch, there will be
> >>>> problem.
> >>>>
> >>>> Regards
> >>>> Bibo Mao
> >>>>
> >>
>

