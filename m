Return-Path: <kvm+bounces-32217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9244B9D4359
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 22:02:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0DD9BB21D20
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 21:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 750991A0B08;
	Wed, 20 Nov 2024 21:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hVshA+0Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BA5487A7
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 21:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732136528; cv=none; b=W+0Sq/iaJK/LiGFf+ckPekRCeESuHzJpiQO9gpcSon8l3Qp5G7fznTkgHhH+DOVCK9Mlf75CUhhVdaBguk4kgX2gaV/Wd7Em9qsq6l/gTC+iiD8qDsb1OJTlAGsJ9kRAmaEUedUW1ui650ZpZ5gx+695slGca2aazgivvn+C6dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732136528; c=relaxed/simple;
	bh=FlsxOQNWR596SWQ5Njf9D12NQ5cQ0HO2pTtLq+Q7ixg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nsitaq3MWJbhZL211X+/cGeImDyFX4pqNZEd9QImczSq2tsJF3DhlU6kc0By4QOsGN7apNFadIzUj6gFSIrOzUFlritMKjqN8tdhVtX5Jc+pvBwQuiYCbBOzaCQkV3lyr0igJHV/Q/CsgkI7RH1DAgth0t3iGpX3psJFYxNkGP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hVshA+0Y; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ee813065afso2064677b3.0
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 13:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732136526; x=1732741326; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eAKU4IN3B3jQqXUroRvil7KjFJ4vtIBC4Rcrezpy92o=;
        b=hVshA+0Ypk3hWyFTpRUIdtqRDNqIv4dl6BSsUTOqZ6IwggPo/rd/FN/Dwr1u8HkAgm
         /OkVYNVPW7n+aHPwbp3TbLL6Bsu/VTC0NX+YyFuveg+f4OKFwF9k+PCYaZFDY2C550xn
         yPB2PhX95//A25TSXBbSMu2Bf8xgQ0JB9C5JJXel59OnHCnnqRAOGIivJ5MYRuGu3rpp
         +PgFppbigR00bV/1nCTJ7DDgxNdmzyE+U1ESO3YUzAZ2VUxJrrQP3MCGDBKz4CHfZyX2
         c9Pbn81JHw+Kupfx3sJz3qzrVc5dONE1s4NCftb9tyw6ucnCsfGxYvY+MbF0E8EVcaSi
         eRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732136526; x=1732741326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eAKU4IN3B3jQqXUroRvil7KjFJ4vtIBC4Rcrezpy92o=;
        b=OPXUV5p6Rv6jQPIDGrFH/+wmjS0FeMX/oisA6bg7bWUHtVX5GHLIHIkMrQXzpGKgmn
         Vbkn1cDX7mwsFwSADiLBa7amOiETGyIc2zAP7BVO/w+jRMuiHo+NB0/PWrsjkSq0fz0Z
         YGx6ODl4vX+kwSjelGuPhCvqRe7aa+qOraPxyH+58o7AkdsPFHAl7785RdtdjXithhqu
         LOw68fLSwIN3pBOoNX+J1uZxdBTfXuJtMjT6Fe764d/C+z4GUOtaIBmUGyKuXqJaZ+Rr
         ikSL4mt/0Ql+TDKJSgAIFDcfx3h8q4fZpislW4Q6hLD6P2aHsp1yRa6GviiB7f2FNTbL
         JDeg==
X-Forwarded-Encrypted: i=1; AJvYcCWqy/ivsIyXBkBodo5Xzyp31McUzZk7uErUr+7eMW7eawVl2AIJDeQiKttqMJRMw/rA3ow=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVWVurze315KK/vjwftwScEIyRurmdrKCQZApJpYW9a3MDTFfG
	D/9X1+gK15Zs/WqZ8Og6Ya/TsektiNMKrr3mRCrBcKDQWw3p0IFlvgI2200zG/YCpNOoaE3URKf
	3ig==
X-Google-Smtp-Source: AGHT+IHSrUpjyIwM/Pq7Hpjjig/hsITufJ/5+sJm7SjRlEyZeZ6+e5r+Xt1WxjyX2NJEyvCprivhfky+mW4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:ec9:b0:6a9:3d52:79e9 with SMTP id
 00721157ae682-6eebd298ff5mr990257b3.4.1732136526174; Wed, 20 Nov 2024
 13:02:06 -0800 (PST)
