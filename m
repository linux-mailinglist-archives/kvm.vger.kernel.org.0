Return-Path: <kvm+bounces-42354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61266A78006
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 068C81891D19
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F168A20E70B;
	Tue,  1 Apr 2025 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YsppG4+P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F523221DBC
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523930; cv=none; b=VAPp1vMXCfrPlSaHirKw+mmUXwZyS5P9yucPAbiDZLdfzAiEBI0pY/yv90W9oxp6GovJ/nGbmucZ2ah+h60qSS4vvwkXcGtSt7jpmJ4WJCRBAkZfHwyGF1xbyMqxdwYzoK1Xn3eC0Iep1LcIigfDgGZqigzmfpKCEKRRQ9jrHP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523930; c=relaxed/simple;
	bh=u5ldWiz2cXiotD/cOofMPUD+9S2OYpN2imw/B/Aw+M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hg47+x7Bss1NjhvnhaxR8bF79DC+EbgJThm15fvokJg7APZaavn94tr0B/hgY68LYQC3xmYGmaaJMYNEmH/tvJc7RdYJDVc+QK4cmyWButr108HrAUoHKKUlmu4WwOx1wqOAJ907rHM9YF12EKYeE1ZSPlK2pat8Ol3lk4cWLb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YsppG4+P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vrf7NR/iVZ/2wCl5JeoFe4lGIXCBAxX7ph94CsZNoVw=;
	b=YsppG4+P/VGc3p3wmw2XXtNkRb36F5fIPM+Tj4WJ0y7/4GK6LoKebDehpSgNkRphVQ2k7o
	0MfcGsTtpVaOl7ubzyMKGcHAJzgoBdQNqY7bD+UHZY5A7Ef4OK8vyQUUN4hAFmCse9H/6W
	0u7umTG/1VgwDclCuT+OSPA/MJYnJug=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523--Ks8kZBkN7--Nk0LxB8fcg-1; Tue, 01 Apr 2025 12:12:06 -0400
X-MC-Unique: -Ks8kZBkN7--Nk0LxB8fcg-1
X-Mimecast-MFC-AGG-ID: -Ks8kZBkN7--Nk0LxB8fcg_1743523925
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43ceeaf1524so30159295e9.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523925; x=1744128725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vrf7NR/iVZ/2wCl5JeoFe4lGIXCBAxX7ph94CsZNoVw=;
        b=bdOMQ7vUj5q3/Nh1tKf2x1feKDaGNNIjjipg7sPlnrf0mM+hKixvNEpOjg7P520jwJ
         EfAm343tpUqoT/1RAKVCBHMbsHym/zZ261bfTWAwIrITchnlDkOCBqLhAHy5XaH/u/iE
         kpDxdEyZXJj3KH6LovHvD7eaM6O0fhwQ8mr07ibWVhP6b4FGX/1FWIsmFAILhszfFqnp
         wboTmmkSVT94bjM44XNfre8yPDepsNTzOeeYHTw5LUVopOLfNzw/yhbTFxwSApdS3OHs
         eHMyTrjK4+lqGGdncMhyXWyxbxT35tjc24qH4Sr8vt3bSrCpNBxhb/XzkwxWFDqsqyGi
         4Sng==
X-Forwarded-Encrypted: i=1; AJvYcCWvQ0vWZUYQTHlfSy7D93ikQsUizHINIJEm0Md0H/fS9e8DR0vyUKPrmEO4p5LAcTk/6eE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTkisZGxUUU+BSg/0YG3T0nTcZBzX32pIZRuAh7vpIipOTveqd
	wllfWkMJp2TO+2ujU7AeNFgoIKpKp/Zyoo+hPsIq9M3mSomdVQaORN/sm1aTI20Zvg70D9Qp+0A
	DzDbRjrEjrhDzeoV2zcR6EUjB4vtN1ySO9Cjz7noIEQYCiwVEFg==
