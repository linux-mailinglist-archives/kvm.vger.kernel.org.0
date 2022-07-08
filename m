Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E2B56AFAE
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 03:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiGHAuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 20:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGHAug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 20:50:36 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6172761D48
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 17:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657241436; x=1688777436;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=b1wnrbwU89wXm+qj6FquuvmP0OFZVzO/RsRu+3zuuZc=;
  b=N3twpFV7sE25z5fuXxOGHuwH86FH2ynnfIRGGrlP3e3tXh59QjT4VArV
   0Q+op/vYp6N/jP5okFykepxVHlDljVs6oxDZ98akcUhL/Gh6+epjuTNVK
   PRRPYWeBxcnkfc3M+oqR19zIlDQVw8hY144pS/UkdvIH1MER/YlYYYQwv
   +Lka5CmoNphW4/lEonzshEK1KKbK1pN9kVx0UTZRIEqc3kpYxP/4669NN
   Hky/+6ah3N1iLXnbKRKHVVOScrZ3UKd18D2XnsmWeZZ0e+4b78R/hzwJv
   qHzk6wLiFE6d46vkKRa5vEDgNBeeIxi25ebqsJM3pVQRWn8extaPjy6N9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="264569406"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="264569406"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 17:48:23 -0700
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="651358127"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.175.244]) ([10.249.175.244])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 17:48:22 -0700
Message-ID: <fd902a14-c48d-9217-dc7f-2e3cf3fc218c@intel.com>
Date:   Fri, 8 Jul 2022 08:48:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v4 1/2] x86: Skip perf related tests when
 platform cannot support
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
References: <20220628093203.73160-1-weijiang.yang@intel.com>
 <YsdBa6BNrwdwBMPI@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YsdBa6BNrwdwBMPI@google.com>
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


On 7/8/2022 4:26 AM, Sean Christopherson wrote:
> On Tue, Jun 28, 2022, Yang Weijiang wrote:
>> Add helpers to check whether MSR_CORE_PERF_GLOBAL_CTRL and rdpmc
>> are supported in KVM. When pmu is disabled with enable_pmu=0,
>> reading MSR_CORE_PERF_GLOBAL_CTRL or executing rdpmc leads to #GP,
>> so skip related tests in this case to avoid test failure.
>>
>> Opportunistically replace some "printf" with "report_skip" to make
>> the output log clean.
> Ooof, these end up dominating the patch.  Can you split them to a separate prep
> patch?  Thanks!

Welcome back!

Will do it, thanks!

>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>
>> v4:
>> - Use supported_fn() to make the code nicer. [Sean]
>> - Replace some of the printf with report_skip to make the results clean. [Sean]
> Put the versioning info below the three dashes so that it doesn't show up in the
> final changelog.
>
>> ---
> <version info goes here>
OK.
>
>>   lib/x86/processor.h | 10 ++++++++++
>>   x86/vmx_tests.c     | 40 +++++++++++++++++++++++++++-------------
>>   2 files changed, 37 insertions(+), 13 deletions(-)
>>
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 9a0dad6..7b6ee92 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -690,4 +690,14 @@ static inline bool cpuid_osxsave(void)
>>   	return cpuid(1).c & (1 << (X86_FEATURE_OSXSAVE % 32));
>>   }
>>   
>> +static inline u8 pmu_version(void)
>> +{
>> +	return cpuid(10).a & 0xff;
>> +}
>> +
>> +static inline bool cpu_has_perf_global_ctrl(void)
>> +{
>> +	return pmu_version() > 1;
>> +}
>> +
>>   #endif
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index 4d581e7..3a14cb2 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -852,6 +852,10 @@ static bool monitor_supported(void)
>>   	return this_cpu_has(X86_FEATURE_MWAIT);
>>   }
>>   
>> +static inline bool pmu_supported(void) {
> Curly brace goes on a new line.
Sorry for the typo.
>
>> +	return !!pmu_version();
>> +}
> Why not put this in processor.h?  And maybe call it cpu_has_pmu()?
Good suggestion, then it can serve other apps. Thank you!
