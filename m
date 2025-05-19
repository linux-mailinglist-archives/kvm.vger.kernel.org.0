Return-Path: <kvm+bounces-47042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21BBBABCB6E
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:30:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52C2F1697A5
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484A9221701;
	Mon, 19 May 2025 23:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1zq/cwN0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10A7221F1C
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697308; cv=none; b=iKf8wc1vNCgJRlaLfPZ9THZhpdcuyPUYH06D2W3AxTL+XrKv5bLiA0FKAKjMxjZyjvCFTWJXuJFeDgt8YmlghxHR4X6y/0iokI0vQsLSpT4VjWkKTUS/+rPuhXNLEqDBMUYW5z5BK8wQE1PxIDn7PqASKMp8Fz943oegPN7lWkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697308; c=relaxed/simple;
	bh=v27lpHZToMipvRUY1lUmbKWwt8EtNtWm7nK3+oLgxfA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cc7PlrOYxyIjG4xPlWWEnNk/CmWLUhONElKU7YxXCw8mwYsBQLAIclp0NqN3y+DwJ+5dBZZ0U8wXZLlRwekGfAgHo8oMLZM1j+J4HVRWGYn2SQHNa7BRBBZoTwwEjc/wr4zmMlF5QZ4krJTK8RWsEZZNf+wM11PpGKwqxJQz/A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1zq/cwN0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e9338430eso2684655a91.3
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697306; x=1748302106; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CYNfSz3c0MEIbufxqfSo89Xbj3evJh8YTPDSU4jQxx8=;
        b=1zq/cwN0rVSkRru9SQ2KsxsySymkGirUyyPgXRMVpxsRD+JmlatYLqUhlv3vpuWZGL
         5dUWOd5w4itj+igPcFUb0kknmNvbytmKVinrMk+NuVYlPQ8escyWIfHMM+yuBZRgjdpZ
         0f/+GT6u4U2Jyk/fj/jSf49CImKOzf22zC4EOCSC9lbU8ghEv5ATlTEuRLt53ocaetYU
         HpHIPlvC88F4auqcJdCTFgG/DdgwyCtWsfVecul02GK+3Co/7zFWMXn2i8HEa5+OtGFz
         gxfrE7Jnzea5lP1MRpY/cOvYMY44hBYS25mmOBg9RyrZRw+RK1gXbVDhuRztsLW6S/cf
         0PsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697306; x=1748302106;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CYNfSz3c0MEIbufxqfSo89Xbj3evJh8YTPDSU4jQxx8=;
        b=w7ype+oNrJHHmiWtz4zBI2S8UH8mND8aUQqzg9IkvjbHSySOa0ZVRCylKuKaP/JGQn
         Z8HQnFy9mg+/fkhIEyZXQcOyOWzyyFCNiwHOyXaLqOXtQxt/vSkDCtHd+Dmb00Pjmlw0
         63NEdK7ftsh2DaJT4bYQlNg7FSq5xOpIbUwUC6vN1UneXtSSNguWbXqHMtJVF9v3cotz
         exAU0mJDUyndcYVU3UT/7OA/yVMzpJD2ZddSPzoyWeOQeX54QLA8he0shQfsLGjYLgbK
         wb7Anhku67zAmKn/0BeUDNbRxEyH2NuP8cmsvqFp7s8j9qixBQLkCkWJ/SfrL00yL9aX
         hCzQ==
X-Gm-Message-State: AOJu0Yy9hM1kX2SUXSFIAvWUUOrcGGkYmqY3i22V3/l0xqCVlmCgqJEk
	I8F/Z1uNXyfnfKe8mkKiShOWP3yqGhsLAEXwvaajsVqSIIRie6iAxo5cTIAgNG2RgGGACk6chaI
	+ID+Bjg==
