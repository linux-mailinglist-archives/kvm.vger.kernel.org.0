Return-Path: <kvm+bounces-49141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41018AD6199
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB183169A5A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7A526E6E7;
	Wed, 11 Jun 2025 21:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZQBCirEh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42A225FA3B
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677794; cv=none; b=qBE+A373I8D/SQ7cyni9F9zefmXhuUytj+q+i+gMEaJpN1V47544B0dX9tI5jTl6zjviwIpmRWJ4kwhSBy60ncDDLS0qCCSE5fl1UrCmWLTtowxmXvVqKoO86wEMkh6tyO12uf3O/23teMZj/MJ7J3OQ9PqDlaIScDvLiwlgAIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677794; c=relaxed/simple;
	bh=PmbWC/TIlLCQzSKdxm1GVL9bgskn+dbrOnYa6rqBgWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DQ92KE7+mCQTFe+6rvh4I0WSy3hyxZAwSzWyPbnD+jR7AUBW3xjBCfOsxsLpQ/gLed6itrGXjiuNpkiiHG1aZS85ZvrN0OtJaDPTSRbV/ZcGXMXAGabtgl1rTHZj7Na6Vpvi/IPwbA0ZVjOfFwgdqhJ8npe2ZTPvqiQocJ+U4/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZQBCirEh; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-745e89b0c32so504645b3a.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677792; x=1750282592; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vsgWR+xgtVyVwImlz4N8xQ42xaa1qcLxZh31sYTHKkU=;
        b=ZQBCirEhbwb6PaKtnEB1N0kQqbCi1FS86iNR3pahqknFmH0WGb7LgxMiL3tpFQdqzm
         kyoUk+oI0Imt5fCE1xCT0J+Mij4ug/kXcAeeyJs8C0N1KQwDmwzMjjQ6/6Oh/1sNKPjY
         IXttyVEaGRH5NwxDZvnGocs5URXuyF2GUehvkxd3wN29iYb8XQlnl3GpMNoP0rg8kjiP
         n6oZEzilzWZAoVtpJknFgbONei13EJTs8S7a/Jtr2CIbHKZBw1zL9q4ScoLUIHbtAg/x
         ovovxe1UULct7Ohks4z0hG+gjTszopEUlDItgrUXhTwv1v74n7/x4F47MQGzlje3wVTH
         BkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677792; x=1750282592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vsgWR+xgtVyVwImlz4N8xQ42xaa1qcLxZh31sYTHKkU=;
        b=wbA/8AAbhVkT4JNq9dQ0HPbHnMn6fq875MmFqKoGszVXXmxUlgbuRcVm+MLba+sEUS
         j8qE16kgT2K9C7q/9bvtcjGtSfDRZhDX966wzV/ok9WFkLOXX8SmiWjlzKPHFtWCDuwm
         n6hpv6uQGaOF820fTJSw/ftoo2T5LvGScwwJO/f5L2k8td+rHIIXqsz61Qb8LwabE5U0
         tUM2JnSq2m1IGqP3qTEISytjGYZWlIvbG14sjE0AEBX2ZFRq6+KL06K2lusUCDtNdVVu
         ODDB02seVa3m+d+nIdLLiETJes/Eonv6vkKqIBabLqqYE+I482jJ6rk11jxb2F9sSWNq
         AGPQ==
X-Gm-Message-State: AOJu0YzZvDHIGDkJau4xU/b1kQc9ZZVdgNpRIxjHAQTxKARctFORskX7
	2aI3b7MvcLcTS2mRCUmbRIm80kfMzlVlbtc9bcCLzPhzkNeiqqfVkdhn98/I9lRTqEgHeoTnRBt
	2/dPl7Q==
X-Google-Smtp-Source: AGHT+IErRFT1YxlszZ8+Hn/lk6gYaxEVplONKqwV+JCUeXaN9V2hIH4Qm61XoRwm2x2oWrmpm9siqH0ZiFQ=
X-Received: from pfax8.prod.google.com ([2002:aa7:9188:0:b0:746:fd4c:1fd0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3e29:b0:748:2ff7:5e22
 with SMTP id d2e1a72fcca58-7487c239e74mr1359444b3a.10.1749677792072; Wed, 11
 Jun 2025 14:36:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:57 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-19-seanjc@google.com>
Subject: [PATCH v2 18/18] KVM: x86: Fold irq_comm.c into irq.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop irq_comm.c, a.k.a. common IRQ APIs, as there has been no non-x86 user
since commit 003f7de62589 ("KVM: ia64: remove") (at the time, irq_comm.c
lived in virt/kvm, not arch/x86/kvm).

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Makefile   |   6 +-
 arch/x86/kvm/irq.c      | 304 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/irq_comm.c | 325 ----------------------------------------
 3 files changed, 305 insertions(+), 330 deletions(-)
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
index 4c219e9f52b0..a0b1499baf6e 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -12,9 +12,10 @@
 #include <linux/export.h>
 #include <linux/kvm_host.h>
 
+#include "hyperv.h"
 #include "ioapic.h"
 #include "irq.h"
-#include "i8254.h"
+#include "trace.h"
 #include "x86.h"
 #include "xen.h"
 
@@ -193,6 +194,307 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
 	return irqchip_in_kernel(kvm);
 }
 
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
+		return kvm_hv_synic_set_irq(e, kvm, irq_source_id, level,
+					    line_status);
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
+		e->set = kvm_hv_synic_set_irq;
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
+
 #ifdef CONFIG_KVM_IOAPIC
 #define IOAPIC_ROUTING_ENTRY(irq) \
 	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
deleted file mode 100644
index 76d1c85a1011..000000000000
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
-		return kvm_hv_synic_set_irq(e, kvm, irq_source_id, level,
-					    line_status);
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
-		e->set = kvm_hv_synic_set_irq;
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
2.50.0.rc1.591.g9c95f17f64-goog


