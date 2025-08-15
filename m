Return-Path: <kvm+bounces-54730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C35DB273CE
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:28:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2838F602061
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347B21C84DE;
	Fri, 15 Aug 2025 00:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hBNGcFqz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73581B21BD
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755217555; cv=none; b=iRKEQb6BYpxt5xR6aeY9h+jD9jhFMm8gHEzSTvFfUxgPUp11tMxCoPwdTxrH9d34fXiFVKqt3edSM23vo+2W13cLnwOcIWziBuny64OKxpSrTfwpzC6wwnIHt90qS5gtgILAK7X7dos+kBTL8ixKe5sYhDuNr2gFhRvtHderW+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755217555; c=relaxed/simple;
	bh=MmffWN1IQs8fm4dHi/LvLLzMxd/gkxVlq7LuwvLwRE0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SA5OS6tqIvenoXkke1YZzBIvcGJ6zNBpPE2JRWQM8Q3c08J9SynVGXJWEx2r0s52+fNcXC07TIoFST1uFrG9WWKwrK+OAFS4JkDZJk+/pTUQo3m5VAuQXqXFgU5h084hgy3hrcYmIgoCellxCkHtqap8yj8XULYJ7kTtDUJx3F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hBNGcFqz; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47173ae6easo2003669a12.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755217553; x=1755822353; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nyWRaldVBsqLHDSF1EOGTWo1xUQuV8Ie9MqemiUHrmw=;
        b=hBNGcFqztSLNcxelJE38pZKxuocW+MZiCwK1eG4nwqOn9894VsSYVV7gIXATo3E0Rp
         BslS3GKgdqX++9/6+7KKB7EhDjFenC08qsnnBv+pYw3Vxs5LrgFjCUjBd65Ua55LmVPj
         aNzH0NttehUdpEiPm8XrtFSiEw38HBLc3XUhD7GX2RVX9qcNVbahcXPnKnepgw++EB5L
         +k9x3g+SjUvAUdcvLEIalcvmnFmYoQ1WISHtF4GysZ4Trx3hLrsM//p23TaDKvJ9/g+J
         Mlb2FRqMHWqeUBL+1W+7vyrq0JJgTn6qmorIJtraSyMPRyPTaYUZm7cNDM9zh7IPkD/W
         Ki6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755217553; x=1755822353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nyWRaldVBsqLHDSF1EOGTWo1xUQuV8Ie9MqemiUHrmw=;
        b=lGrZYY9R9v+NmSbJ3TrNFaAYqKeKqQ4EJ5niv2x3SPGZEzMQoHHSCmNWNPT2FL2c0/
         eixq72MtF1VJvkE++4SzdXJ0wavCOlhCyL4k62YIE/UZDUcONOLOE7O0mnTCNBetI3BJ
         zZQ8i6zMk+Tk6C3Yit/sQjmLRz20ISQJ49oHIHMgHgpFcFTreQh69rW+vY7khDAlebBV
         bS9DcaSK15W6hsu/3gxJNj4wfprcydwtFUp6681pJ8OG4uHN018NtU/R1+ISC1pqc6ei
         762i7HA4UCBod//G5BPwJ6wBzre0RfGPXX7TrL9mXlIKOEcn2RAuTAQuBVkB5Qkvu9qv
         eCZg==
X-Gm-Message-State: AOJu0YwWfA9ANh34/Sonp+gK+b2iydWlhWkQlwqWtW4NAsVPxIheZCPs
	UzMZ6qp8azgao8g+PJd9OXvlIaG97Bk/bFQsNQshiR6Dm5D5xcNpCehjsBUKTXT1Ty9P4okb1eL
	3PvMJIg==
X-Google-Smtp-Source: AGHT+IHMN0kKot/KzIH6X5phgioTA46PF0pTZ0MP0Bgz335zIDfL6xFv+c+JMRRQLmxK2iIcVLlRDteyZhs=
X-Received: from pgc14.prod.google.com ([2002:a05:6a02:2f8e:b0:b42:1e34:a158])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1592:b0:240:6dc:9164
 with SMTP id adf61e73a8af0-240d2da1fe4mr351714637.15.1755217553034; Thu, 14
 Aug 2025 17:25:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:25:25 -0700
In-Reply-To: <20250815002540.2375664-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815002540.2375664-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815002540.2375664-6-seanjc@google.com>
Subject: [PATCH 6.6.y 05/20] KVM: x86: Take irqfds.lock when adding/deleting
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
 arch/x86/kvm/x86.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55185670e0e5..bc52e24f1dda 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13256,16 +13256,22 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
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
 
@@ -13275,9 +13281,9 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	int ret;
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
 
 	WARN_ON(irqfd->producer != prod);
-	irqfd->producer = NULL;
 
 	/*
 	 * When producer of consumer is unregistered, we change back to
@@ -13285,11 +13291,17 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	 * when the irq is masked/disabled or the consumer side (KVM
 	 * int this case doesn't want to receive the interrupts.
 	*/
+	spin_lock_irq(&kvm->irqfds.lock);
+	irqfd->producer = NULL;
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


