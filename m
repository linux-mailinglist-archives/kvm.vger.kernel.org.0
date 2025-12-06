Return-Path: <kvm+bounces-65445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1CFCA9C4E
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E13A31ACCED
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BFA71E9B22;
	Sat,  6 Dec 2025 00:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xomvszyy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E639C319614
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764981812; cv=none; b=PrMdzaKvyiKTt1BeplWShWZxp6JHiaUQfqG8CFpAJdEIlNYI8EB7lin/a8U9fsK1kONs4449R/ycj6ftUQP37F/QZd+6RlbHmu3lTnqsz+PDDQJNjmD9bcpB/rMFkodSSKP7AhQGUSxHg//m6yHed95BPQRQXZzCpQ76sYyRThY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764981812; c=relaxed/simple;
	bh=0GMlepk5J3ka1U9kVqIcu6b3l8f5stdI7eG+wGPYhvo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hRXHaa+8VVfA69pGyxqxk4G9qvyGVVrhnNURDwxE7qrEk0keoVPIZslNQoisAuRdhRFA7k0dS2DS9+tOnVBUv1SXXXdXxY6sWID7xQeFdhURYv2epJo/kHEEq7+DJh+UcyMPvRFEmS0xcnIwy1NT/0h1NxLofCtWBNg7lDcqOWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xomvszyy; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7bad1cef9bcso5155331b3a.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764981809; x=1765586609; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FSL4bypVJAYNju9c3VWi1yEjMMlrNBcwT+8KbaMOsjM=;
        b=XomvszyymPWDOunGSmXaUy1gLwXdAk8OrmBkdN9qhM9k/IdhKAowdFW4l85WUFvf3n
         E/BV6zqNh3VTXoCKNhKYlZs4+LRjmp/Vv/aYrSLtzmEftIHHTtQce2FMr7aNGwWRYypp
         AJz5douDazgEdnXnThV+nLVrEAtuAYStCdB6QZtNN0V4m8GtWW7ewQkJZ2FgpGneED0O
         f6a50qhnWLpPjcBjKm7gcpzpjY36PXTfsIiVQQlNB+ZCER8HWKZdMrXQ+xdDmKC9GE7w
         ikjw4WUjtJIEMDwFjVkm45r500u4XWO/KIvLoPmzj3ggFIVxcxns2aPYePyFLsimCETg
         gAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764981809; x=1765586609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FSL4bypVJAYNju9c3VWi1yEjMMlrNBcwT+8KbaMOsjM=;
        b=Zd0ViwIJ2lrae8DyrpOxirYcVosrPMnJeZd3vSBg8Vm8jhuSwhfGdRxvoyp6XYGFTT
         QSxJS/tDMiftjxkG3OYCukR9OSzR0rnz+iJ6/5sEEGGJ4d7Je7dZNCDtPBofyD43fS5s
         aXzZyvmSpd2dKNs8pT78b0XdC0o9g9TBlZYRmGmQx7QqK/22lbefjo/lCyL6/8KgZ59v
         Fo0gLzRk1hu7SS3qlN2XCRlnuFmPZu0TLCa8iIa003AM1CNGuNUEHL+36HUucQVZAR7x
         GeiW3cfJNghAZjxp3HiaKHLKHqRpzy56KLRErGhyZyFDbeQh/oTdsgDOTlXX7FAehGc1
         YiKQ==
X-Gm-Message-State: AOJu0YyNYTv1S/4cW19l1Q2/JUf/3cbXZLBaA7RB57Q2PwuIjHVZLA0D
	UKr6vxQmLJmpsxC/wdqNvhwVG7TGJFDUE0KOpYWj4Fiao2NLQuxoPcN+kbCQYK19T/37npE8AUA
	XwES7bw==
X-Google-Smtp-Source: AGHT+IGV66CYDTsYUINlpwHFrVLWFlpZRohRkTuK6c5ypaJuCWDBEbI1RF8SRREhYV4AYY97PwaqpI+KuIw=
X-Received: from pfbna23.prod.google.com ([2002:a05:6a00:3e17:b0:793:b157:af51])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3e14:b0:7e8:4433:8fb3
 with SMTP id d2e1a72fcca58-7e8c6c9d722mr904909b3a.59.1764981809149; Fri, 05
 Dec 2025 16:43:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:43:09 -0800
In-Reply-To: <20251206004311.479939-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206004311.479939-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206004311.479939-8-seanjc@google.com>
Subject: [PATCH 7/9] KVM: x86: Fold "struct dest_map" into "struct rtc_status"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop "struct dest_map" and fold its members into its one and only user,
"struct rtc_status".  Tracking "pending" EOIs and associated vCPUs is very
much a hack for legacy RTC behavior, and should never be needed for other
IRQ delivery.  In addition to making it more obvious why KVM tracks target
vCPUs, this will allow burying the "struct rtc_status" definition behind
CONFIG_KVM_IOAPIC=y, which in turn will make it even harder for KVM to
misuse the structure.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/ioapic.c | 29 ++++++++++++++---------------
 arch/x86/kvm/ioapic.h | 10 +++-------
 arch/x86/kvm/lapic.c  | 28 ++++++++++++++--------------
 arch/x86/kvm/lapic.h  |  6 +++---
 4 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 4b49f9728362..9a99d01b111c 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -77,7 +77,7 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic)
 static void rtc_irq_eoi_tracking_reset(struct kvm_ioapic *ioapic)
 {
 	ioapic->rtc_status.pending_eoi = 0;
-	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_IDS);
+	bitmap_zero(ioapic->rtc_status.map, KVM_MAX_VCPU_IDS);
 }
 
 static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic);
