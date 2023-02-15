Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA584697351
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbjBOBRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbjBOBQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:16:58 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27E634009
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:33 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-517f8be4b00so179237017b3.3
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YHoWMeic/UjG++dnFUyACHVbUxHxQxLAVvFnKubV9rg=;
        b=BFMvX8P6kXjmMKY8J1D50/D8HClx3uewlrKwSdSEweDZ/S4Y8fdUivjkxHHgr/IH3D
         eXFVaZW1Xs/qJt4g98vmsuyZakrbZWC5qG4lEwHRAyhNkeohVr6pJxgGOIEbdk90gh12
         jbVPnPqF5dzltidC9m6VayfGR61Llq3Xxqxja6IGWHAjEE0vmFyvsj74wB9iCripY4VU
         I6zXVWX46JSdR4w/I81Fq+sdXLMkqOYO8emgLB5nC6UDpjvBLXwWBeXSw8/KJE3JzHWy
         i2JetKYfjh+BlnyYo2sKo43WrwcnIFSO/Rte/Oyw6H6dEBkgsaqxC5uEfXuhC0c7d4xF
         92PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YHoWMeic/UjG++dnFUyACHVbUxHxQxLAVvFnKubV9rg=;
        b=UQgnTPO90Gojky9UsvQxjvA/nXNcO02CpoZAgd1W2FPCnsxJ3uix4gMZVK0qkxyKRP
         72fBJesLNhkudtRxrN4uG7X8hIh6C3WtVWMCOId9UArNZJBmuNxW0XX5QbdlhHlBMv9u
         R1vrSuPNrD2nwSN4zY13M1GjabF9VeVn2tKnLGrZFxRJJLtFZnD188uvaWoYr0Z3hamL
         6EbRIQqggcXFaLXvZzKeXrYVmJ/o70RCkciGHIM3lTsR7daJh8ih8mrzrLjV+bnIswvS
         z3oFfkEI63kvrjc2/M08k9nHfDHkfAYm+maLOooXEKLVkoFYV0vFGwYjWrGzihUnx4aK
         hfqw==
X-Gm-Message-State: AO0yUKWTnagDcgeFts/+0PYy3SgRwy5EVuATlnKsnzlU3s/g83QMEBva
        ZdBCi5DeA6eVYWQTXFkUt098pCCBGDXUiw==
X-Google-Smtp-Source: AK7set8aGyzTDfSqGhdnumZuY7pFC5tqlXwmoMKur4Sda97RiABxp5FOxeJd7OviVkWsqVeM8Kht0R4cdk9pZg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a0d:c846:0:b0:527:ac4c:9f80 with SMTP id
 k67-20020a0dc846000000b00527ac4c9f80mr73605ywd.342.1676423791719; Tue, 14 Feb
 2023 17:16:31 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:16:08 +0000
In-Reply-To: <20230215011614.725983-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215011614.725983-3-amoorthy@google.com>
Subject: [PATCH 2/8] selftests/kvm: Allow many vcpus per UFFD in demand paging test
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

The aim is to enable the demand_paging_selftest to benchmark multiple
vCPU threads concurrently faulting over a single region/uffd.

Currently,
  (a) "-u" (run test in userfaultfd mode) will create a uffd for each
      vCPU's region, so that each uffd services a single vcpu thread.
  (b) "-u -o" (userfaultfd mode + overlapped vCPU memory accesses)
      simply doesn't work (the test will try to register all of guest
      memory to multiple uffds, and get an error doing so).

With this change
  (1) "-u" behavior is unchanged.
  (2) "-u -a" will create a single uffd for *all* of guest memory.
  (3) "-u -o" will implicitly pass "-a", resolving the breakage in (b).

In cases (2) and (3) all vCPU threads will fault on a single uffd (with
and without partitioned accesses respectively), giving us the behavior
we want to test.

