Return-Path: <kvm+bounces-49127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41117AD617D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:37:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F7941894C11
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9136A24A07A;
	Wed, 11 Jun 2025 21:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v5c1bG6x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2627924887F
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677768; cv=none; b=eVwDDFySjTwZEjukUXG734PaqAd+X61t4ZLrEROSMEIAhssYePl+yEefCj3tE39F/Ul9v4zOZgF/N2rcBCx7mEVPIqvBE9LbMF3HnqLw+EWAODo18TKXLKwlij6MliL3+CO/6xYYW3DWBAb9NUhLQXfwOV9oWLfyvbxN9NcnvvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677768; c=relaxed/simple;
	bh=2vrLJKj19OX456GsG99Naj+YqCT8eAfkbz2WrX4rr1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z73QJjh+ArcHkOwyoSRTSu1wdXogBD3/KKf5N2i7FOc1Y1Fuv1tmUJDZh4aP+ggsZsK2h8Er7/iMRQjuztdlo9JgU4ODtEaKvxJJBdqN5w/ssSKmKPSBhi8zAQ8j2OVAJ6Ne4YtfjBErKdHywbqV6VwfKFf45DR5vLc8cikKmvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v5c1bG6x; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26cdc70befso121214a12.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677766; x=1750282566; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uHI3xCbsYOP2KWw/2eMjfu9hFT7kUbJEy5buHfIZCTM=;
        b=v5c1bG6xrpbvnB6xSwz7/gZPOT67S/kThMBrz21kCI/m3N8eZVU9nFlwixhqULe721
         4/KscdBGBy+H9087podLKaD7oIIh4qnLOES5Nfnqpmhxy6Mylm0EVdODG9BvMbZc+ewr
         /QHkyAh8L5qMyU5IMRY3+/wL7KjfXioOuhbqAAzOuQ44l0S7yvFXGjcbNhz0hBKsfZYI
         QCmVPmGynqR0CvncDynbx9p5cM/hDoNnpnPK8vrQr0dy4hsOqp+gRVtq+99b2GXmbQed
         lHwBBb4nVkbiqe6J9l7zxxJ/9xd0sMnwbmgIajtLIDjJ2AAwvbhSaX0ioQXcPDKj+Zuc
         4MJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677766; x=1750282566;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uHI3xCbsYOP2KWw/2eMjfu9hFT7kUbJEy5buHfIZCTM=;
        b=hiCnyrzJKrM9NQ/FY7aBrWZgqixWbQX3YCXvgcD8A/eAseg6Sv/hPu7eVPEJzdqtUV
         VXcCjjQOBBFgKEE81+C6IXPypXorIG6RbRrrcuxsL7LsDkJpfIK801P7qMEyYiQlFqkP
         LUPZR2oXBQhAbkhcNlXWCPvB31eSZ1pTpANVPA6NJK/19KRNQ7SqA6zq2v51qWpnvv8O
         fTOxtnZIHZ8Df4OzjWBa91aW0sGwPCWmG8btl5Deg4tEYK2t9nx/MjYR9lEu2lvXq+97
         NV9+rY9fkUbMqLjcDvWu7Bg0MzPjHlcYrlzoTsppOk7byvwR2Y4mkt9DMwNTNziog150
         ZP1A==
X-Gm-Message-State: AOJu0YzLFQdYOgwb2EtWXntGvfthGvieleLzJP413sjCHznSoDGdz3Pz
	9lAjjxErCVWf3ECESlAk0jV7olmalAlCQb03OSbTkdSaX8kVtnERZdJ+JvGGFN8gfbkmqmRuQTd
	nJKDNdg==
