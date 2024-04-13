Return-Path: <kvm+bounces-14593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B6EC8A3AAC
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 05:34:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1F911F243D6
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 03:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DD21B285;
	Sat, 13 Apr 2024 03:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1OCInzXG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E692217C74
	for <kvm@vger.kernel.org>; Sat, 13 Apr 2024 03:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712979283; cv=none; b=rUiwHqLWImpiaiUEUQMk3mG/wh/UZbLE4eRddDUtBmUF2O6WIs8Ay5WE44FgggFULRo09ZeRaCLawudZgKLR2uDEZFQWXNvR1vDaYNMGCk5Kr8SWtsLcP/X494lrhU/RQ3eA1FEIflBwJBi+gMx2lde22YX6DYgXumi45pIT32g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712979283; c=relaxed/simple;
	bh=7eGENuSDxEjyodnjKyrrxKl6zyrrHJ0GzynZc3jtLAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j6+R6RWjdWMQqgJ7N5B2Sc6ebYGlpmAONIjB3VSLEplDnDEobdYtzqMTRJ9GHN6Wi6cxtz0Ia0LqRe8mA1MDKoscvt/t3HHmB+fEWb9Mi4lVg3wAA5ieDzIgu6RoZluwacbqIWSNs/zsC3ut28jPlhk4eiKOY5Kdc8XAYYibj5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1OCInzXG; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-22f078f1aecso851126fac.3
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 20:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712979281; x=1713584081; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=viI1MnAmZsDqn6fKevL+eQQg5xqLk1GQ2xu5VwVTbWA=;
        b=1OCInzXG4op7ggcG3pnH03RIYfQHmtGGCLRPwgQ4F2tD322pXAs0XzHEpZHb3QxUiK
         SIT8JSjTusxEDGQMXxs0YemhtikfwG+BXm7w2NlZDZ4RHUja7sAKRvX49HOwgK1U5H4b
         q831adEMlwzEoE38jJOEkQr7CCdNLPmGL5QwuGiK3FNhHYh7zKgClSKl28LPS6S2LTVr
         cT3/OnbcodqR7ifFHF3ued8+vPDvsJ1Uvd8cdTqjqYVw58zlt+/vOe2Uic6TCz/6+vkw
         CjVy/AvsFv0XMHhqLDDdkIQMhNRXMvkVmEhInuaygvQI31fn0v9tzK8v0LSOtuuAYby3
         raZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712979281; x=1713584081;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=viI1MnAmZsDqn6fKevL+eQQg5xqLk1GQ2xu5VwVTbWA=;
        b=uS8JC5J1dmtyLA9i6cmetoEGUTyIKs8RxUmQXHWkNMvI7jqXX05MYrLHRF6n7FKDfm
         zPDsTcixNJ+2/SckPQ5JVzLphDu/DBMdbRpQkz0gF53iq3nt6QcUPxgpj/tT5RncTtEs
         UE7Ga8JYUAkXLTedZvCXRRqa2YzX0yKBHDfS0KPbkROCP432PBz42edsTuIEBUZuG1bm
         dFQVqMPekT6HM8UOdDo2s7nOt1q7Tx+SbWEBztfzw23vaHoDKnqFYTw9TT4NjP3w+I6/
         z4qLQgnJKotnzd+Ft7ZFZcXL3LDpWc6zaWd/46vWdXfkVAQh0a2vzmoM/1pjhdKP+wRg
         3ljA==
X-Forwarded-Encrypted: i=1; AJvYcCWH0ln6rZ73+AEnF82vab05PnJDF4GFRz2HWWncAUnQNG5j8uabcJZyXajVjS4HHS6Q397J5UsVOlZAdn8E4gFuBjbZ
X-Gm-Message-State: AOJu0YwGJpz2/JyZV1z/CZGs1LQ0vxZ4FPbwYIJ2Jo6h3REdZYWtpPoz
	ipy3yyjsnb5j/Y9YT5S7wgSUYGgUcEdI/B3g800Hxh2i/zTQIQ4JtSZD0K/6+w==
X-Google-Smtp-Source: AGHT+IEKBFATWHaWL+/RyGJWKMJx/oF0L4HJ4WRLh0wRus+xao8r2d5G1RNwEOQDpK+xtnel8dM+7Q==
X-Received: by 2002:a05:6871:5888:b0:233:6e02:57ee with SMTP id ok8-20020a056871588800b002336e0257eemr5319265oac.42.1712979280710;
        Fri, 12 Apr 2024 20:34:40 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id q14-20020a62ae0e000000b006ecde91bb6esm3537524pff.183.2024.04.12.20.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 20:34:40 -0700 (PDT)
Date: Sat, 13 Apr 2024 03:34:36 +0000
From: Mingwei Zhang <mizhang@google.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
	peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
	jmattson@google.com, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com,
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of
 PMU state for Intel CPU
Message-ID: <Zhn9TGOiXxcV5Epx@google.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
 <ZhhZush_VOEnimuw@google.com>
 <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>

