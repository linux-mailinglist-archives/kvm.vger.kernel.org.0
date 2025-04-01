Return-Path: <kvm+bounces-42404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75EF2A78375
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 22:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E416716C99B
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:47:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C4821481B;
	Tue,  1 Apr 2025 20:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3dX3bz5V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478431EA7C6
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 20:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540411; cv=none; b=C8LCCqPDsqM2LER92HRe3tHkoOzuItt1oOYczzSmgz8o+TUlFpZnHmy4v6vpEtlA6x0UkcLOqisEzgAKo19Ub5pUCKU2ScMylQB5d+KMlzuex4IVHTG3+XNCZC7UrF0aJP6aSmjh+kaOZvMM3BkYHD4CrAJ49HTJTTYhDm4ARNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540411; c=relaxed/simple;
	bh=4JC9vDgpuY3Y2FxwMbdW8RzZ4m05ZUKUwd4bktvUCtE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ny2w2dES6uYNDbgAmGONb+x6Fspww0guivdBbYQ7CL+E+oTKbxgYMIyVaYRYivWl3GSXeeK0dkOOtEJ5WW7Jfn/i25DIVyzoTvrdqiIVL+V8jC3WD8gBYbZgHeQrULaScMPxZeumZzZ1+/dgnkTtNnLcF0vsgpu5DUwlh9o7JTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3dX3bz5V; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2242ce15cc3so111460845ad.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 13:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540409; x=1744145209; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=amBezYkVNcZuyH4EZC510WvPXbGr3Dq+FrBRP4RH3+k=;
        b=3dX3bz5VEA/pJrMPZVhhcQfCsIDcsN+HdIJ8UgiZXJJL4RfH/6YH8hTV5scUkDsJpW
         im5O3ChpXTa4T92pbre/rl8eq65TfEcUzXAxKlKYTqfazEOskKdKvAAX4uqQM9iS58y/
         kYk2T9wz8nlexg1pwvufUDlNzQIumw0PMQqQxb6qcS+tHYns5a5PbXpAd94dQM/aNKQ6
         vo89loV5K2XX5LfnK98nY4czttRQx0VhFa/cHZdQntwi6prRSxweKz23QHa5mwN+yPTF
         2bklvKsk+Ik387qktbBUeivNycw7Nl/TuTQGm8z7UBqGxEy+6e+OcbKFYDUX8q0R4x/y
         mYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540409; x=1744145209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=amBezYkVNcZuyH4EZC510WvPXbGr3Dq+FrBRP4RH3+k=;
        b=VUHAWwPlJxkSMcxpgfJK/5a9LXW7XNhqiIKjJ86xrLu8+a6OhLx+4Cq3y790VJbd2f
         BPyJnUUO7dyuPG7lwhtUDebaTqf8KRB+ZBqaGnKap5245Ma8FOu13+0LkMay61/bBn2+
         b8OToR8Hk7+d1KZ4poObQBPK8+CT4YWUb220ksiBSmKHxHcIeAXsy4L44iYobTQsiWlR
         nc3VUlsayMBeHlMCVBVvmFzoncHakrvpD6OkFGNqc3QAY4C9It/GJwpnui/tMINDBkEo
         faV46ilJq2xaEZcEaJvmgcFcE+GEt8cyLZjLaFNdJYwnf+C6Df8RgWkpdykY7DmOhL1a
         n8Zg==
X-Gm-Message-State: AOJu0YyPeO7tXRqvZu7102ehSMAh8lXJEg5E/SMO8kg4x1wCbV+HkmJf
	aK7Geg9H2FA40Nc5axU8yZe9MS32GC5YB554SQRDd9ZrZTud1CX41IGfh61aI7vql4ltaPDFi1b
	tuA==
X-Google-Smtp-Source: AGHT+IEa5pU5FztleJgZ0CTC7h18PjwGLO8G4GBjaSUUoGrBKG+0/CQ77Eky5VEgolWpGWv0RRLt0hcHxXQ=
X-Received: from pfblb18.prod.google.com ([2002:a05:6a00:4f12:b0:736:b315:f15e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:174b:b0:736:4d44:8b77
 with SMTP id d2e1a72fcca58-7398035e5a0mr24221681b3a.8.1743540409565; Tue, 01
 Apr 2025 13:46:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:13 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-2-seanjc@google.com>
Subject: [PATCH 01/12] KVM: Use a local struct to do the initial vfs_poll() on
 an irqfd
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

Use a function-local struct for the poll_table passted to vfs_poll(), as
nothing in the vfs_poll() callchain grabs a long-term reference to the
structure, i.e. its lifetime doesn't need to be tied to the irqfd.  Using
a local structure will also allow propagating failures out of the polling
callback without further polluting kvm_kernel_irqfd.

Opportunstically rename irqfd_ptable_queue_proc() to kvm_irqfd_register()
to capture what it actually does.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_irqfd.h |  1 -
 virt/kvm/eventfd.c        | 26 +++++++++++++++++---------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
index 8ad43692e3bb..44fd2a20b09e 100644
--- a/include/linux/kvm_irqfd.h
+++ b/include/linux/kvm_irqfd.h
@@ -55,7 +55,6 @@ struct kvm_kernel_irqfd {
 	/* Used for setup/shutdown */
 	struct eventfd_ctx *eventfd;
 	struct list_head list;
-	poll_table pt;
 	struct work_struct shutdown;
 	struct irq_bypass_consumer consumer;
 	struct irq_bypass_producer *producer;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 249ba5b72e9b..01c6eb4dceb8 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -245,12 +245,17 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 	return ret;
 }
 
-static void
-irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
-			poll_table *pt)
+struct kvm_irqfd_pt {
+	struct kvm_kernel_irqfd *irqfd;
+	poll_table pt;
+};
+
+static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
+			       poll_table *pt)
 {
-	struct kvm_kernel_irqfd *irqfd =
-		container_of(pt, struct kvm_kernel_irqfd, pt);
+	struct kvm_irqfd_pt *p = container_of(pt, struct kvm_irqfd_pt, pt);
+	struct kvm_kernel_irqfd *irqfd = p->irqfd;
+
 	add_wait_queue_priority(wqh, &irqfd->wait);
 }
 
@@ -305,6 +310,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	struct kvm_kernel_irqfd *irqfd, *tmp;
 	struct eventfd_ctx *eventfd = NULL, *resamplefd = NULL;
+	struct kvm_irqfd_pt irqfd_pt;
 	int ret;
 	__poll_t events;
 	int idx;
@@ -394,7 +400,6 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	 * a callback whenever someone signals the underlying eventfd
 	 */
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
-	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
 
 	spin_lock_irq(&kvm->irqfds.lock);
 
@@ -416,11 +421,14 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	spin_unlock_irq(&kvm->irqfds.lock);
 
 	/*
-	 * Check if there was an event already pending on the eventfd
-	 * before we registered, and trigger it as if we didn't miss it.
+	 * Register the irqfd with the eventfd by polling on the eventfd.  If
+	 * there was en event pending on the eventfd prior to registering,
+	 * manually trigger IRQ injection.
 	 */
-	events = vfs_poll(fd_file(f), &irqfd->pt);
+	irqfd_pt.irqfd = irqfd;
+	init_poll_funcptr(&irqfd_pt.pt, kvm_irqfd_register);
 
+	events = vfs_poll(fd_file(f), &irqfd_pt.pt);
 	if (events & EPOLLIN)
 		schedule_work(&irqfd->inject);
 
-- 
2.49.0.504.g3bcea36a83-goog


