Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BFD30CAFA
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239481AbhBBTII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239325AbhBBTEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:04:06 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF10AC061D7C
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:28 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 16so14136462pfn.12
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=3w/Fz3KRal32EzN7XgdofPfwSeoRKBs/rliSL0B+258=;
        b=oFJlf1jVlU3U6YYI2jjAGljxr5RlncvhscYzLLUQHdnBZOxaQc5HGLz1W9vxOmt3FV
         T2yILdv5+AxHIPRh5jfOIjxZ8HAyIyndC5jRSnau6MpMep9EuYTop62ZGfc7UnsxnUAL
         /l95e0QM3Crb7Fs4IruOrTUx7w9NdvXmbdW100osMr78UMa40axPMlvrR0P1LaxuELGX
         zagONAb3w2bZIQf+sZOKUftoE3c6abv++b9lyhTnfQpNs6K6TB1KY8lh5OD8uPaSJwf6
         vYdqYxwwFMv6FjbijA8deacUiS6uAFCF88wAJDDrbPTViikaC8/G7zioF3+ubGDinT3O
         s1vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3w/Fz3KRal32EzN7XgdofPfwSeoRKBs/rliSL0B+258=;
        b=my5bFcNs3uBsck0DYo3BOSfDAd7ORIIBSXRuvu+vRl+wyBP2VfjBYfNSCctHnMI1ed
         u7i86fShOXKwiFd4C4XkqnR/2RORyCJG22MOw0LMXtazaKKbURs0W1sYQiq7BSXwrI96
         /YfnBs+8hrOseqxUkUbKM+YK9Q7yuUIVEq+LsU7mLNUA0mS5Xfn7n90IkXv/XuiSQRoW
         cSnQu9vzxrhNOAGouz89SVFjmgObUozVnGpmHfU/vF1RIgWfvT4tnU406ZJyypDoHtEN
         H0yIugnS3wMHU5oQTh9zdJDWebZ3YiCqsOBIilUezluy14DohC6MELdCOFUk+oe77d2H
         5RfA==
X-Gm-Message-State: AOAM533kZUM9OzK9arwoOISy4A1breUpPQNbQNyBOF5ZCJpGzhhbvK0z
        YI4Hm+EHqI4fvvgK25zeEsn8FdXSg7GH
X-Google-Smtp-Source: ABdhPJwrOmmC+jea7XiyZdD3HaqZEF2v2jSVttQD60y9Xg6aQitnJ+ZqVuqrX9DY76rktQ3d2hqZ9TV0yGpD
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a62:9258:0:b029:1c8:c970:56d with SMTP id
 o85-20020a6292580000b02901c8c970056dmr23015975pfd.70.1612292308218; Tue, 02
 Feb 2021 10:58:28 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:33 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-28-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 27/28] KVM: selftests: Add backing src parameter to dirty_log_perf_test
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a parameter to control the backing memory type for
dirty_log_perf_test so that the test can be run with hugepages.

To: linux-kselftest@vger.kernel.org
CC: Peter Xu <peterx@redhat.com>
CC: Andrew Jones <drjones@redhat.com>
CC: Thomas Huth <thuth@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/demand_paging_test.c        |  3 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 15 ++++++++--
 .../testing/selftests/kvm/include/kvm_util.h  |  6 ----
 .../selftests/kvm/include/perf_test_util.h    |  3 +-
 .../testing/selftests/kvm/include/test_util.h | 14 +++++++++
 .../selftests/kvm/lib/perf_test_util.c        |  6 ++--
 tools/testing/selftests/kvm/lib/test_util.c   | 29 +++++++++++++++++++
 7 files changed, 62 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index cdad1eca72f7..9e3254ff0821 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -265,7 +265,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int vcpu_id;
 	int r;
 
-	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size);
+	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
+				 VM_MEM_SRC_ANONYMOUS);
 
 	perf_test_args.wr_fract = 1;
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 2283a0ec74a9..604ccefd6e76 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -92,6 +92,7 @@ struct test_params {
 	unsigned long iterations;
 	uint64_t phys_offset;
 	int wr_fract;
+	enum vm_mem_backing_src_type backing_src;
 };
 
 static void run_test(enum vm_guest_mode mode, void *arg)
@@ -111,7 +112,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_enable_cap cap = {};
 	struct timespec clear_dirty_log_total = (struct timespec){0};
 
-	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size);
+	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
+				 p->backing_src);
 
 	perf_test_args.wr_fract = p->wr_fract;
 
@@ -236,7 +238,7 @@ static void help(char *name)
 {
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] "
-	       "[-m mode] [-b vcpu bytes] [-v vcpus]\n", name);
+	       "[-m mode] [-b vcpu bytes] [-v vcpus] [-s mem type]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
@@ -251,6 +253,9 @@ static void help(char *name)
 	       "     1/<fraction of pages to write>.\n"
 	       "     (default: 1 i.e. all pages are written to.)\n");
 	printf(" -v: specify the number of vCPUs to run.\n");
