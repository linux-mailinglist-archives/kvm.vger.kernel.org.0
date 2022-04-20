Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5342508E81
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381151AbiDTRiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381136AbiDTRiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:38:17 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5423F1C12F
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:28 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y23-20020a62b517000000b004fd8affa86aso1608403pfe.12
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rxOyftFjuKDO9GheWZ+1hRlXO4qObtEuXZzpkIuZqXU=;
        b=BEDmq7MukwIVcVLTHw8TfhL29aIo6eeFswW4VObgpA9Hwmxalmsbfnt9oB0+CXZ5sb
         MX7x4zv3sA85SMikaZWTtMqFIo43NLQI1VWahardQ7aE+fJs+LXIH3RDdhB6P+S1QI6V
         dTJJNxwkOF1LwBOsKrFVZFgHXgvKqSdgZlMbiSMraIDT2w9W5UO7aGKKX5BFngTftWLD
         bVM5jAMC+8qSJPESpsaIz0HaZ+UTmwMWjICVPpGwm/KhdojtC2e3JLNpNxizEwHywz2c
         c/nd1ZGQ0IEpCIaq0L5pxz1wtMTuCSfNaDIi+jER5A8Co6EOu1NXL0noqs8QL4FASKbm
         owZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rxOyftFjuKDO9GheWZ+1hRlXO4qObtEuXZzpkIuZqXU=;
        b=LW2zePxo28gHVSCPvelca6IoAJfP4+/913excmURKIYZwwOaASdKXnmLEBV3MTF3Sk
         EKN09rRW+cubYQLPQPLxvVDjom/N2x7A1cGI+KPGIBG8etNRLXZPnJopNcO1o9WyrCD+
         qM79CWlf2D6JVgYuPrMMR4COf2j58nTPcaauy5HoIgwtUgCKPCgRfqD4epGrVw7zQrQa
         133u34dR0231S4CWKat2VDB1dL0EU3scpwYuDp5cQUYAy4Inkngy4UG8CLsSSpeAkmBd
         J759xMxtcWChkzBtele6zYbbGVGk0cD65vqLlCxQ/NGB00xBCJqS1khjaK+aXKoYts+F
         /Z3Q==
X-Gm-Message-State: AOAM530DB2yHZuGyUOH5iLKqXxim8yizRWA/Gon2prF1b19w82kv0YOv
        I1SkWecnmTfNi7eSPMSFDCM5qHD0m5mn
X-Google-Smtp-Source: ABdhPJygeQYB7dsDA6ZNx1F8dn8eYPKVPbfwvU99GbDclTbwlihsHWxjeY+wIer/TFt+hodZrVkaR0bGmiXS
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6ea6:489a:aad6:761c])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:1346:b0:50a:8fad:2b6d with SMTP
 id k6-20020a056a00134600b0050a8fad2b6dmr12541073pfu.79.1650476127840; Wed, 20
 Apr 2022 10:35:27 -0700 (PDT)
Date:   Wed, 20 Apr 2022 10:35:09 -0700
In-Reply-To: <20220420173513.1217360-1-bgardon@google.com>
Message-Id: <20220420173513.1217360-7-bgardon@google.com>
Mime-Version: 1.0
References: <20220420173513.1217360-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v6 06/10] KVM: selftests: Add NX huge pages test
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's currently no test coverage of NX hugepages in KVM selftests, so
add a basic test to ensure that the feature works as intended.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  10 +
 .../selftests/kvm/include/kvm_util_base.h     |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  78 ++++++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 177 ++++++++++++++++++
 .../kvm/x86_64/nx_huge_pages_test.sh          |  25 +++
 5 files changed, 291 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
 create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index af582d168621..9bb9bce4df37 100644
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
@@ -104,6 +108,9 @@ TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 
+# Compiled outputs used by test targets
+TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
+
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
@@ -142,7 +149,9 @@ TEST_GEN_PROGS_riscv += kvm_page_table_test
 TEST_GEN_PROGS_riscv += set_memory_region_test
 TEST_GEN_PROGS_riscv += kvm_binary_stats_test
 
