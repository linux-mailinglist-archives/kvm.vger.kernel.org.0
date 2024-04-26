Return-Path: <kvm+bounces-16011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 660238B2EDB
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 05:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 601A31C21A53
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 03:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F34676033;
	Fri, 26 Apr 2024 03:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W/Dtl/6c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7CC757E0
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 03:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101161; cv=none; b=ORq4k0qZxqKHlj60NVw2U4h8T2M8ZUUcmx/EfdZKWRswDl19DqIBb5JDs52V1W2wQRlaZ5mqbCUPYlu10B22lU1qgyY2HufdUe/bKZPk/Q0xyy+eozrMpZT2Wva5W2Vc0VutIr3muPHIqEWXXhBR4hLinggC8r1nspB0OChOoRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101161; c=relaxed/simple;
	bh=N6nqUZWK/ft8y3k7S0i7d7O9JqPf9wUGqpFToio4O1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GzRhTKPW67yPn0fV1qNVY6fyBEGvvn0z73166tErGr/E+mUOtvdmO5txaK/xNpSthhQd1wVsj7O0JJQ34zZyq9+wpzmvpYnpbNvvfxKOR+x/kBf+k56IA0UKAlKSnLKSCLbhLMdEaI2l3qu+mMvuONGoISJKYuzFvRArg653mG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W/Dtl/6c; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a58c09e2187so113593766b.3
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 20:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714101158; x=1714705958; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0gollOxoKKyvw6fTGUWSlbVML5x5LO6G0o13LnZVH94=;
        b=W/Dtl/6c9K5+nqMJf1VOVmfaMOw1mHQ2yi976imO1DscrJB9QSSQeRuj2BHaIkFgTO
         epyn4IHKflJN1PNYbYnu6q0rLmIz5bw3hcDp1P9vTz7h8qOZlULfLVrM9+j0hX9e80zM
         bLd0uHkLoU+x8w7zIyJCVmvZOng4Ngi12OXNG/LpsPQUzCAC/oPBUqldiTJkOCYqQt4P
         flzVXaTvaGgqKHdvCTFH4DWLDQE3IqkTlka6SwRAT9k3sPYKmcDopqMUnmGSiDKG/UUm
         +iEK4gaVkV78mRgLRPn5dJGBQ41CrxXTCXX/Qn3+QnTJmI+uGfAcaGfqCi9gwZFMjYdO
         +a5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714101158; x=1714705958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0gollOxoKKyvw6fTGUWSlbVML5x5LO6G0o13LnZVH94=;
        b=GJaPs1rStivqabUVHqgpMHSt5ursW7T5258lnuJlmyDr+DAgirDdvNNmnUuXaQKAoC
         P/y0FrJzXrUykDqTi38sPz4VJL3ZLDN4Hviuib85wo3g/pJkhOBChk2P95/YE6mItwAu
         1j739ofV9XZ37nP0AAPydKFdhu3LFLOkv5U8EkoedQd+dfdvglXptivr9TwzJT4epKDZ
         AN6udAS4EIaw6xVuTWERbvJrEycuOKDD+KSRyhifQwlzm87qq45oDyg6pElaiUTSMuLr
         mriMsmfs7tKGhjUSXTn/Ck1TCD7GO6jEIkoACTuRSCWaFkvRPDCCvr1rnLi5ILoCTssw
         tkMA==
X-Forwarded-Encrypted: i=1; AJvYcCUBcTq9yZ8+iZRsuSEfk/qOWSwKPhkZuE9BjrjeuqYkrVNejxJQz3If5nKtYQjnQ5j/WTZHYI7GX0qTjGWstWA3w0zz
X-Gm-Message-State: AOJu0YyertfleILLkJWUZxRrlR065CU7soY1pyY8nnh/HUXnhUMQbaHn
	+KG7hvM6OBNB5pio0QCZItqXyYETwRChf0FK3dDuX2zXAJvLOS5+FsPLaKDIKQxwXQ1tkKKzmlr
	Dw6sP8XBRYy/9tQjoPKEZry42JZQSxLoUk3+v
