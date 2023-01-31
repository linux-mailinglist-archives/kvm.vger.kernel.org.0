Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E22683505
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 19:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjAaSSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 13:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjAaSS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 13:18:29 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A302BF08
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 10:18:27 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id ij3-20020a170902ab4300b001968158fa80so3825693plb.2
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 10:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rJKWJ0gIh3iMmgA+SPQgOnOY9IIcpwxGu19jHnxwZCc=;
        b=FgYMcXreikzvCGMPZKzZMED5RK6aSNLx+ye9DVbLL5b+ixc/nKJnaggATCXAYHBlQn
         r3/nyKZx+Dab/oOEUBm5SnJ06fUyhBJe6IewfvXci0VMJ4xz41BQjGaEqpWLt2Dl9B2F
         zzzR42JnsVU74OWrUeiiKtISDriuEURJun7TOESBcawaYQwne+WwhoWsoH+dzFkRquOq
         BJkv387H449ZKS18G6Nr640dlOjClPxFVG4teePGW55RqfOXxNs8mHn64+1IXli9Q2L5
         EIhOnXgIwyuHGoPzYJgkO9Rrflo1l7dE0Lg/C9LvPrVhm4ON9onffmsQUBs/9aFjSOMg
         pfww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rJKWJ0gIh3iMmgA+SPQgOnOY9IIcpwxGu19jHnxwZCc=;
        b=db7Pd4YOHOM2lTO+BCSgUVH9cktrFESzeH8DldVFBYc1JISwXJTeBjWFWd2/YAdQ5t
         JrLmTlukY41oFWXOVuV9KIOcLXqk1Q6vCVqFKLZvK3mIaF0vEy+pvALp6hoelYgeo2Dy
         2vpeDj31KdnCvO6Pvs1eAjw57iWhZED1Qw/5uzEaHHWgY4OcGTc4OOmhumhvLVW6kmQr
         GY9Guv1sMWpvUE4fHqddSiyhiNY1SyViITx4wve+Hnl2W/Y58W9AseBHa6PpB0dk0nA4
         XAdx0PATxIcpzCr7rl2+fKcX7nwXf48hXapdeDRbc6VzyWsMLdDpiF2q9ZCOmpzbWtTE
         XqTQ==
X-Gm-Message-State: AO0yUKXjHIEi7XUMii2ZUFMPw67TQqhm8gpvzIXabjkIXRZlkkjQAt3I
        epyJ/7G3quTWVFQri88GFZeQz2LbUxoz
X-Google-Smtp-Source: AK7set87ywqM1Gp8aTwSKFupvIuQKdvbEv9a985mjbxnrPwnVoOP0Qx4oey7VhhzNZP222HvVrbOalChGv05
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a62:1517:0:b0:592:d6b:4a5b with SMTP id
 23-20020a621517000000b005920d6b4a5bmr3347538pfv.61.1675189106810; Tue, 31 Jan
 2023 10:18:26 -0800 (PST)
Date:   Tue, 31 Jan 2023 18:18:20 +0000
In-Reply-To: <20230131181820.179033-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230131181820.179033-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230131181820.179033-3-bgardon@google.com>
Subject: [PATCH V5 2/2] selftests: KVM: Add dirty logging page splitting test
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
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

Add a test which makes assertions about page counts to help define the
expected behavior of page splitting and to provide needed coverage of the
behavior. This also helps ensure that a failure in eager page splitting
is not covered up by splitting in the vCPU path.

Tested by running the test on an Intel Haswell machine w/wo
MANUAL_PROTECT.

Reviewed-by: Vipin Sharma <vipinsh@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   5 +
 .../x86_64/dirty_log_page_splitting_test.c    | 260 ++++++++++++++++++
 4 files changed, 267 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 1750f91dd9362..9a8022918c3ea 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -61,6 +61,7 @@ TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
 # Compiled test targets
 TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
+TEST_GEN_PROGS_x86_64 += x86_64/dirty_log_page_splitting_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
 TEST_GEN_PROGS_x86_64 += x86_64/exit_on_emulation_failure_test
 TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index fbc2a79369b8b..a089c356f354e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -213,6 +213,7 @@ extern const struct vm_guest_mode_params vm_guest_mode_params[];
 int open_path_or_exit(const char *path, int flags);
 int open_kvm_dev_path_or_exit(void);
 
