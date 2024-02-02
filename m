Return-Path: <kvm+bounces-7873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 023D1847D1B
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:18:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DDB31F2809A
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 23:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F8012C80A;
	Fri,  2 Feb 2024 23:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yXziIpaV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F9112C7E6
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 23:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706915916; cv=none; b=tF/MUTVV8zwocwg6suQ1p/Awa2WA28jQdw2oV+2OL7nOZebJMZsidjCjo5PuFw9Zvk5/K84T23ypbfwzcJ6IKOjhYReauvzLbx0cfFhmOZhMDikZbRuZVyDom4DBium+8oNTmZH+eXk+ImI57tcZ3265dM1+xsXFWOX5koDlKQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706915916; c=relaxed/simple;
	bh=2lzyhY4laC/6FqGkX8jZiMfFuGk71PZJdrnkd/RsoVU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Gk9S2eIjZ6Qop2MGjQ6EaA6tbi84P2LooyUB0lKoCKhaBJC0o0f3DJSwOCsZYsnr5Hykx6JDuXv6bULuTdkEpSHoysM4sl9e8XdlZT0BxxBsR063QLVtPzhDHaXcBQHmCSUiEuLL10NqMmYuvDSDJ/Jx4RLlAFw94tvmrEbh8OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yXziIpaV; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6c2643a07so4720897276.3
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 15:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706915913; x=1707520713; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9DTIvJdIifkzfJTgX6IxXh36jSV6kLqcP4pMjb+H5c=;
        b=yXziIpaViZPmsmECe9djPVUJp/XKy0CxC+hg0JMAU6P6Z4H3o0ZZzR3ir/MOry002q
         ELzcIYCAjEyTZI11+wDz9GN3Aniv4wQWv5F4Gc0vG6ou6avemwCac4bXQBZqnQiZtrEX
         8DIz7Pe7FyI3PoK6EV5l0feiXUN63LZQx1JhqNxJ1TeWfkwoiOhg270mXzSQeewrpBIu
         OfsAdKPh/bV3cWKzRpUzbbVLAyE11KBUL7SWNieNgYmdLFFj1AGjFOTw8WI2ZntRIcVF
         wgMJsbusvq0dmZjVlZuGpuUqGdAiy9t5LvpjBLOLm+8SONKbBKW5o+CLS6k6FGdZneCT
         aSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706915913; x=1707520713;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l9DTIvJdIifkzfJTgX6IxXh36jSV6kLqcP4pMjb+H5c=;
        b=MOc+LZTxid9gYOG1Ecv14VOYu7deCDAWEjGK+txlAXUjvb73ipzttRW1rZirkj9zIm
         rWCj3Oo1/eIgfLfk5whfWSw6589rfjw5Rq9UjGeyGUjYiZz7boLPeHbxPSjVd+AVHfDb
         7O28WljOA1EXLzTHWkSDMigORRfC8wBt7g2rBNa0jdXiPQQMVaoVyO3i45NpwtHG72H2
         KuuPqfMLdZtUiGf1Wv8obZtfPW0JjGuFzh8q8SFODygDIGvg/XB6GdDGpizT0Z3BfoX5
         h2nqk0UDape0zTSBEjuzjQhDll9XJKVp8NS4gY1fZrSPawq1ijlVK6nIydZtTfbPvG7i
         GumA==
X-Gm-Message-State: AOJu0YwyovsldP/1G1OKk7XXr1P1C6Ky/i6wShYWT66C1bCOzRir9fTZ
	8PNhf+h7NyKuodOH+UJcoytaky4WXZdcGfv91EmOiv8Az/xN71mA+ObcYAl3qqBqCMAosVEaH2N
	CLA==
X-Google-Smtp-Source: AGHT+IGHz6j1VsHb+BV+kasyAZ3rjCzvXf63INf57S9P0PXSgtPu4qTB5DHtVK2GZkybsyjtIvpOewUXJkk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1085:b0:dc6:e5e9:f3af with SMTP id
 v5-20020a056902108500b00dc6e5e9f3afmr1216683ybu.9.1706915913773; Fri, 02 Feb
 2024 15:18:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 15:18:31 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240202231831.354848-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Fix a semaphore imbalance in the dirty ring
 logging test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Shaoqin Huang <shahuang@redhat.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

When finishing the final iteration of dirty_log_test testcase, set
host_quit _before_ the final "continue" so that the vCPU worker doesn't
run an extra iteration, and delete the hack-a-fix of an extra "continue"
from the dirty ring testcase.  This fixes a bug where the extra post to
sem_vcpu_cont may not be consumed, which results in failures in subsequent
runs of the testcases.  The bug likely was missed during development as
x86 supports only a single "guest mode", i.e. there aren't any subsequent
testcases after the dirty ring test, because for_each_guest_mode() only
runs a single iteration.

For the regular dirty log testcases, letting the vCPU run one extra
iteration is a non-issue as the vCPU worker waits on sem_vcpu_cont if and
only if the worker is explicitly told to stop (vcpu_sync_stop_requested).
But for the dirty ring test, which needs to periodically stop the vCPU to
reap the dirty ring, letting the vCPU resume the guest _after_ the last
iteration means the vCPU will get stuck without an extra "continue".

