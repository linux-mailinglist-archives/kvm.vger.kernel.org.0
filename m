Return-Path: <kvm+bounces-35675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E007EA13F4F
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 17:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA0A4188E480
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 16:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5AE322CBD3;
	Thu, 16 Jan 2025 16:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ZhECqcwc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187BD8635B;
	Thu, 16 Jan 2025 16:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737044753; cv=none; b=F3c7t0DHkVD6SLgHyvTh37oRgzEQkVRBQQ+h1JkWbSC9Yks1Ha/lZh83kLl2gDYxlOVXg/G54X0FIgvXMpEYHqf5dTd9/3kjQM5FW6Zqp30WU4/0rHWNCjOv4n9yWWmRFPn7CD+03xizALFL1gosTTaWileGbWd1HTOICYKHWLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737044753; c=relaxed/simple;
	bh=D9vs0Pik0obmHjTbTGJXKLbmJdWS45sJfIOBqU4oo2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ldFJsibJC294BgkS0qsFe+hJOwfLeLjyQdWlbKluO+pkXe/T8+3d8UVKImy4ctLEgx4zU9dXjgMQdZaL4dVMan2oXfXwctYlw/DEGTOURJERK7ZdeFPDQVDB0I+HlJCatAM3J3Vcvm2leCL7+EZO9a2eb7oWuAY5rsh7jxyu8Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ZhECqcwc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A1A3740E0289;
	Thu, 16 Jan 2025 16:25:49 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id OK6YAIpT06NV; Thu, 16 Jan 2025 16:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1737044746; bh=ugjD+bG6MAlY16q2glKYww+iGyZHisaYpi4PdwxftP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZhECqcwcBU1LbtABt1WLuInauH12PWJ1wtzKkJSmi438RyI0cp8SMTBuG/I/3ZYM5
	 P/O90EMoQoTDNouSiDBBgZr50dvyQB0XmZ3bkR/fld+6xFo5h1DsGDt1tzfOPNteut
	 OKNuVuSjuX7zwmMCt0wIPskEyMNSlPpHVs/Mum/NeA2aOP8k5dyv2GQdDRJQ0z1Bg1
	 fRiTBJljO4So1QnsFJTQT0jnqF0igaqJQrB3gs48R6f4mBpOtlCzF6BItOkJKgy2Px
	 I1SqEdvD2nn5QDNca4k5as/2c7Aet9/Z9icgJpIVFrDYrAjSJIdaos0RFmqWBQQ28z
	 xvlKCa2Pge9dRWJPoH+y9qUqx9uuJei7JALf9bozLcbNmVCnqd5sJC3U2rF367Lu/d
	 pQoLelVNc5pzIVj8z7Quo4j84MXZckYqqBsfIJM17dXF4XbCOlvU42Y/qPKz+OOO5m
	 MWekJxK4uiMONv8yexsuyoWvc3CUW3FEw4KI1jzcEFGBVac+Ot1ri/tVxLJ2rC93jv
	 ZibvWC6osvUs3bu4x58JEPTOxj2kJEtmWjwKDSYFkCnRAVRIlo11qR9LW8sv+XliSg
	 mpggOjKIwYH9RpRjFkJs38Lq7Csdl+dQUoHWpHaor1Qja9KXVzFhIxQybkO5In8kyY
	 OmybLsTQ6RpJF88mMpoTqXCk=
Received: from zn.tnic (p200300eA971F934F329C23fffEA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:934f:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4720140E0288;
	Thu, 16 Jan 2025 16:25:31 +0000 (UTC)
Date: Thu, 16 Jan 2025 17:25:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	pgonda@google.com, pbonzini@redhat.com, francescolavra.fl@gmail.com,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
Message-ID: <20250116162525.GFZ4ky9TdSn7jltgw7@fat_crate.local>
References: <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
 <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>
 <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
 <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com>
 <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com>
 <Z36FG1nfiT5kKsBr@google.com>
 <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
 <Z36vqqTgrZp5Y3ab@google.com>
 <4ab9dc76-4556-4a96-be0d-2c8ee942b113@amd.com>
 <Z4gqlbumOFPF_rxd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z4gqlbumOFPF_rxd@google.com>

On Wed, Jan 15, 2025 at 01:37:25PM -0800, Sean Christopherson wrote:
> My strong vote is prefer TSC over kvmclock for sched_clock if the TSC is constant,
> nonstop, and not marked stable via command line.

So how do we deal with the case here where a malicious HV could set those bits
and still tweak the TSC?

IOW, I think Secure TSC and TDX should be the only ones who trust the TSC when
in a guest.

If anything, trusting the TSC in a normal guest should at least issue
a warning saying that we do use the TSC but there's no 100% guarantee that it
is trustworthy...

> But wait, there's more!  Because TDX doesn't override .calibrate_tsc() or
> .calibrate_cpu(), even though TDX provides a trusted TSC *and* enumerates the
> frequency of the TSC, unless I'm missing something, tsc_early_init() will compute
> the TSC frequency using the information provided by KVM, i.e. the untrusted host.

Yeah, I guess we don't want that. Or at least we should warn about it.
 
> +	/*
> +	 * If the TSC counts at a constant frequency across P/T states, counts
> +	 * in deep C-states, and the TSC hasn't been marked unstable, prefer
> +	 * the TSC over kvmclock for sched_clock and drop kvmclock's rating so
> +	 * that TSC is chosen as the clocksource.  Note, the TSC unstable check
> +	 * exists purely to honor the TSC being marked unstable via command
> +	 * line, any runtime detection of an unstable will happen after this.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
> +	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
> +	    !check_tsc_unstable()) {
> +		kvm_clock.rating = 299;
> +		pr_warn("kvm-clock: Using native sched_clock\n");

The warn is in the right direction but probably should say TSC still cannot be
trusted 100%.

> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 0864b314c26a..9baffb425386 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -663,7 +663,12 @@ unsigned long native_calibrate_tsc(void)
>  	unsigned int eax_denominator, ebx_numerator, ecx_hz, edx;
>  	unsigned int crystal_khz;
>  
> -	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> +	/*
> +	 * Ignore the vendor when running as a VM, if the hypervisor provides
> +	 * garbage CPUID information then the vendor is also suspect.
> +	 */
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL &&
> +	    !boot_cpu_has(X86_FEATURE_HYPERVISOR))
>  		return 0;
>  
>  	if (boot_cpu_data.cpuid_level < 0x15)
> @@ -713,10 +718,13 @@ unsigned long native_calibrate_tsc(void)
>  		return 0;
>  
>  	/*
> -	 * For Atom SoCs TSC is the only reliable clocksource.
> -	 * Mark TSC reliable so no watchdog on it.
> +	 * For Atom SoCs TSC is the only reliable clocksource.  Similarly, in a
> +	 * VM, any watchdog is going to be less reliable than the TSC as the
> +	 * watchdog source will be emulated in software.  In both cases, mark
> +	 * the TSC reliable so that no watchdog runs on it.
>  	 */
> -	if (boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
> +	if (boot_cpu_has(X86_FEATURE_HYPERVISOR) ||
> +	    boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
>  		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
>  
>  #ifdef CONFIG_X86_LOCAL_APIC

It looks all wrong if a function called native_* sprinkles a bunch of "am
I a guest" checks. I guess we should split it into VM and native variants.

But yeah, the general direction is ok once we agree on what we do when
exactly.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

