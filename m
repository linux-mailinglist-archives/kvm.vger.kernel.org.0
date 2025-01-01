Return-Path: <kvm+bounces-34458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E819FF47B
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 17:11:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 845CA3A2C8B
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 16:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9BCA1E32B9;
	Wed,  1 Jan 2025 16:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VLvVJJsc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD7A1E1044;
	Wed,  1 Jan 2025 16:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735747875; cv=none; b=kLtlRaTQSuHli97VqH14Ny0qMzX9g40ZFRvYyGNBHnof+lMu2+eR+mTrFA1Izjaj7fAoG/uPRWmicgZON/wV1nRKer7OGGrIzUsohHfgGsNw3WRFdhhH3bGpdVs5aFUmi94mXbCvqgXSYvrMRZ/GVRleIoS0pRwnQRFb3FBmOlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735747875; c=relaxed/simple;
	bh=6uFz24wUp5+EQNDc6aWEGFFUA/AS+bXdaxa2YC4AJtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LmCekg2dTnLlNReBphsBVOWvlm5iIHcYoc+GQ51xZi8NqVgAR4ZXgjUn96PAYNdyIVxNS/VIfr3pXKl60ftdLumzHzcKBYNRpfApy8n00vH9cDwQPXXD/MIwNUGEQu4AmNDJnF42imrprFetRzFTEbpVwE0ov5tpHrxKbpf5jZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VLvVJJsc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8755240E02D8;
	Wed,  1 Jan 2025 16:11:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id f3MrholDq4kT; Wed,  1 Jan 2025 16:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735747865; bh=W1F1gigCjrVkSnSF+oNoMRDu/gc8EAAFY+clWA6Isns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VLvVJJscEzb0trv8RpJpEEp3Qwc/OvnoR7ihseBEXI8IgKmzPNv4Nx/EBf0COUCw1
	 XpUv627HEgfOshbDoii3QOYPG7o/VuQiSnnMIpCcQY4TcsRGG0u6byh/H/6H6ATuKH
	 vguPihHZtn6Zw1zP0yBenOmIZJls+sKyNtdSyJmkbtJkHXRl1SbrbsXYIIan7vEdPP
	 rX1cUVJx3oHkSv8bccEl2I1hqrxG0s6aFbi1TGqNW4Qwsc5N0NwMd4tAz+DWk+BQa/
	 tb+0mOySRzGskTeksxsNuknJKuMO/H972fexh/y4sCWPBOevmHrxhsSFPfa1wRWLxt
	 hDvhXPshiNVDi8SiWqkNiPFs4FOOLgZw2oN/MgYTII73TlpPEmZyCUaseweBtyjFXu
	 4HiJcO5QEbkAxIU6fFJIubmw3DXiHCYx6JcacmdRzWZRJSUqSZS1fU1ugKSUVFIuGX
	 LEktvi3bwj4LCgpK6krkdlJxYJDn/6mxVyYAQCPz3CyKdmFskyWTrZ+ltAKPCUHRPB
	 1RRTnD3bxmyyrn+YT2Ofcp06IIqkXLaIDgaro3mbJcfLL/fB2LILRFf17zvjlRc3+Z
	 sBYfORQzxIDnDsOz3IsE+RWI3i/pQVmIfDBKV7j/f6qO6k+x4Z9c+Dm0b22Uk2e3fE
	 iELLdZBqN8DIzyCvfOgqmeDw=
Received: from zn.tnic (pd953008e.dip0.t-ipconnect.de [217.83.0.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8AA8940E02D6;
	Wed,  1 Jan 2025 16:10:54 +0000 (UTC)
Date: Wed, 1 Jan 2025 17:10:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
Message-ID: <20250101161047.GBZ3VpB3SMr9C__thS@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-7-nikunj@amd.com>
 <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
 <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
 <20241210171858.GKZ1h4Apb2kWr6KAyL@fat_crate.local>
 <ff7226fa-683f-467b-b777-8a091a83231e@amd.com>
 <20241217105739.GBZ2FZI0V8pAIy-kZ8@fat_crate.local>
 <7a5de2be-4e79-409a-90f2-398815fc59c7@amd.com>
 <20241224115346.GAZ2qgyt3sQmPdbA4V@fat_crate.local>
 <a28dfd0a-c0ab-490f-bc1a-945182d07790@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a28dfd0a-c0ab-490f-bc1a-945182d07790@amd.com>

On Wed, Jan 01, 2025 at 02:14:38PM +0530, Nikunj A. Dadhania wrote:
> @@ -1437,8 +1471,16 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>  	/* Is it a WRMSR? */
>  	write = ctxt->insn.opcode.bytes[1] == 0x30;
>  
> -	if (regs->cx == MSR_SVSM_CAA)
> +	switch (regs->cx) {
> +	case MSR_SVSM_CAA:
>  		return __vc_handle_msr_caa(regs, write);
> +	case MSR_IA32_TSC:
> +	case MSR_AMD64_GUEST_TSC_FREQ:
> +		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> +			return __vc_handle_msr_tsc(regs, write);

Again: move all the logic inside __vc_handle_msr_tsc().

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