+	printf(" -s: specify the type of memory that should be used to\n"
+	       "     back the guest data region.\n");
+	backing_src_help();
 	puts("");
 	exit(0);
 }
@@ -261,6 +266,7 @@ int main(int argc, char *argv[])
 	struct test_params p = {
 		.iterations = TEST_HOST_LOOP_N,
 		.wr_fract = 1,
+		.backing_src = VM_MEM_SRC_ANONYMOUS,
 	};
 	int opt;
 
@@ -271,7 +277,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hi:p:m:b:f:v:")) != -1) {
+	while ((opt = getopt(argc, argv, "hi:p:m:b:f:v:s:")) != -1) {
 		switch (opt) {
 		case 'i':
 			p.iterations = strtol(optarg, NULL, 10);
@@ -295,6 +301,9 @@ int main(int argc, char *argv[])
 			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
+		case 's':
+			p.backing_src = parse_backing_src_type(optarg);
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 5cbb861525ed..2d7eb6989e83 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -79,12 +79,6 @@ struct vm_guest_mode_params {
 };
 extern const struct vm_guest_mode_params vm_guest_mode_params[];
 
-enum vm_mem_backing_src_type {
-	VM_MEM_SRC_ANONYMOUS,
-	VM_MEM_SRC_ANONYMOUS_THP,
-	VM_MEM_SRC_ANONYMOUS_HUGETLB,
-};
-
 int kvm_check_cap(long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
 int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index b1188823c31b..8b66ab300175 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -44,7 +44,8 @@ extern struct perf_test_args perf_test_args;
 extern uint64_t guest_test_phys_mem;
 
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
-				uint64_t vcpu_memory_bytes);
+				   uint64_t vcpu_memory_bytes,
+				   enum vm_mem_backing_src_type backing_src);
 void perf_test_destroy_vm(struct kvm_vm *vm);
 void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus, uint64_t vcpu_memory_bytes);
 
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index ffffa560436b..749b24a239a1 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -67,4 +67,18 @@ struct timespec timespec_sub(struct timespec ts1, struct timespec ts2);
 struct timespec timespec_diff_now(struct timespec start);
 struct timespec timespec_div(struct timespec ts, int divisor);
 
+enum vm_mem_backing_src_type {
+	VM_MEM_SRC_ANONYMOUS,
+	VM_MEM_SRC_ANONYMOUS_THP,
+	VM_MEM_SRC_ANONYMOUS_HUGETLB,
+};
+
+struct vm_mem_backing_src_alias {
+	const char *name;
+	enum vm_mem_backing_src_type type;
+};
+
+void backing_src_help(void);
+enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9be1944c2d1c..7f1571924347 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -49,7 +49,8 @@ static void guest_code(uint32_t vcpu_id)
 }
 
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
-				   uint64_t vcpu_memory_bytes)
+				   uint64_t vcpu_memory_bytes,
+				   enum vm_mem_backing_src_type backing_src)
 {
 	struct kvm_vm *vm;
 	uint64_t guest_num_pages;
@@ -93,8 +94,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
 
 	/* Add an extra memory slot for testing */
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-				    guest_test_phys_mem,
+	vm_userspace_mem_region_add(vm, backing_src, guest_test_phys_mem,
 				    PERF_TEST_MEM_SLOT_INDEX,
 				    guest_num_pages, 0);
 
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 8e04c0b1608e..9fd60b142c23 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -10,6 +10,7 @@
 #include <limits.h>
 #include <stdlib.h>
 #include <time.h>
+#include "linux/kernel.h"
 
 #include "test_util.h"
 
@@ -109,3 +110,31 @@ void print_skip(const char *fmt, ...)
 	va_end(ap);
 	puts(", skipping test");
 }
+
+const struct vm_mem_backing_src_alias backing_src_aliases[] = {
+	{"anonymous", VM_MEM_SRC_ANONYMOUS,},
+	{"anonymous_thp", VM_MEM_SRC_ANONYMOUS_THP,},
+	{"anonymous_hugetlb", VM_MEM_SRC_ANONYMOUS_HUGETLB,},
+};
+
+void backing_src_help(void)
+{
+	int i;
+
+	printf("Available backing src types:\n");
+	for (i = 0; i < ARRAY_SIZE(backing_src_aliases); i++)
+		printf("\t%s\n", backing_src_aliases[i].name);
+}
+
+enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(backing_src_aliases); i++)
+		if (!strcmp(type_name, backing_src_aliases[i].name))
+			return backing_src_aliases[i].type;
+
+	backing_src_help();
+	TEST_FAIL("Unknown backing src type: %s", type_name);
+	return -1;
+}
-- 
2.30.0.365.g02bc693789-goog

