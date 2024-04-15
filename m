Return-Path: <kvm+bounces-14687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6DAD8A5A32
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 20:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4443E1F226F3
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 18:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C87CB155756;
	Mon, 15 Apr 2024 18:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kEVMKBUO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F651E877;
	Mon, 15 Apr 2024 18:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713206969; cv=none; b=p/YbcPxjRlNsmTHdfLB4cVcR/z7f6mACTEibYS1U8Ea8YZ7GTSx2DUkp26jIgFD9hoYn168lzEZeCEKXABdO8iXO+kfS4qtYc+IOLZRDGKxWfWgGg8rlL0ScZw40KGH8wIBeAt2CTCcd5Kl9S7ESR/PVxl/yKY7J6PRmS0XMxQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713206969; c=relaxed/simple;
	bh=JcwoKU5gaOsesE8/cuz2DXwstgtBAJ9tf7LhVcS4Jpc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XhoWwrQ34Mx3+U8+XcCyNkuYMQ20rZFanDoWyR7/fUvu5ZjFbTp15gs4fRs+yUl2sn3hQYZRGR3Z1tM7GXCh2S32xmCKUTOCe8ZtaeuR+5KIapcJcaMNI696A19EMhekui/axdQjxl3wfvNOru48u5+v4Vr/IcNfbZll5uyMlPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kEVMKBUO; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713206967; x=1744742967;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JcwoKU5gaOsesE8/cuz2DXwstgtBAJ9tf7LhVcS4Jpc=;
  b=kEVMKBUOZn21nfnDjG27T+RooiI3Wa57epOZAanOugOsDuz8814B19g/
   8P8c6Z8j8NzncymTB79D/TlcSAVCFxjI88w7HgV35BLxEPzydmKRm9344
   9yObUryqcOvy+fhE+IwFpkH/9kFKGHsmxtxD8M1/moOYomyKT5aKv4mTD
   J8SNAI918wRzQu1xIWwGF7qHuho4KKUaszV9qoj+usKdcYQtTOGv1D79X
   Eza/1xU/UsgkQdcUSUALc4aRFRs1e+0IYLnXAhIxf9lc36FiWEEuSYDx5
   NstebUIrLW/DQtvqT1QwIZAYRP+Fkxlxkt1BqhW8sa72LpRAUKCB3PutE
   Q==;
X-CSE-ConnectionGUID: ghlukBW8T+Wd19myDqPl5Q==
X-CSE-MsgGUID: IN18ip2VQHuO5bMgISIAlw==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="26071469"
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="26071469"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 11:49:27 -0700
X-CSE-ConnectionGUID: IR/69hUUSYWJtEqmTvufUg==
X-CSE-MsgGUID: hluXB3c5Sw6A5KEL5ew1jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="45295772"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 11:49:26 -0700
Date: Mon, 15 Apr 2024 11:53:58 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Lu Baolu
 <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, Dave Hansen
 <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>, Paul Luse <paul.e.luse@intel.com>, Dan Williams
 <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
 jim.harris@samsung.com, a.manzanares@samsung.com, Bjorn Helgaas
 <helgaas@kernel.org>, guang.zeng@intel.com, robert.hoo.linux@gmail.com,
 jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2 05/13] x86/irq: Reserve a per CPU IDT vector for
 posted MSIs
Message-ID: <20240415115358.04e04204@jacob-builder>
In-Reply-To: <87edbb267x.ffs@tglx>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
	<20240405223110.1609888-6-jacob.jun.pan@linux.intel.com>
	<87edbb267x.ffs@tglx>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Thomas,

On Thu, 11 Apr 2024 18:51:14 +0200, Thomas Gleixner <tglx@linutronix.de>
wrote:

> On Fri, Apr 05 2024 at 15:31, Jacob Pan wrote:
> > diff --git a/arch/x86/include/asm/irq_vectors.h
> > b/arch/x86/include/asm/irq_vectors.h index d18bfb238f66..1ee00be8218d
> > 100644 --- a/arch/x86/include/asm/irq_vectors.h
> > +++ b/arch/x86/include/asm/irq_vectors.h
> > @@ -97,9 +97,16 @@
> >  
> >  #define LOCAL_TIMER_VECTOR		0xec
> >  
> > +/*
> > + * Posted interrupt notification vector for all device MSIs delivered
> > to
> > + * the host kernel.
> > + */
> > +#define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
> >  #define NR_VECTORS			 256
> >  
> > -#ifdef CONFIG_X86_LOCAL_APIC
> > +#ifdef CONFIG_X86_POSTED_MSI
> > +#define FIRST_SYSTEM_VECTOR
> > POSTED_MSI_NOTIFICATION_VECTOR +#elif defined(CONFIG_X86_LOCAL_APIC)
> >  #define FIRST_SYSTEM_VECTOR		LOCAL_TIMER_VECTOR
> >  #else
> >  #define FIRST_SYSTEM_VECTOR		NR_VECTORS  
> 
> This is horrible and we had attempts before to make the system vector
> space dense. They all did not work and making an exception for this is
> not what we want.
> 
> If we really care then we do it proper for _all_ of them. Something like
> the uncompiled below. There is certainly a smarter way to do the build
> thing, but my kbuild foo is rusty.
I too had the concern of the wasting system vectors, but did not know how to
fix it. But now your code below works well. Tested without KVM in .config
to show the gaps:

In VECTOR IRQ domain.

BEFORE:
System: 46: 0-31,50,235-236,244,246-255

AFTER:
System: 46: 0-31,50,241-242,245-255

The only gap is MANAGED_IRQ_SHUTDOWN_VECTOR(243), which is expected on a
running system.

Verified in irqvectors.s: .ascii "->MANAGED_IRQ_SHUTDOWN_VECTOR $243

POSTED MSI/first system vector moved up from 235 to 241 for this case.

Will try to let tools/arch/x86/include/asm/irq_vectors.h also use it
instead of manually copy over each time. Any suggestions greatly
appreciated.

