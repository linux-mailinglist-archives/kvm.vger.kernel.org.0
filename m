Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3FF16B670
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 01:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgBYANW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 19:13:22 -0500
Received: from mga04.intel.com ([192.55.52.120]:3511 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgBYANW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 19:13:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 16:13:21 -0800
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="230834764"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.151]) ([10.249.174.151])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Feb 2020 16:13:18 -0800
Subject: Re: [PATCH 1/2] kvm: vmx: Use basic exit reason to check if it's the
 specific VM EXIT
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200224020751.1469-1-xiaoyao.li@intel.com>
 <20200224020751.1469-2-xiaoyao.li@intel.com>
 <87lfosp9xs.fsf@vitty.brq.redhat.com>
 <d9744594-4a66-d867-f785-64ce4d42b848@intel.com>
 <87imjwp24x.fsf@vitty.brq.redhat.com>
 <20200224161728.GC29865@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <50134028-ef7a-46c6-7602-095c47406ed7@intel.com>
Date:   Tue, 25 Feb 2020 08:13:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224161728.GC29865@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/2020 12:17 AM, Sean Christopherson wrote:
> On Mon, Feb 24, 2020 at 02:04:46PM +0100, Vitaly Kuznetsov wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>
>>> On 2/24/2020 6:16 PM, Vitaly Kuznetsov wrote:
>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>
>>
>> ...
>>
>>>>>    		rip = kvm_rip_read(vcpu);
>>>>>    		rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
>>>>>    		kvm_rip_write(vcpu, rip);
>>>>> @@ -5797,6 +5797,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
>>>>>    {
>>>>>    	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>>>>    	u32 exit_reason = vmx->exit_reason;
>>>>> +	u16 basic_exit_reason = basic(exit_reason);
>>>>
>>>> I don't think renaming local variable is needed, let's just do
>>>>
>>>> 'u16 exit_reason = basic_exit_reason(vmx->exit_reason)' and keep the
>>>> rest of the code as-is.
>>>
>>> No, we can't do this.
>>>
>>> It's not just renaming local variable, the full 32-bit exit reason is
>>> used elsewhere in this function that needs the upper 16-bit.
>>>
>>> Here variable basic_exit_reason is added for the cases where only basic
>>> exit reason number is needed.
>>>
>>
>> Can we do the other way around, i.e. introduce 'extended_exit_reason'
>> and use it where all 32 bits are needed? I'm fine with the change, just
>> trying to minimize the (unneeded) code churn.
> 
> 100% agree.  Even better than adding a second field to vcpu_vmx would be
> to make it a union, though we'd probably want to call it something like
> full_exit_reason in that case.  That should give us compile-time checks on
> exit_reason, e.g. if we try to query one of the upper bits using a u16, e.g.

I have thought about union, but it seems

union {
	u16 exit_reason;
	u32 full_exit_reason;
}

is not a good name. Since there are many codes in vmx.c and nested.c 
assume that exit_reason stands for 32-bit EXIT REASON vmcs field as well 
as evmcs->vm_exit_reason and vmcs12->vm_exit_reason. Do we really want 
to also rename them to full_exit_reason?

Maybe we name it

union {
	u16 basic_exit_reason;
	u32 exit_reason;
}

as what SDM defines?

> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5818,7 +5818,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
>          if (is_guest_mode(vcpu) && nested_vmx_exit_reflected(vcpu, exit_reason))
>                  return nested_vmx_reflect_vmexit(vcpu, exit_reason);
> 
> -       if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
> +       if (vmx->full_exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
>                  dump_vmcs();
>                  vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
>                  vcpu->run->fail_entry.hardware_entry_failure_reason
> @@ -6620,11 +6620,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>          vmx->nested.nested_run_pending = 0;
>          vmx->idt_vectoring_info = 0;
> 
> -       vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
> -       if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
> +       vmx->full_exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
> +       if (vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
>                  kvm_machine_check();
> 
> -       if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
> +       if (vmx->fail ||
> +           (vmx->full_exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
>                  return;
> 
>          vmx->loaded_vmcs->launched = 1;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 7f42cf3dcd70..60c09640ea59 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -260,7 +260,10 @@ struct vcpu_vmx {
>          int vpid;
>          bool emulation_required;
> 
> -       u32 exit_reason;
> +       union {
> +               u16 exit_reason;
> +               u32 full_exit_reason;
> +       }
> 
>          /* Posted interrupt descriptor */
>          struct pi_desc pi_desc;
> 
> 
> 
> 
> 
>> -- 
>> Vitaly
>>