X-Google-Smtp-Source: AGHT+IHD3d0FUo1F+its1m5Q/ZuLYZpcWvtxoKmFmQSmXNfoYPiCCl0K+3fw4yCk8ORbs3n5QKanZNe6CZM=
X-Received: from pjbso6.prod.google.com ([2002:a17:90b:1f86:b0:2ee:3128:390f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b86:b0:30e:8c5d:8f8
 with SMTP id 98e67ed59e1d1-30e8c5d09b3mr23125425a91.14.1747697306228; Mon, 19
 May 2025 16:28:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:28:00 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-8-seanjc@google.com>
Subject: [PATCH 07/15] KVM: x86: Hardcode the PIT IRQ source ID to '2'
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hardcode the PIT's source IRQ ID to '2' instead of "finding" that bit 2
is always the first available bit in irq_sources_bitmap.  Bits 0 and 1 are
set/reserved by kvm_arch_init_vm(), i.e. long before kvm_create_pit() can
be invoked, and KVM allows at most one in-kernel PIT instance, i.e. it's
impossible for the PIT to find a different free bit (there are no other
users of kvm_request_irq_source_id().

Delete the now-defunct irq_sources_bitmap and all its associated code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/i8254.c            | 55 +++++----------------------------
 arch/x86/kvm/i8254.h            |  1 -
 arch/x86/kvm/x86.c              |  6 ----
 include/linux/kvm_host.h        |  1 +
 5 files changed, 8 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f25ec3ec5ce4..c8654e461933 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1396,7 +1396,6 @@ struct kvm_arch {
 	bool pause_in_guest;
 	bool cstate_in_guest;
 
-	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
 
 	/*
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 2a0964c859af..d4fc20c265b2 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -248,8 +248,8 @@ static void pit_do_work(struct kthread_work *work)
 	if (atomic_read(&ps->reinject) && !atomic_xchg(&ps->irq_ack, 0))
 		return;
 
-	kvm_set_irq(kvm, pit->irq_source_id, 0, 1, false);
-	kvm_set_irq(kvm, pit->irq_source_id, 0, 0, false);
+	kvm_set_irq(kvm, KVM_PIT_IRQ_SOURCE_ID, 0, 1, false);
+	kvm_set_irq(kvm, KVM_PIT_IRQ_SOURCE_ID, 0, 0, false);
 
 	/*
 	 * Provides NMI watchdog support via Virtual Wire mode.
@@ -641,47 +641,11 @@ static void kvm_pit_reset(struct kvm_pit *pit)
 	kvm_pit_reset_reinject(pit);
 }
 
-static int kvm_request_irq_source_id(struct kvm *kvm)
+static void kvm_pit_clear_all(struct kvm *kvm)
 {
-	unsigned long *bitmap = &kvm->arch.irq_sources_bitmap;
-	int irq_source_id;
-
 	mutex_lock(&kvm->irq_lock);
-	irq_source_id = find_first_zero_bit(bitmap, BITS_PER_LONG);
-
-	if (irq_source_id >= BITS_PER_LONG) {
-		pr_warn("exhausted allocatable IRQ sources!\n");
-		irq_source_id = -EFAULT;
-		goto unlock;
-	}
-
-	ASSERT(irq_source_id != KVM_USERSPACE_IRQ_SOURCE_ID);
-	ASSERT(irq_source_id != KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID);
-	set_bit(irq_source_id, bitmap);
-unlock:
-	mutex_unlock(&kvm->irq_lock);
-
-	return irq_source_id;
-}
-
-static void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
-{
-	ASSERT(irq_source_id != KVM_USERSPACE_IRQ_SOURCE_ID);
-	ASSERT(irq_source_id != KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID);
-
-	mutex_lock(&kvm->irq_lock);
-	if (irq_source_id < 0 ||
-	    irq_source_id >= BITS_PER_LONG) {
-		pr_err("IRQ source ID out of range!\n");
-		goto unlock;
-	}
-	clear_bit(irq_source_id, &kvm->arch.irq_sources_bitmap);
-	if (!irqchip_kernel(kvm))
-		goto unlock;
-
-	kvm_ioapic_clear_all(kvm->arch.vioapic, irq_source_id);
-	kvm_pic_clear_all(kvm->arch.vpic, irq_source_id);
-unlock:
+	kvm_ioapic_clear_all(kvm->arch.vioapic, KVM_PIT_IRQ_SOURCE_ID);
+	kvm_pic_clear_all(kvm->arch.vpic, KVM_PIT_IRQ_SOURCE_ID);
 	mutex_unlock(&kvm->irq_lock);
 }
 
@@ -715,10 +679,6 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	if (!pit)
 		return NULL;
 
-	pit->irq_source_id = kvm_request_irq_source_id(kvm);
-	if (pit->irq_source_id < 0)
-		goto fail_request;
-
 	mutex_init(&pit->pit_state.lock);
 
 	pid = get_pid(task_tgid(current));
@@ -770,8 +730,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	kvm_pit_set_reinject(pit, false);
 	kthread_destroy_worker(pit->worker);
 fail_kthread:
-	kvm_free_irq_source_id(kvm, pit->irq_source_id);
-fail_request:
+	kvm_pit_clear_all(kvm);
 	kfree(pit);
 	return NULL;
 }
@@ -788,7 +747,7 @@ void kvm_free_pit(struct kvm *kvm)
 		kvm_pit_set_reinject(pit, false);
 		hrtimer_cancel(&pit->pit_state.timer);
 		kthread_destroy_worker(pit->worker);
-		kvm_free_irq_source_id(kvm, pit->irq_source_id);
+		kvm_pit_clear_all(kvm);
 		kfree(pit);
 	}
 }
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index a768212ba821..14fb310357f2 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -42,7 +42,6 @@ struct kvm_pit {
 	struct kvm_io_device speaker_dev;
 	struct kvm *kvm;
 	struct kvm_kpit_state pit_state;
-	int irq_source_id;
 	struct kvm_irq_mask_notifier mask_notifier;
 	struct kthread_worker *worker;
 	struct kthread_work expired;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a9c252c9dab..9e2c249d45ca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12790,12 +12790,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
 
-	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
-	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
-	/* Reserve bit 1 of irq_sources_bitmap for irqfd-resampler */
-	set_bit(KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
-		&kvm->arch.irq_sources_bitmap);
-
 	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
 	mutex_init(&kvm->arch.apic_map_lock);
 	seqcount_raw_spinlock_init(&kvm->arch.pvclock_sc, &kvm->arch.tsc_write_lock);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0d4506598d62..44b439c5fcf4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -190,6 +190,7 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
+#define KVM_PIT_IRQ_SOURCE_ID			2
 
 extern struct mutex kvm_lock;
 extern struct list_head vm_list;
-- 
2.49.0.1101.gccaa498523-goog


