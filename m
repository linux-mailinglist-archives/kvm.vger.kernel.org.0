Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5203B3235B3
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 03:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhBXCav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 21:30:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:5600 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232069AbhBXCau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 21:30:50 -0500
IronPort-SDR: VWX6Ucpoi/ZzXqtEK06rSQYkxlEPBpRrQc4BB//jk3bUS3z8sMT3nWLIhozbW1PMtC2a00fTP4
 egT/HgA2AaXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9904"; a="185132740"
X-IronPort-AV: E=Sophos;i="5.81,201,1610438400"; 
   d="scan'208";a="185132740"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 18:30:09 -0800
IronPort-SDR: l5y4F4I+79QYi/fkh8bjbiV835CNzbTXm15jq+twyycv6hCN5vcps+28xV//CePwERPTy3aBFp
 MS+I7UfsbgPA==
X-IronPort-AV: E=Sophos;i="5.81,201,1610438400"; 
   d="scan'208";a="441930688"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 18:29:10 -0800
Subject: Re: [PATCH 1/2] KVM: vmx/pmu: Fix dummy check if lbr_desc->event is
 created
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20210223013958.1280444-1-like.xu@linux.intel.com>
 <YDU4II6Jt+E5nFmG@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <ca26c4e9-207a-2882-649d-fe82604f68f9@intel.com>
Date:   Wed, 24 Feb 2021 10:29:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YDU4II6Jt+E5nFmG@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/2/24 1:15, Sean Christopherson wrote:
> On Tue, Feb 23, 2021, Like Xu wrote:
>> If lbr_desc->event is successfully created, the intel_pmu_create_
>> guest_lbr_event() will return 0, otherwise it will return -ENOENT,
>> and then jump to LBR msrs dummy handling.
>>
>> Fixes: 1b5ac3226a1a ("KVM: vmx/pmu: Pass-through LBR msrs when the guest LBR event is ACTIVE")
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>   arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index d1df618cb7de..d6a5fe19ff09 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -320,7 +320,7 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
>>   	if (!intel_pmu_is_valid_lbr_msr(vcpu, index))
>>   		return false;
>>   
>> -	if (!lbr_desc->event && !intel_pmu_create_guest_lbr_event(vcpu))
>> +	if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu))
>>   		goto dummy;
> Wouldn't it be better to create an event only on write?  And really, why create
> the event in this flow in the first place?  In normal operation, can't event
> creation be deferred until GUEST_IA32_DEBUGCTL.DEBUGCTLMSR_LBR=1?

We need event creation and pass-through for both read and write.

The LBR driver would firstly access the MSR_LBR_SELECT to configure branch 
types
and we also create LBR event for GUEST_IA32_DEBUGCTL.DEBUGCTLMSR_LBR=1 trap.
A lazy approach requests more cached values and more traps.

> If event
> creation fails in that flow, I would think KVM would do its best to create an
> event in future runs without waiting for additional actions from the guest.

We have done this via releasing the LBR event for next creation and 
pass-through try.

>
> Also, this bug suggests there's a big gaping hole in the test coverage.

Not a big but concern one. To hit that, we need run LBR agent on the host
and grab LBR from the guest. And it's not covered in the current test cases
since we do not recommend this kind of usage in the comment.

> AFAICT,
> event contention would lead to a #GP crash in the host due to lbr_desc->event
> being dereferenced, no?

a #GP crash in the host ？Can you share more understanding about it ?

>
>>   
>>   	/*
>> -- 
>> 2.29.2
>>

