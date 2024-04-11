Return-Path: <kvm+bounces-14344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA1F8A210B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58FD51F234A2
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC763BBC2;
	Thu, 11 Apr 2024 21:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qjKweQFK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6F1205E15
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712871870; cv=none; b=Ko4188lEdbrshcahfYmoeQ0x/4qmnFJMf8kbD6Rl1aYgsnmwuxL3xah1qOWAUcPMPPaUblKg5eK+e7M5bU+kw1XnR/D6YWnYJj8cXZkyLvLhcC0XFZfgGCULp7f1W8lgFIg4vPUQXKeDiLoZXm5iq1mTRrAAvenWPA5pp1IAHp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712871870; c=relaxed/simple;
	bh=YVpKfdoQDQiSnmdlw+IYx/A52nBEvf8d7yMnWLvVQgU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pts7TDwOYq4S7NnOGQBN3SwcXZ9ZV0pU72kVQj+7Efh/Yv/1iB1ytgB7YA3swlmc3b6vp3mV//cJdufJ6mr5CqoZ81TFT/a8JBktPdzJBipkLPOuJUPfkh6N71a8qoIGV9t/JOUqMKOwj/lVajGUVf59QC8A7pCge1Bkq/KcZME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qjKweQFK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e211c27bdeso2762085ad.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712871868; x=1713476668; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EuGdop3yTqRLN7ifNY9EpYHLJpBPWVklj7vsl1p/r30=;
        b=qjKweQFKUrF6gAZAQBlJoM7efycbDVnlecEDl0Ijti3CFksZqhlbzFPWjK/tOxJOrS
         JCmbYalcNVQg6ExRdku8vcGmCQnGVUtTZKvo1ugRl9bicrfWWYxxB1LsbZkCJcpwHYj+
         7dDDkCO4ev+ZCaJfrCZg9QGKpheYbk7s0bsV0EZPKJI1rttH13K1fzPbHBr3oTmMLt66
         IkwM7jeW9RvHbssytCLwUptY8pjPlQ5py7oYvKwJSmbcU14ooNvKslO8yIOesK3AGFRf
         BeKUjsHXMuv+tA4WE/ver8JNuKEJYeoPVGaBsiI/ashRUUmYPCmXrEstPJwJruPGmdqd
         oZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712871868; x=1713476668;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EuGdop3yTqRLN7ifNY9EpYHLJpBPWVklj7vsl1p/r30=;
        b=lZrbVYqMl32cXgXSzfBxRh5Cf3wZkx6bxCqbIbgkIk6c2Zr6fpVD+0WEfe4VF/L/+A
         W53rsDOQ7xHi1zbRUXSgwdDsF4tRZnEEuR+wfUvIa//V44xmWXyuJaEaFfMf0+Nbu+Rj
         89sGFACZphWQOg/qE7LeUXpr5IorXIgV9+Y0apMK32lxcrsq+/FOmtv2rPMmBL5KnNSQ
         sjJX2rcnZOdu4JAMj82abYvmBhEettCXbs5TjvYXZxfjNXpmGxe7XNYX6KvJBl55uxXp
         nTmGmQZFOj1pDb+fbXxVHggadJyKIwd+7KzFm5Z6yI6rUwyZfgA8dwcDBe1vaR3Ir6Go
         r3Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXtkXdFFxc/WTkYI9LbcaOFzb0TfYU2APKFCNIeOHgavfiNbxjGQCUSG3747C5AkfQIISEMQ+fKLg37JzEdN7zKusX1
X-Gm-Message-State: AOJu0YwGDUs29PzMb+0lHuyL9q4BX0eoi+kJhhaRprvr9Prr9FMUKvFR
	2qNI80Z3ob9tR6XlKRB/vkIP+UV5/pbQLpSHfBmuHfivjY77z6dByqUklG6BRgcyjcKjQ0zvCu5
	LlQ==
X-Google-Smtp-Source: AGHT+IF5whDuHMFxrAcSEfb13bVXG1WK0cQWdVo6WBDc/2PFDOw//LVqK7jwShMlKPYYsVuAL00g1h8e1Kc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:234b:b0:1e2:ba13:ab90 with SMTP id
 c11-20020a170903234b00b001e2ba13ab90mr2185plh.1.1712871868196; Thu, 11 Apr
 2024 14:44:28 -0700 (PDT)
