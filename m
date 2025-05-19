Return-Path: <kvm+bounces-47041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D2C74ABCB6B
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:30:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E073C189AD25
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88092221FB1;
	Mon, 19 May 2025 23:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eE1w/xdx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396A5221D92
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697306; cv=none; b=XR6Hmwjdy4QVt4AmhE2s23ThnMUw9HikzTxiJ785sAMeocj3faZtwiXedJ6XB/bgaU4uu6tda4oFWX69oB5l2FrhIljgKpoBjMkE1a6IdQMBIAkaC27IuDcPvmtgmyso+xFkgyv6D7gp9iJaut/nl58/NIXcOrM/N7QhDE5YjJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697306; c=relaxed/simple;
	bh=DxxAtdli8YLcSYXG2cyhc1Qhnv1N2EL2kPaPo+nEHRk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MoMnBRwvFYsrPAWN9XoIWTJUw7QkqNrju0bgVDYGagNH+lbcZHaIZFRMpTX+1PS4w0SXjVFSJjaIMuNyQIh7J2STlz7rQCa5SYbmlNooFvwk6DY3t0VxUscOVcdF0neAvYn5IgtAzVf85QTXO2i4llpF2kjldv25ylmlEVwJwNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eE1w/xdx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e7c25aedaso3057682a91.2
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697304; x=1748302104; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6sutRc/njb8rhVGLfAVAjC870Mmm73jxB+i6PD25/Ys=;
        b=eE1w/xdxnBFEKb7nugsUk+tmoivjyh4eifGZdJJBSQIqcIpsif1f3ESiqBG960QZGP
         tYchDgV5Tj3kQ05jd2/GXUR1AoESXtp6m4lmK9HF4qdg++oGTr4Pb6pow5WnuG00KsYS
         pOWjrdAk8+OH2Ndhy/+WDA0uJ4sDrGlOxOatMfJF5UE35Kd3ZcBsqAQL3v/ISwswvnPy
         uqFh8OxrTZEnYhGj7mktTn6ad9wLSNGM5FhE82RJXn9lUYVhy4FgRYj2f3XoO03OpC4i
         KHjqRuL5Ehm8PnOot+5KdLh4HmCO2qfQJez7fHesGH3K9eH20cPogctWvkort/GvnUdv
         LNKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697304; x=1748302104;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6sutRc/njb8rhVGLfAVAjC870Mmm73jxB+i6PD25/Ys=;
        b=oUgoxFGegY5YlF+LN4Kep9AYWRWJBj5Z/ea+HB6xuWPEvYlFllfF2o2tOCz5BAKHGt
         fLgHoeHK4Ud/snJf11jwPEDUKH7PNQZszHd68fSGdaLoqkyQp/ngsV7oco4Eely0nXDB
         J2MljdJth/v5ouGtWYo7GkvgrYnQ5nN/EyCV1gj7OyEi/7ztgz9XAB0Qv4Vdci8bHfVd
         aoB3ONG32K9LoQ47m3+kv/uTLRFbnWiLGL5/5CR0rYZGTOoMt/SWEbsdtGoSVOdTiD7S
         P/aPttAtkC1DyBnvjrMj4nqB+QFlAr/qnR4NKGE5AWF8BaU0jB5H9yx3hPwfn9cgqt+n
         EHaA==
X-Gm-Message-State: AOJu0YyBcOHPXmTP4e6aO7ijsmtNxbcBAyaqUjML0AZJz4nnokTtku+X
	z5D3NE554nDZcjpnO3XdnsyWCFNx+uhkCoZERT5KhFGqkpYR2iGDvBDChULLn+lXwHR/3joU7+N
	+EiVSiQ==
X-Google-Smtp-Source: AGHT+IHGPBMajla04MgxrlVwsVQli9dUbzxkAy7PKtDrGVE71mvqfTNjDQWwFxF9Xl/sQL5zU8TiFFsVVXs=
X-Received: from pjbqa8.prod.google.com ([2002:a17:90b:4fc8:b0:30e:85f1:6fa5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:534e:b0:2ef:67c2:4030
 with SMTP id 98e67ed59e1d1-30e7d5b7599mr23570889a91.27.1747697304606; Mon, 19
 May 2025 16:28:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:27:59 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-7-seanjc@google.com>
Subject: [PATCH 06/15] KVM: x86: Move kvm_{request,free}_irq_source_id() to
 i8254.c (PIT)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move kvm_{request,free}_irq_source_id() to i8254.c, i.e. the dedicated PIT
emulation file, in anticipation of removing them entirely in favor of
hardcoding the PIT's "requested" source ID (the source ID can only ever be
'2', and the request can never fail).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/i8254.c     | 44 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/irq_comm.c  | 44 ----------------------------------------
 include/linux/kvm_host.h |  2 --
 3 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 739aa6c0d0c3..2a0964c859af 100644
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
+	if (!irqchip_kernel(kvm))
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
index 998c4a34d87c..8c827da3e3d6 100644
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
-	if (!irqchip_kernel(kvm))
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
index 963e250664d6..0d4506598d62 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1780,8 +1780,6 @@ void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
 void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
-int kvm_request_irq_source_id(struct kvm *kvm);
-void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
 
 /*
-- 
2.49.0.1101.gccaa498523-goog


