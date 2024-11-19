Return-Path: <kvm+bounces-32090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3D79D2DE9
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 19:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 36FCAB351DD
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 18:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C0FB1D271C;
	Tue, 19 Nov 2024 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ysl38w15"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226781D0174
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 18:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732040662; cv=none; b=nQwAuMXPWNFWgf28sS1eUfTGvrRpvQye9wsnt73+H46+QcxafK5H0iXVztozzMEkT8klwdiPTuc7UMxIzwa019oRGJxJkU7UGFFBHOJ2adgPWM+magiN/d5lY+xfDkw32d4r12pO5z3Ru1/8OsmHrf3lOMtJ/uLSKVPG6uAD1rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732040662; c=relaxed/simple;
	bh=2w2r5mX58G/SkIa8ZUR/jP1ySgvHIbm+VbG8tiRb4Qs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fkk7LyxSu79Rrmwg7hcNqnrsrzdGLRt9bVRfuTK3Fn21SWlkydD1xg/1MDFeGL1byu2oIst+zU5GPstR7vcu4Qoo5/RAF4NyTYDBPAPw6F6dkiGM6v8T+6r3f2m3zusLbg4Bq/Nfrjd7S5L4IcPwFmHXZdDgevxYDRziN8xqMiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ysl38w15; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6eeb9152b2cso8651717b3.1
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 10:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732040660; x=1732645460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2czk0g24fqh6fFWu59+40RUcjXlxOd2UBqJsJwV4SVg=;
        b=Ysl38w15GQHixQrXKcuF4UkcrhyfzJxfqvs/BLw2SO6ZpvobF6wdctXOX4bvZY1Dj9
         XDJozY0FC/JwQ/fjCr1DPyhz/coGS2d9vpHHyyXM2Q8mlb2cVnMWlS7M7uN87Z5ZF22E
         QB9l3tA9OpboqKeq4ItXnF3Xry7wmugtg+8GKC9JyjYBb2llDvYINFis8faZebuv0YxL
         VOkLJXtMXq3N8pOqVcO2rjBB5D9Jskfuyfzxxh6CSMuljimYVZAdWwSQ18gzsFqL38Mn
         TPe1rUci4o04feDAUJzYqV/0JeNV4GN71HxqVZEoCg5gTWcWJYhbEFYeGYc+Y00Wtmyr
         WO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732040660; x=1732645460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2czk0g24fqh6fFWu59+40RUcjXlxOd2UBqJsJwV4SVg=;
        b=WQ6lITFtXBSkmq48o5kTaKNEiHoY7BeMnuNRgE5hNW8U9ne4CYYmicBWoyA1vmFMBK
         cDGOL5iXbNr2wOPG8tKl+lspwDwMyvBj4KKD12AwYfhJKZ0GQNs6Q4XfRcOojMvw0CY/
         lcSdz9W3bzf3w+jQ/WenFdtcKza1rgpEThq1Vjootwee5o0HxIkBr0J26uNp+CftjJN6
         mgLVQy/0giQGkxgzquXyt1MS/a/lVV2jQUtUPchzg5BylOHKxg9mgMvTxaio/M0T9dNu
         7xyFSnxF/eMBn88KD/MjWb6XTHvHIewujum2c0rEeG01wqY2ET1s6lrSVQ2YtdobZ1FP
         Fdaw==
X-Forwarded-Encrypted: i=1; AJvYcCX6MI8aawmavf2+oH+fy5lxXhGJCnrKvl0AvbkxSoUfiZ34E1sa0FLC1lO24LDOkKhicQY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWCzMJCFHbt7a6NK4O/6BVec1cxUdIXcQ4OcAi9wGcHkepok99
	2JMGqG6E6WlCu3OWPDQ3w1OeC9oh7yYPzDEzMpniZYl//boWWHylavhUAhwcp5O4PZFAGde6X4k
	NSw==
X-Google-Smtp-Source: AGHT+IEXjFdtIZQjMzEZj5GVW2GxK32GN4holf/tRhKSvsOMczUYTZAngrjleLyHus8zXo0KfAuJPOR/waA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d19:b0:6dd:fda3:6568 with SMTP id
 00721157ae682-6ee55c8eca3mr4986707b3.3.1732040660209; Tue, 19 Nov 2024
 10:24:20 -0800 (PST)
