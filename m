Return-Path: <kvm+bounces-51376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 315E3AF6B07
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:04:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFA0C7B6650
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 07:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D908298262;
	Thu,  3 Jul 2025 07:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NWp0edvH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6533328DEFC
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 07:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751526200; cv=none; b=JSNDy0/mLfetLGlcG5B59gXW94vtxuNQGSl89TNItzlWoTnyiy1rVfmDF4AmsKQVu154SM1JMpnAOKxdsYI6z1gcc3V24YrrDqEXqIF2wlVdlN6kQxFcpMVXvlcxoe0gsTMH8Ugb5mySnD/CpP/BlgvjuwUGQpwmkWYqMXlxyVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751526200; c=relaxed/simple;
	bh=BzXwtEIeavtTZYYUVx+lfAQIPYpgvTwFbxREu6EtwrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ajfKhico0hvXY2AuYez7mqufC5qhgQA4HQwZJK42hyKsm1wBp/sDAyOsjwvd+mudSBHStJX7PY1dIXW5Me41KjEm0R2SXUgDcRXs2PvTby/IzlQAgX9V6UrLeA1CgKn6VvMo2kfvM58mFL7qDslO9SSAKaVQ+MdhqrrPyTmOq/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NWp0edvH; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751526199; x=1783062199;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BzXwtEIeavtTZYYUVx+lfAQIPYpgvTwFbxREu6EtwrI=;
  b=NWp0edvHtKj77Xx/AHTrdnsetMHofamUBqQa8LkfXc3WLYgWiQ9St85c
   1Um4W2hQaYKhiTTqibytHiUnqYXWikHGHwPZcVsoVWo1RHUHvyWhwIAt0
   k+FrxKCqPOHJDsvVZAAtUsyaILAgOd+s4buxPvsCb5FRg4J/zNnCMppoh
   VCAWw4Xd9NU1xXpzxG6gxyIHlPXiEbiLOv76z19x5JGwhJ3OBiNK0kg/6
   uWrzQ7Nnhq77Yr+lxRZpGHiP7rRd4qoeZBVaMhesI0ju/555bX9UNSW18
   3uyhGd9Hh4Kxl+ZWYNBjYIMTMskn+QBRzXiDl3Vnuh2PsWk1wZgNPxNAk
   A==;
X-CSE-ConnectionGUID: jiIR079oSr6Dnnc/rA/vTg==
X-CSE-MsgGUID: IPhmP07bRPOgiPM8f8Fz0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="64535942"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="64535942"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:03:17 -0700
X-CSE-ConnectionGUID: ktBMxDa0SVq6uwU+UbRsHA==
X-CSE-MsgGUID: lvFHRDRCQuecOiGfPhCX8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="153924989"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:03:12 -0700
Message-ID: <705f8d41-3577-453a-8464-5cb383708c25@linux.intel.com>
Date: Thu, 3 Jul 2025 15:03:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/16] i386/cpu: Drop CPUID 0x2 specific cache info in
 X86CPUState
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
 <20250620092734.1576677-7-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-7-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> With the pre-defined cache model legacy_intel_cpuid2_cache_info,
> for X86CPUState there's no need to cache special cache information
> for CPUID 0x2 leaf.
>
> Drop the cache_info_cpuid2 field of X86CPUState and use the
> legacy_intel_cpuid2_cache_info directly.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 31 +++++++++++--------------------
>  target/i386/cpu.h |  3 ++-
>  2 files changed, 13 insertions(+), 21 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index a06aa1d629dc..8f174fb971b6 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -244,19 +244,27 @@ static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache, bool *unmacthed)
>      return CACHE_DESCRIPTOR_UNAVAILABLE;
>  }
>  
> +static const CPUCaches legacy_intel_cpuid2_cache_info;
> +
>  /* Encode cache info for CPUID[4] */
>  static void encode_cache_cpuid2(X86CPU *cpu,
>                                  uint32_t *eax, uint32_t *ebx,
>                                  uint32_t *ecx, uint32_t *edx)
>  {
>      CPUX86State *env = &cpu->env;
> -    CPUCaches *caches = &env->cache_info_cpuid2;
> +    const CPUCaches *caches;
>      int l1d, l1i, l2, l3;
>      bool unmatched = false;
>  
>      *eax = 1; /* Number of CPUID[EAX=2] calls required */
>      *ebx = *ecx = *edx = 0;
>  
> +    if (env->enable_legacy_cpuid2_cache) {
> +        caches = &legacy_intel_cpuid2_cache_info;
> +    } else {
> +        caches = &env->cache_info_cpuid4;
> +    }
> +
>      l1d = cpuid2_cache_descriptor(caches->l1d_cache, &unmatched);
>      l1i = cpuid2_cache_descriptor(caches->l1i_cache, &unmatched);
>      l2 = cpuid2_cache_descriptor(caches->l2_cache, &unmatched);
> @@ -705,17 +713,6 @@ static CPUCacheInfo legacy_l2_cache = {
>      .share_level = CPU_TOPOLOGY_LEVEL_CORE,
>  };
>  
> -/*FIXME: CPUID leaf 2 descriptor is inconsistent with CPUID leaf 4 */
> -static CPUCacheInfo legacy_l2_cache_cpuid2 = {
> -    .type = UNIFIED_CACHE,
> -    .level = 2,
> -    .size = 2 * MiB,
> -    .line_size = 64,
> -    .associativity = 8,
> -    .share_level = CPU_TOPOLOGY_LEVEL_INVALID,
> -};
> -
> -
>  /*FIXME: CPUID leaf 0x80000006 is inconsistent with leaves 2 & 4 */
>  static CPUCacheInfo legacy_l2_cache_amd = {
>      .type = UNIFIED_CACHE,
> @@ -8951,18 +8948,12 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>                         "CPU model '%s' doesn't support legacy-cache=off", name);
>              return;
>          }
> -        env->cache_info_cpuid2 = env->cache_info_cpuid4 = env->cache_info_amd =
> -            *cache_info;
> +        env->cache_info_cpuid4 = env->cache_info_amd = *cache_info;
>      } else {
>          /* Build legacy cache information */
> -        env->cache_info_cpuid2.l1d_cache = &legacy_l1d_cache;
> -        env->cache_info_cpuid2.l1i_cache = &legacy_l1i_cache;
>          if (!cpu->consistent_cache) {
> -            env->cache_info_cpuid2.l2_cache = &legacy_l2_cache_cpuid2;
> -        } else {
> -            env->cache_info_cpuid2.l2_cache = &legacy_l2_cache;
> +            env->enable_legacy_cpuid2_cache = true;
>          }
> -        env->cache_info_cpuid2.l3_cache = &legacy_l3_cache;
>  
>          env->cache_info_cpuid4.l1d_cache = &legacy_l1d_cache;
>          env->cache_info_cpuid4.l1i_cache = &legacy_l1i_cache;
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 3c7e59ffb12a..8d3ce8a2b678 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2076,7 +2076,8 @@ typedef struct CPUArchState {
>       * on each CPUID leaf will be different, because we keep compatibility
>       * with old QEMU versions.
>       */
> -    CPUCaches cache_info_cpuid2, cache_info_cpuid4, cache_info_amd;
> +    CPUCaches cache_info_cpuid4, cache_info_amd;
> +    bool enable_legacy_cpuid2_cache;
>  
>      /* MTRRs */
>      uint64_t mtrr_fixed[11];

LGTM.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


