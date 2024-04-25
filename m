Return-Path: <kvm+bounces-15970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 453798B298C
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:17:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1EB7281E5D
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AED47153809;
	Thu, 25 Apr 2024 20:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z/NUikNX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1761534FC
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 20:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714076240; cv=none; b=WFATBokVp2Nq280zhQDUNYaeD/IdDG+n6ytQa8vgGoZzJjhGcvXaiNP/BeT0uMUn35jhx1dhbz7Owg/grT8IoKBtIaQIbZW0FerVvpsxkwSpoFkcEW4b8+zfzTKcqynZK48xG8IzVVq9aGvSG3Ja4bFl5E7HGiljQ9vXxHGyQsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714076240; c=relaxed/simple;
	bh=4BBDPsjN6dzEJ4giKnaR11KMRJazqH6XiUS8veZbFSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xhnh/m7OVjXiCrt6883RP/m3gaIqnZmTP9S3e0JoTlR9w3RYJcFdeF7M5N0p4/uBfjyHNstHjoAwyEKhQnT+Vo7406d0MybhF0//wd1fErJtODJjzAFCMxtBQYHdzzzmERwZv9E051dy1dSwZSyAXecikFKzkVcDkY0w8KVve7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z/NUikNX; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a4715991c32so150414466b.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 13:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714076237; x=1714681037; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMog2JZUZ8XbtVqoBAzMg/dsNmKbqiBjLxtU6d10Qw4=;
        b=Z/NUikNXLNoK3TQtZK1qFP8vOt08KF6jSkM5UBR0TE0iIq6NRXahUIGoSOfOO5HuaY
         pDAABTNq8Fk9l6RVZg/AWdREzGMCtvwjwa8z0FzsEkwu+LNDQAe+ubKzOS3uFYaMoWDc
         kGauC6Hqalz6I1eVLjTq9T9TXBMiiorNCzGjTR5U6v5kkmBxFwpyQiCvZmCSFJXov3Q/
         zxJOjEPRDhBSANYzEiBmrekrpjlWBn3EMJqlVbJuEMMo7j9HDviB6/ffnyIdYkqR2S0I
         SkAXuD4SR2Z38lcelrF6uCGC/ecw9jVTKdW1zRTQAvqqZt0ICF92Y59G3FW/Z1U0IVEU
         xpVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714076237; x=1714681037;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dMog2JZUZ8XbtVqoBAzMg/dsNmKbqiBjLxtU6d10Qw4=;
        b=JyvrdTGfMplbsuBdu3Bia85J4Ysvf+TM7l3y4dojJD7L9vB8ug165DG5IS/XpTqqsU
         y9X6Uqhr39eSyZ9wi3z/+c0ccf5MhtPWg/UxrqzzjcB+JiWrWo3th+dpDIS1uVTi2HvE
         TMYpTVKxYaELYUe35BYHk6+aebKbkyQ2Kkca+ZHVUNxrNSHOtFVUEjYLr/bpkjkk/ryD
         I5oh1wAqaVR96BsAOVTH1ANcBQZ4dSRHwQlv2LKFMun9yneqydHY6fziSM/YXxEGpQ/Q
         KknTe8d8pEqPR9vGAqfcoUCK/e3dM3CjBlJ9mrh92vTThvKcnhlLqFMem6N/TViIVdcp
         vL5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXLXO5e4dm6yWm0qHxh21tmpFhsVZz5Ls96BM/yqdLmU3X6PFvjv8jfuB07CuGO2fGW9yuFSvXM0gLtFYYpYz5gGdnU
X-Gm-Message-State: AOJu0Ywb3B2W8lTnXttWdZRWHjWXkXag5deRUPm4zJYVOEIC5ONIJ+bx
	KpihTZmxBYWBMGRMZAfLyEUdXIr3Vxsdyq9tCIqoadFiT1wUAexxUULIVaVy7DBm3HiceUls6EG
	cJItoO9t/+vkr0319BWP+yh+PokCr2xumAjMQ
