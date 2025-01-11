Return-Path: <kvm+bounces-35150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EFC2A09F5A
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:31:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8867188CED2
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B7A3184E;
	Sat, 11 Jan 2025 00:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tz8G89RD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199A479D2
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555417; cv=none; b=OTWLqydPHNnuq2MksCy4+cmj2Zyj7GOwH4MopOZUBh3GBSew+60y508mEm8ZvKq1uXfD2gE9NLrFhTyrF1q7hHVmgDx9EYPmsVnTblomsvyd8zaJPuR3IZBJh59rMEx0BWg01lTFCIWMrOavTvEnP1ZGtDNAEzAZ3VSQsegQCVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555417; c=relaxed/simple;
	bh=VpeIAx4HgBrBdjrulL38P4sjULv3zDVf3Ct1h85Wlb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fSWS2vWJOzmXrjtQ6NaNwvcA/YX+yfePlj/Iu325WHIM48DPCiB7MLDx+wv5gSvMmrazL7Vt+EcBThPqUN7kMdSr04LbMp93odLi8mRjX+CXC4i7NwyDSUmdCpyzdYl19RdCyGXLFd7SANSkqwNtudm1wdI4vtKSirHFUEmpAYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tz8G89RD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so4800141a91.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555414; x=1737160214; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CWJNZezGcooW6XpZeQGEoIGegjFgZChrjwFhXc5Ge/w=;
        b=tz8G89RDGZ33CBYlpoNj0f5dUsKTYaW3dnwe5Mc3WcAMzZxVQcIHDFnHoLkE168ZDl
         H0nmGnBh1dBnPX80+D7WAxzsCnkljFj+U1QwDVUJfKMV3pz43SInuLQlajPFT1L22k1o
         wbisF7Y22dQEtbhj8RBqVAJo7XzopBQ4GpN04rH5cbIFOWYNV/l1glklt3F0O5E5o1jf
         Etg+omJEeu3bzd0txtgMtlvyxJh5cru1+ZYzs5X85NO2QjDue19nFNSd7Typdi+BG84E
         1iT6WAXnIEfXIn6ygCvzUAmuyxIdTEADqJruky9OJqhgdPaXRS3zHEjSv1Cf1NamBesG
         5tYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555414; x=1737160214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CWJNZezGcooW6XpZeQGEoIGegjFgZChrjwFhXc5Ge/w=;
        b=jFK6k8Jn2+ZeUYCD/LMdGcRxZSg5WSpvPzF+tw1zghlAopHUa2d83+olOFUFUiwCEt
         5zDrC46mRRUEWQPsdtpnNOswn/W82cnuLt4ifyBPyi3HeEzf1s/8+oBftauv045Jh/QU
         lsl8Yx8UDJw9uA3IBhxdaPT3NYsARcnAauExA29vpYO372+Zhcj9yVeLjGXaYi3UuJqe
         e3JBu4EJdGkH7yCqo3A5DVZucYCPFfLqgoL2v4DTy70sxvFxjuTIOa+LFNFMMVqwVGnD
         dilam6V4MjSAiX9IdY2/ohLi6TyPDw0/pRuc6yxOO0QfSUYFa2YWXqEJ6vtQ6YAXtR5s
         Tjzw==
X-Gm-Message-State: AOJu0YxF7yKFG7KcAAdlBsDfbww372Ln/kBpyG6vfCb8QTkMGy00zQKA
	ORBrDPZGNiIpFePdhHUVRyoJjJz8TmaXQTC7RtzrKtN59xaIYDOwsHRMIR17t1gQqBwbLWdWkmJ
	EzQ==
