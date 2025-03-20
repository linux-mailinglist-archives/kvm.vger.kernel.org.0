Return-Path: <kvm+bounces-41576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4DD0A6AA56
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 16:52:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF50D3AF97F
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 15:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645F01EB1BE;
	Thu, 20 Mar 2025 15:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="T8JZCY2E"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A583C14B08A;
	Thu, 20 Mar 2025 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742485951; cv=none; b=sK7ho7C2vAUByNWTTynNp2OgNWGEST9rr0PTikDJHk8HNSHgw2/iSMrt4HDD7pWTj2p82pA2TPxeBZcSncWf1YaXQbvvgoJUFP0EWDHGBIPTGvcoyqBduvg2+1tL0qVHZpqgfagicybP8XA2kHmQ4ootO0F4KEIFUXq5jHs2gPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742485951; c=relaxed/simple;
	bh=we0s46XnY4djI4sN1c19CYNgTaEDzQ013PUuA1pnn4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWlnlb94hzuTw7zK5xFyihQi5Ym6PWbj9kGRusbcYXYwX/L6xRqxZ9vDcK6evYQJZ5mk7vSZEM9w6a5+nkLHtrzbcBOmZAugFSRpbLHW/ZsZyPQ1DCe8yKh94xGo+kyivKfdINFuFK8JSGUDZ8QQze2NQHGLfkEust84Bnn2vrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=T8JZCY2E; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BC35740E0215;
	Thu, 20 Mar 2025 15:52:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id vJUJwGGf0JCK; Thu, 20 Mar 2025 15:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1742485937; bh=LIeJt5+Q0+9D7tT1FOs3SWrO8QvbwUTo126Mca5x2PM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T8JZCY2EQRPdQZVFCuH/v8fsim6Ze6pWzEVcqnNfFfo9rbHy6zxT9ETCZKXbKS25B
	 hikDbdNUixOWpd7OQQSNef0vs2j51WrVTTmgvwVl3Ko0j62iACZnmyBrmoujPuy1Er
	 VRvNW+4eNlU/HqxJQ9s9AFYFtoSwb6WgJKwBxZ/k0Njv0yTDteEezcIZFs9VsrRZtE
	 K8UcEPDebJ1ITNmlfNU12kdJa0kENDQVUwsf02QUGZNZSdesPx4VZWnZo/0XzXKBDh
	 3N7H72g5y2nY9R7ItT5oRs6+UQ/vSfOX76fMfW66dAgtNnrjXTXL2PjnOvA0++Tr+C
	 LQVBcr5M7v8gnwcG6P7ki+iiO95vUQC4FxONRZ25DdIoqZ+mKrVawYWuDI6u6nKbc1
	 ksSNSpFbhTeCwiQoUZ4v7OLZBbnXUnxPZ6CTOg+QIqlOo04qa/3zZs9rPTTHuj95eB
	 ogD/2tCHxf4kAUyHjqU/NlhVzrecdIC/tSkP3OsyWvpCFpTyE0KkdctTd6Ew4K49cf
	 37Wz/KaP3DYT5GPkcEq8ERo2JFtOW0bNYpq9UVggoWeRzSFFz7EhZJ3nEpYLHmoZ0I
	 RqHh6SuCjwc4TdvkVEzuh5u5Y8hXfRKmcDA1+vmH7F1bXNfOpqd6of3WOcTIld7W0y
	 mmUZSVwMI+e6ulm1eFeaIRU4=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E802740E015D;
	Thu, 20 Mar 2025 15:51:56 +0000 (UTC)
Date: Thu, 20 Mar 2025 16:51:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
Message-ID: <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>

On Wed, Feb 26, 2025 at 02:35:09PM +0530, Neeraj Upadhyay wrote:
> +config AMD_SECURE_AVIC
> +	bool "AMD Secure AVIC"
> +	depends on X86_X2APIC
> +	help
> +	  This enables AMD Secure AVIC support on guests that have this feature.

"Enable this to get ..."

