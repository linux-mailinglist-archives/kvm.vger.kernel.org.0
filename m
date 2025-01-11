Return-Path: <kvm+bounces-35158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A6EA09F70
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:33:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82A333A039D
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A63718FC89;
	Sat, 11 Jan 2025 00:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uoesLNpJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC17D18B492
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555430; cv=none; b=prbrvY2/7srH1FK9MUkdeaKBbX9nRkIB27ZsuLsJ6A2MX02fvaxBxY8Xcs+AjGzRMIqpfxeiZh4gy8eDGqey66CWcSQ9xrWUugKFLjLNX94AXZPDjZZm9XPzfeITm9MHGcy5PcXkEm3LcmjGSiI5n3Vqai2o3o1mn21VIWz/YDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555430; c=relaxed/simple;
	bh=3sfvgMqPiGr/4hRycKbPGFa+ObbRBz+P/dL5LYIATKQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HeXSahnR21tpX3fncBiyUaLGkvbRYsi3CHtNpGNaBmqayZbPOLrJba7GMGcQRQZnaCsUEK+6XNhSLeaIFUxfNSZh9B00xZIABM6PcaQb9QkfDiQQLMFWIlKau9HMkBIr93xR7brNh6rJaIJ8IlNjoollTg06MMGDopcqel1R1CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uoesLNpJ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee46799961so6672742a91.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555427; x=1737160227; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YB7ROV39Pzlxg3CsT+e1YkqRcv/fedX8ByOvnUPuqfA=;
        b=uoesLNpJBY02fzzlEihFEK2onjDwkXkLxXBh23o5DIxnTbN7X7s69U/MXIy/K1zU2Z
         BbFNuW7eSaA8GJu/O8I+LQAopz6WLf5Lyk/0GzAzgeRU+sqKz7KLRBBSgb6LkZQ+2dqE
         lTIffx9m0IYEsYFHf1UdzUvFJu4BXIx1KK+Y4Row8lysTKrPFaZofvCVt4yYP9ncK2m6
         a63B5D8l4IWNUpCJotDMvSbO/K/eV4gTCBe4hxx3j7i1ee/992z7q30upgQ+3W29ztDE
         m9fp1MMwWTuzm/2fRSAAVNUz3eIyf3LVhZC0AIDRwWgS5XH8yoivGiOrwSfJFIdC+hsl
         EdJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555427; x=1737160227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YB7ROV39Pzlxg3CsT+e1YkqRcv/fedX8ByOvnUPuqfA=;
        b=bTIt7t3U+uf0OwDu4E+fEiNphvBCM9H0IUw8GOs6dEu+oBL1TCqPJhpSDNTrkMDs8V
         HzA1OqJFb3zdHLvBlRCw1xHRyyp8q9+2zR5D8b3C3YuYslGAO+YdSk8TS2z28ZhDRMDB
         FQlmAkOmMpedQe6ClZpqbbS1RPdyZlX99wJ++KmWsL3ukGW7hKDEMw90LKHwZl9gYDku
         XGNeKZDR31QwyGW+Xlk/6Z3Mq0FprPVoG7VM3UUDdL+IOXaIjb6gm4gR9iBYjeaDgSwP
         YQYbeWuYBNYUfv42QexgWpm4Sr9clZB89m7JkgKQ2hzusxwjYfqBqGQVK5JRuiAEZfed
         aVsg==
X-Gm-Message-State: AOJu0YwOaz7F8N45VQdhBRlrJXHH37m9BWi4hYqSZjteQou0P+r+K9+m
	oCZOdsxX1pY5s3jIQptXJodf7R9nww3k/5S3J9BUs5GAOB34nvIU75uiJD4Cz8Aa0QPnlu1tiV+
	3+A==
X-Google-Smtp-Source: AGHT+IF9PJIrfTvS9nj0PyfnuXky377OG3qzpuoymD5lbk2+qu0GEx0KxT0XjTWhVsB8BPQIq2rSf68CP6U=
X-Received: from pjbqb10.prod.google.com ([2002:a17:90b:280a:b0:2ef:6fb0:55fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc6:b0:2ee:53b3:3f1c
 with SMTP id 98e67ed59e1d1-2f548e9f9ecmr17738470a91.5.1736555427225; Fri, 10
 Jan 2025 16:30:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:55 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-12-seanjc@google.com>
Subject: [PATCH v2 11/20] KVM: selftests: Post to sem_vcpu_stop if and only if
 vcpu_stop is true
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

When running dirty_log_test using the dirty ring, post to sem_vcpu_stop
only when the main thread has explicitly requested that the vCPU stop.
Synchronizing the vCPU and main thread whenever the dirty ring happens to
be full is unnecessary, as KVM's ABI is to actively prevent the vCPU from
running until the ring is no longer full.  I.e. attempting to run the vCPU
will simply result in KVM_EXIT_DIRTY_RING_FULL without ever entering the
guest.  And if KVM doesn't exit, e.g. let's the vCPU dirty more pages,
then that's a KVM bug worth finding.

Posting to sem_vcpu_stop on ring full also makes it difficult to get the
test logic right, e.g. it's easy to let the vCPU keep running when it
shouldn't, as a ring full can essentially happen at any given time.

Opportunistically rework the handling of dirty_ring_vcpu_ring_full to
leave it set for the remainder of the iteration in order to simplify the
surrounding logic.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 40c8f5551c8e..8544e8425f9c 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -379,12 +379,8 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
 	if (get_ucall(vcpu, NULL) == UCALL_SYNC) {
 		vcpu_handle_sync_stop();
 	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL) {
-		/* Update the flag first before pause */
 		WRITE_ONCE(dirty_ring_vcpu_ring_full, true);
-		sem_post(&sem_vcpu_stop);
-		pr_info("Dirty ring full, waiting for it to be collected\n");
-		sem_wait(&sem_vcpu_cont);
-		WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
+		vcpu_handle_sync_stop();
 	} else {
 		TEST_ASSERT(false, "Invalid guest sync status: "
 			    "exit_reason=%s",
@@ -743,7 +739,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
 
 	while (iteration < p->iterations) {
-		bool saw_dirty_ring_full = false;
 		unsigned long i;
 
 		dirty_ring_prev_iteration_last_page = dirty_ring_last_page;
@@ -775,19 +770,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			 * the ring on every pass would make it unlikely the
 			 * vCPU would ever fill the fing).
 			 */
-			if (READ_ONCE(dirty_ring_vcpu_ring_full))
-				saw_dirty_ring_full = true;
-			if (i && !saw_dirty_ring_full)
+			if (i && !READ_ONCE(dirty_ring_vcpu_ring_full))
 				continue;
 
 			log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
 						     bmap, host_num_pages,
 						     &ring_buf_idx);
-
-			if (READ_ONCE(dirty_ring_vcpu_ring_full)) {
-				pr_info("Dirty ring emptied, restarting vCPU\n");
-				sem_post(&sem_vcpu_cont);
-			}
 		}
 
 		/*
@@ -829,6 +817,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			WRITE_ONCE(host_quit, true);
 		sync_global_to_guest(vm, iteration);
 
+		WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
+
 		sem_post(&sem_vcpu_cont);
 	}
 
-- 
2.47.1.613.gc27f4b7a9f-goog