X-Gm-Gg: ASbGncvvXoMqhmrDID6bIhVdFaWDfeNzWNEoWmKd+cS4/TR9FT8sE1DmAIOfUBEJdhf
	+rffvyIhRpeAkLKWzcel4DFmE1skLKHZ06SoSu+CyrzFCo0lg03UrB5oZozy6wM7O5uS1WCpXE4
	q7ffZVNMW9toWefuBn56Uo4fvmI2qytwh5JyyNfcsssTGftUwG1vP7KtUx+BxV1gqHwI0YWZvDT
	MoYFo0l/Xk41y3KcAfwr02NRl8a2PsaWFwT60Eg51UMFroWBQVlWRTnXH0TV72eg3gMj5AYJlt0
	sl84XYo0ccNK9rJpJ95Ing==
X-Received: by 2002:a7b:c410:0:b0:43d:174:2668 with SMTP id 5b1f17b1804b1-43eb0432f65mr5326845e9.0.1743523924938;
        Tue, 01 Apr 2025 09:12:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEk/I3vo1cRXa7Mz4utMMm6kLtNUQbKtvEfiervEB5Xb0Kb0XowzumjTcrRZh98kiO/aEFnGA==
X-Received: by 2002:a7b:c410:0:b0:43d:174:2668 with SMTP id 5b1f17b1804b1-43eb0432f65mr5326525e9.0.1743523924573;
        Tue, 01 Apr 2025 09:12:04 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d82dede21sm203158185e9.4.2025.04.01.09.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:12:02 -0700 (PDT)
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
Subject: [PATCH 20/29] KVM: x86: add planes support for interrupt delivery
Date: Tue,  1 Apr 2025 18:10:57 +0200
Message-ID: <20250401161106.790710-21-pbonzini@redhat.com>
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

Plumb the destination plane into struct kvm_lapic_irq and propagate it
everywhere.  The in-kernel IOAPIC only targets plane 0.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/hyperv.c           |  1 +
 arch/x86/kvm/ioapic.c           |  4 ++--
 arch/x86/kvm/irq_comm.c         | 14 +++++++++++---
 arch/x86/kvm/lapic.c            |  8 ++++----
 arch/x86/kvm/x86.c              |  8 +++++---
 arch/x86/kvm/xen.c              |  1 +
 7 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f832352cf4d3..283d8a4b5b14 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1661,6 +1661,7 @@ struct kvm_lapic_irq {
 	u16 delivery_mode;
 	u16 dest_mode;
 	bool level;
+	u8 plane;
 	u16 trig_mode;
 	u32 shorthand;
 	u32 dest_id;
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a522b467be48..cd1ff31038d2 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -491,6 +491,7 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
 	irq.delivery_mode = APIC_DM_FIXED;
 	irq.vector = vector;
 	irq.level = 1;
+	irq.plane = vcpu->plane;
 
 	ret = kvm_irq_delivery_to_apic(vcpu->kvm, vcpu->arch.apic, &irq, NULL);
 	trace_kvm_hv_synic_set_irq(vcpu->vcpu_id, sint, irq.vector, ret);
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 995eb5054360..c538867afceb 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -402,7 +402,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 				ioapic_service(ioapic, index, false);
 		}
 		if (e->fields.delivery_mode == APIC_DM_FIXED) {
-			struct kvm_lapic_irq irq;
+			struct kvm_lapic_irq irq = { 0 };
 
 			irq.vector = e->fields.vector;
 			irq.delivery_mode = e->fields.delivery_mode << 8;
@@ -442,7 +442,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 {
 	union kvm_ioapic_redirect_entry *entry = &ioapic->redirtbl[irq];
-	struct kvm_lapic_irq irqe;
+	struct kvm_lapic_irq irqe = { 0 };
 	int ret;
 
 	if (entry->fields.mask ||
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8136695f7b96..94f9db50384e 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -48,6 +48,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, struct dest_map *dest_map)
 {
 	int r = -1;
+	struct kvm_plane *plane = kvm->planes[irq->plane];
 	struct kvm_vcpu *vcpu, *lowest = NULL;
 	unsigned long i, dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 	unsigned int dest_vcpus = 0;
@@ -63,7 +64,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 
 	memset(dest_vcpu_bitmap, 0, sizeof(dest_vcpu_bitmap));
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
+	kvm_for_each_plane_vcpu(i, vcpu, plane) {
 		if (!kvm_apic_present(vcpu))
 			continue;
 
@@ -92,7 +93,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		int idx = kvm_vector_to_index(irq->vector, dest_vcpus,
 					dest_vcpu_bitmap, KVM_MAX_VCPUS);
 
-		lowest = kvm_get_vcpu(kvm, idx);
+		lowest = kvm_get_plane_vcpu(plane, idx);
 	}
 
 	if (lowest)
@@ -119,13 +120,20 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 	irq->msi_redir_hint = msg.arch_addr_lo.redirect_hint;
 	irq->level = 1;
 	irq->shorthand = APIC_DEST_NOSHORT;
+	irq->plane = e->msi.plane;
 }
 EXPORT_SYMBOL_GPL(kvm_set_msi_irq);
 
 static inline bool kvm_msi_route_invalid(struct kvm *kvm,
 		struct kvm_kernel_irq_routing_entry *e)
 {
-	return kvm->arch.x2apic_format && (e->msi.address_hi & 0xff);
+	if (kvm->arch.x2apic_format && (e->msi.address_hi & 0xff))
+		return true;
+
+	if (!kvm->planes[e->msi.plane])
+		return true;
+
+	return false;
 }
 
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6ed5f5b4f878..16a0e2387f2c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1223,14 +1223,13 @@ static inline bool kvm_apic_map_get_dest_lapic(struct kvm_plane *plane,
 	}
 
 	*bitmap = (lowest >= 0) ? 1 << lowest : 0;
-
 	return true;
 }
 
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map)
 {
-	struct kvm_plane *plane = kvm->planes[0];
+	struct kvm_plane *plane = kvm->planes[irq->plane];
 	struct kvm_apic_map *map;
 	unsigned long bitmap;
 	struct kvm_lapic **dst = NULL;
@@ -1286,7 +1285,7 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu)
 {
-	struct kvm_plane *plane = kvm->planes[0];
+	struct kvm_plane *plane = kvm->planes[irq->plane];
 	struct kvm_apic_map *map;
 	unsigned long bitmap;
 	struct kvm_lapic **dst = NULL;
@@ -1422,7 +1421,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			      unsigned long *vcpu_bitmap)
 {
-	struct kvm_plane *plane = kvm->planes[0];
+	struct kvm_plane *plane = kvm->planes[irq->plane];
 	struct kvm_lapic **dest_vcpu = NULL;
 	struct kvm_lapic *src = NULL;
 	struct kvm_apic_map *map;
@@ -1544,6 +1543,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 	irq.trig_mode = icr_low & APIC_INT_LEVELTRIG;
 	irq.shorthand = icr_low & APIC_SHORT_MASK;
 	irq.msi_redir_hint = false;
+	irq.plane = apic->vcpu->plane;
 	if (apic_x2apic_mode(apic))
 		irq.dest_id = icr_high;
 	else
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 19e3bb33bf7d..ce8e623052a7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9949,7 +9949,7 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
  *
  * @apicid - apicid of vcpu to be kicked.
  */
-static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
+static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsigned plane_id, int apicid)
 {
 	/*
 	 * All other fields are unused for APIC_DM_REMRD, but may be consumed by
@@ -9960,6 +9960,7 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
 		.dest_mode = APIC_DEST_PHYSICAL,
 		.shorthand = APIC_DEST_NOSHORT,
 		.dest_id = apicid,
+		.plane = plane_id,
 	};
 
 	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
@@ -10092,7 +10093,7 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_UNHALT))
 			break;
 
-		kvm_pv_kick_cpu_op(vcpu->kvm, a1);
+		kvm_pv_kick_cpu_op(vcpu->kvm, vcpu->plane, a1);
 		kvm_sched_yield(vcpu, a1);
 		ret = 0;
 		break;
@@ -13559,7 +13560,8 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 {
 	struct kvm_lapic_irq irq = {
 		.delivery_mode = APIC_DM_FIXED,
-		.vector = vcpu->arch.apf.vec
+		.vector = vcpu->arch.apf.vec,
+		.plane = vcpu->plane,
 	};
 
 	if (work->wakeup_all)
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 7449be30d701..ac9c69f2190b 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -625,6 +625,7 @@ void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
 	irq.shorthand = APIC_DEST_NOSHORT;
 	irq.delivery_mode = APIC_DM_FIXED;
 	irq.level = 1;
+	irq.plane = v->plane;
 
 	kvm_irq_delivery_to_apic(v->kvm, NULL, &irq, NULL);
 }
-- 
2.49.0


