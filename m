Return-Path: <kvm+bounces-51382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0BF5AF6B4A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:18:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C77891C27A2B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 07:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 607A9293B72;
	Thu,  3 Jul 2025 07:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ITuIzenR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89C91CD1F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 07:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751527126; cv=none; b=KSB5oTUdi1bIioslLIliqHg0x2QwoWAYEg8S0gcr1pUkU3yoWhUYmSWc+op5r8yAUaLpkAgmAWwt1FXSWPkotuMC1Z8qZm6BqoXAXNz2AqJVGhxY2HxpWx/UcNh7Be7ARD1VDFrob9s1Zu0FokBh22L+CpILkuwimzMh1HjXvGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751527126; c=relaxed/simple;
	bh=y/Iecl85y+ckLurPf5zWK8lSIDvcS82wO6Az/OPu2bw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TPTQUxiksMGVDk54nxOb2j2CDqJiRfQckIYfoHpmxv61FtvBv4xTdoKPI0bj0LJCWvsRIHhTjmYswKaH+zESsL41uislzCdM1U618KAz3TfefvO6gLppzhhxze4Q2DSBn123UAAUuiNxFpyWwxMcZozj+10ASGbHMVpqeMDXmF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ITuIzenR; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751527125; x=1783063125;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y/Iecl85y+ckLurPf5zWK8lSIDvcS82wO6Az/OPu2bw=;
  b=ITuIzenRMz6WIdy1oSCJhtsVtlgKqFQioL9j3k3aNCM4tNJ5u/SfqwoF
   o0RXp9DvBhwgB3fVpuJJIIj0nIS6nKUOwDke9FgBvv2+13gRPin57WVK6
   y0Nd+frKlGTaB1zgL9tINDg6c6dNfYUXslhmwr0finbBXsURMT905bMSZ
   m/QjHCi67WYvDRIHUi1CcHU5myvSCaSqa+NYxUt0D5Lots6GdlCDDmEaF
   d50Ungmc7OghVAKbAYj1g2eE5n/UtmDg03Dakf8/JgrVlANen98Dwz5YQ
   CBNnUXlI0TqeELGqCDw40wXsfFcZb73c44ngrcrSnGQn9nW8Cpdt4W6yO
   g==;
X-CSE-ConnectionGUID: Uckw80tLQaSQJ7yIbcGeqQ==
X-CSE-MsgGUID: Udkk/lnBTFKkbpapaflynQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53711116"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="53711116"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:18:44 -0700
X-CSE-ConnectionGUID: drtH/3P+TfyL2GOQOs2hOA==
X-CSE-MsgGUID: UFlvVw7oScOo3wAK/iF1Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="159798915"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:18:39 -0700
Message-ID: <8d2b621f-3a3d-4657-8013-2f181b05d17a@linux.intel.com>
Date: Thu, 3 Jul 2025 15:18:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/16] i386/cpu: Add legacy_amd_cache_info cache model
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
 <20250620092734.1576677-11-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-11-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> Based on legacy_l1d_cachei_amd, legacy_l1i_cache_amd, legacy_l2_cache_amd
