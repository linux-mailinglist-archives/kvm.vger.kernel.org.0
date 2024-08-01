Return-Path: <kvm+bounces-22885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EA40944282
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B61C61F22021
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165A11494A5;
	Thu,  1 Aug 2024 05:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oA8YMdfC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E3F1527BF
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488450; cv=none; b=etwlli/vIbzZ1ePrDKgQC9snNIxon/YznDCLBKnaFs2TLVnfzYn4bQz+VDMwkYPU/ETi/F9z1/uylDJ2Hs87zhhhXBIzRABTxZtoQJO7v+iekeLQx/fAqY0eOCCVwEC98O/cj/YC0ARbH4EpGxGL35djs/Vr8rwNl+O0grvKjNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488450; c=relaxed/simple;
	bh=ooIoHd4B2WjFXEVjvElOl6cYTrco31uD4hT/IofdTWw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pHgMMZyf76Wq5sBA3s//8DLog/k4425q/tn3IClZ4eA0WxqEdmb78j0AZCiJl87xZqcyn9ER0/hdQ6hkQ9FDXk+wr0BPE55JN+y+g4Hk8Ecbqi24BcaT0umszVnlE1r0myTm8Lzy0bZLkeh3LJzFNYlh2KL/tx8wSGDDiuAnME0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oA8YMdfC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc5b60f416so53100565ad.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488448; x=1723093248; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=p0t/UD4dIivvXTkixB6hrl3EoPpTSTvHLUpyKF5tk6Y=;
        b=oA8YMdfCf4vhW6Ao4Qo0tN1c0KG8Z1kX7Ac1Gz9UyAHxfPFvjSB19pOtGdkMR3VMc1
         vdof0N47a002JEeFcAaEnXdZRomTWv0wUaOiMCkNDhM9Y7R6HrQr9jpggTfe3n914T1S
         FooljaWq8VuF86JqtnGXmrISf4NpcH5FJXv4p4OUZwXJa6l5D/lyKCGXv+aP66bdxBtX
         qXAgagxOAS3pphB3l99vBxqdupHfDnzF5gXgNoiyN4vrtKurwJmXQlcvX+/+joI/9Zi+
         qRPwGIaPayndxe2NH5JfNEA6MXuby1h6bTuwJgSB9Y3fFrwFJFZUKOGBNL2HVfPbSkRk
         Oc8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488448; x=1723093248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p0t/UD4dIivvXTkixB6hrl3EoPpTSTvHLUpyKF5tk6Y=;
        b=BTfuEj4qUkVFlxaO/Fu4GGgh1xnqifY203gTsYO6GP5vBMoUE4frI/d7YcyDEV+26N
         O/pdsRw6QNP8i1YpTbApwHY/gMq7CMbXxI49ANHAeXsq/2kQ1VhuVejUtjvbugTQ99JH
         pvmzLxT3SLhgyP2YuN6Z4s4ca+Bkd3TJYmc9TbuZGHOKJl5VChJdkDIUW7Gl6Z886z7h
         TsK8DOOc002uK9rMDS0yuItyicFgEck6Rc/6vHWyrgwwRw5Cqwq+F+2VWW2miJt3OepD
         Hm+TKq7QGnOMpVSswS1xHFHirVRVJ0tt2lbVryiDA4rWftmJb+Rl6s88l6jodrW5z94N
         yhTA==
X-Forwarded-Encrypted: i=1; AJvYcCWrSsyQcSykPfYQp2XT24t6uZ4BfpfC3WtW0gK26jxmimvdlMvJQhVjgA6zcrCpSSHiGU8IvHlk3qmk9e0Gxn8JaV8G
X-Gm-Message-State: AOJu0Yz2O0cgUAWlzL8Et0Q5EhrmIbLyAgrg83Lz/RqBETQ3TnKFHAV+
	DJPtf5KYzU7c7b0gu/jEZKekbQEC1MgLejh/jnDPB0XV2iO1nt6NHEikDQN8CQ/UjOwDS2F82pJ
	o0b+qoQ==
