Return-Path: <kvm+bounces-19285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A10F4902E0A
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 03:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5060C1F22CB6
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 01:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F277AD4C;
	Tue, 11 Jun 2024 01:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fw5u6aKf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DCDEDF;
	Tue, 11 Jun 2024 01:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718070350; cv=none; b=D2Lf7ZoIAhodGlO7Ogbg1N/X2i634r1jcTREQaV76EG3B/F8Iw548Uw/hzd6pF6nKyLvVA9OBJu85fTD6a1ncaa6NEAOL/19yQOD07cs0rKsq3OtdEGFMu9Nf4cObi+MkY3ko52Awl/pOWftRMQGLnMORJjDuCjOF5HKnkt7rn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718070350; c=relaxed/simple;
	bh=Rt1ouXIhwMJ1m4R+0fkOGUiXqAnmFxrVnekcV4kzSic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YtZlWnyIf6HfzidSMIU84yI2TkozgvWFDsAx+cOQnw8YU5iJr8YNzQchoA0YWoEJCEA9bFWT+dkaXKBFw80qkE9yBkKwYCh8eLi7GLuSWTtnrIyc0bO8OpYQi7uofwT/ffrisSqXzElEhLqt0b0uZ7uccVBe0ppoVozpLE7mV8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fw5u6aKf; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718070349; x=1749606349;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Rt1ouXIhwMJ1m4R+0fkOGUiXqAnmFxrVnekcV4kzSic=;
  b=fw5u6aKfws35Ha6YagemycgDrotzxtP0M/BVEVxIsnuO4nhhXni/ZK4P
   46lqrUBy01zTf7N+M4/qoKWdWn12It0DHlsOLRbJ13pSe+7+a7/1bEyLy
   cBBCLymZqS2FZZiC7/9OfGWP5dLA5Z4FsooD2AKStaesLFBJZxqNIrtAr
   UfI6YxxGMvF0jQVucQiLXKbFD3gPJPNJf0EWN9+k6hlwrNrcQ79gmtvA8
   2ku/2C0IaiYwE7z4D5l7K+OgZ2tWI10vkt1ZqiV4jjYFbQNIg+/HRca27
   RHKqa1vwhty7DuP2ZcGwckScKvUTOv//pUf6sCFcA6H44zP66kb+uxuGA
   w==;
X-CSE-ConnectionGUID: OcIKM/j4Tv+b6xFCd3MMrQ==
X-CSE-MsgGUID: anDxSpH9RtiiCDgrsZrJAw==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="25333946"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="25333946"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 18:45:48 -0700
X-CSE-ConnectionGUID: 5P26nJYeSCS1oWvCtWsn+A==
X-CSE-MsgGUID: CBle/kBxRFyglXbu/R/q2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="44202807"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 18:45:48 -0700
Message-ID: <e41fd2bc-26f0-4811-927b-3e94d13d5dac@linux.intel.com>
Date: Tue, 11 Jun 2024 09:45:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/pmu: Add a helper to enable bits in
 FIXED_CTR_CTRL
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240608000819.3296176-1-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240608000819.3296176-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/8/2024 8:08 AM, Sean Christopherson wrote:
> Add a helper, intel_pmu_enable_fixed_counter_bits(), to dedup code that
> enables fixed counter bits, i.e. when KVM clears bits in the reserved mask
> used to detect invalid MSR_CORE_PERF_FIXED_CTR_CTRL values.
>
> No functional change intended.
>
> Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index e01c87981927..fb5cbd6cbeff 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -448,6 +448,14 @@ static __always_inline u64 intel_get_fixed_pmc_eventsel(unsigned int index)
>  	return eventsel;
>  }
>  
> +static void intel_pmu_enable_fixed_counter_bits(struct kvm_pmu *pmu, u64 bits)
> +{
> +	int i;
> +
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
> +		pmu->fixed_ctr_ctrl_rsvd &= ~intel_fixed_bits_by_idx(i, bits);
> +}
> +
>  static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -457,7 +465,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	union cpuid10_edx edx;
>  	u64 perf_capabilities;
>  	u64 counter_rsvd;
> -	int i;
>  
>  	memset(&lbr_desc->records, 0, sizeof(lbr_desc->records));
>  
> @@ -501,12 +508,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  			((u64)1 << edx.split.bit_width_fixed) - 1;
>  	}
>  
> -	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
> -		pmu->fixed_ctr_ctrl_rsvd &=
> -			 ~intel_fixed_bits_by_idx(i,
> -						  INTEL_FIXED_0_KERNEL |
> -						  INTEL_FIXED_0_USER |
> -						  INTEL_FIXED_0_ENABLE_PMI);
> +	intel_pmu_enable_fixed_counter_bits(pmu, INTEL_FIXED_0_KERNEL |
> +						 INTEL_FIXED_0_USER |
> +						 INTEL_FIXED_0_ENABLE_PMI);
>  
>  	counter_rsvd = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
>  		(((1ull << pmu->nr_arch_fixed_counters) - 1) << KVM_FIXED_PMC_BASE_IDX));
> @@ -551,10 +555,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  		if (perf_capabilities & PERF_CAP_PEBS_BASELINE) {
>  			pmu->pebs_enable_rsvd = counter_rsvd;
>  			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
> -			for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
> -				pmu->fixed_ctr_ctrl_rsvd &=
> -					~intel_fixed_bits_by_idx(i, ICL_FIXED_0_ADAPTIVE);
>  			pmu->pebs_data_cfg_rsvd = ~0xff00000full;
> +			intel_pmu_enable_fixed_counter_bits(pmu, ICL_FIXED_0_ADAPTIVE);
>  		} else {
>  			pmu->pebs_enable_rsvd =
>  				~((1ull << pmu->nr_arch_gp_counters) - 1);
>
> base-commit: b9adc10edd4e14e66db4f7289a88fdbfa45ae7a8

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


