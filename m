Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41ED579923F
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343916AbjIHWaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343820AbjIHWaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:30:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5AA1FED
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:30:02 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-594e5e2e608so28551967b3.2
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212202; x=1694817002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oufjiRCAsL1Eh3a6usyMZvjIao9zICC1zqfvsVHk2fg=;
        b=1tOR+0vrTK0Z0AcWz2RBhE015q3tA8OHRk8qmSSFxqKSX+FjgOnO6lYbct7ep5Tcdy
         tUCzC4zWsPaxRN8fpCNLn3UobCQLYnfQ2AYv1hfAtlL4j91q+SSd9R6/eHbOqU7Hbyiq
         quh2GVWnuuhCJVAjQXKTxHLu9H1tkjrXtefKiBxS/GpBsByGUz6jORYOwggfuQTn2cWk
         ZvFsyNkD0axKJjOe0OFtBwHxOdZeDkfrE7wi1b5WcM9c4Ghxd1nzMa8trrnJhUEBcW1Z
         r6FQPLZa752rXvtjlLmrTV++1UpApFk7J4CYjjMAF5Z8FqLevq7mhRDmpG0bdy0zGTBZ
         2EoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212202; x=1694817002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oufjiRCAsL1Eh3a6usyMZvjIao9zICC1zqfvsVHk2fg=;
        b=V7rOh5K0RKyotNHp1cVfILjTv5RZsDuuypxD8SszzWgWZNWjjYJxPlt5EMDpTEUct3
         x8tnQa3gt9xNUUAH96QDNFLKDRUbX5+vY8ohY0xnAtTrg5aArQjjIiE3KYenxGmSWvgs
         b+tL0Ykn5EVlr1yjx+tkAOQNQOCDYxp4JbovsI+AWrNhlV0TFP+Ah3+Fy2T1xHl0PxFe
         FoDzgp1ANqM/O8zuzQEvwxI+Dp+vxt/VH+jjVTcBKR1HP1l9tRIQio92gIEu+q7sx4+m
         DXAAWDNY9bqeqRRnzINGLEIHE3eexKmkxsPrqAxBhw1ybDgz1RNBDQNAXP1K7UKBATJU
         L3Hg==
X-Gm-Message-State: AOJu0Yx6+6XgXgbXI5RUVpgzkFEVQBZa4oBUsNgoVCra3Mnm9lnqqzAB
        XVPxTqvQqDI3S3evkBAlQIY0l5k2oOxUTA==
X-Google-Smtp-Source: AGHT+IF/V1StEhGv1jCGQV+ixsg9Le/ugBaOg7jYt/PQ/ct203wFIuDTVqrnvSAmuN6ZALs+FN44k2A15i+5tA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:aa13:0:b0:562:837:122f with SMTP id
 i19-20020a81aa13000000b005620837122fmr94156ywh.9.1694212202026; Fri, 08 Sep
 2023 15:30:02 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:29:01 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-15-amoorthy@google.com>
Subject: [PATCH v5 14/17] KVM: selftests: Allow many vCPUs and reader threads
 per UFFD in demand paging test
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment, demand_paging_test does not support profiling/testing
multiple vCPU threads concurrently faulting on a single uffd because

    (a) "-u" (run test in userfaultfd mode) creates a uffd for each vCPU's
        region, so that each uffd services a single vCPU thread.
    (b) "-u -o" (userfaultfd mode + overlapped vCPU memory accesses)
        simply doesn't work: the test tries to register the same memory
        to multiple uffds, causing an error.

Add support for many vcpus per uffd by
    (1) Keeping "-u" behavior unchanged.
    (2) Making "-u -a" create a single uffd for all of guest memory.
    (3) Making "-u -o" implicitly pass "-a", solving the problem in (b).
In cases (2) and (3) all vCPU threads fault on a single uffd.

