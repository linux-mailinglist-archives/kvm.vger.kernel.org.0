Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6805848DFDD
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 22:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236050AbiAMVr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 16:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiAMVr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 16:47:58 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E428EC06161C
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 13:47:57 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m13so11734265pji.3
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 13:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qlw9zu20908sVRjvcOO7VK1fi4Ol62KCGhcxbKZ2mWM=;
        b=Jsup4IFpxl6vRB3iS3yCHWdZGVZpZYRsv5CJ8Y1zklXVBGfGAFJ0CUrueIqLkRWYZj
         oTYlGnNdqYlMa5U6sq9TldWgHXXStdeBWJlNF6YCGHqvh+HbKUd2K6K6RG+jkbP/PKTa
         rEyryXYeBHwUIhW+LS0Pk+TI1h4yZkocVgR2e8gL7TkgU90eNnuHQNRec10lwWyXfnSJ
         6aC4x5f50z3yLJO7B3OBxg69Xry41ZtqsEMZgsHwdyPcWJDI8CmAiqdyIseNg5ZjPTl6
         Zl+PqNrBVsB3jhjisfP2Gg4+cU5r1SUgSiFDXXIQnzKu1lV+VF+S8m/uq5pkgfN3csPe
         Fn7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qlw9zu20908sVRjvcOO7VK1fi4Ol62KCGhcxbKZ2mWM=;
        b=Qol0M7ScB8UzMUjkmOf2a1E1LRI0zVYY3VFuh2DwNQMaaqrL5MLNYgpkaNHO1O4MIP
         L3y7DnvhY3W0I+IZesBSpjQ0PS+ob3aFdDwIJnRezwn1RSqK3CL1V1HrZpxQRUL1m4Sn
         qXdBoCwtpw6/gNMyRaFLrOC0D4ob4fn+R9jPnKcZaLFhc9z+0WwTFQDIQ5MlMadRw/Dm
         veQc0zHTzFELT+LquIDtgAHDwZB+xxL8ZCPQMgOyzxewU2WW57ZwnbAWyK7c1n+3+hWW
         0syhc47gFMVpTNXtdZzV2v1bhoJceu6UOCj8bJpdUounOdlCjArtUfocxf0QSQP3NApV
         VzQg==
X-Gm-Message-State: AOAM533h3itDrwAdqshRvQYsG3jCoyR2Bn8Ny/9JHy0Js2lvvXY1DU3O
        eW+MtRkKV6AhNeRwEAG94GHkKg==
X-Google-Smtp-Source: ABdhPJyet0qeO9RRG9lay5WRarnCed1yWvPCbp+wzDShDhFsopl8GfEjvMhYbtbHt7gZbrOuQhOf3g==
X-Received: by 2002:a17:903:2344:b0:14a:37c4:721c with SMTP id c4-20020a170903234400b0014a37c4721cmr6563386plh.158.1642110477132;
        Thu, 13 Jan 2022 13:47:57 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u13sm841893pfl.220.2022.01.13.13.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 13:47:56 -0800 (PST)
