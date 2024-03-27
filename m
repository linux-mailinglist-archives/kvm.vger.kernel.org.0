Return-Path: <kvm+bounces-12775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A2FF88D9B1
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 10:00:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF1B02A35A1
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE5336B1C;
	Wed, 27 Mar 2024 08:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JWd1Be/q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4242C848;
	Wed, 27 Mar 2024 08:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711529993; cv=none; b=mX90NY99Qq71uZ5PZVP0fq/YKNCDfiPR56g3JPLq2BXHWN0SkexFaMT5tB9QWA/XMj3tUkLuQIqORwJrP+ZG9KwB3A3rzNopYciJgpd6oRANKsYCncTq0nCRb0QIbJ/63l1hsD13qShqfOWTsS8pygeHZr0aunoWx5f/+YW0mkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711529993; c=relaxed/simple;
	bh=WLIsSI+VhFmHS6tbRm8BpmGWkv9BnRYxiJK4qGOfgys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kNuh4Q4eYTkhAd8M9pJ8iDF6y21ZgCsMWcUB3k9+bj4Qqa0FwP2GFNgAB67Q4I+zAj44gq9rROoXq8Z1959q3P9n+7Xk8xPpcTDqEPW3NXG45dG7MsOB5At6HHONIwE3DzrUVMd2DCcxKrqTRnfx5KO+m9eg1iNFOIKxviS5tWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JWd1Be/q; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711529992; x=1743065992;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WLIsSI+VhFmHS6tbRm8BpmGWkv9BnRYxiJK4qGOfgys=;
  b=JWd1Be/qsDMSlsxubDOauAIF8wQtoc605wdxVAyombALRhFQ7XY5kPy9
   XDZJkRobIOWjavWuaZmW53Hami5MNT1S0QNwJe+Ys6MrcJZJz+3NsbFrg
   P/Hc7hINzxY16e4lkX4fAm03y98sqV67OFQ31go82VLUri2LsvRlxJtow
   EoDTkhNSuXiUpPiCJdbTEjQjra3I/Y4otAlYDUPQscpnf8+WjpDyl0QbB
   6quHxtQtC3ygB+DwPJ7r+LoGqdpTCU13lrNcAZTDgGLze9S/+F365S7/+
   mTnlO1/BaS7zZ4l5o7YOaoMJihi+t6KZBy/IYMCxgRR+onZS2IxB644c2
   Q==;
X-CSE-ConnectionGUID: JUyp63mlQs66Da7esRJcnA==
X-CSE-MsgGUID: lNFtdONGRZyg8T0At72eCg==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="32060939"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="32060939"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 01:59:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="47429133"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.242.198]) ([10.125.242.198])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 01:59:48 -0700
Message-ID: <499e600b-147e-4b8c-9133-80f3f8e87742@linux.intel.com>
Date: Wed, 27 Mar 2024 16:59:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 08/11] x86: pmu: Improve instruction and
 branches events verification
Content-Language: en-US
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong
 <xiong.y.zhang@intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-9-dapeng1.mi@linux.intel.com>
 <ZgO5YgWK3eX-zlgc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZgO5YgWK3eX-zlgc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/27/2024 2:14 PM, Mingwei Zhang wrote:
> On Wed, Jan 03, 2024, Dapeng Mi wrote:
>> If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are moved in
>> __precise_count_loop(). Thus, instructions and branches events can be
>> verified against a precise count instead of a rough range.
>>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>   x86/pmu.c | 26 ++++++++++++++++++++++++++
>>   1 file changed, 26 insertions(+)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 88b89ad889b9..b764827c1c3d 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -25,6 +25,10 @@
>>   	"nop; nop; nop; nop; nop; nop; nop;\n\t"	\
>>   	"loop 1b;\n\t"
>>   
>> +/*Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
>> +#define PRECISE_EXTRA_INSTRNS  (2 + 4)
>> +#define PRECISE_LOOP_INSTRNS   (N * LOOP_INSTRNS + PRECISE_EXTRA_INSTRNS)
>> +#define PRECISE_LOOP_BRANCHES  (N)
>>   #define PRECISE_LOOP_ASM						\
>>   	"wrmsr;\n\t"							\
>>   	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
>> @@ -107,6 +111,24 @@ static inline void loop(u64 cntrs)
>>   		__precise_count_loop(cntrs);
>>   }
>>   
>> +static void adjust_events_range(struct pmu_event *gp_events, int branch_idx)
>> +{
>> +	/*
>> +	 * If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are
>> +	 * moved in __precise_count_loop(). Thus, instructions and branches
>> +	 * events can be verified against a precise count instead of a rough
>> +	 * range.
>> +	 */
>> +	if (this_cpu_has_perf_global_ctrl()) {
>> +		/* instructions event */
>> +		gp_events[0].min = PRECISE_LOOP_INSTRNS;
>> +		gp_events[0].max = PRECISE_LOOP_INSTRNS;
>> +		/* branches event */
>> +		gp_events[branch_idx].min = PRECISE_LOOP_BRANCHES;
>> +		gp_events[branch_idx].max = PRECISE_LOOP_BRANCHES;
>> +	}
>> +}
>> +
>>   volatile uint64_t irq_received;
>>   
>>   static void cnt_overflow(isr_regs_t *regs)
>> @@ -771,6 +793,7 @@ static void check_invalid_rdpmc_gp(void)
>>   
>>   int main(int ac, char **av)
>>   {
>> +	int branch_idx;
>>   	setup_vm();
>>   	handle_irq(PMI_VECTOR, cnt_overflow);
>>   	buf = malloc(N*64);
>> @@ -784,13 +807,16 @@ int main(int ac, char **av)
>>   		}
>>   		gp_events = (struct pmu_event *)intel_gp_events;
>>   		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
>> +		branch_idx = 5;
> This (and the follow up one) hardcoded index is hacky and more
> importantly, error prone especially when code get refactored later.
> Please use a proper way via macro? Eg., checking
> INTEL_ARCH_BRANCHES_RETIRED_INDEX in pmu_counters_test.c might be a good
> one.

Yeah, I would define an enum to enumerate these indexes. Thanks.


>>   		report_prefix_push("Intel");
>>   		set_ref_cycle_expectations();
>>   	} else {
>>   		gp_events_size = sizeof(amd_gp_events)/sizeof(amd_gp_events[0]);
>>   		gp_events = (struct pmu_event *)amd_gp_events;
>> +		branch_idx = 2;
>>   		report_prefix_push("AMD");
>>   	}
>> +	adjust_events_range(gp_events, branch_idx);
>>   
>>   	printf("PMU version:         %d\n", pmu.version);
>>   	printf("GP counters:         %d\n", pmu.nr_gp_counters);
>> -- 
>> 2.34.1
>>

