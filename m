Return-Path: <kvm+bounces-6121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E3E382BA24
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 04:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A56761C238EE
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 03:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B2739AF6;
	Fri, 12 Jan 2024 03:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S7AAR4UK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE9C29D07;
	Fri, 12 Jan 2024 03:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705031434; x=1736567434;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=32XZ4fGvgZQ7I9ngj0l5boYFVTWWUsztHQpTOBJ0QK8=;
  b=S7AAR4UKsmFUwSVQbLuvyfc4xBRa2bNLFPXLw1Fbl6MLf1BxEHZMzFSN
   XxJt1wNF9l/wbIUAOjlO+Zb1jSB5odKPEzLlh78AgdSAY1Q+2QwmkizQ3
   icycmvyIlqx+lUpyP5htyp0peYmwE3GyRTHqMcUZDWJXNwu17Q2pRbrXM
   VLh1iK/g6tcnx2zk89gviLD9/NFv6pv7C4FmMFl4g1rphg96jbBZNQSuq
   HPs98rz/IL0e2zn53TgffJQ82hzUOTbMdhd9/3mgMzT7OFygiVPWqoflB
   iw2mXpubrYBbTPfOvwIl96SM5nsx7z5yrkrUS7+DUnRrhBAourfrzrPjt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="397952993"
X-IronPort-AV: E=Sophos;i="6.04,188,1695711600"; 
   d="scan'208";a="397952993"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 19:50:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,188,1695711600"; 
   d="scan'208";a="24579052"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.98]) ([10.93.5.98])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 19:50:31 -0800
Message-ID: <35f1573e-2800-4cf1-a9f1-b3fa05d7a097@linux.intel.com>
Date: Fri, 12 Jan 2024 11:50:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 11/29] KVM: x86/pmu: Explicitly check for RDPMC of
 unsupported Intel PMC types
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>,
 Like Xu <likexu@tencent.com>
References: <20240109230250.424295-1-seanjc@google.com>
 <20240109230250.424295-12-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240109230250.424295-12-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/10/2024 7:02 AM, Sean Christopherson wrote:
> Explicitly check for attempts to read unsupported PMC types instead of
> letting the bounds check fail.  Functionally, letting the check fail is
> ok, but it's unnecessarily subtle and does a poor job of documenting the
> architectural behavior that KVM is emulating.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 21 +++++++++++++++------
>   1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index c37dd3aa056b..b41bdb0a0995 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -26,6 +26,7 @@
>    * further confuse things, non-architectural PMUs use bit 31 as a flag for
>    * "fast" reads, whereas the "type" is an explicit value.
>    */
> +#define INTEL_RDPMC_GP		0
>   #define INTEL_RDPMC_FIXED	INTEL_PMC_FIXED_RDPMC_BASE
>   
>   #define INTEL_RDPMC_TYPE_MASK	GENMASK(31, 16)
> @@ -89,21 +90,29 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
>   		return NULL;
>   
>   	/*
> -	 * Fixed PMCs are supported on all architectural PMUs.  Note, KVM only
> -	 * emulates fixed PMCs for PMU v2+, but the flag itself is still valid,
> -	 * i.e. let RDPMC fail due to accessing a non-existent counter.
> +	 * General Purpose (GP) PMCs are supported on all PMUs, and fixed PMCs
> +	 * are supported on all architectural PMUs, i.e. on all virtual PMUs
> +	 * supported by KVM.  Note, KVM only emulates fixed PMCs for PMU v2+,
> +	 * but the type itself is still valid, i.e. let RDPMC fail due to
> +	 * accessing a non-existent counter.  Reject attempts to read all other
> +	 * types, which are unknown/unsupported.
>   	 */
> -	idx &= ~INTEL_RDPMC_FIXED;
> -	if (type == INTEL_RDPMC_FIXED) {
> +	switch (type) {
> +	case INTEL_RDPMC_FIXED:
>   		counters = pmu->fixed_counters;
>   		num_counters = pmu->nr_arch_fixed_counters;
>   		bitmask = pmu->counter_bitmask[KVM_PMC_FIXED];
> -	} else {
> +		break;
> +	case INTEL_RDPMC_GP:
>   		counters = pmu->gp_counters;
>   		num_counters = pmu->nr_arch_gp_counters;
>   		bitmask = pmu->counter_bitmask[KVM_PMC_GP];
> +		break;
> +	default:
> +		return NULL;
>   	}
>   
> +	idx &= INTEL_RDPMC_INDEX_MASK;
>   	if (idx >= num_counters)
>   		return NULL;
>   
Reviewed-by: Dapeng Mi  <dapeng1.mi@linux.intel.com>

