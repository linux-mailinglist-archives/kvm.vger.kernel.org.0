Return-Path: <kvm+bounces-42407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2D46A78380
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 22:49:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 705FB3AF036
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF5421C9F9;
	Tue,  1 Apr 2025 20:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kKvTTwLS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFCB21A440
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 20:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540417; cv=none; b=RgG0O6yIDyCgQ1gTJDPbuThZnEPxzZTjBdspQprH5knj1A1sPrfsAdEqBY+tXtGYPrdafN8eIfW0b4Jn/bK3CO+6gitvPV6smn4ed/tNlv0nJ9nRIegA9Yw303zfel3wWv8EyjBHciQ9+lCQFVQBy+5KE1jrxvk4RFVOA+jOqn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540417; c=relaxed/simple;
	bh=nil5itzKYVmVDoYv7gEuftrnT2Lqo+z+CJed2C4O7A4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=omsFfmC5aedynh7wIA84OjH1TdJZCDFmR5hpB4It/njA1Tux46kaCW8RfBtu0DF90g/fnExqrCrGBgmLiiUd/1iB4fK6gZmX/aEamfriSg66qQQQc/8nAN6cvdLnJK8fSducFwy1M879r0EIpSSv1mSfy4ku6t0wf3aA+wIyP+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kKvTTwLS; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-227a8cdd272so99650335ad.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 13:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540415; x=1744145215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Lx4LCcdlopyvqbPN/IhBMgG93mXqJFxiV3H6RMakbuM=;
        b=kKvTTwLSi/UMGKuRPpo3BHTT1rLPJNOskAIYbfPiENj/bc3RmVyYhBpGhQMajZbdlL
         zNUECKlXlZJbwaKK/xLNs2Mr/9qta5UllrlSKC1e9+APZ3FZ0O/IVsMq2dzdOM3+XC+G
         bNFdX/JYL5yzN+gV9Vw0sCbiHk+FonYj7+a664nEbqiAOUifkw6HZyGY7W20bcUqiMXK
         CpzgtoPHZYDx3l8+yVMcUvT2YFLr2ncwlcs6JJKHU9Eiyi9ytGdxS8CrCbaJjdSsMHTf
         dvuCLRWE/5yom4sibM+vOGNbzcZx+WTZ1iJCDML4k6ta+j3b3fTW43bfG+O84i4rgEcr
         mayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540415; x=1744145215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lx4LCcdlopyvqbPN/IhBMgG93mXqJFxiV3H6RMakbuM=;
        b=Qj++NLdYVTFna0AZIbF8bqQgF0Tbctjof+/rH5JtP71GboULzFPEdBhxXmiOLpN4bk
         xEoA1HG//QX6J0yyNtAlRKk35iBheul8nAbTqdqxfOLgOFTGyEz+6YEijqESs+h7ep0i
         vpqlJ3IzIfs0PybfJtHXIEblEllo05t8Kb5LvmQQvr5/+pxdSD0e7USkO/WyfmpN/zKI
         MxSSLzsXz3OKZNwGeTYc4quFcYEXl+sybdXaW/e7ZE9tjoca3bSx6SHKFssBo7z3vgXg
         M+rNUnMWPWQCErusqv1vGDxGS8a05LGdNFtKPBztmCF6/EliwBZjlRni9XHGpmRtJCip
         gDDg==
X-Gm-Message-State: AOJu0Yz1UovVg8A1BkTutch/LcaETrnenx2If4UixMbSlCOjHLdXxLxh
	7lpJq02WH6FLujObRQ2RKuPJnWqr/7uu8x4EKarVKSSwbPvVtQDlgUoqa1IRD0Kqv9UDT7B39Vp
	3Nw==
X-Google-Smtp-Source: AGHT+IHW0sXHX4wMGJ15kvjoFqaPE9awBB7bIk66pU6GUBUvNZBfoLxZ3yipmWjxsb6XuZDLmoik4bMgDVc=
X-Received: from pjbsi11.prod.google.com ([2002:a17:90b:528b:b0:301:1bf5:2efc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2bcc:b0:224:912:153
 with SMTP id d9443c01a7336-2292f942acbmr235734395ad.5.1743540414753; Tue, 01
 Apr 2025 13:46:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:16 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-5-seanjc@google.com>
Subject: [PATCH 04/12] KVM: Add irqfd to KVM's list via the vfs_poll() callback
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

Add the irqfd structure to KVM's list of irqfds in kvm_irqfd_register(),
i.e. via the vfs_poll() callback.  This will allow taking irqfds.lock
across the entire registration sequence (add to waitqueue, add to list),
and more importantly will allow inserting into KVM's list if and only if
adding to the waitqueue succeeds (spoiler alert), without needing to
juggle return codes in weird ways.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 102 +++++++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 45 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 69bf2881635e..01ae5835c8ba 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -245,34 +245,14 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 	return ret;
 }
 
-struct kvm_irqfd_pt {
-	struct kvm_kernel_irqfd *irqfd;
-	poll_table pt;
-};
-
-static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
-			       poll_table *pt)
-{
-	struct kvm_irqfd_pt *p = container_of(pt, struct kvm_irqfd_pt, pt);
-	struct kvm_kernel_irqfd *irqfd = p->irqfd;
-
-	/*
-	 * Add the irqfd as a priority waiter on the eventfd, with a custom
-	 * wake-up handler, so that KVM *and only KVM* is notified whenever the
-	 * underlying eventfd is signaled.
-	 */
-	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
-
-	add_wait_queue_priority(wqh, &irqfd->wait);
-}
-
-/* Must be called under irqfds.lock */
 static void irqfd_update(struct kvm *kvm, struct kvm_kernel_irqfd *irqfd)
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_kernel_irq_routing_entry entries[KVM_NR_IRQCHIPS];
 	int n_entries;
 
