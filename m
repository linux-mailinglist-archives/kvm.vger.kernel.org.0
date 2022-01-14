Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C6848E21A
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 02:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbiANBVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 20:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238670AbiANBV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 20:21:28 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED97C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:28 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id p8-20020a25bd48000000b00611be5dd7eeso7273767ybm.19
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ygEqYsMUWwM4fR5oRpK1sOvvClQlASwcyjWJzTeyT94=;
        b=EHAmGhmFPjmDGG2mMeGxVWpzj9/q8Q4uJs6Z9zBtHzocwY8jw/FLT3TBCvRTprX0Kz
         XrZv/VH4l99Hs9CuRXds6hsFhB494Tt2HEGS3w3UDSSWw3FKY+cIM2GGVVHBpSjcsgZ3
         3lWEaqa/QSq79sIqkdaxcQAnTh6Uv2iIJAuf3QhhWpcZZpl668o+zeYUaDPVOVzuG2U6
         v3iv4JaM36JrVcsKA/uMGPYp7UXHYvz4795JzFoz9QF6DxQXLTQ48WT9xIfvP56tMTbY
         XLtpnmkiIYNiqIg2aeHEsfMJR6ijq7+A5hNhgrLEIdJUgVUZ7Era2/sEj+sWN6PFhioL
         5NFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ygEqYsMUWwM4fR5oRpK1sOvvClQlASwcyjWJzTeyT94=;
        b=Yft5xkglGFVaoQVru9EbsdikKMOHad8gqmHGdvIOQKAgDjtHCYy+FXmvxDsn1qpnJl
         ft1k1+zAqHMrsYCJcxSI/vGrNCgFLC5nsFtpBff55KYffkkXlK8zIcxXB0rc22JBONUr
         2IB8SKi7yCW5Pn18aiIQnTy+By7XAl8vlJT7vJCIH+F1T/ooGEWQ+Yp4r/c5f1CvFgsb
         k+Wi5VxJZHmuqfMI3/8Weytp4CMNU+5FZ/MOXfGxrW6bJNYOk7QGP1EQ85s/K81hIHMx
         TlLtaQb5KnDtfs4tr0QSrXqsvgRy2lBfSX/IXoy8s1L3yQlJiNBiWsPsnKXTbRaL37pk
         iRuw==
X-Gm-Message-State: AOAM531TJ24mkkxGnv/dcNKpvEJk9Vi8FCkW8rvOpz1oMMIwRkglbmWq
        9ihQ8uSg01y4PYUIYXJ7LidrHMB3LHUd92fKS/Aw9vbjbU6N8Q33d+KkrqLgvKx7ltYPCqIjKA1
        uo17aA9s7BSwGndzjIaJPD+N/n3lfKPC2q7JKreXGCmQAYJEyBcr6m6nwR0idPsE=
X-Google-Smtp-Source: ABdhPJwJfkfe/jfRom5GrkTBQjmhzzt7hi6XPy43nQYGFDeE6xEBzZS9oEQtZB+m77p1wRzor66CccAdCnPcmw==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a05:6902:1209:: with SMTP id
 s9mr9946350ybu.48.1642123287333; Thu, 13 Jan 2022 17:21:27 -0800 (PST)
Date:   Thu, 13 Jan 2022 17:21:09 -0800
In-Reply-To: <20220114012109.153448-1-jmattson@google.com>
Message-Id: <20220114012109.153448-7-jmattson@google.com>
Mime-Version: 1.0
References: <20220114012109.153448-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 6/6] selftests: kvm/x86: Add test for KVM_SET_PMU_EVENT_FILTER
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        daviddunn@google.com, cloudliang@tencent.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that the PMU event filter works as expected.

Note that the virtual PMU doesn't work as expected on AMD Zen CPUs (an
intercepted rdmsr appears to be counted as a retired branch
instruction), but the PMU event filter does work.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/pmu_event_filter_test.c        | 306 ++++++++++++++++++
 3 files changed, 308 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 8c129961accf..7834e03ab159 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -22,6 +22,7 @@
 /x86_64/mmio_warning_test
 /x86_64/mmu_role_test
 /x86_64/platform_info_test
