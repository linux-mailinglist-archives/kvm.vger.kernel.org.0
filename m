Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC42667F08C
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 22:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjA0Vmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 16:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjA0Vmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 16:42:43 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBCF1C5AB
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:42:41 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id g9so2106800pfk.13
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0d6n6AuTepafE8zRxy7R/0YUNfUjkxK2wRxr8ePG2TQ=;
        b=Xd70rP95v9OOS8VZ/k+iLrWA61DJSoLEWwTfHLmKtArj4JixnNl/00BMvWM37/4e+q
         zGYB8Qmj7+tqiBw/oie2xjCoKmJOV4JLfcRpzTN1rJwKPa420g1lyElw9YfS0VV3bh5n
         YxeNAf6j2ugwdK5SUsUm16EANlytaNu7GucQ2LEe5EozOKNuxeSmK2/3Bcf9W61yKC5r
         X9uHCqNIqzxTedojEN8KcjAi8z6eDqGBz/yOpoehWCRX0wNawVwTSkFa8zbKArGD7Wy4
         K4H3c9nhbChl8jEbqQdVpQ4v1gsTkCEQBne//T6X46bRuNh3i8YFC+xoOXD9pmM8/NFq
         GLFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0d6n6AuTepafE8zRxy7R/0YUNfUjkxK2wRxr8ePG2TQ=;
        b=tu7eHyU70Psa5j816B9KU9JQul9m+FlyFeOY1gcAMeVd6sQEaHwFRWbWT3QL3Kp3or
         WVwl98j0K6p5OSxATVm9coSSyF1UkW9HRPor4Fk+aK75EzwQeu4UEFRSL6WaiXau7R8q
         gWudqY1yw8r3MAPX/ufd8m1wxJ5Fi6LMctrRKsQlstr6sqoHxP/UzahHM0iGgFaqIr49
         zx5BHE/s9gUkD13lSydbJe7IEVDJcHWSY3bOlpMEjEpMP0iajVdKYvIZqWTwRFndPxzL
         PKRKXfjRTQ7ruy/YlM7MUcZc9cqrDbwiYaBMtXbXTWK3QPGjWYinty5Jo6ewkiM3FLGV
         uBOA==
X-Gm-Message-State: AO0yUKXCJUUgX/clGwyxbaWZuTsEQkZ6zqgvQfjqDa8XyN8+aFyGNEkC
        vzzkRdj4XhaBaMQu5zX5YkqO2RdxnQVD/5v0+UI=
X-Google-Smtp-Source: AK7set8ixdj3l9QJrIJEUtMxmDMBJN5pHM3X69PpntwQqq16lvP6YGflFCI+1AxN2EQZal+YPsNxaw==
X-Received: by 2002:a05:6a00:1884:b0:581:bfac:7a52 with SMTP id x4-20020a056a00188400b00581bfac7a52mr131735pfh.1.1674855761263;
        Fri, 27 Jan 2023 13:42:41 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f186-20020a62dbc3000000b0058a72925687sm3040476pfg.212.2023.01.27.13.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 13:42:40 -0800 (PST)
Date:   Fri, 27 Jan 2023 21:42:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v2 06/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for
 guest Arch LBR
