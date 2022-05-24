Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5409B533350
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 00:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbiEXWMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 18:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiEXWMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 18:12:01 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BA52FFEB
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 15:11:59 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id f4so2112945pgf.4
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 15:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WTfihyvwgyLGsq66iS5in5m2V+CuATt3dZAIwdmKLdg=;
        b=mWR1RSToQywG01H9fAiGKDeFxaZFkisxbDrx4EiQkqMlWTudU9PxWbYspGMm2Er0Ns
         xKHHGyLnx1Qp4layVesgr+W5C5EGvhaWFMISqZONL0gQ2F/jJU6Rz8roskFCqm+4gxlY
         UYTghDdRWvD1gK7L5sb643VO1SJRs6d866a/6NCcCD/3/ZQ0twoW+gPGM3KmDBs/ehn8
         pRl40akkjQQ+GCkpwfnasuZgmz+CCqsaRk220cn9liyDXu//cOf4AjRHl+dQxttkXxtN
         Cwh8NSrsUizEmPO61bU3GdwL0I7jnpNCDEN6mzH2fkc2if2EYy3vy48TksjNoSsAELYL
         7rWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WTfihyvwgyLGsq66iS5in5m2V+CuATt3dZAIwdmKLdg=;
        b=qXC8JeMsif+OLoxiNT735XywJFdhN4EZFtmlWlC4JNb0OxhamerJOVSgZuicRc57DG
         oqZG+CF45GUWJWDWakg6Fhsr45Xm2IGT/JYsOrNwNc8Y+slFSP0hr6K2thi3d3rCNdyj
         Ku/ZXkefitsAgE/N7FKiWF9WH3A6D9jux+MZ21BpXRXZtwnH6fZZZaPoZeeBFdaYTLgp
         x9U9kgXZ0N6YPr5Fn4OnbHaO9HD/MdCuakwzheUPAGzrl6ze+j8PHcRFDnvfAH/xeieb
         OUShAU+aVXL8367hWz+zYgpGo4eO8W2O5Rgnr3vOnsv6JIh8aqBCcNFK6jk9rKazTUxN
         6rOg==
X-Gm-Message-State: AOAM530fJX7JaYuy2xrsTZKZW/rywzgu/++xD5IdIaFpWJ1WdZYdCOSn
        HJho202pd3ZXzCrLbR05e/BEvg==
X-Google-Smtp-Source: ABdhPJyl+208+pRZnzpJ2kLLfuZ6d1y/xNwp/T44hnZZZl2vHWEdtCJ+vBGTSnOSw53uJ48X1PDaqw==
X-Received: by 2002:a05:6a00:729:b0:4f7:77ed:c256 with SMTP id 9-20020a056a00072900b004f777edc256mr30488100pfm.1.1653430318990;
        Tue, 24 May 2022 15:11:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g3-20020a170902d5c300b0015e8d4eb2b9sm7721999plh.259.2022.05.24.15.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 15:11:58 -0700 (PDT)
Date:   Tue, 24 May 2022 22:11:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lei Wang <lei4.wang@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/8] KVM: X86: Expose IA32_PKRS MSR
Message-ID: <Yo1YKoUOPOLpZnqn@google.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20220424101557.134102-4-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424101557.134102-4-lei4.wang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, something like:

  KVM: X86: Virtualize and pass-through IA32_PKRS MSR when supported

because "expose" doesn't precisely cover the pass-through behavior

On Sun, Apr 24, 2022, Lei Wang wrote:
> @@ -1111,6 +1113,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  #endif
>  	unsigned long fs_base, gs_base;
>  	u16 fs_sel, gs_sel;
> +	u32 host_pkrs;
>  	int i;
>  
>  	vmx->req_immediate_exit = false;
> @@ -1146,6 +1149,17 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  	 */
>  	host_state->ldt_sel = kvm_read_ldt();
>  
> +	/*
> +	 * Update the host pkrs vmcs field before vcpu runs.
> +	 * The setting of VM_EXIT_LOAD_IA32_PKRS can ensure
> +	 * kvm_cpu_cap_has(X86_FEATURE_PKS) &&
> +	 * guest_cpuid_has(vcpu, X86_FEATURE_PKS)
> +	 */

Eh, I don't think this comment adds anything.  And practically speaking, whether
or not X86_FEATURE_PKS is reported by kvm_cpu_cap_has() and/or guest_cpuid_has()
is irrelevant.  If KVM is loading PKRS on exit, then the VMCS needs to hold an
up-to-date value.  E.g. if for some reason KVM enables the control even if PKS
isn't exposed to the guest (see below), this code still needs to refresh the value.

> +	if (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_IA32_PKRS) {
> +		host_pkrs = get_current_pkrs();

No need for an intermediate host_pkrs.  I.e. this can simply be:

	if (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_IA32_PKRS)
		vmx_set_host_pkrs(host_state, get_current_pkrs());

> +		vmx_set_host_pkrs(host_state, host_pkrs);
> +	}
> +
>  #ifdef CONFIG_X86_64
>  	savesegment(ds, host_state->ds_sel);
>  	savesegment(es, host_state->es_sel);
> @@ -1901,6 +1915,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_DEBUGCTLMSR:
>  		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>  		break;
> +	case MSR_IA32_PKRS:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_PKS) ||
> +		    (!msr_info->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_PKS)))

