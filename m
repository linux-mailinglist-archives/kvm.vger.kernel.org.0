Return-Path: <kvm+bounces-49124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 954D4AD6178
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0B80188E567
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C6624729E;
	Wed, 11 Jun 2025 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MgB/ELKY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6FE24339D
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677764; cv=none; b=CyvA2Bw1SHSB13GEis9taCk7eR/xpiyomkdONSW/08UJMzSSq7qnV/dDoWxaw5wAcCplXKG0sUkYbphBif5raY9uBoaouvtgrTsNIc3oZHmlSE36EYrPHRwxt/SJJozW2X+zdqDVTkvWPpEgQXhaUib/I+wHRlDPXJ6z/2kWB1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677764; c=relaxed/simple;
	bh=ynqbREqv316s5gsW9OCsqzoURbxrqddvN+Jr9T4Pj0k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X11Z2drksNGIL/OS2mTctQMSOB9lbbtBPVOHW/tT4xGKf/dH+X3OgzuVtSBEmpLOXbGP/H/Cfl1reMAYBFbrY4dnheZOHThNtBU8pqf14sMLSA5UC4cp9MOLbImK+H5aig6IjUbJkmYDq7ZBGT7c8A6Yhl1pB2/i9Z++ebZXgzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MgB/ELKY; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7425efba1a3so187956b3a.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677762; x=1750282562; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PZG/T2PYXDNJDPQNT3ApJnWxeYPAUPNPO+dWK9gIL4Q=;
        b=MgB/ELKY0kZw4ahobdyd938Vb98l+PVtX9FcjEQDdKtitabDcQRObLFnjyi0+LlpRl
         urDwmTWdc35AmxC+SzzzZEafL6YL4PkyOQJikPdhuJKFxWhhn8NiMNVREaVNF9JBRRMc
         hTR0WsFMPu5xFZMmd3yao4G7bp/5G7LgAhblzkj5I63u0uKQ2GfZhwRHsl+IhUHcBG/v
         MXbjUpqDWbGeg2rq+Fn72VuG3kpdyR735vw/gak52idr3+Ja44+p1rNo9doAdlIKNRoP
         hyeQFFm7RmsblpWLrj/tSQU93CPC/DkcOGPOLFCZUs60dK8igWOPuVsmv0K4g0AmFGgk
         cLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677762; x=1750282562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PZG/T2PYXDNJDPQNT3ApJnWxeYPAUPNPO+dWK9gIL4Q=;
        b=ujc6mw3NqRcXToDxWk8GxYz01Fq244gMpCBoa4GmZTHiVu4xUgabR5GHABwW8QIy8I
         eAd5nObEAomZkOQgczr9VZHLtGp7ly4Fq4bv8bmG9pO0nOmjJKbfyOXEso1aofQ9fFsR
         ZoUK+Gww48GZjsjQGOl9gkmtyjXy9HWpGJ5xVF/evgz8ing1hBo3h7adJCASnunVuv8N
         rWKJz7TrLcPZfnIq3MylBi9+gntacKUrt1vYScOuD5Y4ZVNYHrCw4p9OVR0gXuyCvsAU
         4KbKcdkOrtOPAqtdV3Spr7yxybkG97h2wi0/5id4J8Bmst2U9CB6s4OZxVDkKj8fd/vY
         XpfQ==
X-Gm-Message-State: AOJu0YwwdATtetY+8qLabKULngBqkRYFoZ6WpF7SnXETugYr/41fXm0c
	L8wJmu7m6KI6XhLaYSoE5ie2Fllb3dwearhDmuqBA29cTiu9SZU2Pe02s4uIHEXvzJVHzSbniAY
	+OFsjyQ==