X-Google-Smtp-Source: AGHT+IGnRLA6abhkAbzojY7edB/w0Ptxz2eulZ6XO0QV0FgG7Zk4Y0oBfqeQG+5YpJZSfDseca++A/86xOPGwOkUqqA=
X-Received: by 2002:a17:906:6ce:b0:a58:7505:16ff with SMTP id
 v14-20020a17090606ce00b00a58750516ffmr456515ejb.64.1714076237097; Thu, 25 Apr
 2024 13:17:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZiaX3H3YfrVh50cs@google.com> <d8f3497b-9f63-e30e-0c63-253908d40ac2@loongson.cn>
 <d980dd10-e4c4-4774-b107-77b320cec9f9@linux.intel.com> <b5e97aa1-7683-4eff-e1e3-58ac98a8d719@loongson.cn>
 <1ec7a21c-71d0-4f3e-9fa3-3de8ca0f7315@linux.intel.com> <5279eabc-ca46-ee1b-b80d-9a511ba90a36@loongson.cn>
 <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
 <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn> <CAL715W++maAt2Ujfvmu1pZKS4R5EmAPebTU_h9AB8aFbdLFrTQ@mail.gmail.com>
 <f843298c-db08-4fde-9887-13de18d960ac@linux.intel.com> <Zikeh2eGjwzDbytu@google.com>
 <7834a811-4764-42aa-8198-55c4556d947b@linux.intel.com> <CAL715WKh8VBJ-O50oqSnCqKPQo4Bor_aMnRZeS_TzJP3ja8-YQ@mail.gmail.com>
 <6af2da05-cb47-46f7-b129-08463bc9469b@linux.intel.com>
In-Reply-To: <6af2da05-cb47-46f7-b129-08463bc9469b@linux.intel.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Thu, 25 Apr 2024 13:16:40 -0700
Message-ID: <CAL715W+zeqKenPLP2Fm9u_BkGRKAk-mncsOxrg=EKs74qK5f1Q@mail.gmail.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>, Sean Christopherson <seanjc@google.com>, 
	maobibo <maobibo@loongson.cn>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024 at 9:13=E2=80=AFAM Liang, Kan <kan.liang@linux.intel.c=
om> wrote:
>
>
>
> On 2024-04-25 12:24 a.m., Mingwei Zhang wrote:
> > On Wed, Apr 24, 2024 at 8:56=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.in=
tel.com> wrote:
> >>
> >>
> >> On 4/24/2024 11:00 PM, Sean Christopherson wrote:
> >>> On Wed, Apr 24, 2024, Dapeng Mi wrote:
> >>>> On 4/24/2024 1:02 AM, Mingwei Zhang wrote:
> >>>>>>> Maybe, (just maybe), it is possible to do PMU context switch at v=
cpu
> >>>>>>> boundary normally, but doing it at VM Enter/Exit boundary when ho=
st is
> >>>>>>> profiling KVM kernel module. So, dynamically adjusting PMU contex=
t
> >>>>>>> switch location could be an option.
> >>>>>> If there are two VMs with pmu enabled both, however host PMU is no=
t
> >>>>>> enabled. PMU context switch should be done in vcpu thread sched-ou=
t path.
> >>>>>>
> >>>>>> If host pmu is used also, we can choose whether PMU switch should =
be
> >>>>>> done in vm exit path or vcpu thread sched-out path.
> >>>>>>
> >>>>> host PMU is always enabled, ie., Linux currently does not support K=
VM
> >>>>> PMU running standalone. I guess what you mean is there are no activ=
e
> >>>>> perf_events on the host side. Allowing a PMU context switch driftin=
g
> >>>>> from vm-enter/exit boundary to vcpu loop boundary by checking host
> >>>>> side events might be a good option. We can keep the discussion, but=
 I
> >>>>> won't propose that in v2.
> >>>> I suspect if it's really doable to do this deferring. This still mak=
es host
> >>>> lose the most of capability to profile KVM. Per my understanding, mo=
st of
> >>>> KVM overhead happens in the vcpu loop, exactly speaking in VM-exit h=
andling.
> >>>> We have no idea when host want to create perf event to profile KVM, =
it could
> >>>> be at any time.
> >>> No, the idea is that KVM will load host PMU state asap, but only when=
 host PMU
> >>> state actually needs to be loaded, i.e. only when there are relevant =
host events.
> >>>
> >>> If there are no host perf events, KVM keeps guest PMU state loaded fo=
r the entire
> >>> KVM_RUN loop, i.e. provides optimal behavior for the guest.  But if a=
 host perf