Date:   Thu, 13 Jan 2022 21:47:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>
Subject: Re: [PATCH v5 6/8] KVM: VMX: enable IPI virtualization
Message-ID: <YeCeCYY2UTL/T1Tv@google.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-7-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231142849.611-7-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 31, 2021, Zeng Guang wrote:
> +/* Tertiary Processor-Based VM-Execution Controls, word 3 */
> +#define VMX_FEATURE_IPI_VIRT		(3*32 +  4) /* "" Enable IPI virtualization */
>  #endif /* _ASM_X86_VMXFEATURES_H */
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 38d414f64e61..78b0525dd991 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -12,6 +12,7 @@ extern bool __read_mostly enable_ept;
>  extern bool __read_mostly enable_unrestricted_guest;
>  extern bool __read_mostly enable_ept_ad_bits;
>  extern bool __read_mostly enable_pml;
> +extern bool __read_mostly enable_ipiv;
>  extern int __read_mostly pt_mode;
>  
>  #define PT_MODE_SYSTEM		0
> @@ -283,6 +284,12 @@ static inline bool cpu_has_vmx_apicv(void)
>  		cpu_has_vmx_posted_intr();
>  }
>  
> +static inline bool cpu_has_vmx_ipiv(void)
> +{
> +	return vmcs_config.cpu_based_3rd_exec_ctrl &
> +		TERTIARY_EXEC_IPI_VIRT;

Unnecessary newline, that fits on a single line.

> +}
> +
>  static inline bool cpu_has_vmx_flexpriority(void)
>  {
>  	return cpu_has_vmx_tpr_shadow() &&
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 1c94783b5a54..bd9c9a89726a 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -85,11 +85,16 @@ static bool vmx_can_use_vtd_pi(struct kvm *kvm)
>  		irq_remapping_cap(IRQ_POSTING_CAP);
>  }
>  
> +static bool vmx_can_use_ipiv_pi(struct kvm *kvm)
> +{
> +	return irqchip_in_kernel(kvm) && enable_apicv && enable_ipiv;

enable_ipiv should be cleared if !enable_apicv, i.e. the enable_apicv check
here should be unnecessary.

> +}
> +
>  void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>  {
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  
> -	if (!vmx_can_use_vtd_pi(vcpu->kvm))
> +	if (!(vmx_can_use_ipiv_pi(vcpu->kvm) || vmx_can_use_vtd_pi(vcpu->kvm)))

Purely because I am beyond terrible at reading !(A || B) and !(A && B), can we
write this as:

	if (!vmx_can_use_ipiv_pi(vcpu->kvm) && !vmx_can_use_vtd_pi(vcpu->kvm))
		return;

Or better, add a helper.  We could even drop vmx_can_use_ipiv_pi() altogether, e.g.

static bool vmx_can_use_posted_interrupts(struct kvm *kvm)
{
	return irqchip_in_kernel(kvm) &&
	       (enable_ipiv || vmx_can_use_vtd_pi(kvm));
}

Or with both helpers:

static bool vmx_can_use_posted_interrupts(struct kvm *kvm)
{
	return vmx_can_use_ipiv_pi(kvm) || vmx_can_use_vtd_pi(kvm);
}

I don't think I have a strong preference over whether or not to drop 
vmx_can_use_ipiv_pi().  I think it's marginally easier to read with the extra
helper?

>  		return;
>  
>  	/* Set SN when the vCPU is preempted */
> @@ -147,7 +152,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  	struct pi_desc old, new;
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  
> -	if (!vmx_can_use_vtd_pi(vcpu->kvm))
> +	if (!(vmx_can_use_ipiv_pi(vcpu->kvm) || vmx_can_use_vtd_pi(vcpu->kvm)))
>  		return 0;
>  
>  	WARN_ON(irqs_disabled());
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5716db9704c0..2e65464d6dee 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -104,6 +104,9 @@ module_param(fasteoi, bool, S_IRUGO);
>  
>  module_param(enable_apicv, bool, S_IRUGO);
>  
> +bool __read_mostly enable_ipiv = true;
> +module_param(enable_ipiv, bool, 0444);
> +
>  /*
>   * If nested=1, nested virtualization is supported, i.e., guests may use
>   * VMX and be a hypervisor for its own guests. If nested=0, guests may not
> @@ -224,6 +227,11 @@ static const struct {
>  };
>  
>  #define L1D_CACHE_ORDER 4
> +
> +/* PID(Posted-Interrupt Descriptor)-pointer table entry is 64-bit long */
> +#define MAX_PID_TABLE_ORDER get_order(KVM_MAX_VCPU_IDS * sizeof(u64))
> +#define PID_TABLE_ENTRY_VALID 1
> +
>  static void *vmx_l1d_flush_pages;
>  
>  static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
> @@ -2504,7 +2512,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	}
>  
>  	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
> -		u64 opt3 = 0;
> +		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
>  		u64 min3 = 0;
>  
>  		if (adjust_vmx_controls_64(min3, opt3,
> @@ -3841,6 +3849,8 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
>  		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
>  		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
>  		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
> +		vmx_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR),
> +				MSR_TYPE_RW, !enable_ipiv);

Please align this, e.g.

		vmx_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR),
					  MSR_TYPE_RW, !enable_ipiv);

though I think I'd actually prefer we do:


		if (enable_ipiv)
			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR), MSR_TYPE_RW);

and just let it poke out.  That makes it much more obvious that interception is
disabled when IPI virtualization is enabled.  Using vmx_set_intercept_for_msr()
implies that it could go either way, but that's not true as vmx_reset_x2apic_msrs()
sets the bitmap to intercept all x2APIC MSRs.

>  	}
>  }
>  
