Return-Path: <kvm+bounces-1450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FB97E7903
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 07:14:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 503C2281748
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 06:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A775670;
	Fri, 10 Nov 2023 06:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ew/wlSVH"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46EA538C
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 06:14:12 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBEC524E;
	Thu,  9 Nov 2023 22:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699596851; x=1731132851;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Cvu/feWwM6Drw45XaaoAHqUoqywA1BWLqtyRb/Y/siY=;
  b=Ew/wlSVH73wlvBwZkMwGMiWWBX3RsIBE4N6yM2kA0wHsR87JHXLP1O5R
   Sqr/H3/TTAk6ZqaNj3zwZ/UxvScEZuulx7ULu+BnifZkFYyDFWGDGbV72
   YbZ/R7nlP0xyJMON304tp0Q8E5cF1M4oSrvWBgfsTO7dBAYcFMcPct3IC
   q/nqMrscQDNohaMpOooUJLnC08VdJqzyZrjajJGG3Epbqi8HPY3aKMnYh
   +H8deEgzPhVeTCY5FafizwPm9pS72vcxX1v84CE6Cr7QMTfEDBtWUd0pM
   f3qWZf73hpRgMLNpps4QOYDwqJeaTsuHj2Q+exTO5oamfZ5K9KP7moOZ1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="380528796"
X-IronPort-AV: E=Sophos;i="6.03,291,1694761200"; 
   d="scan'208";a="380528796"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 22:07:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="740069660"
X-IronPort-AV: E=Sophos;i="6.03,291,1694761200"; 
   d="scan'208";a="740069660"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.53]) ([10.93.5.53])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 22:07:05 -0800
Message-ID: <c85ffcdc-bf0a-4047-a29d-0ee1b595a227@linux.intel.com>
Date: Fri, 10 Nov 2023 14:07:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/26] KVM: x86/pmu: Disallow "fast" RDPMC for
 architectural Intel PMUs
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>,
 Like Xu <likexu@tencent.com>
References: <20231110021306.1269082-1-seanjc@google.com>
 <20231110021306.1269082-9-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20231110021306.1269082-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/10/2023 10:12 AM, Sean Christopherson wrote:
> Inject #GP on RDPMC if the "fast" flag is set for architectural Intel
> PMUs, i.e. if the PMU version is non-zero.  Per Intel's SDM, and confirmed
> on bare metal, the "fast" flag is supported only for non-architectural
> PMUs, and is reserved for architectural PMUs.
>
>    If the processor does not support architectural performance monitoring
>    (CPUID.0AH:EAX[7:0]=0), ECX[30:0] specifies the index of the PMC to be
>    read. Setting ECX[31] selects “fast” read mode if supported. In this mode,
>    RDPMC returns bits 31:0 of the PMC in EAX while clearing EDX to zero.
>
>    If the processor does support architectural performance monitoring
>    (CPUID.0AH:EAX[7:0] ≠ 0), ECX[31:16] specifies type of PMC while ECX[15:0]
>    specifies the index of the PMC to be read within that type. The following
>    PMC types are currently defined:
>    — General-purpose counters use type 0. The index x (to read IA32_PMCx)
>      must be less than the value enumerated by CPUID.0AH.EAX[15:8] (thus
>      ECX[15:8] must be zero).
>    — Fixed-function counters use type 4000H. The index x (to read
>      IA32_FIXED_CTRx) can be used if either CPUID.0AH.EDX[4:0] > x or
>      CPUID.0AH.ECX[x] = 1 (thus ECX[15:5] must be 0).
>    — Performance metrics use type 2000H. This type can be used only if
>      IA32_PERF_CAPABILITIES.PERF_METRICS_AVAILABLE[bit 15]=1. For this type,
>      the index in ECX[15:0] is implementation specific.
>
> WARN if KVM ever actually tries to complete RDPMC for a non-architectural
> PMU as KVM doesn't support such PMUs, i.e. kvm_pmu_rdpmc() should reject
> the RDPMC before getting to the Intel code.
>
> Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
> Fixes: 67f4d4288c35 ("KVM: x86: rdpmc emulation checks the counter incorrectly")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index c6ea128ea7c8..80255f86072e 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -61,7 +61,19 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
>   
>   static u32 intel_rdpmc_get_masked_idx(struct kvm_pmu *pmu, u32 idx)
>   {
> -	return idx & ~(INTEL_RDPMC_FIXED | INTEL_RDPMC_FAST);
> +	/*
> +	 * Fast RDPMC is only supported on non-architectural PMUs, which KVM
> +	 * doesn't support.
> +	 */
> +	if (WARN_ON_ONCE(!pmu->version))
> +		return idx & ~INTEL_RDPMC_FAST;
> +
> +	/*
> +	 * Fixed PMCs are supported on all architectural PMUs.  Note, KVM only
> +	 * emulates fixed PMCs for PMU v2+, but the flag itself is still valid,
> +	 * i.e. let RDPMC fail due to accessing a non-existent counter.
> +	 */
> +	return idx & ~INTEL_RDPMC_FIXED;
>   }
>   
>   static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


