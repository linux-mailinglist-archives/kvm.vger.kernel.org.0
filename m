Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB05D3D1C63
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 05:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhGVCop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 22:44:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:22794 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230026AbhGVCoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 22:44:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10052"; a="211558428"
X-IronPort-AV: E=Sophos;i="5.84,259,1620716400"; 
   d="scan'208";a="211558428"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 20:25:20 -0700
X-IronPort-AV: E=Sophos;i="5.84,259,1620716400"; 
   d="scan'208";a="501578591"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.110]) ([10.239.13.110])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 20:25:16 -0700
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
To:     pbonzini@redhat.com, seanjc@google.com,
        Andy Lutomirski <luto@kernel.org>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tao Xu <tao3.xu@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20210525051204.1480610-1-tao3.xu@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <dfff6606-6a38-42dc-0ac5-5483ac801f12@intel.com>
Date:   Thu, 22 Jul 2021 11:25:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210525051204.1480610-1-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/2021 1:12 PM, Tao Xu wrote:
> There are some cases that malicious virtual machines can cause CPU stuck
> (event windows don't open up), e.g., infinite loop in microcode when
> nested #AC (CVE-2015-5307). No event window obviously means no events,
> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
> hardware CPU can't be used by host or other VM.
> 
> To resolve those cases, it can enable a notify VM exit if no event
> window occur in VMX non-root mode for a specified amount of time
> (notify window). Since CPU is first observed the risk of not causing
> forward progress, after notify window time in a units of crystal clock,
> Notify VM exit will happen. Notify VM exit can happen incident to delivery
> of a vectored event.
> 
> Expose a module param for configuring notify window, which is in unit of
> crystal clock cycle.
> - A negative value (e.g. -1) is to disable this feature.
> - Make the default as 0. It is safe because an internal threshold is added
> to notify window to ensure all the normal instructions being coverd.

Paolo, Andy, and Sean,

Do you have any comment on this patch? Especially about making default 
notify_window as 0.

Thanks,
-Xiaoyao

> - User can set it to a large value when they want to give more cycles to
> wait for some reasons, e.g., silicon wrongly kill some normal instruction
> due to internal threshold is too small.
> 
> Notify VM exit is defined in latest Intel Architecture Instruction Set
> Extensions Programming Reference, chapter 9.2.
> 
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Tao Xu <tao3.xu@intel.com>
> ---
> 
> Changelog:
> v2:
>       Default set notify window to 0, less than 0 to disable.
>       Add more description in commit message.
> ---
>   arch/x86/include/asm/vmx.h         |  7 +++++
>   arch/x86/include/asm/vmxfeatures.h |  1 +
>   arch/x86/include/uapi/asm/vmx.h    |  4 ++-
>   arch/x86/kvm/vmx/capabilities.h    |  6 +++++
>   arch/x86/kvm/vmx/vmx.c             | 42 ++++++++++++++++++++++++++++--
>   include/uapi/linux/kvm.h           |  2 ++
>   6 files changed, 59 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0ffaa3156a4e..9104c85a973f 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -74,6 +74,7 @@
>   #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
>   #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
>   #define SECONDARY_EXEC_BUS_LOCK_DETECTION	VMCS_CONTROL_BIT(BUS_LOCK_DETECTION)
> +#define SECONDARY_EXEC_NOTIFY_VM_EXITING	VMCS_CONTROL_BIT(NOTIFY_VM_EXITING)
>   
>   #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
>   #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
> @@ -269,6 +270,7 @@ enum vmcs_field {
>   	SECONDARY_VM_EXEC_CONTROL       = 0x0000401e,
>   	PLE_GAP                         = 0x00004020,
>   	PLE_WINDOW                      = 0x00004022,
> +	NOTIFY_WINDOW                   = 0x00004024,
>   	VM_INSTRUCTION_ERROR            = 0x00004400,
>   	VM_EXIT_REASON                  = 0x00004402,
>   	VM_EXIT_INTR_INFO               = 0x00004404,
> @@ -555,6 +557,11 @@ enum vm_entry_failure_code {
>   #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
>   #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
>   
> +/*
> + * Exit Qualifications for NOTIFY VM EXIT
> + */
> +#define NOTIFY_VM_CONTEXT_INVALID     BIT(0)
> +
>   /*
>    * VM-instruction error numbers
>    */
> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
> index d9a74681a77d..15f0f2ab4f95 100644
> --- a/arch/x86/include/asm/vmxfeatures.h
> +++ b/arch/x86/include/asm/vmxfeatures.h
> @@ -84,5 +84,6 @@
>   #define VMX_FEATURE_USR_WAIT_PAUSE	( 2*32+ 26) /* Enable TPAUSE, UMONITOR, UMWAIT in guest */
>   #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
>   #define VMX_FEATURE_BUS_LOCK_DETECTION	( 2*32+ 30) /* "" VM-Exit when bus lock caused */
> +#define VMX_FEATURE_NOTIFY_VM_EXITING	( 2*32+ 31) /* VM-Exit when no event windows after notify window */
>   
>   #endif /* _ASM_X86_VMXFEATURES_H */
> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
> index 946d761adbd3..ef4c80f6553e 100644
> --- a/arch/x86/include/uapi/asm/vmx.h
> +++ b/arch/x86/include/uapi/asm/vmx.h
> @@ -91,6 +91,7 @@
>   #define EXIT_REASON_UMWAIT              67
>   #define EXIT_REASON_TPAUSE              68
>   #define EXIT_REASON_BUS_LOCK            74
> +#define EXIT_REASON_NOTIFY              75
>   
>   #define VMX_EXIT_REASONS \
>   	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
> @@ -153,7 +154,8 @@
>   	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
>   	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
>   	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
> -	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }
> +	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }, \
> +	{ EXIT_REASON_NOTIFY,                "NOTIFY"}
>   
>   #define VMX_EXIT_REASON_FLAGS \
>   	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 8dee8a5fbc17..8527f34a84ac 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -407,4 +407,10 @@ static inline u64 vmx_supported_debugctl(void)
>   	return debugctl;
>   }
>   
> +static inline bool cpu_has_notify_vm_exiting(void)
> +{
> +	return vmcs_config.cpu_based_2nd_exec_ctrl &
> +		SECONDARY_EXEC_NOTIFY_VM_EXITING;
> +}
> +
>   #endif /* __KVM_X86_VMX_CAPS_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4bceb5ca3a89..c0ad01c88dac 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -205,6 +205,10 @@ module_param(ple_window_max, uint, 0444);
>   int __read_mostly pt_mode = PT_MODE_SYSTEM;
>   module_param(pt_mode, int, S_IRUGO);
>   
> +/* Default is 0, less than 0 (for example, -1) disables notify window. */
> +static int __read_mostly notify_window;
> +module_param(notify_window, int, 0644);
> +
>   static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
>   static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
>   static DEFINE_MUTEX(vmx_l1d_flush_mutex);
> @@ -2539,7 +2543,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>   			SECONDARY_EXEC_PT_USE_GPA |
>   			SECONDARY_EXEC_PT_CONCEAL_VMX |
>   			SECONDARY_EXEC_ENABLE_VMFUNC |
> -			SECONDARY_EXEC_BUS_LOCK_DETECTION;
> +			SECONDARY_EXEC_BUS_LOCK_DETECTION |
> +			SECONDARY_EXEC_NOTIFY_VM_EXITING;
>   		if (cpu_has_sgx())
>   			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
>   		if (adjust_vmx_controls(min2, opt2,
> @@ -4376,6 +4381,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>   	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
>   		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
>   
> +	if (cpu_has_notify_vm_exiting() && notify_window < 0)
> +		exec_control &= ~SECONDARY_EXEC_NOTIFY_VM_EXITING;
> +
>   	vmx->secondary_exec_control = exec_control;
>   }
>   
> @@ -4423,6 +4431,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>   		vmx->ple_window_dirty = true;
>   	}
>   
> +	if (cpu_has_notify_vm_exiting() && notify_window >= 0)
> +		vmcs_write32(NOTIFY_WINDOW, notify_window);
> +
>   	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
>   	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
>   	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
> @@ -5642,6 +5653,31 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> +static int handle_notify(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
> +
> +	if (!(exit_qual & NOTIFY_VM_CONTEXT_INVALID)) {
> +		/*
> +		 * Notify VM exit happened while executing iret from NMI,
> +		 * "blocked by NMI" bit has to be set before next VM entry.
> +		 */
> +		if (enable_vnmi &&
> +		    (exit_qual & INTR_INFO_UNBLOCK_NMI))
> +			vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
> +				      GUEST_INTR_STATE_NMI);
> +
> +		return 1;
> +	}
> +
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_NO_EVENT_WINDOW;
> +	vcpu->run->internal.ndata = 1;
> +	vcpu->run->internal.data[0] = exit_qual;
> +
> +	return 0;
> +}
> +
>   /*
>    * The exit handlers return 1 if the exit was handled fully and guest execution
>    * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
> @@ -5699,6 +5735,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>   	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
>   	[EXIT_REASON_ENCLS]		      = handle_encls,
>   	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
> +	[EXIT_REASON_NOTIFY]		      = handle_notify,
>   };
>   
>   static const int kvm_vmx_max_exit_handlers =
> @@ -6042,7 +6079,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   	     exit_reason.basic != EXIT_REASON_EPT_VIOLATION &&
>   	     exit_reason.basic != EXIT_REASON_PML_FULL &&
>   	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
> -	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
> +	     exit_reason.basic != EXIT_REASON_TASK_SWITCH &&
> +	     exit_reason.basic != EXIT_REASON_NOTIFY)) {
>   		int ndata = 3;
>   
>   		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 3fd9a7e9d90c..bb3b49b1fb0d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -278,6 +278,8 @@ struct kvm_xen_exit {
>   #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
>   /* Encounter unexpected vm-exit reason */
>   #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
> +/* Encounter notify vm-exit */
> +#define KVM_INTERNAL_ERROR_NO_EVENT_WINDOW   5
>   
>   /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>   struct kvm_run {
> 

