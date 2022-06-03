Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B5253C26D
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240520AbiFCA4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241081AbiFCAuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:24 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F542CDC9
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:31 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id lk16-20020a17090b33d000b001e68a9ac3a1so1811969pjb.2
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=54xKbfPbda9lBq/BIyn5SRIOrNNvMYE4n4hqgy0RumE=;
        b=aG/sFQu9HYtAa1UcjSFsSiVpG0nwqEym2G5MqAhissHp7TKP+0HZ+Jz5T5ewWMTenh
         9LVR4rVyu1if32kUAuz7N+2VvCtoOABKAW11in9aawQOg+sNxfJ4sfBo1Z8o6mK4P5yD
         dB/4sBeuEi08D0GABNYs5WW18Mv+J3jzDYVlWB/3XiI/psvu9VAqg2TVIgp8rlSdXC1A
         WUHnCyulQ9Wgmjfa3YSsOVjgCbW38Zimp70faC+de1CajW1BVVurQ7XTdRQLTk2DVHKD
         XM5oyZwE8EsrZWuADF7VJ1QL4eUMoV+YGrDLqx6HfHti2TNg2VF02dQfzSHqtaoT5Tfr
         uSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=54xKbfPbda9lBq/BIyn5SRIOrNNvMYE4n4hqgy0RumE=;
        b=OSNYUMT7AmQ2R/eURa/ephj2I7MJtkzdFySi1XkRIsL97+/qCgtA3C0KwM+BysNF4k
         7HxaLEMSnFzEfL3xMNmDEY2FtPecJ8s3UhrOxfZEOREjxppQ0foQk1ts8xrdPP37r2YL
         OTC9O7yBfIOPFUMC1W6lZyVfLzSgucZ90kzuNia1N5VRaXDbVB7b0PuO8JNUPj2QWZA6
         9XxXZ1s9Icese/+XX1ZMkWqHmfgLJoLDjzsRqdjtkhj4387LfeSp1z7FD24SN3R7x52u
         hhwYfxjLT5Drz69r0uAm3ZlvRL70ETHZ1lbadW0S0PuIXSKjA0eEy4rzaa+LFzJBMEob
         UKxA==
X-Gm-Message-State: AOAM533RAYTE3SpZjhW2TenBC2Yht/Y043UXtiFAAyQRpLFW1+EChdQp
        YEaSA/RpoLDSRdJVczTFhBy/fC8DFGA=
X-Google-Smtp-Source: ABdhPJxveH31583Uxbe3E1pXIi+Ta1AdmoE0UAVCoe0VGB/zY5VznOrXKSJZaY4CtJh7FXK0+RO8y6nZ5UU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d64d:b0:162:3595:220c with SMTP id
 y13-20020a170902d64d00b001623595220cmr7810528plh.10.1654217249696; Thu, 02
 Jun 2022 17:47:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:16 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-130-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 129/144] KVM: selftests: Stop conflating vCPU index and ID
 in perf tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Track vCPUs by their 'struct kvm_vcpu' object, and stop assuming that a
vCPU's ID is the same as its index when referencing a vCPU's metadata.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c | 81 ++++++++++---------
 .../selftests/kvm/demand_paging_test.c        | 36 ++++-----
 .../selftests/kvm/dirty_log_perf_test.c       | 39 ++++-----
 .../selftests/kvm/include/perf_test_util.h    |  5 +-
 .../selftests/kvm/lib/perf_test_util.c        | 79 +++++++++---------
 .../kvm/memslot_modification_stress_test.c    | 10 +--
 6 files changed, 129 insertions(+), 121 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index d8909032317a..86a90222f913 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -74,7 +74,7 @@ struct test_params {
 	uint64_t vcpu_memory_bytes;
 
 	/* The number of vCPUs to create in the VM. */
-	int vcpus;
+	int nr_vcpus;
 };
 
 static uint64_t pread_uint64(int fd, const char *filename, uint64_t index)
@@ -127,10 +127,12 @@ static void mark_page_idle(int page_idle_fd, uint64_t pfn)
 		    "Set page_idle bits for PFN 0x%" PRIx64, pfn);
 }
 
