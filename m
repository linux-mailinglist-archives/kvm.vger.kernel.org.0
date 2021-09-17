Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C0040FEB4
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 19:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbhIQRi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 13:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbhIQRi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 13:38:26 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDA9C061574
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 10:37:03 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id z127-20020a633385000000b002618d24cfacso8278841pgz.16
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 10:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sdn1PmaQtPltchy5ksgHmZbBH0mJaPBGIRQI080ax7I=;
        b=QbLFISl0tUzRa5q4FW67gOMxv/oMtQzPA9wC2QyXxneAlqeT7adkfMrx4G9J5ylN4/
         Ozp0KA2zdDwp4FNEylzqucBpfHnRRJbfxhoziiu+YfsI71x2655i30IGf5LnQmMjHEUL
         IyZZWinkI4rx+OSoNDM+IYfpl6twO5zBTPmg33T4rdstHOFOGyhCVK82ldTm+Xe08/8U
         5OuO9ZuHcYZrKDKFL10V5mIQfEqDMDuIgrZZcZliKRLrFrTxZzt3Wd7H0/G5oJeOvEfv
         lxtKWpBFO0CSeNZmvA8lrsbDpd5rr6DyEnIRNOdhTH/VllbwDLnmqcqwVN3i8ivdxMAv
         Kvqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sdn1PmaQtPltchy5ksgHmZbBH0mJaPBGIRQI080ax7I=;
        b=cabVUlHt7zcn9G/77t8AeG+1TtaZZ2ciancRoFJOnTPXh1agkYfOmB3HsyIIlKZ3ae
         iV5s526WpCdGOMzz390YNPqfcmABEQkPxOA3tG+6g3Hu/YB103Pxa2Kep7iNnQe0RhQm
         hOOCKpyL6w0fbrMzRVUjfP3wcafYZ9PYuLnqQ78iLD/0OZ+C8MeKQOpc03hZW2aPCkWY
         E0/czVcoq8cYtjzhwE6q7ZnyiKL6R6odGYv+IrzprFI/1YJo5usIqVzg6opoSFrGG1eh
         NmYgjORKyFG8Fp4/jppWU/MSDbzwB2oVfDXewx6mQboNBrRC0fJrSdy4F60uESwI4qUo
         t3Pw==
X-Gm-Message-State: AOAM532FiySrhqNew+R3GsXlYkMYd+IiEv/sZb5MKGSdfPhnNvmThdV3
        9XoC77lQcwc94PnPRGGsj4nVZi3zYFZkFQ==
X-Google-Smtp-Source: ABdhPJxrQ0jLDBEV9oXeqFMT17SE79FyD9jzoHntaZAPJqKrq4Vwnq49pLqjYDsIuAPcBBOx2bHz/Wue9FMhzA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:7602:b0:13a:2968:a37 with SMTP id
 k2-20020a170902760200b0013a29680a37mr10638097pll.30.1631900223438; Fri, 17
 Sep 2021 10:37:03 -0700 (PDT)
Date:   Fri, 17 Sep 2021 17:36:57 +0000
In-Reply-To: <20210917173657.44011-1-dmatlack@google.com>
Message-Id: <20210917173657.44011-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20210917173657.44011-1-dmatlack@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 3/3] KVM: selftests: Create a separate dirty bitmap per slot
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The calculation to get the per-slot dirty bitmap was incorrect leading
to a buffer overrun. Fix it by splitting out the dirty bitmap into a
separate bitmap per slot.

Fixes: 609e6202ea5f ("KVM: selftests: Support multiple slots in dirty_log_perf_test")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 54 +++++++++++++------
 1 file changed, 39 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 5ad9f2bc7369..c981f93e2043 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -118,42 +118,64 @@ static inline void disable_dirty_logging(struct kvm_vm *vm, int slots)
 	toggle_dirty_logging(vm, slots, false);
 }
 
