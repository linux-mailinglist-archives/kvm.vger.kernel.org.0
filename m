Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9F556AFA8
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 03:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbiGHA5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 20:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236633AbiGHA5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 20:57:34 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A8071BD4
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 17:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657241854; x=1688777854;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jOpjhQ3NisCmJX9fzq6gcEAAztteFBf82yNqfo3Be8U=;
  b=CRXPoXzFuoYA5/ovuqA+9aDco5Vnc4oiqmslWpIKzq2FQmbuBwLh4cuJ
   m5Rl0aWqLuiEF4Ku8wwkvndw7cbjQQgfsM424spPbwLZI+QImiDn3u11f
   pdlc2UzS0748zDHSj9KztX1BKz+H6af8G+z7BsNDwn7hEamFV60nG67bn
   cjPEW4kyYrgpfJFd2g9VqiNLjETniqveiv29VRttoPNrBNeWC+ix8kXFk
   7s/x8+8L40R4UrwJkt1Ke3ppqWEZ/ryuMPw1OtrlYd1EOU/t4ZOotkn3M
   kAvuhUX9zqnVUcH4CKODO7KvD4GGOhkdOmOWXELy6T1c9CYVIh1T1w2Dq
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="282910059"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="282910059"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 17:57:33 -0700
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="651361606"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.175.244]) ([10.249.175.244])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 17:57:32 -0700
Message-ID: <20cf2585-0502-16df-5763-9380ab43d74d@intel.com>
Date:   Fri, 8 Jul 2022 08:57:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v4 2/2] x86: Check platform vPMU
 capabilities before run lbr tests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
References: <20220628093203.73160-1-weijiang.yang@intel.com>
 <20220628093203.73160-2-weijiang.yang@intel.com>
 <YsdB9Is3oHgSFg8S@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YsdB9Is3oHgSFg8S@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/8/2022 4:28 AM, Sean Christopherson wrote:
> On Tue, Jun 28, 2022, Yang Weijiang wrote:
>> Use new helper to check whether pmu is available and Perfmon/Debug
>> capbilities are supported before read MSR_IA32_PERF_CAPABILITIES to
>> avoid test failure. The issue can be captured when enable_pmu=0.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>
>> v4:
>> - Put the X86_FEATURE_PDCM to the right place. [Sean]
>> ---
> <version info goes here>
Will change it.
>
>>   lib/x86/processor.h |  1 +
>>   x86/pmu_lbr.c       | 32 +++++++++++++-------------------
>>   2 files changed, 14 insertions(+), 19 deletions(-)
>>
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 7b6ee92..7a35c7f 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -146,6 +146,7 @@ static inline bool is_intel(void)
>>    */
>>   #define	X86_FEATURE_MWAIT		(CPUID(0x1, 0, ECX, 3))
>>   #define	X86_FEATURE_VMX			(CPUID(0x1, 0, ECX, 5))
>> +#define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))
>>   #define	X86_FEATURE_PCID		(CPUID(0x1, 0, ECX, 17))
>>   #define	X86_FEATURE_MOVBE		(CPUID(0x1, 0, ECX, 22))
>>   #define	X86_FEATURE_TSC_DEADLINE_TIMER	(CPUID(0x1, 0, ECX, 24))
>> diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
>> index 688634d..497df1e 100644
>> --- a/x86/pmu_lbr.c
>> +++ b/x86/pmu_lbr.c
>> @@ -15,6 +15,7 @@
>>   #define MSR_LBR_SELECT		0x000001c8
>>   
>>   volatile int count;
>> +u32 lbr_from, lbr_to;
>>   
>>   static noinline int compute_flag(int i)
>>   {
>> @@ -38,18 +39,6 @@ static noinline int lbr_test(void)
>>   	return 0;
>>   }
>>   
>> -union cpuid10_eax {
>> -	struct {
>> -		unsigned int version_id:8;
>> -		unsigned int num_counters:8;
>> -		unsigned int bit_width:8;
>> -		unsigned int mask_length:8;
>> -	} split;
>> -	unsigned int full;
>> -} eax;
>> -
>> -u32 lbr_from, lbr_to;
>> -
>>   static void init_lbr(void *index)
>>   {
>>   	wrmsr(lbr_from + *(int *) index, 0);
>> @@ -63,7 +52,7 @@ static bool test_init_lbr_from_exception(u64 index)
>>   
>>   int main(int ac, char **av)
>>   {
>> -	struct cpuid id = cpuid(10);
>> +	u8 version = pmu_version();
>>   	u64 perf_cap;
>>   	int max, i;
>>   
>> @@ -74,19 +63,24 @@ int main(int ac, char **av)
>>   		return 0;
>>   	}
>>   
>> -	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
>> -	eax.full = id.a;
>> -
>> -	if (!eax.split.version_id) {
>> +	if (!version) {
> If the previous patch exposes cpu_has_pmu(), then this open coded check goes away
> in favor of the more obvious:
>
> 	if (!cpu_has_pmu()) {
Yep.
>>   		printf("No pmu is detected!\n");
>>   		return report_summary();
>>   	}
>> +
>> +	if (!this_cpu_has(X86_FEATURE_PDCM)) {
>> +		printf("Perfmon/Debug Capabilities MSR isn't supported\n");
>> +		return report_summary();
>> +	}
>> +
>> +	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
>> +
>>   	if (!(perf_cap & PMU_CAP_LBR_FMT)) {
>> -		printf("No LBR is detected!\n");
>> +		printf("(Architectural) LBR is not supported.\n");
>>   		return report_summary();
>>   	}
>>   
>> -	printf("PMU version:		 %d\n", eax.split.version_id);
>> +	printf("PMU version:		 %d\n", version);
> And with the open coded check gone, this can be:
> 	
> 	printf("PMU version:		 %d\n", pmu_version());
Will change it. Thank you!
>
>>   	printf("LBR version:		 %ld\n", perf_cap & PMU_CAP_LBR_FMT);
>>   
>>   	/* Look for LBR from and to MSRs */
>> -- 
>> 2.27.0
>>
