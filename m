Return-Path: <kvm+bounces-35157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB23CA09F6B
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:33:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91CE6188CF45
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B32BB18C907;
	Sat, 11 Jan 2025 00:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PnhHesvV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E707188734
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555428; cv=none; b=sEplB872RhBETO3nOHBHrOMdphbWsUgb1XywW8355iBz68AiyKD1WuvahF42e3sZifCei2gMTZa+xEU6q/GJuZrQHh6YGB5wjv3FoNbOIgIf+okWjN1LtU6cQKntuhN3uKzqr51Rhr8x3nVQkpjLc6juR9T7v6zgFn9cptSPSgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555428; c=relaxed/simple;
	bh=dvr0z46QuRPjeO+M3P6fjhyLCMuwGFDzgudUy3batWo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z/qk+GWWZBoYiYnTKzU30ZpJLer6wZOX1sO9cjGiUMaunr/OyM7vrpZ4GYhrs2muAIyY+jhdTEU2TjkkqGX56DQaNMSDtfdIXnKEtFXDqQgw7rrxsa7TNlXJRfghS8wrbjqJVRjVH5qRcPKCUtzPw/JUbJk+tXgcN2t6kRlXSeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PnhHesvV; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21661949f23so75986115ad.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555426; x=1737160226; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RNK3sklc8NzNdhQ6DzodSTUjKP3FfBCZUP6CSMXfdw4=;
        b=PnhHesvV7HGdsBG6mqlTRZga9oRwXuNxcxm7/r2Crxv5JOPODNfCWf08fiRzONJKRM
         gBA0Wp6eJh4OvziUhwtRFwLe0JH360IZNTok+LBJNOYK/w/K+6kEIuxhSVgqinHNMXAH
         /C3WkFflewq7U6S6GXElYoQRx9ExeiFW98yPoIkHQp1nRHLcO3qjalBx9SR63XIfOZst
         /A7Ejp50g/VfN8Nas5xjCw631ie36RPUFrhVbDbUz1TqPGucqxBPd78GcMUZPqNMRKfr
         6xawDejeyCh7nkxUxptZe1comBAH84kOkJ/caPwBRdW9h9U8S5iTyz4Dq6103TV+SYPD
         0OXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555426; x=1737160226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RNK3sklc8NzNdhQ6DzodSTUjKP3FfBCZUP6CSMXfdw4=;
        b=GQCdF2X7DM0sXEXfxRa1989zP+4oG8TELL3GOhqIJhdL4NuVX9HE4Qg/17/HWZofme
         l9TcpiTfzWO+OgFhKsdnn+xzhwosZQ+PgfoIIgTsA940M12m9jpoVj2qC5y0f48TGlU/
         seuGWCD/PAX3lEiMuhOhqAzR7l7HLCGbDVLORWNSM9xPR4gycrhMvxPzrCSWzIQjq1kq
         mnj/1NZiBIBKUCSN4K0lDNvCeGIHoTpSpdo3nJv0jVgbFAGRgO7hXHhgzVbJ6+l+Mqzi
         F5vxKnUxxKkV9fGnSU3VPZFEaGbVkSQmurK2tLZAWOBYNACbQL5x5MM+6rdqYLWJKsH9
         CPuA==
X-Gm-Message-State: AOJu0Yz3l2XD2ycATuK/qI6egby+YGzVk/NQsOo+Z5vPloAS1nQSWl0l
	+38c790miaQ6MNSATkkEJnYsz0vKcFmh6xts7ODo9pcqM7aEJBeNzISQnfnaOI8h99ZMtgg8cJl
	P9Q==
X-Google-Smtp-Source: AGHT+IFZVo7ZKv5IRkv1HXxsi6LOVpEl2/GjPDFzkEZRkFVeRBFtcXWmAC3wo8WF/6xryaFkvYLsgqOGng8=
X-Received: from plks12.prod.google.com ([2002:a17:903:2cc:b0:211:fb3b:763b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c941:b0:215:a179:14ca
 with SMTP id d9443c01a7336-21a83f3eec9mr194424425ad.2.1736555425724; Fri, 10
 Jan 2025 16:30:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:54 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-11-seanjc@google.com>
Subject: [PATCH v2 10/20] KVM: selftests: Keep dirty_log_test vCPU in guest
 until it needs to stop
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
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


