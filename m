Return-Path: <kvm+bounces-42353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F61CA78008
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B75E16D603
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF1F221DBA;
	Tue,  1 Apr 2025 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YRf6/fdZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25454221D8D
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523927; cv=none; b=E5hmbyc82j1r+f7T8f5+hYFqDZt+SOZV/5yCwSF2hxXNP6LL5irhwcbA1z4VD1HzOAMYLbL7UFYMJ9qs3MCzRL4e0MY59UsGR/4jwOK9TgItxpENtvEQ/ZUx7v0e5HfQVIvuC5Bauzjv1+dBotZpRnVYEu67gte+blKTwX5q8p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523927; c=relaxed/simple;
	bh=5tt6gGijGYJr7yu5paRKM0yRgVu/D/f2JfLQVjaI0xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Imqg6E0mj2m4LNKiXSwgK1RoLoohbLavt+iz+X/oYoLTn+hartN9HPwV/UAzspJ4OGwzpHbsKndRajnuQM7JCKcmE52LcSETpsdFwLHGpGQzK+T2CWs0eaYKFiSwlqcZwkp8WhNwy/xhyRxBaqnYAFDT/8vWqLoM5YEnR1Ko0Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YRf6/fdZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VvZ6p2WrQQTblruIVD9gbYy1bh08r8hJdsaxuYeoEEI=;
	b=YRf6/fdZlmOzuZ1tk+FLjaAqDGz1twfqzvDg0uvtopLWgWSsJwZk5AsdfDQogn0FRohkOg
	EMKSt5pfYf8yrRHympdx+P1kK6+ImX8TjMf5ycMcbZ0IYO+7oQrVeD3Cf1wupE6u+hWzC2
	hpbr0EdK6BLzWq1lyE/pnIAgp7Dum4c=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-SYXGf879P5WdsdpLAnVgFQ-1; Tue, 01 Apr 2025 12:12:02 -0400
X-MC-Unique: SYXGf879P5WdsdpLAnVgFQ-1
X-Mimecast-MFC-AGG-ID: SYXGf879P5WdsdpLAnVgFQ_1743523922
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3913aaf1e32so3298224f8f.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:12:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523921; x=1744128721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VvZ6p2WrQQTblruIVD9gbYy1bh08r8hJdsaxuYeoEEI=;
        b=kKv9YF2bJTeZDJFaZSlzTGJSvXukZZUlHo2neV53ZE7cYhqWKuA5noRwy3ZE4L4zRn
         gn29PfpQlvoHmz6tEy9re3TH25Yw78Eu/Lh7SAq0eLsxoduZ7BZcLx0pBWiq0ay9Arlq
         l4h6WUu51cAeNo9EpEgxxY1F/alpSmiEYjpKpliwwWWEFSF6u1irb2APs2tpJuLnxcJp
         0Ws5twkXiKRSvgT28+LGoMv1vdUO/bTRLvlq1G6H+Ljg7q/sk9QvPjb1edYjy/POSAnr
         Vv9yp46hh8a1VW68IPSGlEei/ONRG2s8GFoVAO+pKLYWswCf9WOGX1Z3J/7MNazIMubh
         u+pg==
X-Forwarded-Encrypted: i=1; AJvYcCU6rZu8PO4RqljPbIjjlKpmlkph9s7VROS1lS1Z7usSh1KbA/aeFdtXwMVIpl70IdvO100=@vger.kernel.org
X-Gm-Message-State: AOJu0YwF5QCYWxtdcIgTkhOk3y4SsslcBIkK26YRd/Cmir72keacV2hE
	KwOaP/A4n0FyHeB0KOnoCiv3jdxoqvfgXYQSfiUTxTw4RkOuynGZNiyE1wDe56gARSulb63pNxe
	X1FIyh3es5bn9foix05Zq4UcOIzxMOOg9U5BOgeALY8BmFd1iRA==
X-Gm-Gg: ASbGncvov8AMrQ+/T4Xl0hHiJ0BRy9B7RCw4Gjm9L9HQrKGYAR687f5SncWwRmbUDYF
	zLC1go6tnigShKRWEvJAvpXxfBkStId572+Mbjc6vdIjMqih1pZx+JtBHd+6rhSYaAzQhgJ5UbP
	+PWsNCv7FKaQI52Aq4C8BERY66kyuzycpn4Ohb17+quf/ux1NA8fI7Hh89vyFCYXcwnQ1X5LRTj
	7404k9jhGPjTRKcPVFwTTh7Hi+IsTNcVloAZV9wAk0RriwvLyOMywT3WYyjQWKiFs2hqXRy0jJt
	9w/A5IMztZ+djr6wbL1weg==
