Return-Path: <kvm+bounces-49179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B88AD6345
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90BD5189E648
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243872D661D;
	Wed, 11 Jun 2025 22:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mkAkgHbe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A0D2E2EF4
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682075; cv=none; b=JnWO9k9zijf8BAuVHMsA1AuOPbW88ihpw9tOoCqFYIukzSmx/eJHptY4kxDP1cctDU5wfYsLC/n++8ivfzX3Gc9zwVG/oKVEoU8dZ2C6+6w+BDaiOkcvlACUenswY9gmY9yAxH1DUd/A4jd4fSsM1yJRSgwlGjvCDFnwJnJ8x0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682075; c=relaxed/simple;
	bh=wHrhMmAPxECbumBhisr6CeJaFww9/hh84HS6HonITio=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KQ5DpOezXzov/pYCcZcVNDb97W8WrJklkTFYjx4OfOiTweYYGWyDs8GSgt2MsKXxTePZA/cxFU3h3AX6tuSF0xrjwh4s+3T1SEwyl3aR6C6A50CBDOsjvlOsMamdUtrUM1YZpCTZerGWq0h5xJyVezFI6sdEm5P88HvIu/YD2ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mkAkgHbe; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7377139d8b1so263383b3a.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682072; x=1750286872; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eWPqxy/EcaIBVD9x6tvhc+E9e7T+tuW/T8x9vMu/aCc=;
        b=mkAkgHbep6A17bS0NYV3urBxTVMGbEUsX+q2XT3OJOnMZppXqsa5QT8G8LrlIzh0P6
         P9HyNFynS4W6jp665iP5sxbzitVxrcaohDQ1+G8kppwwO8vFOx/Bq9z3j5DaFo/Ezh+4
         X7me5b5ztbHskG3yklEuAFzzp/93J2a5y75V0WDG02vMPEWstZGDxZPd6+NJcgSqg8PZ
         r4RuD9OcDSdDgNvdm5/i6tSARtxgEhDTLRsrJZgUwpCryzqRzTxe2a+B3Zou7AUpUf1P
         bWsPGg58UM7DzbW074vX6kbE4m2ObvzXVzZnEKOIgvhT33kQrJ+cywTpah2w4abi6q+r
         WqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682072; x=1750286872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eWPqxy/EcaIBVD9x6tvhc+E9e7T+tuW/T8x9vMu/aCc=;
        b=VPff8H1CtnCchuEuYX26cG3c3czuRwhnpw/dRNz2a7wxcWrJ92pd0lSfP0QrXRIH9d
         1oDDVQ/EJhvMteUwx/rSWVaU8ZVsGd/pEE6qC0k5iyRG4bzCWku0Z3zy1pB1Bx3uyI2v
         m2oCxFEafx5E7kZ4EzbEAcpSQNaFIPCP2A1+w942BtCoX04pQIILJBl29Bb2vraFsd/T
         04/MY8RaKIlIqujurnPscRcoyeHYetZ1XIUnLX9rGWVXo+WflHGGCilzivEBoV3kz4o4
         0xBzG9t6VaAffmseCuHJjzl1nrLlxstqiEVY6ZvGAcgvqWvgCEPG3htZRkbcZkUHhIFS
         20pQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+BNBvqX7xtrkEINtC92spketJfXt6FY5aC99HKhrKqYKP0B29ogq6lqumqaU+iOl5ZUM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs0gvTE+FIrFBNFlV4UHcbBiS70tiHHNLXklRHAYUnTAUm+w/s
	KjEV0szfOrkaQz8xb+3p4RYZQL5n9KNdFSkkXtcSSqriveTMoUndyVgXIQGFRZS9iki9GJVXLgF
	tzj0Okg==
