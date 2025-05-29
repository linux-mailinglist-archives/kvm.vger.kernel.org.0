Return-Path: <kvm+bounces-48012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BE72DAC83FC
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 00:19:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94D4A1BA29B1
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AAB721E0B7;
	Thu, 29 May 2025 22:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g2HJI3+e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098EB21B9C3
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 22:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748557167; cv=none; b=ogDkDRHsrorFoH7IxAmtSe0rRwOWgTPqA6bl9kSSNGqflX1gSvYO3l7akD/ZDwSrMu10B1NWgsREx1siDLU80ELjha00eKKGpGO8BTHLEN43oxXUZ3x5dB/nLDGYdWR7z8yvyupZCplhGKR9vv+cL67DVg1Oo4Kb7Ma2cK4YCko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748557167; c=relaxed/simple;
	bh=/axPWx9pFiZ88xSg3GvujPUpn0OIAQd+muRjqg6LQbU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GFU6bGuyRxFWweNMVXOZl2PkDtNNPXZp1j4M2Py53K098dh5RaAYcgFkOyo+aIrwT9hFuadOoNNjsk9uuUYRk4wmtcuXT8ecXf+N0bNOGNkHg7YfncMhsB4HeDh163YWgcsNgZuZPTASMd7K+CSz2KsDnMDqRNBfGA08gMAdtBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g2HJI3+e; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b0e0c573531so892735a12.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 15:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748557164; x=1749161964; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n+PW3r+/BVI5LEotwQK4/wqYAkrq0SQ+HqmcFVNfHnQ=;
        b=g2HJI3+e+JIxJkSFNERGzufhNxVOpPsLEY+ftZZGlBONpCD3VXCq+Hy58niPMbMAg9
         7xR4or5WQeJuxHiMCEoUetJMGcf4eE9zRX73aRPoYrZh25KPLAYdxnI+Ie0qDscUce9c
         x6Rr8hr8N+m1Jvu4MiEJwI9tovcJ7RrF98m20j0U+g30DOS9ymeHtNpRKSq8001SFCbl
         GPnmXY81nd+P+gdIIv5UKuSXXuBADNKgdHRGLOtreo08OmQfLFc+Lb3iHmLvoJsHxDAm
         Eb0HQ3IA8tDRVg4JN6rfIoj+HOxfNQ/QRZeFnmQA7FcknKlx3scUfmMZ7M5gZZXTrwxc
         sMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748557164; x=1749161964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n+PW3r+/BVI5LEotwQK4/wqYAkrq0SQ+HqmcFVNfHnQ=;
        b=XGN7+7k0RDe11qWLXtlFHIzeHzXXlY7kjIeeKOSiFUr6CYYhUzbfqJyMc+QwnSMkNd
         Qm/Q2X5vRFM3sypcQzoeG2c64qOgS4mJPV1mn55agqAg+9gCIQR5RAqYkhzivc8/nBj7
         3WmVkalsV6WaSMq2HCH3VwJIogw9yqz4fZaqYF4+ZZSpgrTMcmmz7+k8+0Dpm89X+zCm
         wJbphHbk4dCHqlNPKSYGLzKlom4j02kWvGBb2RU95BLRpGYj8/jfRRsr8N9NcG/14X9o
         oYVJwnEyXVMWaKBKtjZ6LSfw12h6Mzg7m59kP/VOyD3az1lZGJ4jmtmbzXE8i4Hn7wG5
         Rx5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUapY5OLQMSueL+t7fGvluxgXmUM0FskJlLApwnfHvdiOhumf7RdFhEPY/N2BSLsmMcmEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvpQyNtax0vcHOYjWkQbLcguYS6Nk5oydP7KPfo37xXmwJDVDa
	OF8Q3quFT58otSDJfz7D2+SnznLxeeBna4qLzp/c/n3u3c3Ylm5f/X5UJJouiBWg35iDFVrkjrI
	DzvhAcQ==
X-Google-Smtp-Source: AGHT+IEUE7BQQdmGE1MoMD1DBcEUe9iBvKfMPZydDvm6S7w80UfsVuDxXmeHBia3lTenxO64ia7iv33wXmA=
X-Received: from pjbse6.prod.google.com ([2002:a17:90b:5186:b0:30a:7da4:f075])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b90:b0:311:eb85:96df
 with SMTP id 98e67ed59e1d1-31241531935mr1811010a91.17.1748557164266; Thu, 29
 May 2025 15:19:24 -0700 (PDT)
