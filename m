Return-Path: <kvm+bounces-26162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C3AC79724FD
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 00:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CBCFB23453
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 22:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E5718C92C;
	Mon,  9 Sep 2024 22:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e2o5TrJX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E85D18C924
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 22:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725919867; cv=none; b=ASypEd8txOCWU7EaGDg7DWqxawLOHmtlFWeo88ekNS7i4O/34Es3zI/v7a8l47G9q/3r3uzZAToh5EewbSkVGzg/aV0B3uJoykyPQlV3mctspCRxoLrnGuvB7Qf78XWCi7E7LehzdsekZnwNRUtAdpFf7n4dKkuTynrP/jKiW4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725919867; c=relaxed/simple;
	bh=Ym4S4z4hZUnUMnFN/gZ0bWxo/cR/CmX26LwWeCa4kJM=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=G310biM1xS5yVWHEJWkJuaYmP52JxUqOhP0DwlLP0yTTzWNCfeyRZrs+xHCId5Vs1LchAqrg0UyCgSXAfws4LFRiuJrm20IOw6VhK89fnuNek45UvrYavOpIv2nSsFghHzzHOOgoqrW8ifkP1wKv3yKCopzi/LzKLlweKQRwwPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e2o5TrJX; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-82cf30e0092so272770139f.3
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 15:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725919864; x=1726524664; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mwiDGbxq8H2WD4p4wklx1FUjJYJSGOrjotVinFQ/oRw=;
        b=e2o5TrJXFXfBcuMD+t+elWncMrLOoX2iFRq4AUKJzqB3k6YAndb+DI8/ctx1D/fzqs
         zpZXiGRUPCCxBkS0ld2EdR/+STuab5wBxAcu5/D0TVGCAihXHhZfcWPFzosi4vAozrUs
         bR4UPzpnBjQCS8LKoVosj1Ea4JTfOeDWXKbQdjDkPUNOe5OC0wHGzgatFwXjw6GjfB9q
         kMM5cRugJFnBhv4QYDJsZqzu8I72fGvM7c2hU28FLuh50uNy77v2Kn/BFQezPcfKrb1G
         kW5POJ52reEz3WJ4/w411m9FD3vGjNuYMiyJbQ6D2paDo0PzU4/l+1QqJrj64A2znYTI
         Tbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725919864; x=1726524664;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mwiDGbxq8H2WD4p4wklx1FUjJYJSGOrjotVinFQ/oRw=;
        b=QibXP7+1dzN9Wr9inOXdsB+Zqe6dn/K36Q2RObSP2zw/CiwYOWE0bavpEaVobo3FX3
         EKKY7yG2vWmlIxHgHxTPtnUxxPlrlbCd3CuiYp7ewYiyim6ZvDxRY5te9J4dbH7uf29R
         hgfTpbDf1qQyP7yv5ndbELotyHIHAYWRUiSgbYT+Wbx9Fq5q+KoauSRfENdEk2wB1cpZ
         b6o8AkiPzSi08yWpu5fwX1F4jycdb2UZd5Xj5d/pvMTdnJUS7lQC2i47HzDhMLXvBv5G
         Uc+gccKRXu+ZOTBTVYZY/OVV3tdXC7umY/I6pnR/d2lxB2rCD471XclRBRuGHk1p6But
         ORRA==
X-Forwarded-Encrypted: i=1; AJvYcCXBIhxLQd3Kd9fPEYxWjYaDnKvNXxo9b+2F281RUoJP9FcKmylMrCNXWyWG6lJD3hfogi8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcvBnTVBcCS24O/F6bxVyPY78OaqYvMIMGy24RxAsIzxYyzAqn
	cZ6dZKPbd9zdpgifHTzpzm82dFWNzZ3wjmjWPATR+xyUPwaurpxZSSL53T2padHB/aZnjS9igi6
	Hv5kJ6eZPqOHxF1Ymx3QWgg==
X-Google-Smtp-Source: AGHT+IFbOAZC8OkGbMlqnvGhe3VdEHbkA3wy16Kyk/Po0dvS9tvD9w+NBX/fV1WUh9kizCTu6HK4wQe3yBUVcQQyFQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:342a:b0:82c:e924:d7d1 with
 SMTP id ca18e2360f4ac-82ce924de3amr2500639f.0.1725919864441; Mon, 09 Sep 2024
 15:11:04 -0700 (PDT)
