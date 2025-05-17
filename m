Return-Path: <kvm+bounces-46929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 275F5ABA888
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 08:47:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0F014A5618
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 06:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D8BE1B423B;
	Sat, 17 May 2025 06:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OM7++1gd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82936156F5E;
	Sat, 17 May 2025 06:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747464434; cv=none; b=DdlzPDQhd05PxrzFYECIy11IqYep6cWatakGBjIpE/ElU4QgRLrrjxPqXV5Gd95aUzgv8wn2/8WedYMkUd0A3sCiugVF1RhBQg7yorDKaUG6uUsnWRRr7GnJvJBRnaO2fRQ3S9xpYY2zKZOguE7O0SK2vH374Upz6Napok7yiG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747464434; c=relaxed/simple;
	bh=RHK4CtJGH2p06WOpFgy9zdi60XoyDOOf/9Jg0eJNxR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KWmr6bMGOYBUYkSqNgxyG/dc6+fzCrXNha03TCUAskbxSxyYUg3ET0fhT1FMoNLgNg8kR81sm+5X1obh43fJub/QV9x3+tTaCRHNQLPtTiThEKwRF2aI3Mps5HgR+4wiyr0jTDc6F2ReBG/HqfBDRzWCGO4zMSLA0jBVJSzBw9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OM7++1gd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECB2C4CEE3;
	Sat, 17 May 2025 06:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747464433;
	bh=RHK4CtJGH2p06WOpFgy9zdi60XoyDOOf/9Jg0eJNxR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OM7++1gdM4gVt7G7V4rBgQVdky8Cd43RBI4rk4vpM1SIP+vJWrMuYsMUVcgqF2BkT
	 Wmf/Te1qMODBePzh2uxrxk5QOIaKt0EFN4rLbUZ1CxWw3jsFsUdtSf2clwDo3RyVrV
	 mKlHUHwzC0Oa0OGiVl0FZB6fGY0tKn5QWHVUoymYdm5vL0l6six0AFyyI5mPO/dsVA
	 ZdXShhtauTw0M1a7RKRPqL+KNdNvwurPp6kiRItc0w0VdvwJPHQHUQWF+tJ9Lh1oBT
	 Pe6KiTR233c620DnlDcywLHVI+KTOPwbiDs3ado0i+P5E2/ubNZr4abgYysRb+dvrb
	 ciaIckKYW3rcA==
Date: Sat, 17 May 2025 08:47:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Zheyun Shen <szy0127@sjtu.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Kevin Loughlin <kevinloughlin@google.com>,
	Kai Huang <kai.huang@intel.com>, Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v2 4/8] x86, lib: Add WBNOINVD helper functions
Message-ID: <aCgw6sbpE6f42sC_@gmail.com>
References: <20250516212833.2544737-1-seanjc@google.com>
 <20250516212833.2544737-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516212833.2544737-5-seanjc@google.com>


* Sean Christopherson <seanjc@google.com> wrote:

> From: Kevin Loughlin <kevinloughlin@google.com>
> 
> In line with WBINVD usage, add WBONINVD helper functions.  Fall back to
> WBINVD (via alternative()) if WBNOINVD isn't supported, as WBINVD provides
> a superset of functionality, just more slowly.
> 
> Note, alternative() ensures compatibility with early boot code as needed.
> 
> Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> [sean: massage changelog and comments, use ASM_WBNOINVD and _ASM_BYTES]
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/smp.h           |  6 ++++++
>  arch/x86/include/asm/special_insns.h | 19 ++++++++++++++++++-
>  arch/x86/lib/cache-smp.c             | 11 +++++++++++
>  3 files changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index 028f126018c9..e08f1ae25401 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -113,6 +113,7 @@ void native_play_dead(void);
>  void play_dead_common(void);
>  void wbinvd_on_cpu(int cpu);
>  void wbinvd_on_all_cpus(void);
> +void wbnoinvd_on_all_cpus(void);
>  
>  void smp_kick_mwait_play_dead(void);
>  void __noreturn mwait_play_dead(unsigned int eax_hint);
> @@ -153,6 +154,11 @@ static inline void wbinvd_on_all_cpus(void)
>  	wbinvd();
>  }
>  
> +static inline void wbnoinvd_on_all_cpus(void)
> +{
> +	wbnoinvd();
> +}
> +
>  static inline struct cpumask *cpu_llc_shared_mask(int cpu)
>  {
>  	return (struct cpumask *)cpumask_of(0);
> diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
> index 6266d6b9e0b8..46b3961e3e4b 100644
> --- a/arch/x86/include/asm/special_insns.h
> +++ b/arch/x86/include/asm/special_insns.h
> @@ -117,7 +117,24 @@ static inline void wrpkru(u32 pkru)
>  
>  static __always_inline void wbinvd(void)
>  {
> -	asm volatile("wbinvd": : :"memory");
> +	asm volatile("wbinvd" : : : "memory");
> +}
> +
> +/* Instruction encoding provided for binutils backwards compatibility. */
> +#define ASM_WBNOINVD _ASM_BYTES(0xf3,0x0f,0x09)
> +
> +/*
> + * Cheaper version of wbinvd(). Call when caches need to be written back but
> + * not invalidated.
> + */
> +static __always_inline void wbnoinvd(void)
> +{
> +	/*
> +	 * If WBNOINVD is unavailable, fall back to the compatible but
> +	 * more destructive WBINVD (which still writes the caches back
> +	 * but also invalidates them).
> +	 */
> +	alternative("wbinvd", ASM_WBNOINVD, X86_FEATURE_WBNOINVD);
>  }

Would be nice here to use the opportunity and document both WBINVD and 
WBNOINVD a bit more comprehensively, to point out that WBINVD writes 
back and flushes the caches (and point out which level of caches this 
affects typically), and to point out that the 'invalidate' part of the 
WBNOINVD name is a misnomer, as it doesn't invalidate anything, it only 
writes back dirty cachelines.

Thanks,

	Ingo

