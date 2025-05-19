Return-Path: <kvm+bounces-47040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D4BCABCB6A
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:29:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88C8E8C336B
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE4D221DB5;
	Mon, 19 May 2025 23:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DuV24uf9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB8122157E
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697305; cv=none; b=m3bkHKKtiahW/GBqLULY12MFDNpPwYh3FKqbDtVC0Ts2jf6F8oq3ZYgf9mpfcm8e+Z0QHMtB/N9EiDiu2LSINgJqEl6yBXnJ66TjCIPZdnYiyYnPxDs9t7guOXE/dAkG9GspSuYManx4n/DTQHHV5Xq/jL+9MWeLe1GCntuHX0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697305; c=relaxed/simple;
	bh=vB6B2/snA85bw+tHsEq5O4+hHBMmK6/WsTM7j8JDbK8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xz5cVMJX8LCpVbMus6LZDlFMYnwnDidLdOi5grqxZRzHcPJTbUS8e2jw2yagyKObG7fmHDjujPfdXHHWr5jI+rXj9JKdy+VkQcaw88pYNH+uh/J3+Q397FWwZ2Yd7fkxYY9MWCGmCCRFrgboI5U0qJazuqwS8FUOJduvMeeUhWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DuV24uf9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e6ccd17d6so5889677a91.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697303; x=1748302103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5677PAq9vSayGLryDnV5on0ZCj/5XK40V+aZo3LfDL4=;
        b=DuV24uf9RQ6bqZz0cjUgzt4C3nxN3Y365GF+has6q/qRkQdOmgPwWKKTxxnpwKQOqX
         HH2vXqdGmc4gbAOq8lhpUokK7aaGT5bc7qoAfLl7JQ9OL2w0+UG0PqYYR8xCjiFUEM4w
         x1gcmGFR1IbXIINAOy4DyI+l6cXlOF85xUFmQlCoGp07xoCzNMq6U4fSZcY3UkIQCQgP
         I5S6a07C7pqqyBMXjGmEVFIh6/u0tQY26/ZkIcn5Xukq7mGNzcq8eFJJifi6gZ6YCZFx
         Wj0gUtYv1savr7tCuF9yHnr1l+bj7m06A8bJCG14CbDnb+6tJsmfhIOWcIBep/aLawvc
         a6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697303; x=1748302103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5677PAq9vSayGLryDnV5on0ZCj/5XK40V+aZo3LfDL4=;
        b=U36EA9n6mHGwrkx8QTfAwoF0u5P+aHBjJWAJPtLsHiZvEqv0Q98JB/PdDxgo2bbpwo
         w8ilfPj6WWnGQXLiAIejgB/5lUIOdnWdifQZXaFHp3sX4fUmfTTPXg3ZeHtcc/JVdPr7
         G11JWd7Do2pqTIRO7XOovHoOSmEVeYbUVnrRAGoVJPeQqrV+GYWB2srisAvXDUbhKF05
         T3IP+zq6Yz1Vtf1+YAfOK8yuasOSy9cqUupRNhmLBEUSdZowxiTjx9DlPPPMuicBMh86
         ZkbO40V7aKnUNVpraEZR4Dwrd3BdYA0V+QTjaTsU1LQx+NLGlI7Au8OAUNBjSWzYfK9q
         S8Qg==
X-Gm-Message-State: AOJu0Yx+UAo0288NeLYIr0qaYHmuFGbQ8IAK4+zZMeH+lZYgcJIEEXJ/
	mqDqZGBySGCp+wbe6stITWArE3CT8/QhGE+Q+RJ4UDUgW4gu+5lmwteqmBP7E+ET7t/AS4z4iEb
	kJchKwQ==
