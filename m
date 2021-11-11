Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B6A44CE27
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhKKAP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbhKKAPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:15:52 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61567C061203
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:13:04 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id q2-20020a170902dac200b001422673d86fso2072072plx.20
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lIJVWQ2zPdpZoHhHHhcf804AT8i7DH5b+tmyTZBIeQQ=;
        b=gCHmer2B6Lq2CfZiQmtwMIxSAWLtPfiUN/zXAus9ZmMNGLzsBg9s0vktnJkdgg/2Um
         rDTf3UoWuaUh3IbV4fIiQH4xjpvvdu/jmoxehu1fl3Kbbaz53Jr3YBVvmwIDsKqg9y2D
         ZVkDud0XW5nzKxO9mEFn1yQWTzyO/zu178oPCcAU3wSqNoKb179MBxx+ZbVBo1e/XCvm
         X9sD5dBw0z0xdL6c6zux1gsVuwHwGR+hD7ful7oMsMwPvEcUK7jx5WKKADlwkzzfLkB0
         m+Tkp1URUF5aFZuEro95ZlbJPLx/AfkGxPX8WhJAM38tttLFMlECT6l69UWGprQOjDL6
         Ve9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lIJVWQ2zPdpZoHhHHhcf804AT8i7DH5b+tmyTZBIeQQ=;
        b=vxGsNYViN0n8DvQtgqqxYN5Sf14+rRmWddLeY1n/gOxupPvtEnDPM169BONygJ+9qm
         PPKRURKyz52hBAoVgjOPcp6Ft8v+0ZpuFFr2MZScpnJ+8uSV9mYebUFm0jJi0OguxVOv
         YxJGD5i5JPYo4mfAxg48yv9IrFxZjY4MTdwxOvT7yVyJL7EuxXywqur0WlZ2Sxp7nHHs
         cyyJ2oU/1oaTuRQ9fI3zIrpbENO5l7K6ek7oYtQKYf3ToM8La5QN4jx8hX+Cb0cRl65b
         Laeoto2ED94aqRGjdlZEOhGIKAhr+2VY2tWs2tJMXaVcYIWCMs16Nhzs37j1UZXkDwAE
         50KQ==
X-Gm-Message-State: AOAM530383y7Kcs/gh+qIJcTfrKGzOeckqgNuHafMrnubcCPm54GDvHV
        t8IH25PQBgAM7tGVfElTBZZFR2GEthcQ5A==
X-Google-Smtp-Source: ABdhPJwFxasxanRq1EGfhKmsdZVAut8gQD6PzOQISjqqUlLQKCTnCFsjkdLcPIGV+/kAZjobMKZwPOZpn7dRPg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:e7d0:: with SMTP id
 kb16mr3579732pjb.22.1636589583866; Wed, 10 Nov 2021 16:13:03 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:12:55 +0000
In-Reply-To: <20211111001257.1446428-1-dmatlack@google.com>
Message-Id: <20211111001257.1446428-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111001257.1446428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 2/4] KVM: selftests: Move vCPU thread creation and joining to
 common helpers
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move vCPU thread creation and joining to common helper functions. This
is in preparation for the next commit which ensures that all vCPU
threads are fully created before entering guest mode on any one
vCPU.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c | 40 +++-------------
 .../selftests/kvm/demand_paging_test.c        | 25 ++--------
 .../selftests/kvm/dirty_log_perf_test.c       | 19 ++------
 .../selftests/kvm/include/perf_test_util.h    |  5 ++
 .../selftests/kvm/lib/perf_test_util.c        | 46 +++++++++++++++++++
 .../kvm/memslot_modification_stress_test.c    | 22 ++-------
 6 files changed, 67 insertions(+), 90 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 7f25a06e19c9..d8909032317a 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -215,9 +215,8 @@ static bool spin_wait_for_next_iteration(int *current_iteration)
 	return true;
 }
 
