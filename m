Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397863CBE97
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 23:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbhGPV3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 17:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236393AbhGPV3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 17:29:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9829DC06175F
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:26:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l16-20020a25cc100000b0290558245b7eabso14373035ybf.10
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Pe/S/uzS2wg1+TTNiX12UiCpgPQMvxwQXCZew3HD/LI=;
        b=HRIndiZDHqG4a429OLA52uU4DdKljsWNo+D+3dxof3wfBygE3ow3/sixI+Rj+aeddG
         5XwNbhgkHO3aumyP5aelfjFIKyJCKos98oErPbcW75b/CY2lHzXEbZyD/ZFxM5itpJjU
         nr+WB8Qvb4p/lsBip0EP58lhsAmgIBy3eicfwDkTm4CgBiu99rNIIP1lCEfwZ1qwrUqX
         Wg2/ro4y/8Fkx7u4cbe18WY3h105D7N7enYVBpjq0FThSNT1ylYQFpRf4oSZHi1ywYBL
         auwrXMTcf2hUH5pMPYnCyjbA8EUiKdFUyFJ7xA6dTumq9KfliPElMuucomcsw8IC2Fl+
         sxaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Pe/S/uzS2wg1+TTNiX12UiCpgPQMvxwQXCZew3HD/LI=;
        b=Du7bkP11TTO0qwsbBwO52SNAEFGFWjfBDBJAuIQYm0ylJUNUX28aP98/ToMSegntWh
         xWVkoFFGOaRgXENESaOjrf23x2LcpA2+JSMNr44CF5B6QbW7Dlx+taUM2w9YbzSZKErn
         j4HYll3lTohN861T/5EEj2TClaczINHAVDOHMW/NnbuTJqWNWtU3fVjSbBWhgS2yvobJ
         wC+FR6K4Cvv9PLXNKEWTjLBjcIA3ulcLomlg6Q291qVSxq3wliJAKuwsj4yrfbsaTg3M
         V7o+22mGBjrF5jUtZt2TInxhzU+F+X96AHvYE8t463mEi0WKcBFL5GMySTr3fijZ5+LG
         6tLQ==
X-Gm-Message-State: AOAM531NbWA1wpeR/nTNTAR+uAMajgyABvJC7Ek4Bx6zto2wGxLgWU4o
        4pth+jiNGJk/fHMkwOhZNI3cSEmUPqkn9fWHvNzVyP+Z+o/88EhyzCWq+qzPmSI47JfjgKollqz
        rxOl9ZkSiw56J6hqdj8dbZkgipPuX00ztJMTzzrawAK235LQ+LuunMY7QZQ==
X-Google-Smtp-Source: ABdhPJyQcHkAB6MPdhvQdWJtxf9obMBiVoOlTPVWctV8cgSO62KQrItWlsn03gEnh4XWHeOfr1ATWxnMN2I=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:9887:: with SMTP id l7mr14704635ybo.191.1626470811681;
 Fri, 16 Jul 2021 14:26:51 -0700 (PDT)
Date:   Fri, 16 Jul 2021 21:26:29 +0000
In-Reply-To: <20210716212629.2232756-1-oupton@google.com>
Message-Id: <20210716212629.2232756-13-oupton@google.com>
Mime-Version: 1.0
References: <20210716212629.2232756-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 12/12] selftests: KVM: Add counter emulation benchmark
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
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test case for counter emulation on arm64. A side effect of how KVM
handles physical counter offsetting on non-ECV systems is that the
virtual counter will always hit hardware and the physical could be
emulated. Force emulation by writing a nonzero offset to the physical
counter and compare the elapsed cycles to a direct read of the hardware
register.

Reviewed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/counter_emulation_benchmark.c | 215 ++++++++++++++++++
 3 files changed, 217 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 2752813d5090..1d811c6a769b 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /aarch64/debug-exceptions
