Return-Path: <kvm+bounces-16642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F348BC6E9
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE0661C21109
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F71142E61;
	Mon,  6 May 2024 05:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rzVyWjOT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED0A142E67
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973486; cv=none; b=TP8FdTKsX9vnJlYZLcKHSqPBTGjHUuoPviciciyJIG3DCuhVD9AdnCcUSGs6Ipu6gp+JXQ8AOePa6apTfvUIDVQL1gRt4vCCG0qlQBV4q2U6m5RBklHBYDfTNMpRfLAzUZN9OTtF/FjCZgyar34wRDeenEVrKQ6A+FS9I3EirKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973486; c=relaxed/simple;
	bh=5YMfqv72qzaTfQfdtWNBLWJA7fSId5Bkt5xYFt59U/M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pk4qSycJP+GY8NfyMgVe5LMlEyuNcu7VTghAPgIB2gxG0ZJ16ilsiTyopJKnIU/sGNppxIZSLXQMCRed4VC8Fw9P0I4C2jD/JUltA7krW/xoHEzabbclmDDIQgY1dhiT3CEikiOZ6UUjXzLNOiXEpq59r1C7QluD0g+u+tO0w14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rzVyWjOT; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61bef0accddso44174377b3.0
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973483; x=1715578283; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Mc6dM/KRfbmzV7TiTWsp1WlioSM+lDrPoDXG/suaLDY=;
        b=rzVyWjOTtro7RAUxwsQ26gBkNo1jq33brSVkURyrpxIZNf7QQ2nsPs2H2OHrGTV6K2
         3Cf/hkLqRn9Tml93gEralvx6cZ2YYUTBMHE9xm6+98PqrnSOoGUBGVDgS9dRaG6Syatn
         ASaBPL+8pbdPI86Qqm0UFsAaEJ0q2fuhOhXV7tMbQAuvsltPeBMFHpxeEumdyLkGEQIC
         6WQGvLpgIft7mm21UA55zxryOAcc9D7ns/wW3RdR70x1LbvGrtONtxbnxPAaQ10qfgnV
         JCc5nkdKkdsNxjlT7UVTf5VuT7R/R1/YtL7rN7906WyZHnDCeW6n3RKU0NLLUK4eYWOx
         MK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973483; x=1715578283;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mc6dM/KRfbmzV7TiTWsp1WlioSM+lDrPoDXG/suaLDY=;
        b=cfEfIlRQzh6UkyM587Ff8haF8uG5Mixq2HD2oFU2Y5/7FZa3Yf8B5rKsJXbPDZedLG
         81TC/qLOsv+wSFw/57D6MhL57sNVETMsGk+NqFfbZMTgsb4qaZ9I1kwa3lhHQn4fwM/c
         kfH57l9gbit+3ys3u1NzooZBv1s8OGXg+tMnbEpGRLrk6iC8zZTzDuP4zZTH+oGdKFU2
         IinVfgQCCDqQ8p9E/Y5bA4gPZ2SZg2fu949kd1Wn2Log74b9JfD9snmiekSH9MQWNqim
         2NqKQRY6KTBlTDqDnCLgD6adHtMkm92W6yzWYFMvRtF5+GW52x+iOdE0G/XFz0wJbtpj
         Mcyg==
X-Forwarded-Encrypted: i=1; AJvYcCXoikK0ZqwcwdL99YFyFK3FGj/i5r6x2xPAi9E5++t/VM7sg3M9m2UAEGDov6sTNk/4sdF8KjcD7n3FRyOD6MAIyY2+
X-Gm-Message-State: AOJu0Yw1ajnqLOICzfAz/kRzebN63DooxDTXD3icJXg/W+dlKR0VUEuh
	zAtvjVCVFaHmc+9ljI5/IME6ftp2xPAT/HY+DtR/xJr2OjVynbu4lsw3WZIELgu7B7DBwQYLzvc
	vZQaOzg==
X-Google-Smtp-Source: AGHT+IETs0YA0w+4VQPrUxj7xsKiJp3CI+FRid4V2keXO9/T3f23XXMGMHTBpoC6GHKNwCC/gb/ArMkK1hYQ
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a0d:e284:0:b0:61b:e2eb:f05 with SMTP id
 l126-20020a0de284000000b0061be2eb0f05mr2630035ywe.2.1714973483652; Sun, 05
 May 2024 22:31:23 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:55 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-31-mizhang@google.com>
