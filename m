Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AFE52965F
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 02:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbiEQA7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 20:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiEQA7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 20:59:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC7141996;
        Mon, 16 May 2022 17:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652749150; x=1684285150;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j7oxhWD8w1YWwyKHmzyw4+OpPHY902Uxh/5mMM9rBQw=;
  b=Q8F0qZmhVnc3+Idax6Oqdlh2X7ZUX+mazyBTw2QQF2QXmTBrVGrebiTp
   ARPePa9r2cbbsvI1FjsAPuLTfXGsaNNW0HLEipkHr9DdcOZDGfTNriq82
   PCGbQjv3zJ8YRCyWv1bI0aU1MC8av0sOgVWeSCjeKTTF4ZNhH+UU76LQR
   tIqPGavXbuGqKdcLJMsyvfEACveUxaSJnvNM7Bbj7JsJWWvSAOAP23DZs
   XCPADEpJUKUBprlsqgrH64r9CIPz0ouYiF7xB5vyFicVc5cOnoUfuyRwQ
   SAZGj5HkaMX9N2ewGeTkt4lrL+RGe4oB8OM/S375QdCH9vlE9XFfAPrYH
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="270952605"
X-IronPort-AV: E=Sophos;i="5.91,231,1647327600"; 
   d="scan'208";a="270952605"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 17:59:10 -0700
X-IronPort-AV: E=Sophos;i="5.91,231,1647327600"; 
   d="scan'208";a="596816373"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.249.173.102]) ([10.249.173.102])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 17:59:07 -0700
Message-ID: <e5025755-8104-3fb9-166a-559cdfa94af8@intel.com>
Date:   Tue, 17 May 2022 08:59:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [PATCH v6 3/3] KVM: VMX: Enable Notify VM exit
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220421072958.16375-1-chenyi.qiang@intel.com>
 <20220421072958.16375-4-chenyi.qiang@intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20220421072958.16375-4-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/21/2022 3:29 PM, Chenyi Qiang wrote:
> From: Tao Xu <tao3.xu@intel.com>
> 
> There are cases that malicious virtual machines can cause CPU stuck (due
> to event windows don't open up), e.g., infinite loop in microcode when
> nested #AC (CVE-2015-5307). No event window means no event (NMI, SMI and
> IRQ) can be delivered. It leads the CPU to be unavailable to host or
> other VMs.
> 
> VMM can enable notify VM exit that a VM exit generated if no event
> window occurs in VM non-root mode for a specified amount of time (notify
> window).
> 
> Feature enabling:
> - The new vmcs field SECONDARY_EXEC_NOTIFY_VM_EXITING is introduced to
>    enable this feature. VMM can set NOTIFY_WINDOW vmcs field to adjust
>    the expected notify window.
> - Add a new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT so that user space
>    can query and enable this feature in per-VM scope. The argument is a
>    64bit value: bits 63:32 are used for notify window, and bits 31:0 are
>    for flags. Current supported flags:
>    - KVM_X86_NOTIFY_VMEXIT_ENABLED: enable the feature with the notify
>      window provided.
>    - KVM_X86_NOTIFY_VMEXIT_USER: exit to userspace once the exits happen.
> - It's safe to even set notify window to zero since an internal hardware
>    threshold is added to vmcs.notify_window.
> 
> VM exit handling:
> - Introduce a vcpu state notify_window_exits to records the count of
>    notify VM exits and expose it through the debugfs.
> - Notify VM exit can happen incident to delivery of a vector event.
>    Allow it in KVM.
> - Exit to userspace unconditionally for handling when VM_CONTEXT_INVALID
>    bit is set.
> 
> Nested handling
> - Nested notify VM exits are not supported yet. Keep the same notify
>    window control in vmcs02 as vmcs01, so that L1 can't escape the
>    restriction of notify VM exits through launching L2 VM.
> - When L2 VM is context invalid and user space should synthesize a shutdown
>    event to a vcpu. KVM makes KVM_REQ_TRIPLE_FAULT request accordingly
>    and it would synthesize a nested triple fault exit to L1 hypervisor to
>    kill L2.
> 
> Notify VM exit is defined in latest Intel Architecture Instruction Set
> Extensions Programming Reference, chapter 9.2.
> 
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Tao Xu <tao3.xu@intel.com>
> Co-developed-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   Documentation/virt/kvm/api.rst     | 48 ++++++++++++++++++++++++++++++
>   arch/x86/include/asm/kvm_host.h    |  9 ++++++
>   arch/x86/include/asm/vmx.h         |  7 +++++
>   arch/x86/include/asm/vmxfeatures.h |  1 +
>   arch/x86/include/uapi/asm/vmx.h    |  4 ++-
>   arch/x86/kvm/vmx/capabilities.h    |  6 ++++
>   arch/x86/kvm/vmx/nested.c          |  8 +++++
>   arch/x86/kvm/vmx/vmx.c             | 48 ++++++++++++++++++++++++++++--
>   arch/x86/kvm/x86.c                 | 18 ++++++++++-
>   arch/x86/kvm/x86.h                 |  5 ++++
>   include/uapi/linux/kvm.h           | 10 +++++++
>   11 files changed, 159 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index e09ce3cb49c5..821ca979234d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6321,6 +6321,26 @@ array field represents return values. The userspace should update the return
>   values of SBI call before resuming the VCPU. For more details on RISC-V SBI
>   spec refer, https://github.com/riscv/riscv-sbi-doc.
>   
> +::
> +
> +    /* KVM_EXIT_NOTIFY */
> +    struct {
> +  #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
> +      __u32 flags;
> +    } notify;
> +
> +Used on x86 systems. When the VM capability KVM_CAP_X86_NOTIFY_VMEXIT is
> +enabled, a VM exit generated if no event window occurs in VM non-root mode
> +for a specified amount of time. Once KVM_X86_NOTIFY_VMEXIT_USER is set when
> +enabling the cap, it would exit to userspace with the exit reason
> +KVM_EXIT_NOTIFY for further handling. The "flags" field contains more
> +detailed info.
> +
> +The valid value for 'data' is:
> +
> +  - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
> +    in VMCS. It would run into unknown result if resume the target VM.
> +
>   ::
>   
>   		/* Fix the size of the union. */
> @@ -7266,6 +7286,34 @@ The valid bits in cap.args[0] are:
>                                       generate a #UD within the guest.
>   =================================== ============================================
>   
> +7.31 KVM_CAP_X86_NOTIFY_VMEXIT
> +------------------------------
> +
> +:Architectures: x86
> +:Target: VM
> +:Parameters: args[0] is the value of notify window as well as some flags
> +:Returns: 0 on success, -EINVAL if hardware doesn't support notify VM exit.
> +
> +Bits 63:32 of args[0] are used for notify window.
> +Bits 31:0 of args[0] are for some flags. Valid bits are::
> +
> +  #define KVM_X86_NOTIFY_VMEXIT_ENABLED    (1 << 0)
> +  #define KVM_X86_NOTIFY_VMEXIT_USER       (1 << 1)
> +
> +This capability allows userspace to configure the notify VM exit on/off
> +in per-VM scope during VM creation. Notify VM exit is disabled by default.
> +When userspace sets KVM_X86_NOTIFY_VMEXIT_ENABLED bit in args[0], VMM would
> +enable this feature with the notify window provided, which will generate
> +a VM exit if no event window occurs in VM non-root mode for a specified of
> +time (notify window).
> +
> +If KVM_X86_NOTIFY_VMEXIT_USER is set in args[0], upon notify VM exits happen,
> +KVM would exit to userspace for handling.
> +
> +This capability is aimed to mitigate the threat that malicious VMs can
> +cause CPU stuck (due to event windows don't open up) and make the CPU
> +unavailable to host or other VMs.
> +
>   8. Other capabilities.
>   ======================
>   
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c20f715f009..28a42658eec5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -65,6 +65,9 @@
>   #define KVM_BUS_LOCK_DETECTION_VALID_MODE	(KVM_BUS_LOCK_DETECTION_OFF | \
>   						 KVM_BUS_LOCK_DETECTION_EXIT)
>   
> +#define KVM_X86_NOTIFY_VMEXIT_VALID_BITS	(KVM_X86_NOTIFY_VMEXIT_ENABLED | \
> +						 KVM_X86_NOTIFY_VMEXIT_USER)
> +
>   /* x86-specific vcpu->requests bit members */
>   #define KVM_REQ_MIGRATE_TIMER		KVM_ARCH_REQ(0)
>   #define KVM_REQ_REPORT_TPR_ACCESS	KVM_ARCH_REQ(1)
> @@ -1157,6 +1160,9 @@ struct kvm_arch {
>   
>   	bool bus_lock_detection_enabled;
>   	bool enable_pmu;
> +
> +	u32 notify_window;
> +	u32 notify_vmexit_flags;
>   	/*
>   	 * If exit_on_emulation_error is set, and the in-kernel instruction
>   	 * emulator fails to emulate an instruction, allow userspace
> @@ -1293,6 +1299,7 @@ struct kvm_vcpu_stat {
>   	u64 directed_yield_attempted;
>   	u64 directed_yield_successful;
>   	u64 guest_mode;
> +	u64 notify_window_exits;
>   };
>   
>   struct x86_instruction_info;
> @@ -1504,6 +1511,8 @@ struct kvm_x86_ops {
>   	 * Returns vCPU specific APICv inhibit reasons
>   	 */
>   	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
> +
> +	bool has_notify_vmexit;
>   };
>   
>   struct kvm_x86_nested_ops {
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 6c343c6a1855..2aa266007873 100644
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
> @@ -553,6 +555,11 @@ enum vm_entry_failure_code {
>   #define EPT_VIOLATION_GVA_IS_VALID	(1 << EPT_VIOLATION_GVA_IS_VALID_BIT)
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
> index 946d761adbd3..a5faf6d88f1b 100644
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
> +	{ EXIT_REASON_NOTIFY,                "NOTIFY" }
>   
>   #define VMX_EXIT_REASON_FLAGS \
>   	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 3f430e218375..0102a6e8a194 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -417,4 +417,10 @@ static inline u64 vmx_supported_debugctl(void)
>   	return debugctl;
>   }
>   
> +static inline bool cpu_has_notify_vmexit(void)
> +{
> +	return vmcs_config.cpu_based_2nd_exec_ctrl &
> +		SECONDARY_EXEC_NOTIFY_VM_EXITING;
> +}
> +
>   #endif /* __KVM_X86_VMX_CAPS_H */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index a6688663da4d..5f74aae96031 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2133,6 +2133,8 @@ static u64 nested_vmx_calc_efer(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>   
>   static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
>   {
> +	struct kvm *kvm = vmx->vcpu.kvm;
> +
>   	/*
>   	 * If vmcs02 hasn't been initialized, set the constant vmcs02 state
>   	 * according to L0's settings (vmcs12 is irrelevant here).  Host
> @@ -2175,6 +2177,9 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
>   	if (cpu_has_vmx_encls_vmexit())
>   		vmcs_write64(ENCLS_EXITING_BITMAP, INVALID_GPA);
>   
> +	if (kvm_notify_vmexit_enabled(kvm))
> +		vmcs_write32(NOTIFY_WINDOW, kvm->arch.notify_window);
> +
>   	/*
>   	 * Set the MSR load/store lists to match L0's settings.  Only the
>   	 * addresses are constant (for vmcs02), the counts can change based
> @@ -6107,6 +6112,9 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
>   			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
>   	case EXIT_REASON_ENCLS:
>   		return nested_vmx_exit_handled_encls(vcpu, vmcs12);
> +	case EXIT_REASON_NOTIFY:
> +		/* Notify VM exit is not exposed to L1 */
> +		return false;
>   	default:
>   		return true;
>   	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cf8581978bce..4ecfca00ff9e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2472,7 +2472,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>   			SECONDARY_EXEC_PT_USE_GPA |
>   			SECONDARY_EXEC_PT_CONCEAL_VMX |
>   			SECONDARY_EXEC_ENABLE_VMFUNC |
> -			SECONDARY_EXEC_BUS_LOCK_DETECTION;
> +			SECONDARY_EXEC_BUS_LOCK_DETECTION |
> +			SECONDARY_EXEC_NOTIFY_VM_EXITING;
>   		if (cpu_has_sgx())
>   			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
>   		if (adjust_vmx_controls(min2, opt2,
> @@ -4357,6 +4358,9 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>   	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
>   		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
>   
> +	if (!kvm_notify_vmexit_enabled(vcpu->kvm))
> +		exec_control &= ~SECONDARY_EXEC_NOTIFY_VM_EXITING;
> +
>   	return exec_control;
>   }
>   
> @@ -4364,6 +4368,8 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>   
>   static void init_vmcs(struct vcpu_vmx *vmx)
>   {
> +	struct kvm *kvm = vmx->vcpu.kvm;
> +
>   	if (nested)
>   		nested_vmx_set_vmcs_shadowing_bitmap();
>   
> @@ -4392,12 +4398,15 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>   		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
>   	}
>   
> -	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
> +	if (!kvm_pause_in_guest(kvm)) {
>   		vmcs_write32(PLE_GAP, ple_gap);
>   		vmx->ple_window = ple_window;
>   		vmx->ple_window_dirty = true;
>   	}
>   
> +	if (kvm_notify_vmexit_enabled(kvm))
> +		vmcs_write32(NOTIFY_WINDOW, kvm->arch.notify_window);
> +
>   	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
>   	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
>   	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
> @@ -5684,6 +5693,32 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
>   	return 1;
>   }
>   
> +static int handle_notify(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
> +	bool context_invalid = exit_qual & NOTIFY_VM_CONTEXT_INVALID;
> +
> +	++vcpu->stat.notify_window_exits;
> +
> +	/*
> +	 * Notify VM exit happened while executing iret from NMI,
> +	 * "blocked by NMI" bit has to be set before next VM entry.
> +	 */
> +	if (enable_vnmi && (exit_qual & INTR_INFO_UNBLOCK_NMI))
> +		vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
> +			      GUEST_INTR_STATE_NMI);
> +
> +	if (vcpu->kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_USER ||
> +	    context_invalid) {
> +		vcpu->run->exit_reason = KVM_EXIT_NOTIFY;
> +		vcpu->run->notify.flags = context_invalid ?
> +					  KVM_NOTIFY_CONTEXT_INVALID : 0;
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
>   /*
>    * The exit handlers return 1 if the exit was handled fully and guest execution
>    * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
> @@ -5741,6 +5776,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>   	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
>   	[EXIT_REASON_ENCLS]		      = handle_encls,
>   	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
> +	[EXIT_REASON_NOTIFY]		      = handle_notify,
>   };
>   
>   static const int kvm_vmx_max_exit_handlers =
> @@ -6105,7 +6141,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   	     exit_reason.basic != EXIT_REASON_EPT_VIOLATION &&
>   	     exit_reason.basic != EXIT_REASON_PML_FULL &&
>   	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
> -	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
> +	     exit_reason.basic != EXIT_REASON_TASK_SWITCH &&
> +	     exit_reason.basic != EXIT_REASON_NOTIFY)) {
>   		int ndata = 3;
>   
>   		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> @@ -7841,6 +7878,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>   	.complete_emulated_msr = kvm_complete_insn_gp,
>   
>   	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> +
> +	.has_notify_vmexit = false,
>   };
>   
>   static unsigned int vmx_handle_intel_pt_intr(void)
> @@ -7979,6 +8018,9 @@ static __init int hardware_setup(void)
>   	kvm_tsc_scaling_ratio_frac_bits = 48;
>   	kvm_has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
>   
> +	if (cpu_has_notify_vmexit())
> +		vmx_x86_ops.has_notify_vmexit = true;
> +
>   	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
>   
>   	if (enable_ept)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c8b9b0bc42aa..ad8a05349614 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -291,7 +291,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>   	STATS_DESC_COUNTER(VCPU, nested_run),
>   	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
>   	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
> -	STATS_DESC_ICOUNTER(VCPU, guest_mode)
> +	STATS_DESC_ICOUNTER(VCPU, guest_mode),
> +	STATS_DESC_COUNTER(VCPU, notify_window_exits),
>   };
>   
>   const struct kvm_stats_header kvm_vcpu_stats_header = {
> @@ -4389,6 +4390,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_DISABLE_QUIRKS2:
>   		r = KVM_X86_VALID_QUIRKS;
>   		break;
> +	case KVM_CAP_X86_NOTIFY_VMEXIT:
> +		r = kvm_x86_ops.has_notify_vmexit;
> +		break;
>   	default:
>   		break;
>   	}
> @@ -6090,6 +6094,18 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		}
>   		mutex_unlock(&kvm->lock);
>   		break;
> +	case KVM_CAP_X86_NOTIFY_VMEXIT:
> +		r = -EINVAL;
> +		if ((u32)cap->args[0] & ~KVM_X86_NOTIFY_VMEXIT_VALID_BITS)
> +			break;
> +		if (!kvm_x86_ops.has_notify_vmexit)
> +			break;
> +		if (!(u32)cap->args[0] & KVM_X86_NOTIFY_VMEXIT_ENABLED)

Miss the parentheses here, should be !((u32)cap->args[0] & 
KVM_X86_NOTIFY_VMEXIT_ENABLED)

> +			break;
> +		kvm->arch.notify_window = cap->args[0] >> 32;
> +		kvm->arch.notify_vmexit_flags = (u32)cap->args[0];
> +		r = 0;
> +		break;
>   	default:
>   		r = -EINVAL;
>   		break;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 588792f00334..6e1e2159cbd4 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -344,6 +344,11 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
>   	return kvm->arch.cstate_in_guest;
>   }
>   
> +static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
> +{
> +	return kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_ENABLED;
> +}
> +
>   enum kvm_intr_type {
>   	/* Values are arbitrary, but must be non-zero. */
>   	KVM_HANDLING_IRQ = 1,
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dd1d8167e71f..86f1ca9c1514 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -270,6 +270,7 @@ struct kvm_xen_exit {
>   #define KVM_EXIT_X86_BUS_LOCK     33
>   #define KVM_EXIT_XEN              34
>   #define KVM_EXIT_RISCV_SBI        35
> +#define KVM_EXIT_NOTIFY           36
>   
>   /* For KVM_EXIT_INTERNAL_ERROR */
>   /* Emulate instruction failed. */
> @@ -490,6 +491,11 @@ struct kvm_run {
>   			unsigned long args[6];
>   			unsigned long ret[2];
>   		} riscv_sbi;
> +		/* KVM_EXIT_NOTIFY */
> +		struct {
> +#define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
> +			__u32 flags;
> +		} notify;
>   		/* Fix the size of the union. */
>   		char padding[256];
>   	};
> @@ -1148,6 +1154,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_PMU_CAPABILITY 212
>   #define KVM_CAP_DISABLE_QUIRKS2 213
>   #define KVM_CAP_VM_TSC_CONTROL 214
> +#define KVM_CAP_X86_NOTIFY_VMEXIT 215
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> @@ -2109,4 +2116,7 @@ struct kvm_stats_desc {
>   /* Available with KVM_CAP_XSAVE2 */
>   #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
>   
> +#define KVM_X86_NOTIFY_VMEXIT_ENABLED		(1ULL << 0)
> +#define KVM_X86_NOTIFY_VMEXIT_USER		(1ULL << 1)
> +
>   #endif /* __LINUX_KVM_H */
