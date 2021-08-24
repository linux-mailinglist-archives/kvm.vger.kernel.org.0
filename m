Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A043F61C5
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 17:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238343AbhHXPgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 11:36:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:23966 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234546AbhHXPgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 11:36:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="204470941"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="204470941"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 08:35:56 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="526668309"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.172.211]) ([10.249.172.211])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 08:35:53 -0700
Subject: Re: [PATCH 4/5] KVM: VMX: Disallow PT MSRs accessing if PT is not
 exposed to guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210824110743.531127-1-xiaoyao.li@intel.com>
 <20210824110743.531127-5-xiaoyao.li@intel.com> <YSUALsBF8rKNPiaS@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <8b53fc19-c3cc-d11f-37e3-70fc0639878d@intel.com>
Date:   Tue, 24 Aug 2021 23:35:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YSUALsBF8rKNPiaS@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/2021 10:20 PM, Sean Christopherson wrote:
> On Tue, Aug 24, 2021, Xiaoyao Li wrote:
>> Per SDM, it triggers #GP for all the accessing of PT MSRs, if
>> X86_FEATURE_INTEL_PT is not available.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++------
>>   1 file changed, 14 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 4a70a6d2f442..1bbc4d84c623 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -1010,9 +1010,16 @@ static unsigned long segment_base(u16 selector)
>>   static inline bool pt_can_write_msr(struct vcpu_vmx *vmx)
>>   {
>>   	return vmx_pt_mode_is_host_guest() &&
>> +	       guest_cpuid_has(&vmx->vcpu, X86_FEATURE_INTEL_PT) &&
>>   	       !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
>>   }
>>   
>> +static inline bool pt_can_read_msr(struct kvm_vcpu *vcpu)
>> +{
>> +	return vmx_pt_mode_is_host_guest() &&
>> +	       guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT);
>> +}
>> +
>>   static inline bool pt_output_base_valid(struct kvm_vcpu *vcpu, u64 base)
>>   {
>>   	/* The base must be 128-byte aligned and a legal physical address. */
>> @@ -1849,24 +1856,24 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   							&msr_info->data);
>>   		break;
>>   	case MSR_IA32_RTIT_CTL:
>> -		if (!vmx_pt_mode_is_host_guest())
>> +		if (!pt_can_read_msr(vcpu))
> 
> These all need to provide exemptions for accesses from the host.  KVM allows
> access to MSRs that are not exposed to the guest so long as all the other checks
> pass. 

Not all the MSRs are allowed to be accessed from host regardless of 
whether it's exposed to guest. e.g., MSR_IA32_TSC_ADJUST, it checks 
guest CPUID first.

For me, for those PT MSRs, I cannot think of any reason that 
host/userspace would access them without PT being exposed to guest.

On the other hand, since this patch indeed breaks the existing userspace 
VMM who accesses those MSRs without checking guest CPUID.

So I will follow your advice to allow the host_initiated case in next 
version.

> Same for the next patch.

Sorry, I don't know how it matters next patch.

> Easiest thing is probably to pass in @msr_info to the helpers and do the check
> there.
> 
>>   			return 1;
>>   		msr_info->data = vmx->pt_desc.guest.ctl;
>>   		break;

