Return-Path: <kvm+bounces-41845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2705CA6E156
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 18:46:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F439188F5DA
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 17:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9BA426B08E;
	Mon, 24 Mar 2025 17:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pWdIytrK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF9526A1C4
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 17:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742837623; cv=none; b=lXAPWAwbado0T9I9t5VqhD5Ewp23mX8GNKUrd2NIXfd0C1YnRTMqmwRSqGwrg5o1H6EKsfAgM6XnLpQ/wDUU3t39MGTlxlW3ENJJm8mMhPM+TEiOuWqC/M0MsdPpIvRbZscgdu38XysIkIKt9rOKHvrUWRD+LyzBHCr8LY/1hUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742837623; c=relaxed/simple;
	bh=smO9N5SKxgy1G1fUozBHmUGxKKNDlxNMEJJCN3XB7VI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PfsOzjMqOhtoUcqvvjHuysv123TdP6++kva0w8qiRv5XCnoAWkxwifXL7v+sNCShVnVdAw/Y3p0hso1gLZfbbNGVELUE/wm4q20IcKfU6j5ngQw4pX/U83p/4oEGj1NIJqclj22bL7pl/PxrgS/KqiSVyc/oZslKe1LG3Pq23wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pWdIytrK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-224364f2492so68873335ad.3
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 10:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742837621; x=1743442421; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wEVPDgzOlF/JMd1kCpp/+G+/XVxiSfG9ZpDB6GPsH7w=;
        b=pWdIytrKGuvU8gmfl8qv2Z4TTK75FrMMYRq77MToIiQBgzT2zexuQw6PhOzh30BCF/
         JnqsK43be8E60ZEJDmWUTvCqaftdnkba2PF028Uzet8s96bdmRa2uYgCfdyzYuUn3P61
         hda2hTpvpmft1KcD+JsQu/fQ5flNIk1N/GMnWoBMzsgC0YwgryJCrbszxRDqvshiEvjF
         E4wnXtMCApK/L9L1Qy1UmWay6gf56wfPfQbPtsjNREWkuAz+rUj6nuEuxWLWQk3r8IJu
         6AHSZZURF3MzAd9+Ip/sZ9cFMMPAYWJx/6su1byaDG21s2UDHxu+Tef59hX8Ak22byCM
         dUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742837621; x=1743442421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wEVPDgzOlF/JMd1kCpp/+G+/XVxiSfG9ZpDB6GPsH7w=;
        b=BeFnqLQUP7hYf7y5ZYPUj02PSXD+K6Yb/P2EUvCkWGNMU1i2ZPYDpIxIF7noAyYi9P
         4Ya5qr/WhCrImm+aQQIGaEEKvRCe12MQMgKHVnFmdApY+3lnsjL6TUbbpFFxCiBopRL9
         g/hg+X/GJ7RjqiSsS5FH9CQXM5EqynLtuFw1TH5D1ATvQteJtsKcIiRw4rVDlJP8HI43
         sM0OFuB3fyZhq57gS6A6s/vI/mjPvjz1HH1LElDD94mj5ll09r/+CAT3sFmqa4Kr8Sko
         2L8zNo+x6qlNzg/az2A5p/vv0aUSo8o45Zwl0ePg8cTAKJoTUMasg3OHYU2yaoSZn+ps
         aagg==
X-Forwarded-Encrypted: i=1; AJvYcCXvTIXtMMDl9Vlq9N/BjecrgywOt18eAf17fj5DAmoyvPG3wNzpzt/OR+5SAUKeYIIqYy0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx45BCVJBr81tn9DNEQ19dAmZB8wqKC0+6kKH/S9u7bzj7nd56+
	URuIA6/qVGsm1L7h8YBPs7wUT0yYe6M6WCeEG8WQFR9AFDtO6Y6oCJujuWcMBNbzdtMF5FhEcDF
	wDPp3SA==
X-Google-Smtp-Source: AGHT+IGI6p2Pj6Fn8aHHQEXMJiBqaTwbmqGsVWU5LIiIRgo44ugxKecCqHQMA+tuCDEL1Vi+10l8dSdDlnrF
X-Received: from plblc15.prod.google.com ([2002:a17:902:fa8f:b0:223:67ac:e082])
 (user=mizhang job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:320b:b0:224:10a2:cae7
 with SMTP id d9443c01a7336-22780e42056mr246605315ad.40.1742837620663; Mon, 24
 Mar 2025 10:33:40 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon, 24 Mar 2025 17:31:10 +0000
In-Reply-To: <20250324173121.1275209-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250324173121.1275209-31-mizhang@google.com>
Subject: [PATCH v4 30/38] KVM: x86/pmu: Handle emulated instruction for
 mediated vPMU
From: Mingwei Zhang <mizhang@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Zide Chen <zide.chen@intel.com>, Eranian Stephane <eranian@google.com>, 
	Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Mediated vPMU needs to accumulate the emulated instructions into counter
and load the counter into HW at vm-entry.

Moreover, if the accumulation leads to counter overflow, KVM needs to
update GLOBAL_STATUS and inject PMI into guest as well.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 68f203454bbc..f71009ec92cf 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -911,10 +911,50 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 	kvm_pmu_reset(vcpu);
 }
 
+static bool pmc_pmi_enabled(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u8 fixed_ctr_ctrl;
+	bool pmi_enabled;
+
+	if (pmc_is_gp(pmc)) {
+		pmi_enabled = pmc->eventsel & ARCH_PERFMON_EVENTSEL_INT;
+	} else {
+		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+						  pmc->idx - KVM_FIXED_PMC_BASE_IDX);
+		pmi_enabled = fixed_ctr_ctrl & INTEL_FIXED_0_ENABLE_PMI;
+	}
+
+	return pmi_enabled;
+}
+
 static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 {
-	pmc->emulated_counter++;
-	kvm_pmu_request_counter_reprogram(pmc);
+	struct kvm_vcpu *vcpu = pmc->vcpu;
+
+	/*
+	 * For perf-based PMUs, accumulate software-emulated events separately
+	 * from pmc->counter, as pmc->counter is offset by the count of the
+	 * associated perf event. Request reprogramming, which will consult
+	 * both emulated and hardware-generated events to detect overflow.
+	 */
+	if (!kvm_mediated_pmu_enabled(vcpu)) {
+		pmc->emulated_counter++;
+		kvm_pmu_request_counter_reprogram(pmc);
+		return;
+	}
+
+	/*
+	 * For mediated PMUs, pmc->counter is updated when the vCPU's PMU is
+	 * put, and will be loaded into hardware when the PMU is loaded. Simply
+	 * increment the counter and signal overflow if it wraps to zero.
+	 */
+	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
+	if (!pmc->counter) {
+		pmc_to_pmu(pmc)->global_status |= BIT_ULL(pmc->idx);
+		if (pmc_pmi_enabled(pmc))
+			kvm_make_request(KVM_REQ_PMI, vcpu);
+	}
 }
 
 static inline bool cpl_is_matched(struct kvm_pmc *pmc)
-- 
2.49.0.395.g12beb8f557-goog


