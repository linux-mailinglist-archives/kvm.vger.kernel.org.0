Return-Path: <kvm+bounces-47038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 084A2ABCB66
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F91A7A6902
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 886BC22154A;
	Mon, 19 May 2025 23:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="istqz/YY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C154431
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697301; cv=none; b=JTl0x9SKGeomV7xoU0XusR8uTZcQy82R07JujK9fy4X11sHUGDWfM/+ZQ3s1f/44UOrTyBOI2FyMolrV0QNOzv1+I5EvJ3uSmh9k9edahyoy/wLVWtKg8NvgvTV+DX3Wuh7HOW2jcBTrWwT8wZ8yGoi9VuP0zmE/Uhq8tp+BCRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697301; c=relaxed/simple;
	bh=Rqx4tIOwuvzIkuS+hhvK3QTqXtDusXXoDiyTkrhAXM0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hhpPVF8rRzvLZOAqCr7ROkl1Y5w5AHPdljv85Ao/ICS45zLQU7bKJ31Ow1geJckusTz+9QB7IrjkWVF9O38j9YKKG2f5CQM2f6oHcNu2tdhX9ubaoCUXiXAq5YIlaX7wS1+qTVpPN/kTiLeHzS/4i/GvxyzBsjW89yJ9078MjCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=istqz/YY; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b1442e039eeso3095762a12.0
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697299; x=1748302099; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AbLQPh1fsq8VOWBYp78JIFNrZ7hflbSEfHvBODcXQ5s=;
        b=istqz/YYvjPBBl18Q7oAl0KF9Ld3jvAevn3xWrXCUzfZK7qRzGkP9eBH/ieNSFjwS2
         sC670djpR1q+Q8dICjW7IZaodfQplLJ/cqNMOHoIKtH8BMhVau72PQtdczSk7ydNXSDw
         boV16c4jKbhn2jkPYRVNKRQzeo+Op+mDRGFEUthH4nsUMlb843CbNJE649ql0kkQcuuL
         I6v2MbD2ZzlROtbOySeBCJmcBD1FAwlWJfQncTjziBrNPEMw0IGobPRjf8x4e0V7HgU8
         TC6mHUa5h9sVkYJ3hQLAwMfzOly/a5jKIsTJinq8NrlTYkBIJDCJv9ozZOG31K+nyJcT
         OGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697299; x=1748302099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AbLQPh1fsq8VOWBYp78JIFNrZ7hflbSEfHvBODcXQ5s=;
        b=mWcA9SzLRgueBhVORaK9pw06A8CGH9Fj2riuYge4uhcxaw/E1PhCJPGoi4JDDYVzEp
         Wh7PFKni3//imsIr4JKucu1qUv2/AWGKCc/9aT/VlDzqPyI8sAv1i0FAB2RulDCUtJbC
         v4lqU2csnNx5P7aEGFGkYhqkP4d9oEjZzmuz+xSghETdXKpleSGPh9LNNq4w8cOk7Tuk
         hToXglpZInb6JkLdx01WbgobmFTbMpHCyZ74TZmJx7kCrNzdEwubwKLE4LbholvhMfpo
         cLqidCPUFBB0nTSpHF5KI04FToPSWH6PfAuIjtAgoyT+4bG3Cu0i/+G7dolto92l0ZI9
         oocQ==
X-Gm-Message-State: AOJu0Yzn/bpQrzsKIUagktMlwnsap9PfHm4w3zVDIs8rhpYYqUT7uR+5
	KGlarfSd2jvNmWtDoAuWE9+5oU+RDsDV54fg52V40us4Vx1dpBYIU9smzhLPF6F5qo4O68z4UHq
	NCtZJHw==
X-Google-Smtp-Source: AGHT+IELa/OBaU4oS5x4ZbaidUXv9+BLCZojuJzU3EtQI6qSLxAolguOuiFMHAGXuQ+SyHn2BSZVs6zuCw8=
X-Received: from pjbtb12.prod.google.com ([2002:a17:90b:53cc:b0:2fc:13d6:b4cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5251:b0:308:5273:4dee
 with SMTP id 98e67ed59e1d1-30e7d542b40mr21807019a91.15.1747697299584; Mon, 19
 May 2025 16:28:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:27:56 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-4-seanjc@google.com>
Subject: [PATCH 03/15] KVM: x86: Drop superfluous kvm_set_ioapic_irq() =>
 kvm_ioapic_set_irq() wrapper
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop the superfluous and confusing kvm_set_ioapic_irq() and instead wire
up ->set() directly to its final destination.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/ioapic.c   |  6 ++++--
 arch/x86/kvm/ioapic.h   |  5 +++--
 arch/x86/kvm/irq_comm.c | 11 +----------
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 45dae2d5d2f1..8c8a8062eb19 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -479,9 +479,11 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 	return ret;
 }
 
-int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
-		       int level, bool line_status)
+int kvm_ioapic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+		       int irq_source_id, int level, bool line_status)
 {
+	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
+	int irq = e->irqchip.pin;
 	int ret, irq_level;
 
 	BUG_ON(irq < 0 || irq >= IOAPIC_NUM_PINS);
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index aa8cb4ac0479..a86f59bbea44 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -111,8 +111,9 @@ void kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu, int vector,
 			int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
 void kvm_ioapic_destroy(struct kvm *kvm);
-int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
-		       int level, bool line_status);
+int kvm_ioapic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+		       int irq_source_id, int level, bool line_status);
+
 void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id);
 void kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 void kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 64f352e7bcb0..8dcb6a555902 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -27,15 +27,6 @@
 #include "x86.h"
 #include "xen.h"
 
-static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
-			      struct kvm *kvm, int irq_source_id, int level,
-			      bool line_status)
-{
-	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
-	return kvm_ioapic_set_irq(ioapic, e->irqchip.pin, irq_source_id, level,
-				line_status);
-}
-
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, struct dest_map *dest_map)
 {
@@ -293,7 +284,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		case KVM_IRQCHIP_IOAPIC:
 			if (ue->u.irqchip.pin >= KVM_IOAPIC_NUM_PINS)
 				return -EINVAL;
-			e->set = kvm_set_ioapic_irq;
+			e->set = kvm_ioapic_set_irq;
 			break;
 		default:
 			return -EINVAL;
-- 
2.49.0.1101.gccaa498523-goog