> and legacy_l3_cache, build a complete legacy AMD cache model, which can
> clarify the purpose of these trivial legacy cache models, simplify the
> initialization of cache info in X86CPUState, and make it easier to
> handle compatibility later.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 112 ++++++++++++++++++++++------------------------
>  1 file changed, 53 insertions(+), 59 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index ec229830c532..bf8d7a19c88d 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -643,60 +643,58 @@ static void encode_topo_cpuid8000001e(X86CPU *cpu, X86CPUTopoInfo *topo_info,
>   * These are legacy cache values. If there is a need to change any
>   * of these values please use builtin_x86_defs
>   */
> -static CPUCacheInfo legacy_l1d_cache_amd = {
> -    .type = DATA_CACHE,
> -    .level = 1,
> -    .size = 64 * KiB,
> -    .self_init = 1,
> -    .line_size = 64,
> -    .associativity = 2,
> -    .sets = 512,
> -    .partitions = 1,
> -    .lines_per_tag = 1,
> -    .no_invd_sharing = true,
> -    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> -};
> -
> -static CPUCacheInfo legacy_l1i_cache_amd = {
> -    .type = INSTRUCTION_CACHE,
> -    .level = 1,
> -    .size = 64 * KiB,
> -    .self_init = 1,
> -    .line_size = 64,
> -    .associativity = 2,
> -    .sets = 512,
> -    .partitions = 1,
> -    .lines_per_tag = 1,
> -    .no_invd_sharing = true,
> -    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> -};
> -
> -static CPUCacheInfo legacy_l2_cache_amd = {
> -    .type = UNIFIED_CACHE,
> -    .level = 2,
> -    .size = 512 * KiB,
> -    .line_size = 64,
> -    .lines_per_tag = 1,
> -    .associativity = 16,
> -    .sets = 512,
> -    .partitions = 1,
> -    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> -};
> -
> -/* Level 3 unified cache: */
> -static CPUCacheInfo legacy_l3_cache = {
> -    .type = UNIFIED_CACHE,
> -    .level = 3,
> -    .size = 16 * MiB,
> -    .line_size = 64,
> -    .associativity = 16,
> -    .sets = 16384,
> -    .partitions = 1,
> -    .lines_per_tag = 1,
> -    .self_init = true,
> -    .inclusive = true,
> -    .complex_indexing = true,
> -    .share_level = CPU_TOPOLOGY_LEVEL_DIE,
> +static const CPUCaches legacy_amd_cache_info = {
> +    .l1d_cache = &(CPUCacheInfo) {
> +        .type = DATA_CACHE,
> +        .level = 1,
> +        .size = 64 * KiB,
> +        .self_init = 1,
> +        .line_size = 64,
> +        .associativity = 2,
> +        .sets = 512,
> +        .partitions = 1,
> +        .lines_per_tag = 1,
> +        .no_invd_sharing = true,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l1i_cache = &(CPUCacheInfo) {
> +        .type = INSTRUCTION_CACHE,
> +        .level = 1,
> +        .size = 64 * KiB,
> +        .self_init = 1,
> +        .line_size = 64,
> +        .associativity = 2,
> +        .sets = 512,
> +        .partitions = 1,
> +        .lines_per_tag = 1,
> +        .no_invd_sharing = true,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l2_cache = &(CPUCacheInfo) {
> +        .type = UNIFIED_CACHE,
> +        .level = 2,
> +        .size = 512 * KiB,
> +        .line_size = 64,
> +        .lines_per_tag = 1,
> +        .associativity = 16,
> +        .sets = 512,
> +        .partitions = 1,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l3_cache = &(CPUCacheInfo) {
> +        .type = UNIFIED_CACHE,
> +        .level = 3,
> +        .size = 16 * MiB,
> +        .line_size = 64,
> +        .associativity = 16,
> +        .sets = 16384,
> +        .partitions = 1,
> +        .lines_per_tag = 1,
> +        .self_init = true,
> +        .inclusive = true,
> +        .complex_indexing = true,
> +        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
> +    },
>  };
>  
>  /*
> @@ -8982,11 +8980,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>          }
>  
>          env->cache_info_cpuid4 = legacy_intel_cache_info;
> -
> -        env->cache_info_amd.l1d_cache = &legacy_l1d_cache_amd;
> -        env->cache_info_amd.l1i_cache = &legacy_l1i_cache_amd;
> -        env->cache_info_amd.l2_cache = &legacy_l2_cache_amd;
> -        env->cache_info_amd.l3_cache = &legacy_l3_cache;
> +        env->cache_info_amd = legacy_amd_cache_info;
>      }
>  
>  #ifndef CONFIG_USER_ONLY

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


