Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78943F61E2
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 17:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238531AbhHXPoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 11:44:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:63076 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238432AbhHXPnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 11:43:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="217061467"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="217061467"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 08:42:48 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="526670292"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.172.211]) ([10.249.172.211])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 08:42:46 -0700
Subject: Re: [PATCH 2/5] KVM: VMX: Use cached vmx->pt_desc.addr_range
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210824110743.531127-1-xiaoyao.li@intel.com>
 <20210824110743.531127-3-xiaoyao.li@intel.com> <YSUPKmtP6Dcl1yio@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <faf53e42-428b-5d54-0a29-2dbe3af6ddd2@intel.com>
Date:   Tue, 24 Aug 2021 23:42:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YSUPKmtP6Dcl1yio@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/2021 11:24 PM, Sean Christopherson wrote:
> On Tue, Aug 24, 2021, Xiaoyao Li wrote:
>> The number of guest's valid PT ADDR MSRs is cached in
> 
> Can you do s/cached/precomputed in the shortlog and changelog?  Explanation below.

OK.

>> vmx->pt_desc.addr_range. Use it instead of calculating it again.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index e0a9460e4dab..7ed96c460661 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2202,8 +2202,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		if (!pt_can_write_msr(vmx))
>>   			return 1;
>>   		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
>> -		if (index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
>> -						       PT_CAP_num_address_ranges))
>> +		if (index >= 2 * vmx->pt_desc.addr_range)
> 
> Ugh, "validate" is a lie, a better name would be intel_pt_get_cap() or so.  There
> is no validation, the helper is simply extracting the requested cap from the
> passed in array of capabilities.
> 
> That matters in this case because the number of address ranges exposed to the
> guest is not bounded by the number of address ranges present in hardware, i.e.
> it's not "validated".  And that matters because KVM uses vmx->pt_desc.addr_range
> to pass through the ADDRn_{A,B} MSRs when tracing enabled.  In other words,
> userspace can expose MSRs to the guest that do not exist.

That's why I provided patch 5.

> The bug shouldn't be a security issue, so long as Intel CPUs are bug free and
> aren't doing silly things with MSR indexes.  The number of possible address ranges
> is encoded in three bits, thus the theoretical max is 8 ranges.  So userspace can't
> get access to arbitrary MSRs, just ADDR0_A -> ADDR7_B.
> 
> And since KVM would be modifying the "validated" value, it's more than just a
> cache, hence the request to use "precomputed".
> 
> Finally, vmx_get_msr() should use the precomputed value as well.

Argh, I missed it.

> P.S. If you want to introduce a bit of churn, s/addr_range/nr_addr_ranges would
>       be a welcome change as well.

In a separate patch?

>>   			return 1;
>>   		if (is_noncanonical_address(data, vcpu))
>>   			return 1;
>> -- 
>> 2.27.0
>>

