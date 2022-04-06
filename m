Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE304F5521
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573927AbiDFFal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2361239AbiDFEZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 00:25:42 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFAA386
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 17:34:57 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o10so562075ple.7
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 17:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iuGOM9FXzoou8j7Uj97o48Zv3qnvpRh8FisRU39YgPs=;
        b=FbZ/9W90LMpEHVvnfKly+G8F5AOYUXVctFDscc/moU7Nl0yAJb0j4L77vCp9T3rQu9
         MCdNqmieQGo16zqOhA4qYGQ0W5lslvHOGJ7ChztotsO9V2Uq/gD7oRPIQnTFjANHUo66
         GGM+BOhpJNyzckBIZvEm5xkqU9fGbbQBzNWpQK1QqN3yqxXyFXQm8fzm77itzTdybg8n
         qHRRvTeYX1tXOBCtyn3C29kswXRxbIn4jrIKLCAlVk0MgecdlIyaQy1N/SFoc1gOJ/ql
         8tNGAwvYMU8jb0HeQ2BzJ+84Q+oz5Rt/AT5QL1UCGSnScy83yHipf9SO7TwuI+bGXweJ
         K5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iuGOM9FXzoou8j7Uj97o48Zv3qnvpRh8FisRU39YgPs=;
        b=f+ZWqAxUtHgidz1ote0QA4YbuCjJe5N8kuPWwCj6JiFfXnpBxlo/fHJAVyROED/1r2
         3LuCyiKoYCQdfJ608kBfss35JCzgx1mu7FhLb+8OiSVzxYhKKeJ89Bo0fqefurf6Y4oJ
         1idRsS6rSeyRJq7Iuzzp0nwrJPDSRjhPYbIsH6Uc0BnBhLB0Wz02AYEdXB3SnpGXmbnP
         JHFjfjeMID+YraKpmyoAVtBEL4UwWD8g36a+itp2FzCah/ny8khVQk2NA2t8/lyCLy0A
         uRKT8PCq1QjQi4yiD1gRPBClHgcqQNV722pC/sruK8wnmdl/clcK5cf7YmoGj2K9rcX6
         dylg==
X-Gm-Message-State: AOAM53222WFGmX6NOd5a2zFXYeaDMvmH2F1gHW7hh35codbkESgTHTSj
        RlQjiWtNaZ3OjPavStFJP8IiBw==
X-Google-Smtp-Source: ABdhPJze44AH7epP3Q2O4AC3dOFP4uiiBVHnCXGcOdFacgdZHUxTLtkES0cdZbppnumehXyxIBQu5Q==
X-Received: by 2002:a17:903:1252:b0:154:ca85:59a0 with SMTP id u18-20020a170903125200b00154ca8559a0mr6193278plh.169.1649205296730;
        Tue, 05 Apr 2022 17:34:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x18-20020a63b212000000b00398f0e07c91sm11484323pge.29.2022.04.05.17.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 17:34:55 -0700 (PDT)
Date:   Wed, 6 Apr 2022 00:34:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tao Xu <tao3.xu@intel.com>
Subject: Re: [PATCH v5 2/3] KVM: VMX: Enable Notify VM exit
Message-ID: <YkzgLGlCAG2ZwgqS@google.com>
References: <20220318074955.22428-1-chenyi.qiang@intel.com>
 <20220318074955.22428-3-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318074955.22428-3-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 18, 2022, Chenyi Qiang wrote:
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

Uber nit, needs a space before the closing curly brace.

