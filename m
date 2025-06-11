Return-Path: <kvm+bounces-49174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D04AD633B
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD67D1BC3D27
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800E72E0B44;
	Wed, 11 Jun 2025 22:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lHQXy3Uz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C5F2E62DF
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682066; cv=none; b=TPICGX7My/9jLH/DfbRzwxjCeEKEqJGjeUzotcJ81S0+yzfVUrvPt7N+mAOcjOdyriFa53YMoAW1/xFUmJvJ3a3HuwZ/CDR+F0mmyqLODDttfWQLF50vvvjpr3QAMU1zjYFOpl58vI9pPmUnM0m4lMSqlnAhO+yyEJyqO3+v3n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682066; c=relaxed/simple;
	bh=RmpqS3viWspRhGwrwfvC2/EZ2b1ubdIVOJ1G2r++QN4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UUZ5fkmGdlg/2xvWFBgelEiAJPdNgNcbr5H437BcR+88wCHTtJZwTfA9LOLKvgb/bYfG0FnQmlKG/YxDuW1MLF5OCV2Lqg3xnaHO3DCdu4XVegCrEqKRpFVqejOoVonxBjlrnMC+EMzuRXKyCQeVuOlMFW5PAoBDGA4vbuQ7GS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lHQXy3Uz; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7395d07a3dcso235062b3a.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682064; x=1750286864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fQO8sxJeRX3ZQyU9A1Csi9W6blDZr8XLiOeAd558lds=;
        b=lHQXy3UzmJdHVk4lSuNAycvegRZABadPguR3XHrDZ7vf+DHIGJsfY8xG/sie143gQG
         BuJyAY3c6+qD/2pTSh7720hKfscBDOgo0S9vvxBcc9959ErXOfzc03qDnxihg5Nu0Y3Q
         TE660wgXeDGgKrg8X9nKmTozSN/XwPxC2jdA/xN+xObzdt2oHOnsceyBUAREvGJ7HjjV
         5eUShp0LzPFhKQM+yNMeceC34xOLXCVXh0kWcjZN+gxmtE0K6HIqLTiFlbsIUbgKUPHV
         OP1X8+v9PjfozI3C6ZLmvE5ERx3AhOLN0tH0/7PdkhMzCwIFjce6wnj/9+2eV5ZzPJ63
         HOGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682064; x=1750286864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fQO8sxJeRX3ZQyU9A1Csi9W6blDZr8XLiOeAd558lds=;
        b=SSyC76GTnAOBdqwf5fPv4BI/FiO9eW+kSRcALE+IFLXyUfZtOiKfpQzY1mX0qFwbB0
         A796ujb3kRrUJbLakxVeeKTtz6uHiToIng+4hPVL5td6GLK77leacQ8AZacSX7EYjKAo
         hO87qba9jcQzA2dXaCWHpf1aUE8Q9Oc+KIHSvZcsQOBbIONLiLNjpW4w2G3zrWxClS/J
         9gp25H6B/UkMte/D5AnTsEa7ZwiWgZIlYA26F5HuxEzkVsIxlHJU/HclMCBep9MQTMWG
         F3JaqC5jHGteD3h+Wfii/Y1Uvd22xcF/q6gF66xD0fAYG2vK2wjRfDzToXYtFbiMvVln
         pOEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfquf/HuTj8G6TmDvciRpbEOCqF48zA08QU6Oc0QZF3c2OXKG8b5c8fcfa1gt9RvjDLi0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm1I14rj0LF8wMljzIN/Y1j4a42hyD5lk9O+WtIEFWAb7DDuCZ
	NFncchov1Y3ZXy/IibkYzp2I79hIt4MwL3fzUja9AGLfrTIt/UovX/zZshZWf7OJ3/43mEb3JvA
	c3AKuRw==
