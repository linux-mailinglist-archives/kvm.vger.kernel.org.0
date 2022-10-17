Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD594601847
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 21:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiJQT6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 15:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiJQT6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 15:58:41 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8184733DA
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:39 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h19-20020a63e153000000b00434dfee8dbaso6934761pgk.18
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P0k63Fd1xYq4jGAXfZxTZxY+rWkD14DilQ3pe5s+Qpo=;
        b=dQUTXsRzAVjtUvzYey6a2PMbBrV2ZYYO6nFkkImEv/raFfCHLfSuZaicy7+/MMfHFq
         qZpwPsNwucSz9jXUW0hDjHSeHsEVceIZO6G1cVmWaa/D2MHck3onIipgpXDjjUr3211n
         QMkFw89LMeF3QzBJ2Dpj3/lLlbv5MY8ZyleVt7HyCQGVYdrCa9pJ4z2yOCogjwrSh0DI
         5JvYYxq/p96o6sucBty+ssIiX1f8N+IsEyLofh1dc4mxhnBsgz4+jcBYplFoinEERidA
         J2RozelPa7VGhJy2Lal8UMUvw8Rp71xmiMZg9djsM+lGLPD4ikgaN0biMxeMVwxEi3Cb
         JA6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P0k63Fd1xYq4jGAXfZxTZxY+rWkD14DilQ3pe5s+Qpo=;
        b=2QTzW9+9NtzHK3FJ4rci+oJe719s9gqqyLQiGlPAnrDygDgXDmP5P58UfIPnnLMbQ/
         yzpF3BUEpIbv799I22RMZHCaaM/MgEt1qQJlkivCyHcd9Igcy4gsuY4OVxKBstQ1ou4g
         BXZ0gUUipRUGsvFzsEWy0brOCjnSABGK2xDayvm/XU9ufoROb6MUAWh+QChxpzLr8YHh
         eyfHLtdHuthKk3CNB9C3IrNHMQXAt+saKvG2+U83MR5/U0QI96GxHfG/Imqtee4VmCMi
         Hr+uRA/uhmZWjhhJwnrUZztRv7J+GrkKdzd0zGUE3mTT9NnlWrLQskz4okiRtGsQdVyd
         2WeA==
X-Gm-Message-State: ACrzQf0Wx4XiASRnjfKD21+qYtuPbZpmXFoHFtwleNC0qrFNSZ7TQaSJ
        i/hiEGpU3QqJmHSPcU8dXTotXu7Tvd0NczVYUe/F+9uFMtCxMFAWgRKqUSpkK460Bl6Rs6SuN72
        eN3wZ9j9CXtLy1ts/BjMHl8mNclDxY9od+OUN6Bgg+153KgMgNP/aDi0ltY2kXkc=
X-Google-Smtp-Source: AMsMyM6RR5MdRZJA19EidqeLSiBpxMXXxL89SG6/SxjHM8yzdoHUiRBO9HyvnAVztOKAbsiq1o67FyNP0XECIQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:4811:b0:20a:fee1:8f69 with SMTP
 id a17-20020a17090a481100b0020afee18f69mr1479651pjh.0.1666036718716; Mon, 17
 Oct 2022 12:58:38 -0700 (PDT)
Date:   Mon, 17 Oct 2022 19:58:21 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-2-ricarkol@google.com>
Subject: [PATCH v10 01/14] KVM: selftests: Add a userfaultfd library
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
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

Move the generic userfaultfd code out of demand_paging_test.c into a
common library, userfaultfd_util. This library consists of a setup and a
stop function. The setup function starts a thread for handling page
faults using the handler callback function. This setup returns a
uffd_desc object which is then used in the stop function (to wait and
destroy the threads).

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/demand_paging_test.c        | 228 +++---------------
 .../selftests/kvm/include/userfaultfd_util.h  |  45 ++++
 .../selftests/kvm/lib/userfaultfd_util.c      | 186 ++++++++++++++
 4 files changed, 262 insertions(+), 198 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0172eb6cb6ee..08a2606aff33 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -47,6 +47,7 @@ LIBKVM += lib/perf_test_util.c
 LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
