Return-Path: <kvm+bounces-14674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C87958A5813
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 18:45:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E1FF1F22A96
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 16:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2218286A;
	Mon, 15 Apr 2024 16:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EZLoD7XH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB19C78C90
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 16:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713199525; cv=none; b=hDxxMOHMn6p2uWhuTLWe2NFz1iNWDREHIKTB6Ugz/WyYGXI7y0K33b/LJ00FvV8d7kzIXtvrHQcyvpsASnOYNXmFMCRdLkULMWTH/dZQSTbJQ+3TwpYDoW7FRxEQkwA5LAtBTGj/9j3392LHrkZI0U3TgQ9HpLixQCStr+uBK6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713199525; c=relaxed/simple;
	bh=z7REmhzopffrfEb5EpBXG8pv1dB7QSKXzzdb+Bcd26Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ugws8EHojgKjk+hZQgavqCNx9afxf9cWwLCbNNT8vEhPAWgD74/1sfhUT/0fvce0Yo0uD2g41wq5F/PrUy3/CeDtnQdqXNvHToOJ4JJ0S8cM8XAbAUjUJfxxW8IeKGh+e3hQZrNSmsfnXfsqKUfkV0uyI4wPvGLnRcdgAE0hikI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EZLoD7XH; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-518bad5f598so2044902e87.2
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 09:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713199522; x=1713804322; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/KhD9KfHwX7IX6Wrg2MRL7/a7LRnOwbZXhvbxH+MaQ=;
        b=EZLoD7XHemjf1D8iOb431mEcQaa4MRr0/1sf0MCyw30Vojwn7G+lCjKsnkcYNF4vU8
         ipouaTZ6oz27yQDXEEsW2OYJqP0jIMzWJ328fzVKAMZ9vof9Tt9+iOOIq6rYfGfvA/kA
         hU5dNy5WNjf8KjanbHu4aTkY9Xj+7tfzf2nW52OXfwJLqdShb3tAtPlQ8GuruCGAhheN
         6YEwE5NAwtDlvIXh79aItETvp6ce3p4zZPdQqRMgEpoGbq0ofLtdclpe53H7kYT2GBdZ
         Vj0GoM6vBu6YUudkSo8Gj2w+172WWdRxwPey4+Mna5yfKuHLBnV+7Is5FyG1tgwqJeWV
         04fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713199522; x=1713804322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f/KhD9KfHwX7IX6Wrg2MRL7/a7LRnOwbZXhvbxH+MaQ=;
        b=Z81bw5hAQ4etGvm2lgYdwR1C8xGUETgTEreaVToe3J7BooGect3tWhGVxZNGeUZ/1Z
         7tV9aQ1bwdjwcb4JoiFPsylzKikmnjCtOBYGNEcrXSaL23dAwnEeRNx3ES6RlXyasLaL
         LcssYiMFYCRM7D1fP3IHGRXBWU2KFtBtckLpGAmIsTAyb/WaEg6d1BvOd3la2CHeV8Jl
         HLsLpg0PN71rcH1dSBP/9I6KkkIrbcIqImRc3FR5eIIiZITncMX0lAkfN49AFCVjcl0E
         HHZ/E4u+aF9RiHNA9iG7e5Jw8pG0XS9uK8YLJ1mv82Q6PXo33ZKWoXZL/qkAdL5vCRF4
         B/VA==
X-Forwarded-Encrypted: i=1; AJvYcCXfzrO/IGCsclhRK6BSoy4s5kGKDfIEXsiBsIRHNHNsEPKsRktp9nTvY6qaySzSqLT5gg4XQM/2jE155PTfObIReK1C
X-Gm-Message-State: AOJu0Ywv/H8uoXU5LS6JABoEZNuGC5ivgE/Vx1Lw1xoY9eid3ykRRzVP
	Lyye0GozEhtxvidHwu8sM1OjRYPOhsjZgdZnOni/dlO2GmrZvHXqsWGSthPRaxZNx4zzvjMXzdX
	RC0w5lMMbvr+7IrQD5cohCnVqSO0adWsE/q9H
X-Google-Smtp-Source: AGHT+IEcBD8O1qMrT7A92+Ydq3Sto26jxXW+0RuDsdMTKnmJALnhCB284OCiAeunirCqxNaVBDcxQvXd+kj7ZYSGKsA=
X-Received: by 2002:a19:3805:0:b0:516:a8f6:3863 with SMTP id
 f5-20020a193805000000b00516a8f63863mr6831908lfa.30.1713199521580; Mon, 15 Apr
 2024 09:45:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-24-xiong.y.zhang@linux.intel.com> <ZhhZush_VOEnimuw@google.com>
 <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com> <Zhn9TGOiXxcV5Epx@google.com>
 <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com> <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com>
