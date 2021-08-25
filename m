Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE1C3F6F8A
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 08:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239058AbhHYGe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 02:34:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:56256 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhHYGe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 02:34:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="204595160"
X-IronPort-AV: E=Sophos;i="5.84,349,1620716400"; 
   d="scan'208";a="204595160"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 23:33:41 -0700
X-IronPort-AV: E=Sophos;i="5.84,349,1620716400"; 
   d="scan'208";a="527098758"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.122]) ([10.239.13.122])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 23:33:38 -0700
Subject: Re: [PATCH 3/5] KVM: VMX: RTIT_CTL_BRANCH_EN has no dependency on
 other CPUID bit
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Alexander Shishkin (hwtracing + intel_th + stm + R:perf)" 
        <alexander.shishkin@linux.intel.com>
References: <20210824110743.531127-1-xiaoyao.li@intel.com>
 <20210824110743.531127-4-xiaoyao.li@intel.com>
 <711265db-f634-36ac-40d2-c09cea825df6@gmail.com>
 <b80a91db-cb35-ba6d-ab36-a0fa1ca051e7@intel.com>
 <6dddf3c0-fa8f-f70c-bd5d-b43c7140ed9a@gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <ed18e08f-1ea6-4ffa-91a7-9d8706a1b781@intel.com>
Date:   Wed, 25 Aug 2021 14:33:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <6dddf3c0-fa8f-f70c-bd5d-b43c7140ed9a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/2021 2:08 PM, Like Xu wrote:
> On 25/8/2021 12:19 pm, Xiaoyao Li wrote:
>> On 8/25/2021 11:30 AM, Like Xu wrote:
>>> +Alexander
>>>
>>> On 24/8/2021 7:07 pm, Xiaoyao Li wrote:
>>>> Per Intel SDM, RTIT_CTL_BRANCH_EN bit has no dependency on any CPUID
>>>> leaf 0x14.
>>>>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> ---
>>>>   arch/x86/kvm/vmx/vmx.c | 8 ++++----
>>>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index 7ed96c460661..4a70a6d2f442 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -7116,7 +7116,8 @@ static void update_intel_pt_cfg(struct 
>>>> kvm_vcpu *vcpu)
>>>>       /* Initialize and clear the no dependency bits */
>>>>       vmx->pt_desc.ctl_bitmask = ~(RTIT_CTL_TRACEEN | RTIT_CTL_OS |
>>>> -            RTIT_CTL_USR | RTIT_CTL_TSC_EN | RTIT_CTL_DISRETC);
>>>> +            RTIT_CTL_USR | RTIT_CTL_TSC_EN | RTIT_CTL_DISRETC |
>>>> +            RTIT_CTL_BRANCH_EN);
>>>>       /*
>>>>        * If CPUID.(EAX=14H,ECX=0):EBX[0]=1 CR3Filter can be set 
>>>> otherwise
>>>> @@ -7134,12 +7135,11 @@ static void update_intel_pt_cfg(struct 
>>>> kvm_vcpu *vcpu)
>>>>                   RTIT_CTL_CYC_THRESH | RTIT_CTL_PSB_FREQ);
>>>>       /*
>>>> -     * If CPUID.(EAX=14H,ECX=0):EBX[3]=1 MTCEn BranchEn and
>>>> -     * MTCFreq can be set
>>>> +     * If CPUID.(EAX=14H,ECX=0):EBX[3]=1 MTCEn and MTCFreq can be set
>>>
>>> If CPUID.(EAX=14H,ECX=0):EBX[3]=1,
>>>
>>>      "indicates support of MTC timing packet and suppression of 
>>> COFI-based packets."
>>
>> I think it's a mistake of SDM in CPUID instruction.
>>
>> If you read 31.3.1, table 31-11 of SDM 325462-075US,
>>
>> It just says CPUID(0x14, 0):EBX[3]: MTC supprted.
>> It doesn't talk anything about COFI packets suppression.
>>
>> Further as below.
>>
>>> Per 31.2.5.4 Branch Enable (BranchEn),
>>>
>>>      "If BranchEn is not set, then relevant COFI packets (TNT, TIP*, 
>>> FUP, MODE.*) are suppressed."
>>>
>>> I think if the COFI capability is suppressed, the software can't set 
>>> the BranchEn bit, right ?
>>
>> Based on your understanding, isn't it that
>>
>> 1. if CPUID.(EAX=14H,ECX=0):EBX[3]=0, it doesn't support "suppression 
>> of COFI-based packets".
>> 2. if it doesn't support "suppression of COFI-based packets", then it 
>> doens't support "If BranchEn is not set, then relevant COFI packets 
>> (TNT, TIP*, FUP, MODE.*) are suppressed", i.e. BranchEn must be 1.
> 
> That's it.
> 
>>
>> Anyway, I think it's just a mistake on CPUID instruction document of SDM.
> 
> Is this an ambiguity rather than a mistake ?
> 
>>
>> CPUD.(EAX=14H,ECX=0):EBX[3] should only indicates the MTC support.
> 
> Please do not make assertions that you do not confirm with hw.
> 
>>
>> BranchEn should be always supported if PT is available. Per "31.2.7.2 
> 
> Check d35869ba348d3f1ff3e6d8214fe0f674bb0e404e.

This commit shows BranchEn is supported on BDW, and must be enabled on 
BDW. This doesn't conflict the description above that BranchEn should be 
always supported.

>> IA32_RTIT_CTL MSR" on SDM:
>> When BranchEn is 1, it enables COFI-based packets.
>> When BranchEn is 0, it disables COFI-based packtes. i.e., COFI packets 
>> are suppressed.
>>
>>>>        */
>>>>       if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_mtc))
>>>>           vmx->pt_desc.ctl_bitmask &= ~(RTIT_CTL_MTC_EN |
>>>> -                RTIT_CTL_BRANCH_EN | RTIT_CTL_MTC_RANGE);
>>>> +                          RTIT_CTL_MTC_RANGE);
>>>>       /* If CPUID.(EAX=14H,ECX=0):EBX[4]=1 FUPonPTW and PTWEn can be 
>>>> set */
>>>>       if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_ptwrite))
>>>>
>>

