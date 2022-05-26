Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C7F5352E9
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347661AbiEZRyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348387AbiEZRyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:54:23 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096B9A88BB
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:22 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id z186-20020a6233c3000000b00510a6bc2864so1309565pfz.10
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=e5pL0FxDuisARPZtbD7txNNR7V88IYUqfzY8P8cZNnU=;
        b=cIsfysGMiDvkrsVfnH8RT9o2QeibtiTYXoojfc0c1/ujMhHm6n8U1YACWuECWl7GlY
         VZAfnxpaRyUed4VFNS1PA43jOYvshFu5UoAL3ZfiFEa2DhRoXSTPO8wP/HpC171kFYCA
         yUrjA6lge0f1EIZcLq6qiwlXyqxFLsiAQ+p5gw0aO5yf8YoplszCZua7+wMsikzlYNaG
         6rg7iEEn/4Cf5bWU6x6f4qio0j16X30M+bQo49u26bS/KTkPNc9QubfgxHBxvWSzfWDN
         0k5ays4QcPftX0DvWuKYHCBdZ1Tua6HNtd45J0K6jhgGz8w37pr9MsU2bSk793UejYnh
         uQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=e5pL0FxDuisARPZtbD7txNNR7V88IYUqfzY8P8cZNnU=;
        b=bd9p20wv9EbSyUS38cZeEGrehRGqyLqllWZ9w3gq3f1U7GiBWNf47yfKLaV1IPtlPn
         jTsN+5C5RpRGGTozuj7Ql78HpRHpiXv5S3+lFv3+8XsTsvEiJunW+rppn9E6Yo7yzsAg
         WKi+IpwDUtrlV5yJpHVYSe0ud7VHUOd7FC46tuhxhaqohOAT66x3RPTJuAUvbPkQ2ji6
         zB742ywc/gd4NC69O5v/ORMn+MJuJHRmIL81Rdw3y6b3kwCIMr1ej/Gez53eCKf/tAv2
         o0XA3TA9YSZLocXJAEki0ohN1azlVO5EmFLoS0Ts6A21YymDqECUnmQmTyR+IsGGCZS9
         oqVQ==
X-Gm-Message-State: AOAM533y/0Dr5TmOOGulS8Z7v2zeaFT1LbhLpXLEOyhVF00zsHGnTvUp
        txjpSDk1KcpJ2thbor3LeBZMY+VIpmz/bhET0k3CzAbuED51pj3wVFCKduZO1kFAEODjrsxQViP
        zzKkAbKZjCinO1QdUS1xXdBO7O9zV0btt5XPVIAgRzTpqRiGC01PCUP3dMCit
X-Google-Smtp-Source: ABdhPJyHn9uFry3FM9MyhXExQxsMxxxss5btuEbXT2ZUDJccIiM9T1sma7PDox22swTBV9CY4ilLG6CSLASc
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:1815:b0:518:9681:44ee with SMTP
 id y21-20020a056a00181500b00518968144eemr23406632pfa.15.1653587661385; Thu,
 26 May 2022 10:54:21 -0700 (PDT)
Date:   Thu, 26 May 2022 17:54:03 +0000
In-Reply-To: <20220526175408.399718-1-bgardon@google.com>
Message-Id: <20220526175408.399718-7-bgardon@google.com>
Mime-Version: 1.0
References: <20220526175408.399718-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v8 06/11] KVM: selftests: Add NX huge pages test
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's currently no test coverage of NX hugepages in KVM selftests, so
add a basic test to ensure that the feature works as intended.

The test creates a VM with a data slot backed with huge pages. The
memory in the data slot is filled with op-codes for the return
instruction. The guest then executes a series of accesses on the memory,
some reads, some instruction fetches. After each operation, the guest
exits and the test performs some checks on the backing page counts to
ensure that NX page splitting an reclaim work as expected.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |  10 +
 .../selftests/kvm/include/kvm_util_base.h     |  11 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  46 ++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 227 ++++++++++++++++++
 .../kvm/x86_64/nx_huge_pages_test.sh          |  40 +++
 6 files changed, 335 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
 create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 90a6dea2e84c..5cf0df616365 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -28,6 +28,7 @@
 /x86_64/max_vcpuid_cap_test
 /x86_64/mmio_warning_test
 /x86_64/mmu_role_test
