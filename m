Return-Path: <kvm+bounces-16645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F81C8BC6ED
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:35:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 908F7B2096D
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 973C5143734;
	Mon,  6 May 2024 05:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yLiEuN7L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B654142E84
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973492; cv=none; b=A9vORcTzHGeFpEbmcG7GhAbKHCMR2cdoYIMy4ej6NRFNI2Q856xTm96gRxUN0eVlLmgKO6a6vJWcoz4BYjNhZhGmcuBe9DtfUETp04gkdb34vpkJAHRFucrQmYuTVthRIrZJj9e/EafQ1XHzr9CUHylicOWmLv/XaWUNTMJPiA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973492; c=relaxed/simple;
	bh=Lp9pUuyt0iSo5TA1URxLuRuvINmD37F/OrEzck7Antg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OTapJh9+rnwlE0gzZ/MZAHLGvWafFxIEJGUG1BNh4pWcGa6qAoPfB5ysrhUDOV16Eki4f1muTue5EbUbmMiqjVB5/Y1vtQTSzXEUAIUd6KYj6frFjvQzuLyhE/CHd50SqaSv03YOHN2d8ESGMrOrvgXRFfzu3YFgWI33Gt4KCng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yLiEuN7L; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6202c9d143cso36833167b3.0
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973489; x=1715578289; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5OaE4SOISVEJQrz7jOK1jySgUG2WCvV5OU99ni3Q3GY=;
        b=yLiEuN7LSi2fZvm3+/GvWNjczKhcXHS+JgoxgSzS1jcxoWbF5pFyo2zO8BuaiXRyxz
         qUTxUhZT+uR3ZttXQR7be/WoUq7UGVtvmeGmMOqgrbWbkVuY3mpVz4qoOtq1AFIAtQGW
         wiKOXLrsmULZYlrP6tZ2gK8fOFk5s6aQ4x/5R7BAlqXn6oVQD+IPPXVILAn482zXZNxB
         j/rvJD3uGj4Yhy3ddfxGOEzIytFl/nZocvA0Enpc/AM6sngOM/51mbX6mvkqzUZWrM7f
         CXbvM0SvVxIbIycZl1OeRT9d48q5BYyzlgh931+RfuxtUPtgLqCIhWJSYZA/iN9MmheH
         e4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973489; x=1715578289;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5OaE4SOISVEJQrz7jOK1jySgUG2WCvV5OU99ni3Q3GY=;
        b=H3p/yxb9UcnUWrssTcZKrOs9fds7wp5aWt6ipUCS/k6ZLW31ktJ6A2LKxbBpRGMUm1
         ldF61QDyDL0DLRQ6zHribCD/vT0C/TimFxcYRiTxKVE2Owj/ai+WMRbXfrm0WFIlTQJo
         9/qj7Wh8mqc2VDJO9C/cpH4Ug63SSMVnyGb6rf/mMcNCflsUGMNcQQKWYtXp3FoA15VW
         073CIIf/MBxG9sEyMmBWkTGvtkvgGYw5hKccl5OuCLhuf3Qd2lYBqsVIbUisfuvdkV/f
         GoyJHng5Uwbh7QVPD1N/Qzm9U1KbxbD8hWZ6jHrczZ8Q2jB9OsjInXagol4oTs/Zd3CI
         ipiw==
X-Forwarded-Encrypted: i=1; AJvYcCXJkacWSI/bLy8qxh0V+vgGltK48gM4WvLjzeMpnTBNoMDXd+Uozs3WISo3UhXyOqnTTz2BTdmwlYE5qbZqzraQeeyR
X-Gm-Message-State: AOJu0YxvIVzK/oCcFe2lOrNiyyw3GPFELlo+dlGeeD9EHLS+HX85wgO5
	wERy9/gSZVxOjutYZ1HgmGPhUW4oWQelG5qFR+tw8Zkw9/Ky5lh2yUYsdpIP59Exa7tlco6HS0N
	IxNEOGQ==
X-Google-Smtp-Source: AGHT+IEvJHnorNw2lDo1XtcziIq1CcQDPqqwrFvijzPVSz84Xi1JdR4gnClhjQO10h5AfLBuEHqfDVd6j9r0
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:110d:b0:de4:7bae:3333 with SMTP id
 o13-20020a056902110d00b00de47bae3333mr3150156ybu.3.1714973489559; Sun, 05 May
 2024 22:31:29 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:58 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-34-mizhang@google.com>
Subject: [PATCH v2 33/54] KVM: x86/pmu: Allow writing to fixed counter
 selector if counter is exposed
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

Allow writing to fixed counter selector if counter is exposed. If this
fixed counter is filtered out, this counter won't be enabled on HW.

Passthrough PMU implements the context switch at VM Enter/Exit boundary the
guest value cannot be directly written to HW since the HW PMU is owned by
the host. Introduce a new field fixed_ctr_ctrl_hw in kvm_pmu to cache the
guest value.  which will be assigne to HW at PMU context restore.

Since passthrough PMU intercept writes to fixed counter selector, there is
no need to read the value at pmu context save, but still clear the fix
counter ctrl MSR and counters when switching out to host PMU.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 28 ++++++++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b396000b9440..9857dda8b851 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -546,6 +546,7 @@ struct kvm_pmu {
 	unsigned nr_arch_fixed_counters;
 	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
+	u64 fixed_ctr_ctrl_hw;
 	u64 fixed_ctr_ctrl_mask;
 	u64 global_ctrl;
 	u64 global_status;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e706d107ff28..f0f99f5c21c5 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -34,6 +34,25 @@
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
+static void reprogram_fixed_counters_in_passthrough_pmu(struct kvm_pmu *pmu, u64 data)
+{
+	struct kvm_pmc *pmc;
+	u64 new_data = 0;
+	int i;
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
+		if (check_pmu_event_filter(pmc)) {
+			pmc->current_config = fixed_ctrl_field(data, i);
+			new_data |= (pmc->current_config << (i * 4));
+		} else {
+			pmc->counter = 0;
+		}
+	}
+	pmu->fixed_ctr_ctrl_hw = new_data;
+	pmu->fixed_ctr_ctrl = data;
+}
+
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
 	struct kvm_pmc *pmc;
@@ -351,7 +370,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & pmu->fixed_ctr_ctrl_mask)
 			return 1;
 
-		if (pmu->fixed_ctr_ctrl != data)
+		if (is_passthrough_pmu_enabled(vcpu))
+			reprogram_fixed_counters_in_passthrough_pmu(pmu, data);
+		else if (pmu->fixed_ctr_ctrl != data)
 			reprogram_fixed_counters(pmu, data);
 		break;
 	case MSR_IA32_PEBS_ENABLE:
@@ -820,13 +841,12 @@ static void intel_save_guest_pmu_context(struct kvm_vcpu *vcpu)
 	if (pmu->global_status)
 		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
 
-	rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
 	/*
 	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
 	 * also avoid these guest fixed counters get accidentially enabled
 	 * during host running when host enable global ctrl.
 	 */
-	if (pmu->fixed_ctr_ctrl)
+	if (pmu->fixed_ctr_ctrl_hw)
 		wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
 }
 
@@ -844,7 +864,7 @@ static void intel_restore_guest_pmu_context(struct kvm_vcpu *vcpu)
 	if (pmu->global_status & toggle)
 		wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status & toggle);
 
-	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
+	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl_hw);
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


