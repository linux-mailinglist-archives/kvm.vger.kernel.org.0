Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9AED1562E0
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2020 05:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgBHEvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 23:51:19 -0500
Received: from mga07.intel.com ([134.134.136.100]:47168 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726995AbgBHEvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 23:51:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 20:51:17 -0800
X-IronPort-AV: E=Sophos;i="5.70,416,1574150400"; 
   d="scan'208";a="225598124"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.53]) ([10.249.174.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2020 20:51:15 -0800
Subject: Re: [PATCH v3 8/8] x86: vmx: virtualize split lock detection
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com,
        peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
 <20200206070412.17400-9-xiaoyao.li@intel.com>
 <20200207182706.GA3267197@rani.riverdale.lan>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <97e022fd-df96-0de0-d9d3-af069e2e3163@intel.com>
Date:   Sat, 8 Feb 2020 12:51:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200207182706.GA3267197@rani.riverdale.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/8/2020 2:27 AM, Arvind Sankar wrote:
> On Thu, Feb 06, 2020 at 03:04:12PM +0800, Xiaoyao Li wrote:
>> Due to the fact that MSR_TEST_CTRL is per-core scope, i.e., the sibling
>> threads in the same physical CPU core share the same MSR, only
>> advertising feature split lock detection to guest when SMT is disabled
>> or unsupported for simplicitly.
>>
>> Below summarizing how guest behaves of different host configuration:
>>
>>    sld_fatal - MSR_TEST_CTL.SDL is forced on and is sticky from the guest's
> 			     ^^^ typo
>>                perspective (so the guest can detect a forced fatal mode).
> 
> Is the part in parentheses actually true currently, before adding [1] Sean's
> suggested SPLIT_LOCK_DETECT_STICKY bit? How would the guest detect the
> forced fatal mode without that?

Ah, I forgot to change this description. And thank you pointing out the 
typo.

The answer is no.
Based on this patch, guest cannot detect a forced fatal mode since no 
SPLIT_LOCK_DETECT_STICKY bit implemented. Guest thinks it can set/clear 
the bit but kvm makes the hardware bit forced set when vcpu is running.

BTW, even without SPLIT_LOCK_DETECT_STICKY bit, there is a way for guest 
to detect it's forced on that rdmsr() after wrmsr(..., SLD bit) to check 
whether the bit is cleared. But this solution is not architectural, so 
we'll try to push the way to add SPLIT_LOCK_DETECT_STICKY/LOCK bit.

> [1] https://lore.kernel.org/kvm/20200204060353.GB31665@linux.intel.com/
> 
>>
>>    sld_warn - SLD is exposed to the guest.  MSR_TEST_CTRL.SLD is left on
>>               until an #AC is intercepted with MSR_TEST_CTRL.SLD=0 in the
>>               guest, at which point normal sld_warn rules apply.  If a vCPU
>>               associated with the task does VM-Enter with
>> 	     MSR_TEST_CTRL.SLD=1, TIF_SLD is reset and the cycle begins
>> 	     anew.
>>
>>    sld_off - When set by the guest, MSR_TEST_CTL.SLD is set on VM-Entry
>>              and cleared on VM-Exit if guest enables SLD.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/include/asm/cpu.h  |  2 ++
>>   arch/x86/kernel/cpu/intel.c |  7 +++++
>>   arch/x86/kvm/vmx/vmx.c      | 59 +++++++++++++++++++++++++++++++++++--
>>   arch/x86/kvm/vmx/vmx.h      |  1 +
>>   arch/x86/kvm/x86.c          | 14 +++++++--
>>   5 files changed, 79 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
>> index f5172dbd3f01..2920de10e72c 100644
>> --- a/arch/x86/include/asm/cpu.h
>> +++ b/arch/x86/include/asm/cpu.h
>> @@ -46,6 +46,7 @@ unsigned int x86_stepping(unsigned int sig);
>>   extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
>>   extern void switch_to_sld(unsigned long tifn);
>>   extern bool handle_user_split_lock(unsigned long ip);
>> +extern void sld_turn_back_on(void);
>>   extern bool split_lock_detect_enabled(void);
>>   extern bool split_lock_detect_fatal(void);
>>   #else
>> @@ -55,6 +56,7 @@ static inline bool handle_user_split_lock(unsigned long ip)
>>   {
>>   	return false;
>>   }
>> +static inline void sld_turn_back_on(void) {}
>>   static inline bool split_lock_detect_enabled(void) { return false; }
>>   static inline bool split_lock_detect_fatal(void) { return false; }
>>   #endif
>> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
>> index b67b46ea66df..28dc1141152b 100644
>> --- a/arch/x86/kernel/cpu/intel.c
>> +++ b/arch/x86/kernel/cpu/intel.c
>> @@ -1087,6 +1087,13 @@ bool handle_user_split_lock(unsigned long ip)
>>   }
>>   EXPORT_SYMBOL_GPL(handle_user_split_lock);
>>   
>> +void sld_turn_back_on(void)
>> +{
>> +	__sld_msr_set(true);
>> +	clear_tsk_thread_flag(current, TIF_SLD);
>> +}
>> +EXPORT_SYMBOL_GPL(sld_turn_back_on);
>> +
>>   /*
>>    * This function is called only when switching between tasks with
>>    * different split-lock detection modes. It sets the MSR for the
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 822211975e6c..8735bf0f3dfd 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -1781,6 +1781,25 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>>   	}
>>   }
>>   
>> +/*
>> + * Note: for guest, feature split lock detection can only be enumerated through
>> + * MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT bit. The FMS enumeration is invalid.
>> + */
>> +static inline bool guest_has_feature_split_lock_detect(struct kvm_vcpu *vcpu)
>> +{
>> +	return vcpu->arch.core_capabilities & MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT;
>> +}
>> +
>> +static inline u64 vmx_msr_test_ctrl_valid_bits(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 valid_bits = 0;
>> +
>> +	if (guest_has_feature_split_lock_detect(vcpu))
>> +		valid_bits |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>> +
>> +	return valid_bits;
>> +}
>> +
>>   /*
>>    * Reads an msr value (of 'msr_index') into 'pdata'.
>>    * Returns 0 on success, non-0 otherwise.
>> @@ -1793,6 +1812,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   	u32 index;
>>   
>>   	switch (msr_info->index) {
>> +	case MSR_TEST_CTRL:
>> +		if (!msr_info->host_initiated &&
>> +		    !guest_has_feature_split_lock_detect(vcpu))
>> +			return 1;
>> +		msr_info->data = vmx->msr_test_ctrl;
>> +		break;
>>   #ifdef CONFIG_X86_64
>>   	case MSR_FS_BASE:
>>   		msr_info->data = vmcs_readl(GUEST_FS_BASE);
>> @@ -1934,6 +1959,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   	u32 index;
>>   
>>   	switch (msr_index) {
>> +	case MSR_TEST_CTRL:
>> +		if (!msr_info->host_initiated &&
>> +		    (!guest_has_feature_split_lock_detect(vcpu) ||
>> +		     data & ~vmx_msr_test_ctrl_valid_bits(vcpu)))
>> +			return 1;
>> +		vmx->msr_test_ctrl = data;
>> +		break;
>>   	case MSR_EFER:
>>   		ret = kvm_set_msr_common(vcpu, msr_info);
>>   		break;
>> @@ -4230,6 +4262,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   
>>   	vmx->rmode.vm86_active = 0;
>>   	vmx->spec_ctrl = 0;
>> +	vmx->msr_test_ctrl = 0;
>>   
>>   	vmx->msr_ia32_umwait_control = 0;
>>   
>> @@ -4563,6 +4596,11 @@ static inline bool guest_cpu_alignment_check_enabled(struct kvm_vcpu *vcpu)
>>   	       (kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
>>   }
>>   
>> +static inline bool guest_cpu_split_lock_detect_enabled(struct vcpu_vmx *vmx)
>> +{
>> +	return vmx->msr_test_ctrl & MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>> +}
>> +
>>   static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>>   {
>>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> @@ -4658,8 +4696,9 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>>   		break;
>>   	case AC_VECTOR:
>>   		/*
>> -		 * Inject #AC back to guest only when guest enables legacy
>> -		 * alignment check.
>> +		 * Inject #AC back to guest only when guest is expecting it,
>> +		 * i.e., guest enables legacy alignment check or split lock
>> +		 * detection.
>>   		 * Otherwise, it must be an unexpected split lock #AC of guest
>>   		 * since hardware SPLIT_LOCK_DETECT bit keeps unchanged set
>>   		 * when vcpu is running. In this case, treat guest the same as
>> @@ -4670,6 +4709,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>>   		 *    similar as sending SIGBUS.
>>   		 */
>>   		if (!split_lock_detect_enabled() ||
>> +		    guest_cpu_split_lock_detect_enabled(vmx) ||
>>   		    guest_cpu_alignment_check_enabled(vcpu)) {
>>   			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
>>   			return 1;
>> @@ -6555,6 +6595,16 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>   	 */
>>   	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
>>   
>> +	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
>> +	    guest_cpu_split_lock_detect_enabled(vmx)) {
>> +		if (test_thread_flag(TIF_SLD))
>> +			sld_turn_back_on();
>> +		else if (!split_lock_detect_enabled())
>> +			wrmsrl(MSR_TEST_CTRL,
>> +			       this_cpu_read(msr_test_ctrl_cache) |
>> +			       MSR_TEST_CTRL_SPLIT_LOCK_DETECT);
>> +	}
>> +
>>   	/* L1D Flush includes CPU buffer clear to mitigate MDS */
>>   	if (static_branch_unlikely(&vmx_l1d_should_flush))
>>   		vmx_l1d_flush(vcpu);
>> @@ -6589,6 +6639,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>   
>>   	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
>>   
>> +	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
>> +	    guest_cpu_split_lock_detect_enabled(vmx) &&
>> +	    !split_lock_detect_enabled())
>> +		wrmsrl(MSR_TEST_CTRL, this_cpu_read(msr_test_ctrl_cache));
>> +
>>   	/* All fields are clean at this point */
>>   	if (static_branch_unlikely(&enable_evmcs))
>>   		current_evmcs->hv_clean_fields |=
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 7f42cf3dcd70..4cb8075e0b2a 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -222,6 +222,7 @@ struct vcpu_vmx {
>>   #endif
>>   
>>   	u64		      spec_ctrl;
>> +	u64		      msr_test_ctrl;
>>   	u32		      msr_ia32_umwait_control;
>>   
>>   	u32 secondary_exec_control;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ed16644289a3..a3bb09319526 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1163,7 +1163,7 @@ static const u32 msrs_to_save_all[] = {
>>   #endif
>>   	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
>>   	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
>> -	MSR_IA32_SPEC_CTRL,
>> +	MSR_IA32_SPEC_CTRL, MSR_TEST_CTRL,
>>   	MSR_IA32_RTIT_CTL, MSR_IA32_RTIT_STATUS, MSR_IA32_RTIT_CR3_MATCH,
>>   	MSR_IA32_RTIT_OUTPUT_BASE, MSR_IA32_RTIT_OUTPUT_MASK,
>>   	MSR_IA32_RTIT_ADDR0_A, MSR_IA32_RTIT_ADDR0_B,
>> @@ -1345,7 +1345,12 @@ static u64 kvm_get_arch_capabilities(void)
>>   
>>   static u64 kvm_get_core_capabilities(void)
>>   {
>> -	return 0;
>> +	u64 data = 0;
>> +
>> +	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) && !cpu_smt_possible())
>> +		data |= MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT;
>> +
>> +	return data;
>>   }
>>   
>>   static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>> @@ -5259,6 +5264,11 @@ static void kvm_init_msr_list(void)
>>   		 * to the guests in some cases.
>>   		 */
>>   		switch (msrs_to_save_all[i]) {
>> +		case MSR_TEST_CTRL:
>> +			if (!(kvm_get_core_capabilities() &
>> +			      MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT))
>> +				continue;
>> +			break;
>>   		case MSR_IA32_BNDCFGS:
>>   			if (!kvm_mpx_supported())
>>   				continue;
>> -- 
>> 2.23.0
>>

