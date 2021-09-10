Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E29C40657A
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 03:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhIJCAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 22:00:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:7224 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhIJCAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 22:00:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10102"; a="208073443"
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="208073443"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 18:59:27 -0700
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="540085015"
Received: from unknown (HELO [10.239.13.122]) ([10.239.13.122])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 18:59:25 -0700
Subject: Re: [PATCH v2 6/7] KVM: VMX: Check Intel PT related CPUID leaves
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
 <20210827070249.924633-7-xiaoyao.li@intel.com> <YTp/oGmiin19q4sQ@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <a7988439-5a4c-3d5a-ea4a-0fad181ad733@intel.com>
Date:   Fri, 10 Sep 2021 09:59:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YTp/oGmiin19q4sQ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/10/2021 5:41 AM, Sean Christopherson wrote:
> On Fri, Aug 27, 2021, Xiaoyao Li wrote:
>> CPUID 0xD leaves reports the capabilities of Intel PT, e.g. it decides
>> which bits are valid to be set in MSR_IA32_RTIT_CTL, and reports the
>> number of PT ADDR ranges.
>>
>> KVM needs to check that guest CPUID values set by userspace doesn't
>> enable any bit which is not supported by bare metal. Otherwise,
>> 1. it will trigger vm-entry failure if hardware unsupported bit is
>>     exposed to guest and set by guest.
>> 2. it triggers #GP when context switch PT MSRs if exposing more
>>     RTIT_ADDR* MSRs than hardware capacity.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> There is bit 31 of CPUID(0xD, 0).ECX that doesn't restrict any bit in
>> MSR_IA32_RTIT_CTL. If guest has different value than host, it won't
>> cause any vm-entry failure, but guest will parse the PT packet with
>> wrong format.
>>
>> I also check it to be same as host to ensure the virtualization correctness.
>>
>> Changes in v2:
>> - Call out that if configuring more PT ADDR MSRs than hardware, it can
>>    cause #GP when context switch.
>> ---
>>   arch/x86/kvm/cpuid.c | 25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 739be5da3bca..0c8e06a24156 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -76,6 +76,7 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
>>   static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
>>   {
>>   	struct kvm_cpuid_entry2 *best;
>> +	u32 eax, ebx, ecx, edx;
>>   
>>   	/*
>>   	 * The existing code assumes virtual address is 48-bit or 57-bit in the
>> @@ -89,6 +90,30 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
>>   			return -EINVAL;
>>   	}
>>   
>> +	/*
>> +	 * CPUID 0xD leaves tell Intel PT capabilities, which decides
> 
> CPUID.0xD is XSAVE state, CPUID.0x14 is Intel PT.  This series needs tests...

My apologize.

>> +	 * pt_desc.ctl_bitmask in later update_intel_pt_cfg().
>> +	 *
>> +	 * pt_desc.ctl_bitmask decides the legal value for guest
>> +	 * MSR_IA32_RTIT_CTL. KVM cannot support PT capabilities beyond native,
>> +	 * otherwise it will trigger vm-entry failure if guest sets native
>> +	 * unsupported bits in MSR_IA32_RTIT_CTL.
>> +	 */
>> +	best = cpuid_entry2_find(entries, nent, 0xD, 0);
>> +	if (best) {
>> +		cpuid_count(0xD, 0, &eax, &ebx, &ecx, &edx);
>> +		if (best->ebx & ~ebx || best->ecx & ~ecx)
>> +			return -EINVAL;
>> +	}
>> +	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>> +	if (best) {
>> +		cpuid_count(0xD, 0, &eax, &ebx, &ecx, &edx);
>> +		if (((best->eax & 0x7) > (eax & 0x7)) ||
> 
> Ugh, looking at the rest of the code, even this isn't sufficient because
> pt_desc.guest.addr_{a,b} are hardcoded at 4 entries, i.e. running KVM on hardware
> with >4 entries will lead to buffer overflows.

it's hardcoded to 4 because there is a note of "no processors support 
more than 4 address ranges" in SDM vol.3 Chapter 31.3.1, table 31-11

> One option would be to bump that to the theoretical max of 15, which doesn't seem
> too horrible, especially if pt_desc as a whole is allocated on-demand, which it
> probably should be since it isn't exactly tiny (nor ubiquitous)
> 
> A different option would be to let userspace define whatever it wants for guest
> CPUID, and instead cap nr_addr_ranges at min(host.cpuid, guest.cpuid, RTIT_ADDR_RANGE).
> 
> Letting userspace generate a bad MSR_IA32_RTIT_CTL is not problematic, there are
> plenty of ways userspace can deliberately trigger VM-Entry failure due to invalid
> guest state (even if this is a VM-Fail condition, it's not a danger to KVM).

I'm fine to only safe guard the nr_addr_range if VM-Entry failure 
doesn't matter.

> 
>> +		    ((best->eax & ~eax) >> 16) ||
>> +		    (best->ebx & ~ebx))
>> +			return -EINVAL;
>> +	}
>> +
>>   	return 0;
>>   }
>>   
>> -- 
>> 2.27.0
>>