-static void *vcpu_thread_main(void *arg)
+static void vcpu_thread_main(struct perf_test_vcpu_args *vcpu_args)
 {
-	struct perf_test_vcpu_args *vcpu_args = arg;
 	struct kvm_vm *vm = perf_test_args.vm;
 	int vcpu_id = vcpu_args->vcpu_id;
 	int current_iteration = 0;
@@ -235,8 +234,6 @@ static void *vcpu_thread_main(void *arg)
 
 		vcpu_last_completed_iteration[vcpu_id] = current_iteration;
 	}
-
-	return NULL;
 }
 
 static void spin_wait_for_vcpu(int vcpu_id, int target_iteration)
@@ -295,43 +292,16 @@ static void mark_memory_idle(struct kvm_vm *vm, int vcpus)
 	run_iteration(vm, vcpus, "Mark memory idle");
 }
 
-static pthread_t *create_vcpu_threads(int vcpus)
-{
-	pthread_t *vcpu_threads;
-	int i;
-
-	vcpu_threads = malloc(vcpus * sizeof(vcpu_threads[0]));
-	TEST_ASSERT(vcpu_threads, "Failed to allocate vcpu_threads.");
-
-	for (i = 0; i < vcpus; i++)
-		pthread_create(&vcpu_threads[i], NULL, vcpu_thread_main,
-			       &perf_test_args.vcpu_args[i]);
-
-	return vcpu_threads;
-}
-
-static void terminate_vcpu_threads(pthread_t *vcpu_threads, int vcpus)
-{
-	int i;
-
-	/* Set done to signal the vCPU threads to exit */
-	done = true;
-
-	for (i = 0; i < vcpus; i++)
-		pthread_join(vcpu_threads[i], NULL);
-}
-
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *params = arg;
 	struct kvm_vm *vm;
-	pthread_t *vcpu_threads;
 	int vcpus = params->vcpus;
 
 	vm = perf_test_create_vm(mode, vcpus, params->vcpu_memory_bytes, 1,
 				 params->backing_src, !overlap_memory_access);
 
-	vcpu_threads = create_vcpu_threads(vcpus);
+	perf_test_start_vcpu_threads(vcpus, vcpu_thread_main);
 
 	pr_info("\n");
 	access_memory(vm, vcpus, ACCESS_WRITE, "Populating memory");
@@ -346,8 +316,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	mark_memory_idle(vm, vcpus);
 	access_memory(vm, vcpus, ACCESS_READ, "Reading from idle memory");
 
-	terminate_vcpu_threads(vcpu_threads, vcpus);
-	free(vcpu_threads);
+	/* Set done to signal the vCPU threads to exit */
+	done = true;
+
+	perf_test_join_vcpu_threads(vcpus);
 	perf_test_destroy_vm(vm);
 }
 
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 26f8fd8a57ec..6a719d065599 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -42,10 +42,9 @@ static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 static size_t demand_paging_size;
 static char *guest_data_prototype;
 
-static void *vcpu_worker(void *data)
+static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 {
 	int ret;
-	struct perf_test_vcpu_args *vcpu_args = (struct perf_test_vcpu_args *)data;
 	int vcpu_id = vcpu_args->vcpu_id;
 	struct kvm_vm *vm = perf_test_args.vm;
 	struct kvm_run *run;
@@ -68,8 +67,6 @@ static void *vcpu_worker(void *data)
 	ts_diff = timespec_elapsed(start);
 	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_id,
 		       ts_diff.tv_sec, ts_diff.tv_nsec);
-
-	return NULL;
 }
 
 static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t addr)
@@ -282,7 +279,6 @@ struct test_params {
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *p = arg;
-	pthread_t *vcpu_threads;
 	pthread_t *uffd_handler_threads = NULL;
 	struct uffd_handler_args *uffd_args = NULL;
 	struct timespec start;
@@ -302,9 +298,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		    "Failed to allocate buffer for guest data pattern");
 	memset(guest_data_prototype, 0xAB, demand_paging_size);
 