On Sat, Apr 13, 2024, Mi, Dapeng wrote:
> 
> On 4/12/2024 5:44 AM, Sean Christopherson wrote:
> > On Fri, Jan 26, 2024, Xiong Zhang wrote:
> > > From: Dapeng Mi <dapeng1.mi@linux.intel.com>
> > > 
> > > Implement the save/restore of PMU state for pasthrough PMU in Intel. In
> > > passthrough mode, KVM owns exclusively the PMU HW when control flow goes to
> > > the scope of passthrough PMU. Thus, KVM needs to save the host PMU state
> > > and gains the full HW PMU ownership. On the contrary, host regains the
> > > ownership of PMU HW from KVM when control flow leaves the scope of
> > > passthrough PMU.
> > > 
> > > Implement PMU context switches for Intel CPUs and opptunistically use
> > > rdpmcl() instead of rdmsrl() when reading counters since the former has
> > > lower latency in Intel CPUs.
> > > 
> > > Co-developed-by: Mingwei Zhang <mizhang@google.com>
> > > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > > Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> > > ---
> > >   arch/x86/kvm/vmx/pmu_intel.c | 73 ++++++++++++++++++++++++++++++++++++
> > >   1 file changed, 73 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > > index 0d58fe7d243e..f79bebe7093d 100644
> > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > @@ -823,10 +823,83 @@ void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
> > >   static void intel_save_pmu_context(struct kvm_vcpu *vcpu)
> > I would prefer there be a "guest" in there somewhere, e.g. intel_save_guest_pmu_context().
> Yeah. It looks clearer.
> > 
> > >   {
> > > +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > > +	struct kvm_pmc *pmc;
> > > +	u32 i;
> > > +
> > > +	if (pmu->version != 2) {
> > > +		pr_warn("only PerfMon v2 is supported for passthrough PMU");
> > > +		return;
> > > +	}
> > > +
> > > +	/* Global ctrl register is already saved at VM-exit. */
> > > +	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
> > > +	/* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. */
> > > +	if (pmu->global_status)
> > > +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
> > > +
> > > +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> > > +		pmc = &pmu->gp_counters[i];
> > > +		rdpmcl(i, pmc->counter);
> > > +		rdmsrl(i + MSR_ARCH_PERFMON_EVENTSEL0, pmc->eventsel);
> > > +		/*
> > > +		 * Clear hardware PERFMON_EVENTSELx and its counter to avoid
> > > +		 * leakage and also avoid this guest GP counter get accidentally
> > > +		 * enabled during host running when host enable global ctrl.
> > > +		 */
> > > +		if (pmc->eventsel)
> > > +			wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
> > > +		if (pmc->counter)
> > > +			wrmsrl(MSR_IA32_PMC0 + i, 0);
> > This doesn't make much sense.  The kernel already has full access to the guest,
> > I don't see what is gained by zeroing out the MSRs just to hide them from perf.
> 
> It's necessary to clear the EVENTSELx MSRs for both GP and fixed counters.
> Considering this case, Guest uses GP counter 2, but Host doesn't use it. So
> if the EVENTSEL2 MSR is not cleared here, the GP counter 2 would be enabled
> unexpectedly on host later since Host perf always enable all validate bits
> in PERF_GLOBAL_CTRL MSR. That would cause issues.
> 
> Yeah,  the clearing for PMCx MSR should be unnecessary .
> 

Why is clearing for PMCx MSR unnecessary? Do we want to leaking counter
values to the host? NO. Not in cloud usage.

Please make changes to this patch with **extreme** caution.

According to our past experience, if there is a bug somewhere,
there is a catch here (normally).

Thanks.
-Mingwei
> 
> > 
> > Similarly, if perf enables a counter if PERF_GLOBAL_CTRL without first restoring
> > the event selector, we gots problems.
> > 
> > Same thing for the fixed counters below.  Can't this just be?
> > 
> > 	for (i = 0; i < pmu->nr_arch_gp_counters; i++)
> > 		rdpmcl(i, pmu->gp_counters[i].counter);
> > 
> > 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
> > 		rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i,
> > 		       pmu->fixed_counters[i].counter);
> > 
> > > +	}
> > > +
> > > +	rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> > > +	/*
> > > +	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
> > > +	 * also avoid these guest fixed counters get accidentially enabled
> > > +	 * during host running when host enable global ctrl.
> > > +	 */
> > > +	if (pmu->fixed_ctr_ctrl)
> > > +		wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> > > +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> > > +		pmc = &pmu->fixed_counters[i];
> > > +		rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i, pmc->counter);
> > > +		if (pmc->counter)
> > > +			wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
> > > +	}
> > >   }
> > >   static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
> > >   {
> > > +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > > +	struct kvm_pmc *pmc;
> > > +	u64 global_status;
> > > +	int i;
> > > +
> > > +	if (pmu->version != 2) {
> > > +		pr_warn("only PerfMon v2 is supported for passthrough PMU");
> > > +		return;
> > > +	}
> > > +
> > > +	/* Clear host global_ctrl and global_status MSR if non-zero. */
> > > +	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> > Why?  PERF_GLOBAL_CTRL will be auto-loaded at VM-Enter, why do it now?
> 
> As previous comments say, host perf always enable all counters in
> PERF_GLOBAL_CTRL by default. The reason to clear PERF_GLOBAL_CTRL here is to
> ensure all counters in disabled state and the later counter manipulation
> (writing MSR) won't cause any race condition or unexpected behavior on HW.
> 
> 
> > 
> > > +	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
> > > +	if (global_status)
> > > +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status);
> > This seems especially silly, isn't the full MSR being written below?  Or am I
> > misunderstanding how these things work?
> 
> I think Jim's comment has already explain why we need to do this.
> 
> > 
> > > +	wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status);
> > > +
> > > +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> > > +		pmc = &pmu->gp_counters[i];
> > > +		wrmsrl(MSR_IA32_PMC0 + i, pmc->counter);
> > > +		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, pmc->eventsel);
> > > +	}
> > > +
> > > +	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> > > +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> > > +		pmc = &pmu->fixed_counters[i];
> > > +		wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, pmc->counter);
> > > +	}
> > >   }
> > >   struct kvm_pmu_ops intel_pmu_ops __initdata = {
> > > -- 
> > > 2.34.1
> > > 

