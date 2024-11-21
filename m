Return-Path: <kvm+bounces-32236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C909D463B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 04:25:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9FE84B2205C
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 03:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8DF1A7262;
	Thu, 21 Nov 2024 03:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m4jTp4Ci"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9626070802;
	Thu, 21 Nov 2024 03:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732159505; cv=none; b=W/UJrb21aNr1LVJRAhnSRPOqndauENp28ApMDpLmrgo6RF2ruUhL8hNpE5vEBAmV76jBRMu1ECgjGKcRjR6dYbYCwjrLVO70OtQLyZ9iItQRitbeAMFrqxroH/+H475ZOhKOSPBzab5F5oL8aFnUs44tjU3L2B7noXEEJdTgk4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732159505; c=relaxed/simple;
	bh=4ojwB9/pY+WU8nV6qONi1pBtAdLF727/EM1SuM28/F0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DWcQkHfR32/ezpMBUpigKjGmtdL/otROvhoWS4K+JZdBJ/ABiKTsqjnpdQ8bUXs3b0eiz4eR3LcKQOEX+4uW3PXhPokC92oTEtltRreDpuWTgHvdLkWPMXifKSUF+eqGgYGc7WPdLvrvMq6cioqU5HKr4xGTyZfV64bhxlVjAro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m4jTp4Ci; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732159504; x=1763695504;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4ojwB9/pY+WU8nV6qONi1pBtAdLF727/EM1SuM28/F0=;
  b=m4jTp4CiEQVLyVskJ+roeND+VDKM5ZaXCmDvKHje14r2z1JDdCNasjTA
   hpuLqiTf1z/8TYazQaBvtON6wS+qk2Q86dZVlzQFECdEY1R+WEdlFmY1C
   eD3aZgmyCC8lF1MjqjIk8fnUpyWL1oEThPDHhNrsbLGDYnEgxTjk9lZor
   J1CT1mmwRBKK1NP7niohtW51kDL559HxSN3TYNQUmBZ4oX6NwCsMM66ge
   91BfAabGHGZwQ2xd8m/d+zlXPaK1XyKY0X3nuiNwqYxhBNldsTqLUMvXP
   9wfcOr4ucx+g+iu3ZPGpvbXqDbyP+o/mMVemXLP3TqaeUh6y4vsyN3dw7
   w==;
X-CSE-ConnectionGUID: YuakE+m0T7mDNnZxEWKMkw==
X-CSE-MsgGUID: /F8QrZDcQ6yEh+M837d9ZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="42759341"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="42759341"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 19:25:03 -0800
X-CSE-ConnectionGUID: KKr9iwA0SiemQXoOJsMnqw==
X-CSE-MsgGUID: zSInqAUfRqCX81ga2CQYmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="90517877"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 19:24:58 -0800
Message-ID: <0a761b20-dc5e-4bba-a72b-07627befc835@linux.intel.com>
Date: Thu, 21 Nov 2024 11:24:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 52/58] KVM: x86/pmu/svm: Implement callback to
 disable MSR interception
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang
 <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-53-mizhang@google.com> <Zz5OTDwQk9XsSVKb@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz5OTDwQk9XsSVKb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2024 5:02 AM, Sean Christopherson wrote:
> +Aaron
>
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> +static void amd_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +	int msr_clear = !!(is_passthrough_pmu_enabled(vcpu));
>> +	int i;
>> +
>> +	for (i = 0; i < min(pmu->nr_arch_gp_counters, AMD64_NUM_COUNTERS); i++) {
>> +		/*
>> +		 * Legacy counters are always available irrespective of any
>> +		 * CPUID feature bits and when X86_FEATURE_PERFCTR_CORE is set,
>> +		 * PERF_LEGACY_CTLx and PERF_LEGACY_CTRx registers are mirrored
>> +		 * with PERF_CTLx and PERF_CTRx respectively.
>> +		 */
>> +		set_msr_interception(vcpu, svm->msrpm, MSR_K7_EVNTSEL0 + i, 0, 0);
>> +		set_msr_interception(vcpu, svm->msrpm, MSR_K7_PERFCTR0 + i, msr_clear, msr_clear);
>> +	}
>> +
>> +	for (i = 0; i < kvm_pmu_cap.num_counters_gp; i++) {
>> +		/*
>> +		 * PERF_CTLx registers require interception in order to clear
>> +		 * HostOnly bit and set GuestOnly bit. This is to prevent the
>> +		 * PERF_CTRx registers from counting before VM entry and after
>> +		 * VM exit.
>> +		 */
>> +		set_msr_interception(vcpu, svm->msrpm, MSR_F15H_PERF_CTL + 2 * i, 0, 0);
>> +
>> +		/*
>> +		 * Pass through counters exposed to the guest and intercept
>> +		 * counters that are unexposed. Do this explicitly since this
>> +		 * function may be set multiple times before vcpu runs.
>> +		 */
>> +		if (i >= pmu->nr_arch_gp_counters)
>> +			msr_clear = 0;
> Similar to my comments on the Intel side, explicitly enable interception for
> MSRs that don't exist in the guest model in a separate for-loop, i.e. don't
> toggle msr_clear in the middle of a loop.

Sure.


>
> I would also love to de-dup the bulk of this code, which is very doable since
> the base+shift for the MSRs is going to be stashed in kvm_pmu.  All that's needed
> on top is unified MSR interception logic, which is something that's been on my
> wish list for some time.  SVM's inverted polarity needs to die a horrible death.
>
> Lucky for me, Aaron is picking up that torch.
>
> Aaron, what's your ETA on the MSR unification?  No rush, but if you think it'll
> be ready in the next month or so, I'll plan on merging that first and landing
> this code on top.

Is there a public link for Aaron's patches? If so, we can rebase the next
version patches on top of Aaron's patches.


>
>> +		set_msr_interception(vcpu, svm->msrpm, MSR_F15H_PERF_CTR + 2 * i, msr_clear, msr_clear);
>> +	}
>> +
>> +	/*
>> +	 * In mediated passthrough vPMU, intercept global PMU MSRs when guest
>> +	 * PMU only owns a subset of counters provided in HW or its version is
>> +	 * less than 2.
>> +	 */
>> +	if (is_passthrough_pmu_enabled(vcpu) && pmu->version > 1 &&
> kvm_pmu_has_perf_global_ctrl(), no?

Yes.


>
>> +	    pmu->nr_arch_gp_counters == kvm_pmu_cap.num_counters_gp)
>> +		msr_clear = 1;
>> +	else
>> +		msr_clear = 0;
>> +
>> +	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_CTL, msr_clear, msr_clear);
>> +	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, msr_clear, msr_clear);
>> +	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, msr_clear, msr_clear);
>> +	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, msr_clear, msr_clear);
>> +}
>> +
>>  struct kvm_pmu_ops amd_pmu_ops __initdata = {
>>  	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
>>  	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
>> @@ -258,6 +312,7 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
>>  	.refresh = amd_pmu_refresh,
>>  	.init = amd_pmu_init,
>>  	.is_rdpmc_passthru_allowed = amd_is_rdpmc_passthru_allowed,
>> +	.passthrough_pmu_msrs = amd_passthrough_pmu_msrs,
>>  	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
>>  	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
>>  	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
>> -- 
>> 2.46.0.rc1.232.g9752f9e123-goog
>>

