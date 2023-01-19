Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8406C674347
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjASUGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjASUGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:06:06 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3E89B103
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:06:04 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id a2-20020a17090acb8200b00225c0839b80so1520275pju.5
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PyMfEnDnfrKdzg8f7h+BNuociXX2rPzzxU9yOiZlUe8=;
        b=kEVNJ+GeN1h23ubqyvE0mfJeF9VNrlK9q6YL1lr31A95rJzyqpJrojspBD/WSzHO9B
         9QuUZ9ijr9YlXKIT99RWsd6PrVtU9MYzyNqbM/Oa/74Aqnh2d+XfZsBI9b57lJ3+Q9O3
         +c7MCorkeTxxEOHkB+fidhmIqu/3/CqHDIkJ62naISxulYoIfcrD4WJDSxLkRCYEfBO4
         8ACVJAhYXq6XyzqISFK27JoBQiQt1B6Q09soqxwbZJiNWQg3Lq7nuAbbcuS4tIqD0qfO
         U/gMIMvNCETNviaJFfpxU8ZihHMvnzYHn6xuECmptbubgKBqKZ1F19ZwDzjO1w6yrhIr
         hY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PyMfEnDnfrKdzg8f7h+BNuociXX2rPzzxU9yOiZlUe8=;
        b=Q1qgHGtRD26z2ia+tGTPG+wv/qJRFxY7KJvRMm7RyLG+xleGNOM/Rbg+xLy0d3QDmw
         SVxpiSpnt1kZSoQOL6XRCXzZRqeHvvnzr0rKeIDCiv9gfkXmBmO5I8wICaQwBkw4Aq0W
         3aaGqpHfkCLDGyamiYuP23DsjNb1gv8gTsmYVY6ABf59YqfN8QzTddMwCc4+AXIxTKoa
         z5TS88A3c0hdiaYYJQQeMR9THc6n8GUW5GzurrdD7OA1FwDrnK8Jag2a0E7Qz4R2YTGQ
         lRPJaTqgepRHCr6y/ZaRuRpq+MoMpB3Rj09GGddxzg1v/O0sBdD+qMM4vRgUkQ5t+cp8
         3aPw==
X-Gm-Message-State: AFqh2kq1yvDrmtIXmt7fL6yeZBsB2nm51QBV6TuH86AViUugTXYeJox/
        ywVxBbpxEEJaBoM3QOvGUawgHkittwzW
X-Google-Smtp-Source: AMrXdXuHuO+ALB4puSMNIZI3NBCa59oXxbNaarT1MGaM4fqwJuDQHjggdf8OPTtKjgVq/n7cb3/d0rqIdLzw
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:9114:b0:229:f43c:4049 with SMTP id
 k20-20020a17090a911400b00229f43c4049mr3789pjo.0.1674158758851; Thu, 19 Jan
 2023 12:05:58 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:05:53 +0000
In-Reply-To: <20230119200553.3922206-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230119200553.3922206-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230119200553.3922206-2-bgardon@google.com>
Subject: [RFC 2/2] selftests: KVM: Add page splitting test
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ben Gardon <bgardon@google.com>
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

Add a test for page splitting during dirty logging and for hugepage
recovery after dirty logging.

Page splitting represents non-trivial behavior, which is complicated
by MANUAL_PROTECT mode, which causes pages to be split on the first
clear, instead of when dirty logging is enabled.

Add a test which makes asserions about page counts to help define the
expected behavior of page splitting and to provid needed coverage of the
behavior. This also helps ensure that a failure in eager page splitting
is not covered up by splitting in the vCPU path.

Tested by running the test on an Intel Haswell machine w/wo
MANUAL_PROTECT.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |   1 +
 .../kvm/x86_64/page_splitting_test.c          | 311 ++++++++++++++++++
 3 files changed, 313 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/page_splitting_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 1750f91dd9362..057ebd709e77a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -76,6 +76,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
 TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