+/x86_64/nx_huge_pages_test
 /x86_64/platform_info_test
 /x86_64/pmu_event_filter_test
 /x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a014368a2cd2..0a41c326de84 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -43,6 +43,10 @@ LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handler
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 LIBKVM_riscv = lib/riscv/processor.c lib/riscv/ucall.c
 
+# Non-compiled test targets
+TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
+
+# Compiled test targets
 TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
@@ -106,6 +110,9 @@ TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 
+# Compiled outputs used by test targets
+TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
+
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
@@ -145,7 +152,9 @@ TEST_GEN_PROGS_riscv += kvm_page_table_test
 TEST_GEN_PROGS_riscv += set_memory_region_test
 TEST_GEN_PROGS_riscv += kvm_binary_stats_test
 
+TEST_PROGS += $(TEST_PROGS_$(UNAME_M))
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
+TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
@@ -196,6 +205,7 @@ $(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 all: $(STATIC_LIBS)
 $(TEST_GEN_PROGS): $(STATIC_LIBS)
+$(TEST_GEN_PROGS_EXTENDED): $(STATIC_LIBS)
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
 cscope:
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 967f6d6cf255..035168cec451 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -430,6 +430,17 @@ void read_stat_data(int stats_fd, struct kvm_stats_header *header,
 		    struct kvm_stats_desc *desc, uint64_t *data,
 		    size_t max_elements);
 
+void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
+		   size_t max_elements);
+
+static inline uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
+{
+	uint64_t data;
+
+	__vm_get_stat(vm, stat_name, &data, 1);
+	return data;
+}
+
 uint32_t guest_get_vcpuid(void);
 
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 5e1ac66faf0f..200d3bb803e0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2645,3 +2645,49 @@ void read_stat_data(int stats_fd, struct kvm_stats_header *header,
 		    "pread() on stat '%s' read %ld bytes, wanted %lu bytes",
 		    desc->name, size, ret);
 }
