Return-Path: <kvm+bounces-14287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F998A1D80
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:12:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E39511C22AAC
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD23E1E315C;
	Thu, 11 Apr 2024 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CceMjX6l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51721E3145
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712855418; cv=none; b=ERv7etxpitrRuyvn0b61sQK9OQE4MPZ5UeGCnfqSueCJJ5O8X2BC5iCyYjPCEm+WX7NQvul4bjBRFXy0WfhTJE8wcW2je4vSiAe5bcPIbE+UaxX44UBI4ds6j+KhzTU+baUvbicv3YtsRNdngUMOlpxiFxHZmMjRVmHoopv5ZeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712855418; c=relaxed/simple;
	bh=dmKeq3gjQHketjHdFgh0tTPetYNhcUGY5aju66evTiw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IGP4SJjT0aazdTRi9sBKmxwsqIbVlf8Cq8E25wkKWSOqPtqh/vUJc2C0IhTYOLBPrAn5MW+9bV/KaVJ5xmn2Co4MS4uORHNrsCktDGP65nAw4Q1ybnICwT9HKml2sBb9rubG6hxIUNGCZ9jPo0R3oWqVTwFbY4yAV372alfWoPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CceMjX6l; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ed663aa4a7so88113b3a.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712855416; x=1713460216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rqXx6wTtROsa6SZ3KmJP214yZkN6Kwx8ERJJrHhG1vo=;
        b=CceMjX6l2Cz45qzShKisH2VHL1AfeIkXJVgQUEqRCOvf0YxPB4oiJEiT/cMYoi8ugJ
         rxNKvJvhjehzbrdebs2Ewz5fXDLhnQRAEheT721mvivbM5p6ujT6bBHppVCIkaVdspJc
         qCG+d02BdJGYg6P0qQNLTI1NT/fp8AFVnVRwbrawYjprmk2T+0wNUONVc+x9d5Fykxhi
         ZxnNlCuBfYtu8igG/9JWl7CJY6Etn9DUp4MXGUyQCopAr6YfJB/8DbR+ab2Zif9dmQPh
         39OXWHTLriN8Cuegmbc5EPzYyP55GovnDUlVJ/08XtYyfV7clG7R0whcX3YenVBNPakN
         0APg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712855416; x=1713460216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rqXx6wTtROsa6SZ3KmJP214yZkN6Kwx8ERJJrHhG1vo=;
        b=M4h0+aC5SwHR9qSkSYy+IT4UX2OSfKcBJMjFbZbgtATQzpx2Qzp0d1vw5zJw8l2eRE
         9L0uoUnqls5TtOVF5noSMgIsIT5g2rL0j6jLOkHXK/W+6+O0UBLSfw9p8/o2fJqi4f8Q
         EqltyYeNF8vsMI5EtgIdWCkhUlII9Rbi3PQF3mMY2CtMd/K2NrhZzAE76d4M+K+Ilg0b
         Ae4OcKXFlxZEtKOnDzf2J0ZnJ4R/33CRs+c71tI3RE0YllcbpnUmikZAOvYaBvMGfVFe
         nVG2/k/mC4Ks7OXQls2+NiyZzESwukXqHgJLTNz5M+MTMITrZy8ywstaSUZQSj3n70MC
         t6dg==
X-Forwarded-Encrypted: i=1; AJvYcCUkBRMstSzrxKXLwcftXmvr7RsEU8ciBXptLQqc1A/lOzxBrvCZG/Uhpt6f+9hlRQrxfyKzL5ZUXsisjM6tOSCxodiE
X-Gm-Message-State: AOJu0YzxU9xjvSjNsGTnofibFHfhbqyA6jRrnbedNqtOIlwxRxVFCiVR
	l7/RbXmZ+kU4aSvWkj2K+3RDFzTjwV6xuAsiSIhwtbHa6abZeuF/zxUj9VdGfqCvhYLjmQ6V/Ga
	IUQ==
X-Google-Smtp-Source: AGHT+IEWqI08gfw2t+6Fzb+9wExPbJl6VfWkbAcDvPmIq8ztEkz7m45QcxqiyQ2biLbx6nyvk5kMDoNGazI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3986:b0:6ec:ee42:b143 with SMTP id
 fi6-20020a056a00398600b006ecee42b143mr7598pfb.2.1712855416032; Thu, 11 Apr
 2024 10:10:16 -0700 (PDT)
