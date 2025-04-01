Return-Path: <kvm+bounces-42352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA0A3A7800C
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDCFE3AFF6B
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2D720E339;
	Tue,  1 Apr 2025 16:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DyNGMZ4f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF25221727
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523924; cv=none; b=g2jqdu9EV+M8ZsJnIDxKW9btYxylfmSe+clrpILzJOgkKpRLAA2auFvZaGmQZr2frWuduYD/bvnCoKO73UMmFEGYG/PfOpfOYmtSd02MQxtAWrolvxv0Z1J2H0ndTMgPsg/6MkEKy7lFwXV/D9z7vRrnEI/T7L3iX0QFek9GJzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523924; c=relaxed/simple;
	bh=ZS7aDIfTrGTsc3CaJTz/rmizqT3vdz4Mep7cX4xxC20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbo6Bhtn7BK9jVoYnzFd57guzghOfROHCGbTyf8PPukzRuHHJ1E1zK6e9UKvE2O29eOFFPKtB4ZzThU6luryb+QdkDXtVbWN1ixh/yu6WQLFTFg4nTID0YyHRJDrmH6bvMr98i2j36tIbo60k3WUmt2m2FdY2SohuQZN4mQ8IbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DyNGMZ4f; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MGWdj9YvBEqpmgwNvC3/3vvpLMl37emPFU+fvsJE+7I=;
	b=DyNGMZ4fdEhQ2apnH5R2D3NvmpsC/Gu0weLAuDQSRf8Hnia1XcMav4D2D80y3+JnfFa6kY
	Ow4LJGJErAybIbsd/oI4mOlRGjbfa4vxiW5AFzIjTJCisIuTVx864OFQ/Zffnc9Z/xcnls
	IxXwEO69bTknQ3p+6Vu5XuGMvPKZmi0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-1X-I1EchPmGsq8ZOnSC7Zw-1; Tue, 01 Apr 2025 12:12:00 -0400
X-MC-Unique: 1X-I1EchPmGsq8ZOnSC7Zw-1
X-Mimecast-MFC-AGG-ID: 1X-I1EchPmGsq8ZOnSC7Zw_1743523919
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-391345e3aa3so3286165f8f.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523919; x=1744128719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MGWdj9YvBEqpmgwNvC3/3vvpLMl37emPFU+fvsJE+7I=;
        b=KFcF7vHLTzpfBHQt33Jb9uN7MeX8+9fGVQ7hbll+xAk7XtOIRO4PQOCgceeHXaHgNe
         0gA60nQge6DB1P9OfozniK9GutQPP0AOQIqAxNqU8tZTkQkQGuwuBkg7VL/arHDQnAfs
         wmLTiZHO+rmGzG6mrThjfo4t/6voF3ICu/qi1fzuVng5gMWxCcO2hk7qqfQMiuS8IJPe
         bUWSGtc5LjGNmvFeDUJvqkclkJ7jbwSO9n4elQ31sI0skg/NoYMygTMI3jWZuxP2VUwd
         NI/v2seXE+RIbwB7fjvKleYsove7J2LZeD4DjG5VWLKQCWMboHOpN3q7J+gWBINrxV3+
         eU1A==
X-Forwarded-Encrypted: i=1; AJvYcCXWtAJ5VLD41VI0yHds/QamDJ4eXESX2Fv9Pcz0Vee8P8ubRALAndB0/AJ/Gj40aOIY3SE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6trh/hfIriXADpQvHcfjoXfR+VLrGp+JE9wUt5q6Q0D6Ajl90
	MhtummEb1PFjnhfx/OALHaWJsO6KGUQpUHIV0BdlrDhmBzgtrBqMTdKUrz5RaKDLVPRl9PBMW+w
	jTUI7NRpaqdcjxaJc2oofpIaUADEwSYcUb7Nsu4UC06PVbUTtOw==