X-Google-Smtp-Source: AGHT+IHwC4AIfQlh3CqCzBFbhI4wTZl3GmqhVvJyK0nru29ZUBIQ3femWzRswMWLjDt/y62obhO+vE/Xt3k=
X-Received: from pjyp5.prod.google.com ([2002:a17:90a:e705:b0:2ef:82c0:cb8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c8c:b0:30e:823f:ef31
 with SMTP id 98e67ed59e1d1-30e823ff071mr20730925a91.29.1747697302915; Mon, 19
 May 2025 16:28:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:27:58 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-6-seanjc@google.com>
Subject: [PATCH 05/15] KVM: x86: Fold kvm_setup_default_irq_routing() into kvm_ioapic_init()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move the default IRQ routing table used for in-kernel I/O APIC routing to
ioapic.c where it belongs, and fold the call to kvm_set_irq_routing() into
kvm_ioapic_init() (the call via kvm_setup_default_irq_routing() is done
immediately after kvm_ioapic_init()).

In addition to making it more obvious that the so called "default" routing
only applies to an in-kernel I/O APIC, getting it out of irq_comm.c will
allow removing irq_comm.c entirely, and will also allow for guarding KVM's
in-kernel I/O APIC emulation with a Kconfig with minimal #ifdefs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/ioapic.c   | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/irq.h      |  1 -
 arch/x86/kvm/irq_comm.c | 32 --------------------------------
 arch/x86/kvm/x86.c      |  6 ------
 4 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 8c8a8062eb19..dc45ea9f5b9c 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -710,6 +710,32 @@ static const struct kvm_io_device_ops ioapic_mmio_ops = {
 	.write    = ioapic_mmio_write,
 };
 
+#define IOAPIC_ROUTING_ENTRY(irq) \
+	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
+	  .u.irqchip = { .irqchip = KVM_IRQCHIP_IOAPIC, .pin = (irq) } }
+#define ROUTING_ENTRY1(irq) IOAPIC_ROUTING_ENTRY(irq)
+
+#define PIC_ROUTING_ENTRY(irq) \
+	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
+	  .u.irqchip = { .irqchip = SELECT_PIC(irq), .pin = (irq) % 8 } }
+#define ROUTING_ENTRY2(irq) \
+	IOAPIC_ROUTING_ENTRY(irq), PIC_ROUTING_ENTRY(irq)
+
+static const struct kvm_irq_routing_entry default_routing[] = {
+	ROUTING_ENTRY2(0), ROUTING_ENTRY2(1),
+	ROUTING_ENTRY2(2), ROUTING_ENTRY2(3),
+	ROUTING_ENTRY2(4), ROUTING_ENTRY2(5),
+	ROUTING_ENTRY2(6), ROUTING_ENTRY2(7),
+	ROUTING_ENTRY2(8), ROUTING_ENTRY2(9),
+	ROUTING_ENTRY2(10), ROUTING_ENTRY2(11),
+	ROUTING_ENTRY2(12), ROUTING_ENTRY2(13),
+	ROUTING_ENTRY2(14), ROUTING_ENTRY2(15),
+	ROUTING_ENTRY1(16), ROUTING_ENTRY1(17),
+	ROUTING_ENTRY1(18), ROUTING_ENTRY1(19),
+	ROUTING_ENTRY1(20), ROUTING_ENTRY1(21),
+	ROUTING_ENTRY1(22), ROUTING_ENTRY1(23),
+};
+
 int kvm_ioapic_init(struct kvm *kvm)
 {
 	struct kvm_ioapic *ioapic;
@@ -731,8 +757,14 @@ int kvm_ioapic_init(struct kvm *kvm)
 	if (ret < 0) {
 		kvm->arch.vioapic = NULL;
 		kfree(ioapic);
+		return ret;
 	}
 
+	ret = kvm_set_irq_routing(kvm, default_routing,
+				  ARRAY_SIZE(default_routing), 0);
+	if (ret)
+		kvm_ioapic_destroy(kvm);
+
 	return ret;
 }
 
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 33dd5666b656..f6134289523e 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -107,7 +107,6 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu);
 
 int apic_has_pending_timer(struct kvm_vcpu *vcpu);
 
-int kvm_setup_default_irq_routing(struct kvm *kvm);
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 			     struct kvm_lapic_irq *irq,
 			     struct dest_map *dest_map);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index b85e4be2ddff..998c4a34d87c 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -334,38 +334,6 @@ bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
 }
 EXPORT_SYMBOL_GPL(kvm_intr_is_single_vcpu);
 
-#define IOAPIC_ROUTING_ENTRY(irq) \
-	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
-	  .u.irqchip = { .irqchip = KVM_IRQCHIP_IOAPIC, .pin = (irq) } }
-#define ROUTING_ENTRY1(irq) IOAPIC_ROUTING_ENTRY(irq)
-
-#define PIC_ROUTING_ENTRY(irq) \
-	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
-	  .u.irqchip = { .irqchip = SELECT_PIC(irq), .pin = (irq) % 8 } }
-#define ROUTING_ENTRY2(irq) \
-	IOAPIC_ROUTING_ENTRY(irq), PIC_ROUTING_ENTRY(irq)
-
-static const struct kvm_irq_routing_entry default_routing[] = {
-	ROUTING_ENTRY2(0), ROUTING_ENTRY2(1),
-	ROUTING_ENTRY2(2), ROUTING_ENTRY2(3),
-	ROUTING_ENTRY2(4), ROUTING_ENTRY2(5),
-	ROUTING_ENTRY2(6), ROUTING_ENTRY2(7),
-	ROUTING_ENTRY2(8), ROUTING_ENTRY2(9),
-	ROUTING_ENTRY2(10), ROUTING_ENTRY2(11),
-	ROUTING_ENTRY2(12), ROUTING_ENTRY2(13),
-	ROUTING_ENTRY2(14), ROUTING_ENTRY2(15),
-	ROUTING_ENTRY1(16), ROUTING_ENTRY1(17),
-	ROUTING_ENTRY1(18), ROUTING_ENTRY1(19),
-	ROUTING_ENTRY1(20), ROUTING_ENTRY1(21),
-	ROUTING_ENTRY1(22), ROUTING_ENTRY1(23),
-};
-
-int kvm_setup_default_irq_routing(struct kvm *kvm)
-{
-	return kvm_set_irq_routing(kvm, default_routing,
-				   ARRAY_SIZE(default_routing), 0);
-}
-
 void kvm_scan_ioapic_irq(struct kvm_vcpu *vcpu, u32 dest_id, u16 dest_mode,
 			 u8 vector, unsigned long *ioapic_handled_vectors)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f9f798f286ce..4a9c252c9dab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7118,12 +7118,6 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			goto create_irqchip_unlock;
 		}
 
-		r = kvm_setup_default_irq_routing(kvm);
-		if (r) {
-			kvm_ioapic_destroy(kvm);
-			kvm_pic_destroy(kvm);
-			goto create_irqchip_unlock;
-		}
 		/* Write kvm->irq_routing before enabling irqchip_in_kernel. */
 		smp_wmb();
 		kvm->arch.irqchip_mode = KVM_IRQCHIP_KERNEL;
-- 
2.49.0.1101.gccaa498523-goog


