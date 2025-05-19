Return-Path: <kvm+bounces-46954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 518C4ABB469
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 07:19:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3957D189253A
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 05:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E0E1F192B;
	Mon, 19 May 2025 05:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bFXAeTYl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FA1B663;
	Mon, 19 May 2025 05:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747631939; cv=none; b=RUq4CAVvci9chjiAxyDQP2vmtZrrZt70sKYkWiG11BTycncvNQ9QlLoVzwEvcV87GI+CKzTCE5ftxRz9prDpUQkJgXJSYkWMeI2mZFx2MfE0WQ0ORKb6tLm6Mn/DdoDEivoSY0iO2hN5B2OGeFziB1OVt/Ff1AvLBmj+JEa1Aco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747631939; c=relaxed/simple;
	bh=BwsPpgxI3FgcRcjvYTn3MOyVRJWaritZE2Q4xtr1Q6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EeldFcxiigyZ+wSZnOvTkSDFhveRVOcpUYq8yjAniSTD/r7oojXDOe47lRBiMlL8Oo9yuvlfJYBzh9SSnDve3p50HitH72SzV79VAeggJBjpf7br+BWTT99D6RSXPLwCmi4h0k9ZXcErn1mrSvXdvyti2VLfwF4KPXAXuSRdgfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bFXAeTYl; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747631937; x=1779167937;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BwsPpgxI3FgcRcjvYTn3MOyVRJWaritZE2Q4xtr1Q6c=;
  b=bFXAeTYllXrvwvltB0aAVqkhiTxhW9rVVgeLItmxxhCF4q+hg18NAAel
   YGC+cllv9cm86fQ1UfxNFIK5VvWNaiVahGSw+TSxjfYB6jIRbuaGQ4GxR
   0t7U4knnlgsmZLlvMCrhhP1eQM9fphWkdoWthAdAysJZO0ovyDa0GSwsR
   i3gQaonneoeg+uxT1Yp6YeWLr/9q1UGeAK3porW+VcLTrUHiB9FEMLeeO
   gYNeCGgTYAmIzrJSfessFkO3fzB0nfXFDyImbk8EiEQC5N7KN00sFIGFq
   c2P8bC/sGtnBCmrVYEvabvmKMZ9dudvLJBBvjkL9LvsPV/Iqrhq8Q6ACv
   g==;
X-CSE-ConnectionGUID: ydfstorNRHG6NV4h1EycQw==
X-CSE-MsgGUID: YDvlU2jFRpuWrVBhlTTrfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="52149361"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="52149361"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 22:18:56 -0700
X-CSE-ConnectionGUID: HtcsRV1dRvatjBZZNfKS7g==
X-CSE-MsgGUID: 5PxEb3+1QaaszqRPosL0Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139759423"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 22:18:48 -0700
Message-ID: <059f5886-e7df-4067-be38-8aca7750059a@linux.intel.com>
Date: Mon, 19 May 2025 13:18:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 23/38] KVM: x86/pmu: Configure the interception of PMU
 MSRs
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com,
 Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Yongwei Ma <yongwei.ma@intel.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>,
 Zide Chen <zide.chen@intel.com>, Eranian Stephane <eranian@google.com>,
 Shukla Manali <Manali.Shukla@amd.com>,
 Nikunj Dadhania <nikunj.dadhania@amd.com>
References: <20250324173121.1275209-1-mizhang@google.com>
 <20250324173121.1275209-24-mizhang@google.com> <aCc_AMOUiw69SiQr@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aCc_AMOUiw69SiQr@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/16/2025 9:34 PM, Sean Christopherson wrote:
> On Mon, Mar 24, 2025, Mingwei Zhang wrote:
>> +static void amd_pmu_update_msr_intercepts(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +	int msr_clear = !!(kvm_mediated_pmu_enabled(vcpu));
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
> This is pointless.  Simply do nothing and KVM will always intercept event selectors.

Yes.



