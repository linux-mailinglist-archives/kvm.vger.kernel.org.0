Return-Path: <kvm+bounces-47049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4629BABCB80
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9345C7A1990
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7200226CEF;
	Mon, 19 May 2025 23:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wgc9aXZG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0DD2253EA
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697320; cv=none; b=gfb0/T2pIkBeFl1ZdURC+kyWL7mp+k+Z4gtL+MIZamBelecskDdekXUfoFyHPe4uWZk+5WA+/PylwDKtAE0+NaZ+ZDmj1RZVfunMU4U3J/If52156id2SHT2ZaJJcQgVILVoMbzFMTcj/ykvKPjULveOAU4eASdIcy2zW3iCcE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697320; c=relaxed/simple;
	bh=tc/GDYNKJ/JO970W56dR3hFPJB+jiI1xGAiF+LJQ+ps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RWuVfF7L7j7PLMeJIlhK8I0gcS6wtI+7Pmmcp1XvqgP14lFS5fLc+LT/CoUz6DWl8eSpFBPYbQ/2Rt4jMQq6OaXrkR+DE750rLTs3blrB+zdMl3wHCZ732Bnf4YZEpbCsHAIPAEPLhv+0pELZ/bsIth/Efz/qjJLsUmNIOx1RFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wgc9aXZG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af5310c1ac1so2949731a12.2
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697317; x=1748302117; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Yt8dL6gvia2/Aq5+LlGzwWYcB9Uwzc86WQj4RAHOGf4=;
        b=wgc9aXZGcswbz/OPihLpxSJb3hMF9BvnMYYscI+vI8rwp5+WXvTB9K8Uyfus8Rt9xh
         DySXqiJKABtTEJrWcVRU+Fa+JvHCmsNSLePgWqO7vPyNk7UyOaHYm7MVI/z+4Ykw2XaE
         sJ8p2GYIEVGV5WPauCIMzk1psRG1wnQQsGt4pix54aVfjxqeuacvAj9O5utS+jxV3nyX
         gHG2vT1Y8h7D0dIxLyWBS2jMPQUcJzSBmvJHhRrLHufJaX/OWIPW+rYMeAYTsfuyUWXy
         WEjBDJYgO+K7uU6n1z3ScEyZLYEqli8Im2qNYLSTa1Kiu/rHCQZ54B88oVGi1gydAYU8
         TunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697317; x=1748302117;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yt8dL6gvia2/Aq5+LlGzwWYcB9Uwzc86WQj4RAHOGf4=;
        b=uIwsUSMMQISn3F9Y5AkrzShq5UBK8GxF4Frl/TtO3RqarzpQ6RdlFXdLwIUr8Ta3j+
         llR6EDSj7SNgnHY362Yk5JE7yeVAqRwTOz5ZiVt0FHD8Lus7gYWL7H1mo+EXkBinEhyt
         Bp60wkAvwbH0P4g1HIElSa7UfjMN/hvnJ0L9McyLJ6ly+40WNeJdluWHVfdfthql4oX7
         WgHZch1W5N0Kdmr+h4BKpmp6IT68mYVLvF0TnrCbxWFVU5xrbtAxEm8GZYAVIurQarhw
         XcqX9MVf2FqUT+4uRAylsFps+tRc8ZTxesaeFvCuNePyXM+fpC032lUWOOkBr1+3WPNg
         /MwQ==
X-Gm-Message-State: AOJu0YyMn92IvFZIHAiJcWsodQL7PhXl5QXrHv9mtyt/YCoPxiIGPmkC
	8DbmUq9Jv73qVAp+EL8M3mZJZAHoKtdpqGS0d+//srnewjW1V+0c1963WWB6uzqNbNFjIbvCK4t
	HMjxxAQ==
X-Google-Smtp-Source: AGHT+IGXrytGt+sKwT00ZGV+dLlBuxNOAw6WYkk4wC/ia6pi8Ets885sNOOc2hhxCbcbWIDEA37QMYR48rc=
X-Received: from pjyp3.prod.google.com ([2002:a17:90a:e703:b0:2fa:a101:755])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c0a:b0:2fa:157e:c78e
 with SMTP id 98e67ed59e1d1-30e7d4ebdb1mr23846796a91.7.1747697317621; Mon, 19
 May 2025 16:28:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:28:07 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-15-seanjc@google.com>
Subject: [PATCH 14/15] KVM: x86: Move IRQ mask notifier infrastructure to I/O
 APIC emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move the IRQ mask logic to ioapic.c as KVM's only user is its in-kernel
I/O APIC emulation.  In addition to encapsulating more I/O APIC specific
code, trimming down irq_comm.c helps pave the way for removing it entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 16 --------------
 arch/x86/kvm/i8254.h            |  2 ++
 arch/x86/kvm/i8259.c            |  2 ++
 arch/x86/kvm/ioapic.c           | 37 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/ioapic.h           | 16 ++++++++++++++
 arch/x86/kvm/irq_comm.c         | 33 -----------------------------
 arch/x86/kvm/x86.c              |  1 -
 7 files changed, 57 insertions(+), 50 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f5ff5174674c..21ccb122ab76 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1426,9 +1426,6 @@ struct kvm_arch {
 	struct delayed_work kvmclock_update_work;
 	struct delayed_work kvmclock_sync_work;
 
-	/* reads protected by irq_srcu, writes by irq_lock */
-	struct hlist_head mask_notifier_list;
-
 #ifdef CONFIG_KVM_HYPERV
 	struct kvm_hv hyperv;
 #endif
@@ -2038,19 +2035,6 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  const void *val, int bytes);
 
