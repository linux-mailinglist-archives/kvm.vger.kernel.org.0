Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC695972F7
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbiHQPaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240097AbiHQPaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:30:09 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502B58E0CC
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 08:30:07 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y9-20020a17090322c900b0016f8fdcc3b1so8393271plg.6
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 08:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=Qkmccm/z1P8KkL3+STm3aMUEd1Pe32aPYrZdxb0HPrk=;
        b=Pxvb+ZGChsqiwkr49DHWgMfeYtE2fVHPO36oj7Mj0yUC8eUwQdp7IjUqkfT1BNZ1UB
         M4sIWk9NkTVEvEOiC0iKLTNnbm3rzh2hMATrXGt7PwnFFbsK8+8ZGq4jj/wi8I0KMbQD
         sjncZTQ/G6xgxuv+qHsD++IiDXwEVPNHcCLy1VmWSZZHaBKO27XELIirIAl/V1Mq1L8L
         b0fNNUJ2Jfb7bl6m13muowxadQcJh3BUKLCzYOgRFn93RajEKKsnSpX1t4MXm16EGfIf
         2kg6bEX843eHdN+bkC5AXPBYt4l6iBCCtJ7Is/ZvSBgj+CijmVAqDgINAPFNNRSD5Bq3
         cASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=Qkmccm/z1P8KkL3+STm3aMUEd1Pe32aPYrZdxb0HPrk=;
        b=xL+SXxXSIadzHiNyKlqXh8fLY+y1nML/XMpJelYbJlMsgcSH/GnppILdpyf8+Yppk+
         OZ28l9eDE5v67PiLHOElcznARDTzUU1VfJL3SVYEVLqnzG8ligqKBlPdFjCAAz9diZ3r
         BTdSpST5/Qfb/uT0h7mxe8kkt4oWUnCajrvYE9m6TZ34yWla4mczFuqlGwqUUMEWBnl7
         3gPKRku6wxTipArjJdgZogDyB4op8yJpUZCmAjS6lywXhSJ1eoNp/1WuT0p7nWjARg/H
         AqGBdUITob0bR9OeEXzt3qVzamEaYgjMSZA8njIZZp2JD/Z5r6h1kNKrG9jfLbTTGq9u
         H5ag==
X-Gm-Message-State: ACgBeo17XVPK5L0uvvH92SkZXz+CP7daZ/bY6jSlcGH96xdXAyE1sRwG
        ikzKIk1zAoDVXa6zfqW3joJGcRe2cP5X
X-Google-Smtp-Source: AA6agR4Vl9pQRf7lXoJiti0d08utPaH3IyHkVgCjs20FK59QowdbfkNojkBF45P/JBKh88yoYDfDR9Q2WAB9
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:788f:b0:170:8b18:8812 with SMTP id
 q15-20020a170902788f00b001708b188812mr26741589pll.1.1660750206813; Wed, 17
 Aug 2022 08:30:06 -0700 (PDT)
Date:   Wed, 17 Aug 2022 08:29:56 -0700
Message-Id: <20220817152956.4056410-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH] KVM: selftests: Run dirty_log_perf_test on specific cpus
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, dmatlack@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add command line options to run the vcpus and the main process on the
specific cpus on a host machine. This is useful as it provides
options to analyze performance based on the vcpus and dirty log worker
locations, like on the different numa nodes or on the same numa nodes.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Suggested-by: David Matlack <dmatlack@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
---

This is based on the discussion at
https://lore.kernel.org/lkml/20220801151928.270380-1-vipinsh@google.com/

 .../selftests/kvm/access_tracking_perf_test.c |   2 +-
 .../selftests/kvm/demand_paging_test.c        |   2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 108 +++++++++++++++++-
 .../selftests/kvm/include/perf_test_util.h    |   3 +-
 .../selftests/kvm/lib/perf_test_util.c        |  32 +++++-
 .../kvm/memslot_modification_stress_test.c    |   2 +-
 6 files changed, 139 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 1c2749b1481ac..9659462f47478 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -299,7 +299,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vm = perf_test_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
 				 params->backing_src, !overlap_memory_access);
 
-	perf_test_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
+	perf_test_start_vcpu_threads(nr_vcpus, NULL, vcpu_thread_main);
 
 	pr_info("\n");
 	access_memory(vm, nr_vcpus, ACCESS_WRITE, "Populating memory");
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 779ae54f89c40..b9848174d6e7c 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -336,7 +336,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Finished creating vCPUs and starting uffd threads\n");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
-	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
+	perf_test_start_vcpu_threads(nr_vcpus, NULL, vcpu_worker);
 	pr_info("Started all vCPUs\n");
 
 	perf_test_join_vcpu_threads(nr_vcpus);
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index f99e39a672d3f..68a1d7262f21b 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -8,10 +8,12 @@
  * Copyright (C) 2020, Google, Inc.
  */
 
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
 #include <pthread.h>