However, blindly firing off an post to sem_vcpu_cont isn't guaranteed to
be consumed, e.g. if the vCPU worker sees host_quit==true before resuming
the guest.  This results in a dangling sem_vcpu_cont, which leads to
subsequent iterations getting out of sync, as the vCPU worker will
continue on before the main task is ready for it to resume the guest,
leading to a variety of asserts, e.g.

  ==== Test Assertion Failure ====
  dirty_log_test.c:384: dirty_ring_vcpu_ring_full
  pid=14854 tid=14854 errno=22 - Invalid argument
     1  0x00000000004033eb: dirty_ring_collect_dirty_pages at dirty_log_test.c:384
     2  0x0000000000402d27: log_mode_collect_dirty_pages at dirty_log_test.c:505
     3   (inlined by) run_test at dirty_log_test.c:802
     4  0x0000000000403dc7: for_each_guest_mode at guest_modes.c:100
     5  0x0000000000401dff: main at dirty_log_test.c:941 (discriminator 3)
     6  0x0000ffff9be173c7: ?? ??:0
     7  0x0000ffff9be1749f: ?? ??:0
     8  0x000000000040206f: _start at ??:?
  Didn't continue vcpu even without ring full

Alternatively, the test could simply reset the semaphores before each
testcase, but papering over hacks with more hacks usually ends in tears.

Reported-by: Shaoqin Huang <shahuang@redhat.com>
Fixes: 84292e565951 ("KVM: selftests: Add dirty ring buffer test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 50 +++++++++++---------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index babea97b31a4..eaad5b20854c 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -376,7 +376,10 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 
 	cleared = kvm_vm_reset_dirty_ring(vcpu->vm);
 
-	/* Cleared pages should be the same as collected */
+	/*
+	 * Cleared pages should be the same as collected, as KVM is supposed to
+	 * clear only the entries that have been harvested.
+	 */
 	TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
 		    "with collected (%u)", cleared, count);
 
@@ -415,12 +418,6 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 	}
 }
 
-static void dirty_ring_before_vcpu_join(void)
-{
-	/* Kick another round of vcpu just to make sure it will quit */
-	sem_post(&sem_vcpu_cont);
-}
-
 struct log_mode {
 	const char *name;
 	/* Return true if this mode is supported, otherwise false */
@@ -433,7 +430,6 @@ struct log_mode {
 				     uint32_t *ring_buf_idx);
 	/* Hook to call when after each vcpu run */
 	void (*after_vcpu_run)(struct kvm_vcpu *vcpu, int ret, int err);
-	void (*before_vcpu_join) (void);
 } log_modes[LOG_MODE_NUM] = {
 	{
 		.name = "dirty-log",
@@ -452,7 +448,6 @@ struct log_mode {
 		.supported = dirty_ring_supported,
 		.create_vm_done = dirty_ring_create_vm_done,
 		.collect_dirty_pages = dirty_ring_collect_dirty_pages,
-		.before_vcpu_join = dirty_ring_before_vcpu_join,
 		.after_vcpu_run = dirty_ring_after_vcpu_run,
 	},
 };
@@ -513,14 +508,6 @@ static void log_mode_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 		mode->after_vcpu_run(vcpu, ret, err);
 }
 
-static void log_mode_before_vcpu_join(void)
-{
-	struct log_mode *mode = &log_modes[host_log_mode];
-
-	if (mode->before_vcpu_join)
-		mode->before_vcpu_join();
-}
-
 static void generate_random_array(uint64_t *guest_array, uint64_t size)
 {
 	uint64_t i;
@@ -719,6 +706,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vm *vm;
 	unsigned long *bmap;
 	uint32_t ring_buf_idx = 0;
+	int sem_val;
 
 	if (!log_mode_supported()) {
 		print_skip("Log mode '%s' not supported",
@@ -788,12 +776,22 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Start the iterations */
 	iteration = 1;
 	sync_global_to_guest(vm, iteration);
-	host_quit = false;
+	WRITE_ONCE(host_quit, false);
 	host_dirty_count = 0;
 	host_clear_count = 0;
 	host_track_next_count = 0;
 	WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
 
+	/*
+	 * Ensure the previous iteration didn't leave a dangling semaphore, i.e.
+	 * that the main task and vCPU worker were synchronized and completed
+	 * verification of all iterations.
+	 */
+	sem_getvalue(&sem_vcpu_stop, &sem_val);
+	TEST_ASSERT_EQ(sem_val, 0);
+	sem_getvalue(&sem_vcpu_cont, &sem_val);
+	TEST_ASSERT_EQ(sem_val, 0);
+
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
 
 	while (iteration < p->iterations) {
@@ -819,15 +817,21 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		assert(host_log_mode == LOG_MODE_DIRTY_RING ||
 		       atomic_read(&vcpu_sync_stop_requested) == false);
 		vm_dirty_log_verify(mode, bmap);
+
+		/*
+		 * Set host_quit before sem_vcpu_cont in the final iteration to
+		 * ensure that the vCPU worker doesn't resume the guest.  As
+		 * above, the dirty ring test may stop and wait even when not
+		 * explicitly request to do so, i.e. would hang waiting for a
+		 * "continue" if it's allowed to resume the guest.
+		 */
+		if (++iteration == p->iterations)
+			WRITE_ONCE(host_quit, true);
+
 		sem_post(&sem_vcpu_cont);
-
-		iteration++;
 		sync_global_to_guest(vm, iteration);
 	}
 
-	/* Tell the vcpu thread to quit */
-	host_quit = true;
-	log_mode_before_vcpu_join();
 	pthread_join(vcpu_thread, NULL);
 
 	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "

base-commit: d79e70e8cc9ee9b0901a93aef391929236ed0f39
-- 
2.43.0.594.gd9cf4e227d-goog


