Return-Path: <kvm+bounces-22858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67B90944267
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:02:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E77B11F22D4B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6171214B964;
	Thu,  1 Aug 2024 05:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YJw6FWc1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8129C14B955
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488400; cv=none; b=cOx0+8p9K3vV+LULNEHybq+Uda9VSRgznPt6VrV8le6RCtlGtizXgzSJwEPglitUxMAx3lml18LH5aFBKA5BH7HtXg39LtUeKYEUtFn38YDg+mvzmHxv8geJyD//Jj4vKweUTgw9VMzoVUUI1X+8WbZepP5WdYXoGGvNQNBJ0GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488400; c=relaxed/simple;
	bh=cpdewCYRTH3HagecD26mSoOrzn+fANDPWjNHtBFYlsA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VdCsH7nq7okuVuQjtxOP0ACeOCry4KC+rRRcJbbrn6OR4+Gd72194TfIlbOxVfivmNcj1TWy7rWL7c3uSLl5jQP7DIJpzjnzRYWK6LFz/uiYVhD4sMowhe9e7FlsIXx/6izCoIcG53Ce51xGnw+YUWEgFKidLbpZtm6aZxYjpqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YJw6FWc1; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-666010fb35cso29306327b3.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488397; x=1723093197; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=E4e28VhtKidH7wKlinlrbGaKmDHKvgGnSQceLj2+f5c=;
        b=YJw6FWc1048zjvTHXzwlZ49YC8pOXRmu570nEd4zK6aEB10apzIiv4ZtagoR/TROQN
         WMt1LxAoVKuddR1Ei4qJQykTtalI11LetS2infIpVAu67NlbSVKcizKGEsbeOATIs/Td
         HKJPDghefWKsD+ljQCfAagqSN27lKMe2UUOWLdTqjeDYW0wlo7GjFHD/CxKwgAVwzR37
         jHK0Q+bgvINro6UoRM7ARuGbbrdj4yf95wnnNHEc7Vpc9frm8UCUjIsOWU+5guxkGzq2
         /DvhgH0oyoYGTLnVae/FmUqkjMY/JxWCN2Dxsvm6sVo8jNq85vaPYZPv3kGbGmlz9B1L
         CVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488397; x=1723093197;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E4e28VhtKidH7wKlinlrbGaKmDHKvgGnSQceLj2+f5c=;
        b=VSXz72ecjItN3Gh9TH1J7x7EA4Y1/ZkNQsW7jcZlD6br66jvWXVGqwcTLpqZA1A6qU
         AUNnNcVhTfAN3NyBKiFIXQdJhFIz/I4iZ7Lrt4sCQ9WvFXy1eaXTsqUmI5I5ylH7/COy
         oL8ROUiMCe347CF2cAs/92WWsJK8+mpnbc+XtlZEhPsOpPPcw54t7YjWlRrpewNxF5za
         vRP/oSgx0v4zmLoqSLNU4DpeFFCwT6HeqXKpKE4m2uE7Ys9P7K4xTQfGEhCc/jJb+RKN
         mx9XVohq5Yd6PQbZy5Yb8VcXzG5708SI/e9+FxksUQOJCMeV3BLuLFAZ5qrhnr2/wCjz
         FMhg==
X-Forwarded-Encrypted: i=1; AJvYcCUZ+chzXEqUB31fjqqKl+btAxCQ3gpNay5TAL8xqSE7cxXxRtrHYJYCIAJN+8kw53/JYfZULtF92hzhAxlM5jfLh5F7
X-Gm-Message-State: AOJu0YxQYY+EItgjWwYNFj8nLvBfF/EzMVFYKBBNghFNB88LrhCpEWEs
	xwLuBeVPnSQ9eUcmsdmC/LxSCauG7J+HckZ2X19LnspO4rsu1ED5Bomgt6hq9gwA+Tz9O14YwUG
	xFRKrQA==
