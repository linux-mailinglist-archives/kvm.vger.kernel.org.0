Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387CC39868E
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 12:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhFBKdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 06:33:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232705AbhFBKdA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 06:33:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622629876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lLCAULJUh2+y/KoHdpXaKpPpvAXqXu6BEzWnpEYezMY=;
        b=RciP88gDAn4HtqI3u482JJip6adJZ/j083euxnvSHPibycMoW3v+rSbee9+voZLcMZk7L9
        rw8hYl+6yRMum4FBQGa0MP08th3VE7rGpfUJc3B2qJ0un/NAqnZygX+a8lKBy+DkCuyPRQ
        niqvTMoIBXKrdMfvrZF3T1qmUW+DBIE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-jgEPQNO3PtmtHgzHHw9jVQ-1; Wed, 02 Jun 2021 06:31:15 -0400
X-MC-Unique: jgEPQNO3PtmtHgzHHw9jVQ-1
Received: by mail-wr1-f71.google.com with SMTP id x10-20020adfc18a0000b029010d83c83f2aso824438wre.8
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 03:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=lLCAULJUh2+y/KoHdpXaKpPpvAXqXu6BEzWnpEYezMY=;
        b=cR6L1Hs1XXAJeuca8nmT6jUULZMZRb5BLX5M2YS/Lkc4klKhbtrYkxXA5etY4CAagl
         vRLgfatxzuq/Yoz/g/e8ieOKg3KQ1PUaX+nQO2lAcdQSucmPd+x6C998IBifZwEduOad
         on0dSLvY3W7o2xeADHEFbhNY3x2w9A6TtZs7ZtG/MO8mEwBGaQcWS3U/KVFKDlsapIoY
         SsLwdB1jvBBlZMGaj2TDrDEHdEV3fiVFDq4X4o7Ujp2vZWF5VmqC3tzOVy+Mz9TwyXpL
         Tx2n2gXO4Im1GcWsPnlygVNuHHCw9f7Mi8AmnOo9qpqckPT3vfCeG3pWpY3VwmccLaJ7
         T6cA==
X-Gm-Message-State: AOAM532TQyt5c+SLCn/xy+IDctQlEgDS43JwzcofZsCVFZ8zJmmPLmIV
        iyxWk1LQfYDBce+mr3v6ZTOrRv4V1e8scWa+Qt69DrcBTAzvDItHxr9pueAT+OQa4tdwqh4CIJs
        iyzR/ZMv2KyFZ
X-Received: by 2002:adf:f7d2:: with SMTP id a18mr17761325wrq.111.1622629873692;
        Wed, 02 Jun 2021 03:31:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/rFbcvr1WPs+b+ajnh1rirCyN4fJbN842qw9sPfHO4cViECkyJZYVRF6rc1VNkTY8fas1ZQ==
X-Received: by 2002:adf:f7d2:: with SMTP id a18mr17761295wrq.111.1622629873458;
        Wed, 02 Jun 2021 03:31:13 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o6sm6958378wre.73.2021.06.02.03.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 03:31:12 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tao Xu <tao3.xu@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tao Xu <tao3.xu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
In-Reply-To: <20210525051204.1480610-1-tao3.xu@intel.com>
References: <20210525051204.1480610-1-tao3.xu@intel.com>
Date:   Wed, 02 Jun 2021 12:31:11 +0200
Message-ID: <871r9k36ds.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tao Xu <tao3.xu@intel.com> writes:

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
>      Default set notify window to 0, less than 0 to disable.
>      Add more description in commit message.

Sorry if this was already discussed, but in case of nested
virtualization and when L1 also enables
SECONDARY_EXEC_NOTIFY_VM_EXITING, shouldn't we just reflect NOTIFY exits
during L2 execution to L1 instead of crashing the whole L1?

