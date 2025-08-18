Return-Path: <kvm+bounces-54882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 718A5B2A062
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 13:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA8114E73CA
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 11:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17D226F2AC;
	Mon, 18 Aug 2025 11:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="FPTV0Erx"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ED231B112;
	Mon, 18 Aug 2025 11:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755516446; cv=none; b=tDpXHjiSMvZyNAgEixfGDcN0ejKBVtBQ8Ob+VNZOlbQx/HFUsTNiO2P9zXbk1rAdJnadelOenBBoV8bLvQNgG8YT5SpJBBN+tUDFtaVgv5y9VmMncmlTizYda8ZM4+pYrK4qZocekCyVAwf/pevtsppoS/5de93+o5TqfIw3eX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755516446; c=relaxed/simple;
	bh=uKl0nQGd8CCEZ8Elq2yeMm2FWiyMJbfJHA9mUf47WrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rBVYzDoWjI4sKeciQk/xRk80HMT44Yq55ksizcQvjqDPFp/wwGPvJ2bQ5FL339E82h/L1kG6QHuaZkleViC8GCWYl7f5Ktla+uye5v0oPnlYkTP52cBuf/woCM4r5QbWyeu/dHMpPdYUUwHT3IfiOeaPKVNHJx6zdMlDypW+njA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=FPTV0Erx; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 992F640E0217;
	Mon, 18 Aug 2025 11:27:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bqNe3jsJHRJ2; Mon, 18 Aug 2025 11:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755516438; bh=SD4F+pqPWXwwjsV9r2Or5I2Ph1uRjmHv+22D7V4Ujd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FPTV0Erx6eQvMggG/XA7GV7dIbaw+G9RNEM4z7veA3hArTqkqOmOemNyQPgja8lDU
	 jnpkYlrugJqopVaV/wmnt1ZmtaXCmC0+dsckJeKh8RGBydJLj9Auqt7bcjcBp5zfml
	 GGsPYry41WmiDicbCmS86AKWjnSH4f01p4nyxJYvBmxEMn5Dv9svwJ2cY7oefvHGH5
	 uIGTdivThE51+4wYiiMaSrw6ypaSTpVx64CkAccAtNpDNlnHALWdvXuvpMW3l9SfAY
	 D77vXiywmlK/+UiIff/VLiPTQSPNxXqOa3uqTFnvuQVV1J/gu8MkLAMC02nC8Pvo/E
	 0aq2aLj/7xj3GATIxkajkUfXG7ks0ThqkHdvBjzsJ/yCqKrM//JXkyfRumtM1+SmGk
	 XaUARys4E4tkCnhOzqfeGZPg0V5stlDt+b/HK3DDc6Su6wsbDg9L0N/ppHnxt9hjFr
	 lU6yetzhDiemtM23AxtORkB2s2dMrg7bNa02qKQkAcPvHLnnIAl6sx7BakcIcgjUS4
	 1t8bzI0lrUJwMb592hvO98UqC62xhsfec8ntWqDPJ5IUu1zfxw1EnY8OnZlU4ITbwj
	 cvA4pbCIgj4r9BMyBxAbRC1O9ICWEjDomj0T4MmcKvkFdyw6kspef9t0onLMTDNyKF
	 ES8RlHYa1CWDdeg4UwMwLnNM=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F196940E0206;
	Mon, 18 Aug 2025 11:26:55 +0000 (UTC)
Date: Mon, 18 Aug 2025 13:26:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [PATCH v9 03/18] x86/apic: Populate .read()/.write() callbacks
 of Secure AVIC driver
Message-ID: <20250818112650.GFaKMN-kR_4SLxrqov@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-4-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811094444.203161-4-Neeraj.Upadhyay@amd.com>

