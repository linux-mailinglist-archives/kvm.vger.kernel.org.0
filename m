Return-Path: <kvm+bounces-51393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ACE2AF6D6C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:48:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23DC07B6327
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4442E2DE6E3;
	Thu,  3 Jul 2025 08:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fJ65uNbx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964C724676D
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 08:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751532496; cv=none; b=eQ6MYf2Sy8tBzgYK8/0C9B2JprhWM6yShXf8kXgByG7YByB1K4mnEZpyBVtTTZbhJ2kz2/pi86hsMWJ7WDC3M0yxYI6YBQlH4+pjcw63PSRzkokxa/Ej6dSgXunlWkgr0Oz/v0UXwU7gjV6l5RUZjBwd4Ca2MxvNlRfh/5fKIPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751532496; c=relaxed/simple;
	bh=TVqic+b8AVGUwxPElX65V0zWrqt8rFKvH8TJ7zuGHG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ljqss0oaxDFp6nGHVik2vNEJMI30YQW/oSuVm4DQWmXGVBYI9nI67dFwCxV/KoESRhl0ZB7sEGFXAMxMtuP6dKgxdcyEhx0Lu1wbKHhpz6FztYHRTMuJpU4Do+8W6ElgDSgGQ2b3JPQN9P1JOqjwAgqbsLOQ5KwDE+KYWNuA6wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fJ65uNbx; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751532494; x=1783068494;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TVqic+b8AVGUwxPElX65V0zWrqt8rFKvH8TJ7zuGHG8=;
  b=fJ65uNbxC2/ANx8Uq/9npr5FbcGYAgzdBNsQEmv4uvkPZ07EzntIxPju
   CLO63OHFTZWvlsDM9r4t3x7A8AHGwEX1GPQ18NEN0DPFZjjK6dNxr7vyZ
   pOENWwAkEYdXHfTWJZZ0Cl5TNREQA6pOArXUbK4cC3Sbv4qw3xkDzaPs1
   pQ+PKOOj7E3oU3yV4fmAeRjER+amn4IXSYH6wkb77DSqo1DYkJx3CKgVm
   46Me4Yd4ZBjfcovdQz+hmJlnURwwgZZJnjWGOAogQe9YYtnk1zpbyejbW
   QunV59bN+kzkvCHIEGXYG8ZRXmnjion/0v9RbXIKDhguRf84IDoYubyy9
   A==;
X-CSE-ConnectionGUID: 0Ef+XiELTCyBN8voRWguWg==
X-CSE-MsgGUID: ikeuFbtnTy6kxMfUtld7bA==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="56468917"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="56468917"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 01:48:05 -0700
X-CSE-ConnectionGUID: EGto2FLtQymYlGi9LsTHFA==
X-CSE-MsgGUID: cPaMJISUREu5N2A/94HLXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="154079941"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 01:48:02 -0700
Message-ID: <47aed1d6-c05d-4d60-a59c-49537a211d21@linux.intel.com>
Date: Thu, 3 Jul 2025 16:47:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/16] i386/cpu: Select legacy cache model based on vendor
 in CPUID 0x2
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
 Pu Wen <puwen@hygon.cn>, Tao Su <tao1.su@intel.com>,
 Yi Lai <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-12-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-12-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> As preparation for merging cache_info_cpuid4 and cache_info_amd in