X-Google-Smtp-Source: AGHT+IGbAKPfzmJX4632s4dXZRLNCWhesSvipTL7gmk5Cn1vyQsk7QDvUwvy1wSu/11M+W3IJ3hHD7SP1As=
X-Received: from pfbgq35.prod.google.com ([2002:a05:6a00:3be3:b0:725:cd3b:326c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:398b:b0:727:d55e:4be3
 with SMTP id d2e1a72fcca58-72d21f315c4mr17757050b3a.7.1736555414278; Fri, 10
 Jan 2025 16:30:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:47 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-4-seanjc@google.com>
Subject: [PATCH v2 03/20] KVM: selftests: Drop signal/kick from dirty ring testcase
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the signal/kick from dirty_log_test's dirty ring handling, as kicking
the vCPU adds marginal value, at the cost of adding significant complexity
to the test.

Asynchronously interrupting the vCPU isn't novel; unless the kernel is
fully tickless, the vCPU will be interrupted by IRQs for any decently
large interval.

And exiting to userspace mode in the middle of a sequence isn't novel
either, as the vCPU will do so every time the ring becomes full.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 106 +++----------------
 1 file changed, 15 insertions(+), 91 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 41c158cf5444..d9911e20337f 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -236,24 +236,6 @@ static enum log_mode_t host_log_mode;
 static pthread_t vcpu_thread;
 static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
 
-static void vcpu_kick(void)
-{
-	pthread_kill(vcpu_thread, SIG_IPI);
-}
-
-/*
- * In our test we do signal tricks, let's use a better version of
- * sem_wait to avoid signal interrupts
- */
-static void sem_wait_until(sem_t *sem)
-{
-	int ret;
-
-	do
-		ret = sem_wait(sem);
-	while (ret == -1 && errno == EINTR);
-}
-
 static bool clear_log_supported(void)
 {
 	return kvm_has_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
@@ -292,17 +274,14 @@ static void vcpu_handle_sync_stop(void)
 		/* It means main thread is sleeping waiting */
 		atomic_set(&vcpu_sync_stop_requested, false);
 		sem_post(&sem_vcpu_stop);
-		sem_wait_until(&sem_vcpu_cont);
+		sem_wait(&sem_vcpu_cont);
 	}
 }
 
-static void default_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
+static void default_after_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 
-	TEST_ASSERT(ret == 0 || (ret == -1 && err == EINTR),
-		    "vcpu run failed: errno=%d", err);
-
 	TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
 		    "Invalid guest sync status: exit_reason=%s",
 		    exit_reason_str(run->exit_reason));
@@ -371,7 +350,6 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 			    "%u != %u", cur->slot, slot);
 		TEST_ASSERT(cur->offset < num_pages, "Offset overflow: "
 			    "0x%llx >= 0x%x", cur->offset, num_pages);
-		//pr_info("fetch 0x%x page %llu\n", *fetch_index, cur->offset);
 		__set_bit_le(cur->offset, bitmap);
 		dirty_ring_last_page = cur->offset;
 		dirty_gfn_set_collected(cur);
@@ -382,13 +360,6 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	return count;
 }
 
-static void dirty_ring_wait_vcpu(void)
-{
-	/* This makes sure that hardware PML cache flushed */
-	vcpu_kick();
-	sem_wait_until(&sem_vcpu_stop);
-}
-
 static void dirty_ring_continue_vcpu(void)
 {
 	pr_info("Notifying vcpu to continue\n");
@@ -400,18 +371,6 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 					   uint32_t *ring_buf_idx)
 {
 	uint32_t count = 0, cleared;
-	bool continued_vcpu = false;
-
-	dirty_ring_wait_vcpu();
-
-	if (!dirty_ring_vcpu_ring_full) {
-		/*
-		 * This is not a ring-full event, it's safe to allow
-		 * vcpu to continue
-		 */
-		dirty_ring_continue_vcpu();
-		continued_vcpu = true;
-	}
 
 	/* Only have one vcpu */
 	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vcpu),
@@ -427,16 +386,13 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 	TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
 		    "with collected (%u)", cleared, count);
 
-	if (!continued_vcpu) {
-		TEST_ASSERT(dirty_ring_vcpu_ring_full,
-			    "Didn't continue vcpu even without ring full");
+	if (READ_ONCE(dirty_ring_vcpu_ring_full))
 		dirty_ring_continue_vcpu();
-	}
 
 	pr_info("Iteration %ld collected %u pages\n", iteration, count);
 }
 