-static void get_dirty_log(struct kvm_vm *vm, int slots, unsigned long *bitmap,
-			  uint64_t nr_pages)
+static void get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int slots)
 {
-	uint64_t slot_pages = nr_pages / slots;
 	int i;
 
 	for (i = 0; i < slots; i++) {
 		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
-		unsigned long *slot_bitmap = bitmap + i * slot_pages;
 
-		kvm_vm_get_dirty_log(vm, slot, slot_bitmap);
+		kvm_vm_get_dirty_log(vm, slot, bitmaps[i]);
 	}
 }
 
-static void clear_dirty_log(struct kvm_vm *vm, int slots, unsigned long *bitmap,
-			    uint64_t nr_pages)
+static void clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
+			    int slots, uint64_t pages_per_slot)
 {
-	uint64_t slot_pages = nr_pages / slots;
 	int i;
 
 	for (i = 0; i < slots; i++) {
 		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
-		unsigned long *slot_bitmap = bitmap + i * slot_pages;
 
-		kvm_vm_clear_dirty_log(vm, slot, slot_bitmap, 0, slot_pages);
+		kvm_vm_clear_dirty_log(vm, slot, bitmaps[i], 0, pages_per_slot);
 	}
 }
 
+static unsigned long **alloc_bitmaps(int slots, uint64_t pages_per_slot)
+{
+	unsigned long **bitmaps;
+	int i;
+
+	bitmaps = malloc(slots * sizeof(bitmaps[0]));
+	TEST_ASSERT(bitmaps, "Failed to allocate bitmaps array.");
+
+	for (i = 0; i < slots; i++) {
+		bitmaps[i] = bitmap_alloc(pages_per_slot);
+		TEST_ASSERT(bitmaps[i], "Failed to allocate slot bitmap.");
+	}
+
+	return bitmaps;
+}
+
+static void free_bitmaps(unsigned long *bitmaps[], int slots)
+{
+	int i;
+
+	for (i = 0; i < slots; i++)
+		free(bitmaps[i]);
+
+	free(bitmaps);
+}
+
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *p = arg;
 	pthread_t *vcpu_threads;
 	struct kvm_vm *vm;
-	unsigned long *bmap;
+	unsigned long **bitmaps;
 	uint64_t guest_num_pages;
 	uint64_t host_num_pages;
+	uint64_t pages_per_slot;
 	int vcpu_id;
 	struct timespec start;
 	struct timespec ts_diff;
@@ -171,7 +193,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
 	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
-	bmap = bitmap_alloc(host_num_pages);
+	pages_per_slot = host_num_pages / p->slots;
+
+	bitmaps = alloc_bitmaps(p->slots, pages_per_slot);
 
 	if (dirty_log_manual_caps) {
 		cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
@@ -239,7 +263,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
 
 		clock_gettime(CLOCK_MONOTONIC, &start);
-		get_dirty_log(vm, p->slots, bmap, host_num_pages);
+		get_dirty_log(vm, bitmaps, p->slots);
 		ts_diff = timespec_elapsed(start);
 		get_dirty_log_total = timespec_add(get_dirty_log_total,
 						   ts_diff);
@@ -248,7 +272,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 		if (dirty_log_manual_caps) {
 			clock_gettime(CLOCK_MONOTONIC, &start);
-			clear_dirty_log(vm, p->slots, bmap, host_num_pages);
+			clear_dirty_log(vm, bitmaps, p->slots, pages_per_slot);
 			ts_diff = timespec_elapsed(start);
 			clear_dirty_log_total = timespec_add(clear_dirty_log_total,
 							     ts_diff);
@@ -281,7 +305,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			clear_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
 	}
 
-	free(bmap);
+	free_bitmaps(bitmaps, p->slots);
 	free(vcpu_threads);
 	perf_test_destroy_vm(vm);
 }
-- 
2.33.0.464.g1972c5931b-goog

