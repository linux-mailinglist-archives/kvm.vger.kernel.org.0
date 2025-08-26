Return-Path: <kvm+bounces-55796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28899B37488
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 23:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D875B7C456F
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 21:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68628284678;
	Tue, 26 Aug 2025 21:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y/U4lLvN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190CA1B6D08
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 21:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756244892; cv=none; b=JX+Kh0EEiG9TQ+/jQcdqaotPEiWitDKhryWxT7Pa+hgbEm5pqr43bbDe2iWlazEve64Xc7wCNpg0G+BqKTthkox+be3Wf8tSdr9KgmudWF8qU3iSmHkL2CDRBcZg9jmO8E99MxPM17OfUA4FFBRs7WGcEgJkM7EcDps+Erm9uDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756244892; c=relaxed/simple;
	bh=bOwaeI93PSDb0zkaMiT9ewABVodLWy1w5hUTcezg2Eg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cZTeQCkYdkh9hKYDmu2y6UXbsVU36EaUaNM/1I6JkNBDe3JI7vIrLS5vs8nTSH+mbjHIwOtIK4368nUqxAw8vpRcvbSLbTddixjhqDz/cbUA3vk8+Fr7n5vLt5PdYJf7e9VW23d/flWSILERXkjt+xtLFQbxGAChEBLsBPi5zT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y/U4lLvN; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4c32f731e7so832166a12.0
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 14:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756244890; x=1756849690; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=csobuERBofV5Nepble+8wxFqNjE3upSKLuk+G9nUdh4=;
        b=y/U4lLvNJ/MerfrBBHu30G/qmSjIvv9fv51NFGoyRrzvtIPkUjHS/H/LUPdJ5tvPFA
         SNA21+HfrUYzaefxgtFx6Y2hxQGXwwMv79wFiNTEKg5XcQUbqyD+lA6VStlWvn35aaSc
         pdPvPM/9+Cr8PRb7xoeYLQ1quNdIv4ITFPDB9ga200A9dyWr/5eJN2QgOqnCKopQjisF
         wOSvhIpmN5OeQr4cC3D2wRGpprWYyUy2LmdRyslx4fV1gxr7ufErKIfnuwN/L9APWxjZ
         W7QY1KcgZHauHUJcL8yeLba1RcsLQ01S2Pt3PsdwgYNNO2AxrI2Z1Hyoa1qQRCvZbghm
         2FCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756244890; x=1756849690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=csobuERBofV5Nepble+8wxFqNjE3upSKLuk+G9nUdh4=;
        b=S4WMoevndr042iDZx/a9d4TS9lSnSGqdJ2fZUNAL8ViKoHVqXeNz32+u0e5F6seDir
         PjKMFScz57AzHsDF6wK/kwsfDoqBqHSWx40RB4hmOo7x3p1NBu8uu51jl+H/r4y7OG1z
         0ZQAzZ6IHc87Eeanu5DI2EhkAxtdFvj8F5d8+ed4ILmwwbWWU+ev2SiAMcttfu2S0+Vh
         eBk1Ox66Fkfo2ZvjS6xndXbzfAkejxzGYW8uD10Cu4kz7hKqU6Rd2WF32n5C8fC5lpeo
         +Ug64JQLfA+XjaQqwmW3Pt7ZrsutGQcHENJcwJAxrj7j9fcgJCET88fe4s6zTLeisL+W
         iI/A==
X-Forwarded-Encrypted: i=1; AJvYcCXAbZeeVgC9JRZTdjkwLnJhfZpeVb6XmV2/Jg2vCPPBkmQJXnsK+VATvYsYji49wKcLHBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBjspc/RkoEyUbjrUqtei816kaCCkg5jmZaQYW5AwlKTKMtvP/
	5uR9wITisnVsgeBjGc93PUF2IX41RpFfyuxAWZOp/YlDTAvNfyPP1dBy+wIWpZNiVYELBaZmq6J
	uB2RVmg==
X-Google-Smtp-Source: AGHT+IFN06e3MQczQrLk326RnPETUX2fqjOe2ujcl7FpqHg8aymnuRt6WEeqpIiIReDvZBv6z8VLbf8Q57A=
X-Received: from pjbpd18.prod.google.com ([2002:a17:90b:1dd2:b0:325:a8d:a485])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c8d:b0:31e:f3a4:333
 with SMTP id 98e67ed59e1d1-32517d19c12mr20302910a91.26.1756244890381; Tue, 26
 Aug 2025 14:48:10 -0700 (PDT)
