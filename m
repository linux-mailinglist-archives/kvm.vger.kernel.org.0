Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADF32B438A
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 13:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbgKPMT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 07:19:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727027AbgKPMT5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 07:19:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605529193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m2AuRZIZPSyj7OBOSQhXvDj7HBZVz1DqcYgooI8nn5c=;
        b=LvW0SlJ0SyKyCb28dnvr9HG+ehKb/xdaZF/iT/l9+Zv7YnMQNwefckTUkNXsYeTbd0lfxh
        NyfAsGc4qyg4PBNw/soh3EvJLg9gu4gaEDZQbtmCtweQH3QTq0FQ1Pldiutcef7BwwKSsj
        88SMtyIciKfmUB6pTjruLVukTSjWlSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-Kq_ZPWnxOki8JFTWs9Q1gg-1; Mon, 16 Nov 2020 07:19:52 -0500
X-MC-Unique: Kq_ZPWnxOki8JFTWs9Q1gg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11A4D100F946;
        Mon, 16 Nov 2020 12:19:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1856860BF1;
        Mon, 16 Nov 2020 12:19:48 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH v3 1/4] KVM: selftests: Factor out guest mode code
Date:   Mon, 16 Nov 2020 13:19:39 +0100
Message-Id: <20201116121942.55031-2-drjones@redhat.com>
In-Reply-To: <20201116121942.55031-1-drjones@redhat.com>
References: <20201116121942.55031-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

demand_paging_test, dirty_log_test, and dirty_log_perf_test have
redundant guest mode code. Factor it out.

Also, while adding a new include, remove the ones we don't need.

Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/demand_paging_test.c        | 107 ++++-----------
 .../selftests/kvm/dirty_log_perf_test.c       | 121 +++++------------
 tools/testing/selftests/kvm/dirty_log_test.c  | 125 ++++++------------
 .../selftests/kvm/include/guest_modes.h       |  21 +++
 tools/testing/selftests/kvm/lib/guest_modes.c |  70 ++++++++++
 6 files changed, 189 insertions(+), 257 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
 create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4febf4d5ead9..ba24691719ef 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -33,7 +33,7 @@ ifeq ($(ARCH),s390)
 	UNAME_M := s390x
 endif
 
-LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c
+LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c
 LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
 LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 3d96a7bfaff3..946161a9ce2d 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -7,23 +7,20 @@
  * Copyright (C) 2019, Google, Inc.
  */
 
-#define _GNU_SOURCE /* for program_invocation_name */
+#define _GNU_SOURCE /* for program_invocation_name and pipe2 */
 
 #include <stdio.h>
 #include <stdlib.h>
-#include <sys/syscall.h>
-#include <unistd.h>
-#include <asm/unistd.h>
 #include <time.h>
 #include <poll.h>
 #include <pthread.h>
-#include <linux/bitmap.h>
-#include <linux/bitops.h>
 #include <linux/userfaultfd.h>
+#include <sys/syscall.h>
 
-#include "perf_test_util.h"
-#include "processor.h"
+#include "kvm_util.h"
 #include "test_util.h"
+#include "perf_test_util.h"
+#include "guest_modes.h"
 
 #ifdef __NR_userfaultfd
 
@@ -248,9 +245,14 @@ static int setup_demand_paging(struct kvm_vm *vm,
 	return 0;
 }
 
