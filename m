Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6596BA519
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 03:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjCOCSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 22:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjCOCST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 22:18:19 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452DE1B559
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:14 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-541942bfdccso88090717b3.14
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678846693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2m1v7ilwqJ4XQC2d/8mjjmsvnkBF+41jXI4NYltR25U=;
        b=Kksu2t5hJb0/PxJm60kW0E92hmVYBTwuvxPt9PIw4Rp/9UQdAjo/gGiaf6XdT1+Miw
         3gNnJx9+ygBs6H+jUOvTClFLEw8Bd1TsGA5sqIGOOWjojDeRj0fL6S/xr8DMKKB77ITy
         Nm4y3YZjgYRz3wDCWDSLC9us2FenIMwZvG/8ITBmKyJJ5S7sV5DaCVYFy2LB2wZqZ7pF
         htQ68X1WfuSnifoqj6tMdaGqAA6ERRwNwuAoYAPRKQ24fAqFUBxy5eK4NYr7BKUW28vH
         Un1YNTPA8nK46WUWZiaB0UIFC6soerLPykrxuDxauI2T/nyG5FZDste2abLBXwfL1m2B
         bR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678846693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2m1v7ilwqJ4XQC2d/8mjjmsvnkBF+41jXI4NYltR25U=;
        b=6Nj2YZNcKRXe8Cfyz4BVSOjQC5gdBuUZ6x7mMTBWD0TFLpg/i4+OtzrKS7WJ4o6rDZ
         bmwgJvc/T5JsodZcdXVmlzs8Ky+gxawSQ3FC9zyW+Xv9XDmF8IuMwOJJSUVBjb14PlGo
         FZ0fv2WZ5Q+3eAr/qEwFWM/3jm5673xIYdwMJEEuEflibjpWxX2dPrnx1v5xtFdr59Dx
         Y3uXD/gBmlePS5RT87Vh+KJ41fnGQbRSZ64tldBTKcwFBlYfjuAM4kYNQ3osmlBMqMxQ
         VrRvA9HfXIYwYF8fh2ZxwjwzvTcPqHxZI1wU9TFmw8b7DQp97HqB+a5Po0CoZwK2bVyO
         npRQ==
X-Gm-Message-State: AO0yUKXZZcxBSIvmpcghTfI6vJ2cxvA+W/wldiF+Hq0OFQ5RJhQF8x/4
        qLzAO9kfVqons1CFQTYiuEPl49F+06U/fw==
X-Google-Smtp-Source: AK7set9nA6v66x5sjHMUs9juzRdmx6r4W3klJG3LDqWHwYcbz5jxitlqbdlBaoo2FPYe84pyXt9yzc112rieog==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a5b:542:0:b0:a67:c976:c910 with SMTP id
 r2-20020a5b0542000000b00a67c976c910mr20080788ybp.7.1678846693543; Tue, 14 Mar
 2023 19:18:13 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:17:38 +0000
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315021738.1151386-15-amoorthy@google.com>
Subject: [WIP Patch v2 14/14] KVM: selftests: Handle memory fault exits in demand_paging_test
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com
Cc:     jthoughton@google.com, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
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

Demonstrate a (very basic) scheme for supporting memory fault exits.

From the vCPU threads:
1. Simply issue UFFDIO_COPY/CONTINUEs in response to memory fault exits,
   with the purpose of establishing the absent mappings. Do so with
   wake_waiters=false to avoid serializing on the userfaultfd wait queue
   locks.

2. When the UFFDIO_COPY/CONTINUE in (1) fails with EEXIST,
   assume that the mapping was already established but is currently
   absent [A] and attempt to populate it using MADV_POPULATE_WRITE.

Issue UFFDIO_COPY/CONTINUEs from the reader threads as well, but with
wake_waiters=true to ensure that any threads sleeping on the uffd are
eventually woken up.

