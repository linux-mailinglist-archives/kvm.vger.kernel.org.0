Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FBA32C69F
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346625AbhCDA3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385514AbhCCRUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 12:20:07 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFA0C061762
        for <kvm@vger.kernel.org>; Wed,  3 Mar 2021 09:19:26 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 192so9718373pfv.0
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 09:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FHyvGZML3MBKrGH2MEphtbcEcxiY8b8O99Y6sp6t/cg=;
        b=G/8MzxJ5fh+VT7ZVlVY7lHzUPSCfmYnOVvgJNjJ+8oquI42E+lnJ2N5+JtmOiYN9FK
         no7sbDNEU1c741o0AvYSFHeAzbyAha5SB1CSZNEOexpDdYGUbOk95brTjTYWgYfPT9yt
         lEXOjCpCe8M9jBiiWj3a9mpnZbxs+zHO0ejQQDWypAftOp654yVXPQGN2vtKAnBmzvSB
         sRzbdNPELAXXcU9M8Z2mi/uw10kDeHpqgX+zzm3Z5HqGSI+MFM32ANqWFA5gXrelxcWv
         6NvTZCvFAS7Nw4difkcOFYRXR/q/uQuOrUL+bDunmMrY8xaxrSFv6aErE/17A3zseMSu
         aFww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FHyvGZML3MBKrGH2MEphtbcEcxiY8b8O99Y6sp6t/cg=;
        b=SRo2Ndqa65dvzzLSjU+Cq9ZCZt89MMACUDqVGC9VF/sBi5bRD7ZbqynDhdvjhQX1y6
         7MQvMCROdMks76IKTscZYgu7k4AnEvWHg31Isfa+KeYkfnadjn1AddKJl4g2adPPxCMT
         7QRNPkym8IaTiu3SRQOg46rTulC/yekuFsnaJfXFlmZMds0KSBvlhJjoDpAX4QXKsUaT
         aWwfdkiw/H4vIIZ7EolkkCuBdoWq9sGO5Bvr595bmwc+bLXwqFrO25mucwr9GWndnWZh
         f9ZGxlBGspZqCdVTa/PwwZw3dVonCLD4mMLlzV8uz1iOLPIuF/7P/6BGZIWWZ9gzPXuF
         ZjMw==
X-Gm-Message-State: AOAM533PkOrylm+sLsx6AItVVnJIfvt0CDEPanzw3101ljBzMUL0jwjk
        wJxpwlBhISTzL60DRTESwg81tA==
X-Google-Smtp-Source: ABdhPJwA8iTpEBJ04oL/dZPg2sq+YVSG/G4ERDnJU5YZa+xfbtDAm9p22T6JSXL8CKIJbml9l5HstQ==
X-Received: by 2002:a63:e150:: with SMTP id h16mr23877981pgk.308.1614791965568;
        Wed, 03 Mar 2021 09:19:25 -0800 (PST)
Received: from google.com ([2620:15c:f:10:805d:6324:3372:6183])
        by smtp.gmail.com with ESMTPSA id g141sm25024624pfb.67.2021.03.03.09.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 09:19:24 -0800 (PST)
Date:   Wed, 3 Mar 2021 09:19:18 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/9] KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL emulation for
 Arch LBR
Message-ID: <YD/FFsTq6wprdMCB@google.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-7-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303135756.1546253-7-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021, Like Xu wrote:
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 25d620685ae7..d14a14eb712d 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -19,6 +19,7 @@
>  #include "pmu.h"
>  
>  #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
> +#define KVM_ARCH_LBR_CTL_MASK			0x7f000f

It would nice to build this up with the individual bits instead of tossing in a
magic number. 

>  static struct kvm_event_hw_type_mapping intel_arch_events[] = {
>  	/* Index must match CPUID 0x0A.EBX bit vector */
> @@ -221,6 +222,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>  		ret = pmu->version > 1;
>  		break;
>  	case MSR_ARCH_LBR_DEPTH:
> +	case MSR_ARCH_LBR_CTL:
>  		ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
>  		break;
>  	default:
> @@ -390,6 +392,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_ARCH_LBR_DEPTH:
>  		msr_info->data = lbr_desc->records.nr;
>  		return 0;
> +	case MSR_ARCH_LBR_CTL:
> +		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
> +		return 0;
>  	default:
>  		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>  		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -457,6 +462,15 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		lbr_desc->records.nr = data;
>  		lbr_desc->arch_lbr_reset = true;
>  		return 0;
> +	case MSR_ARCH_LBR_CTL:
> +		if (!(data & ~KVM_ARCH_LBR_CTL_MASK)) {

Maybe invert this to reduce indentation?

		if (data & ...)
			break; (or "return 1;")


> +			vmcs_write64(GUEST_IA32_LBR_CTL, data);
> +			if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
> +				(data & ARCH_LBR_CTL_LBREN))

Alignment.

> +				intel_pmu_create_guest_lbr_event(vcpu);
> +			return 0;
> +		}
> +		break;
>  	default:
>  		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>  		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -635,12 +649,15 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>   */
>  static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
>  {
> -	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> +	u32 lbr_ctl_field = GUEST_IA32_DEBUGCTL;
>  
> -	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
> -		data &= ~DEBUGCTLMSR_LBR;
> -		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> -	}
> +	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI))
> +		return;
> +
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> +		lbr_ctl_field = GUEST_IA32_LBR_CTL;
> +
> +	vmcs_write64(lbr_ctl_field, vmcs_read64(lbr_ctl_field) & ~BIT(0));

Use ARCH_LBR_CTL_LBREN?

>  }
>  
>  static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6d7e760fdfa0..a0660b9934c6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2036,6 +2036,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  						VM_EXIT_SAVE_DEBUG_CONTROLS)
>  			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
>  
> +		/*
> +		 * For Arch LBR, IA32_DEBUGCTL[bit 0] has no meaning.
> +		 * It can be written to 0 or 1, but reads will always return 0.
> +		 */
> +		if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> +			data &= ~DEBUGCTLMSR_LBR;
> +
>  		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>  		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
>  		    (data & DEBUGCTLMSR_LBR))
> @@ -4463,6 +4470,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  		vmcs_writel(GUEST_SYSENTER_ESP, 0);
>  		vmcs_writel(GUEST_SYSENTER_EIP, 0);
>  		vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
> +		if (cpu_has_vmx_arch_lbr())
> +			vmcs_write64(GUEST_IA32_LBR_CTL, 0);

Not that any guest is likely to care, but is the MSR cleared on INIT?  The SDM
has specific language for warm reset, but I can't find anything for INIT.

  On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their values
  preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling LBRs. If a
  warm reset is triggered while the processor is in C6, also known as warm init,
  all LBR MSRs will be reset to their initial values.

>  	}
>  
>  	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
> -- 
> 2.29.2
> 