-static void mark_vcpu_memory_idle(struct kvm_vm *vm, int vcpu_id)
+static void mark_vcpu_memory_idle(struct kvm_vm *vm,
+				  struct perf_test_vcpu_args *vcpu_args)
 {
-	uint64_t base_gva = perf_test_args.vcpu_args[vcpu_id].gva;
-	uint64_t pages = perf_test_args.vcpu_args[vcpu_id].pages;
+	int vcpu_idx = vcpu_args->vcpu_idx;
+	uint64_t base_gva = vcpu_args->gva;
+	uint64_t pages = vcpu_args->pages;
 	uint64_t page;
 	uint64_t still_idle = 0;
 	uint64_t no_pfn = 0;
@@ -138,7 +140,7 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm, int vcpu_id)
 	int pagemap_fd;
 
 	/* If vCPUs are using an overlapping region, let vCPU 0 mark it idle. */
-	if (overlap_memory_access && vcpu_id)
+	if (overlap_memory_access && vcpu_idx)
 		return;
 
 	page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
@@ -170,7 +172,7 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm, int vcpu_id)
 	 */
 	TEST_ASSERT(no_pfn < pages / 100,
 		    "vCPU %d: No PFN for %" PRIu64 " out of %" PRIu64 " pages.",
-		    vcpu_id, no_pfn, pages);
+		    vcpu_idx, no_pfn, pages);
 
 	/*
 	 * Test that at least 90% of memory has been marked idle (the rest might
@@ -183,17 +185,16 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm, int vcpu_id)
 	TEST_ASSERT(still_idle < pages / 10,
 		    "vCPU%d: Too many pages still idle (%"PRIu64 " out of %"
 		    PRIu64 ").\n",
-		    vcpu_id, still_idle, pages);
+		    vcpu_idx, still_idle, pages);
 
 	close(page_idle_fd);
 	close(pagemap_fd);
 }
 
-static void assert_ucall(struct kvm_vm *vm, uint32_t vcpu_id,
-			 uint64_t expected_ucall)
+static void assert_ucall(struct kvm_vcpu *vcpu, uint64_t expected_ucall)
 {
 	struct ucall uc;
-	uint64_t actual_ucall = get_ucall(vm, vcpu_id, &uc);
+	uint64_t actual_ucall = get_ucall(vcpu->vm, vcpu->id, &uc);
 
 	TEST_ASSERT(expected_ucall == actual_ucall,
 		    "Guest exited unexpectedly (expected ucall %" PRIu64
@@ -217,28 +218,29 @@ static bool spin_wait_for_next_iteration(int *current_iteration)
 
 static void vcpu_thread_main(struct perf_test_vcpu_args *vcpu_args)
 {
+	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	struct kvm_vm *vm = perf_test_args.vm;
-	int vcpu_id = vcpu_args->vcpu_id;
+	int vcpu_idx = vcpu_args->vcpu_idx;
 	int current_iteration = 0;
 
 	while (spin_wait_for_next_iteration(&current_iteration)) {
 		switch (READ_ONCE(iteration_work)) {
 		case ITERATION_ACCESS_MEMORY:
-			vcpu_run(vm, vcpu_id);
-			assert_ucall(vm, vcpu_id, UCALL_SYNC);
+			vcpu_run(vm, vcpu->id);
+			assert_ucall(vcpu, UCALL_SYNC);
 			break;
 		case ITERATION_MARK_IDLE:
-			mark_vcpu_memory_idle(vm, vcpu_id);
+			mark_vcpu_memory_idle(vm, vcpu_args);
 			break;
 		};
 
-		vcpu_last_completed_iteration[vcpu_id] = current_iteration;
+		vcpu_last_completed_iteration[vcpu_idx] = current_iteration;
 	}
 }
 
-static void spin_wait_for_vcpu(int vcpu_id, int target_iteration)
+static void spin_wait_for_vcpu(int vcpu_idx, int target_iteration)
 {
-	while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) !=
+	while (READ_ONCE(vcpu_last_completed_iteration[vcpu_idx]) !=
 	       target_iteration) {
 		continue;
 	}
@@ -250,12 +252,11 @@ enum access_type {
 	ACCESS_WRITE,
 };
 
-static void run_iteration(struct kvm_vm *vm, int vcpus, const char *description)
+static void run_iteration(struct kvm_vm *vm, int nr_vcpus, const char *description)
 {
 	struct timespec ts_start;
 	struct timespec ts_elapsed;
-	int next_iteration;
-	int vcpu_id;
+	int next_iteration, i;
 
 	/* Kick off the vCPUs by incrementing iteration. */
 	next_iteration = ++iteration;
