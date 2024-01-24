Return-Path: <kvm+bounces-6836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC29883ADBA
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 16:49:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8909828B3D7
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 15:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E96897C0BB;
	Wed, 24 Jan 2024 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h8Wd1a8n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0E577F3E
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 15:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706111348; cv=none; b=mgL2/ZfQU7vtMy9zqUlqtu4FmdVm4Ipjub9We6Eau3qaoSBZWcG5XK3nMC1enZ4ta5jCNI3QvPKcfpDjN9Hhn5dw/XsDpmU7siH5Gt93KH1S+E7IYX/c3E1IbJwe+2ZbDMLMGYzOQyCmS1gZH3KuSKj1fQcD22fKH3Xn+DvD3+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706111348; c=relaxed/simple;
	bh=1Yv4ikqQd7y48mZowY0kAcTuLc7mNLCNVy+5tD4cNng=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K6inxu6OgJDmtUPxseDYCZnSgaten4vSejSM/CMBBq0R+hOV0v7C+3iI0DvrAu8rWcQTSr91aO77VtabmXFPR8tTZc17JzwceE+NHNQnkSdPD6ITuaK8A2AOvGpT0QCBTjR3su/9+PJSEcEox+YgIASKtNnrPxTDYP2rYy7IaaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h8Wd1a8n; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ffac5f7afeso66307157b3.0
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706111345; x=1706716145; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qhJ+ztVZsxA/cf/3KD6vJayhy1BZxV4xxk3OB23ybAw=;
        b=h8Wd1a8naWOh/K3PsGF1RaoyP1b66bq+R1YgL5tdG/0j3hxbEC03++lgU39spmPtuU
         idebOzKTZNveym7wg4lx+Rm3j1M1V5B9u507n/5ilqIqe3X8+u3MsNUlQeRMvZzyfaR3
         IaWsnG+zZR/4efbV4aiWDsdSfcmJsjRz3YIyYjuRRmGP11WmRPs49FSeEUJYMm2jPeom
         m0mPeEXGe/CL7mY54VVwjwXt++nfGb8jVOlSoos73/Yer56CeC0StWqDRxZFzwWKSpHy
         WF1IKmQMBunN+n8Gj9A/uAWnd0s4+ETqN7QGYlffsPBbSlsdRZ0Q0RaYq0BDDsB+y3DU
         kFMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706111345; x=1706716145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qhJ+ztVZsxA/cf/3KD6vJayhy1BZxV4xxk3OB23ybAw=;
        b=K8sdqlguBukuBHDS/0Rixz6F0ctJzkgKuyRMScPeOW5Bcxlw4P1pLrUlAWfvQBE0PC
         gwmjQaSP7O+sDLaK/jD2GvBiIgUHyt40rx0q007Fdl/yAyPoVsdV+W2fAsZsrme6DC+V
         bKEGAx3+eXPsai0zHIHnxWIe1j6a7Nx9bJ0ZPPXLLwhKwSHekoi0p2fjo3LeWeytekl1
         9aF/DRENs+iq29s8hnSUh6ZhC/TtyqooXsezBROPD3S3s1T6L6AYLX3ITx8cU8qW3VT1
         KZ+rYMPO7V5t66nimaWjZ+MMiSEZZWllC4AVlQZwQtOWUU5Z8hcaGQEVqlSJ4OpJiSgM
         o0IA==
X-Gm-Message-State: AOJu0YwL8O2lDUYQjmv5yxpXk6UEGeAkSaZgIzWd5I37xYCsBnF/KrFY
	Sgbi4MsHkL1yla5GXLHsMy80sUM1JsAHhvzOTQ8HR+Xl/ksfXAcGAmbLI/XTg87aQbkZi/KvvxV
	gNg==
X-Google-Smtp-Source: AGHT+IGXmCy4698CCi7p+hMLaN15JXQLEy2Ax86x+znGMeuzZHahLmyVrHnb6RQatH3/zrZ+3xkEn+nQ9RE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:a8f:b0:dc2:5237:81c7 with SMTP id
 cd15-20020a0569020a8f00b00dc2523781c7mr460648ybb.3.1706111345676; Wed, 24 Jan
 2024 07:49:05 -0800 (PST)
Date: Wed, 24 Jan 2024 07:49:04 -0800
In-Reply-To: <20240124003858.3954822-2-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240124003858.3954822-1-mizhang@google.com> <20240124003858.3954822-2-mizhang@google.com>
Message-ID: <ZbExcMMl-IAzJrfx@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Reset perf_capabilities in vcpu to 0 if
 PDCM is disabled
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 24, 2024, Mingwei Zhang wrote:
> Reset vcpu->arch.perf_capabilities to 0 if PDCM is disabled in guest cpuid.
> Without this, there is an issue in live migration. In particular, to
> migrate a VM with no PDCM enabled, VMM on the source is able to retrieve a
> non-zero value by reading the MSR_IA32_PERF_CAPABILITIES. However, VMM on
> the target is unable to set the value. This creates confusions on the user
> side.
> 
> Fundamentally, it is because vcpu->arch.perf_capabilities as the cached
> value of MSR_IA32_PERF_CAPABILITIES is incorrect, and there is nothing
> wrong on the kvm_get_msr_common() which just reads
> vcpu->arch.perf_capabilities.
> 
> Fix the issue by adding the reset code in kvm_vcpu_after_set_cpuid(), i.e.
> early in VM setup time.
> 
> Cc: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index adba49afb5fe..416bee03c42a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -369,6 +369,9 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>  	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>  
> +	/* Reset MSR_IA32_PERF_CAPABILITIES guest value to 0 if PDCM is off. */
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
> +		vcpu->arch.perf_capabilities = 0;

No, this is just papering over the underlying bug.  KVM shouldn't be stuffing
vcpu->arch.perf_capabilities without explicit writes from host userspace.  E.g
KVM_SET_CPUID{,2} is allowed multiple times, at which point KVM could clobber a
host userspace write to MSR_IA32_PERF_CAPABILITIES.  It's unlikely any userspace
actually does something like that, but KVM overwriting guest state is almost
never a good thing.

I've been meaning to send a patch for a long time (IIRC, Aaron also ran into this?).
KVM needs to simply not stuff vcpu->arch.perf_capabilities.  I believe we are
already fudging around this in our internal kernels, so I don't think there's a
need to carry a hack-a-fix for the destination kernel.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27e23714e960..fdef9d706d61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12116,7 +12116,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
        kvm_async_pf_hash_reset(vcpu);
 
-       vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
        kvm_pmu_init(vcpu);
 
        vcpu->arch.pending_external_vector = -1;

>  	kvm_pmu_refresh(vcpu);
>  	vcpu->arch.cr4_guest_rsvd_bits =
>  	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
> -- 
> 2.43.0.429.g432eaa2c6b-goog
> 

