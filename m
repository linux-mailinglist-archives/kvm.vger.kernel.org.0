Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C2F406561
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 03:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhIJBsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 21:48:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:16019 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229452AbhIJBr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 21:47:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10102"; a="221015209"
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="221015209"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 18:46:47 -0700
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="540078011"
Received: from unknown (HELO [10.239.13.122]) ([10.239.13.122])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 18:46:44 -0700
Subject: Re: [PATCH] KVM: nVMX: Fix nested bus lock VM exit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210827085110.6763-1-chenyi.qiang@intel.com>
 <YS/BrirERUK4uDaI@google.com>
 <0f064b93-8375-8cba-6422-ff12f95af656@intel.com>
 <YTpLmxaR9zLbcyxx@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <56fa664d-c4e5-066b-2bc8-2f1d2e74b35a@intel.com>
Date:   Fri, 10 Sep 2021 09:46:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YTpLmxaR9zLbcyxx@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/10/2021 1:59 AM, Sean Christopherson wrote:
> On Thu, Sep 02, 2021, Xiaoyao Li wrote:
>> On 9/2/2021 2:08 AM, Sean Christopherson wrote:
>>> On Fri, Aug 27, 2021, Chenyi Qiang wrote:
>>>> Nested bus lock VM exits are not supported yet. If L2 triggers bus lock
>>>> VM exit, it will be directed to L1 VMM, which would cause unexpected
>>>> behavior. Therefore, handle L2's bus lock VM exits in L0 directly.
>>>>
>>>> Fixes: fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")
>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> ---
>>>>    arch/x86/kvm/vmx/nested.c | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>>> index bc6327950657..754f53cf0f7a 100644
>>>> --- a/arch/x86/kvm/vmx/nested.c
>>>> +++ b/arch/x86/kvm/vmx/nested.c
>>>> @@ -5873,6 +5873,8 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
>>>>    	case EXIT_REASON_VMFUNC:
>>>>    		/* VM functions are emulated through L2->L0 vmexits. */
>>>>    		return true;
>>>> +	case EXIT_REASON_BUS_LOCK:
>>>> +		return true;
>>>
>>> Hmm, unless there is zero chance of ever exposing BUS_LOCK_DETECTION to L1, it
>>> might be better to handle this in nested_vmx_l1_wants_exit(), e.g.
>>>
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index b3f77d18eb5a..793534b7eaba 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -6024,6 +6024,8 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
>>>                           SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
>>>           case EXIT_REASON_ENCLS:
>>>                   return nested_vmx_exit_handled_encls(vcpu, vmcs12);
>>> +       case EXIT_REASON_BUS_LOCK:
>>> +               return nested_cpu_has2(vmcs12, SECONDARY_EXEC_BUS_LOCK_DETECTION);
>>
>> yes, for now, it equals
>>
>>                    return false;
>>
>> because KVM doesn't expose it to L1.
>>
>>>           default:
>>>                   return true;
>>>           }
>>>
>>> It's a rather roundabout way of reaching the same result, but I'd prefer to limit
>>> nested_vmx_l0_wants_exit() to cases where L0 wants to handle the exit regardless
>>> of what L1 wants.  This kinda fits that model, but it's not really that L0 "wants"
>>> the exit, it's that L1 can't want the exit.  Does that make sense?
>>
>> something like below has to be in nested_vmx_l0_wants_exit()
>>
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -5873,6 +5873,8 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu
>> *vcpu,
>>          case EXIT_REASON_VMFUNC:
>>                  /* VM functions are emulated through L2->L0 vmexits. */
>>                  return true;
>> +       case EXIT_REASON_BUS_LOCK:
>> +               return vcpu->kvm->arch.bus_lock_detection_enabled;
>>          default:
>>                  break;
>>          }
>>
>>
>> L0 wants this VM exit because it enables BUS LOCK VM exit, not because L1
>> doesn't enable it.
> 
> No, nested_vmx_l0_wants_exit() is specifically for cases where L0 wants to handle
> the exit even if L1 also wants to handle the exit.  For cases where L0 is expected
> to handle the exit because L1 does _not_ want the exit, the intent is to not have
> an entry in nested_vmx_l0_wants_exit().  This is a bit of a grey area, arguably L0
> "wants" the exit because L0 knows BUS_LOCK cannot be exposed to L1.

No. What I wanted to convey here is exactly "L0 wants to handle it 
because L0 wants it, and no matter L1 wants it or not (i.e., even if L1 
wants it) ", not "L0 wants it because the feature not exposed to L1/L1 
cannot enable it".

Even for the future case that this feature is exposed to L1, and both L0 
and L1 enable it. It should exit to L0 first for every bus lock happened 
in L2 VM and after L0 handles it, L0 needs to inject a BUS LOCK VM exit 
to L1 if L1 enables it. Every bus lock acquired in L2 VM should be 
regarded as the bus lock happened in L1 VM as well. L2 VM is just an 
application of L1 VM.

IMO, the flow should be:

if (L0 enables it) {
	exit to L0;
	L0 handling;
	if (is_guest_mode(vcpu) && L1 enables it) {
		inject BUS_LOCK VM EXIT to L1;
	}
} else if (L1 enables it) {
	BUS_LOCK VM exit to L1;
} else {
	BUG();
}

> But if we go with that argument, then the original patch (with a comment), is correct.
> Conditioning L0's wants on bus_lock_detection_enabled is not correct because whether
> or not the feature is enabled by L0 does not affect whether or not it's exposed to L1.
> Obviously BUS_LOCK exits should not happen if bus_lock_detection_enabled==false, but
> that's not relevant for why L0 "wants" the exit.
> 
> I'm not totally opposed to handling this in nested_vmx_l0_wants_exit(), but handling
> the check in nested_vmx_l1_wants_exit() has the advantage of being correct both now
> and in the future (if BUS_LOCK is ever exposed to L1).
> 