X-Google-Smtp-Source: AGHT+IGDSRPovKtzouGSK3nDRKPqldE8VBP2zT0bWpeDyPOPWmuW7dXXtNaKlOcanQ+TJU3/GWyAZLHUToMGkHXfHtM=
X-Received: by 2002:a17:906:368e:b0:a58:7fa5:811f with SMTP id
 a14-20020a170906368e00b00a587fa5811fmr782902ejc.69.1714101157761; Thu, 25 Apr
 2024 20:12:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
 <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn> <CAL715W++maAt2Ujfvmu1pZKS4R5EmAPebTU_h9AB8aFbdLFrTQ@mail.gmail.com>
 <f843298c-db08-4fde-9887-13de18d960ac@linux.intel.com> <Zikeh2eGjwzDbytu@google.com>
 <7834a811-4764-42aa-8198-55c4556d947b@linux.intel.com> <CAL715WKh8VBJ-O50oqSnCqKPQo4Bor_aMnRZeS_TzJP3ja8-YQ@mail.gmail.com>
 <6af2da05-cb47-46f7-b129-08463bc9469b@linux.intel.com> <CAL715W+zeqKenPLP2Fm9u_BkGRKAk-mncsOxrg=EKs74qK5f1Q@mail.gmail.com>
 <42acf1fc-1603-4ac5-8a09-edae2d85963d@linux.intel.com> <ZirPGnSDUzD-iWwc@google.com>
 <77913327-2115-42b5-850a-04ef0581faa7@linux.intel.com>
In-Reply-To: <77913327-2115-42b5-850a-04ef0581faa7@linux.intel.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Thu, 25 Apr 2024 20:12:01 -0700
Message-ID: <CAL715WJCHJD_wcJ+r4TyWfvmk9uNT_kPy7Pt=CHkB-Sf0D4Rqw@mail.gmail.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Kan Liang <kan.liang@linux.intel.com>, 
	maobibo <maobibo@loongson.cn>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024 at 6:46=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.intel.=
com> wrote:
>
>
> On 4/26/2024 5:46 AM, Sean Christopherson wrote:
> > On Thu, Apr 25, 2024, Kan Liang wrote:
> >> On 2024-04-25 4:16 p.m., Mingwei Zhang wrote:
> >>> On Thu, Apr 25, 2024 at 9:13=E2=80=AFAM Liang, Kan <kan.liang@linux.i=
ntel.com> wrote:
> >>>> It should not happen. For the current implementation, perf rejects a=
ll
> >>>> the !exclude_guest system-wide event creation if a guest with the vP=
MU
> >>>> is running.
> >>>> However, it's possible to create an exclude_guest system-wide event =
at
> >>>> any time. KVM cannot use the information from the VM-entry to decide=
 if
> >>>> there will be active perf events in the VM-exit.
> >>> Hmm, why not? If there is any exclude_guest system-wide event,
> >>> perf_guest_enter() can return something to tell KVM "hey, some active
> >>> host events are swapped out. they are originally in counter #2 and
> >>> #3". If so, at the time when perf_guest_enter() returns, KVM will ack
> >>> that and keep it in its pmu data structure.
> >> I think it's possible that someone creates !exclude_guest event after
> > I assume you mean an exclude_guest=3D1 event?  Because perf should be i=
n a state
> > where it rejects exclude_guest=3D0 events.
>
> Suppose should be exclude_guest=3D1 event, the perf event without
> exclude_guest attribute would be blocked to create in the v2 patches
> which we are working on.
>
>
> >
> >> the perf_guest_enter(). The stale information is saved in the KVM. Per=
f
> >> will schedule the event in the next perf_guest_exit(). KVM will not kn=
ow it.
> > Ya, the creation of an event on a CPU that currently has guest PMU stat=
e loaded
> > is what I had in mind when I suggested a callback in my sketch:
> >
> >   :  D. Add a perf callback that is invoked from IRQ context when perf =
wants to
> >   :     configure a new PMU-based events, *before* actually programming=
 the MSRs,
