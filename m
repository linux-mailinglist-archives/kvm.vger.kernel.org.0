Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4334FFD5E
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 20:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbiDMSDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 14:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbiDMSCV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 14:02:21 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1699740A03
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:59:59 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l6-20020a170903120600b0014f43ba55f3so1541081plh.11
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oDKaF227nBT2MqbB1fwM7dDzetRoxMTdlPAeTV2ta2k=;
        b=oed96hXLbqf3H5+veEWpI7BPo6+Tj6+HENlIbuTZ3V0cxFInrOUq+bfBBhnWnpwOil
         hzsTBRaUaiDOz3t8DWOqtHxLfumGuusIqO3GZfnEXToYerUVRodtarOg5Fh3VPykFwjq
         rMvVPu87J42w4tUsHsgoliRq9MSCQdrTontaV7hQ9tuRwp48RrDHwZ9Jt/OdPzcgL0af
         GqUHzNwxjAjyIqtWcATGP+rtDha/KvmktceaOiLEN2mRZGK7Z7jP1iyoWomYLkk9iQbl
         5ScbyfCtJ17qjWizLWP1G8TPBT7+gIvXigqc8ZlHZfiZFjV6jk9SbToLkRRWmVAPyBWn
         tZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oDKaF227nBT2MqbB1fwM7dDzetRoxMTdlPAeTV2ta2k=;
        b=CpvBA9btxWV+STxIikHPyFsBpd1itMw5t2PbEsP32WSNfY9wsqKo9gEeS0A4DDy7nw
         EfS+VhcbWA5Yp/9t1tURP6hQfGGcQWEtbKPY3F9ZCx6/i1rtRVtxML+DOh0tLK3ga5CD
         wd4W9qiOATNQzST0Z+OwV5AK/BE0/IWAEp7HX6DRi4jJRE01ATAJXV60PNY1RZCJnqhk
         H4AYfPHPgF8qxQxgYSOYtOaZnwhp/aFbBlAutRf0eJQ9loOzemZZIb+SkDN7WZ549roY
         /HfRkSArYhaA4TE1hhZsZ+kTZ/xnBXGKJ49y+emxP3z51mTVN52GqHr6eDDK7zQoGQr/
         EUag==
X-Gm-Message-State: AOAM532WSYGdVp0KlB5atVVW4/GbNVm40v7sE7ugqWQ7Sheu+t4Kv4dd
        re7Z4rKW7+NQ29JgMpkcK8XmHIn3Sfyz
X-Google-Smtp-Source: ABdhPJwNN7Emm7zUNN0AwUlDvrPtO3WG1fzXyrP8M5uUg+90Kryz0WiDW7yuJUfiR0Q/JhBSKRDdfp1XM6BQ
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:c087:f2f2:f5f0:f73])
 (user=bgardon job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr25759pjb.1.1649872798287; Wed, 13 Apr
 2022 10:59:58 -0700 (PDT)
Date:   Wed, 13 Apr 2022 10:59:40 -0700
In-Reply-To: <20220413175944.71705-1-bgardon@google.com>
Message-Id: <20220413175944.71705-7-bgardon@google.com>
Mime-Version: 1.0
References: <20220413175944.71705-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 06/10] KVM: selftests: Add NX huge pages test
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's currently no test coverage of NX hugepages in KVM selftests, so
add a basic test to ensure that the feature works as intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  10 ++
 .../selftests/kvm/include/kvm_util_base.h     |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  62 +++++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 166 ++++++++++++++++++
 .../kvm/x86_64/nx_huge_pages_test.sh          |  25 +++
 5 files changed, 264 insertions(+)
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
index fc2321055a69..d332f02370d1 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2651,3 +2651,65 @@ int read_stat_data(int stats_fd, struct kvm_stats_header *header,
 
 	return ret;
 }
+
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
index 000000000000..7f80e48781fd
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -0,0 +1,166 @@
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
index 000000000000..19fc95723fcb
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
+./nx_huge_pages_test
+RET=$?
+
+echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
+echo $NX_HUGE_PAGES_RECOVERY_RATIO > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
+echo $NX_HUGE_PAGES_RECOVERY_PERIOD > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
+echo $HUGE_PAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+
+exit $RET
-- 
2.35.1.1178.g4f1659d476-goog

