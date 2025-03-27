Return-Path: <kvm+bounces-42109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7C7A72DBC
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 11:27:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 287861892014
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 10:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4907720E6F6;
	Thu, 27 Mar 2025 10:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ysu+mUme";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ZTe9E+Fe"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11CC20C497;
	Thu, 27 Mar 2025 10:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743071267; cv=none; b=rjRsAGKsCzSdas5UxBP+nPPswCZmj/4g9Nl+fZE/WaJvDUdbx+PcuZqALpT+HIuCTeWZwfHoafMoveeItUHS4Ep+7jYXf82TlAq2llqdw2zLdeBAA0xX3zPUfR7T4LigLj6HMoUX5tNHBr90uH/xwfIyv5fHzSWVmMi5zcUcSto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743071267; c=relaxed/simple;
	bh=DjighT6KaNkerXFcx2sqy6Gx28dAGuH/PznLd/ld0Zo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=O4lRm7TzPt/1V8wQ7LX7Aup96uKXiEJ8meQW9dW7JXhRjC0Y6cDMLXkH/p/0KsR2UJUXlKrQrkyZyZWjfXUxE4OyNjj4vpgMFgZKMxkLUxNqx3D4aUdpfg/LUySWMXn2gmnp0O/P5832s5TGlx5kzhp7RsvF+3OOqpbzov+FggQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ysu+mUme; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ZTe9E+Fe; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1743071263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XJIKKbFoyEHcQK4utFLPZUfIHZoC09dJJcZQegR1TyU=;
	b=ysu+mUmeYV7gknCnLdGpoOsjn6en58saEIsr6dHf60CXxJSH/ZG5I2CgYg30Juq8wtW83b
	8BQUgGzPxz5PuPnbXlCaQKPc9Zk3Iaz+nTt7D2M6JXT6XjVnqyA8Mj9gyZ/S+64EZSso52
	F0RsvjbYnQV/ZgPbvGWdWZwpYqcN7rQ10FcWz3w4ax3NN0pGtRao7JrJRT3CzaJFBbqUJv
	rvwMQHe/WSWZI5YS1rb6l8gdDsajxvzqESf74/jsLGfoh8nahrY0/g2Adnrf+taqDv4BHO
	438kJOpIcdB1mzx+EIt4I9XdF+NgK6e32LYTSKU5OB5PWaCLYp3UP3j/4GeM9A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1743071263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XJIKKbFoyEHcQK4utFLPZUfIHZoC09dJJcZQegR1TyU=;
	b=ZTe9E+FeZ2VWC364LVwHqPmckhAl05CeUGgjUUsunGhELxPNnJOnVY2q7LBjwixrKh9QVa
	x+FeUrnpmWuinJAQ==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 05/17] x86/apic: Add update_vector callback for Secure
 AVIC
In-Reply-To: <e86f71ec-94f7-46be-87fe-79ca26fa91d7@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-6-Neeraj.Upadhyay@amd.com> <87jz8i31dv.ffs@tglx>
 <ecc20053-42ae-43ba-b1b3-748abe9d5b3b@amd.com>
 <e86f71ec-94f7-46be-87fe-79ca26fa91d7@amd.com>
Date: Thu, 27 Mar 2025 11:27:42 +0100
Message-ID: <871puizs2p.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Mar 25 2025 at 17:40, Neeraj Upadhyay wrote:
> On 3/21/2025 9:05 PM, Neeraj Upadhyay wrote:
> diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
> index 736f62812f5c..fef6faffeed1 100644
> --- a/arch/x86/kernel/apic/vector.c
> +++ b/arch/x86/kernel/apic/vector.c
> @@ -139,6 +139,46 @@ static void apic_update_irq_cfg(struct irq_data *irqd, unsigned int vector,
>                             apicd->hw_irq_cfg.dest_apicid);
>  }
>
> +static inline void apic_drv_update_vector(unsigned int cpu, unsigned int vector, bool set)
> +{
> +       if (apic->update_vector)
> +               apic->update_vector(cpu, vector, set);
> +}
> +
> +static int irq_alloc_vector(const struct cpumask *dest, bool resvd, unsigned int *cpu)
> +{
> +       int vector;
> +
> +       vector = irq_matrix_alloc(vector_matrix, dest, resvd, cpu);
> +
> +       if (vector < 0)
> +               return vector;
> +
> +       apic_drv_update_vector(*cpu, vector, true);
> +
> +       return vector;
> +}

