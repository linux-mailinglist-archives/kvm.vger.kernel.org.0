Return-Path: <kvm+bounces-42690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C7FFA7C401
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:41:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8403D1B61688
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6569A221DA5;
	Fri,  4 Apr 2025 19:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="axIjS05k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF53922171D
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795596; cv=none; b=lW/sf9LF2IQWLo8T0e8RTYtPNm44HKkW5F0FP62o/gd58Vn/62yVcGelCc+wQVKdxuFGwK2ZZQ3Yf/yX9MXk0/VU/BSQZx13Ti3BhVjHGL7uq6hvuWOdjZnEL+/yPd6VDQhDB1HkA5X3ua6wfvk/jPwgarA3D6OG+sQTvFP0ErM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795596; c=relaxed/simple;
	bh=zvROXmjtL1IIWkXeJFgdhMrAr1KnWI1Z/K2ADvFL0ug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TBLVgApWn7NIpYUlaMCCvl1w1f69Qk2zz9Fxe+lhd9HvVt4I/waUTosOqmAzReBzKIE2a5Y1ZzSrV2Sk6Cfir8z4qJRuLgUp3cCvIFh96RnVh7WtPT+6RvX6QTBywLtIeV240qcG/1Fo2XbD4rRV+W+97B7xmqvviQJCuSzQxVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=axIjS05k; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736d64c5e16so2096865b3a.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795594; x=1744400394; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RGxOMNtpRYtvYPUfMG5TmBHR1pFGxtORoL82B7xlqeE=;
        b=axIjS05k0wlvUfolX7qcCU9p6AiPh/ykag8O7FX5ExQy2znj+Xqtt9ME/buLrKrVTr
         kRpKpLx46gQdCIR2D+RI9nfESn5bDTl4RFaYlsn/tn43pRI4qrXD+pBlwCZREsEyzNt1
         vGZLPqRx+NyynVKeN67l2Mcl9SNtSCUKT09tGzx2T06zcTpnYLDZIg4b2gBX+nV7GLS/
         E89tyA3i60KKk9s2EyFbSA4kUL6rf0bCFBzLm8Yx2j81aGuHxrs08ZaanW7vofwLzc9d
         KiGbYjNeGoxM0bu7YwQbWhBIoB27IX5tTQPwv3vqKpaAIY05S2iaRhCuWmt0FDDqlCAc
         ZUQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795594; x=1744400394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RGxOMNtpRYtvYPUfMG5TmBHR1pFGxtORoL82B7xlqeE=;
        b=IdQ60Czsv8MS4dsTgWmskOonquzA7/kPy2x7o4zrH4NdfBnn0SUflQ8Npz5XLmGT+Q
         dGdwKQwL74zhlw7J92Posj8Ow+MsbvHn1TwWsSMOpn5SpYdP1ehDoh/fpNr2SIvhri6P
         mGawoAqszzU7vazgYMiNUYfuU3sUSLooWaLp+CRI/+U0b6Jps2jmXAYXKS0bZVn10Edj
         Ey25yBFj6UPgxKHYtJOKn1ttlqZ+ljW53Q4X1rDDxk0I9Jz62ilHjDfGVVzFZjZdjGUp
         VMsdEM1N9BZoJSSsgIqNldpxs73KDdoKIjnSEtvW3GoXlLPEabFenLeJPRIvA/8OWLzc
         Cy1w==
X-Gm-Message-State: AOJu0YyGvXxDoEUF7cvX1HRF0yc2QZ69s9FerzPSM1borQ8g0Stmx4NE
	BRTog996ciqF9eJF2loNGbVAEVJjbbV/nc88rk22l04Cg1Esdyp0EE3YXC/QYnwybTeu5wYv7MV
	xWQ==
X-Google-Smtp-Source: AGHT+IEQIRfv5MQyN5FPXlDH0jiZdTHciPaHWXw+Tn7fs2rQ/C2nsY1CH5202uPXIoXMn1X9vHNvV8pVCeI=
X-Received: from pfbfa9.prod.google.com ([2002:a05:6a00:2d09:b0:739:8cd6:c16c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2442:b0:736:6ac4:d204
 with SMTP id d2e1a72fcca58-739e4855dd7mr5053725b3a.11.1743795594255; Fri, 04
 Apr 2025 12:39:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:19 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-5-seanjc@google.com>
Subject: [PATCH 04/67] KVM: x86: Take irqfds.lock when adding/deleting IRQ
 bypass producer
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Take irqfds.lock when adding/deleting an IRQ bypass producer to ensure
irqfd->producer isn't modified while kvm_irq_routing_update() is running.
The only lock held when a producer is added/removed is irqbypass's mutex.

Fixes: 872768800652 ("KVM: x86: select IRQ_BYPASS_MANAGER")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f94f1217a087..dcc173852dc5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13569,15 +13569,22 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 {
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
 	int ret;
 
-	irqfd->producer = prod;
 	kvm_arch_start_assignment(irqfd->kvm);
+
+	spin_lock_irq(&kvm->irqfds.lock);
+	irqfd->producer = prod;
+
 	ret = kvm_x86_call(pi_update_irte)(irqfd->kvm,
 					   prod->irq, irqfd->gsi, 1);
 	if (ret)
 		kvm_arch_end_assignment(irqfd->kvm);
 
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+
 	return ret;
 }
 
@@ -13587,9 +13594,9 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	int ret;
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
 
 	WARN_ON(irqfd->producer != prod);
-	irqfd->producer = NULL;
 
 	/*
 	 * When producer of consumer is unregistered, we change back to
@@ -13597,12 +13604,18 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	 * when the irq is masked/disabled or the consumer side (KVM
 	 * int this case doesn't want to receive the interrupts.
 	*/
+	spin_lock_irq(&kvm->irqfds.lock);
+	irqfd->producer = NULL;
+
 	ret = kvm_x86_call(pi_update_irte)(irqfd->kvm,
 					   prod->irq, irqfd->gsi, 0);
 	if (ret)
 		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
 		       " fails: %d\n", irqfd->consumer.token, ret);
 
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+
 	kvm_arch_end_assignment(irqfd->kvm);
 }
 
-- 
2.49.0.504.g3bcea36a83-goog


