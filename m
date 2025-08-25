Return-Path: <kvm+bounces-55640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80D0DB346A2
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 18:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7548B1B2227D
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 16:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09F4B2FF178;
	Mon, 25 Aug 2025 16:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QUVhI7yI"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFB5278165;
	Mon, 25 Aug 2025 16:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756137796; cv=none; b=qYG9JzYp7aHxsuk07FvdUVUtywOW7xbgciNookNuqnQBPLAIySUjSPrXwTylK9HBxAQQrkhT1OdqILPTaN52q8JLbUUUeMHtvIy9hPKOA9R7TnzFBGRBEevrMEkYtQR7F9xdwqOKH3PNV3S3dKoR4/Fkb7cKUDYiuahCgspcm7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756137796; c=relaxed/simple;
	bh=TMYmbV75ENfuMziIrnJPbcxfpn58qSXP8cMZpCdt1wA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sK0rIvNKt+mfyA38TOcSgca0xRxCnUvZHDz/HfjWSo4zXwxyehsORHl9KAiZ5yRxkHLepu4xyjqbJ9V9MesYNYNDWj2+hYvgMBwYIvwihp11oFuYTJZWlw1skrnugreV4enu6w8esV01V5A3dPWO3vavymXCx6wtkjITIqEkweU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=QUVhI7yI; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CAF5440E023B;
	Mon, 25 Aug 2025 16:03:11 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Q3sFWL6bUJ1u; Mon, 25 Aug 2025 16:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756137788; bh=oSJSKtGTsSDr5xrTo430clkfvINZDjV2vXxA4FluFZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QUVhI7yIALl3eV/3zTlSZIP3Ub3uaGYOS0p7uNJ904u0piDWlT3aS9ILbyLApjHLb
	 FA6N8mDWXbh5qi9a9ay7ttj9pwSbJGFpn5DOiMwQGWiqJgrwrYnH5T7HFqqBku7G26
	 t32tAI9pVnb6LvmWo1xlqoddyQiSeu3Pl2/CjCIUDQZlhFsXLNwPKDTRE7Bv1KTa5+
	 3INp5waK/nY5JoF+BpkPEZQcN9MSl3ALh1Xmtoq/jRO2lUCQzuOYWUxcgPTtD9pxW2
	 1HpMzGfBFRgcm4kpYdzw7fiqWhV2G7Cv+T6/ciTGSu7CS5NTRX09fKXiFzi/tdAyyI
	 VVMnyMQhoF+1Kn4/vfVeEIyJsk3Pj7r0CIJWXrfJ8VH768FztFTY6+FCmggGkbQvwk
	 N4VKAoEMlB8ha5kZNvR6X1Z4qMqZyzdVP67SGPb4fFMuLZ0+3Qt0TPPp3WPy9Cygay
	 yo1nvZ9QWa6n2qXwYgzceCEUv9aYTfxSoyxz7oo3yLffxuXifMxyCBJwa5pqlcBr72
	 PI3vLCxWIgEST34bkJbqmUHV/KaWQZc5+qto/VCtdX+yvcCKv+PIHEsdgySh0KKC49
	 LgZ9/WyIO8zkfRvc6xALp++/rXYuSgKuhqicYPVgyyhRJ1Y4/WH7hqG2nJNcUqDlL8
	 OLh51o6uiSsR6WDh43Em9ZB0=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 42CEA40E0217;
	Mon, 25 Aug 2025 16:02:46 +0000 (UTC)
Date: Mon, 25 Aug 2025 18:02:45 +0200
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
Subject: Re: [PATCH v9 00/18] AMD: Add Secure AVIC Guest Support
Message-ID: <20250825160245.GCaKyJJcIbHQ8VwnMv@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>

On Mon, Aug 11, 2025 at 03:14:26PM +0530, Neeraj Upadhyay wrote:
> Kishon Vijay Abraham I (2):
>   x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
>   x86/sev: Enable NMI support for Secure AVIC
> 
> Neeraj Upadhyay (16):
>   x86/apic: Add new driver for Secure AVIC
>   x86/apic: Initialize Secure AVIC APIC backing page
>   x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
>   x86/apic: Initialize APIC ID for Secure AVIC
>   x86/apic: Add update_vector() callback for apic drivers
>   x86/apic: Add update_vector() callback for Secure AVIC
>   x86/apic: Add support to send IPI for Secure AVIC
>   x86/apic: Support LAPIC timer for Secure AVIC
>   x86/apic: Add support to send NMI IPI for Secure AVIC
>   x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
>   x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
>   x86/apic: Handle EOI writes for Secure AVIC guests
>   x86/apic: Add kexec support for Secure AVIC
>   x86/apic: Enable Secure AVIC in Control MSR
>   x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC
>     guests
>   x86/sev: Indicate SEV-SNP guest supports Secure AVIC

Ok, you're all reviewed.

I don't see any big issues with the set anymore except nitpicks I've replied
with to each patch separately. You can work in all review feedback and send
the next revision which I'll queue unless someone objects.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

