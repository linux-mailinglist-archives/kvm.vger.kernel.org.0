Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261414ECF01
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 23:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351333AbiC3VtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 17:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243390AbiC3VtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 17:49:16 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CD0BCBF
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 14:47:30 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id bo5so581768pfb.4
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 14:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lu/OaZ0ppwhDx18TN60M/FhAWhGydJGFXEfzdV2g8HY=;
        b=RAqIT9MKFGfwgpem6ZfAgI3Lqn7WOSMQZjhERWSbGyspdBvdKxB0h7tAUgjzYtNi0H
         P375JcY6Y7E54a2Z0VtgXklIgfkGShzR76HPNW4ZjCFYtrxWSorkwlJo7zgY58qRyK2Q
         tdWV6jw+9ukpMq9pPmDTUvw0Z9ZWJxZW96erI92X7HCu+2kMeLr6yw1DUL0LwW1fV4t2
         Zs+dXPMiBFRlaySqkZFNd9YiNAHBm+3yRrj/WS0nDh1+tothXFjuhhON469Xk7XKrp62
         Srthzd0HpF4w4hZzoMbqoZHeUWHw86CvwfKluDBoFo08shza3gKMEuI/uk7j4NMWBZM2
         Y/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lu/OaZ0ppwhDx18TN60M/FhAWhGydJGFXEfzdV2g8HY=;
        b=6xphgaX7k/YjqZQK5g6dFZtnkhM8ONrFLxjkrQwfInQ9TZTROIS9X7ZheHH8UvnEvL
         a2RSEJzAS2X6XJFb9NJqSY7kBODERR00/ndLlZb7hSTbQkKIO6BeTJNT8tUq9TyBW2ZK
         vHDhjF/Ge5ni3WTv4dH9CJHup+7kZXSFN5lYYy/J6s7O9SFWP5ZxvR1rUPwc0Q3pllzO
         b3xdq1I9NSruyWH3QlAyRJdyjnbIKppZWD9/jAUMtJoynjDNk+ZBBLiJKvJ/pQJabl3k
         imTMYns9gkSRwucCpqp6FhZ1dSiamVFJXo+c9S9hpg2uaW5/9zradollsy/3DEwpUWgK
         FS6w==
X-Gm-Message-State: AOAM532bCsC1DbRmu5Fap5kKeAMr3mZSCr/7sSNqgMzcIxPi0wlrbuRN
        UiUp42O2h29gPwrmVueCXm6rhg==
X-Google-Smtp-Source: ABdhPJwFOO8tofLZJPD3Q3rkBtJWmegX8ISXweJCIst1G5f7McVaWVLKimAT+kjzIJarl+J5cyK7VQ==
X-Received: by 2002:a05:6a00:2402:b0:4e1:3df2:5373 with SMTP id z2-20020a056a00240200b004e13df25373mr1735242pfh.40.1648676850190;
        Wed, 30 Mar 2022 14:47:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 123-20020a620681000000b004fa7c20d732sm23730995pfg.133.2022.03.30.14.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 14:47:29 -0700 (PDT)
Date:   Wed, 30 Mar 2022 21:47:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 7/7] KVM: VMX: Enable PKS for nested VM
Message-ID: <YkTP7uztERLwynAN@google.com>
References: <20220221080840.7369-1-chenyi.qiang@intel.com>
 <20220221080840.7369-8-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221080840.7369-8-chenyi.qiang@intel.com>
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

On Mon, Feb 21, 2022, Chenyi Qiang wrote:
> PKS MSR passes through guest directly. Configure the MSR to match the
> L0/L1 settings so that nested VM runs PKS properly.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 38 ++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/vmx/vmcs12.c |  2 ++
>  arch/x86/kvm/vmx/vmcs12.h |  4 ++++
>  arch/x86/kvm/vmx/vmx.c    |  1 +
>  arch/x86/kvm/vmx/vmx.h    |  2 ++
>  5 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f235f77cbc03..c42a1df385ef 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -252,6 +252,10 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
>  	dest->ds_sel = src->ds_sel;
>  	dest->es_sel = src->es_sel;
>  #endif
> +	if (unlikely(src->pkrs != dest->pkrs)) {
> +		vmcs_write64(HOST_IA32_PKRS, src->pkrs);
> +		dest->pkrs = src->pkrs;
> +	}

It's worth adding a helper for this, a la vmx_set_host_fs_gs(), though this one
can probably be an inline in vmx.h.  E.g. to yield

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bfa37c7665a5..906a2913a886 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -252,10 +252,7 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
        dest->ds_sel = src->ds_sel;
        dest->es_sel = src->es_sel;
 #endif
