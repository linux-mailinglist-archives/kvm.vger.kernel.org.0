Return-Path: <kvm+bounces-14279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DF4BA8A1E16
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6285AB247FE
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E060481C0;
	Thu, 11 Apr 2024 16:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="H3Li+qQj";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="MVdoSrAm"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1269481AA;
	Thu, 11 Apr 2024 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712854278; cv=none; b=ikE8S/IVx7qMnWkTZT3ss+WTbVcgOMEG+gARqmDXAALZcw06k1XTEstvkdyqkZvfjU4a+ENFYsCjgCoqrp0R6QGiSH/u4gznJQttct1szN3SP9U6uvbZVbeiWbAjpuJAOpPQue3Kun5VZJ0lC5g5SDRRjfAVsNLyW3VQ5Nqikms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712854278; c=relaxed/simple;
	bh=d1/jptrgMSQUzJQQQ1uzHJiUIs9jlC0C1nX9hEjOPGw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Q1EE77Fipq/G3QkLPuoFxXaXb5Tx24rSCD7X+lWPgVaYSNdFG4R/GjSvqg7Z0/SkyW4Lhr+Noh/Irz8e79EKnSCvhfQvYfFexczbWNIGkHAN8hH2wsemU9ob/DFItEke3BQOWwq3vXQuKTmIjgBmdVWST9YcetzwjhqZNPsTx+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=H3Li+qQj; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=MVdoSrAm; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1712854274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ukR6eilnG/pWmnW4ihYd+kVMND3BQSTM5uSyxQDF9cM=;
	b=H3Li+qQjhMKedJ3HsEeGikAzfFe1bXY/GeUuFQG21667CdpQXhWwlRm2qbA5ZzE7lf898e
	66wTsqPiQ/5JF8Cein7BMswM/oofPnLOs3ki07lBKDGSP8x1d/Kt9V7gbF/nI3BwPyWYpY
	oaBvxfBitH8cobGlefOnELtX9C6btHC6NVVoj5BKVx7+r6e34mOgqJTy5FpbILrDMxP7Hv
	Vr3rNW3ajcP+43V9LpqL+QmG11VNQD77YEifALOYbHmycz2oNSsL8mmvI7EECRZ17k6jjf
	95wBy9RxJqIJoluO8jm9IlJMguKB/vT96GeIEOxB4JYGGkRklHFqr+fH86pUhA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1712854274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ukR6eilnG/pWmnW4ihYd+kVMND3BQSTM5uSyxQDF9cM=;
	b=MVdoSrAmMvg+YHWpF7/tmr49WE81XVIeM6P/Kz79N7Ptj6Dy88c80NB3myObBYbd/F1c8f
	5ie9qY5SNllqEjDQ==
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
 <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Lu Baolu
 <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, Dave Hansen
 <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>
Cc: Paul Luse <paul.e.luse@intel.com>, Dan Williams
 <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
 jim.harris@samsung.com, a.manzanares@samsung.com, Bjorn Helgaas
 <helgaas@kernel.org>, guang.zeng@intel.com, robert.hoo.linux@gmail.com,
 Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH v2 05/13] x86/irq: Reserve a per CPU IDT vector for
 posted MSIs
In-Reply-To: <20240405223110.1609888-6-jacob.jun.pan@linux.intel.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-6-jacob.jun.pan@linux.intel.com>
Date: Thu, 11 Apr 2024 18:51:14 +0200
Message-ID: <87edbb267x.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Apr 05 2024 at 15:31, Jacob Pan wrote:
> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
> index d18bfb238f66..1ee00be8218d 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -97,9 +97,16 @@
>  
>  #define LOCAL_TIMER_VECTOR		0xec
>  
> +/*
> + * Posted interrupt notification vector for all device MSIs delivered to
> + * the host kernel.
> + */
> +#define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
>  #define NR_VECTORS			 256
>  
> -#ifdef CONFIG_X86_LOCAL_APIC
> +#ifdef CONFIG_X86_POSTED_MSI
> +#define FIRST_SYSTEM_VECTOR		POSTED_MSI_NOTIFICATION_VECTOR
> +#elif defined(CONFIG_X86_LOCAL_APIC)
>  #define FIRST_SYSTEM_VECTOR		LOCAL_TIMER_VECTOR
>  #else
>  #define FIRST_SYSTEM_VECTOR		NR_VECTORS

This is horrible and we had attempts before to make the system vector
space dense. They all did not work and making an exception for this is
not what we want.

If we really care then we do it proper for _all_ of them. Something like
the uncompiled below. There is certainly a smarter way to do the build
thing, but my kbuild foo is rusty.

Thanks,

        tglx
---
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -245,6 +245,7 @@ archscripts: scripts_basic
 
 archheaders:
 	$(Q)$(MAKE) $(build)=arch/x86/entry/syscalls all
+	$(Q)$(MAKE) $(build)=arch/x86/kernel/irqvectors all
 
 ###
 # Kernel objects
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -43,59 +43,46 @@
  */
 #define ISA_IRQ_VECTOR(irq)		(((FIRST_EXTERNAL_VECTOR + 16) & ~15) + irq)
 
+#ifndef __ASSEMBLY__
 /*
- * Special IRQ vectors used by the SMP architecture, 0xf0-0xff
- *
- *  some of the following vectors are 'rare', they are merged
- *  into a single vector (CALL_FUNCTION_VECTOR) to save vector space.
- *  TLB, reschedule and local APIC vectors are performance-critical.
+ * Special IRQ vectors used by the SMP architecture, 0xff and downwards
  */