@@ -263,23 +264,23 @@ static void run_iteration(struct kvm_vm *vm, int vcpus, const char *description)
 	clock_gettime(CLOCK_MONOTONIC, &ts_start);
 
 	/* Wait for all vCPUs to finish the iteration. */
-	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++)
-		spin_wait_for_vcpu(vcpu_id, next_iteration);
+	for (i = 0; i < nr_vcpus; i++)
+		spin_wait_for_vcpu(i, next_iteration);
 
 	ts_elapsed = timespec_elapsed(ts_start);
 	pr_info("%-30s: %ld.%09lds\n",
 		description, ts_elapsed.tv_sec, ts_elapsed.tv_nsec);
 }
 
-static void access_memory(struct kvm_vm *vm, int vcpus, enum access_type access,
-			  const char *description)
+static void access_memory(struct kvm_vm *vm, int nr_vcpus,
+			  enum access_type access, const char *description)
 {
 	perf_test_set_wr_fract(vm, (access == ACCESS_READ) ? INT_MAX : 1);
 	iteration_work = ITERATION_ACCESS_MEMORY;
-	run_iteration(vm, vcpus, description);
+	run_iteration(vm, nr_vcpus, description);
 }
 
-static void mark_memory_idle(struct kvm_vm *vm, int vcpus)
+static void mark_memory_idle(struct kvm_vm *vm, int nr_vcpus)
 {
 	/*
 	 * Even though this parallelizes the work across vCPUs, this is still a
@@ -289,37 +290,37 @@ static void mark_memory_idle(struct kvm_vm *vm, int vcpus)
 	 */
 	pr_debug("Marking VM memory idle (slow)...\n");
 	iteration_work = ITERATION_MARK_IDLE;
-	run_iteration(vm, vcpus, "Mark memory idle");
+	run_iteration(vm, nr_vcpus, "Mark memory idle");
 }
 
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *params = arg;
 	struct kvm_vm *vm;
-	int vcpus = params->vcpus;
+	int nr_vcpus = params->nr_vcpus;
 
-	vm = perf_test_create_vm(mode, vcpus, params->vcpu_memory_bytes, 1,
+	vm = perf_test_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
 				 params->backing_src, !overlap_memory_access);
 
-	perf_test_start_vcpu_threads(vcpus, vcpu_thread_main);
+	perf_test_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
 
 	pr_info("\n");
-	access_memory(vm, vcpus, ACCESS_WRITE, "Populating memory");
+	access_memory(vm, nr_vcpus, ACCESS_WRITE, "Populating memory");
 
 	/* As a control, read and write to the populated memory first. */
-	access_memory(vm, vcpus, ACCESS_WRITE, "Writing to populated memory");
-	access_memory(vm, vcpus, ACCESS_READ, "Reading from populated memory");
+	access_memory(vm, nr_vcpus, ACCESS_WRITE, "Writing to populated memory");
+	access_memory(vm, nr_vcpus, ACCESS_READ, "Reading from populated memory");
 
 	/* Repeat on memory that has been marked as idle. */
-	mark_memory_idle(vm, vcpus);
-	access_memory(vm, vcpus, ACCESS_WRITE, "Writing to idle memory");
-	mark_memory_idle(vm, vcpus);
-	access_memory(vm, vcpus, ACCESS_READ, "Reading from idle memory");
+	mark_memory_idle(vm, nr_vcpus);
+	access_memory(vm, nr_vcpus, ACCESS_WRITE, "Writing to idle memory");
+	mark_memory_idle(vm, nr_vcpus);
+	access_memory(vm, nr_vcpus, ACCESS_READ, "Reading from idle memory");
 
 	/* Set done to signal the vCPU threads to exit */
 	done = true;
 
-	perf_test_join_vcpu_threads(vcpus);
+	perf_test_join_vcpu_threads(nr_vcpus);
 	perf_test_destroy_vm(vm);
 }
 
@@ -347,7 +348,7 @@ int main(int argc, char *argv[])
 	struct test_params params = {
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.vcpu_memory_bytes = DEFAULT_PER_VCPU_MEM_SIZE,
-		.vcpus = 1,
+		.nr_vcpus = 1,
 	};
 	int page_idle_fd;
 	int opt;