X-Google-Smtp-Source: AGHT+IEZeoyoLnloUk+ihHaltqiIN7tERx+GUDU3KDYM33Emcab4XhX1eQFJfO0yxj9LnTc+Z7NDHoXvGo0=
X-Received: from pfbgr3.prod.google.com ([2002:a05:6a00:4d03:b0:73c:6d5:ce4c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734d:b0:215:f6ab:cf77
 with SMTP id adf61e73a8af0-21f9b8c1144mr719025637.23.1749682063917; Wed, 11
 Jun 2025 15:47:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:31 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-30-seanjc@google.com>
Subject: [PATCH v3 28/62] KVM: x86: Dedup AVIC vs. PI code for identifying
 target vCPU
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

Hoist the logic for identifying the target vCPU for a posted interrupt
into common x86.  The code is functionally identical between Intel and
AMD.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/irq.c              | 45 +++++++++++++++---
 arch/x86/kvm/svm/avic.c         | 82 ++++++++-------------------------
 arch/x86/kvm/svm/svm.h          |  2 +-
 arch/x86/kvm/vmx/posted_intr.c  | 55 ++++++----------------
 arch/x86/kvm/vmx/posted_intr.h  |  2 +-
 6 files changed, 75 insertions(+), 113 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cba82d7a701d..c722adfedd96 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1854,7 +1854,7 @@ struct kvm_x86_ops {
 
 	int (*pi_update_irte)(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			      unsigned int host_irq, uint32_t guest_irq,
-			      struct kvm_kernel_irq_routing_entry *new);
+			      struct kvm_vcpu *vcpu, u32 vector);
 	void (*pi_start_assignment)(struct kvm *kvm);
 	void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 09f7a5cdca7d..5948aba9fdc0 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -508,6 +508,42 @@ void kvm_arch_irq_routing_update(struct kvm *kvm)
 		kvm_make_scan_ioapic_request(kvm);
 }
 
+static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
+			      struct kvm_kernel_irq_routing_entry *entry)
+{
+	struct kvm *kvm = irqfd->kvm;
+	struct kvm_vcpu *vcpu = NULL;
+	struct kvm_lapic_irq irq;
+
+	if (!irqchip_in_kernel(kvm) ||
+	    !kvm_arch_has_irq_bypass() ||
+	    !kvm_arch_has_assigned_device(kvm))
+		return 0;
+
+	if (entry && entry->type == KVM_IRQ_ROUTING_MSI) {
+		kvm_set_msi_irq(kvm, entry, &irq);
+
+		/*
+		 * Force remapped mode if hardware doesn't support posting the
+		 * virtual interrupt to a vCPU.  Only IRQs are postable (NMIs,
+		 * SMIs, etc. are not), and neither AMD nor Intel IOMMUs support
+		 * posting multicast/broadcast IRQs.  If the interrupt can't be
+		 * posted, the device MSI needs to be routed to the host so that
+		 * the guest's desired interrupt can be synthesized by KVM.
+		 *
+		 * This means that KVM can only post lowest-priority interrupts
+		 * if they have a single CPU as the destination, e.g. only if
+		 * the guest has affined the interrupt to a single vCPU.
+		 */
+		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
+		    !kvm_irq_is_postable(&irq))
+			vcpu = NULL;
+	}
+
+	return kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, irqfd->producer->irq,
+					    irqfd->gsi, vcpu, irq.vector);
+}
+
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
 {
@@ -522,8 +558,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 	irqfd->producer = prod;
 
 	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
-		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
-						   irqfd->gsi, &irqfd->irq_entry);
+		ret = kvm_pi_update_irte(irqfd, &irqfd->irq_entry);
 		if (ret)
 			kvm_arch_end_assignment(irqfd->kvm);
 	}
@@ -551,8 +586,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
-		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
-						   irqfd->gsi, NULL);
+		ret = kvm_pi_update_irte(irqfd, NULL);
 		if (ret)
 			pr_info("irq bypass consumer (token %p) unregistration fails: %d\n",
 				irqfd->consumer.token, ret);
