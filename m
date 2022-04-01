Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC0A4EFD1F
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 01:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353408AbiDAXjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 19:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiDAXjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 19:39:44 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE62F39BBD
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 16:37:53 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id d6-20020a655886000000b00398b858cdd3so2319236pgu.7
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 16:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OVnrY2Z/BepLYHj2NLDSF8lUsNNOgxbKn23EFBIjPZQ=;
        b=iplM/xFcUsxZRgXikSbWHtSQ52UL0RsOsLJ6gpuAaIZvyF5DFDeKl+IqWUneubWMq7
         mW7W1bkhqZ5x1vCZ3I5wXaBNxrDgZVWr1SL3b5wQnWV0DoPicVmoBx9a+5hhrM0sHv9U
         mH1zXlRxl7KA5MQ2LFx4aOSS3kbeVmR+C08Y9I4gdfDH872paQo+kBe1+8+2m5MTphqL
         jqi+0zKBr8UrHwXvciZ1NMeNHiWCIbZSi7sdcPRdquxEvtOy40quDJ+XwsD26xGr5cmy
         W6i5YpUey5sQgNI6NLznNJbUs1S213gRnS8IvwnNgZNoEOTJb5HgSImgInu/bB36+C1p
         AEyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OVnrY2Z/BepLYHj2NLDSF8lUsNNOgxbKn23EFBIjPZQ=;
        b=FRgNbpBJy3H56d+WE7O/bYmFBceomDP83Q/UjoqQUeK60mDUij9iLzk09fv8VPHosr
         cwiTchIh71Ae1lBDFxwCJqgd/70v3KlCecQwMw7Uw2MNq3BwpXVHy5IMX3Ua5SvzgmDi
         rYV48iwB/yNAHUvA+tALNRVs+A+Db+pZnQm46Dxb2W2G3FHIjKeTQRSEoQmzS+G3tdF/
         CFNNuwI+lDHeLqGbSoGTXBNt96u2ThWLLFS8C/2kCFBxfsEaYPWNLpi0hLmBdLeAO2w9
         5oyb2LjLUyh9jHasZbv04j1OO/nZJMzjVLQFEHHG7u5Mr7G3i9q7/z2HdsMmnL1ZnYDn
         6M3g==
X-Gm-Message-State: AOAM533OtOenT/c83/H2h1lvaqVjJaT43owJS0Cy4fC/doEo5Y5HTmNc
        WfzUfdlqt8iGYem/YllGbj23BKqH/1deMA==
X-Google-Smtp-Source: ABdhPJyaL8KicpcF2UlvW2DCewVHjdYfwlQbVdzqW9ZBHn8NnGuM0oUKo8XyTqnKVf9HZLPSUh0CN48+f9DJwA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1791:b0:4fb:2796:83a1 with SMTP
 id s17-20020a056a00179100b004fb279683a1mr36726050pfg.36.1648856273268; Fri,
 01 Apr 2022 16:37:53 -0700 (PDT)
Date:   Fri,  1 Apr 2022 23:37:35 +0000
In-Reply-To: <20220401233737.3021889-1-dmatlack@google.com>
Message-Id: <20220401233737.3021889-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401233737.3021889-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 1/3] KVM: selftests: Introduce a selftest to measure execution performance
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 .../testing/selftests/kvm/execute_perf_test.c | 188 ++++++++++++++++++
 .../selftests/kvm/include/perf_test_util.h    |   2 +
 .../selftests/kvm/lib/perf_test_util.c        |  25 ++-
 5 files changed, 215 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/execute_perf_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 1f1b6c978bf7..3647ddacb103 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -56,6 +56,7 @@
 /demand_paging_test
 /dirty_log_test
 /dirty_log_perf_test
+/execute_perf_test
 /hardware_disable_test
 /kvm_create_max_vcpus
 /kvm_page_table_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c9cdbd248727..3c67346b0766 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -92,6 +92,7 @@ TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
+TEST_GEN_PROGS_x86_64 += execute_perf_test
 TEST_GEN_PROGS_x86_64 += hardware_disable_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += kvm_page_table_test
diff --git a/tools/testing/selftests/kvm/execute_perf_test.c b/tools/testing/selftests/kvm/execute_perf_test.c
new file mode 100644
index 000000000000..fa78facf44e7
--- /dev/null
+++ b/tools/testing/selftests/kvm/execute_perf_test.c
@@ -0,0 +1,188 @@
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
+	int vcpus;
+};
+
+static void assert_ucall(struct kvm_vm *vm, uint32_t vcpu_id,
+			 uint64_t expected_ucall)
+{
+	struct ucall uc;
+	uint64_t actual_ucall = get_ucall(vm, vcpu_id, &uc);
+
+	TEST_ASSERT(expected_ucall == actual_ucall,
+		    "Guest exited unexpectedly (expected ucall %" PRIu64
+		    ", got %" PRIu64 ")",
+		    expected_ucall, actual_ucall);
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
+	struct kvm_vm *vm = perf_test_args.vm;
+	int vcpu_id = vcpu_args->vcpu_id;
+	int current_iteration = 0;
+
+	while (spin_wait_for_next_iteration(&current_iteration)) {
+		vcpu_run(vm, vcpu_id);
+		assert_ucall(vm, vcpu_id, UCALL_SYNC);
+		vcpu_last_completed_iteration[vcpu_id] = current_iteration;
+	}
+}
+
+static void spin_wait_for_vcpu(int vcpu_id, int target_iteration)
+{
+	while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) !=
+	       target_iteration) {
+		continue;
+	}
+}
+
+static void run_iteration(struct kvm_vm *vm, int vcpus, const char *description)
+{
+	struct timespec ts_start;
+	struct timespec ts_elapsed;
+	int next_iteration;
+	int vcpu_id;
+
+	/* Kick off the vCPUs by incrementing iteration. */
+	next_iteration = ++iteration;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts_start);
+
+	/* Wait for all vCPUs to finish the iteration. */
+	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++)
+		spin_wait_for_vcpu(vcpu_id, next_iteration);
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
+	int vcpus = params->vcpus;
+
+	vm = perf_test_create_vm(mode, vcpus, params->vcpu_memory_bytes, 1,
+				 params->backing_src, !overlap_memory_access);
+
+	perf_test_start_vcpu_threads(vcpus, vcpu_thread_main);
+
+	pr_info("\n");
+
+	perf_test_set_wr_fract(vm, 1);
+	run_iteration(vm, vcpus, "Populating memory");
+
+	perf_test_set_execute(vm, true);
+	run_iteration(vm, vcpus, "Executing from memory");
+
+	/* Set done to signal the vCPU threads to exit */
+	done = true;
+
+	perf_test_join_vcpu_threads(vcpus);
+	perf_test_destroy_vm(vm);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-m mode] [-b vcpu_bytes] [-v vcpus] [-o]  [-s mem_type]\n",
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
+		.vcpus = 1,
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
+			params.vcpus = atoi(optarg);
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
index a86f953d8d36..0a5a56539aff 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -33,6 +33,7 @@ struct perf_test_args {
 	uint64_t gpa;
 	uint64_t guest_page_size;
 	int wr_fract;
+	bool execute;
 
 	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };
@@ -46,6 +47,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+void perf_test_set_execute(struct kvm_vm *vm, bool execute);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 722df3a28791..1a5eb60b59da 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -36,6 +36,16 @@ static void (*vcpu_thread_fn)(struct perf_test_vcpu_args *);
 /* Set to true once all vCPU threads are up and running. */
 static bool all_vcpu_threads_running;
 
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
@@ -58,8 +68,10 @@ static void guest_code(uint32_t vcpu_id)
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
@@ -198,6 +210,15 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
 	sync_global_to_guest(vm, perf_test_args);
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

base-commit: d1fb6a1ca3e535f89628193ab94203533b264c8c
-- 
2.35.1.1094.g7c7d902a7c-goog