@@ -363,7 +364,7 @@ int main(int argc, char *argv[])
 			params.vcpu_memory_bytes = parse_size(optarg);
 			break;
 		case 'v':
-			params.vcpus = atoi(optarg);
+			params.nr_vcpus = atoi(optarg);
 			break;
 		case 'o':
 			overlap_memory_access = true;
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index d8db0a37e973..c46110721088 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -44,28 +44,27 @@ static char *guest_data_prototype;
 
 static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 {
-	int ret;
-	int vcpu_id = vcpu_args->vcpu_id;
+	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	struct kvm_vm *vm = perf_test_args.vm;
-	struct kvm_run *run;
+	int vcpu_idx = vcpu_args->vcpu_idx;
+	struct kvm_run *run = vcpu->run;
 	struct timespec start;
 	struct timespec ts_diff;
-
-	run = vcpu_state(vm, vcpu_id);
+	int ret;
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
 
 	/* Let the guest access its memory */
-	ret = _vcpu_run(vm, vcpu_id);
+	ret = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-	if (get_ucall(vm, vcpu_id, NULL) != UCALL_SYNC) {
+	if (get_ucall(vm, vcpu->id, NULL) != UCALL_SYNC) {
 		TEST_ASSERT(false,
 			    "Invalid guest sync status: exit_reason=%s\n",
 			    exit_reason_str(run->exit_reason));
 	}
 
 	ts_diff = timespec_elapsed(start);
-	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_id,
+	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_idx,
 		       ts_diff.tv_sec, ts_diff.tv_nsec);
 }
 
@@ -285,8 +284,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec ts_diff;
 	int *pipefds = NULL;
 	struct kvm_vm *vm;
-	int vcpu_id;
-	int r;
+	int r, i;
 
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
@@ -309,12 +307,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		pipefds = malloc(sizeof(int) * nr_vcpus * 2);
 		TEST_ASSERT(pipefds, "Unable to allocate memory for pipefd");
 
