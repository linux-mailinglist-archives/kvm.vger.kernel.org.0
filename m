Return-Path: <kvm+bounces-12993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA01E88FC7C
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 11:09:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDD7A1C27AF4
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 10:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A537BB1C;
	Thu, 28 Mar 2024 10:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hiDYjDdc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2963D7D081;
	Thu, 28 Mar 2024 10:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711620569; cv=none; b=qy5MBRcAjhp1o24I0fydco5Bt+6k/teZMv+Kok4OATLg+TiYSg1iSeWD1q2HGKG+l4Zpq1QV4nzis7SGy+1JLQfe4pjAzmnd5cJPAADjGdPrg+MZQRmHHZV6MBUxVhgVNZyxt/kqmxWpwYTUsmJS+bEnNcm1KsBN6mmyNNEgc9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711620569; c=relaxed/simple;
	bh=vWXeQU2KQO42RPmw/5gfcrKLDwqxa+yTVOBVA9d+7Jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ohHUCwIwz3/Ddmbf2b23hKTrKCbENOBTjJpqcWZiFkdHx72eb/sTvjQganP8zgCGGY7C59TKPrY+T9CAYw9GZ86T0JUj8snGc6xXRg37TgygSOou65bAsXHXUnc2K8xB9jpI6Kg4hTZJWHmTO51deXC6jO3Gula3Wqm/vL6vGFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hiDYjDdc; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711620567; x=1743156567;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vWXeQU2KQO42RPmw/5gfcrKLDwqxa+yTVOBVA9d+7Jo=;
  b=hiDYjDdcRAzSwJi60fI2LzFOZtr9Vyad3QbULwUBnDbrHTjbL58uvr+O
   p5vqeslBMjju34eT03zxrGF+yzitwUzlcWGUNdq4Ue288ya3PqlyDsBjm
   Eu+HY9WvNAQeZt5va6Sj2Ua3Jcj6CVp7p+J4gq8O4IDvNBL3yFv/QiM/I
   KNSCjU4E3LG4ZoxgzpZFSfLMOxLEBIGVrJ48el16Lnu2ZbhQZY6vCKuH+
   tBDZ+2Rwf1blXpa/ybXHxi0OQ79VnCcsD2hV2SYUm16A9KWgd20j8UknG
   11E7vp7Jm224YKwXVLP1LYLwJ/0eapz093gI0waC/Uc4WzoB0SM5t9AIv
   A==;
X-CSE-ConnectionGUID: gR8vQ817Rba2RpoFp+XlzQ==
X-CSE-MsgGUID: FvvGUwmhQ0y90fPjtBaKEQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6622487"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="6622487"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 03:09:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="21322227"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.242.198]) ([10.125.242.198])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 03:09:23 -0700
Message-ID: <e230e2e2-9b51-4ad7-bbc5-a90e6d169e92@linux.intel.com>
Date: Thu, 28 Mar 2024 18:09:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 04/11] x86: pmu: Switch instructions and
 core cycles events sequence
Content-Language: en-US
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong
 <xiong.y.zhang@intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-5-dapeng1.mi@linux.intel.com>
 <ZgOwVvTVlvk3iN3x@google.com>
 <c838c85e-c448-4f83-a79f-deb20c6aaf90@linux.intel.com>
 <ZgRSBITQNIRIgu8N@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZgRSBITQNIRIgu8N@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/28/2024 1:06 AM, Mingwei Zhang wrote:
> On Wed, Mar 27, 2024, Mi, Dapeng wrote:
>> On 3/27/2024 1:36 PM, Mingwei Zhang wrote:
>>> On Wed, Jan 03, 2024, Dapeng Mi wrote:
>>>> When running pmu test on SPR, sometimes the following failure is
>>>> reported.
>>>>
>>>> PMU version:         2
>>>> GP counters:         8
>>>> GP counter width:    48
>>>> Mask length:         8
>>>> Fixed counters:      3
>>>> Fixed counter width: 48
>>>> 1000000 <= 55109398 <= 50000000
>>>> FAIL: Intel: core cycles-0
>>>> 1000000 <= 18279571 <= 50000000
>>>> PASS: Intel: core cycles-1
>>>> 1000000 <= 12238092 <= 50000000
>>>> PASS: Intel: core cycles-2
>>>> 1000000 <= 7981727 <= 50000000
>>>> PASS: Intel: core cycles-3
>>>> 1000000 <= 6984711 <= 50000000
>>>> PASS: Intel: core cycles-4
>>>> 1000000 <= 6773673 <= 50000000
>>>> PASS: Intel: core cycles-5
>>>> 1000000 <= 6697842 <= 50000000
>>>> PASS: Intel: core cycles-6
>>>> 1000000 <= 6747947 <= 50000000
>>>> PASS: Intel: core cycles-7
>>>>
>>>> The count of the "core cycles" on first counter would exceed the upper
>>>> boundary and leads to a failure, and then the "core cycles" count would
>>>> drop gradually and reach a stable state.
>>>>
>>>> That looks reasonable. The "core cycles" event is defined as the 1st
>>>> event in xxx_gp_events[] array and it is always verified at first.
>>>> when the program loop() is executed at the first time it needs to warm
>>>> up the pipeline and cache, such as it has to wait for cache is filled.
>>>> All these warm-up work leads to a quite large core cycles count which
>>>> may exceeds the verification range.
>>>>
>>>> The event "instructions" instead of "core cycles" is a good choice as
>>>> the warm-up event since it would always return a fixed count. Thus
>>>> switch instructions and core cycles events sequence in the
>>>> xxx_gp_events[] array.
>>> The observation is great. However, it is hard to agree that we fix the
>>> problem by switching the order. Maybe directly tweaking the N from 50 to
>>> a larger value makes more sense.
>>>
>>> Thanks.
>>> -Mingwei
>> yeah, a larger upper boundary can fix the fault as well, but the question is
>> how large it would be enough. For different CPU model, the needed cycles
>> could be different for warming up. So we may have to set a quite large upper
>> boundary but a large boundary would decrease credibility of this validation.
>> Not sure which one is better. Any inputs from other ones?
>>
> Just checked with an expert from our side, so "core cycles" (0x003c)
> is affected the current CPU state/frequency, ie., its counting value
> could vary largely. In that sense, "warming" up seems reasonable.
> However, switching the order would be a terrible idea for maintanence
> since people will forget it and the problem will come back.
>
>  From another perspective, "warming" up seems just a best effort. Nobody
> knows how warm is really warm. Besides, some systems might turn off some
> C-State and may set a cap on max turbo frequency. All of these will
> directly affect the warm-up process and the counting result of 0x003c.
>
> So, while adding a warm-up blob is reasonable, tweaking the heuristics
> seems to be same for me. Regarding the value, I think I will rely on
> your experiments and observation.