X-Gm-Gg: ASbGncvf3SgIcwU/sdl0yUA/llsys/FJUHPqv6T5EGCGtADhsZgItS4kDpeJHk/RuEH
	LARfj0zIYOAha2fR4A0opPkqYVFmc7kJtosnCNSCwIUQ6byo56yu8G4O5R80LMRFeO2DaR8W+ir
	uXOK918mtvSdwPkKtEF38HMAQuyUf07GDL3u/UkeDyVrXT5FG9KBgqhoenPf8Sr3KEu8HmQpoI+
	4EpHGJdVc6BPuItkLt509rsPQsLoH4h1xdB/tBTqmqtXLFa08r38bE9QT1TWO16+U6lz04xm6Oy
	/ZckfMy0+8b9ZBAUQ7bjUg==
X-Received: by 2002:a05:6000:2508:b0:39c:2688:4ebf with SMTP id ffacd0b85a97d-39c26884ef7mr2250154f8f.6.1743523918613;
        Tue, 01 Apr 2025 09:11:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHej+s4j6aGPDin98dlsYk56EQfZoCit5BuzqKpA6tBi49RGgt4j5M4CiOy46C9AQy9PMLW9Q==
X-Received: by 2002:a05:6000:2508:b0:39c:2688:4ebf with SMTP id ffacd0b85a97d-39c26884ef7mr2250116f8f.6.1743523918194;
        Tue, 01 Apr 2025 09:11:58 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0ddeecc9sm13258499f8f.83.2025.04.01.09.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:57 -0700 (PDT)
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
Subject: [PATCH 18/29] KVM: x86: track APICv inhibits per plane
Date: Tue,  1 Apr 2025 18:10:55 +0200
Message-ID: <20250401161106.790710-19-pbonzini@redhat.com>
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

As a first step towards per-plane APIC maps, track APICv inhibits per
plane.  Most of the inhibits are set or cleared when building the map,
and the virtual machine as a whole will have the OR of the inhibits
of the individual plane.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 21 +++++----
 arch/x86/kvm/hyperv.c           |  2 +-
 arch/x86/kvm/i8254.c            |  4 +-
 arch/x86/kvm/lapic.c            | 15 +++---
 arch/x86/kvm/svm/sev.c          |  2 +-
 arch/x86/kvm/svm/svm.c          |  3 +-
 arch/x86/kvm/x86.c              | 83 +++++++++++++++++++++++++--------
 include/linux/kvm_host.h        |  2 +-
 8 files changed, 90 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e29694a97a19..d07ab048d7cc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1087,6 +1087,7 @@ struct kvm_arch_memory_slot {
 };
 
 struct kvm_arch_plane {
+	unsigned long apicv_inhibit_reasons;
 };
 
 /*
@@ -1299,11 +1300,13 @@ enum kvm_apicv_inhibit {
 	/*
 	 * PIT (i8254) 're-inject' mode, relies on EOI intercept,
 	 * which AVIC doesn't support for edge triggered interrupts.
+	 * Applied only to plane 0.
 	 */
 	APICV_INHIBIT_REASON_PIT_REINJ,
 
 	/*
-	 * AVIC is disabled because SEV doesn't support it.
+	 * AVIC is disabled because SEV doesn't support it.  Sticky and applied
+	 * only to plane 0.
 	 */
 	APICV_INHIBIT_REASON_SEV,
 
@@ -2232,21 +2235,21 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 bool kvm_apicv_activated(struct kvm *kvm);
 bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu);
 void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
-void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
+void __kvm_set_or_clear_apicv_inhibit(struct kvm_plane *plane,
 				      enum kvm_apicv_inhibit reason, bool set);
-void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
+void kvm_set_or_clear_apicv_inhibit(struct kvm_plane *plane,
 				    enum kvm_apicv_inhibit reason, bool set);
 