-		for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
+		for (i = 0; i < nr_vcpus; i++) {
 			struct perf_test_vcpu_args *vcpu_args;
 			void *vcpu_hva;
 			void *vcpu_alias;
 
-			vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
+			vcpu_args = &perf_test_args.vcpu_args[i];
 
 			/* Cache the host addresses of the region */
 			vcpu_hva = addr_gpa2hva(vm, vcpu_args->gpa);
@@ -324,13 +322,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			 * Set up user fault fd to handle demand paging
 			 * requests.
 			 */
-			r = pipe2(&pipefds[vcpu_id * 2],
+			r = pipe2(&pipefds[i * 2],
 				  O_CLOEXEC | O_NONBLOCK);
 			TEST_ASSERT(!r, "Failed to set up pipefd");
 
-			setup_demand_paging(vm, &uffd_handler_threads[vcpu_id],
-					    pipefds[vcpu_id * 2], p->uffd_mode,
-					    p->uffd_delay, &uffd_args[vcpu_id],
+			setup_demand_paging(vm, &uffd_handler_threads[i],
+					    pipefds[i * 2], p->uffd_mode,
+					    p->uffd_delay, &uffd_args[i],
 					    vcpu_hva, vcpu_alias,
 					    vcpu_args->pages * perf_test_args.guest_page_size);
 		}
@@ -350,11 +348,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		char c;
 
 		/* Tell the user fault fd handler threads to quit */
-		for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
-			r = write(pipefds[vcpu_id * 2 + 1], &c, 1);
+		for (i = 0; i < nr_vcpus; i++) {
+			r = write(pipefds[i * 2 + 1], &c, 1);
 			TEST_ASSERT(r == 1, "Unable to write to pipefd");
 
-			pthread_join(uffd_handler_threads[vcpu_id], NULL);
+			pthread_join(uffd_handler_threads[i], NULL);
 		}
 	}
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index c9acf0c3f016..7b71ebf508b0 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -68,44 +68,45 @@ static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
 
 static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 {
-	int ret;
+	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	struct kvm_vm *vm = perf_test_args.vm;
+	int vcpu_idx = vcpu_args->vcpu_idx;
 	uint64_t pages_count = 0;
 	struct kvm_run *run;
 	struct timespec start;
 	struct timespec ts_diff;
 	struct timespec total = (struct timespec){0};
 	struct timespec avg;
-	int vcpu_id = vcpu_args->vcpu_id;
+	int ret;
 
-	run = vcpu_state(vm, vcpu_id);
+	run = vcpu->run;
 
 	while (!READ_ONCE(host_quit)) {
 		int current_iteration = READ_ONCE(iteration);
 
 		clock_gettime(CLOCK_MONOTONIC, &start);
-		ret = _vcpu_run(vm, vcpu_id);
+		ret = _vcpu_run(vm, vcpu->id);
 		ts_diff = timespec_elapsed(start);
 
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-		TEST_ASSERT(get_ucall(vm, vcpu_id, NULL) == UCALL_SYNC,
+		TEST_ASSERT(get_ucall(vm, vcpu->id, NULL) == UCALL_SYNC,
 			    "Invalid guest sync status: exit_reason=%s\n",
 			    exit_reason_str(run->exit_reason));
 
-		pr_debug("Got sync event from vCPU %d\n", vcpu_id);
-		vcpu_last_completed_iteration[vcpu_id] = current_iteration;
+		pr_debug("Got sync event from vCPU %d\n", vcpu_idx);
+		vcpu_last_completed_iteration[vcpu_idx] = current_iteration;
 		pr_debug("vCPU %d updated last completed iteration to %d\n",
-			 vcpu_id, vcpu_last_completed_iteration[vcpu_id]);
+			 vcpu->id, vcpu_last_completed_iteration[vcpu_idx]);
 
 		if (current_iteration) {
 			pages_count += vcpu_args->pages;
 			total = timespec_add(total, ts_diff);
 			pr_debug("vCPU %d iteration %d dirty memory time: %ld.%.9lds\n",
-				vcpu_id, current_iteration, ts_diff.tv_sec,
+				vcpu_idx, current_iteration, ts_diff.tv_sec,
 				ts_diff.tv_nsec);
 		} else {
 			pr_debug("vCPU %d iteration %d populate memory time: %ld.%.9lds\n",
-				vcpu_id, current_iteration, ts_diff.tv_sec,
+				vcpu_idx, current_iteration, ts_diff.tv_sec,
 				ts_diff.tv_nsec);
 		}
 
@@ -113,9 +114,9 @@ static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 		       !READ_ONCE(host_quit)) {}
 	}
 
-	avg = timespec_div(total, vcpu_last_completed_iteration[vcpu_id]);
+	avg = timespec_div(total, vcpu_last_completed_iteration[vcpu_idx]);
 	pr_debug("\nvCPU %d dirtied 0x%lx pages over %d iterations in %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
-		vcpu_id, pages_count, vcpu_last_completed_iteration[vcpu_id],
+		vcpu_idx, pages_count, vcpu_last_completed_iteration[vcpu_idx],
 		total.tv_sec, total.tv_nsec, avg.tv_sec, avg.tv_nsec);
 }
 
@@ -207,13 +208,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	uint64_t guest_num_pages;
 	uint64_t host_num_pages;
 	uint64_t pages_per_slot;
-	int vcpu_id;
 	struct timespec start;
 	struct timespec ts_diff;
 	struct timespec get_dirty_log_total = (struct timespec){0};
 	struct timespec vcpu_dirty_total = (struct timespec){0};
 	struct timespec avg;
 	struct timespec clear_dirty_log_total = (struct timespec){0};
+	int i;
 
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
 				 p->slots, p->backing_src,
@@ -239,15 +240,15 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	host_quit = false;
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
-	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
-		vcpu_last_completed_iteration[vcpu_id] = -1;
+	for (i = 0; i < nr_vcpus; i++)
+		vcpu_last_completed_iteration[i] = -1;
 
 	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
 
 	/* Allow the vCPUs to populate memory */
 	pr_debug("Starting iteration %d - Populating\n", iteration);
-	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
-		while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) !=
+	for (i = 0; i < nr_vcpus; i++) {
+		while (READ_ONCE(vcpu_last_completed_iteration[i]) !=
 		       iteration)
 			;
 	}
@@ -272,8 +273,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		iteration++;
 
 		pr_debug("Starting iteration %d\n", iteration);
