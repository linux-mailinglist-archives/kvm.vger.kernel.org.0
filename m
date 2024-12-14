Return-Path: <kvm+bounces-33802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 685B49F1BBF
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D92A163AB5
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939AB1917D8;
	Sat, 14 Dec 2024 01:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="skf3jYEx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F5718FC79
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138463; cv=none; b=fDSqjGaOq5p4iI4oUVyRBQuc4xn9rptHa9AiPrL8HEGbAsYaJHAxI4BlmRYCqghFufCIm5MUES1r/JfiB1wZJYC9csjPWdt2CqZuPUXlwwZDrwCk1N80KZsLDSA27TZV1QonAmc+AbsuVCGbUFd19FZUbluyeRUk7HKdJ/5KyR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138463; c=relaxed/simple;
	bh=ddHNUXZbIAzXk6KHAJvbKhibmhSrWuehmK8bBf359Vg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oPvsjKfsVMH8L+RIDt3ZFC35EM5bKEv4DEn3sedPeV8sZlWwvSYrmaZUW1pzwi4/lS4kFp+jynr5f+laL0X4RRD7r/I7zO2SlXoxAK9cdYAuCS39EplDR2MM51ni3LvL15BdHxytv2eYMCbghHkTpY4pklFZ8KQasTZ32Yh2drs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=skf3jYEx; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-8019f05c61aso1565213a12.3
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138461; x=1734743261; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gikAV9mXGZZ8J4IjiEskNOiSEWIeGcim2h3UhPVuaNA=;
        b=skf3jYEx4mZtUUlGxcU23oH9puFDyLQmijhF1Bq3NsNv9MBnRXrOLzGkwylP2b0Ga5
         TRmS0zr1dMXI0ZyFKKe+Fg0UO/zn3nKNscSTTrdPuQEGWHiosZiOCMz+roiogOndXqT4
         bdZW3+opHyghacYszdjwQ+ROYD93Iaf1/IDUzqmoEImrPBvh/EfuAOx5E8e5/yvzGKU8
         XW6wZrnMA+F8LXXHEVQ26St9eyNmx3M0jOUJDHf85ADzPGBoi0av5k828iedV1SSIcs7
         IKnLtMjM3vjeBJp6kbIHNt86zaUuFurJ6eopUMSk2zylaE8Na5zPRWTQe/Z3Bya0L39C
         DmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138461; x=1734743261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gikAV9mXGZZ8J4IjiEskNOiSEWIeGcim2h3UhPVuaNA=;
        b=VQmV6TBKw3BgjmtPjuDmuaNmmLdP7JZmBSHjJ7Sbez8zrsqtfveJXEvPrciA+38akZ
         fVotSjbLLZFvTsOcRCefO5vHN++m3ivU18SLlB97Jl8OOFYyCzY3akqPZZ/hlYy5qZg7
         9ZRxWmIgTj6w95nt6vA8Mx0k5QMvN3Qv2jc84v2NBdeOcLSj3AEMYIN6xxl+G+WUT2CJ
         q8XtY5nTsJeP0I0eMrfWHfZATm7DBNh2LDbjOicOqhQvsET7ictDc6kIHMQTBe6CMXqY
         PcgAiT9f6OXmuNtuuPG16YNLo7wZu3dwturkYmLzZokwTu+3BFGv/UpYddzHxe2pdwjc
         3Qpg==
X-Gm-Message-State: AOJu0YzIfBji6SYhzyt7BfuxJOq+NMzr7oRkZRPA/Gka5YTkKFqpVr7I
	y0daP9g1+q8p0UempHzmIjHMhftwEab5onhZAnMAwSEJz3PB8E7GEtB9XWzRVOQjgWmEzKfLnCw
	N3A==
X-Google-Smtp-Source: AGHT+IF3TqbeoScu7UoYVm9frXxX3k5VLFgkgBtc5cIYr2EdAAom1j5OMBSTm/VohiO94wCYgNv1x/5GDTA=
X-Received: from pjbpq2.prod.google.com ([2002:a17:90b:3d82:b0:2ea:3a1b:f493])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53d0:b0:2ea:a9ac:eee1
 with SMTP id 98e67ed59e1d1-2f28fb5fd68mr7648207a91.10.1734138461665; Fri, 13
 Dec 2024 17:07:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:11 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-11-seanjc@google.com>
Subject: [PATCH 10/20] KVM: selftests: Keep dirty_log_test vCPU in guest until
 it needs to stop
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

In the dirty_log_test guest code, exit to userspace only when the vCPU is
explicitly told to stop.  Periodically exiting just to check if a flag has
been set is unnecessary, weirdly complex, and wastes time handling exits
that could be used to dirty memory.

