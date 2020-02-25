Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC26C16B9D8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 07:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbgBYGl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 01:41:26 -0500
Received: from mga04.intel.com ([192.55.52.120]:25525 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgBYGl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 01:41:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 22:41:25 -0800
X-IronPort-AV: E=Sophos;i="5.70,483,1574150400"; 
   d="scan'208";a="230925164"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.151]) ([10.249.174.151])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Feb 2020 22:41:22 -0800
Subject: Re: [PATCH 1/2] kvm: vmx: Use basic exit reason to check if it's the
 specific VM EXIT
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200224020751.1469-1-xiaoyao.li@intel.com>
 <20200224020751.1469-2-xiaoyao.li@intel.com>
 <87lfosp9xs.fsf@vitty.brq.redhat.com>
 <d9744594-4a66-d867-f785-64ce4d42b848@intel.com>
 <87imjwp24x.fsf@vitty.brq.redhat.com>
 <20200224161728.GC29865@linux.intel.com>
 <50134028-ef7a-46c6-7602-095c47406ed7@intel.com>
 <20200225061317.GV29865@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <bb2d36b4-a077-691e-d59e-f65bf534d1ff@intel.com>
Date:   Tue, 25 Feb 2020 14:41:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225061317.GV29865@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/2020 2:13 PM, Sean Christopherson wrote:
> On Tue, Feb 25, 2020 at 08:13:15AM +0800, Xiaoyao Li wrote:
>> On 2/25/2020 12:17 AM, Sean Christopherson wrote:
>>> On Mon, Feb 24, 2020 at 02:04:46PM +0100, Vitaly Kuznetsov wrote:
>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>
>>>>> On 2/24/2020 6:16 PM, Vitaly Kuznetsov wrote:
>>>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>>>
>>>>> Here variable basic_exit_reason is added for the cases where only basic
>>>>> exit reason number is needed.
>>>>>
>>>>
>>>> Can we do the other way around, i.e. introduce 'extended_exit_reason'
>>>> and use it where all 32 bits are needed? I'm fine with the change, just
>>>> trying to minimize the (unneeded) code churn.
>>>
>>> 100% agree.  Even better than adding a second field to vcpu_vmx would be
>>> to make it a union, though we'd probably want to call it something like
>>> full_exit_reason in that case.  That should give us compile-time checks on
>>> exit_reason, e.g. if we try to query one of the upper bits using a u16, e.g.
>>
>> I have thought about union, but it seems
>>
>> union {
>> 	u16 exit_reason;
>> 	u32 full_exit_reason;
>> }
>>
>> is not a good name. Since there are many codes in vmx.c and nested.c assume
>> that exit_reason stands for 32-bit EXIT REASON vmcs field as well as
>> evmcs->vm_exit_reason and vmcs12->vm_exit_reason. Do we really want to also
>> rename them to full_exit_reason?
> 
> It's actually the opposite, almost all of the VMX code assumes exit_reason
> holds only the basic exit reason, i.e. a 16-bit value.  For example, SGX
> adds a modifier flag to denote a VM-Exit was from enclave mode, and that
> bit needs to be stripped from exit_reason, otherwise all the checks like
> "if (exit_reason == blah_blah_blah)" fail.
> 
> Making exit_reason a 16-bit alias of the full/extended exit_reason neatly
> sidesteps that issue.  And it is an issue that has caused actual problems
> in the past, e.g. see commit beb8d93b3e42 ("KVM: VMX: Fix handling of #MC
> that occurs during VM-Entry").  Coincidentally, that commit also removes a
> local "u16 basic_exit_reason" :-).
> 
> Except for one mistake, the pseudo-patch below is the entirety of required
> changes.  Most (all?) of the functions that take "u32 exit_reason" can (and
> should) continue to take a u32.
> 
> As for the name, I strongly prefer keeping the exit_reason name for the
> basic exit reason.  The vast majority of VM-Exits do not have modifiers
> set, i.e. "basic exit reason" == vmcs.EXIT_REASON for nearly all normal
> usage.  This holds true in every form of communication, e.g. when discussing
> VM-Exit reasons, it's never qualified with "basic", it's simply the exit
> reason.  IMO the code is better off following the colloquial usage of "exit
> reason".  A simple comment above the union would suffice to clear up any
> confusion with respect to the SDM.

Well, for this reason we can keep exit_reason for 16-bit usage, and 
define full/extended_exit_reason for 32-bit cases. This makes less code 
churn.

But after we choose to use exit_reason and full/extended_exit_reason, 
what if someday new modifier flags are added and we want to enable some 
modifier flags for nested case?
I guess we need to change existing exit_reason to 
full/extended_exit_reason in nested.c/nested.h to keep the naming rule 
consistent.

>> Maybe we name it
>>
>> union {
>> 	u16 basic_exit_reason;
>> 	u32 exit_reason;
>> }
>>
>> as what SDM defines?
>>
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -5818,7 +5818,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
>>>          if (is_guest_mode(vcpu) && nested_vmx_exit_reflected(vcpu, exit_reason))
>>>                  return nested_vmx_reflect_vmexit(vcpu, exit_reason);
>>>
>>> -       if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
>>> +       if (vmx->full_exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
> 
> If we do go the union route, this snippet of code is insufficient, the
> full/extended exit reason needs to be snapshotted early for use in the
> tracepoint and in fail_entry.hardware_entry_failure_reason.
> 
>>>                  dump_vmcs();
>>>                  vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
>>>                  vcpu->run->fail_entry.hardware_entry_failure_reason
>>> @@ -6620,11 +6620,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>>          vmx->nested.nested_run_pending = 0;
>>>          vmx->idt_vectoring_info = 0;
>>>
>>> -       vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
>>> -       if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
>>> +       vmx->full_exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
>>> +       if (vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
>>>                  kvm_machine_check();
>>>
>>> -       if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
>>> +       if (vmx->fail ||
>>> +           (vmx->full_exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
>>>                  return;
>>>
>>>          vmx->loaded_vmcs->launched = 1;
>>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>>> index 7f42cf3dcd70..60c09640ea59 100644
>>> --- a/arch/x86/kvm/vmx/vmx.h
>>> +++ b/arch/x86/kvm/vmx/vmx.h
>>> @@ -260,7 +260,10 @@ struct vcpu_vmx {
>>>          int vpid;
>>>          bool emulation_required;
>>>
>>> -       u32 exit_reason;
>>> +       union {
>>> +               u16 exit_reason;
>>> +               u32 full_exit_reason;
>>> +       }
>>>
>>>          /* Posted interrupt descriptor */
>>>          struct pi_desc pi_desc;
>>>
>>>
>>>
>>>
>>>
>>>> -- 
>>>> Vitaly
>>>>
>>