> >>> events exists (or comes along), the KVM context switches PMU at VM-En=
ter/VM-Exit,
> >>> i.e. lets the host profile almost all of KVM, at the cost of a degrad=
ed experience
> >>> for the guest while host perf events are active.
> >>
> >> I see. So KVM needs to provide a callback which needs to be called in
> >> the IPI handler. The KVM callback needs to be called to switch PMU sta=
te
> >> before perf really enabling host event and touching PMU MSRs. And only
> >> the perf event with exclude_guest attribute is allowed to create on
> >> host. Thanks.
> >
> > Do we really need a KVM callback? I think that is one option.
> >
> > Immediately after VMEXIT, KVM will check whether there are "host perf
> > events". If so, do the PMU context switch immediately. Otherwise, keep
> > deferring the context switch to the end of vPMU loop.
> >
> > Detecting if there are "host perf events" would be interesting. The
> > "host perf events" refer to the perf_events on the host that are
> > active and assigned with HW counters and that are saved when context
> > switching to the guest PMU. I think getting those events could be done
> > by fetching the bitmaps in cpuc.
>
> The cpuc is ARCH specific structure. I don't think it can be get in the
> generic code. You probably have to implement ARCH specific functions to
> fetch the bitmaps. It probably won't worth it.
>
> You may check the pinned_groups and flexible_groups to understand if
> there are host perf events which may be scheduled when VM-exit. But it
> will not tell the idx of the counters which can only be got when the
> host event is really scheduled.
>
> > I have to look into the details. But
> > at the time of VMEXIT, kvm should already have that information, so it
> > can immediately decide whether to do the PMU context switch or not.
> >
> > oh, but when the control is executing within the run loop, a
> > host-level profiling starts, say 'perf record -a ...', it will
> > generate an IPI to all CPUs. Maybe that's when we need a callback so
> > the KVM guest PMU context gets preempted for the host-level profiling.
> > Gah..
> >
> > hmm, not a fan of that. That means the host can poke the guest PMU
> > context at any time and cause higher overhead. But I admit it is much
> > better than the current approach.
> >
> > The only thing is that: any command like 'perf record/stat -a' shot in
> > dark corners of the host can preempt guest PMUs of _all_ running VMs.
> > So, to alleviate that, maybe a module parameter that disables this
> > "preemption" is possible? This should fit scenarios where we don't
> > want guest PMU to be preempted outside of the vCPU loop?
> >
>
> It should not happen. For the current implementation, perf rejects all
> the !exclude_guest system-wide event creation if a guest with the vPMU
> is running.
> However, it's possible to create an exclude_guest system-wide event at
> any time. KVM cannot use the information from the VM-entry to decide if
> there will be active perf events in the VM-exit.

Hmm, why not? If there is any exclude_guest system-wide event,
perf_guest_enter() can return something to tell KVM "hey, some active
host events are swapped out. they are originally in counter #2 and
#3". If so, at the time when perf_guest_enter() returns, KVM will ack
that and keep it in its pmu data structure.

Now, when doing context switching back to host at just VMEXIT, KVM
will check this data and see if host perf context has something active
(of course, they are all exclude_guest events). If not, deferring the
context switch to vcpu boundary. Otherwise, do the proper PMU context
switching by respecting the occupied counter positions on the host
side, i.e., avoid doubling the work on the KVM side.

Kan, any suggestion on the above approach? Totally understand that
there might be some difficulty, since perf subsystem works in several
layers and obviously fetching low-level mapping is arch specific work.
If that is difficult, we can split the work in two phases: 1) phase
#1, just ask perf to tell kvm if there are active exclude_guest events
swapped out; 2) phase #2, ask perf to tell their (low-level) counter
indices.

Thanks.
-Mingwei

>
> The perf_guest_exit() will reload the host state. It's impossible to
> save the guest state after that. We may need a KVM callback. So perf can
> tell KVM whether to save the guest state before perf reloads the host sta=
te.
>
> Thanks,
> Kan
> >>
> >>
> >>>
> >>> My original sketch: https://lore.kernel.org/all/ZR3eNtP5IVAHeFNC@goog=
lecom
> >

