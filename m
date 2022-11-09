Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3696B623312
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 19:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiKIS7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 13:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiKIS7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 13:59:11 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48984192B7
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 10:59:10 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d18-20020a170902ced200b001871dab2d59so14083181plg.22
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 10:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sIohz5/7afbilsqdEocroMm9Zix3bKJohHWVJ80stQE=;
        b=U5qgTz/bgSBUoJc2ekceYA1+5T1He7Yu7s9d1FL6DBB6GelKWuQVU9RQmye5nBw/2w
         C+bM93hx5djVDx1UTJti4Pst0ffGuw12S293m0WIiwuNYXWdoby0Hi0BPAjbBX91Df4p
         6vTGzM+r32vHPkOyVhv7U9Tchj/6NR3s3WzUUVc6WtJ/p7aI6FUcAWDVqQTOpvWaFRmI
         ELfhE0Aki9MQRnqMFktqpJPWCHehV5SwtUGPDpX9hJv9TF+NbmWfF+YaqLy+g3FxbLts
         a1cYvZskyrAa0LhL7IJtHB9BKvF4XUtw+cJz8FIvcWFpTdhteE7fHQWWcdBJoMHJQFzS
         5Hhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sIohz5/7afbilsqdEocroMm9Zix3bKJohHWVJ80stQE=;
        b=7sn69ZmwhHnwSwl3UCr7q7HMbFPzPH26w0ez3IGrP42f+NDSLzpr+uI8iKa74Fp8zN
         JJ8XhSXQMKA7XixKiZMaBL44bKiYht89Y0LLyBgZxCWHPt0BSLK2Jf2luponBHG0FlKo
         zn8em8Rm72/w4p6p+AgRujbWaVsJQ7Wl5h+eMZ7sF8fshi3d7add5nKnzK4lAj1RNBLU
         GJOWtGXEMH+FgkAy+WTeU44m7H3lOyvWMfxrdYmBE+XPFvHtspe+psAr+F9ErlhVPdRl
         nxpz6QvdYfHXBbRYOieny85BN3MkYZLdtK23U4B6BMBcP3KibKnXF2Joj841C7j2fDqS
         O0Uw==
X-Gm-Message-State: ACrzQf2e3eDcYxKVeC6ay0SSVOH55QGfbeeVOfp/kHdSgkpxi+LBm5A8
        k7RHNc9hbC5d+T1g2LpoKBW8ZaDeDW9buA==
X-Google-Smtp-Source: AMsMyM5HEVYvet/v4YC92xvs5IApM6pLIxpjTirJveA85oDHqTRfEdEVTjZbSyyUOnWYKFFJCabJechxL94aFg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:902:ce0e:b0:187:722:f4db with SMTP id
 k14-20020a170902ce0e00b001870722f4dbmr1255236plg.87.1668020349829; Wed, 09
 Nov 2022 10:59:09 -0800 (PST)
Date:   Wed,  9 Nov 2022 10:59:04 -0800
In-Reply-To: <20221109185905.486172-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221109185905.486172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221109185905.486172-2-dmatlack@google.com>
Subject: [PATCH v3 1/2] KVM: selftests: Introduce a selftest to measure
 execution performance
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new selftest, execute_perf_test, that uses the
perf_test_util framework to measure the performance of executing code
within a VM. This test is similar to the other perf_test_util-based
tests in that it spins up a variable number of vCPUs and runs them
concurrently, accessing memory.

In order to support executiong, extend perf_test_util to populate guest
memory with return instructions rather than random garbage. This way
memory can be execute simply by calling it.

Currently only x86-64 supports execution, but other architectures can be
easily added by providing their return code instruction.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/execute_perf_test.c | 185 ++++++++++++++++++
 .../selftests/kvm/include/perf_test_util.h    |   2 +
 .../selftests/kvm/lib/perf_test_util.c        |  25 ++-
 5 files changed, 212 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/execute_perf_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 2f0d705db9db..60ec1f0b70b5 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -68,6 +68,7 @@
 /demand_paging_test
 /dirty_log_test
 /dirty_log_perf_test