Date: Tue, 19 Nov 2024 10:24:18 -0800
In-Reply-To: <20240801045907.4010984-29-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-29-mizhang@google.com>
Message-ID: <ZzzX0g0LtF_qHggI@google.com>
Subject: Re: [RFC PATCH v3 28/58] KVM: x86/pmu: Add intel_passthrough_pmu_msrs()
 to pass-through PMU MSRs
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 02c9019c6f85..737de5bf1eee 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -740,6 +740,52 @@ static bool intel_is_rdpmc_passthru_allowed(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +/*
> + * Setup PMU MSR interception for both mediated passthrough vPMU and legacy
> + * emulated vPMU. Note that this function is called after each time userspace
> + * set CPUID.
> + */
> +static void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)

Function verb is misleading.  This doesn't always "passthrough" MSRs, it's also
responsible for enabling interception as needed.  intel_pmu_update_msr_intercepts()?

> +{
> +	bool msr_intercept = !is_passthrough_pmu_enabled(vcpu);
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	int i;
> +
> +	/*
> +	 * Unexposed PMU MSRs are intercepted by default. However,
> +	 * KVM_SET_CPUID{,2} may be invoked multiple times. To ensure MSR
> +	 * interception is correct after each call of setting CPUID, explicitly
> +	 * touch msr bitmap for each PMU MSR.
> +	 */
> +	for (i = 0; i < kvm_pmu_cap.num_counters_gp; i++) {
> +		if (i >= pmu->nr_arch_gp_counters)
> +			msr_intercept = true;

Hmm, I like the idea and that y'all remembered to intercept unsupported MSRs, but
it's way, way too easy to clobber msr_intercept and fail to re-initialize across
for-loops.

Rather than update the variable mid-loop, how about this?

	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i, MSR_TYPE_RW, intercept);
		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW,
					  intercept || !fw_writes_is_enabled(vcpu));
	}
	for ( ; i < kvm_pmu_cap.num_counters_gp; i++) {
		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i, MSR_TYPE_RW, true);
		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, true);
	}

	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i, MSR_TYPE_RW, intercept);
	for ( ; i < kvm_pmu_cap.num_counters_fixed; i++)
		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i, MSR_TYPE_RW, true);


> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i, MSR_TYPE_RW, msr_intercept);
> +		if (fw_writes_is_enabled(vcpu))
> +			vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, msr_intercept);
> +		else
> +			vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, true);
> +	}
> +
> +	msr_intercept = !is_passthrough_pmu_enabled(vcpu);
> +	for (i = 0; i < kvm_pmu_cap.num_counters_fixed; i++) {
> +		if (i >= pmu->nr_arch_fixed_counters)
> +			msr_intercept = true;
> +		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i, MSR_TYPE_RW, msr_intercept);
> +	}
> +
> +	if (pmu->version > 1 && is_passthrough_pmu_enabled(vcpu) &&

Don't open code kvm_pmu_has_perf_global_ctrl().

> +	    pmu->nr_arch_gp_counters == kvm_pmu_cap.num_counters_gp &&
> +	    pmu->nr_arch_fixed_counters == kvm_pmu_cap.num_counters_fixed)
> +		msr_intercept = false;
> +	else
> +		msr_intercept = true;

This reinforces that checking PERF_CAPABILITIES for PERF_METRICS is likely doomed
to fail, because doesn't PERF_GLOBAL_CTRL need to be intercepted, strictly speaking,
to prevent setting EN_PERF_METRICS?

> +	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_STATUS, MSR_TYPE_RW, msr_intercept);
> +	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL, MSR_TYPE_RW, msr_intercept);
> +	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, MSR_TYPE_RW, msr_intercept);
> +}
> +
>  struct kvm_pmu_ops intel_pmu_ops __initdata = {
>  	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
>  	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
> @@ -752,6 +798,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
>  	.deliver_pmi = intel_pmu_deliver_pmi,
>  	.cleanup = intel_pmu_cleanup,
>  	.is_rdpmc_passthru_allowed = intel_is_rdpmc_passthru_allowed,
> +	.passthrough_pmu_msrs = intel_passthrough_pmu_msrs,
>  	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
>  	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
>  	.MIN_NR_GP_COUNTERS = 1,
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 

