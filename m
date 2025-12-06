Return-Path: <kvm+bounces-65444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 66951CA9C27
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 13C643039797
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8351D31985D;
	Sat,  6 Dec 2025 00:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Wecf8hX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11263191C4
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764981809; cv=none; b=ERE8Zr1gcc+Tx+rKC5/CSnwExJrtG5ZBTjBs2kwZojQAGBlV94WGE1mj8lYGx8JKdMMe2CI//uRUqSAsyebX9kmf1cpEnhLmDUAzUd9w5TpUrp/2uNfn1JqexZsrlsU+94Jm81mbiO495soZUUK5CLu2CD0BXmckq4R0M/vhd40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764981809; c=relaxed/simple;
	bh=7p3g1ZBu6FRv8reQiyKaecx8NldkmeS5zcA0Xq5dM4c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rHLEiSiB+HgL1/sQVwR/x+k3VLPDBdVbgv0vJe+FCE/aUux+G0/FK5XH5rnNOsyLVQwBWnUXe94Zygdk1UGRNqpiPhyhBVYSALr9u2Dxux8tQFkNW05si+/JlxOuSxFDDLqqkPMTfhIMSwA3RKoT9kukGiEBltuot+SWBi7jul8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Wecf8hX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340d3b1baafso3714309a91.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764981807; x=1765586607; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NmqBiS6+SwZn9pTwZnUkN7lJ7KmnizD8AtO5bpATROo=;
        b=0Wecf8hX6IHV2t0od8eLoOuHaC2EZTJDmvnE1uQvflCpfCbB9MskPem/XUyBc5kRmu
         H26SMWSjas6FGiHHpi82u2V+U8kCiuNLZ1ypI3b1AY5PHecpY8mm5ee0CBqdyZz4AX0c
         HmRH6fCnlrabHnKl1L7KMpDaONdzEYheFxAanpxhGh634JDb1sCo+UFwDdE1He+vfY8k
         UJGlZKJKKvuDkI5U/MgWQ4aoBP0LdtZl4pq1mEGx7Mn4F53F/zlHDnhNFsRjzLovYW5L
         RhZgFpXgBcnWHy6SRs+aVZRWBlyw12TBLdtjGIXS8zQKXYpcZZwulTgdh8eDlWH0ICxt
         yvOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764981807; x=1765586607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NmqBiS6+SwZn9pTwZnUkN7lJ7KmnizD8AtO5bpATROo=;
        b=rHIrWextVYPXcjrabk9crmiu3EDdaGOgnIjnrVPqaYYyvfQw+Iy6UKWWk4VzangQRB
         41LAZNVr7/HSNAGV1ezOP+T+8E3Vp8L6p3nnjXdgIk80AsO/7/Ns9IfilbqZPq3b+pcz
         pWk6wrsKC/LiikB8sR3Pdb38cwiDxzaCzlBezk8bv83XDnFIqdCLghhvlo0h0bXAgTRS
         BI3zeibXyZ9R/0fMrwpGCeshcEpZAAhgHymeIgOU510ctKUwOxIA5kBMP8S1CuK4S2za
         MBd9y+6ahXOFiIDBXAIls8Yfs67kC8HTrgZPjmVyqSgCHVTVo4Tc0RUKQuzkD/KGFhp2
         YcFw==
X-Gm-Message-State: AOJu0YxxOHjSkCa0p3kXTIH3zLxnYNCoO5oPJ5OZgzInGtSpOXkvhAlL
	69mKkTwVsisNopPoisrhTVbZguq4rw8kVLEipzJdCJdSzTkAeTkuL61miMa6IwycHSkWPymF+Q3
	MP6JXIQ==
X-Google-Smtp-Source: AGHT+IGY1NBM2XOWhkiUixcmdJOoH12DnU1T1AFPCYObwsdq9fJeRfBiMmXZxfkhELZV1wZDo8kMuXCtULc=
X-Received: from pjrx5.prod.google.com ([2002:a17:90a:bc85:b0:33b:ca21:e3e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a8b:b0:343:f509:aa4a
 with SMTP id 98e67ed59e1d1-349a260a9d0mr673218a91.36.1764981806998; Fri, 05
 Dec 2025 16:43:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:43:08 -0800
In-Reply-To: <20251206004311.479939-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206004311.479939-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206004311.479939-7-seanjc@google.com>
Subject: [PATCH 6/9] KVM: x86: Add a wrapper to handle common case of IRQ
 delivery without dest_map
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Turn kvm_irq_delivery_to_apic() into a wrapper that passes NULL for the
@dest_map param, as only the ugly I/O APIC RTC hackery needs to know which
vCPUs received the IRQ.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.c |  2 +-
 arch/x86/kvm/ioapic.c |  6 +++---
 arch/x86/kvm/irq.c    |  4 ++--
 arch/x86/kvm/lapic.c  | 23 ++++++++++++++++-------
 arch/x86/kvm/lapic.h  | 16 ++++++++++++----
 arch/x86/kvm/x86.c    |  2 +-
 arch/x86/kvm/xen.c    |  2 +-
 7 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index de92292eb1f5..49bf744ca8e3 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -492,7 +492,7 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
 	irq.vector = vector;
 	irq.level = 1;
 
-	ret = kvm_irq_delivery_to_apic(vcpu->kvm, vcpu->arch.apic, &irq, NULL);
+	ret = kvm_irq_delivery_to_apic(vcpu->kvm, vcpu->arch.apic, &irq);
 	trace_kvm_hv_synic_set_irq(vcpu->vcpu_id, sint, irq.vector, ret);
 	return ret;
 }
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 955c781ba623..4b49f9728362 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -485,11 +485,11 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 		 * if rtc_irq_check_coalesced returns false).
 		 */
 		BUG_ON(ioapic->rtc_status.pending_eoi != 0);
