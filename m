Return-Path: <kvm+bounces-33799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEDF49F1BBA
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:10:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DEE317A041E
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1882186E58;
	Sat, 14 Dec 2024 01:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OihDxFjC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA95169397
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138458; cv=none; b=sAHqZLNVzNadbtYRosbfbgmYVkTiSQ9vHBvBEaGIX4F2MSka7EWRLOi/ZeQqSR25J9o5HZLGJ4n7YMYCPPH+xNYWzVr+0jUI6ZshO10kePzzYsGAZVrHJgT74pVtjjp13tfz43hWm1vZKoRoc5jhb1c154kSUYdjMHrf+vtQt24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138458; c=relaxed/simple;
	bh=ZXFEpYMLr4IBsF5/Te2IiwI3CIA8N20TTqGyTm77KTs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fsqoNlQLhX/AHsCF+EdyY0wKvSVqeQCiePEn5oKNZirLgmKEZqsA/IRQ/G+9uZqO4tNKx++rO6X2+Y0Qh5fCNYLDXQmvxiJ+5wHTtStqGKOyq7anR14CPi3xrzHSeUAREI7iVs8kRF/MnvweC9h4XGhc2WuYDmcP2HREEkOmUok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OihDxFjC; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7f712829f05so1527138a12.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138456; x=1734743256; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=opd7yOFDvSrhfHppvwX3Nzd5Pe0NZ+57ED0TYTOUSNg=;
        b=OihDxFjCP9fgv1g+wBnU3wZ1te0uVrFiVMLrlQzbiy8X5bvLVm/xRtzojw5voMImXN
         g7xre5s4BAKNPKwgKBhJd9XEAHjFQWgXLh8qOOk8jNrQe4stfI+Fg1+wvlFD3XPZq4Vf
         /vWom3F91ULJ8F2ytbkjcdm/prJ7i6dXt16580y1vwLc7oZfgdNrltVnhl7v0U3JTg6Z
         LeU/Lgd3FKyfvcbDoUTXrRsxlGthvvKCN0DNAC/n/Zgko2Qll9nt0PX/Cv9jePHh06I7
         0WgkpAH3Pg/M/7VXmbConhCQA3u3TFw3mnltknnOWMWqsJzk88u7twUDD7I3xDPT/kSu
         l9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138456; x=1734743256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=opd7yOFDvSrhfHppvwX3Nzd5Pe0NZ+57ED0TYTOUSNg=;
        b=pGL+pGD7GtXRMbD0TvW37ZxlQFddL/PsjFMrs8/7ccnx3Vcg8kJ4p4CmI6Soiyp1Hs
         mB5B/GO0AdkOHC1jN4bMekYTtr7VKRNR+Cyf5NPMKVuoVqN08oNJZQiPnAITTkjZOcq1
         ft8aZhsZWCBmUz7+8C5W3Lf59Ez4kgktLvLUT9N0Yyv7M5qGWF8gHi1WZcHvDYdhbut6
         o8igG4E/Y6HcV4f75Q2D+bWU9IqFe6MNDUtXGBnbp8CIgnlK2UhpISIjb1P2W5WAR8UK
         ki78JiARGbeOJvrjIgKZKIPpmzZlsr6xZ65XYLppxuoHpSE/igYLWFwiCPskBm7K4xg7
         HMKQ==
X-Gm-Message-State: AOJu0YyCkmNcE1kbDCDsFgzPb5kAxlrIOBzg0FqGOGtXVcAZfQtb+S3S
	NJp7Gnp5rsBiYwgaUTjPGWJZj0q8bIABvPxtf7BsWUM56eFrFj3Q8NMv+EJlusjZb/wS+jq1XC1
	kKA==
X-Google-Smtp-Source: AGHT+IHJnU2Z0jejJt0UsQNSm1boPEU7u8IfB6VxZK1FebykXxv6VAPXu+SYcUA64noqLsO90ouhS+F2fsc=
X-Received: from pjtu8.prod.google.com ([2002:a17:90a:c888:b0:2d3:d4ca:5fb0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:944:b0:215:65f3:27f2
 with SMTP id d9443c01a7336-21892999322mr82028905ad.8.1734138456660; Fri, 13
 Dec 2024 17:07:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:08 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-8-seanjc@google.com>
Subject: [PATCH 07/20] KVM: selftests: Continuously reap dirty ring while vCPU
 is running
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