A real VMM would track whether it had already COPY/CONTINUEd pages (eg,
via a bitmap) to avoid calls destined to EEXIST. However, even the
naive approach is enough to demonstrate the performance advantages of
KVM_EXIT_MEMORY_FAULT.

[A] In reality it is much likelier that the vCPU thread simply lost a
    race to establish the mapping for the page.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Acked-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/demand_paging_test.c        | 220 +++++++++++++-----
 1 file changed, 164 insertions(+), 56 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 607cd2846e39c..dce72adcb1632 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -15,6 +15,7 @@
 #include <time.h>
 #include <pthread.h>
 #include <linux/userfaultfd.h>
+#include <sys/mman.h>
 #include <sys/syscall.h>
 
 #include "kvm_util.h"
@@ -31,6 +32,60 @@ static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 static size_t demand_paging_size;
 static char *guest_data_prototype;
 
+static int num_uffds;
+static size_t uffd_region_size;
+static struct uffd_desc **uffd_descs;
+/*
+ * Delay when demand paging is performed through userfaultfd or directly by
+ * vcpu_worker in the case of a KVM_EXIT_MEMORY_FAULT.
+ */
+static useconds_t uffd_delay;
+static int uffd_mode;
+
+
+static int handle_uffd_page_request(
+	int uffd_mode, int uffd, uint64_t hva, bool is_vcpu
+);
+
+static void madv_write_or_err(uint64_t gpa)
+{
+	int r;
+	void *hva = addr_gpa2hva(memstress_args.vm, gpa);
+
+	r = madvise(hva, demand_paging_size, MADV_POPULATE_WRITE);
+	TEST_ASSERT(
+		r == 0,
+		"MADV_POPULATE_WRITE on hva 0x%lx (gpa 0x%lx) failed with errno %i\n",
+		(uintptr_t) hva, gpa, errno);
+}
+
+static void ready_page(uint64_t gpa)
+{
+	int r, uffd;
+
+	/*
+	 * This test only registers memslot 1 w/ userfaultfd. Any accesses outside
+	 * the registered ranges should fault in the physical pages through
+	 * MADV_POPULATE_WRITE.
+	 */
+	if ((gpa < memstress_args.gpa)
+		|| (gpa >= memstress_args.gpa + memstress_args.size)) {
+		madv_write_or_err(gpa);
+	} else {
+		if (uffd_delay)
+			usleep(uffd_delay);
+
+		uffd = uffd_descs[(gpa - memstress_args.gpa) / uffd_region_size]->uffd;
+
+		r = handle_uffd_page_request(
+			uffd_mode, uffd,
+			(uint64_t) addr_gpa2hva(memstress_args.vm, gpa), true);
+
+		if (r == EEXIST)
+			madv_write_or_err(gpa);
+	}
+}
+
 static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
@@ -42,25 +97,37 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
 
-	/* Let the guest access its memory */
-	ret = _vcpu_run(vcpu);
-	TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-	if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
-		TEST_ASSERT(false,
-			    "Invalid guest sync status: exit_reason=%s\n",
-			    exit_reason_str(run->exit_reason));
-	}
+	while (true) {
+		/* Let the guest access its memory */
+		ret = _vcpu_run(vcpu);
+		TEST_ASSERT(ret == 0 || (run->exit_reason == KVM_EXIT_MEMORY_FAULT),
+					"vcpu_run failed: %d\n", ret);
+		if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
+
+			if (run->exit_reason == KVM_EXIT_MEMORY_FAULT) {
+				TEST_ASSERT(run->memory_fault.flags == 0,
+							"Unrecognized flags 0x%llx on memory fault exit",
+							run->memory_fault.flags);
+				ready_page(run->memory_fault.gpa);
+				continue;
+			}
+
+			TEST_ASSERT(false,
+					"Invalid guest sync status: exit_reason=%s\n",
+					exit_reason_str(run->exit_reason));
+		}
 
