Return-Path: <kvm+bounces-55634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D419B345A5
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:22:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74B4517B16C
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC5272FD1C5;
	Mon, 25 Aug 2025 15:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cvFmjpF9"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED7A29D05;
	Mon, 25 Aug 2025 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135285; cv=none; b=V5x8CcHc3cCp83avPxWrNgoqvY3Ce8LO6sTCatT1XgfZ9m/NMLtIKxS24N8asgYaAQCBOmpENkso+qV9U7HzoXi5l4aHzVyaoXoFlK+qyAbzafurbq+fDTQjY+BJbHVwRu8YTv1Hvbr8Sx7d+DZenONoKsdjE2EbzCNHiNdW8MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135285; c=relaxed/simple;
	bh=yht9kooDtCddKp9oq0WQwrLyOOfWIsOPxxfK0t3PcxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXUcQmi/xh7g2EBCxqUa2NYJ2BBFve4lUASAZYoYzqKeCR258K1sLn+Za/SBo+zmOPO2OpUfhj01MVjikCjNPJUSNfDcJkuwOsT+vTCoVdeOWBN5iHzWf0LvkPYbeTAL6gd+QtyGrShjjhEDuN1dcTLu1i3HPHoi3aHqKPLI+Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cvFmjpF9; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B85E340E0202;
	Mon, 25 Aug 2025 15:21:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 8lAtePMmCihR; Mon, 25 Aug 2025 15:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756135270; bh=HVRVUz/UspEp+i8rdgXyGIfJt2pNb2hsyxqGoLescTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cvFmjpF9DoPr+HS815AUPvcDZ570dC4vUbla2G+3s7jrNquQPl5HG5JqB5T9jm/xE
	 y7yY3fzZ7Gm+Vo6/dyl2wQC9B4zhKRNuJZ2lTzBUCydDfmxrWLK7Unxbk+VUkdvqNM
	 ijMaa5OuDBNfgzcPvdnMogEUZhBDBXQXZp9PHBhG0TjUOPJ4q1mJV6VZKnE4d2Nalv
	 qiFogpQYMP+6K37ZfLMM3VheQS8I6uh2lGMe96XAKt3ZPx84KpdrhJzQUK+26bXxiH
	 J2dAfrr2gmTjtSaEsmTKlF3BGzPY/JvqZ9KOtu6RBrXTyWE+s4ZuwPMKv38+xOK450
	 JUnHZZ76+fzAAVoJlSIbDCtDAva5yVcHu+NHZgs+8Dqc/j01RWdOz+2AuVX9whpPWH
	 y2WVlKBylA9c4vnv8NT07t8VUKDLce21WXbf4abxuYWxUPwd+ZIMOM718gLY+tsm5n
	 MLmMIlG3CiS95Oe6bfdjlzFZ8veLnacmzOAavy7DNP6kk3rJ354puNUdJSHHXWrdZP
	 tEINLHM4PcXGkjWhzyY1UnzdtvnrbLHR09QheMh7rZCHN2AuouoAJYegf5r641kJSF
	 SVbamKDeP17xAyboKuiYQ1Yml8RTnqWOJ3Ai23+dqzgIBcwizGO+u06opGPnmjre8P
	 CabiZzIAjXFgt0Se8J02DZ04=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3D22F40E01A1;
	Mon, 25 Aug 2025 15:20:49 +0000 (UTC)
Date: Mon, 25 Aug 2025 17:20:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [PATCH v9 11/18] x86/apic: Allow NMI to be injected from
 hypervisor for Secure AVIC
Message-ID: <20250825152042.GAaKx_SlTqYRBywwZl@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-12-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811094444.203161-12-Neeraj.Upadhyay@amd.com>

On Mon, Aug 11, 2025 at 03:14:37PM +0530, Neeraj Upadhyay wrote:
> Secure AVIC requires "AllowedNmi" bit in the Secure AVIC Control MSR
> to be set for NMI to be injected from hypervisor.

"So set it."

And drop that sentence repeating the whole thing again.

> Set "AllowedNmi"
> bit in Secure AVIC Control MSR to allow NMI interrupts to be injected
> from hypervisor.

> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 2a6d4fd8659a..2efc03d324c0 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -703,6 +703,9 @@
>  #define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
>  #define MSR_AMD64_SNP_RESV_BIT		19
>  #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
> +#define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
> +#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
> +#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
>  #define MSR_AMD64_RMP_BASE		0xc0010132
>  #define MSR_AMD64_RMP_END		0xc0010133
>  #define MSR_AMD64_RMP_CFG		0xc0010136

s/_SECURE_AVIC_/_SAVIC_/g

and you'll have room again.

> diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
> index 62681fa4f1a5..2bae2f711959 100644
> --- a/arch/x86/kernel/apic/x2apic_savic.c
> +++ b/arch/x86/kernel/apic/x2apic_savic.c
> @@ -23,6 +23,11 @@ struct secure_avic_page {
>  
>  static struct secure_avic_page __percpu *secure_avic_page __ro_after_init;
>  
> +static inline void savic_wr_control_msr(u64 val)
> +{
> +	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, lower_32_bits(val), upper_32_bits(val));
> +}

Zap that silly wrapper.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