-	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
-	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
-
 	if (p->uffd_mode) {
 		uffd_handler_threads =
 			malloc(nr_vcpus * sizeof(*uffd_handler_threads));
@@ -346,22 +339,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Finished creating vCPUs and starting uffd threads\n");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
-
-	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
-		pthread_create(&vcpu_threads[vcpu_id], NULL, vcpu_worker,
-			       &perf_test_args.vcpu_args[vcpu_id]);
-	}
-
+	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
 	pr_info("Started all vCPUs\n");
 
-	/* Wait for the vcpu threads to quit */
-	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
-		pthread_join(vcpu_threads[vcpu_id], NULL);
-		PER_VCPU_DEBUG("Joined thread for vCPU %d\n", vcpu_id);
-	}
-
+	perf_test_join_vcpu_threads(nr_vcpus);
 	ts_diff = timespec_elapsed(start);
-
 	pr_info("All vCPU threads joined\n");
 
 	if (p->uffd_mode) {
@@ -385,7 +367,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	perf_test_destroy_vm(vm);
 
 	free(guest_data_prototype);
-	free(vcpu_threads);
 	if (p->uffd_mode) {
 		free(uffd_handler_threads);
 		free(uffd_args);
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 583b4d95aa98..1954b964d1cf 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -31,7 +31,7 @@ static bool host_quit;
 static int iteration;
 static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
 
-static void *vcpu_worker(void *data)
+static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 {
 	int ret;
 	struct kvm_vm *vm = perf_test_args.vm;
@@ -41,7 +41,6 @@ static void *vcpu_worker(void *data)
 	struct timespec ts_diff;
 	struct timespec total = (struct timespec){0};
 	struct timespec avg;
-	struct perf_test_vcpu_args *vcpu_args = (struct perf_test_vcpu_args *)data;
 	int vcpu_id = vcpu_args->vcpu_id;
 
 	run = vcpu_state(vm, vcpu_id);
@@ -83,8 +82,6 @@ static void *vcpu_worker(void *data)
 	pr_debug("\nvCPU %d dirtied 0x%lx pages over %d iterations in %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
 		vcpu_id, pages_count, vcpu_last_completed_iteration[vcpu_id],
 		total.tv_sec, total.tv_nsec, avg.tv_sec, avg.tv_nsec);
-
-	return NULL;
 }
 
 struct test_params {
@@ -170,7 +167,6 @@ static void free_bitmaps(unsigned long *bitmaps[], int slots)
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *p = arg;
-	pthread_t *vcpu_threads;
 	struct kvm_vm *vm;
 	unsigned long **bitmaps;
 	uint64_t guest_num_pages;
@@ -204,20 +200,15 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		vm_enable_cap(vm, &cap);
 	}
 
-	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
-	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
-
 	/* Start the iterations */
 	iteration = 0;
 	host_quit = false;
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
-	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
+	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
 		vcpu_last_completed_iteration[vcpu_id] = -1;
 
-		pthread_create(&vcpu_threads[vcpu_id], NULL, vcpu_worker,
-			       &perf_test_args.vcpu_args[vcpu_id]);
-	}
+	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
 
 	/* Allow the vCPUs to populate memory */
 	pr_debug("Starting iteration %d - Populating\n", iteration);
@@ -286,8 +277,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	/* Tell the vcpu thread to quit */
 	host_quit = true;
-	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
-		pthread_join(vcpu_threads[vcpu_id], NULL);
+	perf_test_join_vcpu_threads(nr_vcpus);
 
 	avg = timespec_div(get_dirty_log_total, p->iterations);
 	pr_info("Get dirty log over %lu iterations took %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
@@ -302,7 +292,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	}
 
 	free_bitmaps(bitmaps, p->slots);
-	free(vcpu_threads);
 	perf_test_destroy_vm(vm);
 }
 
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 74e3622b3a6e..a86f953d8d36 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -8,6 +8,8 @@
 #ifndef SELFTEST_KVM_PERF_TEST_UTIL_H
 #define SELFTEST_KVM_PERF_TEST_UTIL_H
 
