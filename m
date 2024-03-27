Return-Path: <kvm+bounces-12773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D68188D9A7
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:55:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C387298C8E
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 08:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4587383BC;
	Wed, 27 Mar 2024 08:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VuzKOcNQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4846436AFE;
	Wed, 27 Mar 2024 08:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711529671; cv=none; b=H9Kza/e87gMDMy/kX3CoqDXpm2ftDzjTYxELVj22gjQtuhNPwpuVkc6EXg8VJAvx5YJjWnPPN8YCq5dCwokE7la1GuzPN1/mxaMgLny5s0c2NRYuMy/Cu0q3GjDvftCNP9hN2LFfb03aQ3ym4xhHo0U9iuyKOCF/HRtz7Eg7PHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711529671; c=relaxed/simple;
	bh=SgpzKo6HLMQEjZmUiiMRhMUEOtW2adAqo3vdC7W24+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FM6hFlW97mYmAeATPdFvsVr3RguRC4ztNly+o4viN02Lm83g6y21ULJNmoR10PTTyThpJTpTMmHs1qIrH46EibzFi8ie5Ujx+ekGyHQnDEG15J+Yi3zKSfqDo8J/CcqwtDC1rWaE2CpiDbw81HLFUytivk5cwjG4df/o1bXIHUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VuzKOcNQ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711529669; x=1743065669;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SgpzKo6HLMQEjZmUiiMRhMUEOtW2adAqo3vdC7W24+U=;
  b=VuzKOcNQxgt0DBcRJziYefSNXAA0u36iDSiWnh1i+fn9BJeLbjRrn3AJ
   WNNh/iDls7/OzKzYFKIqsQaDtU+NXl+JaR8MBt9X07TFA07R3biiFCoM+
   nxm0vzf9faAatIcm7Mu2rVTdAEc06YElltXgjtJPXyCJ7xLLznLWMsm1r
   W036mArk3OtYxzxmMgzz6FZLzCMpLvCOHPBSCEVyvP+743skILXyPYL7E
   8gZ6iav4OzHPn+jE+xB8gxON6JKOeNSL/WGvgMN0bYqzDw01QC3mKSOFC
   34IYcg/2CLdreeXqShNZUWGL9IWb9NOV8k/xbwUaSx0oi3UMcSNp5NNyc
   g==;
X-CSE-ConnectionGUID: 5bgsL15SSAu57/FwAy8prA==
X-CSE-MsgGUID: slmwq82xR6ChJKoh417MpA==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="29094230"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="29094230"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 01:54:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="16612483"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.242.198]) ([10.125.242.198])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 01:54:25 -0700
Message-ID: <c838c85e-c448-4f83-a79f-deb20c6aaf90@linux.intel.com>
Date: Wed, 27 Mar 2024 16:54:22 +0800
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
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZgOwVvTVlvk3iN3x@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/27/2024 1:36 PM, Mingwei Zhang wrote:
> On Wed, Jan 03, 2024, Dapeng Mi wrote:
>> When running pmu test on SPR, sometimes the following failure is
>> reported.
>>
>> PMU version:         2
>> GP counters:         8
>> GP counter width:    48
>> Mask length:         8
>> Fixed counters:      3
>> Fixed counter width: 48
>> 1000000 <= 55109398 <= 50000000
>> FAIL: Intel: core cycles-0
>> 1000000 <= 18279571 <= 50000000
>> PASS: Intel: core cycles-1
>> 1000000 <= 12238092 <= 50000000
>> PASS: Intel: core cycles-2
>> 1000000 <= 7981727 <= 50000000
>> PASS: Intel: core cycles-3
>> 1000000 <= 6984711 <= 50000000
>> PASS: Intel: core cycles-4
>> 1000000 <= 6773673 <= 50000000
>> PASS: Intel: core cycles-5
>> 1000000 <= 6697842 <= 50000000
>> PASS: Intel: core cycles-6
>> 1000000 <= 6747947 <= 50000000
>> PASS: Intel: core cycles-7
>>
>> The count of the "core cycles" on first counter would exceed the upper
>> boundary and leads to a failure, and then the "core cycles" count would
>> drop gradually and reach a stable state.
>>
>> That looks reasonable. The "core cycles" event is defined as the 1st
>> event in xxx_gp_events[] array and it is always verified at first.
>> when the program loop() is executed at the first time it needs to warm
>> up the pipeline and cache, such as it has to wait for cache is filled.
>> All these warm-up work leads to a quite large core cycles count which
>> may exceeds the verification range.
>>
>> The event "instructions" instead of "core cycles" is a good choice as
>> the warm-up event since it would always return a fixed count. Thus
>> switch instructions and core cycles events sequence in the
>> xxx_gp_events[] array.
> The observation is great. However, it is hard to agree that we fix the
> problem by switching the order. Maybe directly tweaking the N from 50 to
> a larger value makes more sense.
>
> Thanks.
> -Mingwei

