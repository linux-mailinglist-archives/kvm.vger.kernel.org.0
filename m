Return-Path: <kvm+bounces-41665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA2BA6BCEE
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:27:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF085189B6CE
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185511C5D5E;
	Fri, 21 Mar 2025 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="U3wlo3Jh";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="J6RtMImY"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4931991CB;
	Fri, 21 Mar 2025 14:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742567233; cv=none; b=RsoVVCigOIVq/38FOHS2PRq+Khx+N3yekt5TjQ//4W4vBPWHkp+JxHiNOUWnMTdB4T7Ur/MgRal1kjiZ62CNXCqaUgRtHEKabOj6mAMwcdYRWMY+87XFNozZN2b8R/SiI6VnqJa0VcQIc9GVCz/cHXCuihDd3em6SpXBIVQbRkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742567233; c=relaxed/simple;
	bh=Vvupyb2Sy3uvR9u042VzEw2wiaEuHN4nbQdv1bL9SvA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=m1NsivVNfnJZpblJ5l0DX74e8cnJexrBluZHfnQU1E3FoScGiKCEgCXJ1GRlNCMOeAQBvNfFo1eKspeZHenHvlrVvcVZ8z5xzhjdtq0Gq078r8vX6Ni5QAJpCnEQnPr2eg63QT+DQGX/z1s3Ues/6E6/Bpu8GTuqg9+ujYI+EwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=U3wlo3Jh; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=J6RtMImY; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742567229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UmxNltNz39yMIHUoaxtv61lmZ7jvm/jrC728nmOVc2o=;
	b=U3wlo3Jhx/S2r2nGUnhDmfCQr4QEfCByQzzn1ru+9ZI/knFgKulS12t2z546XVlH3usb+N
	Ji7Hzd6rJK5JVP6ULi0qLvFv2x3FXDo/p7pR4fcXxbuupfiG0xUVpc7ojBe/Q+o7/DeXua
	vb3CpqbrBibAcT7XvsCmuFdfLnfsodfrK+L0UxdxXUVcQUGqJNSQmgCt0zaWRxIDjh7nOy
	5Tx8utFdHGVTT5g2d5ufFMmsimT0NDwF4mvaPljF7YsreeQS1ijvOed6RB0mqTs9lr1k47
	6BvbROn6UOi1kW6kwJK15RcPr5EmFfPZDxoUZD93uQl+yCYNzXAPPiGHVuqFwg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742567229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UmxNltNz39yMIHUoaxtv61lmZ7jvm/jrC728nmOVc2o=;
	b=J6RtMImY0QEvcinKM5Jo0YuDQyUXDyCJMAI7u1tZ9zUQdkpsd7bl4Qqs/kqLEbR+7ibCUn
	cBLogD1bTM3BG8Ag==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 05/17] x86/apic: Add update_vector callback for Secure
 AVIC
In-Reply-To: <20250226090525.231882-6-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-6-Neeraj.Upadhyay@amd.com>
Date: Fri, 21 Mar 2025 15:27:08 +0100
Message-ID: <87jz8i31dv.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
> Add update_vector callback to set/clear ALLOWED_IRR field in
> the APIC backing page. The ALLOWED_IRR field indicates the
> interrupt vectors which the guest allows the hypervisor to
> send (typically for emulated devices). Interrupt vectors used
> exclusively by the guest itself (like IPI vectors) should not
> be allowed to be injected into the guest for security reasons.
> The update_vector callback is invoked from APIC vector domain
> whenever a vector is allocated, freed or moved.

Your changelog tells a lot about the WHAT. Please read and follow the
documentation, which describes how a change log should be structured.

https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#changelog

> diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
> index 72fa4bb78f0a..e0c9505e05f8 100644
> --- a/arch/x86/kernel/apic/vector.c
> +++ b/arch/x86/kernel/apic/vector.c
> @@ -174,6 +174,8 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
>  		apicd->prev_cpu = apicd->cpu;
>  		WARN_ON_ONCE(apicd->cpu == newcpu);
>  	} else {
> +		if (apic->update_vector)
> +			apic->update_vector(apicd->cpu, apicd->vector, false);
>  		irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
>  				managed);
>  	}
> @@ -183,6 +185,8 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
>  	apicd->cpu = newcpu;
>  	BUG_ON(!IS_ERR_OR_NULL(per_cpu(vector_irq, newcpu)[newvec]));
>  	per_cpu(vector_irq, newcpu)[newvec] = desc;
> +	if (apic->update_vector)
> +		apic->update_vector(apicd->cpu, apicd->vector, true);

A trivial

static inline void apic_update_vector(....)
{
        if (apic->update_vector)
           ....
}

would be too easy to read and add not enough line count, right?

>  static void vector_assign_managed_shutdown(struct irq_data *irqd)
> @@ -528,11 +532,15 @@ static bool vector_configure_legacy(unsigned int virq, struct irq_data *irqd,
>  	if (irqd_is_activated(irqd)) {
>  		trace_vector_setup(virq, true, 0);
>  		apic_update_irq_cfg(irqd, apicd->vector, apicd->cpu);
> +		if (apic->update_vector)
> +			apic->update_vector(apicd->cpu, apicd->vector, true);
>  	} else {
>  		/* Release the vector */
>  		apicd->can_reserve = true;
>  		irqd_set_can_reserve(irqd);
>  		clear_irq_vector(irqd);
> +		if (apic->update_vector)
> +			apic->update_vector(apicd->cpu, apicd->vector, false);
>  		realloc = true;

This is as incomplete as it gets. None of the other code paths which
invoke clear_irq_vector() nor those which invoke free_moved_vector() are
mopping up the leftovers in the backing page.

And no, you don't sprinkle this nonsense all over the call sites. There
is only a very limited number of functions which are involed in setting
up and tearing down a vector. Doing this at the call sites is a
guarantee for missing out as you demonstrated.

> +#define VEC_POS(v)	((v) & (32 - 1))
> +#define REG_POS(v)	(((v) >> 5) << 4)

This is unreadable, undocumented and incomprehensible garbage.

>  static DEFINE_PER_CPU(void *, apic_backing_page);
>  
>  struct apic_id_node {
> @@ -192,6 +195,22 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
>  	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
>  }
>  
> +static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
> +{
> +	void *backing_page;
> +	unsigned long *reg;
> +	int reg_off;
> +
> +	backing_page = per_cpu(apic_backing_page, cpu);
> +	reg_off = SAVIC_ALLOWED_IRR_OFFSET + REG_POS(vector);
> +	reg = (unsigned long *)((char *)backing_page + reg_off);
> +
> +	if (set)
> +		test_and_set_bit(VEC_POS(vector), reg);
> +	else
> +		test_and_clear_bit(VEC_POS(vector), reg);
> +}

What's the test_and_ for if you ignore the return value anyway?

Als I have no idea what SAVIC_ALLOWED_IRR_OFFSET means. Whether it's
something from the datashit or a made up thing does not matter. It's
patently non-informative.

Again:

struct apic_page {
	union {
		u32	regs[NR_APIC_REGS];
		u8	bytes[PAGE_SIZE];
	};
};                

       struct apic_page *ap = this_cpu_ptr(apic_page);
       unsigned long *sirr;

       /*
        * apic_page.regs[SAVIC_ALLOWED_IRR_OFFSET...] is an array of
        * consecutive 32-bit registers, which represents a vector bitmap.
        */
        sirr = (unsigned long *) &ap->regs[SAVIC_ALLOWED_IRR_OFFSET];
        if (set)
        	set_bit(sirr, vector);
        else
        	clear_bit(sirr, vector);

See how code suddenly becomes self explaining, obvious and
comprehensible?

Thanks,

        tglx