@@ -568,8 +602,7 @@ int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				  struct kvm_kernel_irq_routing_entry *old,
 				  struct kvm_kernel_irq_routing_entry *new)
 {
-	return kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, irqfd->producer->irq,
-					    irqfd->gsi, new);
+	return kvm_pi_update_irte(irqfd, new);
 }
 
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3bbd565dcd0f..14a1544af192 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -803,52 +803,12 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
 	return 0;
 }
 
-/*
- * Note:
- * The HW cannot support posting multicast/broadcast
- * interrupts to a vCPU. So, we still use legacy interrupt
- * remapping for these kind of interrupts.
- *
- * For lowest-priority interrupts, we only support
- * those with single CPU as the destination, e.g. user
- * configures the interrupts via /proc/irq or uses
- * irqbalance to make the interrupts single-CPU.
- */
-static int
-get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
-		 struct vcpu_data *vcpu_info, struct kvm_vcpu **vcpu)
-{
-	struct kvm_lapic_irq irq;
-	*vcpu = NULL;
-
-	kvm_set_msi_irq(kvm, e, &irq);
-
-	if (!kvm_intr_is_single_vcpu(kvm, &irq, vcpu) ||
-	    !kvm_irq_is_postable(&irq)) {
-		pr_debug("SVM: %s: use legacy intr remap mode for irq %u\n",
-			 __func__, irq.vector);
-		return -1;
-	}
-
-	pr_debug("SVM: %s: use GA mode for irq %u\n", __func__,
-		 irq.vector);
-	vcpu_info->vector = irq.vector;
-
-	return 0;
-}
-
 int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			unsigned int host_irq, uint32_t guest_irq,
-			struct kvm_kernel_irq_routing_entry *new)
+			struct kvm_vcpu *vcpu, u32 vector)
 {
-	bool enable_remapped_mode = true;
-	struct vcpu_data vcpu_info;
-	struct kvm_vcpu *vcpu = NULL;
 	int ret = 0;
 
-	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
-		return 0;
-
 	/*
 	 * If the IRQ was affined to a different vCPU, remove the IRTE metadata
 	 * from the *previous* vCPU's list.
@@ -856,7 +816,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	svm_ir_list_del(irqfd);
 
 	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
-		 __func__, host_irq, guest_irq, !!new);
+		 __func__, host_irq, guest_irq, !!vcpu);
 
 	/**
 	 * Here, we setup with legacy mode in the following cases:
@@ -865,23 +825,23 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	 * 3. APIC virtualization is disabled for the vcpu.
 	 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
 	 */
-	if (new && new->type == KVM_IRQ_ROUTING_MSI &&
-	    !get_pi_vcpu_info(kvm, new, &vcpu_info, &vcpu) &&
-	    kvm_vcpu_apicv_active(vcpu)) {
-		struct amd_iommu_pi_data pi;
-
-		enable_remapped_mode = false;
-
-		vcpu_info.pi_desc_addr = avic_get_backing_page_address(to_svm(vcpu));
-
+	if (vcpu && kvm_vcpu_apicv_active(vcpu)) {
 		/*
 		 * Try to enable guest_mode in IRTE.  Note, the address
 		 * of the vCPU's AVIC backing page is passed to the
 		 * IOMMU via vcpu_info->pi_desc_addr.
 		 */
-		pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id, vcpu->vcpu_id);
-		pi.is_guest_mode = true;
-		pi.vcpu_data = &vcpu_info;
+		struct vcpu_data vcpu_info = {
+			.pi_desc_addr = avic_get_backing_page_address(to_svm(vcpu)),
+			.vector = vector,
+		};
+
+		struct amd_iommu_pi_data pi = {
+			.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id, vcpu->vcpu_id),
+			.is_guest_mode = true,
+			.vcpu_data = &vcpu_info,
+		};
+
 		ret = irq_set_vcpu_affinity(host_irq, &pi);
 
 		/**
@@ -893,12 +853,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 */
 		if (!ret)
 			ret = svm_ir_list_add(to_svm(vcpu), irqfd, &pi);
-	}
 