Date: Tue, 26 Aug 2025 14:48:08 -0700
In-Reply-To: <20250826213455.2338722-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250826213455.2338722-1-sagis@google.com>
Message-ID: <aK4rmD7QpotYXume@google.com>
Subject: Re: [PATCH] KVM: TDX: Force split irqchip for TDX at irqchip creation time
From: Sean Christopherson <seanjc@google.com>
To: Sagi Shahar <sagis@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 26, 2025, Sagi Shahar wrote:
> TDX module protects the EOI-bitmap which prevents the use of in-kernel
> I/O APIC. See more details in the original patch [1]
> 
> The current implementation already enforces the use of split irqchip for
> TDX but it does so at the vCPU creation time which is generally to late
> to fallback to split irqchip.
> 
> This patch follows Sean's recomendation from [2] and move the check if
> I/O APIC is supported for the VM at irqchip creation time.
> 
> [1] https://lore.kernel.org/lkml/20250222014757.897978-11-binbin.wu@linux.intel.com/
> [2] https://lore.kernel.org/lkml/aK3vZ5HuKKeFuuM4@google.com/
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 +++
>  arch/x86/kvm/vmx/tdx.c          | 15 ++++++++-------
>  arch/x86/kvm/x86.c              | 10 ++++++++++
>  3 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f19a76d3ca0e..cb22fc48cdec 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1357,6 +1357,7 @@ struct kvm_arch {
>  	u8 vm_type;
>  	bool has_private_mem;
>  	bool has_protected_state;
> +	bool has_protected_eoi;
>  	bool pre_fault_allowed;
>  	struct hlist_head *mmu_page_hash;
>  	struct list_head active_mmu_pages;
> @@ -2284,6 +2285,8 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>  
>  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
>  
> +#define kvm_arch_has_protected_eoi(kvm) (!(kvm)->arch.has_protected_eoi)
> +
>  static inline u16 kvm_read_ldt(void)
>  {
>  	u16 ldt;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 66744f5768c8..8c270a159692 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -658,6 +658,12 @@ int tdx_vm_init(struct kvm *kvm)
>  	 */
>  	kvm->max_vcpus = min_t(int, kvm->max_vcpus, num_present_cpus());
>  
> +	/*
> +	 * TDX Module doesn't allow the hypervisor to modify the EOI-bitmap,
> +	 * i.e. all EOIs are accelerated and never trigger exits.
> +	 */
> +	kvm->arch.has_protected_eoi = true;
> +
>  	kvm_tdx->state = TD_STATE_UNINITIALIZED;
>  
>  	return 0;
> @@ -671,13 +677,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>  	if (kvm_tdx->state != TD_STATE_INITIALIZED)
>  		return -EIO;
>  
> -	/*
> -	 * TDX module mandates APICv, which requires an in-kernel local APIC.
> -	 * Disallow an in-kernel I/O APIC, because level-triggered interrupts
> -	 * and thus the I/O APIC as a whole can't be faithfully emulated in KVM.
> -	 */
> -	if (!irqchip_split(vcpu->kvm))
> -		return -EINVAL;
> +	/* Split irqchip should be enforced at irqchip creation time. */
> +	KVM_BUG_ON(irqchip_split(vcpu->kvm), vcpu->kvm);

Sadly, the existing check needs to stay, because userspace could simply not create
any irqchip.  My complaints about KVM_CREATE_IRQCHIP is that KVM is allowing an
explicit action that is unsupported/invalid.  For lack of an in-kernel local APIC,
there's no better alternative to enforcing the check at vCPU creation.

>  	fpstate_set_confidential(&vcpu->arch.guest_fpu);
>  	vcpu->arch.apic->guest_apic_protected = true;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a1c49bc681c4..a846dd3dcb23 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6966,6 +6966,16 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		if (irqchip_in_kernel(kvm))
>  			goto create_irqchip_unlock;
>  
> +		/*
> +		 * Disallow an in-kernel I/O APIC for platforms that has protected
> +		 * EOI (such as TDX). The hypervisor can't modify the EOI-bitmap
> +		 * on these platforms which prevents the proper emulation of
> +		 * level-triggered interrupts.
> +		 */

Slight tweak to shorten this and to avoid mentioning the EOI-bitmap.  The use of
a software-controlled EOI-bitmap is a vendor specific detail, and it's not so much
the inability to modify the bitmap that's problematic, it's that TDX doesn't
allow intercepting EOIs.  E.g. TDX also requires x2APIC and PICv to be enabled,
without which EOIs would effectively be intercepted by other means.

		/*
		 * Disallow an in-kernel I/O APIC if the VM has protected EOIs,
		 * i.e. if KVM can't intercept EOIs and thus can't properly
		 * emulate level-triggered interrupts.
		 */

> +		r = -ENOTTY;
> +		if (kvm_arch_has_protected_eoi(kvm))

No need for a macro wrapper, just do

		if (kvm->arch.has_protected_eoi)

kvm_arch_has_readonly_mem() and similar accessors exist so that arch-neutral
code, e.g. check_memory_region_flags() in kvm_main.c, can query arch-specific
state.  Nothing outside of KVM x86 should care about protected EOI, because that's
very much an x86-specific detail.

> +			goto create_irqchip_unlock;
> +
>  		r = -EINVAL;
>  		if (kvm->created_vcpus)
>  			goto create_irqchip_unlock;
> -- 
> 2.51.0.261.g7ce5a0a67e-goog
> 

