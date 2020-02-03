Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5523150A68
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 16:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgBCP6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 10:58:47 -0500
Received: from mga14.intel.com ([192.55.52.115]:38411 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbgBCP6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 10:58:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 07:58:46 -0800
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="223977759"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.30.164]) ([10.255.30.164])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 03 Feb 2020 07:58:44 -0800
Subject: Re: [PATCH v2 6/6] x86: vmx: virtualize split lock detection
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
 <20200203151608.28053-7-xiaoyao.li@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <4c871e71-20c9-694e-8f90-d7b88db314c3@intel.com>
Date:   Mon, 3 Feb 2020 23:58:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200203151608.28053-7-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/2020 11:16 PM, Xiaoyao Li wrote:
> Due to the fact that MSR_TEST_CTRL is per-core scope, i.e., the sibling
> threads in the same physical CPU core share the same MSR, only
> advertising feature split lock detection to guest when SMT is disabled
> or unsupported for simplicitly.
> 
> Only when host is sld_off, can guest control the hardware value of
> MSR_TEST_CTL, i.e., KVM loads guest's value into hardware when vcpu is
> running.
> 
> The vmx->disable_split_lock_detect can be set to true after unhandled
> split_lock #AC in guest only when host is sld_warn mode. It's for not
> burnning old guest, of course malicous guest can exploit it for DoS
> attack.
> 
> If want to prevent DoS attack from malicious guest, it must use sld_fatal
> mode in host. When host is sld_fatal, hardware value of
> MSR_TEST_CTL.SPLIT_LOCK_DETECT never cleared.
> 
> Below summarizing how guest behaves if SMT is off and it's a linux guest:
> 
> -----------------------------------------------------------------------
>     Host	| Guest | Guest behavior
> -----------------------------------------------------------------------
> 1. off	|	| same as in bare metal
> -----------------------------------------------------------------------
> 2. warn | off	| hardware bit set initially. Once split lock happens,
> 	|	| it sets vmx->disable_split_lock_detect, which leads
> 	|	| hardware bit to be cleared when vcpu is running
>          |	| So, it's the same as in bare metal
> 	---------------------------------------------------------------
> 3.	| warn	| - user space: get #AC when split lock, then clear
> 	|	|   MSR bit, but hardware bit is not cleared. #AC again,
> 	|	|   finally sets vmx->disable_split_lock_detect, which
> 	|	|   leads hardware bit to be cleared when vcpu is running;
> 	|	|   After the userspace process finishes, it sets vcpu's
> 	|	|   MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit, which causes
> 	|	|   vmx->disable_split_lock_detect to be set false
>          |	|   So it's somehow the same as in bare-metal
>          |	| - kernel: same as in bare metal.
> 	--------------------------------------------------------------
> 4.	| fatal | same as in bare metal
> ----------------------------------------------------------------------
> 5. fatal| off   | #AC reported to userspace
> 	--------------------------------------------------------------
> 6.	| warn  | - user space: get #AC when split lock, then clear
> 	|	|   MSR bit, but hardware bit is not cleared, #AC again,
>          |	|   #AC reported to userspace
>          |	| - kernel: same as in bare metal, call die();
> 	-------------------------------------------------------------
> 7.    	| fatal | same as in bare metal
> ----------------------------------------------------------------------
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 72 +++++++++++++++++++++++++++++++++++-------
>   arch/x86/kvm/vmx/vmx.h |  1 +
>   arch/x86/kvm/x86.c     | 13 ++++++--
>   3 files changed, 73 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 93e3370c5f84..a0c3f579ecb6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1781,6 +1781,26 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>   	}
>   }
>   
> +/*
> + * Note: for guest, feature split lock detection can only be enumerated by
> + * MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT. The FMS enumeration is invalid.
> + */
> +static inline bool guest_has_feature_split_lock_detect(struct kvm_vcpu *vcpu)
> +{
> +	return !!(vcpu->arch.core_capabilities &
> +		  MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT);
> +}
> +
> +static inline u64 vmx_msr_test_ctrl_valid_bits(struct kvm_vcpu *vcpu)
> +{
> +	u64 valid_bits = 0;
> +
> +	if (guest_has_feature_split_lock_detect(vcpu))
> +		valid_bits |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
> +
> +	return valid_bits;
> +}
> +
>   /*
>    * Reads an msr value (of 'msr_index') into 'pdata'.
>    * Returns 0 on success, non-0 otherwise.
> @@ -1793,6 +1813,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	u32 index;
>   
>   	switch (msr_info->index) {
> +	case MSR_TEST_CTRL:
> +		if (!msr_info->host_initiated &&
> +		    !guest_has_feature_split_lock_detect(vcpu))
> +			return 1;
> +		msr_info->data = vmx->msr_test_ctrl;
> +		break;
>   #ifdef CONFIG_X86_64
>   	case MSR_FS_BASE:
>   		msr_info->data = vmcs_readl(GUEST_FS_BASE);
> @@ -1934,6 +1960,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	u32 index;
>   
>   	switch (msr_index) {
> +	case MSR_TEST_CTRL:
> +		if (!msr_info->host_initiated &&
> +		    (!guest_has_feature_split_lock_detect(vcpu) ||
> +		     data & ~vmx_msr_test_ctrl_valid_bits(vcpu)))
> +			return 1;
> +		if (data & MSR_TEST_CTRL_SPLIT_LOCK_DETECT)
> +			vmx->disable_split_lock_detect = false;
> +		vmx->msr_test_ctrl = data;
> +		break;
>   	case MSR_EFER:
>   		ret = kvm_set_msr_common(vcpu, msr_info);
>   		break;
> @@ -4233,6 +4268,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   
>   	vmx->msr_ia32_umwait_control = 0;
>   
> +	vmx->msr_test_ctrl = 0;
>   	vmx->disable_split_lock_detect = false;
>   
>   	vcpu->arch.microcode_version = 0x100000000ULL;
> @@ -4565,6 +4601,11 @@ static inline bool guest_cpu_alignment_check_enabled(struct kvm_vcpu *vcpu)
>   	       (kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
>   }
>   
> +static inline bool guest_cpu_split_lock_detect_enabled(struct vcpu_vmx *vmx)
> +{
> +	return !!(vmx->msr_test_ctrl & MSR_TEST_CTRL_SPLIT_LOCK_DETECT);
> +}
> +
>   static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -4660,8 +4701,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>   		break;
>   	case AC_VECTOR:
>   		/*
> -		 * Inject #AC back to guest only when legacy alignment check
> -		 * enabled.
> +		 * Inject #AC back to guest only when guest is expecting it,
> +		 * i.e., legacy alignment check or split lock #AC enabled.
>   		 * Otherwise, it must be an unexpected split-lock #AC for guest
>   		 * since KVM keeps hardware SPLIT_LOCK_DETECT bit unchanged
>   		 * when vcpu is running.
> @@ -4674,12 +4715,13 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>   		 *    similar as sending SIGBUS.
>   		 */
>   		if (guest_cpu_alignment_check_enabled(vcpu) ||
> +		    guest_cpu_split_lock_detect_enabled(vmx) ||
>   		    WARN_ON(get_split_lock_detect_state() == sld_off)) {
>   			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
>   			return 1;
>   		}
>   		if (get_split_lock_detect_state() == sld_warn) {
> -			pr_warn("kvm: split lock #AC happened in %s [%d]\n",
> +			pr_warn_ratelimited("kvm: split lock #AC happened in %s [%d]\n",
>   				current->comm, current->pid);
>   			vmx->disable_split_lock_detect = true;
>   			return 1;
> @@ -6491,6 +6533,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   	unsigned long cr3, cr4;
> +	bool host_sld_enabled, guest_sld_enabled;
>   
>   	/* Record the guest's net vcpu time for enforced NMI injections. */
>   	if (unlikely(!enable_vnmi &&
> @@ -6562,10 +6605,15 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   	 */
>   	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
>   
> -	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
> -	    unlikely(vmx->disable_split_lock_detect) &&
> -	    !test_tsk_thread_flag(current, TIF_SLD))
> -		split_lock_detect_set(false);
> +	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
> +		host_sld_enabled = get_split_lock_detect_state() &&
> +				   !test_tsk_thread_flag(current, TIF_SLD);
> +		guest_sld_enabled = guest_cpu_split_lock_detect_enabled(vmx);
> +		if (host_sld_enabled && unlikely(vmx->disable_split_lock_detect))
> +			split_lock_detect_set(false);
> +		else if (!host_sld_enabled && guest_sld_enabled)
> +			split_lock_detect_set(true);
> +	}
>   
>   	/* L1D Flush includes CPU buffer clear to mitigate MDS */
>   	if (static_branch_unlikely(&vmx_l1d_should_flush))
> @@ -6601,10 +6649,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
>   
> -	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
> -	    unlikely(vmx->disable_split_lock_detect) &&
> -	    !test_tsk_thread_flag(current, TIF_SLD))
> -		split_lock_detect_set(true);
> +	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
> +		if (host_sld_enabled && unlikely(vmx->disable_split_lock_detect))
> +			split_lock_detect_set(true);
> +		else if (!host_sld_enabled && guest_sld_enabled)
> +			split_lock_detect_set(false);
> +	}
>   
>   	/* All fields are clean at this point */
>   	if (static_branch_unlikely(&enable_evmcs))
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 912eba66c5d5..c36c663f4bae 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -222,6 +222,7 @@ struct vcpu_vmx {
>   #endif
>   
>   	u64		      spec_ctrl;
> +	u64		      msr_test_ctrl;
>   	u32		      msr_ia32_umwait_control;
>   
>   	u32 secondary_exec_control;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a97a8f5dd1df..56e799981d53 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1163,7 +1163,7 @@ static const u32 msrs_to_save_all[] = {
>   #endif
>   	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
>   	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
> -	MSR_IA32_SPEC_CTRL,
> +	MSR_IA32_SPEC_CTRL, MSR_TEST_CTRL,
>   	MSR_IA32_RTIT_CTL, MSR_IA32_RTIT_STATUS, MSR_IA32_RTIT_CR3_MATCH,
>   	MSR_IA32_RTIT_OUTPUT_BASE, MSR_IA32_RTIT_OUTPUT_MASK,
>   	MSR_IA32_RTIT_ADDR0_A, MSR_IA32_RTIT_ADDR0_B,
> @@ -1345,7 +1345,12 @@ static u64 kvm_get_arch_capabilities(void)
>   
>   static u64 kvm_get_core_capabilities(void)
>   {
> -	return 0;
> +	u64 data = 0;
> +
> +	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) && !cpu_smt_possible())
> +		data |= MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT;
> +
> +	return data;
>   }
>   
>   static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
> @@ -5259,6 +5264,10 @@ static void kvm_init_msr_list(void)
>   		 * to the guests in some cases.
>   		 */
>   		switch (msrs_to_save_all[i]) {
> +		case MSR_TEST_CTRL:
> +			if (!(kvm_get_core_capabilities() &
> +			      MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT))
> +				continue;
			
sorry, forget	 	break;
>   		case MSR_IA32_BNDCFGS:
>   			if (!kvm_mpx_supported())
>   				continue;
> 