Date: Mon, 09 Sep 2024 22:11:03 +0000
In-Reply-To: <20240801045907.4010984-13-mizhang@google.com> (message from
 Mingwei Zhang on Thu,  1 Aug 2024 04:58:21 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnt7cbkeavc.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [RFC PATCH v3 12/58] perf: core/x86: Register a new vector for
 KVM GUEST PMI
From: Colton Lewis <coltonlewis@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, xiong.y.zhang@intel.com, 
	dapeng1.mi@linux.intel.com, kan.liang@intel.com, zhenyuw@linux.intel.com, 
	manali.shukla@amd.com, sandipan.das@amd.com, jmattson@google.com, 
	eranian@google.com, irogers@google.com, namhyung@kernel.org, 
	mizhang@google.com, gce-passthrou-pmu-dev@google.com, samantha.alt@intel.com, 
	zhiyuan.lv@intel.com, yanfei.xu@intel.com, like.xu.linux@gmail.com, 
	peterz@infradead.org, rananta@google.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hello,

Mingwei Zhang <mizhang@google.com> writes:

> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

> Create a new vector in the host IDT for kvm guest PMI handling within
> mediated passthrough vPMU. In addition, guest PMI handler registration
> is added into x86_set_kvm_irq_handler().

> This is the preparation work to support mediated passthrough vPMU to
> handle kvm guest PMIs without interference from PMI handler of the host
> PMU.

> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>   arch/x86/include/asm/hardirq.h                |  1 +
>   arch/x86/include/asm/idtentry.h               |  1 +
>   arch/x86/include/asm/irq_vectors.h            |  5 ++++-
>   arch/x86/kernel/idt.c                         |  1 +
>   arch/x86/kernel/irq.c                         | 21 +++++++++++++++++++
>   .../beauty/arch/x86/include/asm/irq_vectors.h |  5 ++++-
>   6 files changed, 32 insertions(+), 2 deletions(-)

> diff --git a/arch/x86/include/asm/hardirq.h  
> b/arch/x86/include/asm/hardirq.h
> index c67fa6ad098a..42a396763c8d 100644
> --- a/arch/x86/include/asm/hardirq.h
> +++ b/arch/x86/include/asm/hardirq.h
> @@ -19,6 +19,7 @@ typedef struct {
>   	unsigned int kvm_posted_intr_ipis;
>   	unsigned int kvm_posted_intr_wakeup_ipis;
>   	unsigned int kvm_posted_intr_nested_ipis;
> +	unsigned int kvm_guest_pmis;
>   #endif
>   	unsigned int x86_platform_ipis;	/* arch dependent */
>   	unsigned int apic_perf_irqs;
> diff --git a/arch/x86/include/asm/idtentry.h  
> b/arch/x86/include/asm/idtentry.h
> index d4f24499b256..7b1e3e542b1d 100644
> --- a/arch/x86/include/asm/idtentry.h
> +++ b/arch/x86/include/asm/idtentry.h
> @@ -745,6 +745,7 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		 
> sysvec_irq_work);
>   DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,		sysvec_kvm_posted_intr_ipi);
>   DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	 
> sysvec_kvm_posted_intr_wakeup_ipi);
>   DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	 
> sysvec_kvm_posted_intr_nested_ipi);
> +DECLARE_IDTENTRY_SYSVEC(KVM_GUEST_PMI_VECTOR,	         
> sysvec_kvm_guest_pmi_handler);
>   #else
>   # define fred_sysvec_kvm_posted_intr_ipi		NULL
>   # define fred_sysvec_kvm_posted_intr_wakeup_ipi		NULL
> diff --git a/arch/x86/include/asm/irq_vectors.h  
> b/arch/x86/include/asm/irq_vectors.h
> index 13aea8fc3d45..ada270e6f5cb 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -77,7 +77,10 @@
>    */
>   #define IRQ_WORK_VECTOR			0xf6

> -/* 0xf5 - unused, was UV_BAU_MESSAGE */
> +#if IS_ENABLED(CONFIG_KVM)
> +#define KVM_GUEST_PMI_VECTOR		0xf5
> +#endif
> +
>   #define DEFERRED_ERROR_VECTOR		0xf4

