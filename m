Return-Path: <kvm+bounces-33806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D989F1BC7
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:12:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F060716357E
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1EE1A8F86;
	Sat, 14 Dec 2024 01:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CV736Lo7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7A31991A9
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138471; cv=none; b=E/sYtwYrJwkN1Ar1IWnFwkczem/SOpQjD8tfwZWIsZJs+ZcgmPFLuNELgl4+UHnsmJegQrEEpxzbQvMuBSj3ZPXaRRhVvqnh1yclDea+vqMzOSkeQa/V9vb9SxlVru3QkJgH6PsJl4qdp0Ox2YSZ7JmI4BS2uJlM8t2Q+iXcHDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138471; c=relaxed/simple;
	bh=uHBTQ1MR91fKk9C6yhATyFnfaltG5kAv8HeS2SlSvw8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NPve8LUs1+yXMX2HI1EWHQle5OWvEfU3fTVVLzzlM7DQTS0lH8cw+RjLbHsZZlkjDf1tX/osE2ZE7hp1p/pcPU7Rh+8t3KUzdyoviczU2UNi+TrltmDr1Q3j7B0KHJ8kbW9pRFOFEnZN0S3lTxjvNVHfezVJwkae5CqG6d2LXig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CV736Lo7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee5668e09bso2185967a91.3
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138468; x=1734743268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k/WoCua5rXlbcFyljn1VWee9B6n0EVLZHTgnpdWpUBU=;
        b=CV736Lo7BjlFb2B/S12bJOTcbliN+/aMHPuIkYx7v9qG6rrLYB2Shjb8HgMYjE7KKO
         VAjkAlEBzA8T6ACINzyzlmrnfchrI2TQdKrKM02vUR3VKgyiT18TRk1uxFTw9tMTrvsp
         xZ52jNqX1TVPsMrkly5CtN1+9lQ7cuz54DygQZfyQSqy+hrlgldhfaJePukKmgTUqcYI
         pFCMXmpjg6k/Bm0+KssKhn1moQSFJAHM9Bq0oGoow4/mPGdgDAB7WfyGIwDHM28Mjcfq
         NOM1JDPhX8NX4N6NT1B8qN5UA2DJ2AR7aRDAJ+201xRRAIIj4SfO6Wv/3uTSsrfIo/93
         bJOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138468; x=1734743268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k/WoCua5rXlbcFyljn1VWee9B6n0EVLZHTgnpdWpUBU=;
        b=WpnIaeEzAcWXl7AOANfH0WPg5c1jyrRZhpsdaunDQc5j5xS9hCPKhyk9L+AuGSnkbz
         FPlf8iuAzLFHeV+Qfqv4jg2QYNFJtTt9IEccDTFcnR/QKD6myM/lOlYqUjNa3zdqqVWm
         IY6rsWt4wy4na52lE3G4jgo4w6SySZKNSoc4aJ6OQCZbKBpwD/Vn65TO9eFYsaBqFaNs
         ZVDHPQ6FRlD2+UeZpxOv8NgtfR/nYvn/3gwlOEnp6adajSsgjpP8YziceRTL+j24k/Jz
         CGVxPRvYPw5Q50t6DyHaE5NCAagC3LclUMUJGFYS71QSUwJaqcvq6Nj9nI1cT0BSAs4W
         okjQ==
X-Gm-Message-State: AOJu0YwJvKu85YiNM5f4Z4TOUGc/xBjy+RE2yjkrvtSfG6v3V51jTVgf
	Q0P/TvAoNgRj8AoiJZzhxO8qktMo9PQ7djzRFRRA3eFFWuMERA4NrzyNrTLyGszYk7a+WL5eExF
	uLA==
