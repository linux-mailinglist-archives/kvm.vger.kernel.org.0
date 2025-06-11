Return-Path: <kvm+bounces-49208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6174DAD6375
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 127DD174686
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D942F365E;
	Wed, 11 Jun 2025 22:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XNCLzPtV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197072737E5
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682125; cv=none; b=i9FcbunWZ/UPyuxJI6wBSPWSL7Vbt0VzI8/kAst6Z0edPkJ61Csihv2Er0imetbyGANOXhe0V2SX3tvugb1y8Vf/XbecbYfA8SXR+tuboBvBIuXsYZ7H8+ciC6pADET4bRzr/KF1zx2lnPNpMLipee4NEUn6Y4wdKpQ9rKLr0t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682125; c=relaxed/simple;
	bh=01/TeXAv+/ld+0h+0i5gKdPXqo5VXKxKWxynJL1IDDI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LXId+xsp2ONirkzDOBeQcRJuQn1Fbeyswi6w8+/pR2sAWjCQxhu6DY7P15PRjEebwrVaLeFIuSnCfOsp+9M5flwfO5CHdKBMBVI9HBaS7ZUbzCKONny91+SYnHPyJgc+msRmI73lAQYvfvS+UBC476hPTAaXNDtRgofd72uh2yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XNCLzPtV; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235c897d378so2224735ad.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682123; x=1750286923; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A2H6mQAi3X2cVhbsLup4QR14EBoE/FmvQ1a87TN4T2w=;
        b=XNCLzPtVBm9J9IUnbDZJbTtBcRKVHwC8/qQ+c0f6ZNueDE0ZgcB7nsuVmAQVk/UwJv
         7DrKtJHEwzFf+lCSytPA3ylY9+II+EMxUBedcJU/eSIzXEXcgXlg9zDSzuocBeoVIuiW
         NPbleE2hVJmbXg19V6Ii0KVRGuXPeLHjCjhfi4fIaydemgDK7T5iwrQEg3yvFZyUeQA0
         lNBhATpxeNA8c83aetfX1PeEbOnorrpWkv/WkYVF6qjHL/uQnlI0RWkQAO7q+txc6N/6
         o0ZzxUxvnUuEqok7nIyb5FvkRtfBXnhvUo0ibEoBCwloD57+Kp/X/WJoqkqDli56qI+U
         l3Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682123; x=1750286923;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A2H6mQAi3X2cVhbsLup4QR14EBoE/FmvQ1a87TN4T2w=;
        b=mAl1bniDnNTt/R8XTrrlFh86JnPcc1z5fe4s5rHg6/7pFRbb1xw/tJxA6SwKT2d/y5
         v1Ka1XJKVRn1aONmhqy7WcZPRqu8GueZPcQbDjtmea8KyhM0ybZlKOkEeWf8pfp5VBrw
         qLsZsWk/m7aIwai0T1EZOBq4n/U83eWMO13F9KP0kBVb/Mimq2a08CaRv+wDA0pK8S6B
         +PIhDx804poWRvVkJLOBJlmAU33dvi+i4y9u9d7dlFEc2j3rdtUU6czS9VNxauMgmDiV
         apgJRGyS7qI+rtDS0UmlL0LzYG4dWfsQk16Z29zYyyajxjVzyURnPWBn4TsV7hljmQjv
         vcsg==
X-Forwarded-Encrypted: i=1; AJvYcCUpDtRD8Wz1mZrryhy1tcsjLULj8buUBBS3YA0B4vYMFyI8VWTKqkzV1fIX3+4f8+tuL5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdTuioEbv6T3Vh4s160xhNM4FnO+KJlIB2JIl8sSPsOdwhv7sh
	iIiHAkGg4yqgUxl8ioV7a5wg+rKCPfq9ZZhkiHXKXpMVlV1YbkGUHS8D5SIGpHkbHO+Rdh2pnd/
	Jqm4Qbw==
X-Google-Smtp-Source: AGHT+IEmj8Wn93vyxOZ20/CzQNxDRl4F7IoOM7uRFd48VrtVcKzRebVp/cgdBntFE1vN9k4o1Eln3ZwGSvs=
X-Received: from plhl7.prod.google.com ([2002:a17:903:1207:b0:21f:4f0a:c7e2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54f:b0:234:ba37:87a5
 with SMTP id d9443c01a7336-23641b1aab7mr72956825ad.25.1749682123415; Wed, 11
 Jun 2025 15:48:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:46:05 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-64-seanjc@google.com>
Subject: [PATCH v3 62/62] KVM: x86: Rename kvm_set_msi_irq() => kvm_msi_to_lapic_irq()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename kvm_set_msi_irq() to kvm_msi_to_lapic_irq() to better capture what
it actually does, e.g. it's _really_ easy to conflate kvm_set_msi_irq()
with kvm_set_msi().

Opportunistically delete the public declaration and export, as they are
no longer used/needed.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/irq.c              | 14 +++++++-------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 01edcefbd937..af08b1acba04 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2381,9 +2381,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu);
 bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			     struct kvm_vcpu **dest_vcpu);
 
-void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
-		     struct kvm_lapic_irq *irq);
-
 static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
 {
 	/* We can only post Fixed and LowPrio IRQs */
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 3e4338c6a712..83c91845389c 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -252,8 +252,9 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 	return r;
 }
 
-void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
-		     struct kvm_lapic_irq *irq)
+static void kvm_msi_to_lapic_irq(struct kvm *kvm,
+				 struct kvm_kernel_irq_routing_entry *e,
+				 struct kvm_lapic_irq *irq)
 {
 	struct msi_msg msg = { .address_lo = e->msi.address_lo,
 			       .address_hi = e->msi.address_hi,
@@ -271,7 +272,6 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 	irq->level = 1;
 	irq->shorthand = APIC_DEST_NOSHORT;
 }
-EXPORT_SYMBOL_GPL(kvm_set_msi_irq);
 
 static inline bool kvm_msi_route_invalid(struct kvm *kvm,
 		struct kvm_kernel_irq_routing_entry *e)
@@ -290,7 +290,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	if (!level)
 		return -1;
 
-	kvm_set_msi_irq(kvm, e, &irq);
+	kvm_msi_to_lapic_irq(kvm, e, &irq);
 
 	return kvm_irq_delivery_to_apic(kvm, NULL, &irq, NULL);
 }
@@ -313,7 +313,7 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 		if (kvm_msi_route_invalid(kvm, e))
 			return -EINVAL;
 
-		kvm_set_msi_irq(kvm, e, &irq);
+		kvm_msi_to_lapic_irq(kvm, e, &irq);
 
 		if (kvm_irq_delivery_to_apic_fast(kvm, NULL, &irq, &r, NULL))
 			return r;
@@ -486,7 +486,7 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
 			if (entry->type != KVM_IRQ_ROUTING_MSI)
 				continue;
 
-			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
+			kvm_msi_to_lapic_irq(vcpu->kvm, entry, &irq);
 
 			if (!irq.trig_mode)
 				continue;
@@ -521,7 +521,7 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 		return -EINVAL;
 
 	if (entry && entry->type == KVM_IRQ_ROUTING_MSI) {
-		kvm_set_msi_irq(kvm, entry, &irq);
+		kvm_msi_to_lapic_irq(kvm, entry, &irq);
 
 		/*
 		 * Force remapped mode if hardware doesn't support posting the
-- 
2.50.0.rc1.591.g9c95f17f64-goog


