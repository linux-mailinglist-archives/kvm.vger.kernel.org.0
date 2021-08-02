Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D960D3DD607
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 14:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhHBMxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 08:53:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:31381 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232629AbhHBMxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 08:53:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10063"; a="274511422"
X-IronPort-AV: E=Sophos;i="5.84,288,1620716400"; 
   d="scan'208";a="274511422"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 05:53:07 -0700
X-IronPort-AV: E=Sophos;i="5.84,288,1620716400"; 
   d="scan'208";a="520498828"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.168.136]) ([10.249.168.136])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 05:53:03 -0700
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
To:     Sean Christopherson <seanjc@google.com>, Tao Xu <tao3.xu@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <YQRkBI9RFf6lbifZ@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <b0c90258-3f68-57a2-664a-e20a6d251e45@intel.com>
Date:   Mon, 2 Aug 2021 20:53:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQRkBI9RFf6lbifZ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/31/2021 4:41 AM, Sean Christopherson wrote:
> On Tue, May 25, 2021, Tao Xu wrote:
>>   #endif /* __KVM_X86_VMX_CAPS_H */
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 4bceb5ca3a89..c0ad01c88dac 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -205,6 +205,10 @@ module_param(ple_window_max, uint, 0444);
>>   int __read_mostly pt_mode = PT_MODE_SYSTEM;
>>   module_param(pt_mode, int, S_IRUGO);
>>   
>> +/* Default is 0, less than 0 (for example, -1) disables notify window. */
>> +static int __read_mostly notify_window;
> 
> I'm not sure I like the idea of trusting ucode to select an appropriate internal
> threshold.  Unless the internal threshold is architecturally defined to be at
> least N nanoseconds or whatever, I think KVM should provide its own sane default.
> E.g. it's not hard to imagine a scenario where a ucode patch gets rolled out that
> adjusts the threshold and starts silently degrading guest performance.

You mean when internal threshold gets smaller somehow, and cases 
false-positive that leads unexpected VM exit on normal instruction? In 
this case, we set increase the vmcs.notify_window in KVM.

I think there is no better to avoid this case if ucode changes internal 
threshold. Unless KVM's default notify_window is bigger enough.

> Even if the internal threshold isn't architecturally constrained, it would be very,
> very helpful if Intel could publish the per-uarch/stepping thresholds, e.g. to give
> us a ballpark idea of how agressive KVM can be before it risks false positives.

Even Intel publishes the internal threshold, we still need to provide a 
final best_value (internal + vmcs.notify_window). Then what's that value?

If we have an option for final best_value, then I think it's OK to just 
let vmcs.notify_window = best_value. Then the true final value is 
best_value + internal.
  - if it's a normal instruction, it should finish within best_value or 
best_value + internal. So it makes no difference.
  - if it's an instruction in malicious case, it won't go to next 
instruction whether wait for best_value or best_value + internal.

>> +module_param(notify_window, int, 0644);
> 
> I really like the idea of making the module param writable, but doing so will
> require far more effort.  At an absolute minimum, the module param would need to
> be snapshotted at VM creation time, a la lapic_timer_advance_ns, otherwise the
> behavior is non-deterministic.
> 
> But I don't think snapshotting is a worthwhile approach because the main reason
> for adjusting the window while guests are running is probably going to be to relax
> the window because guest's are observing degraded performance.  

Let's make it non-writable.

> Hopefully that
> never happens, but the "CPU adds a magic internal buffer" behavior makes me more
> than a bit nervous.

If we don't trust internal value, we can just treat it as 0.