+enum {
+	__SPURIOUS_APIC_VECTOR,
+	__ERROR_APIC_VECTOR,
+	__RESCHEDULE_VECTOR,
+	__CALL_FUNCTION_VECTOR,
+	__CALL_FUNCTION_SINGLE_VECTOR,
+	__THERMAL_APIC_VECTOR,
+	__THRESHOLD_APIC_VECTOR,
+	__REBOOT_VECTOR,
+	__X86_PLATFORM_IPI_VECTOR,
+	__IRQ_WORK_VECTOR,
+	__DEFERRED_ERROR_VECTOR,
 
-#define SPURIOUS_APIC_VECTOR		0xff
-/*
- * Sanity check
- */
-#if ((SPURIOUS_APIC_VECTOR & 0x0F) != 0x0F)
-# error SPURIOUS_APIC_VECTOR definition error
+#if IS_ENABLED(CONFIG_HYPERVISOR_GUEST)
+	__HYPERVISOR_CALLBACK_VECTOR,
 #endif
 
-#define ERROR_APIC_VECTOR		0xfe
-#define RESCHEDULE_VECTOR		0xfd
-#define CALL_FUNCTION_VECTOR		0xfc
-#define CALL_FUNCTION_SINGLE_VECTOR	0xfb
-#define THERMAL_APIC_VECTOR		0xfa
-#define THRESHOLD_APIC_VECTOR		0xf9
-#define REBOOT_VECTOR			0xf8
-
-/*
- * Generic system vector for platform specific use
- */
-#define X86_PLATFORM_IPI_VECTOR		0xf7
-
-/*
- * IRQ work vector:
- */
-#define IRQ_WORK_VECTOR			0xf6
-
-/* 0xf5 - unused, was UV_BAU_MESSAGE */
-#define DEFERRED_ERROR_VECTOR		0xf4
-
-/* Vector on which hypervisor callbacks will be delivered */
-#define HYPERVISOR_CALLBACK_VECTOR	0xf3
-
-/* Vector for KVM to deliver posted interrupt IPI */
-#define POSTED_INTR_VECTOR		0xf2
-#define POSTED_INTR_WAKEUP_VECTOR	0xf1
-#define POSTED_INTR_NESTED_VECTOR	0xf0
-
-#define MANAGED_IRQ_SHUTDOWN_VECTOR	0xef
+#if IS_ENABLED(CONFIG_KVM)
+	/* Vector for KVM to deliver posted interrupt IPI */
+	__POSTED_INTR_VECTOR,
+	__POSTED_INTR_WAKEUP_VECTOR,
+	__POSTED_INTR_NESTED_VECTOR,
+#endif
+	__MANAGED_IRQ_SHUTDOWN_VECTOR,
 
 #if IS_ENABLED(CONFIG_HYPERV)
-#define HYPERV_REENLIGHTENMENT_VECTOR	0xee
-#define HYPERV_STIMER0_VECTOR		0xed
+	__HYPERV_REENLIGHTENMENT_VECTOR,
+	__HYPERV_STIMER0_VECTOR,
 #endif
+	__LOCAL_TIMER_VECTOR,
+};
+#endif /* !__ASSEMBLY__ */
 
-#define LOCAL_TIMER_VECTOR		0xec
+#ifndef COMPILE_OFFSETS
+#include <asm/irqvectors.h>
+#endif
 
 #define NR_VECTORS			 256
 
--- /dev/null
+++ b/arch/x86/kernel/irqvectors/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+
+irqvectors-file	:= arch/$(SRCARCH)/include/generated/asm/irqvectors.h
+targets 	+= arch/$(SRCARCH)/kernel/irqvectors/irqvectors.s
+
+$(irqvectors-file): arch/$(SRCARCH)/kernel/irqvectors/irqvectors.s FORCE
+	$(call filechk,offsets,__ASM_IRQVECTORS_H__)
+
+PHONY += all
+all: $(irqvectors-file)
+	@:
--- /dev/null
+++ b/arch/x86/kernel/irqvectors/irqvectors.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+#define COMPILE_OFFSETS
+
+#include <linux/kbuild.h>
+#include <asm/irq_vectors.h>
+
+#define VECNR(v)	(0xFF - __##v)
+#define VECTOR(v)	DEFINE(v, VECNR(v))
+
+static void __used common(void)
+{
+	VECTOR(SPURIOUS_APIC_VECTOR);
+	VECTOR(ERROR_APIC_VECTOR);
+	VECTOR(RESCHEDULE_VECTOR);
+	VECTOR(CALL_FUNCTION_VECTOR);
+	VECTOR(CALL_FUNCTION_SINGLE_VECTOR);
+	VECTOR(THERMAL_APIC_VECTOR);
+	VECTOR(THRESHOLD_APIC_VECTOR);
+	VECTOR(REBOOT_VECTOR);
+	VECTOR(X86_PLATFORM_IPI_VECTOR);
+	VECTOR(IRQ_WORK_VECTOR);
+	VECTOR(DEFERRED_ERROR_VECTOR);
+
+#if IS_ENABLED(CONFIG_HYPERVISOR_GUEST)
+	VECTOR(HYPERVISOR_CALLBACK_VECTOR);
+#endif
+
+#if IS_ENABLED(CONFIG_KVM)
+	/* Vector for KVM to deliver posted interrupt IPI */
+	VECTOR(POSTED_INTR_VECTOR);
+	VECTOR(POSTED_INTR_WAKEUP_VECTOR);
+	VECTOR(POSTED_INTR_NESTED_VECTOR);
+#endif
+	VECTOR(MANAGED_IRQ_SHUTDOWN_VECTOR);
+
+#if IS_ENABLED(CONFIG_HYPERV)
+	VECTOR(HYPERV_REENLIGHTENMENT_VECTOR);
+	VECTOR(HYPERV_STIMER0_VECTOR);
+#endif
+	VECTOR(LOCAL_TIMER_VECTOR);
+}
+