X-Google-Smtp-Source: AGHT+IFOeCbT2lDeMqrjnzPUROIbOyM0ueRQ9T8pig2LcktQB+XboaiyKqT5ZsgtmelIG0HO7XsfyTiWA8U=
X-Received: from pjbph7.prod.google.com ([2002:a17:90b:3bc7:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2807:b0:2ee:fd53:2b03
 with SMTP id 98e67ed59e1d1-2f2900a66f4mr6687922a91.25.1734138468592; Fri, 13
 Dec 2024 17:07:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:15 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-15-seanjc@google.com>
Subject: [PATCH 14/20] KVM: selftests: Collect *all* dirty entries in each
 dirty_log_test iteration
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Collect all dirty entries during each iteration of dirty_log_test by
doing a final collection after the vCPU has been stopped.  To deal with
KVM's destructive approach to getting the dirty bitmaps, use a second
bitmap for the post-stop collection.

Collecting all entries that were dirtied during an iteration simplifies
the verification logic *and* improves test coverage.

  - If a page is written during iteration X, but not seen as dirty until
    X+1, the test can get a false pass if the page is also written during
    X+1.

  - If a dirty page used a stale value from a previous iteration, the test
    would grant a false pass.

  - If a missed dirty log occurs in the last iteration, the test would fail
    to detect the issue.

E.g. modifying mark_page_dirty_in_slot() to dirty an unwritten gfn:

	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
		unsigned long rel_gfn = gfn - memslot->base_gfn;
		u32 slot = (memslot->as_id << 16) | memslot->id;

		if (!vcpu->extra_dirty &&
		    gfn_to_memslot(kvm, gfn + 1) == memslot) {
			vcpu->extra_dirty = true;
			mark_page_dirty_in_slot(kvm, memslot, gfn + 1);
		}
		if (kvm->dirty_ring_size && vcpu)
			kvm_dirty_ring_push(vcpu, slot, rel_gfn);
		else if (memslot->dirty_bitmap)
			set_bit_le(rel_gfn, memslot->dirty_bitmap);
	}

isn't detected with the current approach, even with an interval of 1ms
(when running nested in a VM; bare metal would be even *less* likely to
detect the bug due to the vCPU being able to dirty more memory).  Whereas
collecting all dirty entries consistently detects failures with an
interval of 700ms or more (the longer interval means a higher probability
of an actual write to the prematurely-dirtied page).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 149 ++++++-------------
 1 file changed, 45 insertions(+), 104 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index fe8cc7f77e22..3a4e411353d7 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -134,7 +134,6 @@ static uint64_t host_num_pages;
 /* For statistics only */
 static uint64_t host_dirty_count;
 static uint64_t host_clear_count;
-static uint64_t host_track_next_count;
 
 /* Whether dirty ring reset is requested, or finished */
 static sem_t sem_vcpu_stop;
@@ -422,15 +421,6 @@ struct log_mode {
 	},
 };
 
-/*
- * We use this bitmap to track some pages that should have its dirty
- * bit set in the _next_ iteration.  For example, if we detected the
- * page value changed to current iteration but at the same time the
- * page bit is cleared in the latest bitmap, then the system must
- * report that write in the next get dirty log call.
- */
-static unsigned long *host_bmap_track;
-
 static void log_modes_dump(void)
 {
 	int i;
@@ -491,79 +481,52 @@ static void *vcpu_worker(void *data)
 	return NULL;
 }
 