> ---
>  arch/x86/include/asm/vmx.h         |  7 +++++
>  arch/x86/include/asm/vmxfeatures.h |  1 +
>  arch/x86/include/uapi/asm/vmx.h    |  4 ++-
>  arch/x86/kvm/vmx/capabilities.h    |  6 +++++
>  arch/x86/kvm/vmx/vmx.c             | 42 ++++++++++++++++++++++++++++--
>  include/uapi/linux/kvm.h           |  2 ++
>  6 files changed, 59 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0ffaa3156a4e..9104c85a973f 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -74,6 +74,7 @@
>  #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
>  #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
>  #define SECONDARY_EXEC_BUS_LOCK_DETECTION	VMCS_CONTROL_BIT(BUS_LOCK_DETECTION)
> +#define SECONDARY_EXEC_NOTIFY_VM_EXITING	VMCS_CONTROL_BIT(NOTIFY_VM_EXITING)
>  
>  #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
>  #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
> @@ -269,6 +270,7 @@ enum vmcs_field {
>  	SECONDARY_VM_EXEC_CONTROL       = 0x0000401e,
>  	PLE_GAP                         = 0x00004020,
>  	PLE_WINDOW                      = 0x00004022,
> +	NOTIFY_WINDOW                   = 0x00004024,
>  	VM_INSTRUCTION_ERROR            = 0x00004400,
>  	VM_EXIT_REASON                  = 0x00004402,
>  	VM_EXIT_INTR_INFO               = 0x00004404,
> @@ -555,6 +557,11 @@ enum vm_entry_failure_code {
>  #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
>  #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
>  
> +/*
> + * Exit Qualifications for NOTIFY VM EXIT
> + */
> +#define NOTIFY_VM_CONTEXT_INVALID     BIT(0)
> +
>  /*
>   * VM-instruction error numbers
>   */
> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
> index d9a74681a77d..15f0f2ab4f95 100644
> --- a/arch/x86/include/asm/vmxfeatures.h
> +++ b/arch/x86/include/asm/vmxfeatures.h
> @@ -84,5 +84,6 @@
>  #define VMX_FEATURE_USR_WAIT_PAUSE	( 2*32+ 26) /* Enable TPAUSE, UMONITOR, UMWAIT in guest */
>  #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
>  #define VMX_FEATURE_BUS_LOCK_DETECTION	( 2*32+ 30) /* "" VM-Exit when bus lock caused */
> +#define VMX_FEATURE_NOTIFY_VM_EXITING	( 2*32+ 31) /* VM-Exit when no event windows after notify window */
>  
>  #endif /* _ASM_X86_VMXFEATURES_H */
> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
> index 946d761adbd3..ef4c80f6553e 100644
> --- a/arch/x86/include/uapi/asm/vmx.h
> +++ b/arch/x86/include/uapi/asm/vmx.h
> @@ -91,6 +91,7 @@
>  #define EXIT_REASON_UMWAIT              67
>  #define EXIT_REASON_TPAUSE              68
>  #define EXIT_REASON_BUS_LOCK            74
> +#define EXIT_REASON_NOTIFY              75
>  
>  #define VMX_EXIT_REASONS \
>  	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
> @@ -153,7 +154,8 @@
>  	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
>  	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
>  	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
> -	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }
> +	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }, \
> +	{ EXIT_REASON_NOTIFY,                "NOTIFY"}
>  
>  #define VMX_EXIT_REASON_FLAGS \
>  	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 8dee8a5fbc17..8527f34a84ac 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -407,4 +407,10 @@ static inline u64 vmx_supported_debugctl(void)
>  	return debugctl;
>  }
>  
> +static inline bool cpu_has_notify_vm_exiting(void)
> +{
> +	return vmcs_config.cpu_based_2nd_exec_ctrl &
> +		SECONDARY_EXEC_NOTIFY_VM_EXITING;
> +}
> +
>  #endif /* __KVM_X86_VMX_CAPS_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4bceb5ca3a89..c0ad01c88dac 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -205,6 +205,10 @@ module_param(ple_window_max, uint, 0444);
>  int __read_mostly pt_mode = PT_MODE_SYSTEM;
>  module_param(pt_mode, int, S_IRUGO);
>  
> +/* Default is 0, less than 0 (for example, -1) disables notify window. */
> +static int __read_mostly notify_window;
> +module_param(notify_window, int, 0644);
> +
>  static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
>  static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
>  static DEFINE_MUTEX(vmx_l1d_flush_mutex);
> @@ -2539,7 +2543,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  			SECONDARY_EXEC_PT_USE_GPA |
>  			SECONDARY_EXEC_PT_CONCEAL_VMX |
>  			SECONDARY_EXEC_ENABLE_VMFUNC |
> -			SECONDARY_EXEC_BUS_LOCK_DETECTION;
> +			SECONDARY_EXEC_BUS_LOCK_DETECTION |
> +			SECONDARY_EXEC_NOTIFY_VM_EXITING;
>  		if (cpu_has_sgx())
>  			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
>  		if (adjust_vmx_controls(min2, opt2,
> @@ -4376,6 +4381,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
>  		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
>  
> +	if (cpu_has_notify_vm_exiting() && notify_window < 0)
> +		exec_control &= ~SECONDARY_EXEC_NOTIFY_VM_EXITING;
> +
>  	vmx->secondary_exec_control = exec_control;
>  }
>  
> @@ -4423,6 +4431,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  		vmx->ple_window_dirty = true;
>  	}
>  
> +	if (cpu_has_notify_vm_exiting() && notify_window >= 0)
> +		vmcs_write32(NOTIFY_WINDOW, notify_window);
> +
>  	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
>  	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
>  	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
> @@ -5642,6 +5653,31 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
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
>  /*
>   * The exit handlers return 1 if the exit was handled fully and guest execution
>   * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
> @@ -5699,6 +5735,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
>  	[EXIT_REASON_ENCLS]		      = handle_encls,
>  	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
> +	[EXIT_REASON_NOTIFY]		      = handle_notify,
>  };
>  
>  static const int kvm_vmx_max_exit_handlers =
> @@ -6042,7 +6079,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	     exit_reason.basic != EXIT_REASON_EPT_VIOLATION &&
>  	     exit_reason.basic != EXIT_REASON_PML_FULL &&
>  	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
> -	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
> +	     exit_reason.basic != EXIT_REASON_TASK_SWITCH &&
> +	     exit_reason.basic != EXIT_REASON_NOTIFY)) {
>  		int ndata = 3;
>  
>  		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 3fd9a7e9d90c..bb3b49b1fb0d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -278,6 +278,8 @@ struct kvm_xen_exit {
>  #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
>  /* Encounter unexpected vm-exit reason */
>  #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
> +/* Encounter notify vm-exit */
> +#define KVM_INTERNAL_ERROR_NO_EVENT_WINDOW   5
>  
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {

-- 
Vitaly

