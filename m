Return-Path: <kvm+bounces-47050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD45CABCB7D
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:32:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6391C8C528C
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8EB9226D1F;
	Mon, 19 May 2025 23:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W0kDoOx7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE8D225A2D
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697322; cv=none; b=GzDEjiKT0PiX9qFNZxahN3/dEc8rHipFVdOBfjuBFtngZCSas+YP7Ajx/A9MLM0t/gw2eX7+OuFsWxS+lMVFBmPZHW7Y3Cyag9Q5UCl+7aWzbq4Rt/ib+Z/1+APPzdX+13IYF6ONsGLLQVntxnnBhgsPC6winEciql6nP4sGA1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697322; c=relaxed/simple;
	bh=2h+R3oCjDJHijaqD59kpzjyUlIgPd4MTEsYrNuKVieg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KOvcauReM48Y/h6UDKQqrSxsuX1IcrObXQxTBMA1b9N3BV4gzfipLZ/XD+gbkrL0Bsa4nkhXNxcVxZoYHWC5s4GV8TysFkU6Iftdeu13IUHxBjvfeGmC++4qsEP1uC6vr8IJ0e4SFZmoMOznfj+Xu+yh0j11y90Y3ZdQOKb2RwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W0kDoOx7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e9e8d3e85so3440856a91.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697319; x=1748302119; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GYplnj3zQPro5+YI4R9fT1vffU3AD1XGCuuLElZqFbg=;
        b=W0kDoOx7AhzCdNd+ZSmlzggf5Q/iSt9cUJ9y8EvM3vvJq3fzO/84Tt78lBQMkBWzYn
         Obu9e6IKKEnEC/O1aoQ1WpSl13vpyhcEqHN5fX42tfi1uY9uqE4nIwbWyliVpU2Mrmpm
         WmDCwz6cCsY3IPjQ3uYXaAa0py6RSg2hPJU0wrf/yZCRF8Y7j4lOwd800GaHMjf8BOha
         OMgXnutivfkrD3ba0CaRKvZqsBThO56XgjsRlc1/YpqCo0zyI21xaLc8PEr5d+zl/LCs
         25Xj2Im2MsOrnEIoXlDHyjIEsPMu/EeYucDbdg9bY8Wc0ya5IzHhem8STjWIjDpKldEY
         3l6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697319; x=1748302119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GYplnj3zQPro5+YI4R9fT1vffU3AD1XGCuuLElZqFbg=;
        b=T31pvvSGO3T1N87LAWpCTTEkF5iXduE4d/ry70vhBnyy7D6qBLz6GJwqBTUnnwJhx3
         6Hz2ONsEFhnalcvNZeydoiOntXGtlqJ3Of6HUFmAWGFzGwlZI2ot83xOD9vi9F+3ojhK
         lIcrX68Si80z+HOm1lSojRHzCr7fdJEcaYWsBYIV+5/VTyEvIYgZAqFpwMGBf2w1pA6W
         uAwhVAPo2ltK4BnBWAq0zIp2dX08tdZJAYRXSS5L0YHOBJl2IN+edoYW9fwlgmjFByOj
         50I5QZsEQH5O7arS7pXurGxAc/7HVCslmTXd5ygkhSSfYMPDZ1wLhryvxiqTdWsw4BJ+
         KJCg==
X-Gm-Message-State: AOJu0Yw4+kQA+jtMk0ReaVgwb+ii2IMSywJ6bh7VX5/yFjaEVNNfGDq3
	yef6JWFRXsbgXJwC0koWn86ikBqUbAHxtjUPSpdPQKZpVf/Ax5p7So63BgiFJQI9WKHCul97Aka
	eaCfVOw==
X-Google-Smtp-Source: AGHT+IGWa46bD0SKjXEZmQKHNSJP4I6FRXvqvQ4YBRiR5zoAR4K89jbzjqICZAPpFfqaZdmJiiLtMykGVOw=
X-Received: from pjbsw12.prod.google.com ([2002:a17:90b:2c8c:b0:2ea:5084:5297])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f4c:b0:2ee:5958:828
 with SMTP id 98e67ed59e1d1-30e7d522155mr25648574a91.9.1747697319047; Mon, 19
 May 2025 16:28:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:28:08 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-16-seanjc@google.com>
