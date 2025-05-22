Return-Path: <kvm+bounces-47437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78A64AC188E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C960D170B70
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFED82D4B4D;
	Thu, 22 May 2025 23:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NIdvL3sI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2DD2D3A7A
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 23:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957967; cv=none; b=Ca2X/RqZ8Fam+erM/+UJuopUYpXIMSqlM00VH73UI7W3bI/0KbpDan2qjOU5+P11WbNVskHoyH+ReaR5Yzb94/GXh1vcBD8AJgarhQhBkEdjVc38JjYB75P/4Hq6cM3HEXujobd6y9lP55E7cpJxmGr4SA5vHxH5Tz0qUvwUJOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957967; c=relaxed/simple;
	bh=Q+vc4pb6WDvcUQF3b0USVqnlp5sa+HZsP4+IXWQxYWs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jiti6TSDcQgfo2R2TUGvDThcelM8youlyMA7XVYPYxT4rkltW0Y1S4Ua9v0/+0+P0GbtocE5FjAQgKI4FCDmjiKhThQMIUhdtBWRuDgWFrQjvos9wUIw/bJvx2zvL5AsXIuWEGQKCFv2fWHksh748Za3ZcKVMR1azrp2v5ZpIHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NIdvL3sI; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ed0017688so4752428a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 16:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957964; x=1748562764; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MSc6nvEfNa3Mk9v70O2GwrdpOydgfEuVH7IGLa1xnl8=;
        b=NIdvL3sIzNl31piD6L0t7pnrTkq0kqdSsSvAWyMNIlQW26/lXgnufAv5RnekSzD+rX
         GiPV3DaNG0fh8JX6UpsFT/hes+p2huzxysIyH8WLYINcHkw4YmAAiAx/ovs95HQwqPrH
         LYtCOwXZwXIpfP6qNzGJm8bz56zYIvmeU1yw0eX4qWSuYNQUFyezNRFEllr80y6rr7kK
         tUBTO2FlTmwBuyR5t6AQJOD7S+k0q1KM565aylXW927yTuhVZtFvYP1i9ELlHloUjeOm
         L5C8pE5pppGu/dfWSi3BQsFQ9lfNQlO8N8cTrmybJkXrdzcOEsNJipvGnTWWb2Hynhe3
         9l6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957964; x=1748562764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MSc6nvEfNa3Mk9v70O2GwrdpOydgfEuVH7IGLa1xnl8=;
        b=BUzdDY4xBpAwySdoul24quBk1ChZNzyZi3MeFIHP14qBvW6mXmS5EGBo3wErpePZn/
         5OLUbnZdKzom31Wke5L0Y6vhBI97B+1tlGNucv8FyiBcMIlc8k09d5DnUSafa4/N230C
         6OcOrSnPjBFET3z+oIEHd6kQ1Ey9NsPIN8NreyqnAL9y0x6dwNSJG51WhPmTlgy4IDhz
         //RpOb1uWRFVH6qCI+bjNJTYEBh8LZwqU4Bka2RKtC/eqq0YyAlpqL5yiOdtk0/XLSJU
         yhilNFmwFZMj3SlxtR+VJaEEVcuA0FBTjdb7R9WbpS5oAvvEayTmbsfKLHAuHT53BTWx
         qE9w==
X-Forwarded-Encrypted: i=1; AJvYcCUwz/jGzQxnWPDWO3NQEH0UWdaBk8/yCG9s8+QMKzO+95s1/GAaG3i/lPbv4QrLoblhcKU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs6rppzTvgHPf/ToXe1ZZJyILO0hnbBpWWx5QAR7z2PZ+JJH+d
	aZNeax1D/nV6Xafr/fguQez55fP5s0B2VXpQrq0z9QajHWvlnY+rFDLuu+1xf6+DzAZKJ4z+CCv
	2gZvGjQ==