-       if (unlikely(src->pkrs != dest->pkrs)) {
-               vmcs_write64(HOST_IA32_PKRS, src->pkrs);
-               dest->pkrs = src->pkrs;
-       }
+       vmx_set_host_pkrs(dest, src->pkrs);
 }

 static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 35fee600fae7..b6b5f1a46544 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1157,10 +1157,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
         */
        if (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_IA32_PKRS) {
                host_pkrs = get_current_pkrs();
-               if (unlikely(host_pkrs != host_state->pkrs)) {
-                       vmcs_write64(HOST_IA32_PKRS, host_pkrs);
-                       host_state->pkrs = host_pkrs;
-               }
+               vmx_set_host_pkrs(host_state, host_pkrs);
        }

 #ifdef CONFIG_X86_64


>  }
>  
>  static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
> @@ -685,6 +689,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>  					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
>  
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_PKRS, MSR_TYPE_RW);
> +
>  	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>  
>  	vmx->nested.force_msr_bitmap_recalc = false;
> @@ -2433,6 +2440,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
>  		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>  			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
> +
> +		if (vmx->nested.nested_run_pending &&
> +		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
> +			vmcs_write64(GUEST_IA32_PKRS, vmcs12->guest_ia32_pkrs);
>  	}
>  
>  	if (nested_cpu_has_xsaves(vmcs12))
> @@ -2521,6 +2532,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
>  	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>  		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
> +	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
> +	    (!vmx->nested.nested_run_pending ||
> +	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
> +		vmcs_write64(GUEST_IA32_PKRS, vmx->nested.vmcs01_guest_pkrs);
> +
>  	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
>  
>  	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
> @@ -2897,6 +2913,10 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>  					   vmcs12->host_ia32_perf_global_ctrl)))
>  		return -EINVAL;
>  
> +	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS) &&
> +		CC(!kvm_pkrs_valid(vmcs12->host_ia32_pkrs)))

Please align the indentation:

	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS) &&
	    CC(!kvm_pkrs_valid(vmcs12->host_ia32_pkrs)))
		return -EINVAL;

> +		return -EINVAL;
> +
>  #ifdef CONFIG_X86_64
>  	ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);
>  #else
> @@ -3049,6 +3069,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  	if (nested_check_guest_non_reg_state(vmcs12))
>  		return -EINVAL;
>  
> +	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS) &&
> +	    CC(!kvm_pkrs_valid(vmcs12->guest_ia32_pkrs)))
> +		return -EINVAL;
> +
>  	return 0;
>  }
>  
> @@ -3377,6 +3401,9 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	if (kvm_mpx_supported() &&
>  		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>  		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> +	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
> +	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))

This needs read the current PKRS if from_vmentry == false, e.g.

	if (kvm_cpu_cap_has(X86_FEATURE_PKS) && 
	    (!from_vmentry ||
	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))

because in the migration case, if nested state is set after MSR state, the value
needs to come from the current MSR value, which was propagated to vmc02 (which
this calls vmcs01, but whatever).

Note, I'm pretty sure the GUEST_BNDCFGS code is broken, surprise surprise.

> +		vmx->nested.vmcs01_guest_pkrs = vmcs_read64(GUEST_IA32_PKRS);
>  
>  	/*
>  	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
> @@ -4022,6 +4049,7 @@ static bool is_vmcs12_ext_field(unsigned long field)
>  	case GUEST_IDTR_BASE:
>  	case GUEST_PENDING_DBG_EXCEPTIONS:
>  	case GUEST_BNDCFGS:
> +	case GUEST_IA32_PKRS:
>  		return true;
>  	default:
>  		break;
> @@ -4073,6 +4101,8 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>  		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>  	if (kvm_mpx_supported())
>  		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_PKS))

This needs to check vmx->nested.msrs.entry_ctls_* (I can never remember if it's
the high or low part...).  The SDM states PKRS is saved "if the processor supports
the 1-setting of the 'load PKRS' VM-entry control", which is different than PKRS
being supported in CPUID.  Also, guest CPUID is userspace controlled, e.g. userspace
could induce a failed VMREAD by giving a garbage CPUID model, where vmx->nested.msrs
can only be restricted by userspace, i.e. is trusted.

Happyily, checking vmx->nested.msrs is also a performance win, as guest_cpuid_has()
can require walking a large array.