Per my understanding, most of extra cpu cycles should come from the warm 
up for cache. If we don't want to change the validation order,  it may 
be doable to add an extra warm-up phase before starting the validation. 
Thus we don't need to enlarge the upper boundary. It looks not a 
preferred way since it would decrease the credibility of the validation.

Let me try to add a warm-up phase first and check if it works as expect.


>
> Thanks.
> -Mingwei
>>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>>> ---
>>>>    x86/pmu.c | 16 ++++++++--------
>>>>    1 file changed, 8 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/x86/pmu.c b/x86/pmu.c
>>>> index a42fff8d8b36..67ebfbe55b49 100644
>>>> --- a/x86/pmu.c
>>>> +++ b/x86/pmu.c
>>>> @@ -31,16 +31,16 @@ struct pmu_event {
>>>>    	int min;
>>>>    	int max;
>>>>    } intel_gp_events[] = {
>>>> -	{"core cycles", 0x003c, 1*N, 50*N},
>>>>    	{"instructions", 0x00c0, 10*N, 10.2*N},
>>>> +	{"core cycles", 0x003c, 1*N, 50*N},
>>>>    	{"ref cycles", 0x013c, 1*N, 30*N},
>>>>    	{"llc references", 0x4f2e, 1, 2*N},
>>>>    	{"llc misses", 0x412e, 1, 1*N},
>>>>    	{"branches", 0x00c4, 1*N, 1.1*N},
>>>>    	{"branch misses", 0x00c5, 0, 0.1*N},
>>>>    }, amd_gp_events[] = {
>>>> -	{"core cycles", 0x0076, 1*N, 50*N},
>>>>    	{"instructions", 0x00c0, 10*N, 10.2*N},
>>>> +	{"core cycles", 0x0076, 1*N, 50*N},
>>>>    	{"branches", 0x00c2, 1*N, 1.1*N},
>>>>    	{"branch misses", 0x00c3, 0, 0.1*N},
>>>>    }, fixed_events[] = {
>>>> @@ -307,7 +307,7 @@ static void check_counter_overflow(void)
>>>>    	int i;
>>>>    	pmu_counter_t cnt = {
>>>>    		.ctr = MSR_GP_COUNTERx(0),
>>>> -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
>>>> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel /* instructions */,
>>>>    	};
>>>>    	overflow_preset = measure_for_overflow(&cnt);
>>>> @@ -365,11 +365,11 @@ static void check_gp_counter_cmask(void)
>>>>    {
>>>>    	pmu_counter_t cnt = {
>>>>    		.ctr = MSR_GP_COUNTERx(0),
>>>> -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
>>>> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel /* instructions */,
>>>>    	};
>>>>    	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
>>>>    	measure_one(&cnt);
>>>> -	report(cnt.count < gp_events[1].min, "cmask");
>>>> +	report(cnt.count < gp_events[0].min, "cmask");
>>>>    }
>>>>    static void do_rdpmc_fast(void *ptr)
>>>> @@ -446,7 +446,7 @@ static void check_running_counter_wrmsr(void)
>>>>    	uint64_t count;
>>>>    	pmu_counter_t evt = {
>>>>    		.ctr = MSR_GP_COUNTERx(0),
>>>> -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
>>>> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel,
>>>>    	};
>>>>    	report_prefix_push("running counter wrmsr");
>>>> @@ -455,7 +455,7 @@ static void check_running_counter_wrmsr(void)
>>>>    	loop();
>>>>    	wrmsr(MSR_GP_COUNTERx(0), 0);
>>>>    	stop_event(&evt);
>>>> -	report(evt.count < gp_events[1].min, "cntr");
>>>> +	report(evt.count < gp_events[0].min, "cntr");
>>>>    	/* clear status before overflow test */
>>>>    	if (this_cpu_has_perf_global_status())
>>>> @@ -493,7 +493,7 @@ static void check_emulated_instr(void)
>>>>    	pmu_counter_t instr_cnt = {
>>>>    		.ctr = MSR_GP_COUNTERx(1),
>>>>    		/* instructions */
>>>> -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
>>>> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel,
>>>>    	};
>>>>    	report_prefix_push("emulated instruction");
>>>> -- 
>>>> 2.34.1
>>>>

