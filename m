Return-Path: <kvm+bounces-56388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A320B3CE06
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 19:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0FB956248C
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 17:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 921AF261B9D;
	Sat, 30 Aug 2025 17:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Y2/1UaJq"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E64284B4F;
	Sat, 30 Aug 2025 17:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756574406; cv=none; b=AsoZ7K0A7/EwZmYAxApf6eQTQFf1otowZOdcUMCdgLnNdsTxihH2hLQLT5l/ruRL72XLqaY9czf9qKtlarKtYjl8tziot9cOPI9LopNvqbu5RHsV/UOa0l7Qe5lnKSJIDjXrrncITkRAEolBWtLH5Mn/vygAiNe+LJvOgNygc08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756574406; c=relaxed/simple;
	bh=KF3oOWX/aUFO8SGoQKKdkC7zzq3zptMbJSRQ+x1Qnn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dFTDLx6ZS3+293HFr/rhTB2hgLIl0DBf7Pt89gsYrp00+Y8O+4iTnTTs51pKulgN+XHPhpOAnIFdFCPXX8q1StRKixsrKMaBAspmUjqy93PxkC9dzvoU6Bby4EEyO32/MeG+7sLWVUmWDQ1htp31+idxvx1xybzik6rruAnadog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Y2/1UaJq; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E54A740E016C;
	Sat, 30 Aug 2025 17:19:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 48_kHgx2fDtm; Sat, 30 Aug 2025 17:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756574390; bh=yFHx6y297lhsVBJOnwZMghCs9css2zjdqXyvjnNnMBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y2/1UaJqO3pWMDKvgiR/nPpIJwxPgMHqumoxYUpKkd5TZfLhjMf/IlohOaBxKq43W
	 i+DlZed6Aib+rKfH0zpn4Xnii6/WCg7komBl4D8u6R4wnmTlgcQttYOOcFepPmkDW6
	 YWa5bh1KLCCaQ7UU1BkYSROEBT/AKAExk1sq5gSa887EhtpkAGx4IWZcDmeGoK7kzV
	 Te2zwH8Kx9LH99CzeQG4cH2x4LHHFyupkO2QWHV3/IHiwqVJWcsC0PVrE9xsP9imv+
	 6HM2K4PUq/hWEKQSZ7l+zzVD1EDXMzhZ/tSOu5qriYgGpyBQqGs4ExeM926qfqaC5M
	 3jOzvKcWjNFtFBI8wc/7zhGJqJuY70p1iQcZt98CA85516JIPAcXVPLSiOn4x9prrQ
	 4kbuStol/MwprklF58Y+L+oudPhw26h/Ao5Ffj0oH9Lz/DtZRT9SPAw+z0x5uCniuE
	 89l+wBRuiXwd7bGf1YPS7zbB2iB+VpzKqlDWXwrHA4eLEqJhwpSNawla68L0unSOOv
	 T+vvK11k1tNiRRNwhnAJhQdE1Zzbg/g+sVoiu9T+y0DhMV9zwezUaTrWL1Y1Oz3JG6
	 7Nop549gg1XEBAF+e8/exaHJD9C4E0VLxG8IqZxZOuKaw6wCkand42Ab1ikVYfB4+V
	 hnORRUHOfczIGjVxzfAtQefg=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 4DD2040E016D;
	Sat, 30 Aug 2025 17:19:28 +0000 (UTC)
Date: Sat, 30 Aug 2025 19:19:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
	Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Naveen N Rao <naveen@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v4 2/4] x86/cpu/topology: Always try
 cpu_parse_topology_ext() on AMD/Hygon
Message-ID: <20250830171921.GAaLMymVpsFhjWtylo@fat_crate.local>
References: <20250825075732.10694-1-kprateek.nayak@amd.com>
 <20250825075732.10694-3-kprateek.nayak@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250825075732.10694-3-kprateek.nayak@amd.com>

