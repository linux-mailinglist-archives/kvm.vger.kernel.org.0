Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3705141E1
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 07:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354199AbiD2Fsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 01:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354162AbiD2Fs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 01:48:28 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEED83FBD9;
        Thu, 28 Apr 2022 22:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651211109; x=1682747109;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=zvnfBG7BKg/DyeMcD9WDj5UDxwVxbi2ih2bn8ZMBFwc=;
  b=imcmbKB/86pP2+taGtwBZGdtKtYXVSkify1cx5sRFL6cxHj1PS98joc0
   9l+MqRSrJcp9hQbnLfiy7FQQfN7rVMKaz7CohvzqObhS54WK2b3V0jFc4
   zyR3YwG/Fpm63phGLs++lvukovSdjh0Xf605CBkqkg3xsf5y6VXcMQJlB
   cL9htnNdVL+EjXIKpLFJEwYhcgAgpYjr4XdTlMuK5AXwpseYEi+tervRy
   TeGVZQfVIZxvggVb5dICKE9jy7Pwtdn64+FNzF5MQHGF0Is0exGXjRP2R
   aEguVhydzqKa2mvKE/z4KqV5TKNXnXdtLz2Okoa26aYWQ7BJkRoSdnin+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266065800"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="266065800"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 22:45:09 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="560126685"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.171.134]) ([10.249.171.134])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 22:45:06 -0700
Message-ID: <cc1089a8-cbb6-4148-2721-9beb694591b7@intel.com>
Date:   Fri, 29 Apr 2022 13:45:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v10 08/16] KVM: x86/pmu: Refactor code to support guest
 Arch LBR
Content-Language: en-US
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220422075509.353942-1-weijiang.yang@intel.com>
 <20220422075509.353942-9-weijiang.yang@intel.com>
 <4ad3bbff-8577-8e84-6ed9-b6f90e018224@linux.intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <4ad3bbff-8577-8e84-6ed9-b6f90e018224@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/28/2022 10:18 PM, Liang, Kan wrote:
>
> On 4/22/2022 3:55 AM, Yang Weijiang wrote:
>> Take account of Arch LBR when do sanity checks before program
>> vPMU for guest. Pass through Arch LBR recording MSRs to guest
>> to gain better performance. Note, Arch LBR and Legacy LBR support
>> are mutually exclusive, i.e., they're not both available on one
>> platform.
>>
>> Co-developed-by: Like Xu <like.xu@linux.intel.com>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>    arch/x86/kvm/vmx/pmu_intel.c | 37 +++++++++++++++++++++++++++++-------
>>    arch/x86/kvm/vmx/vmx.c       |  3 +++
>>    2 files changed, 33 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 7dc8a5783df7..cb28888e9f4f 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -170,12 +170,16 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
>>    
>>    bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
>>    {
>> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>> +		return guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
>> +
>>    	/*
>>    	 * As a first step, a guest could only enable LBR feature if its
>>    	 * cpu model is the same as the host because the LBR registers
>>    	 * would be pass-through to the guest and they're model specific.
>>    	 */
>> -	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
>> +	return !boot_cpu_has(X86_FEATURE_ARCH_LBR) &&
>> +		boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
>>    }
>>    
>>    bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
>> @@ -193,12 +197,19 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
> I think we should move MSR_ARCH_LBR_DEPTH and MSR_ARCH_LBR_CTL to this
> function as well, since they are LBR related MSRs.
Makes sense, will change it in next version.
>
>>    	if (!intel_pmu_lbr_is_enabled(vcpu))
>>    		return ret;
>>    
>> -	ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
>> -		(index >= records->from && index < records->from + records->nr) ||
>> -		(index >= records->to && index < records->to + records->nr);
>> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +		ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS);
>> +
>> +	if (!ret) {
>> +		ret = (index >= records->from &&
>> +		       index < records->from + records->nr) ||
>> +		      (index >= records->to &&
>> +		       index < records->to + records->nr);
>> +	}
>>    
>>    	if (!ret && records->info)
>> -		ret = (index >= records->info && index < records->info + records->nr);
>> +		ret = (index >= records->info &&
>> +		       index < records->info + records->nr);
> Please use "{}" since you split it to two lines.
OK.
>
> Thanks,
> Kan
>>    
>>    	return ret;
>>    }
>> @@ -747,6 +758,9 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
>>    			vmx_set_intercept_for_msr(vcpu, lbr->info + i, MSR_TYPE_RW, set);
>>    	}
>>    
>> +	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +		return;
>> +
>>    	vmx_set_intercept_for_msr(vcpu, MSR_LBR_SELECT, MSR_TYPE_RW, set);
>>    	vmx_set_intercept_for_msr(vcpu, MSR_LBR_TOS, MSR_TYPE_RW, set);
>>    }
>> @@ -787,10 +801,13 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>>    {
>>    	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>    	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>> +	bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
>> +		(vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
>> +		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
>>    
>>    	if (!lbr_desc->event) {
>>    		vmx_disable_lbr_msrs_passthrough(vcpu);
>> -		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
>> +		if (lbr_enable)
>>    			goto warn;
>>    		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
>>    			goto warn;
>> @@ -807,13 +824,19 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>>    	return;
>>    
>>    warn:
>> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>> +		wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
>>    	pr_warn_ratelimited("kvm: vcpu-%d: fail to passthrough LBR.\n",
>>    		vcpu->vcpu_id);
>>    }
>>    
>>    static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>>    {
>> -	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
>> +	bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
>> +		(vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
>> +		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
>> +
>> +	if (!lbr_enable)
>>    		intel_pmu_release_guest_lbr_event(vcpu);
>>    }
>>    
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 73961fcfb62d..a1816c6597f5 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -573,6 +573,9 @@ static bool is_valid_passthrough_msr(u32 msr)
>>    	case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 31:
>>    	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
>>    	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>> +	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
>> +	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
>> +	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
>>    		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
>>    		return true;
>>    	}
