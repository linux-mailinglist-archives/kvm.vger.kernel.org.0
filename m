Return-Path: <kvm+bounces-43933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C816DA98A7A
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A15C13AEA4F
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 13:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B0014F125;
	Wed, 23 Apr 2025 13:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X8NOLukP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE5738DF9
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 13:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745413558; cv=none; b=qN77x9biPoT9gMwacewbU2LfJ52NyJbLTnQRCsng9Frn/XV+DjAVB0tvgVFOktVqlCwGiRKuRySEsVopYQEGPUBizxIueEnecMjkaR65Bio0JD9hh9BtwVqw4lc6ugNMdlP4mMhXqsawFoqR/tmf1LyJlg2YE2567akuHkNQS9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745413558; c=relaxed/simple;
	bh=Tl+0+y185DgIHpX7ae3+z9ruYdWnjo2wg62la9Udigo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NVPnD5PsljAd5rFugXWDwTD5eHB/w8pM+ui4tWtxD8qP2lA1DzJ/drPWIJ0tAiBmlpjhL0MFwNqHBeABQ4yuNfoSwIbxh0iElAndOFqZDF2eWnmWslGk9BvdJJkfJFXJS14f9nKxUe4cq7hVvLW6/dsNoEqq4QjGS6/IZNVLZc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X8NOLukP; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745413557; x=1776949557;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Tl+0+y185DgIHpX7ae3+z9ruYdWnjo2wg62la9Udigo=;
  b=X8NOLukP70fgQFLAmghDN552IKm7ipfpozHoid5lC5W12KSYpiMPIXG2
   MNejRiny6Isv0tPOHrU3pwxXlQwbZSDDuGZHw3fgKsUblqRs/cvjaIQuV
   gGHz69s0eXTHVpP57knKxlpx9ew7w4jlIXDkB4b1uLFSWo6oPn0K36qQo
   LeU6lrayl+PlfkgqsRucV2hn0F5a3tR6SMf2/fm32HGWMtYdmggzvpMP4
   OsqQwtEY2rSWp1G83gBidmlCUcA4iPTrkAwmFEmdRbEflRZaQcKKvhwFd
   S6AEpKCUFnL7mo56FLMQeNh/PvmYdeanv2oKWSR3vRUCviVEeLG+EnOhY
   w==;
X-CSE-ConnectionGUID: QCxCGR5eR+yLELOfVnMckg==
X-CSE-MsgGUID: VIa0NbGnRxyiJ9ox2O8PNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="46914903"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="46914903"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 06:05:51 -0700
X-CSE-ConnectionGUID: uXSIB91ITSG/dEQvO9r4RQ==
X-CSE-MsgGUID: HzAHN9adTmaDywAH/ernmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132061302"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 06:05:46 -0700
Message-ID: <596c7a44-797b-4a16-bd7e-0f0dc5c2e593@intel.com>
Date: Wed, 23 Apr 2025 21:05:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/10] i386/cpu: Mark CPUID[0x80000005] as reserved for
 Intel
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>
Cc: Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
 Tejus GK <tejus.gk@nutanix.com>, Jason Zeng <jason.zeng@intel.com>,
 Manish Mishra <manish.mishra@nutanix.com>, Tao Su <tao1.su@intel.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <20250423114702.1529340-2-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250423114702.1529340-2-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/23/2025 7:46 PM, Zhao Liu wrote:
> Per SDM, 0x80000005 leaf is reserved for Intel CPU, and its current
> "assert" check blocks adding new cache model for non-AMD CPUs.
> 
> Therefore, check the vendor and encode this leaf as all-0 for Intel
> CPU. And since Zhaoxin mostly follows Intel behavior, apply the vendor
> check for Zhaoxin as well.
> 
> Note, for !vendor_cpuid_only case, non-AMD CPU would get the wrong
> information, i.e., get AMD's cache model for Intel or Zhaoxin CPUs.
> For this case, there is no need to tweak for non-AMD CPUs, because
> vendor_cpuid_only has been turned on by default since PC machine v6.1.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>   target/i386/cpu.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 1b64ceaaba46..8fdafa8aedaf 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7248,11 +7248,23 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>           *edx = env->cpuid_model[(index - 0x80000002) * 4 + 3];
>           break;
>       case 0x80000005:
> -        /* cache info (L1 cache) */
> -        if (cpu->cache_info_passthrough) {
> +        /*
> +         * cache info (L1 cache)
> +         *
> +         * For !vendor_cpuid_only case, non-AMD CPU would get the wrong
> +         * information, i.e., get AMD's cache model. It doesn't matter,
> +         * vendor_cpuid_only has been turned on by default since
> +         * PC machine v6.1.
> +         */

We need to define a new compat property for it other than 
vendor_cpuid_only, for 10.1.

I proposed some change to leaf FEAT_8000_0001_EDX[1], and I was told by 
Paolo (privately) that vendor_cpuid_only doesn't suffice.

  On Fri, Oct 11, 2024 at 6:22 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
  >
  > On 10/11/2024 11:30 PM, Paolo Bonzini wrote:
  > > On Fri, Oct 11, 2024 at 4:55 PM Xiaoyao Li <xiaoyao.li@intel.com> 
wrote:
  > >>
  > >> I think patch 8 is also a general issue> Without it, the
  > >> CPUID_EXT2_AMD_ALIASES bits are exposed to Intel VMs which are
  > >> reserved bits for Intel.
  > >
  > > Yes but you'd have to add compat properties for these. If you can do
  > > it for TDX only, that's easier.
  >
  > Does vendor_cpuid_only suffice?

  Unfortunately not, because it is turned off only for <=6.0 machine
  types. Here you'd have to turn it off for <=9.1 machine types.


[1] 
https://lore.kernel.org/qemu-devel/20240814075431.339209-9-xiaoyao.li@intel.com/


> +        if (cpu->vendor_cpuid_only &&
> +            (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
> +            *eax = *ebx = *ecx = *edx = 0;
> +            break;
> +        } else if (cpu->cache_info_passthrough) {
>               x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
>               break;
>           }
> +
>           *eax = (L1_DTLB_2M_ASSOC << 24) | (L1_DTLB_2M_ENTRIES << 16) |
>                  (L1_ITLB_2M_ASSOC <<  8) | (L1_ITLB_2M_ENTRIES);
>           *ebx = (L1_DTLB_4K_ASSOC << 24) | (L1_DTLB_4K_ENTRIES << 16) |