+TEST_GEN_PROGS_x86_64 += x86_64/page_splitting_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index fbc2a79369b8b..98974a601b0af 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -402,6 +402,7 @@ static inline uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
 	uint64_t data;
 
 	__vm_get_stat(vm, stat_name, &data, 1);
+
 	return data;
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/page_splitting_test.c
new file mode 100644
index 0000000000000..4b5dcd4908b5a
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/page_splitting_test.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM dirty logging page splitting test
+ *
+ * Based on dirty_log_perf.c
+ *
+ * Copyright (C) 2018, Red Hat, Inc.
+ * Copyright (C) 2020, Google, Inc.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <time.h>
+#include <pthread.h>
+#include <linux/bitmap.h>
+
+#include "kvm_util.h"
+#include "test_util.h"
+#include "memstress.h"
+#include "guest_modes.h"
+
+/* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
+#define TEST_HOST_LOOP_N		2UL
+
+static int NR_VCPUS = 2;
+static int NR_SLOTS = 2;
+static int NR_ITERATIONS = 2;
+static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
+
+/* Host variables */
+static u64 dirty_log_manual_caps;
+static bool host_quit;
+static int iteration;
+static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
+
+struct kvm_page_stats {
+	uint64_t pages_4k;
+	uint64_t pages_2m;
+	uint64_t pages_1g;
+	uint64_t hugepages;
+};
+
+static void get_page_stats(struct kvm_vm *vm, struct kvm_page_stats *stats)
+{
+	stats->pages_4k = vm_get_stat(vm, "pages_4k");
+	stats->pages_2m = vm_get_stat(vm, "pages_2m");
+	stats->pages_1g = vm_get_stat(vm, "pages_1g");
+	stats->hugepages = stats->pages_2m + stats->pages_1g;
+
+	pr_debug("Page stats - 4K: %ld 2M: %ld 1G: %ld huge: %ld\n",
+		 stats->pages_4k, stats->pages_2m, stats->pages_1g,
+		 stats->hugepages);
+}
+
+static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
+{
+	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
+	int vcpu_idx = vcpu_args->vcpu_idx;
+	uint64_t pages_count = 0;
+	struct kvm_run *run;
+	int ret;
+
+	run = vcpu->run;
+
+	while (!READ_ONCE(host_quit)) {
+		int current_iteration = READ_ONCE(iteration);
+
+		ret = _vcpu_run(vcpu);
+
+		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
+		TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
+			    "Invalid guest sync status: exit_reason=%s\n",
+			    exit_reason_str(run->exit_reason));
+
+		vcpu_last_completed_iteration[vcpu_idx] = current_iteration;
+
+		if (current_iteration)
+			pages_count += vcpu_args->pages;
+
+		/* Wait for the start of the next iteration to be signaled. */
+		while (current_iteration == READ_ONCE(iteration) &&
+		       READ_ONCE(iteration) >= 0 &&
+		       !READ_ONCE(host_quit))
+			;
+	}
+}
+
+struct test_params {
+	enum vm_mem_backing_src_type backing_src;
+};
+
+static void run_test(struct test_params *p)
+{
+	struct kvm_vm *vm;
+	unsigned long **bitmaps;
+	uint64_t guest_num_pages;
+	uint64_t host_num_pages;
+	uint64_t pages_per_slot;
+	int i;
+	uint64_t total_4k_pages;
+	struct kvm_page_stats stats_populated;
+	struct kvm_page_stats stats_dirty_logging_enabled;
+	struct kvm_page_stats stats_dirty_pass[NR_ITERATIONS];
+	struct kvm_page_stats stats_clear_pass[NR_ITERATIONS];
+	struct kvm_page_stats stats_dirty_logging_disabled;
+	struct kvm_page_stats stats_repopulated;
+
+	vm = memstress_create_vm(VM_MODE_DEFAULT, NR_VCPUS, guest_percpu_mem_size,
+				 NR_SLOTS, p->backing_src, false);
+
+	guest_num_pages = (NR_VCPUS * guest_percpu_mem_size) >> vm->page_shift;
+	guest_num_pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, guest_num_pages);
+	host_num_pages = vm_num_host_pages(VM_MODE_DEFAULT, guest_num_pages);
+	pages_per_slot = host_num_pages / NR_SLOTS;
+
+	bitmaps = memstress_alloc_bitmaps(NR_SLOTS, pages_per_slot);
+
+	if (dirty_log_manual_caps)
+		vm_enable_cap(vm, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2,
+			      dirty_log_manual_caps);
+
+	/* Start the iterations */
+	iteration = 0;
+	host_quit = false;
+
+	for (i = 0; i < NR_VCPUS; i++)
+		vcpu_last_completed_iteration[i] = -1;
+
+	memstress_start_vcpu_threads(NR_VCPUS, vcpu_worker);
+
+	/* Allow the vCPUs to populate memory */
+	for (i = 0; i < NR_VCPUS; i++) {
+		while (READ_ONCE(vcpu_last_completed_iteration[i]) !=
+		       iteration)
+			;
+	}
+
+	pr_debug("\nGetting stats after populating memory:\n");
+	get_page_stats(vm, &stats_populated);
+
+	/* Enable dirty logging */
+	memstress_enable_dirty_logging(vm, NR_SLOTS);
+
+	pr_debug("\nGetting stats after enabling dirty logging:\n");
+	get_page_stats(vm, &stats_dirty_logging_enabled);
+
+	while (iteration < NR_ITERATIONS) {
+		/*
+		 * Incrementing the iteration number will start the vCPUs
+		 * dirtying memory again.
+		 */
+		iteration++;
+
+		for (i = 0; i < NR_VCPUS; i++) {
+			while (READ_ONCE(vcpu_last_completed_iteration[i])
+			       != iteration)
+				;
+		}
+
+		pr_debug("\nGetting stats after dirtying memory on pass %d:\n", iteration);
+		get_page_stats(vm, &stats_dirty_pass[iteration - 1]);
+
+		memstress_get_dirty_log(vm, bitmaps, NR_SLOTS);
+
+		if (dirty_log_manual_caps) {
+			memstress_clear_dirty_log(vm, bitmaps, NR_SLOTS, pages_per_slot);
+
+			pr_debug("\nGetting stats after clearing dirty log pass %d:\n", iteration);
+			get_page_stats(vm, &stats_clear_pass[iteration - 1]);
+		}
+	}
+
+	/* Disable dirty logging */
+	memstress_disable_dirty_logging(vm, NR_SLOTS);
+
+	pr_debug("\nGetting stats after disabling dirty logging:\n");
+	get_page_stats(vm, &stats_dirty_logging_disabled);
+
+	/* Run vCPUs again to fault pages back in. */
+	iteration++;
+	for (i = 0; i < NR_VCPUS; i++) {
+		while (READ_ONCE(vcpu_last_completed_iteration[i]) != iteration)
+			;
+	}
+
+	pr_debug("\nGetting stats after repopulating memory:\n");
+	get_page_stats(vm, &stats_repopulated);
+
+	/*
+	 * Tell the vCPU threads to quit.  No need to manually check that vCPUs
+	 * have stopped running after disabling dirty logging, the join will
+	 * wait for them to exit.
+	 */
+	host_quit = true;
+	memstress_join_vcpu_threads(NR_VCPUS);
+
+	memstress_free_bitmaps(bitmaps, NR_SLOTS);
+	memstress_destroy_vm(vm);
+
+	/* Make assertions about the page counts. */
+	total_4k_pages = stats_populated.pages_4k;
+	total_4k_pages += stats_populated.pages_2m * 512;
+	total_4k_pages += stats_populated.pages_1g * 512 * 512;
+
+	/*
+	 * Check that all huge pages were split. Since large pages can only
+	 * exist in the data slot, and the vCPUs should have dirtied all pages
+	 * in the data slot, there should be no huge pages left after splitting.
+	 * Splitting happens at dirty log enable time without
+	 * KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 and after the first clear pass
+	 * with that capability.
+	 */
+	if (dirty_log_manual_caps) {
+		TEST_ASSERT(stats_clear_pass[0].hugepages == 0,
+			    "Unexpected huge page count after splitting. Expected 0, got %ld",
+			    stats_clear_pass[0].hugepages);
+		TEST_ASSERT(stats_clear_pass[0].pages_4k == total_4k_pages,
+			    "All memory should be mapped at 4k. Expected %ld 4k pages, got %ld",
+			    total_4k_pages, stats_clear_pass[0].pages_4k);
+	} else {
+		TEST_ASSERT(stats_dirty_logging_enabled.hugepages == 0,
+			    "Unexpected huge page count after splitting. Expected 0, got %ld",
+			    stats_dirty_logging_enabled.hugepages);
+		TEST_ASSERT(stats_dirty_logging_enabled.pages_4k == total_4k_pages,
+			    "All memory should be mapped at 4k. Expected %ld 4k pages, got %ld",
+			    total_4k_pages, stats_dirty_logging_enabled.pages_4k);
+	}
+
+	/*
+	 * Once dirty logging is disabled and the vCPUs have touched all their
+	 * memory again, the page counts should be the same as they were
+	 * right after initial population of memory.
+	 */
+	TEST_ASSERT(stats_populated.pages_4k == stats_repopulated.pages_4k,
+		    "4k page count did not return to its initial value after "
+		    "dirty logging. Expected %ld, got %ld",
+		    stats_populated.pages_4k, stats_repopulated.pages_4k);
+	TEST_ASSERT(stats_populated.pages_2m == stats_repopulated.pages_2m,
+		    "2m page count did not return to its initial value after "
+		    "dirty logging. Expected %ld, got %ld",
+		    stats_populated.pages_2m, stats_repopulated.pages_2m);
+	TEST_ASSERT(stats_populated.pages_1g == stats_repopulated.pages_1g,
+		    "1g page count did not return to its initial value after "
+		    "dirty logging. Expected %ld, got %ld",
+		    stats_populated.pages_1g, stats_repopulated.pages_1g);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-g] [-m mode] [-b vcpu bytes] [-s mem type]\n",
+	       name);
+	puts("");
+	printf(" -g: Do not enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2. This\n"
+	       "     makes KVM_GET_DIRTY_LOG clear the dirty log (i.e.\n"
+	       "     KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE is not enabled)\n"
+	       "     and writes will be tracked as soon as dirty logging is\n"
+	       "     enabled on the memslot (i.e. KVM_DIRTY_LOG_INITIALLY_SET\n"
+	       "     is not enabled).\n");
+	printf(" -b: specify the size of the memory region which should be\n"
+	       "     dirtied by each vCPU. e.g. 10M or 3G.\n"
+	       "     (default: 1G)\n");
+	backing_src_help("-s");
+	puts("");
+	exit(0);
+}
+
+int main(int argc, char *argv[])
+{
+	struct test_params p = {
+		.backing_src = VM_MEM_SRC_ANONYMOUS_HUGETLB,
+	};
+	int opt;
+
+	dirty_log_manual_caps =
+		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
+	dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
+				  KVM_DIRTY_LOG_INITIALLY_SET);
+
+	guest_modes_append_default();
+
+	while ((opt = getopt(argc, argv, "b:ghs:")) != -1) {
+		switch (opt) {
+		case 'b':
+			guest_percpu_mem_size = parse_size(optarg);
+			break;
+		case 'g':
+			dirty_log_manual_caps = 0;
+			break;
+		case 'h':
+			help(argv[0]);
+			break;
+		case 's':
+			p.backing_src = parse_backing_src_type(optarg);
+			break;
+		default:
+			help(argv[0]);
+			break;
+		}
+	}
+
+	if (!is_backing_src_hugetlb(p.backing_src)) {
+		pr_info("This test will only work reliably with HugeTLB memory. "
+			"It can work with THP, but that is best effort.");
+		return KSFT_SKIP;
+	}
+
+	run_test(&p);
+
+	return 0;
+}
-- 
2.39.1.405.gd4c25cc71f-goog

