Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F42497AC
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 05:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfFRDE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 23:04:59 -0400
Received: from mga07.intel.com ([134.134.136.100]:60266 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfFRDE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 23:04:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 20:04:58 -0700
X-ExtLoop1: 1
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.224]) ([10.239.196.224])
  by orsmga003.jf.intel.com with ESMTP; 17 Jun 2019 20:04:55 -0700
Subject: Re: [PATCH RESEND v3 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
To:     Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, fenghua.yu@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jingqi.liu@intel.com
References: <20190616095555.20978-1-tao3.xu@intel.com>
 <20190616095555.20978-3-tao3.xu@intel.com>
 <d99b2ae1-38fc-0b71-2613-8131decc923a@intel.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <3468075c-9289-b2b5-8310-e1f39524a8e9@intel.com>
Date:   Tue, 18 Jun 2019 11:04:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
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

After read the kernel code of umwait again and test it again, host can 
set it to 0, when we set sys max_time to 0. So I am wondering to remove 
the "if (!data)" and set the value of msr value to 0x186a0(maxtime = 
100000) when KVM initialization.

And considering we use "-overcommit cpu-pm=on" to use umwait in QEMU 
side. It means guest can over-commit the host CPU, so set to 0 make sense.

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

Thanks for reminding.
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

