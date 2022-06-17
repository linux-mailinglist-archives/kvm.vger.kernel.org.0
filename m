Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94AA54EEFC
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 03:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379538AbiFQBtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 21:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379379AbiFQBtF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 21:49:05 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160085EBEE
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 18:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655430545; x=1686966545;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=W3RarqNEbfQ3uBMIaYK9fagS2DlhzuPSand5YG3Cg9c=;
  b=ctapfHZ82BzuyMFVwZ6hkpXLRNXZRh+6LjqtkIGpVj0W3OutLO0ovv3l
   k2vhUPvoD0o8MZVJpNY3o+FsvmCe3+hS2j52YYRNarqpC2G1WyNj4nu7I
   OPiKuFb1xD3ic5ixuvNZir3r+p7TSjJAyVNPgEyI9pK0z8ZQq8VG2LrmV
   pXqqFiDrHXr0pHUrCh9K81oUkpGpwfYXPRLzXaGIrH5eJUxv6rjL1vBqy
   3/LTDkjSMhp3cHzlhmGCiVkWsibpQDJuRkpe1jILgaWo4GqE1yEhdS/zl
   TZgTYiOAfiohnFvoAOFVzomrw0LLl7ZWVwIwxQIH7WRyO17HnyeI4quK9
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="279453596"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="279453596"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 18:49:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="589907393"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.170.76]) ([10.249.170.76])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 18:49:02 -0700
Message-ID: <707390f6-827d-1dce-eaf8-c0790031d27d@intel.com>
Date:   Fri, 17 Jun 2022 09:49:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v2 3/3] x86: Skip perf related tests when
 pmu is disabled
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, like.xu.linux@gmail.com, jmattson@google.com,
        kvm@vger.kernel.org
References: <20220615084641.6977-1-weijiang.yang@intel.com>
 <20220615084641.6977-4-weijiang.yang@intel.com> <Yqt5Fa/8l56XhfRC@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Yqt5Fa/8l56XhfRC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/17/2022 2:40 AM, Sean Christopherson wrote:
> On Wed, Jun 15, 2022, Yang Weijiang wrote:
>> When pmu is disabled in KVM, reading MSR_CORE_PERF_GLOBAL_CTRL
>> or executing rdpmc leads to #GP, so skip related tests in this case.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   x86/vmx_tests.c | 24 ++++++++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>>
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index 4d581e7..dd6fc13 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -944,6 +944,16 @@ static void insn_intercept_main(void)
>>   			continue;
>>   		}
>>   
>> +		if (insn_table[cur_insn].flag == CPU_RDPMC) {
>> +			struct cpuid id = cpuid(10);
>> +
>> +			if (!(id.a & 0xff)) {
> Please add helpers to query (a) the PMU version and (b) whether or not PERF_GLOBAL_CTRL
> is supported.
Sure.
>
>> +				printf("\tFeature required for %s is not supported.\n",
>> +				       insn_table[cur_insn].name);
>> +				continue;
>> +			}
>> +		}
>> +
>>   		if (insn_table[cur_insn].disabled) {
>>   			printf("\tFeature required for %s is not supported.\n",
>>   			       insn_table[cur_insn].name);
>> @@ -7490,6 +7500,13 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
>>   
>>   static void test_load_host_perf_global_ctrl(void)
>>   {
>> +	struct cpuid id = cpuid(10);
>> +
>> +	if (!(id.a & 0xff)) {
>> +		report_skip("test_load_host_perf_global_ctrl");
>> +		return;
>> +	}
>> +
>>   	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
>>   		printf("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
>>   		return;
>> @@ -7502,6 +7519,13 @@ static void test_load_host_perf_global_ctrl(void)
>>   
>>   static void test_load_guest_perf_global_ctrl(void)
>>   {
>> +	struct cpuid id = cpuid(10);
>> +
>> +	if (!(id.a & 0xff)) {
>> +		report_skip("test_load_guest_perf_global_ctrl");
>> +		return;
>> +	}
>> +
>>   	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
>>   		printf("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
>>   		return;
>> -- 
>> 2.31.1
>>
