Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8016785B9
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 20:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbjAWTDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 14:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjAWTDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 14:03:36 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2E316333
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 11:03:34 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id s4-20020a056a00194400b0058d9b9fecb6so5684163pfk.1
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 11:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0npHJgLgboBXgYnUwk1Sul4f7aUtJiI3ey0Plz8dops=;
        b=k8eZHUA4PW7wOm7VXsba0RObujQMutFa+IA9Jyr7FE9A2Y9Q8qjxHMF+ScEgc9qPJ/
         xFt7a1kVH9gkVc/XzheANKzU+aMo/C9z/5r7zzKFdE/7EbTavbnEEwCqYwkAXfgx68J3
         W7xBZPYxv0ozI48ISmDBD3qli2P4iA/KXzixSBBl91fflw9Tvibj9LVUTX9QB6/V56av
         csdYZ7i/8mQCzsV1zE0WBSSr9WT0nvjMTKrLmmmLneCDp8h+7SE3+vyQ+9l2Bpfw1U4C
         jsRq2xJtI65/ICckglz36rVNQ9Ml7RV2YcWHhlZpL402knUIYKSdmsQBYxLnjp4ZDrUH
         WOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0npHJgLgboBXgYnUwk1Sul4f7aUtJiI3ey0Plz8dops=;
        b=Utulgu7IfKK4T6OTWrx7saBWluXZqTvG6oANV4PDDqUV4vzjtoEMOpRnRuPm+8WlML
         hyLxs28LD3xki2uaEZo/IHxGumdN+ZfKGJ+JAtP3TIC8RB5nKv6JZIjeIAaXrEEUE23w
         fpOcNBLuoFXG4rIXFJrc76X+8qdFXqNLwaAOoUqswMAa1oWy2mwFxbBHIIrIjRcshfaT
         CQf22RQ6bMvlEHScVt+Qb188Rb4ZbkdNdLb8YW+ZStFyFxJpdUEish798seqpPWEx7Fn
         4IeeepTQXRpmMAAt5vWTJTvQNNU0SaRIF5Rb9jNXlL6jq+WK1OKKASY2RL/qhLD0gkhV
         q98Q==
X-Gm-Message-State: AFqh2kqD9/T1TLkJGDtHOdxq2l/NqhZJvLDp7WNcXEeaid1RENuSYlox
        LXwkwgSo7z60Vcrg8d6Cxey+wDXNKCsV
X-Google-Smtp-Source: AMrXdXunCimUwLoGUfi1U2uZ1sBBXV0Ryvf/B3UHDWFAl3wAkzZK8C5H11zC5U1FFij16KwAs/xuwbH3mFgg
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:db14:b0:229:6fd:efec with SMTP id
 g20-20020a17090adb1400b0022906fdefecmr3476919pjv.154.1674500613559; Mon, 23
 Jan 2023 11:03:33 -0800 (PST)
Date:   Mon, 23 Jan 2023 19:03:28 +0000
In-Reply-To: <20230123190329.520285-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230123190329.520285-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230123190329.520285-2-bgardon@google.com>
Subject: [PATCH v2 1/2] selftests: KVM: Move dirty logging functions to memstress.(c|h)
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

Move some helper functions from dirty_log_perf_test.c to the memstress
library so that they can be used in a future commit which tests page
splitting during dirty logging.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 84 ++-----------------
 .../testing/selftests/kvm/include/memstress.h |  8 ++
 tools/testing/selftests/kvm/lib/memstress.c   | 72 ++++++++++++++++
 3 files changed, 87 insertions(+), 77 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index e9d6d1aecf89c..416719e205183 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -136,77 +136,6 @@ struct test_params {
 	bool random_access;
 };
 
-static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
-{
-	int i;
-
-	for (i = 0; i < slots; i++) {
-		int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
-		int flags = enable ? KVM_MEM_LOG_DIRTY_PAGES : 0;
-
-		vm_mem_region_set_flags(vm, slot, flags);
-	}
-}
-
-static inline void enable_dirty_logging(struct kvm_vm *vm, int slots)
-{
-	toggle_dirty_logging(vm, slots, true);
-}
-
-static inline void disable_dirty_logging(struct kvm_vm *vm, int slots)
-{
-	toggle_dirty_logging(vm, slots, false);
-}
-
-static void get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int slots)
-{
-	int i;
-
-	for (i = 0; i < slots; i++) {
-		int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
-
-		kvm_vm_get_dirty_log(vm, slot, bitmaps[i]);
-	}
-}
-
-static void clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
-			    int slots, uint64_t pages_per_slot)
-{
-	int i;
-
-	for (i = 0; i < slots; i++) {
-		int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
-
-		kvm_vm_clear_dirty_log(vm, slot, bitmaps[i], 0, pages_per_slot);
-	}
-}
-
-static unsigned long **alloc_bitmaps(int slots, uint64_t pages_per_slot)
-{
-	unsigned long **bitmaps;
-	int i;
-
-	bitmaps = malloc(slots * sizeof(bitmaps[0]));
-	TEST_ASSERT(bitmaps, "Failed to allocate bitmaps array.");
-
-	for (i = 0; i < slots; i++) {
-		bitmaps[i] = bitmap_zalloc(pages_per_slot);
-		TEST_ASSERT(bitmaps[i], "Failed to allocate slot bitmap.");
-	}
-
-	return bitmaps;
-}
-
-static void free_bitmaps(unsigned long *bitmaps[], int slots)
-{
-	int i;
-
-	for (i = 0; i < slots; i++)
-		free(bitmaps[i]);
-
-	free(bitmaps);
-}
-
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *p = arg;
@@ -236,7 +165,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
 	pages_per_slot = host_num_pages / p->slots;
 