+LIBKVM += lib/userfaultfd_util.c
 
 LIBKVM_STRING += lib/string_override.c
 
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 779ae54f89c4..8e1fe4ffcccd 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -22,23 +22,13 @@
 #include "test_util.h"
 #include "perf_test_util.h"
 #include "guest_modes.h"
+#include "userfaultfd_util.h"
 
 #ifdef __NR_userfaultfd
 
-#ifdef PRINT_PER_PAGE_UPDATES
-#define PER_PAGE_DEBUG(...) printf(__VA_ARGS__)
-#else
-#define PER_PAGE_DEBUG(...) _no_printf(__VA_ARGS__)
-#endif
-
-#ifdef PRINT_PER_VCPU_UPDATES
-#define PER_VCPU_DEBUG(...) printf(__VA_ARGS__)
-#else
-#define PER_VCPU_DEBUG(...) _no_printf(__VA_ARGS__)
-#endif
-
 static int nr_vcpus = 1;
 static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
+
 static size_t demand_paging_size;
 static char *guest_data_prototype;
 
@@ -67,9 +57,11 @@ static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 		       ts_diff.tv_sec, ts_diff.tv_nsec);
 }
 
-static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t addr)
+static int handle_uffd_page_request(int uffd_mode, int uffd,
+		struct uffd_msg *msg)
 {
 	pid_t tid = syscall(__NR_gettid);
+	uint64_t addr = msg->arg.pagefault.address;
 	struct timespec start;
 	struct timespec ts_diff;
 	int r;
@@ -116,174 +108,32 @@ static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t addr)
 	return 0;
 }
 
