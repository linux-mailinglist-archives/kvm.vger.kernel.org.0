Return-Path: <kvm+bounces-42410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ACAEA78385
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 22:49:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B28BA1892A17
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793002206BA;
	Tue,  1 Apr 2025 20:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AE1+iz0g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283CF211299
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 20:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540421; cv=none; b=RHX4Up/DfxVGiR06vnJdGyiWMfhH/yEslCIRLBMvE40ffNEyKmSHlwcco857icrPMWVhbvfPslc+1GfW6SKJDtSoRERuJfI+BbIBsol0gsnYMcjfdxqp5GnBpINn+Zq7gYAEQ1bUdRBRgpRh8/PGrCVxlQ/lyy83z5J4WAZk0sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540421; c=relaxed/simple;
	bh=ADxRVRx091FTCCf4bvhC0j46BfdY/59y0ru1KU1eFuo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ASsG7QZfIxw+e8vcuLNsB85KrYzPdcDyjbzNMVSHx2C+4LkHWqOCvJ04gGPLqUP0Bpl11Rvw/boXknVGeGO3LEUWrTa4W1pBTvwJeBKnAJS205oP7AywTNyDdggyaAnSFNksWCJe2gpxmEi7nFhC+JjZK+yXjYkw/4DvOgDY4GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AE1+iz0g; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff8119b436so10764257a91.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 13:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540420; x=1744145220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aA8/rbjSPW3y49ht4xFwJaGU+DA9JsbqwVRp3IHMGug=;
        b=AE1+iz0gebL6ysCKkgwmp82yKZq3fKdXipvGv3kD/r7A67dsPh3mlBM1XDyWcxE5Jr
         jh+e1iDZXPkQIcVHVoq2zA6VdsAqgmWwo2Ku5BUulTXMXtXvdcnwKrWXvhdwkqD3wi+2
         Bho1JTs2gCoLCl3EL2OsQ8zW/xOwiCR40XrfVtPZIZKvgo1chIfAsQYTQju5fAN6S90P
         Etqj9No9HPukRs6ZE2cXIdFrNDVKIrkDrUp8V/O+p+d4re96gp1KRraYakWOCRbAqNvh
         UIDkmTEz0UV6DNa9PZ6Xs9YX0T7toE0wOSQJ9N7xbHgCzYjiVSbLLJemWfcS9rq/VfYh
         ufzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540420; x=1744145220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aA8/rbjSPW3y49ht4xFwJaGU+DA9JsbqwVRp3IHMGug=;
        b=N9OpgQMuGjStnIvnxu4MxchYcf/taiDqWato5dpHkBqJUQo8y8uIuLkOfZuycw1Xw6
         YhCPdJr9cE/nn2KgR1E1KVH5xVsHh3WuCYDctblaHNFmvmQY6OxbBrVbf0wzidtaRIoA
         GQ84rYDpU0pF+S7IrKcMCJQzFbD0gO16vUSKh5RcOT0notaU6PMuIYnqySmZ6JiYyg8b
         107gCVEBnbz2osUwXWA+EbbwzSkEkA7dn17YG+2ZXhJYFnUg3CP3igADp2sndQeZtcSq
         MFM0CcXDcdSHz+6+AjsScEO9tqnW3Sh6CRxWcGx9cqnfFtbwWcO68OjOUEZw7w0GPQIx
         cJ6Q==
X-Gm-Message-State: AOJu0YzCLZxSx8JUxDdCjfqc10Lq0gK8/GX8OPQdZ04JaVPjqAkph6VT
	+0U6fH8MfnNCGcCkKInYpGTAFAstSU9mOroQq1A7H5l/zLNMTNyIlPFTKAfzhq2vBmd/E+1nLqy
	qRg==