>  #define VMX_EXIT_REASON_FLAGS \
>  	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 3f430e218375..0102a6e8a194 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -417,4 +417,10 @@ static inline u64 vmx_supported_debugctl(void)
>  	return debugctl;
>  }
>  
> +static inline bool cpu_has_notify_vmexit(void)
> +{
> +	return vmcs_config.cpu_based_2nd_exec_ctrl &
> +		SECONDARY_EXEC_NOTIFY_VM_EXITING;
> +}
> +
>  #endif /* __KVM_X86_VMX_CAPS_H */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f18744f7ff82..1bcf086d2ed4 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2134,6 +2134,8 @@ static u64 nested_vmx_calc_efer(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  
>  static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
>  {
> +	struct kvm *kvm = vmx->vcpu.kvm;
> +
>  	/*
>  	 * If vmcs02 hasn't been initialized, set the constant vmcs02 state
>  	 * according to L0's settings (vmcs12 is irrelevant here).  Host
> @@ -2176,6 +2178,9 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
>  	if (cpu_has_vmx_encls_vmexit())
>  		vmcs_write64(ENCLS_EXITING_BITMAP, INVALID_GPA);
>  
> +	if (kvm_notify_vmexit_enabled(kvm))
> +		vmcs_write32(NOTIFY_WINDOW, kvm->arch.notify_window);
> +
>  	/*
>  	 * Set the MSR load/store lists to match L0's settings.  Only the
>  	 * addresses are constant (for vmcs02), the counts can change based
> @@ -4218,8 +4223,15 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  		/*
>  		 * Transfer the event that L0 or L1 may wanted to inject into
>  		 * L2 to IDT_VECTORING_INFO_FIELD.
> +		 *
> +		 * Skip this if the exit is due to a NOTIFY_VM_CONTEXT_INVALID
> +		 * exit; in that case, L0 will synthesize a nested TRIPLE_FAULT
> +		 * vmexit to kill L2.  No IDT vectoring info is recorded for
> +		 * triple faults, and __vmx_handle_exit does not expect it.
>  		 */
> -		vmcs12_save_pending_event(vcpu, vmcs12);
> +		if (!(to_vmx(vcpu)->exit_reason.basic == EXIT_REASON_NOTIFY) &&
> +		    kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu))
> +			vmcs12_save_pending_event(vcpu, vmcs12);

Unless I'm misreading the parantheses, this is saving pending events if and only
if there's a pending triple fault.  LOL, looks like you copy+pasted verbatim from
Paolo.  https://lkml.kernel.org/r/c7681cf8-7b99-eb43-0195-d35adb011f21@redhat.com

Checking KVM_REQ_TRIPLE_FAULT is also flawed, KVM should never actually reach
this point with the triple fault pending (see my response to patch 1).

Explicitly checking for EXIT_REASON_TRIPLE_FAULT is more correct, but that's still
flawed as the VMCS needs to be explicitly written with zeros (well, bit 31 needs
to be cleared), i.e. this check needs to be moved inside vmcs12_save_pending_event().
Ha, and I think skipping this path on VMX_EXIT_REASONS_FAILED_VMENTRY is also
technically wrong.  That's still a VM-Exit, I'm pretty sure failed VM-Entry only
skips the MSR load/store list processing (because the load lists on VM-Entry are
processed after the final consistency checks).

Lastly, this flaw is orthogonal to NOTIFY support, e.g. I'm guessing the MCE
shenanigans plus KVM_SET_VCPU_EVENTS can force this scenario.  I.e. this needs to
be fixed in a separate patch.

All in all, I think doing the below across two patches would be do the trick.
I'll throw this into a small series along with the fix for the theoretical WARN
bugs in the forced exit paths.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f18744f7ff82..7e24bf7800fa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3695,12 +3695,16 @@ vmcs12_guest_cr4(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 }

 static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