Date: Thu, 11 Apr 2024 10:10:14 -0700
In-Reply-To: <20240126085444.324918-5-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-5-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhgZdqAB6LlvJLof@google.com>
Subject: Re: [RFC PATCH 04/41] perf: core/x86: Add support to register a new
 vector for PMI handling
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@intel.com>
> 
> Create a new vector in the host IDT for PMI handling within a passthrough
> vPMU implementation. In addition, add a function to allow the registration
> of the handler and a function to switch the PMI handler.
> 
> This is the preparation work to support KVM passthrough vPMU to handle its
> own PMIs without interference from PMI handler of the host PMU.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/include/asm/hardirq.h           |  1 +
>  arch/x86/include/asm/idtentry.h          |  1 +
>  arch/x86/include/asm/irq.h               |  1 +
>  arch/x86/include/asm/irq_vectors.h       |  2 +-
>  arch/x86/kernel/idt.c                    |  1 +
>  arch/x86/kernel/irq.c                    | 29 ++++++++++++++++++++++++
>  tools/arch/x86/include/asm/irq_vectors.h |  1 +
>  7 files changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
> index 66837b8c67f1..c1e2c1a480bf 100644
> --- a/arch/x86/include/asm/hardirq.h
> +++ b/arch/x86/include/asm/hardirq.h
> @@ -19,6 +19,7 @@ typedef struct {
>  	unsigned int kvm_posted_intr_ipis;
>  	unsigned int kvm_posted_intr_wakeup_ipis;
>  	unsigned int kvm_posted_intr_nested_ipis;
> +	unsigned int kvm_vpmu_pmis;

Somewhat off topic, does anyone actually ever use these particular stats?  If the
desire is to track _all_ IRQs, why not have an array and bump the counts in common
code?

>  #endif
>  	unsigned int x86_platform_ipis;	/* arch dependent */
>  	unsigned int apic_perf_irqs;
> diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
> index 05fd175cec7d..d1b58366bc21 100644
> --- a/arch/x86/include/asm/idtentry.h
> +++ b/arch/x86/include/asm/idtentry.h
> @@ -675,6 +675,7 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		sysvec_irq_work);
>  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,		sysvec_kvm_posted_intr_ipi);
>  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	sysvec_kvm_posted_intr_wakeup_ipi);
>  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested_ipi);
> +DECLARE_IDTENTRY_SYSVEC(KVM_VPMU_VECTOR,	        sysvec_kvm_vpmu_handler);

I vote for KVM_VIRTUAL_PMI_VECTOR.  I don't see any reasy to abbreviate "virtual",
and the vector is a for a Performance Monitoring Interupt.

>  #endif
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
> diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
> index 836c170d3087..ee268f42d04a 100644
> --- a/arch/x86/include/asm/irq.h
> +++ b/arch/x86/include/asm/irq.h
> @@ -31,6 +31,7 @@ extern void fixup_irqs(void);
>  
>  #ifdef CONFIG_HAVE_KVM
>  extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
> +extern void kvm_set_vpmu_handler(void (*handler)(void));

virtual_pmi_handler()

>  #endif
>  
>  extern void (*x86_platform_ipi_callback)(void);
> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
> index 3a19904c2db6..120403572307 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -77,7 +77,7 @@
>   */
>  #define IRQ_WORK_VECTOR			0xf6
>  
> -/* 0xf5 - unused, was UV_BAU_MESSAGE */
> +#define KVM_VPMU_VECTOR			0xf5

This should be inside

	#ifdef CONFIG_HAVE_KVM

no?

>  #define DEFERRED_ERROR_VECTOR		0xf4
>  
>  /* Vector on which hypervisor callbacks will be delivered */
> diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
> index 8857abc706e4..6944eec251f4 100644
> --- a/arch/x86/kernel/idt.c
> +++ b/arch/x86/kernel/idt.c
> @@ -157,6 +157,7 @@ static const __initconst struct idt_data apic_idts[] = {
>  	INTG(POSTED_INTR_VECTOR,		asm_sysvec_kvm_posted_intr_ipi),
>  	INTG(POSTED_INTR_WAKEUP_VECTOR,		asm_sysvec_kvm_posted_intr_wakeup_ipi),
>  	INTG(POSTED_INTR_NESTED_VECTOR,		asm_sysvec_kvm_posted_intr_nested_ipi),
> +	INTG(KVM_VPMU_VECTOR,		        asm_sysvec_kvm_vpmu_handler),

kvm_virtual_pmi_handler

> @@ -332,6 +351,16 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm_posted_intr_nested_ipi)
>  	apic_eoi();
>  	inc_irq_stat(kvm_posted_intr_nested_ipis);
>  }
> +
> +/*
> + * Handler for KVM_PT_PMU_VECTOR.

Heh, not sure where the PT part came from...

> + */
> +DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_vpmu_handler)
> +{
> +	apic_eoi();
> +	inc_irq_stat(kvm_vpmu_pmis);
> +	kvm_vpmu_handler();
> +}
>  #endif
>  
>  
> diff --git a/tools/arch/x86/include/asm/irq_vectors.h b/tools/arch/x86/include/asm/irq_vectors.h
> index 3a19904c2db6..3773e60f1af8 100644
> --- a/tools/arch/x86/include/asm/irq_vectors.h
> +++ b/tools/arch/x86/include/asm/irq_vectors.h
> @@ -85,6 +85,7 @@
>  
>  /* Vector for KVM to deliver posted interrupt IPI */
>  #ifdef CONFIG_HAVE_KVM
> +#define KVM_VPMU_VECTOR			0xf5

Heh, and your copy+paste is out of date.

>  #define POSTED_INTR_VECTOR		0xf2
>  #define POSTED_INTR_WAKEUP_VECTOR	0xf1
>  #define POSTED_INTR_NESTED_VECTOR	0xf0
> -- 
> 2.34.1
> 

