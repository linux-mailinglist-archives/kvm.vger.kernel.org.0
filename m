Return-Path: <kvm+bounces-22888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34542944285
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C2ED2B238FC
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C695D153593;
	Thu,  1 Aug 2024 05:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vwzbls5A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51CF1534F8
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488456; cv=none; b=h9E6oqCXJ0a+SVIP+2HdNYqDNwMIq0sKuhUmzT1mWbAafqNJl75yPgqrVG4sovTtbtexoKO2yZ6cwQxg35vN+AbEx0Di2IKGdnnJxj+C9VrqOy1TKAXt2mRTKgx2OABiMs/VAjQ0foarSyEUKr0dNjpcQTTmfBd4cTDEpDr48Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488456; c=relaxed/simple;
	bh=hfCifMWLKFUz3KUyJZoboIqKJGi++P8HvrtPYrBpy5A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JidDkvys9eTIyVfqNusjCKxA4oh1P0OCnyoewCMsd+sIPLzNpz2DOQc3eiv1IiHDYcNGVjHF4qAWDzwXYM6kGqyDXBJ8WpM12wk/vyRPgWCb7wgjLeiXxfp32fjmRMBieamDFnBkV4KzLaZSEyMxbiM/97SftPh7MyD6v/OSUMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vwzbls5A; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb4c2276b6so6660183a91.1
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488454; x=1723093254; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=311Z3AoQ2JtdjycDfcinivqhlqwksY6b2H5cCC/LJ0Q=;
        b=vwzbls5AbGUfjzePy0Q7rtL7b6bpyASCc0ducG71yUoeAxU3M706JJhL5WiHkLYJgb
         4d1VMXav6/PSg2+WCYzEl3G2ia8Aei0VojagXkBBVM8yhzAg5WWiD+RDH944oEhwD8HN
         /pj0o2X9zsRWaHrZpBT9vtGJXzwwWIhmmMRDa6w/FYlCpbiQoh4io/BMP2ICr6vvbgSY
         ChJTbuBCmrsTgyEbOa8QQrFWyv0G+NbvCrxED53NzXuTXZd2WgZ/rTNKlxrAk+mUxZHk
         uzlbjPISIrg6ZvEfC+7lC9SDPffTMK8oDAgObbU4bFEXNUlSJZx/fMP84iUKlaUWPKNV
         vQGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488454; x=1723093254;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=311Z3AoQ2JtdjycDfcinivqhlqwksY6b2H5cCC/LJ0Q=;
        b=QhV1VmjhVjBsSzAaYoqHYh0Y8xT1yV4d6fWMvXegimgaZPPQ/ys8aN/Lr44P+dFif0
         Hg4YTrdTBNhR8ZtBb86wM7XcKfGqFOVZqRWzVzpYKzgo9wFvg+u4b3h/K81y0gkv8UQN
         pBp9V4rLqyI4UBNeJb+Y8jlCLp2IESDBYHGwbJNbTkPYGvE2/TPLQgRGWYE+Z+qFueLs
         ksWz2MoQOLwXDJgWicp/n41QxaKnG/jEmqoYG23uY5WGrcB9vLJYtMY7PrqQPo8M+wAT
         JLYE2f8F78K1raFdG9syrv1BiNtiHuL5QPpDKL3qNMpxuJwk0EU8iA1+JsTsReiqbyek
         DVug==
X-Forwarded-Encrypted: i=1; AJvYcCW8vcAaM+yOpgXJtulzWQHvA/+RcAINLYL1zFrSzKNpmAg4+PBmXCbV3uBQjRN+JQbx3WCZV9VI3rDHaOBRzZYLmWwg
X-Gm-Message-State: AOJu0YzK8/3MP+/ObKkJ7pDU/TJSjjeD5pj8IvpUI9uYjRdEXDxDyzmi
	sNN3y4N2knm3/DgJvKrWqmMOpQnt3Np5F0iAGg/Pt2b2RgKvJBWBlttx1Ylr3Ns/Uz0PnKUSpf0
	RcGc/RA==
X-Google-Smtp-Source: AGHT+IE7b9MrGSg1LLwijHD9u/x7qeWAFstIK8S2MxnZDPs1/+5zP/QQ8/lDj5iAaacVgnjFrbQ1sMQRpQDn
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:90a:582:b0:2c9:ba2b:42ac with SMTP id
 98e67ed59e1d1-2cfe7925363mr31965a91.4.1722488453820; Wed, 31 Jul 2024
 22:00:53 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:59:04 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-56-mizhang@google.com>
Subject: [RFC PATCH v3 55/58] KVM: x86/pmu/svm: Implement handlers to save and
 restore context
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

Implement the AMD-specific handlers to save and restore the state of
PMU-related MSRs when using passthrough PMU.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/pmu.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 2b7cc7616162..86818da66bbe 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -307,6 +307,36 @@ static void amd_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
 	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, msr_clear, msr_clear);
 }
 
+static void amd_save_pmu_context(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	rdmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, pmu->global_ctrl);
+	wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
+	rdmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, pmu->global_status);
+
+	/* Clear global status bits if non-zero */
+	if (pmu->global_status)
+		wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, pmu->global_status);
+}
+
+static void amd_restore_pmu_context(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u64 global_status;
+
+	wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
+	rdmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, global_status);
+
+	/* Clear host global_status MSR if non-zero. */
+	if (global_status)
+		wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, global_status);
+
+	wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, pmu->global_status);
+
+	wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, pmu->global_ctrl);
+}
+
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
@@ -318,6 +348,8 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.init = amd_pmu_init,
 	.is_rdpmc_passthru_allowed = amd_is_rdpmc_passthru_allowed,
 	.passthrough_pmu_msrs = amd_passthrough_pmu_msrs,
+	.save_pmu_context = amd_save_pmu_context,
+	.restore_pmu_context = amd_restore_pmu_context,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
-- 
2.46.0.rc1.232.g9752f9e123-goog