> And on the other hand, adding a ton of logic to forcefully update every VMCS is
> likely overkill.
> 
> So, that takes us back to providing a sane, somewhat conservative default.  I've
> said in the past that ideally the notify_window would be as small as possible,
> but pushing it down to single digit cycles swings the pendulum too far in the
> other direction.
> 
>> +
>>   static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
>>   static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
>>   static DEFINE_MUTEX(vmx_l1d_flush_mutex);
>> @@ -2539,7 +2543,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>   			SECONDARY_EXEC_PT_USE_GPA |
>>   			SECONDARY_EXEC_PT_CONCEAL_VMX |
>>   			SECONDARY_EXEC_ENABLE_VMFUNC |
>> -			SECONDARY_EXEC_BUS_LOCK_DETECTION;
>> +			SECONDARY_EXEC_BUS_LOCK_DETECTION |
>> +			SECONDARY_EXEC_NOTIFY_VM_EXITING;
>>   		if (cpu_has_sgx())
>>   			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
>>   		if (adjust_vmx_controls(min2, opt2,
>> @@ -4376,6 +4381,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>>   	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
>>   		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
>>   
>> +	if (cpu_has_notify_vm_exiting() && notify_window < 0)
>> +		exec_control &= ~SECONDARY_EXEC_NOTIFY_VM_EXITING;
>> +
>>   	vmx->secondary_exec_control = exec_control;
>>   }
>>   
>> @@ -4423,6 +4431,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>>   		vmx->ple_window_dirty = true;
>>   	}
>>   
>> +	if (cpu_has_notify_vm_exiting() && notify_window >= 0)
>> +		vmcs_write32(NOTIFY_WINDOW, notify_window);
> 
> I'm all for punting full nested support to a future patch, but _this_ patch
> absolutely needs to apply KVM's notify_window to vmcs02, otherwise L1 can simply
> run in L2 to avoid the restriction.  init_vmcs() is used only for vmcs01, i.e.
> prepare_vmcs02_constant_state() needs to set the correct vmcs.NOTIFY_WINDOW,
> and prepare_vmcs02_early() needs to set/clear SECONDARY_EXEC_NOTIFY_VM_EXITING
> appropriately.

Thanks for pointing it out. We will fix it in next version.

>> +
>>   	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
>>   	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
>>   	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
>> @@ -5642,6 +5653,31 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
>>   	return 0;
>>   }
>>   
>> +static int handle_notify(struct kvm_vcpu *vcpu)
>> +{
>> +	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
>> +
>> +	if (!(exit_qual & NOTIFY_VM_CONTEXT_INVALID)) {
> 
> What does CONTEXT_INVALID mean?  The ISE doesn't provide any information whatsoever.

It means whether the VM context is corrupted and not valid in the VMCS.

>> +		/*
>> +		 * Notify VM exit happened while executing iret from NMI,
>> +		 * "blocked by NMI" bit has to be set before next VM entry.
>> +		 */
>> +		if (enable_vnmi &&
>> +		    (exit_qual & INTR_INFO_UNBLOCK_NMI))
>> +			vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
>> +				      GUEST_INTR_STATE_NMI);
> 
> Hmm, logging of some kind is probably a good idea if this exit occurs, e.g. so
> that the host can (a) get an indication that a guest is potentially malicious and
> (b) rule out (or confirm) notify_window exits as the source of degraded guest
> performance.
> 
> Maybe add a per-vCPU stat, "u64 notify_window_exits"?

Good idea.

> Another thought would be to also do pr_info/warn_ratelimited if a vCPU gets
> multiple notify_window exits and doesn't appear to be making forward progress,
> e.g. same RIP observed two notify_window exits in a row.  Even if the guest is
> making forward progress, displaying the guest RIP and instruction (if possible)
> could be useful in triaging why the guest appears to be getting false positives.

I suppose kvm_exit trace can be used if we find there are too many 
notify_exit.

>> +		return 1;
>> +	}
>> +
>> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_NO_EVENT_WINDOW;
>> +	vcpu->run->internal.ndata = 1;
>> +	vcpu->run->internal.data[0] = exit_qual;
> 
> Unless an invalid context can _never_ happen, or is already fatal to the guest,

As I explained, invalid means VM context is corrupted and not valid in 
VMCS. We have no choice.

> I don't think effectively killing the guest is a good idea.  KVM doesn't know
> for certain that the guest was being malicious, all it knows is that the CPU
> didn't open an event window for some arbitrary amount of time (arbitrary because
> the internal threshold is likely to be uarch specific).  KVM is getting exits,
> which means it's getting a chance to check for signals, etc..., so resuming the
> guest is ok.
> 
>> +
>> +	return 0;
>> +}
>> +
>>   /*
>>    * The exit handlers return 1 if the exit was handled fully and guest execution
>>    * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
>> @@ -5699,6 +5735,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>>   	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
>>   	[EXIT_REASON_ENCLS]		      = handle_encls,
>>   	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
>> +	[EXIT_REASON_NOTIFY]		      = handle_notify,
>>   };
>>   

