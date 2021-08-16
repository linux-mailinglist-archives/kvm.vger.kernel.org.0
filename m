Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13A83ECC10
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhHPANg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbhHPANc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:13:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FD9C0617AF
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:13:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso15079767ybq.10
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q/e6QF13PbPmzNyeEHftd6LeZ3rm+y0LrpmmQX2iAWM=;
        b=mZQUuekC/Wn8aj3bTX5IwP8Q/uxfw7bpTRbmkVO6crVko3MYwmMop1um7jNsOuIA5G
         2l7IQBaS8rZb2aP3GDppVo/kxpeMHSTowDCLmcOSVWFYG+toZyWpfqzwYMEkPGoP+GAr
         Vxxxe3eGGIT7KZ0BNLxroWGMHSDl8kEndxmKA5kojcb3OHcvNu6CfqYeSHjFzwrMaDdv
         jyncHkHfIGUoOx1Xj5edz3qHxQgIOwIjNbXpAMqnCMKInrbkgoGw5hCj0W+RstgOFWIg
         zL5Zd8JpDIXTsZB/uIGX8V0zRfma8YgV2qFMPNv8+dKZetTlsvcSiBYSxv8SoZGL5DQD
         JdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q/e6QF13PbPmzNyeEHftd6LeZ3rm+y0LrpmmQX2iAWM=;
        b=Am5SNzU2lWIlDldlU0LlsaJ65jEAX9KQDgfZe0IQj1wjB+BPDKTIYE+/mDAgIl/axU
         FDyeOLGxwArhL00Wm2BAN6zH/GayGFh0jUJq3WlMr7cWkB41wCD642Sod83q+l/HJH+R
         WePzvB0FM37kPaUiQlo2cYr9Lvu5XxJKi7WCHdIaGt62zKpC9wwRKxn/aLdr6TVrCDaL
         b/5BQkJ99BM0mWdl4PelscHWTrYUpgHYjihEJl+h9pqQkp82dubuunOXKEK9k0BW8PW7
         qysaFTfMgI3qxEBRcAYeCuTj9LiATvVdS7Jwe0kh4w2KlgH8VmHoxwgiT8iiReucJP1n
         Y6Kw==
X-Gm-Message-State: AOAM532mU3R4+A/CiJly709Q6NLT2HQ+AzGowcWxms48D7L6idAJmseY
        0m4vcFypKCAPxwIs7Hi+gkNfwGwZJK199I7gFl5XgTFY3XXjHQiHNYvjGXlgFAB1u5nGtMWMGP/
        t7AEhNOCmCzHPPFYANGQKMYK+q/C5y4EHGY3+MiufZ86nIKBh+hq3vFSd/w==
X-Google-Smtp-Source: ABdhPJxqohNtoShnC6CGm0BF0rD3zR+u+wedYLYQEXcm4ORB58buXd3rRAuCc1dYfmncyVSTVuHAktSHhpg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:810b:: with SMTP id o11mr18944380ybk.495.1629072781457;
 Sun, 15 Aug 2021 17:13:01 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:46 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-10-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 9/9] selftests: KVM: Add counter emulation benchmark
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
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
Change-Id: Iec9ed89346c3f65b7f9067a7e96a9d94afbab526
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/counter_emulation_benchmark.c | 207 ++++++++++++++++++
 3 files changed, 209 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 9a73befbd8d6..0f3d842b82d6 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+/aarch64/counter_emulation_benchmark
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
 /aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a74d4876c69c..3652b39e02b8 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -86,6 +86,7 @@ TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 
+TEST_GEN_PROGS_aarch64 += aarch64/counter_emulation_benchmark
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
new file mode 100644
index 000000000000..48dbd9459102
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
@@ -0,0 +1,207 @@
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
+}
+
+static void enter_guest(struct kvm_vm *vm)
+{
+	struct ucall uc;
+
+	vcpu_ioctl(vm, VCPU_ID, KVM_RUN, NULL);
+
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
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
+		enter_guest(vm);
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
+				KVM_ARM_VCPU_TIMER_PHYS_OFFSET, &offset,
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
+				  KVM_ARM_VCPU_TIMER_PHYS_OFFSET)) {
+		print_skip("KVM_ARM_VCPU_TIMER_PHYS_OFFSET not supported.");
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
2.33.0.rc1.237.g0d66db33f3-goog