-static void run_test(enum vm_guest_mode mode, bool use_uffd,
-		     useconds_t uffd_delay)
+struct test_params {
+	bool use_uffd;
+	useconds_t uffd_delay;
+};
+
+static void run_test(enum vm_guest_mode mode, void *arg)
 {
+	struct test_params *p = arg;
 	pthread_t *vcpu_threads;
 	pthread_t *uffd_handler_threads = NULL;
 	struct uffd_handler_args *uffd_args = NULL;
@@ -275,7 +277,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 
 	add_vcpus(vm, nr_vcpus, guest_percpu_mem_size);
 
-	if (use_uffd) {
+	if (p->use_uffd) {
 		uffd_handler_threads =
 			malloc(nr_vcpus * sizeof(*uffd_handler_threads));
 		TEST_ASSERT(uffd_handler_threads, "Memory allocation failed");
@@ -308,7 +310,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 			r = setup_demand_paging(vm,
 						&uffd_handler_threads[vcpu_id],
 						pipefds[vcpu_id * 2],
-						uffd_delay, &uffd_args[vcpu_id],
+						p->uffd_delay, &uffd_args[vcpu_id],
 						vcpu_hva, guest_percpu_mem_size);
 			if (r < 0)
 				exit(-r);
@@ -339,7 +341,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 
 	pr_info("All vCPU threads joined\n");
 
-	if (use_uffd) {
+	if (p->use_uffd) {
 		char c;
 
 		/* Tell the user fault fd handler threads to quit */
@@ -362,38 +364,19 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 
 	free(guest_data_prototype);
 	free(vcpu_threads);
-	if (use_uffd) {
+	if (p->use_uffd) {
 		free(uffd_handler_threads);
 		free(uffd_args);
 		free(pipefds);
 	}
 }
 
-struct guest_mode {
-	bool supported;
-	bool enabled;
-};
-static struct guest_mode guest_modes[NUM_VM_MODES];
-
-#define guest_mode_init(mode, supported, enabled) ({ \
-	guest_modes[mode] = (struct guest_mode){ supported, enabled }; \
-})
-
 static void help(char *name)
 {
-	int i;
-
 	puts("");
 	printf("usage: %s [-h] [-m mode] [-u] [-d uffd_delay_usec]\n"
 	       "          [-b memory] [-v vcpus]\n", name);
-	printf(" -m: specify the guest mode ID to test\n"
-	       "     (default: test all supported modes)\n"
-	       "     This option may be used multiple times.\n"
-	       "     Guest mode IDs:\n");
-	for (i = 0; i < NUM_VM_MODES; ++i) {
-		printf("         %d:    %s%s\n", i, vm_guest_mode_string(i),
-		       guest_modes[i].supported ? " (supported)" : "");
-	}
+	guest_modes_help();
 	printf(" -u: use User Fault FD to handle vCPU page\n"
 	       "     faults.\n");
 	printf(" -d: add a delay in usec to the User Fault\n"
@@ -410,53 +393,22 @@ static void help(char *name)
 int main(int argc, char *argv[])
 {
 	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
-	bool mode_selected = false;
-	unsigned int mode;
-	int opt, i;
-	bool use_uffd = false;
-	useconds_t uffd_delay = 0;
-
-#ifdef __x86_64__
-	guest_mode_init(VM_MODE_PXXV48_4K, true, true);
-#endif
-#ifdef __aarch64__
-	guest_mode_init(VM_MODE_P40V48_4K, true, true);
-	guest_mode_init(VM_MODE_P40V48_64K, true, true);
-	{
-		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
-
-		if (limit >= 52)
-			guest_mode_init(VM_MODE_P52V48_64K, true, true);
-		if (limit >= 48) {
-			guest_mode_init(VM_MODE_P48V48_4K, true, true);
-			guest_mode_init(VM_MODE_P48V48_64K, true, true);
-		}
-	}
-#endif
-#ifdef __s390x__
-	guest_mode_init(VM_MODE_P40V48_4K, true, true);
-#endif
+	struct test_params p = {};
+	int opt;
+
+	guest_modes_append_default();
 
 	while ((opt = getopt(argc, argv, "hm:ud:b:v:")) != -1) {
 		switch (opt) {
 		case 'm':
-			if (!mode_selected) {
-				for (i = 0; i < NUM_VM_MODES; ++i)
-					guest_modes[i].enabled = false;
-				mode_selected = true;
-			}
-			mode = strtoul(optarg, NULL, 10);
-			TEST_ASSERT(mode < NUM_VM_MODES,
-				    "Guest mode ID %d too big", mode);
-			guest_modes[mode].enabled = true;
+			guest_modes_cmdline(optarg);
 			break;
 		case 'u':
-			use_uffd = true;
+			p.use_uffd = true;
 			break;
 		case 'd':
-			uffd_delay = strtoul(optarg, NULL, 0);
-			TEST_ASSERT(uffd_delay >= 0,
-				    "A negative UFFD delay is not supported.");
+			p.uffd_delay = strtoul(optarg, NULL, 0);
+			TEST_ASSERT(p.uffd_delay >= 0, "A negative UFFD delay is not supported.");
 			break;
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
@@ -473,14 +425,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	for (i = 0; i < NUM_VM_MODES; ++i) {
-		if (!guest_modes[i].enabled)
-			continue;
-		TEST_ASSERT(guest_modes[i].supported,
-			    "Guest mode ID %d (%s) not supported.",
-			    i, vm_guest_mode_string(i));
-		run_test(i, use_uffd, uffd_delay);
-	}
+	for_each_guest_mode(run_test, &p);
 
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 9c6a7be31e03..506741eb5d7f 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -12,16 +12,14 @@
 
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
 #include <time.h>
 #include <pthread.h>
 #include <linux/bitmap.h>
-#include <linux/bitops.h>
 
 #include "kvm_util.h"
-#include "perf_test_util.h"
-#include "processor.h"
 #include "test_util.h"
+#include "perf_test_util.h"
+#include "guest_modes.h"
 
 /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
 #define TEST_HOST_LOOP_N		2UL
@@ -89,9 +87,15 @@ static void *vcpu_worker(void *data)
 	return NULL;
 }
 
-static void run_test(enum vm_guest_mode mode, unsigned long iterations,
-		     uint64_t phys_offset, int wr_fract)
+struct test_params {
+	unsigned long iterations;
+	uint64_t phys_offset;
+	int wr_fract;
+};
+
+static void run_test(enum vm_guest_mode mode, void *arg)
 {
+	struct test_params *p = arg;
 	pthread_t *vcpu_threads;
 	struct kvm_vm *vm;
 	unsigned long *bmap;
@@ -108,7 +112,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 
 	vm = create_vm(mode, nr_vcpus, guest_percpu_mem_size);
 
-	perf_test_args.wr_fract = wr_fract;
+	perf_test_args.wr_fract = p->wr_fract;
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
@@ -156,7 +160,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
-	while (iteration < iterations) {
+	while (iteration < p->iterations) {
 		/*
 		 * Incrementing the iteration number will start the vCPUs
 		 * dirtying memory again.
@@ -210,15 +214,15 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	pr_info("Disabling dirty logging time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
-	avg = timespec_div(get_dirty_log_total, iterations);
+	avg = timespec_div(get_dirty_log_total, p->iterations);
 	pr_info("Get dirty log over %lu iterations took %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
-		iterations, get_dirty_log_total.tv_sec,
+		p->iterations, get_dirty_log_total.tv_sec,
 		get_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
 
 	if (dirty_log_manual_caps) {
-		avg = timespec_div(clear_dirty_log_total, iterations);
+		avg = timespec_div(clear_dirty_log_total, p->iterations);
 		pr_info("Clear dirty log over %lu iterations took %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
-			iterations, clear_dirty_log_total.tv_sec,
+			p->iterations, clear_dirty_log_total.tv_sec,
 			clear_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
 	}
 
@@ -228,20 +232,8 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	kvm_vm_free(vm);
 }
 
-struct guest_mode {
-	bool supported;
-	bool enabled;
-};
-static struct guest_mode guest_modes[NUM_VM_MODES];
-
-#define guest_mode_init(mode, supported, enabled) ({ \
-	guest_modes[mode] = (struct guest_mode){ supported, enabled }; \
-})
-
 static void help(char *name)
 {
-	int i;
-
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] "
 	       "[-m mode] [-b vcpu bytes] [-v vcpus]\n", name);
@@ -250,14 +242,7 @@ static void help(char *name)
 	       TEST_HOST_LOOP_N);
 	printf(" -p: specify guest physical test memory offset\n"
 	       "     Warning: a low offset can conflict with the loaded test code.\n");
-	printf(" -m: specify the guest mode ID to test "
-	       "(default: test all supported modes)\n"
-	       "     This option may be used multiple times.\n"
-	       "     Guest mode IDs:\n");
-	for (i = 0; i < NUM_VM_MODES; ++i) {
-		printf("         %d:    %s%s\n", i, vm_guest_mode_string(i),
-		       guest_modes[i].supported ? " (supported)" : "");
-	}
+	guest_modes_help();
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     dirtied by each vCPU. e.g. 10M or 3G.\n"
 	       "     (default: 1G)\n");
@@ -272,74 +257,43 @@ static void help(char *name)
 
 int main(int argc, char *argv[])
 {
-	unsigned long iterations = TEST_HOST_LOOP_N;
-	bool mode_selected = false;
-	uint64_t phys_offset = 0;
-	unsigned int mode;
-	int opt, i;
-	int wr_fract = 1;
+	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
+	struct test_params p = {
+		.iterations = TEST_HOST_LOOP_N,
+		.wr_fract = 1,
+	};
+	int opt;
 
 	dirty_log_manual_caps =
 		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
 	dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
 				  KVM_DIRTY_LOG_INITIALLY_SET);
 
-#ifdef __x86_64__
-	guest_mode_init(VM_MODE_PXXV48_4K, true, true);
-#endif
-#ifdef __aarch64__
-	guest_mode_init(VM_MODE_P40V48_4K, true, true);
-	guest_mode_init(VM_MODE_P40V48_64K, true, true);
-
-	{
-		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
-
-		if (limit >= 52)
-			guest_mode_init(VM_MODE_P52V48_64K, true, true);
-		if (limit >= 48) {
-			guest_mode_init(VM_MODE_P48V48_4K, true, true);
-			guest_mode_init(VM_MODE_P48V48_64K, true, true);
-		}
-	}
-#endif
-#ifdef __s390x__
-	guest_mode_init(VM_MODE_P40V48_4K, true, true);
-#endif
+	guest_modes_append_default();
 
 	while ((opt = getopt(argc, argv, "hi:p:m:b:f:v:")) != -1) {
 		switch (opt) {
 		case 'i':
-			iterations = strtol(optarg, NULL, 10);
+			p.iterations = strtol(optarg, NULL, 10);
 			break;
 		case 'p':
-			phys_offset = strtoull(optarg, NULL, 0);
+			p.phys_offset = strtoull(optarg, NULL, 0);
 			break;
 		case 'm':
-			if (!mode_selected) {
-				for (i = 0; i < NUM_VM_MODES; ++i)
-					guest_modes[i].enabled = false;
-				mode_selected = true;
-			}
-			mode = strtoul(optarg, NULL, 10);
-			TEST_ASSERT(mode < NUM_VM_MODES,
-				    "Guest mode ID %d too big", mode);
-			guest_modes[mode].enabled = true;
+			guest_modes_cmdline(optarg);
 			break;
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
 			break;
 		case 'f':
-			wr_fract = atoi(optarg);
-			TEST_ASSERT(wr_fract >= 1,
+			p.wr_fract = atoi(optarg);
+			TEST_ASSERT(p.wr_fract >= 1,
 				    "Write fraction cannot be less than one");
 			break;
 		case 'v':
 			nr_vcpus = atoi(optarg);
-			TEST_ASSERT(nr_vcpus > 0,
-				    "Must have a positive number of vCPUs");
-			TEST_ASSERT(nr_vcpus <= MAX_VCPUS,
-				    "This test does not currently support\n"
-				    "more than %d vCPUs.", MAX_VCPUS);
+			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
+				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
 		case 'h':
 		default:
@@ -348,18 +302,11 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	TEST_ASSERT(iterations >= 2, "The test should have at least two iterations");
+	TEST_ASSERT(p.iterations >= 2, "The test should have at least two iterations");
 
-	pr_info("Test iterations: %"PRIu64"\n",	iterations);
+	pr_info("Test iterations: %"PRIu64"\n",	p.iterations);
 
-	for (i = 0; i < NUM_VM_MODES; ++i) {
-		if (!guest_modes[i].enabled)
-			continue;
-		TEST_ASSERT(guest_modes[i].supported,
-			    "Guest mode ID %d (%s) not supported.",
-			    i, vm_guest_mode_string(i));
-		run_test(i, iterations, phys_offset, wr_fract);
-	}
+	for_each_guest_mode(run_test, &p);
 
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 471baecb7772..bb2752d78fe3 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -9,8 +9,6 @@
 
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
-#include <time.h>
 #include <pthread.h>
 #include <semaphore.h>
 #include <sys/types.h>
@@ -20,8 +18,9 @@
 #include <linux/bitops.h>
 #include <asm/barrier.h>
 
-#include "test_util.h"
 #include "kvm_util.h"
+#include "test_util.h"
+#include "guest_modes.h"
 #include "processor.h"
 
 #define VCPU_ID				1
@@ -673,9 +672,15 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 #define DIRTY_MEM_BITS 30 /* 1G */
 #define PAGE_SHIFT_4K  12
 
-static void run_test(enum vm_guest_mode mode, unsigned long iterations,
-		     unsigned long interval, uint64_t phys_offset)
+struct test_params {
+	unsigned long iterations;
+	unsigned long interval;
+	uint64_t phys_offset;
+};
+
+static void run_test(enum vm_guest_mode mode, void *arg)
 {
+	struct test_params *p = arg;
 	struct kvm_vm *vm;
 	unsigned long *bmap;
 
@@ -709,12 +714,12 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	host_page_size = getpagesize();
 	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
 
-	if (!phys_offset) {
+	if (!p->phys_offset) {
 		guest_test_phys_mem = (vm_get_max_gfn(vm) -
 				       guest_num_pages) * guest_page_size;
 		guest_test_phys_mem &= ~(host_page_size - 1);
 	} else {
-		guest_test_phys_mem = phys_offset;
+		guest_test_phys_mem = p->phys_offset;
 	}
 
 #ifdef __s390x__
@@ -758,9 +763,9 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vm);
 
-	while (iteration < iterations) {
+	while (iteration < p->iterations) {
 		/* Give the vcpu thread some time to dirty some pages */
-		usleep(interval * 1000);
+		usleep(p->interval * 1000);
 		log_mode_collect_dirty_pages(vm, TEST_MEM_SLOT_INDEX,
 					     bmap, host_num_pages);
 		vm_dirty_log_verify(mode, bmap);
@@ -783,20 +788,8 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	kvm_vm_free(vm);
 }
 
-struct guest_mode {
-	bool supported;
-	bool enabled;
-};
-static struct guest_mode guest_modes[NUM_VM_MODES];
-
-#define guest_mode_init(mode, supported, enabled) ({ \
-	guest_modes[mode] = (struct guest_mode){ supported, enabled }; \
-})
-
 static void help(char *name)
 {
-	int i;
-
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-I interval] "
 	       "[-p offset] [-m mode]\n", name);
@@ -813,51 +806,23 @@ static void help(char *name)
 	printf(" -M: specify the host logging mode "
 	       "(default: run all log modes).  Supported modes: \n\t");
 	log_modes_dump();
-	printf(" -m: specify the guest mode ID to test "
-	       "(default: test all supported modes)\n"
-	       "     This option may be used multiple times.\n"
-	       "     Guest mode IDs:\n");
-	for (i = 0; i < NUM_VM_MODES; ++i) {
-		printf("         %d:    %s%s\n", i, vm_guest_mode_string(i),
-		       guest_modes[i].supported ? " (supported)" : "");
-	}
+	guest_modes_help();
 	puts("");
 	exit(0);
 }
 
 int main(int argc, char *argv[])
 {
-	unsigned long iterations = TEST_HOST_LOOP_N;
-	unsigned long interval = TEST_HOST_LOOP_INTERVAL;
-	bool mode_selected = false;
-	uint64_t phys_offset = 0;
-	unsigned int mode;
-	int opt, i, j;
+	struct test_params p = {
+		.iterations = TEST_HOST_LOOP_N,
+		.interval = TEST_HOST_LOOP_INTERVAL,
+	};
+	int opt, i;
 
 	sem_init(&dirty_ring_vcpu_stop, 0, 0);
 	sem_init(&dirty_ring_vcpu_cont, 0, 0);
 
-#ifdef __x86_64__
-	guest_mode_init(VM_MODE_PXXV48_4K, true, true);
-#endif
-#ifdef __aarch64__
-	guest_mode_init(VM_MODE_P40V48_4K, true, true);
-	guest_mode_init(VM_MODE_P40V48_64K, true, true);
-
-	{
-		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
-
-		if (limit >= 52)
-			guest_mode_init(VM_MODE_P52V48_64K, true, true);
-		if (limit >= 48) {
-			guest_mode_init(VM_MODE_P48V48_4K, true, true);
-			guest_mode_init(VM_MODE_P48V48_64K, true, true);
-		}
-	}
-#endif
-#ifdef __s390x__
-	guest_mode_init(VM_MODE_P40V48_4K, true, true);
-#endif
+	guest_modes_append_default();
 
 	while ((opt = getopt(argc, argv, "c:hi:I:p:m:M:")) != -1) {
 		switch (opt) {
@@ -865,24 +830,16 @@ int main(int argc, char *argv[])
 			test_dirty_ring_count = strtol(optarg, NULL, 10);
 			break;
 		case 'i':
-			iterations = strtol(optarg, NULL, 10);
+			p.iterations = strtol(optarg, NULL, 10);
 			break;
 		case 'I':
-			interval = strtol(optarg, NULL, 10);
+			p.interval = strtol(optarg, NULL, 10);
 			break;
 		case 'p':
-			phys_offset = strtoull(optarg, NULL, 0);
+			p.phys_offset = strtoull(optarg, NULL, 0);
 			break;
 		case 'm':
-			if (!mode_selected) {
-				for (i = 0; i < NUM_VM_MODES; ++i)
-					guest_modes[i].enabled = false;
-				mode_selected = true;
-			}
-			mode = strtoul(optarg, NULL, 10);
-			TEST_ASSERT(mode < NUM_VM_MODES,
-				    "Guest mode ID %d too big", mode);
-			guest_modes[mode].enabled = true;
+			guest_modes_cmdline(optarg);
 			break;
 		case 'M':
 			if (!strcmp(optarg, "all")) {
@@ -911,32 +868,24 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	TEST_ASSERT(iterations > 2, "Iterations must be greater than two");
-	TEST_ASSERT(interval > 0, "Interval must be greater than zero");
+	TEST_ASSERT(p.iterations > 2, "Iterations must be greater than two");
+	TEST_ASSERT(p.interval > 0, "Interval must be greater than zero");
 
 	pr_info("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
-		iterations, interval);
+		p.iterations, p.interval);
 
 	srandom(time(0));
 
-	for (i = 0; i < NUM_VM_MODES; ++i) {
-		if (!guest_modes[i].enabled)
-			continue;
-		TEST_ASSERT(guest_modes[i].supported,
-			    "Guest mode ID %d (%s) not supported.",
-			    i, vm_guest_mode_string(i));
-		if (host_log_mode_option == LOG_MODE_ALL) {
-			/* Run each log mode */
-			for (j = 0; j < LOG_MODE_NUM; j++) {
-				pr_info("Testing Log Mode '%s'\n",
-					log_modes[j].name);
-				host_log_mode = j;
-				run_test(i, iterations, interval, phys_offset);
-			}
-		} else {
-			host_log_mode = host_log_mode_option;
-			run_test(i, iterations, interval, phys_offset);
+	if (host_log_mode_option == LOG_MODE_ALL) {
+		/* Run each log mode */
+		for (i = 0; i < LOG_MODE_NUM; i++) {
+			pr_info("Testing Log Mode '%s'\n", log_modes[i].name);
+			host_log_mode = i;
+			for_each_guest_mode(run_test, &p);
 		}
+	} else {
+		host_log_mode = host_log_mode_option;
+		for_each_guest_mode(run_test, &p);
 	}
 
 	return 0;
diff --git a/tools/testing/selftests/kvm/include/guest_modes.h b/tools/testing/selftests/kvm/include/guest_modes.h
new file mode 100644
index 000000000000..b691df33e64e
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/guest_modes.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020, Red Hat, Inc.
+ */
+#include "kvm_util.h"
+
+struct guest_mode {
+	bool supported;
+	bool enabled;
+};
+
+extern struct guest_mode guest_modes[NUM_VM_MODES];
+
+#define guest_mode_append(mode, supported, enabled) ({ \
+	guest_modes[mode] = (struct guest_mode){ supported, enabled }; \
+})
+
+void guest_modes_append_default(void);
+void for_each_guest_mode(void (*func)(enum vm_guest_mode, void *), void *arg);
+void guest_modes_help(void);
+void guest_modes_cmdline(const char *arg);
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
new file mode 100644
index 000000000000..25bff307c71f
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020, Red Hat, Inc.
+ */
+#include "guest_modes.h"
+
+struct guest_mode guest_modes[NUM_VM_MODES];
+
+void guest_modes_append_default(void)
+{
+	guest_mode_append(VM_MODE_DEFAULT, true, true);
+
+#ifdef __aarch64__
+	guest_mode_append(VM_MODE_P40V48_64K, true, true);
+	{
+		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+		if (limit >= 52)
+			guest_mode_append(VM_MODE_P52V48_64K, true, true);
+		if (limit >= 48) {
+			guest_mode_append(VM_MODE_P48V48_4K, true, true);
+			guest_mode_append(VM_MODE_P48V48_64K, true, true);
+		}
+	}
+#endif
+}
+
+void for_each_guest_mode(void (*func)(enum vm_guest_mode, void *), void *arg)
+{
+	int i;
+
+	for (i = 0; i < NUM_VM_MODES; ++i) {
+		if (!guest_modes[i].enabled)
+			continue;
+		TEST_ASSERT(guest_modes[i].supported,
+			    "Guest mode ID %d (%s) not supported.",
+			    i, vm_guest_mode_string(i));
+		func(i, arg);
+	}
+}
+
+void guest_modes_help(void)
+{
+	int i;
+
+	printf(" -m: specify the guest mode ID to test\n"
+	       "     (default: test all supported modes)\n"
+	       "     This option may be used multiple times.\n"
+	       "     Guest mode IDs:\n");
+	for (i = 0; i < NUM_VM_MODES; ++i) {
+		printf("         %d:    %s%s\n", i, vm_guest_mode_string(i),
+		       guest_modes[i].supported ? " (supported)" : "");
+	}
+}
+
+void guest_modes_cmdline(const char *arg)
+{
+	static bool mode_selected;
+	unsigned int mode;
+	int i;
+
+	if (!mode_selected) {
+		for (i = 0; i < NUM_VM_MODES; ++i)
+			guest_modes[i].enabled = false;
+		mode_selected = true;
+	}
+
+	mode = strtoul(optarg, NULL, 10);
+	TEST_ASSERT(mode < NUM_VM_MODES, "Guest mode ID %d too big", mode);
+	guest_modes[mode].enabled = true;
+}
-- 
2.26.2

