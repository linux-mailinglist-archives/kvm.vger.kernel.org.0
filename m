Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF8277EEB8
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 03:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347521AbjHQB32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 21:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347505AbjHQB27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 21:28:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0166272B;
        Wed, 16 Aug 2023 18:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692235737; x=1723771737;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=reOe4K/NB9kxJWKf43y8QvKb9DpF3lZtmzRQIrussTc=;
  b=e4HgMwINjiy8dSBmXxL8ultoIyDDE+cY819zgzFx1ED0LLriZiJTEZQS
   iTJbAm4iVcB7Q6G5dTwoG9+1yBRVdws1p6LgJ3jVcyvNVB3ae0r6dSNBu
   DFRw5KML7+s/BKOQEz8r6mdQIkzB7a3p8AfchPujOxODIMlwUG6oJSmv8
   sbW/ahC00YVt4usPo9aZuFH3K0uFArJFF4RqSlIARU8W+WS9pocDEMxFW
   EBaEzzEbFltmmaTmOp02owXeuA+bJ+BCra7fFjAiM4Qrvo1fgBKZ+FbYM
   7DbCmln6ADP2vtBOAWA5idqBVcOyGac1D7Kg/m+venLot2USKgzU/N+Ho
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="357653555"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="357653555"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 18:28:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="980941656"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="980941656"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.52]) ([10.238.10.52])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 18:28:55 -0700
Message-ID: <244a3f0b-16fd-eac8-f207-1dfe7859410b@linux.intel.com>
Date:   Thu, 17 Aug 2023 09:28:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 3/9] KVM: x86: Use KVM-governed feature framework to
 track "LAM enabled"
To:     Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>,
        "David.Laight@ACULAB.COM" <David.Laight@aculab.com>,
        Guang Zeng <guang.zeng@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <20230719144131.29052-4-binbin.wu@linux.intel.com>
 <c4faf38ea79e0f4eb3d35d26c018cd2bfe9fe384.camel@intel.com>
 <66235c55-05ac-edd5-c45e-df1c42446eb3@linux.intel.com>
 <aa17648c001704d83dcf641c1c7e9894e65eb87a.camel@intel.com>
 <ZN1Ardu9GRx7KlAV@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZN1Ardu9GRx7KlAV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/17/2023 5:33 AM, Sean Christopherson wrote:
> On Wed, Aug 16, 2023, Kai Huang wrote:
>>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>>> @@ -7783,6 +7783,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>>>>    		vmx->msr_ia32_feature_control_valid_bits &=
>>>>>    			~FEAT_CTL_SGX_LC_ENABLED;
>>>>>    
>>>>> +	if (boot_cpu_has(X86_FEATURE_LAM))
>>>>> +		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LAM);
>>>>> +
>>>> If you want to use boot_cpu_has(), it's better to be done at your last patch to
>>>> only set the cap bit when boot_cpu_has() is true, I suppose.
>>> Yes, but new version of kvm_governed_feature_check_and_set() of
>>> KVM-governed feature framework will check against kvm_cpu_cap_has() as well.
>>> I will remove the if statement and call
>>> kvm_governed_feature_check_and_set()  directly.
>>> https://lore.kernel.org/kvm/20230815203653.519297-2-seanjc@google.com/
>>>
>> I mean kvm_cpu_cap_has() checks against the host CPUID directly while here you
>> are using boot_cpu_has().  They are not the same.
>>
>> If LAM should be only supported when boot_cpu_has() is true then it seems you
>> can just only set the LAM cap bit when boot_cpu_has() is true.  As you also
>> mentioned above the kvm_governed_feature_check_and_set() here internally does
>> kvm_cpu_cap_has().
> That's covered by the last patch:
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e961e9a05847..06061c11d74d 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -677,7 +677,7 @@ void kvm_set_cpu_caps(void)
>          kvm_cpu_cap_mask(CPUID_7_1_EAX,
>                  F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
>                  F(FZRM) | F(FSRS) | F(FSRC) |
> -               F(AMX_FP16) | F(AVX_IFMA)
> +               F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
>          );
>   
>          kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
>
>
> Which highlights a problem with activating a goverened feature before said feature
> is actually supported by KVM: it's all kinds of confusing.
>
> It'll generate a more churn in git history, but I think we should first enable
> LAM without a goverened feature, and then activate a goverened feature later on.
> Using a goverened feature is purely an optimization, i.e. the series needs to be
> function without using a governed feature.
OK, then how about the second option which has been listed in your v9 
patch series discussion.
https://lore.kernel.org/kvm/20230606091842.13123-1-binbin.wu@linux.intel.com/T/#m16ee5cec4a46954f985cb6afedb5f5a3435373a1

Temporarily add a bool can_use_lam in kvm_vcpu_arch and use the bool
"can_use_lam" instead of guest_can_use(vcpu, X86_FEATURE_LAM).
and then put the patch of adopting "KVM-governed feature framework" to 
the last.


>
> That should yield an easier-to-review series on all fronts: the initial supports
> won't have any more hidden dependencies than absolutely necessary, switching to
> a goverened feature should be a very mechanical conversion (if it's not, that's
> a red flag), and last but not least, it makes it super easy to make a judgment
> call as to whether using a governed feature flag is justified, because all of the
> users will be in scope.
>
> TL;DR: Do the whole goverened feature thing dead last.

