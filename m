Return-Path: <kvm+bounces-41669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2259DA6BDF4
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:06:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D9EF17DAD3
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211BA1D90AD;
	Fri, 21 Mar 2025 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="kae6lGAS";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="TtaaFLCY"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96551BF33F;
	Fri, 21 Mar 2025 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742569574; cv=none; b=E5/kOqZbrZHmUopoYeOnmZJjLMX38NhMz2i97UA9mWZUp0LtqbWO7IX6jSYW2OtckVYHYqPlXD5rKYYr4sWIqszfdMIwj11oGBP1/DVxb94yIj65PBu0Ep6fEii1VLfjsKPlRp7W4eWW8wSsJG3amrLkBAFOcTJhZRa8RSzhWkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742569574; c=relaxed/simple;
	bh=XA2Gu50kK0XaU4z9LhCZJkypLoFELm9KQ+TbWjfT2Pc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BXWzpCYenfwBQ90LkNjfM2xTLiNK9fzWOOqZadw++2xifeffGCG0npkDtZGZw6v0qGYPqXwPI3jtFqQhbKadz/3SJhzeVoL1ezqF6W2/jqgUd2e/UR3AcoBh7dWh+p2vwutieNQFrEeR/xx4TCWwWO/mGFnu9U8WXgAs3tA2GlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=kae6lGAS; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=TtaaFLCY; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742569570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s3xRMm/rve5tX4RS5krW2FzMj7lxvQwvAFwsA0ucEdk=;
	b=kae6lGASZtykieaHmifexy4idu0yP4qRtqwsFaZV7yrzaYKiC8V7DG0O9PsunJlTpumG03
	jgSovk0pzFC/TnJ9fOFKwg5nptoI1YGOpdudZVQUlsD71nZsOdXSj6c9IG63q9gPd4KidV
	n6YHH/DRHSXmyaAR6epLyAtXOWR1DaeO2eh3zQcLrc/HN08kuQ8R6D7PPfDQsZ0wKcPbGU
	pQgUGp3Hn8vTR8q8tYRKIB6RWDmgEp58IzDvZasZK/XLhRT3chpdZbyfrYYoSrCI+oEgsx
	jNU0pgUr+oBmbwWBE+tVhSyijVWCvyd2EfIed7mhwdbMGxipUAgl3LX1pFvCOw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742569570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s3xRMm/rve5tX4RS5krW2FzMj7lxvQwvAFwsA0ucEdk=;
	b=TtaaFLCY3ksSp92lAsQ+lVHRJ2FGy4RFaqJ1MOBIByr3IsZcWRULCZ4d9vjP/3ETaZWHhx
	P3hdmMDZmiA7HKBw==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 06/17] x86/apic: Add support to send IPI for Secure AVIC
In-Reply-To: <20250226090525.231882-7-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-7-Neeraj.Upadhyay@amd.com>
Date: Fri, 21 Mar 2025 16:06:09 +0100
Message-ID: <87h63m2zku.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
> +	/* Self IPIs are accelerated by hardware, use wrmsr */
> +	case APIC_SELF_IPI:
> +		cfg = __prepare_ICR(APIC_DEST_SELF, data, 0);
> +		native_x2apic_icr_write(cfg, 0);
> +		break;

Please move this into a proper inline helper with a understandable
comment and do not hide it in the maze of this write() wrapper.

>  	/* ALLOWED_IRR offsets are writable */
>  	case SAVIC_ALLOWED_IRR_OFFSET ... SAVIC_ALLOWED_IRR_OFFSET + 0x70:
>  		if (IS_ALIGNED(reg - SAVIC_ALLOWED_IRR_OFFSET, 16)) {
> @@ -154,13 +159,100 @@ static void x2apic_savic_write(u32 reg, u32 data)
>  	}
>  }
>  
> +static void send_ipi(int cpu, int vector)

Both are unsigned

> +{
> +	void *backing_page;
> +	int reg_off;
> +
> +	backing_page = per_cpu(apic_backing_page, cpu);
> +	reg_off = APIC_IRR + REG_POS(vector);
> +	/*
> +	 * Use test_and_set_bit() to ensure that IRR updates are atomic w.r.t. other
> +	 * IRR updates such as during VMRUN and during CPU interrupt handling flow.
> +	 */
> +	test_and_set_bit(VEC_POS(vector), (unsigned long *)((char *)backing_page + reg_off));

See previous mail.

> +}
> +
> +static void send_ipi_dest(u64 icr_data)
> +{
> +	int vector, cpu;
> +
> +	vector = icr_data & APIC_VECTOR_MASK;
> +	cpu = icr_data >> 32;

Yes, converting from u64 to int is the proper conversion (NOT)

> +
> +	send_ipi(cpu, vector);
> +}
> +
> +static void send_ipi_target(u64 icr_data)
> +{
> +	if (icr_data & APIC_DEST_LOGICAL) {
> +		pr_err("IPI target should be of PHYSICAL type\n");
> +		return;
> +	}
> +
> +	send_ipi_dest(icr_data);
> +}
> +
> +static void send_ipi_allbut(u64 icr_data)
> +{
> +	const struct cpumask *self_cpu_mask = get_cpu_mask(smp_processor_id());
> +	unsigned long flags;
> +	int vector, cpu;
> +
> +	vector = icr_data & APIC_VECTOR_MASK;
> +	local_irq_save(flags);
> +	for_each_cpu_andnot(cpu, cpu_present_mask, self_cpu_mask)
> +		send_ipi(cpu, vector);
> +	savic_ghcb_msr_write(APIC_ICR, icr_data);
> +	local_irq_restore(flags);
> +}
> +
> +static void send_ipi_allinc(u64 icr_data)
> +{
> +	int vector;
> +
> +	send_ipi_allbut(icr_data);
> +	vector = icr_data & APIC_VECTOR_MASK;
> +	native_x2apic_icr_write(APIC_DEST_SELF | vector, 0);
> +}
> +
> +static void x2apic_savic_icr_write(u32 icr_low, u32 icr_high)
> +{
> +	int dsh, vector;
> +	u64 icr_data;
> +
> +	icr_data = ((u64)icr_high) << 32 | icr_low;
> +	dsh = icr_low & APIC_DEST_ALLBUT;
> +
> +	switch (dsh) {
> +	case APIC_DEST_SELF:
> +		vector = icr_data & APIC_VECTOR_MASK;

So you construct icr_data first and then extract the vector from it,
which is encoded in the low bits of icr_low.

> +		x2apic_savic_write(APIC_SELF_IPI, vector);
> +		break;
> +	case APIC_DEST_ALLINC:
> +		send_ipi_allinc(icr_data);

And you do the same nonsense in all other functions. Oh well...

Thanks,

        tglx

