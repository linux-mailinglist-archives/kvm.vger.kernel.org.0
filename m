Return-Path: <kvm+bounces-16637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B2EC78BC6E4
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C8181F21F3E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B351428EC;
	Mon,  6 May 2024 05:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gpyTb3/v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4766D142659
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973476; cv=none; b=lPd+2ecxCY46TCY/OoiDJEHud1GfoVmb5tWfQomsiTtkD2GUufnSfwg2cwZJg/BcPf41Fkg2POfh1L7PNsw1u8xV8IJWKCenSEbVfADjzjYljX1D+wBdrqz/YcEdpiVxgGVqYOyyIhNYWeDP3/9tR1FEBQl1E3w6OMqhNNkaxb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973476; c=relaxed/simple;
	bh=UdZqWNqzeB0cg7wdvprRnRfsefRwp8AZHxDSSpJByyk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FUy4p6Yc+zCl+dtBVVqWsLLLpEaqyKP3Z5XyvuNQSrkLN+Zfg4GSghiLAJR7eexoG3eh7pC+xAsY9qIarUtUFV+kB1KWR0pZvtQgZGGIxXdCCMzDNpFsqpSaRZrhVTBnhtWGjTIid06W428J6pPNtnsdpLi7BZNAU3TWcxW2Rrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gpyTb3/v; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5c6245bc7caso1505315a12.3
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973475; x=1715578275; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qGdTiGFpAD7t0Nw5YwyJJdyfP8r0jkD9X8gPcBU6XUM=;
        b=gpyTb3/vGKExpVEOHOLRM75Y0RkY/svSThg2u31kT2zDNgIhZoLYQl2YJxtmDKFIUp
         Sb++2e5TrziVHw+GSbvzJizP2AqBlxdABd+FfoVP/JeRT1wsMEHyjXaNXKXD/qT7Il+Y
         OfduXIFssnFVaviA9984npl42wdBrVklRiVDuNCMAwbO3H3enZBvzirbc/r+f4jaYtLQ
         PHoKMwvH+TNKzFp/r1fycTjzatl4oo8rrWBYWoxmLIYLyOQHPwdJJTTOWozQ/OEDzaWi
         uqr4LC27wgfMATuygvEDmhqurmEhv2j0wKkghiF6XmOAdqkSBselKA5iTQlLJYMwugEp
         d/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973475; x=1715578275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qGdTiGFpAD7t0Nw5YwyJJdyfP8r0jkD9X8gPcBU6XUM=;
        b=qZ/6KJs31ixQEsnLbwBY1eERrL2G2FOm9slZC8XEG9uxDTlqFDA2MauwQJvdx+zFfG
         l83/YFHlqZujKG/vjaQD8t4pFuLuo6Z75DmOyrVRxZtQyrDrYqm3CFUc4SFxhLaqhZB9
         HiQWRDK7E2oCDXMAFFGTMB4KXOGQo1zsOQnKPJar8aQcKUjhg6tPrAvBTDAWnmuBt+fG
         Iv7Z7N9XDXA4IOF1PRcwjFnj3gV/r5RPG9KeYP5PS3aEa3sJiMFrxUGzSH3Q1K9XmEX3
         UD1pd0sAU5RLEJl4Y7fNshJbc3PpfZH+7st8Fql2OtUTeuiUn8rl0SxjTx+ERHkWNUB1
         5NbA==
X-Forwarded-Encrypted: i=1; AJvYcCUixrWBMk+7KnlFL7cPxSrAnSXyRovlboDkBR7zFiEIsQN1nw70xBIgXnDfaBr6vwhBntJHBJk8Qhot4qhjskXq+ehx
X-Gm-Message-State: AOJu0YyWdv2AyOuc4FTXIUEWI1NRirqKEmSYZlW6S+0uKzP2mdpNqa3l
	gOk9NRJa3uvLCYLl/dwAbPJ/lpqb/0RIzuGvEaJlmc3pqXrWZzgxq4QY3/GjdLaySLC2+In0n7Z
	RkW4plA==
X-Google-Smtp-Source: AGHT+IGYWQPb81CDVBWmWEGQFtP9vagQYnjfwuEIm4SVx6KL1RUYYJsKtF7tXLL/CuM31FXUTVspm/zuW71V
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a63:921b:0:b0:5d8:bb0c:d28b with SMTP id
 o27-20020a63921b000000b005d8bb0cd28bmr23023pgd.8.1714973474158; Sun, 05 May
 2024 22:31:14 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:50 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-26-mizhang@google.com>
Subject: [PATCH v2 25/54] KVM: x86/pmu: Add intel_passthrough_pmu_msrs() to
 pass-through PMU MSRs
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
---
 arch/x86/kvm/cpuid.c         |  3 +--
 arch/x86/kvm/vmx/pmu_intel.c | 47 ++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b577ba649feb..99e6cca67beb 100644
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
index ed79cbba1edc..8e8d1f2aa5e5 100644
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
2.45.0.rc1.225.g2a3ae87e7f-goog


