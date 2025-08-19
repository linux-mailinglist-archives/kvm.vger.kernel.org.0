Return-Path: <kvm+bounces-55044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D2BBAB2CEF0
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 00:00:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A33A189F252
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 21:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB51346A1A;
	Tue, 19 Aug 2025 21:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Yzk8lswj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE1B353379;
	Tue, 19 Aug 2025 21:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640425; cv=none; b=equDUJMzRFNj96ARpnCERL3Q7vNzmzBtvWhMmt4pe0iX+j+KV6jKknBBEqIun4suTvQk8+EKwdIYkxyl6Pft+3NrTpLPFj1JZjELDYsVb/URH/cBKZZ+DzUpInFeTtprvIDOMiVkGzSBtGQ5XTSY7awkC1ut7yFzvBTJDbN+8tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640425; c=relaxed/simple;
	bh=TWuKoxSWGOvopi2+snd6RASAGJ8GpSwrvFTmG3OG0Lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCMIIHz2gXnG/OGUFRjZKqEYZ5watto2ZndJbTD+v/4yYJJAgqOqRRh988bqH6UrIzBlfw3Otz/MetqJEwe7SfPI4+ZmyHjL/Gq1BnfXmp4eZadFIj6H8LEHVljps0GtmEGfeLqBqj+31qj12SC1YWlfFvsdEOyJFBMKrIRWja0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Yzk8lswj; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 12FBC40E0288;
	Tue, 19 Aug 2025 21:53:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id WjedSVQWOLqG; Tue, 19 Aug 2025 21:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755640417; bh=noHFfny8I//IpmOsSj6wN1r6QT1k27poGI6FcQyOc60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yzk8lswjcCpUClEbHaCy9TQdaeAdAR/UnVlJWVPtihsAeWuuLgrOBmt6QsX6ym+im
	 WsJsjR3OrI8cLGjFtEdX9kaQz6BKvYQkYA9Qwq70+F3MwIg6cHNitOKONcRsQQ2iOb
	 YYAe12Miq3YDNUVL/JEau/EcxyJ4lF7af3tscwz/gUhC5sxU+qdi2RMsp8py3BuzKH
	 kBjHv+UFdy6MVqRmW8a+5w4lQUt1mPUBX2zZdkBOkUtRduyRURWTXIV7/oeJKAtELR
	 wJt722rIV4APwjPBRHUJdNKSoOlcoYnyRfuDV5YcX6uKOO67IPQIQlOicGtDdYikk/
	 cE18hlPD6u94PO5cCWVUEx19kOaChQHZ5p52OvDV5/E4B31RKbRApJM47IkFLvg5Ok
	 ldXZg+QNHGa8po/DpOUx7KXh3WEqZZqeLvsHdt1u/j3ZIopsKpS1Z5qapV5ZBN418G
	 tBMEYBZi6YZYyRZFe2R7i+5HRVHwd+87hFKOw+MJ4TRVU1ATgHT5N42HfSa908BAJq
	 IezvwzgDTmskb1Y8yhYrWgmuH9Cr6u2uZCbpyNUWcHbuklfoe8X42J3HnKAM3i4082
	 vMIpxf1lnn0eJokL8LgPfp8baK5QAN2t/1QAaTO3FMo876501cKJdvGWoVS8uf5n2B
	 sq+dBuMOyPwfrqycWPVIu1X4=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7D58440E027E;
	Tue, 19 Aug 2025 21:53:15 +0000 (UTC)
Date: Tue, 19 Aug 2025 23:53:04 +0200
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
Subject: Re: [PATCH v9 04/18] x86/apic: Initialize APIC ID for Secure AVIC
Message-ID: <20250819215304.GMaKTyQBWi6YzqZ0bW@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-5-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811094444.203161-5-Neeraj.Upadhyay@amd.com>

On Mon, Aug 11, 2025 at 03:14:30PM +0530, Neeraj Upadhyay wrote:
> Initialize the APIC ID in the Secure AVIC APIC backing page with
> the APIC_ID msr value read from Hypervisor. CPU topology evaluation
> later during boot would catch and report any duplicate APIC ID for
> two CPUs.
> 
> Reviewed-by: Tianyu Lan <tiala@microsoft.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v8:
>  - Added Tianyu's Reviewed-by.
>  - Code cleanup.
> 
>  arch/x86/kernel/apic/x2apic_savic.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
> index 86a522685230..55edc6c30ba4 100644
> --- a/arch/x86/kernel/apic/x2apic_savic.c
> +++ b/arch/x86/kernel/apic/x2apic_savic.c
> @@ -141,6 +141,12 @@ static void savic_setup(void)
>  	enum es_result res;
>  	unsigned long gpa;
>  
> +	/*
> +	 * Before Secure AVIC is enabled, APIC msr reads are intercepted.

s/msr/MSR/g

Please check your whole text for such acronyms.

> +	 * APIC_ID msr read returns the value from the Hypervisor.
> +	 */
> +	apic_set_reg(ap, APIC_ID, native_apic_msr_read(APIC_ID));
> +
>  	gpa = __pa(ap);
>  
>  	/*
> -- 
> 2.34.1
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