In-Reply-To: <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Mon, 15 Apr 2024 09:44:45 -0700
Message-ID: <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	pbonzini@redhat.com, peterz@infradead.org, kan.liang@intel.com, 
	zhenyuw@linux.intel.com, jmattson@google.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com, 
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 3:04=E2=80=AFAM Mi, Dapeng <dapeng1.mi@linux.intel.=
com> wrote:
>
>
> On 4/15/2024 2:06 PM, Mingwei Zhang wrote:
> > On Fri, Apr 12, 2024 at 9:25=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.in=
tel.com> wrote:
> >>
> >> On 4/13/2024 11:34 AM, Mingwei Zhang wrote:
> >>> On Sat, Apr 13, 2024, Mi, Dapeng wrote:
> >>>> On 4/12/2024 5:44 AM, Sean Christopherson wrote:
> >>>>> On Fri, Jan 26, 2024, Xiong Zhang wrote:
> >>>>>> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >>>>>>
> >>>>>> Implement the save/restore of PMU state for pasthrough PMU in Inte=
l. In
> >>>>>> passthrough mode, KVM owns exclusively the PMU HW when control flo=
w goes to
> >>>>>> the scope of passthrough PMU. Thus, KVM needs to save the host PMU=
 state
> >>>>>> and gains the full HW PMU ownership. On the contrary, host regains=
 the