-                                     struct vmcs12 *vmcs12)
+                                     struct vmcs12 *vmcs12,
+                                     u32 vm_exit_reason)
 {
        u32 idt_vectoring;
        unsigned int nr;

-       if (vcpu->arch.exception.injected) {
+       if ((vm_exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) ||
+           vm_exit_reason == EXIT_REASON_TRIPLE_FAULT) {
+               vmcs12->idt_vectoring_info_field = 0;
+       } else if (vcpu->arch.exception.injected) {
                nr = vcpu->arch.exception.nr;
                idt_vectoring = nr | VECTORING_INFO_VALID_MASK;

@@ -4215,12 +4219,6 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
                 * instead of reading the real value. */
                vmcs12->vm_entry_intr_info_field &= ~INTR_INFO_VALID_MASK;

-               /*
-                * Transfer the event that L0 or L1 may wanted to inject into
-                * L2 to IDT_VECTORING_INFO_FIELD.
-                */
-               vmcs12_save_pending_event(vcpu, vmcs12);
-
                /*
                 * According to spec, there's no need to store the guest's
                 * MSRs if the exit is due to a VM-entry failure that occurs
@@ -4234,6 +4232,12 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
                                         VMX_ABORT_SAVE_GUEST_MSR_FAIL);
        }

+       /*
+        * Transfer the event that L0 or L1 may wanted to inject into L2 to
+        * IDT_VECTORING_INFO_FIELD.
+        */
+       vmcs12_save_pending_event(vcpu, vmcs12, vm_exit_reason);
+
        /*
         * Drop what we picked up for L2 via vmx_complete_interrupts. It is
         * preserved above and would only end up incorrectly in L1.

>  		/*
>  		 * According to spec, there's no need to store the guest's
> @@ -6085,6 +6097,9 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
>  			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
>  	case EXIT_REASON_ENCLS:
>  		return nested_vmx_exit_handled_encls(vcpu, vmcs12);
> +	case EXIT_REASON_NOTIFY:
> +		/* Notify VM exit is not exposed to L1 */
> +		return false;
>  	default:
>  		return true;
>  	}

...

> @@ -5691,6 +5700,32 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static int handle_notify(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
> +
> +	++vcpu->stat.notify_window_exits;
> +	pr_warn_ratelimited("Notify window exits at address: 0x%lx\n",
> +			    kvm_rip_read(vcpu));

Gah, I'm pretty sure you added this printk at my suggestion[*].  That was a bad
suggestion, the host won't have any idea what that RIP means, and getting the info
to the right people/entity would be difficult, especially since it's ratelimited.

Unless someone objects, please drop the printk (I still like the stat though!)
Sorry for the churn :-(

[*] https://lkml.kernel.org/r/YQRkBI9RFf6lbifZ@google.com

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
> +	vcpu->run->exit_reason = KVM_EXIT_NOTIFY;
> +	vcpu->run->notify.data |= KVM_NOTIFY_CONTEXT_INVALID;
> +	return 0;
> +}
> +
>  /*
>   * The exit handlers return 1 if the exit was handled fully and guest execution
>   * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
> @@ -5748,6 +5783,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
>  	[EXIT_REASON_ENCLS]		      = handle_encls,
>  	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
> +	[EXIT_REASON_NOTIFY]		      = handle_notify,
>  };
>  
>  static const int kvm_vmx_max_exit_handlers =
> @@ -6112,7 +6148,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	     exit_reason.basic != EXIT_REASON_EPT_VIOLATION &&
>  	     exit_reason.basic != EXIT_REASON_PML_FULL &&
>  	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
> -	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
> +	     exit_reason.basic != EXIT_REASON_TASK_SWITCH &&
> +	     exit_reason.basic != EXIT_REASON_NOTIFY)) {
>  		int ndata = 3;
>  
>  		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> @@ -7987,6 +8024,7 @@ static __init int hardware_setup(void)
>  	}
>  
>  	kvm_has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
> +	kvm_has_notify_vmexit = cpu_has_notify_vmexit();

Why is this info being cached?  cpu_has_notify_vmexit() is not expensive, nor is
it called in a hot path.  Oooh, it's so x86 can see it.

I'd prefer to add a flag to struct kvm_x86_ops, similar to cpu_dirty_log_size.
That avoids having all these global variables and their exports.

>  	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fee402a700df..9fd693db6d9d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -163,6 +163,8 @@ u64 __read_mostly kvm_default_tsc_scaling_ratio;
>  EXPORT_SYMBOL_GPL(kvm_default_tsc_scaling_ratio);
>  bool __read_mostly kvm_has_bus_lock_exit;
>  EXPORT_SYMBOL_GPL(kvm_has_bus_lock_exit);
> +bool __read_mostly kvm_has_notify_vmexit;
> +EXPORT_SYMBOL_GPL(kvm_has_notify_vmexit);
>  
>  /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
>  static u32 __read_mostly tsc_tolerance_ppm = 250;
> @@ -291,7 +293,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>  	STATS_DESC_COUNTER(VCPU, nested_run),
>  	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
>  	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
> -	STATS_DESC_ICOUNTER(VCPU, guest_mode)
> +	STATS_DESC_ICOUNTER(VCPU, guest_mode),
> +	STATS_DESC_COUNTER(VCPU, notify_window_exits),
>  };
>  
>  const struct kvm_stats_header kvm_vcpu_stats_header = {
> @@ -4359,10 +4362,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		if (r < sizeof(struct kvm_xsave))
>  			r = sizeof(struct kvm_xsave);
>  		break;
> +	}
>  	case KVM_CAP_PMU_CAPABILITY:
>  		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
>  		break;
> -	}
> +	case KVM_CAP_X86_NOTIFY_VMEXIT:
> +		r = kvm_has_notify_vmexit;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -6055,6 +6061,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		}
>  		mutex_unlock(&kvm->lock);
>  		break;
> +	case KVM_CAP_X86_NOTIFY_VMEXIT:
> +		r = -EINVAL;
> +		if (!kvm_has_notify_vmexit)
> +			break;
> +		kvm->arch.notify_window = cap->args[0];

Using -1 for "off" is both kludgy and flawed, e.g. it prevents usersepace from
configuring the full 32 bits of the field.  Not that I expect userspace to do that,
but it's an unnecessary shortcoming.

Rather than -1, what about using bits 63:32 for the window value, and bits 31:0
for flags?  Then we can have an explicit enable flag (no need to set notifi_window
to -1 during VM creation), and we can also reserve flags for future use, e.g. if
we want to support exiting to userspace on every NOTIFY exit.  Actually, I don't
see any reason not to add that functionality straightaway.  KVM already has the
new userpace exit reason, so it'd be like one or two lines of code here, plus the
same in the exit handler.

> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -11649,6 +11662,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.guest_can_read_msr_platform_info = true;
>  	kvm->arch.enable_pmu = enable_pmu;
>  
> +	kvm->arch.notify_window = -1;
> +
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
>  	kvm->arch.hv_root_tdp = INVALID_PAGE;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index aa86abad914d..cf115233ce18 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -349,6 +349,11 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
>  	return kvm->arch.cstate_in_guest;
>  }
>  
> +static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
> +{
> +	return kvm->arch.notify_window >= 0;
> +}
> +
>  enum kvm_intr_type {
>  	/* Values are arbitrary, but must be non-zero. */
>  	KVM_HANDLING_IRQ = 1,
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d2f1efc3aa35..8f58196569a0 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -270,6 +270,7 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_X86_BUS_LOCK     33
>  #define KVM_EXIT_XEN              34
>  #define KVM_EXIT_RISCV_SBI        35
> +#define KVM_EXIT_NOTIFY           36
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -487,6 +488,11 @@ struct kvm_run {
>  			unsigned long args[6];
>  			unsigned long ret[2];
>  		} riscv_sbi;
> +		/* KVM_EXIT_NOTIFY */
> +		struct {
> +#define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
> +			__u32 data;

Probably better to use "flags" instead of "data".

> +		} notify;
>  		/* Fix the size of the union. */
>  		char padding[256];
>  	};
> @@ -1143,6 +1149,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_AIL_MODE_3 210
>  #define KVM_CAP_S390_MEM_OP_EXTENSION 211
>  #define KVM_CAP_PMU_CAPABILITY 212
> +#define KVM_CAP_X86_NOTIFY_VMEXIT 213
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.17.1
> 
