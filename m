Return-Path: <kvm+bounces-47015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE29BABC76B
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 20:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 882044A2328
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAEF921147B;
	Mon, 19 May 2025 18:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zgrg4IZJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D17220C001
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 18:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680922; cv=none; b=EoSabR1KmCdbteE0eGXjEbG+AMAW9I82hMDa6u6gHwHDJn3VBIkfOkg1CgT2Gvhmo147mSMDj5xFF6ejlZFG+RbFftGYsUlbJwlqe2O5bso03+ulT7ScHYnuzwkgupU2M2zL/BWULJQI6f9hpalh1cBIzVFb6EImIDLgf7l6eUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680922; c=relaxed/simple;
	bh=8ktdrLUAiBXw/pB6xl3QteVK8vmsyuV4GRrjhK4M1uk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F0RXt3y5nhpw5AIWQ9oOtaLfuW5Wm6n44EdLW7tGxH0x/dLh2gBrx4Y7LwEO4vZkmGvsGV2Vdu0uNazLjjGWNtmLY/9cNHZRVq7UySVcFePYnxjgbTLaSE4EZ1f26TwOex9beJfcWbc1YL84V2W1IUEsRgU47s9+0q/guogBgz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zgrg4IZJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e7c25aedaso2920246a91.2
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 11:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680920; x=1748285720; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ID0K77cu4OHC+wFfljvoyA4ejd82lVYZb+u9j8jbS6w=;
        b=zgrg4IZJlF83sIQo4ec3zWuR7bxitiitKVCJa+rxAUWQX+Z/DYUbLQ3iFma1V1CVyu
         qIPykXj0uRU67lF8qjf7wT2lNILDX6z/AAx0N/QuLOSGbK36R9vcyRmu4Suhm4rlhBEr
         jd5Zm02KspkaWwQL5elLbh/coh/bCsNFLYYj286iBNMZ4k3cXoWgXQH+JzTCbA0yaxVq
         cnqLad8Ul5pN0fW2+2ooRQt9XyH52IVL3tesZzWwcSfBvEy0tt41btbZV5QhGE3Rfu3L
         KBTjgF1yk/g/jIp1DQQocoav9iDn+MEN+Ug8w3dD/+FnhBCMnczKbshd7TUXGwuxWzF6
         Me9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680920; x=1748285720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ID0K77cu4OHC+wFfljvoyA4ejd82lVYZb+u9j8jbS6w=;
        b=sdCVgzyYxFoxAHTM/mEdM6VcfxRsOJu1lBjCbtZeB87r22GVqngTW3VvPGoRXptn87
         JCWa/fklivOfI2BsQ+dgJah9PAbZw9Xdrpj/4HDHxNbggmY6zuQJEXpX3Kpunsk1iMyY
         1cnf69ecKYRLe6Mms3C5V6S7sq7bHbH83+Mezkz/PwvE5HmdWoPDUfJxmsZ0coSQsr6d
         zyy1CSxm6jpnSmuqVAa/viC8H3/fW6sMYSbFHjicN/uxNngRSwcJuPAg0dir23TS00sm
         BPIU5uYQ4Tm2P5mEI8njxaV0w3eNQp9B/cDDxeUgCbCFUtqRdFv/FstVnh0BJ3J7flrF
         zXQw==
X-Gm-Message-State: AOJu0YxUYsiMdADCXdKW+1jfmzElSaOUv1pe4iDaH2M//hY5sVqKsUpr
	bnFYBIbMnZmwnb8FqPdwGZTTVcbm3zwRnfGugWo15hW5c/C8W98ma77AFB5VNkh/lJ9caGq4wcm
	6g1XY4g==
X-Google-Smtp-Source: AGHT+IEaLF1s48wE5AIuvexHP+HKA2rzrNNO6wCebHCQJZafvZj5yhtA+uxhZqD9qAgjgxLgy4Xu2cmiqA0=
X-Received: from pjtu3.prod.google.com ([2002:a17:90a:c883:b0:2ff:6e58:8a0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d604:b0:30a:9316:75a2
 with SMTP id 98e67ed59e1d1-30e7d52adcfmr23209313a91.10.1747680920311; Mon, 19
 May 2025 11:55:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:03 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-2-seanjc@google.com>
Subject: [PATCH v2 01/12] KVM: Use a local struct to do the initial vfs_poll()
 on an irqfd
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

Use a function-local struct for the poll_table passed to vfs_poll(), as
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
index 11e5d1e3f12e..39e42b19d9f7 100644
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
2.49.0.1101.gccaa498523-goog