Message-ID: <Y9RFTUqdS05WBCaW@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-7-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125040604.5051-7-weijiang.yang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022, Yang Weijiang wrote:
> @@ -345,6 +346,30 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool arch_lbr_ctl_is_valid(struct kvm_vcpu *vcpu, u64 ctl)
> +{
> +	struct kvm_cpuid_entry2 *entry;
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	if (!pmu->kvm_arch_lbr_depth)
> +		return false;
> +
> +	if (ctl & ~KVM_ARCH_LBR_CTL_MASK)
> +		return false;
> +
> +	entry = kvm_find_cpuid_entry(vcpu, 0x1c);

Why!?!?!  Why does this series reinvent the wheel so many times.  We already have
a huge pile of reserved bits masks that are computed in intel_pmu_refresh(), just
do the easy thing and follow the established pattern.

> +	if (!entry)
> +		return false;
> +
> +	if (!(entry->ebx & BIT(0)) && (ctl & ARCH_LBR_CTL_CPL))
> +		return false;
> +	if (!(entry->ebx & BIT(2)) && (ctl & ARCH_LBR_CTL_STACK))
> +		return false;
> +	if (!(entry->ebx & BIT(1)) && (ctl & ARCH_LBR_CTL_FILTER))
> +		return false;
> +	return true;
> +}
> +
>  static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -377,6 +402,14 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_ARCH_LBR_DEPTH:
>  		msr_info->data = lbr_desc->records.nr;
>  		return 0;
> +	case MSR_ARCH_LBR_CTL:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {

So I assume the point of this code is to allow reading MSR_ARCH_LBR_CTL from
userspace before doing KVM_SET_CPUID2, but I would much rather do that in a
generic way, i.e. build this series on 
https://lore.kernel.org/all/20230124234905.3774678-7-seanjc@google.com

> +			WARN_ON_ONCE(!msr_info->host_initiated);
> +			msr_info->data = 0;
> +		} else {
> +			msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
> +		}
> +		return 0;
>  	default:
>  		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>  		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -483,6 +516,18 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>  			wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
>  		return 0;
> +	case MSR_ARCH_LBR_CTL:
> +		if (msr_info->host_initiated && !pmu->kvm_arch_lbr_depth)
> +			return data != 0;
> +
> +		if (!arch_lbr_ctl_is_valid(vcpu, data))
> +			break;
> +
> +		vmcs_write64(GUEST_IA32_LBR_CTL, data);
> +		if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
> +		    (data & ARCH_LBR_CTL_LBREN))
> +			intel_pmu_create_guest_lbr_event(vcpu);
> +		return 0;
>  	default:
>  		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>  		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -727,12 +772,16 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
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
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> +		lbr_ctl_field = GUEST_IA32_LBR_CTL;

Similar to other comments, just rely on KVM not allowing LBRs to be enabled unless
the guest is configured with the correct flavor.

> +
> +	vmcs_write64(lbr_ctl_field, vmcs_read64(lbr_ctl_field) & ~0x1ULL);

Open coding a bit just because it happens to be in the same position in both fields
is ridiculous.

	u64 debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);

	if (!debugctl & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI))
		return;

	if (cpu_feature_enabled(X86_FEATURE_ARCH_LBR))
		vmcs_clear_bits64(GUEST_IA32_LBR_CTL, ARCH_LBR_CTL_LBREN);
	else
		vmcs_write64(GUEST_IA32_DEBUGCTL, debugctl & ~DEBUGCTLMSR_LBR);

>  }
>  
>  static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
> @@ -801,7 +850,8 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> -	bool lbr_enable = !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
> +	bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
> +		(vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
>  		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
>  
>  	if (!lbr_desc->event) {
> @@ -829,7 +879,8 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>  
>  static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>  {
> -	bool lbr_enable = !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
> +	bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
> +		(vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
>  		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);

Instead of open coding the same ugly ternary operator in multiple locations, add
a helper.

>  
>  	if (!lbr_enable)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cea8c07f5229..1ae2efc29546 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2120,6 +2120,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  						VM_EXIT_SAVE_DEBUG_CONTROLS)
>  			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
>  
> +		/*
> +		 * For Arch LBR, IA32_DEBUGCTL[bit 0] has no meaning.
> +		 * It can be written to 0 or 1, but reads will always return 0.
> +		 */
> +		if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))

This can be dependent solely on the host CPU.  If LBRs are unsupported, the bit
will be marked invalid and cleared above.  And as mentioned multiple times, KVM
needs to allow enabling LBRs iff the guest and host flavors match.

> +			data &= ~DEBUGCTLMSR_LBR;

This needs to be done before shoving the value into vmcs12.

> +
>  		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>  		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
>  		    (data & DEBUGCTLMSR_LBR))
> -- 
> 2.27.0
> 