-	bitmaps = alloc_bitmaps(p->slots, pages_per_slot);
+	bitmaps = memstress_alloc_bitmaps(p->slots, pages_per_slot);
 
 	if (dirty_log_manual_caps)
 		vm_enable_cap(vm, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2,
@@ -277,7 +206,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	/* Enable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
-	enable_dirty_logging(vm, p->slots);
+	memstress_enable_dirty_logging(vm, p->slots);
 	ts_diff = timespec_elapsed(start);
 	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
@@ -306,7 +235,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
 
 		clock_gettime(CLOCK_MONOTONIC, &start);
-		get_dirty_log(vm, bitmaps, p->slots);
+		memstress_get_dirty_log(vm, bitmaps, p->slots);
 		ts_diff = timespec_elapsed(start);
 		get_dirty_log_total = timespec_add(get_dirty_log_total,
 						   ts_diff);
@@ -315,7 +244,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 		if (dirty_log_manual_caps) {
 			clock_gettime(CLOCK_MONOTONIC, &start);
-			clear_dirty_log(vm, bitmaps, p->slots, pages_per_slot);
+			memstress_clear_dirty_log(vm, bitmaps, p->slots,
+						  pages_per_slot);
 			ts_diff = timespec_elapsed(start);
 			clear_dirty_log_total = timespec_add(clear_dirty_log_total,
 							     ts_diff);
@@ -334,7 +264,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	/* Disable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
-	disable_dirty_logging(vm, p->slots);
+	memstress_disable_dirty_logging(vm, p->slots);
 	ts_diff = timespec_elapsed(start);
 	pr_info("Disabling dirty logging time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
@@ -359,7 +289,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			clear_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
 	}
 
-	free_bitmaps(bitmaps, p->slots);
+	memstress_free_bitmaps(bitmaps, p->slots);
 	arch_cleanup_vm(vm);
 	memstress_destroy_vm(vm);
 }
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index 72e3e358ef7bd..ce4e603050eaa 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -72,4 +72,12 @@ void memstress_guest_code(uint32_t vcpu_id);
 uint64_t memstress_nested_pages(int nr_vcpus);
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);
 
+void memstress_enable_dirty_logging(struct kvm_vm *vm, int slots);
+void memstress_disable_dirty_logging(struct kvm_vm *vm, int slots);
+void memstress_get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int slots);
+void memstress_clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
+			       int slots, uint64_t pages_per_slot);
+unsigned long **memstress_alloc_bitmaps(int slots, uint64_t pages_per_slot);
+void memstress_free_bitmaps(unsigned long *bitmaps[], int slots);
+
 #endif /* SELFTEST_KVM_MEMSTRESS_H */
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 5f1d3173c238c..3632956c6bcf5 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -5,6 +5,7 @@
 #define _GNU_SOURCE
 
 #include <inttypes.h>
+#include <linux/bitmap.h>
 
 #include "kvm_util.h"
 #include "memstress.h"
@@ -320,3 +321,74 @@ void memstress_join_vcpu_threads(int nr_vcpus)
 	for (i = 0; i < nr_vcpus; i++)
 		pthread_join(vcpu_threads[i].thread, NULL);
 }
+
+static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
+{
+	int i;
+
+	for (i = 0; i < slots; i++) {
+		int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
+		int flags = enable ? KVM_MEM_LOG_DIRTY_PAGES : 0;
+
+		vm_mem_region_set_flags(vm, slot, flags);
+	}
+}
+
+void memstress_enable_dirty_logging(struct kvm_vm *vm, int slots)
+{
+	toggle_dirty_logging(vm, slots, true);
+}
+
+void memstress_disable_dirty_logging(struct kvm_vm *vm, int slots)
+{
+	toggle_dirty_logging(vm, slots, false);
+}
+
+void memstress_get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int slots)
+{
+	int i;
+
+	for (i = 0; i < slots; i++) {
+		int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
+
+		kvm_vm_get_dirty_log(vm, slot, bitmaps[i]);
+	}
+}
+
+void memstress_clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
+			       int slots, uint64_t pages_per_slot)
+{
+	int i;
+
+	for (i = 0; i < slots; i++) {
+		int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
+
+		kvm_vm_clear_dirty_log(vm, slot, bitmaps[i], 0, pages_per_slot);
+	}
+}
+
+unsigned long **memstress_alloc_bitmaps(int slots, uint64_t pages_per_slot)
+{
+	unsigned long **bitmaps;
+	int i;
+
+	bitmaps = malloc(slots * sizeof(bitmaps[0]));
+	TEST_ASSERT(bitmaps, "Failed to allocate bitmaps array.");
+
+	for (i = 0; i < slots; i++) {
+		bitmaps[i] = bitmap_zalloc(pages_per_slot);
+		TEST_ASSERT(bitmaps[i], "Failed to allocate slot bitmap.");
+	}
+
+	return bitmaps;
+}
+
+void memstress_free_bitmaps(unsigned long *bitmaps[], int slots)
+{
+	int i;
+
+	for (i = 0; i < slots; i++)
+		free(bitmaps[i]);
+
+	free(bitmaps);
+}
-- 
2.39.1.405.gd4c25cc71f-goog

