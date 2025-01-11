Return-Path: <kvm+bounces-35154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46453A09F67
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:32:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 389823A996C
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BAF7174EF0;
	Sat, 11 Jan 2025 00:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VrU+iic9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B1F1EB48
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555423; cv=none; b=Y0SxlYxqacQWV/ADd1mqGzhK5hnBvwgE9Zj8PaSzxO5B2HwblyYT/W1CPc7jfdWxn93kr3e77ia9WUNGpO8LkEHw13d0Y0HNDCqbGKacq6ItwHtiMv6vE89SKJSqatk4cW+n4IWo6+HSlBSgbG8ucQ+Q7Jd/7q4raUAM8S/uPEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555423; c=relaxed/simple;
	bh=QGDCeJPchThIuDJkjyaSdj0tx8LKDXww3qbAv++T4dI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BrzCDuRZyXkgDAX0ozUjEOapUA5BOdl6S+nc+m/g4Y5pQe1Nwh47+Jm52SM+n6qA/r7h5D/7in7pg7xy0ISQlaotMneOJxkE83sID/Pvu+6oG3rHCWA1O/fYaZ1HgdGnRQmL3emGl0ofNCw/dgQiZOMccMAnQxjsc25S9GaWZOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VrU+iic9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef7fbd99a6so4611643a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555420; x=1737160220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dGMBXjHv8rojpdZoojt2m8NgO/lC7pQdQVMcdYyWG8c=;
        b=VrU+iic91IUAJqF0feegqsp7MK5gqiOe3P79sMVwCGhgtDkgcdhc/1xo8Z7ojZ3RXc
         h9QXREhw4nKwSz+kIRTbKiFQxmEN/7yMQf8IhnJorHq8EsYmyGGIs/R6XOqU1LSNB9Cl
         KcPVwB4tZ+lxUHQWBoLSjzJn1ZPcDLJL/DHrrs0Y0vSQrfMihtqr2149PFTq2PtnFn8y
         hkAHtJ2xhINW2iFZZB8VorLAIqkTqN4vVR8HK2fshSRJ+2NDh2EG7IIfFzBZcZLQyP49
         Belh8CjeB2+5LrXSE9yr2YI4yhd2FpbkkLiPmxV91fQ41t728c+VtANdpdlHgRwhl1Q0
         9N4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555420; x=1737160220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dGMBXjHv8rojpdZoojt2m8NgO/lC7pQdQVMcdYyWG8c=;
        b=eh9BZN84IKsxDvHND5m+Y2O4K0HJRlMDxGTOLPZPPtavlNNNAUEjMVY9C34yDD5nl8
         mzSDSY21juUG8/Z/hLWWTCLdDyCu6oCbPNE209KHY+tgrpO8eulvS/oUtzWy0BsqIEei
         f3uQPpp8G+pXdrOIBHxjh0KQrTGlvnLFMTke7UEHx8k/BjVxFP2kSssJcJOw2i+OJFv9
         L9N3iQyigNEPxdikgd9a3Mz/sIzJUiHHIAFlcPmmiPxHLgaSf061QMuXPI5GLR0y+7ls
         6LsVoyTEoollDPM1LAE1YPT4LZfe5y/ppgyVQowEm87+OLgUyZnV3q+g4kK7Uyag1G/o
         Ydsw==
X-Gm-Message-State: AOJu0Ywcyy6R05FFn7di0Ev+XXxeZHWRtIiZfHoOf7UGfjZlPf5Osyq0
	djP9KBYdb+WXBo+hLnWUQjZdJi9ns59AXTXFOl6IJll5R5QmM23ZEvbuIZDGQ80O0zfv9lRhLo/
	c+w==
