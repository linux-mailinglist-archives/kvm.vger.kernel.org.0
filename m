Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD547D43F6
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbjJXA1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjJXA1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:27:01 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DF610C6
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:50 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9da175faaso26359535ad.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107209; x=1698712009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JwQXCr637BG2GMnZ3Zgjp5AEv/uuEs9akrm/IfbGmL8=;
        b=lkD/UItx0iwqy2N9mYXLbZR//gwHVHVPGnz6SiR0YIplbf45hPVKTom8Bh9jRHdyPV
         nxJpjAPtRF6HDbXU1InMnNTlz7VEWFkxKVcyyVqZnDr5pbRpNE0riYBJeYjYqeYBFlZA
         L0NYOX1ksavUSeaYlkJYPa9Nx1FDeyhUIR39nYz+CBOxA0Jpct2LpJdMkuip09A/cVO/
         0QYEMFDr446/r1LEcLZRXf9dX1Y1YFFKvLHdVjculiRr+92xafSTQoybqHkhxN3rHaEf
         Yi0gB1kmGK/mLeS2gF3fVNl17JWQMMMsimKasUcXL6xq1ZYBzdBdimzkXo1j07XxNtEO
         ZF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107209; x=1698712009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JwQXCr637BG2GMnZ3Zgjp5AEv/uuEs9akrm/IfbGmL8=;
        b=sNqAiaegwS3hjf1+X7aNhXapFQmWIG6aGRmnKDujbuT1U7SaTV/bQVeyqWqTdL0+Ow
         orXBaSXHCPtzjIUdRBtRPiEDo+n4jk8zZ/jnKKQrON0uklvEDal7wdTBwt4CHxx++tw/
         mcVUlkdRn9++qeuhrpMq9uDzhjdpzsgq+dSEx6FtSyq3MGJ+vbUR3QDl9g5Hv4NYOutM
         1qum15+aKJZ7e7ihaWcporIY59jUyaP1ududbKJSDd8lkDXZ1T9J48/k7plEszYSKVLj
         BVH5KAhHhJKagAI1KNaDn+z+WEnchKKc30D7VlIuicKIDQMwbLiw9/pjCWGnCebWyGlY
         r5EQ==
X-Gm-Message-State: AOJu0YxhW3aaBFfyOE0/BTbog+VVM8fjdvEq67F2d7WYkOp9rJf/XYMc
        HdT5xWbHytsQKXCrKjenl01DNk+fxBc=
X-Google-Smtp-Source: AGHT+IEu3I4uiKbU26E88MDgAwwhBZ4BcB4rIdfnbCGFn2Zlm14a8UPDjIpdwi4pYa6cAWF9VWcuf1knKJ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab5a:b0:1bf:cc5:7b53 with SMTP id
 ij26-20020a170902ab5a00b001bf0cc57b53mr198433plb.1.1698107209479; Mon, 23 Oct
 2023 17:26:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 17:26:27 -0700
In-Reply-To: <20231024002633.2540714-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024002633.2540714-8-seanjc@google.com>
Subject: [PATCH v5 07/13] KVM: selftests: Add pmu.h and lib/pmu.c for common
 PMU assets
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

By defining the PMU performance events and masks relevant for x86 in
the new pmu.h and pmu.c, it becomes easier to reference them, minimizing
potential errors in code that handles these values.

Clean up pmu_event_filter_test.c by including pmu.h and removing
unnecessary macros.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
[sean: drop PSEUDO_ARCH_REFERENCE_CYCLES]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 tools/testing/selftests/kvm/include/pmu.h     | 84 +++++++++++++++++++
 tools/testing/selftests/kvm/lib/pmu.c         | 28 +++++++
 .../kvm/x86_64/pmu_event_filter_test.c        | 32 ++-----
 4 files changed, 122 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/pmu.h
 create mode 100644 tools/testing/selftests/kvm/lib/pmu.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index fb01c3f8d3da..ed1c17cabc07 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -23,6 +23,7 @@ LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
 LIBKVM += lib/memstress.c
+LIBKVM += lib/pmu.c
 LIBKVM += lib/guest_sprintf.c
 LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
