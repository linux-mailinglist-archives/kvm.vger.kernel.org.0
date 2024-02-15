Return-Path: <kvm+bounces-8846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA7EF85720E
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:55:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEC2C1C20992
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25C231482F7;
	Thu, 15 Feb 2024 23:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aesvWqQM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FB11474CB
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041268; cv=none; b=TTgFaM+cyZ7PDJt/7yEZ6nj9OewLG6YQoAG5HK0TgedlTggoxVHUUuaT+WcdiVsUpsHy7DO2HU6186PFVndKJZxpDKQLe4OzvnELMYYciJfknlJBGxvzR4ZN32xOgFqXF82j01TgiMxtzLn5QLHm5d25pGImlQOY+J6+C908RvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041268; c=relaxed/simple;
	bh=AnPqRYIC1QnoGXTWm3rmcWk+De5eqFNuKVfi0J28esc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ProBUMyH8H3998ry9gHOrMQgOIq9nGGx6rUTiFhUIzEhBNJnHsChJSqesTEL2nOwWhak6NAqMc8WkTK2tg2YQztWhRYWY1B0bmwaCrNlnmo4vObNKy62gevsd2GrKSkDauQJT/Qs2Cxg29KSxhYNqrtwn9zFyBG+h2hKX7uhR4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aesvWqQM; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc15b03287so2044037276.3
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041263; x=1708646063; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V33K/kUOR8QF90cj78Or2u3/ENRnBAVw9m4e0yn9pfo=;
        b=aesvWqQMvgGnbOIN1dnGXf46AuHlgtqanuhd+vXcN/K2wsAvfklIbn3hsf69zrHeF6
         l9gNNIZqIQyyQ9f5ln60aBW5ZkJ8Kl8pHn3uY7A0673OJxpJ4RwLB40KALMrNRYg63HU
         bTSJRrTanzS2khCNoReDqj8Zn2MC6T/g0kdFVfW97FWWPL47W4jiKbFyBsoEQyN35G17
         xEfYMg2AG8kUQj1dy3734foQ2SA1bwxNvfzRlT/DU1YGgEPHVZ0gljKxCswbnvNznz3R
         QAse1zv5UOS2MX8DeWzKMF49iwkDUMSeBntaUw5jJ1oAYCEV40nh6bwvEhr7DZy5Lbeq
         XEyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041263; x=1708646063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V33K/kUOR8QF90cj78Or2u3/ENRnBAVw9m4e0yn9pfo=;
        b=hTKXFAETuT/vLiWWE8LPEGfAcJt97u9ivP9KJz4rRlBa7B5Z+bR+S7VsrwOtOxjnUn
         vQQvH1STD7JjFbMhp+g14iExk4eqcT0g7zzbzJBnSLiYnDRqQdtBSwfK2LA3cW8cZRFY
         g4NzmsMFZdtp35R1y4ocp77R9SwNq6HPXNi9Xb+92EOf7rUnELmE4ly3xYQEoDd10C56
         jkinkRxRkiu0SPyLWLK8v1l8236Rr65/zUy9NBaMxd66j4A0BgLpX/phAYnkw1qf150W
         Nr7ptqMkuXfDTVhR1E3JvAqYHgNBuEN30baLtHX5ktT/sqVWT3XA6EDCx6el6rmNJkZ4
         MteA==
X-Forwarded-Encrypted: i=1; AJvYcCXg3xlLaIYZAZeZtpCbOWU7cvHLZNaikWCurHg8lGDayUQJOHufXnOT1bs7+fl4JMglx0bJyf8nZDSBGGkHuW/4bAJd
X-Gm-Message-State: AOJu0YwxArOVCJZZHEIrjYwksU1M6g8X/kiy+QkzSEvNLGgcsZ997Fmj
	mbzy38OOOevoWufzEO/VEp7PlGwCBP1Az/ApCAeKoQfxrRRxjOXEfRtGUZ4p6APmxu/PJD04lWv
	UGDW+pNJWFw==
X-Google-Smtp-Source: AGHT+IG1uwtqUD5sLGbojdTBDV4ey1ZLfXEvNLIVrSuykiZmXMD/5Lba0NjgEZ/yxuxIxTECeeSfwijsGH9ZRQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1b85:b0:dc2:26f6:fbc8 with SMTP
 id ei5-20020a0569021b8500b00dc226f6fbc8mr129460ybb.7.1708041263068; Thu, 15
 Feb 2024 15:54:23 -0800 (PST)
Date: Thu, 15 Feb 2024 23:54:02 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-12-amoorthy@google.com>
Subject: [PATCH v7 11/14] KVM: selftests: Allow many vCPUs and reader threads
 per UFFD in demand paging test
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

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
index 08a5ca5bed56..dad1fb338f36 100644
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
2.44.0.rc0.258.g7320e95886-goog