-		for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
-			while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id])
+		for (i = 0; i < nr_vcpus; i++) {
+			while (READ_ONCE(vcpu_last_completed_iteration[i])
 			       != iteration)
 				;
 		}
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index a86f953d8d36..9a6cdaed33f6 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -25,7 +25,8 @@ struct perf_test_vcpu_args {
 	uint64_t pages;
 
 	/* Only used by the host userspace part of the vCPU thread */
-	int vcpu_id;
+	struct kvm_vcpu *vcpu;
+	int vcpu_idx;
 };
 
 struct perf_test_args {
@@ -39,7 +40,7 @@ struct perf_test_args {
 
 extern struct perf_test_args perf_test_args;
 
-struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
+struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 				   uint64_t vcpu_memory_bytes, int slots,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index ffbd3664e162..679f64527f1a 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -17,8 +17,8 @@ struct perf_test_args perf_test_args;
 static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
 
 struct vcpu_thread {
-	/* The id of the vCPU. */
-	int vcpu_id;
+	/* The index of the vCPU. */
+	int vcpu_idx;
 
 	/* The pthread backing the vCPU. */
 	pthread_t thread;
@@ -36,24 +36,26 @@ static void (*vcpu_thread_fn)(struct perf_test_vcpu_args *);
 /* Set to true once all vCPU threads are up and running. */
 static bool all_vcpu_threads_running;
 
+static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+
 /*
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
  */
-static void guest_code(uint32_t vcpu_id)
+static void guest_code(uint32_t vcpu_idx)
 {
 	struct perf_test_args *pta = &perf_test_args;
-	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_id];
+	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
 	uint64_t gva;
 	uint64_t pages;
 	int i;
 
-	/* Make sure vCPU args data structure is not corrupt. */
-	GUEST_ASSERT(vcpu_args->vcpu_id == vcpu_id);
-
 	gva = vcpu_args->gva;
 	pages = vcpu_args->pages;
 
+	/* Make sure vCPU args data structure is not corrupt. */
+	GUEST_ASSERT(vcpu_args->vcpu_idx == vcpu_idx);
+
 	while (true) {
 		for (i = 0; i < pages; i++) {
 			uint64_t addr = gva + (i * pta->guest_page_size);
@@ -68,40 +70,43 @@ static void guest_code(uint32_t vcpu_id)
 	}
 }
 
-void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
+void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
+			   struct kvm_vcpu *vcpus[],
 			   uint64_t vcpu_memory_bytes,
 			   bool partition_vcpu_memory_access)
 {
 	struct perf_test_args *pta = &perf_test_args;
 	struct perf_test_vcpu_args *vcpu_args;
-	int vcpu_id;
+	int i;
 
-	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
-		vcpu_args = &pta->vcpu_args[vcpu_id];
+	for (i = 0; i < nr_vcpus; i++) {
+		vcpu_args = &pta->vcpu_args[i];
+
+		vcpu_args->vcpu = vcpus[i];
+		vcpu_args->vcpu_idx = i;
 
-		vcpu_args->vcpu_id = vcpu_id;
 		if (partition_vcpu_memory_access) {
 			vcpu_args->gva = guest_test_virt_mem +
-					 (vcpu_id * vcpu_memory_bytes);
+					 (i * vcpu_memory_bytes);
 			vcpu_args->pages = vcpu_memory_bytes /
 					   pta->guest_page_size;
-			vcpu_args->gpa = pta->gpa + (vcpu_id * vcpu_memory_bytes);
+			vcpu_args->gpa = pta->gpa + (i * vcpu_memory_bytes);
 		} else {
 			vcpu_args->gva = guest_test_virt_mem;
-			vcpu_args->pages = (vcpus * vcpu_memory_bytes) /
+			vcpu_args->pages = (nr_vcpus * vcpu_memory_bytes) /
 					   pta->guest_page_size;
 			vcpu_args->gpa = pta->gpa;
 		}
 
-		vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
+		vcpu_args_set(vm, vcpus[i]->id, 1, i);
 
 		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
-			 vcpu_id, vcpu_args->gpa, vcpu_args->gpa +
+			 i, vcpu_args->gpa, vcpu_args->gpa +
 			 (vcpu_args->pages * pta->guest_page_size));
 	}
 }
 
-struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
+struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 				   uint64_t vcpu_memory_bytes, int slots,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access)
@@ -124,7 +129,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	pta->guest_page_size = vm_guest_mode_params[mode].page_size;
 
 	guest_num_pages = vm_adjust_num_guest_pages(mode,
-				(vcpus * vcpu_memory_bytes) / pta->guest_page_size);
+				(nr_vcpus * vcpu_memory_bytes) / pta->guest_page_size);
 
 	TEST_ASSERT(vcpu_memory_bytes % getpagesize() == 0,
 		    "Guest memory size is not host page size aligned.");