+
+/*
+ * Read the data of the named stat
+ *
+ * Input Args:
+ *   vm - the VM for which the stat should be read
+ *   stat_name - the name of the stat to read
+ *   max_elements - the maximum number of 8-byte values to read into data
+ *
+ * Output Args:
+ *   data - the buffer into which stat data should be read
+ *
+ * Read the data values of a specified stat from the binary stats interface.
+ */
+void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
+		   size_t max_elements)
+{
+	struct kvm_stats_desc *stats_desc;
+	struct kvm_stats_header header;
+	struct kvm_stats_desc *desc;
+	size_t size_desc;
+	int stats_fd;
+	int i;
+
+	stats_fd = vm_get_stats_fd(vm);
+
+	read_stats_header(stats_fd, &header);
+
+	stats_desc = read_stats_descriptors(stats_fd, &header);
+
+	size_desc = get_stats_descriptor_size(&header);
+
+	for (i = 0; i < header.num_desc; ++i) {
+		desc = (void *)stats_desc + (i * size_desc);
+
+		if (strcmp(desc->name, stat_name))
+			continue;
+
+		read_stat_data(stats_fd, &header, desc, data, max_elements);
+
+		break;
+	}
+
+	free(stats_desc);
+	close(stats_fd);
+}
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
new file mode 100644
index 000000000000..09e05cda3dcd
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * tools/testing/selftests/kvm/nx_huge_page_test.c
+ *
+ * Usage: to be run via nx_huge_page_test.sh, which does the necessary
+ * environment setup and teardown
+ *
+ * Copyright (C) 2022, Google LLC.
+ */
+
+#define _GNU_SOURCE
+
+#include <fcntl.h>
+#include <stdint.h>
+#include <time.h>
+
+#include <test_util.h>
+#include "kvm_util.h"
+#include "processor.h"
+
+#define HPAGE_SLOT		10
+#define HPAGE_GPA		(4UL << 30) /* 4G prevents collision w/ slot 0 */
+#define HPAGE_GVA		HPAGE_GPA /* GVA is arbitrary, so use GPA. */
+#define PAGES_PER_2MB_HUGE_PAGE 512
+#define HPAGE_SLOT_NPAGES	(3 * PAGES_PER_2MB_HUGE_PAGE)
+
+/*
+ * Passed by nx_huge_pages_test.sh to provide an easy warning if this test is
+ * being run without it.
+ */
+#define MAGIC_TOKEN 887563923
+
+/*
+ * x86 opcode for the return instruction. Used to call into, and then
+ * immediately return from, memory backed with hugepages.
+ */
+#define RETURN_OPCODE 0xC3
+
+/* Call the specified memory address. */
+static void guest_do_CALL(uint64_t target)
+{
+	((void (*)(void)) target)();
+}
+
+/*
+ * Exit the VM after each memory access so that the userspace component of the
+ * test can make assertions about the pages backing the VM.
+ *
+ * See the below for an explanation of how each access should affect the
+ * backing mappings.
+ */
+void guest_code(void)
+{
+	uint64_t hpage_1 = HPAGE_GVA;
+	uint64_t hpage_2 = hpage_1 + (PAGE_SIZE * 512);
+	uint64_t hpage_3 = hpage_2 + (PAGE_SIZE * 512);
+
+	READ_ONCE(*(uint64_t *)hpage_1);
+	GUEST_SYNC(1);
+
+	READ_ONCE(*(uint64_t *)hpage_2);
+	GUEST_SYNC(2);
+
+	guest_do_CALL(hpage_1);
+	GUEST_SYNC(3);
+
+	guest_do_CALL(hpage_3);
+	GUEST_SYNC(4);
+
+	READ_ONCE(*(uint64_t *)hpage_1);
+	GUEST_SYNC(5);
+
+	READ_ONCE(*(uint64_t *)hpage_3);
+	GUEST_SYNC(6);
+}
+
+static void check_2m_page_count(struct kvm_vm *vm, int expected_pages_2m)
+{
+	int actual_pages_2m;
+
+	actual_pages_2m = vm_get_stat(vm, "pages_2m");
+
+	TEST_ASSERT(actual_pages_2m == expected_pages_2m,
+		    "Unexpected 2m page count. Expected %d, got %d",
+		    expected_pages_2m, actual_pages_2m);
+}
+
+static void check_split_count(struct kvm_vm *vm, int expected_splits)
+{
+	int actual_splits;
+
+	actual_splits = vm_get_stat(vm, "nx_lpage_splits");
+
+	TEST_ASSERT(actual_splits == expected_splits,
+		    "Unexpected NX huge page split count. Expected %d, got %d",
+		    expected_splits, actual_splits);
+}
+
+static void wait_for_reclaim(int reclaim_period_ms)
+{
+	long reclaim_wait_ms;
+	struct timespec ts;
+
+	reclaim_wait_ms = reclaim_period_ms * 5;
+	ts.tv_sec = reclaim_wait_ms / 1000;
+	ts.tv_nsec = (reclaim_wait_ms - (ts.tv_sec * 1000)) * 1000000;
+	nanosleep(&ts, NULL);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-p period_ms] [-t token]\n", name);
+	puts("");
+	printf(" -p: The NX reclaim period in miliseconds.\n");
+	printf(" -t: The magic token to indicate environment setup is done.\n");
+	puts("");
+	exit(0);
+}
+
+int main(int argc, char **argv)
+{
+	int reclaim_period_ms = 0, token = 0, opt;
+	struct kvm_vm *vm;
+	void *hva;
+
+	while ((opt = getopt(argc, argv, "hp:t:")) != -1) {
+		switch (opt) {
+		case 'p':
+			reclaim_period_ms = atoi(optarg);
+			break;
+		case 't':
+			token = atoi(optarg);
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			break;
+		}
+	}
+
+	if (token != MAGIC_TOKEN) {
+		print_skip("This test must be run with the magic token %d.\n"
+			   "This is done by nx_huge_pages_test.sh, which\n"
+			   "also handles environment setup for the test.",
+			   MAGIC_TOKEN);
+		exit(KSFT_SKIP);
+	}
+
+	if (!reclaim_period_ms) {
+		print_skip("The NX reclaim period must be specified and non-zero");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(0, 0, guest_code);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
+				    HPAGE_GPA, HPAGE_SLOT,
+				    HPAGE_SLOT_NPAGES, 0);
+
+	virt_map(vm, HPAGE_GVA, HPAGE_GPA, HPAGE_SLOT_NPAGES);
+
+	hva = addr_gpa2hva(vm, HPAGE_GPA);
+	memset(hva, RETURN_OPCODE, HPAGE_SLOT_NPAGES * PAGE_SIZE);
+
+	check_2m_page_count(vm, 0);
+	check_split_count(vm, 0);
+
+	/*
+	 * The guest code will first read from the first hugepage, resulting
+	 * in a huge page mapping being created.
+	 */
+	vcpu_run(vm, 0);
+	check_2m_page_count(vm, 1);
+	check_split_count(vm, 0);
+
+	/*
+	 * Then the guest code will read from the second hugepage, resulting
+	 * in another huge page mapping being created.
+	 */
+	vcpu_run(vm, 0);
+	check_2m_page_count(vm, 2);
+	check_split_count(vm, 0);
+
+	/*
+	 * Next, the guest will execute from the first huge page, causing it
+	 * to be remapped at 4k.
+	 */
+	vcpu_run(vm, 0);
+	check_2m_page_count(vm, 1);
+	check_split_count(vm, 1);
+
+	/*
+	 * Executing from the third huge page (previously unaccessed) will
+	 * cause part to be mapped at 4k.
+	 */
+	vcpu_run(vm, 0);
+	check_2m_page_count(vm, 1);
+	check_split_count(vm, 2);
+
+	/* Reading from the first huge page again should have no effect. */
+	vcpu_run(vm, 0);
+	check_2m_page_count(vm, 1);
+	check_split_count(vm, 2);
+
+	/* Give recovery thread time to run. */
+	wait_for_reclaim(reclaim_period_ms);
+
+	/*
+	 * Now that the reclaimer has run, all the split pages should be gone.
+	 */
+	check_2m_page_count(vm, 1);
+	check_split_count(vm, 0);
+
+	/*
+	 * The 4k mapping on hpage 3 should have been removed, so check that
+	 * reading from it causes a huge page mapping to be installed.
+	 */
+	vcpu_run(vm, 0);
+	check_2m_page_count(vm, 2);
+	check_split_count(vm, 0);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
new file mode 100755
index 000000000000..4e090a84f5f3
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
@@ -0,0 +1,40 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only */
+#
+# Wrapper script which performs setup and cleanup for nx_huge_pages_test.
+# Makes use of root privileges to set up huge pages and KVM module parameters.
+#
+# tools/testing/selftests/kvm/nx_huge_page_test.sh
+# Copyright (C) 2022, Google LLC.
+
+set -e
+
+NX_HUGE_PAGES=$(cat /sys/module/kvm/parameters/nx_huge_pages)
+NX_HUGE_PAGES_RECOVERY_RATIO=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio)
+NX_HUGE_PAGES_RECOVERY_PERIOD=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
+HUGE_PAGES=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
+
+set +e
+
+function sudo_echo () {
+	echo "$1" | sudo tee -a "$2" > /dev/null
+}
+
+(
+	set -e
+
+	sudo_echo 1 /sys/module/kvm/parameters/nx_huge_pages
+	sudo_echo 1 /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
+	sudo_echo 100 /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
+	sudo_echo "$(( $HUGE_PAGES + 3 ))" /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+
+	"$(dirname $0)"/nx_huge_pages_test -t 887563923 -p 100
+)
+RET=$?
+
+sudo_echo "$NX_HUGE_PAGES" /sys/module/kvm/parameters/nx_huge_pages
+sudo_echo "$NX_HUGE_PAGES_RECOVERY_RATIO" /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
+sudo_echo "$NX_HUGE_PAGES_RECOVERY_PERIOD" /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
+sudo_echo "$HUGE_PAGES" /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+
+exit $RET
-- 
2.36.1.124.g0e6072fb45-goog