Date: Thu, 29 May 2025 15:19:22 -0700
In-Reply-To: <20250529042710.crjcc76dqpiak4pn@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523011756.3243624-1-seanjc@google.com> <20250523011756.3243624-4-seanjc@google.com>
 <20250529042710.crjcc76dqpiak4pn@desk>
Message-ID: <aDjdagbqcesTcnhc@google.com>
Subject: Re: [PATCH 3/5] KVM: VMX: Apply MMIO Stale Data mitigation if KVM
 maps MMIO into the guest
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 28, 2025, Pawan Gupta wrote:
> On Thu, May 22, 2025 at 06:17:54PM -0700, Sean Christopherson wrote:
> > @@ -7282,7 +7288,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> >  	if (static_branch_unlikely(&vmx_l1d_should_flush))
> >  		vmx_l1d_flush(vcpu);
> >  	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
> > -		 kvm_arch_has_assigned_device(vcpu->kvm))
> > +		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
> >  		mds_clear_cpu_buffers();
> 
> I think this also paves way for buffer clear for MDS and MMIO to be done at
> a single place. Please let me know if below is feasible:

It's definitely feasible (this thought crossed my mind as well), but because
CLEAR_CPU_BUFFERS emits VERW iff X86_FEATURE_CLEAR_CPU_BUF is enabled, the below
would do nothing for the MMIO case (either that, or I'm missing something).

We could obviously rework CLEAR_CPU_BUFFERS, I'm just not sure that's worth the
effort at this point.  I'm definitely not opposed to it though.

> diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
> index 2f20fb170def..004fe1ca89f0 100644
> --- a/arch/x86/kvm/vmx/run_flags.h
> +++ b/arch/x86/kvm/vmx/run_flags.h
> @@ -2,12 +2,12 @@
>  #ifndef __KVM_X86_VMX_RUN_FLAGS_H
>  #define __KVM_X86_VMX_RUN_FLAGS_H
>  
> -#define VMX_RUN_VMRESUME_SHIFT				0
> -#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT			1
> -#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT	2
> +#define VMX_RUN_VMRESUME_SHIFT			0
> +#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT		1
> +#define VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT		2
>  
> -#define VMX_RUN_VMRESUME			BIT(VMX_RUN_VMRESUME_SHIFT)
> -#define VMX_RUN_SAVE_SPEC_CTRL			BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> -#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT)
> +#define VMX_RUN_VMRESUME		BIT(VMX_RUN_VMRESUME_SHIFT)
> +#define VMX_RUN_SAVE_SPEC_CTRL		BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> +#define VMX_RUN_CLEAR_CPU_BUFFERS	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT)
>  
>  #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index f6986dee6f8c..ab602ce4967e 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -141,6 +141,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	/* Check if vmlaunch or vmresume is needed */
>  	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
>  
> +	test $VMX_RUN_CLEAR_CPU_BUFFERS, %ebx
> +
>  	/* Load guest registers.  Don't clobber flags. */
>  	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
>  	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
> @@ -161,8 +163,11 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	/* Load guest RAX.  This kills the @regs pointer! */
>  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
>  
> +	/* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
> +	jz .Lskip_clear_cpu_buffers
>  	/* Clobbers EFLAGS.ZF */
>  	CLEAR_CPU_BUFFERS
> +.Lskip_clear_cpu_buffers:
>  
>  	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
>  	jnc .Lvmlaunch
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1e4790c8993a..1415aeea35f7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -958,9 +958,10 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
>  	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
>  		flags |= VMX_RUN_SAVE_SPEC_CTRL;
>  
> -	if (static_branch_unlikely(&mmio_stale_data_clear) &&
> -	    kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> -		flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
> +	if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF) ||
> +	    (static_branch_unlikely(&mmio_stale_data_clear) &&
> +	     kvm_vcpu_can_access_host_mmio(&vmx->vcpu)))
> +		flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
>  
>  	return flags;
>  }
> @@ -7296,9 +7297,6 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  	 */
>  	if (static_branch_unlikely(&vmx_l1d_should_flush))
>  		vmx_l1d_flush(vcpu);
> -	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
> -		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
> -		mds_clear_cpu_buffers();
>  
>  	vmx_disable_fb_clear(vmx);
>  

