Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E05E79B3C2
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbjIKUtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236951AbjIKLon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:44:43 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E70CDD;
        Mon, 11 Sep 2023 04:44:38 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 41be03b00d2f7-5778fda7c06so69227a12.3;
        Mon, 11 Sep 2023 04:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694432677; x=1695037477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjlcpOVc8B+eld+MSy+Nl8iijHxzp2oGybmFJViS2Fo=;
        b=h0ptvIUd0cYWwRfVRLiiOHN2EnhCRht2ZeGtiP1sl8/Izo7Fwus1NygsDCMIXIGeS/
         YFojghet4TFeOuG0V/4sO67kODbVI4yj3NG4vA0rSURCknIjw7QnfgdoTvoN5f3r3pZD
         EKPpUGWrnB5XlsOFn6Ppw3WFM1h2JfmklLnobndaTXUDPHW1XhZ/IwZesC5ic8CXuMql
         hM3DMCYSLDigncrkypL+EJniwWZGIHwVaUnb4Y90fvQmxiEtiGPYqzAvzH/IdBwU8xp0
         sWC3zXIujYVw9Ij4nKvgBMVrKXymVvHOiso94qe+ZfSMobZNupAf0Y+UyCuMSSMcB2s2
         EpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694432677; x=1695037477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vjlcpOVc8B+eld+MSy+Nl8iijHxzp2oGybmFJViS2Fo=;
        b=PwmH5LN31ztmS0xKjpUJBsX9ZWfMPlcGeN1Algi0/JleTYN74wwvZwGnioAaRF+5dc
         qgSh3/rdRBGzyAXqcL13mvBPu8bt4f9KbGyYwgQnudNYM7WpVXatnMu9MPt0CKb7rL6U
         O4kU44ED3Tp6u5PTokh9u0GZuCE99fSQD9j2VD7iJPaja5lbpk/rySKyE4lofoCPC6Yk
         uy8la3IxBryRS7mH9Cnk8gt93MSXhdgxJkyVqhMzmoL3znGWmtzJl+9ZpeoPiDcugPso
         BlXeQu21AYDIpVWIkLv3+KeFJjUyq7OdCRi8F7iXoG+tNpSlIaZOzn31/lixj7m/FE/H
         BnFg==
X-Gm-Message-State: AOJu0YwEcKaSM0EEBlbwk4OEk3RwCdAVikk8DOdTE0jGbDJHiBjsD9re
        VbQs0CBHDJhuRgC7fB7Ztlk=
X-Google-Smtp-Source: AGHT+IFlwTyNMbdKQylHOGNCVvVYZrCDrRHo3mAlq41IXhdS7TbFgqGKaKDGIi34F+NDAW2TOL/UfA==
X-Received: by 2002:a17:90a:e144:b0:274:1bb1:415a with SMTP id ez4-20020a17090ae14400b002741bb1415amr1359315pjb.41.1694432677555;
        Mon, 11 Sep 2023 04:44:37 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a10c900b00273f65fa424sm3855390pje.8.2023.09.11.04.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 04:44:37 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/9] KVM: selftests: Add pmu.h for PMU events and common masks
Date:   Mon, 11 Sep 2023 19:43:41 +0800
Message-Id: <20230911114347.85882-4-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911114347.85882-1-cloudliang@tencent.com>
References: <20230911114347.85882-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 tools/testing/selftests/kvm/include/pmu.h     | 96 +++++++++++++++++++
 tools/testing/selftests/kvm/lib/pmu.c         | 38 ++++++++
 .../kvm/x86_64/pmu_event_filter_test.c        | 32 ++-----
 4 files changed, 144 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/pmu.h
 create mode 100644 tools/testing/selftests/kvm/lib/pmu.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 77026907968f..172c4223b286 100644
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
index 000000000000..f9d5bf14cf5f
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/pmu.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * tools/testing/selftests/kvm/include/pmu.h
+ *
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
+
+	NR_REAL_INTEL_ARCH_EVENTS,
+
+	/*
+	 * Pseudo-architectural event used to implement IA32_FIXED_CTR2, a.k.a.
+	 * TSC reference cycles. The architectural reference cycles event may
+	 * or may not actually use the TSC as the reference, e.g. might use the
+	 * core crystal clock or the bus clock (yeah, "architectural").
+	 */
+	PSEUDO_ARCH_REFERENCE_CYCLES = NR_REAL_INTEL_ARCH_EVENTS,
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
index 000000000000..331ddbc12fce
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/pmu.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Kernel-based Virtual Machine -- Selftests Performance Monitoring Unit support
+ *
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
+	[PSEUDO_ARCH_REFERENCE_CYCLES]		= ARCH_EVENT(0xa4, 0x1),
+};
+
+/* mapping between fixed pmc index and intel_arch_events array */
+const int intel_pmu_fixed_pmc_events[] = {
+	[0] = INTEL_ARCH_INSTRUCTIONS_RETIRED,
+	[1] = INTEL_ARCH_CPU_CYCLES,
+	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
+};
+
+const uint64_t amd_pmu_arch_events[] = {
+	[AMD_ZEN_CORE_CYCLES]			= ARCH_EVENT(0x76, 0x00),
+	[AMD_ZEN_INSTRUCTIONS]			= ARCH_EVENT(0xc0, 0x00),
+	[AMD_ZEN_BRANCHES]			= ARCH_EVENT(0xc2, 0x00),
+	[AMD_ZEN_BRANCH_MISSES]			= ARCH_EVENT(0xc3, 0x00),
+};
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index b0b91e6e79fb..b5402327d739 100644
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
2.39.3

