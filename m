Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE14D4BA5AE
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 17:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243069AbiBQQWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 11:22:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243068AbiBQQWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 11:22:48 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD52D25BD4D
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:22:32 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 139so5473078pge.1
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ec42Otu6+sjdPXI3KGI3rQvxSUQHItE2qw3K/D5yq80=;
        b=C+KhRCt70LCkeJgyEZP8gPt1pmo34vq7Uu+uGBobRJ29DMWrUcvyoAt4TFjJeW5h/B
         xCgELViGwqyKwiFXKAEunsgJISevLRfHmDLf0MV7n4CtMT5jHyYcR/EaO92HlpX5ApEM
         8QbACXhPeuFsGfF0PWT7KX0pE9sjC8plwaFN9w7YsJ49bRS1zlVDlajEMH6Pv+fCqhsj
         CwbLfNoa+fwCwkDGX5Dn5iL/2eiQ7xlLirI5o3OY03+Mb2zKp8UxQvxizHO0W911pHHX
         nDrjVW4DRyOUPadbuejSCIon8MSYILOUL/MjwXGC/n7SkCN3Ns+ALF0SRoGgBmm2Gq78
         JGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ec42Otu6+sjdPXI3KGI3rQvxSUQHItE2qw3K/D5yq80=;
        b=CGYijEWFLvR/ruFSJh+Z7IyNvlGpq5ZSK+01HwAMUcbjrZF1CweCn/nK8ZId7e2s2n
         KzMNkT8flEP4iaoaKT+QESFVf+DkMaFhEtgQNkrRjL8ibiCfhPMrN41qYmBj8dcCRpsJ
         YnbxJGXvSwMeA5ckArtjI+doricSW+fkI4wykyq33eTUAvF5GHDfAsLK+JyWAflGiCoO
         tsZR1wCBuUiHMwN9PYOb3eH3Tcg4ANrTh658E9pPEDhgRhEAOj3jU5lhACSz1NR0TGhV
         Pz6uZ7RLZ2p4WRM6NqesE0D7nXDJQcWXkZ4+yhe2wJOUxM9byiLnusiEcjj/JVAyDl5D
         IdYA==
X-Gm-Message-State: AOAM532eKPv7DwkZd+0tn7jZPbcxE/T6nrwbpnGR/3+58+b8/3ZL3T/H
        6x4bzbfqh+8vRVuuAOHNhQtcuw==
X-Google-Smtp-Source: ABdhPJydJPj2l1AR1/ffaP70IcBUaztXfVOLWKC6FMzkHBR8SI6RUDgEbCGVlq+OkA9Lj4EHnQSSyA==
X-Received: by 2002:a63:4809:0:b0:365:1426:8702 with SMTP id v9-20020a634809000000b0036514268702mr3008276pga.170.1645114952095;
        Thu, 17 Feb 2022 08:22:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k62sm8519664pga.86.2022.02.17.08.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 08:22:31 -0800 (PST)
Date:   Thu, 17 Feb 2022 16:22:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Dunn <daviddunn@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 1/3] KVM: x86: Provide per VM capability for disabling
 PMU virtualization
Message-ID: <Yg52RP+hzIVaNAas@google.com>
References: <20220215014806.4102669-1-daviddunn@google.com>
 <20220215014806.4102669-2-daviddunn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215014806.4102669-2-daviddunn@google.com>
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

On Tue, Feb 15, 2022, David Dunn wrote:
> Add a new capability, KVM_CAP_PMU_CAPABILITY, that takes a bitmask of
> settings/features to allow userspace to configure PMU virtualization on
> a per-VM basis.  For now, support a single flag, KVM_CAP_PMU_DISABLE,
> to allow disabling PMU virtualization for a VM even when KVM is configured
> with enable_pmu=true a module level.
> 
> To keep KVM simple, disallow changing VM's PMU configuration after vCPUs
> have been created.
> 
> Signed-off-by: David Dunn <daviddunn@google.com>
> ---

A few nits, otherwise

Reviewed-by: Sean Christopherson <seanjc@google.com>

Somewhat off-topic, looking at this got me looking at vmx_get_perf_capabilities().
We really should cache the result of its RDMSR.

And I believe emulation of WRMSR from the guest to MSR_IA32_PERF_CAPABILITIES is
missing a guest_cpuid_has() check.