-static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
+static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 
@@ -444,17 +400,14 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 	if (get_ucall(vcpu, NULL) == UCALL_SYNC) {
 		/* We should allow this to continue */
 		;
-	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
-		   (ret == -1 && err == EINTR)) {
+	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL) {
 		/* Update the flag first before pause */
-		WRITE_ONCE(dirty_ring_vcpu_ring_full,
-			   run->exit_reason == KVM_EXIT_DIRTY_RING_FULL);
+		WRITE_ONCE(dirty_ring_vcpu_ring_full, true);
 		sem_post(&sem_vcpu_stop);
-		pr_info("vcpu stops because %s...\n",
-			dirty_ring_vcpu_ring_full ?
-			"dirty ring is full" : "vcpu is kicked out");
-		sem_wait_until(&sem_vcpu_cont);
+		pr_info("Dirty ring full, waiting for it to be collected\n");
+		sem_wait(&sem_vcpu_cont);
 		pr_info("vcpu continues now.\n");
+		WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
 	} else {
 		TEST_ASSERT(false, "Invalid guest sync status: "
 			    "exit_reason=%s",
@@ -473,7 +426,7 @@ struct log_mode {
 				     void *bitmap, uint32_t num_pages,
 				     uint32_t *ring_buf_idx);
 	/* Hook to call when after each vcpu run */
-	void (*after_vcpu_run)(struct kvm_vcpu *vcpu, int ret, int err);
+	void (*after_vcpu_run)(struct kvm_vcpu *vcpu);
 } log_modes[LOG_MODE_NUM] = {
 	{
 		.name = "dirty-log",
@@ -544,47 +497,24 @@ static void log_mode_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 	mode->collect_dirty_pages(vcpu, slot, bitmap, num_pages, ring_buf_idx);
 }
 
-static void log_mode_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
+static void log_mode_after_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct log_mode *mode = &log_modes[host_log_mode];
 
 	if (mode->after_vcpu_run)
-		mode->after_vcpu_run(vcpu, ret, err);
+		mode->after_vcpu_run(vcpu);
 }
 
 static void *vcpu_worker(void *data)
 {
-	int ret;
 	struct kvm_vcpu *vcpu = data;
 	uint64_t pages_count = 0;
-	struct kvm_signal_mask *sigmask = alloca(offsetof(struct kvm_signal_mask, sigset)
-						 + sizeof(sigset_t));
-	sigset_t *sigset = (sigset_t *) &sigmask->sigset;
-
-	/*
-	 * SIG_IPI is unblocked atomically while in KVM_RUN.  It causes the
-	 * ioctl to return with -EINTR, but it is still pending and we need
-	 * to accept it with the sigwait.
-	 */
-	sigmask->len = 8;
-	pthread_sigmask(0, NULL, sigset);
-	sigdelset(sigset, SIG_IPI);
-	vcpu_ioctl(vcpu, KVM_SET_SIGNAL_MASK, sigmask);
-
-	sigemptyset(sigset);
-	sigaddset(sigset, SIG_IPI);
 
 	while (!READ_ONCE(host_quit)) {
-		/* Clear any existing kick signals */
 		pages_count += TEST_PAGES_PER_LOOP;
 		/* Let the guest dirty the random pages */
-		ret = __vcpu_run(vcpu);
-		if (ret == -1 && errno == EINTR) {
-			int sig = -1;
-			sigwait(sigset, &sig);
-			assert(sig == SIG_IPI);
-		}
-		log_mode_after_vcpu_run(vcpu, ret, errno);
+		vcpu_run(vcpu);
+		log_mode_after_vcpu_run(vcpu);
 	}
 
 	pr_info("Dirtied %"PRIu64" pages\n", pages_count);
@@ -838,7 +768,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		 * we need to stop vcpu when verify data.
 		 */
 		atomic_set(&vcpu_sync_stop_requested, true);
-		sem_wait_until(&sem_vcpu_stop);
+		sem_wait(&sem_vcpu_stop);
 		/*
 		 * NOTE: for dirty ring, it's possible that we didn't stop at
 		 * GUEST_SYNC but instead we stopped because ring is full;
@@ -905,7 +835,6 @@ int main(int argc, char *argv[])
 		.interval = TEST_HOST_LOOP_INTERVAL,
 	};
 	int opt, i;
-	sigset_t sigset;
 
 	sem_init(&sem_vcpu_stop, 0, 0);
 	sem_init(&sem_vcpu_cont, 0, 0);
@@ -964,11 +893,6 @@ int main(int argc, char *argv[])
 
 	srandom(time(0));
 
-	/* Ensure that vCPU threads start with SIG_IPI blocked.  */
-	sigemptyset(&sigset);
-	sigaddset(&sigset, SIG_IPI);
-	pthread_sigmask(SIG_BLOCK, &sigset, NULL);
-
 	if (host_log_mode_option == LOG_MODE_ALL) {
 		/* Run each log mode */
 		for (i = 0; i < LOG_MODE_NUM; i++) {
-- 
2.47.1.613.gc27f4b7a9f-goog


