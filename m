Return-Path: <kvm+bounces-16971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BAA98BF63B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F99428AA8A
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D5618651;
	Wed,  8 May 2024 06:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZdKnLhl0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F47171A2;
	Wed,  8 May 2024 06:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715149674; cv=none; b=Op7mpaANPUBPvkiwrRgZF9nZVZbMiVnSms35m3/7DwFet5LcOTthiyOInnqqKzXSIByPPBPqMOQaaw6OG1AO3VRuE/cVI13emX4u38R+ryl/ECjLqgSCH8/muXwClHU76fjOoBEGGa+dOrCYzpG5yaW/ycwcitJq8ytFNZf/HLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715149674; c=relaxed/simple;
	bh=SRdSWoGxwc2/ZbcZujDPJNT4qWG4QjJ6L+NyNtSaN54=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J+DLLXKQyqJvIlNW5IrzMxNnUb0MmYK92QjB3rla7TSB3M2kck3OU4EYX5GZLwkiGtmo4Y512H8vmE4NfBIqUP+mtdRCjWsSGHC9Nm+AJvhyDk3+zZhoGwFfr5koAklQ2XmLwvQ9v4Ub0TLx7pzQEV1LCx0jUj4wIEt+2+i5RjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZdKnLhl0; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715149672; x=1746685672;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SRdSWoGxwc2/ZbcZujDPJNT4qWG4QjJ6L+NyNtSaN54=;
  b=ZdKnLhl07AImnc3lceqOVPFx+IoGnNDMY0h5BHqhz/kWWCCNwLEKC1df
   i6WH1TSMyGtgyslQXhLbX+AZvPd+iyCXWKDAUawGTGU1RBtzaDj5HXQsk
   YFrTqBINd+f6dSpB1Lf0ZU/N+rbWf7N5ERmZe1uZCB09xQAgdhtnURIW2
   5E0Ye3p7XvpRuIoBFZW4lZAwmngCfYv+ghsIgKJIZMUwLeKaTnBpurBDz
   Q8FEoTaHrNRhYp9hjPbkh9hTo6igK6eOyfucC8F4JsKSVcJZOXmf9bIHb
   7/ntBzXnpVJ0gpdBj27A+xf7s3mwfUrxsmJiPxZn8TX0MflApZ2ot6f+B
   A==;
X-CSE-ConnectionGUID: V9Cj0zhqQWezigXarULbfQ==
X-CSE-MsgGUID: OgRvmr2VQ2aGq9BvEYd6Zw==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11111214"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="11111214"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 23:27:52 -0700
X-CSE-ConnectionGUID: 5gWhoNniS2uImUH2RYZkgw==
X-CSE-MsgGUID: eCACEudSTXqwIWvevVd+tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="28873958"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 23:27:46 -0700
Message-ID: <fbb8306c-775b-4f00-a2a6-a0b17c8f038e@linux.intel.com>
Date: Wed, 8 May 2024 14:27:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/54] KVM: x86/pmu: Always set global enable bits in
 passthrough mode
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-18-mizhang@google.com>
 <3eb01add-3776-46a8-87f7-54144692d7d7@linux.intel.com>
 <CAL715WL80ZOtAo2mT95_zW9Xhv-qOqnPjLGPMp1bJKZ1dOxhTg@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CAL715WL80ZOtAo2mT95_zW9Xhv-qOqnPjLGPMp1bJKZ1dOxhTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 5/8/2024 12:36 PM, Mingwei Zhang wrote:
> On Tue, May 7, 2024 at 9:19 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>> On 5/6/2024 1:29 PM, Mingwei Zhang wrote:
>>> From: Sandipan Das <sandipan.das@amd.com>
>>>
>>> Currently, the global control bits for a vcpu are restored to the reset
>>> state only if the guest PMU version is less than 2. This works for
>>> emulated PMU as the MSRs are intercepted and backing events are created
>>> for and managed by the host PMU [1].
>>>
>>> If such a guest in run with passthrough PMU, the counters no longer work
>>> because the global enable bits are cleared. Hence, set the global enable
>>> bits to their reset state if passthrough PMU is used.
>>>
>>> A passthrough-capable host may not necessarily support PMU version 2 and
>>> it can choose to restore or save the global control state from struct
>>> kvm_pmu in the PMU context save and restore helpers depending on the
>>> availability of the global control register.
>>>
>>> [1] 7b46b733bdb4 ("KVM: x86/pmu: Set enable bits for GP counters in PERF_GLOBAL_CTRL at "RESET"");
>>> Reported-by: Mingwei Zhang <mizhang@google.com>
>>> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
>>> [removed the fixes tag]
>>> ---
>>>  arch/x86/kvm/pmu.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>>> index 5768ea2935e9..e656f72fdace 100644
>>> --- a/arch/x86/kvm/pmu.c
>>> +++ b/arch/x86/kvm/pmu.c
>>> @@ -787,7 +787,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>>>        * in the global controls).  Emulate that behavior when refreshing the
>>>        * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
>>>        */
>>> -     if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters)
>>> +     if ((pmu->passthrough || kvm_pmu_has_perf_global_ctrl(pmu)) && pmu->nr_arch_gp_counters)
>> The logic seems not correct. we could support perfmon version 1 for
>> meidated vPMU (passthrough vPMU) as well in the future.  pmu->passthrough
>> is ture doesn't guarantee GLOBAL_CTRL MSR always exists.
> heh, the logic is correct here. However, I would say the code change
> may not reflect that clearly.
>
> The if condition combines the handling of global ctrl registers for
> both the legacy vPMU and the mediated passthrough vPMU.
>
> In legacy pmu, the logic should be this:
>
> if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters)
>
> Because, since KVM emulates the MSR, if the global ctrl register does
> not exist, then there is no point resetting it to any value. However,
> if it does exist, there are non-zero number of GP counters, we should
> reset it to some value (all enabling bits are set for GP counters)
> according to SDM.
>
> The logic for mediated passthrough PMU is different as follows:
>
> if (pmu->passthrough && pmu->nr_arch_gp_counters)
>
> Since mediated passthrough PMU requires PerfMon v4 in Intel (PerfMon
> v2 in AMD), once it is enabled (pmu->passthrough = true), then global
> ctrl _must_ exist phyiscally. Regardless of whether we expose it to
> the guest VM, at reset time, we need to ensure enabling bits for GP
> counters are set (behind the screen). This is critical for AMD, since
> most of the guests are usually in (AMD) PerfMon v1 in which global
> ctrl MSR is inaccessible, but does exist and is operating in HW.
>
> Yes, if we eliminate that requirement (pmu->passthrough -> Perfmon v4
> Intel / Perfmon v2 AMD), then this code will have to change. However,
Yeah, that's what I'm worrying about. We ever discussed to support mediated
vPMU on HW below perfmon v4. When someone implements this, he may not
notice this place needs to be changed as well, this introduces a potential
bug and we should avoid this.
> that is currently not in our RFCv2.
>
> Thanks.
> -Mingwei
>
>
>
>
>
>
>
>>
>>>               pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
>>>  }
>>>