-static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
+static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long **bmap)
 {
 	uint64_t page, nr_dirty_pages = 0, nr_clean_pages = 0;
 	uint64_t step = vm_num_host_pages(mode, 1);
-	uint64_t min_iter = 0;
 
 	for (page = 0; page < host_num_pages; page += step) {
 		uint64_t val = *(uint64_t *)(host_test_mem + page * host_page_size);
+		bool bmap0_dirty = __test_and_clear_bit_le(page, bmap[0]);
 
-		/* If this is a special page that we were tracking... */
-		if (__test_and_clear_bit_le(page, host_bmap_track)) {
-			host_track_next_count++;
-			TEST_ASSERT(test_bit_le(page, bmap),
-				    "Page %"PRIu64" should have its dirty bit "
-				    "set in this iteration but it is missing",
-				    page);
-		}
-
-		if (__test_and_clear_bit_le(page, bmap)) {
+		/*
+		 * Ensure both bitmaps are cleared, as a page can be written
+		 * multiple times per iteration, i.e. can show up in both
+		 * bitmaps, and the dirty ring is additive, i.e. doesn't purge
+		 * bitmap entries from previous collections.
+		 */
+		if (__test_and_clear_bit_le(page, bmap[1]) || bmap0_dirty) {
 			nr_dirty_pages++;
 
 			/*
-			 * If the bit is set, the value written onto
-			 * the corresponding page should be either the
-			 * previous iteration number or the current one.
+			 * If the page is dirty, the value written to memory
+			 * should be the current iteration number.
 			 */
-			if (val == iteration || val == iteration - 1)
+			if (val == iteration)
 				continue;
 
 			if (host_log_mode == LOG_MODE_DIRTY_RING) {
-				if (val == iteration - 2 && min_iter <= iteration - 2) {
-					/*
-					 * Short answer: this case is special
-					 * only for dirty ring test where the
-					 * page is the last page before a kvm
-					 * dirty ring full in iteration N-2.
-					 *
-					 * Long answer: Assuming ring size R,
-					 * one possible condition is:
-					 *
-					 *      main thr       vcpu thr
-					 *      --------       --------
-					 *    iter=1
-					 *                   write 1 to page 0~(R-1)
-					 *                   full, vmexit
-					 *    collect 0~(R-1)
-					 *    kick vcpu
-					 *                   write 1 to (R-1)~(2R-2)
-					 *                   full, vmexit
-					 *    iter=2
-					 *    collect (R-1)~(2R-2)
-					 *    kick vcpu
-					 *                   write 1 to (2R-2)
-					 *                   (NOTE!!! "1" cached in cpu reg)
-					 *                   write 2 to (2R-1)~(3R-3)
-					 *                   full, vmexit
-					 *    iter=3
-					 *    collect (2R-2)~(3R-3)
-					 *    (here if we read value on page
-					 *     "2R-2" is 1, while iter=3!!!)
-					 *
-					 * This however can only happen once per iteration.
-					 */
-					min_iter = iteration - 1;
+				/*
+				 * The last page in the ring from this iteration
+				 * or the previous can be written with the value
+				 * from the previous iteration (relative to the
+				 * last page's iteration), as the value to be
+				 * written may be cached in a CPU register.
+				 */
+				if (page == dirty_ring_last_page ||
+				    page == dirty_ring_prev_iteration_last_page)
 					continue;
-				} else if (page == dirty_ring_last_page ||
-					   page == dirty_ring_prev_iteration_last_page) {
-					/*
-					 * Please refer to comments in
-					 * dirty_ring_last_page.
-					 */
-					continue;
-				}
+			} else if (!val && iteration == 1 && bmap0_dirty) {
+				/*
+				 * When testing get+clear, the dirty bitmap
+				 * starts with all bits set, and so the first
+				 * iteration can observe a "dirty" page that
+				 * was never written, but only in the first
+				 * bitmap (collecting the bitmap also clears
+				 * all dirty pages).
+				 */
+				continue;
 			}
 
 			TEST_FAIL("Dirty page %lu value (%lu) != iteration (%lu) "
@@ -574,36 +537,13 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 			nr_clean_pages++;
 			/*
 			 * If cleared, the value written can be any
-			 * value smaller or equals to the iteration
-			 * number.  Note that the value can be exactly
-			 * (iteration-1) if that write can happen
-			 * like this:
-			 *
-			 * (1) increase loop count to "iteration-1"
-			 * (2) write to page P happens (with value
-			 *     "iteration-1")
-			 * (3) get dirty log for "iteration-1"; we'll
-			 *     see that page P bit is set (dirtied),
-			 *     and not set the bit in host_bmap_track
-			 * (4) increase loop count to "iteration"
-			 *     (which is current iteration)
-			 * (5) get dirty log for current iteration,
-			 *     we'll see that page P is cleared, with
-			 *     value "iteration-1".
+			 * value smaller than the iteration number.
 			 */
-			TEST_ASSERT(val <= iteration,
-				    "Clear page %lu value (%lu) > iteration (%lu) "
+			TEST_ASSERT(val < iteration,
+				    "Clear page %lu value (%lu) >= iteration (%lu) "
 				    "(last = %lu, prev_last = %lu)",
 				    page, val, iteration, dirty_ring_last_page,
 				    dirty_ring_prev_iteration_last_page);
-			if (val == iteration) {
-				/*
-				 * This page is _just_ modified; it
-				 * should report its dirtyness in the
-				 * next run
-				 */
-				__set_bit_le(page, host_bmap_track);
-			}
 		}
 	}
 
@@ -639,7 +579,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_params *p = arg;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	unsigned long *bmap;
+	unsigned long *bmap[2];
 	uint32_t ring_buf_idx = 0;
 	int sem_val;
 
@@ -695,8 +635,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
 
-	bmap = bitmap_zalloc(host_num_pages);
-	host_bmap_track = bitmap_zalloc(host_num_pages);
+	bmap[0] = bitmap_zalloc(host_num_pages);
+	bmap[1] = bitmap_zalloc(host_num_pages);
 
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
@@ -723,7 +663,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	WRITE_ONCE(host_quit, false);
 	host_dirty_count = 0;
 	host_clear_count = 0;
-	host_track_next_count = 0;
 	WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
 
 	/*
@@ -774,7 +713,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				continue;
 
 			log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
-						     bmap, host_num_pages,
+						     bmap[0], host_num_pages,
 						     &ring_buf_idx);
 		}
 
@@ -804,6 +743,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		 * the flush of the last page, and since we handle the last
 		 * page specially verification will succeed anyway.
 		 */
+		log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
+					     bmap[1], host_num_pages,
+					     &ring_buf_idx);
 		vm_dirty_log_verify(mode, bmap);
 
 		/*
@@ -824,12 +766,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	pthread_join(vcpu_thread, NULL);
 
-	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
-		"track_next (%"PRIu64")\n", host_dirty_count, host_clear_count,
-		host_track_next_count);
+	pr_info("Total bits checked: dirty (%lu), clear (%lu)\n",
+		host_dirty_count, host_clear_count);
 
-	free(bmap);
-	free(host_bmap_track);
+	free(bmap[0]);
+	free(bmap[1]);
 	kvm_vm_free(vm);
 }
 
-- 
2.47.1.613.gc27f4b7a9f-goog


