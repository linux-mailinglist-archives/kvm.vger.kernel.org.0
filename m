Return-Path: <kvm+bounces-49129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 262ECAD6183
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:37:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3A363AB649
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94BE024EA85;
	Wed, 11 Jun 2025 21:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vOaZWIud"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAF8244697
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677773; cv=none; b=tk25PwrqsGKLEq/3vWN6D+r4sRf8bUTUdf/xUCbPyJeNgaxRJ94d2vepw0kq4XEULMppu3c4oPgtxdCT5xohQId1Fpd/1JMUGIIOY9H6PPDZSm3wQfjl4jlIe2Za4hL9G4/bXCKNhwUXb+rTEai/M+hWp2GFFl0794oD7P3IdFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677773; c=relaxed/simple;
	bh=rgEWFRNx9AOzae/hY5m5+rHU8BL+ZKgpKWt+nqQu+9M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lCkhd+tCVoIjpXWhsvvEtF9hZCsEievu4RnGfOvst/5mewBJUS5MZMSE9gcLqX+fetX8YtO9MyEt0uLYiv/frZzfWYDgVpVagPe9C/sz0qWC4eEEBNaAe9ZLJZX2Ogg5Evb/QnUwAbdbw4MbXMvDhAPbk3v9b011aqYBC5afsx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vOaZWIud; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747af0bf0ebso229894b3a.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677771; x=1750282571; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=btr0cphDsMq+/yUhHVR8RE1UTj6gq99THk7CUF4LA9c=;
        b=vOaZWIudYIMGyMoh3vqNil8JDEeQfOG28mWLwxRjo/c+Z3TqMRJM91P5lCw3/6PdXK
         C7sRbvJJk99OqnDGVo3NmNKns9q29uDhJ7RP5j7wLc7MVrEGfuNyJYUG1Ci0yy3tkElD
         gXfPhXD6sS/uXjbdWTg6Zx7j9jJUA3hhasEpg7gUWMO2bEZhxxEJdxbi/K7wGA21rudx
         8utetzuoze8s9TCikfc80vQO2QkUXX9MBxuLY3QXn1IHT5OLMtRA0e/ev+86QYKeQYCV
         +WkG6PMF3OMMMYEfDuDCoR3vuwiIlXsMPO1tuOkxtJ7XNBWS8vEa4BbHtLgQYe6DwRZK
         9DAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677771; x=1750282571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=btr0cphDsMq+/yUhHVR8RE1UTj6gq99THk7CUF4LA9c=;
        b=ZFUcF19grnZat25RnJ1deklIzoDskSQc6zmHxAyILqxkOfvsJC+S0Ay0gYCJj0TfdC
         mtZVCbntuo4R9qeGVQP5mYK1Uw0wiZZcZGa2B6jHNjU2SNN8SUvG8Sb6wXeZhoJOJ7oi
         WskugH0suoi9zCETcbuHJwJPbgp6c01+Svd+rjdnyjVzdon6b5X7Et1aVBHBIbShf9uA
         R4FWs143CEkIt7iYRk73F8zmPdkMh2kyf8+3vcOSwi8NJkRDMf9EBF4L47f4zpi2fMUp
         lkQZ7v5NDaOp/ysWmtAwKnd648zVVIpsBHRNcnAP4uWrmlvFi/M+b83XcWNLnIU36KVt
         t3vA==
X-Gm-Message-State: AOJu0Yzzhb2OglmGWCHD7ZzlhxcyTa/KKUxbBimNF8dJbnRxiLor+5TS
	+sYoMTIH/gQ/i53IIPmbL7hBjjY0Vc7+RX2Vzi4mzbn4ol8alstnlpl+JPtw2k0JwYUwjf+3oge
	Lv/Uq+Q==
X-Google-Smtp-Source: AGHT+IFsPfyLnlFkwEO+3G76q5pk5GAKqTVHEuqReQsV0DBZ81IuIEqthkXBqU0MXTWDMH0fmDduzmsim6M=
X-Received: from pfwp55.prod.google.com ([2002:a05:6a00:26f7:b0:746:2a27:3025])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ad2:b0:742:a5f2:9c51
 with SMTP id d2e1a72fcca58-7487e288d11mr630129b3a.16.1749677771627; Wed, 11
 Jun 2025 14:36:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:45 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-7-seanjc@google.com>
Subject: [PATCH v2 06/18] KVM: x86: Move KVM_{GET,SET}_IRQCHIP ioctl helpers
 to irq.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the ioctl helpers for getting/setting fully in-kernel IRQ chip state
