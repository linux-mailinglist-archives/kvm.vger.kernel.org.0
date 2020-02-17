Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A06161328
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 14:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgBQNUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 08:20:08 -0500
Received: from mga06.intel.com ([134.134.136.31]:31422 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgBQNUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 08:20:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Feb 2020 05:20:07 -0800
X-IronPort-AV: E=Sophos;i="5.70,452,1574150400"; 
   d="scan'208";a="228416652"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.168.218]) ([10.249.168.218])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Feb 2020 05:20:05 -0800
Subject: Re: [RFC PATCH 1/2] KVM: CPUID: Enable supervisor XSAVE states in
 CPUID enumeration and XSS
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com,
        aaronlewis@google.com
References: <20200211065706.3462-1-weijiang.yang@intel.com>
 <a75a0e16-198d-9c96-3a63-d09a93909c0f@intel.com>
 <20200217130355.GA10854@local-michael-cet-test.sh.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <2125c47d-06c5-d559-c95c-a55a71790f31@intel.com>
Date:   Mon, 17 Feb 2020 21:20:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200217130355.GA10854@local-michael-cet-test.sh.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/2020 9:03 PM, Yang Weijiang wrote:
> On Mon, Feb 17, 2020 at 12:26:51PM +0800, Xiaoyao Li wrote:
>> On 2/11/2020 2:57 PM, Yang Weijiang wrote:
>>> CPUID.(EAX=DH, ECX={i}H i>=0) enumerates XSAVE related leaves/sub-leaves,
>>> +extern int host_xss;
>>> +u64 kvm_supported_xss(void)
>>> +{
>>> +	return KVM_SUPPORTED_XSS & host_xss;
>>> +}
>>> +
>>
>> How about using a global variable, supported_xss, instead of calculating the
>> mask on every call. Just like what Sean posted on
>> https://lore.kernel.org/kvm/20200201185218.24473-21-sean.j.christopherson@intel.com/
>>
> Thanks Xiaoyao for the comments!
> Good suggestion, I'll change it in next version.
> 
>>>    #define F(x) bit(X86_FEATURE_##x)
>>>    int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>>> @@ -112,10 +118,17 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>>>    		vcpu->arch.guest_xstate_size = best->ebx =
>>>    			xstate_required_size(vcpu->arch.xcr0, false);
>>>    	}
>>> -
>>>    	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
>>> -	if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
>>> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>>> +	if (best && (best->eax & (F(XSAVES) | F(XSAVEC)))) {
>>> +		u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
>>> +
>>> +		best->ebx = xstate_required_size(xstate, true);
>>> +		vcpu->arch.guest_supported_xss =
>>> +			(best->ecx | ((u64)best->edx << 32)) &
>>> +			kvm_supported_xss();
>>> +	} else {
>>> +		vcpu->arch.guest_supported_xss = 0;
>>> +	}
>>>    	/*
>>>    	 * The existing code assumes virtual address is 48-bit or 57-bit in the
>>> @@ -426,6 +439,56 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
>>>    	}
>>>    }
>>> +static inline bool do_cpuid_0xd_mask(struct kvm_cpuid_entry2 *entry, int index)
>>> +{
>>> +	unsigned int f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
>>> +	/* cpuid 0xD.1.eax */
>>> +	const u32 kvm_cpuid_D_1_eax_x86_features =
>>> +		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
>>> +	u64 u_supported = kvm_supported_xcr0();
>>> +	u64 s_supported = kvm_supported_xss();
>>> +	u64 supported;
>>> +
>>> +	switch (index) {
>>> +	case 0:
>>> +		if (!u_supported) {
>>> +			entry->eax = 0;
>>> +			entry->ebx = 0;
>>> +			entry->ecx = 0;
>>> +			entry->edx = 0;
>>> +			return false;
>>> +		}
>>> +		entry->eax &= u_supported;
>>> +		entry->ebx = xstate_required_size(u_supported, false);
>>> +		entry->ecx = entry->ebx;
>>> +		entry->edx &= u_supported >> 32;
>>> +		break;
>>> +	case 1:
>>> +		supported = u_supported | s_supported;
>>> +		entry->eax &= kvm_cpuid_D_1_eax_x86_features;
>>> +		cpuid_mask(&entry->eax, CPUID_D_1_EAX);
>>> +		entry->ebx = 0;
>>> +		entry->edx &= s_supported >> 32;
>>> +		entry->ecx &= s_supported;
>>
>> We'd better initialize msr_ia32_xss bitmap (entry->ecx & entry-edx) as zeros
>> here.
> Hmm, explicit setting the MSR to 0 is good in this case, but there's implied
> flow to ensure guest MSR_IA32_XSS will be 0 if entry->ecx and entry->edx are 0s.
> In above kvm_update_cpuid(), vcpu->arch.guest_supported_xss is set to 0
> when they're 0s. this masks guest cannot set non-zero value to this
> MSR. And in kvm_vcpu_reset(), vcpu->arch.ia32_xss is initialized to 0,
> in kvm_load_guest_xsave_state() MSR_IA32_XSS is set to ia32_xss,
> therefore the MSR is kept to 0.

Sorry, I think what I said "msr_ia32_xss bitmap" misled you.

"msr_ia32_xss bitmap" is not MSR_IA32_XSS,
but the (entry->ecx | entry->edx >> 32) of cpuid.D_1

I meant we'd better set entry->ecx and entry->edx to 0 here.

>>
>>> +		if (entry->eax & (F(XSAVES) | F(XSAVEC)))
>>> +			entry->ebx = xstate_required_size(supported, true);
>>
>> And setup msr_ia32_xss bitmap based on the s_supported within this condition
>> when F(XSAVES) is supported.
> 

And set entry->ecx & entry->edx only when F(XSAVES) is supported.

> IIUC, both XSAVEC and XSAVES use compacted format of the extended
> region, so if XSAVEC is supported while XSAVES is not, guest still can
> get correct size, so in existing code the two bits are ORed.

Yeah, but entry->ecx and entry->edx should be non-zero only when 
F(XSAVES) is set.

>>
>>> +		break;
>>> +	default:
>>> +		supported = (entry->ecx & 0x1) ? s_supported : u_supported;
>>> +		if (!(supported & (BIT_ULL(index)))) {
>>> +			entry->eax = 0;
>>> +			entry->ebx = 0;
>>> +			entry->ecx = 0;
>>> +			entry->edx = 0;
>>> +			return false;
>>> +		}
>>> +		if (entry->ecx & 0x1)
>>> +			entry->ebx = 0;
>>> +		break;
>>> +	}
>>> +	return true;
>>> +}
>>> +
>>>    static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>>>    				  int *nent, int maxnent)
>>>    {
>>> @@ -440,7 +503,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>>>    	unsigned f_lm = 0;
>>>    #endif
>>>    	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
>>> -	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
>>>    	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
>>>    	/* cpuid 1.edx */
>>> @@ -495,10 +557,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>>>    		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
>>>    		F(PMM) | F(PMM_EN);
>>> -	/* cpuid 0xD.1.eax */
>>> -	const u32 kvm_cpuid_D_1_eax_x86_features =
>>> -		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
>>> -
>>>    	/* all calls to cpuid_count() should be made on the same cpu */
>>>    	get_cpu();
>>> @@ -639,38 +697,21 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>>>    		break;
>>>    	}
>>>    	case 0xd: {
>>> -		int idx, i;
>>> -		u64 supported = kvm_supported_xcr0();
>>> +		int i, idx;
>>> -		entry->eax &= supported;
>>> -		entry->ebx = xstate_required_size(supported, false);
>>> -		entry->ecx = entry->ebx;
>>> -		entry->edx &= supported >> 32;
>>> -		if (!supported)
>>> +		if (!do_cpuid_0xd_mask(&entry[0], 0))
>>>    			break;
>>> -
>>> -		for (idx = 1, i = 1; idx < 64; ++idx) {
>>> -			u64 mask = ((u64)1 << idx);
>>> +		for (i = 1, idx = 1; idx < 64; ++idx) {
>>>    			if (*nent >= maxnent)
>>>    				goto out;
>>> -
>>>    			do_host_cpuid(&entry[i], function, idx);
>>> -			if (idx == 1) {
>>> -				entry[i].eax &= kvm_cpuid_D_1_eax_x86_features;
>>> -				cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
>>> -				entry[i].ebx = 0;
>>> -				if (entry[i].eax & (F(XSAVES)|F(XSAVEC)))
>>> -					entry[i].ebx =
>>> -						xstate_required_size(supported,
>>> -								     true);
>>> -			} else {
>>> -				if (entry[i].eax == 0 || !(supported & mask))
>>> -					continue;
>>> -				if (WARN_ON_ONCE(entry[i].ecx & 1))
>>> -					continue;
>>> -			}
>>> -			entry[i].ecx = 0;
>>> -			entry[i].edx = 0;
>>> +
>>> +			if (entry[i].eax == 0 && entry[i].ebx == 0 &&
>>> +			    entry[i].ecx == 0 && entry[i].edx == 0)
>>> +				continue;
>>> +
>>> +			if (!do_cpuid_0xd_mask(&entry[i], idx))
>>> +				continue;
>>>    			++*nent;
>>>    			++i;
>>>    		}
>   >
> 

