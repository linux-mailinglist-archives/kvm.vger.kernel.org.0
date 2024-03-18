Return-Path: <kvm+bounces-11972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33AC887E266
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 04:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D09E7280EA9
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 03:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA3D1E878;
	Mon, 18 Mar 2024 03:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SXCWONBf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2671E864
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 03:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710731378; cv=none; b=iwlwo1eVcLwoFtgI6xILg6EMX3lFIvD5b8AsF9H0ydBADL2coC6wR2S9WjjzYSV42D4PLhZpMHkM/EV2pXShWnSTLeKOBPR3P5MqddFZP9Layvj+d3nHdACWz6xnj6wnStD8D9zA+P1Ey0TXBn7qYejDWta9mY3hxZLg1Uv4FA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710731378; c=relaxed/simple;
	bh=0SIo5nnH8rXWWo/PKZWu5xaHib3sujSo/4+YK3yVEhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=afANlo49Jf6W3lT4npf2OS/BQuST+uwAjNDTiMcpc5/j7oX5yzMqwwbWJmSxuKn5lmpDTXqau097CFP5ujcFbp0hpJr7jlfcJTNThlRi/yQLKeppGMSG+1fmOiH7Ae5VzgGbEPZej9t7jvNRSyaFpqMv5LNp6D8F9q5i1xghZq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SXCWONBf; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710731376; x=1742267376;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0SIo5nnH8rXWWo/PKZWu5xaHib3sujSo/4+YK3yVEhE=;
  b=SXCWONBfMCYmWk8nUz80z2SoUbD1cFppUULT1r4HrJEpTwptNSDiEwoV
   P2zcibyBKmbpc+BAUkBC8w0nYDP2yU20OfX4jAt2KnrgyQZbM1wvxDY4+
   trNKfFS09xshVpvgzbypKlU/bcz0owXodDLyvBCZuAJDnbY+0p7IBcTIk
   7tYJM3BmLirjmK7GOLyFH9CUr2HyMqRuVrnprH/3UJZOGLf/DEJjZAgFE
   I0hmw/RDYHGUE2xeN0dmQHpZojh4oVXXviyeEBF6hs7O2nwiGdRRT2O2b
   hf8NX6qah1PnT879vTAwjAB3TTAYHRK0V3LQvIA4jXu241Fuyu9tW37mI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11016"; a="5660370"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="5660370"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2024 20:09:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="44264959"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2024 20:09:33 -0700
Message-ID: <4cbf6d9c-3916-4436-abfe-10b35734b67a@intel.com>
Date: Mon, 18 Mar 2024 11:09:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] kvm: add support for guest physical bits
Content-Language: en-US
To: Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org
References: <20240313132719.939417-1-kraxel@redhat.com>
 <20240313132719.939417-3-kraxel@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240313132719.939417-3-kraxel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/2024 9:27 PM, Gerd Hoffmann wrote:
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
>   target/i386/kvm/kvm-cpu.c | 32 +++++++++++++++++++++++++++++++-
>   3 files changed, 33 insertions(+), 1 deletion(-)
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
> index 9c791b7b0520..a2b7bfaeadf8 100644
> --- a/target/i386/kvm/kvm-cpu.c
> +++ b/target/i386/kvm/kvm-cpu.c
> @@ -18,10 +18,36 @@
>   #include "kvm_i386.h"
>   #include "hw/core/accel-cpu.h"
>   
> +static void kvm_set_guest_phys_bits(CPUState *cs)
> +{
> +    X86CPU *cpu = X86_CPU(cs);
> +    uint32_t eax, guest_phys_bits;
> +
> +    if (!cpu->host_phys_bits) {
> +        return;
> +    }

This needs explanation of why. What if users set the phys-bits to 
exactly host's value, via "-cpu xxx,phys-bits=host's value"?


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
> @@ -50,7 +76,11 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>                                                      MSR_IA32_UCODE_REV);
>           }
>       }
> -    return host_cpu_realizefn(cs, errp);
> +    ret = host_cpu_realizefn(cs, errp);

We need to check ret and return if !ret;

> +    kvm_set_guest_phys_bits(cs);
> +
> +    return ret;
>   }
>   
>   static bool lmce_supported(void)