diff --git a/tools/testing/selftests/kvm/include/pmu.h b/tools/testing/selftests/kvm/include/pmu.h
new file mode 100644
index 000000000000..987602c62b51
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/pmu.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2023, Tencent, Inc.
+ */
+#ifndef SELFTEST_KVM_PMU_H
+#define SELFTEST_KVM_PMU_H
+
+#include <stdint.h>
+
+#define X86_PMC_IDX_MAX				64
+#define INTEL_PMC_MAX_GENERIC				32
+#define KVM_PMU_EVENT_FILTER_MAX_EVENTS		300
+
+#define GP_COUNTER_NR_OFS_BIT				8
+#define EVENT_LENGTH_OFS_BIT				24
+
+#define PMU_VERSION_MASK				GENMASK_ULL(7, 0)
+#define EVENT_LENGTH_MASK				GENMASK_ULL(31, EVENT_LENGTH_OFS_BIT)
+#define GP_COUNTER_NR_MASK				GENMASK_ULL(15, GP_COUNTER_NR_OFS_BIT)
+#define FIXED_COUNTER_NR_MASK				GENMASK_ULL(4, 0)
+
+#define ARCH_PERFMON_EVENTSEL_EVENT			GENMASK_ULL(7, 0)
+#define ARCH_PERFMON_EVENTSEL_UMASK			GENMASK_ULL(15, 8)
+#define ARCH_PERFMON_EVENTSEL_USR			BIT_ULL(16)
+#define ARCH_PERFMON_EVENTSEL_OS			BIT_ULL(17)
+#define ARCH_PERFMON_EVENTSEL_EDGE			BIT_ULL(18)
+#define ARCH_PERFMON_EVENTSEL_PIN_CONTROL		BIT_ULL(19)
+#define ARCH_PERFMON_EVENTSEL_INT			BIT_ULL(20)
+#define ARCH_PERFMON_EVENTSEL_ANY			BIT_ULL(21)
+#define ARCH_PERFMON_EVENTSEL_ENABLE			BIT_ULL(22)
+#define ARCH_PERFMON_EVENTSEL_INV			BIT_ULL(23)
+#define ARCH_PERFMON_EVENTSEL_CMASK			GENMASK_ULL(31, 24)
+
+#define PMC_MAX_FIXED					16
+#define PMC_IDX_FIXED					32
+
+/* RDPMC offset for Fixed PMCs */
+#define PMC_FIXED_RDPMC_BASE				BIT_ULL(30)
+#define PMC_FIXED_RDPMC_METRICS			BIT_ULL(29)
+
+#define FIXED_BITS_MASK				0xFULL
+#define FIXED_BITS_STRIDE				4
+#define FIXED_0_KERNEL					BIT_ULL(0)
+#define FIXED_0_USER					BIT_ULL(1)
+#define FIXED_0_ANYTHREAD				BIT_ULL(2)
+#define FIXED_0_ENABLE_PMI				BIT_ULL(3)
+
+#define fixed_bits_by_idx(_idx, _bits)			\
+	((_bits) << ((_idx) * FIXED_BITS_STRIDE))
+
+#define AMD64_NR_COUNTERS				4
+#define AMD64_NR_COUNTERS_CORE				6
+
+#define PMU_CAP_FW_WRITES				BIT_ULL(13)
+#define PMU_CAP_LBR_FMT				0x3f
+
+enum intel_pmu_architectural_events {
+	/*
+	 * The order of the architectural events matters as support for each
+	 * event is enumerated via CPUID using the index of the event.
+	 */
+	INTEL_ARCH_CPU_CYCLES,
+	INTEL_ARCH_INSTRUCTIONS_RETIRED,
+	INTEL_ARCH_REFERENCE_CYCLES,
+	INTEL_ARCH_LLC_REFERENCES,
+	INTEL_ARCH_LLC_MISSES,
+	INTEL_ARCH_BRANCHES_RETIRED,
+	INTEL_ARCH_BRANCHES_MISPREDICTED,
+	NR_INTEL_ARCH_EVENTS,
+};
+
+enum amd_pmu_k7_events {
+	AMD_ZEN_CORE_CYCLES,
+	AMD_ZEN_INSTRUCTIONS,
+	AMD_ZEN_BRANCHES,
+	AMD_ZEN_BRANCH_MISSES,
+	NR_AMD_ARCH_EVENTS,
+};
+
+extern const uint64_t intel_pmu_arch_events[];
+extern const uint64_t amd_pmu_arch_events[];
+extern const int intel_pmu_fixed_pmc_events[];
+
+#endif /* SELFTEST_KVM_PMU_H */
diff --git a/tools/testing/selftests/kvm/lib/pmu.c b/tools/testing/selftests/kvm/lib/pmu.c
new file mode 100644
index 000000000000..27a6c35f98a1
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/pmu.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023, Tencent, Inc.
+ */
+
+#include <stdint.h>
+
+#include "pmu.h"
+
+/* Definitions for Architectural Performance Events */
+#define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) << 8)
+
+const uint64_t intel_pmu_arch_events[] = {
+	[INTEL_ARCH_CPU_CYCLES]			= ARCH_EVENT(0x3c, 0x0),
+	[INTEL_ARCH_INSTRUCTIONS_RETIRED]	= ARCH_EVENT(0xc0, 0x0),
+	[INTEL_ARCH_REFERENCE_CYCLES]		= ARCH_EVENT(0x3c, 0x1),
+	[INTEL_ARCH_LLC_REFERENCES]		= ARCH_EVENT(0x2e, 0x4f),
+	[INTEL_ARCH_LLC_MISSES]			= ARCH_EVENT(0x2e, 0x41),
+	[INTEL_ARCH_BRANCHES_RETIRED]		= ARCH_EVENT(0xc4, 0x0),
+	[INTEL_ARCH_BRANCHES_MISPREDICTED]	= ARCH_EVENT(0xc5, 0x0),
+};
+
+const uint64_t amd_pmu_arch_events[] = {
+	[AMD_ZEN_CORE_CYCLES]			= ARCH_EVENT(0x76, 0x00),
+	[AMD_ZEN_INSTRUCTIONS]			= ARCH_EVENT(0xc0, 0x00),
+	[AMD_ZEN_BRANCHES]			= ARCH_EVENT(0xc2, 0x00),
+	[AMD_ZEN_BRANCH_MISSES]			= ARCH_EVENT(0xc3, 0x00),
+};
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 283cc55597a4..b6e4f57a8651 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -11,31 +11,18 @@
  */
 
 #define _GNU_SOURCE /* for program_invocation_short_name */
