Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C056EBC54
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 03:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjDWBmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 21:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjDWBmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 21:42:23 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2709A1713
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 18:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682214142; x=1713750142;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=P6080je90lIovriavxQfpQRi4x/WMp/xCSI7yBxP4fQ=;
  b=iOtb2dJ5Lwyg1reNjwB0f+bgZCdVtDRCvOQLGcurMxMmkAKzF/LmM6MO
   pLIAsT/KpfByu/Ybg6AoR5Pot4A+YCTqcu84Axfr7UUsw5rpoUFJO1h4g
   34VS0XmwBKErUQA/1xMOxqloHkw3l3F7xMcIl/8hIdLVNzSMFyD/8YpB4
   gOtNbk/gv0ar/fLz8YXLUyLmpRR/JcW/kO+EZ1ApWwmNJSyG8l04K2Hk6
   xFLdJ6oxILlwBPjsYw1uDxcszADDsI10dg0ztxtQMe3hQA0qz++CuxtKu
   p0QfhslJm1U0+ZITs8ltQQAlOnAt12i4iA58OGYzK+Q8NZWwUD2ykPooo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="335109507"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="335109507"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 18:42:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="816820036"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="816820036"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.214.112]) ([10.254.214.112])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 18:42:20 -0700
Message-ID: <b8b94944-c69c-63a8-1cfd-2d267d2d9efe@linux.intel.com>
Date:   Sun, 23 Apr 2023 09:42:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests v3 1/4] x86: Allow setting of CR3 LAM bits if LAM
 supported
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        robert.hu@linux.intel.com
References: <20230412075134.21240-1-binbin.wu@linux.intel.com>
 <20230412075134.21240-2-binbin.wu@linux.intel.com>
 <ZEHuuAw39ZXopaqN@chao-email>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZEHuuAw39ZXopaqN@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/21/2023 10:02 AM, Chao Gao wrote:
> On Wed, Apr 12, 2023 at 03:51:31PM +0800, Binbin Wu wrote:
>> If LAM is supported, VM entry allows CR3.LAM_U48 (bit 62) and CR3.LAM_U57
>> (bit 61) to be set in CR3 field.
>>
>> Change the test result expectations when setting CR3.LAM_U48 or CR3.LAM_U57
>> on vmlaunch tests when LAM is supported.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Reviewed-by: Chao Gao <chao.gao@intel.com>
>> ---
>> lib/x86/processor.h | 3 +++
>> x86/vmx_tests.c     | 6 +++++-
>> 2 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 3d58ef7..e00a32b 100644
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
>> @@ -248,6 +250,7 @@ static inline bool is_intel(void)
>> #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
>> #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
>> #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
>> +#define	X86_FEATURE_LAM			(CPUID(0x7, 1, EAX, 26))
>>
>> /*
>>   * Extended Leafs, a.k.a. AMD defined
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index 7bba816..5ee1264 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -7000,7 +7000,11 @@ static void test_host_ctl_regs(void)
>> 		cr3 = cr3_saved | (1ul << i);
>> 		vmcs_write(HOST_CR3, cr3);
>> 		report_prefix_pushf("HOST_CR3 %lx", cr3);
>> -		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>> +		if (this_cpu_has(X86_FEATURE_LAM) &&
>> +		    ((i == X86_CR3_LAM_U57_BIT) || ( i == X86_CR3_LAM_U48_BIT)))
> 						    ^ stray space


Thanks, will remove it.

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
