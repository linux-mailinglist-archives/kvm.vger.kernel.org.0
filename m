Return-Path: <kvm+bounces-35161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F414BA09F74
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29A323A5A86
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C094DDD2;
	Sat, 11 Jan 2025 00:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MAtyv4OT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B626D190485
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555434; cv=none; b=Zwi5oGKAxPjm7Bs3i00kG1bys1vRlbLqp2E5jG0oFbRybkaQdoXVol0e1weiucCwBV/4Vk2BJVI6X96jrSMSFRDmqmn2Zao2dJ+sR5SrdAqVpv3nfgG08otI1z5yl0GZXJK9oFmNLyG0l4Bi6IaPgdKz+vshwUmoeAlkgA9CF34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555434; c=relaxed/simple;
	bh=uHBTQ1MR91fKk9C6yhATyFnfaltG5kAv8HeS2SlSvw8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gN9w8FPOpqOUilMqz36gP+5HuxSXXNmzv+WN8yHxxAnyBibUiliL+BqFXhfGNxryWkrl0gnpLsAEmsLuVwXSS9ABSrYgfuXlxAOu1kMM2DezUXf1jSHDUxCCt9JE4anrxch3ddY6DoZZVsW4A8Sq4XqZmdoUQMlvWX0HNlo8pIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MAtyv4OT; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef8c7ef51dso4674335a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555432; x=1737160232; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k/WoCua5rXlbcFyljn1VWee9B6n0EVLZHTgnpdWpUBU=;
        b=MAtyv4OTS14pbVkOSVFbLYaY73k4kwYckgsh676RMpoUfmTCS29/x7zojZWCBSTKnP
         w3Fse3Ru80iK5gAm/fNOAR+3Pjn+COSe3tJIshzzKfI1J2n2BWr4nNoIU503fBc/t0s7
         zftLG7uPmRUd44UPMBJwmp4NBicmRES5mATq8Q4te3/+WCQrvr9zIEvj7IUV3fXK8SuY
         ZIcMm6ik+8WHv1z3Y/DemOVmH9R4kzc/NsE/DXyhAWC1h5CZ/8hk0B15cFYqJC+8EiSt
         B7BqSv0Fo1Hu29n1EPH4YIorCr6NdNAgwX6AnIMZN5Ff9tDbVz28ruwSGeokwIrZMEvs
         k+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555432; x=1737160232;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k/WoCua5rXlbcFyljn1VWee9B6n0EVLZHTgnpdWpUBU=;
        b=u1NLIzD5vbmQ01bu7p6iuWbafT2w57QyUMwMZdNBblX6M4B6xrraFOwnSSrYX9vmQt
         Aeycq/xLFaLkOLXFEwQjRq7FCs3py6wWgT940wJ2TmQJF+a9wx0qEYjFJQNPlv15xicw
         l8OXanvobibZ8n3HxEHIHPRr0G2L/XteQML0hdwwdgAiJpkHSXFReD5qDvN2QTmW6T4+
         2ZKZDYN/pm4NjvNb2G8rgMsdwtEycnBPcm0dWgmFFaq/fKJwjt0Nj8LlCFCxgCjWjER8
         O2hR+onCy6MDX2K+6vs3Q9y4NbOEkV3d8B7erBK13sI0A9vdFzrCY1L9cC7r0Yp5ayvZ
         1l5A==
X-Gm-Message-State: AOJu0YyhQ5zRVPeTwzoIiAnenh0URnlJRE00syHJGrFuqE/jZgo8eXOF
	1+ILDOJ0+/nMNKGLczAyMEdjW1uKv62lYkorJUXTlw6q7pgGwca2J/xm3ZH9IavHDdbQfWitPH2
	uMQ==
X-Google-Smtp-Source: AGHT+IGfAsD82MPTOooMUIuLAPI+tMIahrYpTh9+mHzzcwIpUsN+dIK8wbKd4wg7pMjxdHs+5rAQwgbUyRw=
X-Received: from pjbov6.prod.google.com ([2002:a17:90b:2586:b0:2ef:9b30:69d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c106:b0:2ee:7e53:bfae
 with SMTP id 98e67ed59e1d1-2f55836e87amr12011326a91.10.1736555432128; Fri, 10
 Jan 2025 16:30:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:58 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-15-seanjc@google.com>
Subject: [PATCH v2 14/20] KVM: selftests: Collect *all* dirty entries in each
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


