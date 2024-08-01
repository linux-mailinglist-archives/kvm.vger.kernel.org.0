Return-Path: <kvm+bounces-22869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDA77944272
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:03:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7372C28769A
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C53146D65;
	Thu,  1 Aug 2024 05:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HLoOAw2W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DC814E2C4
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488420; cv=none; b=XCAPMxKvjayCircp+5T5E+qAmppi6Jr9jc7oASsObtreJav/n6Pjwx44vE4XqD7q01Uuiy00GtQxXRHduZqm0cFmvkslLW++iakX4jrdhDQ8XIJfXFUD+g71zY+Ooy9ru7lWLybIp4sa6sE8F8XvbMRhudahCuqbOW38IzcIQ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488420; c=relaxed/simple;
	bh=DVGGSBE4W6Dj56Ja/cNg4RJ9IrCtN6hDhrMfpoaPwqc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t3uIFxVc26qxRb7/CnxcUtMIu9CzoDESKcziywv8s2kr+f8WsCNmQcFF5AJVfQHSQdz1tycHNP93rzS+U8ePy7kIgMBeiO3X1o6BYDqapDtHRQselW0MZ0tfqdKM1NwZZO8N2aLJVj9orMM1+9s1Ee6qkIygY9gRS0r74qsUXb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HLoOAw2W; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6886cd07673so23087b3.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488418; x=1723093218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EAjDDshI/vxpb+COr8g3koCBShOFriBt/RZDXZjNeQw=;
        b=HLoOAw2WKwN6ZvWzlZa0SydEvaNrgfkEE47+RnXFsnI9nN/IeFh+ab38HBTRc6cdBH
         2IjL3KsDK0SqESgzh9S4fcL2j7T247yFTB+fm0gmKWUNaBhNLZzrUl/ct7psygm3CEQL
         9SvMpUEIt80T4QzjYleMtdu09aAt4KaVoN4Uv1IUFf9AoXwsZumuhPa9nGlxknpKKji7
         134N7RtcghidWkPGvd8x3eNxyX/yFSbs6jbSqOXwkDjqFva+6RfSPAGcNPHl+1Z6jRjh
         7C1pjSp5z89+OBihPq2AlhWM4kWjHrNlyj9rtH7kwHrfudxJGh99C0F48DlTnlZPxw0q
         RHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488418; x=1723093218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EAjDDshI/vxpb+COr8g3koCBShOFriBt/RZDXZjNeQw=;
        b=mMiXpyhO2qWN53tRXcsfIB0QrPzv6hHXx4v6qOQEmTr7zmDGEQnxGmIM12eoBqyoId
         gQ6C+Mi26lF1A6eW8Nw3ixFf8LgdNNUVriFlCky3ylMeIvHGl+8X27hAY9Qfggn8hb5c
         xaLvrlDm8rzahiMUBE5bUTkELXKHfbx1p7dVWCGWhhkHySMIUE0aYkFNUnj5IbiKbSTa
         8HfeDwh/gOW39azbg5O3JcPkVHypgyf7ao2dqMpe5GbcsTiiAOOeLhc8kOstfrEaxWYH
         p7bPz/+C72B8IlCFVem8yBx3dFtO5kEPrXYLlpf/qpv7qVT0cT2/mbK5p0PVOpMRAjrK
         4WcA==
X-Forwarded-Encrypted: i=1; AJvYcCVtgNiszI8Jr4fwpu8Ok+VmNbP4rbN71QWhtajF02rYuafSEe4AE2OewNe84hmF6mAny5kvNpl4ohVjD1jQGMfzzy1N
X-Gm-Message-State: AOJu0YwovQw3rCytbfTra7lKi4KWUYvvtfHNqdUZavxofJTZ0QoFWaqP
	AZjmHM9jgraoMNLY01SB8b0AX8XSE7p6t0tg1smJ09jxVV/gSqE/FL1VoGubZR5QWf1Dlu/R/eN
	Ems8dfA==
X-Google-Smtp-Source: AGHT+IEkVZ+i3g09rESJdS/AT8fQo3wvNx/XY/njVc3ARcUO1sIJlc9FqWoLOF7Q3kcvAsK0WKMpyjnDTiTK
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:690c:289:b0:62c:f6fd:5401 with SMTP id
 00721157ae682-6874f036bdamr164567b3.6.1722488417696; Wed, 31 Jul 2024
 22:00:17 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:45 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-37-mizhang@google.com>
Subject: [RFC PATCH v3 36/58] KVM: x86/pmu: Allow writing to fixed counter
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
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
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
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 28 ++++++++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e5c288d4264f..93c17da8271d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -549,6 +549,7 @@ struct kvm_pmu {
 	unsigned nr_arch_fixed_counters;
 	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
+	u64 fixed_ctr_ctrl_hw;
 	u64 fixed_ctr_ctrl_mask;
 	u64 global_ctrl;
 	u64 global_status;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 0cd38c5632ee..c61936266cbd 100644
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
2.46.0.rc1.232.g9752f9e123-goog


