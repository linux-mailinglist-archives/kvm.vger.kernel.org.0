Return-Path: <kvm+bounces-54085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77BEEB1C13D
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 09:23:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79A743AB8C2
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 07:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0466821B9F1;
	Wed,  6 Aug 2025 07:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UFWia2fm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE3720468E;
	Wed,  6 Aug 2025 07:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754465021; cv=none; b=jYAXqBWAv6gTHFPoqlCLyZ+w+LnBhZulWmK/Zz5QhFDWBCvf1yzgbEtFVKJw53CWTpz/n24W2BBQOZMjop6/1qJgHSphwoGTtQJaDS7CYud6paAeEe2+bppiDZ86rUHS74WT66OyuRFcE4z5vdrPK9ASRKbN+savGBFh9uy3T8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754465021; c=relaxed/simple;
	bh=G0Wr5xHCgCkQb4iGS1fDfJr2i2DoSme9cI3fiU/HLtk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mcNOuR0ZUG6RGC4I1AnxFUj9x4ZPQmlIqZ6CGvs5FpgFNiBqZyzXwS0UTVQG3LmmunSvxVOCat+Rf5n5yfgBN4IAeU0e5pY71Lj5bx8xzkXSfcY4B9tYDZIN5f6D1Qna2WllxoZa9RxSejGBg1RBypvswi31RRYvJoUgH5HDW+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UFWia2fm; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754465020; x=1786001020;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G0Wr5xHCgCkQb4iGS1fDfJr2i2DoSme9cI3fiU/HLtk=;
  b=UFWia2fmYUo0UsZqd9j//0ppdlXcUoIWyUF979ehyJ9cmvSKCiRMCUZb
   /2lKwnfZpTBAqZjOdDGuMhZ+AKhNjbbC9gRQtHUYcNUFXU3UKyQlGgKVy
   AhGDtUlE4SC3Jt7bUPJzPmNvCASLhgDo149Jo7JN8mBgMLBaeT/ZEzEdt
   WUI7wKqFn7BAssngUDJaPTN5xncl2Dkei+D98dohW2SOSs/KvpOdt+yEX
   qTNVUicRxqt2hLCEcjs+k5NU3h7Q7N1cGSg3q6XyUhOHvZKagdHLHR2S5
   5VkAsx/55YIKzwwoioGqu6uMgk0g9hc8lpXUfjae5MRjC0KC/gTN6VZWM
   A==;
X-CSE-ConnectionGUID: c9QCYqCgTAadqEfG3YkvIw==
X-CSE-MsgGUID: tCkyWME8Qxafj0ZiTZO3VQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="56909884"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56909884"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:23:39 -0700
X-CSE-ConnectionGUID: RLQ49wA0SfKwawdCWOWOtw==
X-CSE-MsgGUID: 3maTRtTmQpGQgUfrUk6eZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="195666869"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:23:37 -0700
Message-ID: <2fa1e68d-afbf-4aa4-99cb-b2001eb314de@linux.intel.com>
Date: Wed, 6 Aug 2025 15:23:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/18] KVM: x86/pmu: Move kvm_init_pmu_capability() to
 pmu.c
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li
 <xin@zytor.com>, Sandipan Das <sandipan.das@amd.com>
References: <20250805190526.1453366-1-seanjc@google.com>
 <20250805190526.1453366-10-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250805190526.1453366-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/6/2025 3:05 AM, Sean Christopherson wrote:
> Move kvm_init_pmu_capability() to pmu.c so that future changes can access
> variables that have no business being visible outside of pmu.c.
> kvm_init_pmu_capability() is called once per module load, there's is zero
> reason it needs to be inlined.
>
> No functional change intended.
>
> Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Cc: Sandipan Das <sandipan.das@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/pmu.h | 47 +---------------------------------------------
>  2 files changed, 48 insertions(+), 46 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 75e9cfc689f8..eb17d90916ea 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -96,6 +96,53 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
>  #undef __KVM_X86_PMU_OP
>  }
>  
> +void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
> +{
> +	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
> +	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
> +
> +	/*
> +	 * Hybrid PMUs don't play nice with virtualization without careful
> +	 * configuration by userspace, and KVM's APIs for reporting supported
> +	 * vPMU features do not account for hybrid PMUs.  Disable vPMU support
> +	 * for hybrid PMUs until KVM gains a way to let userspace opt-in.
> +	 */
> +	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
> +		enable_pmu = false;
> +
> +	if (enable_pmu) {
> +		perf_get_x86_pmu_capability(&kvm_pmu_cap);
> +
> +		/*
> +		 * WARN if perf did NOT disable hardware PMU if the number of
> +		 * architecturally required GP counters aren't present, i.e. if
> +		 * there are a non-zero number of counters, but fewer than what
> +		 * is architecturally required.
> +		 */
> +		if (!kvm_pmu_cap.num_counters_gp ||
> +		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ctrs))
> +			enable_pmu = false;
> +		else if (is_intel && !kvm_pmu_cap.version)
> +			enable_pmu = false;
> +	}
> +
> +	if (!enable_pmu) {
> +		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
> +		return;
> +	}
> +
> +	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
> +	kvm_pmu_cap.num_counters_gp = min(kvm_pmu_cap.num_counters_gp,
> +					  pmu_ops->MAX_NR_GP_COUNTERS);
> +	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
> +					     KVM_MAX_NR_FIXED_COUNTERS);
> +
> +	kvm_pmu_eventsel.INSTRUCTIONS_RETIRED =
> +		perf_get_hw_event_config(PERF_COUNT_HW_INSTRUCTIONS);
> +	kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED =
> +		perf_get_hw_event_config(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
> +}
> +
>  static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>  {
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index ad89d0bd6005..13477066eb40 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -180,52 +180,7 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
>  extern struct x86_pmu_capability kvm_pmu_cap;
>  extern struct kvm_pmu_emulated_event_selectors kvm_pmu_eventsel;
>  
> -static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
> -{
> -	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
> -	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
> -
> -	/*
> -	 * Hybrid PMUs don't play nice with virtualization without careful
> -	 * configuration by userspace, and KVM's APIs for reporting supported
> -	 * vPMU features do not account for hybrid PMUs.  Disable vPMU support
> -	 * for hybrid PMUs until KVM gains a way to let userspace opt-in.
> -	 */
> -	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
> -		enable_pmu = false;
> -
> -	if (enable_pmu) {
> -		perf_get_x86_pmu_capability(&kvm_pmu_cap);
> -
> -		/*
> -		 * WARN if perf did NOT disable hardware PMU if the number of
> -		 * architecturally required GP counters aren't present, i.e. if
> -		 * there are a non-zero number of counters, but fewer than what
> -		 * is architecturally required.
> -		 */
> -		if (!kvm_pmu_cap.num_counters_gp ||
> -		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ctrs))
> -			enable_pmu = false;
> -		else if (is_intel && !kvm_pmu_cap.version)
> -			enable_pmu = false;
> -	}
> -
> -	if (!enable_pmu) {
> -		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
> -		return;
> -	}
> -
> -	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
> -	kvm_pmu_cap.num_counters_gp = min(kvm_pmu_cap.num_counters_gp,
> -					  pmu_ops->MAX_NR_GP_COUNTERS);
> -	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
> -					     KVM_MAX_NR_FIXED_COUNTERS);
> -
> -	kvm_pmu_eventsel.INSTRUCTIONS_RETIRED =
> -		perf_get_hw_event_config(PERF_COUNT_HW_INSTRUCTIONS);
> -	kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED =
> -		perf_get_hw_event_config(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
> -}
> +void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops);
>  
>  static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
>  {

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>