Subject: [PATCH v2 30/54] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Implement the save/restore of PMU state for pasthrough PMU in Intel. In
passthrough mode, KVM owns exclusively the PMU HW when control flow goes to
the scope of passthrough PMU. Thus, KVM needs to save the host PMU state
and gains the full HW PMU ownership. On the contrary, host regains the
ownership of PMU HW from KVM when control flow leaves the scope of
passthrough PMU.

Implement PMU context switches for Intel CPUs and opptunistically use
rdpmcl() instead of rdmsrl() when reading counters since the former has
lower latency in Intel CPUs.

Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.c           | 46 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c | 41 +++++++++++++++++++++++++++++++-
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 782b564bdf96..13197472e31d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1068,14 +1068,60 @@ void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
 
 void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	u32 i;
+
 	lockdep_assert_irqs_disabled();
 
 	static_call_cond(kvm_x86_pmu_save_pmu_context)(vcpu);
+
+	/*
+	 * Clear hardware selector MSR content and its counter to avoid
+	 * leakage and also avoid this guest GP counter get accidentally
+	 * enabled during host running when host enable global ctrl.
+	 */
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		pmc = &pmu->gp_counters[i];
+		rdmsrl(pmc->msr_counter, pmc->counter);
+		rdmsrl(pmc->msr_eventsel, pmc->eventsel);
+		if (pmc->counter)
+			wrmsrl(pmc->msr_counter, 0);
+		if (pmc->eventsel)
+			wrmsrl(pmc->msr_eventsel, 0);
+	}
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmc = &pmu->fixed_counters[i];
+		rdmsrl(pmc->msr_counter, pmc->counter);
+		if (pmc->counter)
+			wrmsrl(pmc->msr_counter, 0);
+	}
 }
 
 void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	int i;
+
 	lockdep_assert_irqs_disabled();
 
 	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);
+
+	/*
+	 * No need to zero out unexposed GP/fixed counters/selectors since RDPMC
+	 * in this case will be intercepted. Accessing to these counters and
+	 * selectors will cause #GP in the guest.
+	 */
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		pmc = &pmu->gp_counters[i];
+		wrmsrl(pmc->msr_counter, pmc->counter);
+		wrmsrl(pmc->msr_eventsel, pmu->gp_counters[i].eventsel);
+	}
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmc = &pmu->fixed_counters[i];
+		wrmsrl(pmc->msr_counter, pmc->counter);
+	}
 }
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7852ba25a240..a23cf9ca224e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -572,7 +572,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	}
 
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
-		pmu->fixed_counters[i].msr_eventsel = MSR_CORE_PERF_FIXED_CTR_CTRL;
+		pmu->fixed_counters[i].msr_eventsel = 0;
 		pmu->fixed_counters[i].msr_counter = MSR_CORE_PERF_FIXED_CTR0 + i;
 	}
 }
@@ -799,6 +799,43 @@ static void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
 	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, MSR_TYPE_RW, msr_intercept);
 }
 
+static void intel_save_guest_pmu_context(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	/* Global ctrl register is already saved at VM-exit. */
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
+	/* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. */
+	if (pmu->global_status)
+		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
+
+	rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
+	/*
+	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
+	 * also avoid these guest fixed counters get accidentially enabled
+	 * during host running when host enable global ctrl.
+	 */
+	if (pmu->fixed_ctr_ctrl)
+		wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
+}
+
+static void intel_restore_guest_pmu_context(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u64 global_status, toggle;
+
+	/* Clear host global_ctrl MSR if non-zero. */
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
+	toggle = pmu->global_status ^ global_status;
+	if (global_status & toggle)
+		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status & toggle);
+	if (pmu->global_status & toggle)
+		wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status & toggle);
+
+	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
+}
+
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
@@ -812,6 +849,8 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.cleanup = intel_pmu_cleanup,
 	.is_rdpmc_passthru_allowed = intel_is_rdpmc_passthru_allowed,
 	.passthrough_pmu_msrs = intel_passthrough_pmu_msrs,
+	.save_pmu_context = intel_save_guest_pmu_context,
+	.restore_pmu_context = intel_restore_guest_pmu_context,
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = 1,
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


