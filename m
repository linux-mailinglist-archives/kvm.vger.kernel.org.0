Return-Path: <kvm+bounces-18370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62FF08D44D3
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 07:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB94B1F2319F
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 05:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E98143C4F;
	Thu, 30 May 2024 05:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UA9WY8zD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4C915B7
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 05:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717047255; cv=none; b=D9xYlsdLWidqyZC8LucBluePaT+1P6mWfBH9T8eX/qeA5putK4EDH5ozxdTD9L9zem84YvrAwns8Nti4Xjz75tAaH34vY6cXj8SiffDHewP9l/FM7ixx7+PacRXUqBbp1Z25Fk5nWoC4+LxNUUgTLHR5lLCMZCDCd0zm4Xl/i20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717047255; c=relaxed/simple;
	bh=CNrwBoaBeYZ5XLah8SlDSM3dwLdplqGdOv6NcFsIYOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQKNSeUhzOCTUfh3MQQ0b0+GxaoQChY/SZaNBajPVH4kMy/azcnstL4sSioLnPfB2vgtUy+qxE6iiBkyS9GdcjymhRqglk3hT3+9c8YKWmsuIcx0eliC46XAU25SDUJv5aevDNArSn8rtaDxb+bpjtxW4bLaJk3/mTqquEwpPIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UA9WY8zD; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2c1b45206abso28495a91.1
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 22:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717047254; x=1717652054; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J5Yrh4Rdyvlx4+qbJeLZG3YmLcReTNOhbkhBTpFxmQM=;
        b=UA9WY8zDLHCBsjMUOrwkKsPAQiyu76oFP0cClOy4odBLWTiXAWx4lC0Fbau3CkH690
         66IEWAbOB7HCOkKYfGyQX055HJpAy+RbMq3v3NIRZxofWzL86gCZLK/PRMQv957ZjHwe
         mUvwYQ296smwTAnB7avmhE5gFn07pnjWgmyQOf99a2gDEmQ109dAUsf/4NMu3ZQ9sCEO
         KlfNO2a8DgNZkIUiIz8BAPfzxk0ZIYRvy7fg50oZ4pg0N29ek3V6bYAy7Xf4ryj7aZEc
         e90NaF6tiPjXCR80cmTJ32oBzrJJZ7ea6s2d2LnxbRzniUycdY4Fpca2njl6RXZ3Q391
         9aGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717047254; x=1717652054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5Yrh4Rdyvlx4+qbJeLZG3YmLcReTNOhbkhBTpFxmQM=;
        b=QRbz2qZsdYCJfgTBHShfkTrk6yHWp25QZcQJtguybL29dx/46UJUjg77BIVn6dqKHZ
         aR590XSGFTmzgPXymoaJ9bNEWKYdJLhUBiQ4i6NTJ+SKpkG7zab3QMpsNW9fEY6pn3DP
         uxI89YLzw/ZuHT//w9soeB7AHuY1lb080w+pGDLRSSNRyF/fIeQ18oAsTlkUBL8YDRiT
         yVHjq7/zjHOqBeEPpzdgzr4qElPMmRs36eDJXpzGEwLOBgZPGgt+ZFdEXl9GrgM767sk
         1QQRnpN2ON48fmofDb0ZPaWzTohlQpa5ScJRdaKt0xuCsl2oZRarlXuILxDYwGfsOhnw
         Ivng==
X-Forwarded-Encrypted: i=1; AJvYcCV8bcLVfxSoE9wYlLjE+KIS+LVRn824oyG3J88Va5Mqfzyattao2tX2opsT7dGuE/gsAmmtACQfiI6437+CT47m9uJ3
X-Gm-Message-State: AOJu0YwkXvQA2x+HKAdPxWtTQzyBo/c1d20SFaGn+hX2RQ59r+REZ5I7
	YsFvK4KO9PgIEKHWLvyE0Xhb4JPBDtg14TUSQWohq7Y5OEX+ud3kI/TpeMD1bA==
X-Google-Smtp-Source: AGHT+IH2+lgK8rTATdkh6jHextrAtS1tICLH2veC6oRLyU3riJPz4HmzuCqc87lpmKa1UvJ1uZnH7A==
X-Received: by 2002:a17:90b:713:b0:2bd:ad66:5b14 with SMTP id 98e67ed59e1d1-2c1ab9fac1bmr1167590a91.25.1717047253304;
        Wed, 29 May 2024 22:34:13 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1ad4e53cdsm418163a91.26.2024.05.29.22.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 22:34:12 -0700 (PDT)
Date: Thu, 30 May 2024 05:34:09 +0000
From: Mingwei Zhang <mizhang@google.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Kan Liang <kan.liang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	gce-passthrou-pmu-dev@google.com,
	Samantha Alt <samantha.alt@intel.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
	maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 30/54] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
Message-ID: <ZlgP0eav8UgT4mZN@google.com>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-31-mizhang@google.com>
 <719d8331-331b-46b2-a2ff-fe5ff7fa4b5e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <719d8331-331b-46b2-a2ff-fe5ff7fa4b5e@linux.intel.com>

On Tue, May 14, 2024, Mi, Dapeng wrote:
> 
> On 5/6/2024 1:29 PM, Mingwei Zhang wrote:
> > Implement the save/restore of PMU state for pasthrough PMU in Intel. In
> > passthrough mode, KVM owns exclusively the PMU HW when control flow goes to
> > the scope of passthrough PMU. Thus, KVM needs to save the host PMU state
> > and gains the full HW PMU ownership. On the contrary, host regains the
> > ownership of PMU HW from KVM when control flow leaves the scope of
> > passthrough PMU.
> >
> > Implement PMU context switches for Intel CPUs and opptunistically use
> > rdpmcl() instead of rdmsrl() when reading counters since the former has
> > lower latency in Intel CPUs.
> 
> It looks rdpmcl() optimization is removed from this patch, right? The
> description is not identical with code.

