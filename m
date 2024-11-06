Return-Path: <kvm+bounces-30845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 703E09BDDA9
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 04:36:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01CF11F2358C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA76E19047F;
	Wed,  6 Nov 2024 03:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mDR3niQ8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8961F19006F
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 03:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730864179; cv=none; b=SwTjYoExSfUbL7GOMJA1/JqaG2bBdG+N47fNk+rSoFvlD/DKpBCo9PtIZcv4jD4fbTuUFEIViBte8pgzfTleN/U81hNfSH+OCKMR24n0Bs01XB4qzkxdTxrZEjfV+onMwQjleWwl2mMK/rBaz0IvHCZwGoe3atl/NYyUK47eRFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730864179; c=relaxed/simple;
	bh=b/LjEV98+IEYePScSsvtFe/I008tMdVIcy/1aEMTVQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RONTn0NNMGmhnlLCcDqd+UxVbUwotPtha+L/axZAa/r8k17t+pQAJdoRYlgkMePgC5pSh+odredh9hZ2/Fsl8u3TXSunkT6d8Vnn1f6g/obUtNZt5u8bEHlfMqEdMDr7k7WDrdEu24iP82/b4bVjDSihhFOzl3owvFnWGqnWBm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mDR3niQ8; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730864177; x=1762400177;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b/LjEV98+IEYePScSsvtFe/I008tMdVIcy/1aEMTVQg=;
  b=mDR3niQ8oOIAv+NAzOVGUk2JCbRGdwBw3wPc7ENLFX0OuGFa5vjmpeLm
   p0xnKBKXI+OGHFldOsGqKYq80BhaSkhhvKMLZf7umSpNZZcx+VnmYlDx3
   hwLzU21BK7NFAP5SxE82C+HLF80/LiOarnMYYupSFxkPffk+OB5AiRW9B
   dUoGx3TF/xZrpdeAbsM6eWl2VH9+KOeZOxxWUPs6MTHtMLllQSirVYpIk
   vbiOpP7eukhTIaktGPezvPtDv69EbbAvRxhdWQ2L/DPw+RRkxf2E9aJUE
   2PonIrj6eBbKxiIbF0jPdosO7lQFzExlo78oUX0YcrjfWHihzH2v1xGjM
   g==;
X-CSE-ConnectionGUID: 0mloQcXbQiyaDP8bcvvKwg==
X-CSE-MsgGUID: QxiQLKG/QNCd1kcWCjvAvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="34571407"
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="34571407"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 19:36:16 -0800
X-CSE-ConnectionGUID: J1yWAnCQSK60motsMdSHig==
X-CSE-MsgGUID: LYxdUWSaT22FcM+nT4VHcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="88855947"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 05 Nov 2024 19:36:12 -0800
Date: Wed, 6 Nov 2024 11:54:04 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, lyan@digitalocean.com,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, joe.jin@oracle.com, davydov-max@yandex-team.ru
Subject: Re: [PATCH 1/7] target/i386: disable PerfMonV2 when PERFCORE
 unavailable
Message-ID: <ZyroXEOsRPonKD7x@intel.com>
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-2-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104094119.4131-2-dongli.zhang@oracle.com>

Hi Dongli,

On Mon, Nov 04, 2024 at 01:40:16AM -0800, Dongli Zhang wrote:
> Date: Mon,  4 Nov 2024 01:40:16 -0800
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH 1/7] target/i386: disable PerfMonV2 when PERFCORE
>  unavailable
> X-Mailer: git-send-email 2.43.5
> 
> When the PERFCORE is disabled with "-cpu host,-perfctr-core", it is
> reflected in in guest dmesg.
> 
> [    0.285136] Performance Events: AMD PMU driver.
> 
> However, the guest cpuid indicates the PerfMonV2 is still available.
> 
> CPU:
>    Extended Performance Monitoring and Debugging (0x80000022):
>       AMD performance monitoring V2         = true
>       AMD LBR V2                            = false
>       AMD LBR stack & PMC freezing          = false
>       number of core perf ctrs              = 0x6 (6)
>       number of LBR stack entries           = 0x0 (0)
>       number of avail Northbridge perf ctrs = 0x0 (0)
>       number of available UMC PMCs          = 0x0 (0)
>       active UMCs bitmask                   = 0x0
> 
> Disable PerfMonV2 in cpuid when PERFCORE is disabled.
> 
> Fixes: 209b0ac12074 ("target/i386: Add PerfMonV2 feature bit")
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  target/i386/cpu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 3baa95481f..4490a7a8d6 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7103,6 +7103,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          *eax = *ebx = *ecx = *edx = 0;
>          /* AMD Extended Performance Monitoring and Debug */
>          if (kvm_enabled() && cpu->enable_pmu &&
> +            (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_PERFCORE) &&
>              (env->features[FEAT_8000_0022_EAX] & CPUID_8000_0022_EAX_PERFMON_V2)) {
>              *eax |= CPUID_8000_0022_EAX_PERFMON_V2;
>              *ebx |= kvm_arch_get_supported_cpuid(cs->kvm_state, index, count,

You can define dependency like this:

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3baa95481fbc..99c69ec9f369 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1803,6 +1803,10 @@ static FeatureDep feature_dependencies[] = {
         .from = { FEAT_7_1_EDX,             CPUID_7_1_EDX_AVX10 },
         .to = { FEAT_24_0_EBX,              ~0ull },
     },
+    {
+        .from = { FEAT_8000_0001_ECX,       CPUID_EXT3_PERFCORE },
+        .to = { FEAT_8000_0022_EAX,         CPUID_8000_0022_EAX_PERFMON_V2 }
+    }
 };

 typedef struct X86RegisterInfo32 {

---
Does this meet your needs?

Regards,
Zhao