+	lockdep_assert_held(&kvm->irqfds.lock);
+
 	n_entries = kvm_irq_map_gsi(kvm, entries, irqfd->gsi);
 
 	write_seqcount_begin(&irqfd->irq_entry_sc);
@@ -286,6 +266,49 @@ static void irqfd_update(struct kvm *kvm, struct kvm_kernel_irqfd *irqfd)
 	write_seqcount_end(&irqfd->irq_entry_sc);
 }
 
+struct kvm_irqfd_pt {
+	struct kvm_kernel_irqfd *irqfd;
+	struct kvm *kvm;
+	poll_table pt;
+	int ret;
+};
+
+static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
+			       poll_table *pt)
+{
+	struct kvm_irqfd_pt *p = container_of(pt, struct kvm_irqfd_pt, pt);
+	struct kvm_kernel_irqfd *irqfd = p->irqfd;
+	struct kvm_kernel_irqfd *tmp;
+	struct kvm *kvm = p->kvm;
+
+	spin_lock_irq(&kvm->irqfds.lock);
+
+	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
+		if (irqfd->eventfd != tmp->eventfd)
+			continue;
+		/* This fd is used for another irq already. */
+		p->ret = -EBUSY;
+		spin_unlock_irq(&kvm->irqfds.lock);
+		return;
+	}
+
+	irqfd_update(kvm, irqfd);
+
+	list_add_tail(&irqfd->list, &kvm->irqfds.items);
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+	/*
+	 * Add the irqfd as a priority waiter on the eventfd, with a custom
+	 * wake-up handler, so that KVM *and only KVM* is notified whenever the
+	 * underlying eventfd is signaled.
+	 */
+	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
+
+	add_wait_queue_priority(wqh, &irqfd->wait);
+	p->ret = 0;
+}
+
 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
 void __attribute__((weak)) kvm_arch_irq_bypass_stop(
 				struct irq_bypass_consumer *cons)
@@ -315,7 +338,7 @@ bool __attribute__((weak)) kvm_arch_irqfd_route_changed(
 static int
 kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 {
-	struct kvm_kernel_irqfd *irqfd, *tmp;
+	struct kvm_kernel_irqfd *irqfd;
 	struct eventfd_ctx *eventfd = NULL, *resamplefd = NULL;
 	struct kvm_irqfd_pt irqfd_pt;
 	int ret;
@@ -414,32 +437,22 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	 */
 	idx = srcu_read_lock(&kvm->irq_srcu);
 
-	spin_lock_irq(&kvm->irqfds.lock);
-
-	ret = 0;
-	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
-		if (irqfd->eventfd != tmp->eventfd)
-			continue;
-		/* This fd is used for another irq already. */
-		ret = -EBUSY;
-		goto fail_duplicate;
-	}
-
-	irqfd_update(kvm, irqfd);
-
-	list_add_tail(&irqfd->list, &kvm->irqfds.items);
-
-	spin_unlock_irq(&kvm->irqfds.lock);
-
 	/*
-	 * Register the irqfd with the eventfd by polling on the eventfd.  If
-	 * there was en event pending on the eventfd prior to registering,
-	 * manually trigger IRQ injection.
+	 * Register the irqfd with the eventfd by polling on the eventfd, and
+	 * simultaneously and the irqfd to KVM's list.  If there was en event
+	 * pending on the eventfd prior to registering, manually trigger IRQ
+	 * injection.
 	 */
 	irqfd_pt.irqfd = irqfd;
+	irqfd_pt.kvm = kvm;
 	init_poll_funcptr(&irqfd_pt.pt, kvm_irqfd_register);
 
 	events = vfs_poll(fd_file(f), &irqfd_pt.pt);
+
+	ret = irqfd_pt.ret;
+	if (ret)
+		goto fail_poll;
+
 	if (events & EPOLLIN)
 		schedule_work(&irqfd->inject);
 
@@ -460,8 +473,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return 0;
 
-fail_duplicate:
-	spin_unlock_irq(&kvm->irqfds.lock);
+fail_poll:
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 fail:
 	if (irqfd->resampler)
-- 
2.49.0.504.g3bcea36a83-goog


