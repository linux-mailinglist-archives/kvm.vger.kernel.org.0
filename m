Return-Path: <kvm+bounces-39571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B32AA47EB7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54009171ECC
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38D022F3BD;
	Thu, 27 Feb 2025 13:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LYFX06Ck"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0980B270021;
	Thu, 27 Feb 2025 13:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740662133; cv=none; b=avn4AQzTXeFbEAGDS1OiB0lZZuf5TARSVM9zSElgLXoPFGxflKxcfOu9RUaettdgzfIksRf1st+nF8rmG7DVa46nYCVSfRr0Im5DCMGoSDE7G8CqYA3ToZazH/thdCgCj/yg8jyKrdD5iOi9DOi27SkVI5fKWzuIHW1a1ASBzCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740662133; c=relaxed/simple;
	bh=10uz/6GHPznmkoEebLO3Ry9z1Iblsqs6tsAuZLbb6pM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dj/Q/nuXyTpyg8Al12leS26dVQWuv8KJMWw6WHVF+oNVTuPvIjUGE8vD+5hAKDrsUDIa7QLWxXj2EBQT7opzFYO4sjf7Dm5DYa+PhTPZO/WDDn3FvTTPG72f9hGj0WGuq8ZrzuO0n/vZ0rQNj7y3u/rYwjfFkvraPUbYUfTLKmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LYFX06Ck; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740662131; x=1772198131;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=10uz/6GHPznmkoEebLO3Ry9z1Iblsqs6tsAuZLbb6pM=;
  b=LYFX06CkwC+gqCyG3pnqEIG85r6LcJ44amr7ziTISBfi3LW9L/bRnNWh
   T3YnJ8Dehcc5HrrwwVnapXBCmdnqi2n+4wXwAeM4Hb21F7NkmZDETjXwa
   hy/pr5ROdtqXYbplzDyEc6F6vq6bSmWSCqbEEv+pZOOWt3qX/64Qh5WA0
   hu2Y7h/JgUQKpPOfT+nft/rOLldWaZPdeH2bWQYPRebwSJtaPF+980hKi
   U1LM9wbrZk0LGJydSvUHK4uJ3dkRbhXUcts5yOprY5k88RURTAWkaww08
   hnnKCU3peWjioL3ppBxYiwl4fxc/XxF4CI3WD1Xr8BnvI5/AG7UNWhvXu
   w==;
X-CSE-ConnectionGUID: 3Mw+YTATRl2dm5Cfr6t4IA==
X-CSE-MsgGUID: AwuZyFPUSQ2ANaEYzxIneA==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="52945587"
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="52945587"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 05:15:30 -0800
X-CSE-ConnectionGUID: YSzANlW6TheqXNJb8PsEYQ==
X-CSE-MsgGUID: IW3p7XzcS9++CSw8VxGIiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="147939679"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa001.fm.intel.com with ESMTP; 27 Feb 2025 05:15:24 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 8582D2D5; Thu, 27 Feb 2025 15:15:23 +0200 (EET)
Date: Thu, 27 Feb 2025 15:15:23 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Daniel Lezcano <daniel.lezcano@linaro.org>, John Stultz <jstultz@google.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH v2 06/38] x86/tdx: Override PV calibration routines with
 CPUID-based calibration
Message-ID: <buq5hn27q7r5ktb33rxejp7i54s22zqu3vw44bie6vzcouzzdc@btjgkdpoeclw>
References: <20250227021855.3257188-1-seanjc@google.com>
 <20250227021855.3257188-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250227021855.3257188-7-seanjc@google.com>