That is correct. I was debugging this for a while and since we don't
have rdpmcl_safe(), one of the bug cause rdpmc() to crash the kernel.
Really don't like rdpmc(). But will add it back in next version.

> 
> 
> >
> > Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> 
> The commit tags doesn't follow the rules in Linux document, we need to
> change it in next version.

Will do.
> 
> https://docs.kernel.org/process/submitting-patches.html#:~:text=Co%2Ddeveloped%2Dby%3A%20states,work%20on%20a%20single%20patch.
> 
> > ---
> >  arch/x86/kvm/pmu.c           | 46 ++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/pmu_intel.c | 41 +++++++++++++++++++++++++++++++-
> >  2 files changed, 86 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 782b564bdf96..13197472e31d 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -1068,14 +1068,60 @@ void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
> >  
> >  void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu)
> >  {
> > +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > +	struct kvm_pmc *pmc;
> > +	u32 i;
> > +
> >  	lockdep_assert_irqs_disabled();
> >  
> >  	static_call_cond(kvm_x86_pmu_save_pmu_context)(vcpu);
> > +
> > +	/*
> > +	 * Clear hardware selector MSR content and its counter to avoid
> > +	 * leakage and also avoid this guest GP counter get accidentally
> > +	 * enabled during host running when host enable global ctrl.
> > +	 */
> > +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> > +		pmc = &pmu->gp_counters[i];
> > +		rdmsrl(pmc->msr_counter, pmc->counter);
> 
> I understood we want to use common code to manipulate PMU MSRs as much as
> possible, but I don't think we should sacrifice performance. rdpmcl() has
> better performance than rdmsrl(). If AMD CPUs doesn't support rdpmc
> instruction, I think we should move this into vendor specific
> xxx_save/restore_pmu_context helpers().
> 
> 
> > +		rdmsrl(pmc->msr_eventsel, pmc->eventsel);
> > +		if (pmc->counter)
> > +			wrmsrl(pmc->msr_counter, 0);
> > +		if (pmc->eventsel)
> > +			wrmsrl(pmc->msr_eventsel, 0);
> > +	}
> > +
> > +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> > +		pmc = &pmu->fixed_counters[i];
> > +		rdmsrl(pmc->msr_counter, pmc->counter);
> > +		if (pmc->counter)
> > +			wrmsrl(pmc->msr_counter, 0);
> > +	}
> >  }
> >  
> >  void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
> >  {
> > +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > +	struct kvm_pmc *pmc;
> > +	int i;
> > +
> >  	lockdep_assert_irqs_disabled();
> >  
> >  	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);
> > +
> > +	/*
> > +	 * No need to zero out unexposed GP/fixed counters/selectors since RDPMC
> > +	 * in this case will be intercepted. Accessing to these counters and
> > +	 * selectors will cause #GP in the guest.
> > +	 */
> > +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> > +		pmc = &pmu->gp_counters[i];
> > +		wrmsrl(pmc->msr_counter, pmc->counter);
> > +		wrmsrl(pmc->msr_eventsel, pmu->gp_counters[i].eventsel);
> > +	}
> > +
> > +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> > +		pmc = &pmu->fixed_counters[i];
> > +		wrmsrl(pmc->msr_counter, pmc->counter);
> > +	}
> >  }
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > index 7852ba25a240..a23cf9ca224e 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -572,7 +572,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
> >  	}
> >  
> >  	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> > -		pmu->fixed_counters[i].msr_eventsel = MSR_CORE_PERF_FIXED_CTR_CTRL;
> > +		pmu->fixed_counters[i].msr_eventsel = 0;
> Why to initialize msr_eventsel to 0 instead of the real MSR address here?
> >  		pmu->fixed_counters[i].msr_counter = MSR_CORE_PERF_FIXED_CTR0 + i;
> >  	}
> >  }
> > @@ -799,6 +799,43 @@ static void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
> >  	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, MSR_TYPE_RW, msr_intercept);
> >  }
> >  
> > +static void intel_save_guest_pmu_context(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > +
> > +	/* Global ctrl register is already saved at VM-exit. */
> > +	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
> > +	/* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. */
> > +	if (pmu->global_status)
> > +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
> > +
> > +	rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> > +	/*
> > +	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
> > +	 * also avoid these guest fixed counters get accidentially enabled
> > +	 * during host running when host enable global ctrl.
> > +	 */
> > +	if (pmu->fixed_ctr_ctrl)
> > +		wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> > +}
> > +
> > +static void intel_restore_guest_pmu_context(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > +	u64 global_status, toggle;
> > +
> > +	/* Clear host global_ctrl MSR if non-zero. */
> > +	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> > +	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
> > +	toggle = pmu->global_status ^ global_status;
> > +	if (global_status & toggle)
> > +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status & toggle);
> > +	if (pmu->global_status & toggle)
> > +		wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status & toggle);
> > +
> > +	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> > +}
> > +
> >  struct kvm_pmu_ops intel_pmu_ops __initdata = {
> >  	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
> >  	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
> > @@ -812,6 +849,8 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
> >  	.cleanup = intel_pmu_cleanup,
> >  	.is_rdpmc_passthru_allowed = intel_is_rdpmc_passthru_allowed,
> >  	.passthrough_pmu_msrs = intel_passthrough_pmu_msrs,
> > +	.save_pmu_context = intel_save_guest_pmu_context,
> > +	.restore_pmu_context = intel_restore_guest_pmu_context,
> >  	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
> >  	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
> >  	.MIN_NR_GP_COUNTERS = 1,
> 