@@ -139,8 +144,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	 * The memory is also added to memslot 0, but that's a benign side
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
-	vm = __vm_create_with_vcpus(mode, vcpus, DEFAULT_GUEST_PHY_PAGES,
-				    guest_num_pages, 0, guest_code, NULL);
+	vm = __vm_create_with_vcpus(mode, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
+				    guest_num_pages, 0, guest_code, vcpus);
 
 	pta->vm = vm;
 
@@ -151,8 +156,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
 		    "Requested more guest memory than address space allows.\n"
 		    "    guest pages: %" PRIx64 " max gfn: %" PRIx64
-		    " vcpus: %d wss: %" PRIx64 "]\n",
-		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
+		    " nr_vcpus: %d wss: %" PRIx64 "]\n",
+		    guest_num_pages, vm_get_max_gfn(vm), nr_vcpus,
 		    vcpu_memory_bytes);
 
 	pta->gpa = (vm_get_max_gfn(vm) - guest_num_pages) * pta->guest_page_size;
@@ -176,7 +181,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	/* Do mapping for the demand paging memory slot */
 	virt_map(vm, guest_test_virt_mem, pta->gpa, guest_num_pages);
 
-	perf_test_setup_vcpus(vm, vcpus, vcpu_memory_bytes, partition_vcpu_memory_access);
+	perf_test_setup_vcpus(vm, nr_vcpus, vcpus, vcpu_memory_bytes,
+			      partition_vcpu_memory_access);
 
 	ucall_init(vm, NULL);
 
@@ -213,39 +219,40 @@ static void *vcpu_thread_main(void *data)
 	while (!READ_ONCE(all_vcpu_threads_running))
 		;
 
-	vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_id]);
+	vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_idx]);
 
 	return NULL;
 }
 
-void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *))
+void perf_test_start_vcpu_threads(int nr_vcpus,
+				  void (*vcpu_fn)(struct perf_test_vcpu_args *))
 {
-	int vcpu_id;
+	int i;
 
 	vcpu_thread_fn = vcpu_fn;
 	WRITE_ONCE(all_vcpu_threads_running, false);
 
-	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
-		struct vcpu_thread *vcpu = &vcpu_threads[vcpu_id];
+	for (i = 0; i < nr_vcpus; i++) {
+		struct vcpu_thread *vcpu = &vcpu_threads[i];
 
-		vcpu->vcpu_id = vcpu_id;
+		vcpu->vcpu_idx = i;
 		WRITE_ONCE(vcpu->running, false);
 
 		pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
 	}
 
-	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
-		while (!READ_ONCE(vcpu_threads[vcpu_id].running))
+	for (i = 0; i < nr_vcpus; i++) {
+		while (!READ_ONCE(vcpu_threads[i].running))
 			;
 	}
 
 	WRITE_ONCE(all_vcpu_threads_running, true);
 }
 
-void perf_test_join_vcpu_threads(int vcpus)
+void perf_test_join_vcpu_threads(int nr_vcpus)
 {
-	int vcpu_id;
+	int i;
 
-	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++)
-		pthread_join(vcpu_threads[vcpu_id].thread, NULL);
+	for (i = 0; i < nr_vcpus; i++)
+		pthread_join(vcpu_threads[i].thread, NULL);
 }
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 1410d0a9141a..a3efb3182119 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -38,19 +38,19 @@ static bool run_vcpus = true;
 
 static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 {
-	int ret;
-	int vcpu_id = vcpu_args->vcpu_id;
+	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	struct kvm_vm *vm = perf_test_args.vm;
 	struct kvm_run *run;
+	int ret;
 
-	run = vcpu_state(vm, vcpu_id);
+	run = vcpu->run;
 
 	/* Let the guest access its memory until a stop signal is received */
 	while (READ_ONCE(run_vcpus)) {
-		ret = _vcpu_run(vm, vcpu_id);
+		ret = _vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
 
-		if (get_ucall(vm, vcpu_id, NULL) == UCALL_SYNC)
+		if (get_ucall(vm, vcpu->id, NULL) == UCALL_SYNC)
 			continue;
 
 		TEST_ASSERT(false,
-- 
2.36.1.255.ge46751e96f-goog