-	if (!ret && vcpu) {
-		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id,
-					 guest_irq, vcpu_info.vector,
-					 vcpu_info.pi_desc_addr, !!new);
+		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, guest_irq,
+					 vector, vcpu_info.pi_desc_addr, true);
+	} else {
+		ret = irq_set_vcpu_affinity(host_irq, NULL);
 	}
 
 	if (ret < 0) {
@@ -906,10 +865,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		goto out;
 	}
 
-	if (enable_remapped_mode)
-		ret = irq_set_vcpu_affinity(host_irq, NULL);
-	else
-		ret = 0;
+	ret = 0;
 out:
 	return ret;
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 939ff0e35a2b..b5cd1927b009 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -747,7 +747,7 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			unsigned int host_irq, uint32_t guest_irq,
-			struct kvm_kernel_irq_routing_entry *new);
+			struct kvm_vcpu *vcpu, u32 vector);
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void avic_ring_doorbell(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index e59eae11f476..3de767c5d6b2 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -300,46 +300,19 @@ void vmx_pi_start_assignment(struct kvm *kvm)
 
 int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		       unsigned int host_irq, uint32_t guest_irq,
-		       struct kvm_kernel_irq_routing_entry *new)
+		       struct kvm_vcpu *vcpu, u32 vector)
 {
-	struct kvm_lapic_irq irq;
-	struct kvm_vcpu *vcpu;
-	struct vcpu_data vcpu_info;
-
-	if (!vmx_can_use_vtd_pi(kvm))
-		return 0;
-
-	/*
-	 * VT-d PI cannot support posting multicast/broadcast
-	 * interrupts to a vCPU, we still use interrupt remapping
-	 * for these kind of interrupts.
-	 *
-	 * For lowest-priority interrupts, we only support
-	 * those with single CPU as the destination, e.g. user
-	 * configures the interrupts via /proc/irq or uses
-	 * irqbalance to make the interrupts single-CPU.
-	 *
-	 * We will support full lowest-priority interrupt later.
-	 *
-	 * In addition, we can only inject generic interrupts using
-	 * the PI mechanism, refuse to route others through it.
-	 */
-	if (!new || new->type != KVM_IRQ_ROUTING_MSI)
-		goto do_remapping;
-
-	kvm_set_msi_irq(kvm, new, &irq);
-
-	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
-	    !kvm_irq_is_postable(&irq))
-		goto do_remapping;
-
-	vcpu_info.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu));
-	vcpu_info.vector = irq.vector;
-
-	trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, guest_irq,
-				 vcpu_info.vector, vcpu_info.pi_desc_addr, true);
-
-	return irq_set_vcpu_affinity(host_irq, &vcpu_info);
-do_remapping:
-	return irq_set_vcpu_affinity(host_irq, NULL);
+	if (vcpu) {
+		struct vcpu_data vcpu_info = {
+			.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu)),
+			.vector = vector,
+		};
+
+		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, guest_irq,
+					 vcpu_info.vector, vcpu_info.pi_desc_addr, true);
+
+		return irq_set_vcpu_affinity(host_irq, &vcpu_info);
+	} else {
+		return irq_set_vcpu_affinity(host_irq, NULL);
+	}
 }
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index a94afcb55f7f..94ed66ea6249 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -16,7 +16,7 @@ void pi_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		       unsigned int host_irq, uint32_t guest_irq,
-		       struct kvm_kernel_irq_routing_entry *new);
+		       struct kvm_vcpu *vcpu, u32 vector);
 void vmx_pi_start_assignment(struct kvm *kvm);
 
 static inline int pi_find_highest_vector(struct pi_desc *pi_desc)
-- 
2.50.0.rc1.591.g9c95f17f64-goog