> X86CPUState, set legacy cache model based on vendor in the CPUID 0x2
> leaf. For AMD CPU, select legacy AMD cache model (in cache_info_amd) as
> the default cache model, otherwise, select legacy Intel cache model (in
> cache_info_cpuid4) as before.
>
> To ensure compatibility is not broken, add an enable_legacy_vendor_cache
> flag based on x-vendor-only-v2 to indicate cases where the legacy cache
> model should be used regardless of the vendor. For CPUID 0x2 leaf,
> enable_legacy_vendor_cache flag indicates to pick legacy Intel cache
> model, which is for compatibility with the behavior of PC machine v10.0
> and older.
>
> The following explains how current vendor-based default legacy cache
> model ensures correctness without breaking compatibility.
>
> * For the PC machine v6.0 and older, vendor_cpuid_only=false, and
>   vendor_cpuid_only_v2=false.
>
>   - If the named CPU model has its own cache model, and doesn't use
>     legacy cache model (legacy_cache=false), then cache_info_cpuid4 and
>     cache_info_amd are same, so 0x2 leaf uses its own cache model
>     regardless of the vendor.
>
>   - For max/host/named CPU (without its own cache model), then the flag
>     enable_legacy_vendor_cache is true, they will use legacy Intel cache
>     model just like their previous behavior.
>
> * For the PC machine v10.0 and older (to v6.1), vendor_cpuid_only=true,
>   and vendor_cpuid_only_v2=false.
>
>   - If the named CPU model has its own cache model (legacy_cache=false),
>     then cache_info_cpuid4 & cache_info_amd both equal to its own cache
>     model, so it uses its own cache model in 0x2 leaf regardless of the
>     vendor. Only AMD CPUs have all-0 leaf due to vendor_cpuid_only=true,
>     and this is exactly the behavior of these old machines.
>
>   - For max/host/named CPU (without its own cache model), then the flag
>     enable_legacy_vendor_cache is true, they will use legacy Intel cache
>     model. Similarly, only AMD CPUs have all-0 leaf, and this is exactly
>     the behavior of these old machines.
>
> * For the PC machine v10.1 and newer, vendor_cpuid_only=true, and
>   vendor_cpuid_only_v2=true.
>
>   - If the named CPU model has its own cache model (legacy_cache=false),
>     then cache_info_cpuid4 & cache_info_amd both equal to its own cache
>     model, so it uses its own cache model in 0x2 leaf regardless of the
>     vendor. And AMD CPUs have all-0 leaf. Nothing will change.
>
>   - For max/host/named CPU (without its own cache model), then the flag
>     enable_legacy_vendor_cache is false, the legacy cache model is
>     selected based on vendor.
>
>     For AMD CPU, it will use legacy AMD cache but still get all-0 leaf
>     due to vendor_cpuid_only=true.
>
>     For non-AMD (Intel/Zhaoxin) CPU, it will use legacy Intel cache as
>     expected.
>
>     Here, selecting the legacy cache model based on the vendor does not
>     change the previous (before the change)  behavior.
>
> Therefore, the above analysis proves that, with the help of the flag
> enable_legacy_vendor_cache, it is acceptable to select the default
> legacy cache model based on the vendor.
>
> For the CPUID 0x2 leaf, in X86CPUState, a unified cache_info is enough.
> It only needs to be initialized and configured with the corresponding
> legacy cache model based on the vendor.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 47 +++++++++++++++++++++++++++++++++++++----------
>  target/i386/cpu.h |  1 +
>  2 files changed, 38 insertions(+), 10 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index bf8d7a19c88d..524d39de9ace 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -248,23 +248,17 @@ static const CPUCaches legacy_intel_cpuid2_cache_info;
>  
>  /* Encode cache info for CPUID[4] */
>  static void encode_cache_cpuid2(X86CPU *cpu,
> +                                const CPUCaches *caches,
>                                  uint32_t *eax, uint32_t *ebx,
>                                  uint32_t *ecx, uint32_t *edx)
>  {
>      CPUX86State *env = &cpu->env;
> -    const CPUCaches *caches;
>      int l1d, l1i, l2, l3;
>      bool unmatched = false;
>  
>      *eax = 1; /* Number of CPUID[EAX=2] calls required */
>      *ebx = *ecx = *edx = 0;
>  
> -    if (env->enable_legacy_cpuid2_cache) {
> -        caches = &legacy_intel_cpuid2_cache_info;
> -    } else {
> -        caches = &env->cache_info_cpuid4;
> -    }
> -
>      l1d = cpuid2_cache_descriptor(caches->l1d_cache, &unmatched);
>      l1i = cpuid2_cache_descriptor(caches->l1i_cache, &unmatched);
>      l2 = cpuid2_cache_descriptor(caches->l2_cache, &unmatched);
> @@ -7482,8 +7476,37 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>              *ecx &= ~CPUID_EXT_PDCM;
>          }
>          break;
> -    case 2:
> -        /* cache info: needed for Pentium Pro compatibility */
> +    case 2: { /* cache info: needed for Pentium Pro compatibility */
> +        const CPUCaches *caches;
> +
> +        if (env->enable_legacy_cpuid2_cache) {
> +            caches = &legacy_intel_cpuid2_cache_info;
> +        } else if (env->enable_legacy_vendor_cache) {
> +            caches = &legacy_intel_cache_info;
> +        } else {
> +            /*
> +             * FIXME: Temporarily select cache info model here based on
> +             * vendor, and merge these 2 cache info models later.
> +             *
> +             * This condition covers the following cases (with
> +             * enable_legacy_vendor_cache=false):
> +             *  - When CPU model has its own cache model and doesn't use legacy
> +             *    cache model (legacy_model=off). Then cache_info_amd and
> +             *    cache_info_cpuid4 are the same.
> +             *
> +             *  - For v10.1 and newer machines, when CPU model uses legacy cache
> +             *    model. Non-AMD CPUs use cache_info_cpuid4 like before and AMD
> +             *    CPU will use cache_info_amd. But this doesn't matter for AMD
> +             *    CPU, because this leaf encodes all-0 for AMD whatever its cache
> +             *    model is.
> +             */
> +            if (IS_AMD_CPU(env)) {
> +                caches = &env->cache_info_amd;
> +            } else {
> +                caches = &env->cache_info_cpuid4;
> +            }
> +        }
> +
>          if (cpu->cache_info_passthrough) {
>              x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
>              break;
> @@ -7491,8 +7514,9 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>              *eax = *ebx = *ecx = *edx = 0;
>              break;
>          }
> -        encode_cache_cpuid2(cpu, eax, ebx, ecx, edx);
> +        encode_cache_cpuid2(cpu, caches, eax, ebx, ecx, edx);
>          break;
> +    }
>      case 4:
>          /* cache info: needed for Core compatibility */
>          if (cpu->cache_info_passthrough) {
> @@ -8979,6 +9003,9 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>              env->enable_legacy_cpuid2_cache = true;
>          }
>  
> +        if (!cpu->vendor_cpuid_only_v2) {
> +            env->enable_legacy_vendor_cache = true;
> +        }
>          env->cache_info_cpuid4 = legacy_intel_cache_info;
>          env->cache_info_amd = legacy_amd_cache_info;
>      }
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 02cda176798f..243383efd602 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2078,6 +2078,7 @@ typedef struct CPUArchState {
>       */
>      CPUCaches cache_info_cpuid4, cache_info_amd;
>      bool enable_legacy_cpuid2_cache;
> +    bool enable_legacy_vendor_cache;
>  
>      /* MTRRs */
>      uint64_t mtrr_fixed[11];

LGTM. Thanks.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



