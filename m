Return-Path: <kvm+bounces-49173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9533EAD6338
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:57:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26227189936B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F4D02DECBE;
	Wed, 11 Jun 2025 22:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H6CXvzgn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BD82E62BF
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682064; cv=none; b=lEJ1mB3xc8qWKN33XbHtN25WHY4c8XZVJDIGxfAGrhiPoDa2AqedLpjiotvQq1i+sj1/a7KKv69fYLNsQA+c9ACp51Y6ATXnG5RRdIU3M75HMZXD0Rc/aXMj8Gyh9JbNOyDB+7PCexS5QARZPdpttfoHaRs94mmCzsEplpj7jSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682064; c=relaxed/simple;
	bh=uXv1JJhJ7y+b5ncL0qkl5w2p8YdTPS1EEOU//fa5q8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jTzUW+xnQ67LboTBSadEK4BwpOcAP0mXtg+Ym2SjWfqQXjd1oykfFMPhPSgQMRcWCjg6C1tQBIj2b14zCy0smnkq1GbPay16JNKD55qLmGLqlT9l2YN0/eifUXrc85U8yfBIeVld3lXHZ2S9sT91pT2BuMW75AvUXItrtk7iSqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H6CXvzgn; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747d84fe5f8so176964b3a.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682062; x=1750286862; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hWHk4g1Vwy67+s92oAAb3P4JIkRwWseZejUTZj9H+ss=;
        b=H6CXvzgnKVxhnydBJKbB93vJQ6CZ9sl5517qYYEnwMOOqH3iwZUnGzA8oABZTgCBJk
         pum/h/iQbJO49huJWsDGijIBbUlI7bw6MJDBcBiyvPggSXBMNqUoV3gWeVNBoCfVO/R8
         vKRgbU/dcTyqNz0i/85ad3jao7dYbAtq38ClnsDSSHJd8PNWywS4zBIRuxHmrlxgN/YI
         Rp+O/glP38PUe9y5zyDP7xDleOWgjcC8/L9fYRQDy+wq/cPuYfBk1kCnLBPF+asP8Rq/
         DsTPRZDexa0do7ue//rzXFJcVO1+HTk3yyCXPglZYvWAatfw+So4XJITPOk7JJ2o3eu4
         HV6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682062; x=1750286862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hWHk4g1Vwy67+s92oAAb3P4JIkRwWseZejUTZj9H+ss=;
        b=qs6sA4h2uu5kNcWMApv5hLzkTQHrhz+1WISRdYkUw05GVh8kmXm7xsDLo6GW4Bv8aY
         SZoesXvvYw6NxE2E6WZY7kB0ZoNtfOSoPI/T7yImIkyb57DQzJ7eljfoulwXVRi6j52j
         qzI8wQLcfSEgvGYxQoe/HgPmLJNCParSFwHiZA9+zxSavnILo/r+2FCSx63oWLC6LaZf
         F5BNei7hDCbHeikwweh3sE6jbh4293ZK99fqwLtNMgmmicxfwzMVGnJZg3F7AWyHlEvu
         nqq65Su8tFZtD195+oZyt7G9vy1Z+7cVJrl0FGfZnigaRlF8moEm93inF7hV5ENZboFm
         TGDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbuFijRQpjOeJkvYYCR/U2LAfd8FKdjhO8cxl9hGh3zMiQN1pbeBGmyxppnL4L4hNy6Wg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVzxkQXUIGz0K5YqoCTuLbXW0kToXjIbRlIPFtUIvpUSe/S9Rg
	3p0raAW01iPtNe9iXJc3d4dJ7bIpUDQJkI0XbqyecfRXd0Rrm5Dh1pdZZvYXRNE6V8xbD/0spiH
	lPneg9w==
X-Google-Smtp-Source: AGHT+IFmVhbjucYXuzMglz700r5SKDcVNbLOfHQ/SQsr3MFTg4okaXCI4Ylw5BtYSrn3coqW+U0cp+uUzfA=
X-Received: from pfbhe19.prod.google.com ([2002:a05:6a00:6613:b0:747:a305:836a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a89:b0:748:2e1a:84e3
 with SMTP id d2e1a72fcca58-7486cb4a9famr8199641b3a.8.1749682062215; Wed, 11
 Jun 2025 15:47:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:30 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-29-seanjc@google.com>
Subject: [PATCH v3 27/62] KVM: x86: Nullify irqfd->producer after updating IRTEs
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

Nullify irqfd->producer (when it's going away) _after_ updating IRTEs so
that the producer can be queried during the update.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index b9d3ec72037c..09f7a5cdca7d 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -549,7 +549,6 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	 * KVM must relinquish control of the IRTE.
 	 */
 	spin_lock_irq(&kvm->irqfds.lock);
-	irqfd->producer = NULL;
 
 	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
 		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
@@ -558,10 +557,10 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 			pr_info("irq bypass consumer (token %p) unregistration fails: %d\n",
 				irqfd->consumer.token, ret);
 	}
+	irqfd->producer = NULL;
 
 	spin_unlock_irq(&kvm->irqfds.lock);
 
-
 	kvm_arch_end_assignment(irqfd->kvm);
 }
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog


