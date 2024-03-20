Return-Path: <kvm+bounces-12208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A0F8809EA
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 03:50:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 487991C22D34
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 02:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB3118B15;
	Wed, 20 Mar 2024 02:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OzQus3L9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B02101C6
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 02:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710902706; cv=none; b=K68dkjCnGKZH//9ZgkixEtg1nAxDXkK7dpSi3+dd4dpQMkisFfhkVGHFUaFlKj2zTmIuYQtFfktxfDbbu+g1uREQk8T5iaZmjOVqdl4bJNMjfaLRvEL45KQjEdD2GPgdFO33YXp2RktPLB0SliRttBpOQZGmHY1Okve7WiWRtB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710902706; c=relaxed/simple;
	bh=wDrdXvmqmwC120bCCmSpfnoYTook8fzexp+jUU3i9mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qjQgu3GTdb4IuXyZXnMsYXOFJZffkDOFVH0lnbl+y1+R8Ci7Bv90TalTVyDO4+CcBRjoIyAKTQ3gDSx7v0Zp4DrYlRtMll5dRiITULkZSoTGLUXBBUFy7cg23MzUnxVfwa+hP5MdicS+5GPeJReUIlVbK1wE/i3qg+8DVnHX9Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OzQus3L9; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710902703; x=1742438703;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wDrdXvmqmwC120bCCmSpfnoYTook8fzexp+jUU3i9mc=;
  b=OzQus3L9TYpTy37qFDyjL49qH7FDcrWUIBtJaQ/62b2xB38aIUtURgrh
   ficY20nFKK018aQ0An+h00Y628mFla6Lm7LW2Dj5e8x3x6D3crJ5lDYPz
   +chnET6gO3ID7oKXjIESkUpoFDif9b++wkkQrz5rCKDAT/xGMtV6Vb8hw
   vkyw2XEMP0WuWLD/q95toZMWXlLmDMLk+kbEVJjF8ZN9MJsAVnPXOB9Hj
   vFZ5kO1Gfz0CuQJ4UESMnexFVf9yXtfHMRVyQP0ujJtlNCGjJmRkeBIga
   aO2q9gQCF5k4ndDpoGOKE+RmCvR5+Wi2WIhgCSQt4SfBzOS2JbUBY+rFz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="28281888"
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="28281888"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 19:45:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="51451803"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 19:45:01 -0700
Message-ID: <54e8b518-2bea-4a5b-a75a-4fd45535c6fa@intel.com>
Date: Wed, 20 Mar 2024 10:44:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] kvm: add support for guest physical bits
Content-Language: en-US
To: Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20240318155336.156197-1-kraxel@redhat.com>
 <20240318155336.156197-2-kraxel@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240318155336.156197-2-kraxel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/2024 11:53 PM, Gerd Hoffmann wrote:
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
>   target/i386/cpu.h         |  1 +
>   target/i386/cpu.c         |  1 +
>   target/i386/kvm/kvm-cpu.c | 31 ++++++++++++++++++++++++++++++-
>   3 files changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 952174bb6f52..d427218827f6 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2026,6 +2026,7 @@ struct ArchCPU {
>   
>       /* Number of physical address bits supported */
>       uint32_t phys_bits;
> +    uint32_t guest_phys_bits;
>   
>       /* in order to simplify APIC support, we leave this pointer to the
>          user */
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 9a210d8d9290..c88c895a5b3e 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6570,6 +6570,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>           if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
>               /* 64 bit processor */
>                *eax |= (cpu_x86_virtual_addr_width(env) << 8);
> +             *eax |= (cpu->guest_phys_bits << 16);
>           }
>           *ebx = env->features[FEAT_8000_0008_EBX];
>           if (cs->nr_cores * cs->nr_threads > 1) {
> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
> index 9c791b7b0520..5132bb96abd5 100644
> --- a/target/i386/kvm/kvm-cpu.c
> +++ b/target/i386/kvm/kvm-cpu.c
> @@ -18,10 +18,33 @@
>   #include "kvm_i386.h"
>   #include "hw/core/accel-cpu.h"
>   
> +static void kvm_set_guest_phys_bits(CPUState *cs)
> +{
> +    X86CPU *cpu = X86_CPU(cs);
> +    uint32_t eax, guest_phys_bits;
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
> +    if (cpu->host_phys_bits_limit &&
> +        cpu->guest_phys_bits > cpu->host_phys_bits_limit) {
> +        cpu->guest_phys_bits = cpu->host_phys_bits_limit;

host_phys_bits_limit takes effect only when cpu->host_phys_bits is set.

If users pass configuration like "-cpu 
qemu64,phys-bits=52,host-phys-bits-limit=45", the cpu->guest_phys_bits 
will be set to 45. I think this is not what we want, though the usage 
seems insane.

We can guard it as

  if (cpu->host_phys_bits && cpu->host_phys_bits_limit &&
      cpu->guest_phys_bits > cpu->host_phys_bits_limt)
{
}

Simpler, we can guard with cpu->phys_bits like below, because 
cpu->host_phys_bits_limit is used to guard cpu->phys_bits in 
host_cpu_realizefn()

  if (cpu->guest_phys_bits > cpu->phys_bits) {
	cpu->guest_phys_bits = cpu->phys_bits;
}


with this resolved,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> +    }
> +}
> +
>   static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>   {
>       X86CPU *cpu = X86_CPU(cs);
>       CPUX86State *env = &cpu->env;
> +    bool ret;
>   
>       /*
>        * The realize order is important, since x86_cpu_realize() checks if
> @@ -50,7 +73,13 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>                                                      MSR_IA32_UCODE_REV);
>           }
>       }
> -    return host_cpu_realizefn(cs, errp);
> +    ret = host_cpu_realizefn(cs, errp);
> +    if (!ret) {
> +        return ret;
> +    }
> +
> +    kvm_set_guest_phys_bits(cs);
> +    return true;
>   }
>   
>   static bool lmce_supported(void)


