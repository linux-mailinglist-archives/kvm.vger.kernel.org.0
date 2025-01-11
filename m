Return-Path: <kvm+bounces-35156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B69CCA09F6A
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF2863AB074
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C6518801A;
	Sat, 11 Jan 2025 00:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z1MW3Wl9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761C6171E49
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555426; cv=none; b=MZR04hbKRlEGHXfbOWnK6p4CsBRsBAnoqSpt9Z1LtKNwCWpPorrwV3ObxNUQKGjDQzVqCoYuGFCENevXynb31hlFgfYcNqjo30Iw762w1lHSu8J4m8iX4ZzPEm1k6x2iW7ySIQILLTuZ0KFe2SxxYlCTPWEfnNMtA4r+76OzAe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555426; c=relaxed/simple;
	bh=OgTTk595VIyjaFheqBqRfYqIoPT5CZ9K1t127fuPGa4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RWRZaETR0F7VFVtr/k3yjnYEFf61bKIHUXDfPKq95y08hOhmFYGg7Q26/NMWDYwSMMKP0TfJ929dDr9yEfv8dv2jNtPZNrKD1eaYOH6hyMA3/4UICVrNNi9dq6oUJOZhOlrzacyGYlkgveETHN3GDNSzIheCzE+YSeGyv5Hu8CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z1MW3Wl9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efa74481fdso4762415a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555424; x=1737160224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FAzPo3qg+GcWGQlv0+FYKxHsP1523EqIgag6kKt+kTY=;
        b=z1MW3Wl9m4tzjLCOvxwXc53Nhg1IQHTxndzi4SeB20dOLzfp+mJn2tOYVhw72/qQdC
         iBHl8nRONVc06VQCGHK+JO7GtfajXJ4kJGd6mtDA6IOgHBLAVqw6WPiwzVqGw4oyCIA8
         bQR+EaiOGl/bYl3KgRhzzzxJSI4qWIhwSOO7jOr7K8GDuPnKpv1EVXJfSJMiJm0ixj6v
         lDl1YG8DQG3kqX2FUIqhL/e6h3j6MXCktYvD88sgINbR4HOJoBVTwJhzpzwcyxYHsRcm
         DmoZ0kpPZEu1cTgjsz35g2TqscM8ZevpnUv4zfdm8ec1cIkfiAH3Bt9nRTT8yxzC2BnK
         UWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555424; x=1737160224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FAzPo3qg+GcWGQlv0+FYKxHsP1523EqIgag6kKt+kTY=;
        b=jANorD2YkI2qOVkiBqA9X1GsYfnbkCnBvRfZJE2/WtCce1Vw4zEcyb27G3WLFwUjFZ
         5WuT5a76xTWxrOQooiTtrOvFLo9el1uMUtMu2v6nfKYmUOGVX1S+V8CnZhFYbmeClgwQ
         +fWoQPPMmK82qYvHl+LN3OVgzMkCLLacMOKs7wUpwMkaaxg2xmxFXDjDXmOiZt9fdA+4
         3kTSuo46/MP736Lso1MVxPEKLSU3BpyoRsccOZAn2wPOCh/WEUO9RBPpWYevZyWTNNHA
         ILqY9mBCIIMVni5o2IEv+ziw4SF9J0VcU+10ldL7qQdkaqD49lp9Qq0h/giwtcmktduO
         smlg==
X-Gm-Message-State: AOJu0Yx2Zky37DXk7o/S6T4+PBWzLL664/my9PhOPOwlFswhAqMM0wVs
	4C2MLEiJRq52LI8JGFprB55OMrrFIrHNDgwgXgsJ8UWXqv7PwTQm/5TqEUoEpBRNvMNGPLTJ+3d
	cZw==
X-Google-Smtp-Source: AGHT+IFcZmNvkzAFZeqVU6HOmDlE0qdzEz5X0u8ak5y2AJn4YmqiFkSzOypX660zjNhdGKiOFPzhRq/DJvA=
X-Received: from pjbee12.prod.google.com ([2002:a17:90a:fc4c:b0:2e5:5ffc:1c36])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:254e:b0:2ef:19d0:2261
 with SMTP id 98e67ed59e1d1-2f548eae703mr20633108a91.16.1736555423972; Fri, 10
 Jan 2025 16:30:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:53 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-10-seanjc@google.com>
Subject: [PATCH v2 09/20] KVM: selftests: Honor "stop" request in dirty ring test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the vCPU doesn't dirty every page on the first iteration for
architectures that support the dirty ring, honor vcpu_stop in the dirty
ring's vCPU worker, i.e. stop when the main thread says "stop".  This will
allow plumbing vcpu_stop into the guest so that the vCPU doesn't need to
periodically exit to userspace just to see if it should stop.

Add a comment explaining that marking all pages as dirty is problematic
for the dirty ring, as it results in the guest getting stuck on "ring
full".  This could be addressed by adding a GUEST_SYNC() in that initial
loop, but it's not clear how that would interact with s390's behavior.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 55a385499434..8d31e275a23d 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -387,8 +387,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
 
 	/* A ucall-sync or ring-full event is allowed */
 	if (get_ucall(vcpu, NULL) == UCALL_SYNC) {
-		/* We should allow this to continue */
-		;
+		vcpu_handle_sync_stop();
 	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL) {
 		/* Update the flag first before pause */
 		WRITE_ONCE(dirty_ring_vcpu_ring_full, true);
@@ -697,6 +696,15 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
 	guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
+
+	/*
+	 * The workaround in guest_code() to write all pages prior to the first
+	 * iteration isn't compatible with the dirty ring, as the dirty ring
+	 * support relies on the vCPU to actually stop when vcpu_stop is set so
+	 * that the vCPU doesn't hang waiting for the dirty ring to be emptied.
+	 */
+	TEST_ASSERT(host_log_mode != LOG_MODE_DIRTY_RING,
+		    "Test needs to be updated to support s390 dirty ring");
 #endif
 
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
-- 
2.47.1.613.gc27f4b7a9f-goog


