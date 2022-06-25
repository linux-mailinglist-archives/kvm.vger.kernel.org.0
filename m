Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BA255A783
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 08:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbiFYGfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jun 2022 02:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiFYGfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jun 2022 02:35:07 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5EF4AE17
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 23:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656138907; x=1687674907;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ncsSzD9lukMtrHqAkss875YlBgCtPzCDAL9ZDZZYm1E=;
  b=H4I+PTvAS5kbKQtae0On7fx/TGcW/cPbVyzY/YibwoZRI0tU5cu+F6Bv
   i8lUW5BUedKYLRIFpiNXYZ31Se6/3Cu7ssKpCXwuqsFQCvhf6k9QMAcvR
   HFULpr8IIcN/kf2eU6mxSkCD9uWOPFFB+zCwD1JjUson/0USfXVkzdKfG
   nUGvG+hdgAPWhu/HXLu/Lh31eLTi0B9XsV6ejDo5TRRN2g88eVit7dKdh
   IwibChLdmWu4L9eS3G48BLAuqJxcdJ70VPaAaH/SuGTTjI+riZqWErtbB
   pJ8IiWom1i0i2BwPVSIfClX/WS1m5OKeVNTlKu093uS9tRwVy0FG50ezT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10388"; a="306623261"
X-IronPort-AV: E=Sophos;i="5.92,221,1650956400"; 
   d="scan'208";a="306623261"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 23:35:07 -0700
X-IronPort-AV: E=Sophos;i="5.92,221,1650956400"; 
   d="scan'208";a="645600520"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.169.7]) ([10.249.169.7])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 23:35:05 -0700
Message-ID: <8b0ed7fb-9dba-f677-0779-8f80166c29c2@intel.com>
Date:   Sat, 25 Jun 2022 14:34:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 2/3] x86: Skip perf related tests when platform cannot
 support
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
References: <20220624090828.62191-1-weijiang.yang@intel.com>
 <20220624090828.62191-3-weijiang.yang@intel.com>
 <YrY1+UHZMDno74we@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YrY1+UHZMDno74we@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/25/2022 6:08 AM, Sean Christopherson wrote:
> On Fri, Jun 24, 2022, Yang Weijiang wrote:
>> Add helpers to check whether MSR_CORE_PERF_GLOBAL_CTRL and rdpmc
>> are supported in KVM. When pmu is disabled with enable_pmu=0,
>> reading MSR_CORE_PERF_GLOBAL_CTRL or executing rdpmc leads to #GP,
>> so skip related tests in this case to avoid test failure.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   lib/x86/processor.h | 10 ++++++++++
>>   x86/vmx_tests.c     | 18 ++++++++++++++++++
>>   2 files changed, 28 insertions(+)
>>
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 9a0dad6..70b9193 100644
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
>> +static inline bool has_perf_global_ctrl(void)
> Slight preference for this_cpu_has_perf_global_ctrl() or cpu_has_perf_global_ctrl().
OK, will change it. Thanks.
>
>> +{
>> +	return pmu_version() > 1;
>> +}
>> +
>>   #endif
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index 4d581e7..3cf0776 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -944,6 +944,14 @@ static void insn_intercept_main(void)
>>   			continue;
>>   		}
>>   
>> +		if (insn_table[cur_insn].flag == CPU_RDPMC) {
>> +			if (!!pmu_version()) {
>> +				printf("\tFeature required for %s is not supported.\n",
>> +				       insn_table[cur_insn].name);
>> +				continue;
>> +			}
>> +		}
> There's no need to copy+paste a bunch of code plus a one-off check, just add
> another helper that plays nice with supported_fn().
Good, I'll add a supported_fn().
>
> static inline bool this_cpu_has_pmu(void)
> {
> 	return !!pmu_version();
> }
>
>> +
>>   		if (insn_table[cur_insn].disabled) {
>>   			printf("\tFeature required for %s is not supported.\n",
>>   			       insn_table[cur_insn].name);
>> @@ -7490,6 +7498,11 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
>>   
>>   static void test_load_host_perf_global_ctrl(void)
>>   {
>> +	if (!has_perf_global_ctrl()) {
>> +		report_skip("test_load_host_perf_global_ctrl");
> If you're going to print just the function name, then
>
> 		report_skip(__func__);
>
> will suffice.  I'd still prefer a more helpful message, especially since there's
> another "skip" in this function.
Will do it.
>
>> +		return;
>> +	}
>> +
>>   	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
>>   		printf("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
>>   		return;
> Speaking of said skip, can you clean up the existing code to use report_skip()?
Will do it.
>
>> @@ -7502,6 +7515,11 @@ static void test_load_host_perf_global_ctrl(void)
>>   
>>   static void test_load_guest_perf_global_ctrl(void)
>>   {
>> +	if (!has_perf_global_ctrl()) {
>> +		report_skip("test_load_guest_perf_global_ctrl");
>> +		return;
>> +	}
>> +
>>   	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
>>   		printf("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
>>   		return;
>> -- 
>> 2.27.0
>>