static int irq_alloc_vector(const struct cpumask *dest, bool resvd, unsigned int *cpu)
{
	int vector = irq_matrix_alloc(vector_matrix, dest, resvd, cpu);

	if (vector > 0)
		apic_drv_update_vector(*cpu, vector, true);
        return vector;
}

Perhaps?

> After checking more on this, set_bit(vector, ) cannot be used directly  here, as
> 32-bit registers are not consecutive. Each register is aligned at 16 byte
> boundary.

Fair enough.

> So, I changed it to below:
>
> --- a/arch/x86/kernel/apic/x2apic_savic.c
> +++ b/arch/x86/kernel/apic/x2apic_savic.c
> @@ -19,6 +19,26 @@
>
>  /* APIC_EILVTn(3) is the last defined APIC register. */
>  #define NR_APIC_REGS   (APIC_EILVTn(4) >> 2)
> +/*
> + * APIC registers such as APIC_IRR, APIC_ISR, ... are mapped as
> + * 32-bit registers and are aligned at 16-byte boundary. For
> + * example, APIC_IRR registers mapping looks like below:
> + *
> + * #Offset    #bits         Description
> + *  0x200      31:0         vectors 0-31
> + *  0x210      31:0         vectors 32-63
> + *  ...
> + *  0x270      31:0         vectors 224-255
> + *
> + * VEC_BIT_POS gives the bit position of a vector in the APIC
> + * reg containing its state.
> + */
> +#define VEC_BIT_POS(v) ((v) & (32 - 1))
> +/*
> + * VEC_REG_OFF gives the relative (from the start offset of that APIC
> + * register) offset of the APIC register containing state for a vector.
> + */
> +#define VEC_REG_OFF(v) (((v) >> 5) << 4)
>
>  struct apic_page {
>         union {
> @@ -185,6 +205,35 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
>         __send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
>  }
>
> +static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
> +{
> +       struct apic_page *ap = per_cpu_ptr(apic_backing_page, cpu);
> +       unsigned long *sirr;
> +       int vec_bit;
> +       int reg_off;
> +
> +       /*
> +        * ALLOWED_IRR registers are mapped in the apic_page at below byte
> +        * offsets. Each register is a 32-bit register aligned at 16-byte
> +        * boundary.
> +        *
> +        * #Offset                    #bits     Description
> +        * SAVIC_ALLOWED_IRR_OFFSET   31:0      Guest allowed vectors 0-31
> +        * "" + 0x10                  31:0      Guest allowed vectors 32-63
> +        * ...
> +        * "" + 0x70                  31:0      Guest allowed vectors 224-255
> +        *
> +        */
> +       reg_off = SAVIC_ALLOWED_IRR_OFFSET + VEC_REG_OFF(vector);
> +       sirr = (unsigned long *) &ap->regs[reg_off >> 2];
> +       vec_bit = VEC_BIT_POS(vector);
> +
> +       if (set)
> +               set_bit(vec_bit, sirr);
> +       else
> +               clear_bit(vec_bit, sirr);
> +}

If you need 20 lines of horrific comments to explain incomprehensible
macros and code, then something is fundamentally wrong. Then you want to
sit back and think about whether this can't be expressed in simple and
obvious ways. Let's look at the math.

The relevant registers are starting at regs[SAVIC_ALLOWED_IRR]. Due to
the 16-byte alignment the vector number obviously cannot be used for
linear bitmap addressing.

But the resulting bit number can be trivially calculated with:

   bit = vector + 32 * (vector / 32);

which can be converted to:

   bit = vector + (vector & ~0x1f);

That conversion should be done by any reasonable compiler.

Ergo the whole thing can be condensed to:

static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
{
	struct apic_page *ap = per_cpu_ptr(apic_backing_page, cpu);
	unsigned long *sirr = (unsigned long *) &ap->regs[SAVIC_ALLOWED_IRR];

        /*
         * The registers are 32-bit wide and 16-byte aligned.
         * Compensate for the resulting bit number spacing.
         */
        unsigned int bit = vector + 32 * (vector / 32);

	if (set)
		set_bit(vec_bit, sirr);
	else
		clear_bit(vec_bit, sirr);
}

Two comment lines plus one line of trivial math makes this
comprehensible and obvious. No?

If you need that adjustment for other places as well, then you can
provide a trivial and documented inline function for it.

Thanks,

        tglx

