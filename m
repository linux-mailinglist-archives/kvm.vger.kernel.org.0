Return-Path: <kvm+bounces-14620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73FD08A47C1
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 08:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F41411F22596
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 06:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CAE48F47;
	Mon, 15 Apr 2024 06:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a+aSBhI9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6335672
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 06:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713161217; cv=none; b=RO2XhX/8zwuhrgZnLLYHcb6GUm9FASKZvTCyHVNBFtCU3O/cwKeFD/AeohdEYUsDIa+lQoJjlZQGSE8xo5IDSj2nb+dmfIj/DXm5U+yn7YOMadW4f1m9m2Zq66wE+TBwmzlq/xZYhmtonYbqf9pTYmoWFbtOEB7jemVMy5FkWIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713161217; c=relaxed/simple;
	bh=3EAFvzTo5E1mM9qXtkWc8kM9COIu5o/1Z/0f/58YETo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jtieeiMHzgSR/nN824JWAUWMzT08kZLfCgfKYiGjDKbz+TOd0jG+YHtEGmUAdmQ2W7lxELsSPlGjcxa1q0VaVtTbzCBtrdPuUeZJMnnhMH9T3TtMtY90+AImttxfs4YhHBwR/JpgrhVrT8UpIZ/oEsU9aHaoJ8Y8rV75MDT1Keo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a+aSBhI9; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-56e48d0a632so4439681a12.2
        for <kvm@vger.kernel.org>; Sun, 14 Apr 2024 23:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713161214; x=1713766014; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMah3Z+s/W6m3gGpZYndkJ0SsrEXyOIm46Gptw1+MBQ=;
        b=a+aSBhI9DR3wfhJ9rpaB83gdIMJReqMLlM+xyfr3ANAnkZ8Xff1kQGSVTQTban++rA
         c4OeJgzboECgdN/BKw7oedi+3AusuBAuqFwKJE2SWyvdzE1yv/4FB7IU1vmFBAoLw4tl
         Ayynl1X8V+2bjkF6IaoH+1JInAMQH0eAC/RB5hHgXubaziRh8K+2+jTantbkDcF3MmxN
         k6VLmAMyrtlVG5t4Y8ye5gK84ZiOzdBrKn95wt57RnnyP9ey53f7kGIjepyWw8mkSo76
         898WDU//p0//E7tjZ1jaAXSaIMl/yAJ7VFnZwI41CZPveMvHtlF8NOFBy6+hqYvzP1t4
         JHgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713161214; x=1713766014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oMah3Z+s/W6m3gGpZYndkJ0SsrEXyOIm46Gptw1+MBQ=;
        b=jgVBV1Ik64bUuP1yEBAUxITlE/h48gWZ9NeQeNDvpuJVTM16coSw4pr9qu40M86aXQ
         NNJfC01K2qJ5L8rhCp+VAHdL1iO9vw1yxHbMGlZ7pfi9ujXVelGnHY1LmGP6Nx7c5BDE
         XfSRHe2RrbBkMWFT70Z6I79JLYb/8DMDvH1z5lWMKgZuwy8U+lmLQixoPRPaED3lcSS0
         ZH0HFfisqKpeQkxa6fZ7WRTweE2NXwVmp9UufukqgaEDaRtowjU2btxndyo6cQXmKSpF
         Gq+9lHvbAIGcay98zbqDSeslIsfZeCJ1trjLxq61VoB0PmvxfMAcR1YAX18330q89DaF
         NKnw==
X-Forwarded-Encrypted: i=1; AJvYcCXkbWQnERqLFPsgEhTVIWlYu1FtWfA6rQlovZ0avlAcFDSrgbea1Gcb1EmQQxM1htI1XbNOzLvHb/PYqAbXxU3ntPzd
X-Gm-Message-State: AOJu0YxByKR/0GYiNSKvMZJXSEleaUQ93kyco7bwT+WAe9zWneyKnaLS
	zlgXqXTOeuoQ0KW7lOBltEpFWVbHkZKIbTzsIDY1vNzU6Kx6BdQzWtz3C4WK0BRvIYapc92KCnf
	2Da7tWu2IpmBJc4KxqBE/mW+ebDgsktDmVaI2