@@ -92,7 +92,7 @@ static void __rtc_irq_eoi_tracking_restore_one(struct kvm_vcpu *vcpu)
 {
 	bool new_val, old_val;
 	struct kvm_ioapic *ioapic = vcpu->kvm->arch.vioapic;
-	struct dest_map *dest_map = &ioapic->rtc_status.dest_map;
+	struct rtc_status *status = &ioapic->rtc_status;
 	union kvm_ioapic_redirect_entry *e;
 
 	e = &ioapic->redirtbl[RTC_GSI];
@@ -102,17 +102,17 @@ static void __rtc_irq_eoi_tracking_restore_one(struct kvm_vcpu *vcpu)
 		return;
 
 	new_val = kvm_apic_pending_eoi(vcpu, e->fields.vector);
-	old_val = test_bit(vcpu->vcpu_id, dest_map->map);
+	old_val = test_bit(vcpu->vcpu_id, status->map);
 
 	if (new_val == old_val)
 		return;
 
 	if (new_val) {
-		__set_bit(vcpu->vcpu_id, dest_map->map);
-		dest_map->vectors[vcpu->vcpu_id] = e->fields.vector;
+		__set_bit(vcpu->vcpu_id, status->map);
+		status->vectors[vcpu->vcpu_id] = e->fields.vector;
 		ioapic->rtc_status.pending_eoi++;
 	} else {
-		__clear_bit(vcpu->vcpu_id, dest_map->map);
+		__clear_bit(vcpu->vcpu_id, status->map);
 		ioapic->rtc_status.pending_eoi--;
 		rtc_status_pending_eoi_check_valid(ioapic);
 	}
@@ -143,13 +143,12 @@ static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic)
 static void rtc_irq_eoi(struct kvm_ioapic *ioapic, struct kvm_vcpu *vcpu,
 			int vector)
 {
-	struct dest_map *dest_map = &ioapic->rtc_status.dest_map;
+	struct rtc_status *status = &ioapic->rtc_status;
 
 	/* RTC special handling */
-	if (test_bit(vcpu->vcpu_id, dest_map->map) &&
-	    (vector == dest_map->vectors[vcpu->vcpu_id]) &&
-	    (test_and_clear_bit(vcpu->vcpu_id,
-				ioapic->rtc_status.dest_map.map))) {
+	if (test_bit(vcpu->vcpu_id, status->map) &&
+	    (vector == status->vectors[vcpu->vcpu_id]) &&
+	    (test_and_clear_bit(vcpu->vcpu_id, status->map))) {
 		--ioapic->rtc_status.pending_eoi;
 		rtc_status_pending_eoi_check_valid(ioapic);
 	}
@@ -260,15 +259,15 @@ static void kvm_ioapic_inject_all(struct kvm_ioapic *ioapic, unsigned long irr)
 void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong *ioapic_handled_vectors)
 {
 	struct kvm_ioapic *ioapic = vcpu->kvm->arch.vioapic;
-	struct dest_map *dest_map = &ioapic->rtc_status.dest_map;
+	struct rtc_status *status = &ioapic->rtc_status;
 	union kvm_ioapic_redirect_entry *e;
 	int index;
 
 	spin_lock(&ioapic->lock);
 
 	/* Make sure we see any missing RTC EOI */
-	if (test_bit(vcpu->vcpu_id, dest_map->map))
-		__set_bit(dest_map->vectors[vcpu->vcpu_id],
+	if (test_bit(vcpu->vcpu_id, status->map))
+		__set_bit(status->vectors[vcpu->vcpu_id],
 			  ioapic_handled_vectors);
 
 	for (index = 0; index < IOAPIC_NUM_PINS; index++) {
@@ -486,7 +485,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 		 */
 		BUG_ON(ioapic->rtc_status.pending_eoi != 0);
 		ret = __kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe,
-						 &ioapic->rtc_status.dest_map);
+						 &ioapic->rtc_status);
 		ioapic->rtc_status.pending_eoi = (ret < 0 ? 0 : ret);
 	} else
 		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe);
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index ad238a6e63dc..868ed593a5c9 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -36,7 +36,9 @@ struct kvm_vcpu;
 
 #define RTC_GSI 8
 