On Mon, Aug 25, 2025 at 07:57:30AM +0000, K Prateek Nayak wrote:
> This has not been a problem on baremetal platforms since support for
> TOPOEXT (Fam 0x15 and later) predates the support for CPUID leaf 0xb
> (Fam 0x17[Zen2] and later), however, for AMD guests on QEMU, "x2apic"
> feature can be enabled independent of the "topoext" feature where QEMU
> expects topology and the initial APICID to be parsed using the CPUID
> leaf 0xb (especially when number of cores > 255) which is populated
> independent of the "topoext" feature flag.

This sounds like we're fixing the kernel because someone *might* supply
a funky configuration to qemu. You need to understand that we're not wagging
the dog and fixing the kernel because of that.

If someone manages to enable some weird concoction of feature flags in qemu,
we certainly won't "fix" that in the kernel.

So let's concentrate that text around fixing the issue of parsing CPUID
topology leafs which we should parse and looking at CPUID flags only for those
feature leafs, for which those flags are existing.

If qemu wants stuff to work, then it better emulate the feature flag
configuration like the hw does.

> Unconditionally call cpu_parse_topology_ext() on AMD and Hygon
> processors to first parse the topology using the XTOPOLOGY leaves
> (0x80000026 / 0xb) before using the TOPOEXT leaf (0x8000001e).
> 
> Cc: stable@vger.kernel.org # Only v6.9 and above
> Link: https://lore.kernel.org/lkml/1529686927-7665-1-git-send-email-suravee.suthikulpanit@amd.com/ [1]
> Link: https://lore.kernel.org/lkml/20080818181435.523309000@linux-os.sc.intel.com/ [2]
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 [3]
> Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
> Fixes: 3986a0a805e6 ("x86/CPU/AMD: Derive CPU topology from CPUID function 0xB when available")
> Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
> ---
> Changelog v3..v4:
> 
> o Quoted relevant section of the PPR justifying the changes.
> 
> o Moved this patch up ahead.
> 
> o Cc'd stable and made a note that backports should target v6.9 and
>   above since this depends on the x86 topology rewrite.

Put that explanation in the CC:stable comment.

> ---
>  arch/x86/kernel/cpu/topology_amd.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
> index 827dd0dbb6e9..4e3134a5550c 100644
> --- a/arch/x86/kernel/cpu/topology_amd.c
> +++ b/arch/x86/kernel/cpu/topology_amd.c
> @@ -175,18 +175,14 @@ static void topoext_fixup(struct topo_scan *tscan)
>  
>  static void parse_topology_amd(struct topo_scan *tscan)
>  {
> -	bool has_topoext = false;
> -
>  	/*
> -	 * If the extended topology leaf 0x8000_001e is available
> -	 * try to get SMT, CORE, TILE, and DIE shifts from extended
> +	 * Try to get SMT, CORE, TILE, and DIE shifts from extended
>  	 * CPUID leaf 0x8000_0026 on supported processors first. If
>  	 * extended CPUID leaf 0x8000_0026 is not supported, try to
>  	 * get SMT and CORE shift from leaf 0xb first, then try to
>  	 * get the CORE shift from leaf 0x8000_0008.
>  	 */
> -	if (cpu_feature_enabled(X86_FEATURE_TOPOEXT))
> -		has_topoext = cpu_parse_topology_ext(tscan);
> +	bool has_topoext = cpu_parse_topology_ext(tscan);

Ok, I see what the point here is - you want to parse topology regardless of
X86_FEATURE_TOPOEXT.

Which is true - latter "indicates support for Core::X86::Cpuid::CachePropEax0
and Core::X86::Cpuid::ExtApicId" only and the leafs cpu_parse_topology_ext()
attempts to parse are different ones.

So, "has_topoext" doesn't have anything to do with X86_FEATURE_TOPOEXT - it
simply means that the topology extensions parser found some extensions and
parsed them. So let's rename that variable differently so that there is no
confusion.

You can do the renaming in parse_8000_001e() in a later patch as that is only
a cosmetic thing and we don't want to send that to stable.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

