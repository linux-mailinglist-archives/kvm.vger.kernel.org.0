Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD33D606E33
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 05:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJUDNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 23:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiJUDNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 23:13:05 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1441A1D7982;
        Thu, 20 Oct 2022 20:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666321982; x=1697857982;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t0mbhePNMhxVH3bu6M8dRQS/SgQ0nfCNRaQmnJ0MhhY=;
  b=AuHdmcUpL2bRLPiHfYxC2d+mne7L6GJRO1ax81enQhEOYxdxhuzh76ZQ
   YhZpX9V8JvjnO6Q3FlSH2OpspV/nFbFToVe0LVOCtX5Nzfvc17S1AsRJO
   7Ua3wx35v+sXrkNb6kfGEtz6tA9r3vdA65i3gxTNNCkG2CdNU+Ti3l4wn
   AK6Fc5feGAEmbNhMyrrjY8P4+fEdMnHHqMV+GUBdzZDTqWIeGFaDBBYkL
   lQ26FX1b91bCxn9N5Ey0eLN4Cp9Ik7pespsGpnJoXlu+QR6GkKoTxU88X
   sDxTaL50lG6yMkDxLja8YfOD3fBlY0wRIcpnIcS26QtY3UaTYC3z+Iawx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="294295175"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="294295175"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 20:13:01 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="755546133"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="755546133"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.117]) ([10.255.28.117])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 20:13:00 -0700
Message-ID: <b40fd338-cb3b-b602-0059-39f775e77ad6@intel.com>
Date:   Fri, 21 Oct 2022 11:12:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.3
Subject: Re: [PATCH] KVM: x86: Fix the initial value of mcg_cap
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221020031615.890400-1-xiaoyao.li@intel.com>
 <Y1FatU6Yf9n5pWB+@google.com>
 <092dc961-76f6-331a-6f91-a77a58f6732d@intel.com>
 <Y1F4AoeOhNFQnHnJ@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Y1F4AoeOhNFQnHnJ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/2022 12:32 AM, Sean Christopherson wrote:
> On Thu, Oct 20, 2022, Xiaoyao Li wrote:
>> On 10/20/2022 10:27 PM, Sean Christopherson wrote:
>>> On Thu, Oct 20, 2022, Xiaoyao Li wrote:
>>>> vcpu->arch.mcg_cap represents the value of MSR_IA32_MCG_CAP. It's
>>>> set via ioctl(KVM_X86_SETUP_MCE) from userspace when exposing and
>>>> configuring MCE to guest.
>>>>
>>>> It's wrong to leave the default value as KVM_MAX_MCE_BANKS.
>>>
>>> Why?  I agree it's an odd default, but the whole MCE API is odd.  Functionally,
>>> I don't see anything that's broken by allowing the guest to access the MCx_CTL MSRs
>>> by default.
>>
>> Yes. Allowing the access doesn't cause any issue for a VM.
>>
>> However, for the perspective of virtualization. It virtualizes a magic
>> hardware that even CPUID.MCA/MCE is not advertised and MCE is not set up by
>> userspace, guest is told there are 32 banks and all the banks can be
>> accessed.
> 
> '0' isn't necessarily better though, e.g. if userspace parrots back KVM's "supported"
> CPUID without invoking KVM_X86_SETUP_MCE, then it's equally odd that the guest will
> see no supported MCE MSRS.
> 
> Older versions of the SDM also state (or at least very strongly imply) that banks
> 0-3 are always available on P6.
> 
> Bank 0 is an especially weird case, as several of the MSRs are aliased to other
> MSRs that predate the machine check architecture.
> 
> Anyways, if this were newly introduced code I'd be all for defaulting to '0', but
> KVM has defaulted to KVM_MAX_MCE_BANKS since KVM_X86_SETUP_MCE was added way back
> in 2009.  Unless there's a bug that's fixed by this, I'm inclined to keep the
> current behavior even though it's weird, as hiding all MCE MSRs by default could
> theoretically cause a regression, e.g. by triggering #GP on MSRs that an older
> guest expects to always exist.

fair enough.

> If we really want to clean up this code, I think the correct approach would be to
> inject #GP on all relevant MSRs if CPUID.MCA==0, e.g.

It's what I thought of as well. But I didn't find any statement in SDM 
of "Accessing Machine Check MSRs gets #GP if no CPUID.MCA"

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4bd5f8a751de..97fafd851d8d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3260,6 +3260,9 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>          u64 data = msr_info->data;
>          u32 offset, last_msr;
>   
> +       if (!msr_info->host_initiated && !guest_cpuid_has(X86_FEATURE_MCA))
> +               return 1;
> +
>          switch (msr) {
>          case MSR_IA32_MCG_STATUS:
>                  vcpu->arch.mcg_status = data;
> @@ -3891,6 +3894,14 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
>          unsigned bank_num = mcg_cap & 0xff;
>          u32 offset, last_msr;
>   
> +       if (msr == MSR_IA32_P5_MC_ADDR || msr == MSR_IA32_P5_MC_TYPE) {
> +               *pdata = 0;
> +               return 0;
> +       }
> +
> +       if (!host && !guest_cpuid_has(X86_FEATURE_MCA))
> +               return 1;
> +
>          switch (msr) {
>          case MSR_IA32_P5_MC_ADDR:
>          case MSR_IA32_P5_MC_TYPE:
> 
> Or alternatively, this should work too:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4bd5f8a751de..e4a44d7af0a6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3774,6 +3774,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>          case MSR_IA32_MCG_STATUS:
>          case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
>          case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
> +               if (!msr_info->host_initiated &&
> +                   !guest_cpuid_has(X86_FEATURE_MCA))
> +                       return 1;
>                  return set_msr_mce(vcpu, msr_info);
>   
>          case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
> @@ -4142,13 +4145,17 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   
>                  msr_info->data = vcpu->arch.msr_kvm_poll_control;
>                  break;
> -       case MSR_IA32_P5_MC_ADDR:
> -       case MSR_IA32_P5_MC_TYPE:
>          case MSR_IA32_MCG_CAP:
>          case MSR_IA32_MCG_CTL:
>          case MSR_IA32_MCG_STATUS:
>          case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
>          case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
> +               if (!msr_info->host_initiated &&
> +                   !guest_cpuid_has(X86_FEATURE_MCA))
> +                       return 1;
> +               fallthrough;
> +       case MSR_IA32_P5_MC_ADDR:
> +       case MSR_IA32_P5_MC_TYPE:
>                  return get_msr_mce(vcpu, msr_info->index, &msr_info->data,
>                                     msr_info->host_initiated);
>          case MSR_IA32_XSS:
> 

