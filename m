Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6033F449C
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 07:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbhHWFRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 01:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbhHWFRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 01:17:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DCFC061756
        for <kvm@vger.kernel.org>; Sun, 22 Aug 2021 22:16:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f64-20020a2538430000b0290593bfc4b046so15512686yba.9
        for <kvm@vger.kernel.org>; Sun, 22 Aug 2021 22:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=SZp9jopn6L2gGcjaBST5d963oFablXCgT4VwmaYX6c8=;
        b=BWDOf9o4rquaek14MDqqotPhxfN7ahfaqMx6tz5jr8+1ICDTokXwzaWj9OiWvGGlCY
         xhpf17kFVXBYtpSAPmuHEzf8x0lpZylcyF/q96KBfzZOdcd+rnm+AnGXTqFvzCNdv1nx
         lcQRiwvQrD9I1j42OQo3g2Wfc7/jWA8TPQzhZFgtDg3tNEpOtdgao/VPZ4Q7US7woJvr
         JIXVPexNEV9hSe9N3zGuTM4TbsYWIrafPJnq/+dbaafxrjVxhSOsn3O1KNpXRTQ7X+zz
         s1VBxLXXdRvPBRGp1nfHT3OSPatiwwllLizCMmrMv6a/yhg+hSnhUldaNCHO5KFLQXj0
         tm5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=SZp9jopn6L2gGcjaBST5d963oFablXCgT4VwmaYX6c8=;
        b=mFZmKfpMRm1tE4W+gX0uubK+NZmsrYvabRlsPuORHDZ6uypKIR2OBb+PJ4arADmI32
         45/QM1VCQ+ZTmPcQSuY2RLisse5QYad7BDSXTf3oOtHUzXpOcgAWilxrGs/ak4bHEJy7
         pys+HkS9cUknClO5JBAPSA7MJ0rN3pVtCkULSSvkDokZHIfyUeLvjr8jZ7AOvsNu7A4p
         /G6wAvws13Azx4lUpOv+M5jDSnrF1QcjQkfqfUOo6VkprlJVpgskVbCY/vQRJCDWoWmE
         u2ScHaOySzp2zdfMQew8da04uxJ9nRIzLxHPV5Lqzo16d5bRQieRE05yWysW3erdmNOF
         +o1g==
X-Gm-Message-State: AOAM531kPVoFBb/srHRntp27NxaASqLbw3e4X6+ZPl5UnP3+ta6aepHv
        iz44JFp6/PUi0ajzs3umpVbpwXbTj6+H
X-Google-Smtp-Source: ABdhPJw3+CP6MbRvTm7KTzVWXTtryJM4LQ+VtZvRUcmHJyEdIEagZ7K+YREB0AIgRqanEJCzlZAlPTiij5mT
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a25:da89:: with SMTP id
 n131mr41861469ybf.255.1629695789605; Sun, 22 Aug 2021 22:16:29 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 23 Aug 2021 05:16:22 +0000
Message-Id: <20210823051622.312890-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH] selftests: KVM: use dirty logging to check if page stats work correctly
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgorden@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When dirty logging is enabled, KVM splits the all hugepage mapping in
NPT/EPT into the smallest 4K size. This property could be used to check if
the page stats metrics work properly in KVM mmu. At the same time, this
logic might be used the other way around: using page stats to verify if
dirty logging really splits all huge pages.

So add page stats checking in dirty logging performance selftest. In
particular, add checks in three locations:
 - just after vm is created;
 - after populating memory into vm but before enabling dirty logging;
 - after turning off dirty logging.

Tested using commands:
 - ./dirty_log_perf_test -s anonymous_hugetlb_1gb
 - ./dirty_log_perf_test -s anonymous_thp

Cc: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Jing Zhang <jingzhangos@google.com>
Cc: Peter Xu <peterx@redhat.com>

Suggested-by: Ben Gardon <bgorden@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 30 +++++++++++++++++++
 .../testing/selftests/kvm/include/test_util.h |  1 +
 .../selftests/kvm/lib/perf_test_util.c        |  3 ++
 tools/testing/selftests/kvm/lib/test_util.c   | 29 ++++++++++++++++++
 4 files changed, 63 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 3c30d0045d8d..e190f6860166 100644
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
 
@@ -166,6 +170,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
 				 p->slots, p->backing_src);
 
+#ifdef __x86_64__
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_4K) == 0,
+		    "4K page is non zero");
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) == 0,
+		    "2M page is non zero");
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_1G) == 0,
+		    "1G page is non zero");
+#endif
 	perf_test_args.wr_fract = p->wr_fract;
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
@@ -211,6 +223,16 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Populate memory time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+#ifdef __x86_64__
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_4K) != 0,
+		    "4K page is zero");
+	if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP)
+		TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) != 0,
+			    "2M page is zero");
+	if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
+		TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_1G) != 0,
+			    "1G page is zero");
+#endif
 	/* Enable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	enable_dirty_logging(vm, p->slots);
@@ -256,6 +278,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
 		}
 	}
+#ifdef __x86_64__
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_4K) != 0,
+		    "4K page is zero after dirty logging");
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) == 0,
+		    "2M page is non-zero after dirty logging");
+	TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_1G) == 0,
+		    "1G page is non-zero after dirty logging");
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
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 0ef80dbdc116..c2c532990fb0 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -96,6 +96,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
 	guest_test_phys_mem &= ~((1 << 20) - 1);
+#elif __x86_64__
+	/* Align to 1G (segment size) to allow hugepage mapping. */
+	guest_test_phys_mem &= ~((1 << 30) - 1);
 #endif
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
 
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
2.33.0.rc2.250.ged5fa647cd-goog