X-Google-Smtp-Source: AGHT+IHwqVGLUGlxkC788P9aAg8SZHts1m5iM6VOVnyqPUl1W3ZH+X/Hy+gczlwAUKEWq0d/8alcVjwKFnXv
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:902:ce81:b0:1fb:984c:5531 with SMTP id
 d9443c01a7336-1ff4ce4d58amr1349925ad.2.1722488447984; Wed, 31 Jul 2024
 22:00:47 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:59:01 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-53-mizhang@google.com>
Subject: [RFC PATCH v3 52/58] KVM: x86/pmu/svm: Implement callback to disable
 MSR interception
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Sandipan Das <sandipan.das@amd.com>

Implement the AMD-specific callback for passthrough PMU that disables
interception of PMU-related MSRs if the guest PMU counters qualify the
requirement of passthrough. The PMU registers include the following.
 - PerfCntrGlobalStatus (MSR 0xc0000300)
 - PerfCntrGlobalCtl (MSR 0xc0000301)
 - PerfCntrGlobalStatusClr (MSR 0xc0000302)
 - PerfCntrGlobalStatusSet (MSR 0xc0000303)
 - PERF_CTLx and PERF_CTRx pairs (MSRs 0xc0010200..0xc001020b)

Note that the passthrough/interception is invoked after each CPUID set.
Since CPUID set can be done multiple times, do the intercept/clear of the
bitmap explicitly for each counters as well as global registers.

Note that even if the host is PerfCtrCore or PerfMonV2 capable, a guest
should still be able to use the four K7 legacy counters. Disable
interception of these MSRs in passthrough mode.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/pmu.c | 55 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 0a16f0eb2511..cc03c3e9941f 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -248,6 +248,60 @@ static bool amd_is_rdpmc_passthru_allowed(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static void amd_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int msr_clear = !!(is_passthrough_pmu_enabled(vcpu));
+	int i;
+
+	for (i = 0; i < min(pmu->nr_arch_gp_counters, AMD64_NUM_COUNTERS); i++) {
+		/*
+		 * Legacy counters are always available irrespective of any
+		 * CPUID feature bits and when X86_FEATURE_PERFCTR_CORE is set,
+		 * PERF_LEGACY_CTLx and PERF_LEGACY_CTRx registers are mirrored
+		 * with PERF_CTLx and PERF_CTRx respectively.
+		 */
+		set_msr_interception(vcpu, svm->msrpm, MSR_K7_EVNTSEL0 + i, 0, 0);
+		set_msr_interception(vcpu, svm->msrpm, MSR_K7_PERFCTR0 + i, msr_clear, msr_clear);
+	}
+
+	for (i = 0; i < kvm_pmu_cap.num_counters_gp; i++) {
+		/*
+		 * PERF_CTLx registers require interception in order to clear
+		 * HostOnly bit and set GuestOnly bit. This is to prevent the
+		 * PERF_CTRx registers from counting before VM entry and after
+		 * VM exit.
+		 */
+		set_msr_interception(vcpu, svm->msrpm, MSR_F15H_PERF_CTL + 2 * i, 0, 0);
+
+		/*
+		 * Pass through counters exposed to the guest and intercept
+		 * counters that are unexposed. Do this explicitly since this
+		 * function may be set multiple times before vcpu runs.
+		 */
+		if (i >= pmu->nr_arch_gp_counters)
+			msr_clear = 0;
+		set_msr_interception(vcpu, svm->msrpm, MSR_F15H_PERF_CTR + 2 * i, msr_clear, msr_clear);
+	}
+
+	/*
+	 * In mediated passthrough vPMU, intercept global PMU MSRs when guest
+	 * PMU only owns a subset of counters provided in HW or its version is
+	 * less than 2.
+	 */
+	if (is_passthrough_pmu_enabled(vcpu) && pmu->version > 1 &&
+	    pmu->nr_arch_gp_counters == kvm_pmu_cap.num_counters_gp)
+		msr_clear = 1;
+	else
+		msr_clear = 0;
+
+	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_CTL, msr_clear, msr_clear);
+	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, msr_clear, msr_clear);
+	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, msr_clear, msr_clear);
+	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, msr_clear, msr_clear);
+}
+
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
@@ -258,6 +312,7 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
 	.is_rdpmc_passthru_allowed = amd_is_rdpmc_passthru_allowed,
+	.passthrough_pmu_msrs = amd_passthrough_pmu_msrs,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
-- 
2.46.0.rc1.232.g9752f9e123-goog


