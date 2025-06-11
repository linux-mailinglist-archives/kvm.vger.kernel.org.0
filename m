Return-Path: <kvm+bounces-49132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79675AD6188
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90950177E7D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088A425745F;
	Wed, 11 Jun 2025 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eylpKjSU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1D1253F05
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677779; cv=none; b=IGJQVUsSKvrDwBmkowzDdrFn2rK1TrpMuDFkI4PESfNWBFxXj7jhDMTGCxbdGHZMgv+8jA2cIt+aJ5vjFTDvQd52wUr5IOfYhWH476DCKt5qnaAU/LyAHOiN7vEKIDoZV0Gm6t3q+AZ+SERN9t6qqNwV6cRoJFRlqBiL5oV/Uog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677779; c=relaxed/simple;
	bh=+vYrgJY1+/1o07RK4HZUh7EncKERE3O3MBachh0luvA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OaUYQDCD7iJFskrnYGSShkIWjaN8hQy0OONaUX/oBkquYotPyZXDwKEeyrFR41t5mmzn/aPf5D561hnLWdoyd2sEaRv5KL0oyzgl2YT9WDWCiHjsjtxEQKMeCrVGl08na8LxaWQu7y/iiKnvQgOmes/E1hkVtSWjXyh5wxo0hA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eylpKjSU; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2fa1a84565so100947a12.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677777; x=1750282577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=afviLMdVVwZckbxRv+VEZNnw8Pog0zIlB+4nuAi0opA=;
        b=eylpKjSUBOUwmPeaM6afliuGW+5lIGVadVKBUU9GQeP1X8eOUydDgwzZnaeKirP1nO
         cXz/kWacejmdMmz255JDL3Yr4uKnP7o/ZWxLog4fjz1imxkUYAPcOcU4oC6afHhHDBCq
         7IsFVX/bbqCqFRLaQLI/ZZuRRRxVAiumQKHcH5aMjK7Obs1V92QuKvdH3RkSkEMSbUNx
         CpMAa8zeDPrZaxWNjQ535wA3pFEQ/kBwCZpC30HeBjUg0/fMlb84q7m5zZ7nUck7RrQW
         s6OzYynaGVr+nmhjibHIqakk6qPX9rmxdwmYGPIdQ723ZrC4Wwrlj4KPbblswUerdw24
         Eehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677777; x=1750282577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=afviLMdVVwZckbxRv+VEZNnw8Pog0zIlB+4nuAi0opA=;
        b=gG4PgEoTCAnQTthtQg8+o+06aKFwUXgMN08kiJj1p5tXJ1gOb6HbV9gwO5O8YJWCJd
         +m+ap0WZHg5fl1ClPNw/zWo5QbhnqBIy8AJh7VJUs+kkSpZBV6+XriBjp1uHiH92wvRs
         zuXYBYVB1OK7JEAPJh1ASks6gI4PZOpC9Q1UK3pkf885hreFLtdU3q84LahCV3evGUhM
         nFtrQ6EDUSxM81BHqa2ev61GazxFxr/qedSqP6dZhVMxKyEuTkF8oqJtoBtXzSiDWbdO
         yW10aTjqL3IqQkOg0Py7ch5aWcvKUKkRL2dcE1LKZBdQFivQAY695JyOfkwRMSjXx8XY
         sYHw==
X-Gm-Message-State: AOJu0YzMG2spbpYsOjT30xfdjPzNc7iwnwBox3ERY72RI8JTEIfeCIWV
	RexWPMnYdSrST70A1BhJNG8/77wRCNtkdsctk0+pVnE2ce50cgU2lN1qUmoMYW5pBQLGwy72la3
	spQm4cg==
