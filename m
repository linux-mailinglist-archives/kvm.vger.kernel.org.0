Return-Path: <kvm+bounces-41137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC86AA624E3
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E12BC3BFAA9
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 02:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD3417E473;
	Sat, 15 Mar 2025 02:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rwUddyvU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7732F42
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 02:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742006787; cv=none; b=dGi8+5Y0y7q2jlACKmtyhOunqGq7HHBKYebUC+cAEkbupXfbNcpDSLEkI95SEMJbgJbQnHE7rqh0VubzZosiIXmnoWFOZ+0jXQxaIH9mq7MT4pz2yAn4pSToaJUAhMvAFBsIx60Mu3MkhbD9Gbm3hbqtYfRCgTxbsYDwPvV15a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742006787; c=relaxed/simple;
	bh=zE2x2+fnsLlPa6R+8WbeaprDfUWrnn0g2dGoFppplYQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=uRXGTQ2ZxnDec46VK//KesCo+cjtWj4diKgZ4fxtB6hfl3q/M3D/faKBYBEBXVKnRGuyCqAVk+hwivyyYUZR+moZiW7rsJnqe+C3Bv1rN/3E1Tn5iLodHeSMGWa18Kgryyx21DjwouFW0N322yiC9H8rbyKNFxI9vKYCSRZq3MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rwUddyvU; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-224191d9228so53062215ad.3
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 19:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742006786; x=1742611586; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BaEBGOtjjM3QZjXXOToF+8tuzgxFy135iBSbOXF+4mM=;
        b=rwUddyvU+ITtKrkqzDWm1PNWysVR2iDIyB95s7QNeJayyYvMJ8Kly6zcO7wh9YgYZH
         QGLkpeJoWEU7IfZWGu7wnKldSlNPjMHAhP+kzqkMDtWvpOJUNMdryu5egR0E3Lz8mEAS
         0ZSefoiXSRyMikLFErL1AmnKev6ah0CRbgD4D9scFLIHIgdtPI0K4Wmee/wrsdyvq9Xb
         e1oCmYlIO3BTxQsYGmkZ2lBICkq2DA7XQDme+g+/QvRUk7r/0uHlW9uSqFNNQSDmNWXm
         JKODP4+UhwdV1hMyymGnvXU5RFsnUX4LZUD//auSFoWkq4fQrglHtGoJBtcryZaBiGrk
         hfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742006786; x=1742611586;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BaEBGOtjjM3QZjXXOToF+8tuzgxFy135iBSbOXF+4mM=;
        b=Se2h8XvIPcuFslc2mw0hzhIKsm3ijyh0n2plP0AVF47uE6lUy11XSGkgS/gVSwG3+C
         dJag8Vm33/6SparT1MTrd1ZIgy8u0R+EPlW9t6ikzCsNu26PiONGctNHk6SuRCZGb2lf
         zvuxImpwnr8CsPY4ZDntqBcCGf08zQWYo3FrUpckA2++BInRRZfaPSGIbBPMz0FIGoH7
         r5KZf3EPyky2C3w4qf211uz+bNDWdEIP4GCC1VUaQAXh1XOxPqBhREvKWBJcduU2k6DJ
         tCiJ8WyufEqK2btfSmvO0sdbUSXlsWou1YE3OxlURfkCFnIvk+VqMl8yAirxSoyYXN8f
         FDig==
X-Gm-Message-State: AOJu0YykMwoLdbBjeB/KMBue66YIenldOM5Nea9PSOgiDWl+upVjz4Rm
	p0H9KbRzOkuzx0Jp6Bhl/2hcxHBy2oCUEbr4M9ah4EGEmAETx2WwAxHMMxuqjwCpwX5I8neXpWM
	J8w==
X-Google-Smtp-Source: AGHT+IFSxPMqmVW0H6TDp8BIElDyX64QgkLUzwVsPfN7ljR5rpZkAu9lBMlhG8hmy9YQm6yHIr1MoOS8wDI=
X-Received: from pfbha9.prod.google.com ([2002:a05:6a00:8509:b0:736:9d24:ae31])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3cc8:b0:736:5b85:a911
 with SMTP id d2e1a72fcca58-7372239a441mr6858418b3a.8.1742006785800; Fri, 14
 Mar 2025 19:46:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 19:46:23 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315024623.2363994-1-seanjc@google.com>
Subject: [PATCH] KVM: Allow building irqbypass.ko as as module when kvm.ko is
 a module
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert HAVE_KVM_IRQ_BYPASS into a tristate so that selecting
IRQ_BYPASS_MANAGER follows KVM={m,y}, i.e. doesn't force irqbypass.ko to
be built-in.

Note, PPC allows building KVM as a module, but selects HAVE_KVM_IRQ_BYPASS
from a boolean Kconfig, i.e. KVM PPC unnecessarily forces irqbpass.ko to
be built-in.  But that flaw is a longstanding PPC specific issue.

Fixes: 61df71ee992d ("kvm: move "select IRQ_BYPASS_MANAGER" to common code")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/Kconfig         |  2 +-
 virt/kvm/eventfd.c       | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f34f4cfaa513..be7e1cd516d1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2382,7 +2382,7 @@ static inline bool kvm_is_visible_memslot(struct kvm_memory_slot *memslot)
 struct kvm_vcpu *kvm_get_running_vcpu(void);
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 
-#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 bool kvm_arch_has_irq_bypass(void);
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
 			   struct irq_bypass_producer *);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 54e959e7d68f..570938f0455c 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -75,7 +75,7 @@ config KVM_COMPAT
        depends on KVM && COMPAT && !(S390 || ARM64 || RISCV)
 
 config HAVE_KVM_IRQ_BYPASS
-       bool
+       tristate
        select IRQ_BYPASS_MANAGER
 
 config HAVE_KVM_VCPU_ASYNC_IOCTL
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 249ba5b72e9b..11e5d1e3f12e 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -149,7 +149,7 @@ irqfd_shutdown(struct work_struct *work)
 	/*
 	 * It is now safe to release the object's resources
 	 */
-#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 	irq_bypass_unregister_consumer(&irqfd->consumer);
 #endif
 	eventfd_ctx_put(irqfd->eventfd);
@@ -274,7 +274,7 @@ static void irqfd_update(struct kvm *kvm, struct kvm_kernel_irqfd *irqfd)
 	write_seqcount_end(&irqfd->irq_entry_sc);
 }
 
-#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 void __attribute__((weak)) kvm_arch_irq_bypass_stop(
 				struct irq_bypass_consumer *cons)
 {
@@ -424,7 +424,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	if (events & EPOLLIN)
 		schedule_work(&irqfd->inject);
 
-#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 	if (kvm_arch_has_irq_bypass()) {
 		irqfd->consumer.token = (void *)irqfd->eventfd;
 		irqfd->consumer.add_producer = kvm_arch_irq_bypass_add_producer;
@@ -609,14 +609,14 @@ void kvm_irq_routing_update(struct kvm *kvm)
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	list_for_each_entry(irqfd, &kvm->irqfds.items, list) {
-#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 		/* Under irqfds.lock, so can read irq_entry safely */
 		struct kvm_kernel_irq_routing_entry old = irqfd->irq_entry;
 #endif
 
 		irqfd_update(kvm, irqfd);
 
-#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 		if (irqfd->producer &&
 		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry)) {
 			int ret = kvm_arch_update_irqfd_routing(

base-commit: ea9bd29a9c0d757b3384ae3e633e6bbaddf00725
-- 
2.49.0.rc1.451.g8f38331e32-goog


