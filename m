Return-Path: <kvm+bounces-4018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CB2F480C119
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 07:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D36C1F20F29
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 06:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B0C1F5FC;
	Mon, 11 Dec 2023 06:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mdg0HjdP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A13D9;
	Sun, 10 Dec 2023 22:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702274611; x=1733810611;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fqItQSWm3yTpgW92qdHNXR7t4gqbCIKE+I2hDEIxe5o=;
  b=mdg0HjdPiD5tdHlwOLFWspJWL7xK050FikLzt2birfLupd8XSmJPe5gw
   7EyKSZYm9T+cVuNDQcMgthq7V8cWBGa3eUecuCPP8raDtHrSKOsg/DlDL
   RcIhltvlpTlQ87tb1pbn8xsdTDTgwcc9RjiN2c/SHsvy8a5TmcAmHfGeV
   rNA02d3ktn6pBx7AgEhrM5jPZdr18S0/JZT4ZAuMQqtpoB1qdIqxQZOng
   3WDMpDpsB1ggNFSRsg0udHvOpiXQgB22EIXcggFq6U/ZlesXDd1s+1IfZ
   mxBDHtY1Q0/jQPVDEwbJYcFCciglzQq/WDPp7qNBaYMOdNfImllqo24tw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10920"; a="374103030"
X-IronPort-AV: E=Sophos;i="6.04,267,1695711600"; 
   d="scan'208";a="374103030"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2023 22:03:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10920"; a="863642253"
X-IronPort-AV: E=Sophos;i="6.04,267,1695711600"; 
   d="scan'208";a="863642253"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.53]) ([10.93.5.53])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2023 22:03:28 -0800
Message-ID: <7639fb68-5142-42fe-9dff-7f7c31d03d22@linux.intel.com>
Date: Mon, 11 Dec 2023 14:03:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/28] KVM: x86/pmu: Disallow "fast" RDPMC for
 architectural Intel PMUs
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>,
 Like Xu <likexu@tencent.com>
References: <20231202000417.922113-1-seanjc@google.com>
 <20231202000417.922113-10-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20231202000417.922113-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/2/2023 8:03 AM, Sean Christopherson wrote:
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
> Opportunistically WARN if KVM ever actually tries to complete RDPMC for a
> non-architectural PMU, and drop the non-existent "support" for fast RDPMC,
> as KVM doesn't support such PMUs, i.e. kvm_pmu_rdpmc() should reject the
> RDPMC before getting to the Intel code.
>
> Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
> Fixes: 67f4d4288c35 ("KVM: x86: rdpmc emulation checks the counter incorrectly")
> Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 22 ++++++++++++++++++----
>   1 file changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 6903dd9b71ad..644de27bd48a 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -22,7 +22,6 @@
>   
>   /* Perf's "BASE" is wildly misleading, this is a single-bit flag, not a base. */
>   #define INTEL_RDPMC_FIXED	INTEL_PMC_FIXED_RDPMC_BASE
> -#define INTEL_RDPMC_FAST	BIT(31)
>   
>   #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
>   
> @@ -67,10 +66,25 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
>   	struct kvm_pmc *counters;
>   	unsigned int num_counters;
>   
> -	if (idx & INTEL_RDPMC_FAST)
> -		*mask &= GENMASK_ULL(31, 0);
> +	/*
> +	 * The encoding of ECX for RDPMC is different for architectural versus
> +	 * non-architecturals PMUs (PMUs with version '0').  For architectural
> +	 * PMUs, bits 31:16 specify the PMC type and bits 15:0 specify the PMC
> +	 * index.  For non-architectural PMUs, bit 31 is a "fast" flag, and
> +	 * bits 30:0 specify the PMC index.
> +	 *
> +	 * Yell and reject attempts to read PMCs for a non-architectural PMU,
> +	 * as KVM doesn't support such PMUs.
> +	 */
> +	if (WARN_ON_ONCE(!pmu->version))
> +		return NULL;
>   
> -	idx &= ~(INTEL_RDPMC_FIXED | INTEL_RDPMC_FAST);
> +	/*
> +	 * Fixed PMCs are supported on all architectural PMUs.  Note, KVM only
> +	 * emulates fixed PMCs for PMU v2+, but the flag itself is still valid,
> +	 * i.e. let RDPMC fail due to accessing a non-existent counter.
> +	 */
> +	idx &= ~INTEL_RDPMC_FIXED;
>   	if (fixed) {
>   		counters = pmu->fixed_counters;
>   		num_counters = pmu->nr_arch_fixed_counters;

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