+bool get_kvm_param_bool(const char *param);
 bool get_kvm_intel_param_bool(const char *param);
 bool get_kvm_amd_param_bool(const char *param);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 56d5ea949cbbe..fa6d69f731990 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -80,6 +80,11 @@ static bool get_module_param_bool(const char *module_name, const char *param)
 	TEST_FAIL("Unrecognized value '%c' for boolean module param", value);
 }
 
+bool get_kvm_param_bool(const char *param)
+{
+	return get_module_param_bool("kvm", param);
+}
+
 bool get_kvm_intel_param_bool(const char *param)
 {
 	return get_module_param_bool("kvm_intel", param);
diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
new file mode 100644
index 0000000000000..ed08c7ac3b2e3
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
@@ -0,0 +1,260 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM dirty logging page splitting test
+ *
+ * Based on dirty_log_perf.c
+ *
+ * Copyright (C) 2018, Red Hat, Inc.
+ * Copyright (C) 2023, Google, Inc.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <pthread.h>
+#include <linux/bitmap.h>
+
+#include "kvm_util.h"
+#include "test_util.h"
+#include "memstress.h"
+#include "guest_modes.h"
+
+#define VCPUS		2
+#define SLOTS		2
+#define ITERATIONS	2
+
+static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
+
+static enum vm_mem_backing_src_type backing_src = VM_MEM_SRC_ANONYMOUS_HUGETLB;
+
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
+static void get_page_stats(struct kvm_vm *vm, struct kvm_page_stats *stats, const char *stage)
+{
+	stats->pages_4k = vm_get_stat(vm, "pages_4k");
+	stats->pages_2m = vm_get_stat(vm, "pages_2m");
+	stats->pages_1g = vm_get_stat(vm, "pages_1g");
+	stats->hugepages = stats->pages_2m + stats->pages_1g;
+
+	pr_debug("\nPage stats after %s: 4K: %ld 2M: %ld 1G: %ld huge: %ld\n",
+		 stage, stats->pages_4k, stats->pages_2m, stats->pages_1g,
+		 stats->hugepages);
+}
+
+static void run_vcpu_iteration(struct kvm_vm *vm)
+{
+	int i;
+
+	iteration++;
+	for (i = 0; i < VCPUS; i++) {
+		while (READ_ONCE(vcpu_last_completed_iteration[i]) !=
+		       iteration)
+			;
+	}
+}
+
+static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
+{
+	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
+	int vcpu_idx = vcpu_args->vcpu_idx;
+
+	while (!READ_ONCE(host_quit)) {
+		int current_iteration = READ_ONCE(iteration);
+
+		vcpu_run(vcpu);
+
+		ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
+
+		vcpu_last_completed_iteration[vcpu_idx] = current_iteration;
+
+		/* Wait for the start of the next iteration to be signaled. */
+		while (current_iteration == READ_ONCE(iteration) &&
+		       READ_ONCE(iteration) >= 0 &&
+		       !READ_ONCE(host_quit))
+			;
+	}
+}
+
+static void run_test(enum vm_guest_mode mode, void *unused)
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
+	struct kvm_page_stats stats_dirty_pass[ITERATIONS];
+	struct kvm_page_stats stats_clear_pass[ITERATIONS];
+	struct kvm_page_stats stats_dirty_logging_disabled;
+	struct kvm_page_stats stats_repopulated;
+
+	vm = memstress_create_vm(mode, VCPUS, guest_percpu_mem_size,
+				 SLOTS, backing_src, false);
+
+	guest_num_pages = (VCPUS * guest_percpu_mem_size) >> vm->page_shift;
+	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
+	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
+	pages_per_slot = host_num_pages / SLOTS;
+
+	bitmaps = memstress_alloc_bitmaps(SLOTS, pages_per_slot);
+
+	if (dirty_log_manual_caps)
+		vm_enable_cap(vm, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2,
+			      dirty_log_manual_caps);
+
+	/* Start the iterations */
+	iteration = -1;
+	host_quit = false;
+
+	for (i = 0; i < VCPUS; i++)
+		vcpu_last_completed_iteration[i] = -1;
+
+	memstress_start_vcpu_threads(VCPUS, vcpu_worker);
+
+	run_vcpu_iteration(vm);
+	get_page_stats(vm, &stats_populated, "populating memory");
+
+	/* Enable dirty logging */
+	memstress_enable_dirty_logging(vm, SLOTS);
+
+	get_page_stats(vm, &stats_dirty_logging_enabled, "enabling dirty logging");
+
+	while (iteration < ITERATIONS) {
+		run_vcpu_iteration(vm);
+		get_page_stats(vm, &stats_dirty_pass[iteration - 1],
+			       "dirtying memory");
+
+		memstress_get_dirty_log(vm, bitmaps, SLOTS);
+
+		if (dirty_log_manual_caps) {
+			memstress_clear_dirty_log(vm, bitmaps, SLOTS, pages_per_slot);
+
+			get_page_stats(vm, &stats_clear_pass[iteration - 1], "clearing dirty log");
+		}
+	}
+
+	/* Disable dirty logging */
+	memstress_disable_dirty_logging(vm, SLOTS);
+
+	get_page_stats(vm, &stats_dirty_logging_disabled, "disabling dirty logging");
+
+	/* Run vCPUs again to fault pages back in. */
+	run_vcpu_iteration(vm);
+	get_page_stats(vm, &stats_repopulated, "repopulating memory");
+
+	/*
+	 * Tell the vCPU threads to quit.  No need to manually check that vCPUs
+	 * have stopped running after disabling dirty logging, the join will
+	 * wait for them to exit.
+	 */
+	host_quit = true;
+	memstress_join_vcpu_threads(VCPUS);
+
+	memstress_free_bitmaps(bitmaps, SLOTS);
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
+		ASSERT_EQ(stats_clear_pass[0].hugepages, 0);
+		ASSERT_EQ(stats_clear_pass[0].pages_4k, total_4k_pages);
+		ASSERT_EQ(stats_dirty_logging_enabled.hugepages, stats_populated.hugepages);
+	} else {
+		ASSERT_EQ(stats_dirty_logging_enabled.hugepages, 0);
+		ASSERT_EQ(stats_dirty_logging_enabled.pages_4k, total_4k_pages);
+	}
+
+	/*
+	 * Once dirty logging is disabled and the vCPUs have touched all their
+	 * memory again, the page counts should be the same as they were
+	 * right after initial population of memory.
+	 */
+	ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k);
+	ASSERT_EQ(stats_populated.pages_2m, stats_repopulated.pages_2m);
+	ASSERT_EQ(stats_populated.pages_1g, stats_repopulated.pages_1g);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-b vcpu bytes] [-s mem type]\n",
+	       name);
+	puts("");
+	printf(" -b: specify the size of the memory region which should be\n"
+	       "     dirtied by each vCPU. e.g. 10M or 3G.\n"
+	       "     (default: 1G)\n");
+	backing_src_help("-s");
+	puts("");
+}
+
+int main(int argc, char *argv[])
+{
+	int opt;
+
+	TEST_REQUIRE(get_kvm_param_bool("eager_page_split"));
+	TEST_REQUIRE(get_kvm_param_bool("tdp_mmu"));
+
+	while ((opt = getopt(argc, argv, "b:hs:")) != -1) {
+		switch (opt) {
+		case 'b':
+			guest_percpu_mem_size = parse_size(optarg);
+			break;
+		case 'h':
+			help(argv[0]);
+			exit(0);
+		case 's':
+			backing_src = parse_backing_src_type(optarg);
+			break;
+		default:
+			help(argv[0]);
+			exit(1);
+		}
+	}
+
+	if (!is_backing_src_hugetlb(backing_src)) {
+		pr_info("This test will only work reliably with HugeTLB memory. "
+			"It can work with THP, but that is best effort.");
+		return KSFT_SKIP;
+	}
+
+	guest_modes_append_default();
+
+	dirty_log_manual_caps = 0;
+	for_each_guest_mode(run_test, NULL);
+
+	dirty_log_manual_caps =
+		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
+
+	if (dirty_log_manual_caps) {
+		dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
+					  KVM_DIRTY_LOG_INITIALLY_SET);
+		for_each_guest_mode(run_test, NULL);
+	} else {
+		pr_info("Skipping testing with MANUAL_PROTECT as it is not supported");
+	}
+
+	return 0;
+}
-- 
2.39.1.456.gfc5497dd1b-goog

