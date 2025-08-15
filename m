Return-Path: <kvm+bounces-54706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7884DB27368
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FB635E85F1
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1013919F137;
	Fri, 15 Aug 2025 00:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zP5yQsCc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823DFA935
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755216743; cv=none; b=VXzNu0rLhE6RDA7q4Z9mT5vi4trGmuWE+xbR6jqh/JUq/P7sxu5Bczhllh+bfnlsSdxxnr2OIkOdyvSiCnxSiz8Z6UU81sXvBCybEM0h1p3uGX0bwZ8eXeM+CP32wRJPad5pwxZbGZTBVewcJUiVXVPcyF3tuD9pQKIv5onUbPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755216743; c=relaxed/simple;
	bh=VhV9EFrTudTyrNyi+hXz4xZPaoxl5bt2eNREG6X3+KU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hOgrm7oOHe3NxzL3T92pxKHQ8nlgKVkXyRLDW+qOq1amlBKUbKFeqR/Vx/1/GTPKWbk5GKNoVvbxZfBhgF+uKCu0NoPUHZ7BLo7ixUrQS/iK6h4kUnRwW8CKtS3SZ2NpMJK8D5D0b05l0JMV+PaqurvQamOG44oogVeWPFDukmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zP5yQsCc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3232677ad11so1441684a91.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755216741; x=1755821541; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IwosmCXhK1vj9BTxghsFWvBqb4znPc+loO6bF0vRg/w=;
        b=zP5yQsCcy5QpL2kFvKjhxF2peyA3+u4o0TlE6elSG9Ivsg3bBJdnvJ9Y6jBYpmSYgn
         mr/drTREDgzrzZ3k+moyZMe7c2lexPaQxVUSvXEbwJe9XBPa3D/PFDSlHpvRvhMvi+NJ
         0oSws3wpOReY9JsC+BpAMDvbEeiHD21IPSAjhuPoH3nRBKvJi7jULHYsW3eHJHACdNd7
         XyKki0La52diHF9vDvZBqWsCgSa70F7LBiMzei4bB9/4ygQXGWPJhlfkxjU8U2LwfxlM
         7OGAYfBIPHkeG16T5e54deb6zbKWgakdMIcXHC2+2/05dCB1KfkXfVmZ1o0A4kO/9WSN
         wgsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755216741; x=1755821541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IwosmCXhK1vj9BTxghsFWvBqb4znPc+loO6bF0vRg/w=;
        b=FiMYko8IJ4RnR+t1KGsIi++rSdbjd9Dxe3Wso8TVLLlrXcXkmN3QoErzslnFpS0Ysv
         xDCGfO2g2nN30vtpKEy9g7WrsNaVeeEPNyFNIru1f9CzUBiBsDVHgnorIIOd80uDbe+l
         /L5672UqYyyd3cF38IOcbQyKpHh5o4fZNM9EMayss05MGiIgWyhaHBNMsZNAp5w4dcG5
         tKaHzzB4Q8d/NxSAP+DiGMkBY1ESRLIgA+9sRS4oZFZmsEb5JiMwGVirlszVNFPhjPSg
         CETLM9qDxibDjXMY0A2hjKJWaIHVfWRMrieWDygEPgbAUAD8/ySKO0YNtXB+9Z+1cszG
         6Fzg==
X-Gm-Message-State: AOJu0YwKF4cVv7v8/ndvX03ujDcxsU4tEXrTl+jgb9R6h8DZ5yIfvupg
	wJNC5vrKIAAE4YjWOYEQG29lJGvO1ng5HKUD7abYtuQY7Un+99A7+VqMLh6YWzvY4w4pXH9mNmB
	eyzxeWQ==
X-Google-Smtp-Source: AGHT+IGO/jPS6jdJmEtvnGY3PxwPeRyl+ObkL45xgwHrNfQdLHZ7iDlH5jvrHyrHHvz2++/SRO0Y4P+AtJ8=
X-Received: from pjbpq1.prod.google.com ([2002:a17:90b:3d81:b0:31f:1ed:c76e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfcd:b0:312:1ae9:1525
 with SMTP id 98e67ed59e1d1-32341e17c8cmr356019a91.8.1755216740828; Thu, 14
 Aug 2025 17:12:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:11:49 -0700
In-Reply-To: <20250815001205.2370711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815001205.2370711-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815001205.2370711-6-seanjc@google.com>
Subject: [PATCH 6.1.y 05/21] KVM: x86: Take irqfds.lock when adding/deleting
 IRQ bypass producer
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit f1fb088d9cecde5c3066d8ff8846789667519b7d ]

Take irqfds.lock when adding/deleting an IRQ bypass producer to ensure
irqfd->producer isn't modified while kvm_irq_routing_update() is running.
The only lock held when a producer is added/removed is irqbypass's mutex.

Fixes: 872768800652 ("KVM: x86: select IRQ_BYPASS_MANAGER")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250404193923.1413163-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sean: account for lack of kvm_x86_call()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6dc8f662fa4..08c4ad276ccb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13385,16 +13385,22 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
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
 	ret = static_call(kvm_x86_pi_update_irte)(irqfd->kvm,
 					 prod->irq, irqfd->gsi, 1);
-
 	if (ret)
 		kvm_arch_end_assignment(irqfd->kvm);
 
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+
 	return ret;
 }
 
@@ -13404,9 +13410,9 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	int ret;
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
 
 	WARN_ON(irqfd->producer != prod);
-	irqfd->producer = NULL;
 
 	/*
 	 * When producer of consumer is unregistered, we change back to
@@ -13414,11 +13420,18 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	 * when the irq is masked/disabled or the consumer side (KVM
 	 * int this case doesn't want to receive the interrupts.
 	*/
+	spin_lock_irq(&kvm->irqfds.lock);
+	irqfd->producer = NULL;
+
+
 	ret = static_call(kvm_x86_pi_update_irte)(irqfd->kvm, prod->irq, irqfd->gsi, 0);
 	if (ret)
 		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
 		       " fails: %d\n", irqfd->consumer.token, ret);
 
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+
 	kvm_arch_end_assignment(irqfd->kvm);
 }
 
-- 
2.51.0.rc1.163.g2494970778-goog


