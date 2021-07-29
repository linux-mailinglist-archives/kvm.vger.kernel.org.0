Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC483DAA46
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 19:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhG2RdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 13:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbhG2RdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 13:33:13 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E27EC061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:33:10 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id bm25-20020a05620a1999b02903a9c3f8b89fso4225291qkb.2
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sKMrrP4voAV9C0PWJBEJj1iHoBcibmGqJfqIyZQerFw=;
        b=kM32+O8pEFxYs/NnkaadiOH2eEuOwk3MLulsiUcYgEI3IqKZFcVvGHgi+8c1H5Apoy
         IosAL6iJeLKRwrycRO5lxX+Ogi3dVl5EJv/hM711qzc5oIRi/iZn+AO2evoGa8EJQquu
         mkeJiBBtolzi6tFKAPdpy8rrg+kpGi9wn0fhywx+yCIr92UVN9M39IjSTKlyxiViP2/g
         QFxHTwchsBhSZ7E6mGH1sHc1c0rHvdAhGitFNkopKHI1KXFKnUA/99QaWybRhbz/DBoC
         pE0x+sN4XuJaQ4I6WLWEVmjuB5qKeimdtrdQlCFqwpvM3aZ2qdJodbSuXyYSRCDo0XS+
         EKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sKMrrP4voAV9C0PWJBEJj1iHoBcibmGqJfqIyZQerFw=;
        b=CvPMdxsTs709mFNUzvtH1m5BcZb7WH5aXOnw7WQz44sRaUd9dubC22EB4wxKOB0KMv
         y0oljVleHwfGkqKmY52kGCp1Tfh8Bdmo1qrZhiyhoQO3nj5QQNyTgOnvMF4jzIaSEt86
         Doq40GEX8asIUieDTY51S6Zom51BftROi9P/tWwG6aKlkUIOSCn8V8YmFZViOWpbbC9y
         tMXU7SjdxnroyPC7GnZJdHWmglYwyKzAcYG+p75aHRZejhqJ21fuhUR2N/34wEsKJ1ft
         pOBgpnZIVd33IPdW8Q3WH4CsX45ruZL0jtEv/T8dvVRGEzXSTLB+R/bvAhosE3QKNqki
         WBQQ==
X-Gm-Message-State: AOAM530l2gqYoymsyRVtmaQ+KQVfZfojheadSOmjLLWf6+cpjCPL1nnV
        vx2OahNmcjvDubu6KNmoVPyUVSabFn8QQmEWf+TvlvsdCmqmDCKvl6ezGaT+Qm00AWd3nWhUyYE
        kC/Y9vtlM5wgZpiyiTDIRePkeaPDqRNdwzGMuV0bdWroNcl4nYmJVMBeoow==
X-Google-Smtp-Source: ABdhPJzQIbA9Ui+hj36tEeWjXnbDHAuE+zWBxIC2YH1neGEAyqlkpRzTxf3VK9gUpqUubQYQZ5QJVnLAjTI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:d08:: with SMTP id
 8mr6511329qvh.32.1627579989084; Thu, 29 Jul 2021 10:33:09 -0700 (PDT)
Date:   Thu, 29 Jul 2021 17:32:52 +0000
In-Reply-To: <20210729173300.181775-1-oupton@google.com>
Message-Id: <20210729173300.181775-6-oupton@google.com>
Mime-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v5 05/13] selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a selftest for the new KVM clock UAPI that was introduced. Ensure
that the KVM clock is consistent between userspace and the guest, and
that the difference in realtime will only ever cause the KVM clock to
advance forward.

Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/x86_64/kvm_clock_test.c     | 204 ++++++++++++++++++
 4 files changed, 208 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 36896d251977..958a809c8de4 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -11,6 +11,7 @@
 /x86_64/emulator_error_test
 /x86_64/get_cpuid_test
 /x86_64/get_msr_index_features
+/x86_64/kvm_clock_test
 /x86_64/kvm_pv_test
 /x86_64/hyperv_clock
 /x86_64/hyperv_cpuid
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c103873531e0..0f94b18b33ce 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -46,6 +46,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
+TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 010b59b13917..a8ac5d52e17b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -19,6 +19,8 @@
 #define KVM_DEV_PATH "/dev/kvm"
 #define KVM_MAX_VCPUS 512
 