X-Received: by 2002:a05:6000:290f:b0:390:f552:d291 with SMTP id ffacd0b85a97d-39c120dc53emr14114204f8f.22.1743523921381;
        Tue, 01 Apr 2025 09:12:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEjZPOv67fdn5slA2kWJTIKa56TO0rlWQ9//KKstMEhjPv7ui4gb+V8jJo68vRdLNVttSIuA==
X-Received: by 2002:a05:6000:290f:b0:390:f552:d291 with SMTP id ffacd0b85a97d-39c120dc53emr14114152f8f.22.1743523920948;
        Tue, 01 Apr 2025 09:12:00 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b79e33asm14665265f8f.66.2025.04.01.09.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:59 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 19/29] KVM: x86: move APIC map to kvm_arch_plane
Date: Tue,  1 Apr 2025 18:10:56 +0200
Message-ID: <20250401161106.790710-20-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IRQs need to be directed to the appropriate plane (typically, but not
always, the same as the vCPU that is running).  Because each plane has
a separate struct kvm_vcpu *, the map that holds the pointers to them
must be individual to the plane as well.

This works fine as long as all IRQs (even those directed at multiple CPUs)
only target a single plane.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +--
 arch/x86/kvm/lapic.c            | 94 +++++++++++++++++++--------------
 arch/x86/kvm/svm/sev.c          |  2 +-
 arch/x86/kvm/x86.c              | 10 ++--
 4 files changed, 67 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d07ab048d7cc..f832352cf4d3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1087,6 +1087,10 @@ struct kvm_arch_memory_slot {
 };
 
 struct kvm_arch_plane {
+	struct mutex apic_map_lock;
+	struct kvm_apic_map __rcu *apic_map;
+	atomic_t apic_map_dirty;
+
 	unsigned long apicv_inhibit_reasons;
 };
 