to irq.c, partly to trim down x86.c, but mostly in preparation for adding
a Kconfig to control support for in-kernel I/O APIC, PIC, and PIT
emulation.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/irq.h |  3 +++
 arch/x86/kvm/x86.c | 55 ---------------------------------------------
 3 files changed, 59 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 97d68d837929..da47e2165389 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -12,6 +12,7 @@
 #include <linux/export.h>
 #include <linux/kvm_host.h>
 
+#include "ioapic.h"
 #include "irq.h"
 #include "i8254.h"
 #include "x86.h"
@@ -178,3 +179,58 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
 {
 	return irqchip_in_kernel(kvm);
 }
+
+int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
+{
+	struct kvm_pic *pic = kvm->arch.vpic;
+	int r;
+
+	r = 0;
+	switch (chip->chip_id) {
+	case KVM_IRQCHIP_PIC_MASTER:
+		memcpy(&chip->chip.pic, &pic->pics[0],
+			sizeof(struct kvm_pic_state));
+		break;
+	case KVM_IRQCHIP_PIC_SLAVE:
+		memcpy(&chip->chip.pic, &pic->pics[1],
+			sizeof(struct kvm_pic_state));
+		break;
+	case KVM_IRQCHIP_IOAPIC:
+		kvm_get_ioapic(kvm, &chip->chip.ioapic);
+		break;
+	default:
+		r = -EINVAL;
+		break;
+	}
+	return r;
+}
+
+int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
+{
+	struct kvm_pic *pic = kvm->arch.vpic;
+	int r;
+
+	r = 0;
+	switch (chip->chip_id) {
+	case KVM_IRQCHIP_PIC_MASTER:
+		spin_lock(&pic->lock);
+		memcpy(&pic->pics[0], &chip->chip.pic,
+			sizeof(struct kvm_pic_state));
+		spin_unlock(&pic->lock);
+		break;
+	case KVM_IRQCHIP_PIC_SLAVE:
+		spin_lock(&pic->lock);
+		memcpy(&pic->pics[1], &chip->chip.pic,
+			sizeof(struct kvm_pic_state));
+		spin_unlock(&pic->lock);
+		break;
+	case KVM_IRQCHIP_IOAPIC:
+		kvm_set_ioapic(kvm, &chip->chip.ioapic);
+		break;
+	default:
+		r = -EINVAL;
+		break;
+	}
+	kvm_pic_update_irq(pic);
+	return r;
+}
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 33dd5666b656..aa77a6b2828c 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -66,6 +66,9 @@ void kvm_pic_update_irq(struct kvm_pic *s);
 int kvm_pic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
 		    int irq_source_id, int level, bool line_status);
 
+int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip);
+int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip);
+
 static inline int irqchip_split(struct kvm *kvm)
 {
 	int mode = kvm->arch.irqchip_mode;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 50e9fa57b859..311a670b6652 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6395,61 +6395,6 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 	return 0;
 }
 
-static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
-{
-	struct kvm_pic *pic = kvm->arch.vpic;
-	int r;
-
-	r = 0;
-	switch (chip->chip_id) {
-	case KVM_IRQCHIP_PIC_MASTER:
-		memcpy(&chip->chip.pic, &pic->pics[0],
-			sizeof(struct kvm_pic_state));
-		break;
-	case KVM_IRQCHIP_PIC_SLAVE:
-		memcpy(&chip->chip.pic, &pic->pics[1],
-			sizeof(struct kvm_pic_state));
-		break;
-	case KVM_IRQCHIP_IOAPIC:
-		kvm_get_ioapic(kvm, &chip->chip.ioapic);
-		break;
-	default:
-		r = -EINVAL;
-		break;
-	}
-	return r;
-}
-
-static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
-{
-	struct kvm_pic *pic = kvm->arch.vpic;
-	int r;
-
-	r = 0;
-	switch (chip->chip_id) {
-	case KVM_IRQCHIP_PIC_MASTER:
-		spin_lock(&pic->lock);
-		memcpy(&pic->pics[0], &chip->chip.pic,
-			sizeof(struct kvm_pic_state));
-		spin_unlock(&pic->lock);
-		break;
-	case KVM_IRQCHIP_PIC_SLAVE:
-		spin_lock(&pic->lock);
-		memcpy(&pic->pics[1], &chip->chip.pic,
-			sizeof(struct kvm_pic_state));
-		spin_unlock(&pic->lock);
-		break;
-	case KVM_IRQCHIP_IOAPIC:
-		kvm_set_ioapic(kvm, &chip->chip.ioapic);
-		break;
-	default:
-		r = -EINVAL;
-		break;
-	}
-	kvm_pic_update_irq(pic);
-	return r;
-}
-
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog


