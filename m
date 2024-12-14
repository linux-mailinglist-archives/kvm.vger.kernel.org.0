Return-Path: <kvm+bounces-33795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51EFD9F1BB1
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:08:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67C8F16323F
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FFB645023;
	Sat, 14 Dec 2024 01:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3NNu6Cc1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21621A260
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138451; cv=none; b=kuy8NBrZEIp77EDL8taSFE4Ebef8APj9Rm9AFeZhp6dkGKMrXnY4w0ojVwmaoCh+WEU7nyF/5EbN68Qt+PLLlG0kLo7YpviybrZr22LQuIc6PPIkrUPoaxbDl3hozbXXtkwvr32JEmKpQTiScsod1MOb3LGc6NWPzHOucmk5WYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138451; c=relaxed/simple;
	bh=VpeIAx4HgBrBdjrulL38P4sjULv3zDVf3Ct1h85Wlb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mljiyo+8+YOGbbaWW1B0kqXwtM8c4OvSHkxClnJe/wT3VWdRye+d3RE3oPIIqzoYSdqITMoVTV3+7SrO6X4MtZKkvD622pCX97y1IoY99w36oupZucV09q/2HpN6XLzItntlfTrtyvlVL/7DrMnI7k4lfeebVOU3k2AtegwxLIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3NNu6Cc1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efa0eb9cfeso1935219a91.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138449; x=1734743249; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CWJNZezGcooW6XpZeQGEoIGegjFgZChrjwFhXc5Ge/w=;
        b=3NNu6Cc1s8H9q/JS2uTP25VecEuegE9TR0TPWaeNPAsRhuuaT2pKko9ZIqK8VnYL0U
         Ckwxj+lv59eLxq+5yKXSeUi1nA0dTAWcir/ZM8m3EfP3ZW1xq2jnI3O/3/RDXScCuV65
         TV3N+2gB44fqbU/0+QcUVfgeAml6oS7n+SZeb37NBvXUKzX6j/4dTbDUcvToDCTUMSdO
         dBO5v8oVQdA2jQnOsuCWAynoIk2DfxEjPGg0mbbY+AVHqqe7wumrcBEfy3XHky/DNhE1
         F2fwvVo5CpThl181z/k/1NIRjQP6TuESxzbz/2Cz42Nr2csdHPPW7guYf0lury6042L+
         6g6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138449; x=1734743249;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CWJNZezGcooW6XpZeQGEoIGegjFgZChrjwFhXc5Ge/w=;
        b=BgZ3KhAMjmIyk9e1FWAnzaT3D/7V8qRnrvmypJbIDxlsTmIBVvKPPyshcrj/oviXSD
         4W3poag08QQr6YvbDhIgqWl4f8ZB1Gz7IZZwpEZjBUxZJ73SHiqPmpSSihlYnHfMK+/t
         sN71HetE79RuvRGMd+whqKn1Hoirnmk9iSPIflRH9EFclRBH+Zry7xxG3YFoNP2FQ6CA
         QMwWrJ+HjAYtHIldQo15w1f2xEn2B1O0cqc2EokDj3prW3LYy5gLx524YsyKwWncYT4H
         ca7zbEQ0NZuaAFeXUAFuHGwAOO3WgG5Zzwk5QYFmtcC0z+7sc5wZQeHs2EftpFdOh3CW
         kXnw==
X-Gm-Message-State: AOJu0YyL8M930xM5+ReO+jln2J9W8iQeSjpw1g74eJHnRmSyDMgvohxe
	mKm9nR1jG8BkC7qrfGbJmVlPma2AOdi83vlmmOUcqNfXPVZjPGh7pHfChuK4nUJltrXII/JrWZN
	zKg==
X-Google-Smtp-Source: AGHT+IEy2Sg+GijSqGqxRvlytRT21UvxmkoF/622NIZfTiAYN57h5uvq1E/T5Vrd05ut5ibH3MC26jcm9ag=
X-Received: from pjbsr5.prod.google.com ([2002:a17:90b:4e85:b0:2ef:8ef8:2701])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d8c:b0:2ee:5a82:433a
 with SMTP id 98e67ed59e1d1-2f2919d7bffmr6717799a91.17.1734138449286; Fri, 13
 Dec 2024 17:07:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:04 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-4-seanjc@google.com>
Subject: [PATCH 03/20] KVM: selftests: Drop signal/kick from dirty ring testcase
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


