Return-Path: <kvm+bounces-47474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F84AC1939
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39B0F188C285
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E70C211488;
	Fri, 23 May 2025 01:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vNYgxjyV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B514C2797BF
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962053; cv=none; b=lCRuMfLh8KxfBNYGngqt7Rwmw1tmdJsmlSIcfV1zFDTonIGqY8I9gQ/loz++z/Ru2Lx0eoAPE36GHepA5JmfqzSLpogPdpgKoSdBrBTTINHmjgtIIebu2DdZoS2ZqRU9RJSZNja9QmHh8Lbpz6dbt0IZjQ5Ks5NH95rkryr3CAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962053; c=relaxed/simple;
	bh=CXftmt6Rv0xuDp1ncXMCQ2Iq5vWS80lFiGXqp9hH0Wk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qRw91N1mlSZpy38t4xVM1VClP9z8fMM1Rxt263/OFrDF5mhfbgUl4C8rT3fMdWLbXI2Qv+lYOK5/tkZ9HxEZeBuzxjPiQ+0B8ZqHkmLnvmZB/rvJ8aNh4QALOqc1IgU2ix1YmlAM9qXHjAJ9ZqglK2x38ZoYU512gNtpu1ddjwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vNYgxjyV; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b16b35ea570so8471231a12.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962051; x=1748566851; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rKGx/dcplKQAs++4ShZiLUsnF0fAAm6Wg1gHjnqOhAE=;
        b=vNYgxjyV9URebtAUlmMNdEzdVaZGYANMH5YEAN5FIpJFURnQ4NCjl4EoKOba5zvEWj
         UBeJaDNSwQIDLpTQ+z2suP1VCkngXcWJw5DbH6Yb6ny3W2cLbE4SRL8CV/r+33vqACYK
         urvJEjIynEK6j9TsinKx7h+06Ny+Xkl5ZP/yxG6e3uojjOoPwvHLE9kEX8XQ8f9cMocq
         xa1BpEVoPjgR3b9m7tbzL1axNm0gDJcYxTov8ehl9SBpy/Oxh7QSEydG/6fMq+zbM4SY
         QbFDgzbZfR1xPR7f3KJ2I01q8US5swM/lfe1tPq6oyDVApCQB6gZpz4ZaNGcheZzSVtb
         S2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962051; x=1748566851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rKGx/dcplKQAs++4ShZiLUsnF0fAAm6Wg1gHjnqOhAE=;
        b=BDH561ZLWc+H6ENPNEJlvPVyZeQwGkq+KwqlotBOaSbPj7pnoIo6OI1IKVaJkxbNKx
         gaeNXh0Pm1k2t3MoX20XZaHscpgBNTWLn0q0hwRLHCN0lAqlUv3g0FlmHfrEbz1fTNvF
         abYisBam5COb+0wNl5ppWMFOjhMnPQ692o7m1gTpWHCW0a3AlX2Tn1OIjgP1ejivqOdp
         1Au17PROTHRsN2I/gqGCzzX9iL3zRFnMW03VGxTdz6p2zbJHwSasv+hcW35w/IBpGozA
         xaHY8cNQrqzShIDBE2dyCnpsiej2vgj0Mz178mf8szgRDAAxbm7MKsuO/gQrxkFLxHaf
         o/kA==
X-Gm-Message-State: AOJu0YxZCIh8T5fvcbtX/W0V3g26U3t7nxB3vy4dP1j/buUE06uSCeTn
	mXhAfM4t3a5Dsl1yT6CW1PzV57ncmdjwRjhtV3UZ5ZGGg7O6Zj+8qLgQ/qlzR9mkkpzxt95o8j2
	F3JbiDw==
X-Google-Smtp-Source: AGHT+IG0lW4uEVpvpd+X7AgmnpqUOdNQN1x4hf8EtHj36zwvoU1Ib5gejTv/GUolVnEbYv2D7W5sxDw/nR8=
X-Received: from pjbpm9.prod.google.com ([2002:a17:90b:3c49:b0:308:64af:7bb9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:54ce:b0:30e:8c5d:8e4
 with SMTP id 98e67ed59e1d1-310e96e73c8mr2089364a91.16.1747962051165; Thu, 22
 May 2025 18:00:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:29 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-25-seanjc@google.com>
Subject: [PATCH v2 24/59] KVM: x86: Move IRQ routing/delivery APIs from x86.c
 => irq.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Move a bunch of IRQ routing and delivery APIs from x86.c to irq.c.  x86.c
has grown quite fat, and irq.c is the perfect landing spot.

Opportunistically rewrite kvm_arch_irq_bypass_del_producer()'s comment, as
the existing comment has several typos and is rather confusing.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c | 87 ---------------------------------------------
 2 files changed, 88 insertions(+), 87 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 314a93599942..3f75b8130c3b 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -11,6 +11,7 @@
 
 #include <linux/export.h>
 #include <linux/kvm_host.h>
+#include <linux/kvm_irqfd.h>
 
 #include "hyperv.h"
 #include "ioapic.h"
@@ -332,6 +333,18 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 	return -EWOULDBLOCK;
 }
 
+int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
+			bool line_status)
+{
+	if (!irqchip_in_kernel(kvm))
+		return -ENXIO;
+
+	irq_event->status = kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID,
+					irq_event->irq, irq_event->level,
+					line_status);
+	return 0;
+}
+
 bool kvm_arch_can_set_irq_routing(struct kvm *kvm)
 {
 	return irqchip_in_kernel(kvm);
@@ -494,3 +507,78 @@ void kvm_arch_irq_routing_update(struct kvm *kvm)
 	if (irqchip_split(kvm))
 		kvm_make_scan_ioapic_request(kvm);
 }
