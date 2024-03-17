Return-Path: <kvm+bounces-11962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 287D987DC96
	for <lists+kvm@lfdr.de>; Sun, 17 Mar 2024 09:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1EFD1F21746
	for <lists+kvm@lfdr.de>; Sun, 17 Mar 2024 08:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C553F510;
	Sun, 17 Mar 2024 08:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C1AxQ1BI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7AA1865
	for <kvm@vger.kernel.org>; Sun, 17 Mar 2024 08:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710664351; cv=none; b=ZG52z13jmccoMNTXMAkgRjn8ZZ+BDS3OV4GadWxAgCmEwMTSdaeYo6y8bZDvwYzkuNLwxhN8iLWWlgcnO/VzhA2Bt6Jj0OGmotOocbarNGCl/YpZBubtmSjR9LbUZOfhp7kYnCp2zE5/oJmSEyUH9uhr2OCaNOp0UJNXofbkAyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710664351; c=relaxed/simple;
	bh=92hfYwokdeu/YuQ+PkV1vqiKNBjGzAAHo/vUwVuYsRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iAy5yTVpgzc7Sal7p4McUTqNw93EwlLGwtKqbfQLC5QjAZRYy68OoqMVyTWRL/SGNsrhsG2STwFJNaD66gUmt8XQvgHizPZP1mc1z8MeYpj4L9Vc2Kq2sUIFdPLwmEhjKrW0p4tU9O1tQdYZSZ0TH3gmLK4ixqGByRHSUabNgSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C1AxQ1BI; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710664349; x=1742200349;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=92hfYwokdeu/YuQ+PkV1vqiKNBjGzAAHo/vUwVuYsRo=;
  b=C1AxQ1BIs/Y9SVmVSVFzEY9by7Opx+Im+9/OjnB1bBLBiRcUz3+lyv71
   c+Kz0VTJ9jD/ezNge5nf5TOULAde1zVamwprFDQSFhzwAfFU6cCxzRzhN
   OcHO6365KWUWB5hcbVPkXwObxlsdR3CQ3XF1h2fofe0dz02/yJsBFT0o3
   5g/QIoUTjLMOXUkaATOVe5U2KLzOmAyCMJwt1oj3XMDv3oSobnVfICAYw
   xf8B69sSovgLUgD/wra0tdUgsdHPmo0GiXCUwrJ8CcXHNMjRx0dzHICqi
   GMn4uS6o0MO24IUTMYwdQHcI9RliLSXodAwievDk1GowUoZdatFnwazvG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11015"; a="23006648"
X-IronPort-AV: E=Sophos;i="6.07,132,1708416000"; 
   d="scan'208";a="23006648"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2024 01:32:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,132,1708416000"; 
   d="scan'208";a="13788545"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2024 01:32:26 -0700
Date: Sun, 17 Mar 2024 16:29:31 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: qemu-devel@nongnu.org, Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/3] kvm: add support for guest physical bits
Message-ID: <Zfap1cqJngPblW+x@linux.bj.intel.com>
References: <20240313132719.939417-1-kraxel@redhat.com>
 <20240313132719.939417-3-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240313132719.939417-3-kraxel@redhat.com>

On Wed, Mar 13, 2024 at 02:27:18PM +0100, Gerd Hoffmann wrote:
> Query kvm for supported guest physical address bits, in cpuid
> function 80000008, eax[23:16].  Usually this is identical to host
> physical address bits.  With NPT or EPT being used this might be
> restricted to 48 (max 4-level paging address space size) even if
> the host cpu supports more physical address bits.
> 
> When set pass this to the guest, using cpuid too.  Guest firmware
> can use this to figure how big the usable guest physical address
> space is, so PCI bar mapping are actually reachable.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  target/i386/cpu.h         |  1 +
>  target/i386/cpu.c         |  1 +
>  target/i386/kvm/kvm-cpu.c | 32 +++++++++++++++++++++++++++++++-
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 952174bb6f52..d427218827f6 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2026,6 +2026,7 @@ struct ArchCPU {
>  
>      /* Number of physical address bits supported */
>      uint32_t phys_bits;
> +    uint32_t guest_phys_bits;
>  
>      /* in order to simplify APIC support, we leave this pointer to the
>         user */
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 9a210d8d9290..c88c895a5b3e 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6570,6 +6570,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
>              /* 64 bit processor */
>               *eax |= (cpu_x86_virtual_addr_width(env) << 8);
> +             *eax |= (cpu->guest_phys_bits << 16);
>          }
>          *ebx = env->features[FEAT_8000_0008_EBX];
>          if (cs->nr_cores * cs->nr_threads > 1) {
> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
> index 9c791b7b0520..a2b7bfaeadf8 100644
> --- a/target/i386/kvm/kvm-cpu.c
> +++ b/target/i386/kvm/kvm-cpu.c
> @@ -18,10 +18,36 @@
>  #include "kvm_i386.h"
>  #include "hw/core/accel-cpu.h"
>  
> +static void kvm_set_guest_phys_bits(CPUState *cs)
> +{
> +    X86CPU *cpu = X86_CPU(cs);
> +    uint32_t eax, guest_phys_bits;
> +
> +    if (!cpu->host_phys_bits) {
> +        return;
> +    }
> +
> +    eax = kvm_arch_get_supported_cpuid(cs->kvm_state, 0x80000008, 0, R_EAX);
> +    guest_phys_bits = (eax >> 16) & 0xff;
> +    if (!guest_phys_bits) {
> +        return;
> +    }
> +
> +    if (cpu->guest_phys_bits == 0 ||
> +        cpu->guest_phys_bits > guest_phys_bits) {
> +        cpu->guest_phys_bits = guest_phys_bits;
> +    }
> +
> +    if (cpu->guest_phys_bits > cpu->host_phys_bits_limit) {
> +        cpu->guest_phys_bits = cpu->host_phys_bits_limit;

host_phys_bits_limit is zero by default, so I think it is better to be
like:

        if (cpu->host_phys_bits_limit &&
            cpu->guest_phys_bits > cpu->host_phys_bits_limit) {
            cpu->guest_phys_bits = cpu->host_phys_bits_limit;
        }

> +    }
> +}
> +
>  static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>  {
>      X86CPU *cpu = X86_CPU(cs);
>      CPUX86State *env = &cpu->env;
> +    bool ret;
>  
>      /*
>       * The realize order is important, since x86_cpu_realize() checks if
> @@ -50,7 +76,11 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>                                                     MSR_IA32_UCODE_REV);
>          }
>      }
> -    return host_cpu_realizefn(cs, errp);
> +    ret = host_cpu_realizefn(cs, errp);
> +
> +    kvm_set_guest_phys_bits(cs);
> +
> +    return ret;
>  }
>  
>  static bool lmce_supported(void)
> -- 
> 2.44.0
> 
> 

