Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793243FEB36
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 11:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245595AbhIBJ3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 05:29:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:38994 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343539AbhIBJ3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 05:29:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="218756250"
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="218756250"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 02:28:15 -0700
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="532961015"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.0.162]) ([10.238.0.162])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 02:28:12 -0700
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Tao Xu <tao3.xu@intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <YQRkBI9RFf6lbifZ@google.com>
 <b0c90258-3f68-57a2-664a-e20a6d251e45@intel.com>
 <YQgTPakbT+kCwMLP@google.com>
 <080602dc-f998-ec13-ddf9-42902aa477de@intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <4079f0c9-e34c-c034-853a-b26908a58182@intel.com>
Date:   Thu, 2 Sep 2021 17:28:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <080602dc-f998-ec13-ddf9-42902aa477de@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/3/2021 8:38 AM, Xiaoyao Li wrote:
> On 8/2/2021 11:46 PM, Sean Christopherson wrote:
>> On Mon, Aug 02, 2021, Xiaoyao Li wrote:
>>> On 7/31/2021 4:41 AM, Sean Christopherson wrote:
>>>> On Tue, May 25, 2021, Tao Xu wrote:
>>>>>    #endif /* __KVM_X86_VMX_CAPS_H */
>>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>>> index 4bceb5ca3a89..c0ad01c88dac 100644
>>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>>> @@ -205,6 +205,10 @@ module_param(ple_window_max, uint, 0444);
>>>>>    int __read_mostly pt_mode = PT_MODE_SYSTEM;
>>>>>    module_param(pt_mode, int, S_IRUGO);
>>>>> +/* Default is 0, less than 0 (for example, -1) disables notify 
>>>>> window. */
>>>>> +static int __read_mostly notify_window;
>>>>
>>>> I'm not sure I like the idea of trusting ucode to select an 
>>>> appropriate internal
>>>> threshold.  Unless the internal threshold is architecturally defined 
>>>> to be at
>>>> least N nanoseconds or whatever, I think KVM should provide its own 
>>>> sane default.
>>>> E.g. it's not hard to imagine a scenario where a ucode patch gets 
>>>> rolled out that
>>>> adjusts the threshold and starts silently degrading guest performance.
>>>
>>> You mean when internal threshold gets smaller somehow, and cases
>>> false-positive that leads unexpected VM exit on normal instruction? 
>>> In this
>>> case, we set increase the vmcs.notify_window in KVM.
>>
>> Not while VMs are running though.
>>
>>> I think there is no better to avoid this case if ucode changes internal
>>> threshold. Unless KVM's default notify_window is bigger enough.
>>>
>>>> Even if the internal threshold isn't architecturally constrained, it 
>>>> would be very,
>>>> very helpful if Intel could publish the per-uarch/stepping 
>>>> thresholds, e.g. to give
>>>> us a ballpark idea of how agressive KVM can be before it risks false 
>>>> positives.
>>>
>>> Even Intel publishes the internal threshold, we still need to provide a
>>> final best_value (internal + vmcs.notify_window). Then what's that 
>>> value?
>>
>> The ideal value would be high enough to guarantee there are zero false 
>> positives,
>> yet low enough to prevent a malicious guest from causing instability 
>> in the host
>> by blocking events for an extended duration.  The problem is that 
>> there's no
>> magic answer for the threshold at which a blocked event would lead to 
>> system
>> instability, and without at least a general idea of the internal value 
>> there's no
>> answer at all.
>>
>> IIRC, SGX instructions have a hard upper bound of 25k cycles before 
>> they have to
>> check for pending interrupts, e.g. it's why EINIT is interruptible.  
>> The 25k cycle
>> limit is likely a good starting point for the combined minimum.  
>> That's why I want
>> to know the internal minimum; if the internal minimum is _guaranteed_ 
>> to be >25k,
>> then KVM can be more aggressive with its default value.
> 
> OK. I will go internally to see if we can publish the internal threshold.
> 

Hi Sean,

After syncing internally, we know that the internal threshold is not 
architectural but a model-specific value. It will be published in some 
place in future.

On Sapphire Rapids platform, the threshold is 128k. With this in mind, 
is it appropriate to set 0 as the default value of notify_window?

>>> If we have an option for final best_value, then I think it's OK to 
>>> just let
>>> vmcs.notify_window = best_value. Then the true final value is 
>>> best_value +
>>> internal.
>>>   - if it's a normal instruction, it should finish within best_value or
>>> best_value + internal. So it makes no difference.
>>>   - if it's an instruction in malicious case, it won't go to next 
>>> instruction
>>> whether wait for best_value or best_value + internal.
>>
>> ...
>>
>>>>> +
>>>>>        vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
>>>>>        vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
>>>>>        vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
>>>>> @@ -5642,6 +5653,31 @@ static int handle_bus_lock_vmexit(struct 
>>>>> kvm_vcpu *vcpu)
>>>>>        return 0;
>>>>>    }
>>>>> +static int handle_notify(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +    unsigned long exit_qual = vmx_get_exit_qual(vcpu);
>>>>> +
>>>>> +    if (!(exit_qual & NOTIFY_VM_CONTEXT_INVALID)) {
>>>>
>>>> What does CONTEXT_INVALID mean?  The ISE doesn't provide any 
>>>> information whatsoever.
>>>
>>> It means whether the VM context is corrupted and not valid in the VMCS.
>>
>> Well that's a bit terrifying.  Under what conditions can the VM 
>> context become
>> corrupted?  E.g. if the context can be corrupted by an inopportune 
>> NOTIFY exit,
>> then KVM needs to be ultra conservative as a false positive could be 
>> fatal to a
>> guest.
>>
> 
> Short answer is no case will set the VM_CONTEXT_INVALID bit.
> 
> VM_CONTEXT_INVALID is so fatal and IMHO it won't be set for any 
> inopportune NOTIFY exit.
