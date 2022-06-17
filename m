Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FDC54EEF5
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 03:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378914AbiFQBrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 21:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbiFQBrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 21:47:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0B263BEA
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 18:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655430430; x=1686966430;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RhdyV1iNo1aQFp+rcF2KakrPLURmZ5LdKLFKXusJMjc=;
  b=DklJvM78wOQpJsajGC/9itpyxYBLwMQDjuduKkC3wJpvhjXOH/Rhg+qi
   Uc82sipAAOkIfe5TjgF+TD4gCHMRxu0J4MVuLnzMvL0EHHHI3hT+lA1d6
   ZunPo2VNs+HOvhD6s9upfyXET/WFfYh5485iuJJmHPUo9W3eDLYhCcgcp
   4j9s6P+qhQYsIpQDWK6YdCLxfZ8XV7gs/hx5C/dRKiiCvUNXQ22elIa3A
   phztcLC7XBqaUHYhza6Ral7LhB1bhNEBLoJxOtVzkVPDen+HPFxIpLuPF
   VO3kkAY4BxqwdfAGS+D/LR8q2Nl+GRt1H3ICySCmMRXdIku5pt3HgoNcz
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="278192238"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="278192238"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 18:47:10 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="589906563"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.170.76]) ([10.249.170.76])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 18:47:08 -0700
Message-ID: <948fb7b4-4d9f-6a07-09cb-6182bb9cbb92@intel.com>
Date:   Fri, 17 Jun 2022 09:47:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v2 2/3] x86: Skip running test when pmu is
 disabled
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, like.xu.linux@gmail.com, jmattson@google.com,
        kvm@vger.kernel.org
References: <20220615084641.6977-1-weijiang.yang@intel.com>
 <20220615084641.6977-3-weijiang.yang@intel.com> <Yqt3zzTV2UrsFX3v@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Yqt3zzTV2UrsFX3v@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/17/2022 2:34 AM, Sean Christopherson wrote:
> On Wed, Jun 15, 2022, Yang Weijiang wrote:
>> Read MSR_IA32_PERF_CAPABILITIES triggers #GP when pmu is disabled
>> by enable_pmu=0 in KVM. Let's check whether pmu is available before
>> issue msr reading to avoid the #GP. Also check PDCM bit before read
>> the MSR.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   x86/pmu_lbr.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
>> index 688634d..62614a0 100644
>> --- a/x86/pmu_lbr.c
>> +++ b/x86/pmu_lbr.c
>> @@ -5,6 +5,7 @@
>>   #define N 1000000
>>   #define MAX_NUM_LBR_ENTRY	  32
>>   #define DEBUGCTLMSR_LBR	  (1UL <<  0)
>> +#define PDCM_ENABLED	  (1UL << 15)
>>   #define PMU_CAP_LBR_FMT	  0x3f
>>   
>>   #define MSR_LBR_NHM_FROM	0x00000680
>> @@ -74,13 +75,22 @@ int main(int ac, char **av)
>>   		return 0;
>>   	}
>>   
>> -	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
>>   	eax.full = id.a;
>>   
>>   	if (!eax.split.version_id) {
>>   		printf("No pmu is detected!\n");
>>   		return report_summary();
>>   	}
>> +
>> +	id = cpuid(1);
>> +
>> +	if (!(id.c & PDCM_ENABLED)) {
> Don't open code cpuid(), add and use X86_FEATURE_PDCM:
>
>    #define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))
>
> 	if (!this_cpu_has(X86_FEATURE_PDCM))
> 		...
Oops, this is more x86 style code, thank you!
>
>
>> +		printf("No PDCM is detected!\n");
> If your going to bother printing a message, please make it useful.  Every time I
> read PMU code I have to reread the kernel's cpufeatures.h to remember what PDCM
> stands for.
>
> 		printf("Perf/Debug Capabilities MSR isn't supported\n");
Exactly, I'll bear it in mind :-)
>
>> +		return report_summary();
>> +	}
>> +
>> +	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
>> +
>>   	if (!(perf_cap & PMU_CAP_LBR_FMT)) {
>>   		printf("No LBR is detected!\n");
> Similar complaint,
>
> 		printf("Architectural LBRs are not supported.\n");
Sure.
>
>>   		return report_summary();
>> -- 
>> 2.31.1
>>
