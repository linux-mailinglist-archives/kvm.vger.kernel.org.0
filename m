Return-Path: <kvm+bounces-12774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16EEC88D9AB
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:56:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99B6E1F2E255
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 08:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70DF837141;
	Wed, 27 Mar 2024 08:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Knd8r+Fv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E524A3418B;
	Wed, 27 Mar 2024 08:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711529755; cv=none; b=Dg9hFRseZ9aU6UbbSLL2VoIRcHZ7/PnPVFTSTI+0dZ+rx0YAGDjwtLBZohIZ3XpgysvDyxI/nybji69JfLRsTjkhGlIIdQrF6kU8UOJFvO8VC3L5a4PnE3umw9FXEQHShUlV+wRgp6LSn760F9lR3Vj0BCwSPELZ2DhNqVHLQVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711529755; c=relaxed/simple;
	bh=SIIHaGimWKCCFol4x5gKqvkWyQ3hIZIdWBEQ92j2QyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DM/F2q6KW9F0R7vCzAq+l2Zq2fQLYETNrZviddy9AYtijaTkHeTOdtBBIZIKjM4LY5O03yIq8h3zNeWY6vUA8MJ6eKH7i0Z8H7M7gPYwh2NJuwTcuuDqy/7khTXN6+1QBeUfOmfEro6663g5HoYdkpGXxd9vmJK3gPVS+QR1iSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Knd8r+Fv; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711529754; x=1743065754;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SIIHaGimWKCCFol4x5gKqvkWyQ3hIZIdWBEQ92j2QyI=;
  b=Knd8r+Fv8uIhPMo1tB8DVCMpX1Va7ryS40Yk++EDZBdjnS6MK/cN268L
   ZlIIC51Ssbr0ajpp6x3v4WG/Ti6cL9XTkMYzDqiBGq+/x6ELylPGl2SZF
   cjs4efwWs93VMsHNG+42M19PbLgvNfY0QZkImcIYWflpzAvqlBfiSrUF1
   hHNEWHTD9CFPK6VNAjpqSJlkvhxDkaW+wK95Cqn8oETir7WPxwkwODkl9
   UpjCu5jqT/5cpa1kWq4HIXC/cvyLI2u3trQY3mrSIhSmviYThw5YA2bzh
   EQuiN7BVMzwCpNiYHV082qNPtt+ccmm9G8ZWW8hO9yddN8mQwwsHomBu5
   Q==;
X-CSE-ConnectionGUID: 9jn1qkJTQD+INZV8b7ZSCw==
X-CSE-MsgGUID: MsvAAJ+7SnWwWVzRGtZd9w==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="29094429"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="29094429"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 01:55:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="16612675"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.242.198]) ([10.125.242.198])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 01:55:51 -0700
Message-ID: <c509996d-fdda-4a57-b6ac-597c811f7786@linux.intel.com>
Date: Wed, 27 Mar 2024 16:55:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 07/11] x86: pmu: Enable and disable PMCs
 in loop() asm blob
Content-Language: en-US
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong
 <xiong.y.zhang@intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-8-dapeng1.mi@linux.intel.com>
 <ZgO3vWIeC3sk_B5N@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZgO3vWIeC3sk_B5N@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/27/2024 2:07 PM, Mingwei Zhang wrote:
> On Wed, Jan 03, 2024, Dapeng Mi wrote:
>> Currently enabling PMCs, executing loop() and disabling PMCs are divided
>> 3 separated functions. So there could be other instructions executed
>> between enabling PMCS and running loop() or running loop() and disabling
>> PMCs, e.g. if there are multiple counters enabled in measure_many()
>> function, the instructions which enabling the 2nd and more counters
>> would be counted in by the 1st counter.
>>
>> So current implementation can only verify the correctness of count by an
>> rough range rather than a precise count even for instructions and
>> branches events. Strictly speaking, this verification is meaningless as
>> the test could still pass even though KVM vPMU has something wrong and
>> reports an incorrect instructions or branches count which is in the rough
>> range.
>>
>> Thus, move the PMCs enabling and disabling into the loop() asm blob and
>> ensure only the loop asm instructions would be counted, then the
>> instructions or branches events can be verified with an precise count
>> instead of an rough range.
>>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>   x86/pmu.c | 83 +++++++++++++++++++++++++++++++++++++++++++++----------
>>   1 file changed, 69 insertions(+), 14 deletions(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 46bed66c5c9f..88b89ad889b9 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -18,6 +18,20 @@
>>   #define EXPECTED_INSTR 17
>>   #define EXPECTED_BRNCH 5
>>   
>> +// Instrustion number of LOOP_ASM code
>> +#define LOOP_INSTRNS	10
>> +#define LOOP_ASM					\
>> +	"1: mov (%1), %2; add $64, %1;\n\t"		\
>> +	"nop; nop; nop; nop; nop; nop; nop;\n\t"	\
>> +	"loop 1b;\n\t"
>> +
>> +#define PRECISE_LOOP_ASM						\
>> +	"wrmsr;\n\t"							\
>> +	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
>> +	LOOP_ASM							\
>> +	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
>> +	"wrmsr;\n\t"
> Can we add "FEP" prefix into the above blob? This way, we can expand the
> testing for emulated instructions.


Yeah, that sounds like a new feature request. I would add it in next 
version.


>> +
>>   typedef struct {
>>   	uint32_t ctr;
>>   	uint64_t config;
>> @@ -54,13 +68,43 @@ char *buf;
>>   static struct pmu_event *gp_events;
>>   static unsigned int gp_events_size;
>>   
>> -static inline void loop(void)
>> +
>> +static inline void __loop(void)
>> +{
>> +	unsigned long tmp, tmp2, tmp3;
>> +
>> +	asm volatile(LOOP_ASM
>> +		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)
>> +		     : "0"(N), "1"(buf));
>> +}
>> +
>> +/*
>> + * Enable and disable counters in a whole asm blob to ensure
>> + * no other instructions are counted in the time slot between
>> + * counters enabling and really LOOP_ASM code executing.
>> + * Thus counters can verify instructions and branches events
>> + * against precise counts instead of a rough valid count range.
>> + */
>> +static inline void __precise_count_loop(u64 cntrs)
>>   {
>>   	unsigned long tmp, tmp2, tmp3;
>> +	unsigned int global_ctl = pmu.msr_global_ctl;
>> +	u32 eax = cntrs & (BIT_ULL(32) - 1);
>> +	u32 edx = cntrs >> 32;
>>   
>> -	asm volatile("1: mov (%1), %2; add $64, %1; nop; nop; nop; nop; nop; nop; nop; loop 1b"
>> -			: "=c"(tmp), "=r"(tmp2), "=r"(tmp3): "0"(N), "1"(buf));
>> +	asm volatile(PRECISE_LOOP_ASM
>> +		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)
>> +		     : "a"(eax), "d"(edx), "c"(global_ctl),
>> +		       "0"(N), "1"(buf)
>> +		     : "edi");
>> +}
>>   
>> +static inline void loop(u64 cntrs)
>> +{
>> +	if (!this_cpu_has_perf_global_ctrl())
>> +		__loop();
>> +	else
>> +		__precise_count_loop(cntrs);
>>   }
>>   
>>   volatile uint64_t irq_received;
>> @@ -159,18 +203,17 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
>>   	    ctrl = (ctrl & ~(0xf << shift)) | (usrospmi << shift);
>>   	    wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
>>       }
>> -    global_enable(evt);
>>       apic_write(APIC_LVTPC, PMI_VECTOR);
>>   }
>>   
>>   static void start_event(pmu_counter_t *evt)
>>   {
>>   	__start_event(evt, 0);
>> +	global_enable(evt);
>>   }
>>   
>> -static void stop_event(pmu_counter_t *evt)
>> +static void __stop_event(pmu_counter_t *evt)
>>   {
>> -	global_disable(evt);
>>   	if (is_gp(evt)) {
>>   		wrmsr(MSR_GP_EVENT_SELECTx(event_to_global_idx(evt)),
>>   		      evt->config & ~EVNTSEL_EN);
>> @@ -182,14 +225,24 @@ static void stop_event(pmu_counter_t *evt)
>>   	evt->count = rdmsr(evt->ctr);
>>   }
>>   
>> +static void stop_event(pmu_counter_t *evt)
>> +{
>> +	global_disable(evt);
>> +	__stop_event(evt);
>> +}
>> +
>>   static noinline void measure_many(pmu_counter_t *evt, int count)
>>   {
>>   	int i;
>> +	u64 cntrs = 0;
>> +
>> +	for (i = 0; i < count; i++) {
>> +		__start_event(&evt[i], 0);
>> +		cntrs |= BIT_ULL(event_to_global_idx(&evt[i]));
>> +	}
>> +	loop(cntrs);
>>   	for (i = 0; i < count; i++)
>> -		start_event(&evt[i]);
>> -	loop();
>> -	for (i = 0; i < count; i++)
>> -		stop_event(&evt[i]);
>> +		__stop_event(&evt[i]);
>>   }
>>   
>>   static void measure_one(pmu_counter_t *evt)
>> @@ -199,9 +252,11 @@ static void measure_one(pmu_counter_t *evt)
>>   
>>   static noinline void __measure(pmu_counter_t *evt, uint64_t count)
>>   {
>> +	u64 cntrs = BIT_ULL(event_to_global_idx(evt));
>> +
>>   	__start_event(evt, count);
>> -	loop();
>> -	stop_event(evt);
>> +	loop(cntrs);
>> +	__stop_event(evt);
>>   }
>>   
>>   static bool verify_event(uint64_t count, struct pmu_event *e)
>> @@ -451,7 +506,7 @@ static void check_running_counter_wrmsr(void)
>>   	report_prefix_push("running counter wrmsr");
>>   
>>   	start_event(&evt);
>> -	loop();
>> +	__loop();
>>   	wrmsr(MSR_GP_COUNTERx(0), 0);
>>   	stop_event(&evt);
>>   	report(evt.count < gp_events[0].min, "cntr");
>> @@ -468,7 +523,7 @@ static void check_running_counter_wrmsr(void)
>>   
>>   	wrmsr(MSR_GP_COUNTERx(0), count);
>>   
>> -	loop();
>> +	__loop();
>>   	stop_event(&evt);
>>   
>>   	if (this_cpu_has_perf_global_status()) {
>> -- 
>> 2.34.1
>>