X-Google-Smtp-Source: AGHT+IFtihXA1ixlkcjuYPXGi/3nyMcTJqsYkMUIphzCaA6DcRFEslloczpIHH8OqTcj441vz3MgX+UAWJI=
X-Received: from pjb7.prod.google.com ([2002:a17:90b:2f07:b0:2fe:800f:23a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c02:b0:2fe:80cb:ac05
 with SMTP id 98e67ed59e1d1-310e96c946emr1657552a91.9.1747957964380; Thu, 22
 May 2025 16:52:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:16 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-7-seanjc@google.com>
Subject: [PATCH v3 06/13] sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
From: Sean Christopherson <seanjc@google.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Shuah Khan <shuah@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the setting of WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() and
instead have callers manually add the flag prior to adding their structure
to the queue.  Blindly setting WQ_FLAG_EXCLUSIVE is flawed, as the nature
of exclusive, priority waiters means that only the first waiter added will
ever receive notifications.

Pushing the flawed behavior to callers will allow fixing the problem one
hypervisor at a time (KVM added the flawed API, and then KVM's code was
copy+pasted nearly verbatim by Xen and Hyper-V), and will also allow for
adding an API that provides true exclusivity, i.e. that guarantees at most
one priority waiter is in the queue.

Opportunistically add a comment in Hyper-V to call out the mess.  Xen
privcmd's irqfd_wakefup() doesn't actually operate in exclusive mode, i.e.
can be "fixed" simply by dropping WQ_FLAG_EXCLUSIVE.  And KVM is primed to
switch to the aforementioned fully exclusive API, i.e. won't be carrying
the flawed code for long.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/hv/mshv_eventfd.c | 8 ++++++++
 drivers/xen/privcmd.c     | 1 +
 kernel/sched/wait.c       | 4 ++--
 virt/kvm/eventfd.c        | 1 +
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_eventfd.c b/drivers/hv/mshv_eventfd.c
index 8dd22be2ca0b..b348928871c2 100644
--- a/drivers/hv/mshv_eventfd.c
+++ b/drivers/hv/mshv_eventfd.c
@@ -368,6 +368,14 @@ static void mshv_irqfd_queue_proc(struct file *file, wait_queue_head_t *wqh,
 			container_of(polltbl, struct mshv_irqfd, irqfd_polltbl);
 
 	irqfd->irqfd_wqh = wqh;
+
+	/*
+	 * TODO: Ensure there isn't already an exclusive, priority waiter, e.g.
+	 * that the irqfd isn't already bound to another partition.  Only the
+	 * first exclusive waiter encountered will be notified, and
+	 * add_wait_queue_priority() doesn't enforce exclusivity.
+	 */
+	irqfd->irqfd_wait.flags |= WQ_FLAG_EXCLUSIVE;
 	add_wait_queue_priority(wqh, &irqfd->irqfd_wait);
 }
 
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 13a10f3294a8..c08ec8a7d27c 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -957,6 +957,7 @@ irqfd_poll_func(struct file *file, wait_queue_head_t *wqh, poll_table *pt)
 	struct privcmd_kernel_irqfd *kirqfd =
 		container_of(pt, struct privcmd_kernel_irqfd, pt);
 
+	kirqfd->wait.flags |= WQ_FLAG_EXCLUSIVE;
 	add_wait_queue_priority(wqh, &kirqfd->wait);
 }
 
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 51e38f5f4701..4ab3ab195277 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -40,7 +40,7 @@ void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_
 {
 	unsigned long flags;
 
-	wq_entry->flags |= WQ_FLAG_EXCLUSIVE | WQ_FLAG_PRIORITY;
+	wq_entry->flags |= WQ_FLAG_PRIORITY;
 	spin_lock_irqsave(&wq_head->lock, flags);
 	__add_wait_queue(wq_head, wq_entry);
 	spin_unlock_irqrestore(&wq_head->lock, flags);
@@ -64,7 +64,7 @@ EXPORT_SYMBOL(remove_wait_queue);
  * the non-exclusive tasks. Normally, exclusive tasks will be at the end of
  * the list and any non-exclusive tasks will be woken first. A priority task
  * may be at the head of the list, and can consume the event without any other
- * tasks being woken.
+ * tasks being woken if it's also an exclusive task.
  *
  * There are circumstances in which we can try to wake a task which has already
  * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 04877b297267..c7969904637a 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -316,6 +316,7 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 
 	spin_release(&kvm->irqfds.lock.dep_map, _RET_IP_);
+	irqfd->wait.flags |= WQ_FLAG_EXCLUSIVE;
 	add_wait_queue_priority(wqh, &irqfd->wait);
 	spin_acquire(&kvm->irqfds.lock.dep_map, 0, 0, _RET_IP_);
 
-- 
2.49.0.1151.ga128411c76-goog