-bool quit_uffd_thread;
-
-struct uffd_handler_args {
+struct test_params {
 	int uffd_mode;
-	int uffd;
-	int pipefd;
-	useconds_t delay;
+	useconds_t uffd_delay;
+	enum vm_mem_backing_src_type src_type;
+	bool partition_vcpu_memory_access;
 };
 
-static void *uffd_handler_thread_fn(void *arg)
-{
-	struct uffd_handler_args *uffd_args = (struct uffd_handler_args *)arg;
-	int uffd = uffd_args->uffd;
-	int pipefd = uffd_args->pipefd;
-	useconds_t delay = uffd_args->delay;
-	int64_t pages = 0;
-	struct timespec start;
-	struct timespec ts_diff;
-
-	clock_gettime(CLOCK_MONOTONIC, &start);
-	while (!quit_uffd_thread) {
-		struct uffd_msg msg;
-		struct pollfd pollfd[2];
-		char tmp_chr;
-		int r;
-		uint64_t addr;
-
-		pollfd[0].fd = uffd;
-		pollfd[0].events = POLLIN;
-		pollfd[1].fd = pipefd;
-		pollfd[1].events = POLLIN;
-
-		r = poll(pollfd, 2, -1);
-		switch (r) {
-		case -1:
-			pr_info("poll err");
-			continue;
-		case 0:
-			continue;
-		case 1:
-			break;
-		default:
-			pr_info("Polling uffd returned %d", r);
-			return NULL;
-		}
-
-		if (pollfd[0].revents & POLLERR) {
-			pr_info("uffd revents has POLLERR");
-			return NULL;
-		}
-
-		if (pollfd[1].revents & POLLIN) {
-			r = read(pollfd[1].fd, &tmp_chr, 1);
-			TEST_ASSERT(r == 1,
-				    "Error reading pipefd in UFFD thread\n");
-			return NULL;
-		}
-
-		if (!(pollfd[0].revents & POLLIN))
-			continue;
-
-		r = read(uffd, &msg, sizeof(msg));
-		if (r == -1) {
-			if (errno == EAGAIN)
-				continue;
-			pr_info("Read of uffd got errno %d\n", errno);
-			return NULL;
-		}
-
-		if (r != sizeof(msg)) {
-			pr_info("Read on uffd returned unexpected size: %d bytes", r);
-			return NULL;
-		}
-
-		if (!(msg.event & UFFD_EVENT_PAGEFAULT))
-			continue;
-
-		if (delay)
-			usleep(delay);
-		addr =  msg.arg.pagefault.address;
-		r = handle_uffd_page_request(uffd_args->uffd_mode, uffd, addr);
-		if (r < 0)
-			return NULL;
-		pages++;
-	}
-
-	ts_diff = timespec_elapsed(start);
-	PER_VCPU_DEBUG("userfaulted %ld pages over %ld.%.9lds. (%f/sec)\n",
-		       pages, ts_diff.tv_sec, ts_diff.tv_nsec,
-		       pages / ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
-
-	return NULL;
-}
-
-static void setup_demand_paging(struct kvm_vm *vm,
-				pthread_t *uffd_handler_thread, int pipefd,
-				int uffd_mode, useconds_t uffd_delay,
-				struct uffd_handler_args *uffd_args,
-				void *hva, void *alias, uint64_t len)
+static void prefault_mem(void *alias, uint64_t len)
 {
-	bool is_minor = (uffd_mode == UFFDIO_REGISTER_MODE_MINOR);
-	int uffd;
-	struct uffdio_api uffdio_api;
-	struct uffdio_register uffdio_register;
-	uint64_t expected_ioctls = ((uint64_t) 1) << _UFFDIO_COPY;
-	int ret;
+	size_t p;
 
-	PER_PAGE_DEBUG("Userfaultfd %s mode, faults resolved with %s\n",
-		       is_minor ? "MINOR" : "MISSING",
-		       is_minor ? "UFFDIO_CONINUE" : "UFFDIO_COPY");
-
-	/* In order to get minor faults, prefault via the alias. */
-	if (is_minor) {
-		size_t p;
-
-		expected_ioctls = ((uint64_t) 1) << _UFFDIO_CONTINUE;
-
-		TEST_ASSERT(alias != NULL, "Alias required for minor faults");
-		for (p = 0; p < (len / demand_paging_size); ++p) {
-			memcpy(alias + (p * demand_paging_size),
-			       guest_data_prototype, demand_paging_size);
-		}
+	TEST_ASSERT(alias != NULL, "Alias required for minor faults");
+	for (p = 0; p < (len / demand_paging_size); ++p) {
+		memcpy(alias + (p * demand_paging_size),
+		       guest_data_prototype, demand_paging_size);
 	}
-
-	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
-	TEST_ASSERT(uffd >= 0, __KVM_SYSCALL_ERROR("userfaultfd()", uffd));
-
-	uffdio_api.api = UFFD_API;
-	uffdio_api.features = 0;
-	ret = ioctl(uffd, UFFDIO_API, &uffdio_api);
-	TEST_ASSERT(ret != -1, __KVM_SYSCALL_ERROR("UFFDIO_API", ret));
-
-	uffdio_register.range.start = (uint64_t)hva;
-	uffdio_register.range.len = len;
-	uffdio_register.mode = uffd_mode;
-	ret = ioctl(uffd, UFFDIO_REGISTER, &uffdio_register);
-	TEST_ASSERT(ret != -1, __KVM_SYSCALL_ERROR("UFFDIO_REGISTER", ret));
-	TEST_ASSERT((uffdio_register.ioctls & expected_ioctls) ==
-		    expected_ioctls, "missing userfaultfd ioctls");
-
-	uffd_args->uffd_mode = uffd_mode;
-	uffd_args->uffd = uffd;
-	uffd_args->pipefd = pipefd;
-	uffd_args->delay = uffd_delay;
-	pthread_create(uffd_handler_thread, NULL, uffd_handler_thread_fn,
-		       uffd_args);
-
-	PER_VCPU_DEBUG("Created uffd thread for HVA range [%p, %p)\n",
-		       hva, hva + len);
 }
 
-struct test_params {
-	int uffd_mode;
-	useconds_t uffd_delay;
-	enum vm_mem_backing_src_type src_type;
-	bool partition_vcpu_memory_access;
-};
-
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *p = arg;
-	pthread_t *uffd_handler_threads = NULL;
-	struct uffd_handler_args *uffd_args = NULL;
+	struct uffd_desc **uffd_descs = NULL;
 	struct timespec start;
 	struct timespec ts_diff;
-	int *pipefds = NULL;
 	struct kvm_vm *vm;
-	int r, i;
+	int i;
 
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
@@ -296,15 +146,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	memset(guest_data_prototype, 0xAB, demand_paging_size);
 
 	if (p->uffd_mode) {
-		uffd_handler_threads =
-			malloc(nr_vcpus * sizeof(*uffd_handler_threads));
-		TEST_ASSERT(uffd_handler_threads, "Memory allocation failed");
-
-		uffd_args = malloc(nr_vcpus * sizeof(*uffd_args));
-		TEST_ASSERT(uffd_args, "Memory allocation failed");
-
-		pipefds = malloc(sizeof(int) * nr_vcpus * 2);
-		TEST_ASSERT(pipefds, "Unable to allocate memory for pipefd");
+		uffd_descs = malloc(nr_vcpus * sizeof(struct uffd_desc *));
+		TEST_ASSERT(uffd_descs, "Memory allocation failed");
 
 		for (i = 0; i < nr_vcpus; i++) {
 			struct perf_test_vcpu_args *vcpu_args;
@@ -317,19 +160,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			vcpu_hva = addr_gpa2hva(vm, vcpu_args->gpa);
 			vcpu_alias = addr_gpa2alias(vm, vcpu_args->gpa);
 
+			prefault_mem(vcpu_alias,
+				vcpu_args->pages * perf_test_args.guest_page_size);
+
 			/*
 			 * Set up user fault fd to handle demand paging
 			 * requests.
 			 */
-			r = pipe2(&pipefds[i * 2],
-				  O_CLOEXEC | O_NONBLOCK);
-			TEST_ASSERT(!r, "Failed to set up pipefd");
-
-			setup_demand_paging(vm, &uffd_handler_threads[i],
-					    pipefds[i * 2], p->uffd_mode,
-					    p->uffd_delay, &uffd_args[i],
-					    vcpu_hva, vcpu_alias,
-					    vcpu_args->pages * perf_test_args.guest_page_size);
+			uffd_descs[i] = uffd_setup_demand_paging(
+				p->uffd_mode, p->uffd_delay, vcpu_hva,
+				vcpu_args->pages * perf_test_args.guest_page_size,
+				&handle_uffd_page_request);
 		}
 	}
 
@@ -344,15 +185,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("All vCPU threads joined\n");
 
 	if (p->uffd_mode) {
-		char c;
-
 		/* Tell the user fault fd handler threads to quit */
-		for (i = 0; i < nr_vcpus; i++) {
-			r = write(pipefds[i * 2 + 1], &c, 1);
-			TEST_ASSERT(r == 1, "Unable to write to pipefd");
-
-			pthread_join(uffd_handler_threads[i], NULL);
-		}
+		for (i = 0; i < nr_vcpus; i++)
+			uffd_stop_demand_paging(uffd_descs[i]);
 	}
 
 	pr_info("Total guest execution time: %ld.%.9lds\n",
@@ -364,11 +199,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	perf_test_destroy_vm(vm);
 
 	free(guest_data_prototype);
-	if (p->uffd_mode) {
-		free(uffd_handler_threads);
-		free(uffd_args);
-		free(pipefds);
-	}
+	if (p->uffd_mode)
+		free(uffd_descs);
 }
 
 static void help(char *name)
diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/tools/testing/selftests/kvm/include/userfaultfd_util.h
new file mode 100644
index 000000000000..877449c34592
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/userfaultfd_util.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * KVM userfaultfd util
+ *
+ * Copyright (C) 2018, Red Hat, Inc.
+ * Copyright (C) 2019-2022 Google LLC
+ */
+
+#define _GNU_SOURCE /* for pipe2 */
+
+#include <inttypes.h>
+#include <time.h>
+#include <pthread.h>
+#include <linux/userfaultfd.h>
+
+#include "test_util.h"
+
+typedef int (*uffd_handler_t)(int uffd_mode, int uffd, struct uffd_msg *msg);
+
+struct uffd_desc {
+	int uffd_mode;
+	int uffd;
+	int pipefds[2];
+	useconds_t delay;
+	uffd_handler_t handler;
+	pthread_t thread;
+};
+
+struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
+					   void *hva, uint64_t len,
+					   uffd_handler_t handler);
+
+void uffd_stop_demand_paging(struct uffd_desc *uffd);
+
+#ifdef PRINT_PER_PAGE_UPDATES
+#define PER_PAGE_DEBUG(...) printf(__VA_ARGS__)
+#else
+#define PER_PAGE_DEBUG(...) _no_printf(__VA_ARGS__)
+#endif
+
+#ifdef PRINT_PER_VCPU_UPDATES
+#define PER_VCPU_DEBUG(...) printf(__VA_ARGS__)
+#else
+#define PER_VCPU_DEBUG(...) _no_printf(__VA_ARGS__)
+#endif
diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
new file mode 100644
index 000000000000..3b44846fc277
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM userfaultfd util
+ * Adapted from demand_paging_test.c
+ *
+ * Copyright (C) 2018, Red Hat, Inc.
+ * Copyright (C) 2019-2022 Google LLC
+ */
+
+#define _GNU_SOURCE /* for pipe2 */
+
+#include <inttypes.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <time.h>
+#include <poll.h>
+#include <pthread.h>
+#include <linux/userfaultfd.h>
+#include <sys/syscall.h>
+
+#include "kvm_util.h"
+#include "test_util.h"
+#include "perf_test_util.h"
+#include "userfaultfd_util.h"
+
+#ifdef __NR_userfaultfd
+
+static void *uffd_handler_thread_fn(void *arg)
+{
+	struct uffd_desc *uffd_desc = (struct uffd_desc *)arg;
+	int uffd = uffd_desc->uffd;
+	int pipefd = uffd_desc->pipefds[0];
+	useconds_t delay = uffd_desc->delay;
+	int64_t pages = 0;
+	struct timespec start;
+	struct timespec ts_diff;
+
+	clock_gettime(CLOCK_MONOTONIC, &start);
+	while (1) {
+		struct uffd_msg msg;
+		struct pollfd pollfd[2];
+		char tmp_chr;
+		int r;
+
+		pollfd[0].fd = uffd;
+		pollfd[0].events = POLLIN;
+		pollfd[1].fd = pipefd;
+		pollfd[1].events = POLLIN;
+
+		r = poll(pollfd, 2, -1);
+		switch (r) {
+		case -1:
+			pr_info("poll err");
+			continue;
+		case 0:
+			continue;
+		case 1:
+			break;
+		default:
+			pr_info("Polling uffd returned %d", r);
+			return NULL;
+		}
+
+		if (pollfd[0].revents & POLLERR) {
+			pr_info("uffd revents has POLLERR");
+			return NULL;
+		}
+
+		if (pollfd[1].revents & POLLIN) {
+			r = read(pollfd[1].fd, &tmp_chr, 1);
+			TEST_ASSERT(r == 1,
+				    "Error reading pipefd in UFFD thread\n");
+			return NULL;
+		}
+
+		if (!(pollfd[0].revents & POLLIN))
+			continue;
+
+		r = read(uffd, &msg, sizeof(msg));
+		if (r == -1) {
+			if (errno == EAGAIN)
+				continue;
+			pr_info("Read of uffd got errno %d\n", errno);
+			return NULL;
+		}
+
+		if (r != sizeof(msg)) {
+			pr_info("Read on uffd returned unexpected size: %d bytes", r);
+			return NULL;
+		}
+
+		if (!(msg.event & UFFD_EVENT_PAGEFAULT))
+			continue;
+
+		if (delay)
+			usleep(delay);
+		r = uffd_desc->handler(uffd_desc->uffd_mode, uffd, &msg);
+		if (r < 0)
+			return NULL;
+		pages++;
+	}
+
+	ts_diff = timespec_elapsed(start);
+	PER_VCPU_DEBUG("userfaulted %ld pages over %ld.%.9lds. (%f/sec)\n",
+		       pages, ts_diff.tv_sec, ts_diff.tv_nsec,
+		       pages / ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
+
+	return NULL;
+}
+
+struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
+					   void *hva, uint64_t len,
+					   uffd_handler_t handler)
+{
+	struct uffd_desc *uffd_desc;
+	bool is_minor = (uffd_mode == UFFDIO_REGISTER_MODE_MINOR);
+	int uffd;
+	struct uffdio_api uffdio_api;
+	struct uffdio_register uffdio_register;
+	uint64_t expected_ioctls = ((uint64_t) 1) << _UFFDIO_COPY;
+	int ret;
+
+	PER_PAGE_DEBUG("Userfaultfd %s mode, faults resolved with %s\n",
+		       is_minor ? "MINOR" : "MISSING",
+		       is_minor ? "UFFDIO_CONINUE" : "UFFDIO_COPY");
+
+	uffd_desc = malloc(sizeof(struct uffd_desc));
+	TEST_ASSERT(uffd_desc, "malloc failed");
+
+	/* In order to get minor faults, prefault via the alias. */
+	if (is_minor)
+		expected_ioctls = ((uint64_t) 1) << _UFFDIO_CONTINUE;
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	TEST_ASSERT(uffd >= 0, "uffd creation failed, errno: %d", errno);
+
+	uffdio_api.api = UFFD_API;
+	uffdio_api.features = 0;
+	TEST_ASSERT(ioctl(uffd, UFFDIO_API, &uffdio_api) != -1,
+		    "ioctl UFFDIO_API failed: %" PRIu64,
+		    (uint64_t)uffdio_api.api);
+
+	uffdio_register.range.start = (uint64_t)hva;
+	uffdio_register.range.len = len;
+	uffdio_register.mode = uffd_mode;
+	TEST_ASSERT(ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) != -1,
+		    "ioctl UFFDIO_REGISTER failed");
+	TEST_ASSERT((uffdio_register.ioctls & expected_ioctls) ==
+		    expected_ioctls, "missing userfaultfd ioctls");
+
+	ret = pipe2(uffd_desc->pipefds, O_CLOEXEC | O_NONBLOCK);
+	TEST_ASSERT(!ret, "Failed to set up pipefd");
+
+	uffd_desc->uffd_mode = uffd_mode;
+	uffd_desc->uffd = uffd;
+	uffd_desc->delay = delay;
+	uffd_desc->handler = handler;
+	pthread_create(&uffd_desc->thread, NULL, uffd_handler_thread_fn,
+		       uffd_desc);
+
+	PER_VCPU_DEBUG("Created uffd thread for HVA range [%p, %p)\n",
+		       hva, hva + len);
+
+	return uffd_desc;
+}
+
+void uffd_stop_demand_paging(struct uffd_desc *uffd)
+{
+	char c = 0;
+	int ret;
+
+	ret = write(uffd->pipefds[1], &c, 1);
+	TEST_ASSERT(ret == 1, "Unable to write to pipefd");
+
+	ret = pthread_join(uffd->thread, NULL);
+	TEST_ASSERT(ret == 0, "Pthread_join failed.");
+
+	close(uffd->uffd);
+
+	close(uffd->pipefds[1]);
+	close(uffd->pipefds[0]);
+
+	free(uffd);
+}
+
+#endif /* __NR_userfaultfd */
-- 
2.38.0.413.g74048e4d9e-goog

