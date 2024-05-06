Return-Path: <kvm+bounces-16665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C2EF8BC701
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC6DD281964
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28600144D39;
	Mon,  6 May 2024 05:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YI6Sk36j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A05144D23
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973528; cv=none; b=Zj9WM8OvAFUBHeWGKbudxs74D500SQ9pqBjCqYDBF6dayWz4PJcxN1zDQO7sjE3GOQXpDboamHky7Hg7PJw75Jh92HRCXvDFBjuT5OZ0JWa4Bg0E/90+omZF98GPElv/rp9m9hvmXxgPNkPYYVGTdlUAxepazot7fZr6TvNNkj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973528; c=relaxed/simple;
	bh=jBwiMX7wI5HSLPF5fi9xEqtZdEHS8PbAGIyITtauspA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BhmAYSeTfKb0rEyoZFdu3ZoY8ss477SSdIreb/tRg8HZ62wxiG8kxX7EhkdJvChVUOaHfeIsvZcbiOXo8Q0BjfO+nsxY2LCwexPZPKgL7+nwktoJtMhoJSBJf5A8IdyzIlbei0AmYJJHgS9YDJRZE3F3kE0K+bcYeeteDZLYSW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YI6Sk36j; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2b3f16d858bso2181035a91.2
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973526; x=1715578326; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8V3t/43+VUCDBaE5V+mRBCTLjWbUoLkXSrwV9/F1T0U=;
        b=YI6Sk36jQIALMfDO8i+e9AOIHGtbmvruCQs0TA87uH3eDWzyG4SoTtAH8PBs2Jidsf
         aPmGpBmUd3nagLqT9sObwjqRU/OaWR2byn+/naFhzCFBUvX3utr+xv53FDzvAk9qjp7R
         6Ll/8M9b50UkWwdcU85s16ZnIF55XFV+PQsnSmcNBC/hcJwyCLER9iuWTNoUb/DzA+VC
         EiCKUlq9RJAmmQmiHJzNOFVEOSOzZAQweFyuqHSP3GHWz40YrrmOh/3Y2l2Xr19JYogp
         QCZWPGDgmmLc6Qv6li1W70rDUwv0jUeeDZEhHnRpdW1wNQ2toEeBEqyKmI3o8ITg03YK
         /v2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973526; x=1715578326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8V3t/43+VUCDBaE5V+mRBCTLjWbUoLkXSrwV9/F1T0U=;
        b=ofhU78EIS1MEduYL8Qdi6q1GR3ln4MVCJLQqog+1BPn8OboD3Hu6Xo2g5daxPqGG2i
         w3fUHVHhyjpWs3gnZNovqAa5hHY194k056fHu982PD2PlB1gq+1tyHFX5Gthdmzg7Cbx
         TWca61eqAcL4DAhMAFwdk823LcHGU8CAaIyU0WYjQ0cZYxpJBQ3l0O+yLRsdB81dGj2s
         lW/rgoNiPfcisqnSQRaLguITpiyuMk8bXEDWvEuplIxl0M1Wh8rTLiFwB3wq/2Sajcso
         pWUr3K/YjIdXB4wgEEkBotHjcdQxxEqACTojkb8STwXAQTJcG9GIlg0HOhaHQv2M6+g9
         RQXA==
X-Forwarded-Encrypted: i=1; AJvYcCUBRq8f9HUHN35IHEMcE++w4uYAfIoynptR/U0lSiZWRn3y/Swy+RBWd4lGkgzBEeT4KRX6kaaL6/oZVpzPqZ4FN0YZ
X-Gm-Message-State: AOJu0YyMhWiDX5+RIKOdTTFXUmm+AcjaW9aFG5SroM0ChPr3Uxs7Q6vZ
	8djc2mR9moGAfJyYI92ayDmK6Y+ZBlMo54MaUCjYsIMpq3m3HyYv4uUSVFiEdxaknmE0m1cgPvj
	RJgnEyQ==
X-Google-Smtp-Source: AGHT+IHCD7D1gafdXvnIaWh5MkPYdDClrelpiWTXntnXJIQreciZAWpYD5dSVRqOOaEkmZpIEOG7CsdVjTmf
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:90b:124e:b0:2b2:b00b:a342 with SMTP id
 gx14-20020a17090b124e00b002b2b00ba342mr29501pjb.4.1714973526441; Sun, 05 May
 2024 22:32:06 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:18 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-54-mizhang@google.com>
Subject: [PATCH v2 53/54] KVM: x86/pmu/svm: Implement handlers to save and
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
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Sandipan Das <sandipan.das@amd.com>

Implement the AMD-specific handlers to save and restore the state of
PMU-related MSRs when using passthrough PMU.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/kvm/svm/pmu.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index bed0acfaf34d..9629a172aa1b 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -295,6 +295,36 @@ static void amd_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
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
@@ -306,6 +336,8 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.init = amd_pmu_init,
 	.is_rdpmc_passthru_allowed = amd_is_rdpmc_passthru_allowed,
 	.passthrough_pmu_msrs = amd_passthrough_pmu_msrs,
+	.save_pmu_context = amd_save_pmu_context,
+	.restore_pmu_context = amd_restore_pmu_context,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


