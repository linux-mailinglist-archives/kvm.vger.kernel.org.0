Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366F8697358
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjBOBRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbjBOBRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:17:08 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA9131E23
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:41 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4c11ae6ab25so179162887b3.8
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ji8WghclKAhj57urzXye6wBO7ysPmUoMohvoVp5Cmo8=;
        b=GJzSRkccRTUwHG+o3x8+8CyEBDcwnBg9c8OsL1KGY64ImfTJ3mYDDrt8Y6tm9yw0Ll
         eDlKxuOkTVRWH6MlaXpUpz8Ex8Q8FCizYJpR3ya37MKNf+4OPACXM07B06ltxb8DF7R/
         lK6MZvvVHj8kn83v7PnCUC9/Ddw+W53R4hX+gH9K6vS8152CNv64F1HiLD6bAt8YnH8/
         tFBPJHz+mP3mX/66dT5fWjUtSCizaqiLKNqXRh0nelI8tV7XHHy4h6aBahfPhu5NOoJF
         vDDD9mOdOh95dfKeSoETlP7dQ3qL9MV7a2jny92mOspe5gJTW/mc7wWJbzotvNvIiYPu
         R6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ji8WghclKAhj57urzXye6wBO7ysPmUoMohvoVp5Cmo8=;
        b=M0lQ2V8RzhJtWlcCNX+CDGrUMjPLjip+k/0a8jSqwQ/Ki0BSzhWFwMICPWPOnvz3e8
         IAogcizYwsgCfkV+sZtBHpJvXesLofRw85x/I/EsQHlaoeAXuhvxkb8HapmOQQD5cqUK
         J2AYae8yd/iS1S2t1FdjYFl1hMt2FlqidevB4swgitoPXC2cL+ttpZ1/MGoPVwLx8qx7
         lw9DFkcwfHc+CpJ5jmEL971vgRENYr99Ka1iGuFQy9yvjIqWkhMXyHJJM+CV7Six4+hM
         Fr4n8McZULPGqe+De3wAxDnjw2qPr4chwyQXye9LGuQm1WbJmfA2YQAZWOj64v5V8tqJ
         OOlQ==
X-Gm-Message-State: AO0yUKU8N8q+ADSsdNlG7ezNq/XhgecHxL7b1OyLrLCJkjdQuRmhyUr6
        OOfdvq34JSHCirDYKEaqpmf46FgwJ1gPCQ==
X-Google-Smtp-Source: AK7set+ZC379pB3zY5cDUe2KY5fc5be91Y6acUhjr0klhjLcKkET8sJgULBzIXisweiqe3KGPGMXv2WabI21Hg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:4ecd:0:b0:527:98b2:bce with SMTP id
 c196-20020a814ecd000000b0052798b20bcemr68517ywb.222.1676423799019; Tue, 14
 Feb 2023 17:16:39 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:16:14 +0000
In-Reply-To: <20230215011614.725983-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215011614.725983-9-amoorthy@google.com>
Subject: [PATCH 8/8] selftests/kvm: Handle mem fault exits in demand paging test
From:   Anish Moorthy <amoorthy@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
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

When a memory fault exit is received for a GFN which has not yet been
UFFDIO_COPY/CONTINUEd, said call will be issued (and any EEXISTs will be
ignored). Otherwise, the pages will be faulted in via
MADV_POPULATE_WRITE.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Acked-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/demand_paging_test.c        | 206 +++++++++++++-----
 1 file changed, 151 insertions(+), 55 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 34d5ba2044a2c..ff731aef52fd0 100644
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
@@ -42,25 +97,34 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 
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
@@ -71,58 +135,81 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
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
@@ -139,12 +226,10 @@ static void prefault_mem(void *alias, uint64_t len)
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
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
@@ -156,12 +241,18 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		    "Failed to allocate buffer for guest data pattern");
 	memset(guest_data_prototype, 0xAB, demand_paging_size);
 
-	if (p->uffd_mode) {
+	if (uffd_mode) {
 		num_uffds = p->single_uffd ? 1 : nr_vcpus;
 		uffd_region_size = nr_vcpus * guest_percpu_mem_size / num_uffds;
 
 		uffd_descs = malloc(num_uffds * sizeof(struct uffd_desc *));
-		TEST_ASSERT(uffd_descs, "Memory allocation failed");
+		TEST_ASSERT(uffd_descs, "Failed to allocate memory of uffd descriptors");
+
+		if (p->memfault_exits) {
+			TEST_ASSERT(vm_check_cap(vm, KVM_CAP_MEM_FAULT_NOWAIT) > 0,
+						"Vm does not have KVM_CAP_SET_MEM_FAULT_NOWAIT");
+			vm_ioctl(vm, KVM_SET_MEM_FAULT_NOWAIT, &p->memfault_exits);
+		}
 
 		for (i = 0; i < num_uffds; i++) {
 			struct memstress_vcpu_args *vcpu_args;
@@ -181,10 +272,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
 
@@ -198,7 +289,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	ts_diff = timespec_elapsed(start);
 	pr_info("All vCPU threads joined\n");
 
-	if (p->uffd_mode) {
+	if (uffd_mode) {
 		/* Tell the user fault fd handler threads to quit */
 		for (i = 0; i < num_uffds; i++)
 			uffd_stop_demand_paging(uffd_descs[i]);
@@ -213,7 +304,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	memstress_destroy_vm(vm);
 
 	free(guest_data_prototype);
-	if (p->uffd_mode)
+	if (uffd_mode)
 		free(uffd_descs);
 }
 
@@ -222,7 +313,7 @@ static void help(char *name)
 	puts("");
 	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a]\n"
 		   "          [-d uffd_delay_usec] [-r readers_per_uffd] [-b memory]\n"
-		   "          [-s type] [-v vcpus] [-o]\n", name);
+		   "          [-w] [-s type] [-v vcpus] [-o]\n", name);
 	guest_modes_help();
 	printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
 	       "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
@@ -233,6 +324,7 @@ static void help(char *name)
 	       "     FD handler to simulate demand paging\n"
 	       "     overheads. Ignored without -u.\n");
 	printf(" -r: Set the number of reader threads per uffd.\n");
+	printf(" -w: Enable kvm cap for memory fault exits.\n");
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     demand paged by each vCPU. e.g. 10M or 3G.\n"
 	       "     Default: 1G\n");
@@ -252,29 +344,30 @@ int main(int argc, char *argv[])
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
@@ -297,6 +390,9 @@ int main(int argc, char *argv[])
 						"Invalid number of readers per uffd %d: must be >=1",
 						p.readers_per_uffd);
 			break;
+		case 'w':
+			p.memfault_exits = true;
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
@@ -304,7 +400,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (p.uffd_mode == UFFDIO_REGISTER_MODE_MINOR &&
+	if (uffd_mode == UFFDIO_REGISTER_MODE_MINOR &&
 	    !backing_src_is_shared(p.src_type)) {
 		TEST_FAIL("userfaultfd MINOR mode requires shared memory; pick a different -s");
 	}
-- 
2.39.1.581.gbfd45094c4-goog