On Wed, Feb 26, 2025 at 06:18:22PM -0800, Sean Christopherson wrote:
> When running as a TDX guest, explicitly override the TSC frequency
> calibration routine with CPUID-based calibration instead of potentially
> relying on a hypervisor-controlled PV routine.  For TDX guests, CPUID.0x15
> is always emulated by the TDX-Module, i.e. the information from CPUID is
> more trustworthy than the information provided by the hypervisor.
> 
> To maintain backwards compatibility with TDX guest kernels that use native
> calibration, and because it's the least awful option, retain
> native_calibrate_tsc()'s stuffing of the local APIC bus period using the
> core crystal frequency.  While it's entirely possible for the hypervisor
> to emulate the APIC timer at a different frequency than the core crystal
> frequency, the commonly accepted interpretation of Intel's SDM is that APIC
> timer runs at the core crystal frequency when that latter is enumerated via
> CPUID:
> 
>   The APIC timer frequency will be the processor’s bus clock or core
>   crystal clock frequency (when TSC/core crystal clock ratio is enumerated
>   in CPUID leaf 0x15).
> 
> If the hypervisor is malicious and deliberately runs the APIC timer at the
> wrong frequency, nothing would stop the hypervisor from modifying the
> frequency at any time, i.e. attempting to manually calibrate the frequency
> out of paranoia would be futile.
> 
> Deliberately leave the CPU frequency calibration routine as is, since the
> TDX-Module doesn't provide any guarantees with respect to CPUID.0x16.
> 
> Opportunistically add a comment explaining that CoCo TSC initialization
> needs to come after hypervisor specific initialization.
> 
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/coco/tdx/tdx.c    | 30 +++++++++++++++++++++++++++---
>  arch/x86/include/asm/tdx.h |  2 ++
>  arch/x86/kernel/tsc.c      |  8 ++++++++
>  3 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> index 32809a06dab4..42cdaa98dc5e 100644
> --- a/arch/x86/coco/tdx/tdx.c
> +++ b/arch/x86/coco/tdx/tdx.c
> @@ -8,6 +8,7 @@
>  #include <linux/export.h>
>  #include <linux/io.h>
>  #include <linux/kexec.h>
> +#include <asm/apic.h>
>  #include <asm/coco.h>
>  #include <asm/tdx.h>
>  #include <asm/vmx.h>
> @@ -1063,9 +1064,6 @@ void __init tdx_early_init(void)
>  
>  	setup_force_cpu_cap(X86_FEATURE_TDX_GUEST);
>  
> -	/* TSC is the only reliable clock in TDX guest */
> -	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
> -
>  	cc_vendor = CC_VENDOR_INTEL;
>  
>  	/* Configure the TD */
> @@ -1122,3 +1120,29 @@ void __init tdx_early_init(void)
>  
>  	tdx_announce();
>  }
> +
> +static unsigned long tdx_get_tsc_khz(void)
> +{
> +	struct cpuid_tsc_info info;
> +
> +	if (WARN_ON_ONCE(cpuid_get_tsc_freq(&info)))
> +		return 0;
> +
> +	lapic_timer_period = info.crystal_khz * 1000 / HZ;
> +
> +	return info.tsc_khz;
> +}
> +
> +void __init tdx_tsc_init(void)
> +{
> +	/* TSC is the only reliable clock in TDX guest */
> +	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
> +	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> +
> +	/*
> +	 * Override the PV calibration routines (if set) with more trustworthy
> +	 * CPUID-based calibration.  The TDX module emulates CPUID, whereas any
> +	 * PV information is provided by the hypervisor.
> +	 */
> +	tsc_register_calibration_routines(tdx_get_tsc_khz, NULL);
> +}
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index b4b16dafd55e..621fbdd101e2 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -53,6 +53,7 @@ struct ve_info {
>  #ifdef CONFIG_INTEL_TDX_GUEST
>  
>  void __init tdx_early_init(void);
> +void __init tdx_tsc_init(void);
>  
>  void tdx_get_ve_info(struct ve_info *ve);
>  
> @@ -72,6 +73,7 @@ void __init tdx_dump_td_ctls(u64 td_ctls);
>  #else
>  
>  static inline void tdx_early_init(void) { };
> +static inline void tdx_tsc_init(void) { }
>  static inline void tdx_safe_halt(void) { };
>  
>  static inline bool tdx_early_handle_ve(struct pt_regs *regs) { return false; }
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 6a011cd1ff94..472d6c71d3a5 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -32,6 +32,7 @@
>  #include <asm/topology.h>
>  #include <asm/uv/uv.h>
>  #include <asm/sev.h>
> +#include <asm/tdx.h>
>  
>  unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
>  EXPORT_SYMBOL(cpu_khz);
> @@ -1563,8 +1564,15 @@ void __init tsc_early_init(void)
>  	if (is_early_uv_system())
>  		return;
>  
> +	/*
> +	 * Do CoCo specific "secure" TSC initialization *after* hypervisor
> +	 * platform initialization so that the secure variant can override the
> +	 * hypervisor's PV calibration routine with a more trusted method.
> +	 */
>  	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
>  		snp_secure_tsc_init();
> +	else if (boot_cpu_has(X86_FEATURE_TDX_GUEST))
> +		tdx_tsc_init();

Maybe a x86_platform.guest callback for this?


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