X-Google-Smtp-Source: AGHT+IGEG5h+XdvBZsfOP4WIVoU6EIbIQoZeJBB+YTLPLiy+efdbc+9aZGANnnVVnd62MBQByP1coVKnSpY=
X-Received: from pfbhj8.prod.google.com ([2002:a05:6a00:8708:b0:746:2747:e782])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:22cf:b0:748:2ebf:7418
 with SMTP id d2e1a72fcca58-7487e2dc74dmr987606b3a.24.1749682072521; Wed, 11
 Jun 2025 15:47:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:36 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-35-seanjc@google.com>
Subject: [PATCH v3 33/62] KVM: Fold kvm_arch_irqfd_route_changed() into kvm_arch_update_irqfd_routing()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Fold kvm_arch_irqfd_route_changed() into kvm_arch_update_irqfd_routing().
Calling arch code to know whether or not to call arch code is absurd.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c     | 15 +++++----------
 arch/x86/kvm/irq.c       | 15 +++++----------
 include/linux/kvm_host.h |  2 --
 virt/kvm/eventfd.c       | 10 +---------
 4 files changed, 11 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94fb2f096a20..04f2116927b1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2761,20 +2761,15 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq);
 }
 
-bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
-				  struct kvm_kernel_irq_routing_entry *new)
-{
-	if (old->type != KVM_IRQ_ROUTING_MSI ||
-	    new->type != KVM_IRQ_ROUTING_MSI)
-		return true;
-
-	return memcmp(&old->msi, &new->msi, sizeof(new->msi));
-}
-
 void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				   struct kvm_kernel_irq_routing_entry *old,
 				   struct kvm_kernel_irq_routing_entry *new)
 {
+	if (old->type == KVM_IRQ_ROUTING_MSI &&
+	    new->type == KVM_IRQ_ROUTING_MSI &&
+	    !memcmp(&old->msi, &new->msi, sizeof(new->msi)))
+		return;
+
 	/*
 	 * Remapping the vLPI requires taking the its_lock mutex to resolve
 	 * the new translation. We're in spinlock land at this point, so no
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index adc250ca1171..48134aebb541 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -610,19 +610,14 @@ void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				   struct kvm_kernel_irq_routing_entry *old,
 				   struct kvm_kernel_irq_routing_entry *new)
 {
+	if (old->type == KVM_IRQ_ROUTING_MSI &&
+	    new->type == KVM_IRQ_ROUTING_MSI &&
+	    !memcmp(&old->msi, &new->msi, sizeof(new->msi)))
+		return;
+
 	kvm_pi_update_irte(irqfd, new);
 }
 
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
 #ifdef CONFIG_KVM_IOAPIC
 #define IOAPIC_ROUTING_ENTRY(irq) \
 	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8e74ac0f90b1..fb9ec06aa807 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2413,8 +2413,6 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *);
 void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				   struct kvm_kernel_irq_routing_entry *old,
 				   struct kvm_kernel_irq_routing_entry *new);
-bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *,
-				  struct kvm_kernel_irq_routing_entry *);
 #endif /* CONFIG_HAVE_KVM_IRQ_BYPASS */
 
 #ifdef CONFIG_HAVE_KVM_INVALID_WAKEUPS
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index a4f80fe8a5f3..defc2c04d241 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -291,13 +291,6 @@ void __weak kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 {
 
 }
-
-bool __attribute__((weak)) kvm_arch_irqfd_route_changed(
-				struct kvm_kernel_irq_routing_entry *old,
-				struct kvm_kernel_irq_routing_entry *new)
-{
-	return true;
-}
 #endif
 
 static int
@@ -617,8 +610,7 @@ void kvm_irq_routing_update(struct kvm *kvm)
 		irqfd_update(kvm, irqfd);
 
 #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
-		if (irqfd->producer &&
-		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry))
+		if (irqfd->producer)
 			kvm_arch_update_irqfd_routing(irqfd, &old, &irqfd->irq_entry);
 #endif
 	}
-- 
2.50.0.rc1.591.g9c95f17f64-goog