-static inline void kvm_set_apicv_inhibit(struct kvm *kvm,
+static inline void kvm_set_apicv_inhibit(struct kvm_plane *plane,
 					 enum kvm_apicv_inhibit reason)
 {
-	kvm_set_or_clear_apicv_inhibit(kvm, reason, true);
+	kvm_set_or_clear_apicv_inhibit(plane, reason, true);
 }
 
-static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
+static inline void kvm_clear_apicv_inhibit(struct kvm_plane *plane,
 					   enum kvm_apicv_inhibit reason)
 {
-	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
+	kvm_set_or_clear_apicv_inhibit(plane, reason, false);
 }
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
@@ -2360,8 +2363,8 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 				       unsigned long *vcpu_bitmap);
 
-static inline void kvm_arch_init_plane(struct kvm_plane *plane) {}
-static inline void kvm_arch_free_plane(struct kvm_plane *plane) {}
+void kvm_arch_init_plane(struct kvm_plane *plane);
+void kvm_arch_free_plane(struct kvm_plane *plane);
 
 bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work);
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index c6592e7f40a2..a522b467be48 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -145,7 +145,7 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 	 * Inhibit APICv if any vCPU is using SynIC's AutoEOI, which relies on
 	 * the hypervisor to manually inject IRQs.
 	 */