yeah, a larger upper boundary can fix the fault as well, but the 
question is how large it would be enough. For different CPU model, the 
needed cycles could be different for warming up. So we may have to set a 
quite large upper boundary but a large boundary would decrease 
credibility of this validation. Not sure which one is better. Any inputs 
from other ones?


>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>   x86/pmu.c | 16 ++++++++--------
>>   1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index a42fff8d8b36..67ebfbe55b49 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -31,16 +31,16 @@ struct pmu_event {
>>   	int min;
>>   	int max;
>>   } intel_gp_events[] = {
>> -	{"core cycles", 0x003c, 1*N, 50*N},
>>   	{"instructions", 0x00c0, 10*N, 10.2*N},
>> +	{"core cycles", 0x003c, 1*N, 50*N},
>>   	{"ref cycles", 0x013c, 1*N, 30*N},
>>   	{"llc references", 0x4f2e, 1, 2*N},
>>   	{"llc misses", 0x412e, 1, 1*N},
>>   	{"branches", 0x00c4, 1*N, 1.1*N},
>>   	{"branch misses", 0x00c5, 0, 0.1*N},
>>   }, amd_gp_events[] = {
>> -	{"core cycles", 0x0076, 1*N, 50*N},
>>   	{"instructions", 0x00c0, 10*N, 10.2*N},
>> +	{"core cycles", 0x0076, 1*N, 50*N},
>>   	{"branches", 0x00c2, 1*N, 1.1*N},
>>   	{"branch misses", 0x00c3, 0, 0.1*N},
>>   }, fixed_events[] = {
>> @@ -307,7 +307,7 @@ static void check_counter_overflow(void)
>>   	int i;
>>   	pmu_counter_t cnt = {
>>   		.ctr = MSR_GP_COUNTERx(0),
>> -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
>> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel /* instructions */,
>>   	};
>>   	overflow_preset = measure_for_overflow(&cnt);
>>   
>> @@ -365,11 +365,11 @@ static void check_gp_counter_cmask(void)
>>   {
>>   	pmu_counter_t cnt = {
>>   		.ctr = MSR_GP_COUNTERx(0),
>> -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
>> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel /* instructions */,
>>   	};
>>   	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
>>   	measure_one(&cnt);
>> -	report(cnt.count < gp_events[1].min, "cmask");
>> +	report(cnt.count < gp_events[0].min, "cmask");
>>   }
>>   
>>   static void do_rdpmc_fast(void *ptr)
>> @@ -446,7 +446,7 @@ static void check_running_counter_wrmsr(void)
>>   	uint64_t count;
>>   	pmu_counter_t evt = {
>>   		.ctr = MSR_GP_COUNTERx(0),
>> -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
>> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel,
>>   	};
>>   
>>   	report_prefix_push("running counter wrmsr");
>> @@ -455,7 +455,7 @@ static void check_running_counter_wrmsr(void)
>>   	loop();
>>   	wrmsr(MSR_GP_COUNTERx(0), 0);
>>   	stop_event(&evt);
>> -	report(evt.count < gp_events[1].min, "cntr");
>> +	report(evt.count < gp_events[0].min, "cntr");
>>   
>>   	/* clear status before overflow test */
>>   	if (this_cpu_has_perf_global_status())
>> @@ -493,7 +493,7 @@ static void check_emulated_instr(void)
>>   	pmu_counter_t instr_cnt = {
>>   		.ctr = MSR_GP_COUNTERx(1),
>>   		/* instructions */
>> -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
>> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel,
>>   	};
>>   	report_prefix_push("emulated instruction");
>>   
>> -- 
>> 2.34.1
>>

