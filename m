Return-Path: <kvm+bounces-61048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 035E2C07B9B
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 20:23:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E85A1C26C57
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 18:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2FB034888E;
	Fri, 24 Oct 2025 18:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TgCAQno6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A340262FCB
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 18:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761330065; cv=none; b=ppeC6DIy4cGqeoOm5IaCUQnlXBTARtDuYJ/vkEL/tmHeXAAEtcBPpxgLgd+PN4+0eAFGqn+Sq/la005HZj2Y0ZHzzq8jtl7y8HA0MXTgQdEs9ii+w44wntq3OWws8pwSiW3PNnK0DYkOWuLjsG+zi8L8sdHMEyS2G18WxBz8fuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761330065; c=relaxed/simple;
	bh=qEjhueFmBdVFJfmSVo+4OwWjw4pk1oFYNkSXBsjouu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YBFsdKL8/vtTsX2D1yjy9XzsBlVjt4Je5nSumAnUDxpOR79+BMiOi9iYqe5H5DY2AzQH217yWXalCWYZ/OCSR0/KB+gjmvbgxVUdp1v5mcg+omdzLpsyWKBpuIi7e9MbM4kDUE46rYq+BoR0LGUnUFNWY4IGKZM2rPOFYYL5yFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TgCAQno6; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761330064; x=1792866064;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qEjhueFmBdVFJfmSVo+4OwWjw4pk1oFYNkSXBsjouu8=;
  b=TgCAQno67ElrUq3wr4z0kyMsw2nZGgqIw+gD6nLcXXFYYYXjPrsbo3iX
   srbhUbEhMJM7RI9SbPRejeAFqRCWWh8SRypA2kOd6HsSjLqKKHPt7hQQU
   Bbw/GFS4a2vAXzYGtqi6DL3s5RqfyVGCtk7bJyYZd6eWiCRMNlL3PIvDG
   LhBSvJDh+hO+DjoaG7q6mKChlBj+NiVt94cYRYFux7x0Q/zEs4ONgKYJv
   DViaC7Gfr3K67tFMg8nellmwv3GwytRZTE1O4PR4kffmQL7gSrSehHUtZ
   VqZHMi/29tauEYTyF5BeYwSwrAZi8iCNiaSv06Ki1ycj3T6mSptyATQTC
   A==;
X-CSE-ConnectionGUID: jzTuuuhiQfG6poqqJCABlA==
X-CSE-MsgGUID: IjwhSU9ITqGhIxb3LL/RUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63550967"
X-IronPort-AV: E=Sophos;i="6.19,253,1754982000"; 
   d="scan'208";a="63550967"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 11:21:04 -0700
X-CSE-ConnectionGUID: /wr5UoqaQ6WL2klWrJDb2w==
X-CSE-MsgGUID: XAHaULWUQ9uk1S9XO1XhZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,253,1754982000"; 
   d="scan'208";a="188882523"
Received: from soc-cp83kr3.clients.intel.com (HELO [10.241.241.181]) ([10.241.241.181])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 11:21:03 -0700
Message-ID: <ad613e22-fdfc-4870-9d90-8894218bb7fc@intel.com>
Date: Fri, 24 Oct 2025 11:21:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/20] i386/cpu: Reorganize dependency check for arch
 lbr state
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-8-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20251024065632.1448606-8-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/23/2025 11:56 PM, Zhao Liu wrote:
> The arch lbr state has 2 dependencies:
>  * Arch lbr feature bit (CPUID 0x7.0x0:EDX[bit 19]):
> 
>    This bit also depends on pmu property. Mask it off if pmu is disabled
>    in x86_cpu_expand_features(), so that it is not needed to repeatedly
>    check whether this bit is set as well as pmu is enabled.
> 
>    Note this doesn't need compat option, since even KVM hasn't support
>    arch lbr yet.
> 
>    The supported xstate is constructed based such dependency in
>    cpuid_has_xsave_feature(), so if pmu is disabled and arch lbr bit is
>    masked off, then arch lbr state won't be included in supported
>    xstates.
> 
>    Thus it's safe to drop the check on arch lbr bit in CPUID 0xD
>    encoding.
> 
>  * XSAVES feature bit (CPUID 0xD.0x1.EAX[bit 3]):
> 
>    Arch lbr state is a supervisor state, which requires the XSAVES
>    feature support. Enumerate supported supervisor state based on XSAVES
>    feature bit in x86_cpu_enable_xsave_components().
> 
>    Then it's safe to drop the check on XSAVES feature support during
>    CPUID 0XD encoding.
> 
> Suggested-by: Zide Chen <zide.chen@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Zide Chen <zide.chen@intel.com>

> ---
>  target/i386/cpu.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 236a2f3a9426..5b7a81fcdb1b 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -8174,16 +8174,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>              *ebx = xsave_area_size(xstate, true);
>              *ecx = env->features[FEAT_XSAVE_XSS_LO];
>              *edx = env->features[FEAT_XSAVE_XSS_HI];
> -            if (kvm_enabled() && cpu->enable_pmu &&
> -                (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR) &&
> -                (*eax & CPUID_XSAVE_XSAVES)) {
> -                *ecx |= XSTATE_ARCH_LBR_MASK;
> -            } else {
> -                *ecx &= ~XSTATE_ARCH_LBR_MASK;
> -            }
> -        } else if (count == 0xf && cpu->enable_pmu
> -                   && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
> -            x86_cpu_get_supported_cpuid(0xD, count, eax, ebx, ecx, edx);
>          } else if (count < ARRAY_SIZE(x86_ext_save_areas)) {
>              const ExtSaveArea *esa = &x86_ext_save_areas[count];
>  
> @@ -8902,6 +8892,12 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
>  
>      mask = 0;
>      for (i = 0; i < ARRAY_SIZE(x86_ext_save_areas); i++) {
> +        /* Skip supervisor states if XSAVES is not supported. */
> +        if (CPUID_XSTATE_XSS_MASK & (1 << i) &&
> +            !(env->features[FEAT_XSAVE] & CPUID_XSAVE_XSAVES)) {
> +            continue;
> +        }
> +
>          const ExtSaveArea *esa = &x86_ext_save_areas[i];
>          if (cpuid_has_xsave_feature(env, esa)) {
>              mask |= (1ULL << i);
> @@ -9019,11 +9015,13 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>          }
>      }
>  
> -    if (!cpu->pdcm_on_even_without_pmu) {
> +    if (!cpu->enable_pmu) {
>          /* PDCM is fixed1 bit for TDX */
> -        if (!cpu->enable_pmu && !is_tdx_vm()) {
> +        if (!cpu->pdcm_on_even_without_pmu && !is_tdx_vm()) {
>              env->features[FEAT_1_ECX] &= ~CPUID_EXT_PDCM;
>          }
> +
> +        env->features[FEAT_7_0_EDX] &= ~CPUID_7_0_EDX_ARCH_LBR;
>      }
>  
>      for (i = 0; i < ARRAY_SIZE(feature_dependencies); i++) {


