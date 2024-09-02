Return-Path: <kvm+bounces-25657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04475968126
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 09:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24A4D1C2200C
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 07:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A032E17D378;
	Mon,  2 Sep 2024 07:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IfsTNY8u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F380182D2;
	Mon,  2 Sep 2024 07:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725263960; cv=none; b=IyicSIQWRTpJPN9thxEiOucbBgw9ra5AVb8pCHWhiD8neQHpdddSltjxcwGXhdBHYdmSqQYtJ8l/qffJmU9h1PlRHG+e+wjErddJXj/q6gZJjM6K6s2KZa+68kYtNsgMIvYJe4airw0bq/xTi7z2F7/aAu8PEtX6MsfTxx69ldA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725263960; c=relaxed/simple;
	bh=6Dk7gywO2Xx99j80xEtAcVsdd5Ll/b1XFetXma4XnVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CKOMvAHrnt99mWs4Fyq5bxnHMVxt9dCfvsU+iHldLdI+rd5XsgoyAdvJxQKYb+jfrHlQTzVfch9TyQMODTSCGTNMxyTasn5pX6UZfX/M6Usw237Kt9SnF7U1V67ox6SONxXjs2NtSFlLuzKsrBxhqMDxtCRvXImQHN80NpNClbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IfsTNY8u; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725263959; x=1756799959;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6Dk7gywO2Xx99j80xEtAcVsdd5Ll/b1XFetXma4XnVM=;
  b=IfsTNY8uO2c8AS+iP9wtaDKs3SGfxhoFbcwhHhGuQu3jfxagU85tGwhh
   ONQL/CPYoXdhPy5T4SI/pCqg3EsD8vk5FCmOAwfj0w249DKhHjURWwSM7
   t/YSyqgjNflVid2WWS7AQFLVcjaz6eZ6FQxlFV6Twk3lKdOvj/aML1Ft7
   sfzWYAlbmUv5BtTjeYwYqJNsg0778GXFE5kVEDhJ+dOBnzsFOEe+NHxDn
   YMY23BCd3sFGH9DYyNxcIDOLrEEJh933Ppcl565raPNoQYtyzhO78yw6d
   THoJQe6Vs/pBHNJUBbcrYUvkK0mSSw9vajBS8nGGnn+RuJyJvvrGNu8t8
   A==;
X-CSE-ConnectionGUID: F1zjWOBnT0SC8WxuDnayyw==
X-CSE-MsgGUID: 3qHqsm7hTiegIvBp/mG42A==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="24015282"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="24015282"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 00:59:18 -0700
X-CSE-ConnectionGUID: vP9/s6qvQ6GstJARSKghCQ==
X-CSE-MsgGUID: MRVTKgBhSw+jJvHam9/WaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="69161080"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.233.125]) ([10.124.233.125])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 00:59:12 -0700
Message-ID: <0c8d4bcf-5589-4371-b171-3ae90de15121@linux.intel.com>
Date: Mon, 2 Sep 2024 15:59:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 36/58] KVM: x86/pmu: Allow writing to fixed counter
 selector if counter is exposed
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-37-mizhang@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240801045907.4010984-37-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/1/2024 12:58 PM, Mingwei Zhang wrote:
> Allow writing to fixed counter selector if counter is exposed. If this
> fixed counter is filtered out, this counter won't be enabled on HW.
>
> Passthrough PMU implements the context switch at VM Enter/Exit boundary the
> guest value cannot be directly written to HW since the HW PMU is owned by
> the host. Introduce a new field fixed_ctr_ctrl_hw in kvm_pmu to cache the
> guest value.  which will be assigne to HW at PMU context restore.
>
> Since passthrough PMU intercept writes to fixed counter selector, there is
> no need to read the value at pmu context save, but still clear the fix
> counter ctrl MSR and counters when switching out to host PMU.
>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/vmx/pmu_intel.c    | 28 ++++++++++++++++++++++++----
>  2 files changed, 25 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e5c288d4264f..93c17da8271d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -549,6 +549,7 @@ struct kvm_pmu {
>  	unsigned nr_arch_fixed_counters;
>  	unsigned available_event_types;
>  	u64 fixed_ctr_ctrl;
> +	u64 fixed_ctr_ctrl_hw;
>  	u64 fixed_ctr_ctrl_mask;
>  	u64 global_ctrl;
>  	u64 global_status;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 0cd38c5632ee..c61936266cbd 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -34,6 +34,25 @@
>  
>  #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
>  
> +static void reprogram_fixed_counters_in_passthrough_pmu(struct kvm_pmu *pmu, u64 data)
> +{
> +	struct kvm_pmc *pmc;
> +	u64 new_data = 0;
> +	int i;
> +
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> +		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
> +		if (check_pmu_event_filter(pmc)) {
> +			pmc->current_config = fixed_ctrl_field(data, i);
> +			new_data |= (pmc->current_config << (i * 4));

Since we already have macro intel_fixed_bits_by_idx() to manipulate
fixed_cntr_ctrl, we 'd better to use it.

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3dbeb41b85ab..0aa58bffb99d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -44,7 +44,7 @@ static void
reprogram_fixed_counters_in_passthrough_pmu(struct kvm_pmu *pmu, u64
                pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
                if (check_pmu_event_filter(pmc)) {
                        pmc->current_config = fixed_ctrl_field(data, i);
-                       new_data |= (pmc->current_config << (i * 4));
+                       new_data |= intel_fixed_bits_by_idx(i,
pmc->current_config);
                } else {
                        pmc->counter = 0;
                }


> +		} else {
> +			pmc->counter = 0;
> +		}
> +	}
> +	pmu->fixed_ctr_ctrl_hw = new_data;
> +	pmu->fixed_ctr_ctrl = data;
> +}
> +
>  static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>  {
>  	struct kvm_pmc *pmc;
> @@ -351,7 +370,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (data & pmu->fixed_ctr_ctrl_mask)
>  			return 1;
>  
> -		if (pmu->fixed_ctr_ctrl != data)
> +		if (is_passthrough_pmu_enabled(vcpu))
> +			reprogram_fixed_counters_in_passthrough_pmu(pmu, data);
> +		else if (pmu->fixed_ctr_ctrl != data)
>  			reprogram_fixed_counters(pmu, data);
>  		break;
>  	case MSR_IA32_PEBS_ENABLE:
> @@ -820,13 +841,12 @@ static void intel_save_guest_pmu_context(struct kvm_vcpu *vcpu)
>  	if (pmu->global_status)
>  		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
>  
> -	rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
>  	/*
>  	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
>  	 * also avoid these guest fixed counters get accidentially enabled
>  	 * during host running when host enable global ctrl.
>  	 */
> -	if (pmu->fixed_ctr_ctrl)
> +	if (pmu->fixed_ctr_ctrl_hw)
>  		wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>  }
>  
> @@ -844,7 +864,7 @@ static void intel_restore_guest_pmu_context(struct kvm_vcpu *vcpu)
>  	if (pmu->global_status & toggle)
>  		wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status & toggle);
>  
> -	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> +	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl_hw);
>  }
>  
>  struct kvm_pmu_ops intel_pmu_ops __initdata = {