-	__kvm_set_or_clear_apicv_inhibit(vcpu->kvm,
+	__kvm_set_or_clear_apicv_inhibit(vcpu_to_plane(vcpu),
 					 APICV_INHIBIT_REASON_HYPERV,
 					 !!hv->synic_auto_eoi_used);
 
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index e3a3e7b90c26..ded1a9565c36 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -306,13 +306,13 @@ void kvm_pit_set_reinject(struct kvm_pit *pit, bool reinject)
 	 * So, deactivate APICv when PIT is in reinject mode.
 	 */
 	if (reinject) {
-		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PIT_REINJ);
+		kvm_set_apicv_inhibit(kvm->planes[0], APICV_INHIBIT_REASON_PIT_REINJ);
 		/* The initial state is preserved while ps->reinject == 0. */
 		kvm_pit_reset_reinject(pit);
 		kvm_register_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
 		kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	} else {
-		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PIT_REINJ);
+		kvm_clear_apicv_inhibit(kvm->planes[0], APICV_INHIBIT_REASON_PIT_REINJ);
 		kvm_unregister_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
 		kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	}
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c078269f7b1d..4077c8d1e37e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -377,6 +377,7 @@ enum {
 
 static void kvm_recalculate_apic_map(struct kvm *kvm)
 {
+	struct kvm_plane *plane = kvm->planes[0];
 	struct kvm_apic_map *new, *old = NULL;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
@@ -456,19 +457,19 @@ static void kvm_recalculate_apic_map(struct kvm *kvm)
 	 * map also applies to APICv.
 	 */
 	if (!new)
-		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
+		kvm_set_apicv_inhibit(plane, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
 	else
-		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
+		kvm_clear_apicv_inhibit(plane, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
 
 	if (!new || new->logical_mode == KVM_APIC_MODE_MAP_DISABLED)
-		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
+		kvm_set_apicv_inhibit(plane, APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
 	else
-		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
+		kvm_clear_apicv_inhibit(plane, APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
 
 	if (xapic_id_mismatch)
-		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
+		kvm_set_apicv_inhibit(plane, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
 	else
-		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
+		kvm_clear_apicv_inhibit(plane, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
 
 	old = rcu_dereference_protected(kvm->arch.apic_map,
 			lockdep_is_held(&kvm->arch.apic_map_lock));
@@ -2630,7 +2631,7 @@ static void __kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value)
 
 	if ((value & MSR_IA32_APICBASE_ENABLE) &&
 	     apic->base_address != APIC_DEFAULT_PHYS_BASE) {
-		kvm_set_apicv_inhibit(apic->vcpu->kvm,
+		kvm_set_apicv_inhibit(vcpu_to_plane(vcpu),
 				      APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
 	}
 }
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 827dbe4d2b3b..130d895f1d95 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -458,7 +458,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	INIT_LIST_HEAD(&sev->mirror_vms);
 	sev->need_init = false;
 
-	kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_SEV);
+	kvm_set_apicv_inhibit(kvm->planes[0], APICV_INHIBIT_REASON_SEV);
 
 	return 0;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f6a435ff7e2d..917bfe8db101 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3926,7 +3926,8 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 		 * the VM wide AVIC inhibition.
 		 */
 		if (!is_guest_mode(vcpu))
-			kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
+			kvm_set_apicv_inhibit(vcpu_to_plane(vcpu),
+					      APICV_INHIBIT_REASON_IRQWIN);
 
 		svm_set_vintr(svm);
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 653886e6e1c8..382d8ace131f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6567,7 +6567,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		smp_wmb();
 		kvm->arch.irqchip_mode = KVM_IRQCHIP_SPLIT;
 		kvm->arch.nr_reserved_ioapic_pins = cap->args[0];
-		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_ABSENT);
+		kvm_clear_apicv_inhibit(kvm->planes[0], APICV_INHIBIT_REASON_ABSENT);
 		r = 0;
 split_irqchip_unlock:
 		mutex_unlock(&kvm->lock);
@@ -7109,7 +7109,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		/* Write kvm->irq_routing before enabling irqchip_in_kernel. */
 		smp_wmb();
 		kvm->arch.irqchip_mode = KVM_IRQCHIP_KERNEL;
-		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_ABSENT);
+		kvm_clear_apicv_inhibit(kvm->planes[0], APICV_INHIBIT_REASON_ABSENT);
 	create_irqchip_unlock:
 		mutex_unlock(&kvm->lock);
 		break;
@@ -9996,14 +9996,18 @@ static void set_or_clear_apicv_inhibit(unsigned long *inhibits,
 	trace_kvm_apicv_inhibit_changed(reason, set, *inhibits);
 }
 
-static void kvm_apicv_init(struct kvm *kvm)
+static void kvm_apicv_init(struct kvm *kvm, unsigned long *apicv_inhibit_reasons)
 {
-	enum kvm_apicv_inhibit reason = enable_apicv ? APICV_INHIBIT_REASON_ABSENT :
-						       APICV_INHIBIT_REASON_DISABLED;
+	enum kvm_apicv_inhibit reason;
 
-	set_or_clear_apicv_inhibit(&kvm->arch.apicv_inhibit_reasons, reason, true);
+	if (!enable_apicv)
+		reason = APICV_INHIBIT_REASON_DISABLED;
+	else if (!irqchip_kernel(kvm))
+		reason = APICV_INHIBIT_REASON_ABSENT;
+	else
+		return;
 
-	init_rwsem(&kvm->arch.apicv_update_lock);
+	set_or_clear_apicv_inhibit(apicv_inhibit_reasons, reason, true);
 }
 
 static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
@@ -10633,10 +10637,22 @@ static void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	__kvm_vcpu_update_apicv(vcpu);
 }
 
-void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
+static bool kvm_compute_apicv_inhibit(struct kvm *kvm,
+				      enum kvm_apicv_inhibit reason)
+{
+	int i;
+	for (i = 0; i < KVM_MAX_VCPU_PLANES; i++)
+		if (test_bit(reason, &kvm->planes[i]->arch.apicv_inhibit_reasons))
+			return true;
+
+	return false;
+}
+
+void __kvm_set_or_clear_apicv_inhibit(struct kvm_plane *plane,
 				      enum kvm_apicv_inhibit reason, bool set)
 {
-	unsigned long old, new;
+	struct kvm *kvm = plane->kvm;
+	unsigned long local, global;
 	bool changed;
 
 	lockdep_assert_held_write(&kvm->arch.apicv_update_lock);
@@ -10644,9 +10660,24 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 	if (!(kvm_x86_ops.required_apicv_inhibits & BIT(reason)))
 		return;
 
-	old = new = kvm->arch.apicv_inhibit_reasons;
-	set_or_clear_apicv_inhibit(&new, reason, set);
-	changed = (!!old != !!new);
+	local = plane->arch.apicv_inhibit_reasons;
+	set_or_clear_apicv_inhibit(&local, reason, set);
+
+	/* Could this flip change the global state? */
+	global = kvm->arch.apicv_inhibit_reasons;
+	if ((local & BIT(reason)) == (global & BIT(reason))) {
+		/* Easy case 1, the bit is now the same as for the whole VM.  */
+		changed = false;
+	} else if (set) {
+		/* Easy case 2, maybe the bit flipped globally from clear to set?  */
+		changed = !global;
+		set_or_clear_apicv_inhibit(&global, reason, set);
+	} else {
+		/* Harder case, check if no other plane had this inhibit.  */
+		set = kvm_compute_apicv_inhibit(kvm, reason);
+		set_or_clear_apicv_inhibit(&global, reason, set);
+		changed = !global;
+	}
 
 	if (changed) {
 		/*
@@ -10664,7 +10695,8 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 	}
 
-	kvm->arch.apicv_inhibit_reasons = new;
+	plane->arch.apicv_inhibit_reasons = local;
+	kvm->arch.apicv_inhibit_reasons = global;
 
 	if (changed && set) {
 		unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
@@ -10675,14 +10707,17 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 	}
 }
 
-void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
+void kvm_set_or_clear_apicv_inhibit(struct kvm_plane *plane,
 				    enum kvm_apicv_inhibit reason, bool set)
 {
+	struct kvm *kvm;
+
 	if (!enable_apicv)
 		return;
 
+	kvm = plane->kvm;
 	down_write(&kvm->arch.apicv_update_lock);
-	__kvm_set_or_clear_apicv_inhibit(kvm, reason, set);
+	__kvm_set_or_clear_apicv_inhibit(plane, reason, set);
 	up_write(&kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_set_or_clear_apicv_inhibit);
@@ -12083,24 +12118,26 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
+static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm_plane *plane)
 {
 	bool set = false;
+	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
 	if (!enable_apicv)
 		return;
 
+	kvm = plane->kvm;
 	down_write(&kvm->arch.apicv_update_lock);
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
+	kvm_for_each_plane_vcpu(i, vcpu, plane) {
 		if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ) {
 			set = true;
 			break;
 		}
 	}
-	__kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_BLOCKIRQ, set);
+	__kvm_set_or_clear_apicv_inhibit(plane, APICV_INHIBIT_REASON_BLOCKIRQ, set);
 	up_write(&kvm->arch.apicv_update_lock);
 }
 
@@ -12156,7 +12193,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 	kvm_x86_call(update_exception_bitmap)(vcpu);
 
-	kvm_arch_vcpu_guestdbg_update_apicv_inhibit(vcpu->kvm);
+	kvm_arch_vcpu_guestdbg_update_apicv_inhibit(vcpu_to_plane(vcpu));
 
 	r = 0;
 
@@ -12732,6 +12769,11 @@ void kvm_arch_free_vm(struct kvm *kvm)
 }
 
 
+void kvm_arch_init_plane(struct kvm_plane *plane)
+{
+	kvm_apicv_init(plane->kvm, &plane->arch.apicv_inhibit_reasons);
+}
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
@@ -12767,6 +12809,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	set_bit(KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
 		&kvm->arch.irq_sources_bitmap);
 
+	init_rwsem(&kvm->arch.apicv_update_lock);
 	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
 	mutex_init(&kvm->arch.apic_map_lock);
 	seqcount_raw_spinlock_init(&kvm->arch.pvclock_sc, &kvm->arch.tsc_write_lock);
@@ -12789,7 +12832,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
 
-	kvm_apicv_init(kvm);
+	kvm_apicv_init(kvm, &kvm->arch.apicv_inhibit_reasons);
 	kvm_hv_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 152dc5845309..5cade1c04646 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -943,7 +943,7 @@ static inline struct kvm_plane *vcpu_to_plane(struct kvm_vcpu *vcpu)
 #else
 static inline struct kvm_plane *vcpu_to_plane(struct kvm_vcpu *vcpu)
 {
-	return vcpu->kvm->planes[vcpu->plane_id];
+	return vcpu->kvm->planes[vcpu->plane];
 }
 #endif
 
-- 
2.49.0


