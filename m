Return-Path: <kvm+bounces-22883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8899D944280
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB3C9B237AB
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78BED15278D;
	Thu,  1 Aug 2024 05:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ERqfIqa2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466D7152517
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488446; cv=none; b=mAM7H8qmBDAgErCTKybDJReSnbztpk3twVxTo5rrw4mh/O92xYljjXQuWKtiytqoAHh2WZvCmj6fcQgO27kK88Cmw5S+i4mzgLIoZEK+HEqsfM46LXKg66IKfo9pgLNWc3h3iHjtLurgM+lOBbCuldG1jUP2pQz6qrMbTRaOWwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488446; c=relaxed/simple;
	bh=cdpKS3/uACb3KxMOvGHLsLYuNv1uvNwIlHZC51S5MPI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QJFBmGpQwwoUe4xS/m6UFouiBMktjRQXP/8wGlyt3LCpeDWmcLmlPXgOdzO6g5lzEBDMF5/MzZAMxaZhMOhoVo7VHuXEUAKX3VoFbmFXWwGGLtTAhTXpeVE8X8Z18VXRnbU3bZzkMPVmD65r/Vp/J1AmXjg3CWV6gLLJxhoHkuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ERqfIqa2; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0bcd04741fso868002276.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488444; x=1723093244; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bm7ZCS61nv2akVrVL6X4rg4hbgFHoPFsqWK4Hp1ajno=;
        b=ERqfIqa2j7N2rfjegAq9N1aLkIiTUJ7E82iNvBtoCoNbm5HtVcH/mXPzAnMoCS/Ift
         V8GkZHQPGDV3SgbiNG54ap++Jatv4tmdpAMNLwbPnLJwcOrE+CdJUZzUzv79pv9nwC/3
         PrFkuj8SM+x2NS8UvOGNRxEybU/2mSOi54qyMyj31NI9Ww4Qk5y5C+aUXWqGcUCxDpmd
         7X26ICA8VJWiN+y3qZwWXMEuB04Cu7r6gcdVzpPqME4byMYTm1ORUz9DuWmnWeG+JCZe
         7tp0futE3pMIQJ7Yf5Baloy8Uj+5uqHVwFVbMxFnq5aLFTORJLr1JJU5szXqpx1gCHPn
         97iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488444; x=1723093244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bm7ZCS61nv2akVrVL6X4rg4hbgFHoPFsqWK4Hp1ajno=;
        b=hiCUPB9RwaoKobrSoLCveMteG9u6RM9L1D9Avu3lbU79EkfrMuzYP1X8tnoH+7QLN8
         mLlhE9a7n+KxC1YPnJKQ69W8TltpwMtWe5Znh44aOOryCT6GrA9mlqkwBgYVJNcuA5Hu
         0/rxzT8ZsIVGDyTU3/5CLi5OHljcCBqP6gY16eBzxGq0RoERu10TUz1wWk/ElHP9RGmn
         j6sGDt7iu6varBoLJNeYgNh63McBE+Sk6SQ3ohSgjXJH/l3hDepWZBpqFmcJDwI2V+JJ
         7HS1Jq2DeEdaZs9JH+H7bz1uhYVuSmwbWAkdWTadkqwDzBQhyDL6yoYzfaW+KuwTPUp8
         GRWg==
X-Forwarded-Encrypted: i=1; AJvYcCXbTh2a9SOXPii3nSUhXpNmX2o4N7H9/2NK0uSQm97nTQJMEth65SLONOZJU4U8aEFK2UNecG7cg/LqZ5Vk5nTDbFBu
X-Gm-Message-State: AOJu0YzGjzWwJ2piw17vPcC493KKQWghoko8q5rS8vFgwPWxFil+Fq7D
	ae11gHBiUS/HKv7IcYPUHyY9lpSO4QPtUTrKSQrsWTjzCLVkt8ABNCYhLdFPxcAEYbHJ1JGovCh
	utdxbUA==
X-Google-Smtp-Source: AGHT+IF4VPoCa5Bi3PU0camhKoeHZtOuU9gIT2voR88T+GMpmTvgcbCdr/cc6zxAFccrkaQh5tCHXOh06UAT
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:1007:b0:dfb:22ca:1efd with SMTP id
 3f1490d57ef6-e0bcd36bf56mr2383276.9.1722488444219; Wed, 31 Jul 2024 22:00:44
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:59 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-51-mizhang@google.com>
Subject: [RFC PATCH v3 50/58] KVM: x86/pmu/svm: Set enable_passthrough_pmu
 module parameter
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

Since passthrough PMU can be also used on some AMD platforms, set the
"enable_passthrough_pmu" KVM kernel module parameter to true when the
following conditions are met.
 - parameter is set to true when module loaded
 - enable_pmu is true
 - is running on and AMD CPU
 - CPU supports PerfMonV2
 - host PMU supports passthrough mode

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.h     | 22 ++++++++++++++--------
 arch/x86/kvm/svm/svm.c |  2 ++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 10553bc1ae1d..9fb3ddfd3a10 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -196,6 +196,7 @@ extern struct kvm_pmu_emulated_event_selectors kvm_pmu_eventsel;
 static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 {
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
+	bool is_amd = boot_cpu_data.x86_vendor == X86_VENDOR_AMD;
 	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
 
 	/*
@@ -223,18 +224,23 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 			enable_pmu = false;
 	}
 
-	/* Pass-through vPMU is only supported in Intel CPUs. */
-	if (!is_intel)
+	/* Pass-through vPMU is only supported in Intel and AMD CPUs. */
+	if (!is_intel && !is_amd)
 		enable_passthrough_pmu = false;
 
 	/*
-	 * Pass-through vPMU requires at least PerfMon version 4 because the
-	 * implementation requires the usage of MSR_CORE_PERF_GLOBAL_STATUS_SET
-	 * for counter emulation as well as PMU context switch.  In addition, it
-	 * requires host PMU support on passthrough mode. Disable pass-through
-	 * vPMU if any condition fails.
+	 * On Intel platforms, pass-through vPMU requires at least PerfMon
+	 * version 4 because the implementation requires the usage of
+	 * MSR_CORE_PERF_GLOBAL_STATUS_SET for counter emulation as well as
+	 * PMU context switch.  In addition, it requires host PMU support on
+	 * passthrough mode. Disable pass-through vPMU if any condition fails.
+	 *
+	 * On AMD platforms, pass-through vPMU requires at least PerfMonV2
+	 * because MSR_PERF_CNTR_GLOBAL_STATUS_SET is required.
 	 */
-	if (!enable_pmu || kvm_pmu_cap.version < 4 || !kvm_pmu_cap.passthrough)
+	if (!enable_pmu || !kvm_pmu_cap.passthrough ||
+	    (is_intel && kvm_pmu_cap.version < 4) ||
+	    (is_amd && kvm_pmu_cap.version < 2))
 		enable_passthrough_pmu = false;
 
 	if (!enable_pmu) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 296c524988f9..12868b7e6f51 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -239,6 +239,8 @@ module_param(intercept_smi, bool, 0444);
 bool vnmi = true;
 module_param(vnmi, bool, 0444);
 
+module_param(enable_passthrough_pmu, bool, 0444);
+
 static bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
-- 
2.46.0.rc1.232.g9752f9e123-goog