Subject: [PATCH 15/15] KVM: x86: Fold irq_comm.c into irq.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop irq_comm.c, a.k.a. common IRQ APIs, as there has been no non-x86 user
since commit 003f7de62589 ("KVM: ia64: remove") (at the time, irq_comm.c
lived in virt/kvm, not arch/x86/kvm).

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Makefile   |   6 +-
 arch/x86/kvm/irq.c      | 305 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/irq_comm.c | 325 ----------------------------------------
 3 files changed, 306 insertions(+), 330 deletions(-)
 delete mode 100644 arch/x86/kvm/irq_comm.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 92c737257789..c4b8950c7abe 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -5,10 +5,8 @@ ccflags-$(CONFIG_KVM_WERROR) += -Werror
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-kvm-y			+= x86.o emulate.o irq.o lapic.o \
-			   irq_comm.o cpuid.o pmu.o mtrr.o \
-			   debugfs.o mmu/mmu.o mmu/page_track.o \
-			   mmu/spte.o
+kvm-y			+= x86.o emulate.o irq.o lapic.o cpuid.o pmu.o mtrr.o \
+			   debugfs.o mmu/mmu.o mmu/page_track.o mmu/spte.o
 
 kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_IOAPIC) += i8259.o i8254.o ioapic.o
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index a416ccddde5f..314a93599942 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -12,8 +12,10 @@
 #include <linux/export.h>
 #include <linux/kvm_host.h>
 
+#include "hyperv.h"
+#include "ioapic.h"
 #include "irq.h"
-#include "i8254.h"
+#include "trace.h"
 #include "x86.h"
 #include "xen.h"
 
@@ -191,3 +193,304 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
 {
 	return irqchip_in_kernel(kvm);
 }