On Mon, Aug 11, 2025 at 03:14:29PM +0530, Neeraj Upadhyay wrote:
> Add read() and write() APIC callback functions to read and write x2APIC
> registers directly from the guest APIC backing page of a vCPU.
> 
> The x2APIC registers are mapped at an offset within the guest APIC
> backing page which is same as their x2APIC MMIO offset. Secure AVIC
> adds new registers such as ALLOWED_IRRs (which are at 4-byte offset
> within the IRR register offset range) and NMI_REQ to the APIC register
> space.
> 
> When Secure AVIC is enabled, guest's rdmsr/wrmsr of APIC registers
> result in VC exception (for non-accelerated register accesses) with

s/VC/#VC/g since you're talking about an exception vector.

> error code VMEXIT_AVIC_NOACCEL. The VC exception handler can read/write
> the x2APIC register in the guest APIC backing page to complete the
> rdmsr/wrmsr.

All x86 insns in caps pls: RDMSR/WRMSR.

> +static u32 savic_read(u32 reg)
> +{
> +	void *ap = this_cpu_ptr(secure_avic_page);
> +
> +	/*
> +	 * When Secure AVIC is enabled, rdmsr/wrmsr of APIC registers
> +	 * result in VC exception (for non-accelerated register accesses)
> +	 * with VMEXIT_AVIC_NOACCEL error code. The VC exception handler
> +	 * can read/write the x2APIC register in the guest APIC backing page.
> +	 * Since doing this would increase the latency of accessing x2APIC
> +	 * registers, instead of doing rdmsr/wrmsr based accesses and
> +	 * handling apic register reads/writes in VC exception, the read()

s/apic/APIC/g

Please be consistent across the whole set. Acronyms are in all caps. Insn
names too.

> +	 * and write() callbacks directly read/write APIC register from/to
> +	 * the vCPU APIC backing page.
> +	 */

Move that comment above the function. And also split it in paragraphs: when it
becomes more than 4-5 lines, split the next one with a new line.

> +	switch (reg) {
> +	case APIC_LVTT:
> +	case APIC_TMICT:
> +	case APIC_TMCCT:
> +	case APIC_TDCR:
> +	case APIC_ID:
> +	case APIC_LVR:
> +	case APIC_TASKPRI:
> +	case APIC_ARBPRI:
> +	case APIC_PROCPRI:
> +	case APIC_LDR:
> +	case APIC_SPIV:
> +	case APIC_ESR:
> +	case APIC_LVTTHMR:
> +	case APIC_LVTPC:
> +	case APIC_LVT0:
> +	case APIC_LVT1:
> +	case APIC_LVTERR:
> +	case APIC_EFEAT:
> +	case APIC_ECTRL:
> +	case APIC_SEOI:
> +	case APIC_IER:
> +	case APIC_EILVTn(0) ... APIC_EILVTn(3):
> +		return apic_get_reg(ap, reg);
> +	case APIC_ICR:
> +		return (u32) apic_get_reg64(ap, reg);
			    ^

no need for that space.

> +	case APIC_ISR ... APIC_ISR + 0x70:
> +	case APIC_TMR ... APIC_TMR + 0x70:
> +		if (WARN_ONCE(!IS_ALIGNED(reg, 16),
> +			      "APIC reg read offset 0x%x not aligned at 16 bytes", reg))
> +			return 0;
> +		return apic_get_reg(ap, reg);
> +	/* IRR and ALLOWED_IRR offset range */
> +	case APIC_IRR ... APIC_IRR + 0x74:
> +		/*
> +		 * Either aligned at 16 bytes for valid IRR reg offset or a
> +		 * valid Secure AVIC ALLOWED_IRR offset.
> +		 */
> +		if (WARN_ONCE(!(IS_ALIGNED(reg, 16) ||
> +				IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)),
> +			      "Misaligned IRR/ALLOWED_IRR APIC reg read offset 0x%x", reg))

What is that second thing supposed to catch?

reg can be aligned to 16 but reg - SAVIC_ALLOWED_IRR cannot be?

I can't follow the comment... perhaps write it out and not try to be clever.

> +			return 0;
> +		return apic_get_reg(ap, reg);
> +	default:
> +		pr_err("Permission denied: read of Secure AVIC reg offset 0x%x\n", reg);

Permission denied?

"Error reading unknown Secure AVIC reg offset..."

I'd say.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

