Return-Path: <kvm+bounces-6837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 876C783ADC4
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 16:52:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36AA12832A3
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 15:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1171D7CF03;
	Wed, 24 Jan 2024 15:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DTr4vU6R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24D48F72
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 15:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706111525; cv=none; b=M2pL29WGbj0wajFuCFnuJ7DambGVXYfUkSd+6ItVzPZLqyS80+YC2qcUsEch0M2/4i2iYhG6Pb8j35nvcjWTULoZxEBnr6ykxcpYyQdukNP/7O8CkmWwmC/fhHsI7q7orgGKKfSMU3Z84E3pvKzZFhXRvzoAAWTT+7DdcWc2Tdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706111525; c=relaxed/simple;
	bh=5+Q9qegyLCxY0GbcvM7XUveJWPKwcWJO2IzqTLRRZgw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AEDlrmWCeC2/VNvoZLnds0VV9w95Bm7Q9J+JQhu5vtWz8NUkQzClo4hJLuUA2vHkxgtsYImWiQEPmmrXdnTwWqnCpGtoiZn+theniz8TMTv6w1d+p/dkB5nqR9u3L3Buw2beMYZvfKX9yrc59TkKRVJPuEAkoqZLrLWg0TyeTAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DTr4vU6R; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cf555b2a53so5152087a12.1
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706111523; x=1706716323; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=15Smc0I6laySZAADKXNgIBqIeb7i2uujkD5rSgymC8s=;
        b=DTr4vU6RO6AFXvf83Dj2G+3QNxvfBswkvordcCFneFZbUMiKetv8feadH+RrJC0Bnh
         umGf5yz/CzdSdiCHFD2qA/xO8wBR78t/d+OfpU4WUVqPFEWkxMiBez8fJqtz6/7GTn9a
         eso+rcvcywZBLL20O1SpL/09UQq/azwDmGhc4w3yyaY2snVctfQAwLGF301Kz1LvgGcT
         gkMoVkWUtTrvl+9iy0k782BYgK9mpInl+2noZHI26jFsKaxlh8SM58E28gfAnzeK0fF6
         dzXevOt0CPkSJDnOfRpZTdyYHadW+mQQTDrP1yZeVfBSGk9UgIPG9wbYLDHKtoerGs2l
         QE6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706111523; x=1706716323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=15Smc0I6laySZAADKXNgIBqIeb7i2uujkD5rSgymC8s=;
        b=jDS5xP6VSmSOJex43zLMPygxBNBCCQIgm/2qwZD+116X/SZ7bGK4iV+SOO/Qsb5/fE
         a7h2hLEXxq8TQy/E5h4p4VM+3jB7KF7oDSYnSdTk1h7+KJaxBxUG1JQRc+tFViPfM6jd
         zRx0PpJq+tHmUqN2tIAilGDgVsDRDCQxpcDODv5TtssqsWJS6D/LzWfh661w4Shaz0SE
         D2A4xhtScPwPXd5N0VT2Ona/qnFD1lgKa7CuQ91uZxT3OphHvdQpZ6jD/GJRwXPIEJAm
         u72gvnXpdK0ZRske5oMTX2n2Hj3kNtQ8ElOOccftW0n+z1mq6aN9MLj+FHl6stCRGcCY
         GRVw==
X-Gm-Message-State: AOJu0YzVFvBDDA0dSvV9r/Xw7gba0VimdvuY+TW6l1Y0qVcRII7r8B3I
	sj98tCq3C2Xb3Xd/jt2ZaVCYMjNjHlhxjXEwllR8Vth6JczlZ1nGzou+Fl0qpCxgOuZIeu2kGEi
	JjA==
X-Google-Smtp-Source: AGHT+IEm8QG2D/bn95OntQyOSaO/bdQ/ceRpMS5AfsxeuT2dftWSyU0cgv4uy/fSf5IheAZbnrQ7rDLmbKk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:be18:b0:290:f8b6:558e with SMTP id
 a24-20020a17090abe1800b00290f8b6558emr5886pjs.1.1706111522090; Wed, 24 Jan
 2024 07:52:02 -0800 (PST)
Date: Wed, 24 Jan 2024 07:52:00 -0800
In-Reply-To: <20240124003858.3954822-3-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240124003858.3954822-1-mizhang@google.com> <20240124003858.3954822-3-mizhang@google.com>
Message-ID: <ZbEyIM41MGYTXcK_@google.com>
Subject: Re: [PATCH 2/2] KVM: x86/pmu: Remove vcpu_get_perf_capabilities()
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 24, 2024, Mingwei Zhang wrote:
> Remove vcpu_get_perf_capabilities() helper and directly use the
> vcpu->arch.perf_capabilities which now contains the true value of
> IA32_PERF_CAPABILITIES if exposed to guest (and 0 otherwise). This should
> slightly improve performance by avoiding the runtime check of
> X86_FEATURE_PDCM.

I have a generic in-progress series[*] to more or less solve the performance woes
with guest_cpuid_has().  I would rather keep the current code, even though it's
somewhat odd, as it's possible there are setups that rely on KVM checking PDCM.
E.g. if userspace sets MSRs *after* CPUID and plugs in a non-zero PERF_CAPABILITES.

[*] https://lore.kernel.org/all/20231110235528.1561679-1-seanjc@google.com

> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index a6216c874729..7cbee2d16ed9 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -158,17 +158,9 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
>  	return &counters[array_index_nospec(idx, num_counters)];
>  }
>  
> -static inline u64 vcpu_get_perf_capabilities(struct kvm_vcpu *vcpu)
> -{
> -	if (!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
> -		return 0;
> -
> -	return vcpu->arch.perf_capabilities;
> -}
> -
>  static inline bool fw_writes_is_enabled(struct kvm_vcpu *vcpu)
>  {
> -	return (vcpu_get_perf_capabilities(vcpu) & PMU_CAP_FW_WRITES) != 0;
> +	return (vcpu->arch.perf_capabilities & PMU_CAP_FW_WRITES) != 0;
>  }
>  
>  static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
> @@ -207,13 +199,13 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>  	case MSR_CORE_PERF_FIXED_CTR_CTRL:
>  		return kvm_pmu_has_perf_global_ctrl(pmu);
>  	case MSR_IA32_PEBS_ENABLE:
> -		ret = vcpu_get_perf_capabilities(vcpu) & PERF_CAP_PEBS_FORMAT;
> +		ret = vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT;
>  		break;
>  	case MSR_IA32_DS_AREA:
>  		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
>  		break;
>  	case MSR_PEBS_DATA_CFG:
> -		perf_capabilities = vcpu_get_perf_capabilities(vcpu);
> +		perf_capabilities = vcpu->arch.perf_capabilities;
>  		ret = (perf_capabilities & PERF_CAP_PEBS_BASELINE) &&
>  			((perf_capabilities & PERF_CAP_PEBS_FORMAT) > 3);
>  		break;
> @@ -577,7 +569,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	bitmap_set(pmu->all_valid_pmc_idx,
>  		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
>  
> -	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
> +	perf_capabilities = vcpu->arch.perf_capabilities;
>  	if (cpuid_model_is_consistent(vcpu) &&
>  	    (perf_capabilities & PMU_CAP_LBR_FMT))
>  		x86_perf_get_lbr(&lbr_desc->records);
> -- 
> 2.43.0.429.g432eaa2c6b-goog
> 