X-Google-Smtp-Source: AGHT+IHJAqbWPW2717RHqDNgb5rrvvCaP9K8UNMsM2be7EeoZcszVgwUYcSsaHg32Lh2LwEcCGXqDDSzueTz6HKpMlk=
X-Received: by 2002:a17:906:752:b0:a52:3adc:b779 with SMTP id
 z18-20020a170906075200b00a523adcb779mr6933768ejb.17.1713161213799; Sun, 14
 Apr 2024 23:06:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-24-xiong.y.zhang@linux.intel.com> <ZhhZush_VOEnimuw@google.com>
 <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com> <Zhn9TGOiXxcV5Epx@google.com>
 <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
In-Reply-To: <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Sun, 14 Apr 2024 23:06:17 -0700
Message-ID: <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
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

On Fri, Apr 12, 2024 at 9:25=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.intel.=
com> wrote:
>
>
> On 4/13/2024 11:34 AM, Mingwei Zhang wrote:
> > On Sat, Apr 13, 2024, Mi, Dapeng wrote:
> >> On 4/12/2024 5:44 AM, Sean Christopherson wrote:
> >>> On Fri, Jan 26, 2024, Xiong Zhang wrote:
> >>>> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >>>>
> >>>> Implement the save/restore of PMU state for pasthrough PMU in Intel.=
 In
