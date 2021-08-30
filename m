Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2A73FB07E
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 06:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhH3Epc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 00:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbhH3Epb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 00:45:31 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472F5C061760
        for <kvm@vger.kernel.org>; Sun, 29 Aug 2021 21:44:38 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id mm23-20020a17090b359700b00185945eae0eso2101658pjb.3
        for <kvm@vger.kernel.org>; Sun, 29 Aug 2021 21:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RoJ0LsLVs40o7Nox03dwwTrjHnUzwdc///UAgXfF3Tc=;
        b=RF03EgJj3F24vcUGNvoG4Fh+n2kFhF1dlYTNKTong/NWfugW8QcnHaQAOodmweyrWW
         OTWcGLn9VgFpufi8YlTXPZbXlRL0dcy9D9QiTdykURXnHQm6+vqtoo9/PmvlswCGkMI/
         zH8OVGd2ywSruiGboumDNnm/Cn9ohVcsN2KjhTgc4pWYrNZBmquOxhLqVrCDnMvlWPoV
         NWdJ3N4D/IAv3HG4euiZ/5SjNryM2sx2UWkgWDOLByPGWUdk6O7LhzUt14/CCfsznvON
         Wi0YkrjRBZH23RYwBizZxVKAIp/UCyFBualBtzPaSCY2XExEVBL0SAesidMSdz2aiqaI
         DVrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RoJ0LsLVs40o7Nox03dwwTrjHnUzwdc///UAgXfF3Tc=;
        b=I3V+EhzAalLCIOCjub0x4f4efwjS1qdHf94STG6T6r+xFqOkjXswE+v0VNXCXXdxRQ
         MNBvBpIav3cUuQ8JVyhhJJKvWF6YyJAcwv+Dk+llC58Cu0at9PBA81sfagml15/dFtJ9
         hP4Wncah7xjDZXlT46KcVInh3gjVDLjruWSMKMAsLhzE6j6w4dDf0sfd5LZRAUYgCHNj
         8mZ74+4QvNHOyPP6rFkjCGk2M8cG3Eb9MjqGAl1fTGgtGrlFON6nCRzQEbaNk3XYj0Ot
         /N9a+pHTFF1eJJYT8fFmWqN5ZOAvlSj2GS9EEJ7T5ohojJb5nK3XYqU3gAr7518YBU9d
         ZFAA==
X-Gm-Message-State: AOAM533ehF4H7jIL1TQgdulEejNFD4urs1SQWYFa5Wsk8gbGUDIdHEKy
        G88/neb0y39Z4N+6sLq5BxmBCZVSHLOe
X-Google-Smtp-Source: ABdhPJzmW1FSmqK8xT6hF9uY4CuQPY0a/lTVmlyKfrQpQsAljqAmAfv0zV7Qa3Wq7VNMB5YJP+18LZqbNNPh
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:903:32cd:b0:138:9904:ef79 with SMTP id
 i13-20020a17090332cd00b001389904ef79mr14594852plr.27.1630298677755; Sun, 29
 Aug 2021 21:44:37 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 30 Aug 2021 04:44:25 +0000
In-Reply-To: <20210830044425.2686755-1-mizhang@google.com>
Message-Id: <20210830044425.2686755-3-mizhang@google.com>
Mime-Version: 1.0
References: <20210830044425.2686755-1-mizhang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v3 2/2] selftests: KVM: use dirty logging to check if page
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
index 3c30d0045d8d..bc598e07b295 100644
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
+		TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) > 0,
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