With potentially multiple vCPUs per UFFD, it makes sense to allow
configuring the number of reader threads per UFFD as well: add the "-r"
flag to do so.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Acked-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   |  4 +-
 .../selftests/kvm/demand_paging_test.c        | 76 +++++++++++++---
 .../selftests/kvm/include/userfaultfd_util.h  | 17 +++-
 .../selftests/kvm/lib/userfaultfd_util.c      | 87 +++++++++++++------
 4 files changed, 137 insertions(+), 47 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 47bb914ab2fa..e5ca4b4be903 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -375,14 +375,14 @@ static void setup_uffd(struct kvm_vm *vm, struct test_params *p,
 		*pt_uffd = uffd_setup_demand_paging(uffd_mode, 0,
 						    pt_args.hva,
 						    pt_args.paging_size,
-						    test->uffd_pt_handler);
+						    1, test->uffd_pt_handler);
 
 	*data_uffd = NULL;
 	if (test->uffd_data_handler)
 		*data_uffd = uffd_setup_demand_paging(uffd_mode, 0,
 						      data_args.hva,
 						      data_args.paging_size,
-						      test->uffd_data_handler);
+						      1, test->uffd_data_handler);
 }
 
 static void free_uffd(struct test_desc *test, struct uffd_desc *pt_uffd,
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 6dc823fa933a..f7897a951f90 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -77,8 +77,20 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		copy.mode = 0;
 
 		r = ioctl(uffd, UFFDIO_COPY, &copy);
-		if (r == -1) {
-			pr_info("Failed UFFDIO_COPY in 0x%lx from thread %d with errno: %d\n",
+		/*
+		 * With multiple vCPU threads fault on a single page and there are
+		 * multiple readers for the UFFD, at least one of the UFFDIO_COPYs
+		 * will fail with EEXIST: handle that case without signaling an
+		 * error.
+		 *
+		 * Note that this also suppress any EEXISTs occurring from,
+		 * e.g., the first UFFDIO_COPY/CONTINUEs on a page. That never
+		 * happens here, but a realistic VMM might potentially maintain
+		 * some external state to correctly surface EEXISTs to userspace
+		 * (or prevent duplicate COPY/CONTINUEs in the first place).
+		 */
+		if (r == -1 && errno != EEXIST) {
+			pr_info("Failed UFFDIO_COPY in 0x%lx from thread %d, errno = %d\n",
 				addr, tid, errno);
 			return r;
 		}
@@ -89,8 +101,20 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		cont.range.len = demand_paging_size;
 
 		r = ioctl(uffd, UFFDIO_CONTINUE, &cont);
-		if (r == -1) {
-			pr_info("Failed UFFDIO_CONTINUE in 0x%lx from thread %d with errno: %d\n",
+		/*
+		 * With multiple vCPU threads fault on a single page and there are
+		 * multiple readers for the UFFD, at least one of the UFFDIO_COPYs
+		 * will fail with EEXIST: handle that case without signaling an
+		 * error.
+		 *
+		 * Note that this also suppress any EEXISTs occurring from,
+		 * e.g., the first UFFDIO_COPY/CONTINUEs on a page. That never
+		 * happens here, but a realistic VMM might potentially maintain
+		 * some external state to correctly surface EEXISTs to userspace
+		 * (or prevent duplicate COPY/CONTINUEs in the first place).
+		 */
+		if (r == -1 && errno != EEXIST) {
+			pr_info("Failed UFFDIO_CONTINUE in 0x%lx, thread %d, errno = %d\n",
 				addr, tid, errno);
 			return r;
 		}
@@ -110,7 +134,9 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 
 struct test_params {
 	int uffd_mode;
+	bool single_uffd;
 	useconds_t uffd_delay;
+	int readers_per_uffd;
 	enum vm_mem_backing_src_type src_type;
 	bool partition_vcpu_memory_access;
 };
@@ -134,8 +160,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec start;
 	struct timespec ts_diff;
 	struct kvm_vm *vm;
-	int i;
+	int i, num_uffds = 0;
 	double vcpu_paging_rate;
+	uint64_t uffd_region_size;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
@@ -148,7 +175,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	memset(guest_data_prototype, 0xAB, demand_paging_size);
 
 	if (p->uffd_mode == UFFDIO_REGISTER_MODE_MINOR) {
-		for (i = 0; i < nr_vcpus; i++) {
+		num_uffds = p->single_uffd ? 1 : nr_vcpus;
+		for (i = 0; i < num_uffds; i++) {
 			vcpu_args = &memstress_args.vcpu_args[i];
 			prefault_mem(addr_gpa2alias(vm, vcpu_args->gpa),
 				     vcpu_args->pages * memstress_args.guest_page_size);
@@ -156,9 +184,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	}
 
 	if (p->uffd_mode) {
-		uffd_descs = malloc(nr_vcpus * sizeof(struct uffd_desc *));
+		num_uffds = p->single_uffd ? 1 : nr_vcpus;
+		uffd_region_size = nr_vcpus * guest_percpu_mem_size / num_uffds;
+
+		uffd_descs = malloc(num_uffds * sizeof(struct uffd_desc *));
 		TEST_ASSERT(uffd_descs, "Memory allocation failed");
-		for (i = 0; i < nr_vcpus; i++) {
+		for (i = 0; i < num_uffds; i++) {
+			struct memstress_vcpu_args *vcpu_args;
 			void *vcpu_hva;
 
 			vcpu_args = &memstress_args.vcpu_args[i];
@@ -171,7 +203,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			 */
 			uffd_descs[i] = uffd_setup_demand_paging(
 				p->uffd_mode, p->uffd_delay, vcpu_hva,
-				vcpu_args->pages * memstress_args.guest_page_size,
+				uffd_region_size,
+				p->readers_per_uffd,
 				&handle_uffd_page_request);
 		}
 	}
@@ -188,7 +221,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	if (p->uffd_mode) {
 		/* Tell the user fault fd handler threads to quit */
-		for (i = 0; i < nr_vcpus; i++)
+		for (i = 0; i < num_uffds; i++)
 			uffd_stop_demand_paging(uffd_descs[i]);
 	}
 
@@ -214,15 +247,20 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-d uffd_delay_usec]\n"
-	       "          [-b memory] [-s type] [-v vcpus] [-c cpu_list] [-o]\n", name);
+	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a]\n"
+		   "          [-d uffd_delay_usec] [-r readers_per_uffd] [-b memory]\n"
+		   "          [-s type] [-v vcpus] [-c cpu_list] [-o]\n", name);
 	guest_modes_help();
 	printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
 	       "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
 	kvm_print_vcpu_pinning_help();
+	printf(" -a: Use a single userfaultfd for all of guest memory, instead of\n"
+	       "     creating one for each region paged by a unique vCPU\n"
+	       "     Set implicitly with -o, and no effect without -u.\n");
 	printf(" -d: add a delay in usec to the User Fault\n"
 	       "     FD handler to simulate demand paging\n"
 	       "     overheads. Ignored without -u.\n");
+	printf(" -r: Set the number of reader threads per uffd.\n");
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     demand paged by each vCPU. e.g. 10M or 3G.\n"
 	       "     Default: 1G\n");
@@ -241,12 +279,14 @@ int main(int argc, char *argv[])
 	struct test_params p = {
 		.src_type = DEFAULT_VM_MEM_SRC,
 		.partition_vcpu_memory_access = true,
+		.readers_per_uffd = 1,
+		.single_uffd = false,
 	};
 	int opt;
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hm:u:d:b:s:v:c:o")) != -1) {
+	while ((opt = getopt(argc, argv, "ahom:u:d:b:s:v:c:r:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -258,6 +298,9 @@ int main(int argc, char *argv[])
 				p.uffd_mode = UFFDIO_REGISTER_MODE_MINOR;
 			TEST_ASSERT(p.uffd_mode, "UFFD mode must be 'MISSING' or 'MINOR'.");
 			break;
+		case 'a':
+			p.single_uffd = true;
+			break;
 		case 'd':
 			p.uffd_delay = strtoul(optarg, NULL, 0);
 			TEST_ASSERT(p.uffd_delay >= 0, "A negative UFFD delay is not supported.");
@@ -278,6 +321,13 @@ int main(int argc, char *argv[])
 			break;
 		case 'o':
 			p.partition_vcpu_memory_access = false;
+			p.single_uffd = true;
+			break;
+		case 'r':
+			p.readers_per_uffd = atoi(optarg);
+			TEST_ASSERT(p.readers_per_uffd >= 1,
+				    "Invalid number of readers per uffd %d: must be >=1",
+				    p.readers_per_uffd);
 			break;
 		case 'h':
 		default:
diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/tools/testing/selftests/kvm/include/userfaultfd_util.h
index 877449c34592..af83a437e74a 100644
--- a/tools/testing/selftests/kvm/include/userfaultfd_util.h
+++ b/tools/testing/selftests/kvm/include/userfaultfd_util.h
@@ -17,18 +17,27 @@
 
 typedef int (*uffd_handler_t)(int uffd_mode, int uffd, struct uffd_msg *msg);
 
-struct uffd_desc {
+struct uffd_reader_args {
 	int uffd_mode;
 	int uffd;
-	int pipefds[2];
 	useconds_t delay;
 	uffd_handler_t handler;
-	pthread_t thread;
+	/* Holds the read end of the pipe for killing the reader. */
+	int pipe;
+};
+
+struct uffd_desc {
+	int uffd;
+	uint64_t num_readers;
+	/* Holds the write ends of the pipes for killing the readers. */
+	int *pipefds;
+	pthread_t *readers;
+	struct uffd_reader_args *reader_args;
 };
 
 struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 					   void *hva, uint64_t len,
-					   uffd_handler_t handler);
+					   uint64_t num_readers, uffd_handler_t handler);
 
 void uffd_stop_demand_paging(struct uffd_desc *uffd);
 
diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
index 271f63891581..6f220aa4fb08 100644
--- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -27,10 +27,8 @@
 
 static void *uffd_handler_thread_fn(void *arg)
 {
-	struct uffd_desc *uffd_desc = (struct uffd_desc *)arg;
-	int uffd = uffd_desc->uffd;
-	int pipefd = uffd_desc->pipefds[0];
-	useconds_t delay = uffd_desc->delay;
+	struct uffd_reader_args *reader_args = (struct uffd_reader_args *)arg;
+	int uffd = reader_args->uffd;
 	int64_t pages = 0;
 	struct timespec start;
 	struct timespec ts_diff;
@@ -44,7 +42,7 @@ static void *uffd_handler_thread_fn(void *arg)
 
 		pollfd[0].fd = uffd;
 		pollfd[0].events = POLLIN;
-		pollfd[1].fd = pipefd;
+		pollfd[1].fd = reader_args->pipe;
 		pollfd[1].events = POLLIN;
 
 		r = poll(pollfd, 2, -1);
@@ -92,9 +90,9 @@ static void *uffd_handler_thread_fn(void *arg)
 		if (!(msg.event & UFFD_EVENT_PAGEFAULT))
 			continue;
 
-		if (delay)
-			usleep(delay);
-		r = uffd_desc->handler(uffd_desc->uffd_mode, uffd, &msg);
+		if (reader_args->delay)
+			usleep(reader_args->delay);
+		r = reader_args->handler(reader_args->uffd_mode, uffd, &msg);
 		if (r < 0)
 			return NULL;
 		pages++;
@@ -110,7 +108,7 @@ static void *uffd_handler_thread_fn(void *arg)
 
 struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 					   void *hva, uint64_t len,
-					   uffd_handler_t handler)
+					   uint64_t num_readers, uffd_handler_t handler)
 {
 	struct uffd_desc *uffd_desc;
 	bool is_minor = (uffd_mode == UFFDIO_REGISTER_MODE_MINOR);
@@ -118,14 +116,26 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 	struct uffdio_api uffdio_api;
 	struct uffdio_register uffdio_register;
 	uint64_t expected_ioctls = ((uint64_t) 1) << _UFFDIO_COPY;
-	int ret;
+	int ret, i;
 
 	PER_PAGE_DEBUG("Userfaultfd %s mode, faults resolved with %s\n",
 		       is_minor ? "MINOR" : "MISSING",
 		       is_minor ? "UFFDIO_CONINUE" : "UFFDIO_COPY");
 
 	uffd_desc = malloc(sizeof(struct uffd_desc));
-	TEST_ASSERT(uffd_desc, "malloc failed");
+	TEST_ASSERT(uffd_desc, "Failed to malloc uffd descriptor");
+
+	uffd_desc->pipefds = malloc(sizeof(int) * num_readers);
+	TEST_ASSERT(uffd_desc->pipefds, "Failed to malloc pipes");
+
+	uffd_desc->readers = malloc(sizeof(pthread_t) * num_readers);
+	TEST_ASSERT(uffd_desc->readers, "Failed to malloc reader threads");
+
+	uffd_desc->reader_args = malloc(
+		sizeof(struct uffd_reader_args) * num_readers);
+	TEST_ASSERT(uffd_desc->reader_args, "Failed to malloc reader_args");
+
+	uffd_desc->num_readers = num_readers;
 
 	/* In order to get minor faults, prefault via the alias. */
 	if (is_minor)
@@ -148,18 +158,28 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 	TEST_ASSERT((uffdio_register.ioctls & expected_ioctls) ==
 		    expected_ioctls, "missing userfaultfd ioctls");
 
-	ret = pipe2(uffd_desc->pipefds, O_CLOEXEC | O_NONBLOCK);
-	TEST_ASSERT(!ret, "Failed to set up pipefd");
-
-	uffd_desc->uffd_mode = uffd_mode;
 	uffd_desc->uffd = uffd;
-	uffd_desc->delay = delay;
-	uffd_desc->handler = handler;
-	pthread_create(&uffd_desc->thread, NULL, uffd_handler_thread_fn,
-		       uffd_desc);
+	for (i = 0; i < uffd_desc->num_readers; ++i) {
+		int pipes[2];
+
+		ret = pipe2((int *) &pipes, O_CLOEXEC | O_NONBLOCK);
+		TEST_ASSERT(!ret, "Failed to set up pipefd %i for uffd_desc %p",
+			    i, uffd_desc);
+
+		uffd_desc->pipefds[i] = pipes[1];
 
-	PER_VCPU_DEBUG("Created uffd thread for HVA range [%p, %p)\n",
-		       hva, hva + len);
+		uffd_desc->reader_args[i].uffd_mode = uffd_mode;
+		uffd_desc->reader_args[i].uffd = uffd;
+		uffd_desc->reader_args[i].delay = delay;
+		uffd_desc->reader_args[i].handler = handler;
+		uffd_desc->reader_args[i].pipe = pipes[0];
+
+		pthread_create(&uffd_desc->readers[i], NULL, uffd_handler_thread_fn,
+			       &uffd_desc->reader_args[i]);
+
+		PER_VCPU_DEBUG("Created uffd thread %i for HVA range [%p, %p)\n",
+			       i, hva, hva + len);
+	}
 
 	return uffd_desc;
 }
@@ -167,19 +187,30 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 void uffd_stop_demand_paging(struct uffd_desc *uffd)
 {
 	char c = 0;
-	int ret;
+	int i, ret;
 
-	ret = write(uffd->pipefds[1], &c, 1);
-	TEST_ASSERT(ret == 1, "Unable to write to pipefd");
+	for (i = 0; i < uffd->num_readers; ++i) {
+		ret = write(uffd->pipefds[i], &c, 1);
+		TEST_ASSERT(
+			ret == 1, "Unable to write to pipefd %i for uffd_desc %p", i, uffd);
+	}
 
-	ret = pthread_join(uffd->thread, NULL);
-	TEST_ASSERT(ret == 0, "Pthread_join failed.");
+	for (i = 0; i < uffd->num_readers; ++i) {
+		ret = pthread_join(uffd->readers[i], NULL);
+		TEST_ASSERT(
+			ret == 0, "Pthread_join failed on reader %i for uffd_desc %p", i, uffd);
+	}
 
 	close(uffd->uffd);
 
-	close(uffd->pipefds[1]);
-	close(uffd->pipefds[0]);
+	for (i = 0; i < uffd->num_readers; ++i) {
+		close(uffd->pipefds[i]);
+		close(uffd->reader_args[i].pipe);
+	}
 
+	free(uffd->pipefds);
+	free(uffd->readers);
+	free(uffd->reader_args);
 	free(uffd);
 }
 
-- 
2.42.0.283.g2d96d420d3-goog