With multiple threads now allowed to fault on a single UFFD, it makes
sense to allow more than one reader thread per UFFD as well: an option
for this (-r) is also added.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Acked-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   |  4 +-
 .../selftests/kvm/demand_paging_test.c        | 62 +++++++++----
 .../selftests/kvm/include/userfaultfd_util.h  | 18 +++-
 .../selftests/kvm/lib/userfaultfd_util.c      | 86 +++++++++++++------
 4 files changed, 125 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index beb944fa6fd46..de4251b811e3b 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -377,14 +377,14 @@ static void setup_uffd(struct kvm_vm *vm, struct test_params *p,
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
index 6809184ce2390..3c1d5b81c9822 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -58,7 +58,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 }
 
 static int handle_uffd_page_request(int uffd_mode, int uffd,
-		struct uffd_msg *msg)
+									struct uffd_msg *msg)
 {
 	pid_t tid = syscall(__NR_gettid);
 	uint64_t addr = msg->arg.pagefault.address;
@@ -77,8 +77,15 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		copy.mode = 0;
 
 		r = ioctl(uffd, UFFDIO_COPY, &copy);
-		if (r == -1) {
-			pr_info("Failed UFFDIO_COPY in 0x%lx from thread %d with errno: %d\n",
+		/*
+		 * With multiple vCPU threads fault on a single page and there are
+		 * multiple readers for the UFFD, at least one of the UFFDIO_COPYs
+		 * will fail with EEXIST: handle that case without signaling an
+		 * error.
+		 */
+		if (r == -1 && errno != EEXIST) {
+			pr_info(
+				"Failed UFFDIO_COPY in 0x%lx from thread %d, errno = %d\n",
 				addr, tid, errno);
 			return r;
 		}
@@ -89,8 +96,10 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		cont.range.len = demand_paging_size;
 
 		r = ioctl(uffd, UFFDIO_CONTINUE, &cont);
-		if (r == -1) {
-			pr_info("Failed UFFDIO_CONTINUE in 0x%lx from thread %d with errno: %d\n",
+		/* See the note about EEXISTs in the UFFDIO_COPY branch. */
+		if (r == -1 && errno != EEXIST) {
+			pr_info(
+				"Failed UFFDIO_CONTINUE in 0x%lx from thread %d, errno = %d\n",
 				addr, tid, errno);
 			return r;
 		}
@@ -110,7 +119,9 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 
 struct test_params {
 	int uffd_mode;
+	bool single_uffd;
 	useconds_t uffd_delay;
+	int readers_per_uffd;
 	enum vm_mem_backing_src_type src_type;
 	bool partition_vcpu_memory_access;
 };
@@ -133,7 +144,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec start;
 	struct timespec ts_diff;
 	struct kvm_vm *vm;
-	int i;
+	int i, num_uffds = 0;
+	uint64_t uffd_region_size;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
@@ -146,10 +158,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	memset(guest_data_prototype, 0xAB, demand_paging_size);
 
 	if (p->uffd_mode) {
-		uffd_descs = malloc(nr_vcpus * sizeof(struct uffd_desc *));
+		num_uffds = p->single_uffd ? 1 : nr_vcpus;
+		uffd_region_size = nr_vcpus * guest_percpu_mem_size / num_uffds;
+
+		uffd_descs = malloc(num_uffds * sizeof(struct uffd_desc *));
 		TEST_ASSERT(uffd_descs, "Memory allocation failed");
 
-		for (i = 0; i < nr_vcpus; i++) {
+		for (i = 0; i < num_uffds; i++) {
 			struct memstress_vcpu_args *vcpu_args;
 			void *vcpu_hva;
 			void *vcpu_alias;
@@ -160,8 +175,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			vcpu_hva = addr_gpa2hva(vm, vcpu_args->gpa);
 			vcpu_alias = addr_gpa2alias(vm, vcpu_args->gpa);
 
-			prefault_mem(vcpu_alias,
-				vcpu_args->pages * memstress_args.guest_page_size);
+			prefault_mem(vcpu_alias, uffd_region_size);
 
 			/*
 			 * Set up user fault fd to handle demand paging
@@ -169,7 +183,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			 */
 			uffd_descs[i] = uffd_setup_demand_paging(
 				p->uffd_mode, p->uffd_delay, vcpu_hva,
-				vcpu_args->pages * memstress_args.guest_page_size,
+				uffd_region_size,
+				p->readers_per_uffd,
 				&handle_uffd_page_request);
 		}
 	}
@@ -186,7 +201,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	if (p->uffd_mode) {
 		/* Tell the user fault fd handler threads to quit */
-		for (i = 0; i < nr_vcpus; i++)
+		for (i = 0; i < num_uffds; i++)
 			uffd_stop_demand_paging(uffd_descs[i]);
 	}
 
@@ -206,14 +221,19 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-d uffd_delay_usec]\n"
-	       "          [-b memory] [-s type] [-v vcpus] [-o]\n", name);
+	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a]\n"
+		   "          [-d uffd_delay_usec] [-r readers_per_uffd] [-b memory]\n"
+		   "          [-s type] [-v vcpus] [-o]\n", name);
 	guest_modes_help();
 	printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
 	       "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
+	printf(" -a: Use a single userfaultfd for all of guest memory, instead of\n"
+		   "     creating one for each region paged by a unique vCPU\n"
+		   "     Set implicitly with -o, and no effect without -u.\n");
 	printf(" -d: add a delay in usec to the User Fault\n"
 	       "     FD handler to simulate demand paging\n"
 	       "     overheads. Ignored without -u.\n");
+	printf(" -r: Set the number of reader threads per uffd.\n");
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     demand paged by each vCPU. e.g. 10M or 3G.\n"
 	       "     Default: 1G\n");
@@ -231,12 +251,14 @@ int main(int argc, char *argv[])
 	struct test_params p = {
 		.src_type = DEFAULT_VM_MEM_SRC,
 		.partition_vcpu_memory_access = true,
+		.readers_per_uffd = 1,
+		.single_uffd = false,
 	};
 	int opt;
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hm:u:d:b:s:v:o")) != -1) {
+	while ((opt = getopt(argc, argv, "ahom:u:d:b:s:v:r:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -248,6 +270,9 @@ int main(int argc, char *argv[])
 				p.uffd_mode = UFFDIO_REGISTER_MODE_MINOR;
 			TEST_ASSERT(p.uffd_mode, "UFFD mode must be 'MISSING' or 'MINOR'.");
 			break;
+		case 'a':
+			p.single_uffd = true;
+			break;
 		case 'd':
 			p.uffd_delay = strtoul(optarg, NULL, 0);
 			TEST_ASSERT(p.uffd_delay >= 0, "A negative UFFD delay is not supported.");
@@ -265,6 +290,13 @@ int main(int argc, char *argv[])
 			break;
 		case 'o':
 			p.partition_vcpu_memory_access = false;
+			p.single_uffd = true;
+			break;
+		case 'r':
+			p.readers_per_uffd = atoi(optarg);
+			TEST_ASSERT(p.readers_per_uffd >= 1,
+						"Invalid number of readers per uffd %d: must be >=1",
+						p.readers_per_uffd);
 			break;
 		case 'h':
 		default:
diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/tools/testing/selftests/kvm/include/userfaultfd_util.h
index 877449c345928..92cc1f9ec0686 100644
--- a/tools/testing/selftests/kvm/include/userfaultfd_util.h
+++ b/tools/testing/selftests/kvm/include/userfaultfd_util.h
@@ -17,18 +17,30 @@
 
 typedef int (*uffd_handler_t)(int uffd_mode, int uffd, struct uffd_msg *msg);
 
+struct uffd_reader_args {
+	int uffd_mode;
+	int uffd;
+	useconds_t delay;
+	uffd_handler_t handler;
+	/* Holds the read end of the pipe for killing the reader. */
+	int pipe;
+};
+
 struct uffd_desc {
 	int uffd_mode;
 	int uffd;
-	int pipefds[2];
 	useconds_t delay;
 	uffd_handler_t handler;
-	pthread_t thread;
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
index 92cef20902f1f..2723ee1e3e1b2 100644
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
@@ -148,18 +158,32 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 	TEST_ASSERT((uffdio_register.ioctls & expected_ioctls) ==
 		    expected_ioctls, "missing userfaultfd ioctls");
 
-	ret = pipe2(uffd_desc->pipefds, O_CLOEXEC | O_NONBLOCK);
-	TEST_ASSERT(!ret, "Failed to set up pipefd");
-
 	uffd_desc->uffd_mode = uffd_mode;
 	uffd_desc->uffd = uffd;
 	uffd_desc->delay = delay;
 	uffd_desc->handler = handler;
-	pthread_create(&uffd_desc->thread, NULL, uffd_handler_thread_fn,
-		       uffd_desc);
 
-	PER_VCPU_DEBUG("Created uffd thread for HVA range [%p, %p)\n",
-		       hva, hva + len);
+	for (i = 0; i < uffd_desc->num_readers; ++i) {
+		int pipes[2];
+
+		ret = pipe2((int *) &pipes, O_CLOEXEC | O_NONBLOCK);
+		TEST_ASSERT(!ret, "Failed to set up pipefd %i for uffd_desc %p",
+					i, uffd_desc);
+
+		uffd_desc->pipefds[i] = pipes[1];
+
+		uffd_desc->reader_args[i].uffd_mode = uffd_mode;
+		uffd_desc->reader_args[i].uffd = uffd;
+		uffd_desc->reader_args[i].delay = delay;
+		uffd_desc->reader_args[i].handler = handler;
+		uffd_desc->reader_args[i].pipe = pipes[0];
+
+		pthread_create(&uffd_desc->readers[i], NULL, uffd_handler_thread_fn,
+					   &uffd_desc->reader_args[i]);
+
+		PER_VCPU_DEBUG("Created uffd thread %i for HVA range [%p, %p)\n",
+					   i, hva, hva + len);
+	}
 
 	return uffd_desc;
 }
@@ -167,19 +191,31 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
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
+			ret == 0,
+			"Pthread_join failed on reader thread %i for uffd_desc %p", i, uffd);
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
2.39.1.581.gbfd45094c4-goog