-	ts_diff = timespec_elapsed(start);
-	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_idx,
-		       ts_diff.tv_sec, ts_diff.tv_nsec);
+		ts_diff = timespec_elapsed(start);
+		PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_idx,
+				ts_diff.tv_sec, ts_diff.tv_nsec);
+		break;
+	}
 }
 
-static int handle_uffd_page_request(int uffd_mode, int uffd,
-									struct uffd_msg *msg)
+static int handle_uffd_page_request(
+	int uffd_mode, int uffd, uint64_t hva, bool is_vcpu)
 {
 	pid_t tid = syscall(__NR_gettid);
-	uint64_t addr = msg->arg.pagefault.address;
 	struct timespec start;
 	struct timespec ts_diff;
 	int r;
@@ -71,58 +138,81 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		struct uffdio_copy copy;
 
 		copy.src = (uint64_t)guest_data_prototype;
-		copy.dst = addr;
+		copy.dst = hva;
 		copy.len = demand_paging_size;
-		copy.mode = 0;
+		copy.mode = UFFDIO_COPY_MODE_DONTWAKE;
 
-		r = ioctl(uffd, UFFDIO_COPY, &copy);
 		/*
-		 * With multiple vCPU threads fault on a single page and there are
-		 * multiple readers for the UFFD, at least one of the UFFDIO_COPYs
-		 * will fail with EEXIST: handle that case without signaling an
-		 * error.
+		 * With multiple vCPU threads and at least one of multiple reader threads
+		 * or vCPU memory faults, multiple vCPUs accessing an absent page will
+		 * almost certainly cause some thread doing the UFFDIO_COPY here to get
+		 * EEXIST: make sure to allow that case.
 		 */
-		if (r == -1 && errno != EEXIST) {
-			pr_info(
-				"Failed UFFDIO_COPY in 0x%lx from thread %d, errno = %d\n",
-				addr, tid, errno);
-			return r;
-		}
+		r = ioctl(uffd, UFFDIO_COPY, &copy);
+		TEST_ASSERT(
+			r == 0 || errno == EEXIST,
+			"Thread 0x%x failed UFFDIO_COPY on hva 0x%lx, errno = %d",
+			gettid(), hva, errno);
 	} else if (uffd_mode == UFFDIO_REGISTER_MODE_MINOR) {
+		/* The comments in the UFFDIO_COPY branch also apply here. */
 		struct uffdio_continue cont = {0};
 
-		cont.range.start = addr;
+		cont.range.start = hva;
 		cont.range.len = demand_paging_size;
+		cont.mode = UFFDIO_CONTINUE_MODE_DONTWAKE;
 
 		r = ioctl(uffd, UFFDIO_CONTINUE, &cont);
-		/* See the note about EEXISTs in the UFFDIO_COPY branch. */
-		if (r == -1 && errno != EEXIST) {
-			pr_info(
-				"Failed UFFDIO_CONTINUE in 0x%lx from thread %d, errno = %d\n",
-				addr, tid, errno);
-			return r;
-		}
+		TEST_ASSERT(
+			r == 0 || errno == EEXIST,
+			"Thread 0x%x failed UFFDIO_CONTINUE on hva 0x%lx, errno = %d",
+			gettid(), hva, errno);
 	} else {
 		TEST_FAIL("Invalid uffd mode %d", uffd_mode);
 	}
 
+	/*
+	 * If the above UFFDIO_COPY/CONTINUE fails with EEXIST, it will do so without
+	 * waking threads waiting on the UFFD: make sure that happens here.
+	 */
+	if (!is_vcpu) {
+		struct uffdio_range range = {
+			.start = hva,
+			.len = demand_paging_size
+		};
+		r = ioctl(uffd, UFFDIO_WAKE, &range);
+		TEST_ASSERT(
+			r == 0,
+			"Thread 0x%x failed UFFDIO_WAKE on hva 0x%lx, errno = %d",
+			gettid(), hva, errno);
+	}
+
 	ts_diff = timespec_elapsed(start);
 
 	PER_PAGE_DEBUG("UFFD page-in %d \t%ld ns\n", tid,
 		       timespec_to_ns(ts_diff));
 	PER_PAGE_DEBUG("Paged in %ld bytes at 0x%lx from thread %d\n",
-		       demand_paging_size, addr, tid);
+		       demand_paging_size, hva, tid);
 
 	return 0;
 }
 