X-Google-Smtp-Source: AGHT+IGhUDDedez1Ad1IXxuj+ld9CEuEoa6u2kh/UYMFajcgbRUQg7tQQlHdw5YhnDOJpsmI7+uKkGAssNU=
X-Received: from pgar4.prod.google.com ([2002:a05:6a02:2e84:b0:b2c:4ef2:ca0e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7345:b0:21a:de8e:44b4
 with SMTP id adf61e73a8af0-21f9b9f8536mr424572637.16.1749677766665; Wed, 11
 Jun 2025 14:36:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:43 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-5-seanjc@google.com>
Subject: [PATCH v2 04/18] KVM: x86: Drop superfluous kvm_hv_set_sint() =>
 kvm_hv_synic_set_irq() wrapper
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop the superfluous kvm_hv_set_sint() and instead wire up ->set() directly
to its final destination, kvm_hv_synic_set_irq().  Keep hv_synic_set_irq()
instead of kvm_hv_set_sint() to provide some amount of consistency in the
->set() helpers, e.g. to match kvm_pic_set_irq() and kvm_ioapic_set_irq().

kvm_set_msi() is arguably the oddball, e.g. kvm_set_msi_irq() should be
something like kvm_msi_to_lapic_irq() so that kvm_set_msi() can instead be
kvm_set_msi_irq(), but that's a future problem to solve.

No functional change intended.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.c   | 10 +++++++---
 arch/x86/kvm/hyperv.h   |  3 ++-
 arch/x86/kvm/irq_comm.c | 18 +++---------------
 3 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 24f0318c50d7..f316e11383aa 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -497,15 +497,19 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
 	return ret;
 }
 
-int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vpidx, u32 sint)
+int kvm_hv_synic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+			 int irq_source_id, int level, bool line_status)
 {
 	struct kvm_vcpu_hv_synic *synic;
 
-	synic = synic_get(kvm, vpidx);
+	if (!level)
+		return -1;
+
+	synic = synic_get(kvm, e->hv_sint.vcpu);
 	if (!synic)
 		return -EINVAL;
 
-	return synic_set_irq(synic, sint);
+	return synic_set_irq(synic, e->hv_sint.sint);
 }
 
 void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector)
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 913bfc96959c..6ce160ffa678 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -103,7 +103,8 @@ static inline bool kvm_hv_hypercall_enabled(struct kvm_vcpu *vcpu)
 int kvm_hv_hypercall(struct kvm_vcpu *vcpu);
 
 void kvm_hv_irq_routing_update(struct kvm *kvm);
-int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
+int kvm_hv_synic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+			 int irq_source_id, int level, bool line_status);
 void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
 int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
 
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8dcb6a555902..28a8555ab58b 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -127,18 +127,6 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	return kvm_irq_delivery_to_apic(kvm, NULL, &irq, NULL);
 }
 
-#ifdef CONFIG_KVM_HYPERV
-static int kvm_hv_set_sint(struct kvm_kernel_irq_routing_entry *e,
-		    struct kvm *kvm, int irq_source_id, int level,
-		    bool line_status)
-{
-	if (!level)
-		return -1;
-
-	return kvm_hv_synic_set_irq(kvm, e->hv_sint.vcpu, e->hv_sint.sint);
-}
-#endif
-
 int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 			      struct kvm *kvm, int irq_source_id, int level,
 			      bool line_status)
@@ -149,8 +137,8 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 	switch (e->type) {
 #ifdef CONFIG_KVM_HYPERV
 	case KVM_IRQ_ROUTING_HV_SINT:
-		return kvm_hv_set_sint(e, kvm, irq_source_id, level,
-				       line_status);
+		return kvm_hv_synic_set_irq(e, kvm, irq_source_id, level,
+					    line_status);
 #endif
 
 	case KVM_IRQ_ROUTING_MSI:
@@ -302,7 +290,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		break;
 #ifdef CONFIG_KVM_HYPERV
 	case KVM_IRQ_ROUTING_HV_SINT:
-		e->set = kvm_hv_set_sint;
+		e->set = kvm_hv_synic_set_irq;
 		e->hv_sint.vcpu = ue->u.hv_sint.vcpu;
 		e->hv_sint.sint = ue->u.hv_sint.sint;
 		break;
-- 
2.50.0.rc1.591.g9c95f17f64-goog


