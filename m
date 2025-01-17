Return-Path: <kvm+bounces-35889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0077DA15A11
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5311A1888890
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C2C1DED7B;
	Fri, 17 Jan 2025 23:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zaJAw/tq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BBF1DE8B5
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 23:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737157329; cv=none; b=kh1saXyyr+tjW9/esWeloNsh8U0XPfwyMLu/AeApdyNB9lV8dst99eywzTRDsHoxi29wGsS4FwYlLUiOlnXwCcALtOMunaoAHWm9FZn2IWhP0UoEGp/kRG8EkbImsa4uNLctfdtcmYr3XZtOF1rueaoaUlpfrByNRGXucv2nyMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737157329; c=relaxed/simple;
	bh=POfrsUNWIq048XGnB7sBSN8xdPfF9XX/t9xz+NiNUvk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V4zgK+Ck1lIZqC6mzSQKRO0o2rViJqLtzS1xv8qikIKqv5gBkvn8Ey0XSBkE6/vpWdq+7bShUSwH0jQTxlP99oTC5tPPeH9MT1+zgK1P2nwT6vqZF7FsPo8qDA2gP+KjS7Vo6KGAdTcPQtXQh9gcQGtUBhuklT7EuCnx/FoCvV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zaJAw/tq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so5147840a91.2
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 15:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737157327; x=1737762127; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=u5+M48xEYsPxfpNh5jdjkOZetq5qZE6t5SXp0yc/k2M=;
        b=zaJAw/tqRmIs1TdEJJKbSEHfCyDrrCvpuUlSbJlAYMOdbIbpo14Y9bEzXe2dicGGGq
         LyAUYK3RP9IV34VjwqNPg1cgWhnf4dOj0+4qTQ2sC+rF25aCsstuTsNGHaQxHKarKHYe
         oPoT3BhDCLaTVBB6/NEuCyptJ4EWGuzYmw3Q9heuEjTmZh9PAVH5c8mKjQ+O60wpBNSE
         rzrsKK+vqkTju3zg6J1zXX8Aw+QRukvfWOazSpha9ceqfa1FLs1OlqKYO1Ti7YqQSQTv
         B6Ob0HRftwY1aH1ytjoXVRWh48T5GpPGSBRHLj/y2nmvzZgXsysDfm0S4+FyW+ALNaPt
         /sQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737157327; x=1737762127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u5+M48xEYsPxfpNh5jdjkOZetq5qZE6t5SXp0yc/k2M=;
        b=Fhow0A3BVviEMt9eLOlDPjHGez8qgkxNWLnqR0xvBNhlW+yQ8kLXhk9QxNEz5ygrBW
         SWAAE6OahdcrkXvmd2i0cit7AuPRLj2ScOOJSJos5gXpOzwxHqqvaA3eVZ9FSND4bPBY
         tMz0wSYW0VbgXdaObcdHU/gD6jUtC5JWJ3KKKh5lCGrOFZLfLWK7+xL4rqe9SuQ1U+mT
         Vh94Fx7b6t7IrOMIuTD9C11c9ixxaw2gWBOMWDZP4IG1RN40I2vuWtw+n9BUhNgtlKpm
         7pwJZJ7csg8GcETbCKcojYKt1xIxUGFDGYzfE4Fqbl+2NgmQCEYbIYzVyNK98iZuoOOC
         zzlg==
X-Gm-Message-State: AOJu0YyiCc5xgrXqwI9wk3HajPLDNJA8CmzcQ7hwy1CoiY0pGKl2gbr1
	7xpZN91XVvR3rRiKmrftt9txQ6dy8Vv/0PEsNwlhWzt0ubDQPXiLwEc3avIb7PLMEaeW2SoriS2
	IWA==
