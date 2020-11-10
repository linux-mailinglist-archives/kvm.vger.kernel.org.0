Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528062AE0FA
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 21:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbgKJUsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 15:48:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731407AbgKJUsT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 15:48:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605041298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lrh1uhDsoNqUz6VM2KlP0rXDEZNjcKGUPq/7PT+EREI=;
        b=fuwy0fY7rckAu2iHKCGBcearnRN/6zUX/Q71lnSCMhblw0qGG7N0zwP1Zh97MElxjCwSUd
        dISgS5my7HEB1Kqds8Ci2734jrdNDB8W/tYV7Yrcf4otxiV8ZQJEJxgD3F24RN6ZCefVKB
        e76quPK6zNIsIbAfWjKeOcNV/MGTWks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-bl4owIkJNpyRimrDGDdTtg-1; Tue, 10 Nov 2020 15:48:15 -0500
X-MC-Unique: bl4owIkJNpyRimrDGDdTtg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E30B1882FC1;
        Tue, 10 Nov 2020 20:48:14 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DE731002C28;
        Tue, 10 Nov 2020 20:48:12 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 2/8] KVM: selftests: Remove deadcode
Date:   Tue, 10 Nov 2020 21:47:56 +0100
Message-Id: <20201110204802.417521-3-drjones@redhat.com>
In-Reply-To: <20201110204802.417521-1-drjones@redhat.com>
References: <20201110204802.417521-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nothing sets USE_CLEAR_DIRTY_LOG anymore, so anything it surrounds
is dead code.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 44 -------------------
 1 file changed, 44 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 85c9b8f73142..b9115e8ef0ed 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -88,10 +88,6 @@ static void *vcpu_worker(void *data)
 	return NULL;
 }
 
-#ifdef USE_CLEAR_DIRTY_LOG
-static u64 dirty_log_manual_caps;
-#endif
-
 static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 		     uint64_t phys_offset, int wr_fract)
 {
@@ -106,10 +102,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	struct timespec get_dirty_log_total = (struct timespec){0};
 	struct timespec vcpu_dirty_total = (struct timespec){0};
 	struct timespec avg;
-#ifdef USE_CLEAR_DIRTY_LOG
-	struct kvm_enable_cap cap = {};
-	struct timespec clear_dirty_log_total = (struct timespec){0};
-#endif
 
 	vm = create_vm(mode, nr_vcpus, guest_percpu_mem_size);
 
@@ -120,12 +112,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
 	bmap = bitmap_alloc(host_num_pages);
 
-#ifdef USE_CLEAR_DIRTY_LOG
-	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
-	cap.args[0] = dirty_log_manual_caps;
-	vm_enable_cap(vm, &cap);
-#endif
-
 	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
 	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
 
@@ -189,18 +175,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 						   ts_diff);
 		pr_info("Iteration %lu get dirty log time: %ld.%.9lds\n",
 			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
-
-#ifdef USE_CLEAR_DIRTY_LOG
-		clock_gettime(CLOCK_MONOTONIC, &start);
-		kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
-				       host_num_pages);
-
-		ts_diff = timespec_diff_now(start);
-		clear_dirty_log_total = timespec_add(clear_dirty_log_total,
-						     ts_diff);
-		pr_info("Iteration %lu clear dirty log time: %ld.%.9lds\n",
-			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
-#endif
 	}
 
 	/* Tell the vcpu thread to quit */
@@ -220,13 +194,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 		iterations, get_dirty_log_total.tv_sec,
 		get_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
 
-#ifdef USE_CLEAR_DIRTY_LOG
-	avg = timespec_div(clear_dirty_log_total, iterations);
-	pr_info("Clear dirty log over %lu iterations took %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
-		iterations, clear_dirty_log_total.tv_sec,
-		clear_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
-#endif
-
 	free(bmap);
 	free(vcpu_threads);
 	ucall_uninit(vm);
@@ -284,17 +251,6 @@ int main(int argc, char *argv[])
 	int opt, i;
 	int wr_fract = 1;
 
-#ifdef USE_CLEAR_DIRTY_LOG
-	dirty_log_manual_caps =
-		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
-	if (!dirty_log_manual_caps) {
-		print_skip("KVM_CLEAR_DIRTY_LOG not available");
-		exit(KSFT_SKIP);
-	}
-	dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
-				  KVM_DIRTY_LOG_INITIALLY_SET);
-#endif
-
 #ifdef __x86_64__
 	guest_mode_init(VM_MODE_PXXV48_4K, true, true);
 #endif
-- 
2.26.2

