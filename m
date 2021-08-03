Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FFC3DE8E5
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhHCIuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:50:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:18401 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234689AbhHCIuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 04:50:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10064"; a="211762837"
X-IronPort-AV: E=Sophos;i="5.84,291,1620716400"; 
   d="scan'208";a="211762837"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 01:50:08 -0700
X-IronPort-AV: E=Sophos;i="5.84,291,1620716400"; 
   d="scan'208";a="510951292"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.0.162]) ([10.238.0.162])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 01:50:06 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v4 2/5] KVM: X86: Expose PKS to guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210205083706.14146-1-chenyi.qiang@intel.com>
 <20210205083706.14146-3-chenyi.qiang@intel.com> <YQLa4UErfNbdjv3l@google.com>
Message-ID: <4c335e72-5866-9b7a-ee99-712adc9a9228@intel.com>
Date:   Tue, 3 Aug 2021 16:50:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQLa4UErfNbdjv3l@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Sean for your review.

On 7/30/2021 12:44 AM, Sean Christopherson wrote:
> On Fri, Feb 05, 2021, Chenyi Qiang wrote:
>> @@ -539,6 +540,7 @@ struct kvm_vcpu_arch {
>>   	unsigned long cr8;
>>   	u32 host_pkru;
>>   	u32 pkru;
>> +	u32 pkrs;
>>   	u32 hflags;
>>   	u64 efer;
>>   	u64 apic_base;
> 
> ...
> 
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 89af692deb7e..2266d98ace6f 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -250,6 +250,7 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
>>   	dest->ds_sel = src->ds_sel;
>>   	dest->es_sel = src->es_sel;
>>   #endif
>> +	dest->pkrs = src->pkrs;
> 
> This is wrong.  It also arguably belongs in patch 04.
> 
> The part that's missing is actually updating vmcs.HOST_IA32_PKRS.  FS/GS are
> handled by vmx_set_host_fs_gs(), while LDT/DS/ES are oddballs where the selector
> is also the state that's restored.
> 

Will fix it. I guess it should belong in patch 05.

> In other words, this will cause nested VM-Exit to load the wrong PKRS.
> 
>>   }
>>   
>>   static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
>> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
>> index 1472c6c376f7..b5ba6407c5e1 100644
>> --- a/arch/x86/kvm/vmx/vmcs.h
>> +++ b/arch/x86/kvm/vmx/vmcs.h
>> @@ -40,6 +40,7 @@ struct vmcs_host_state {
>>   #ifdef CONFIG_X86_64
>>   	u16           ds_sel, es_sel;
>>   #endif
>> +	u32           pkrs;
>>   };
>>   
>>   struct vmcs_controls_shadow {
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 47b8357b9751..a3d95492e2b7 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -363,6 +363,8 @@ module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
>>   static u32 vmx_segment_access_rights(struct kvm_segment *var);
>>   static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
>>   							  u32 msr, int type);
>> +static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
>> +							 u32 msr, int type);
>>   
>>   void vmx_vmexit(void);
>>   
>> @@ -660,6 +662,8 @@ static bool is_valid_passthrough_msr(u32 msr)
>>   	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
>>   		/* PT MSRs. These are handled in pt_update_intercept_for_msr() */
>>   		return true;
>> +	case MSR_IA32_PKRS:
>> +		return true;
> 
> This is wrong with respect to MSR filtering, as KVM will fail to intercept the
> MSR in response to a filter change.  See vmx_msr_filter_changed()..  I also think
> that special casing PKRS is a bad idea in general.  More later.
> 

Yes, msr filter support for PKRS was missing. Will add the support in 
vmx_msr_filter_changed().

