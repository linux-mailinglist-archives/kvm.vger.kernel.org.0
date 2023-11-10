Return-Path: <kvm+bounces-1449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB4C97E77F0
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 04:22:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76FB02815D6
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC04915C9;
	Fri, 10 Nov 2023 03:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XVTRXLx0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56CE7EB
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 03:22:19 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7B044B8;
	Thu,  9 Nov 2023 19:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699586539; x=1731122539;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LyXh89DZFds6kfqwwgiPNw2dRbfgv6YGyU8KIF0+n1g=;
  b=XVTRXLx0hdti7N+UfyyD79bsnJC9xs2atgxYKZ2xDPlApPkXMbCGlTZi
   5UAIKeyTuanPocSzrMwiUU30hogQoFHW5v+0K81ukbUIL8dSLLFJM5ugA
   0Src9g+BSUT6E5h+oF0tZpPAXytlkPvtjdF43cb9/ekoVCNB3UFkbEpdV
   jys+d03Hi2uO3XiW2/9otn1XnqUN5/7VNzBaVYw+XCedyEXJVBU94+pYj
   iI4OxF/nMpvtPhNTlqeOn6ExVXR2getYEwK0OSRO9U5D5fTMVznhv+aVG
   RjF3OR0jxIiybTddWiyIn56znXIZ95EPAtoq8RyC/JEEpFhm25UGLjvyE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="8777558"
X-IronPort-AV: E=Sophos;i="6.03,291,1694761200"; 
   d="scan'208";a="8777558"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 19:22:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="1010837947"
X-IronPort-AV: E=Sophos;i="6.03,291,1694761200"; 
   d="scan'208";a="1010837947"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.53]) ([10.93.5.53])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 19:22:15 -0800
Message-ID: <5d0c1946-0b22-4983-868b-db7f79fe16bc@linux.intel.com>
Date: Fri, 10 Nov 2023 11:22:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/26] KVM: x86/pmu: Apply "fast" RDPMC only to Intel
 PMUs
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>,
 Like Xu <likexu@tencent.com>
References: <20231110021306.1269082-1-seanjc@google.com>
 <20231110021306.1269082-8-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20231110021306.1269082-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/10/2023 10:12 AM, Sean Christopherson wrote:
> Move the handling of "fast" RDPMC instructions, which drop bits 63:31 of


63:32?


> the count, to Intel.  The "fast" flag, and all flags for that matter, are
> Intel-only and aren't supported by AMD.
>
> Opportunistically replace open coded bit crud with proper #defines.
>
> Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/pmu.c           |  3 +--
>   arch/x86/kvm/vmx/pmu_intel.c | 20 ++++++++++++++++----
>   2 files changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 99ed72966528..e3ba5e12c2e7 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -499,10 +499,9 @@ static int kvm_pmu_rdpmc_vmware(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>   
>   int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>   {
> -	bool fast_mode = idx & (1u << 31);
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>   	struct kvm_pmc *pmc;
> -	u64 mask = fast_mode ? ~0u : ~0ull;
> +	u64 mask = ~0ull;
>   
>   	if (!pmu->version)
>   		return 1;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 3bac3b32b485..c6ea128ea7c8 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -20,6 +20,10 @@
>   #include "nested.h"
>   #include "pmu.h"
>   
> +/* Perf's "BASE" is wildly misleading, this is a single-bit flag, not a base. */
> +#define INTEL_RDPMC_FIXED	INTEL_PMC_FIXED_RDPMC_BASE
> +#define INTEL_RDPMC_FAST	BIT(31)
> +
>   #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
>   
>   static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
> @@ -55,12 +59,17 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
>   	}
>   }
>   
> +static u32 intel_rdpmc_get_masked_idx(struct kvm_pmu *pmu, u32 idx)


inline?


> +{
> +	return idx & ~(INTEL_RDPMC_FIXED | INTEL_RDPMC_FAST);
> +}
> +
>   static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> -	bool fixed = idx & (1u << 30);
> +	bool fixed = idx & INTEL_RDPMC_FIXED;
>   
> -	idx &= ~(3u << 30);
> +	idx = intel_rdpmc_get_masked_idx(pmu, idx);
>   
>   	return fixed ? idx < pmu->nr_arch_fixed_counters
>   		     : idx < pmu->nr_arch_gp_counters;
> @@ -70,11 +79,14 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
>   					    unsigned int idx, u64 *mask)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> -	bool fixed = idx & (1u << 30);
> +	bool fixed = idx & INTEL_RDPMC_FIXED;
>   	struct kvm_pmc *counters;
>   	unsigned int num_counters;
>   
> -	idx &= ~(3u << 30);
> +	if (idx & INTEL_RDPMC_FAST)
> +		*mask &= GENMASK_ULL(31, 0);
> +
> +	idx = intel_rdpmc_get_masked_idx(pmu, idx);
>   	if (fixed) {
>   		counters = pmu->fixed_counters;
>   		num_counters = pmu->nr_arch_fixed_counters;
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

