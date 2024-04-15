Return-Path: <kvm+bounces-14636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 430D98A4C1E
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 12:04:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B02CB21F8A
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 10:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D944BA94;
	Mon, 15 Apr 2024 10:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LCgMo3Pg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E1D4594C;
	Mon, 15 Apr 2024 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713175483; cv=none; b=Lx6+ASPOyWlMuhbro7qQMwYh88DOT+BmnfrlxSfAnpcVr+07oXEniFObavBtDhxiEEpZVKNO5noLF2kUqErzP6e/0QHb52q85KJi/8L0A1/OrTS0UteBZ9iQN9iETTPADqptFJg5Y+feJjVc9ZOZzYkGBA9ovJ1o9n6Wk4Wf/1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713175483; c=relaxed/simple;
	bh=89vb5QzwZ/ZG05AU7pd6AXtGxsVZyOEg4lxXRQn8oZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fEjrH08g9Bc7+gr73WHBu9FoW0ClWhMlzBavjX0PZMtgMgwoXK6Ue+M2MESH+douNkcrVEvdoUyCkWuqUUmTHRk1ERnxDFPM6LuKOyPGonqmdkAxEW9FlFsAdQsU1oHda5In04BcY+JSlkE0WHDj2Nud1L/ulGqbpkFyNX4SRSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LCgMo3Pg; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713175481; x=1744711481;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=89vb5QzwZ/ZG05AU7pd6AXtGxsVZyOEg4lxXRQn8oZA=;
  b=LCgMo3PgznHPqyvi/BxP8dp8tIV+5Pil6a6EN41AYjKu6nJSQ3Mvt5Lv
   wrdFASMSQiYXhrbAMMiIUmP/DaDdr5ycgJ7hNtCweTX7JmzCkx27AoPAx
   9hHsERfH0um9DBH3U1rc8e09rhzS41b63kB8/dPnpdhL57LL+OUeswCgp
   YFaj2q8Gq4tUXh35+w4wri4qdqqKcg+pTgtTXtT1o3sgd/e0d7iSdshJ3
   ppjdPoQ25H0FpvVxsjVB1vxP/h2ByDIKETN+yjIk/3nqOsBJjfTO1ZwiL
   yKE4WkbnSoQkRP6fYYlop6qGMFdEZN12QceQkaA87hek24QuJs3JA0WMr
   A==;
X-CSE-ConnectionGUID: rk6EbyoQTNefplPvCoEFcA==
X-CSE-MsgGUID: cbyI5w0JRiO8uzWw3Ti6TQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11044"; a="8411084"
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="8411084"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 03:04:34 -0700
X-CSE-ConnectionGUID: CWjZk0Z6TjyBaXhJiN7xMA==
X-CSE-MsgGUID: 0NV4xBZsTg+EqaMCBph5TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="21867128"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 03:04:31 -0700
Message-ID: <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com>
Date: Mon, 15 Apr 2024 18:04:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
 <ZhhZush_VOEnimuw@google.com>
 <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
 <Zhn9TGOiXxcV5Epx@google.com>
 <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
 <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/15/2024 2:06 PM, Mingwei Zhang wrote:
