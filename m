Return-Path: <kvm+bounces-47019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E688BABC773
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 20:56:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0758D188BD45
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11BF4219A81;
	Mon, 19 May 2025 18:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NviifZWn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A2A217F29
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 18:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680930; cv=none; b=LipI50U31YuGyUufYSvncqCT5eBwcGlt3O27oZ5/xs9tRKIqeF+5BtagP0H1C3hrkGaVqkC1nk3gFiVVFv4j/lObc/90sd4I4iI29QP6RyPM46g5m8aMK4euITwUX2WH6B/voqGb7owO/kI/meqNmg0tv+XcDejBQ5J16SNM+LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680930; c=relaxed/simple;
	bh=WahQq1TbuZObX7S0cHAq9wgsYhpFJZsXmk63oXnHArs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PP0hOSY2MuZYpra92wqT3x7WYFyfFl1bEgA2oYbxA/pUGBqxkkopTxGPW8RnFhCzL/tjwc3xUG5cJMhCdcVrABUlPtS3DgbBBv+uo/ad9BiKwqHFR2v0pNHL8StmwztyhDH9dIcya+Va0LuZ3SlBgdiv+0FiTHVHAdfdrWGIfnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NviifZWn; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e8425926eso4991210a91.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 11:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680928; x=1748285728; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yzOWtWZ17B97iG5Cps4S6OXY8vgm63oceMRcqA1Kf10=;
        b=NviifZWnLvkErOsgRxNpmnP7ws6JB2GrEddxR1fpVV1w+jbTlqIDuvGC4+A4qb0Foc
         hqZAFRwbWC/pd5DNMwo0e4FOYCeTjcVL/1gq5LEKlJ6JpX20/C1BJYP1Z5a82TVIQs9O
         UYgaG9N+QXZgwmBCMnLxvoN2F/Nkwccg+taPpXnFOpW4IekTf8CLF3R3W9SCp1nOvJKO
         sevd3I7A3oEoowhmi4uDcnhK6ivxLPY7LAuzb/UhJHkcLEXjG8VwQVxENqBp1CbOGZBh
         LxawlNKbZODgFEvBUZnKvQBXSPM94wEimIDFNjiHgN9RF18K8d13VEQ1dAz+rY54G6sJ
         zZ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680928; x=1748285728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yzOWtWZ17B97iG5Cps4S6OXY8vgm63oceMRcqA1Kf10=;
        b=OIY6Ut/9d257QxoFoqGaloQJM1dekjCt4yYm+o/vj+yZhbf4XrLnzV0PaQqOtUKUXb
         vsrAYVrkQ3w3eZ/Ot9+LlA6SlgKrHlYmyN8AUyZJPljY8MhhvzzQDjT4XToRPzubky3L
         hW2tfQYx/eSpGY7oSRXj7elayPSth8Q2kzhuhlblQJ1ALpxuGs0VWkIPeZvYtiznMvte
         9DLGL/FHUNmyKwtROuM+OC4eBQJUij/D5dCQ2L5npQ55NjhNFxfpNPLyibnQKYS48cTp
         Uke6tdSo6Jm74iQTuwuPhc1kYUC97z69g1ilUHk6dRE6WOWXlE3nsFvJetW5TJfV5BrW
         m8lg==
X-Gm-Message-State: AOJu0YwuOpblTzvFChBVSSir9ly94wzS9SA1MMGqY/otpdxTzYGtW9qj
	2dCML0f5p17NT/t+G90IKDLPclvRf9o4hXGuQL6Kdx6HWU9tdvMf0HPQ/T/EEr0X+/n/iIxaXcm
	L/B0I0g==
X-Google-Smtp-Source: AGHT+IF4CHreF9GYhizgGap1CjiBCuQFeZKtOe+ZDk0WbGkBJzfweABFcsSXBbTResROqvG8ccbJeQWMTR0=
X-Received: from pjbso6.prod.google.com ([2002:a17:90b:1f86:b0:2ee:3128:390f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dd1:b0:2ff:6167:e92d
 with SMTP id 98e67ed59e1d1-30e8323ee6emr17930934a91.32.1747680928036; Mon, 19
 May 2025 11:55:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:07 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-6-seanjc@google.com>
Subject: [PATCH v2 05/12] KVM: Add irqfd to eventfd's waitqueue while holding irqfds.lock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	K Prateek Nayak <kprateek.nayak@amd.com>, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Add an irqfd to its target eventfd's waitqueue while holding irqfds.lock,
which is mildly terrifying but functionally safe.  irqfds.lock is taken
inside the waitqueue's lock, but if and only if the eventfd is being
released, i.e. that path is mutually exclusive with registration as KVM
holds a reference to the eventfd (and obviously must do so to avoid UAF).

This will allow using the eventfd's waitqueue to enforce KVM's requirement
that eventfd is assigned to at most one irqfd, without introducing races.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 99274d60335d..04877b297267 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -204,6 +204,11 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 	int ret = 0;
 
 	if (flags & EPOLLIN) {
+		/*
+		 * WARNING: Do NOT take irqfds.lock in any path except EPOLLHUP,
+		 * as KVM holds irqfds.lock when registering the irqfd with the
+		 * eventfd.
+		 */
 		u64 cnt;
 		eventfd_ctx_do_read(irqfd->eventfd, &cnt);
 
@@ -225,6 +230,11 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 		/* The eventfd is closing, detach from KVM */
 		unsigned long iflags;
 
+		/*
+		 * Taking irqfds.lock is safe here, as KVM holds a reference to
+		 * the eventfd when registering the irqfd, i.e. this path can't
+		 * be reached while kvm_irqfd_add() is running.
+		 */
 		spin_lock_irqsave(&kvm->irqfds.lock, iflags);
 
 		/*
@@ -296,16 +306,21 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
 
-	spin_unlock_irq(&kvm->irqfds.lock);
-
 	/*
 	 * Add the irqfd as a priority waiter on the eventfd, with a custom
 	 * wake-up handler, so that KVM *and only KVM* is notified whenever the
-	 * underlying eventfd is signaled.
+	 * underlying eventfd is signaled.  Temporarily lie to lockdep about
+	 * holding irqfds.lock to avoid a false positive regarding potential
+	 * deadlock with irqfd_wakeup() (see irqfd_wakeup() for details).
 	 */
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 
+	spin_release(&kvm->irqfds.lock.dep_map, _RET_IP_);
 	add_wait_queue_priority(wqh, &irqfd->wait);
+	spin_acquire(&kvm->irqfds.lock.dep_map, 0, 0, _RET_IP_);
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+
 	p->ret = 0;
 }
 
-- 
2.49.0.1101.gccaa498523-goog