> >   :     and have KVM's callback put the guest PMU state
>
>
> when host creates a perf event with exclude_guest attribute which is
> used to profile KVM/VMM user space, the vCPU process could work at three
> places.
>
> 1. in guest state (non-root mode)
>
> 2. inside vcpu-loop
>
> 3. outside vcpu-loop
>
> Since the PMU state has already been switched to host state, we don't
> need to consider the case 3 and only care about cases 1 and 2.
>
> when host creates a perf event with exclude_guest attribute to profile
> KVM/VMM user space,  an IPI is triggered to enable the perf event
> eventually like the following code shows.
>
> event_function_call(event, __perf_event_enable, NULL);
>
> For case 1,  a vm-exit is triggered and KVM starts to process the
> vm-exit and then run IPI irq handler, exactly speaking
> __perf_event_enable() to enable the perf event.
>
> For case 2, the IPI irq handler would preempt the vcpu-loop and call
> __perf_event_enable() to enable the perf event.
>
> So IMO KVM just needs to provide a callback to switch guest/host PMU
> state, and __perf_event_enable() calls this callback before really
> touching PMU MSRs.

ok, in this case, do we still need KVM to query perf if there are
active exclude_guest events? yes? Because there is an ordering issue.
The above suggests that the host-level perf profiling comes when a VM
is already running, there is an IPI that can invoke the callback and
trigger preemption. In this case, KVM should switch the context from
guest to host. What if it is the other way around, ie., host-level
profiling runs first and then VM runs?

In this case, just before entering the vcpu loop, kvm should check
whether there is an active host event and save that into a pmu data
structure. If none, do the context switch early (so that KVM saves a
huge amount of unnecessary PMU context switches in the future).
Otherwise, keep the host PMU context until vm-enter. At the time of
vm-exit, do the check again using the data stored in pmu structure. If
there is an active event do the context switch to the host PMU,
otherwise defer that until exiting the vcpu loop. Of course, in the
meantime, if there is any perf profiling started causing the IPI, the
irq handler calls the callback, preempting the guest PMU context. If
that happens, at the time of exiting the vcpu boundary, PMU context
switch is skipped since it is already done. Of course, note that the
irq could come at any time, so the PMU context switch in all 4
locations need to check the state flag (and skip the context switch if
needed).

So this requires vcpu->pmu has two pieces of state information: 1) the
flag similar to TIF_NEED_FPU_LOAD; 2) host perf context info (phase #1
just a boolean; phase #2, bitmap of occupied counters).

This is a non-trivial optimization on the PMU context switch. I am
thinking about splitting them into the following phases:

1) lazy PMU context switch, i.e., wait until the guest touches PMU MSR
for the 1st time.
2) fast PMU context switch on KVM side, i.e., KVM checking event
selector value (enable/disable) and selectively switch PMU state
(reducing rd/wr msrs)
3) dynamic PMU context boundary, ie., KVM can dynamically choose PMU
context switch boundary depending on existing active host-level
events.
3.1) more accurate dynamic PMU context switch, ie., KVM checking
host-level counter position and further reduces the number of msr
accesses.
4) guest PMU context preemption, i.e., any new host-level perf
profiling can immediately preempt the guest PMU in the vcpu loop
(instead of waiting for the next PMU context switch in KVM).

Thanks.
-Mingwei
>
> >
> > It's a similar idea to TIF_NEED_FPU_LOAD, just that instead of a common=
 chunk of
> > kernel code swapping out the guest state (kernel_fpu_begin()), it's a c=
allback
> > into KVM.

