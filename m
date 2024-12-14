Return-Path: <kvm+bounces-33810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3738A9F1BD0
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A1301881818
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:13:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D37381AB500;
	Sat, 14 Dec 2024 01:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cKI3orlS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759371B372C
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138476; cv=none; b=B88J20lNxIi0qeTcpvYVRPeK/PmSl7MPb5AIdHdC1gnCBcOISDqQqOjpwIO0d6FbyPa5rKjxX/ID2sZZLbB2ICZ1CyvRsWeXUtsCg0IXEu7Ws0+4ynQaDWFbIhF8o/i7eUrMNNTbxuDWv48b7C6I0bWYtwrTK9I+gfcj+BEjY4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138476; c=relaxed/simple;
	bh=Kr5ySemqhB8x0c8j9nsPd7eiJY6MO4EMZGp4hkHhkd8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kVkOA8M9PoPRAoylqJDYAYB2NHBBUYVIsjg/WzFrEFkw/Ch61T8WwqDZQr/GBEvXboeroSL3V1pUXA2wWOg5C25SBffWDahXSa+SFmOTpjZxkqAt8QzXG1evL8DjxWjSD39Bl0KL6U4NBXJqYWD1gAdB90CQnpKHHi3SQlDTdw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cKI3orlS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef8c7ef51dso1925972a91.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138475; x=1734743275; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Os40ssNAIeaE2KoVXFwHg6MBfdGS9M+rTKqJ6LN+iOY=;
        b=cKI3orlSBC+2NeRm+KHjYDI65Es+dTRorEq1MRh+I4n3nhEK29dqySngp1ti2dlAYh
         5KmjFjGVh+YCL1A9jqkquf3NBD8CZzsmC+Z4CVbmu2LuINjjAux02FA5lNDcCWxYkuYM
         3crtBodHOrxUn6vgQqyMmN3rtW5+FYuxiTNvGRhTcqwluerN3cjELhARCF2PSxbAFNyi
         VtsyrbEK62tJsgY6kYzrIq1p/F70dkASqfi25RixSIJ33TB7XUgp8h/mXq5vir3u2TOz
         cbpOcDP3sBDSNORFMZjmIAUs1rQ9Y8iy6tjosjQCpSdcx3e7BgZMowirpL+UFq969mkB
         gWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138475; x=1734743275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Os40ssNAIeaE2KoVXFwHg6MBfdGS9M+rTKqJ6LN+iOY=;
        b=OLDfRmZsuWkjBNWjL/JnU4Xbpb0ueqGWJhhJ11NjoZffTuX2AjSPaj20rsh+MfRSbK
         7gp1JlOcQC4onJqfeLYGvCmPpeqjiMQ7wsOVsgajU8V/EEMBzhSkxdQ4YsdhlJCm/zXE
         JOp/HzuHJPclT86lSOf1rBRCdRual5c3wEqr1sqHT+0/WkUWcTxIeHKeok1GQ/mKlhgd
         v5R+G3XTohCyMvs//YKjk0TjNFOf36MEuOSSkN6J/bea4BgAL5hfj61vSuBReTLj+vSy
         KCXNh310+qaz3lNEonTDkeOUaSjBolxZrqJMNI1+cLh14fbz0oo8f8+jHqCZLChQHHJz
         B17Q==
X-Gm-Message-State: AOJu0Yypb9adh/VARwG/5EVacU4RSQpCDCVI+n+dejnei9O1js2pyXIj
	/vUhC2JLvsip6QP/q4TjWup5EVwBe1vKR9/B/+CplDMRoWAWdohRrGIGCp2d9l+2G1keqs9oBEU
	65w==
X-Google-Smtp-Source: AGHT+IEZ+CgAMrCPJQOZACHcPD8CU7pR7etrO0c0IAnvZOB3YGn0IBxaunMGHCwATRbOfD17c9JSoaKnYEU=
X-Received: from pjh13.prod.google.com ([2002:a17:90b:3f8d:b0:2ef:701e:21c1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c02:b0:2ee:7e53:bfae
 with SMTP id 98e67ed59e1d1-2f29166c324mr6418476a91.10.1734138474915; Fri, 13
 Dec 2024 17:07:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:19 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-19-seanjc@google.com>
Subject: [PATCH 18/20] KVM: selftests: Set per-iteration variables at the
 start of each iteration
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Set the per-iteration variables at the start of each iteration instead of
setting them before the loop, and at the end of each iteration.  To ensure
the vCPU doesn't race ahead before the first iteration, simply have the
vCPU worker want for sem_vcpu_cont, which conveniently avoids the need to
special case posting sem_vcpu_cont from the loop.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 43 ++++++++------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 18d41537e737..f156459bf1ae 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -481,6 +481,8 @@ static void *vcpu_worker(void *data)
 {
 	struct kvm_vcpu *vcpu = data;
 
+	sem_wait(&sem_vcpu_cont);
+
 	while (!READ_ONCE(host_quit)) {
 		/* Let the guest dirty the random pages */
 		vcpu_run(vcpu);
@@ -675,15 +677,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	sync_global_to_guest(vm, guest_test_virt_mem);
 	sync_global_to_guest(vm, guest_num_pages);
 
-	/* Start the iterations */
-	iteration = 1;
-	sync_global_to_guest(vm, iteration);
-	WRITE_ONCE(host_quit, false);
 	host_dirty_count = 0;
 	host_clear_count = 0;
-	WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
-	WRITE_ONCE(nr_writes, 0);
-	sync_global_to_guest(vm, nr_writes);
+	WRITE_ONCE(host_quit, false);
 
 	/*
 	 * Ensure the previous iteration didn't leave a dangling semaphore, i.e.
@@ -695,12 +691,22 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	sem_getvalue(&sem_vcpu_cont, &sem_val);
 	TEST_ASSERT_EQ(sem_val, 0);
 
+	TEST_ASSERT_EQ(vcpu_stop, false);
+
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
 
-	while (iteration < p->iterations) {
+	for (iteration = 1; iteration < p->iterations; iteration++) {
 		unsigned long i;
 
+		sync_global_to_guest(vm, iteration);
+
+		WRITE_ONCE(nr_writes, 0);
+		sync_global_to_guest(vm, nr_writes);
+
 		dirty_ring_prev_iteration_last_page = dirty_ring_last_page;
+		WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
+
+		sem_post(&sem_vcpu_cont);
 
 		/*
 		 * Let the vCPU run beyond the configured interval until it has
@@ -779,26 +785,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 					     bmap[1], host_num_pages,
 					     &ring_buf_idx);
 		vm_dirty_log_verify(mode, bmap);
-
-		/*
-		 * Set host_quit before sem_vcpu_cont in the final iteration to
-		 * ensure that the vCPU worker doesn't resume the guest.  As
-		 * above, the dirty ring test may stop and wait even when not
-		 * explicitly request to do so, i.e. would hang waiting for a
-		 * "continue" if it's allowed to resume the guest.
-		 */
-		if (++iteration == p->iterations)
-			WRITE_ONCE(host_quit, true);
-		sync_global_to_guest(vm, iteration);
-
-		WRITE_ONCE(nr_writes, 0);
-		sync_global_to_guest(vm, nr_writes);
-
-		WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
-
-		sem_post(&sem_vcpu_cont);
 	}
 
+	WRITE_ONCE(host_quit, true);
+	sem_post(&sem_vcpu_cont);
+
 	pthread_join(vcpu_thread, NULL);
 
 	pr_info("Total bits checked: dirty (%lu), clear (%lu)\n",
-- 
2.47.1.613.gc27f4b7a9f-goog


