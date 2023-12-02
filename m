Return-Path: <kvm+bounces-3200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3122780188A
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:06:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3CC71F21103
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED4A2F55;
	Sat,  2 Dec 2023 00:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cx9jtUmQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1435F1FCC
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:04:52 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5c638433bcfso1295286a12.2
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475491; x=1702080291; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pFreupbkDM72Lg9VXbt3uhD5eL3MlA+w2z7WkHNK64w=;
        b=cx9jtUmQ/itREeQ3zPZ6HEhY1Ji/eRVx+NxlEUsaKcesbnzji0eEvYKLietWzyYs0j
         68hfxRvv3ObPtqHtiKHTvQO14v58R3pwhKJfWnU3EMrRKvdQ+vAgRpZFzoq4V8wH7/Z0
         YLEU7FgvPMNUCA1VYcUxcluULrEIe+deB9SnNLAhu2PBPFKRei5W2gB/beYWy35/1IPw
         NoeGlrVoBLt55maDLScOyx55J4Wu6qw+g4WZ/8cVvpzOBrqxES2vz6utSJWTbkVNAxcg
         0Cqbe4QOufisdSyQSsbgNwjRxRjOEVsY7v/YceEPEBEtvKEUo9dpf+0WSreX13JPDNn9
         PzLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475491; x=1702080291;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pFreupbkDM72Lg9VXbt3uhD5eL3MlA+w2z7WkHNK64w=;
        b=O/92xwi/3/ekzlazDq9ilAggqiMzWzsnl7E/jqSg03xV1gR4mBuG0GxFfJD6S3FEV9
         Y8LbzHDKOksJV/4U+RYRPEqeZ90F0SXMobmGn1Mh9fmcaJxnZxL4sIMWfKXzqSZ+9xpP
         RJRiDreXWczM39vMYKlbM3ZdW4Tr5/HBaYuvFFt0Fx3kWmz1qK+rwa6DLbWjPYwalsOe
         lileH/h1IGijHKiSDtqcaQokzlIw/oJDSzXXFbGYVrxy7vVle/FfoctmA2h/3bvyEN//
         HXNRGap3PEmF2k3UbNn36sWkLpUKqkck8u3TGKeO+L+juqoUGeAgLuAVrPwr8svuj8N4
         pCHA==
X-Gm-Message-State: AOJu0YxBgQl4QrN824q3dpIGa6jJUIayBKNmT2dK6bWiilL+ffS6v1VG
	FcSB4WP3X7suBApz2OiigZRTXV3WhZA=
X-Google-Smtp-Source: AGHT+IEubbDPtMfnKUKT3StWcq1d1UbQ5gQgTTOpqeK44obHj7WNiHuJSFhy1OBm3lpRBRwoo0hv8AICwGw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f146:0:b0:5c6:5f11:4d82 with SMTP id
 o6-20020a63f146000000b005c65f114d82mr26268pgk.12.1701475491490; Fri, 01 Dec
 2023 16:04:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:04:05 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-17-seanjc@google.com>
Subject: [PATCH v9 16/28] KVM: selftests: Test Intel PMU architectural events
 on fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Extend the PMU counters test to validate architectural events using fixed
counters.  The core logic is largely the same, the biggest difference
being that if a fixed counter exists, its associated event is available
(the SDM doesn't explicitly state this to be true, but it's KVM's ABI and
letting software program a fixed counter that doesn't actually count would
be quite bizarre).

Note, fixed counters rely on PERF_GLOBAL_CTRL.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 54 +++++++++++++++----
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 5b8687bb4639..663e8fbe7ff8 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -150,26 +150,46 @@ static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_feature even
 	guest_assert_event_count(idx, event, pmc, pmc_msr);
 }
 
+#define X86_PMU_FEATURE_NULL						\
+({									\
+	struct kvm_x86_pmu_feature feature = {};			\
+									\
+	feature;							\
+})
+
+static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
+{
+	return !(*(u64 *)&event);
+}
+
 static void guest_test_arch_event(uint8_t idx)
 {
 	const struct {
 		struct kvm_x86_pmu_feature gp_event;
+		struct kvm_x86_pmu_feature fixed_event;
 	} intel_event_to_feature[] = {
-		[INTEL_ARCH_CPU_CYCLES_INDEX]		 = { X86_PMU_FEATURE_CPU_CYCLES },
-		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 = { X86_PMU_FEATURE_INSNS_RETIRED },
-		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 = { X86_PMU_FEATURE_REFERENCE_CYCLES },
-		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 = { X86_PMU_FEATURE_LLC_REFERENCES },
-		[INTEL_ARCH_LLC_MISSES_INDEX]		 = { X86_PMU_FEATURE_LLC_MISSES },
-		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED },
-		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED },
-		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS },
+		[INTEL_ARCH_CPU_CYCLES_INDEX]		 = { X86_PMU_FEATURE_CPU_CYCLES, X86_PMU_FEATURE_CPU_CYCLES_FIXED },
+		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 = { X86_PMU_FEATURE_INSNS_RETIRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
+		/*
+		 * Note, the fixed counter for reference cycles is NOT the same
+		 * as the general purpose architectural event.  The fixed counter
+		 * explicitly counts at the same frequency as the TSC, whereas
+		 * the GP event counts at a fixed, but uarch specific, frequency.
+		 * Bundle them here for simplicity.
+		 */
+		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 = { X86_PMU_FEATURE_REFERENCE_CYCLES, X86_PMU_FEATURE_REFERENCE_TSC_CYCLES_FIXED },
+		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 = { X86_PMU_FEATURE_LLC_REFERENCES, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_LLC_MISSES_INDEX]		 = { X86_PMU_FEATURE_LLC_MISSES, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS, X86_PMU_FEATURE_TOPDOWN_SLOTS_FIXED },
 	};
 
 	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	uint32_t pmu_version = guest_get_pmu_version();
 	/* PERF_GLOBAL_CTRL exists only for Architectural PMU Version 2+. */
 	bool guest_has_perf_global_ctrl = pmu_version >= 2;
-	struct kvm_x86_pmu_feature gp_event;
+	struct kvm_x86_pmu_feature gp_event, fixed_event;
 	uint32_t base_pmc_msr;
 	unsigned int i;
 
@@ -199,6 +219,22 @@ static void guest_test_arch_event(uint8_t idx)
 		__guest_test_arch_event(idx, gp_event, i, base_pmc_msr + i,
 					MSR_P6_EVNTSEL0 + i, eventsel);
 	}
+
+	if (!guest_has_perf_global_ctrl)
+		return;
+
+	fixed_event = intel_event_to_feature[idx].fixed_event;
+	if (pmu_is_null_feature(fixed_event) || !this_pmu_has(fixed_event))
+		return;
+
+	i = fixed_event.f.bit;
+
+	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, FIXED_PMC_CTRL(i, FIXED_PMC_KERNEL));
+
+	__guest_test_arch_event(idx, fixed_event, i | INTEL_RDPMC_FIXED,
+				MSR_CORE_PERF_FIXED_CTR0 + i,
+				MSR_CORE_PERF_GLOBAL_CTRL,
+				FIXED_PMC_GLOBAL_CTRL_ENABLE(i));
 }
 
 static void guest_test_arch_events(void)
-- 
2.43.0.rc2.451.g8631bc7472-goog


