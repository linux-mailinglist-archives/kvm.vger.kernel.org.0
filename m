Return-Path: <kvm+bounces-12779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0569F88DA14
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 10:18:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3656E1C27D4E
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A015237711;
	Wed, 27 Mar 2024 09:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LKB0gRBk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCC6125C9;
	Wed, 27 Mar 2024 09:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711531088; cv=none; b=itZoT91uVLtU+n42fZn5C+373qmVJSVAN2nCdd0CliYqz3B3lkwgmQ/4HmUj1KMSEW4/6mli2PLJDe5ARLapQ4I02kbgDb9fbxhReMzfkRRvhbjDQpCJgU7fZROawKlJL9GO6JaU/0v+dE1OOdJQzHJuR+mJ40uMKJHNrZyk04E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711531088; c=relaxed/simple;
	bh=16NSvZdjDhZssZn34ASsBck8iCwqCtaIPiOBnRnFI8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c4qrmwxLLQjniUjHHIUSDTZtzclfoi4bI4ycO8Npcl2egIs9+PIT0xD8jDttikwpK5Wu0uZ7Gz2PGXmQSP4YESNOkL4sp3P55VJ3RuxlgGs9+zdmfAP4OH6oEjOv9wAkhknbQYWol88XMXZ3YezXG91EU0D4fnBchzacArpmc2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LKB0gRBk; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711531087; x=1743067087;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=16NSvZdjDhZssZn34ASsBck8iCwqCtaIPiOBnRnFI8g=;
  b=LKB0gRBkxNMBW/N/s9fFW7OdjruP8Cu187O9lu/lc8ymjT8IZFuI5e1K
   +/PS4+hJJsGyC+nRBz87pN2SigNt+a2pMxZI2pY0rN3sbmDdfqsq+wM9E
   IRvtOdLM8LMfdr/Kj/eLe5F+PyrNvIFwSx24Q5m3qdrgzlRwDI//Lg+dh
   COsJFsACS/bwMXr0Uql4gIXG0zxZ6xTMQFoG5K6BY31Pn1d6AZ93BV/rc
   fBLhsdzApaQle/xb/+PxYGQzFRsI222D1LJZLWQYX0HFNumdyFQw8WHJB
   jygTKAqtBLp9F6g/M0xYwcJQAvfiuAfmqmiiQlpMrh8hm3hMfpnkvviRU
   w==;
X-CSE-ConnectionGUID: oIUY4h0BTUSiIZ2cbJSSyA==
X-CSE-MsgGUID: WNO4d+2mSaeFcTUi0gM5fg==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="18051305"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="18051305"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 02:18:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="20940718"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.242.198]) ([10.125.242.198])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 02:18:03 -0700
Message-ID: <b204b992-8ad4-48d6-a0dd-d297ae23a5a2@linux.intel.com>
Date: Wed, 27 Mar 2024 17:18:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 09/11] x86: pmu: Improve LLC misses
 event verification
Content-Language: en-US
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong
 <xiong.y.zhang@intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-10-dapeng1.mi@linux.intel.com>
 <ZgO7Wr0URLc_ru1S@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZgO7Wr0URLc_ru1S@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/27/2024 2:23 PM, Mingwei Zhang wrote:
> On Wed, Jan 03, 2024, Dapeng Mi wrote:
>> When running pmu test on SPR, sometimes the following failure is
>> reported.
>>
>> 1 <= 0 <= 1000000
>> FAIL: Intel: llc misses-4
>>
>> Currently The LLC misses occurring only depends on probability. It's
>> possible that there is no LLC misses happened in the whole loop(),
>> especially along with processors have larger and larger cache size just
>> like what we observed on SPR.
>>
>> Thus, add clflush instruction into the loop() asm blob and ensure once
>> LLC miss is triggered at least.
>>
>> Suggested-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> I wonder if we can skip all LLC tests if CPU does not have
> clflush/clflushopt properties?