+#include <sched.h>
 #include <linux/bitmap.h>
 
 #include "kvm_util.h"
@@ -66,6 +68,8 @@ static u64 dirty_log_manual_caps;
 static bool host_quit;
 static int iteration;
 static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
+/* Map vcpus to logical cpus on host. */
+static int vcpu_to_lcpu_map[KVM_MAX_VCPUS];
 
 static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 {
@@ -132,6 +136,7 @@ struct test_params {
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
+	int *vcpu_to_lcpu;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -248,7 +253,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	for (i = 0; i < nr_vcpus; i++)
 		vcpu_last_completed_iteration[i] = -1;
 
-	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
+	perf_test_start_vcpu_threads(nr_vcpus, p->vcpu_to_lcpu, vcpu_worker);
 
 	/* Allow the vCPUs to populate memory */
 	pr_debug("Starting iteration %d - Populating\n", iteration);
@@ -348,12 +353,74 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	perf_test_destroy_vm(vm);
 }
 
+static int parse_num(const char *num_str)
+{
+	int num;
+	char *end_ptr;
+
+	errno = 0;
+	num = (int)strtol(num_str, &end_ptr, 10);
+	TEST_ASSERT(num_str != end_ptr && *end_ptr == '\0',
+		    "Invalid number string.\n");
+	TEST_ASSERT(errno == 0, "Conversion error: %d\n", errno);
+
+	return num;
+}
+
+static int parse_cpu_list(const char *arg)
+{
+	char delim[2] = ",";
+	char *cpu, *cpu_list;
+	int i = 0, cpu_num;
+
+	cpu_list = strdup(arg);
+	TEST_ASSERT(cpu_list, "Low memory\n");
+
+	cpu = strtok(cpu_list, delim);
+	while (cpu) {
+		cpu_num = parse_num(cpu);
+		TEST_ASSERT(cpu_num >= 0, "Invalid cpu number: %d\n", cpu_num);
+		vcpu_to_lcpu_map[i++] = cpu_num;
+		cpu = strtok(NULL, delim);
+	}
+
+	free(cpu_list);
+
+	return i;
+}
+
+static void assign_dirty_log_perf_test_cpu(const char *arg)
+{
+	char delim[2] = ",";
+	char *cpu, *cpu_list;
+	cpu_set_t cpuset;
+	int cpu_num, err;
+
+	cpu_list = strdup(arg);
+	TEST_ASSERT(cpu_list, "Low memory\n");
+
+	CPU_ZERO(&cpuset);
+	cpu = strtok(cpu_list, delim);
+	while (cpu) {
+		cpu_num = parse_num(cpu);
+		TEST_ASSERT(cpu_num >= 0, "Invalid cpu number: %d\n", cpu_num);
+		CPU_SET(cpu_num, &cpuset);
+		cpu = strtok(NULL, delim);
+	}
+
+	err = sched_setaffinity(0, sizeof(cpu_set_t), &cpuset);
+	TEST_ASSERT(err == 0, "Error in setting dirty log perf test cpu\n");
+
+	free(cpu_list);
+}
+
 static void help(char *name)
 {
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
 	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
-	       "[-x memslots]\n", name);
+	       "[-x memslots] [-c logical cpus for vcpus]"
+	       "[-d cpus to run dirty_log_perf_test]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
@@ -383,6 +450,26 @@ static void help(char *name)
 	backing_src_help("-s");
 	printf(" -x: Split the memory region into this number of memslots.\n"
 	       "     (default: 1)\n");
+	printf(" -c: Comma separated values of the logical CPUs which will run\n"
+	       "     the vCPUs. Number of values should be equal to the number\n"
+	       "     of vCPUs.\n\n"
+	       "     Example: ./dirty_log_perf_test -v 3 -c 22,43,1\n"
+	       "     This means that the vcpu 0 will run on the logical cpu 22,\n"
+	       "     vcpu 1 on the logical cpu 43 and vcpu 2 on the logical cpu 1.\n"
+	       "     (default: No cpu mapping)\n\n");
+	printf(" -d: Comma separated values of the logical CPUs on which\n"
+	       "     dirty_log_perf_test will run. Without -c option, all of\n"
+	       "     the vcpus and main process will run on the cpus provided here.\n"
+	       "     This option also accepts a single cpu. (default: No cpu mapping)\n\n"
+	       "     Example 1: ./dirty_log_perf_test -v 3 -c 22,43,1 -d 101\n"
+	       "     Main application thread will run on logical cpu 101 and\n"
+	       "     vcpus will run on the logical cpus 22, 43 and 1\n\n"
+	       "     Example 2: ./dirty_log_perf_test -v 3 -d 101\n"
+	       "     Main application thread and vcpus will run on the logical\n"
+	       "     cpu 101\n\n"
+	       "     Example 3: ./dirty_log_perf_test -v 3 -d 101,23,53\n"
+	       "     Main application thread and vcpus will run on logical cpus\n"
+	       "     101, 23 and 53.\n");
 	puts("");
 	exit(0);
 }