Nit, please align the lines that are inside a pair of parantheses, i.e.

		if (!kvm_cpu_cap_has(X86_FEATURE_PKS) ||
		    (!msr_info->host_initiated &&
		     !guest_cpuid_has(vcpu, X86_FEATURE_PKS)))
			return 1;

> +			return 1;
> +		msr_info->data = kvm_read_pkrs(vcpu);

A comment on the caching patch, please use kvm_pkrs_read() to follow the GPR, RIP,
PDPTR, etc... terminology (CR0/3/4 got grandfathered in).

> +		break;
>  	default:
>  	find_uret_msr:
>  		msr = vmx_find_uret_msr(vmx, msr_info->index);
> @@ -2242,7 +2263,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		}
>  		ret = kvm_set_msr_common(vcpu, msr_info);
>  		break;
> -
> +	case MSR_IA32_PKRS:
> +		if (!kvm_pkrs_valid(data))
> +			return 1;

Nit, please move this to after the capability checks.  Does not affect functionality
at all, but logically it doesn't make sense to check for a valid value of a register
that doesn't exist.

> +		if (!kvm_cpu_cap_has(X86_FEATURE_PKS) ||
> +		    (!msr_info->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_PKS)))
> +			return 1;
> +		vcpu->arch.pkrs = data;
> +		kvm_register_mark_available(vcpu, VCPU_EXREG_PKRS);
> +		vmcs_write64(GUEST_IA32_PKRS, data);

The caching patch should add kvm_write_pkrs().  And in there, I think I'd vote for
a WARN_ON_ONCE() that the incoming value doesn't set bits 63:32.  It's redundant
with kvm_pkrs_valid()


> +		break;
>  	default:
>  	find_uret_msr:
>  		msr = vmx_find_uret_msr(vmx, msr_index);

...

> @@ -7406,6 +7445,20 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  
>  	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>  	vmx_update_exception_bitmap(vcpu);
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_PKS)) {a
> +		if (guest_cpuid_has(vcpu, X86_FEATURE_PKS)) {
> +			vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW);
> +
> +			vm_entry_controls_setbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
> +			vm_exit_controls_setbit(vmx, VM_EXIT_LOAD_IA32_PKRS);

Ugh, toggling the entry/exit controls here won't do the correct thing if L2 is
active.  The MSR intercept logic works because it always operates on vmcs01's bitmap.

Let's keep this as simple as possible and set the controls if they're supported.
KVM will waste a few cycles on entry/exit if PKS is supported in the host but not
exposed to the guest, but that's not the end of the world.  If we want to optimize
that, then we can do that in the future and in a more generic way.

So this becomes:

	if (kvm_cpu_cap_has(X86_FEATURE_PKS))
		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW,
					  !guest_cpuid_has(vcpu, X86_FEATURE_PKS));

And please hoist that up to be next to the handling of X86_FEATURE_XFD to try and
bunch together code that does similar things.

The last edge case to deal with is if only one of the controls is supported, e.g. if
an L0 hypervisor is being evil.  Big surprise, BNDCFGS doesn't get this right and
needs a bug fix patch, e.g. it could retain the guest's value after exit, or host's
value after entry.  It's a silly case because it basically requires broken host
"hardware", but it'd be nice to get it right in KVM.  And that'd also be a good
opportunity to handle all of the pairs, i.e. clear the bits during setup_vmcs_config()
instead of checking both the entry and exit flags in cpu_has_load_*().

So for this series, optimistically assume my idea will pan out and a
adjust_vm_entry_exit_pair() helper will exit by the time this is fully baked.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6927f6e8ec31..53e12e6006af 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2434,6 +2434,16 @@ static bool cpu_has_sgx(void)
        return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
 }

+static __init void adjust_vm_entry_exit_pair(u32 *entry_controls, u32 entry_bit,
+                                            u32 *exit_controls, u32 exit_bit)
+{
+       if ((*entry_controls & entry_bit) && (*exit_controls & exit_bit))
+               return;
+
+       *entry_controls &= ~entry_bit;
+       *exit_controls &= ~exit_bit;
+}
+
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
                                      u32 msr, u32 *result)
 {
@@ -2614,6 +2624,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
                                &_vmentry_control) < 0)
                return -EIO;

+       adjust_vm_entry_exit_pair(&_vmentry_control, VM_ENTRY_LOAD_IA32_PKRS,
+                                 &_vmexit_control, VM_EXIT_LOAD_IA32_PKRS);
+
        /*
         * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
         * can't be used due to an errata where VM Exit may incorrectly clear
@@ -7536,6 +7549,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
                vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
                                          !guest_cpuid_has(vcpu, X86_FEATURE_XFD));

+       if (kvm_cpu_cap_has(X86_FEATURE_PKS))
+               vmx_set_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW,
+                                         !guest_cpuid_has(vcpu, X86_FEATURE_PKS));

        set_cr4_guest_host_mask(vmx);


> +		} else {
> +			vmx_enable_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW);
> +
> +			vm_entry_controls_clearbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
> +			vm_exit_controls_clearbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
> +		}
> +	}
>  }
>  

...

> @@ -11410,6 +11414,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
>  	kvm_rip_write(vcpu, 0xfff0);
>  
> +	if (!init_event && kvm_cpu_cap_has(X86_FEATURE_PKS))
> +		__kvm_set_msr(vcpu, MSR_IA32_PKRS, 0, true);

Please put this with the other !init_event stuff, e.g. look for MSR_IA32_XSS.

>  	vcpu->arch.cr3 = 0;
>  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
>  
 
