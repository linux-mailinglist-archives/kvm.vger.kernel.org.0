Return-Path: <kvm+bounces-45973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE5C9AB0330
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 20:49:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79671178575
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 18:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134C728B7E4;
	Thu,  8 May 2025 18:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dfgyAqoO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f202.google.com (mail-vk1-f202.google.com [209.85.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FCD288536
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 18:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730020; cv=none; b=g93F7a/aRXbrgdiUytBu5l6BSvDJft3JFtqwogx3GMZCW2nCbL+hHH233ucIXtq+p9LatvePmNlJ8FRZuua851VNNcy72jLE660UXDR38xI2NqQ17E9T6/RMmVacWEjSah420fkBkEjnnrVBRmyFFdEBfRnMbCpfNvsdPRbVAbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730020; c=relaxed/simple;
	bh=uGzoZiAyC7XeHc9C6MAXsup18eUjrbN0PWQ5mpOWyLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EHqPhq1p49znauYnXfQpeQJQgWsZYhfbcD+2AIU0ksz/imPdmyR3d7YFXiTXygTlkW4VKf/GHHSBh5LBKLjRoE326mugfED6pWGYu+e3bo32fjlk7rw8kTy1R+7gjkLTQaJ88RI5QD9yGqW1ykHltcyxVcJtF1hQSEBvxkfdHF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dfgyAqoO; arc=none smtp.client-ip=209.85.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f202.google.com with SMTP id 71dfb90a1353d-523f9fafc5bso287557e0c.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 11:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746730016; x=1747334816; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g7MOPr6aEyCJBKCYTTWJ1BhSZeOvZNL8U24hH1aKYh4=;
        b=dfgyAqoOdwdxKo1hl3sBEi394wqfvCVmQJ7PPbdwZDnuV8TU9Z9qPIjRCo73hNO6HX
         XKAoGjApjMuAaHV3OxUxv1VyzHsIvCtH8tQj6vLTwNmYE8OJSvJH1waSMUv7FkPxr2eW
         qHpi9qRSrClD1utA9xEyLDL00sbme22wo/E9DQOMleOy7P72KBmAhmX/vjMgrdQps+ZT
         V5erPppPJxpG7uQwcF6YOCBLNXdh9oLzQmY9OJcueQz3EJZPhvjIJ/Hqk1n0BEVPzgKd
         E5aRzpCjaL8Q/8VxqsszT9lsKWjpZsOA+Zb7Vz8AUCBknMTf+ONpEPB16BzuWCg5K2w5
         uHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730016; x=1747334816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g7MOPr6aEyCJBKCYTTWJ1BhSZeOvZNL8U24hH1aKYh4=;
        b=H2aue92/M3JfHq/NO+CMQgVfyYv2ZCtqu7T5ldKk65PXQHk2BwCGgoIeM2RQaNndUg
         H6SRrHtV3OflY1mQoNlvO59OQSWnW7YLfqq5BIaQ/rKaubi5QkuR1tgu4M+z/valo7/s
         5UCs7GsIk02L6bsjHW42P0Ac8HYYxIc2g+BeEXtR2pzyq0y1aOx2KB7MFgV1pfHCaqVP
         sZQDsL0C8AWgsD4bfwhUiPyJfMJ/F9sYAbf5bGyTgmktWSJoxzhg3Pc37YyHMMXAKM2H
         i6HSshO+R6evZ3jefPqd++AS2Rel4CQuLP75OQsbAcAk+6q9QwyzXz+8244P5S63z9R4
         QgNw==
X-Forwarded-Encrypted: i=1; AJvYcCW2WYfip/oFzraCFO5CWINoJDNXjWhd6jrzdemzAOMrUTrdUShhaU2T2UP4OO+jQS/DXXs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2kadVRgVuNtpZas5GldkiZnQC5XdbZNX9zqrNcMX0DhiXe/7j
	E44FL1qAWQLeD0DuKpMfQ+5Iy82EGNsyiPUUnokyBC+nTbDSiLlkNutYGzyPGB47MZG0kSMZyc2
	hPTt/DGuqDxk1ds6a2g==
X-Google-Smtp-Source: AGHT+IGf6TRPd0VvytlRNzzFCvUuIvZQ2B6eYivTZIQK94OkxaMDDnPLjXseEjTKt4R30HtA36ZwF3H1RdlMbOxE
X-Received: from vsbbu12.prod.google.com ([2002:a05:6102:524c:b0:4c2:f06a:6e57])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:151c:b0:4db:154e:69a7 with SMTP id ada2fe7eead31-4deed32b9c1mr742288137.2.1746730016307;
 Thu, 08 May 2025 11:46:56 -0700 (PDT)
Date: Thu,  8 May 2025 18:46:48 +0000
In-Reply-To: <20250508184649.2576210-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250508184649.2576210-1-jthoughton@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250508184649.2576210-8-jthoughton@google.com>
Subject: [PATCH v4 7/7] KVM: selftests: access_tracking_perf_test: Use MGLRU
 for access tracking
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Yu Zhao <yuzhao@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Use MGLRU's debugfs interface to do access tracking instead of
page_idle. The logic to use the page_idle bitmap is left in, as it is
useful for kernels that do not have MGLRU built in.

When MGLRU is enabled, page_idle will report pages as still idle even
after being accessed, as MGLRU doesn't necessarily clear the Idle folio
flag when accessing an idle page, so the test will not attempt to use
page_idle if MGLRU is enabled but otherwise not usable.

Aging pages with MGLRU is much faster than marking pages as idle with
page_idle.

Co-developed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/access_tracking_perf_test.c | 227 ++++++++--
 .../selftests/kvm/include/lru_gen_util.h      |  51 +++
 .../testing/selftests/kvm/lib/lru_gen_util.c  | 386 ++++++++++++++++++
 4 files changed, 638 insertions(+), 27 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/lru_gen_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/lru_gen_util.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index bea746878bcaa..24d2a5d387d34 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -8,6 +8,7 @@ LIBKVM += lib/elf.c
 LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
+LIBKVM += lib/lru_gen_util.c
 LIBKVM += lib/memstress.c
 LIBKVM += lib/guest_sprintf.c
 LIBKVM += lib/rbtree.c
diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index a2ac6fa2ba141..da7196fd1b230 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -7,9 +7,11 @@
  * This test measures the performance effects of KVM's access tracking.
  * Access tracking is driven by the MMU notifiers test_young, clear_young, and
  * clear_flush_young. These notifiers do not have a direct userspace API,
- * however the clear_young notifier can be triggered by marking a pages as idle
- * in /sys/kernel/mm/page_idle/bitmap. This test leverages that mechanism to
- * enable access tracking on guest memory.
+ * however the clear_young notifier can be triggered either by
+ *   1. marking a pages as idle in /sys/kernel/mm/page_idle/bitmap OR
+ *   2. adding a new MGLRU generation using the lru_gen debugfs file.
+ * This test leverages page_idle to enable access tracking on guest memory
+ * unless MGLRU is enabled, in which case MGLRU is used.
  *
  * To measure performance this test runs a VM with a configurable number of
  * vCPUs that each touch every page in disjoint regions of memory. Performance
@@ -17,10 +19,11 @@
  * predefined region.
  *
  * Note that a deterministic correctness test of access tracking is not possible
- * by using page_idle as it exists today. This is for a few reasons:
+ * by using page_idle or MGLRU aging as it exists today. This is for a few
+ * reasons:
  *
- * 1. page_idle only issues clear_young notifiers, which lack a TLB flush. This
- *    means subsequent guest accesses are not guaranteed to see page table
+ * 1. page_idle and MGLRU only issue clear_young notifiers, which lack a TLB flush.
+ *    This means subsequent guest accesses are not guaranteed to see page table
  *    updates made by KVM until some time in the future.
  *
  * 2. page_idle only operates on LRU pages. Newly allocated pages are not
@@ -48,9 +51,17 @@
 #include "guest_modes.h"
 #include "processor.h"
 
+#include "cgroup_util.h"
+#include "lru_gen_util.h"
+
+static const char *TEST_MEMCG_NAME = "access_tracking_perf_test";
+
 /* Global variable used to synchronize all of the vCPU threads. */
 static int iteration;
 
+/* The cgroup memory controller root. Needed for lru_gen-based aging. */
+char cgroup_root[PATH_MAX];
+
 /* Defines what vCPU threads should do during a given iteration. */
 static enum {
 	/* Run the vCPU to access all its memory. */
@@ -75,6 +86,15 @@ static bool overlap_memory_access;
  */
 static int idle_pages_warn_only = -1;
 
+/* Whether or not to use MGLRU instead of page_idle for access tracking */
+static bool use_lru_gen;
+
+/* Total number of pages to expect in the memcg after touching everything */
+static long test_pages;
+
+/* Last generation we found the pages in */
+static int lru_gen_last_gen = -1;
+
 struct test_params {
 	/* The backing source for the region of memory. */
 	enum vm_mem_backing_src_type backing_src;
@@ -133,8 +153,24 @@ static void mark_page_idle(int page_idle_fd, uint64_t pfn)
 		    "Set page_idle bits for PFN 0x%" PRIx64, pfn);
 }
 
-static void mark_vcpu_memory_idle(struct kvm_vm *vm,
-				  struct memstress_vcpu_args *vcpu_args)
+static void too_many_idle_pages(long idle_pages, long total_pages, int vcpu_idx)
+{
+	char prefix[18] = {};
+
+	if (vcpu_idx >= 0)
+		snprintf(prefix, 18, "vCPU%d: ", vcpu_idx);
+
+	TEST_ASSERT(idle_pages_warn_only,
+		    "%sToo many pages still idle (%lu out of %lu)",
+		    prefix, idle_pages, total_pages);
+
+	printf("WARNING: %sToo many pages still idle (%lu out of %lu), "
+	       "this will affect performance results.\n",
+	       prefix, idle_pages, total_pages);
+}
+
+static void pageidle_mark_vcpu_memory_idle(struct kvm_vm *vm,
+					   struct memstress_vcpu_args *vcpu_args)
 {
 	int vcpu_idx = vcpu_args->vcpu_idx;
 	uint64_t base_gva = vcpu_args->gva;
@@ -188,20 +224,78 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm,
 	 * access tracking but low enough as to not make the test too brittle
 	 * over time and across architectures.
 	 */
-	if (still_idle >= pages / 10) {
-		TEST_ASSERT(idle_pages_warn_only,
-			    "vCPU%d: Too many pages still idle (%lu out of %lu)",
-			    vcpu_idx, still_idle, pages);
-
-		printf("WARNING: vCPU%d: Too many pages still idle (%lu out of %lu), "
-		       "this will affect performance results.\n",
-		       vcpu_idx, still_idle, pages);
-	}
+	if (still_idle >= pages / 10)
+		too_many_idle_pages(still_idle, pages,
+				    overlap_memory_access ? -1 : vcpu_idx);
 
 	close(page_idle_fd);
 	close(pagemap_fd);
 }
 
+int find_generation(struct memcg_stats *stats, long total_pages)
+{
+	/*
+	 * For finding the generation that contains our pages, use the same
+	 * 90% threshold that page_idle uses.
+	 */
+	int gen = lru_gen_find_generation(stats, total_pages * 9 / 10);
+
+	if (gen >= 0)
+		return gen;
+
+	if (!idle_pages_warn_only) {
+		TEST_FAIL("Could not find a generation with 90%% of guest memory (%ld pages).",
+			   total_pages * 9 / 10);
+		return gen;
+	}
+
+	/*
+	 * We couldn't find a generation with 90% of guest memory, which can
+	 * happen if access tracking is unreliable. Simply look for a majority
+	 * of pages.
+	 */
+	puts("WARNING: Couldn't find a generation with 90% of guest memory. "
+	     "Performance results may not be accurate.");
+	gen = lru_gen_find_generation(stats, total_pages / 2);
+	TEST_ASSERT(gen >= 0,
+		    "Could not find a generation with 50%% of guest memory (%ld pages).",
+		    total_pages / 2);
+	return gen;
+}
+
+static void lru_gen_mark_memory_idle(struct kvm_vm *vm)
+{
+	struct timespec ts_start;
+	struct timespec ts_elapsed;
+	struct memcg_stats stats;
+	int new_gen;
+
+	/* Make a new generation */
+	clock_gettime(CLOCK_MONOTONIC, &ts_start);
+	lru_gen_do_aging(&stats, TEST_MEMCG_NAME);
+	ts_elapsed = timespec_elapsed(ts_start);
+
+	/* Check the generation again */
+	new_gen = find_generation(&stats, test_pages);
+
+	/*
+	 * This function should only be invoked with newly-accessed pages,
+	 * so pages should always move to a newer generation.
+	 */
+	if (new_gen <= lru_gen_last_gen) {
+		/* We did not move to a newer generation. */
+		long idle_pages = lru_gen_sum_memcg_stats_for_gen(lru_gen_last_gen,
+								  &stats);
+
+		too_many_idle_pages(min_t(long, idle_pages, test_pages),
+				    test_pages, -1);
+	}
+	pr_info("%-30s: %ld.%09lds\n",
+		"Mark memory idle (lru_gen)", ts_elapsed.tv_sec,
+		ts_elapsed.tv_nsec);
+	lru_gen_last_gen = new_gen;
+}
+
 static void assert_ucall(struct kvm_vcpu *vcpu, uint64_t expected_ucall)
 {
 	struct ucall uc;
@@ -241,7 +335,7 @@ static void vcpu_thread_main(struct memstress_vcpu_args *vcpu_args)
 			assert_ucall(vcpu, UCALL_SYNC);
 			break;
 		case ITERATION_MARK_IDLE:
-			mark_vcpu_memory_idle(vm, vcpu_args);
+			pageidle_mark_vcpu_memory_idle(vm, vcpu_args);
 			break;
 		}
 
@@ -293,15 +387,18 @@ static void access_memory(struct kvm_vm *vm, int nr_vcpus,
 
 static void mark_memory_idle(struct kvm_vm *vm, int nr_vcpus)
 {
+	if (use_lru_gen)
+		return lru_gen_mark_memory_idle(vm);
+
 	/*
 	 * Even though this parallelizes the work across vCPUs, this is still a
 	 * very slow operation because page_idle forces the test to mark one pfn
-	 * at a time and the clear_young notifier serializes on the KVM MMU
+	 * at a time and the clear_young notifier may serialize on the KVM MMU
 	 * lock.
 	 */
 	pr_debug("Marking VM memory idle (slow)...\n");
 	iteration_work = ITERATION_MARK_IDLE;
-	run_iteration(vm, nr_vcpus, "Mark memory idle");
+	run_iteration(vm, nr_vcpus, "Mark memory idle (page_idle)");
 }
 
 static void run_test(enum vm_guest_mode mode, void *arg)
@@ -313,11 +410,38 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vm = memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
 				 params->backing_src, !overlap_memory_access);
 
+	/*
+	 * If guest_page_size is larger than the host's page size, the
+	 * guest (memstress) will only fault in a subset of the host's pages.
+	 */
+	test_pages = params->nr_vcpus * params->vcpu_memory_bytes /
+		      max(memstress_args.guest_page_size,
+			  (uint64_t)getpagesize());
+
 	memstress_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
 
 	pr_info("\n");
 	access_memory(vm, nr_vcpus, ACCESS_WRITE, "Populating memory");
 
+	if (use_lru_gen) {
+		struct memcg_stats stats;
+
+		/*
+		 * Do a page table scan now. Following initial population, aging
+		 * may not cause the pages to move to a newer generation. Do
+		 * an aging pass now so that future aging passes always move
+		 * pages to a newer generation.
+		 */
+		printf("Initial aging pass (lru_gen)\n");
+		lru_gen_do_aging(&stats, TEST_MEMCG_NAME);
+		TEST_ASSERT(lru_gen_sum_memcg_stats(&stats) >= test_pages,
+			    "Not all pages accounted for (looking for %ld). "
+			    "Was the memcg set up correctly?", test_pages);
+		access_memory(vm, nr_vcpus, ACCESS_WRITE, "Re-populating memory");
+		lru_gen_read_memcg_stats(&stats, TEST_MEMCG_NAME);
+		lru_gen_last_gen = find_generation(&stats, test_pages);
+	}
+
 	/* As a control, read and write to the populated memory first. */
 	access_memory(vm, nr_vcpus, ACCESS_WRITE, "Writing to populated memory");
 	access_memory(vm, nr_vcpus, ACCESS_READ, "Reading from populated memory");
@@ -354,7 +478,12 @@ static int access_tracking_unreliable(void)
 		puts("Skipping idle page count sanity check, because NUMA balancing is enabled");
 		return 1;
 	}
+	return 0;
+}
 