@@ -396,8 +483,10 @@ int main(int argc, char *argv[])
 		.partition_vcpu_memory_access = true,
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
+		.vcpu_to_lcpu = NULL,
 	};
 	int opt;
+	int nr_lcpus = -1;
 
 	dirty_log_manual_caps =
 		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
@@ -406,8 +495,14 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "c:d:eghi:p:m:nb:f:v:os:x:")) != -1) {
 		switch (opt) {
+		case 'c':
+			nr_lcpus = parse_cpu_list(optarg);
+			break;
+		case 'd':
+			assign_dirty_log_perf_test_cpu(optarg);
+			break;
 		case 'e':
 			/* 'e' is for evil. */
 			run_vcpus_while_disabling_dirty_logging = true;
@@ -455,6 +550,13 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (nr_lcpus != -1) {
+		TEST_ASSERT(nr_lcpus == nr_vcpus,
+			    "Number of vCPUs (%d) are not equal to number of logical cpus provided (%d).",
+			    nr_vcpus, nr_lcpus);
+		p.vcpu_to_lcpu = vcpu_to_lcpu_map;
+	}
+
 	TEST_ASSERT(p.iterations >= 2, "The test should have at least two iterations");
 
 	pr_info("Test iterations: %"PRIu64"\n",	p.iterations);
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index eaa88df0555a8..bd6c566cfc92e 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -53,7 +53,8 @@ void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
 
-void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
+void perf_test_start_vcpu_threads(int vcpus, int *vcpus_to_lcpu,
+				  void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
 void perf_test_guest_code(uint32_t vcpu_id);
 
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7e..771fbdf3d2c22 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -2,11 +2,14 @@
 /*
  * Copyright (C) 2020, Google LLC.
  */
+#define _GNU_SOURCE
 #include <inttypes.h>
 
 #include "kvm_util.h"
 #include "perf_test_util.h"
 #include "processor.h"
+#include <pthread.h>
+#include <sched.h>
 
 struct perf_test_args perf_test_args;
 
@@ -260,10 +263,15 @@ static void *vcpu_thread_main(void *data)
 	return NULL;
 }
 
-void perf_test_start_vcpu_threads(int nr_vcpus,
+void perf_test_start_vcpu_threads(int nr_vcpus, int *vcpu_to_lcpu,
 				  void (*vcpu_fn)(struct perf_test_vcpu_args *))
 {
-	int i;
+	int i, err = 0;
+	pthread_attr_t attr;
+	cpu_set_t cpuset;
+
+	pthread_attr_init(&attr);
+	CPU_ZERO(&cpuset);
 
 	vcpu_thread_fn = vcpu_fn;
 	WRITE_ONCE(all_vcpu_threads_running, false);
@@ -274,7 +282,24 @@ void perf_test_start_vcpu_threads(int nr_vcpus,
 		vcpu->vcpu_idx = i;
 		WRITE_ONCE(vcpu->running, false);
 
-		pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
+		if (vcpu_to_lcpu) {
+			CPU_SET(vcpu_to_lcpu[i], &cpuset);
+
+			err = pthread_attr_setaffinity_np(&attr,
+							  sizeof(cpu_set_t),
+							  &cpuset);
+			TEST_ASSERT(err == 0,
+				    "vCPU %d could not be mapped to logical cpu %d, error returned: %d\n",
+				    i, vcpu_to_lcpu[i], err);
+
+			CPU_CLR(vcpu_to_lcpu[i], &cpuset);
+		}
+
+		err = pthread_create(&vcpu->thread, &attr, vcpu_thread_main,
+				     vcpu);
+		TEST_ASSERT(err == 0,
+			    "error in creating vcpu %d thread, error returned: %d\n",
+			    i, err);
 	}
 
 	for (i = 0; i < nr_vcpus; i++) {
@@ -283,6 +308,7 @@ void perf_test_start_vcpu_threads(int nr_vcpus,
 	}
 
 	WRITE_ONCE(all_vcpu_threads_running, true);
+	pthread_attr_destroy(&attr);
 }
 
 void perf_test_join_vcpu_threads(int nr_vcpus)
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 6ee7e1dde4043..246f8cc7bb2b1 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -103,7 +103,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	pr_info("Finished creating vCPUs\n");
 
-	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
+	perf_test_start_vcpu_threads(nr_vcpus, NULL, vcpu_worker);
 
 	pr_info("Started all vCPUs\n");
 
-- 
2.37.1.595.g718a3a8f04-goog