X-Google-Smtp-Source: AGHT+IHVaZGEEdb4svmSOuWtVIDeYOOZZPZkNbz2XRwkXTumeQwS5L4YZBF1f95KtvQzctuCleUgMd0qvMo=
X-Received: from pjbrs12.prod.google.com ([2002:a17:90b:2b8c:b0:2ea:6aa8:c4ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e4b:b0:2f4:465d:5c94
 with SMTP id 98e67ed59e1d1-2f548ebb621mr19044455a91.11.1736555420614; Fri, 10
 Jan 2025 16:30:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:51 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-8-seanjc@google.com>
Subject: [PATCH v2 07/20] KVM: selftests: Continuously reap dirty ring while
 vCPU is running
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Continue collecting entries from the dirty ring for the entire time the
vCPU is running.  Collecting exactly once all but guarantees the vCPU will
encounter a "ring full" event and stop.  While testing ring full is
interesting, stopping and doing nothing is not, especially for larger
intervals as the test effectively does nothing for a much longer time.

To balance continuous collection with letting the guest make forward
progress, chunk the interval waiting into 1ms loops (which also makes
the math dead simple).

To maintain coverage for "ring full", collect entries on subsequent
iterations if and only if the ring has been filled at least once.  I.e.
let the ring fill up (if the interval allows), but after that contiuously
empty it so that the vCPU can keep running.

Opportunistically drop unnecessary zero-initialization of "count".

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 63 ++++++++++++++------
 1 file changed, 46 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 5a04a7bd73e0..2aee047b8b1c 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -340,8 +340,6 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	struct kvm_dirty_gfn *cur;
 	uint32_t count = 0;
 
-	dirty_ring_prev_iteration_last_page = dirty_ring_last_page;
-
 	while (true) {
 		cur = &dirty_gfns[*fetch_index % test_dirty_ring_count];
 		if (!dirty_gfn_is_dirtied(cur))
@@ -360,17 +358,11 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	return count;
 }
 
-static void dirty_ring_continue_vcpu(void)
-{
-	pr_info("Notifying vcpu to continue\n");
-	sem_post(&sem_vcpu_cont);
-}
-
 static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 					   void *bitmap, uint32_t num_pages,
 					   uint32_t *ring_buf_idx)
 {
-	uint32_t count = 0, cleared;
+	uint32_t count, cleared;
 
 	/* Only have one vcpu */
 	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vcpu),
@@ -385,9 +377,6 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 	 */
 	TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
 		    "with collected (%u)", cleared, count);
-
-	if (READ_ONCE(dirty_ring_vcpu_ring_full))
-		dirty_ring_continue_vcpu();
 }
 
 static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
@@ -404,7 +393,6 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
 		sem_post(&sem_vcpu_stop);
 		pr_info("Dirty ring full, waiting for it to be collected\n");
 		sem_wait(&sem_vcpu_cont);
-		pr_info("vcpu continues now.\n");
 		WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
 	} else {
 		TEST_ASSERT(false, "Invalid guest sync status: "
@@ -755,11 +743,52 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
 
 	while (iteration < p->iterations) {
+		bool saw_dirty_ring_full = false;
+		unsigned long i;
+
+		dirty_ring_prev_iteration_last_page = dirty_ring_last_page;
+
 		/* Give the vcpu thread some time to dirty some pages */
-		usleep(p->interval * 1000);
-		log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
-					     bmap, host_num_pages,
-					     &ring_buf_idx);
+		for (i = 0; i < p->interval; i++) {
+			usleep(1000);
+
+			/*
+			 * Reap dirty pages while the guest is running so that
+			 * dirty ring full events are resolved, i.e. so that a
+			 * larger interval doesn't always end up with a vCPU
+			 * that's effectively blocked.  Collecting while the
+			 * guest is running also verifies KVM doesn't lose any
+			 * state.
+			 *
+			 * For bitmap modes, KVM overwrites the entire bitmap,
+			 * i.e. collecting the bitmaps is destructive.  Collect
+			 * the bitmap only on the first pass, otherwise this
+			 * test would lose track of dirty pages.
+			 */
+			if (i && host_log_mode != LOG_MODE_DIRTY_RING)
+				continue;
+
+			/*
+			 * For the dirty ring, empty the ring on subsequent
+			 * passes only if the ring was filled at least once,
+			 * to verify KVM's handling of a full ring (emptying
+			 * the ring on every pass would make it unlikely the
+			 * vCPU would ever fill the fing).
+			 */
+			if (READ_ONCE(dirty_ring_vcpu_ring_full))
+				saw_dirty_ring_full = true;
+			if (i && !saw_dirty_ring_full)
+				continue;
+
+			log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
+						     bmap, host_num_pages,
+						     &ring_buf_idx);
+
+			if (READ_ONCE(dirty_ring_vcpu_ring_full)) {
+				pr_info("Dirty ring emptied, restarting vCPU\n");
+				sem_post(&sem_vcpu_cont);
+			}
+		}
 
 		/*
 		 * See vcpu_sync_stop_requested definition for details on why
-- 
2.47.1.613.gc27f4b7a9f-goog


