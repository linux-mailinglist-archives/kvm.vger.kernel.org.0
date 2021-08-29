Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6E93FADC0
	for <lists+kvm@lfdr.de>; Sun, 29 Aug 2021 20:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbhH2S1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Aug 2021 14:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235916AbhH2S1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Aug 2021 14:27:40 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C54C061760
        for <kvm@vger.kernel.org>; Sun, 29 Aug 2021 11:26:47 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r21-20020a63d9150000b029023ccd23c20cso2673029pgg.19
        for <kvm@vger.kernel.org>; Sun, 29 Aug 2021 11:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=aZ7Pxe57fEMPbk2rJbVH9QT9ZPZ0Llj+AGW3Zhhzqrg=;
        b=pMm/Mr/m+aeIjuPR3E6Tu57eT5lCddN9PZV3IMO6Pjou3ecMrqfq8+Qj6Fen1HDurR
         Y2p+Z35+8u+klOa2DFSVyoCFHOv883/AKQR3Ef2+h+noBzSv1ohLwwphTLFL1kYaFkzk
         Dy7JGgsxGDPDUvPXwJYz62ArCioB0ABY/Hin+iwPvE8iEBtrODAyduBi5vRzsh4j4SYA
         ulBk++yfF46kwYWRdN8vyOWOw5JUGrg+IqVxgzINTcDykJoZdpyKoOCgow3gkx2hbVvz
         ncSh/d89hB32jVFQUo1tBXUEsSCWOUI8GePUmgbvp5vBBDqKke0Pnlb/NG9bOVhicn5r
         sLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=aZ7Pxe57fEMPbk2rJbVH9QT9ZPZ0Llj+AGW3Zhhzqrg=;
        b=p8T3p8qtLS7t88n9dvrCpeDs3KKqKLaUkwbiFs+RR/QBPHMSpc1ojupoU1bDvKIP8H
         IncJDbdrc3GDveLVABHHjskmBuk19VuTcSJTuouie29zLIizxCaeSsoixrqHpTzbYTNx
         A1XC9R1zEu1JQEF3x+maeRu6mO4yM+Pus0KdcykL7pwQd58RZnsLFJ97TnBVwBgTAIL0
         3yr9ro6lQOPobTN710JXXj3jqr8l0l8Ss/eBsdbMBh9fDBTXkzo4EH5U18ZnCk5sd3wX
         0KiAIBilJqrVlUDrDvg+RPAeDz4oQs22XnEX4sfoiZGjjU1JrKpQ0oq5T/nWs1XxHWdl
         Ji4g==
X-Gm-Message-State: AOAM531UaBNVFPcT+pGWFkis6ZyQuW1zm1+T2kRW966T7TgKD5sdj3Fi
        pUrmIu1/ahHgEhXt6XSH+EFnCQcWns2h
X-Google-Smtp-Source: ABdhPJzNdyDE37ZnSg/vofjbh4REKSTi7y/r+ggckFH2AlyLQ7A6Tw01hVhzg48Yv/9ZsyehNgKDIRPJeup2
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:903:2c2:b029:101:9c88:d928 with SMTP
 id s2-20020a17090302c2b02901019c88d928mr18444239plk.62.1630261607275; Sun, 29
 Aug 2021 11:26:47 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Sun, 29 Aug 2021 18:26:41 +0000
In-Reply-To: <20210829182641.2505220-1-mizhang@google.com>
Message-Id: <20210829182641.2505220-3-mizhang@google.com>
Mime-Version: 1.0
References: <20210829182641.2505220-1-mizhang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v2 2/2] selftests: KVM: use dirty logging to check if page
 stats work correctly
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When dirty logging is enabled, KVM splits the hugepage mapping in NPT/EPT
into the smallest 4K size after guest VM writes to it. This property could
be used to check if the page stats metrics work properly in KVM x86/mmu. At
the same time, this logic might be used the other way around: using page
stats to verify if dirty logging really splits all huge pages after guest
VM writes to all memory.

So add page stats checking in dirty logging performance selftest. In
particular, add checks in three locations:
 - just after vm is created;
 - after populating memory into vm without turning on dirty logging;
 - after guest vm writing to all memory again with dirty logging turned on.

Tested using commands:
 - ./dirty_log_perf_test -s anonymous_hugetlb_1gb
 - ./dirty_log_perf_test -s anonymous_hugetlb_2mb
 - ./dirty_log_perf_test -s anonymous_thp

