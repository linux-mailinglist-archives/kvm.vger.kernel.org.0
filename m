Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8137212F7A
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 00:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgGBW2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 18:28:44 -0400
Received: from mga07.intel.com ([134.134.136.100]:50847 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgGBW2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 18:28:44 -0400
IronPort-SDR: q1svIC/YizTQ8ydy7ch0L9qAarSa0Odr+qyCSqeC4fZzQFI9WTj2xylQf1VoRGb51u6IE4Z/gB
 Mei0qIZRNJzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="212067387"
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="212067387"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 15:28:43 -0700
IronPort-SDR: +1ViAuCQOuQdfSMX2B6BmxcYDEibA9bsT17rtsST1DOrzyDSk9PLkOOWAwW4iNwPFAZTNXqp4R
 I+2QHHdq2MVA==
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="426100146"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.34]) ([10.255.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 15:28:41 -0700
Subject: Re: [PATCH v2 2/7] KVM: X86: Go on updating other CPUID leaves when
 leaf 1 is absent
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200623115816.24132-1-xiaoyao.li@intel.com>
 <20200623115816.24132-3-xiaoyao.li@intel.com>
 <20200702185403.GH3575@linux.intel.com>
 <20200702190237.GK3575@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <54c1cea0-75d5-c38f-c3e5-a8a0679c5fcf@intel.com>
Date:   Fri, 3 Jul 2020 06:28:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200702190237.GK3575@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/3/2020 3:02 AM, Sean Christopherson wrote:
> On Thu, Jul 02, 2020 at 11:54:03AM -0700, Sean Christopherson wrote:
>> On Tue, Jun 23, 2020 at 07:58:11PM +0800, Xiaoyao Li wrote:
>>> As handling of bits other leaf 1 added over time, kvm_update_cpuid()
>>> should not return directly if leaf 1 is absent, but should go on
>>> updateing other CPUID leaves.
>>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> This should probably be marked for stable.
>>
>>> ---
>>>   arch/x86/kvm/cpuid.c | 23 +++++++++++------------
>>>   1 file changed, 11 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 1d13bad42bf9..0164dac95ef5 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -60,22 +60,21 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>>>   	struct kvm_lapic *apic = vcpu->arch.apic;
>>>   
>>>   	best = kvm_find_cpuid_entry(vcpu, 1, 0);
>>> -	if (!best)
>>> -		return 0;
>>
>> Rather than wrap the existing code, what about throwing it in a separate
>> helper?  That generates an easier to read diff and also has the nice
>> property of getting 'apic' out of the common code.
> 
> Hrm, that'd be overkill once the apic code is moved in a few patches.
> What if you keep the cpuid updates wrapped (as in this patch), but then
> do
> 
> 	if (best && apic) {
> 	}
> 
> for the apic path?  That'll minimize churn for code that is disappearing,
> e.g. will make future git archaeologists happy :-).

Sure. I'll do it in next version.

>>> -
>>> -	/* Update OSXSAVE bit */
>>> -	if (boot_cpu_has(X86_FEATURE_XSAVE) && best->function == 0x1)
>>> -		cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
>>> +	if (best) {
>>> +		/* Update OSXSAVE bit */
>>> +		if (boot_cpu_has(X86_FEATURE_XSAVE))
>>> +			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
>>>   				   kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE));
>>>   
>>> -	cpuid_entry_change(best, X86_FEATURE_APIC,
>>> +		cpuid_entry_change(best, X86_FEATURE_APIC,
>>>   			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
>>>   
>>> -	if (apic) {
>>> -		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
>>> -			apic->lapic_timer.timer_mode_mask = 3 << 17;
>>> -		else
>>> -			apic->lapic_timer.timer_mode_mask = 1 << 17;
>>> +		if (apic) {
>>> +			if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
>>> +				apic->lapic_timer.timer_mode_mask = 3 << 17;
>>> +			else
>>> +				apic->lapic_timer.timer_mode_mask = 1 << 17;
>>> +		}
>>>   	}
>>>   
>>>   	best = kvm_find_cpuid_entry(vcpu, 7, 0);
>>> -- 
>>> 2.18.2
>>>