X-Google-Smtp-Source: AGHT+IEJRurOYzy7EBSRytoln369m1CPCouqctswPhetUVJJ/3eBhE1YoV5gyGB5lgBPAN2muoLSu1GC+rM=
X-Received: from pfbbe7.prod.google.com ([2002:a05:6a00:1f07:b0:746:1a2e:b29b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:b90:b0:1f5:7eb5:72dc
 with SMTP id adf61e73a8af0-21f97752d70mr1972780637.3.1749677777044; Wed, 11
 Jun 2025 14:36:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:48 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-10-seanjc@google.com>
Subject: [PATCH v2 09/18] KVM: x86: Move kvm_{request,free}_irq_source_id() to
 i8254.c (PIT)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move kvm_{request,free}_irq_source_id() to i8254.c, i.e. the dedicated PIT
emulation file, in anticipation of removing them entirely in favor of
hardcoding the PIT's "requested" source ID (the source ID can only ever be
'2', and the request can never fail).

No functional change intended.

Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/i8254.c     | 44 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/irq_comm.c  | 44 ----------------------------------------
 include/linux/kvm_host.h |  2 --
 3 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 59f956f35f4c..2bb223bf0dac 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -641,6 +641,50 @@ static void kvm_pit_reset(struct kvm_pit *pit)
 	kvm_pit_reset_reinject(pit);
 }
 
+static int kvm_request_irq_source_id(struct kvm *kvm)
+{
+	unsigned long *bitmap = &kvm->arch.irq_sources_bitmap;
+	int irq_source_id;
+
+	mutex_lock(&kvm->irq_lock);
+	irq_source_id = find_first_zero_bit(bitmap, BITS_PER_LONG);
+
+	if (irq_source_id >= BITS_PER_LONG) {
+		pr_warn("exhausted allocatable IRQ sources!\n");
+		irq_source_id = -EFAULT;
+		goto unlock;
+	}
+
+	ASSERT(irq_source_id != KVM_USERSPACE_IRQ_SOURCE_ID);
+	ASSERT(irq_source_id != KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID);
+	set_bit(irq_source_id, bitmap);
+unlock:
+	mutex_unlock(&kvm->irq_lock);
+
+	return irq_source_id;
+}
+
+static void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
+{
+	ASSERT(irq_source_id != KVM_USERSPACE_IRQ_SOURCE_ID);
+	ASSERT(irq_source_id != KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID);
+
+	mutex_lock(&kvm->irq_lock);
+	if (irq_source_id < 0 ||
+	    irq_source_id >= BITS_PER_LONG) {
+		pr_err("IRQ source ID out of range!\n");
+		goto unlock;
+	}
+	clear_bit(irq_source_id, &kvm->arch.irq_sources_bitmap);
+	if (!irqchip_full(kvm))
+		goto unlock;
+
+	kvm_ioapic_clear_all(kvm->arch.vioapic, irq_source_id);
+	kvm_pic_clear_all(kvm->arch.vpic, irq_source_id);
+unlock:
+	mutex_unlock(&kvm->irq_lock);
+}
+
 static void pit_mask_notifer(struct kvm_irq_mask_notifier *kimn, bool mask)
 {
 	struct kvm_pit *pit = container_of(kimn, struct kvm_pit, mask_notifier);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 99c521bd9db5..138c675dc24b 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -165,50 +165,6 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 	return -EWOULDBLOCK;
 }
 
-int kvm_request_irq_source_id(struct kvm *kvm)
-{
-	unsigned long *bitmap = &kvm->arch.irq_sources_bitmap;
-	int irq_source_id;
-
-	mutex_lock(&kvm->irq_lock);
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
-void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
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
-	if (!irqchip_full(kvm))
-		goto unlock;
-
-	kvm_ioapic_clear_all(kvm->arch.vioapic, irq_source_id);
-	kvm_pic_clear_all(kvm->arch.vpic, irq_source_id);
-unlock:
-	mutex_unlock(&kvm->irq_lock);
-}
-
 void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
 				    struct kvm_irq_mask_notifier *kimn)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9461517b4e62..cba8fc4529e8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1784,8 +1784,6 @@ void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
 void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
-int kvm_request_irq_source_id(struct kvm *kvm);
-void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
 
 /*
-- 
2.50.0.rc1.591.g9c95f17f64-goog