+/execute_perf_test
 /hardware_disable_test
 /kvm_create_max_vcpus
 /kvm_page_table_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0172eb6cb6ee..73ea068f90de 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -132,6 +132,7 @@ TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
+TEST_GEN_PROGS_x86_64 += execute_perf_test
 TEST_GEN_PROGS_x86_64 += hardware_disable_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += kvm_page_table_test
diff --git a/tools/testing/selftests/kvm/execute_perf_test.c b/tools/testing/selftests/kvm/execute_perf_test.c
new file mode 100644
index 000000000000..665bdbe62206
--- /dev/null
+++ b/tools/testing/selftests/kvm/execute_perf_test.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <inttypes.h>
+#include <limits.h>
+#include <pthread.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include "kvm_util.h"
+#include "test_util.h"
+#include "perf_test_util.h"
+#include "guest_modes.h"
+
+/* Global variable used to synchronize all of the vCPU threads. */
+static int iteration;
+
+/* Set to true when vCPU threads should exit. */
+static bool done;
+
+/* The iteration that was last completed by each vCPU. */
+static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
+
+/* Whether to overlap the regions of memory vCPUs access. */
+static bool overlap_memory_access;
+
+struct test_params {
+	/* The backing source for the region of memory. */
+	enum vm_mem_backing_src_type backing_src;
+
+	/* The amount of memory to allocate for each vCPU. */
+	uint64_t vcpu_memory_bytes;
+
+	/* The number of vCPUs to create in the VM. */
+	int nr_vcpus;
+};
+
+static void assert_ucall(struct kvm_vcpu *vcpu, uint64_t expected_ucall)
+{
+	struct ucall uc;
+
+	TEST_ASSERT(expected_ucall == get_ucall(vcpu, &uc),
+		    "Guest exited unexpectedly (expected ucall %" PRIu64
+		    ", got %" PRIu64 ")",
+		    expected_ucall, uc.cmd);
+}
+
+static bool spin_wait_for_next_iteration(int *current_iteration)
+{
+	int last_iteration = *current_iteration;
+
+	do {
+		if (READ_ONCE(done))
+			return false;
+
+		*current_iteration = READ_ONCE(iteration);
+	} while (last_iteration == *current_iteration);
+
+	return true;
+}
+
+static void vcpu_thread_main(struct perf_test_vcpu_args *vcpu_args)
+{
+	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
+	int current_iteration = 0;
+
+	while (spin_wait_for_next_iteration(&current_iteration)) {
+		vcpu_run(vcpu);
+		assert_ucall(vcpu, UCALL_SYNC);
+		vcpu_last_completed_iteration[vcpu->id] = current_iteration;
+	}
+}
+
+static void spin_wait_for_vcpu(struct kvm_vcpu *vcpu, int target_iteration)
+{
+	while (READ_ONCE(vcpu_last_completed_iteration[vcpu->id]) !=
+	       target_iteration) {
+		continue;
+	}
+}
+
+static void run_iteration(struct kvm_vm *vm, const char *description)
+{
+	struct timespec ts_elapsed;
+	struct timespec ts_start;
+	struct kvm_vcpu *vcpu;
+	int next_iteration;
+
+	/* Kick off the vCPUs by incrementing iteration. */
+	next_iteration = ++iteration;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts_start);
+
+	/* Wait for all vCPUs to finish the iteration. */
+	list_for_each_entry(vcpu, &vm->vcpus, list)
+		spin_wait_for_vcpu(vcpu, next_iteration);
+
+	ts_elapsed = timespec_elapsed(ts_start);
+	pr_info("%-30s: %ld.%09lds\n",
+		description, ts_elapsed.tv_sec, ts_elapsed.tv_nsec);
+}
+
+static void run_test(enum vm_guest_mode mode, void *arg)
+{
+	struct test_params *params = arg;
+	struct kvm_vm *vm;
+
+	vm = perf_test_create_vm(mode, params->nr_vcpus,
+				 params->vcpu_memory_bytes, 1,
+				 params->backing_src, !overlap_memory_access);
+
+	perf_test_start_vcpu_threads(params->nr_vcpus, vcpu_thread_main);
+
+	pr_info("\n");
+
+	perf_test_set_wr_fract(vm, 1);
+	run_iteration(vm, "Populating memory");
+
+	perf_test_set_execute(vm, true);
+	run_iteration(vm, "Executing from memory");
+
+	/* Set done to signal the vCPU threads to exit */
+	done = true;
+
+	perf_test_join_vcpu_threads(params->nr_vcpus);
+	perf_test_destroy_vm(vm);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-m mode] [-b vcpu_bytes] [-v nr_vcpus] [-o]  [-s mem_type]\n",
+	       name);
+	puts("");
+	printf(" -h: Display this help message.");
+	guest_modes_help();
+	printf(" -b: specify the size of the memory region which should be\n"
+	       "     dirtied by each vCPU. e.g. 10M or 3G.\n"
+	       "     (default: 1G)\n");
+	printf(" -v: specify the number of vCPUs to run.\n");
+	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
+	       "     them into a separate region of memory for each vCPU.\n");
+	backing_src_help("-s");
+	puts("");
+	exit(0);
+}
+
+int main(int argc, char *argv[])
+{
+	struct test_params params = {
+		.backing_src = DEFAULT_VM_MEM_SRC,
+		.vcpu_memory_bytes = DEFAULT_PER_VCPU_MEM_SIZE,
+		.nr_vcpus = 1,
+	};
+	int opt;
+
+	guest_modes_append_default();
+
+	while ((opt = getopt(argc, argv, "hm:b:v:os:")) != -1) {
+		switch (opt) {
+		case 'm':
+			guest_modes_cmdline(optarg);
+			break;
+		case 'b':
+			params.vcpu_memory_bytes = parse_size(optarg);
+			break;
+		case 'v':
+			params.nr_vcpus = atoi(optarg);
+			break;
+		case 'o':
+			overlap_memory_access = true;
+			break;
+		case 's':
+			params.backing_src = parse_backing_src_type(optarg);
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			break;
+		}
+	}
+
+	for_each_guest_mode(run_test, &params);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index eaa88df0555a..ec2540e36906 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -36,6 +36,7 @@ struct perf_test_args {
 	uint64_t size;
 	uint64_t guest_page_size;
 	int wr_fract;
+	bool execute;
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
@@ -52,6 +53,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+void perf_test_set_execute(struct kvm_vm *vm, bool execute);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..99721076d31f 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -38,6 +38,16 @@ static bool all_vcpu_threads_running;
 
 static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
+/*
+ * When writing to guest memory, write the opcode for the `ret` instruction so
+ * that subsequent iteractions can exercise instruction fetch by calling the
+ * memory.
+ *
+ * NOTE: Non-x86 architectures would to use different values here to support
+ * execute.
+ */
+#define RETURN_OPCODE 0xC3
+
 /*
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
@@ -60,8 +70,10 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 		for (i = 0; i < pages; i++) {
 			uint64_t addr = gva + (i * pta->guest_page_size);
 
-			if (i % pta->wr_fract == 0)
-				*(uint64_t *)addr = 0x0123456789ABCDEF;
+			if (pta->execute)
+				((void (*)(void)) addr)();
+			else if (i % pta->wr_fract == 0)
+				*(uint64_t *)addr = RETURN_OPCODE;
 			else
 				READ_ONCE(*(uint64_t *)addr);
 		}
@@ -240,6 +252,15 @@ void __weak perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_v
 	exit(KSFT_SKIP);
 }
 
+void perf_test_set_execute(struct kvm_vm *vm, bool execute)
+{
+#ifndef __x86_64__
+	TEST_ASSERT(false, "Execute not supported on this architure; see RETURN_OPCODE.");
+#endif
+	perf_test_args.execute = execute;
+	sync_global_to_guest(vm, perf_test_args);
+}
+
 static void *vcpu_thread_main(void *data)
 {
 	struct vcpu_thread *vcpu = data;
-- 
2.38.1.431.g37b22c650d-goog