+#include <pthread.h>
+
 #include "kvm_util.h"
 
 /* Default guest test virtual memory offset */
@@ -45,4 +47,7 @@ void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
 
+void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
+void perf_test_join_vcpu_threads(int vcpus);
+
 #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 77f9eb5667c9..d646477ed16a 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -16,6 +16,20 @@ struct perf_test_args perf_test_args;
  */
 static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
 
+struct vcpu_thread {
+	/* The id of the vCPU. */
+	int vcpu_id;
+
+	/* The pthread backing the vCPU. */
+	pthread_t thread;
+};
+
+/* The vCPU threads involved in this test. */
+static struct vcpu_thread vcpu_threads[KVM_MAX_VCPUS];
+
+/* The function run by each vCPU thread, as provided by the test. */
+static void (*vcpu_thread_fn)(struct perf_test_vcpu_args *);
+
 /*
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
@@ -177,3 +191,35 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
 	perf_test_args.wr_fract = wr_fract;
 	sync_global_to_guest(vm, perf_test_args);
 }
+
+static void *vcpu_thread_main(void *data)
+{
+	struct vcpu_thread *vcpu = data;
+
+	vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_id]);
+
+	return NULL;
+}
+
+void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *))
+{
+	int vcpu_id;
+
+	vcpu_thread_fn = vcpu_fn;
+
+	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
+		struct vcpu_thread *vcpu = &vcpu_threads[vcpu_id];
+
+		vcpu->vcpu_id = vcpu_id;
+
+		pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
+	}
+}
+
+void perf_test_join_vcpu_threads(int vcpus)
+{
+	int vcpu_id;
+
+	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++)
+		pthread_join(vcpu_threads[vcpu_id].thread, NULL);
+}
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index df431d0da1ee..5bd0b076f57f 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -36,11 +36,9 @@ static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 
 static bool run_vcpus = true;
 
-static void *vcpu_worker(void *data)
+static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 {
 	int ret;
-	struct perf_test_vcpu_args *vcpu_args =
-		(struct perf_test_vcpu_args *)data;
 	int vcpu_id = vcpu_args->vcpu_id;
 	struct kvm_vm *vm = perf_test_args.vm;
 	struct kvm_run *run;
@@ -59,8 +57,6 @@ static void *vcpu_worker(void *data)
 			    "Invalid guest sync status: exit_reason=%s\n",
 			    exit_reason_str(run->exit_reason));
 	}
-
-	return NULL;
 }
 
 struct memslot_antagonist_args {
@@ -100,22 +96,15 @@ struct test_params {
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *p = arg;
-	pthread_t *vcpu_threads;
 	struct kvm_vm *vm;
-	int vcpu_id;
 
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 VM_MEM_SRC_ANONYMOUS,
 				 p->partition_vcpu_memory_access);
 
-	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
-	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
-
 	pr_info("Finished creating vCPUs\n");
 
-	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
-		pthread_create(&vcpu_threads[vcpu_id], NULL, vcpu_worker,
-			       &perf_test_args.vcpu_args[vcpu_id]);
+	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
 
 	pr_info("Started all vCPUs\n");
 
@@ -124,16 +113,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	run_vcpus = false;
 
-	/* Wait for the vcpu threads to quit */
-	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
-		pthread_join(vcpu_threads[vcpu_id], NULL);
-
+	perf_test_join_vcpu_threads(nr_vcpus);
 	pr_info("All vCPU threads joined\n");
 
 	ucall_uninit(vm);
 	kvm_vm_free(vm);
-
-	free(vcpu_threads);
 }
 
 static void help(char *name)
-- 
2.34.0.rc1.387.gb447b232ab-goog

