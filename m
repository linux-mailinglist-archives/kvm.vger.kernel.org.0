Return-Path: <kvm+bounces-22861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 135FD94426A
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65E70B22ED4
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C0714D294;
	Thu,  1 Aug 2024 05:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="utzzxdxC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8D61448FB
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488405; cv=none; b=DTY4998B4aTMEAS6n9qYeNrncj4Gy/vP08l+t4kOIQzndeBBysXl/hAUKo/ikMouXDEeYqZN9K4QpHMNYh+p+oRlD+ysrDE4N1BfDj+c0xjOEhy3s4fyqGoVyeK7fXZfmYuI2PnKfvblKL9aeRGpfjfhI4tru2j0YyAcofuuBvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488405; c=relaxed/simple;
	bh=c1fCTvilDFVcRNJhCRp0QJSo7ujqHFTlpwpghPBcc60=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cg3VPpWZNga75joPploUeFI39dK+y0mbxCNxzZuUMvFIgGMDjnCSjYW9hbwlRas3Yu6DsCGs6OKfvD4DLhjGLPoKxOn2sE/K8K70zrpysUk4589ObthlIWVE+9tb+sYqx6aQHLjZw+++buj8kb6d6qgNiVMLiH4d5B7HCdSM8cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=utzzxdxC; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0bbd1ca079so2381709276.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488403; x=1723093203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=irJZdD9WRLE+TSvW8RXjQ94EKY3/u6wzawNTQJVZPek=;
        b=utzzxdxCLFdbCJPp/mofHdjNH8l9Pmb4Dkv4Y2zCxprXatjHwkkJ9CaRASRszbMyOc
         y283SWu9pXSji2T4ZvDZKx6ldHnHyEl778P6IURpWXBUnS8yT5oICXBXZeS8wymyzZHS
         oHs/4zTEWH6Z3g5YXRQcxfoLzFK59obfJVb4RhUwtNEmCzoLpsP951/Cwq1njGujpN1B
         leSLMYkAu+ZwCjDJOqf4ZZfPLZdEKsz+wvQF3IL6l5q1VkCOSewExXLRVq9FL80cKB+I
         vj5vC8rc31dQnxwr9giIQgTcS0wkrA7PLO0gSIrXnRuHPEQhjkCmSm8Yp5gEUmsCDmF9
         0FbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488403; x=1723093203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=irJZdD9WRLE+TSvW8RXjQ94EKY3/u6wzawNTQJVZPek=;
        b=XjLoqdOex7fxO5ycewlBRVHrIFtL5ZKRj5KCQ9wgFKcA2y/3053lGjSEOacTGXI+Fc
         ABY227J+moZ0iB4CV8I8+B/98uunB+eewNk/XAGeoUuEUOWkFETyXrbf/WgC72tJep9R
         l4mxx2SnRBipoZNYobD0WlPHvEdASG/5N++XyM7zIxwx9xHbdS+gWzs9cnYI5mf2FH/f
         Z6g8b2bduiBXBfhxdoMojwVoosdevFNbMO/dP9X7kqQTnqdQP8EyEkoIRB+JZmFRYTSS
         VJgZyvUNNnOUDIrRchry2+9/6skcSTzFh5BUYOgThFzhH5yvWYdIsXOyV+i5I/IQuj8k
         JNSw==
X-Forwarded-Encrypted: i=1; AJvYcCVRn1cu8dPyjJc2XWOiOLmZIp+b+TT/ypZw+OaJY+kYDeM54GmirKysa8YpJvpeUs7YyrrsitKGJARwL18QEMN5JjIz
X-Gm-Message-State: AOJu0YzmvctATo+XXFv+V7JQngDn5Q1rPu8GROmiL3584Zxplt0rWVfX
	ei4jn6IHiIe6/+rhNVQWE5d1I5WBTjdt9Ghv7BKkPtRvKP1ie18PeDPzPUFe7QzYPKOm5RCJwN9
	zDMU3ZQ==