+static int handle_uffd_page_request_from_uffd(
+	int uffd_mode, int uffd, struct uffd_msg *msg)
+{
+	TEST_ASSERT(
+		msg->event == UFFD_EVENT_PAGEFAULT,
+		"Received uffd message with event %d != UFFD_EVENT_PAGEFAULT",
+		msg->event);
+	return handle_uffd_page_request(
+		uffd_mode, uffd, msg->arg.pagefault.address, false);
+}
+
 struct test_params {
-	int uffd_mode;
 	bool single_uffd;
-	useconds_t uffd_delay;
 	int readers_per_uffd;
 	enum vm_mem_backing_src_type src_type;
 	bool partition_vcpu_memory_access;
+	bool memfault_exits;
 };
 
 static void prefault_mem(void *alias, uint64_t len)
@@ -139,18 +229,31 @@ static void prefault_mem(void *alias, uint64_t len)
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *p = arg;
-	struct uffd_desc **uffd_descs = NULL;
 	struct timespec start;
 	struct timespec ts_diff;
 	struct kvm_vm *vm;
-	int i, num_uffds = 0;
-	uint64_t uffd_region_size;
+	int i;
+	uint32_t slot_flags = 0;
+	bool uffd_memfault_exits = uffd_mode && p->memfault_exits;
+
+	if (uffd_memfault_exits) {
+		TEST_ASSERT(kvm_has_cap(KVM_CAP_MEMORY_FAULT_NOWAIT) > 0,
+					"KVM does not have KVM_CAP_MEMORY_FAULT_NOWAIT");
+		slot_flags = KVM_MEM_ABSENT_MAPPING_FAULT;
+	}
 
 	vm = memstress_create_vm(
 		mode, nr_vcpus, guest_percpu_mem_size,
-		1, 0,
+		1, slot_flags,
 		p->src_type, p->partition_vcpu_memory_access);
 
+	if (uffd_memfault_exits) {
+		if (kvm_has_cap(KVM_CAP_X86_MEMORY_FAULT_EXIT))
+			vm_enable_cap(
+				vm, KVM_CAP_X86_MEMORY_FAULT_EXIT,
+				KVM_MEMFAULT_REASON_ABSENT_MAPPING);
+	}
+
 	demand_paging_size = get_backing_src_pagesz(p->src_type);
 
 	guest_data_prototype = malloc(demand_paging_size);
@@ -158,12 +261,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		    "Failed to allocate buffer for guest data pattern");
 	memset(guest_data_prototype, 0xAB, demand_paging_size);
 
-	if (p->uffd_mode) {
+	if (uffd_mode) {
 		num_uffds = p->single_uffd ? 1 : nr_vcpus;
 		uffd_region_size = nr_vcpus * guest_percpu_mem_size / num_uffds;
 
 		uffd_descs = malloc(num_uffds * sizeof(struct uffd_desc *));
-		TEST_ASSERT(uffd_descs, "Memory allocation failed");
+		TEST_ASSERT(uffd_descs, "Failed to allocate memory of uffd descriptors");
 
 		for (i = 0; i < num_uffds; i++) {
 			struct memstress_vcpu_args *vcpu_args;
@@ -183,10 +286,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			 * requests.
 			 */
 			uffd_descs[i] = uffd_setup_demand_paging(
-				p->uffd_mode, p->uffd_delay, vcpu_hva,
+				uffd_mode, uffd_delay, vcpu_hva,
 				uffd_region_size,
 				p->readers_per_uffd,
-				&handle_uffd_page_request);
+				&handle_uffd_page_request_from_uffd);
 		}
 	}
 