-#include "test_util.h"
+
 #include "kvm_util.h"
+#include "pmu.h"
 #include "processor.h"
-
-/*
- * In lieu of copying perf_event.h into tools...
- */
-#define ARCH_PERFMON_EVENTSEL_OS			(1ULL << 17)
-#define ARCH_PERFMON_EVENTSEL_ENABLE			(1ULL << 22)
-
-/* End of stuff taken from perf_event.h. */
-
-/* Oddly, this isn't in perf_event.h. */
-#define ARCH_PERFMON_BRANCHES_RETIRED		5
+#include "test_util.h"
 
 #define NUM_BRANCHES 42
-#define INTEL_PMC_IDX_FIXED		32
-
-/* Matches KVM_PMU_EVENT_FILTER_MAX_EVENTS in pmu.c */
-#define MAX_FILTER_EVENTS		300
 #define MAX_TEST_EVENTS		10
 
 #define PMU_EVENT_FILTER_INVALID_ACTION		(KVM_PMU_EVENT_DENY + 1)
 #define PMU_EVENT_FILTER_INVALID_FLAGS			(KVM_PMU_EVENT_FLAGS_VALID_MASK << 1)
-#define PMU_EVENT_FILTER_INVALID_NEVENTS		(MAX_FILTER_EVENTS + 1)
+#define PMU_EVENT_FILTER_INVALID_NEVENTS		(KVM_PMU_EVENT_FILTER_MAX_EVENTS + 1)
 
 /*
  * This is how the event selector and unit mask are stored in an AMD
@@ -63,7 +50,6 @@
 
 #define AMD_ZEN_BR_RETIRED EVENT(0xc2, 0)
 
-
 /*
  * "Retired instructions", from Processor Programming Reference
  * (PPR) for AMD Family 17h Model 01h, Revision B1 Processors,
@@ -84,7 +70,7 @@ struct __kvm_pmu_event_filter {
 	__u32 fixed_counter_bitmap;
 	__u32 flags;
 	__u32 pad[4];
-	__u64 events[MAX_FILTER_EVENTS];
+	__u64 events[KVM_PMU_EVENT_FILTER_MAX_EVENTS];
 };
 
 /*
@@ -729,14 +715,14 @@ static void add_dummy_events(uint64_t *events, int nevents)
 
 static void test_masked_events(struct kvm_vcpu *vcpu)
 {
-	int nevents = MAX_FILTER_EVENTS - MAX_TEST_EVENTS;
-	uint64_t events[MAX_FILTER_EVENTS];
+	int nevents = KVM_PMU_EVENT_FILTER_MAX_EVENTS - MAX_TEST_EVENTS;
+	uint64_t events[KVM_PMU_EVENT_FILTER_MAX_EVENTS];
 
 	/* Run the test cases against a sparse PMU event filter. */
 	run_masked_events_tests(vcpu, events, 0);
 
 	/* Run the test cases against a dense PMU event filter. */
-	add_dummy_events(events, MAX_FILTER_EVENTS);
+	add_dummy_events(events, KVM_PMU_EVENT_FILTER_MAX_EVENTS);
 	run_masked_events_tests(vcpu, events, nevents);
 }
 
@@ -818,7 +804,7 @@ static void intel_run_fixed_counter_guest_code(uint8_t fixed_ctr_idx)
 		/* Only OS_EN bit is enabled for fixed counter[idx]. */
 		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * fixed_ctr_idx));
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL,
-		      BIT_ULL(INTEL_PMC_IDX_FIXED + fixed_ctr_idx));
+		      BIT_ULL(PMC_IDX_FIXED + fixed_ctr_idx));
 		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 
-- 
2.42.0.758.gaed0368e0e-goog