Opportunistically convert 'i' to a uint64_t to guard against the unlikely
scenario that guest_num_pages exceeds the storage of an int.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 43 ++++++++++----------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 8d31e275a23d..40c8f5551c8e 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -31,9 +31,6 @@
 /* Default guest test virtual memory offset */
 #define DEFAULT_GUEST_TEST_MEM		0xc0000000
 
-/* How many pages to dirty for each guest loop */
-#define TEST_PAGES_PER_LOOP		1024
-
 /* How many host loops to run (one KVM_GET_DIRTY_LOG for each loop) */
 #define TEST_HOST_LOOP_N		32UL
 
@@ -75,6 +72,7 @@ static uint64_t host_page_size;
 static uint64_t guest_page_size;
 static uint64_t guest_num_pages;
 static uint64_t iteration;
+static bool vcpu_stop;
 
 /*
  * Guest physical memory offset of the testing memory slot.
@@ -96,9 +94,10 @@ static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
 static void guest_code(void)
 {
 	uint64_t addr;
-	int i;
 
 #ifdef __s390x__
+	uint64_t i;
+
 	/*
 	 * On s390x, all pages of a 1M segment are initially marked as dirty
 	 * when a page of the segment is written to for the very first time.
@@ -112,7 +111,7 @@ static void guest_code(void)
 #endif
 
 	while (true) {
-		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
+		while (!READ_ONCE(vcpu_stop)) {
 			addr = guest_test_virt_mem;
 			addr += (guest_random_u64(&guest_rng) % guest_num_pages)
 				* guest_page_size;
@@ -140,14 +139,7 @@ static uint64_t host_track_next_count;
 /* Whether dirty ring reset is requested, or finished */
 static sem_t sem_vcpu_stop;
 static sem_t sem_vcpu_cont;
-/*
- * This is only set by main thread, and only cleared by vcpu thread.  It is
- * used to request vcpu thread to stop at the next GUEST_SYNC, since GUEST_SYNC
- * is the only place that we'll guarantee both "dirty bit" and "dirty data"
- * will match.  E.g., SIG_IPI won't guarantee that if the vcpu is interrupted
- * after setting dirty bit but before the data is written.
- */
-static atomic_t vcpu_sync_stop_requested;
+
 /*
  * This is updated by the vcpu thread to tell the host whether it's a
  * ring-full event.  It should only be read until a sem_wait() of
@@ -272,9 +264,7 @@ static void clear_log_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 /* Should only be called after a GUEST_SYNC */
 static void vcpu_handle_sync_stop(void)
 {
-	if (atomic_read(&vcpu_sync_stop_requested)) {
-		/* It means main thread is sleeping waiting */
-		atomic_set(&vcpu_sync_stop_requested, false);
+	if (READ_ONCE(vcpu_stop)) {
 		sem_post(&sem_vcpu_stop);
 		sem_wait(&sem_vcpu_cont);
 	}
@@ -801,11 +791,24 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		}
 
 		/*
-		 * See vcpu_sync_stop_requested definition for details on why
-		 * we need to stop vcpu when verify data.
+		 * Stop the vCPU prior to collecting and verifying the dirty
+		 * log.  If the vCPU is allowed to run during collection, then
+		 * pages that are written during this iteration may be missed,
+		 * i.e. collected in the next iteration.  And if the vCPU is
+		 * writing memory during verification, pages that this thread
+		 * sees as clean may be written with this iteration's value.
 		 */
-		atomic_set(&vcpu_sync_stop_requested, true);
+		WRITE_ONCE(vcpu_stop, true);
+		sync_global_to_guest(vm, vcpu_stop);
 		sem_wait(&sem_vcpu_stop);
+
+		/*
+		 * Clear vcpu_stop after the vCPU thread has acknowledge the
+		 * stop request and is waiting, i.e. is definitely not running!
+		 */
+		WRITE_ONCE(vcpu_stop, false);
+		sync_global_to_guest(vm, vcpu_stop);
+
 		/*
 		 * NOTE: for dirty ring, it's possible that we didn't stop at
 		 * GUEST_SYNC but instead we stopped because ring is full;
@@ -813,8 +816,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		 * the flush of the last page, and since we handle the last
 		 * page specially verification will succeed anyway.
 		 */
-		assert(host_log_mode == LOG_MODE_DIRTY_RING ||
-		       atomic_read(&vcpu_sync_stop_requested) == false);
 		vm_dirty_log_verify(mode, bmap);
 
 		/*
-- 
2.47.1.613.gc27f4b7a9f-goog