X-Google-Smtp-Source: AGHT+IGl6m0HjxHGktxDhc1qkC2rHr/QX1dmPhJzqq7Pyp3+7VIqcRHqfV4KIdxMFGQd93i0eQhdjm9Q+jM=
X-Received: from pfbcg12.prod.google.com ([2002:a05:6a00:290c:b0:72d:b526:23ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:338b:b0:729:597:4f97
 with SMTP id d2e1a72fcca58-72dafbd26d3mr8487641b3a.20.1737157327404; Fri, 17
 Jan 2025 15:42:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 15:41:59 -0800
In-Reply-To: <20250117234204.2600624-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117234204.2600624-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117234204.2600624-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: selftests: Make Intel arch events globally available
 in PMU counters test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Wrap PMU counter test's array of Intel architectrual in a helper function
so that the events can be queried in multiple locations.  Add a comment to
explain the need for a wrapper.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86/pmu_counters_test.c     | 84 +++++++++++--------
 1 file changed, 49 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index accd7ecd3e5f..fe7d72fc8a75 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -33,6 +33,53 @@
 static uint8_t kvm_pmu_version;
 static bool kvm_has_perf_caps;
 
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
+struct kvm_intel_pmu_event {
+	struct kvm_x86_pmu_feature gp_event;
+	struct kvm_x86_pmu_feature fixed_event;
+};
+
+/*
+ * Wrap the array to appease the compiler, as the macros used to construct each
+ * kvm_x86_pmu_feature use syntax that's only valid in function scope, and the
+ * compiler often thinks the feature definitions aren't compile-time constants.
+ */
+static struct kvm_intel_pmu_event intel_event_to_feature(uint8_t idx)
+{
+	const struct kvm_intel_pmu_event __intel_event_to_feature[] = {
+		[INTEL_ARCH_CPU_CYCLES_INDEX]		 = { X86_PMU_FEATURE_CPU_CYCLES, X86_PMU_FEATURE_CPU_CYCLES_FIXED },
+		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 = { X86_PMU_FEATURE_INSNS_RETIRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
+		/*
+		 * Note, the fixed counter for reference cycles is NOT the same as the
+		 * general purpose architectural event.  The fixed counter explicitly
+		 * counts at the same frequency as the TSC, whereas the GP event counts
+		 * at a fixed, but uarch specific, frequency.  Bundle them here for
+		 * simplicity.
+		 */
+		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 = { X86_PMU_FEATURE_REFERENCE_CYCLES, X86_PMU_FEATURE_REFERENCE_TSC_CYCLES_FIXED },
+		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 = { X86_PMU_FEATURE_LLC_REFERENCES, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_LLC_MISSES_INDEX]		 = { X86_PMU_FEATURE_LLC_MISSES, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS, X86_PMU_FEATURE_TOPDOWN_SLOTS_FIXED },
+	};
+
+	kvm_static_assert(ARRAY_SIZE(__intel_event_to_feature) == NR_INTEL_ARCH_EVENTS);
+
+	return __intel_event_to_feature[idx];
+}
+
 static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 						  void *guest_code,
 						  uint8_t pmu_version,
@@ -197,41 +244,8 @@ static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_feature even
 		GUEST_TEST_EVENT(idx, event, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, KVM_FEP);
 }
 
-#define X86_PMU_FEATURE_NULL						\
-({									\
-	struct kvm_x86_pmu_feature feature = {};			\
-									\
-	feature;							\
-})
-
-static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
-{
-	return !(*(u64 *)&event);
-}
-
 static void guest_test_arch_event(uint8_t idx)
 {
-	const struct {
-		struct kvm_x86_pmu_feature gp_event;
-		struct kvm_x86_pmu_feature fixed_event;
-	} intel_event_to_feature[] = {
-		[INTEL_ARCH_CPU_CYCLES_INDEX]		 = { X86_PMU_FEATURE_CPU_CYCLES, X86_PMU_FEATURE_CPU_CYCLES_FIXED },
-		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 = { X86_PMU_FEATURE_INSNS_RETIRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
-		/*
-		 * Note, the fixed counter for reference cycles is NOT the same
-		 * as the general purpose architectural event.  The fixed counter
-		 * explicitly counts at the same frequency as the TSC, whereas
-		 * the GP event counts at a fixed, but uarch specific, frequency.
-		 * Bundle them here for simplicity.
-		 */
-		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 = { X86_PMU_FEATURE_REFERENCE_CYCLES, X86_PMU_FEATURE_REFERENCE_TSC_CYCLES_FIXED },
-		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 = { X86_PMU_FEATURE_LLC_REFERENCES, X86_PMU_FEATURE_NULL },
-		[INTEL_ARCH_LLC_MISSES_INDEX]		 = { X86_PMU_FEATURE_LLC_MISSES, X86_PMU_FEATURE_NULL },
-		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED, X86_PMU_FEATURE_NULL },
-		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED, X86_PMU_FEATURE_NULL },
-		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS, X86_PMU_FEATURE_TOPDOWN_SLOTS_FIXED },
-	};
-
 	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	uint32_t pmu_version = guest_get_pmu_version();
 	/* PERF_GLOBAL_CTRL exists only for Architectural PMU Version 2+. */
@@ -249,7 +263,7 @@ static void guest_test_arch_event(uint8_t idx)
 	else
 		base_pmc_msr = MSR_IA32_PERFCTR0;
 
-	gp_event = intel_event_to_feature[idx].gp_event;
+	gp_event = intel_event_to_feature(idx).gp_event;
 	GUEST_ASSERT_EQ(idx, gp_event.f.bit);
 
 	GUEST_ASSERT(nr_gp_counters);
@@ -270,7 +284,7 @@ static void guest_test_arch_event(uint8_t idx)
 	if (!guest_has_perf_global_ctrl)
 		return;
 
-	fixed_event = intel_event_to_feature[idx].fixed_event;
+	fixed_event = intel_event_to_feature(idx).fixed_event;
 	if (pmu_is_null_feature(fixed_event) || !this_pmu_has(fixed_event))
 		return;
 
-- 
2.48.0.rc2.279.g1de40edade-goog


