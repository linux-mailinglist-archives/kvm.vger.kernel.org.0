Return-Path: <kvm+bounces-50696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33052AE85E5
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:14:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBC283B1746
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062B325C80E;
	Wed, 25 Jun 2025 14:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yjW1yDU6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12FF263F27
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750860812; cv=none; b=MX9MbT6wFuI9gAM/Un/FjjsIIlclJpH2/sDT/qdVb3qSKiifQQrc2w6v36sZUuymGmps1BQ1g2AuIyXwlO174U8tlP4kiQUx33RybEsQXP7NUmmH5YPHOxwxAwG+7yQUVH4ycquHbkBA1oBDV95pd7u+5fgcj5dwyUiSi1gAg7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750860812; c=relaxed/simple;
	bh=3Lx4YfF4E+0D+54sATNPIVi3En98iogOQUwpK6T1l30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=exRQnZZOrTxuzUNn51du59nSZhXb7uf2T2BRWMtEQQZ8VapjEn8+Mey1McjgazMLbpBzSYQH7kfz+RUTG+28++Fr/j3bu7DQ1oBHRD0GnwcQIm9NzGGycUaQPEoZKgCvvvBhi/uAZZCXFZWDNpo774diSysvQnVDcdVfty5sTrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yjW1yDU6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3122368d82bso9611109a91.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750860810; x=1751465610; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e3vFMQxozFim60Z7x8xtgxJzxh5+7L1wLR4WIqGJudk=;
        b=yjW1yDU6rnRyDY4KpemhelVafl4+SX6aHWFnx+vAceXUyD4uKCbcwKDWCCoC04HbBA
         JFE5zPt0EkhdPOaw6ifL25OWbiS08qxMavqyYfd1GeYIUQAVpVfPq7VbSnOrgKJC6SBy
         guNPNWfYfhYMd8nwJYYagt5XkF1igjrA+6wgRFJXHfcoKGo0jIzsiUOKMvqq6Rteg/gU
         6iAq8G6XqCpt4E1s/uYXrPGAiwuqpy3ZA2kru6ZzdB1BQzycb341Z3tQlhHX1q5TsObM
         8vDu91I9j4fxcCLWtR+Ir/1hxdwtdlcwjSeSCNWhYvoVH5m0PCorMcyLghFevwaryawU
         ssEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750860810; x=1751465610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e3vFMQxozFim60Z7x8xtgxJzxh5+7L1wLR4WIqGJudk=;
        b=jw/2btnNn8zdR5XzLb4ap14NBO7sapCcGfCUEk0yWKFndmoQ1i9OamMDmPXraUnHYp
         Ir4j0SSCARLK3ZloLTRGgY+hheUw9z7qalzOuxFHSW7C6aH8Dc1NDwMv/4P22r+oHNIp
         hJ1joY2/rYHvmzmtR/yNLLj+H7r3mo3+nXk+av85q5PZt8y0bWYDs3+x5yfvJ0ZMtTph
         TGE4yq7vrieoUDRRp0yrNNrXsauJqK3oxSD1f2x29Je/v51krqLVtFeRBGyLCQmPO9K5
         44HArK+Zt7u2WM8+RZqPa2PgXXdKCWHj1veQuW9DxqG9sFc8VKsxTcY3R2r/jq06yBGx
         hPnA==
X-Forwarded-Encrypted: i=1; AJvYcCV1pkHX5zreLmfNxC1L8mhRb76qW6pyIuJa8xU0S2DWicL0mm14x8YixDIfezBf/uvFVqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJO1fVGbKHTEGjem0W+8aB9Lav2P7iy5EAyv3IvNFCUtL2DeGk
	Eh/TIl639hGnAVqVvFMiWSjjaukZROsnbuSATaMfODJiYe9ip6pkm6DH2IEPcZW7bYxW3rGc9rL
	ceybi2Q==
X-Google-Smtp-Source: AGHT+IHJFUHfCE0NwqZe4TsTTpwGATMcI2FSbsq0ZxT2x22+L8XKwmw+hxPSBIqeGkjjCkAVFudqIjTxflw=
X-Received: from pjbpv1.prod.google.com ([2002:a17:90b:3c81:b0:313:2d44:397b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1646:b0:311:fde5:c4b6
 with SMTP id 98e67ed59e1d1-315f25ca80dmr4343285a91.6.1750860810035; Wed, 25
 Jun 2025 07:13:30 -0700 (PDT)
Date: Wed, 25 Jun 2025 07:13:28 -0700
In-Reply-To: <20250408093213.57962-4-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250408093213.57962-1-nikunj@amd.com> <20250408093213.57962-4-nikunj@amd.com>
Message-ID: <aFwECPca4SbV916d@google.com>
Subject: Re: [PATCH v6 3/4] KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC
 enabled guests
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com, 
	vaishali.thakkar@suse.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 08, 2025, Nikunj A Dadhania wrote:
> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
> guests. Disable interception of this MSR when Secure TSC is enabled. Note
> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
> hypervisor context.
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Tested-by: Vaishali Thakkar <vaishali.thakkar@suse.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  1 +
>  arch/x86/kvm/svm/sev.c     |  3 +++
>  arch/x86/kvm/svm/svm.c     |  1 +
>  arch/x86/kvm/svm/svm.h     | 11 ++++++++++-
>  4 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 9b7fa99ae951..6ab66b80e751 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -290,6 +290,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>  #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
> +#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
>  
>  struct vmcb_seg {
>  	u16 selector;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0bc708ee2788..50263b473f95 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4504,6 +4504,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  	/* Clear intercepts on selected MSRs */
>  	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
>  	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
> +
> +	if (snp_secure_tsc_enabled(vcpu->kvm))
> +		set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_GUEST_TSC_FREQ, 1, 1);
>  }
>  
>  void sev_init_vmcb(struct vcpu_svm *svm)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8abeab91d329..e65721db1f81 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -143,6 +143,7 @@ static const struct svm_direct_access_msrs {
>  	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> +	{ .index = MSR_AMD64_GUEST_TSC_FREQ,		.always = false },
>  	{ .index = MSR_INVALID,				.always = false },
>  };
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d4490eaed55d..711e21b7a3d0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned long pa)
>  #define	IOPM_SIZE PAGE_SIZE * 3
>  #define	MSRPM_SIZE PAGE_SIZE * 2
>  
> -#define MAX_DIRECT_ACCESS_MSRS	48
> +#define MAX_DIRECT_ACCESS_MSRS	49
>  #define MSRPM_OFFSETS	32
>  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
> @@ -377,10 +377,19 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
>  	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
>  	       !WARN_ON_ONCE(!sev_es_guest(kvm));
>  }
> +
> +static inline bool snp_secure_tsc_enabled(struct kvm *kvm)

This is only ever used in sev.c, it has no business living in svm.c.  And there's
especially no reason to have a stub for CONFIG_KVM_AMD_SEV=n.
> +{
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> +
> +	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
> +		!WARN_ON_ONCE(!sev_snp_guest(kvm));
> +}
>  #else
>  #define sev_guest(kvm) false
>  #define sev_es_guest(kvm) false
>  #define sev_snp_guest(kvm) false
> +#define snp_secure_tsc_enabled(kvm) false
>  #endif
>  
>  static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
> -- 
> 2.43.0
> 