> >>>>>> ownership of PMU HW from KVM when control flow leaves the scope of
> >>>>>> passthrough PMU.
> >>>>>>
> >>>>>> Implement PMU context switches for Intel CPUs and opptunistically =
use
> >>>>>> rdpmcl() instead of rdmsrl() when reading counters since the forme=
r has
> >>>>>> lower latency in Intel CPUs.
> >>>>>>
> >>>>>> Co-developed-by: Mingwei Zhang <mizhang@google.com>
> >>>>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> >>>>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >>>>>> ---
> >>>>>>     arch/x86/kvm/vmx/pmu_intel.c | 73 ++++++++++++++++++++++++++++=
++++++++
> >>>>>>     1 file changed, 73 insertions(+)
> >>>>>>
> >>>>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_i=
ntel.c
> >>>>>> index 0d58fe7d243e..f79bebe7093d 100644
> >>>>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
> >>>>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> >>>>>> @@ -823,10 +823,83 @@ void intel_passthrough_pmu_msrs(struct kvm_v=
cpu *vcpu)
> >>>>>>     static void intel_save_pmu_context(struct kvm_vcpu *vcpu)
> >>>>> I would prefer there be a "guest" in there somewhere, e.g. intel_sa=
ve_guest_pmu_context().
> >>>> Yeah. It looks clearer.
> >>>>>>     {
> >>>>>> +  struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> >>>>>> +  struct kvm_pmc *pmc;
> >>>>>> +  u32 i;
> >>>>>> +
> >>>>>> +  if (pmu->version !=3D 2) {
> >>>>>> +          pr_warn("only PerfMon v2 is supported for passthrough P=
MU");
> >>>>>> +          return;
> >>>>>> +  }
> >>>>>> +
> >>>>>> +  /* Global ctrl register is already saved at VM-exit. */
> >>>>>> +  rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
> >>>>>> +  /* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero.=
 */
> >>>>>> +  if (pmu->global_status)
> >>>>>> +          wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_statu=
s);
> >>>>>> +
> >>>>>> +  for (i =3D 0; i < pmu->nr_arch_gp_counters; i++) {
> >>>>>> +          pmc =3D &pmu->gp_counters[i];
> >>>>>> +          rdpmcl(i, pmc->counter);
> >>>>>> +          rdmsrl(i + MSR_ARCH_PERFMON_EVENTSEL0, pmc->eventsel);
> >>>>>> +          /*
> >>>>>> +           * Clear hardware PERFMON_EVENTSELx and its counter to =
avoid
> >>>>>> +           * leakage and also avoid this guest GP counter get acc=
identally
> >>>>>> +           * enabled during host running when host enable global =
ctrl.
> >>>>>> +           */
> >>>>>> +          if (pmc->eventsel)
> >>>>>> +                  wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
> >>>>>> +          if (pmc->counter)
> >>>>>> +                  wrmsrl(MSR_IA32_PMC0 + i, 0);
> >>>>> This doesn't make much sense.  The kernel already has full access t=
o the guest,
> >>>>> I don't see what is gained by zeroing out the MSRs just to hide the=
m from perf.
> >>>> It's necessary to clear the EVENTSELx MSRs for both GP and fixed cou=
nters.
> >>>> Considering this case, Guest uses GP counter 2, but Host doesn't use=
 it. So
> >>>> if the EVENTSEL2 MSR is not cleared here, the GP counter 2 would be =
enabled
> >>>> unexpectedly on host later since Host perf always enable all validat=
e bits
> >>>> in PERF_GLOBAL_CTRL MSR. That would cause issues.
> >>>>
> >>>> Yeah,  the clearing for PMCx MSR should be unnecessary .
> >>>>
> >>> Why is clearing for PMCx MSR unnecessary? Do we want to leaking count=
er
> >>> values to the host? NO. Not in cloud usage.
> >> No, this place is clearing the guest counter value instead of host
> >> counter value. Host always has method to see guest value in a normal V=
M
> >> if he want. I don't see its necessity, it's just a overkill and
> >> introduce extra overhead to write MSRs.
> >>
> > I am curious how the perf subsystem solves the problem? Does perf
> > subsystem in the host only scrubbing the selector but not the counter
> > value when doing the context switch?
>
> When context switch happens, perf code would schedule out the old events
> and schedule in the new events. When scheduling out, the ENABLE bit of
> EVENTSELx MSR would be cleared, and when scheduling in, the EVENTSELx
> and PMCx MSRs would be overwritten with new event's attr.config and
> sample_period separately.  Of course, these is only for the case when
> there are new events to be programmed on the PMC. If no new events, the
> PMCx MSR would keep stall value and won't be cleared.
>
> Anyway, I don't see any reason that PMCx MSR must be cleared.
>

I don't have a strong opinion on the upstream version. But since both
the mediated vPMU and perf are clients of PMU HW, leaving PMC values
uncleared when transition out of the vPMU boundary is leaking info
technically.

Alternatively, doing the clearing at vcpu loop boundary should be
sufficient if considering performance overhead.

Thanks
-Mingwei
>
>
> >
> >>> Please make changes to this patch with **extreme** caution.
> >>>
> >>> According to our past experience, if there is a bug somewhere,
> >>> there is a catch here (normally).
> >>>
> >>> Thanks.
> >>> -Mingwei
> >>>>> Similarly, if perf enables a counter if PERF_GLOBAL_CTRL without fi=
rst restoring
> >>>>> the event selector, we gots problems.
> >>>>>
> >>>>> Same thing for the fixed counters below.  Can't this just be?
> >>>>>
> >>>>>      for (i =3D 0; i < pmu->nr_arch_gp_counters; i++)
> >>>>>              rdpmcl(i, pmu->gp_counters[i].counter);
> >>>>>
> >>>>>      for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++)
> >>>>>              rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i,
> >>>>>                     pmu->fixed_counters[i].counter);
> >>>>>
> >>>>>> +  }
> >>>>>> +
> >>>>>> +  rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> >>>>>> +  /*
> >>>>>> +   * Clear hardware FIXED_CTR_CTRL MSR to avoid information leaka=
ge and
> >>>>>> +   * also avoid these guest fixed counters get accidentially enab=
led
> >>>>>> +   * during host running when host enable global ctrl.
> >>>>>> +   */
> >>>>>> +  if (pmu->fixed_ctr_ctrl)
> >>>>>> +          wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> >>>>>> +  for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> >>>>>> +          pmc =3D &pmu->fixed_counters[i];
> >>>>>> +          rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i, pmc->counter);
> >>>>>> +          if (pmc->counter)
> >>>>>> +                  wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
> >>>>>> +  }
> >>>>>>     }
> >>>>>>     static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
> >>>>>>     {
> >>>>>> +  struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> >>>>>> +  struct kvm_pmc *pmc;
> >>>>>> +  u64 global_status;
> >>>>>> +  int i;
> >>>>>> +
> >>>>>> +  if (pmu->version !=3D 2) {
> >>>>>> +          pr_warn("only PerfMon v2 is supported for passthrough P=
MU");
> >>>>>> +          return;
> >>>>>> +  }
> >>>>>> +
> >>>>>> +  /* Clear host global_ctrl and global_status MSR if non-zero. */
> >>>>>> +  wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> >>>>> Why?  PERF_GLOBAL_CTRL will be auto-loaded at VM-Enter, why do it n=
ow?
> >>>> As previous comments say, host perf always enable all counters in
> >>>> PERF_GLOBAL_CTRL by default. The reason to clear PERF_GLOBAL_CTRL he=
re is to
> >>>> ensure all counters in disabled state and the later counter manipula=
tion
> >>>> (writing MSR) won't cause any race condition or unexpected behavior =
on HW.
> >>>>
> >>>>
> >>>>>> +  rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
> >>>>>> +  if (global_status)
> >>>>>> +          wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status);
> >>>>> This seems especially silly, isn't the full MSR being written below=
?  Or am I
> >>>>> misunderstanding how these things work?
> >>>> I think Jim's comment has already explain why we need to do this.
> >>>>
> >>>>>> +  wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status);
> >>>>>> +
> >>>>>> +  for (i =3D 0; i < pmu->nr_arch_gp_counters; i++) {
> >>>>>> +          pmc =3D &pmu->gp_counters[i];
> >>>>>> +          wrmsrl(MSR_IA32_PMC0 + i, pmc->counter);
> >>>>>> +          wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, pmc->eventsel);
> >>>>>> +  }
> >>>>>> +
> >>>>>> +  wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> >>>>>> +  for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> >>>>>> +          pmc =3D &pmu->fixed_counters[i];
> >>>>>> +          wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, pmc->counter);
> >>>>>> +  }
> >>>>>>     }
> >>>>>>     struct kvm_pmu_ops intel_pmu_ops __initdata =3D {
> >>>>>> --
> >>>>>> 2.34.1
> >>>>>>

