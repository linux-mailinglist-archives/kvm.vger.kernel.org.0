Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E74048489B
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 20:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiADTcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 14:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiADTcf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 14:32:35 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F1DC061792
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 11:32:35 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id r5so33565337pgi.6
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 11:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XtOM86rcIDhUEVJJrSrXXYTFcIhTo09zqSW+wQ8NDvo=;
        b=azfR1U8ASdhcYtfRtnAZwayPplqVw8gIHtDXlEu1mP8qzPVOO5nTx+MSAjRtmXd7Ei
         jJUyEiK6xPa/tU8FvyTHrLK0nzy1VEfDHskJ/pxOpwEcRpHMD82M8iJwyA0i2r88OwXm
         oqpPCNMWHEkbzngGI6P/VnHhewsnQ80j5qYEWEOEfLsHuqQbuifRD252TnEDABeU+PJX
         APaimRTWjEIRoADsuTdEEtIx9I1I1J/1idBDlz4/YAvqR1TxxJrNeZWzWzwg4KxzxWbF
         d3Jc8ndPU4cD8D66vaGDuvxYZcGzpSYChYdzefkGPIX4F7Ht+Scd7chbAVqCqXol3sIK
         kvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XtOM86rcIDhUEVJJrSrXXYTFcIhTo09zqSW+wQ8NDvo=;
        b=ChYvyU77UstzhylRvC6hI7+9T9qUVXhn1TOXYh+Grpljx508MnaFM+oZJXwnNcMASc
         wgE7RnUCkBScIC0oUmoUV3lkGK1DdcnfuhjzbS6G1I2mzsim31kYKtt+FEKWXxUumAKL
         v/cG9y/k/xqtrKPr+pw3d2T9QelQX1f2/N84rDHMtcHxjuKw7MJW4XgJR9asYf4mMuoA
         r6kaT6oTGnNiF/aAX4ZkBwIhwMBOt9Xeizd9w+jeQdm0nkFIi3J1cRdMal36++Y8bF5N
         QR9240/j6aRaK4zj7eSYJ0fD7uj6NZq8S3isDU/9aWGbopxzG2kgwZwTpnl+rw+q2eA+
         VVmQ==
X-Gm-Message-State: AOAM533yicevVbl8BelaSDNuPvAN1L+TUyDqOGnjzi0v0GcKHzkc11wJ
        rfQgGvpmECBKOf9VUOJZD9JgPg==
X-Google-Smtp-Source: ABdhPJwX0owBE0gdeH1l7IQikJyn610QU+zyBIODbPFe8Wmbnp2eFSMK4ahfO1I7uaABUTa2vCmm3Q==
X-Received: by 2002:a63:7b54:: with SMTP id k20mr15640347pgn.445.1641324754314;
        Tue, 04 Jan 2022 11:32:34 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u35sm9259767pfg.157.2022.01.04.11.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 11:32:33 -0800 (PST)
Date:   Tue, 4 Jan 2022 19:32:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Zhong <yang.zhong@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com, corbet@lwn.net,
        shuah@kernel.org, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com
Subject: Re: [PATCH v4 10/21] kvm: x86: Add emulation for IA32_XFD
Message-ID: <YdSgzsiBft/NgxdF@google.com>
References: <20211229131328.12283-1-yang.zhong@intel.com>
 <20211229131328.12283-11-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229131328.12283-11-yang.zhong@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 29, 2021, Yang Zhong wrote:
> From: Jing Liu <jing2.liu@intel.com>
> 
> Intel's eXtended Feature Disable (XFD) feature allows the software
> to dynamically adjust fpstate buffer size for XSAVE features which
> have large state.
> 
> Because fpstate has been expanded for all possible dynamic xstates
> at KVM_SET_CPUID2, emulation of the IA32_XFD MSR is straightforward.
> For write just call fpu_update_guest_xfd() to update the guest fpu
> container once all the sanity checks are passed. For read then
> return the cached value in the container.
> 
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> Signed-off-by: Jing Liu <jing2.liu@intel.com>
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> ---
>  arch/x86/kvm/x86.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e50e97ac4408..36677b754ac9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1359,6 +1359,7 @@ static const u32 msrs_to_save_all[] = {
>  	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
>  	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
>  	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
> +	MSR_IA32_XFD,
>  };
>  
>  static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
> @@ -3669,6 +3670,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  		vcpu->arch.msr_misc_features_enables = data;
>  		break;
> +#ifdef CONFIG_X86_64
> +	case MSR_IA32_XFD:
> +		if (!msr_info->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
> +			return 1;
> +
> +		if (data & ~(XFEATURE_MASK_USER_DYNAMIC &
> +			     vcpu->arch.guest_supported_xcr0))
> +			return 1;
> +
> +		fpu_update_guest_xfd(&vcpu->arch.guest_fpu, data);
> +		break;
> +#endif
>  	default:
>  		if (kvm_pmu_is_valid_msr(vcpu, msr))
>  			return kvm_pmu_set_msr(vcpu, msr_info);
> @@ -3989,6 +4003,15 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_K7_HWCR:
>  		msr_info->data = vcpu->arch.msr_hwcr;
>  		break;
> +#ifdef CONFIG_X86_64
> +	case MSR_IA32_XFD:
> +		if (!msr_info->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
> +			return 1;
> +
> +		msr_info->data = vcpu->arch.guest_fpu.fpstate->xfd;
> +		break;
> +#endif
>  	default:
>  		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>  			return kvm_pmu_get_msr(vcpu, msr_info);
> @@ -6422,6 +6445,10 @@ static void kvm_init_msr_list(void)
>  			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>  				continue;
>  			break;
> +		case MSR_IA32_XFD:
> +			if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
> +				continue;

I suspect the 32-bit host support is wrong.  The kernel's handle_xfd_event()
checks for 64-bit support in addition to the CPU feature itself, which implies
that the feature can be reported in boot_cpu_data for 32-bit kernels.

  static bool handle_xfd_event(struct pt_regs *regs)
  {
	u64 xfd_err;
	int err;

	if (!IS_ENABLED(CONFIG_X86_64) || !cpu_feature_enabled(X86_FEATURE_XFD))
		return false;

	...
  }

In this specific case, that means KVM will tell userspace it needs to mgirate
MSR_IA32_XFD, and then reject attempts to read/write the MSR.

If 32-bit host kernels do not explicitly suppress X86_FEATURE_XFD, then KVM needs
to do:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 556555537a18..156ce332d55b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -455,9 +455,11 @@ void kvm_set_cpu_caps(void)
 #ifdef CONFIG_X86_64
        unsigned int f_gbpages = F(GBPAGES);
        unsigned int f_lm = F(LM);
+       unsigned int f_xfd = F(XFD);
 #else
        unsigned int f_gbpages = 0;
        unsigned int f_lm = 0;
+       unsigned int f_xfd = 0;
 #endif
        memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));

@@ -545,7 +547,7 @@ void kvm_set_cpu_caps(void)
        );

        kvm_cpu_cap_mask(CPUID_D_1_EAX,
-               F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | F(XFD)
+               F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
        );

        kvm_cpu_cap_init_scattered(CPUID_12_EAX,

> +			break;
>  		default:
>  			break;
>  		}