Date: Wed, 20 Nov 2024 13:02:04 -0800
In-Reply-To: <20240801045907.4010984-53-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-53-mizhang@google.com>
Message-ID: <Zz5OTDwQk9XsSVKb@google.com>
Subject: Re: [RFC PATCH v3 52/58] KVM: x86/pmu/svm: Implement callback to
 disable MSR interception
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
	linux-perf-users@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="us-ascii"

+Aaron

On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> +static void amd_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	int msr_clear = !!(is_passthrough_pmu_enabled(vcpu));
> +	int i;
> +
> +	for (i = 0; i < min(pmu->nr_arch_gp_counters, AMD64_NUM_COUNTERS); i++) {
> +		/*
> +		 * Legacy counters are always available irrespective of any
> +		 * CPUID feature bits and when X86_FEATURE_PERFCTR_CORE is set,
> +		 * PERF_LEGACY_CTLx and PERF_LEGACY_CTRx registers are mirrored
> +		 * with PERF_CTLx and PERF_CTRx respectively.
> +		 */
> +		set_msr_interception(vcpu, svm->msrpm, MSR_K7_EVNTSEL0 + i, 0, 0);
> +		set_msr_interception(vcpu, svm->msrpm, MSR_K7_PERFCTR0 + i, msr_clear, msr_clear);
> +	}
> +
> +	for (i = 0; i < kvm_pmu_cap.num_counters_gp; i++) {
> +		/*
> +		 * PERF_CTLx registers require interception in order to clear
> +		 * HostOnly bit and set GuestOnly bit. This is to prevent the
> +		 * PERF_CTRx registers from counting before VM entry and after
> +		 * VM exit.
> +		 */
> +		set_msr_interception(vcpu, svm->msrpm, MSR_F15H_PERF_CTL + 2 * i, 0, 0);
> +
> +		/*
> +		 * Pass through counters exposed to the guest and intercept
> +		 * counters that are unexposed. Do this explicitly since this
> +		 * function may be set multiple times before vcpu runs.
> +		 */
> +		if (i >= pmu->nr_arch_gp_counters)
> +			msr_clear = 0;

Similar to my comments on the Intel side, explicitly enable interception for
MSRs that don't exist in the guest model in a separate for-loop, i.e. don't
toggle msr_clear in the middle of a loop.

I would also love to de-dup the bulk of this code, which is very doable since
the base+shift for the MSRs is going to be stashed in kvm_pmu.  All that's needed
on top is unified MSR interception logic, which is something that's been on my
wish list for some time.  SVM's inverted polarity needs to die a horrible death.

Lucky for me, Aaron is picking up that torch.

Aaron, what's your ETA on the MSR unification?  No rush, but if you think it'll
be ready in the next month or so, I'll plan on merging that first and landing
this code on top.

> +		set_msr_interception(vcpu, svm->msrpm, MSR_F15H_PERF_CTR + 2 * i, msr_clear, msr_clear);
> +	}
> +
> +	/*
> +	 * In mediated passthrough vPMU, intercept global PMU MSRs when guest
> +	 * PMU only owns a subset of counters provided in HW or its version is
> +	 * less than 2.
> +	 */
> +	if (is_passthrough_pmu_enabled(vcpu) && pmu->version > 1 &&

kvm_pmu_has_perf_global_ctrl(), no?

> +	    pmu->nr_arch_gp_counters == kvm_pmu_cap.num_counters_gp)
> +		msr_clear = 1;
> +	else
> +		msr_clear = 0;
> +
> +	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_CTL, msr_clear, msr_clear);
> +	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, msr_clear, msr_clear);
> +	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, msr_clear, msr_clear);
> +	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, msr_clear, msr_clear);
> +}
> +
>  struct kvm_pmu_ops amd_pmu_ops __initdata = {
>  	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
>  	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
> @@ -258,6 +312,7 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
>  	.refresh = amd_pmu_refresh,
>  	.init = amd_pmu_init,
>  	.is_rdpmc_passthru_allowed = amd_is_rdpmc_passthru_allowed,
> +	.passthrough_pmu_msrs = amd_passthrough_pmu_msrs,
>  	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
>  	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
>  	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 