X-Google-Smtp-Source: AGHT+IHZe+/cCSU0lslMnaab+D51PLQFe9tuFbokmysftHCFBXl9tfqMC3s3XuLIcm7zeS1joxRcJfr6JG4Y
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:1201:b0:e05:aa67:2d4b with SMTP id
 3f1490d57ef6-e0bcd2167d8mr3501276.3.1722488402898; Wed, 31 Jul 2024 22:00:02
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:37 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-29-mizhang@google.com>
Subject: [RFC PATCH v3 28/58] KVM: x86/pmu: Add intel_passthrough_pmu_msrs()
 to pass-through PMU MSRs
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Event selectors for GP counters and fixed counters control MSR are
intercepted for the purpose of security, i.e., preventing guest from using
unallowed events to steal information or take advantages of any CPU errata.

Other than event selectors, disable PMU counter MSR interception specified
in guest CPUID, counter MSR index outside of exported range will still be
intercepted.

Global registers like global_ctrl will passthrough only if pmu version is
greater than 1.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/cpuid.c         |  3 +--
 arch/x86/kvm/vmx/pmu_intel.c | 47 ++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3deb79b39847..f01e2f1ccce1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -382,8 +382,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	kvm_pmu_refresh(vcpu);
 
-	if (is_passthrough_pmu_enabled(vcpu))
-		kvm_pmu_passthrough_pmu_msrs(vcpu);
+	kvm_pmu_passthrough_pmu_msrs(vcpu);
 
 	vcpu->arch.cr4_guest_rsvd_bits =
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 02c9019c6f85..737de5bf1eee 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -740,6 +740,52 @@ static bool intel_is_rdpmc_passthru_allowed(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+/*
+ * Setup PMU MSR interception for both mediated passthrough vPMU and legacy
+ * emulated vPMU. Note that this function is called after each time userspace
+ * set CPUID.
+ */
+static void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
+{
+	bool msr_intercept = !is_passthrough_pmu_enabled(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	int i;
+
+	/*
+	 * Unexposed PMU MSRs are intercepted by default. However,
+	 * KVM_SET_CPUID{,2} may be invoked multiple times. To ensure MSR
+	 * interception is correct after each call of setting CPUID, explicitly
+	 * touch msr bitmap for each PMU MSR.
+	 */
+	for (i = 0; i < kvm_pmu_cap.num_counters_gp; i++) {
+		if (i >= pmu->nr_arch_gp_counters)
+			msr_intercept = true;
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i, MSR_TYPE_RW, msr_intercept);
+		if (fw_writes_is_enabled(vcpu))
+			vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, msr_intercept);
+		else
+			vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, true);
+	}
+
+	msr_intercept = !is_passthrough_pmu_enabled(vcpu);
+	for (i = 0; i < kvm_pmu_cap.num_counters_fixed; i++) {
+		if (i >= pmu->nr_arch_fixed_counters)
+			msr_intercept = true;
+		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i, MSR_TYPE_RW, msr_intercept);
+	}
+
+	if (pmu->version > 1 && is_passthrough_pmu_enabled(vcpu) &&
+	    pmu->nr_arch_gp_counters == kvm_pmu_cap.num_counters_gp &&
+	    pmu->nr_arch_fixed_counters == kvm_pmu_cap.num_counters_fixed)
+		msr_intercept = false;
+	else
+		msr_intercept = true;
+
+	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_STATUS, MSR_TYPE_RW, msr_intercept);
+	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL, MSR_TYPE_RW, msr_intercept);
+	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, MSR_TYPE_RW, msr_intercept);
+}
+
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
@@ -752,6 +798,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
 	.is_rdpmc_passthru_allowed = intel_is_rdpmc_passthru_allowed,
+	.passthrough_pmu_msrs = intel_passthrough_pmu_msrs,
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = 1,
-- 
2.46.0.rc1.232.g9752f9e123-goog


