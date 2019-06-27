Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E235796F
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 04:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfF0CYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 22:24:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:34573 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfF0CYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 22:24:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 19:24:37 -0700
X-IronPort-AV: E=Sophos;i="5.63,422,1557212400"; 
   d="scan'208";a="156077730"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 26 Jun 2019 19:24:33 -0700
Subject: Re: [PATCH v9 11/17] kvm/vmx: Emulate MSR TEST_CTL
To:     Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        kvm@vger.kernel.org
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-12-git-send-email-fenghua.yu@intel.com>
From:   Xiaoyao Li <xiaoyao.li@linux.intel.com>
Message-ID: <b52b0f72-e242-68b1-640c-85759bdce869@linux.intel.com>
Date:   Thu, 27 Jun 2019 10:24:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1560897679-228028-12-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo & tglx,

Do you have any comments on this one as the policy of how to expose 
split lock detection (emulate TEST_CTL) for guest changed.

This patch makes the implementation as below:

Host	|Guest	|Actual value in guest	|split lock happen in guest
------------------------------------------------------------------
on	|off	|	on		|report #AC to userspace
	|on	|	on		|inject #AC back to guest
------------------------------------------------------------------
off	|off	|	off		|No #AC
	|on	|	on		|inject #AC back to guest

In case 2, when split lock detection of both host and guest on, if there 
is a split lock is guest, it will inject #AC back to userspace. Then if 
#AC is from guest userspace apps, guest kernel sends SIGBUS to userspace 
apps instead of whole guest killed by host. If #AC is from guest kernel, 
guest kernel may clear it's split lock bit in test_ctl msr and 
re-execute the instruction, then it goes into case 1, the #AC will 
report to host userspace, e.g., QEMU.