> ---
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -245,6 +245,7 @@ archscripts: scripts_basic
>  
>  archheaders:
>  	$(Q)$(MAKE) $(build)=arch/x86/entry/syscalls all
> +	$(Q)$(MAKE) $(build)=arch/x86/kernel/irqvectors all
>  
>  ###
>  # Kernel objects
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -43,59 +43,46 @@
>   */
>  #define ISA_IRQ_VECTOR(irq)		(((FIRST_EXTERNAL_VECTOR +
> 16) & ~15) + irq) 
> +#ifndef __ASSEMBLY__
>  /*
> - * Special IRQ vectors used by the SMP architecture, 0xf0-0xff
> - *
> - *  some of the following vectors are 'rare', they are merged
> - *  into a single vector (CALL_FUNCTION_VECTOR) to save vector space.
> - *  TLB, reschedule and local APIC vectors are performance-critical.
> + * Special IRQ vectors used by the SMP architecture, 0xff and downwards
>   */
> +enum {
> +	__SPURIOUS_APIC_VECTOR,
> +	__ERROR_APIC_VECTOR,
> +	__RESCHEDULE_VECTOR,
> +	__CALL_FUNCTION_VECTOR,
> +	__CALL_FUNCTION_SINGLE_VECTOR,
> +	__THERMAL_APIC_VECTOR,
> +	__THRESHOLD_APIC_VECTOR,
> +	__REBOOT_VECTOR,
> +	__X86_PLATFORM_IPI_VECTOR,
> +	__IRQ_WORK_VECTOR,
> +	__DEFERRED_ERROR_VECTOR,
>  
> -#define SPURIOUS_APIC_VECTOR		0xff
> -/*
> - * Sanity check
> - */
> -#if ((SPURIOUS_APIC_VECTOR & 0x0F) != 0x0F)
> -# error SPURIOUS_APIC_VECTOR definition error
> +#if IS_ENABLED(CONFIG_HYPERVISOR_GUEST)
> +	__HYPERVISOR_CALLBACK_VECTOR,
>  #endif
>  
> -#define ERROR_APIC_VECTOR		0xfe
> -#define RESCHEDULE_VECTOR		0xfd
> -#define CALL_FUNCTION_VECTOR		0xfc
> -#define CALL_FUNCTION_SINGLE_VECTOR	0xfb
> -#define THERMAL_APIC_VECTOR		0xfa
> -#define THRESHOLD_APIC_VECTOR		0xf9
> -#define REBOOT_VECTOR			0xf8
> -
> -/*
> - * Generic system vector for platform specific use
> - */
> -#define X86_PLATFORM_IPI_VECTOR		0xf7
> -
> -/*
> - * IRQ work vector:
> - */
> -#define IRQ_WORK_VECTOR			0xf6
> -
> -/* 0xf5 - unused, was UV_BAU_MESSAGE */
> -#define DEFERRED_ERROR_VECTOR		0xf4
> -
> -/* Vector on which hypervisor callbacks will be delivered */
> -#define HYPERVISOR_CALLBACK_VECTOR	0xf3
> -
> -/* Vector for KVM to deliver posted interrupt IPI */
> -#define POSTED_INTR_VECTOR		0xf2
> -#define POSTED_INTR_WAKEUP_VECTOR	0xf1
> -#define POSTED_INTR_NESTED_VECTOR	0xf0
> -
> -#define MANAGED_IRQ_SHUTDOWN_VECTOR	0xef
> +#if IS_ENABLED(CONFIG_KVM)
> +	/* Vector for KVM to deliver posted interrupt IPI */
> +	__POSTED_INTR_VECTOR,
> +	__POSTED_INTR_WAKEUP_VECTOR,
> +	__POSTED_INTR_NESTED_VECTOR,
> +#endif
> +	__MANAGED_IRQ_SHUTDOWN_VECTOR,
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
> -#define HYPERV_REENLIGHTENMENT_VECTOR	0xee
> -#define HYPERV_STIMER0_VECTOR		0xed
> +	__HYPERV_REENLIGHTENMENT_VECTOR,
> +	__HYPERV_STIMER0_VECTOR,
>  #endif
> +	__LOCAL_TIMER_VECTOR,
> +};
> +#endif /* !__ASSEMBLY__ */
>  
> -#define LOCAL_TIMER_VECTOR		0xec
> +#ifndef COMPILE_OFFSETS
> +#include <asm/irqvectors.h>
> +#endif
>  
>  #define NR_VECTORS			 256
>  
> --- /dev/null
> +++ b/arch/x86/kernel/irqvectors/Makefile
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +irqvectors-file	:=
> arch/$(SRCARCH)/include/generated/asm/irqvectors.h +targets 	+=
> arch/$(SRCARCH)/kernel/irqvectors/irqvectors.s +
> +$(irqvectors-file): arch/$(SRCARCH)/kernel/irqvectors/irqvectors.s FORCE
> +	$(call filechk,offsets,__ASM_IRQVECTORS_H__)
> +
> +PHONY += all
> +all: $(irqvectors-file)
> +	@:
> --- /dev/null
> +++ b/arch/x86/kernel/irqvectors/irqvectors.c
> @@ -0,0 +1,42 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define COMPILE_OFFSETS
> +
> +#include <linux/kbuild.h>
> +#include <asm/irq_vectors.h>
> +
> +#define VECNR(v)	(0xFF - __##v)
> +#define VECTOR(v)	DEFINE(v, VECNR(v))
> +
> +static void __used common(void)
> +{
> +	VECTOR(SPURIOUS_APIC_VECTOR);
> +	VECTOR(ERROR_APIC_VECTOR);
> +	VECTOR(RESCHEDULE_VECTOR);
> +	VECTOR(CALL_FUNCTION_VECTOR);
> +	VECTOR(CALL_FUNCTION_SINGLE_VECTOR);
> +	VECTOR(THERMAL_APIC_VECTOR);
> +	VECTOR(THRESHOLD_APIC_VECTOR);
> +	VECTOR(REBOOT_VECTOR);
> +	VECTOR(X86_PLATFORM_IPI_VECTOR);
> +	VECTOR(IRQ_WORK_VECTOR);
> +	VECTOR(DEFERRED_ERROR_VECTOR);
> +
> +#if IS_ENABLED(CONFIG_HYPERVISOR_GUEST)
> +	VECTOR(HYPERVISOR_CALLBACK_VECTOR);
> +#endif
> +
> +#if IS_ENABLED(CONFIG_KVM)
> +	/* Vector for KVM to deliver posted interrupt IPI */
> +	VECTOR(POSTED_INTR_VECTOR);
> +	VECTOR(POSTED_INTR_WAKEUP_VECTOR);
> +	VECTOR(POSTED_INTR_NESTED_VECTOR);
> +#endif
> +	VECTOR(MANAGED_IRQ_SHUTDOWN_VECTOR);
> +
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	VECTOR(HYPERV_REENLIGHTENMENT_VECTOR);
> +	VECTOR(HYPERV_STIMER0_VECTOR);
> +#endif
> +	VECTOR(LOCAL_TIMER_VECTOR);
> +}
> +
> 
> 
> 


Thanks,

Jacob