> On Fri, Apr 12, 2024 at 9:25 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>> On 4/13/2024 11:34 AM, Mingwei Zhang wrote:
>>> On Sat, Apr 13, 2024, Mi, Dapeng wrote:
>>>> On 4/12/2024 5:44 AM, Sean Christopherson wrote:
>>>>> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>>>>>> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>>>>>
>>>>>> Implement the save/restore of PMU state for pasthrough PMU in Intel. In
>>>>>> passthrough mode, KVM owns exclusively the PMU HW when control flow goes to
>>>>>> the scope of passthrough PMU. Thus, KVM needs to save the host PMU state
>>>>>> and gains the full HW PMU ownership. On the contrary, host regains the
>>>>>> ownership of PMU HW from KVM when control flow leaves the scope of
>>>>>> passthrough PMU.
>>>>>>
>>>>>> Implement PMU context switches for Intel CPUs and opptunistically use
>>>>>> rdpmcl() instead of rdmsrl() when reading counters since the former has
>>>>>> lower latency in Intel CPUs.
>>>>>>
>>>>>> Co-developed-by: Mingwei Zhang <mizhang@google.com>
>>>>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>>>>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>>>>> ---
>>>>>>     arch/x86/kvm/vmx/pmu_intel.c | 73 ++++++++++++++++++++++++++++++++++++
>>>>>>     1 file changed, 73 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>>>>>> index 0d58fe7d243e..f79bebe7093d 100644
>>>>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>>>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>>>>> @@ -823,10 +823,83 @@ void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
>>>>>>     static void intel_save_pmu_context(struct kvm_vcpu *vcpu)
>>>>> I would prefer there be a "guest" in there somewhere, e.g. intel_save_guest_pmu_context().
>>>> Yeah. It looks clearer.
>>>>>>     {
>>>>>> +  struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>>>>> +  struct kvm_pmc *pmc;
>>>>>> +  u32 i;
>>>>>> +
>>>>>> +  if (pmu->version != 2) {
>>>>>> +          pr_warn("only PerfMon v2 is supported for passthrough PMU");
>>>>>> +          return;
>>>>>> +  }
>>>>>> +
>>>>>> +  /* Global ctrl register is already saved at VM-exit. */
>>>>>> +  rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
>>>>>> +  /* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. */
>>>>>> +  if (pmu->global_status)
>>>>>> +          wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
>>>>>> +
>>>>>> +  for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
>>>>>> +          pmc = &pmu->gp_counters[i];
>>>>>> +          rdpmcl(i, pmc->counter);
>>>>>> +          rdmsrl(i + MSR_ARCH_PERFMON_EVENTSEL0, pmc->eventsel);
>>>>>> +          /*
>>>>>> +           * Clear hardware PERFMON_EVENTSELx and its counter to avoid
>>>>>> +           * leakage and also avoid this guest GP counter get accidentally
>>>>>> +           * enabled during host running when host enable global ctrl.
>>>>>> +           */
>>>>>> +          if (pmc->eventsel)
>>>>>> +                  wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
>>>>>> +          if (pmc->counter)
>>>>>> +                  wrmsrl(MSR_IA32_PMC0 + i, 0);
>>>>> This doesn't make much sense.  The kernel already has full access to the guest,
>>>>> I don't see what is gained by zeroing out the MSRs just to hide them from perf.
>>>> It's necessary to clear the EVENTSELx MSRs for both GP and fixed counters.
>>>> Considering this case, Guest uses GP counter 2, but Host doesn't use it. So
>>>> if the EVENTSEL2 MSR is not cleared here, the GP counter 2 would be enabled
>>>> unexpectedly on host later since Host perf always enable all validate bits
>>>> in PERF_GLOBAL_CTRL MSR. That would cause issues.
>>>>
>>>> Yeah,  the clearing for PMCx MSR should be unnecessary .
>>>>
>>> Why is clearing for PMCx MSR unnecessary? Do we want to leaking counter
>>> values to the host? NO. Not in cloud usage.
>> No, this place is clearing the guest counter value instead of host
>> counter value. Host always has method to see guest value in a normal VM
>> if he want. I don't see its necessity, it's just a overkill and
>> introduce extra overhead to write MSRs.
>>
> I am curious how the perf subsystem solves the problem? Does perf
> subsystem in the host only scrubbing the selector but not the counter
> value when doing the context switch?

When context switch happens, perf code would schedule out the old events 
and schedule in the new events. When scheduling out, the ENABLE bit of 
EVENTSELx MSR would be cleared, and when scheduling in, the EVENTSELx 
and PMCx MSRs would be overwritten with new event's attr.config and 
sample_period separately.  Of course, these is only for the case when 
there are new events to be programmed on the PMC. If no new events, the 
PMCx MSR would keep stall value and won't be cleared.

Anyway, I don't see any reason that PMCx MSR must be cleared.



>
>>> Please make changes to this patch with **extreme** caution.
>>>
>>> According to our past experience, if there is a bug somewhere,
>>> there is a catch here (normally).
>>>
>>> Thanks.
>>> -Mingwei
>>>>> Similarly, if perf enables a counter if PERF_GLOBAL_CTRL without first restoring
>>>>> the event selector, we gots problems.
>>>>>
>>>>> Same thing for the fixed counters below.  Can't this just be?
>>>>>
>>>>>      for (i = 0; i < pmu->nr_arch_gp_counters; i++)
>>>>>              rdpmcl(i, pmu->gp_counters[i].counter);
>>>>>
>>>>>      for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
>>>>>              rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i,
>>>>>                     pmu->fixed_counters[i].counter);
>>>>>
>>>>>> +  }
>>>>>> +
>>>>>> +  rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
>>>>>> +  /*
>>>>>> +   * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
>>>>>> +   * also avoid these guest fixed counters get accidentially enabled
>>>>>> +   * during host running when host enable global ctrl.
>>>>>> +   */
>>>>>> +  if (pmu->fixed_ctr_ctrl)
>>>>>> +          wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>>>>>> +  for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>>>>>> +          pmc = &pmu->fixed_counters[i];
>>>>>> +          rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i, pmc->counter);
>>>>>> +          if (pmc->counter)
>>>>>> +                  wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
>>>>>> +  }
>>>>>>     }
>>>>>>     static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
>>>>>>     {
>>>>>> +  struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>>>>> +  struct kvm_pmc *pmc;
>>>>>> +  u64 global_status;
>>>>>> +  int i;
>>>>>> +
>>>>>> +  if (pmu->version != 2) {
>>>>>> +          pr_warn("only PerfMon v2 is supported for passthrough PMU");
>>>>>> +          return;
>>>>>> +  }
>>>>>> +
>>>>>> +  /* Clear host global_ctrl and global_status MSR if non-zero. */
>>>>>> +  wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>>>>> Why?  PERF_GLOBAL_CTRL will be auto-loaded at VM-Enter, why do it now?
>>>> As previous comments say, host perf always enable all counters in
>>>> PERF_GLOBAL_CTRL by default. The reason to clear PERF_GLOBAL_CTRL here is to
>>>> ensure all counters in disabled state and the later counter manipulation
>>>> (writing MSR) won't cause any race condition or unexpected behavior on HW.
>>>>
>>>>
>>>>>> +  rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
>>>>>> +  if (global_status)
>>>>>> +          wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status);
>>>>> This seems especially silly, isn't the full MSR being written below?  Or am I
>>>>> misunderstanding how these things work?
>>>> I think Jim's comment has already explain why we need to do this.
>>>>
>>>>>> +  wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status);
>>>>>> +
>>>>>> +  for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
>>>>>> +          pmc = &pmu->gp_counters[i];
>>>>>> +          wrmsrl(MSR_IA32_PMC0 + i, pmc->counter);
>>>>>> +          wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, pmc->eventsel);
>>>>>> +  }
>>>>>> +
>>>>>> +  wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
>>>>>> +  for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>>>>>> +          pmc = &pmu->fixed_counters[i];
>>>>>> +          wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, pmc->counter);
>>>>>> +  }
>>>>>>     }
>>>>>>     struct kvm_pmu_ops intel_pmu_ops __initdata = {
>>>>>> --
>>>>>> 2.34.1
>>>>>>

