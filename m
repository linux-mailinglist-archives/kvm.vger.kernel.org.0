Return-Path: <kvm+bounces-42408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C24E1A7837D
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 22:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1593216CBF7
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD75C21D3EA;
	Tue,  1 Apr 2025 20:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4np9ppca"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3074B21C168
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 20:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540418; cv=none; b=F1mB7cnYxLQa25MruA9O8TAoRqPXipKU6p/TQ/alwBpBwnPlr3xaJ7LglCJlyyKaSYtgUrZFj/2cVJ0AMWh16gSWmXnya1hsaKkKnEV+ACFpvD4zndmOOkVE+T9mrW131yJWsiwhL50nBbL8Jr42Bsu06IdsTX+xjhugka429yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540418; c=relaxed/simple;
	bh=SQCk7dl/an2O85TPN3SHobLIgSZpdPBWw0r/t+ZuWrA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aGxfOuXeyjzoWUcKzG/y2uNzZKJIiC0gT5n0CJM7BhSiaduwpkuzev9oAFdR/EWx7+NXkvYuUi8JG+v+y0tO6kFH9C0MXm9ejIdwdID2u1nQsDq2j7mkambC9vwB4Dtek1TBhfTNvoQt1lJrPug9/uG+7SxtdSmsqzB4NFlhnCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4np9ppca; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3032f4eca83so10215663a91.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 13:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540416; x=1744145216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=y1emrfR/t8xEof5u39JxRR5LEtGKo3o+GNsYerS4PAw=;
        b=4np9ppcaVZEu1w4o0C4C19sw5pZryiZMApBAyI/XqXcmtmxNNsAOrNZXJXJz1y1WgO
         Q91kiydg+GeWmIDE1Wr49nKb8GhUjiTtYcw97rcYtQ5T96xmQoSBtqeRXkO8A1SRN4po
         SOHEx70SJpfFPHRePmRB975JExMnf8XMq5MDZ0r7YbEDHVW7DGrbFlEnhwE9TVb3FhqK
         lGBbYAszhJWYuTqf5X7Gr3hZYsRJbKrJ9nIqR7jTk+utmWi9645OWgfF+mKKyBBVd0GR
         5eBNqstbgwU5mQQFm/k6ntuVlP6Q3EKaUlZWQ/7z2//9PjKly2SjtsB75Z6kijZSdFMs
         pUpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540416; x=1744145216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y1emrfR/t8xEof5u39JxRR5LEtGKo3o+GNsYerS4PAw=;
        b=OZLEndlg1JL7Xnvro4IwtEtI9BJD0InAkmyCJxjstX/AD61rZgb7337O6fAF70W7Ns
         H/T1GAkauB16h/XCpbqjesTn3SYyHn5TgJlDdEubHjNYJlHjWI9ePbIAbOVoVq3u4PD+
         NOhJ8nXGRy8AitRtwmSPeVEXIVM1aL2LEFYGk/UsU2Z3dA9fwFw8z8NsYQeLkwE3ziVM
         dJ60dhvz7OciK+GP8siBS+8lkygbdpku08EOd8X9NHzXV/t7F4Hs+z/C519UkWAeVGUL
         x/8hTDuB9g2+XPKFxoSOa+8xdD8W6fPaod1siJ5DwPMdHb5wQrdouBrdQGZKF1oTuJM7
         UUHQ==
X-Gm-Message-State: AOJu0YzLqV5oXKh4yt9hoxZstbXUd0h4LONL+pJqAr3R7TRm1kB59imP
	Hgoi4LMj+h2LnOJkoXr5nRNUwyR10ft6vj9i/Eb4AyvowZJiry4ILXFHF9wOekwi5cieJpd6jHq
	Hxg==
X-Google-Smtp-Source: AGHT+IGO2fBqWvuDL6Vwrbo2kzqtang4rRNKtiORi8KQTXOklAN9xTuLpqS5Vs1VfeAZVw4/UWdyo4ySkHQ=
X-Received: from pjbsw7.prod.google.com ([2002:a17:90b:2c87:b0:2fe:800f:23a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38ce:b0:2fe:ba7f:8032
 with SMTP id 98e67ed59e1d1-30531f948c8mr21050786a91.9.1743540416529; Tue, 01
 Apr 2025 13:46:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:17 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-6-seanjc@google.com>
Subject: [PATCH 05/12] KVM: Add irqfd to eventfd's waitqueue while holding irqfds.lock
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
index 01ae5835c8ba..a33c10bd042a 100644
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
2.49.0.504.g3bcea36a83-goog