+
+int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
+			     struct kvm_lapic_irq *irq, struct dest_map *dest_map)
+{
+	int r = -1;
+	struct kvm_vcpu *vcpu, *lowest = NULL;
+	unsigned long i, dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
+	unsigned int dest_vcpus = 0;
+
+	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
+		return r;
+
+	if (irq->dest_mode == APIC_DEST_PHYSICAL &&
+	    irq->dest_id == 0xff && kvm_lowest_prio_delivery(irq)) {
+		pr_info("apic: phys broadcast and lowest prio\n");
+		irq->delivery_mode = APIC_DM_FIXED;
+	}
+
+	memset(dest_vcpu_bitmap, 0, sizeof(dest_vcpu_bitmap));
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_apic_present(vcpu))
+			continue;
+
+		if (!kvm_apic_match_dest(vcpu, src, irq->shorthand,
+					irq->dest_id, irq->dest_mode))
+			continue;
+
+		if (!kvm_lowest_prio_delivery(irq)) {
+			if (r < 0)
+				r = 0;
+			r += kvm_apic_set_irq(vcpu, irq, dest_map);
+		} else if (kvm_apic_sw_enabled(vcpu->arch.apic)) {
+			if (!kvm_vector_hashing_enabled()) {
+				if (!lowest)
+					lowest = vcpu;
+				else if (kvm_apic_compare_prio(vcpu, lowest) < 0)
+					lowest = vcpu;
+			} else {
+				__set_bit(i, dest_vcpu_bitmap);
+				dest_vcpus++;
+			}
+		}
+	}
+
+	if (dest_vcpus != 0) {
+		int idx = kvm_vector_to_index(irq->vector, dest_vcpus,
+					dest_vcpu_bitmap, KVM_MAX_VCPUS);
+
+		lowest = kvm_get_vcpu(kvm, idx);
+	}
+
+	if (lowest)
+		r = kvm_apic_set_irq(lowest, irq, dest_map);
+
+	return r;
+}
+
+void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
+		     struct kvm_lapic_irq *irq)
+{
+	struct msi_msg msg = { .address_lo = e->msi.address_lo,
+			       .address_hi = e->msi.address_hi,
+			       .data = e->msi.data };
+
+	trace_kvm_msi_set_irq(msg.address_lo | (kvm->arch.x2apic_format ?
+			      (u64)msg.address_hi << 32 : 0), msg.data);
+
+	irq->dest_id = x86_msi_msg_get_destid(&msg, kvm->arch.x2apic_format);
+	irq->vector = msg.arch_data.vector;
+	irq->dest_mode = kvm_lapic_irq_dest_mode(msg.arch_addr_lo.dest_mode_logical);
+	irq->trig_mode = msg.arch_data.is_level;
+	irq->delivery_mode = msg.arch_data.delivery_mode << 8;
+	irq->msi_redir_hint = msg.arch_addr_lo.redirect_hint;
+	irq->level = 1;
+	irq->shorthand = APIC_DEST_NOSHORT;
+}
+EXPORT_SYMBOL_GPL(kvm_set_msi_irq);
+
+static inline bool kvm_msi_route_invalid(struct kvm *kvm,
+		struct kvm_kernel_irq_routing_entry *e)
+{
+	return kvm->arch.x2apic_format && (e->msi.address_hi & 0xff);
+}
+
+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		struct kvm *kvm, int irq_source_id, int level, bool line_status)
+{
+	struct kvm_lapic_irq irq;
+
+	if (kvm_msi_route_invalid(kvm, e))
+		return -EINVAL;
+
+	if (!level)
+		return -1;
+
+	kvm_set_msi_irq(kvm, e, &irq);
+
+	return kvm_irq_delivery_to_apic(kvm, NULL, &irq, NULL);
+}
+
+int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
+			      struct kvm *kvm, int irq_source_id, int level,
+			      bool line_status)
+{
+	struct kvm_lapic_irq irq;
+	int r;
+
+	switch (e->type) {
+#ifdef CONFIG_KVM_HYPERV
+	case KVM_IRQ_ROUTING_HV_SINT:
+		return kvm_hv_set_sint(e, kvm, irq_source_id, level,
+				       line_status);
+#endif
+
+	case KVM_IRQ_ROUTING_MSI:
+		if (kvm_msi_route_invalid(kvm, e))
+			return -EINVAL;
+
+		kvm_set_msi_irq(kvm, e, &irq);
+
+		if (kvm_irq_delivery_to_apic_fast(kvm, NULL, &irq, &r, NULL))
+			return r;
+		break;
+
+#ifdef CONFIG_KVM_XEN
+	case KVM_IRQ_ROUTING_XEN_EVTCHN:
+		if (!level)
+			return -1;
+
+		return kvm_xen_set_evtchn_fast(&e->xen_evtchn, kvm);
+#endif
+	default:
+		break;
+	}
+
+	return -EWOULDBLOCK;
+}
+
+bool kvm_arch_can_set_irq_routing(struct kvm *kvm)
+{
+	return irqchip_in_kernel(kvm);
+}
+
+int kvm_set_routing_entry(struct kvm *kvm,
+			  struct kvm_kernel_irq_routing_entry *e,
+			  const struct kvm_irq_routing_entry *ue)
+{
+	/* We can't check irqchip_in_kernel() here as some callers are
+	 * currently initializing the irqchip. Other callers should therefore
+	 * check kvm_arch_can_set_irq_routing() before calling this function.
+	 */
+	switch (ue->type) {
+#ifdef CONFIG_KVM_IOAPIC
+	case KVM_IRQ_ROUTING_IRQCHIP:
+		if (irqchip_split(kvm))
+			return -EINVAL;
+		e->irqchip.pin = ue->u.irqchip.pin;
+		switch (ue->u.irqchip.irqchip) {
+		case KVM_IRQCHIP_PIC_SLAVE:
+			e->irqchip.pin += PIC_NUM_PINS / 2;
+			fallthrough;
+		case KVM_IRQCHIP_PIC_MASTER:
+			if (ue->u.irqchip.pin >= PIC_NUM_PINS / 2)
+				return -EINVAL;
+			e->set = kvm_pic_set_irq;
+			break;
+		case KVM_IRQCHIP_IOAPIC:
+			if (ue->u.irqchip.pin >= KVM_IOAPIC_NUM_PINS)
+				return -EINVAL;
+			e->set = kvm_ioapic_set_irq;
+			break;
+		default:
+			return -EINVAL;
+		}
+		e->irqchip.irqchip = ue->u.irqchip.irqchip;
+		break;
+#endif
+	case KVM_IRQ_ROUTING_MSI:
+		e->set = kvm_set_msi;
+		e->msi.address_lo = ue->u.msi.address_lo;
+		e->msi.address_hi = ue->u.msi.address_hi;
+		e->msi.data = ue->u.msi.data;
+
+		if (kvm_msi_route_invalid(kvm, e))
+			return -EINVAL;
+		break;
+#ifdef CONFIG_KVM_HYPERV
+	case KVM_IRQ_ROUTING_HV_SINT:
+		e->set = kvm_hv_set_sint;
+		e->hv_sint.vcpu = ue->u.hv_sint.vcpu;
+		e->hv_sint.sint = ue->u.hv_sint.sint;
+		break;
+#endif
+#ifdef CONFIG_KVM_XEN
+	case KVM_IRQ_ROUTING_XEN_EVTCHN:
+		return kvm_xen_setup_evtchn(kvm, e, ue);
+#endif
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
+			     struct kvm_vcpu **dest_vcpu)
+{
+	int r = 0;
+	unsigned long i;
+	struct kvm_vcpu *vcpu;
+
+	if (kvm_intr_is_single_vcpu_fast(kvm, irq, dest_vcpu))
+		return true;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_apic_present(vcpu))
+			continue;
+
+		if (!kvm_apic_match_dest(vcpu, NULL, irq->shorthand,
+					irq->dest_id, irq->dest_mode))
+			continue;
+
+		if (++r == 2)
+			return false;
+
+		*dest_vcpu = vcpu;
+	}
+
+	return r == 1;
+}
+EXPORT_SYMBOL_GPL(kvm_intr_is_single_vcpu);
+
+void kvm_scan_ioapic_irq(struct kvm_vcpu *vcpu, u32 dest_id, u16 dest_mode,
+			 u8 vector, unsigned long *ioapic_handled_vectors)
+{
+	/*
+	 * Intercept EOI if the vCPU is the target of the new IRQ routing, or
+	 * the vCPU has a pending IRQ from the old routing, i.e. if the vCPU
+	 * may receive a level-triggered IRQ in the future, or already received
+	 * level-triggered IRQ.  The EOI needs to be intercepted and forwarded
+	 * to I/O APIC emulation so that the IRQ can be de-asserted.
+	 */
+	if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT, dest_id, dest_mode)) {
+		__set_bit(vector, ioapic_handled_vectors);
+	} else if (kvm_apic_pending_eoi(vcpu, vector)) {
+		__set_bit(vector, ioapic_handled_vectors);
+
+		/*
+		 * Track the highest pending EOI for which the vCPU is NOT the
+		 * target in the new routing.  Only the EOI for the IRQ that is
+		 * in-flight (for the old routing) needs to be intercepted, any
+		 * future IRQs that arrive on this vCPU will be coincidental to
+		 * the level-triggered routing and don't need to be intercepted.
+		 */
+		if ((int)vector > vcpu->arch.highest_stale_pending_ioapic_eoi)
+			vcpu->arch.highest_stale_pending_ioapic_eoi = vector;
+	}
+}
+
+void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
+			    ulong *ioapic_handled_vectors)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_kernel_irq_routing_entry *entry;
+	struct kvm_irq_routing_table *table;
+	u32 i, nr_ioapic_pins;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->irq_srcu);
+	table = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
+	nr_ioapic_pins = min_t(u32, table->nr_rt_entries,
+			       kvm->arch.nr_reserved_ioapic_pins);
+	for (i = 0; i < nr_ioapic_pins; ++i) {
+		hlist_for_each_entry(entry, &table->map[i], link) {
+			struct kvm_lapic_irq irq;
+
+			if (entry->type != KVM_IRQ_ROUTING_MSI)
+				continue;
+
+			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
+
+			if (!irq.trig_mode)
+				continue;
+
+			kvm_scan_ioapic_irq(vcpu, irq.dest_id, irq.dest_mode,
+					    irq.vector, ioapic_handled_vectors);
+		}
+	}
+	srcu_read_unlock(&kvm->irq_srcu, idx);
+}
+
+void kvm_arch_irq_routing_update(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_HYPERV
+	kvm_hv_irq_routing_update(kvm);
+#endif
+
+	if (irqchip_split(kvm))
+		kvm_make_scan_ioapic_request(kvm);
+}
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
deleted file mode 100644
index fc0fa8155882..000000000000
--- a/arch/x86/kvm/irq_comm.c
+++ /dev/null
@@ -1,325 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * irq_comm.c: Common API for in kernel interrupt controller
- * Copyright (c) 2007, Intel Corporation.
- *
- * Authors:
- *   Yaozu (Eddie) Dong <Eddie.dong@intel.com>
- *
- * Copyright 2010 Red Hat, Inc. and/or its affiliates.
- */
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/kvm_host.h>
-#include <linux/slab.h>
-#include <linux/export.h>
-#include <linux/rculist.h>
-
-#include "hyperv.h"
-#include "ioapic.h"
-#include "irq.h"
-#include "lapic.h"
-#include "trace.h"
-#include "x86.h"
-#include "xen.h"
-
-int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
-		struct kvm_lapic_irq *irq, struct dest_map *dest_map)
-{
-	int r = -1;
-	struct kvm_vcpu *vcpu, *lowest = NULL;
-	unsigned long i, dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
-	unsigned int dest_vcpus = 0;
-
-	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
-		return r;
-
-	if (irq->dest_mode == APIC_DEST_PHYSICAL &&
-	    irq->dest_id == 0xff && kvm_lowest_prio_delivery(irq)) {
-		pr_info("apic: phys broadcast and lowest prio\n");
-		irq->delivery_mode = APIC_DM_FIXED;
-	}
-
-	memset(dest_vcpu_bitmap, 0, sizeof(dest_vcpu_bitmap));
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (!kvm_apic_present(vcpu))
-			continue;
-
-		if (!kvm_apic_match_dest(vcpu, src, irq->shorthand,
-					irq->dest_id, irq->dest_mode))
-			continue;
-
-		if (!kvm_lowest_prio_delivery(irq)) {
-			if (r < 0)
-				r = 0;
-			r += kvm_apic_set_irq(vcpu, irq, dest_map);
-		} else if (kvm_apic_sw_enabled(vcpu->arch.apic)) {
-			if (!kvm_vector_hashing_enabled()) {
-				if (!lowest)
-					lowest = vcpu;
-				else if (kvm_apic_compare_prio(vcpu, lowest) < 0)
-					lowest = vcpu;
-			} else {
-				__set_bit(i, dest_vcpu_bitmap);
-				dest_vcpus++;
-			}
-		}
-	}
-
-	if (dest_vcpus != 0) {
-		int idx = kvm_vector_to_index(irq->vector, dest_vcpus,
-					dest_vcpu_bitmap, KVM_MAX_VCPUS);
-
-		lowest = kvm_get_vcpu(kvm, idx);
-	}
-
-	if (lowest)
-		r = kvm_apic_set_irq(lowest, irq, dest_map);
-
-	return r;
-}
-
-void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
-		     struct kvm_lapic_irq *irq)
-{
-	struct msi_msg msg = { .address_lo = e->msi.address_lo,
-			       .address_hi = e->msi.address_hi,
-			       .data = e->msi.data };
-
-	trace_kvm_msi_set_irq(msg.address_lo | (kvm->arch.x2apic_format ?
-			      (u64)msg.address_hi << 32 : 0), msg.data);
-
-	irq->dest_id = x86_msi_msg_get_destid(&msg, kvm->arch.x2apic_format);
-	irq->vector = msg.arch_data.vector;
-	irq->dest_mode = kvm_lapic_irq_dest_mode(msg.arch_addr_lo.dest_mode_logical);
-	irq->trig_mode = msg.arch_data.is_level;
-	irq->delivery_mode = msg.arch_data.delivery_mode << 8;
-	irq->msi_redir_hint = msg.arch_addr_lo.redirect_hint;
-	irq->level = 1;
-	irq->shorthand = APIC_DEST_NOSHORT;
-}
-EXPORT_SYMBOL_GPL(kvm_set_msi_irq);
-
-static inline bool kvm_msi_route_invalid(struct kvm *kvm,
-		struct kvm_kernel_irq_routing_entry *e)
-{
-	return kvm->arch.x2apic_format && (e->msi.address_hi & 0xff);
-}
-
-int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
-		struct kvm *kvm, int irq_source_id, int level, bool line_status)
-{
-	struct kvm_lapic_irq irq;
-
-	if (kvm_msi_route_invalid(kvm, e))
-		return -EINVAL;
-
-	if (!level)
-		return -1;
-
-	kvm_set_msi_irq(kvm, e, &irq);
-
-	return kvm_irq_delivery_to_apic(kvm, NULL, &irq, NULL);
-}
-
-int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
-			      struct kvm *kvm, int irq_source_id, int level,
-			      bool line_status)
-{
-	struct kvm_lapic_irq irq;
-	int r;
-
-	switch (e->type) {
-#ifdef CONFIG_KVM_HYPERV
-	case KVM_IRQ_ROUTING_HV_SINT:
-		return kvm_hv_set_sint(e, kvm, irq_source_id, level,
-				       line_status);
-#endif
-
-	case KVM_IRQ_ROUTING_MSI:
-		if (kvm_msi_route_invalid(kvm, e))
-			return -EINVAL;
-
-		kvm_set_msi_irq(kvm, e, &irq);
-
-		if (kvm_irq_delivery_to_apic_fast(kvm, NULL, &irq, &r, NULL))
-			return r;
-		break;
-
-#ifdef CONFIG_KVM_XEN
-	case KVM_IRQ_ROUTING_XEN_EVTCHN:
-		if (!level)
-			return -1;
-
-		return kvm_xen_set_evtchn_fast(&e->xen_evtchn, kvm);
-#endif
-	default:
-		break;
-	}
-
-	return -EWOULDBLOCK;
-}
-
-bool kvm_arch_can_set_irq_routing(struct kvm *kvm)
-{
-	return irqchip_in_kernel(kvm);
-}
-
-int kvm_set_routing_entry(struct kvm *kvm,
-			  struct kvm_kernel_irq_routing_entry *e,
-			  const struct kvm_irq_routing_entry *ue)
-{
-	/* We can't check irqchip_in_kernel() here as some callers are
-	 * currently initializing the irqchip. Other callers should therefore
-	 * check kvm_arch_can_set_irq_routing() before calling this function.
-	 */
-	switch (ue->type) {
-#ifdef CONFIG_KVM_IOAPIC
-	case KVM_IRQ_ROUTING_IRQCHIP:
-		if (irqchip_split(kvm))
-			return -EINVAL;
-		e->irqchip.pin = ue->u.irqchip.pin;
-		switch (ue->u.irqchip.irqchip) {
-		case KVM_IRQCHIP_PIC_SLAVE:
-			e->irqchip.pin += PIC_NUM_PINS / 2;
-			fallthrough;
-		case KVM_IRQCHIP_PIC_MASTER:
-			if (ue->u.irqchip.pin >= PIC_NUM_PINS / 2)
-				return -EINVAL;
-			e->set = kvm_pic_set_irq;
-			break;
-		case KVM_IRQCHIP_IOAPIC:
-			if (ue->u.irqchip.pin >= KVM_IOAPIC_NUM_PINS)
-				return -EINVAL;
-			e->set = kvm_ioapic_set_irq;
-			break;
-		default:
-			return -EINVAL;
-		}
-		e->irqchip.irqchip = ue->u.irqchip.irqchip;
-		break;
-#endif
-	case KVM_IRQ_ROUTING_MSI:
-		e->set = kvm_set_msi;
-		e->msi.address_lo = ue->u.msi.address_lo;
-		e->msi.address_hi = ue->u.msi.address_hi;
-		e->msi.data = ue->u.msi.data;
-
-		if (kvm_msi_route_invalid(kvm, e))
-			return -EINVAL;
-		break;
-#ifdef CONFIG_KVM_HYPERV
-	case KVM_IRQ_ROUTING_HV_SINT:
-		e->set = kvm_hv_set_sint;
-		e->hv_sint.vcpu = ue->u.hv_sint.vcpu;
-		e->hv_sint.sint = ue->u.hv_sint.sint;
-		break;
-#endif
-#ifdef CONFIG_KVM_XEN
-	case KVM_IRQ_ROUTING_XEN_EVTCHN:
-		return kvm_xen_setup_evtchn(kvm, e, ue);
-#endif
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
-			     struct kvm_vcpu **dest_vcpu)
-{
-	int r = 0;
-	unsigned long i;
-	struct kvm_vcpu *vcpu;
-
-	if (kvm_intr_is_single_vcpu_fast(kvm, irq, dest_vcpu))
-		return true;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (!kvm_apic_present(vcpu))
-			continue;
-
-		if (!kvm_apic_match_dest(vcpu, NULL, irq->shorthand,
-					irq->dest_id, irq->dest_mode))
-			continue;
-
-		if (++r == 2)
-			return false;
-
-		*dest_vcpu = vcpu;
-	}
-
-	return r == 1;
-}
-EXPORT_SYMBOL_GPL(kvm_intr_is_single_vcpu);
-
-void kvm_scan_ioapic_irq(struct kvm_vcpu *vcpu, u32 dest_id, u16 dest_mode,
-			 u8 vector, unsigned long *ioapic_handled_vectors)
-{
-	/*
-	 * Intercept EOI if the vCPU is the target of the new IRQ routing, or
-	 * the vCPU has a pending IRQ from the old routing, i.e. if the vCPU
-	 * may receive a level-triggered IRQ in the future, or already received
-	 * level-triggered IRQ.  The EOI needs to be intercepted and forwarded
-	 * to I/O APIC emulation so that the IRQ can be de-asserted.
-	 */
-	if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT, dest_id, dest_mode)) {
-		__set_bit(vector, ioapic_handled_vectors);
-	} else if (kvm_apic_pending_eoi(vcpu, vector)) {
-		__set_bit(vector, ioapic_handled_vectors);
-
-		/*
-		 * Track the highest pending EOI for which the vCPU is NOT the
-		 * target in the new routing.  Only the EOI for the IRQ that is
-		 * in-flight (for the old routing) needs to be intercepted, any
-		 * future IRQs that arrive on this vCPU will be coincidental to
-		 * the level-triggered routing and don't need to be intercepted.
-		 */
-		if ((int)vector > vcpu->arch.highest_stale_pending_ioapic_eoi)
-			vcpu->arch.highest_stale_pending_ioapic_eoi = vector;
-	}
-}
-
-void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
-			    ulong *ioapic_handled_vectors)
-{
-	struct kvm *kvm = vcpu->kvm;
-	struct kvm_kernel_irq_routing_entry *entry;
-	struct kvm_irq_routing_table *table;
-	u32 i, nr_ioapic_pins;
-	int idx;
-
-	idx = srcu_read_lock(&kvm->irq_srcu);
-	table = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
-	nr_ioapic_pins = min_t(u32, table->nr_rt_entries,
-			       kvm->arch.nr_reserved_ioapic_pins);
-	for (i = 0; i < nr_ioapic_pins; ++i) {
-		hlist_for_each_entry(entry, &table->map[i], link) {
-			struct kvm_lapic_irq irq;
-
-			if (entry->type != KVM_IRQ_ROUTING_MSI)
-				continue;
-
-			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
-
-			if (!irq.trig_mode)
-				continue;
-
-			kvm_scan_ioapic_irq(vcpu, irq.dest_id, irq.dest_mode,
-					    irq.vector, ioapic_handled_vectors);
-		}
-	}
-	srcu_read_unlock(&kvm->irq_srcu, idx);
-}
-
-void kvm_arch_irq_routing_update(struct kvm *kvm)
-{
-#ifdef CONFIG_KVM_HYPERV
-	kvm_hv_irq_routing_update(kvm);
-#endif
-
-	if (irqchip_split(kvm))
-		kvm_make_scan_ioapic_request(kvm);
-}
-- 
2.49.0.1101.gccaa498523-goog