>   /* Vector on which hypervisor callbacks will be delivered */
> diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
> index f445bec516a0..0bec4c7e2308 100644
> --- a/arch/x86/kernel/idt.c
> +++ b/arch/x86/kernel/idt.c
> @@ -157,6 +157,7 @@ static const __initconst struct idt_data apic_idts[]  
> = {
>   	INTG(POSTED_INTR_VECTOR,		asm_sysvec_kvm_posted_intr_ipi),
>   	INTG(POSTED_INTR_WAKEUP_VECTOR,		asm_sysvec_kvm_posted_intr_wakeup_ipi),
>   	INTG(POSTED_INTR_NESTED_VECTOR,		asm_sysvec_kvm_posted_intr_nested_ipi),
> +	INTG(KVM_GUEST_PMI_VECTOR,		asm_sysvec_kvm_guest_pmi_handler),


There is a subtle inconsistency in that this code is guarded on
CONFIG_HAVE_KVM when the #define KVM_GUEST_PMI_VECTOR is guarded on
CONFIG_KVM. Beats me why there are two different flags that are so
similar, but it is possible they have different values leading to
compilation errors.

I happened to hit this compilation error because make defconfig will
define CONFIG_HAVE_KVM but not CONFIG_KVM. CONFIG_KVM is the more strict
of the two because it depends on CONFIG_HAVE_KVM.

This code should also be guarded on CONFIG_KVM.

>   # endif
>   # ifdef CONFIG_IRQ_WORK
>   	INTG(IRQ_WORK_VECTOR,			asm_sysvec_irq_work),
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 18cd418fe106..b29714e23fc4 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -183,6 +183,12 @@ int arch_show_interrupts(struct seq_file *p, int  
> prec)
>   		seq_printf(p, "%10u ",
>   			   irq_stats(j)->kvm_posted_intr_wakeup_ipis);
>   	seq_puts(p, "  Posted-interrupt wakeup event\n");
> +
> +	seq_printf(p, "%*s: ", prec, "VPMU");
> +	for_each_online_cpu(j)
> +		seq_printf(p, "%10u ",
> +			   irq_stats(j)->kvm_guest_pmis);
> +	seq_puts(p, " KVM GUEST PMI\n");
>   #endif
>   #ifdef CONFIG_X86_POSTED_MSI
>   	seq_printf(p, "%*s: ", prec, "PMN");
> @@ -311,6 +317,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_x86_platform_ipi)
>   #if IS_ENABLED(CONFIG_KVM)
>   static void dummy_handler(void) {}
>   static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
> +static void (*kvm_guest_pmi_handler)(void) = dummy_handler;

>   void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void))
>   {
> @@ -321,6 +328,10 @@ void x86_set_kvm_irq_handler(u8 vector, void  
> (*handler)(void))
>   	    (handler == dummy_handler ||
>   	     kvm_posted_intr_wakeup_handler == dummy_handler))
>   		kvm_posted_intr_wakeup_handler = handler;
> +	else if (vector == KVM_GUEST_PMI_VECTOR &&
> +		 (handler == dummy_handler ||
> +		  kvm_guest_pmi_handler == dummy_handler))
> +		kvm_guest_pmi_handler = handler;
>   	else
>   		WARN_ON_ONCE(1);

> @@ -356,6 +367,16 @@  
> DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm_posted_intr_nested_ipi)
>   	apic_eoi();
>   	inc_irq_stat(kvm_posted_intr_nested_ipis);
>   }
> +
> +/*
> + * Handler for KVM_GUEST_PMI_VECTOR.
> + */
> +DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_guest_pmi_handler)
> +{
> +	apic_eoi();
> +	inc_irq_stat(kvm_guest_pmis);
> +	kvm_guest_pmi_handler();
> +}
>   #endif

>   #ifdef CONFIG_X86_POSTED_MSI
> diff --git a/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h  
> b/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
> index 13aea8fc3d45..670dcee46631 100644
> --- a/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
> +++ b/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
> @@ -77,7 +77,10 @@
>    */
>   #define IRQ_WORK_VECTOR			0xf6

> -/* 0xf5 - unused, was UV_BAU_MESSAGE */
> +#if IS_ENABLED(CONFIG_KVM)
> +#define KVM_GUEST_PMI_VECTOR           0xf5
> +#endif
> +
>   #define DEFERRED_ERROR_VECTOR		0xf4

>   /* Vector on which hypervisor callbacks will be delivered */

