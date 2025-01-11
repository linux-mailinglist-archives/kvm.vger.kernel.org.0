Return-Path: <kvm+bounces-35165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC21A09F7B
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:35:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21B87188A05E
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0195919F40B;
	Sat, 11 Jan 2025 00:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z5JrCNUY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1328F5B
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555441; cv=none; b=jg+1PrPNPkOQ+X6AlLl80HbaCyAkabvk6xEMpNgxoSzSRD17ddSrp77DPX7JtKdAJUrMq/wltNn+Le154uPPz6Ee/IWEG/7dEHoiUcgds7AkDZ9GYYCrHCqSBqf84FN3avMxj3nUnMWbfR95ZlV6cdtkWV+oq/Edr4JSCwTfkE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555441; c=relaxed/simple;
	bh=L8D0b1+KiW9ahs+qBDC4G+scCazWGnThE6lO6mNZavo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PJdLV4XLaf87We6rUeoMJmaK8cRj35WCGwZLYxsDnGTvJT3TsCpFq8XS3CoZRBEyrnej6+SnpZddNvbDp1drCJyRssZ5AdpjqddvKavuLUKvgjiSMJYegZb92XVorlfWapNdkGB3bJ7NI44m31QHunMSK5VnO1tE+mNW8ZSUy/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z5JrCNUY; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f5538a2356so4534759a91.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555439; x=1737160239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=S8bBOr0/HNvEyebC3bb/WW1HKqndMpC6/ffxTDW/jVI=;
        b=Z5JrCNUYFVEFwq0KZ9FlqZ1Om7cI+IF/5d+hW+8qXsVFOZ+bChU3rvLHzK7CJOaQev
         FffoTNa/ir12uQqJW92M3KtmyXIo9xkuSG64LGFTasxAAl0yS5UGVQ2J18bR0BFYfsc2
         Vv4iSm7+XLcLqfz1fiSXYzrR+XGvPP43Yxd89NXMPPbIJhB6/w9jc8si3DAvsilOPFUT
         fVwXfcZXQpeCy3MoIU7YZxTl8ZcmKUAgTcNveUySCH4hU0hyKwb1JTTd8q9VBivnIGD+
         kLYFDjSz5Gdm6byhtV7omiS4gTEfeDhVOJTUVYFz+hiy177VGPS36WiBy4i96y/gnFmb
         YGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555439; x=1737160239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S8bBOr0/HNvEyebC3bb/WW1HKqndMpC6/ffxTDW/jVI=;
        b=jfhWQf8Cu/P+g+6VAvQm764lO6B76RKzFOQ4dWSX9WMXaQY5UoM4WIAtfThHT2xwsH
         iLvYfq8cjMbZRQOoXEcfb+uQQEb7Fn+vQoXsMzuUjxqSk3eklBfgQv0wByY6as39nbLk
         y3evD7UEyVankgaSP3X9955xMVD872DDExDSx9BuWhsUHsG/OVwVgZgGpZk5tbhdBr0C
         g0+co+adI/T/xAUOUzmalluYrHFagGGTGD9tH76n0x9f733mxSnxXbPllA5iFZijjdoM
         llSf9LTv2iR3SCLf12TQnBlKtVejdQFzp12FjzvVnDYYTnHpf+TFOvuniqKqcQeTkJxW
         anEA==
X-Gm-Message-State: AOJu0YxOmux733HHcT2q/XKslqI7J4uFGl4bZ4B17q7dTLgAXRbA7JeJ
	uGKcaBzNTadmTit9Unor99IZQ1o3+4FRWftddh8BU+KTfoAwKv2TRyUNhchKtp2Qb27IokwA9vK
	Zlw==
X-Google-Smtp-Source: AGHT+IG8OJ4cGazMV/P/Pm31Fw9xdVTCsOZDWRosn8YO8BNm6aYjr7+8IBYnSgIAeh1WsD1lcKtnyJmoRDE=
X-Received: from pjbnd3.prod.google.com ([2002:a17:90b:4cc3:b0:2f4:432d:250c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1348:b0:2ee:cb5c:6c
 with SMTP id 98e67ed59e1d1-2f548ee54ccmr15776191a91.22.1736555439070; Fri, 10
 Jan 2025 16:30:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:30:02 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-19-seanjc@google.com>
Subject: [PATCH v2 18/20] KVM: selftests: Set per-iteration variables at the
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
index e9854b5a28f1..40567257ebea 100644
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
@@ -785,26 +791,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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


