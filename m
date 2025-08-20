Return-Path: <kvm+bounces-55189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF256B2E17A
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33F3F4E34C9
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BADC132255B;
	Wed, 20 Aug 2025 15:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ddBruz86"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58040311C2D;
	Wed, 20 Aug 2025 15:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755704835; cv=none; b=XJAhOb+Oea+GBUVWnqciKQd9yaIqrRVqrGxWiFXWX+D70zWlc+1y9eaaQxeDX2A469PjaZ+QNwsc3yN6Ap6h7YGUw0B/GAdgNyVGmesEkAgj8ebPLbkEyeGfVJrh525pVzvqsBvRWyStcf6LGmock2goQrpmgEcobkJ4R0SrS6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755704835; c=relaxed/simple;
	bh=GuWjLqYKSZ/aoYK30GW/t4+9hHnz18vrhQHyUPJL2m4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QSY5rtF68+qFbmHmIycsxdj4f++7YAPQ1p1CZiWDuyncEad+M26VBH3Cn2GInOYE69h+gRXHdv8hhkwlIp4UYlWlWEuaM3XtR+db47t8TfDhVKUHxHJgY10YJUzfzzC15IlIFbdHWYyHEknUqUtU+XhphjWQYS/icOCZPNNAeLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ddBruz86; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5D04E40E0286;
	Wed, 20 Aug 2025 15:47:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Nys5oPv9JVH4; Wed, 20 Aug 2025 15:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755704827; bh=CfLg1xiZMCBl5orUohLMUAUF4PljRhSWUc00xPK0J7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ddBruz86auWNNUExgl49tNXZY8XqFLTWbKmexN99jmrGJ98pi9owTPdtoNXBDAB2/
	 hb2JiaVMVfqJng6hK1z8D+TLqDJWSiF5W4IE+oCoSflyRw8RAj5DDSF0lDb0ufaBVy
	 JUdui75Bi69SxD7xIHxbviPIlyy5kmycmaiXSswtjE9gqHcTBGPDS1Fc6Ve3iJ3jak
	 C0voX3xOx67yftrVDke0BDN9YIn7u5eJjs1g4kCXipnWmTQTq2zNULba48N1uPukTo
	 FEdrqWUHa/pMqGeiyZr9vhlppY58I9w2eyyht9uTmNS5EX0IFoWJTOJAa3oRr1KEBm
	 2aeYosjab9zBjzhJ8S/R2+48ixmi947gBukoeD5N7D1OZU5X8qNDqVratOPMz4XKXj
	 ehST8q7lsOIzYyfmG5mqXoZpt/iE9YcoXFtYQ3D96opv21nEHlY35lgeesKk/GBhMk
	 u4ExgzC+168pAwkUkQzJsU3PQ+tyT9t7QJUj46JTpNnXH+DTgUxZK6T8108eGu2h8v
	 uo983JkFbHHnUnqibBMvw23nxhgl5oEtswiRPtTifpLuzitC7oxyiUK499+xSs0Wk6
	 BgTgqNiEd/eh66pHE6hANPyxjHuIP1yK9+VtSCuGJ5P8Nwde5LaA+X7QMClJXOqtAd
	 +2NSukbHwkS6lFGjb6Ojx++4=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C3CD740E0163;
	Wed, 20 Aug 2025 15:46:44 +0000 (UTC)
Date: Wed, 20 Aug 2025 17:46:38 +0200
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
Subject: Re: [PATCH v9 07/18] x86/apic: Add support to send IPI for Secure
 AVIC
Message-ID: <20250820154638.GOaKXt3vTcSd2320tm@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-8-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811094444.203161-8-Neeraj.Upadhyay@amd.com>

On Mon, Aug 11, 2025 at 03:14:33PM +0530, Neeraj Upadhyay wrote:
> With Secure AVIC only Self-IPI is accelerated. To handle all the
> other IPIs, add new callbacks for sending IPI. These callbacks write
> to the IRR of the target guest vCPU's APIC backing page and issue
> GHCB protocol MSR write event for the hypervisor to notify the
> target vCPU about the new interrupt request.
> 
> For Secure AVIC GHCB APIC MSR writes, reuse GHCB msr handling code in
	     ^^^^^^^^^^^^^^^^^^

say what now?!

> +void savic_ghcb_msr_write(u32 reg, u64 value)

I guess this belongs into x2apic_savic.c.

> +{
> +	u64 msr = APIC_BASE_MSR + (reg >> 4);
> +	struct pt_regs regs = {
> +		.cx = msr,
> +		.ax = lower_32_bits(value),
> +		.dx = upper_32_bits(value)
> +	};
> +	struct es_em_ctxt ctxt = { .regs = &regs };
> +	struct ghcb_state state;
> +	enum es_result res;
> +	struct ghcb *ghcb;
> +
> +	guard(irqsave)();
> +
> +	ghcb = __sev_get_ghcb(&state);
> +	vc_ghcb_invalidate(ghcb);
> +
> +	res = sev_es_ghcb_handle_msr(ghcb, &ctxt, true);
> +	if (res != ES_OK) {
> +		pr_err("Secure AVIC msr (0x%llx) write returned error (%d)\n", msr, res);
> +		/* MSR writes should never fail. Any failure is fatal error for SNP guest */
> +		snp_abort();
> +	}
> +
> +	__sev_put_ghcb(&state);
> +}

...

> +static inline void self_ipi_reg_write(unsigned int vector)
> +{
> +	/*
> +	 * Secure AVIC hardware accelerates guest's MSR write to SELF_IPI
> +	 * register. It updates the IRR in the APIC backing page, evaluates
> +	 * the new IRR for interrupt injection and continues with guest
> +	 * code execution.
> +	 */

Why is that comment here? It is above a WRMSR write. What acceleration is it
talking about?

> +	native_apic_msr_write(APIC_SELF_IPI, vector);
> +}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