@@ -200,7 +303,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	ts_diff = timespec_elapsed(start);
 	pr_info("All vCPU threads joined\n");
 
-	if (p->uffd_mode) {
+	if (uffd_mode) {
 		/* Tell the user fault fd handler threads to quit */
 		for (i = 0; i < num_uffds; i++)
 			uffd_stop_demand_paging(uffd_descs[i]);
@@ -215,7 +318,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	memstress_destroy_vm(vm);
 
 	free(guest_data_prototype);
-	if (p->uffd_mode)
+	if (uffd_mode)
 		free(uffd_descs);
 }
 
@@ -224,7 +327,7 @@ static void help(char *name)
 	puts("");
 	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a]\n"
 		   "          [-d uffd_delay_usec] [-r readers_per_uffd] [-b memory]\n"
-		   "          [-s type] [-v vcpus] [-o]\n", name);
+		   "          [-w] [-s type] [-v vcpus] [-o]\n", name);
 	guest_modes_help();
 	printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
 	       "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
@@ -235,6 +338,7 @@ static void help(char *name)
 	       "     FD handler to simulate demand paging\n"
 	       "     overheads. Ignored without -u.\n");
 	printf(" -r: Set the number of reader threads per uffd.\n");
+	printf(" -w: Enable kvm cap for memory fault exits.\n");
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     demand paged by each vCPU. e.g. 10M or 3G.\n"
 	       "     Default: 1G\n");
@@ -254,29 +358,30 @@ int main(int argc, char *argv[])
 		.partition_vcpu_memory_access = true,
 		.readers_per_uffd = 1,
 		.single_uffd = false,
+		.memfault_exits = false,
 	};
 	int opt;
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ahom:u:d:b:s:v:r:")) != -1) {
+	while ((opt = getopt(argc, argv, "ahowm:u:d:b:s:v:r:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
 			break;
 		case 'u':
 			if (!strcmp("MISSING", optarg))
-				p.uffd_mode = UFFDIO_REGISTER_MODE_MISSING;
+				uffd_mode = UFFDIO_REGISTER_MODE_MISSING;
 			else if (!strcmp("MINOR", optarg))
-				p.uffd_mode = UFFDIO_REGISTER_MODE_MINOR;
-			TEST_ASSERT(p.uffd_mode, "UFFD mode must be 'MISSING' or 'MINOR'.");
+				uffd_mode = UFFDIO_REGISTER_MODE_MINOR;
+			TEST_ASSERT(uffd_mode, "UFFD mode must be 'MISSING' or 'MINOR'.");
 			break;
 		case 'a':
 			p.single_uffd = true;
 			break;
 		case 'd':
-			p.uffd_delay = strtoul(optarg, NULL, 0);
-			TEST_ASSERT(p.uffd_delay >= 0, "A negative UFFD delay is not supported.");
+			uffd_delay = strtoul(optarg, NULL, 0);
+			TEST_ASSERT(uffd_delay >= 0, "A negative UFFD delay is not supported.");
 			break;
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
@@ -299,6 +404,9 @@ int main(int argc, char *argv[])
 						"Invalid number of readers per uffd %d: must be >=1",
 						p.readers_per_uffd);
 			break;
+		case 'w':
+			p.memfault_exits = true;
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
@@ -306,7 +414,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (p.uffd_mode == UFFDIO_REGISTER_MODE_MINOR &&
+	if (uffd_mode == UFFDIO_REGISTER_MODE_MINOR &&
 	    !backing_src_is_shared(p.src_type)) {
 		TEST_FAIL("userfaultfd MINOR mode requires shared memory; pick a different -s");
 	}
-- 
2.40.0.rc1.284.g88254d51c5-goog

