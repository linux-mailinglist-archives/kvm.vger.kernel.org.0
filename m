Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F5A16A5A3
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 13:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgBXMBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 07:01:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:52215 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbgBXMBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 07:01:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 04:01:29 -0800
X-IronPort-AV: E=Sophos;i="5.70,480,1574150400"; 
   d="scan'208";a="230626314"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.151]) ([10.249.174.151])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Feb 2020 04:01:26 -0800
Subject: Re: [PATCH 1/2] kvm: vmx: Use basic exit reason to check if it's the
 specific VM EXIT
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200224020751.1469-1-xiaoyao.li@intel.com>
 <20200224020751.1469-2-xiaoyao.li@intel.com>
 <87lfosp9xs.fsf@vitty.brq.redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <d9744594-4a66-d867-f785-64ce4d42b848@intel.com>
Date:   Mon, 24 Feb 2020 20:01:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87lfosp9xs.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/24/2020 6:16 PM, Vitaly Kuznetsov wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> Current kvm uses the 32-bit exit reason to check if it's any specific VM
>> EXIT, however only the low 16-bit of VM EXIT REASON acts as the basic
>> exit reason.
>>
>> Introduce Macro basic(exit_reaso)
> 
> "exit_reason"

Ah, will correct it in v2.

>>   to help retrieve the basic exit reason
>> from VM EXIT REASON, and use the basic exit reason for checking and
>> indexing the exit hanlder.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 44 ++++++++++++++++++++++--------------------
>>   arch/x86/kvm/vmx/vmx.h |  2 ++
>>   2 files changed, 25 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 9a6664886f2e..85da72d4dc92 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -1584,7 +1584,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
>>   	 * i.e. we end up advancing IP with some random value.
>>   	 */
>>   	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
>> -	    to_vmx(vcpu)->exit_reason != EXIT_REASON_EPT_MISCONFIG) {
>> +	    basic(to_vmx(vcpu)->exit_reason) != EXIT_REASON_EPT_MISCONFIG) {
> 
> "basic" word is probably 'too basic' to be used for this purpose. Even
> if we need a macro for it (I'm not really convinced it improves the
> readability), I'd suggest we name it 'basic_exit_reason()' instead.

Agreed.

>>   		rip = kvm_rip_read(vcpu);
>>   		rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
>>   		kvm_rip_write(vcpu, rip);
>> @@ -5797,6 +5797,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
>>   {
>>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>   	u32 exit_reason = vmx->exit_reason;
>> +	u16 basic_exit_reason = basic(exit_reason);
> 
> I don't think renaming local variable is needed, let's just do
> 
> 'u16 exit_reason = basic_exit_reason(vmx->exit_reason)' and keep the
> rest of the code as-is.

No, we can't do this.

It's not just renaming local variable, the full 32-bit exit reason is 
used elsewhere in this function that needs the upper 16-bit.

Here variable basic_exit_reason is added for the cases where only basic 
exit reason number is needed.

>>   	u32 vectoring_info = vmx->idt_vectoring_info;
>>   
>>   	trace_kvm_exit(exit_reason, vcpu, KVM_ISA_VMX);
>> @@ -5842,17 +5843,17 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
>>   	 * will cause infinite loop.
>>   	 */
>>   	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
>> -			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
>> -			exit_reason != EXIT_REASON_EPT_VIOLATION &&
>> -			exit_reason != EXIT_REASON_PML_FULL &&
>> -			exit_reason != EXIT_REASON_TASK_SWITCH)) {
>> +			(basic_exit_reason != EXIT_REASON_EXCEPTION_NMI &&
>> +			 basic_exit_reason != EXIT_REASON_EPT_VIOLATION &&
>> +			 basic_exit_reason != EXIT_REASON_PML_FULL &&
>> +			 basic_exit_reason != EXIT_REASON_TASK_SWITCH)) {
>>   		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>>   		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
>>   		vcpu->run->internal.ndata = 3;
>>   		vcpu->run->internal.data[0] = vectoring_info;
>>   		vcpu->run->internal.data[1] = exit_reason;
>>   		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
>> -		if (exit_reason == EXIT_REASON_EPT_MISCONFIG) {
>> +		if (basic_exit_reason == EXIT_REASON_EPT_MISCONFIG) {
>>   			vcpu->run->internal.ndata++;
>>   			vcpu->run->internal.data[3] =
>>   				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
>> @@ -5884,32 +5885,32 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
>>   		return 1;
>>   	}
>>   
>> -	if (exit_reason >= kvm_vmx_max_exit_handlers)
>> +	if (basic_exit_reason >= kvm_vmx_max_exit_handlers)
>>   		goto unexpected_vmexit;
>>   #ifdef CONFIG_RETPOLINE
>> -	if (exit_reason == EXIT_REASON_MSR_WRITE)
>> +	if (basic_exit_reason == EXIT_REASON_MSR_WRITE)
>>   		return kvm_emulate_wrmsr(vcpu);
>> -	else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
>> +	else if (basic_exit_reason == EXIT_REASON_PREEMPTION_TIMER)
>>   		return handle_preemption_timer(vcpu);
>> -	else if (exit_reason == EXIT_REASON_INTERRUPT_WINDOW)
>> +	else if (basic_exit_reason == EXIT_REASON_INTERRUPT_WINDOW)
>>   		return handle_interrupt_window(vcpu);
>> -	else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
>> +	else if (basic_exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
>>   		return handle_external_interrupt(vcpu);
>> -	else if (exit_reason == EXIT_REASON_HLT)
>> +	else if (basic_exit_reason == EXIT_REASON_HLT)
>>   		return kvm_emulate_halt(vcpu);
>> -	else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
>> +	else if (basic_exit_reason == EXIT_REASON_EPT_MISCONFIG)
>>   		return handle_ept_misconfig(vcpu);
>>   #endif
>>   
>> -	exit_reason = array_index_nospec(exit_reason,
>> +	basic_exit_reason = array_index_nospec(basic_exit_reason,
>>   					 kvm_vmx_max_exit_handlers);
>> -	if (!kvm_vmx_exit_handlers[exit_reason])
>> +	if (!kvm_vmx_exit_handlers[basic_exit_reason])
>>   		goto unexpected_vmexit;
>>   
>> -	return kvm_vmx_exit_handlers[exit_reason](vcpu);
>> +	return kvm_vmx_exit_handlers[basic_exit_reason](vcpu);
>>   
>>   unexpected_vmexit:
>> -	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", exit_reason);
>> +	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", basic_exit_reason);
>>   	dump_vmcs();
>>   	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>>   	vcpu->run->internal.suberror =
>> @@ -6241,13 +6242,14 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
>>   	enum exit_fastpath_completion *exit_fastpath)
>>   {
>>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> +	u16 basic_exit_reason = basic(vmx->exit_reason);
> 
> Here I'd suggest we also use the same
> 
> 'u16 exit_reason = basic_exit_reason(vmx->exit_reason)'
> 
> as above.
> 
>>   
>> -	if (vmx->exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
>> +	if (basic_exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
>>   		handle_external_interrupt_irqoff(vcpu);
>> -	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
>> +	else if (basic_exit_reason == EXIT_REASON_EXCEPTION_NMI)
>>   		handle_exception_nmi_irqoff(vmx);
>>   	else if (!is_guest_mode(vcpu) &&
>> -		vmx->exit_reason == EXIT_REASON_MSR_WRITE)
>> +		 basic_exit_reason == EXIT_REASON_MSR_WRITE)
>>   		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
>>   }
>>   
>> @@ -6621,7 +6623,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>   	vmx->idt_vectoring_info = 0;
>>   
>>   	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
>> -	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
>> +	if (basic(vmx->exit_reason) == EXIT_REASON_MCE_DURING_VMENTRY)
>>   		kvm_machine_check();
>>   
>>   	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 7f42cf3dcd70..c6ba33eedb59 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -22,6 +22,8 @@ extern u32 get_umwait_control_msr(void);
>>   
>>   #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
>>   
>> +#define basic(exit_reason) ((u16)(exit_reason))
>> +
>>   #ifdef CONFIG_X86_64
>>   #define NR_SHARED_MSRS	7
>>   #else
> 

