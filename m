Return-Path: <kvm+bounces-61049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 27DF0C07B7A
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 20:22:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0D4044F9CC0
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 18:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD5B93491C2;
	Fri, 24 Oct 2025 18:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V1NkDRFe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D36B262FCB
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 18:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761330069; cv=none; b=XhfjVHFbYz6LPbm4lD4/rAwkRxENYv051HOKipwL4ocJ9w9hrTQdLJo8p5GMIvXavC21ywCfhB0uGaSTaz0rzMq8CrZVRUBfKczPndA2HBcwN1Q5tCPciUxa978f9HePZc6/sGINGTOegTWenwn4Kn3Pp2x1Ps7ZcjG2aFS/YXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761330069; c=relaxed/simple;
	bh=len0glU2yj1H+jJxLFoYUNqMIXEmHQqgK+yIOKm5WK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G87S1kcsXGWy3zPJp4KhGu/3/xjuW2YHcHx8mYY6bb6Fcbm87jjF13azBKPyYR4DirEXnibXt3WhWp73LtsObKR1/9dgYtLZ1oA0lBBGStJ7Kj/Fq8WqVRvWn3nBLMXBhT5cfgzOqjg+nwUGvrem3/2OAV+BVvADCBWMG8xv9js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V1NkDRFe; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761330067; x=1792866067;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=len0glU2yj1H+jJxLFoYUNqMIXEmHQqgK+yIOKm5WK4=;
  b=V1NkDRFeylBtIlU5An/QQKVE9BpxS2BNaLBuzry1yjIIkt52Z0p1EPNH
   I1eYRXeQZBWXQw7Vp1cS7VWnsOjLmJYpSa+eOvso/PipSO8BE67xNc/zM
   1Bc+Sj6DmPyrCQltiSZP3A6nLsS0GrW6pqnuS/h/zA7RqYYGeG1/drg09
   42bf7NEbDhf/wxFsrKnci3+bHFBLUK0mTBwnoLNnlLYmaUrpBGDwOzilV
   OpjgUE7Jj7PJ2Lwf3YCEVr43WZ7n4cjv7r+AblSlbJ3cvjzBRbaoS/lXZ
   aPrCw70UJqn1h7UYtbWZOtwj37D47ozZzX9cK8bsYw7BhMsEEH+vFD1n+
   w==;
X-CSE-ConnectionGUID: qjzT9oUZSTCUEoopE3EHUQ==
X-CSE-MsgGUID: veMS04CbRNimlxmhliVCew==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63550969"
X-IronPort-AV: E=Sophos;i="6.19,253,1754982000"; 
   d="scan'208";a="63550969"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 11:21:07 -0700
X-CSE-ConnectionGUID: 2WCoOoWFRcy/c3j3blz6VQ==
X-CSE-MsgGUID: fk28vnV3Q3yKX/jhnR3r/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,253,1754982000"; 
   d="scan'208";a="188882533"
Received: from soc-cp83kr3.clients.intel.com (HELO [10.241.241.181]) ([10.241.241.181])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 11:21:07 -0700
Message-ID: <03763c00-3f14-4cab-9a75-78771cbbb79a@intel.com>
Date: Fri, 24 Oct 2025 11:21:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/20] i386/cpu: Drop pmu check in CPUID 0x1C encoding
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-9-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20251024065632.1448606-9-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/23/2025 11:56 PM, Zhao Liu wrote:
> Since CPUID_7_0_EDX_ARCH_LBR will be masked off if pmu is disabled,
> there's no need to check CPUID_7_0_EDX_ARCH_LBR feature with pmu.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Zide Chen <zide.chen@intel.com>

> ---
>  target/i386/cpu.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 5b7a81fcdb1b..5cd335bb5574 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -8275,11 +8275,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          }
>          break;
>      }
> -    case 0x1C:
> -        if (cpu->enable_pmu && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
> -            x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
> -            *edx = 0;
> +    case 0x1C: /* Last Branch Records Information Leaf */
> +        *eax = 0;
> +        *ebx = 0;
> +        *ecx = 0;
> +        *edx = 0;
> +        if (!(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
> +            break;
>          }
> +        x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
> +        *edx = 0; /* EDX is reserved. */
>          break;
>      case 0x1D: {
>          /* AMX TILE, for now hardcoded for Sapphire Rapids*/


