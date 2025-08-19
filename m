Return-Path: <kvm+bounces-55030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A0DB2CC0E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 20:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D728620AA5
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 18:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F90A266580;
	Tue, 19 Aug 2025 18:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s/rkmcWp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408D11CA84
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 18:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755628296; cv=none; b=qPX3aD/d10myguTSuWdxTkkr7nWnRZD07qoZ01sx9SGHO9FORKJDHceehy2H3/FHlOTndNpoA5urUFLkrP2hrhGc42hkpLtwkqNkM8KrprI6h9DbG66qEton03Ar2ZRMsiK1PVMANRUSU4YVy9XqPGymyLHJcKJg8oB3Gzp0hGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755628296; c=relaxed/simple;
	bh=FE+BN6LjNerPXRHgBqS2Ez17EMLb3CBEEycmzjisUDI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t/OgIaidhJQ/wkoK9HCcaAL59P8yDMNWUnaHQg71opmFwxuYBlJ+mLtqR5oaeEF1fXvtIzO65nA+p8jMGXGw7mZg1+c9R4zYq6tQd/O+nLIU0Vx9SZM2amQZQUI49ZCz3dAl+kCZgoQAdF03xCK+qoJFTne2BBcblTTjH0PvwD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s/rkmcWp; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-244581ce13aso114798535ad.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 11:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755628294; x=1756233094; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CFNNkQYjnYLgd8xADJLc6v9c/H2C2oVnrzthJVOhtI8=;
        b=s/rkmcWplnUvns4inLXTvs2ge1sPGsaogHE2bwyI2N/S9dFzQpbR+bpdK4hlhZ6wCC
         MNfBrGsS2YqWyJfePpNBW928qu9WMgK9VEvDMJD/4HxTW8I7vFj/H3VrmMloVVIik7iQ
         G1ngjQilh2nXdZZWstKSri2AcJVE3ek7FpmYj+sODZ7tEkol6xazVxHVlH0cxym+cPN9
         v3Axd2wRnumr3sxIgCAfLOhyoiAU6b0bm/xY3pMy8XuPZchpGc0sTZRucLDovMGZN2i/
         ud1W1TRDqoRbIVIsIEukj06YyrEPlGBYyyzgJlV0b+YX5Uj/TL3VvomTZK5E6I12B1P+
         YWmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755628294; x=1756233094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CFNNkQYjnYLgd8xADJLc6v9c/H2C2oVnrzthJVOhtI8=;
        b=hoxgm5d1VisAuxkdSsgLQvDfq1XXj8NJL8GYh1UIBJ0zWt7Q7sfNor8swmZ8t4ILB0
         36VpeK2BYVUvREpgpZ59rnyuExz/l+2YdE+9NGy+6rWoyxxQUYGiM81GOgV3sji9OeS4
         aXyPoLPCGLXAO1pLVAMv9kYqfWGFL5F1g0puNMVY6LC3uMMaJAtsIMQ1rRs5FoXaWMh7
         L43fa4ifpD2qpYvc6aSH1i2V4FmGhAnla3bdz+kdR05/Vl4/bPJfalC1QpWKY67exTd/
         pzUreg7aTO1Y8hUZveYSNVuc6U6iSZ0V7idu5bpu+vfYjr76yaukV+yP4rvRsHrDStod
         2pYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhxdHmxDPgadUQEDcHYgqRHkTc4shc7lUkGtO5Tk3zDt2q4cWwOEKNNrMiczBrwC13hhU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7d7KqYmRg63bw98o0ezqT/LaVe0djzV1INRJ1zDaRRVxV/Bv0
	g914Qi6M4wAsi2QnZoG9zTriRJjFE/4zEjENznh1D4mF2w9gmHX/lRKy2UmopvqonI/o2ZRwQbl
	gZ+Si9w==
X-Google-Smtp-Source: AGHT+IEDg1kaCLKoFxeqzpHElS+/odpD96HAvM0fcSQ167yZRCgA4vG6C1GJlLZudaOwRY5bqjrqKCaz2EM=
X-Received: from pjbcz14.prod.google.com ([2002:a17:90a:d44e:b0:31f:28cf:d340])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce8e:b0:240:5c38:7544
 with SMTP id d9443c01a7336-245e04eae52mr40059805ad.50.1755628294529; Tue, 19
 Aug 2025 11:31:34 -0700 (PDT)
Date: Tue, 19 Aug 2025 11:31:32 -0700
In-Reply-To: <20250804103751.7760-3-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250804103751.7760-1-nikunj@amd.com> <20250804103751.7760-3-nikunj@amd.com>
Message-ID: <aKTDBMCPxOXQhzDq@google.com>
Subject: Re: [PATCH v10 2/2] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com, 
	vaishali.thakkar@suse.com, kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 04, 2025, Nikunj A Dadhania wrote:
> Add support for Secure TSC, allowing userspace to configure the Secure TSC
> feature for SNP guests. Use the SNP specification's desired TSC frequency
> parameter during the SNP_LAUNCH_START command to set the mean TSC
> frequency in KHz for Secure TSC enabled guests.
> 
> Always use kvm->arch.arch.default_tsc_khz as the TSC frequency that is
> passed to SNP guests in the SNP_LAUNCH_START command.  The default value
> is the host TSC frequency.  The userspace can optionally change the TSC
> frequency via the KVM_SET_TSC_KHZ ioctl before calling the
> SNP_LAUNCH_START ioctl.
> 
> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
> guests. Disable interception of this MSR when Secure TSC is enabled. Note
> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
> hypervisor context.
> 
> Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  1 +
>  arch/x86/kvm/svm/sev.c     | 27 +++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c     |  2 ++
>  arch/x86/kvm/svm/svm.h     |  2 ++
>  4 files changed, 32 insertions(+)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index ffc27f676243..17f6c3fedeee 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -299,6 +299,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>  #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
> +#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
>  
>  #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e88dce598785..f9ab9ecc213f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -146,6 +146,14 @@ static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
>  	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
>  }
>  
> +bool snp_secure_tsc_enabled(struct kvm *kvm)

snp_is_secure_tsc_enabled() to make it super obvious this is a predicate.

> +{
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> +
> +	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
> +		!WARN_ON_ONCE(!sev_snp_guest(kvm));

Align indentation.

> +}
> @@ -4455,6 +4479,9 @@ void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>  					  !guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) &&
>  					  !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID));
>  
> +	if (snp_secure_tsc_enabled(vcpu->kvm))
> +		svm_disable_intercept_for_msr(vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_R);

I'm leaning towards:

	svm_set_intercept_for_msr(vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_R,
				  !snp_is_secure_tsc_enabled(vcpu->kvm));

because the cost of setting a bit is negligible.

> +
>  	/*
>  	 * For SEV-ES, accesses to MSR_IA32_XSS should not be intercepted if
>  	 * the host/guest supports its use.
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d9931c6c4bc6..a81bf83ccb52 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1317,6 +1317,8 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  	svm->guest_state_loaded = false;
>  
> +	vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(vcpu->kvm);

Hmm, we can and should handle this in sev.c.  If we add sev_vcpu_create(), then
we don't need to expose snp_is_secure_tsc_enabled(), and we can move more code
into that helper.

I'll post a combined series of this and the GHCB version patches.

