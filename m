Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DC26D58AD
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 08:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbjDDGS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 02:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbjDDGSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 02:18:50 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486042705
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 23:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680589096; x=1712125096;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VDyMFgzKCaJ9TnC9ECWNQFyHiJvgRFWuo7ncWcBsgYs=;
  b=RHJz9Q35aXdV6sTD382zCfFxZJf1iwnAnrdllEviFpLvOuNM08seIR/1
   xXqwFBsayZcIUz4bBExYCtQ09sCGJSmND6j+SOZu1kcolRtTSKg5rurOk
   AcQLqYtoSsIYjFawQ/8zIU39Vx8ikHmxLXbGaftU7BuG3jMeyeUF1dMO3
   vxbe34tJ3SmzqHAQ73Ucl9gC16Tq7wh1pNyReGExKHc9JcvKlDQpcEavy
   Wowr4rSDhGpu6eyapv2hro24pAvoaJJffzKuw8clN42RNffIpOWqPxoCS
   pdz2YXaKR9itEKIh4AxqQfK6jFzFwKIIB7Sw0PBzqHp/qxa/EMwgKOUtb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="407161253"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="407161253"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 23:18:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="663464967"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="663464967"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.215.140]) ([10.254.215.140])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 23:18:12 -0700
Message-ID: <23cb6ccf-18e6-2728-e2b4-def4d9e9c601@linux.intel.com>
Date:   Tue, 4 Apr 2023 14:18:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v2 1/4] x86: Allow setting of CR3 LAM bits
 if LAM supported
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        robert.hu@linux.intel.com
References: <20230319083732.29458-1-binbin.wu@linux.intel.com>
 <20230319083732.29458-2-binbin.wu@linux.intel.com> <ZCu6+kqF2asJvwWU@gao-cwp>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZCu6+kqF2asJvwWU@gao-cwp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/4/2023 1:51 PM, Chao Gao wrote:
> On Sun, Mar 19, 2023 at 04:37:29PM +0800, Binbin Wu wrote:
>> If LAM is supported, VM entry allows CR3.LAM_U48 (bit 62) and CR3.LAM_U57
>> (bit 61) to be set in CR3 field.
>>
>> Change the test result expectations when setting CR3.LAM_U48 or CR3.LAM_U57
>> on vmlaunch tests when LAM is supported.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
> and two nits below:

Thanks, will update it.


>
>> ---
>> lib/x86/processor.h | 2 ++
>> x86/vmx_tests.c     | 6 +++++-
>> 2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 3d58ef7..8373bbe 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -55,6 +55,8 @@
>> #define X86_CR0_PG		BIT(X86_CR0_PG_BIT)
>>
>> #define X86_CR3_PCID_MASK	GENMASK(11, 0)
>> +#define X86_CR3_LAM_U57_BIT	(61)
>> +#define X86_CR3_LAM_U48_BIT	(62)
>>
>> #define X86_CR4_VME_BIT		(0)
>> #define X86_CR4_VME		BIT(X86_CR4_VME_BIT)
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index 7bba816..1be22ac 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -7000,7 +7000,11 @@ static void test_host_ctl_regs(void)
>> 		cr3 = cr3_saved | (1ul << i);
>> 		vmcs_write(HOST_CR3, cr3);
>> 		report_prefix_pushf("HOST_CR3 %lx", cr3);
>> -		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>> +		if (this_cpu_has(X86_FEATURE_LAM) &&
> Nit: X86_FEATURE_LAM should be defined in this patch (instead of patch 2).
>
>> +		    ((i==X86_CR3_LAM_U57_BIT) || (i==X86_CR3_LAM_U48_BIT)))
> Nit: spaces are needed around "==" i.e.,
>
> 	((i == X86_CR3_LAM_U57_BIT) || (i == X86_CR3_LAM_U48_BIT)))
>
>> +			test_vmx_vmlaunch(0);
>> +		else
>> +			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>> 		report_prefix_pop();
>> 	}
>>
>> -- 
>> 2.25.1
>>