@@ -1381,9 +1385,6 @@ struct kvm_arch {
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
 	atomic_t vapics_in_nmi_mode;
-	struct mutex apic_map_lock;
-	struct kvm_apic_map __rcu *apic_map;
-	atomic_t apic_map_dirty;
 
 	bool apic_access_memslot_enabled;
 	bool apic_access_memslot_inhibited;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4077c8d1e37e..6ed5f5b4f878 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -375,9 +375,9 @@ enum {
 	DIRTY
 };
 
-static void kvm_recalculate_apic_map(struct kvm *kvm)
+static void kvm_recalculate_apic_map(struct kvm_plane *plane)
 {
-	struct kvm_plane *plane = kvm->planes[0];
+	struct kvm *kvm = plane->kvm;
 	struct kvm_apic_map *new, *old = NULL;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
@@ -385,27 +385,27 @@ static void kvm_recalculate_apic_map(struct kvm *kvm)
 	bool xapic_id_mismatch;
 	int r;
 
-	/* Read kvm->arch.apic_map_dirty before kvm->arch.apic_map.  */
-	if (atomic_read_acquire(&kvm->arch.apic_map_dirty) == CLEAN)
+	/* Read plane->arch.apic_map_dirty before plane->arch.apic_map.  */
+	if (atomic_read_acquire(&plane->arch.apic_map_dirty) == CLEAN)
 		return;
 
 	WARN_ONCE(!irqchip_in_kernel(kvm),
 		  "Dirty APIC map without an in-kernel local APIC");
 
-	mutex_lock(&kvm->arch.apic_map_lock);
+	mutex_lock(&plane->arch.apic_map_lock);
 
 retry:
 	/*
-	 * Read kvm->arch.apic_map_dirty before kvm->arch.apic_map (if clean)
+	 * Read plane->arch.apic_map_dirty before plane->arch.apic_map (if clean)
 	 * or the APIC registers (if dirty).  Note, on retry the map may have
 	 * not yet been marked dirty by whatever task changed a vCPU's x2APIC
 	 * ID, i.e. the map may still show up as in-progress.  In that case
 	 * this task still needs to retry and complete its calculation.
 	 */
-	if (atomic_cmpxchg_acquire(&kvm->arch.apic_map_dirty,
+	if (atomic_cmpxchg_acquire(&plane->arch.apic_map_dirty,
 				   DIRTY, UPDATE_IN_PROGRESS) == CLEAN) {
 		/* Someone else has updated the map. */
-		mutex_unlock(&kvm->arch.apic_map_lock);
+		mutex_unlock(&plane->arch.apic_map_lock);
 		return;
 	}
 
@@ -418,7 +418,7 @@ static void kvm_recalculate_apic_map(struct kvm *kvm)
 	 */
 	xapic_id_mismatch = false;
 
-	kvm_for_each_vcpu(i, vcpu, kvm)
+	kvm_for_each_plane_vcpu(i, vcpu, plane)
 		if (kvm_apic_present(vcpu))
 			max_id = max(max_id, kvm_x2apic_id(vcpu->arch.apic));
 
@@ -432,7 +432,7 @@ static void kvm_recalculate_apic_map(struct kvm *kvm)
 	new->max_apic_id = max_id;
 	new->logical_mode = KVM_APIC_MODE_SW_DISABLED;
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
+	kvm_for_each_plane_vcpu(i, vcpu, plane) {
 		if (!kvm_apic_present(vcpu))
 			continue;
 
@@ -471,21 +471,29 @@ static void kvm_recalculate_apic_map(struct kvm *kvm)
 	else
 		kvm_clear_apicv_inhibit(plane, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
 
-	old = rcu_dereference_protected(kvm->arch.apic_map,
-			lockdep_is_held(&kvm->arch.apic_map_lock));
-	rcu_assign_pointer(kvm->arch.apic_map, new);
+	old = rcu_dereference_protected(plane->arch.apic_map,
+			lockdep_is_held(&plane->arch.apic_map_lock));
+	rcu_assign_pointer(plane->arch.apic_map, new);
 	/*
-	 * Write kvm->arch.apic_map before clearing apic->apic_map_dirty.
+	 * Write plane->arch.apic_map before clearing apic->apic_map_dirty.
 	 * If another update has come in, leave it DIRTY.
 	 */
-	atomic_cmpxchg_release(&kvm->arch.apic_map_dirty,
+	atomic_cmpxchg_release(&plane->arch.apic_map_dirty,
 			       UPDATE_IN_PROGRESS, CLEAN);
-	mutex_unlock(&kvm->arch.apic_map_lock);
+	mutex_unlock(&plane->arch.apic_map_lock);
 
 	if (old)
 		kvfree_rcu(old, rcu);
 
-	kvm_make_scan_ioapic_request(kvm);
+	if (plane->plane == 0)
+		kvm_make_scan_ioapic_request(kvm);
+}
+
+static inline void kvm_mark_apic_map_dirty(struct kvm_vcpu *vcpu)
+{
+	struct kvm_plane *plane = vcpu_to_plane(vcpu);
+
+	atomic_set_release(&plane->arch.apic_map_dirty, DIRTY);
 }
 
 static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
@@ -501,7 +509,7 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 		else
 			static_branch_inc(&apic_sw_disabled.key);
 
-		atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
+		kvm_mark_apic_map_dirty(apic->vcpu);
 	}
 
 	/* Check if there are APF page ready requests pending */
@@ -514,19 +522,19 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
 {
 	kvm_lapic_set_reg(apic, APIC_ID, id << 24);
-	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
+	kvm_mark_apic_map_dirty(apic->vcpu);
 }
 
 static inline void kvm_apic_set_ldr(struct kvm_lapic *apic, u32 id)
 {
 	kvm_lapic_set_reg(apic, APIC_LDR, id);
-	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
+	kvm_mark_apic_map_dirty(apic->vcpu);
 }
 
 static inline void kvm_apic_set_dfr(struct kvm_lapic *apic, u32 val)
 {
 	kvm_lapic_set_reg(apic, APIC_DFR, val);
-	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
+	kvm_mark_apic_map_dirty(apic->vcpu);
 }
 
 static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
@@ -537,7 +545,7 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
 
 	kvm_lapic_set_reg(apic, APIC_ID, id);
 	kvm_lapic_set_reg(apic, APIC_LDR, ldr);
-	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
+	kvm_mark_apic_map_dirty(apic->vcpu);
 }
 
 static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
@@ -866,6 +874,7 @@ int kvm_pv_send_ipi(struct kvm_vcpu *source, unsigned long ipi_bitmap_low,
 		    unsigned long ipi_bitmap_high, u32 min,
 		    unsigned long icr, int op_64_bit)
 {
+	struct kvm_plane *plane = vcpu_to_plane(source);
 	struct kvm_apic_map *map;
 	struct kvm_lapic_irq irq = {0};
 	int cluster_size = op_64_bit ? 64 : 32;
@@ -880,7 +889,7 @@ int kvm_pv_send_ipi(struct kvm_vcpu *source, unsigned long ipi_bitmap_low,
 	irq.trig_mode = icr & APIC_INT_LEVELTRIG;
 
 	rcu_read_lock();
-	map = rcu_dereference(source->kvm->arch.apic_map);
+	map = rcu_dereference(plane->arch.apic_map);
 
 	count = -EOPNOTSUPP;
 	if (likely(map)) {
@@ -1152,7 +1161,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
  * means that the interrupt should be dropped.  In this case, *bitmap would be
  * zero and *dst undefined.
  */
-static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
+static inline bool kvm_apic_map_get_dest_lapic(struct kvm_plane *plane,
 		struct kvm_lapic **src, struct kvm_lapic_irq *irq,
 		struct kvm_apic_map *map, struct kvm_lapic ***dst,
 		unsigned long *bitmap)
@@ -1166,7 +1175,7 @@ static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
 	} else if (irq->shorthand)
 		return false;
 
-	if (!map || kvm_apic_is_broadcast_dest(kvm, src, irq, map))
+	if (!map || kvm_apic_is_broadcast_dest(plane->kvm, src, irq, map))
 		return false;
 
 	if (irq->dest_mode == APIC_DEST_PHYSICAL) {
@@ -1207,7 +1216,7 @@ static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
 				bitmap, 16);
 
 		if (!(*dst)[lowest]) {
-			kvm_apic_disabled_lapic_found(kvm);
+			kvm_apic_disabled_lapic_found(plane->kvm);
 			*bitmap = 0;
 			return true;
 		}
@@ -1221,6 +1230,7 @@ static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map)
 {
+	struct kvm_plane *plane = kvm->planes[0];
 	struct kvm_apic_map *map;
 	unsigned long bitmap;
 	struct kvm_lapic **dst = NULL;
@@ -1228,6 +1238,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 	bool ret;
 
 	*r = -1;
+	if (KVM_BUG_ON(!plane, kvm)) {
+		*r = 0;
+		return true;
+	}
 
 	if (irq->shorthand == APIC_DEST_SELF) {
 		if (KVM_BUG_ON(!src, kvm)) {
@@ -1239,9 +1253,9 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 	}
 
 	rcu_read_lock();
-	map = rcu_dereference(kvm->arch.apic_map);
+	map = rcu_dereference(plane->arch.apic_map);
 
-	ret = kvm_apic_map_get_dest_lapic(kvm, &src, irq, map, &dst, &bitmap);
+	ret = kvm_apic_map_get_dest_lapic(plane, &src, irq, map, &dst, &bitmap);
 	if (ret) {
 		*r = 0;
 		for_each_set_bit(i, &bitmap, 16) {
@@ -1272,6 +1286,7 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu)
 {
+	struct kvm_plane *plane = kvm->planes[0];
 	struct kvm_apic_map *map;
 	unsigned long bitmap;
 	struct kvm_lapic **dst = NULL;
@@ -1281,9 +1296,9 @@ bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 		return false;
 
 	rcu_read_lock();
-	map = rcu_dereference(kvm->arch.apic_map);
+	map = rcu_dereference(plane->arch.apic_map);
 
-	if (kvm_apic_map_get_dest_lapic(kvm, NULL, irq, map, &dst, &bitmap) &&
+	if (kvm_apic_map_get_dest_lapic(plane, NULL, irq, map, &dst, &bitmap) &&
 			hweight16(bitmap) == 1) {
 		unsigned long i = find_first_bit(&bitmap, 16);
 
@@ -1407,6 +1422,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			      unsigned long *vcpu_bitmap)
 {
+	struct kvm_plane *plane = kvm->planes[0];
 	struct kvm_lapic **dest_vcpu = NULL;
 	struct kvm_lapic *src = NULL;
 	struct kvm_apic_map *map;
@@ -1416,9 +1432,9 @@ void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
 	bool ret;
 
 	rcu_read_lock();
-	map = rcu_dereference(kvm->arch.apic_map);
+	map = rcu_dereference(plane->arch.apic_map);
 
-	ret = kvm_apic_map_get_dest_lapic(kvm, &src, irq, map, &dest_vcpu,
+	ret = kvm_apic_map_get_dest_lapic(plane, &src, irq, map, &dest_vcpu,
 					  &bitmap);
 	if (ret) {
 		for_each_set_bit(i, &bitmap, 16) {
@@ -2420,7 +2436,7 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	 * was toggled, the APIC ID changed, etc...   The maps are marked dirty
 	 * on relevant changes, i.e. this is a nop for most writes.
 	 */
-	kvm_recalculate_apic_map(apic->vcpu->kvm);
+	kvm_recalculate_apic_map(vcpu_to_plane(apic->vcpu));
 
 	return ret;
 }
@@ -2610,7 +2626,7 @@ static void __kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value)
 			kvm_make_request(KVM_REQ_APF_READY, vcpu);
 		} else {
 			static_branch_inc(&apic_hw_disabled.key);
-			atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
+			kvm_mark_apic_map_dirty(apic->vcpu);
 		}
 	}
 
@@ -2657,7 +2673,7 @@ int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated)
 	}
 
 	__kvm_apic_set_base(vcpu, value);
-	kvm_recalculate_apic_map(vcpu->kvm);
+	kvm_recalculate_apic_map(vcpu_to_plane(vcpu));
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_apic_set_base);
@@ -2823,7 +2839,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.apic_arb_prio = 0;
 	vcpu->arch.apic_attention = 0;
 
-	kvm_recalculate_apic_map(vcpu->kvm);
+	kvm_recalculate_apic_map(vcpu_to_plane(apic->vcpu));
 }
 
 /*
@@ -3115,13 +3131,13 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 
 	r = kvm_apic_state_fixup(vcpu, s, true);
 	if (r) {
-		kvm_recalculate_apic_map(vcpu->kvm);
+		kvm_recalculate_apic_map(vcpu_to_plane(apic->vcpu));
 		return r;
 	}
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
 
-	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
-	kvm_recalculate_apic_map(vcpu->kvm);
+	kvm_mark_apic_map_dirty(apic->vcpu);
+	kvm_recalculate_apic_map(vcpu_to_plane(apic->vcpu));
 	kvm_apic_set_version(vcpu);
 
 	apic_update_ppr(apic);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 130d895f1d95..9d4492862c11 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -458,7 +458,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	INIT_LIST_HEAD(&sev->mirror_vms);
 	sev->need_init = false;
 
-	kvm_set_apicv_inhibit(kvm->planes[0], APICV_INHIBIT_REASON_SEV);
+	kvm_set_apicv_inhibit(kvm->planes[[0], APICV_INHIBIT_REASON_SEV);
 
 	return 0;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 382d8ace131f..19e3bb33bf7d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10021,7 +10021,7 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 		goto no_yield;
 
 	rcu_read_lock();
-	map = rcu_dereference(vcpu->kvm->arch.apic_map);
+	map = rcu_dereference(vcpu_to_plane(vcpu)->arch.apic_map);
 
 	if (likely(map) && dest_id <= map->max_apic_id && map->phys_map[dest_id])
 		target = map->phys_map[dest_id]->vcpu;
@@ -12771,6 +12771,7 @@ void kvm_arch_free_vm(struct kvm *kvm)
 
 void kvm_arch_init_plane(struct kvm_plane *plane)
 {
+	mutex_init(&plane->arch.apic_map_lock);
 	kvm_apicv_init(plane->kvm, &plane->arch.apicv_inhibit_reasons);
 }
 
@@ -12811,7 +12812,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	init_rwsem(&kvm->arch.apicv_update_lock);
 	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
-	mutex_init(&kvm->arch.apic_map_lock);
 	seqcount_raw_spinlock_init(&kvm->arch.pvclock_sc, &kvm->arch.tsc_write_lock);
 	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
 
@@ -12960,6 +12960,11 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 	static_call_cond(kvm_x86_vm_pre_destroy)(kvm);
 }
 
+void kvm_arch_free_plane(struct kvm_plane *plane)
+{
+	kvfree(rcu_dereference_check(plane->arch.apic_map, 1));
+}
+
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	if (current->mm == kvm->mm) {
@@ -12981,7 +12986,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
-	kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
 	kvm_mmu_uninit_vm(kvm);
 	kvm_page_track_cleanup(kvm);
-- 
2.49.0