On 6/19/2019 6:41 AM, Fenghua Yu wrote:
> From: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> 
> A control bit (bit 29) in TEST_CTL MSR 0x33 will be introduced in
> future x86 processors. When bit 29 is set, the processor causes #AC
> exception for split locked accesses at all CPL.
> 
> Please check the latest Intel 64 and IA-32 Architectures Software
> Developer's Manual for more detailed information on the MSR and
> the split lock bit.
> 
> This patch emulates MSR_TEST_CTL with vmx->msr_test_ctl and does the
> following:
> 1. As MSR TEST_CTL of guest is emulated, enable the related bit
> in CORE_CAPABILITY to correctly report this feature to guest.
> 
> 2. If host has split lock detection enabled, forcing it enabled in
> guest to avoid guest's slowdown attack by using split lock.
> If host has it disabled, it can give control to guest that guest can
> enable it on its own purpose.
> 
> Note: Guest can read and write bit 29 of MSR_TEST_CTL if hardware has
> feature split lock detection. But when guest running, the real value in
> hardware MSR will be different from the value read in guest when guest
> has it disabled and host has it enabled. It can be regarded as host's
> value overrides guest's value.
> 
> To avoid costly RDMSR of TEST_CTL when switching between host and guest
> during vmentry, read per CPU variable msr_test_ctl_cached which caches
> the MSR value.
> 
> Besides, only inject #AC exception back when guest can handle it.
> Otherwise, it must be a split lock caused #AC. In this case, print a hint.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 92 ++++++++++++++++++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/vmx.h |  2 +
>   arch/x86/kvm/x86.c     | 19 ++++++++-
>   3 files changed, 109 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b93e36ddee5e..d096cee48a40 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1640,6 +1640,16 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
>   	return !(val & ~valid_bits);
>   }
>   
> +static u64 vmx_get_msr_test_ctl_mask(struct kvm_vcpu *vcpu)
> +{
> +	u64 mask = 0;
> +
> +	if (vcpu->arch.core_capability & MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT)
> +		mask |= MSR_TEST_CTL_SPLIT_LOCK_DETECT;
> +
> +	return mask;
> +}
> +
>   static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>   {
>   	switch (msr->index) {
> @@ -1666,6 +1676,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	u32 index;
>   
>   	switch (msr_info->index) {
> +	case MSR_TEST_CTL:
> +		if (!vmx->msr_test_ctl_mask)
> +			return 1;
> +		msr_info->data = vmx->msr_test_ctl;
> +		break;
>   #ifdef CONFIG_X86_64
>   	case MSR_FS_BASE:
>   		msr_info->data = vmcs_readl(GUEST_FS_BASE);
> @@ -1803,6 +1818,18 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	u32 index;
>   
>   	switch (msr_index) {
> +	case MSR_TEST_CTL:
> +		if (!vmx->msr_test_ctl_mask ||
> +		    (data & vmx->msr_test_ctl_mask) != data)
> +			return 1;
> +		vmx->msr_test_ctl = data;
> +		break;
> +	case MSR_IA32_CORE_CAP:
> +		if (!msr_info->host_initiated)
> +			return 1;
> +		vcpu->arch.core_capability = data;
> +		vmx->msr_test_ctl_mask = vmx_get_msr_test_ctl_mask(vcpu);
> +		break;
>   	case MSR_EFER:
>   		ret = kvm_set_msr_common(vcpu, msr_info);
>   		break;
> @@ -4121,6 +4148,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   
>   	vmx->rmode.vm86_active = 0;
>   	vmx->spec_ctrl = 0;
> +	vmx->msr_test_ctl = 0;
> +	vmx->msr_test_ctl_mask = vmx_get_msr_test_ctl_mask(vcpu);
>   
>   	vcpu->arch.microcode_version = 0x100000000ULL;
>   	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
> @@ -4449,6 +4478,28 @@ static int handle_machine_check(struct kvm_vcpu *vcpu)
>   	return 1;
>   }
>   
> +/*
> + * In intel SDM, #AC can be caused in two way:
> + *	1. Unaligned memory access when CPL = 3 && CR0.AM == 1 && EFLAGS.AC == 1
> + *	2. Lock on crossing cache line memory access, when split lock detection
> + *	   is enabled (bit 29 of MSR_TEST_CTL is set). This #AC can be generated
> + *	   in any CPL.
> + *
> + * So, when guest's split lock detection is enabled, it can be assumed capable
> + * of handling #AC in any CPL.
> + * Or when guest's CR0.AM and EFLAGS.AC are both set, it can be assumed capable
> + * of handling #AC in CPL == 3.
> + */
> +static bool guest_can_handle_ac(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	return (vmx->msr_test_ctl & MSR_TEST_CTL_SPLIT_LOCK_DETECT) ||
> +	       ((vmx_get_cpl(vcpu) == 3) &&
> +		kvm_read_cr0_bits(vcpu, X86_CR0_AM) &&
> +		(kvm_get_rflags(vcpu) & X86_EFLAGS_AC));
> +}
> +
>   static int handle_exception(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -4514,9 +4565,6 @@ static int handle_exception(struct kvm_vcpu *vcpu)
>   		return handle_rmode_exception(vcpu, ex_no, error_code);
>   
>   	switch (ex_no) {
> -	case AC_VECTOR:
> -		kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
> -		return 1;
>   	case DB_VECTOR:
>   		dr6 = vmcs_readl(EXIT_QUALIFICATION);
>   		if (!(vcpu->guest_debug &
> @@ -4545,6 +4593,15 @@ static int handle_exception(struct kvm_vcpu *vcpu)
>   		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
>   		kvm_run->debug.arch.exception = ex_no;
>   		break;
> +	case AC_VECTOR:
> +		if (guest_can_handle_ac(vcpu)) {
> +			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
> +			return 1;
> +		}
> +		pr_warn("kvm: %s[%d]: there is an #AC exception in guest due to split lock. "
> +			"Please try to fix it, or disable the split lock detection in host to workaround.",
> +			current->comm, current->pid);
> +		/* fall through */
>   	default:
>   		kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
>   		kvm_run->ex.exception = ex_no;
> @@ -6335,6 +6392,33 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>   					msrs[i].host, false);
>   }
>   
> +static void atomic_switch_msr_test_ctl(struct vcpu_vmx *vmx)
> +{
> +	u64 guest_val;
> +	u64 host_val = this_cpu_read(msr_test_ctl_cached);
> +	u64 mask = vmx->msr_test_ctl_mask;
> +
> +	/*
> +	 * Guest can cause overall system performance degradation (of host or
> +	 * other guest) by using split lock. Hence, it takes following policy:
> +	 *  - If host has split lock detection enabled, forcing it enabled in
> +	 *    guest during vm entry.
> +	 *  - If host has split lock detection disabled, guest can enable it for
> +	 *    it's own purpose that it will load guest's value during vm entry.
> +	 *
> +	 * So use adjusted mask to achieve this.
> +	 */
> +	if (host_val & MSR_TEST_CTL_SPLIT_LOCK_DETECT)
> +		mask &= ~MSR_TEST_CTL_SPLIT_LOCK_DETECT;
> +
> +	guest_val = (host_val & ~mask) | (vmx->msr_test_ctl & mask);
> +
> +	if (host_val == guest_val)
> +		clear_atomic_switch_msr(vmx, MSR_TEST_CTL);
> +	else
> +		add_atomic_switch_msr(vmx, MSR_TEST_CTL, guest_val, host_val, false);
> +}
> +
>   static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
>   {
>   	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
> @@ -6443,6 +6527,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	atomic_switch_perf_msrs(vmx);
>   
> +	atomic_switch_msr_test_ctl(vmx);
> +
>   	vmx_update_hv_timer(vcpu);
>   
>   	/*
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 61128b48c503..2a54b0b5741e 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -193,6 +193,8 @@ struct vcpu_vmx {
>   	u64		      msr_guest_kernel_gs_base;
>   #endif
>   
> +	u64		      msr_test_ctl;
> +	u64		      msr_test_ctl_mask;
>   	u64		      spec_ctrl;
>   
>   	u32 vm_entry_controls_shadow;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index dc4c72bd6781..741ad4e61386 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1238,7 +1238,24 @@ EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
>   
>   static u64 kvm_get_core_capability(void)
>   {
> -	return 0;
> +	u64 data = 0;
> +
> +	if (boot_cpu_has(X86_FEATURE_CORE_CAPABILITY)) {
> +		rdmsrl(MSR_IA32_CORE_CAP, data);
> +
> +		/* mask non-virtualizable functions */
> +		data &= MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT;
> +	} else if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
> +		/*
> +		 * There will be a list of FMS values that have split lock
> +		 * detection but lack the CORE CAPABILITY MSR. In this case,
> +		 * set MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT since we emulate
> +		 * MSR CORE_CAPABILITY.
> +		 */
> +		data |= MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT;
> +	}
> +
> +	return data;
>   }
>   
>   static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
> 