> +	  AMD Secure AVIC provides hardware acceleration for performance sensitive
> +	  APIC accesses and support for managing guest owned APIC state for SEV-SNP
> +	  guests. Secure AVIC does not support xapic mode. It has functional
> +	  dependency on x2apic being enabled in the guest.
> +
> +	  If you don't know what to do here, say N.
> +
>  config X86_POSTED_MSI
>  	bool "Enable MSI and MSI-x delivery by posted interrupts"
>  	depends on X86_64 && IRQ_REMAP
> @@ -1557,6 +1570,7 @@ config AMD_MEM_ENCRYPT
>  	select X86_MEM_ENCRYPT
>  	select UNACCEPTED_MEMORY
>  	select CRYPTO_LIB_AESGCM
> +	select AMD_SECURE_AVIC

AMD_MEM_ENCRYPT doesn't absolutely need AMD_SECURE_AVIC so this can go.

>  	help
>  	  Say yes to enable support for the encryption of system memory.
>  	  This requires an AMD processor that supports Secure Memory

...

> +static void x2apic_savic_send_IPI(int cpu, int vector)
> +{
> +	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
> +
> +	/* x2apic MSRs are special and need a special fence: */
> +	weak_wrmsr_fence();
> +	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
> +}
> +
> +static void

Unnecessary line break.

> +__send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
> +{
> +	unsigned long query_cpu;
> +	unsigned long this_cpu;
> +	unsigned long flags;
> +
> +	/* x2apic MSRs are special and need a special fence: */
> +	weak_wrmsr_fence();
> +
> +	local_irq_save(flags);
> +
> +	this_cpu = smp_processor_id();
> +	for_each_cpu(query_cpu, mask) {
> +		if (apic_dest == APIC_DEST_ALLBUT && this_cpu == query_cpu)
> +			continue;
> +		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
> +				       vector, APIC_DEST_PHYSICAL);
> +	}
> +	local_irq_restore(flags);
> +}
> +
> +static void x2apic_savic_send_IPI_mask(const struct cpumask *mask, int vector)
> +{
> +	__send_IPI_mask(mask, vector, APIC_DEST_ALLINC);
> +}
> +
> +static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
> +{
> +	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
> +}
> +
> +static int x2apic_savic_probe(void)
> +{
> +	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
> +		return 0;
> +
> +	if (!x2apic_mode) {
> +		pr_err("Secure AVIC enabled in non x2APIC mode\n");
> +		snp_abort();
> +	}
> +
> +	pr_info("Secure AVIC Enabled\n");

That's not necessary.

Actually, you could figure out why that

	pr_info("Switched APIC routing to: %s\n", driver->name);

doesn't come out in current kernels anymore:

$ dmesg | grep -i "switched apic"
$

and fix that as a separate patch.

Looks like it broke in 6.10 or so:

$ grep -E "Switched APIC" *
04-rc7+:Switched APIC routing to physical flat.
05-rc1+:Switched APIC routing to physical flat.
05-rc2+:Switched APIC routing to physical flat.
05-rc3+:Switched APIC routing to physical flat.
05-rc4+:APIC: Switched APIC routing to: physical flat
05-rc6+:Switched APIC routing to physical flat.
06-rc4+:APIC: Switched APIC routing to: physical flat
06-rc6+:APIC: Switched APIC routing to: physical flat
07-0+:APIC: Switched APIC routing to: physical flat
07-rc1+:APIC: Switched APIC routing to: physical flat
07-rc7+:APIC: Switched APIC routing to: physical flat
08-rc1+:APIC: Switched APIC routing to: physical flat
08-rc3+:APIC: Switched APIC routing to: physical flat
08-rc6+:APIC: Switched APIC routing to: physical flat
08-rc7+:APIC: Switched APIC routing to: physical flat
09-rc7+:APIC: Switched APIC routing to: physical flat
10-rc1+:APIC: Switched APIC routing to: physical flat
10-rc6+:APIC: Switched APIC routing to: physical flat
<--- EOF

Thx.


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