+/aarch64/counter_emulation_benchmark
 /aarch64/get-reg-list
 /aarch64/vgic_init
 /s390x/memop
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index d89908108c97..e560a3e74bc2 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -86,6 +86,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
+TEST_GEN_PROGS_aarch64 += aarch64/counter_emulation_benchmark
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
new file mode 100644
index 000000000000..73aeb6cdebfe
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
@@ -0,0 +1,215 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * counter_emulation_benchmark.c -- test to measure the effects of counter
+ * emulation on guest reads of the physical counter.
+ *
+ * Copyright (c) 2021, Google LLC.
+ */
+
+#define _GNU_SOURCE
+#include <asm/kvm.h>
+#include <linux/kvm.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define VCPU_ID 0
+
+static struct counter_values {
+	uint64_t cntvct_start;
+	uint64_t cntpct;
+	uint64_t cntvct_end;
+} counter_values;
+
+static uint64_t nr_iterations = 1000;
+
+static void do_test(void)
+{
+	/*
+	 * Open-coded approach instead of using helper methods to keep a tight
+	 * interval around the physical counter read.
+	 */
+	asm volatile("isb\n\t"
+		     "mrs %[cntvct_start], cntvct_el0\n\t"
+		     "isb\n\t"
+		     "mrs %[cntpct], cntpct_el0\n\t"
+		     "isb\n\t"
+		     "mrs %[cntvct_end], cntvct_el0\n\t"
+		     "isb\n\t"
+		     : [cntvct_start] "=r"(counter_values.cntvct_start),
+		     [cntpct] "=r"(counter_values.cntpct),
+		     [cntvct_end] "=r"(counter_values.cntvct_end));
+}
+
+static void guest_main(void)
+{
+	int i;
+
+	for (i = 0; i < nr_iterations; i++) {
+		do_test();
+		GUEST_SYNC(i);
+	}
+
+	for (i = 0; i < nr_iterations; i++) {
+		do_test();
+		GUEST_SYNC(i);
+	}
+
+	GUEST_DONE();
+}
+
+static bool enter_guest(struct kvm_vm *vm)
+{
+	struct ucall uc;
+
+	vcpu_ioctl(vm, VCPU_ID, KVM_RUN, NULL);
+
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	case UCALL_DONE:
+		return true;
+	case UCALL_SYNC:
+		break;
+	case UCALL_ABORT:
+		TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
+			    __FILE__, uc.args[1]);
+		break;
+	default:
+		TEST_ASSERT(false, "unexpected exit: %s",
+			    exit_reason_str(vcpu_state(vm, VCPU_ID)->exit_reason));
+		break;
+	}
+
+	/* more work to do in the guest */
+	return false;
+}
+
+static double counter_frequency(void)
+{
+	uint32_t freq;
+
+	asm volatile("mrs %0, cntfrq_el0"
+		     : "=r" (freq));
+
+	return freq / 1000000.0;
+}
+
+static void log_csv(FILE *csv, bool trapped)
+{
+	double freq = counter_frequency();
+
+	fprintf(csv, "%s,%.02f,%lu,%lu,%lu\n",
+		trapped ? "true" : "false", freq,
+		counter_values.cntvct_start,
+		counter_values.cntpct,
+		counter_values.cntvct_end);
+}
+
+static double run_loop(struct kvm_vm *vm, FILE *csv, bool trapped)
+{
+	double avg = 0;
+	int i;
+
+	for (i = 0; i < nr_iterations; i++) {
+		uint64_t delta;
+
+		TEST_ASSERT(!enter_guest(vm), "guest exited unexpectedly");
+		sync_global_from_guest(vm, counter_values);
+
+		if (csv)
+			log_csv(csv, trapped);
+
+		delta = counter_values.cntvct_end - counter_values.cntvct_start;
+		avg = ((avg * i) + delta) / (i + 1);
+	}
+
+	return avg;
+}
+
+static void setup_counter(struct kvm_vm *vm, uint64_t offset)
+{
+	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				KVM_ARM_VCPU_TIMER_OFFSET_PTIMER, &offset,
+				true);
+}
+
+static void run_tests(struct kvm_vm *vm, FILE *csv)
+{
+	double avg_trapped, avg_native, freq;
+
+	freq = counter_frequency();
+
+	if (csv)
+		fputs("trapped,freq_mhz,cntvct_start,cntpct,cntvct_end\n", csv);
+
+	/* no physical offsetting; kvm allows reads of cntpct_el0 */
+	setup_counter(vm, 0);
+	avg_native = run_loop(vm, csv, false);
+
+	/* force emulation of the physical counter */
+	setup_counter(vm, 1);
+	avg_trapped = run_loop(vm, csv, true);
+
+	TEST_ASSERT(enter_guest(vm), "guest didn't run to completion");
+	pr_info("%lu iterations: average cycles (@%.02fMHz) native: %.02f, trapped: %.02f\n",
+		nr_iterations, freq, avg_native, avg_trapped);
+}
+
+static void usage(const char *program_name)
+{
+	fprintf(stderr,
+		"Usage: %s [-h] [-o csv_file] [-n iterations]\n"
+		"  -h prints this message\n"
+		"  -n number of test iterations (default: %lu)\n"
+		"  -o csv file to write data\n",
+		program_name, nr_iterations);
+}
+
+int main(int argc, char **argv)
+{
+	struct kvm_vm *vm;
+	FILE *csv = NULL;
+	int opt;
+
+	while ((opt = getopt(argc, argv, "hn:o:")) != -1) {
+		switch (opt) {
+		case 'o':
+			csv = fopen(optarg, "w");
+			if (!csv) {
+				fprintf(stderr, "failed to open file '%s': %d\n",
+					optarg, errno);
+				exit(1);
+			}
+			break;
+		case 'n':
+			nr_iterations = strtoul(optarg, NULL, 0);
+			break;
+		default:
+			fprintf(stderr, "unrecognized option: '-%c'\n", opt);
+			/* fallthrough */
+		case 'h':
+			usage(argv[0]);
+			exit(1);
+		}
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, guest_main);
+	sync_global_to_guest(vm, nr_iterations);
+	ucall_init(vm, NULL);
+
+	if (_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				  KVM_ARM_VCPU_TIMER_OFFSET_PTIMER)) {
+		print_skip("KVM_ARM_VCPU_TIMER_OFFSET_PTIMER not supported.");
+		exit(KSFT_SKIP);
+	}
+
+	run_tests(vm, csv);
+	kvm_vm_free(vm);
+
+	if (csv)
+		fclose(csv);
+}
-- 
2.32.0.402.g57bb445576-goog

