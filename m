Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F233A0662
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbhFHVuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbhFHVuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 17:50:19 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56CDC061787
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 14:48:25 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id g14-20020a926b0e0000b02901bb2deb9d71so16221876ilc.6
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VJQxNxTePlfcf3dKFi1wZt07MNFX3dohgtzce5ctPa8=;
        b=iT2LSgpulAl5w53RB3CBjKdDjKgT1rjoyLj64YQHdNGhEeD+nIa19wz3vII3s98KAG
         VLJPGgncFNePZwCtyquAJe14uE17M/dcFUyntRJiXhmzOwvp2vbPHqx3DoPsiSS0/aBu
         5pzm4FEvMZM5TCzuwrH+bZI6lFUwJX5SivK+C47q1Y8PyupQC20hP5IXgdkuHMiAtNAX
         t5556xcRrXS++W4ZoifRWftNJ1ADUQPup1hQnFmAnDChj2/0q861ilHIX3w6zW64Ab9B
         g7xo34HbT5lS+qnq8ITh+Na97cPNDjempspB8bduXonZle5P1Rp/9s5V3gyuR4B67T2A
         ishg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VJQxNxTePlfcf3dKFi1wZt07MNFX3dohgtzce5ctPa8=;
        b=f3olOQLl4QGRtikQeBlvDapwJuhypyP/ET65a0Fn6G8G6gGgsJEGYVg2oVzsC/8jUw
         61jrgvFr7tV4PI6YXLMVkpQjE4dGhgwPLw6ZA8TVmqlhe/8OW/3miobU0gQXaUOG5zMI
         4x9UV+/Pe4rWI3BdeS1F7D4cVAmeFXQ+viukjM9P67pXlMzieV/VtiPW677pAnh4lt3y
         fNz2JQPkP9NxfCYRnQ4sVmtgK+c5NyRUXbzaf8/gwaKdXTp48DoTYq460lD8WTcFG20W
         myC2irAUmKeJnbddnHRUQxWhUatAQQdTUoHCTh7QLab7CkZ+wFbPHPWRwTsopvui+pYu
         2mgA==
X-Gm-Message-State: AOAM530A0+OIZu+k4b4+SlOqlUEf8It67YMN3tqWQEmApwFhx5wozzd8
        eIor9mk2XqQcLTwz93WAfOOXvkPW8k7pM/MxTbMQt4nf/3rS/x8BBrayaog+nXVw5OJSlAkMv8m
        Nx0PAwJIyTF3KzpJgX4QJCg5nr3cOHSaKKOKm9RQ55pGT6iyEGIPHrSQ4iQ==
X-Google-Smtp-Source: ABdhPJzBTB2xENzPFDzDvoxEae14J3frnbRBetzaDnCBIYPPtwPfiwJKr/up2FrtPuroAUjo6qPOLg+MpDg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:9542:: with SMTP id y60mr22663989jah.134.1623188905120;
 Tue, 08 Jun 2021 14:48:25 -0700 (PDT)
Date:   Tue,  8 Jun 2021 21:47:38 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-7-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 06/10] selftests: KVM: Add counter emulation benchmark
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
 .../kvm/aarch64/counter_emulation_benchmark.c | 209 ++++++++++++++++++
 3 files changed, 211 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 1a5782d8a0d4..ac6a7d17d04a 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+/aarch64/counter_emulation_benchmark
 /aarch64/get-reg-list
 /aarch64/get-reg-list-sve
 /aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index b14f16dc954a..c2e5a7d877b1 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -77,6 +77,7 @@ TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 
+TEST_GEN_PROGS_aarch64 += aarch64/counter_emulation_benchmark
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
new file mode 100644
index 000000000000..c403e0762200
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
@@ -0,0 +1,209 @@
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
+static void run_tests(struct kvm_vm *vm, FILE *csv)
+{
+	struct kvm_system_counter_state state = {0};
+	double avg_trapped, avg_native, freq;
+
+	freq = counter_frequency();
+
+	if (csv)
+		fputs("trapped,freq_mhz,cntvct_start,cntpct,cntvct_end\n", csv);
+
+	/* no physical offsetting; kvm allows reads of cntpct_el0 */
+	vcpu_ioctl(vm, VCPU_ID, KVM_SET_SYSTEM_COUNTER_STATE, &state);
+	avg_native = run_loop(vm, csv, false);
+
+	/* force emulation of the physical counter */
+	state.flags = KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET;
+	state.cntpoff = 1;
+	vcpu_ioctl(vm, VCPU_ID, KVM_SET_SYSTEM_COUNTER_STATE, &state);
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
+	if (!kvm_check_cap(KVM_CAP_SYSTEM_COUNTER_STATE)) {
+		print_skip("KVM_CAP_SYSTEM_COUNTER_STATE not supported");
+		exit(KSFT_SKIP);
+	}
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
+	vm = vm_create_default(0, 0, guest_main);
+	sync_global_to_guest(vm, nr_iterations);
+	ucall_init(vm, NULL);
+	run_tests(vm, csv);
+	kvm_vm_free(vm);
+
+	if (csv)
+		fclose(csv);
+}
-- 
2.32.0.rc1.229.g3e70b5a671-goog