-struct dest_map {
+struct rtc_status {
+	int pending_eoi;
+
 	/* vcpu bitmap where IRQ has been sent */
 	DECLARE_BITMAP(map, KVM_MAX_VCPU_IDS);
 
@@ -47,12 +49,6 @@ struct dest_map {
 	u8 vectors[KVM_MAX_VCPU_IDS];
 };
 
-
-struct rtc_status {
-	int pending_eoi;
-	struct dest_map dest_map;
-};
-
 union kvm_ioapic_redirect_entry {
 	u64 bits;
 	struct {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 769facb27d3d..0a44765aba12 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -784,15 +784,15 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_lapic_find_highest_irr);
 
 static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			     int vector, int level, int trig_mode,
-			     struct dest_map *dest_map);
+			     struct rtc_status *rtc_status);
 
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
-		     struct dest_map *dest_map)
+		     struct rtc_status *rtc_status)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	return __apic_accept_irq(apic, irq->delivery_mode, irq->vector,
-			irq->level, irq->trig_mode, dest_map);
+				 irq->level, irq->trig_mode, rtc_status);
 }
 
 static int __pv_send_ipi(unsigned long *ipi_bitmap, struct kvm_apic_map *map,
@@ -1177,7 +1177,7 @@ static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
 
 static bool __kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 					    struct kvm_lapic_irq *irq, int *r,
-					    struct dest_map *dest_map)
+					    struct rtc_status *rtc_status)
 {
 	struct kvm_apic_map *map;
 	unsigned long bitmap;
@@ -1192,7 +1192,7 @@ static bool __kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *s
 			*r = 0;
 			return true;
 		}
-		*r = kvm_apic_set_irq(src->vcpu, irq, dest_map);
+		*r = kvm_apic_set_irq(src->vcpu, irq, rtc_status);
 		return true;
 	}
 
@@ -1205,7 +1205,7 @@ static bool __kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *s
 		for_each_set_bit(i, &bitmap, 16) {
 			if (!dst[i])
 				continue;
-			*r += kvm_apic_set_irq(dst[i]->vcpu, irq, dest_map);
+			*r += kvm_apic_set_irq(dst[i]->vcpu, irq, rtc_status);
 		}
 	}
 
@@ -1293,14 +1293,14 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_intr_is_single_vcpu);
 
 int __kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 			       struct kvm_lapic_irq *irq,
-			       struct dest_map *dest_map)
+			       struct rtc_status *rtc_status)
 {
 	int r = -1;
 	struct kvm_vcpu *vcpu, *lowest = NULL;
 	unsigned long i, dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 	unsigned int dest_vcpus = 0;
 
-	if (__kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
+	if (__kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, rtc_status))
 		return r;
 
 	if (irq->dest_mode == APIC_DEST_PHYSICAL &&
@@ -1322,7 +1322,7 @@ int __kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		if (!kvm_lowest_prio_delivery(irq)) {
 			if (r < 0)
 				r = 0;
-			r += kvm_apic_set_irq(vcpu, irq, dest_map);
+			r += kvm_apic_set_irq(vcpu, irq, rtc_status);
 		} else if (kvm_apic_sw_enabled(vcpu->arch.apic)) {
 			if (!vector_hashing_enabled) {
 				if (!lowest)
@@ -1344,7 +1344,7 @@ int __kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 	}
 
 	if (lowest)
-		r = kvm_apic_set_irq(lowest, irq, dest_map);
+		r = kvm_apic_set_irq(lowest, irq, rtc_status);
 
 	return r;
 }
@@ -1355,7 +1355,7 @@ int __kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
  */
 static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			     int vector, int level, int trig_mode,
-			     struct dest_map *dest_map)
+			     struct rtc_status *rtc_status)
 {
 	int result = 0;
 	struct kvm_vcpu *vcpu = apic->vcpu;
@@ -1376,9 +1376,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 
 		result = 1;
 
-		if (dest_map) {
-			__set_bit(vcpu->vcpu_id, dest_map->map);
-			dest_map->vectors[vcpu->vcpu_id] = vector;
+		if (rtc_status) {
+			__set_bit(vcpu->vcpu_id, rtc_status->map);
+			rtc_status->vectors[vcpu->vcpu_id] = vector;
 		}
 
 		if (apic_test_vector(vector, apic->regs + APIC_TMR) != !!trig_mode) {
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 901c05a5ac60..71c80fa020e0 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -88,7 +88,7 @@ struct kvm_lapic {
 	int nr_lvt_entries;
 };
 
-struct dest_map;
+struct rtc_status;
 
 int kvm_create_lapic(struct kvm_vcpu *vcpu);
 void kvm_free_lapic(struct kvm_vcpu *vcpu);
@@ -110,7 +110,7 @@ bool __kvm_apic_update_irr(unsigned long *pir, void *regs, int *max_irr);
 bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, unsigned long *pir, int *max_irr);
 void kvm_apic_update_ppr(struct kvm_vcpu *vcpu);
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
-		     struct dest_map *dest_map);
+		     struct rtc_status *rtc_status);
 int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
 void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
 int kvm_alloc_apic_access_page(struct kvm *kvm);
@@ -120,7 +120,7 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 				   struct kvm_lapic_irq *irq, int *r);
 int __kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 			       struct kvm_lapic_irq *irq,
-			       struct dest_map *dest_map);
+			       struct rtc_status *rtc_status);
 
 static inline int kvm_irq_delivery_to_apic(struct kvm *kvm,
 					   struct kvm_lapic *src,
-- 
2.52.0.223.gf5cc29aaa4-goog