+#define NSEC_PER_SEC 1000000000L
+
 /*
  * Callers of kvm_util only have an incomplete/opaque description of the
  * structure kvm_util is using to maintain the state of a VM.
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
new file mode 100644
index 000000000000..e0dcc27ae9f1
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021, Google LLC.
+ *
+ * Tests for adjusting the KVM clock from userspace
+ */
+#include <asm/kvm_para.h>
+#include <asm/pvclock.h>
+#include <asm/pvclock-abi.h>
+#include <stdint.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <time.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID 0
+
+struct test_case {
+	uint64_t kvmclock_base;
+	int64_t realtime_offset;
+};
+
+static struct test_case test_cases[] = {
+	{ .kvmclock_base = 0 },
+	{ .kvmclock_base = 180 * NSEC_PER_SEC },
+	{ .kvmclock_base = 0, .realtime_offset = -180 * NSEC_PER_SEC },
+	{ .kvmclock_base = 0, .realtime_offset = 180 * NSEC_PER_SEC },
+};
+
+#define GUEST_SYNC_CLOCK(__stage, __val)			\
+		GUEST_SYNC_ARGS(__stage, __val, 0, 0, 0)
+
+static void guest_main(vm_paddr_t pvti_pa, struct pvclock_vcpu_time_info *pvti)
+{
+	int i;
+
+	wrmsr(MSR_KVM_SYSTEM_TIME_NEW, pvti_pa | KVM_MSR_ENABLED);
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
+		GUEST_SYNC_CLOCK(i, __pvclock_read_cycles(pvti, rdtsc()));
+}
+
+#define EXPECTED_FLAGS (KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
+
+static inline void assert_flags(struct kvm_clock_data *data)
+{
+	TEST_ASSERT((data->flags & EXPECTED_FLAGS) == EXPECTED_FLAGS,
+		    "unexpected clock data flags: %x (want set: %x)",
+		    data->flags, EXPECTED_FLAGS);
+}
+
+static void handle_sync(struct ucall *uc, struct kvm_clock_data *start,
+			struct kvm_clock_data *end)
+{
+	uint64_t obs, exp_lo, exp_hi;
+
+	obs = uc->args[2];
+	exp_lo = start->clock;
+	exp_hi = end->clock;
+
+	assert_flags(start);
+	assert_flags(end);
+
+	TEST_ASSERT(exp_lo <= obs && obs <= exp_hi,
+		    "unexpected kvm-clock value: %"PRIu64" expected range: [%"PRIu64", %"PRIu64"]",
+		    obs, exp_lo, exp_hi);
+
+	pr_info("kvm-clock value: %"PRIu64" expected range [%"PRIu64", %"PRIu64"]\n",
+		obs, exp_lo, exp_hi);
+}
+
+static void handle_abort(struct ucall *uc)
+{
+	TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0],
+		  __FILE__, uc->args[1]);
+}
+
+static void setup_clock(struct kvm_vm *vm, struct test_case *test_case)
+{
+	struct kvm_clock_data data;
+
+	memset(&data, 0, sizeof(data));
+
+	data.clock = test_case->kvmclock_base;
+	if (test_case->realtime_offset) {
+		struct timespec ts;
+		int r;
+
+		data.flags |= KVM_CLOCK_REALTIME;
+		do {
+			r = clock_gettime(CLOCK_REALTIME, &ts);
+			if (!r)
+				break;
+		} while (errno == EINTR);
+
+		TEST_ASSERT(!r, "clock_gettime() failed: %d\n", r);
+
+		data.realtime = ts.tv_sec * NSEC_PER_SEC;
+		data.realtime += ts.tv_nsec;
+		data.realtime += test_case->realtime_offset;
+	}
+
+	vm_ioctl(vm, KVM_SET_CLOCK, &data);
+}
+
+static void enter_guest(struct kvm_vm *vm)
+{
+	struct kvm_clock_data start, end;
+	struct kvm_run *run;
+	struct ucall uc;
+	int i, r;
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		setup_clock(vm, &test_cases[i]);
+
+		vm_ioctl(vm, KVM_GET_CLOCK, &start);
+
+		r = _vcpu_run(vm, VCPU_ID);
+		vm_ioctl(vm, KVM_GET_CLOCK, &end);
+
+		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "unexpected exit reason: %u (%s)",
+			    run->exit_reason, exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			handle_sync(&uc, &start, &end);
+			break;
+		case UCALL_ABORT:
+			handle_abort(&uc);
+			return;
+		default:
+			TEST_ASSERT(0, "unhandled ucall: %ld\n",
+				    get_ucall(vm, VCPU_ID, &uc));
+		}
+	}
+}
+
+#define CLOCKSOURCE_PATH "/sys/devices/system/clocksource/clocksource0/current_clocksource"
+
+static void check_clocksource(void)
+{
+	char *clk_name;
+	struct stat st;
+	FILE *fp;
+
+	fp = fopen(CLOCKSOURCE_PATH, "r");
+	if (!fp) {
+		pr_info("failed to open clocksource file: %d; assuming TSC.\n",
+			errno);
+		return;
+	}
+
+	if (fstat(fileno(fp), &st)) {
+		pr_info("failed to stat clocksource file: %d; assuming TSC.\n",
+			errno);
+		goto out;
+	}
+
+	clk_name = malloc(st.st_size);
+	TEST_ASSERT(clk_name, "failed to allocate buffer to read file\n");
+
+	if (!fgets(clk_name, st.st_size, fp)) {
+		pr_info("failed to read clocksource file: %d; assuming TSC.\n",
+			ferror(fp));
+		goto out;
+	}
+
+	TEST_ASSERT(!strncmp(clk_name, "tsc\n", st.st_size),
+		    "clocksource not supported: %s", clk_name);
+out:
+	fclose(fp);
+}
+
+int main(void)
+{
+	vm_vaddr_t pvti_gva;
+	vm_paddr_t pvti_gpa;
+	struct kvm_vm *vm;
+	int flags;
+
+	flags = kvm_check_cap(KVM_CAP_ADJUST_CLOCK);
+	if (!(flags & KVM_CLOCK_REALTIME)) {
+		print_skip("KVM_CLOCK_REALTIME not supported; flags: %x",
+			   flags);
+		exit(KSFT_SKIP);
+	}
+
+	check_clocksource();
+
+	vm = vm_create_default(VCPU_ID, 0, guest_main);
+
+	pvti_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000);
+	pvti_gpa = addr_gva2gpa(vm, pvti_gva);
+	vcpu_args_set(vm, VCPU_ID, 2, pvti_gpa, pvti_gva);
+
+	enter_guest(vm);
+	kvm_vm_free(vm);
+}
-- 
2.32.0.432.gabb21c7263-goog