X-Google-Smtp-Source: AGHT+IGPKQIpTDjSAFv6mOIjPhaD8mB5M58fuRVAGtuBRqCaVZPcbvGXavVh+jOMgZS7XB5O8QfCC5Vv/cQ=
X-Received: from pfbna4.prod.google.com ([2002:a05:6a00:3e04:b0:746:2ae9:24a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:83cb:0:b0:742:b9d2:dc8f
 with SMTP id d2e1a72fcca58-7487cdffc94mr839105b3a.1.1749677761823; Wed, 11
 Jun 2025 14:36:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:40 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-2-seanjc@google.com>
Subject: [PATCH v2 01/18] KVM: x86: Trigger I/O APIC route rescan in kvm_arch_irq_routing_update()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Trigger the I/O APIC route rescan that's performed for a split IRQ chip
after userspace updates IRQ routes in kvm_arch_irq_routing_update(), i.e.
before dropping kvm->irq_lock.  Calling kvm_make_all_cpus_request() under
a mutex is perfectly safe, and the smp_wmb()+smp_mb__after_atomic() pair
in __kvm_make_request()+kvm_check_request() ensures the new routing is
visible to vCPUs prior to the request being visible to vCPUs.

In all likelihood, commit b053b2aef25d ("KVM: x86: Add EOI exit bitmap
inference") somewhat arbitrarily made the request outside of irq_lock to
avoid holding irq_lock any longer than is strictly necessary.  And then
commit abdb080f7ac8 ("kvm/irqchip: kvm_arch_irq_routing_update renaming
split") took the easy route of adding another arch hook instead of risking
a functional change.

Note, the call to synchronize_srcu_expedited() does NOT provide ordering
guarantees with respect to vCPUs scanning the new routing; as above, the
request infrastructure provides the necessary ordering.  I.e. there's no
need to wait for kvm_scan_ioapic_routes() to complete if it's actively
running, because regardless of whether it grabs the old or new table, the
vCPU will have another KVM_REQ_SCAN_IOAPIC pending, i.e. will rescan again
and see the new mappings.

Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq_comm.c  | 10 +++-------
 include/linux/kvm_host.h |  4 ----
 virt/kvm/irqchip.c       |  2 --
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index d6d792b5d1bd..e2ae62ff9cc2 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -395,13 +395,6 @@ int kvm_setup_default_irq_routing(struct kvm *kvm)
 				   ARRAY_SIZE(default_routing), 0);
 }
 
-void kvm_arch_post_irq_routing_update(struct kvm *kvm)
-{
-	if (!irqchip_split(kvm))
-		return;
-	kvm_make_scan_ioapic_request(kvm);
-}
-
 void kvm_scan_ioapic_irq(struct kvm_vcpu *vcpu, u32 dest_id, u16 dest_mode,
 			 u8 vector, unsigned long *ioapic_handled_vectors)
 {
@@ -466,4 +459,7 @@ void kvm_arch_irq_routing_update(struct kvm *kvm)
 #ifdef CONFIG_KVM_HYPERV
 	kvm_hv_irq_routing_update(kvm);
 #endif
+
+	if (irqchip_split(kvm))
+		kvm_make_scan_ioapic_request(kvm);
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3bde4fb5c6aa..9461517b4e62 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1024,14 +1024,10 @@ void vcpu_put(struct kvm_vcpu *vcpu);
 
 #ifdef __KVM_HAVE_IOAPIC
 void kvm_arch_post_irq_ack_notifier_list_update(struct kvm *kvm);
-void kvm_arch_post_irq_routing_update(struct kvm *kvm);
 #else
 static inline void kvm_arch_post_irq_ack_notifier_list_update(struct kvm *kvm)
 {
 }
-static inline void kvm_arch_post_irq_routing_update(struct kvm *kvm)
-{
-}
 #endif
 
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 162d8ed889f2..6ccabfd32287 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -222,8 +222,6 @@ int kvm_set_irq_routing(struct kvm *kvm,
 	kvm_arch_irq_routing_update(kvm);
 	mutex_unlock(&kvm->irq_lock);
 
-	kvm_arch_post_irq_routing_update(kvm);
-
 	synchronize_srcu_expedited(&kvm->irq_srcu);
 
 	new = old;
-- 
2.50.0.rc1.591.g9c95f17f64-goog


