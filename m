Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDC3447A15
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 08:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfFQGba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 02:31:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:24239 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfFQGba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 02:31:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jun 2019 23:31:29 -0700
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 16 Jun 2019 23:31:26 -0700
Subject: Re: [PATCH RESEND v3 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
From:   Xiaoyao Li <xiaoyao.li@linux.intel.com>
To:     Tao Xu <tao3.xu@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, fenghua.yu@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jingqi.liu@intel.com
References: <20190616095555.20978-1-tao3.xu@intel.com>
 <20190616095555.20978-3-tao3.xu@intel.com>
 <d99b2ae1-38fc-0b71-2613-8131decc923a@intel.com>
Message-ID: <ea1fc40b-8f80-d5f0-6c97-adb245599e07@linux.intel.com>
Date:   Mon, 17 Jun 2019 14:31:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <d99b2ae1-38fc-0b71-2613-8131decc923a@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/17/2019 11:32 AM, Xiaoyao Li wrote:
> 
> 
> On 6/16/2019 5:55 PM, Tao Xu wrote:
>> UMWAIT and TPAUSE instructions use IA32_UMWAIT_CONTROL at MSR index E1H
>> to determines the maximum time in TSC-quanta that the processor can 
>> reside
>> in either C0.1 or C0.2.
>>
>> This patch emulates MSR IA32_UMWAIT_CONTROL in guest and differentiate
>> IA32_UMWAIT_CONTROL between host and guest. The variable
>> mwait_control_cached in arch/x86/power/umwait.c caches the MSR value, so
>> this patch uses it to avoid frequently rdmsr of IA32_UMWAIT_CONTROL.
>>
>> Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
>> Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c  | 36 ++++++++++++++++++++++++++++++++++++
>>   arch/x86/kvm/vmx/vmx.h  |  3 +++
>>   arch/x86/power/umwait.c |  3 ++-
>>   3 files changed, 41 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index b35bfac30a34..f33a25e82cb8 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -1679,6 +1679,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, 
>> struct msr_data *msr_info)
>>   #endif
>>       case MSR_EFER:
>>           return kvm_get_msr_common(vcpu, msr_info);
>> +    case MSR_IA32_UMWAIT_CONTROL:
>> +        if (!vmx_waitpkg_supported())
>> +            return 1;
>> +
>> +        msr_info->data = vmx->msr_ia32_umwait_control;
>> +        break;
>>       case MSR_IA32_SPEC_CTRL:
>>           if (!msr_info->host_initiated &&
>>               !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
>> @@ -1841,6 +1847,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, 
>> struct msr_data *msr_info)
>>               return 1;
>>           vmcs_write64(GUEST_BNDCFGS, data);
>>           break;
>> +    case MSR_IA32_UMWAIT_CONTROL:
>> +        if (!vmx_waitpkg_supported())
>> +            return 1;
>> +
>> +        if (!data)
>> +            break;
>> +
> 
> Why cannot clear it to zero?
> 
>> +        vmx->msr_ia32_umwait_control = data;
>> +        break;
>>       case MSR_IA32_SPEC_CTRL:
>>           if (!msr_info->host_initiated &&
>>               !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
>> @@ -4126,6 +4141,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu 
>> *vcpu, bool init_event)
>>       vmx->rmode.vm86_active = 0;
>>       vmx->spec_ctrl = 0;
>> +    vmx->msr_ia32_umwait_control = 0;
>> +
>>       vcpu->arch.microcode_version = 0x100000000ULL;
>>       vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
>>       kvm_set_cr8(vcpu, 0);
>> @@ -6339,6 +6356,23 @@ static void atomic_switch_perf_msrs(struct 
>> vcpu_vmx *vmx)
>>                       msrs[i].host, false);
>>   }
>> +static void atomic_switch_ia32_umwait_control(struct vcpu_vmx *vmx)
>> +{
>> +    u64 host_umwait_control;
>> +
>> +    if (!vmx_waitpkg_supported())
>> +        return;
>> +
>> +    host_umwait_control = umwait_control_cached;
>> +
> 
> It's redundant to define host_umwait_control and this line, we can just 
> use umwait_control_cached.
> 
>> +    if (vmx->msr_ia32_umwait_control != host_umwait_control)
>> +        add_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL,
>> +                      vmx->msr_ia32_umwait_control,
>> +                      host_umwait_control, false);
> 
> The bit 1 is reserved, at least, we need to do below to ensure not 
> modifying the reserved bit:
> 
>      guest_val = (vmx->msr_ia32_umwait_control & ~BIT_ULL(1)) |
>              (host_val & BIT_ULL(1))
> 

I find a better solution to ensure reserved bit 1 not being modified in 
vmx_set_msr() as below:

	if((data ^ umwait_control_cached) & BIT_ULL(1))
		return 1;

>> +    else
>> +        clear_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL);
>> +}
>> +
>>   static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
>>   {
>>       vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
>> @@ -6447,6 +6481,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>       atomic_switch_perf_msrs(vmx);
>> +    atomic_switch_ia32_umwait_control(vmx);
>> +
>>       vmx_update_hv_timer(vcpu);
>>       /*
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 61128b48c503..8485bec7c38a 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -14,6 +14,8 @@
>>   extern const u32 vmx_msr_index[];
>>   extern u64 host_efer;
>> +extern u32 umwait_control_cached;
>> +
>>   #define MSR_TYPE_R    1
>>   #define MSR_TYPE_W    2
>>   #define MSR_TYPE_RW    3
>> @@ -194,6 +196,7 @@ struct vcpu_vmx {
>>   #endif
>>       u64              spec_ctrl;
>> +    u64              msr_ia32_umwait_control;
>>       u32 vm_entry_controls_shadow;
>>       u32 vm_exit_controls_shadow;
>> diff --git a/arch/x86/power/umwait.c b/arch/x86/power/umwait.c
>> index 7fa381e3fd4e..2e6ce4cbccb3 100644
>> --- a/arch/x86/power/umwait.c
>> +++ b/arch/x86/power/umwait.c
>> @@ -9,7 +9,8 @@
>>    * MSR value. By default, umwait max time is 100000 in TSC-quanta 
>> and C0.2
>>    * is enabled
>>    */
>> -static u32 umwait_control_cached = 100000;
>> +u32 umwait_control_cached = 100000;
>> +EXPORT_SYMBOL_GPL(umwait_control_cached);
>>   /*
>>    * Serialize access to umwait_control_cached and IA32_UMWAIT_CONTROL 
>> MSR
>>