+TEST_PROGS += $(TEST_PROGS_$(UNAME_M))
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
+TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
@@ -193,6 +202,7 @@ $(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 all: $(STATIC_LIBS)
 $(TEST_GEN_PROGS): $(STATIC_LIBS)
+$(TEST_GEN_PROGS_EXTENDED): $(STATIC_LIBS)
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
 cscope:
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 2a3a4d9ed8e3..001b55ae25f8 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -406,6 +406,7 @@ struct kvm_stats_desc *read_stats_desc(int stats_fd,
 int read_stat_data(int stats_fd, struct kvm_stats_header *header,
 		   struct kvm_stats_desc *desc, uint64_t *data,
 		   ssize_t max_elements);
+uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ea4ab64e5997..9896cc49eb54 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2651,3 +2651,81 @@ int read_stat_data(int stats_fd, struct kvm_stats_header *header,
 
 	return ret;
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
+ * Return:
+ *   The number of data elements read into data or -ERRNO on error.
+ *
+ * Read the data values of a specified stat from the binary stats interface.
+ */
+static int __vm_get_stat(struct kvm_vm *vm, const char *stat_name,
+			    uint64_t *data, ssize_t max_elements)
+{
+	struct kvm_stats_desc *stats_desc;
+	struct kvm_stats_header header;
+	struct kvm_stats_desc *desc;
+	size_t size_desc;
+	int stats_fd;
+	int ret = -EINVAL;
+	int i;
+
+	stats_fd = vm_get_stats_fd(vm);
+
+	read_stats_header(stats_fd, &header);
+
+	stats_desc = read_stats_desc(stats_fd, &header);
+
+	size_desc = sizeof(struct kvm_stats_desc) + header.name_size;
+
+	/* Read kvm stats data one by one */
+	for (i = 0; i < header.num_desc; ++i) {
+		desc = (void *)stats_desc + (i * size_desc);
+
+		if (strcmp(desc->name, stat_name))
+			continue;
+
+		ret = read_stat_data(stats_fd, &header, desc, data,
+				     max_elements);
+	}
+
+	free(stats_desc);
+	close(stats_fd);
+	return ret;
+}
+
+/*
+ * Read the value of the named stat
+ *
+ * Input Args:
+ *   vm - the VM for which the stat should be read
+ *   stat_name - the name of the stat to read
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   The value of the stat
+ *
+ * Reads the value of the named stat through the binary stat interface. If
+ * the named stat has multiple data elements, only the first will be returned.
+ */
+uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
+{
+	uint64_t data;
+	int ret;
+
+	ret = __vm_get_stat(vm, stat_name, &data, 1);
+	TEST_ASSERT(ret == 1,
+		    "Stat %s expected to have 1 element, but %d returned",
+		    stat_name, ret);
+	return data;
+}
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
new file mode 100644
index 000000000000..1c14368500b7
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -0,0 +1,177 @@
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
+
+#define HPAGE_SLOT		10
+#define HPAGE_GVA		(23*1024*1024)
+#define HPAGE_GPA		(10*1024*1024)
+#define HPAGE_SLOT_NPAGES	(512 * 3)
+#define PAGE_SIZE		4096
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
+/*
+ * Exit the VM after each memory access so that the userspace component of the
+ * test can make assertions about the pages backing the VM.
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
+	((void (*)(void)) hpage_1)();
+	GUEST_SYNC(3);
+
+	((void (*)(void)) hpage_3)();
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
+		    "Unexpected nx lpage split count. Expected %d, got %d",
+		    expected_splits, actual_splits);
+}
+
+int main(int argc, char **argv)
+{
+	struct kvm_vm *vm;
+	struct timespec ts;
+	void *hva;
+
+	if (argc != 2 || strtol(argv[1], NULL, 0) != MAGIC_TOKEN) {
+		printf("This test must be run through nx_huge_pages_test.sh");
+		return KSFT_SKIP;
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
+	/*
+	 * Give recovery thread time to run. The wrapper script sets
+	 * recovery_period_ms to 100, so wait 5x that.
+	 */
+	ts.tv_sec = 0;
+	ts.tv_nsec = 500000000;
+	nanosleep(&ts, NULL);
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
index 000000000000..c2429ad8066a
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
@@ -0,0 +1,25 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only */
+
+# tools/testing/selftests/kvm/nx_huge_page_test.sh
+# Copyright (C) 2022, Google LLC.
+
+NX_HUGE_PAGES=$(cat /sys/module/kvm/parameters/nx_huge_pages)
+NX_HUGE_PAGES_RECOVERY_RATIO=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio)
+NX_HUGE_PAGES_RECOVERY_PERIOD=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
+HUGE_PAGES=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
+
+echo 1 > /sys/module/kvm/parameters/nx_huge_pages
+echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
+echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
+echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+
+"$(dirname $0)"/nx_huge_pages_test 887563923
+RET=$?
+
+echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
+echo $NX_HUGE_PAGES_RECOVERY_RATIO > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
+echo $NX_HUGE_PAGES_RECOVERY_PERIOD > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
+echo $HUGE_PAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+
+exit $RET
-- 
2.36.0.rc0.470.gd361397f0d-goog

