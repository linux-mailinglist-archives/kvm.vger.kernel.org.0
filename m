Return-Path: <kvm+bounces-28152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD534995784
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 21:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64A521F2655F
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 19:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C764213ED1;
	Tue,  8 Oct 2024 19:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="gLwORhLF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0D01E0E1F;
	Tue,  8 Oct 2024 19:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728414991; cv=none; b=s/kjqy8aADM6sD23AExG4V5kbwST3jvmkh4WxA+xjJlArhToQnulAv1BYcKh7PGQ3k0h5IOsfkJ6Czt93QyaWxTUm7utUkjLfBZqs06SqhqVSP47C7a/41d7B1Gt9Slg7Y2Qeo4u1Tev83RbEm/uDkJgxv73mF4ldT6IsuSvw+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728414991; c=relaxed/simple;
	bh=lYbyo+A+uUJ7b3hd8/KN6hpCmPCBCTCSQ+I7ufCu12k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TB6OQ2v4Dt+/6LHQcRtj0GyiPIKUXAK3TvWRzYomOHH5aqHOBc6W13kbvkuNK6pUpm6ZRiRbWl/xrj7PDFAOfe/eHMjHs+c3Eh+oHPO8ZwIpDcd/u0fNfHezvuc1RVYwRPOqLuHMeZVSWjWlBPHnpHmVfRz5AKwDGQgnh1B2M7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=gLwORhLF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 313BB40E015F;
	Tue,  8 Oct 2024 19:16:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KZszS8Uy29l7; Tue,  8 Oct 2024 19:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1728414980; bh=VFyob7KPVxpSAJVJAnRtwFGOUftj7P0e2hmVXC4ret0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gLwORhLFkmCNRDnLV9Gx6d0Ffcj9bVIP/eB5jAIiyaezkVHYG+WjPn9V40am9ydu8
	 kbGibNmcQ8OzGQmY8X33KsvtoJzfKfs+p85hTgQiTMd0mpOlQP3e1Rz91R1+D22QRh
	 y+clQ77ffa4krajH9AcY/BQRnQ47ozWP+Ea9iE8EAzCLhR/EOwMBrBELEJsNTiEtkw
	 d2XTTpUxaF9DZdVlUBGOaCieUgtp1wm/w/K/pvoL7qfI7LzEFGlZmmfn4MRgSCymYN
	 ajSMK/HUmR6Sa/5DGbFmlnP9nVuUiFzaas/izJoqjPpMVWg9u4cTVEQUq+NDuntN4L
	 KbHf1VQbfMC4hMgIyyVgS66xj/LA/n0NBnRtV9VT8hmg7HFP5CYtyYNGtusScjHp2B
	 vd4g5Vii63Yl3pszajKWQ7AXNCk7KyLNa1dCs7Tw56d6GFVNrf+0QCeaKXB482wUy+
	 /WLp97ILQP8i4GDeHxKMznWqeWv5rsGQ3Ot8R7n8u9HolaffWrIk8V8VT+ZpPqi9FM
	 OQzVXyqwZ7EnquG0EdbOuT2VZi0t1eG06vFIpLCLNdPj/KmTxZs5SCHzbEH2xmxRzY
	 8d3j0h4AfK9gayi0qrRcDMWuD0bZiPmP5S785RPbMPDnS95Goz0dmTHYWYqRfWwg2f
	 vShBGqdl8of/Kqrrkl96mmAM=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BE4D740E0263;
	Tue,  8 Oct 2024 19:16:02 +0000 (UTC)
Date: Tue, 8 Oct 2024 21:15:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <20241008191556.GNZwWE7EsxceGh4HM4@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>

On Fri, Sep 13, 2024 at 05:06:52PM +0530, Neeraj Upadhyay wrote:
> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index cd44e120fe53..ec038be0a048 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -394,6 +394,7 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
>  				 MSR_AMD64_SNP_VMSA_REG_PROT |		\
>  				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
>  				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
> +				 MSR_AMD64_SNP_SECURE_AVIC_ENABLED |	\
>  				 MSR_AMD64_SNP_RESERVED_MASK)
>  
>  /*

Shouldn't this hunk be in the last patch of the series, after all the sAVIC
enablement has happened?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