>  Documentation/virt/kvm/api.rst  | 22 ++++++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm/pmu.c          |  2 +-
>  arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
>  arch/x86/kvm/x86.c              | 17 +++++++++++++++++
>  include/uapi/linux/kvm.h        |  3 +++
>  tools/include/uapi/linux/kvm.h  |  3 +++
>  7 files changed, 48 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a4267104db50..df836965b347 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7561,3 +7561,25 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
>  of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
>  the hypercalls whose corresponding bit is in the argument, and return
>  ENOSYS for the others.
> +
> +8.35 KVM_CAP_PMU_CAPABILITY
> +---------------------------
> +
> +:Capability KVM_CAP_PMU_CAPABILITY
> +:Architectures: x86
> +:Type: vm
> +:Parameters: arg[0] is bitmask of PMU virtualization capabilities.

Referring to "DISABLE" as a capabilitiy is rather odd, but I don't have a better
suggestion.

> +:Returns 0 on success, -EINVAL when arg[0] contains invalid bits
> +
> +This capability alters PMU virtualization in KVM.
> +
> +Calling KVM_CHECK_EXTENSION for this capability returns a bitmask of
> +PMU virtualization capabilities that can be adjusted on a VM.
> +
> +The argument to KVM_ENABLE_CAP is also a bitmask and selects specific
> +PMU virtualization capabilities to be applied to the VM.  This can
> +only be invoked on a VM prior to the creation of VCPUs.
> +
> +At this time, KVM_CAP_PMU_DISABLE is the only capability.  Setting
> +this capability will disable PMU virtualization for that VM.  Usermode
> +should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 10815b672a26..61e9050a3488 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1233,6 +1233,7 @@ struct kvm_arch {
>  	hpa_t	hv_root_tdp;
>  	spinlock_t hv_root_tdp_lock;
>  #endif
> +	bool enable_pmu;

Doesn''t really matter, but I'd prefer we put this up among the many other bools, e.g.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4bb0d3be2055..b57d40419ddd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1150,6 +1150,7 @@ struct kvm_arch {
        bool guest_can_read_msr_platform_info;
        bool exception_payload_enabled;
 
+       bool enable_pmu;
        bool bus_lock_detection_enabled;
        /*
         * If exit_on_emulation_error is set, and the in-kernel instruction
@@ -1233,7 +1234,6 @@ struct kvm_arch {
        hpa_t   hv_root_tdp;
        spinlock_t hv_root_tdp_lock;
 #endif
-       bool enable_pmu;
 };
 
 struct kvm_vm_stat {

>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 5aa45f13b16d..d4de52409335 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -101,7 +101,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>  {
>  	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
>  
> -	if (!enable_pmu)
> +	if (!vcpu->kvm->arch.enable_pmu)
>  		return NULL;
>  
>  	switch (msr) {
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 03fab48b149c..4e5b1eeeb77c 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -487,7 +487,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	pmu->reserved_bits = 0xffffffff00200000ull;
>  
>  	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
> -	if (!entry || !enable_pmu)
> +	if (!entry || !vcpu->kvm->arch.enable_pmu)
>  		return;
>  	eax.full = entry->eax;
>  	edx.full = entry->edx;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eaa3b5b89c5e..0803a1388bbf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -110,6 +110,8 @@ static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
>  
>  #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
>  
> +#define KVM_CAP_PMU_VALID_MASK KVM_CAP_PMU_DISABLE
> +
>  #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
>                                      KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
>  
> @@ -4331,6 +4333,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		if (r < sizeof(struct kvm_xsave))
>  			r = sizeof(struct kvm_xsave);
>  		break;
> +	case KVM_CAP_PMU_CAPABILITY:
> +		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
> +		break;
>  	}
>  	default:
>  		break;
> @@ -6005,6 +6010,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		kvm->arch.exit_on_emulation_error = cap->args[0];
>  		r = 0;
>  		break;
> +	case KVM_CAP_PMU_CAPABILITY:
> +		r = -EINVAL;
> +		if (!enable_pmu || (cap->args[0] & ~KVM_CAP_PMU_VALID_MASK))
> +			break;

I'd prefer another newline here, the other case statements are just bad influences :-)

> +		mutex_lock(&kvm->lock);
> +		if (!kvm->created_vcpus) {
> +			kvm->arch.enable_pmu = !(cap->args[0] & KVM_CAP_PMU_DISABLE);
> +			r = 0;
> +		}
> +		mutex_unlock(&kvm->lock);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