X-Google-Smtp-Source: AGHT+IFNeoRXudJIhYy54+gWI9XhGfZjSENkGoRo+7f/LsMQFMRvJAGHHKhngEbnDzEbKA/LkqDUDBWf+PXb
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:690c:2fc8:b0:66a:a05e:9fe4 with SMTP id
 00721157ae682-6885437710amr2107b3.3.1722488397409; Wed, 31 Jul 2024 21:59:57
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:34 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-26-mizhang@google.com>
Subject: [RFC PATCH v3 25/58] KVM: x86/pmu: Introduce PMU operator to check if
 rdpmc passthrough allowed
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

Introduce a vendor specific API to check if rdpmc passthrough allowed.
RDPMC passthrough requires guest VM have the full ownership of all
counters. These include general purpose counters and fixed counters and
some vendor specific MSRs such as PERF_METRICS. Since PERF_METRICS MSR is
Intel specific, putting the check into vendor specific code.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 +
 arch/x86/kvm/pmu.c                     |  1 +
 arch/x86/kvm/pmu.h                     |  1 +
 arch/x86/kvm/svm/pmu.c                 |  6 ++++++
 arch/x86/kvm/vmx/pmu_intel.c           | 16 ++++++++++++++++
 5 files changed, 25 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index f852b13aeefe..fd986d5146e4 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -20,6 +20,7 @@ KVM_X86_PMU_OP(get_msr)
 KVM_X86_PMU_OP(set_msr)
 KVM_X86_PMU_OP(refresh)
 KVM_X86_PMU_OP(init)
+KVM_X86_PMU_OP(is_rdpmc_passthru_allowed)
 KVM_X86_PMU_OP_OPTIONAL(reset)
 KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 19104e16a986..3afefe4cf6e2 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -102,6 +102,7 @@ bool kvm_pmu_check_rdpmc_passthrough(struct kvm_vcpu *vcpu)
 
 	if (is_passthrough_pmu_enabled(vcpu) &&
 	    !enable_vmware_backdoor &&
+	    static_call(kvm_x86_pmu_is_rdpmc_passthru_allowed)(vcpu) &&
 	    pmu->nr_arch_gp_counters == kvm_pmu_cap.num_counters_gp &&
 	    pmu->nr_arch_fixed_counters == kvm_pmu_cap.num_counters_fixed &&
 	    pmu->counter_bitmask[KVM_PMC_GP] == (((u64)1 << kvm_pmu_cap.bit_width_gp) - 1) &&
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 91941a0f6e47..e1af6d07b191 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -40,6 +40,7 @@ struct kvm_pmu_ops {
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*cleanup)(struct kvm_vcpu *vcpu);
+	bool (*is_rdpmc_passthru_allowed)(struct kvm_vcpu *vcpu);
 
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index dfcc38bd97d3..6b471b1ec9b8 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -228,6 +228,11 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 	}
 }
 
+static bool amd_is_rdpmc_passthru_allowed(struct kvm_vcpu *vcpu)
+{
+	return true;
+}
+
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
@@ -237,6 +242,7 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.set_msr = amd_pmu_set_msr,
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
+	.is_rdpmc_passthru_allowed = amd_is_rdpmc_passthru_allowed,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e417fd91e5fe..02c9019c6f85 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -725,6 +725,21 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 	}
 }
 
+static bool intel_is_rdpmc_passthru_allowed(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Per Intel SDM vol. 2 for RDPMC, MSR_PERF_METRICS is accessible by
+	 * with type 0x2000 in ECX[31:16], while the index value in ECX[15:0] is
+	 * implementation specific. Therefore, if the host has this MSR, but
+	 * does not expose it to the guest, RDPMC has to be intercepted.
+	 */
+	if ((host_perf_cap & PMU_CAP_PERF_METRICS) &&
+	    !(vcpu_get_perf_capabilities(vcpu) & PMU_CAP_PERF_METRICS))
+		return false;
+
+	return true;
+}
+
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
@@ -736,6 +751,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
+	.is_rdpmc_passthru_allowed = intel_is_rdpmc_passthru_allowed,
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = 1,
-- 
2.46.0.rc1.232.g9752f9e123-goog


