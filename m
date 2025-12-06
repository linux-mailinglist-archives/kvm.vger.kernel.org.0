Return-Path: <kvm+bounces-65446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4D5CA9C54
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CAFC31DBE33
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC37D30E820;
	Sat,  6 Dec 2025 00:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lm00pY5J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047CB311949
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764981813; cv=none; b=GMXPjppWqEzESUD7EOxIpHoQS0mZgfWF5O79TnXXjiRDpKk57MpLK9fJI3+3/XAHE7WTqpCc0ujvfB70+nKxmGk4+NFnc0NE5THVlCL2vFebYFBB+BOI8ly8FtDWRCcrpkWSkUD+fzXci1C6x33cbpv5H2B+F3rTb2RPeUx90h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764981813; c=relaxed/simple;
	bh=D8YNs0jhQxmKrlLqzsIgpVcygIjolyUDJAk5r4FS0BA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rr6o2EwzP5FdpQ3f4pQ42bChJa99a4DQgpm5+rLc+OKzIWbyWG2rlyPixjLlDYMYS8G8i/xzIa+Kr1LTH7pRev42Zng9fDOCbYXYk0GsisVd3QvxzqBVIcQA+BohDPDD45EuaYjs5KORNH5wcxMhDLR/8U3Pe3Gt2KFIWid4JVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lm00pY5J; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-349a2f509acso391819a91.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764981811; x=1765586611; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0M5Fh7g4g+vMHY3O01HjRrVVFkeqJ1Xqgz9TEiQY1Wo=;
        b=lm00pY5Jkajb5fv+9ENc7//wgow4/lOb6T9fX+cfkLOyDMY1XUe6yP+xGrzIGq++v9
         Rd44ogZfdmP+fjcslt6A5m6zrVZNiYlWPGOxu77ov9ghPApSK8HbARcTgdQ868DnHmwu
         IQt2uElEXgSggdIi0UeUh3MThcKLcXClhktBmuH6Ou5WFXgu3+G8oxennMxQ10qG2ARY
         vtYSbFAKFiyxfXm5omxhdui8+vjoaSJMIXRH/gaNyRwPqc53uU64PL8NmXyUU9ewxKZp
         r+mkYOWz5Zp6zc2JtQ54qgOh5I5KLFVlCN8bLsu4ZM8+kfaPFcUHgRBjyfjGZbB7HOwO
         V48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764981811; x=1765586611;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0M5Fh7g4g+vMHY3O01HjRrVVFkeqJ1Xqgz9TEiQY1Wo=;
        b=Hs5kG3pGFgag/hu+eFU5ozr2kU4g5oMNnK0LEHNbkyCbOspMUz2xdgUM2wIEgfDjCF
         kGRvlddf0dU186VyCSitN9hVOUzk8nUawk2t6LJfMmQRU0mTETzprnq2xsDw+N4ZaDjW
         LgeWB8EXTbflwEvVZm7YJTy36ZfUKBO8Sqt038gxF7T4SdAwIpdsW1cfqlJYr06ByjA1
         jjxRWRMzoBVd8BRiyyE5nsRg5ga0nyGEUl9JPa8elNqY6nSjeqD40QYQbT0bBuoUz9gn
         Zumbwxx6wS0fZrW2FR0sv+Ra6pnlBBWDHX1dTAWE3wp2CivWQOhDFF7EcsdeZDXF5YEX
         Skcg==
X-Gm-Message-State: AOJu0YyXQqIvhHre4bwgPBdFk5BABHCDTFTP+uKSC2XCp7RC3fDOHUgC
	u54aaZEBved8AhuRpK3NwxdAKVOm6ZHCSZotT1ZezswzaHEz7TQUYsVV7+YEjMo1eloRTNhdhPy
	ToVFbnQ==
X-Google-Smtp-Source: AGHT+IGlL8/b1FRD3bhiv9p0K1W8yDjW0JkM8vQ36QdvszBI5wd93UySoZ1QCSk/ibL5UW+HM3nqArHB2qk=
X-Received: from pjwt13.prod.google.com ([2002:a17:90a:d14d:b0:33b:52d6:e13e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c12:b0:340:ad5e:c3
 with SMTP id 98e67ed59e1d1-349a24cc0eemr697918a91.1.1764981811179; Fri, 05
 Dec 2025 16:43:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:43:10 -0800
In-Reply-To: <20251206004311.479939-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206004311.479939-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206004311.479939-9-seanjc@google.com>
Subject: [PATCH 8/9] KVM: x86: Bury ioapic.h definitions behind CONFIG_KVM_IOAPIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Now that almost everything in ioapic.h is used only by code guarded by
CONFIG_KVM_IOAPIC=y, bury (almost) the entire thing behind the Kconfig.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/ioapic.h | 14 +++++++++-----
 arch/x86/kvm/lapic.c  |  2 ++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 868ed593a5c9..3dadae093690 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -6,6 +6,8 @@
 #include <kvm/iodev.h>
 #include "irq.h"
 
+#ifdef CONFIG_KVM_IOAPIC
+
 struct kvm;
 struct kvm_vcpu;
 
@@ -99,11 +101,6 @@ void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
 void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
 			     bool mask);
 
-static inline int ioapic_in_kernel(struct kvm *kvm)
-{
-	return irqchip_full(kvm);
-}
-
 void kvm_rtc_eoi_tracking_restore_one(struct kvm_vcpu *vcpu);
 void kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu, int vector,
 			int trigger_mode);
@@ -116,6 +113,13 @@ void kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 void kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu,
 			   ulong *ioapic_handled_vectors);
+#endif /* CONFIG_KVM_IOAPIC */
+
+static inline int ioapic_in_kernel(struct kvm *kvm)
+{
+	return irqchip_full(kvm);
+}
+
 void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
 			    ulong *ioapic_handled_vectors);
 void kvm_scan_ioapic_irq(struct kvm_vcpu *vcpu, u32 dest_id, u16 dest_mode,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0a44765aba12..78c39341b2a5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1376,10 +1376,12 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 
 		result = 1;
 
+#ifdef CONFIG_KVM_IOAPIC
 		if (rtc_status) {
 			__set_bit(vcpu->vcpu_id, rtc_status->map);
 			rtc_status->vectors[vcpu->vcpu_id] = vector;
 		}
+#endif
 
 		if (apic_test_vector(vector, apic->regs + APIC_TMR) != !!trig_mode) {
 			if (trig_mode)
-- 
2.52.0.223.gf5cc29aaa4-goog