Date: Thu, 11 Apr 2024 14:44:26 -0700
In-Reply-To: <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhhZush_VOEnimuw@google.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
> 
> Implement the save/restore of PMU state for pasthrough PMU in Intel. In
> passthrough mode, KVM owns exclusively the PMU HW when control flow goes to
> the scope of passthrough PMU. Thus, KVM needs to save the host PMU state
> and gains the full HW PMU ownership. On the contrary, host regains the
> ownership of PMU HW from KVM when control flow leaves the scope of
> passthrough PMU.
> 
> Implement PMU context switches for Intel CPUs and opptunistically use
> rdpmcl() instead of rdmsrl() when reading counters since the former has
> lower latency in Intel CPUs.
> 
> Co-developed-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 73 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 73 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 0d58fe7d243e..f79bebe7093d 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -823,10 +823,83 @@ void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
>  
>  static void intel_save_pmu_context(struct kvm_vcpu *vcpu)

I would prefer there be a "guest" in there somewhere, e.g. intel_save_guest_pmu_context().

>  {
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc;
> +	u32 i;
> +
> +	if (pmu->version != 2) {
> +		pr_warn("only PerfMon v2 is supported for passthrough PMU");
> +		return;
> +	}
> +
> +	/* Global ctrl register is already saved at VM-exit. */
> +	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
> +	/* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. */
> +	if (pmu->global_status)
> +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
> +
> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> +		pmc = &pmu->gp_counters[i];
> +		rdpmcl(i, pmc->counter);
> +		rdmsrl(i + MSR_ARCH_PERFMON_EVENTSEL0, pmc->eventsel);
> +		/*
> +		 * Clear hardware PERFMON_EVENTSELx and its counter to avoid
> +		 * leakage and also avoid this guest GP counter get accidentally
> +		 * enabled during host running when host enable global ctrl.
> +		 */
> +		if (pmc->eventsel)
> +			wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
> +		if (pmc->counter)
> +			wrmsrl(MSR_IA32_PMC0 + i, 0);

This doesn't make much sense.  The kernel already has full access to the guest,
I don't see what is gained by zeroing out the MSRs just to hide them from perf.

Similarly, if perf enables a counter if PERF_GLOBAL_CTRL without first restoring
the event selector, we gots problems.

Same thing for the fixed counters below.  Can't this just be?

	for (i = 0; i < pmu->nr_arch_gp_counters; i++)
		rdpmcl(i, pmu->gp_counters[i].counter);

	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
		rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i,
		       pmu->fixed_counters[i].counter);

> +	}
> +
> +	rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> +	/*
> +	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
> +	 * also avoid these guest fixed counters get accidentially enabled
> +	 * during host running when host enable global ctrl.
> +	 */
> +	if (pmu->fixed_ctr_ctrl)
> +		wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> +		pmc = &pmu->fixed_counters[i];
> +		rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i, pmc->counter);
> +		if (pmc->counter)
> +			wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
> +	}
>  }
>  
>  static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc;
> +	u64 global_status;
> +	int i;
> +
> +	if (pmu->version != 2) {
> +		pr_warn("only PerfMon v2 is supported for passthrough PMU");
> +		return;
> +	}
> +
> +	/* Clear host global_ctrl and global_status MSR if non-zero. */
> +	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);

Why?  PERF_GLOBAL_CTRL will be auto-loaded at VM-Enter, why do it now?

> +	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
> +	if (global_status)
> +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status);

This seems especially silly, isn't the full MSR being written below?  Or am I
misunderstanding how these things work?

> +	wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status);
> +
> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> +		pmc = &pmu->gp_counters[i];
> +		wrmsrl(MSR_IA32_PMC0 + i, pmc->counter);
> +		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, pmc->eventsel);
> +	}
> +
> +	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> +		pmc = &pmu->fixed_counters[i];
> +		wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, pmc->counter);
> +	}
>  }
>  
>  struct kvm_pmu_ops intel_pmu_ops __initdata = {
> -- 
> 2.34.1
> 

