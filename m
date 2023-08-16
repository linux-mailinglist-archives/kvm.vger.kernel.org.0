Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E71577DAF4
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 09:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242274AbjHPHLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 03:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242291AbjHPHLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 03:11:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF624210E;
        Wed, 16 Aug 2023 00:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692169861; x=1723705861;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Avk47HRr7hmd3aiB6mFoRtvYzU40ndIbm2aY2S3QoHo=;
  b=iTlD8kyKPJ8HKHEOrZCNzkj0OM9/AiIbXT2x7yDRiDxSpvqmbsYLSiPb
   WGL3R763bf/JcL92Tg90S584aj0SCrj2e8OhIWhae8fEDSB1sYNkCBw1t
   EDVlmXDapdlTIUPrUF1fMba4QYe9fy2ZABZO0PRAUOmADDcE8DwndAnpt
   TUnBtf/wXW4mT6zS6ViKP8EKdsisg1pwMcJeMk2a12zh+NJ9CPrgvSFRB
   v6iKxv9C3U9ngX3Wpc24C2twmZQODU8U7OtjPQ1CdMetsaVzXsNWRWL0p
   8l9V1j9IataEytJVFjCI9Uqe2sxGl27aatkMbSDp2BrxYZYLuE6AhWeVx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="369933508"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="369933508"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 00:08:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="769084380"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="769084380"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.52]) ([10.238.10.52])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 00:08:56 -0700
Message-ID: <66235c55-05ac-edd5-c45e-df1c42446eb3@linux.intel.com>
Date:   Wed, 16 Aug 2023 15:08:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 3/9] KVM: x86: Use KVM-governed feature framework to
 track "LAM enabled"
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <20230719144131.29052-4-binbin.wu@linux.intel.com>
 <c4faf38ea79e0f4eb3d35d26c018cd2bfe9fe384.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <c4faf38ea79e0f4eb3d35d26c018cd2bfe9fe384.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/16/2023 11:46 AM, Huang, Kai wrote:
> On Wed, 2023-07-19 at 22:41 +0800, Binbin Wu wrote:
>> Use the governed feature framework to track if Linear Address Masking (LAM)
>> is "enabled", i.e. if LAM can be used by the guest. So that guest_can_use()
>> can be used to support LAM virtualization.
> Better to explain why to use governed feature for LAM?  Is it because there's
> hot path(s) calling guest_cpuid_has()?  Anyway some context of why can help
> here.
Yes, to avoid calling guest_cpuid_has() in CR3 handling and instruction 
emulation paths.
I will add the context next version.
Thanks!

>
>> LAM modifies the checking that is applied to 64-bit linear addresses, allowing
>> software to use of the untranslated address bits for metadata and masks the
>> metadata bits before using them as linear addresses to access memory.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>>   arch/x86/kvm/governed_features.h | 2 ++
>>   arch/x86/kvm/vmx/vmx.c           | 3 +++
>>   2 files changed, 5 insertions(+)
>>
>> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
>> index 40ce8e6608cd..708578d60e6f 100644
>> --- a/arch/x86/kvm/governed_features.h
>> +++ b/arch/x86/kvm/governed_features.h
>> @@ -5,5 +5,7 @@ BUILD_BUG()
>>   
>>   #define KVM_GOVERNED_X86_FEATURE(x) KVM_GOVERNED_FEATURE(X86_FEATURE_##x)
>>   
>> +KVM_GOVERNED_X86_FEATURE(LAM)
>> +
>>   #undef KVM_GOVERNED_X86_FEATURE
>>   #undef KVM_GOVERNED_FEATURE
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 0ecf4be2c6af..ae47303c88d7 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7783,6 +7783,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   		vmx->msr_ia32_feature_control_valid_bits &=
>>   			~FEAT_CTL_SGX_LC_ENABLED;
>>   
>> +	if (boot_cpu_has(X86_FEATURE_LAM))
>> +		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LAM);
>> +
> If you want to use boot_cpu_has(), it's better to be done at your last patch to
> only set the cap bit when boot_cpu_has() is true, I suppose.
Yes, but new version of kvm_governed_feature_check_and_set() of 
KVM-governed feature framework will check against kvm_cpu_cap_has() as well.
I will remove the if statement and call 
kvm_governed_feature_check_and_set()  directly.
https://lore.kernel.org/kvm/20230815203653.519297-2-seanjc@google.com/


>
>>   	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>>   	vmx_update_exception_bitmap(vcpu);
>>   }

