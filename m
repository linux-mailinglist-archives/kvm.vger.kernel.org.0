Return-Path: <kvm+bounces-51374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7864AF6A87
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:41:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEE3A1706EA
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 06:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEED6291C29;
	Thu,  3 Jul 2025 06:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WPWVQOFc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200C11C84D3
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 06:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751524908; cv=none; b=DMSeNDQoVCWnPwWRKCUJNCnac5s0EBgfWYV8oWf8NxE7iFm4QSYG8e/TdHFuFw4k4Vs0BY5vi6ZOWqu688S+dM5tdKEIqxNNiO7oT5Fvez1Wt7rJM/gQMNgxttpf2iBAkQjQIOm/LrRrMnni9R3adwP5404eyLfQiQIoS/bAqY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751524908; c=relaxed/simple;
	bh=zb0yY/Oe4msYOmornpmCDciRbYe2tXpbbXuG+M9KjDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pPIyqbK2HnPsmTYFdTmFbtYy5KLDjw+zAydFziGF+LvSbQaSUP/1ShMdjhj/n3lq6cWOVhfR+YWT2RGnsy9+7XD4Gezx685pOkz/fzVieNhNUzjQABBdH7ELzQ8Bh+3zykOMadWZFwPKPYJgmmqQqknrGWYRkLmBwebwu5TDeRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WPWVQOFc; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751524907; x=1783060907;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zb0yY/Oe4msYOmornpmCDciRbYe2tXpbbXuG+M9KjDI=;
  b=WPWVQOFcUuf9yhudwrupGIb/FHkGTZHxQpZChqNoO9gG835dm75gAPCg
   6e7yPQqJ+mMG+S+7G26Hev+ubfR0QVGRJKtalNUj2RcL884BoskZZ+tgJ
   bxps/3jmJWagwZwJ17dsxmnU2Q06y5JjuD42Pg8aZD1lThkljbyf8KE+I
   9M43tE0nCBTkLQSJjdzBIu+BZH4CfJwOL0EQmtXlS3ifdF6SuYTxJSuPO
   S3lUlHdcHKBaDjb9N79aQ8iwaCZFAOmjJ78QIYzobQZ9nUyq+kZFAhVEe
   4BQ6Yp1SOMBLgelp+wze7hdTgll+ozd7lTQsN0c/uAAVF4+rXIWYRiWyO
   A==;
X-CSE-ConnectionGUID: M7hWAMUaTROKqVAbqjck4Q==
X-CSE-MsgGUID: ZipqQfHVQeOL3zL0GSAHTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="52956628"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="52956628"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:41:47 -0700
X-CSE-ConnectionGUID: Lq1snJB9TjipDnp5/o0Aag==
X-CSE-MsgGUID: ebuZZdehSzaPJEFFtqXdig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="185220939"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:41:42 -0700
Message-ID: <1318c33d-9733-4541-b9f8-691a5dc2586e@linux.intel.com>
Date: Thu, 3 Jul 2025 14:41:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/16] i386/cpu: Consolidate CPUID 0x4 leaf
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
 <20250620092734.1576677-6-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-6-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> Modern Intel CPUs use CPUID 0x4 leaf to describe cache information
> and leave space in 0x2 for prefetch and TLBs (even TLB has its own leaf
> CPUID 0x18).
>
> And 0x2 leaf provides a descriptor 0xFF to instruct software to check
> cache information in 0x4 leaf instead.
>
> Therefore, follow this behavior to encode 0xFF when Intel CPU has 0x4
> leaf with "x-consistent-cache=true" for compatibility.
>
> In addition, for older CPUs without 0x4 leaf, still enumerate the cache
> descriptor in 0x2 leaf, except the case that there's no descriptor
> matching the cache model, then directly encode 0xFF in 0x2 leaf. This
> makes sense, as in the 0x2 leaf era, all supported caches should have
> the corresponding descriptor.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 48 ++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 37 insertions(+), 11 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 2f895bf13523..a06aa1d629dc 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -223,7 +223,7 @@ struct CPUID2CacheDescriptorInfo cpuid2_cache_descriptors[] = {
>   * Return a CPUID 2 cache descriptor for a given cache.
>   * If no known descriptor is found, return CACHE_DESCRIPTOR_UNAVAILABLE
>   */
> -static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
> +static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache, bool *unmacthed)
>  {
>      int i;
>  
> @@ -240,9 +240,44 @@ static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
>              }
>      }
>  
> +    *unmacthed |= true;
>      return CACHE_DESCRIPTOR_UNAVAILABLE;
>  }
>  
> +/* Encode cache info for CPUID[4] */
> +static void encode_cache_cpuid2(X86CPU *cpu,
> +                                uint32_t *eax, uint32_t *ebx,
> +                                uint32_t *ecx, uint32_t *edx)
> +{
> +    CPUX86State *env = &cpu->env;
> +    CPUCaches *caches = &env->cache_info_cpuid2;
> +    int l1d, l1i, l2, l3;
> +    bool unmatched = false;
> +
> +    *eax = 1; /* Number of CPUID[EAX=2] calls required */
> +    *ebx = *ecx = *edx = 0;
> +
> +    l1d = cpuid2_cache_descriptor(caches->l1d_cache, &unmatched);
> +    l1i = cpuid2_cache_descriptor(caches->l1i_cache, &unmatched);
> +    l2 = cpuid2_cache_descriptor(caches->l2_cache, &unmatched);
> +    l3 = cpuid2_cache_descriptor(caches->l3_cache, &unmatched);
> +
> +    if (!cpu->consistent_cache ||
> +        (env->cpuid_min_level < 0x4 && !unmatched)) {
> +        /*
> +         * Though SDM defines code 0x40 for cases with no L2 or L3. It's
> +         * also valid to just ignore l3's code if there's no l2.
> +         */
> +        if (cpu->enable_l3_cache) {
> +            *ecx = l3;
> +        }
> +        *edx = (l1d << 16) | (l1i <<  8) | l2;
> +    } else {
> +        *ecx = 0;
> +        *edx = CACHE_DESCRIPTOR_UNAVAILABLE;
> +    }
> +}
> +
>  /* CPUID Leaf 4 constants: */
>  
>  /* EAX: */
> @@ -7451,16 +7486,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>              *eax = *ebx = *ecx = *edx = 0;
>              break;
>          }
> -        *eax = 1; /* Number of CPUID[EAX=2] calls required */
> -        *ebx = 0;
> -        if (!cpu->enable_l3_cache) {
> -            *ecx = 0;
> -        } else {
> -            *ecx = cpuid2_cache_descriptor(env->cache_info_cpuid2.l3_cache);
> -        }
> -        *edx = (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1d_cache) << 16) |
> -               (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1i_cache) <<  8) |
> -               (cpuid2_cache_descriptor(env->cache_info_cpuid2.l2_cache));
> +        encode_cache_cpuid2(cpu, eax, ebx, ecx, edx);
>          break;
>      case 4:
>          /* cache info: needed for Core compatibility */

LGTM.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