-		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe,
-					       &ioapic->rtc_status.dest_map);
+		ret = __kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe,
+						 &ioapic->rtc_status.dest_map);
 		ioapic->rtc_status.pending_eoi = (ret < 0 ? 0 : ret);
 	} else
-		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe, NULL);
+		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe);
 
 	if (ret && irqe.trig_mode == IOAPIC_LEVEL_TRIG)
 		entry->fields.remote_irr = 1;
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 7cc8950005b6..a52115441c07 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -235,7 +235,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 
 	kvm_msi_to_lapic_irq(kvm, e, &irq);
 
-	return kvm_irq_delivery_to_apic(kvm, NULL, &irq, NULL);
+	return kvm_irq_delivery_to_apic(kvm, NULL, &irq);
 }
 
 int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
@@ -258,7 +258,7 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 
 		kvm_msi_to_lapic_irq(kvm, e, &irq);
 
-		if (kvm_irq_delivery_to_apic_fast(kvm, NULL, &irq, &r, NULL))
+		if (kvm_irq_delivery_to_apic_fast(kvm, NULL, &irq, &r))
 			return r;
 		break;
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 785c0352fa0e..769facb27d3d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1175,8 +1175,9 @@ static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
 	return true;
 }
 
-bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
-		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map)
+static bool __kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
+					    struct kvm_lapic_irq *irq, int *r,
+					    struct dest_map *dest_map)
 {
 	struct kvm_apic_map *map;
 	unsigned long bitmap;
@@ -1212,6 +1213,13 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 	return ret;
 }
 
+
+bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
+				   struct kvm_lapic_irq *irq, int *r)
+{
+	return __kvm_irq_delivery_to_apic_fast(kvm, src, irq, r, NULL);
+}
+
 /*
  * This routine tries to handle interrupts in posted mode, here is how
  * it deals with different cases:
@@ -1283,15 +1291,16 @@ bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_intr_is_single_vcpu);
 
-int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
-			     struct kvm_lapic_irq *irq, struct dest_map *dest_map)
+int __kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
+			       struct kvm_lapic_irq *irq,
+			       struct dest_map *dest_map)
 {
 	int r = -1;
 	struct kvm_vcpu *vcpu, *lowest = NULL;
 	unsigned long i, dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 	unsigned int dest_vcpus = 0;
 
-	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
+	if (__kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
 		return r;
 
 	if (irq->dest_mode == APIC_DEST_PHYSICAL &&
@@ -1587,7 +1596,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 
 	trace_kvm_apic_ipi(icr_low, irq.dest_id);
 
-	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, NULL);
+	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_apic_send_ipi);
 
@@ -2556,7 +2565,7 @@ static int __kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data, bool fast)
 		kvm_icr_to_lapic_irq(apic, (u32)data, (u32)(data >> 32), &irq);
 
 		if (!kvm_irq_delivery_to_apic_fast(apic->vcpu->kvm, apic, &irq,
-						   &ignored, NULL))
+						   &ignored))
 			return -EWOULDBLOCK;
 
 		trace_kvm_apic_ipi((u32)data, irq.dest_id);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 282b9b7da98c..901c05a5ac60 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -117,10 +117,18 @@ int kvm_alloc_apic_access_page(struct kvm *kvm);
 void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu);
 
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
-		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
-int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
-			     struct kvm_lapic_irq *irq,
-			     struct dest_map *dest_map);
+				   struct kvm_lapic_irq *irq, int *r);
+int __kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
+			       struct kvm_lapic_irq *irq,
+			       struct dest_map *dest_map);
+
+static inline int kvm_irq_delivery_to_apic(struct kvm *kvm,
+					   struct kvm_lapic *src,
+					   struct kvm_lapic_irq *irq)
+{
+	return __kvm_irq_delivery_to_apic(kvm, src, irq, NULL);
+}
+
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 
 int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f582dac9ea0c..bf8059179edb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10245,7 +10245,7 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
 		.dest_id = apicid,
 	};
 
-	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
+	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq);
 }
 
 bool kvm_apicv_activated(struct kvm *kvm)
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d6b2a665b499..28eeb1b2a16c 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -626,7 +626,7 @@ void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
 	irq.delivery_mode = APIC_DM_FIXED;
 	irq.level = 1;
 
-	kvm_irq_delivery_to_apic(v->kvm, NULL, &irq, NULL);
+	kvm_irq_delivery_to_apic(v->kvm, NULL, &irq);
 }
 
 /*
-- 
2.52.0.223.gf5cc29aaa4-goog