X-Google-Smtp-Source: AGHT+IGGwFEdDMuZ0xntNe6yk2g8zeyEv/XFu/sxHNOeaskOniT4X4IpuqAn0QXf3B4CSI533+/1l7AS/qA=
X-Received: from pfbby7.prod.google.com ([2002:a05:6a00:4007:b0:737:6066:fee8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9f07:b0:1f5:709d:e0b7
 with SMTP id adf61e73a8af0-2009f5b5002mr26259502637.6.1743540419700; Tue, 01
 Apr 2025 13:46:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:19 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-8-seanjc@google.com>
Subject: [PATCH 07/12] KVM: Disallow binding multiple irqfds to an eventfd
 with a priority waiter
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Disallow binding an irqfd to an eventfd that already has a priority waiter,
i.e. to an eventfd that already has an attached irqfd.  KVM always
operates in exclusive mode for EPOLL_IN (unconditionally returns '1'),
i.e. only the first waiter will be notified.

KVM already disallows binding multiple irqfds to an eventfd in a single
VM, but doesn't guard against multiple VMs binding to an eventfd.  Adding
the extra protection reduces the pain of a userspace VMM bug, e.g. if
userspace fails to de-assign before re-assigning when transferring state
for intra-host migration, then the migration will explicitly fail as
opposed to dropping IRQs on the destination VM.

Temporarily keep KVM's manual check on irqfds.items, but add a WARN, e.g.
to allow sanity checking the waitqueue enforcement.

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 54 +++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index a33c10bd042a..25c360ed2e1e 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -291,37 +291,57 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 	struct kvm_kernel_irqfd *tmp;
 	struct kvm *kvm = p->kvm;
 
+	/*
+	 * Note, irqfds.lock protects the irqfd's irq_entry, i.e. its routing,
+	 * and irqfds.items.  It does NOT protect registering with the eventfd.
+	 */
 	spin_lock_irq(&kvm->irqfds.lock);
 
-	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
-		if (irqfd->eventfd != tmp->eventfd)
-			continue;
-		/* This fd is used for another irq already. */
-		p->ret = -EBUSY;
-		spin_unlock_irq(&kvm->irqfds.lock);
-		return;
-	}
-
+	/*
+	 * Initialize the routing information prior to adding the irqfd to the
+	 * eventfd's waitqueue, as irqfd_wakeup() can be invoked as soon as the
+	 * irqfd is registered.
+	 */
 	irqfd_update(kvm, irqfd);
 
-	list_add_tail(&irqfd->list, &kvm->irqfds.items);
-
 	/*
 	 * Add the irqfd as a priority waiter on the eventfd, with a custom
 	 * wake-up handler, so that KVM *and only KVM* is notified whenever the
-	 * underlying eventfd is signaled.  Temporarily lie to lockdep about
-	 * holding irqfds.lock to avoid a false positive regarding potential
-	 * deadlock with irqfd_wakeup() (see irqfd_wakeup() for details).
+	 * underlying eventfd is signaled.
 	 */
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 
+	/*
+	 * Temporarily lie to lockdep about holding irqfds.lock to avoid a
+	 * false positive regarding potential deadlock with irqfd_wakeup()
+	 * (see irqfd_wakeup() for details).
+	 *
+	 * Adding to the wait queue will fail if there is already a priority
+	 * waiter, i.e. if the eventfd is associated with another irqfd (in any
+	 * VM).  Note, kvm_irqfd_deassign() waits for all in-flight shutdown
+	 * jobs to complete, i.e. ensures the irqfd has been removed from the
+	 * eventfd's waitqueue before returning to userspace.
+	 */
 	spin_release(&kvm->irqfds.lock.dep_map, _RET_IP_);
-	add_wait_queue_priority(wqh, &irqfd->wait);
+	p->ret = add_wait_queue_priority_exclusive(wqh, &irqfd->wait);
 	spin_acquire(&kvm->irqfds.lock.dep_map, 0, 0, _RET_IP_);
+	if (p->ret)
+		goto out;
 
+	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
+		if (irqfd->eventfd != tmp->eventfd)
+			continue;
+
+		WARN_ON_ONCE(1);
+		/* This fd is used for another irq already. */
+		p->ret = -EBUSY;
+		goto out;
+	}
+
+	list_add_tail(&irqfd->list, &kvm->irqfds.items);
+
+out:
 	spin_unlock_irq(&kvm->irqfds.lock);
-
-	p->ret = 0;
 }
 
 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
-- 
2.49.0.504.g3bcea36a83-goog