-struct kvm_irq_mask_notifier {
-	void (*func)(struct kvm_irq_mask_notifier *kimn, bool masked);
-	int irq;
-	struct hlist_node link;
-};
-
-void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
-				    struct kvm_irq_mask_notifier *kimn);
-void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
-				      struct kvm_irq_mask_notifier *kimn);
-void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
-			     bool mask);
-
 extern bool tdp_enabled;
 
 u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index 14fb310357f2..de172567b56a 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -6,6 +6,8 @@
 
 #include <kvm/iodev.h>
 
+#include "ioapic.h"
+
 struct kvm_kpit_channel_state {
 	u32 count; /* can be 65536 */
 	u16 latched_count;
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 4de055efc4ee..2ac7f1678c46 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -31,6 +31,8 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/bitops.h>
+
+#include "ioapic.h"
 #include "irq.h"
 
 #include <linux/kvm_host.h>
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 151ee9a64c3c..daaf16e4681a 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -310,6 +310,42 @@ void kvm_arch_post_irq_ack_notifier_list_update(struct kvm *kvm)
 	kvm_make_scan_ioapic_request(kvm);
 }
 
+void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
+				    struct kvm_irq_mask_notifier *kimn)
+{
+	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
+
+	mutex_lock(&kvm->irq_lock);
+	kimn->irq = irq;
+	hlist_add_head_rcu(&kimn->link, &ioapic->mask_notifier_list);
+	mutex_unlock(&kvm->irq_lock);
+}
+
+void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
+				      struct kvm_irq_mask_notifier *kimn)
+{
+	mutex_lock(&kvm->irq_lock);
+	hlist_del_rcu(&kimn->link);
+	mutex_unlock(&kvm->irq_lock);
+	synchronize_srcu(&kvm->irq_srcu);
+}
+
+void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
+			     bool mask)
+{
+	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
+	struct kvm_irq_mask_notifier *kimn;
+	int idx, gsi;
+
+	idx = srcu_read_lock(&kvm->irq_srcu);
+	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
+	if (gsi != -1)
+		hlist_for_each_entry_rcu(kimn, &ioapic->mask_notifier_list, link)
+			if (kimn->irq == gsi)
+				kimn->func(kimn, mask);
+	srcu_read_unlock(&kvm->irq_srcu, idx);
+}
+
 static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 {
 	unsigned index;
@@ -736,6 +772,7 @@ int kvm_ioapic_init(struct kvm *kvm)
 		return -ENOMEM;
 	spin_lock_init(&ioapic->lock);
 	INIT_DELAYED_WORK(&ioapic->eoi_inject, kvm_ioapic_eoi_inject_work);
+	INIT_HLIST_HEAD(&ioapic->mask_notifier_list);
 	kvm->arch.vioapic = ioapic;
 	kvm_ioapic_reset(ioapic);
 	kvm_iodevice_init(&ioapic->dev, &ioapic_mmio_ops);
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index fee17eb201ef..f5c1ff640635 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -86,8 +86,24 @@ struct kvm_ioapic {
 	struct delayed_work eoi_inject;
 	u32 irq_eoi[IOAPIC_NUM_PINS];
 	u32 irr_delivered;
+
+	/* reads protected by irq_srcu, writes by irq_lock */
+	struct hlist_head mask_notifier_list;
 };
 
+struct kvm_irq_mask_notifier {
+	void (*func)(struct kvm_irq_mask_notifier *kimn, bool masked);
+	int irq;
+	struct hlist_node link;
+};
+
+void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
+				    struct kvm_irq_mask_notifier *kimn);
+void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
+				      struct kvm_irq_mask_notifier *kimn);
+void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
+			     bool mask);
+
 #ifdef DEBUG
 #define ASSERT(x)  							\
 do {									\
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index a4ef150fdd1c..fc0fa8155882 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -161,39 +161,6 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 	return -EWOULDBLOCK;
 }
 
-void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
-				    struct kvm_irq_mask_notifier *kimn)
-{
-	mutex_lock(&kvm->irq_lock);
-	kimn->irq = irq;
-	hlist_add_head_rcu(&kimn->link, &kvm->arch.mask_notifier_list);
-	mutex_unlock(&kvm->irq_lock);
-}
-
-void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
-				      struct kvm_irq_mask_notifier *kimn)
-{
-	mutex_lock(&kvm->irq_lock);
-	hlist_del_rcu(&kimn->link);
-	mutex_unlock(&kvm->irq_lock);
-	synchronize_srcu(&kvm->irq_srcu);
-}
-
-void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
-			     bool mask)
-{
-	struct kvm_irq_mask_notifier *kimn;
-	int idx, gsi;
-
-	idx = srcu_read_lock(&kvm->irq_srcu);
-	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
-	if (gsi != -1)
-		hlist_for_each_entry_rcu(kimn, &kvm->arch.mask_notifier_list, link)
-			if (kimn->irq == gsi)
-				kimn->func(kimn, mask);
-	srcu_read_unlock(&kvm->irq_srcu, idx);
-}
-
 bool kvm_arch_can_set_irq_routing(struct kvm *kvm)
 {
 	return irqchip_in_kernel(kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 52eff4919d95..3ac6f7c83a06 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12799,7 +12799,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_uninit_mmu;
 
-	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
 
 	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
-- 
2.49.0.1101.gccaa498523-goog