Cc: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Jing Zhang <jingzhangos@google.com>
Cc: Peter Xu <peterx@redhat.com>

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 44 +++++++++++++++++++
 .../testing/selftests/kvm/include/test_util.h |  1 +
 .../selftests/kvm/include/x86_64/processor.h  |  7 +++
 tools/testing/selftests/kvm/lib/test_util.c   | 29 ++++++++++++
 4 files changed, 81 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 3c30d0045d8d..1fc63ad55cf3 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -19,6 +19,10 @@
 #include "perf_test_util.h"
 #include "guest_modes.h"
 
+#ifdef __x86_64__
+#include "processor.h"
+#endif
+
 /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
 #define TEST_HOST_LOOP_N		2UL
 
@@ -166,6 +170,18 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
 				 p->slots, p->backing_src);
 
+#ifdef __x86_64__
+	/*
+	 * No vCPUs have been started yet, so KVM should not have created any
+	 * mapping at this moment.
+	 */
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_4K) == 0,
+		    "4K page is non zero");
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) == 0,
+		    "2M page is non zero");
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_1G) == 0,
+		    "1G page is non zero");
+#endif
 	perf_test_args.wr_fract = p->wr_fract;
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
@@ -211,6 +227,22 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Populate memory time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+#ifdef __x86_64__
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_4K) != 0,
+		    "4K page is zero");
+	/* Ensure THP page stats is non-zero to minimize the flakiness. */
+	if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP)
+		TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) > 0
+			"2M page number is zero");
+	else if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_2MB)
+		TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) ==
+			(guest_percpu_mem_size * nr_vcpus) >> X86_PAGE_2M_SHIFT,
+			"2M page number does not match");
+	else if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
+		TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_1G) ==
+			(guest_percpu_mem_size * nr_vcpus) >> X86_PAGE_1G_SHIFT,
+			"1G page number does not match");
+#endif
 	/* Enable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	enable_dirty_logging(vm, p->slots);
@@ -256,6 +288,18 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
 		}
 	}
+#ifdef __x86_64__
+	/*
+	 * When vCPUs writes to all memory again with dirty logging enabled, we
+	 * should see only 4K page mappings exist in KVM mmu.
+	 */
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_4K) != 0,
+		    "4K page is zero after dirtying memory");
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) == 0,
+		    "2M page is non-zero after dirtying memory");
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_1G) == 0,
+		    "1G page is non-zero  after dirtying memory");
+#endif
 
 	/* Disable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index d79be15dd3d2..dca5fcf7aa87 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -102,6 +102,7 @@ const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i);
 size_t get_backing_src_pagesz(uint32_t i);
 void backing_src_help(void);
 enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name);
+size_t get_page_stats(uint32_t page_level);
 
 /*
  * Whether or not the given source type is shared memory (as opposed to
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 242ae8e09a65..9749319821a3 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -39,6 +39,13 @@
 #define X86_CR4_SMAP		(1ul << 21)
 #define X86_CR4_PKE		(1ul << 22)
 
+#define X86_PAGE_4K_SHIFT	12
+#define X86_PAGE_4K		(1ul << X86_PAGE_4K_SHIFT)
+#define X86_PAGE_2M_SHIFT	21
+#define X86_PAGE_2M		(1ul << X86_PAGE_2M_SHIFT)
+#define X86_PAGE_1G_SHIFT	30
+#define X86_PAGE_1G		(1ul << X86_PAGE_1G_SHIFT)
+
 /* CPUID.1.ECX */
 #define CPUID_VMX		(1ul << 5)
 #define CPUID_SMX		(1ul << 6)
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index af1031fed97f..07eb6b5c125e 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -15,6 +15,13 @@
 #include "linux/kernel.h"
 
 #include "test_util.h"
+#include "processor.h"
+
+static const char * const pagestat_filepaths[] = {
+	"/sys/kernel/debug/kvm/pages_4k",
+	"/sys/kernel/debug/kvm/pages_2m",
+	"/sys/kernel/debug/kvm/pages_1g",
+};
 
 /*
  * Parses "[0-9]+[kmgt]?".
@@ -141,6 +148,28 @@ size_t get_trans_hugepagesz(void)
 	return size;
 }
 
+#ifdef __x86_64__
+size_t get_stats_from_file(const char *path)
+{
+	size_t value;
+	FILE *f;
+
+	f = fopen(path, "r");
+	TEST_ASSERT(f != NULL, "Error in opening file: %s\n", path);
+
+	fscanf(f, "%ld", &value);
+	fclose(f);
+
+	return value;
+}
+
+size_t get_page_stats(uint32_t page_level)
+{
+	TEST_ASSERT(page_level <= X86_PAGE_SIZE_1G, "page type error.");
+	return get_stats_from_file(pagestat_filepaths[page_level]);
+}
+#endif
+
 size_t get_def_hugetlb_pagesz(void)
 {
 	char buf[64];
-- 
2.33.0.259.gc128427fd7-goog