+/x86_64/pmu_event_filter_test
 /x86_64/set_boot_cpu_id
 /x86_64/set_sregs_test
 /x86_64/sev_migrate_tests
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c407ebbec2c1..899413a6588f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -56,6 +56,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
+TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
 TEST_GEN_PROGS_x86_64 += x86_64/smm_test
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
new file mode 100644
index 000000000000..8ac99d4cbc73
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -0,0 +1,306 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test for x86 KVM_SET_PMU_EVENT_FILTER.
+ *
+ * Copyright (C) 2022, Google LLC.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * Verifies the expected behavior of allow lists and deny lists for
+ * virtual PMU events.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+/*
+ * In lieue of copying perf_event.h into tools...
+ */
+#define ARCH_PERFMON_EVENTSEL_ENABLE	BIT(22)
+#define ARCH_PERFMON_EVENTSEL_OS	BIT(17)
+
+#define VCPU_ID 0
+#define NUM_BRANCHES 42
+
+/*
+ * This is how the event selector and unit mask are stored in an AMD
+ * core performance event-select register. Intel's format is similar,
+ * but the event selector is only 8 bits.
+ */
+#define EVENT(select, umask) ((select & 0xf00UL) << 24 | (select & 0xff) | \
+			      (umask & 0xff) << 8)
+
+/*
+ * "Branch instructions retired", from the Intel SDM, volume 3,
+ * "Pre-defined Architectural Performance Events."
+ */
+
+#define INTEL_BR_RETIRED EVENT(0xc4, 0)
+
+/*
+ * "Retired branch instructions", from Processor Programming Reference
+ * (PPR) for AMD Family 17h Model 01h, Revision B1 Processors,
+ * Preliminary Processor Programming Reference (PPR) for AMD Family
+ * 17h Model 31h, Revision B0 Processors, and Preliminary Processor
+ * Programming Reference (PPR) for AMD Family 19h Model 01h, Revision
+ * B1 Processors Volume 1 of 2
+ */
+
+#define AMD_ZEN_BR_RETIRED EVENT(0xc2, 0)
+
+/*
+ * This event list comprises Intel's eight architectural events plus
+ * AMD's "branch instructions retired" for Zen[123].
+ */
+static const uint64_t event_list[] = {
+	EVENT(0x3c, 0),
+	EVENT(0xc0, 0),
+	EVENT(0x3c, 1),
+	EVENT(0x2e, 0x4f),
+	EVENT(0x2e, 0x41),
+	EVENT(0xc4, 0),
+	EVENT(0xc5, 0),
+	EVENT(0xa4, 1),
+	AMD_ZEN_BR_RETIRED,
+};
+
+static void intel_guest_code(void)
+{
+	uint64_t br0, br1;
+
+	for (;;) {
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+		wrmsr(MSR_P6_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | INTEL_BR_RETIRED);
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 1);
+		br0 = rdmsr(MSR_IA32_PMC0);
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+		br1 = rdmsr(MSR_IA32_PMC0);
+		GUEST_SYNC(br1 - br0);
+	}
+}
+
+/*
+ * To avoid needing a check for CPUID.80000001:ECX.PerfCtrExtCore[bit
+ * 23], this code uses the always-available, legacy K7 PMU MSRs, which
+ * alias to the first four of the six extended core PMU MSRs.
+ */
+static void amd_guest_code(void)
+{
+	uint64_t br0, br1;
+
+	for (;;) {
+		wrmsr(MSR_K7_EVNTSEL0, 0);
+		wrmsr(MSR_K7_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | AMD_ZEN_BR_RETIRED);
+		br0 = rdmsr(MSR_K7_PERFCTR0);
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+		br1 = rdmsr(MSR_K7_PERFCTR0);
+		GUEST_SYNC(br1 - br0);
+	}
+}
+
+static uint64_t test_branches_retired(struct kvm_vm *vm)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct ucall uc;
+
+	vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+	get_ucall(vm, VCPU_ID, &uc);
+	TEST_ASSERT(uc.cmd == UCALL_SYNC,
+		    "Received ucall other than UCALL_SYNC: %lu", uc.cmd);
+	return uc.args[1];
+}
+
+static struct kvm_pmu_event_filter *make_pmu_event_filter(uint32_t nevents)
+{
+	struct kvm_pmu_event_filter *f;
+	int size = sizeof(*f) + nevents * sizeof(f->events[0]);
+
+	f = malloc(size);
+	TEST_ASSERT(f, "Out of memory");
+	memset(f, 0, size);
+	f->nevents = nevents;
+	return f;
+}
+
+static struct kvm_pmu_event_filter *event_filter(uint32_t action)
+{
+	struct kvm_pmu_event_filter *f;
+	int i;
+
+	f = make_pmu_event_filter(ARRAY_SIZE(event_list));
+	f->action = action;
+	for (i = 0; i < ARRAY_SIZE(event_list); i++)
+		f->events[i] = event_list[i];
+
+	return f;
+}
+
+static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
+						 uint64_t event)
+{
+	bool found = false;
+	int i;
+
+	for (i = 0; i < f->nevents; i++) {
+		if (found)
+			f->events[i - 1] = f->events[i];
+		else
+			found = f->events[i] == event;
+	}
+	if (found)
+		f->nevents--;
+	return f;
+}
+
+static void test_no_filter(struct kvm_vm *vm)
+{
+	uint64_t count = test_branches_retired(vm);
+
+	if (count != NUM_BRANCHES)
+		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
+			__func__, count, NUM_BRANCHES);
+	TEST_ASSERT(count, "Allowed PMU event is not counting");
+}
+
+static uint64_t test_with_filter(struct kvm_vm *vm,
+				 struct kvm_pmu_event_filter *f)
+{
+	vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
+	return test_branches_retired(vm);
+}
+
+static void test_member_deny_list(struct kvm_vm *vm)
+{
+	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
+	uint64_t count = test_with_filter(vm, f);
+
+	free(f);
+	if (count)
+		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",
+			__func__, count);
+	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
+}
+
+static void test_member_allow_list(struct kvm_vm *vm)
+{
+	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
+	uint64_t count = test_with_filter(vm, f);
+
+	free(f);
+	if (count != NUM_BRANCHES)
+		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
+			__func__, count, NUM_BRANCHES);
+	TEST_ASSERT(count, "Allowed PMU event is not counting");
+}
+
+static void test_not_member_deny_list(struct kvm_vm *vm)
+{
+	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
+	uint64_t count;
+
+	remove_event(f, INTEL_BR_RETIRED);
+	remove_event(f, AMD_ZEN_BR_RETIRED);
+	count = test_with_filter(vm, f);
+	free(f);
+	if (count != NUM_BRANCHES)
+		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
+			__func__, count, NUM_BRANCHES);
+	TEST_ASSERT(count, "Allowed PMU event is not counting");
+}
+
+static void test_not_member_allow_list(struct kvm_vm *vm)
+{
+	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
+	uint64_t count;
+
+	remove_event(f, INTEL_BR_RETIRED);
+	remove_event(f, AMD_ZEN_BR_RETIRED);
+	count = test_with_filter(vm, f);
+	free(f);
+	if (count)
+		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",
+			__func__, count);
+	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
+}
+
+/*
+ * Note that CPUID leaf 0xa is Intel-specific. This leaf should be
+ * clear on AMD hardware.
+ */
+static bool vcpu_supports_intel_br_retired(void)
+{
+	struct kvm_cpuid_entry2 *entry;
+	struct kvm_cpuid2 *cpuid;
+
+	cpuid = kvm_get_supported_cpuid();
+	entry = kvm_get_supported_cpuid_index(0xa, 0);
+	return entry &&
+		(entry->eax & 0xff) &&
+		(entry->eax >> 24) > 5 &&
+		!(entry->ebx & BIT(5));
+}
+
+/*
+ * Determining AMD support for a PMU event requires consulting the AMD
+ * PPR for the CPU or reference material derived therefrom.
+ */
+static bool vcpu_supports_amd_zen_br_retired(void)
+{
+	struct kvm_cpuid_entry2 *entry;
+	struct kvm_cpuid2 *cpuid;
+
+	cpuid = kvm_get_supported_cpuid();
+	entry = kvm_get_supported_cpuid_index(1, 0);
+	return entry &&
+		((x86_family(entry->eax) == 0x17 &&
+		  (x86_model(entry->eax) == 1 ||
+		   x86_model(entry->eax) == 0x31)) ||
+		 (x86_family(entry->eax) == 0x19 &&
+		  x86_model(entry->eax) == 1));
+}
+
+int main(int argc, char *argv[])
+{
+	void (*guest_code)(void) = NULL;
+	struct kvm_vm *vm;
+	int r;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	r = kvm_check_cap(KVM_CAP_PMU_EVENT_FILTER);
+	if (!r) {
+		print_skip("KVM_CAP_PMU_EVENT_FILTER not supported");
+		exit(KSFT_SKIP);
+	}
+
+	if (vcpu_supports_intel_br_retired())
+		guest_code = intel_guest_code;
+	else if (vcpu_supports_amd_zen_br_retired())
+		guest_code = amd_guest_code;
+
+	if (!guest_code) {
+		print_skip("Branch instructions retired not supported");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+
+	test_no_filter(vm);
+	test_member_deny_list(vm);
+	test_member_allow_list(vm);
+	test_not_member_deny_list(vm);
+	test_not_member_allow_list(vm);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.34.1.703.g22d0c6ccf7-goog

