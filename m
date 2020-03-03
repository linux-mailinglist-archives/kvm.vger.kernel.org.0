Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33315176DEA
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 05:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgCCEQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 23:16:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:38597 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbgCCEQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 23:16:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 20:16:40 -0800
X-IronPort-AV: E=Sophos;i="5.70,510,1574150400"; 
   d="scan'208";a="233468716"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.30.67]) ([10.255.30.67])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Mar 2020 20:16:37 -0800
Subject: Re: [PATCH 1/6] KVM: x86: Fix tracing of CPUID.function when function
 is out-of-range
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-2-sean.j.christopherson@intel.com>
 <6b41fc5c-f7f4-b20d-cfb5-95bf13cc7534@intel.com>
 <20200303040851.GD27842@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <c32f1043-8178-9e9a-ce81-ab28b5d0583a@intel.com>
Date:   Tue, 3 Mar 2020 12:16:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303040851.GD27842@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/3/2020 12:08 PM, Sean Christopherson wrote:
> On Tue, Mar 03, 2020 at 10:50:03AM +0800, Xiaoyao Li wrote:
>> On 3/3/2020 3:57 AM, Sean Christopherson wrote:
>>> Rework kvm_cpuid() to query entry->function when adjusting the output
>>> values so that the original function (in the aptly named "function") is
>>> preserved for tracing.  This fixes a bug where trace_kvm_cpuid() will
>>> trace the max function for a range instead of the requested function if
>>> the requested function is out-of-range and an entry for the max function
>>> exists.
>>>
>>> Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
>>> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
>>> Cc: Jim Mattson <jmattson@google.com>
>>> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> ---
>>>   arch/x86/kvm/cpuid.c | 15 +++++++--------
>>>   1 file changed, 7 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index b1c469446b07..6be012937eba 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -997,12 +997,12 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
>>>   	return max && function <= max->eax;
>>>   }
>>> +/* Returns true if the requested leaf/function exists in guest CPUID. */
>>>   bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>>>   	       u32 *ecx, u32 *edx, bool check_limit)
>>>   {
>>> -	u32 function = *eax, index = *ecx;
>>> +	const u32 function = *eax, index = *ecx;
>>>   	struct kvm_cpuid_entry2 *entry;
>>> -	struct kvm_cpuid_entry2 *max;
>>>   	bool found;
>>>   	entry = kvm_find_cpuid_entry(vcpu, function, index);
>>> @@ -1015,18 +1015,17 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>>>   	 */
>>>   	if (!entry && check_limit && !guest_cpuid_is_amd(vcpu) &&
>>>   	    !cpuid_function_in_range(vcpu, function)) {
>>> -		max = kvm_find_cpuid_entry(vcpu, 0, 0);
>>> -		if (max) {
>>> -			function = max->eax;
>>> -			entry = kvm_find_cpuid_entry(vcpu, function, index);
>>> -		}
>>> +		entry = kvm_find_cpuid_entry(vcpu, 0, 0);
>>> +		if (entry)
>>> +			entry = kvm_find_cpuid_entry(vcpu, entry->eax, index);
>>
>> There is a problem.
>>
>> when queried leaf is out of range on Intel CPU, it returns the maximum basic
>> leaf, and any dependence on input ECX (i.e., subleaf) value in the basic
>> leaf is honored. As disclaimed in SDM of CPUID instruction.
> 
> That's what the code above does.
> 
>> The ECX should be honored if and only the leaf has a significant index.
>> If the leaf doesn't has a significant index, it just ignores the EDX input
> 
> s/EDX/ECX
> 
>> in bare metal.
>>
>> So it should be something like:
>>
>> if (!entry && check_limit && !guest_cpuid_is_amd(vcpu) &&
>> 	!cpuid_function_in_range(vcpu, function)) {
>> 	entry = kvm_find_cpuid_entry(vcpu, 0, 0);
>> 	if (entry) {
>> 		entry = kvm_find_cpuid_entry(vcpu, entry->eax, 0);
>> 		if (entry &&
>> 		    entry->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX ) {
> 
> This is unnecessary IMO.  The only scenario where SIGNFICANT_INDEX is 0
> and cpuid_entry(entry->eax, 0) != cpuid_entry(entry->eax, index) is if
> userspace created a cpuid entry for index>0 with SIGNFICANT_INDEX.  

I just forgot that is_matching_cpuid_entry() has taken SIGNIFICANT_INDEX 
into account.

Please ignore my stupid noise.

> a busted model, e.g. it'd be the SDM equivalent of an Intel CPU having
> different output for CPUID.0x16.0 and CPUID.16.5 despite the SDM stating
> that the CPUID.0x16 ignores the index.
> 
> E.g. on my system with a max basic leaf of 0x16
> 
> $ cpuid -1 -r
> CPU:
>     0x00000000 0x00: eax=0x00000016 ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69
> ...
>     0x00000016 0x00: eax=0x00000e74 ebx=0x0000125c ecx=0x00000064 edx=0x00000000
> 
> $ cpuid -1 -r -l 0x16
> CPU:
>     0x00000016 0x00: eax=0x00000e74 ebx=0x0000125c ecx=0x00000064 edx=0x00000000
> ~ $ cpuid -1 -r -l 0x16 -s 4
> CPU:
>     0x00000016 0x04: eax=0x00000e74 ebx=0x0000125c ecx=0x00000064 edx=0x00000000
> ~ $ cpuid -1 -r -l 0x16 -s 466
> CPU:
>     0x00000016 0x1d2: eax=0x00000e74 ebx=0x0000125c ecx=0x00000064 edx=0x00000000
> 
> 
> If it returned anything else for CPUID.0x16.0x4 then it'd be a CPU bug.
> Same thing here, it's a userspace bug if it creates a CPUID entry that
> shouldn't exist.  E.g. ignoring Intel's silly "max basic leaf" behavior
> for the moment, if userspace created a entry for CPUID.0x0.N it would
> break the Linux kernel's cpu_detect(), as it doesn't initialize ECX when
> doing CPUID.0x0.
> 
>> 			entry = kvm_find_cpuid_entry(vcpu, entry->eax,
>> 						     index);
>> 		}
>> 	}
>> }
>>
>>>   	}
>>>   	if (entry) {
>>>   		*eax = entry->eax;
>>>   		*ebx = entry->ebx;
>>>   		*ecx = entry->ecx;
>>>   		*edx = entry->edx;
>>> -		if (function == 7 && index == 0) {
>>> +
>>> +		if (entry->function == 7 && index == 0) {
>>>   			u64 data;
>>>   		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
>>>   			    (data & TSX_CTRL_CPUID_CLEAR))
>>>
>>

