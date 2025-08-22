Return-Path: <kvm+bounces-55518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA96B32157
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 19:15:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56FAA1D62AB3
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 17:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14AF0235355;
	Fri, 22 Aug 2025 17:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="b0WMiCwl"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB181F418D;
	Fri, 22 Aug 2025 17:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755882917; cv=none; b=f6nGbJ34xXIrXZmjcuc53dZgCeZiAYqdkIUswkqKuoqOJX2vz2K59upFU4zPdoftdSE57dzRgelxCTcjy+6bJOlvIPDTBDHlScpwIpaFdeLIEg4clouqf6VEGF0ZmBMj5NUIG/J5q/QYA4vrebLPwapFZTxUeIB1UYBA6ZoWAM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755882917; c=relaxed/simple;
	bh=hJfOC4Z3RwmjhaMabVWhQoSFn5WzZtfk5U3g6RgwDjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEJRpHjew1gl6ebkFI+btrpHMXRo6PCoAvRBnibVNPJhoGtDU52/C6+vdR094gwQ8dOVtc9t5CNHF+ePd07zZZ+2R8hNzWqqfHv36qtbwaooj3fYqXhyZhYw+qd74tQBhpc85/GOxKUrl0EwjSq21H2piFbsvn3/BbJkQviEE48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=b0WMiCwl; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9998840E016D;
	Fri, 22 Aug 2025 17:15:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id QKQhwCmkg3yj; Fri, 22 Aug 2025 17:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755882910; bh=Imx6jlDCxT0P4Eh/gLuwdcYM/vVlBxkudaX4uj1O7DQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b0WMiCwlCqJbgCVBSxegKL/FbRoEec86FCJKzmGljYhMopLM6aDTLoEdYN+DfMFt6
	 K7No4P0f8z/fLc1HCgxbf3DmpopqtijFriZtSfiVfUo0Q3r4Ml4IbYXwEmwJPJ+M+J
	 SW9HSRQsjVxHwzXgFePH+nITTYr/BWFh429vnN1a6zUXd92N2qReIS+TCPYpbt6x25
	 5+lROjPj+2oMuyWJ/48tfpyIgtWurtnrQN81zDV2cbxgdf6siNcZuNSUEK/2wJm/3n
	 SOc64E5xefIWSPLeKKSJoZwhVVZeE0x3qQkPoJ9ilgXTtT0s7nBGTYmLc6ODrLbcWt
	 i1TwHMIjndwws2+X4CBGbF0mq4ADXiIbbgkmTpuMrEsBw9prTpblm06KzEpQr62/A1
	 CTPxeA2MQQ0h8GR0zbStQPkpaE6mzhEWS6vIlSydx1o4BI2pDiHCN/Aux5BmGDf/vd
	 fywfEniQisiE+FXryKusdbm3JGBjnRyM7UCUM4dJ5mSrDjicEM7d8mhkRUca+g3y/i
	 dehNRBSb1s/h83Q3rXY4QpVnbx85Lu7ZsgLwLdNRitjQr5fineg72x26pRV6GokBCQ
	 KIoDM7V93EnRsZs1deBWQI/EWAX2XdoJ440QYCUd/H7LPOQh2S0VWnijv8p+tl/1ww
	 6hCzmGuoNnuZJCBOJlhOeZsg=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9ED7A40E025A;
	Fri, 22 Aug 2025 17:14:47 +0000 (UTC)
Date: Fri, 22 Aug 2025 19:14:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
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
Message-ID: <20250822171441.GRaKilgR4XCm_v-ow_@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-8-Neeraj.Upadhyay@amd.com>
 <20250820154638.GOaKXt3vTcSd2320tm@fat_crate.local>
 <29dd4494-01a8-45bf-9f88-1d99d6ff6ac0@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <29dd4494-01a8-45bf-9f88-1d99d6ff6ac0@amd.com>

On Thu, Aug 21, 2025 at 10:57:24AM +0530, Upadhyay, Neeraj wrote:
> Is below better?

I was only reacting to that head-spinning, conglomerate of abbreviations "AVIC
GHCB APIC MSR".

> x86/apic: Add support to send IPI for Secure AVIC
> 
> Secure AVIC hardware only accelerates Self-IPI, i.e. on WRMSR to
> APIC_SELF_IPI and APIC_ICR (with destination shorthand equal to Self)
> registers, hardware takes care of updating the APIC_IRR in the APIC
> backing page of the vCPU. For other IPI types (cross-vCPU, broadcast IPIs),
> software needs to take care of updating the APIC_IRR state of the target
> CPUs and to ensure that the target vCPUs notice the new pending interrupt.
> 
> Add new callbacks in the Secure AVIC driver for sending IPI requests. These
> callbacks update the IRR in the target guest vCPU's APIC backing page. To
> ensure that the remote vCPU notices the new pending interrupt, reuse the
> GHCB MSR handling code in vc_handle_msr() to issue APIC_ICR MSR-write GHCB
> protocol event to the hypervisor. For Secure AVIC guests, on APIC_ICR write
> MSR exits, the hypervisor notifies the target vCPU by either sending an AVIC
> doorbell (if target vCPU is running) or by waking up the non-running target
> vCPU.

But I'll take a definitely better commit message too! :-)

> Ok moving it to x2apic_savic.c requires below 4 sev-internal declarations to
> be moved to arch/x86/include/asm/sev.h
> 
> struct ghcb_state;
> struct ghcb *__sev_get_ghcb(struct ghcb_state *state);
> void __sev_put_ghcb(struct ghcb_state *state);
> enum es_result sev_es_ghcb_handle_msr(...);

Well, do you anticipate needing any more sev* facilities for SAVIC?

If so, you probably should carve them out into arch/x86/coco/sev/savic.c

If only 4 functions, I guess they're probably still ok in .../sev/core.c

> This comment explains why WRMSR is sufficient for sending SELF_IPI. On
> WRMSR by vCPU, Secure AVIC hardware takes care of updating APIC_IRR in
> backing page. Hardware also ensures that new APIC_IRR state is evaluated
> for new pending interrupts. So, WRMSR is hardware-accelerated.
> 
> For non-self-IPI case, software need to do APIC_IRR update and sending of
> wakeup-request/doorbell to the target vCPU.

Yeah, you need to rewrite it like the commit message above - it needs to say
that upon the MSR write, hw does this and that and therefore accelerates this
type of IPI.

Then it is clear what you mean by "acceleration."

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

