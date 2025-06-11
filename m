Return-Path: <kvm+bounces-49130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F518AD6187
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:38:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 667061E2175
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4B8254B03;
	Wed, 11 Jun 2025 21:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pbrNte8o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC16425228B
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677777; cv=none; b=M2Xnb2WBLXTCOU8mlDcCijlVQLyrmT208s1dKDXmeqT3PveqIuNvb/5IP3cZCs6WlgP+v+PzP0+N+D/BxS6InvfrxagirJLpW+cn2liOyFA9bhhbrP+U2n9xDRGLZggsqlVRvUa0nsqv6tkp6MNb31knMncX2v9NF0CoXfada4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677777; c=relaxed/simple;
	bh=pZl2VSKAfR5v4Bw2AKfURG4THxaXEzLGkGiVfL5sIHo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YSyPLEYca+d+nooqCyBuZTXWWft9/tPQ8cc36CzBBj9XnhKDS7Oy8kUmwK8LzjiUpc3n5AVOkFbApw2HKEkwdU/txGPMVTn1yVacX7FL70a9ozOIUT5Ztr9KYxD9InBGUUj/Fel/T+ho3RqSAKCfBUnWUyD9h+yAi+D/oG2hYlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pbrNte8o; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747d143117eso224880b3a.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677775; x=1750282575; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oni1jfbd5pBW7XeSkgGvJ+4ZwWsOOKBYCbwtU5ZqKQs=;
        b=pbrNte8oIWP/wKXszHbFxx4GQMbtaNPR8I1Qx9y+fywB+PrhAl2G4XnTl0U7NFAbsm
         uPSf5gfLzC92BvYurV2DhyKXOwmL9K+uOz8lT+MvLtW0ApyKY4pcXJFNe4KUhRVmfEjZ
         zXe+uqpiwuw/v9I0N6pG1sW5ScSK+yjbTegItTV6jLjKLUVo/1SK+lRz09j3E/C2v53W
         cV3ZRIkmlMiVnE+tdaayHHtrLa0kyTVivEeyIffY+XYJcXsvu93yLMu5cPQvo34I7L9c
         JYtP1WrnCicGNWmDMW/Pw+wy6zfVe5D0wbJuUVHsbTwfuieVVRP+B3k+IZ3zIRqRbyj0
         8nyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677775; x=1750282575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oni1jfbd5pBW7XeSkgGvJ+4ZwWsOOKBYCbwtU5ZqKQs=;
        b=XJKcUjOfk4VMyxn1yz1kg1S91Vn4Ae3JlIcFpgdGWc2zCskSXM2ZYZWiid3PP7quB7
         6BkaHk1+8DsozLZkRw7Cvrib/xYjDn1dgjfThQZGQ4vYnTJyLePUgDeoMbSEwN3+76Kw
         NVmzmWmsLIKgXRZUsTe1Txq06m7w9hM8sHq+IBptNF07dwYhQ0TOzaCHxPD0iLXVflYV
         rrJkDg34Kzocb77/QkGCoP2xEPDvaoubpdVdAhlKfuIDh4WIouXXbNsMMygHBfC2+OoZ
         bqv/oJmUMYj3SjxdyWvQU6KkxJZxloWHOO3FOkzvE40fN6rv38+ArMF+M1W74uM1ILYH
         aD3w==
X-Gm-Message-State: AOJu0YwSz9TjzI+A6D5IOsPMJhHUmAyFEpZvmC54Wfg3v6fyIX5AD75V
	56tfFIT6wwM8TKHIY9OTOZn5Bdk3xx0/V0fOOzMbn2TTAaKcRmyKrkCX7b1kFK5ZxkwJ6d/jOWg
	oCTvcvQ==
X-Google-Smtp-Source: AGHT+IGYTun2uqID12Wrh0REil2e2ryIuSl2BbCmsAyARmY7r8+j7UXcE1vuirTxZmTRrYFotB9aYBO41Kw=
X-Received: from pfxx12.prod.google.com ([2002:a05:6a00:10c:b0:746:fd4c:1fcf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12c6:b0:218:c22:e3e6
 with SMTP id adf61e73a8af0-21f9b9eed98mr446426637.12.1749677775238; Wed, 11
 Jun 2025 14:36:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:47 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-9-seanjc@google.com>
Subject: [PATCH v2 08/18] KVM: x86: Move kvm_setup_default_irq_routing() into irq.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the default IRQ routing table used for in-kernel I/O APIC and PIC
routing to irq.c, and tweak the name to make it explicitly clear what
routing is being initialized.

In addition to making it more obvious that the so called "default" routing
only applies to an in-kernel I/O APIC, getting it out of irq_comm.c will
allow removing irq_comm.c entirely.  And placing the function alongside
other I/O APIC and PIC code will allow for guarding KVM's in-kernel I/O
APIC and PIC emulation with a Kconfig with minimal #ifdefs.

No functional change intended.

Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c      | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/irq.h      |  3 ++-
 arch/x86/kvm/irq_comm.c | 32 --------------------------------
 arch/x86/kvm/x86.c      |  2 +-
 4 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 97e1617ce24d..b696161ec078 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -180,6 +180,38 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
 	return irqchip_in_kernel(kvm);
 }
 
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
+int kvm_setup_default_ioapic_and_pic_routing(struct kvm *kvm)
+{
+	return kvm_set_irq_routing(kvm, default_routing,
+				   ARRAY_SIZE(default_routing), 0);
+}
+
 int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 {
 	struct kvm_pic *pic = kvm->arch.vpic;
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 4ac346102350..7b8b54462f95 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -66,6 +66,8 @@ void kvm_pic_update_irq(struct kvm_pic *s);
 int kvm_pic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
 		    int irq_source_id, int level, bool line_status);
 
+int kvm_setup_default_ioapic_and_pic_routing(struct kvm *kvm);
+
 int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip);
 int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip);
 
@@ -110,7 +112,6 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu);
 
 int apic_has_pending_timer(struct kvm_vcpu *vcpu);
 
-int kvm_setup_default_irq_routing(struct kvm *kvm);
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 			     struct kvm_lapic_irq *irq,
 			     struct dest_map *dest_map);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index bcf2f1e4a005..99c521bd9db5 100644
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
index fb7b0d301c38..f02a9a332f69 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6991,7 +6991,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			goto create_irqchip_unlock;
 		}
 
-		r = kvm_setup_default_irq_routing(kvm);
+		r = kvm_setup_default_ioapic_and_pic_routing(kvm);
 		if (r) {
 			kvm_ioapic_destroy(kvm);
 			kvm_pic_destroy(kvm);
-- 
2.50.0.rc1.591.g9c95f17f64-goog