>>   	}
>>   
>>   	r = possible_passthrough_msr_slot(msr) != -ENOENT;
> 
> ...
> 
>> +	case MSR_IA32_PKRS:
>> +		if (!kvm_pkrs_valid(data))
>> +			return 1;
>> +		if (!kvm_cpu_cap_has(X86_FEATURE_PKS) ||
>> +		    (!msr_info->host_initiated &&
>> +		    !guest_cpuid_has(vcpu, X86_FEATURE_PKS)))
>> +			return 1;
>> +		if (vcpu->arch.pkrs != data) {
> 
> This will need to be modified if we go with my below proposal.
> 
>> +			vcpu->arch.pkrs = data;
>> +			vmcs_write64(GUEST_IA32_PKRS, data);
>> +		}
>> +		break;
>>   	case MSR_TSC_AUX:
>>   		if (!msr_info->host_initiated &&
>>   		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
>> @@ -2479,7 +2518,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>   	      VM_EXIT_LOAD_IA32_EFER |
>>   	      VM_EXIT_CLEAR_BNDCFGS |
>>   	      VM_EXIT_PT_CONCEAL_PIP |
>> -	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
>> +	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
>> +	      VM_EXIT_LOAD_IA32_PKRS;
>>   	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
>>   				&_vmexit_control) < 0)
>>   		return -EIO;
>> @@ -2503,7 +2543,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>   	      VM_ENTRY_LOAD_IA32_EFER |
>>   	      VM_ENTRY_LOAD_BNDCFGS |
>>   	      VM_ENTRY_PT_CONCEAL_PIP |
>> -	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
>> +	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
>> +	      VM_ENTRY_LOAD_IA32_PKRS;
>>   	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
>>   				&_vmentry_control) < 0)
>>   		return -EIO;
>> @@ -3103,8 +3144,9 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>>   	 * is in force while we are in guest mode.  Do not let guests control
>>   	 * this bit, even if host CR4.MCE == 0.
>>   	 */
>> -	unsigned long hw_cr4;
>> +	unsigned long hw_cr4, old_cr4;
>>   
>> +	old_cr4 = kvm_read_cr4(vcpu);
>>   	hw_cr4 = (cr4_read_shadow() & X86_CR4_MCE) | (cr4 & ~X86_CR4_MCE);
>>   	if (is_unrestricted_guest(vcpu))
>>   		hw_cr4 |= KVM_VM_CR4_ALWAYS_ON_UNRESTRICTED_GUEST;
>> @@ -3152,7 +3194,7 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>>   		}
>>   
>>   		/*
>> -		 * SMEP/SMAP/PKU is disabled if CPU is in non-paging mode in
>> +		 * SMEP/SMAP/PKU/PKS is disabled if CPU is in non-paging mode in
>>   		 * hardware.  To emulate this behavior, SMEP/SMAP/PKU needs
>>   		 * to be manually disabled when guest switches to non-paging
>>   		 * mode.
>> @@ -3160,10 +3202,29 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>>   		 * If !enable_unrestricted_guest, the CPU is always running
>>   		 * with CR0.PG=1 and CR4 needs to be modified.
>>   		 * If enable_unrestricted_guest, the CPU automatically
>> -		 * disables SMEP/SMAP/PKU when the guest sets CR0.PG=0.
>> +		 * disables SMEP/SMAP/PKU/PKS when the guest sets CR0.PG=0.
>>   		 */
>>   		if (!is_paging(vcpu))
>> -			hw_cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
>> +			hw_cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE |
>> +				    X86_CR4_PKS);
>> +	}
>> +
>> +	if ((hw_cr4 ^ old_cr4) & X86_CR4_PKS) {
> 
> Comparing hw_cr4 and old_cr4 is wrong, they are representative of two different
> contexts.  old_cr4 is the guest's previous CR4 irrespective of KVM maniuplations,
> whereas hw_cr4 does include KVM's modification, e.g. the is_paging() logic above
> may clear CR4.PKS and may lead to incorrect behavior.
> 
> E.g.:
> 
> 	guest.CR4.PKS = 1
> 	guest.CR0.PG  = 0
> 	guest_hw.CR4.PKS = 0  // KVM
> 	vmcs.LOAD_PKRS = 0    // KVM
> 	guest.CR0.PG  = 1
> 	guest_hw.CR4.PKS = 1  // KVM
> 	vmcs.LOAD_PKRS not modified because guest.CR4.PKS == guest_hw.CR4.PKS == 1
> 
> This logic also fails to handle the case where L1 doesn't intercept CR4.PKS
> modifications for L2.
> 
> The VM-Exit path that does:
> 
>> +     if (static_cpu_has(X86_FEATURE_PKS) &&
>> +         kvm_read_cr4_bits(vcpu, X86_CR4_PKS))
>> +             vcpu->arch.pkrs = vmcs_read64(GUEST_IA32_PKRS)
> 
> is also flawed in that, per this scheme, it may unnecessarily read vmcs.GUEST_PKRS,
> though I don't think it can get the wrong value, unless of course it's running L2...
> 
> In short, IMO toggling PKRS interception/load on CR4 changes is a really, really
> bad idea.  UMIP emulation attempted do fancy toggling and got it wrong multiple
> times, and this is more complicated than what UMIP was trying to do.
> 
> The only motiviation for toggling PKRS interception/load is to avoid the VMREAD in
> the VM-Exit path.  Given that vcpu->arch.pkrs is rarely accessed by KVM, e.g. only
> on host userspace MSR reads and and GVA->GPA translation via permission_fault(),
> keeping vcpu->arch.pkrs up-to-date at all times is unnecessary, i.e. it can be
> synchronized on-demand.  And regarding permission_fault(), that's indirectly gated
> by CR4.PKS=1, thus deferring the VMREAD to permission_fault() is guaranteed to be
> more performant than reading on every VM-Exit (with CR4.PKS=1).
> 
> So:
> 
>    - Disable PKRS MSR interception if it's exposed to the guest.
>    - Load PKRS on entry/exit if it's exposed to the guest.
>    - Add VCPU_EXREG_PKRS and clear its bits in vmx_register_cache_reset().
>    - Add helpers to read/write/cache PKRS and use accordingly.
> 

Make sense. Will refactor all these mentioned in next version.

>> +		/* pass through PKRS to guest when CR4.PKS=1 */
>> +		if (guest_cpuid_has(vcpu, X86_FEATURE_PKS) && hw_cr4 & X86_CR4_PKS) {
>> +			vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW);
>> +			vm_entry_controls_setbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
>> +			vm_exit_controls_setbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
>> +			/*
>> +			 * Every vm exit saves guest pkrs automatically, sync vcpu->arch.pkrs
>> +			 * to VMCS.GUEST_PKRS to avoid the pollution by host pkrs.
>> +			 */
>> +			vmcs_write64(GUEST_IA32_PKRS, vcpu->arch.pkrs);
>> +		} else {
>> +			vmx_enable_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW);
>> +			vm_entry_controls_clearbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
>> +			vm_exit_controls_clearbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
>> +		}
>>   	}
>>   
>>   	vmcs_writel(CR4_READ_SHADOW, cr4);
> 
> ...
> 
>> @@ -6776,6 +6841,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>   
>>   	pt_guest_exit(vmx);
>>   
>> +	if (static_cpu_has(X86_FEATURE_PKS) &&
>> +	    kvm_read_cr4_bits(vcpu, X86_CR4_PKS))
>> +		vcpu->arch.pkrs = vmcs_read64(GUEST_IA32_PKRS);
>> +
>>   	kvm_load_host_xsave_state(vcpu);
>>   
>>   	vmx->nested.nested_run_pending = 0;
>> @@ -7280,6 +7349,14 @@ static __init void vmx_set_cpu_caps(void)
>>   	if (vmx_pt_mode_is_host_guest())
>>   		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
>>   
>> +	/*
>> +	 * PKS is not yet implemented for shadow paging.
>> +	 * If not support VM_{ENTRY, EXIT}_LOAD_IA32_PKRS,
>> +	 * don't expose the PKS as well.
>> +	 */
>> +	if (enable_ept && cpu_has_load_ia32_pkrs())
>> +		kvm_cpu_cap_check_and_set(X86_FEATURE_PKS);
>> +
>>   	if (vmx_umip_emulated())
>>   		kvm_cpu_cap_set(X86_FEATURE_UMIP);
>>   
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index f5ede41bf9e6..684ef760481c 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1213,7 +1213,7 @@ static const u32 msrs_to_save_all[] = {
>>   	MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
>>   	MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
>>   	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
>> -	MSR_IA32_UMWAIT_CONTROL,
>> +	MSR_IA32_UMWAIT_CONTROL, MSR_IA32_PKRS,
>>   
>>   	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
>>   	MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
>> @@ -5718,6 +5718,10 @@ static void kvm_init_msr_list(void)
>>   				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
>>   				continue;
>>   			break;
>> +		case MSR_IA32_PKRS:
>> +			if (!kvm_cpu_cap_has(X86_FEATURE_PKS))
>> +				continue;
>> +			break;
>>   		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
>>   			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
>>   			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>> @@ -10026,6 +10030,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   
>>   	vcpu->arch.ia32_xss = 0;
>>   
>> +	vcpu->arch.pkrs = 0;
> 
> This is wrong and also unreviewable.  It's wrong because the write isn't propagted
> to vmcs.GUEST_PKRS, e.g. if the guest enables CR0.PG and CR4.PKS without writing
> PKRS, KVM will run the guest with a stale value.
> 

Yes, should write to vmcs to do reset.
  > It's unreviewable because the SDM doesn't specify whether PKRS is 
cleared or
> preserved on INIT.  The SDM needs an entry for PRKS in Table 9-1. "IA-32 and Intel
> 64 Processor States Following Power-up, Reset, or INIT" before this can be merged.
> 

PKRS is missing in Table 9-1. It will be updated in next version of SDM, 
just let you know to help current review:

"PKRS is cleared on INIT. It should be 0 in all cases."

>> +
>>   	kvm_x86_ops.vcpu_reset(vcpu, init_event);
>>   }
