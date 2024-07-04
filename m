Return-Path: <kvm+bounces-20955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB519275D7
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 14:21:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFD83281C8A
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 12:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4171AE866;
	Thu,  4 Jul 2024 12:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h3JHz1DA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEBE1AE842;
	Thu,  4 Jul 2024 12:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720095684; cv=none; b=itTpTZ25CEQIfhd0Yz1rFuxK7CHl09Ib8AGJan9x1H8sB6xBWVLyX7A+BwgxlWvBG2yKNwRtb01EoDK7nhnF8VHkCfgCQQcCdHuZqDMJu2968rYsiKR/BVpbM82KKT2Bxf+ocKuKBx/YWutlIAUH3JLyXoG5LdjiqZiexlJtO/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720095684; c=relaxed/simple;
	bh=XtcAzSjR7cd/L8cGrfT98oaBS5Sbc/RdMZNnzv7jvnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BsRZOerwy5Ln8l90tjR7IGAsbJon4GGoDadK1bQxImJCV9UoFm1mgZ1+bW5odePiAwf053jpdjrlWSID2GFLuqAlkZi1UKY+pgtPoF7qVMTaxwOgkTRJ2hLh8j+qywgWeo7hWMCi2Kah9LtfVUaGixanWJqN9xrydIsPMfr+v04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h3JHz1DA; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720095683; x=1751631683;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XtcAzSjR7cd/L8cGrfT98oaBS5Sbc/RdMZNnzv7jvnY=;
  b=h3JHz1DAm2zU6EIVl20+jt+xdrjqbUEtjazWQp09JT7egEbAEdQ94mx/
   zKTELhjaoP+vT1E4L/KnDmkqNSk0MrVG4dF+Vm1H+eQ07QrdTrCfNsUu7
   8wH/lI/D21+6/afg1DBRHFBcroKcq2Xfn/C9eNTM3bPb0mcLn4YeeWvnB
   +FP5m8lC9hxz0fIaXlJ0Ah+avdV2CnV/8YxGHO6gGNWKjpUdPX3endSAG
   zalYgNGI6ZaDiMVfvIZUCeGWL37jxKos9PRR/2xEB4L+Ify7k2zwIoPK7
   Qp+BQtOIVtJFBctk8BpQrj8qiRfMU4NelY4rUJFy4r3rBq6YNc2oWDOEY
   A==;
X-CSE-ConnectionGUID: ZPK/4WSDTB6BF20p7IOBGw==
X-CSE-MsgGUID: dapSDcGbRCmP7UNkqnPmQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="17208566"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="17208566"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 05:21:22 -0700
X-CSE-ConnectionGUID: d5d2AiCISYqk15aa3/AURw==
X-CSE-MsgGUID: k2s/5gstQf6paHkwtZ7jXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51022379"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.1]) ([10.124.225.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 05:21:18 -0700
Message-ID: <a00be0fa-1dbc-4873-85f9-958f5ea0ad7a@linux.intel.com>
Date: Thu, 4 Jul 2024 20:21:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v5 12/18] x86: pmu: Improve instruction and branches
 events verification
To: Sandipan Das <sandipan.das@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang
 <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 ravi.bangoria@amd.com, manali.shukla@amd.com,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
 <20240703095712.64202-13-dapeng1.mi@linux.intel.com>
 <6d512a14-ace1-41a3-801e-0beb41425734@amd.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <6d512a14-ace1-41a3-801e-0beb41425734@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 7/4/2024 4:02 PM, Sandipan Das wrote:
> On 7/3/2024 3:27 PM, Dapeng Mi wrote:
>> If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are moved in
>> __precise_count_loop(). Thus, instructions and branches events can be
>> verified against a precise count instead of a rough range.
>>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>  x86/pmu.c | 31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index d005e376..ffb7b4a4 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -19,6 +19,11 @@
>>  #define EXPECTED_INSTR 17
>>  #define EXPECTED_BRNCH 5
>>  
>> +
>> +/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
>> +#define EXTRA_INSTRNS  (3 + 3)
>> +#define LOOP_INSTRNS   (N * 10 + EXTRA_INSTRNS)
>> +#define LOOP_BRANCHES  (N)
>>  #define LOOP_ASM(_wrmsr)						\
>>  	_wrmsr "\n\t"							\
>>  	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
>> @@ -122,6 +127,24 @@ static inline void loop(u64 cntrs)
>>  		__precise_loop(cntrs);
>>  }
>>  
>> +static void adjust_events_range(struct pmu_event *gp_events,
>> +				int instruction_idx, int branch_idx)
>> +{
>> +	/*
>> +	 * If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are
>> +	 * moved in __precise_loop(). Thus, instructions and branches events
>> +	 * can be verified against a precise count instead of a rough range.
>> +	 */
>> +	if (this_cpu_has_perf_global_ctrl()) {
> This causes some intermittent failures on AMD processors using PerfMonV2
> due to variance in counts. This probably has to do with the way instructions
> leading to a VM-Entry or VM-Exit are accounted when counting retired
> instructions and branches. Adding the following change makes all the tests
> pass again.

Thanks to verify on AMD platforms. Would add it in next version.


>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 0658a1c1..09a34a3f 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -222,7 +222,7 @@ static void adjust_events_range(struct pmu_event *gp_events,
>          * moved in __precise_loop(). Thus, instructions and branches events
>          * can be verified against a precise count instead of a rough range.
>          */
> -       if (this_cpu_has_perf_global_ctrl()) {
> +       if (pmu.is_intel && this_cpu_has_perf_global_ctrl()) {
>                 /* instructions event */
>                 gp_events[instruction_idx].min = LOOP_INSTRNS;
>                 gp_events[instruction_idx].max = LOOP_INSTRNS;
>
>
>> +		/* instructions event */
>> +		gp_events[instruction_idx].min = LOOP_INSTRNS;
>> +		gp_events[instruction_idx].max = LOOP_INSTRNS;
>> +		/* branches event */
>> +		gp_events[branch_idx].min = LOOP_BRANCHES;
>> +		gp_events[branch_idx].max = LOOP_BRANCHES;
>> +	}
>> +}
>> +
>>  volatile uint64_t irq_received;
>>  
>>  static void cnt_overflow(isr_regs_t *regs)
>> @@ -823,6 +846,9 @@ static void check_invalid_rdpmc_gp(void)
>>  
>>  int main(int ac, char **av)
>>  {
>> +	int instruction_idx;
>> +	int branch_idx;
>> +
>>  	setup_vm();
>>  	handle_irq(PMI_VECTOR, cnt_overflow);
>>  	buf = malloc(N*64);
>> @@ -836,13 +862,18 @@ int main(int ac, char **av)
>>  		}
>>  		gp_events = (struct pmu_event *)intel_gp_events;
>>  		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
>> +		instruction_idx = INTEL_INSTRUCTIONS_IDX;
>> +		branch_idx = INTEL_BRANCHES_IDX;
>>  		report_prefix_push("Intel");
>>  		set_ref_cycle_expectations();
>>  	} else {
>>  		gp_events_size = sizeof(amd_gp_events)/sizeof(amd_gp_events[0]);
>>  		gp_events = (struct pmu_event *)amd_gp_events;
>> +		instruction_idx = AMD_INSTRUCTIONS_IDX;
>> +		branch_idx = AMD_BRANCHES_IDX;
>>  		report_prefix_push("AMD");
>>  	}
>> +	adjust_events_range(gp_events, instruction_idx, branch_idx);
>>  
>>  	printf("PMU version:         %d\n", pmu.version);
>>  	printf("GP counters:         %d\n", pmu.nr_gp_counters);
>