+static int run_test_for_each_guest_mode(const char *cgroup, void *arg)
+{
+	for_each_guest_mode(run_test, arg);
 	return 0;
 }
 
@@ -372,7 +501,7 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
-	printf(" -w: Control whether the test warns or fails if more than 10%\n"
+	printf(" -w: Control whether the test warns or fails if more than 10%%\n"
 	       "     of pages are still seen as idle/old after accessing guest\n"
 	       "     memory.  >0 == warn only, 0 == fail, <0 == auto.  For auto\n"
 	       "     mode, the test fails by default, but switches to warn only\n"
@@ -383,6 +512,11 @@ static void help(char *name)
 	exit(0);
 }
 
+void destroy_cgroup(char *cg)
+{
+	printf("Destroying cgroup: %s\n", cg);
+}
+
 int main(int argc, char *argv[])
 {
 	struct test_params params = {
@@ -390,6 +524,7 @@ int main(int argc, char *argv[])
 		.vcpu_memory_bytes = DEFAULT_PER_VCPU_MEM_SIZE,
 		.nr_vcpus = 1,
 	};
+	char *new_cg = NULL;
 	int page_idle_fd;
 	int opt;
 
@@ -424,15 +559,53 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
-	__TEST_REQUIRE(page_idle_fd >= 0,
-		       "CONFIG_IDLE_PAGE_TRACKING is not enabled");
-	close(page_idle_fd);
-
 	if (idle_pages_warn_only == -1)
 		idle_pages_warn_only = access_tracking_unreliable();
 
-	for_each_guest_mode(run_test, &params);
+	if (lru_gen_usable()) {
+		bool cg_created = true;
+		int ret;
+
+		puts("Using lru_gen for aging");
+		use_lru_gen = true;
+
+		if (cg_find_controller_root(cgroup_root, sizeof(cgroup_root), "memory"))
+			ksft_exit_skip("Cannot find memory cgroup controller\n");
+
+		new_cg = cg_name(cgroup_root, TEST_MEMCG_NAME);
+		printf("Creating cgroup: %s\n", new_cg);
+		if (cg_create(new_cg)) {
+			if (errno == EEXIST) {
+				printf("Found existing cgroup");
+				cg_created = false;
+			} else {
+				ksft_exit_skip("could not create new cgroup: %s\n", new_cg);
+			}
+		}
+
+		/*
+		 * This will fork off a new process to run the test within
+		 * a new memcg, so we need to properly propagate the return
+		 * value up.
+		 */
+		ret = cg_run(new_cg, &run_test_for_each_guest_mode, &params);
+		if (cg_created)
+			cg_destroy(new_cg);
+		if (ret < 0)
+			TEST_FAIL("child did not spawn or was abnormally killed");
+		if (ret)
+			return ret;
+	} else {
+		page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
+		__TEST_REQUIRE(page_idle_fd >= 0,
+			       "Couldn't open /sys/kernel/mm/page_idle/bitmap. "
+			       "Is CONFIG_IDLE_PAGE_TRACKING enabled?");
+
+		close(page_idle_fd);
+
+		puts("Using page_idle for aging");
+		run_test_for_each_guest_mode(NULL, &params);
+	}
 
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/include/lru_gen_util.h b/tools/testing/selftests/kvm/include/lru_gen_util.h
new file mode 100644
index 0000000000000..d32ff5d8ffd05
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/lru_gen_util.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Tools for integrating with lru_gen, like parsing the lru_gen debugfs output.
+ *
+ * Copyright (C) 2025, Google LLC.
+ */
+#ifndef SELFTEST_KVM_LRU_GEN_UTIL_H
+#define SELFTEST_KVM_LRU_GEN_UTIL_H
+
+#include <inttypes.h>
+#include <limits.h>
+#include <stdlib.h>
+
+#include "test_util.h"
+
+#define MAX_NR_GENS 16 /* MAX_NR_GENS in include/linux/mmzone.h */
+#define MAX_NR_NODES 4 /* Maximum number of nodes supported by the test */
+
+#define LRU_GEN_DEBUGFS "/sys/kernel/debug/lru_gen"
+#define LRU_GEN_ENABLED_PATH "/sys/kernel/mm/lru_gen/enabled"
+#define LRU_GEN_ENABLED 1
+#define LRU_GEN_MM_WALK 2
+
+struct generation_stats {
+	int gen;
+	long age_ms;
+	long nr_anon;
+	long nr_file;
+};
+
+struct node_stats {
+	int node;
+	int nr_gens; /* Number of populated gens entries. */
+	struct generation_stats gens[MAX_NR_GENS];
+};
+
+struct memcg_stats {
+	unsigned long memcg_id;
+	int nr_nodes; /* Number of populated nodes entries. */
+	struct node_stats nodes[MAX_NR_NODES];
+};
+
+void lru_gen_read_memcg_stats(struct memcg_stats *stats, const char *memcg);
+long lru_gen_sum_memcg_stats(const struct memcg_stats *stats);
+long lru_gen_sum_memcg_stats_for_gen(int gen, const struct memcg_stats *stats);
+void lru_gen_do_aging(struct memcg_stats *stats, const char *memcg);
+int lru_gen_find_generation(const struct memcg_stats *stats,
+			    unsigned long total_pages);
+bool lru_gen_usable(void);
+
+#endif /* SELFTEST_KVM_LRU_GEN_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/lru_gen_util.c b/tools/testing/selftests/kvm/lib/lru_gen_util.c
new file mode 100644
index 0000000000000..8d55029ee9ba0
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/lru_gen_util.c
@@ -0,0 +1,386 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, Google LLC.
+ */
+
+#include <time.h>
+
+#include "lru_gen_util.h"
+
+/*
+ * Tracks state while we parse memcg lru_gen stats. The file we're parsing is
+ * structured like this (some extra whitespace elided):
+ *
+ * memcg (id) (path)
+ * node (id)
+ * (gen_nr) (age_in_ms) (nr_anon_pages) (nr_file_pages)
+ */
+struct memcg_stats_parse_context {
+	bool consumed; /* Whether or not this line was consumed */
+	/* Next parse handler to invoke */
+	void (*next_handler)(struct memcg_stats *,
+			     struct memcg_stats_parse_context *, char *);
+	int current_node_idx; /* Current index in nodes array */
+	const char *name; /* The name of the memcg we're looking for */
+};
+
+static void memcg_stats_handle_searching(struct memcg_stats *stats,
+					 struct memcg_stats_parse_context *ctx,
+					 char *line);
+static void memcg_stats_handle_in_memcg(struct memcg_stats *stats,
+					struct memcg_stats_parse_context *ctx,
+					char *line);
+static void memcg_stats_handle_in_node(struct memcg_stats *stats,
+				       struct memcg_stats_parse_context *ctx,
+				       char *line);
+
+struct split_iterator {
+	char *str;
+	char *save;
+};
+
+static char *split_next(struct split_iterator *it)
+{
+	char *ret = strtok_r(it->str, " \t\n\r", &it->save);
+
+	it->str = NULL;
+	return ret;
+}
+
+static void memcg_stats_handle_searching(struct memcg_stats *stats,
+					 struct memcg_stats_parse_context *ctx,
+					 char *line)
+{
+	struct split_iterator it = { .str = line };
+	char *prefix = split_next(&it);
+	char *memcg_id = split_next(&it);
+	char *memcg_name = split_next(&it);
+	char *end;
+
+	ctx->consumed = true;
+
+	if (!prefix || strcmp("memcg", prefix))
+		return; /* Not a memcg line (maybe empty), skip */
+
+	TEST_ASSERT(memcg_id && memcg_name,
+		    "malformed memcg line; no memcg id or memcg_name");
+
+	if (strcmp(memcg_name + 1, ctx->name))
+		return; /* Wrong memcg, skip */
+
+	/* Found it! */
+
+	stats->memcg_id = strtoul(memcg_id, &end, 10);
+	TEST_ASSERT(*end == '\0', "malformed memcg id '%s'", memcg_id);
+	if (!stats->memcg_id)
+		return; /* Removed memcg? */
+
+	ctx->next_handler = memcg_stats_handle_in_memcg;
+}
+
+static void memcg_stats_handle_in_memcg(struct memcg_stats *stats,
+					struct memcg_stats_parse_context *ctx,
+					char *line)
+{
+	struct split_iterator it = { .str = line };
+	char *prefix = split_next(&it);
+	char *id = split_next(&it);
+	long found_node_id;
+	char *end;
+
+	ctx->consumed = true;
+	ctx->current_node_idx = -1;
+
+	if (!prefix)
+		return; /* Skip empty lines */
+
+	if (!strcmp("memcg", prefix)) {
+		/* Memcg done, found next one; stop. */
+		ctx->next_handler = NULL;
+		return;
+	} else if (strcmp("node", prefix))
+		TEST_ASSERT(false, "found malformed line after 'memcg ...',"
+				   "token: '%s'", prefix);
+
+	/* At this point we know we have a node line. Parse the ID. */
+
+	TEST_ASSERT(id, "malformed node line; no node id");
+
+	found_node_id = strtol(id, &end, 10);
+	TEST_ASSERT(*end == '\0', "malformed node id '%s'", id);
+
+	ctx->current_node_idx = stats->nr_nodes++;
+	TEST_ASSERT(ctx->current_node_idx < MAX_NR_NODES,
+		    "memcg has stats for too many nodes, max is %d",
+		    MAX_NR_NODES);
+	stats->nodes[ctx->current_node_idx].node = found_node_id;
+
+	ctx->next_handler = memcg_stats_handle_in_node;
+}
+
+static void memcg_stats_handle_in_node(struct memcg_stats *stats,
+				       struct memcg_stats_parse_context *ctx,
+				       char *line)
+{
+	char *my_line = strdup(line);
+	struct split_iterator it = { .str = my_line };
+	char *gen, *age, *nr_anon, *nr_file;
+	struct node_stats *node_stats;
+	struct generation_stats *gen_stats;
+	char *end;
+
+	TEST_ASSERT(it.str, "failed to copy input line");
+
+	gen = split_next(&it);
+
+	if (!gen)
+		goto out_consume; /* Skip empty lines */
+
+	if (!strcmp("memcg", gen) || !strcmp("node", gen)) {
+		/*
+		 * Reached next memcg or node section. Don't consume, let the
+		 * other handler deal with this.
+		 */
+		ctx->next_handler = memcg_stats_handle_in_memcg;
+		goto out;
+	}
+
+	node_stats = &stats->nodes[ctx->current_node_idx];
+	TEST_ASSERT(node_stats->nr_gens < MAX_NR_GENS,
+		    "found too many generation lines; max is %d",
+		    MAX_NR_GENS);
+	gen_stats = &node_stats->gens[node_stats->nr_gens++];
+
+	age = split_next(&it);
+	nr_anon = split_next(&it);
+	nr_file = split_next(&it);
+
+	TEST_ASSERT(age && nr_anon && nr_file,
+		    "malformed generation line; not enough tokens");
+
+	gen_stats->gen = (int)strtol(gen, &end, 10);
+	TEST_ASSERT(*end == '\0', "malformed generation number '%s'", gen);
+
+	gen_stats->age_ms = strtol(age, &end, 10);
+	TEST_ASSERT(*end == '\0', "malformed generation age '%s'", age);
+
+	gen_stats->nr_anon = strtol(nr_anon, &end, 10);
+	TEST_ASSERT(*end == '\0', "malformed anonymous page count '%s'",
+		    nr_anon);
+
+	gen_stats->nr_file = strtol(nr_file, &end, 10);
+	TEST_ASSERT(*end == '\0', "malformed file page count '%s'", nr_file);
+
+out_consume:
+	ctx->consumed = true;
+out:
+	free(my_line);
+}
+
+static void print_memcg_stats(const struct memcg_stats *stats, const char *name)
+{
+	int node, gen;
+
+	pr_debug("stats for memcg %s (id %lu):\n", name, stats->memcg_id);
+	for (node = 0; node < stats->nr_nodes; ++node) {
+		pr_debug("\tnode %d\n", stats->nodes[node].node);
+		for (gen = 0; gen < stats->nodes[node].nr_gens; ++gen) {
+			const struct generation_stats *gstats =
+				&stats->nodes[node].gens[gen];
+
+			pr_debug("\t\tgen %d\tage_ms %ld"
+				 "\tnr_anon %ld\tnr_file %ld\n",
+				 gstats->gen, gstats->age_ms, gstats->nr_anon,
+				 gstats->nr_file);
+		}
+	}
+}
+
+/* Re-read lru_gen debugfs information for @memcg into @stats. */
+void lru_gen_read_memcg_stats(struct memcg_stats *stats, const char *memcg)
+{
+	FILE *f;
+	ssize_t read = 0;
+	char *line = NULL;
+	size_t bufsz;
+	struct memcg_stats_parse_context ctx = {
+		.next_handler = memcg_stats_handle_searching,
+		.name = memcg,
+	};
+
+	memset(stats, 0, sizeof(struct memcg_stats));
+
+	f = fopen(LRU_GEN_DEBUGFS, "r");
+	TEST_ASSERT(f, "fopen(%s) failed", LRU_GEN_DEBUGFS);
+
+	while (ctx.next_handler && (read = getline(&line, &bufsz, f)) > 0) {
+		ctx.consumed = false;
+
+		do {
+			ctx.next_handler(stats, &ctx, line);
+			if (!ctx.next_handler)
+				break;
+		} while (!ctx.consumed);
+	}
+
+	if (read < 0 && !feof(f))
+		TEST_ASSERT(false, "getline(%s) failed", LRU_GEN_DEBUGFS);
+
+	TEST_ASSERT(stats->memcg_id > 0, "Couldn't find memcg: %s\n"
+		    "Did the memcg get created in the proper mount?",
+		    memcg);
+	if (line)
+		free(line);
+	TEST_ASSERT(!fclose(f), "fclose(%s) failed", LRU_GEN_DEBUGFS);
+
+	print_memcg_stats(stats, memcg);
+}
+
+/*
+ * Find all pages tracked by lru_gen for this memcg in generation @target_gen.
+ *
+ * If @target_gen is negative, look for all generations.
+ */
+long lru_gen_sum_memcg_stats_for_gen(int target_gen,
+				     const struct memcg_stats *stats)
+{
+	int node, gen;
+	long total_nr = 0;
+
+	for (node = 0; node < stats->nr_nodes; ++node) {
+		const struct node_stats *node_stats = &stats->nodes[node];
+
+		for (gen = 0; gen < node_stats->nr_gens; ++gen) {
+			const struct generation_stats *gen_stats =
+				&node_stats->gens[gen];
+
+			if (target_gen >= 0 && gen_stats->gen != target_gen)
+				continue;
+
+			total_nr += gen_stats->nr_anon + gen_stats->nr_file;
+		}
+	}
+
+	return total_nr;
+}
+
+/* Find all pages tracked by lru_gen for this memcg. */
+long lru_gen_sum_memcg_stats(const struct memcg_stats *stats)
+{
+	return lru_gen_sum_memcg_stats_for_gen(-1, stats);
+}
+
+/*
+ * If lru_gen aging should force page table scanning.
+ *
+ * If you want to set this to false, you will need to do eviction
+ * before doing extra aging passes.
+ */
+static const bool force_scan = true;
+
+static void run_aging_impl(unsigned long memcg_id, int node_id, int max_gen)
+{
+	FILE *f = fopen(LRU_GEN_DEBUGFS, "w");
+	char *command;
+	size_t sz;
+
+	TEST_ASSERT(f, "fopen(%s) failed", LRU_GEN_DEBUGFS);
+	sz = asprintf(&command, "+ %lu %d %d 1 %d\n",
+		      memcg_id, node_id, max_gen, force_scan);
+	TEST_ASSERT(sz > 0, "creating aging command failed");
+
+	pr_debug("Running aging command: %s", command);
+	if (fwrite(command, sizeof(char), sz, f) < sz) {
+		TEST_ASSERT(false, "writing aging command %s to %s failed",
+			    command, LRU_GEN_DEBUGFS);
+	}
+
+	TEST_ASSERT(!fclose(f), "fclose(%s) failed", LRU_GEN_DEBUGFS);
+}
+
+void lru_gen_do_aging(struct memcg_stats *stats, const char *memcg)
+{
+	int node, gen;
+
+	pr_debug("lru_gen: invoking aging...\n");
+
+	/* Must read memcg stats to construct the proper aging command. */
+	lru_gen_read_memcg_stats(stats, memcg);
+
+	for (node = 0; node < stats->nr_nodes; ++node) {
+		int max_gen = 0;
+
+		for (gen = 0; gen < stats->nodes[node].nr_gens; ++gen) {
+			int this_gen = stats->nodes[node].gens[gen].gen;
+
+			max_gen = max_gen > this_gen ? max_gen : this_gen;
+		}
+
+		run_aging_impl(stats->memcg_id, stats->nodes[node].node,
+			       max_gen);
+	}
+
+	/* Re-read so callers get updated information */
+	lru_gen_read_memcg_stats(stats, memcg);
+}
+
+/*
+ * Find which generation contains at least @pages pages, assuming that
+ * such a generation exists.
+ */
+int lru_gen_find_generation(const struct memcg_stats *stats,
+			    unsigned long pages)
+{
+	int node, gen, gen_idx, min_gen = INT_MAX, max_gen = -1;
+
+	for (node = 0; node < stats->nr_nodes; ++node)
+		for (gen_idx = 0; gen_idx < stats->nodes[node].nr_gens;
+		     ++gen_idx) {
+			gen = stats->nodes[node].gens[gen_idx].gen;
+			max_gen = gen > max_gen ? gen : max_gen;
+			min_gen = gen < min_gen ? gen : min_gen;
+		}
+
+	for (gen = min_gen; gen <= max_gen; ++gen)
+		/* See if this generation has enough pages. */
+		if (lru_gen_sum_memcg_stats_for_gen(gen, stats) > pages)
+			return gen;
+
+	return -1;
+}
+
+bool lru_gen_usable(void)
+{
+	long required_features = LRU_GEN_ENABLED | LRU_GEN_MM_WALK;
+	int lru_gen_fd, lru_gen_debug_fd;
+	char mglru_feature_str[8] = {};
+	long mglru_features;
+
+	lru_gen_fd = open(LRU_GEN_ENABLED_PATH, O_RDONLY);
+	if (lru_gen_fd < 0) {
+		puts("lru_gen: Could not open " LRU_GEN_ENABLED_PATH);
+		return false;
+	}
+	if (read(lru_gen_fd, &mglru_feature_str, 7) < 7) {
+		puts("lru_gen: Could not read from " LRU_GEN_ENABLED_PATH);
+		close(lru_gen_fd);
+		return false;
+	}
+	close(lru_gen_fd);
+
+	mglru_features = strtol(mglru_feature_str, NULL, 16);
+	if ((mglru_features & required_features) != required_features) {
+		printf("lru_gen: missing features, got: %s, expected: 0x%lx\n",
+		       mglru_feature_str, required_features);
+		printf("lru_gen: Try 'echo 0x%lx > /sys/kernel/mm/lru_gen/enabled'\n",
+		       required_features);
+		return false;
+	}
+
+	lru_gen_debug_fd = open(LRU_GEN_DEBUGFS, O_RDWR);
+	__TEST_REQUIRE(lru_gen_debug_fd >= 0,
+		       "lru_gen: Could not open " LRU_GEN_DEBUGFS ", "
+		       "but lru_gen is enabled, so cannot use page_idle.");
+	close(lru_gen_debug_fd);
+	return true;
+}
-- 
2.49.0.1015.ga840276032-goog