Looks reasonable, the LLC miss event should be skipped at least if 
clflush/clflushopt are not supported since the validation can't grantee 
the correctness. But for LLC reference event, I think we can keep it 
since the asm_loop() would always 1 LLC reference at least.

If no disapproval, I would change code to skip LLC miss event if 
clflush/clflushopt are not supported in next version. Thanks.


>> ---
>>   x86/pmu.c | 43 ++++++++++++++++++++++++++++++-------------
>>   1 file changed, 30 insertions(+), 13 deletions(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index b764827c1c3d..8fd3db0fbf81 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -20,19 +20,21 @@
>>   
>>   // Instrustion number of LOOP_ASM code
>>   #define LOOP_INSTRNS	10
>> -#define LOOP_ASM					\
>> +#define LOOP_ASM(_clflush)				\
>> +	_clflush "\n\t"                                 \
>> +	"mfence;\n\t"                                   \
>>   	"1: mov (%1), %2; add $64, %1;\n\t"		\
>>   	"nop; nop; nop; nop; nop; nop; nop;\n\t"	\
>>   	"loop 1b;\n\t"
>>   
>> -/*Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
>> -#define PRECISE_EXTRA_INSTRNS  (2 + 4)
>> +/*Enable GLOBAL_CTRL + disable GLOBAL_CTRL + clflush/mfence instructions */
>> +#define PRECISE_EXTRA_INSTRNS  (2 + 4 + 2)
>>   #define PRECISE_LOOP_INSTRNS   (N * LOOP_INSTRNS + PRECISE_EXTRA_INSTRNS)
>>   #define PRECISE_LOOP_BRANCHES  (N)
>> -#define PRECISE_LOOP_ASM						\
>> +#define PRECISE_LOOP_ASM(_clflush)					\
>>   	"wrmsr;\n\t"							\
>>   	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
>> -	LOOP_ASM							\
>> +	LOOP_ASM(_clflush)						\
>>   	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
>>   	"wrmsr;\n\t"
>>   
>> @@ -72,14 +74,30 @@ char *buf;
>>   static struct pmu_event *gp_events;
>>   static unsigned int gp_events_size;
>>   
>> +#define _loop_asm(_clflush)					\
>> +do {								\
>> +	asm volatile(LOOP_ASM(_clflush)				\
>> +		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)	\
>> +		     : "0"(N), "1"(buf));			\
>> +} while (0)
>> +
>> +#define _precise_loop_asm(_clflush)				\
>> +do {								\
>> +	asm volatile(PRECISE_LOOP_ASM(_clflush)			\
>> +		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)	\
>> +		     : "a"(eax), "d"(edx), "c"(global_ctl),	\
>> +		       "0"(N), "1"(buf)				\
>> +		     : "edi");					\
>> +} while (0)
>>   
>>   static inline void __loop(void)
>>   {
>>   	unsigned long tmp, tmp2, tmp3;
>>   
>> -	asm volatile(LOOP_ASM
>> -		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)
>> -		     : "0"(N), "1"(buf));
>> +	if (this_cpu_has(X86_FEATURE_CLFLUSH))
>> +		_loop_asm("clflush (%1)");
>> +	else
>> +		_loop_asm("nop");
>>   }
>>   
>>   /*
>> @@ -96,11 +114,10 @@ static inline void __precise_count_loop(u64 cntrs)
>>   	u32 eax = cntrs & (BIT_ULL(32) - 1);
>>   	u32 edx = cntrs >> 32;
>>   
>> -	asm volatile(PRECISE_LOOP_ASM
>> -		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)
>> -		     : "a"(eax), "d"(edx), "c"(global_ctl),
>> -		       "0"(N), "1"(buf)
>> -		     : "edi");
>> +	if (this_cpu_has(X86_FEATURE_CLFLUSH))
>> +		_precise_loop_asm("clflush (%1)");
>> +	else
>> +		_precise_loop_asm("nop");
>>   }
>>   
>>   static inline void loop(u64 cntrs)
>> -- 
>> 2.34.1
>>