+
+int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
+				      struct irq_bypass_producer *prod)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
+	int ret = 0;
+
+	kvm_arch_start_assignment(irqfd->kvm);
+
+	spin_lock_irq(&kvm->irqfds.lock);
+	irqfd->producer = prod;
+
+	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
+		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
+						   irqfd->gsi, &irqfd->irq_entry);
+		if (ret)
+			kvm_arch_end_assignment(irqfd->kvm);
+	}
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+	return ret;
+}
+
+void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
+				      struct irq_bypass_producer *prod)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
+	int ret;
+
+	WARN_ON(irqfd->producer != prod);
+
+	/*
+	 * If the producer of an IRQ that is currently being posted to a vCPU
+	 * is unregistered, change the associated IRTE back to remapped mode as
+	 * the IRQ has been released (or repurposed) by the device driver, i.e.
+	 * KVM must relinquish control of the IRTE.
+	 */
+	spin_lock_irq(&kvm->irqfds.lock);
+	irqfd->producer = NULL;
+
+	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
+		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
+						   irqfd->gsi, NULL);
+		if (ret)
+			pr_info("irq bypass consumer (token %p) unregistration fails: %d\n",
+				irqfd->consumer.token, ret);
+	}
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+
+	kvm_arch_end_assignment(irqfd->kvm);
+}
+
+int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
+				  struct kvm_kernel_irq_routing_entry *old,
+				  struct kvm_kernel_irq_routing_entry *new)
+{
+	return kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, irqfd->producer->irq,
+					    irqfd->gsi, new);
+}
+
+bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
+				  struct kvm_kernel_irq_routing_entry *new)
+{
+	if (old->type != KVM_IRQ_ROUTING_MSI ||
+	    new->type != KVM_IRQ_ROUTING_MSI)
+		return true;
+
+	return !!memcmp(&old->msi, &new->msi, sizeof(new->msi));
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b645ccda0999..a9900c246bb3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6549,18 +6549,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 		kvm_vcpu_kick(vcpu);
 }
 
-int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
-			bool line_status)
-{
-	if (!irqchip_in_kernel(kvm))
-		return -ENXIO;
-
-	irq_event->status = kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID,
-					irq_event->irq, irq_event->level,
-					line_status);
-	return 0;
-}
-
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
@@ -13627,81 +13615,6 @@ bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
 
-int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
-				      struct irq_bypass_producer *prod)
-{
-	struct kvm_kernel_irqfd *irqfd =
-		container_of(cons, struct kvm_kernel_irqfd, consumer);
-	struct kvm *kvm = irqfd->kvm;
-	int ret = 0;
-
-	kvm_arch_start_assignment(irqfd->kvm);
-
-	spin_lock_irq(&kvm->irqfds.lock);
-	irqfd->producer = prod;
-
-	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
-		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
-						   irqfd->gsi, &irqfd->irq_entry);
-		if (ret)
-			kvm_arch_end_assignment(irqfd->kvm);
-	}
-	spin_unlock_irq(&kvm->irqfds.lock);
-
-	return ret;
-}
-
-void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
-				      struct irq_bypass_producer *prod)
-{
-	struct kvm_kernel_irqfd *irqfd =
-		container_of(cons, struct kvm_kernel_irqfd, consumer);
-	struct kvm *kvm = irqfd->kvm;
-	int ret;
-
-	WARN_ON(irqfd->producer != prod);
-
-	/*
-	 * When producer of consumer is unregistered, we change back to
-	 * remapped mode, so we can re-use the current implementation
-	 * when the irq is masked/disabled or the consumer side (KVM
-	 * int this case doesn't want to receive the interrupts.
-	*/
-	spin_lock_irq(&kvm->irqfds.lock);
-	irqfd->producer = NULL;
-
-	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
-		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
-						   irqfd->gsi, NULL);
-		if (ret)
-			pr_info("irq bypass consumer (token %p) unregistration fails: %d\n",
-				irqfd->consumer.token, ret);
-	}
-
-	spin_unlock_irq(&kvm->irqfds.lock);
-
-
-	kvm_arch_end_assignment(irqfd->kvm);
-}
-
-int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
-				  struct kvm_kernel_irq_routing_entry *old,
-				  struct kvm_kernel_irq_routing_entry *new)
-{
-	return kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, irqfd->producer->irq,
-					    irqfd->gsi, new);
-}
-
-bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
-				  struct kvm_kernel_irq_routing_entry *new)
-{
-	if (old->type != KVM_IRQ_ROUTING_MSI ||
-	    new->type != KVM_IRQ_ROUTING_MSI)
-		return true;
-
-	return !!memcmp(&old->msi, &new->msi, sizeof(new->msi));
-}
-
 bool kvm_vector_hashing_enabled(void)
 {
 	return vector_hashing;
-- 
2.49.0.1151.ga128411c76-goog