> >>>> passthrough mode, KVM owns exclusively the PMU HW when control flow =
goes to
> >>>> the scope of passthrough PMU. Thus, KVM needs to save the host PMU s=
tate
> >>>> and gains the full HW PMU ownership. On the contrary, host regains t=
he
> >>>> ownership of PMU HW from KVM when control flow leaves the scope of
> >>>> passthrough PMU.
> >>>>
> >>>> Implement PMU context switches for Intel CPUs and opptunistically us=
e
> >>>> rdpmcl() instead of rdmsrl() when reading counters since the former =
has
> >>>> lower latency in Intel CPUs.
> >>>>
> >>>> Co-developed-by: Mingwei Zhang <mizhang@google.com>
> >>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> >>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >>>> ---
> >>>>    arch/x86/kvm/vmx/pmu_intel.c | 73 +++++++++++++++++++++++++++++++=
+++++
> >>>>    1 file changed, 73 insertions(+)
> >>>>
> >>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_int=
el.c
> >>>> index 0d58fe7d243e..f79bebe7093d 100644
> >>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
> >>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> >>>> @@ -823,10 +823,83 @@ void intel_passthrough_pmu_msrs(struct kvm_vcp=
u *vcpu)
> >>>>    static void intel_save_pmu_context(struct kvm_vcpu *vcpu)
> >>> I would prefer there be a "guest" in there somewhere, e.g. intel_save=
_guest_pmu_context().
> >> Yeah. It looks clearer.
> >>>>    {
> >>>> +  struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> >>>> +  struct kvm_pmc *pmc;
> >>>> +  u32 i;
> >>>> +
> >>>> +  if (pmu->version !=3D 2) {
> >>>> +          pr_warn("only PerfMon v2 is supported for passthrough PMU=
");
> >>>> +          return;
> >>>> +  }
> >>>> +
> >>>> +  /* Global ctrl register is already saved at VM-exit. */
> >>>> +  rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
> >>>> +  /* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. *=
/
> >>>> +  if (pmu->global_status)
> >>>> +          wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status)=
;
> >>>> +
> >>>> +  for (i =3D 0; i < pmu->nr_arch_gp_counters; i++) {
> >>>> +          pmc =3D &pmu->gp_counters[i];
> >>>> +          rdpmcl(i, pmc->counter);
> >>>> +          rdmsrl(i + MSR_ARCH_PERFMON_EVENTSEL0, pmc->eventsel);
> >>>> +          /*
> >>>> +           * Clear hardware PERFMON_EVENTSELx and its counter to av=
oid
> >>>> +           * leakage and also avoid this guest GP counter get accid=
entally
> >>>> +           * enabled during host running when host enable global ct=
rl.
> >>>> +           */
> >>>> +          if (pmc->eventsel)
> >>>> +                  wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
> >>>> +          if (pmc->counter)
> >>>> +                  wrmsrl(MSR_IA32_PMC0 + i, 0);
> >>> This doesn't make much sense.  The kernel already has full access to =
the guest,
> >>> I don't see what is gained by zeroing out the MSRs just to hide them =
from perf.
> >> It's necessary to clear the EVENTSELx MSRs for both GP and fixed count=
ers.
> >> Considering this case, Guest uses GP counter 2, but Host doesn't use i=
t. So
> >> if the EVENTSEL2 MSR is not cleared here, the GP counter 2 would be en=
abled
> >> unexpectedly on host later since Host perf always enable all validate =
bits
> >> in PERF_GLOBAL_CTRL MSR. That would cause issues.
> >>
> >> Yeah,  the clearing for PMCx MSR should be unnecessary .
> >>
> > Why is clearing for PMCx MSR unnecessary? Do we want to leaking counter
> > values to the host? NO. Not in cloud usage.
>
> No, this place is clearing the guest counter value instead of host
> counter value. Host always has method to see guest value in a normal VM
> if he want. I don't see its necessity, it's just a overkill and
> introduce extra overhead to write MSRs.
>

I am curious how the perf subsystem solves the problem? Does perf
subsystem in the host only scrubbing the selector but not the counter
value when doing the context switch?

>
> >
> > Please make changes to this patch with **extreme** caution.
> >
> > According to our past experience, if there is a bug somewhere,
> > there is a catch here (normally).
> >
> > Thanks.
> > -Mingwei
> >>> Similarly, if perf enables a counter if PERF_GLOBAL_CTRL without firs=
t restoring
> >>> the event selector, we gots problems.
> >>>
> >>> Same thing for the fixed counters below.  Can't this just be?
> >>>
> >>>     for (i =3D 0; i < pmu->nr_arch_gp_counters; i++)
> >>>             rdpmcl(i, pmu->gp_counters[i].counter);
> >>>
> >>>     for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++)
> >>>             rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i,
> >>>                    pmu->fixed_counters[i].counter);
> >>>
> >>>> +  }
> >>>> +
> >>>> +  rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> >>>> +  /*
> >>>> +   * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage=
 and
> >>>> +   * also avoid these guest fixed counters get accidentially enable=
d
> >>>> +   * during host running when host enable global ctrl.
> >>>> +   */
> >>>> +  if (pmu->fixed_ctr_ctrl)
> >>>> +          wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> >>>> +  for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> >>>> +          pmc =3D &pmu->fixed_counters[i];
> >>>> +          rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i, pmc->counter);
> >>>> +          if (pmc->counter)
> >>>> +                  wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
> >>>> +  }
> >>>>    }
> >>>>    static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
> >>>>    {
> >>>> +  struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> >>>> +  struct kvm_pmc *pmc;
> >>>> +  u64 global_status;
> >>>> +  int i;
> >>>> +
> >>>> +  if (pmu->version !=3D 2) {
> >>>> +          pr_warn("only PerfMon v2 is supported for passthrough PMU=
");
> >>>> +          return;
> >>>> +  }
> >>>> +
> >>>> +  /* Clear host global_ctrl and global_status MSR if non-zero. */
> >>>> +  wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> >>> Why?  PERF_GLOBAL_CTRL will be auto-loaded at VM-Enter, why do it now=
?
> >> As previous comments say, host perf always enable all counters in
> >> PERF_GLOBAL_CTRL by default. The reason to clear PERF_GLOBAL_CTRL here=
 is to
> >> ensure all counters in disabled state and the later counter manipulati=
on
> >> (writing MSR) won't cause any race condition or unexpected behavior on=
 HW.
> >>
> >>
> >>>> +  rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
> >>>> +  if (global_status)
> >>>> +          wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status);
> >>> This seems especially silly, isn't the full MSR being written below? =
 Or am I
> >>> misunderstanding how these things work?
> >> I think Jim's comment has already explain why we need to do this.
> >>
> >>>> +  wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status);
> >>>> +
> >>>> +  for (i =3D 0; i < pmu->nr_arch_gp_counters; i++) {
> >>>> +          pmc =3D &pmu->gp_counters[i];
> >>>> +          wrmsrl(MSR_IA32_PMC0 + i, pmc->counter);
> >>>> +          wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, pmc->eventsel);
> >>>> +  }
> >>>> +
> >>>> +  wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> >>>> +  for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> >>>> +          pmc =3D &pmu->fixed_counters[i];
> >>>> +          wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, pmc->counter);
> >>>> +  }
> >>>>    }
> >>>>    struct kvm_pmu_ops intel_pmu_ops __initdata =3D {
> >>>> --
> >>>> 2.34.1
> >>>>

