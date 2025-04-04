Return-Path: <kvm+bounces-42719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B120AA7C442
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44BF87A97E2
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C86E922E01E;
	Fri,  4 Apr 2025 19:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ii1y3gX4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6F322DF81
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795646; cv=none; b=mfHBvkMiXh9plf8EasdkYY+WKVHGKqpjT50KNlJKNLZMcenXHGYpZefNj7c0J/2M5UgotbCfThCrbqDqY+yH6Ur18UtwW8yYDnkj9I7VdmKqCWzpXhAz8v8yMglsl21bv0Qs0QSlD0Y5fpsWydW8GOl2YlFEzTPkamTM0yRg53U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795646; c=relaxed/simple;
	bh=gAMzCvcXzkDJ9F9l0lrjivM69IhB1IaN/+MJTI/UKb8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dk3QZglvTAzcpUW2NKZUE3WtRxoZDL4+sPi8w9EWMfhV4BW3Dd0gDYMB3kJiRXpl7Wq/bmW24FXPLBBbyGTl00zdiJ4uIDsa/OdUHEbFc2qq/pKE7BVhoaQ5ZC1utGCuPlGolZRXjOJIXVhK020Op2pBU/WwjVPpSrjlEFNoGqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ii1y3gX4; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736b431ee0dso1963799b3a.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795644; x=1744400444; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=H2RYMqQTeJsr/S1FidZ9b5PuuDedAtkVn2laGJYfLbg=;
        b=Ii1y3gX4ZjGU1Kmp6UZcQLZHbdMaPYrVvBJ5rF1xxmBHWLWykvvxcFqhr1MCZqL8zh
         s0ZzwaEh8qCF8eVs2naFwfLC2ojzjsO91SPY6pFpGWV9meEOYTQywDellDxzqVNBLzAE
         TfK7uytC9ZFGpjwsLoAKiR2BQc2NpuW28urBE/VStfmmwTaYNADrlt3CRXINrIFxft6I
         D0dmEBT77UjjlDQXEIf2R/9fyMpbZyQ+7wtdMX2d/lhj3iMVluHvmw7A9JfHrATwkKRM
         uC3qPWDQUpSPbpBraC1KCKH1QHQzN8qWUavDH4BVg/D52sk7ZRT6oV+WNhTBCNQkghEA
         HCOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795644; x=1744400444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H2RYMqQTeJsr/S1FidZ9b5PuuDedAtkVn2laGJYfLbg=;
        b=JNiblwGMb9oRXRT/GlVjDwDQZpkuwCyq32qf+ZvN4XpqdbOcYRUVMgxoilbSoq+exi
         L/PsXENtXflHjlxukWrusnQfyKq6iM1FJ777C/8bDAePrm+cuwAKFtETEtUye4xusQOH
         ekZ9XHATqPWl83mZLhYWIN/ke4b+RNbODrn4Xt8URZVKtAfGxrdq3DW2tEoJyFV/w1xC
         atJ8kjEDof/+IqyhYoaKPtQsRY0jBvS+ZhK3/lBVY3UIMbtf7NV26wQ5fOvGepO9IuuH
         W1cj8UhRet+Ao+lW8ML8O8dv3HbjCpRiD+0KPAO9ex8ONS8QgimpTS7uZ4D1Qojltxrf
         du1w==
X-Gm-Message-State: AOJu0YyTw4GeNtw6dEcumoIB2kqmqvK5B3kAbQT4c+nft3xC7oU+VMoq
	FTjv1El2uVDlaKoFz72qQC8J9ntQ9pbPhbowccvxWONQziGrDfeTmPGSW5HCMsFdELF59qU931I
	zVQ==
X-Google-Smtp-Source: AGHT+IFNJHAsoiO6n3VwVWgJkyAkhRtsy6on7q+rDtSQTDsyUctiC80j/CViWl2oBMuVNP5BPeL148rFMw0=
X-Received: from pfmy23.prod.google.com ([2002:aa7:8057:0:b0:736:b37b:f363])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1397:b0:736:51ab:7ae1
 with SMTP id d2e1a72fcca58-739e4be4210mr5217175b3a.16.1743795644331; Fri, 04
 Apr 2025 12:40:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:48 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-34-seanjc@google.com>
Subject: [PATCH 33/67] KVM: x86: Dedup AVIC vs. PI code for identifying target vCPU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Hoist the logic for identifying the target vCPU for a posted interrupt
into common x86.  The code is functionally identical between Intel and
AMD.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/svm/avic.c         | 83 ++++++++-------------------------
 arch/x86/kvm/svm/svm.h          |  3 +-
 arch/x86/kvm/vmx/posted_intr.c  | 56 ++++++----------------
 arch/x86/kvm/vmx/posted_intr.h  |  3 +-
 arch/x86/kvm/x86.c              | 46 +++++++++++++++---
 6 files changed, 81 insertions(+), 113 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 85f45fc5156d..cb98d8d3c6c2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1838,7 +1838,8 @@ struct kvm_x86_ops {
 
 	int (*pi_update_irte)(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			      unsigned int host_irq, uint32_t guest_irq,
-			      struct kvm_kernel_irq_routing_entry *new);
+			      struct kvm_kernel_irq_routing_entry *new,
+			      struct kvm_vcpu *vcpu, u32 vector);
 	void (*pi_start_assignment)(struct kvm *kvm);
 	void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ea6eae72b941..666f518340a7 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -812,52 +812,13 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
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
+			struct kvm_kernel_irq_routing_entry *new,
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
@@ -865,7 +826,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	svm_ir_list_del(irqfd);
 
 	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
-		 __func__, host_irq, guest_irq, !!new);
+		 __func__, host_irq, guest_irq, !!vcpu);
 
 	/**
 	 * Here, we setup with legacy mode in the following cases:
@@ -874,23 +835,23 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	 * 3. APIC virtualization is disabled for the vcpu.
 	 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
 	 */
-	if (new && new && new->type == KVM_IRQ_ROUTING_MSI &&
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
@@ -902,12 +863,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
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
@@ -915,10 +875,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
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
index 6ad0aa86f78d..5ce240085ee0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -741,7 +741,8 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			unsigned int host_irq, uint32_t guest_irq,
-			struct kvm_kernel_irq_routing_entry *new);
+			struct kvm_kernel_irq_routing_entry *new,
+			struct kvm_vcpu *vcpu, u32 vector);
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void avic_ring_doorbell(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 786912cee3f8..fd5f6a125614 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -266,46 +266,20 @@ void vmx_pi_start_assignment(struct kvm *kvm)
 
 int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		       unsigned int host_irq, uint32_t guest_irq,
-		       struct kvm_kernel_irq_routing_entry *new)
+		       struct kvm_kernel_irq_routing_entry *new,
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
index a586d6aaf862..ee3e19e976ac 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -15,7 +15,8 @@ void __init pi_init_cpu(int cpu);
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		       unsigned int host_irq, uint32_t guest_irq,
-		       struct kvm_kernel_irq_routing_entry *new);
+		       struct kvm_kernel_irq_routing_entry *new,
+		       struct kvm_vcpu *vcpu, u32 vector);
 void vmx_pi_start_assignment(struct kvm *kvm);
 
 static inline int pi_find_highest_vector(struct pi_desc *pi_desc)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b8b259847d05..0ab818bba743 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13567,6 +13567,43 @@ bool kvm_arch_has_irq_bypass(void)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_has_irq_bypass);
 
+static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
+			      struct kvm_kernel_irq_routing_entry *old,
+			      struct kvm_kernel_irq_routing_entry *new)
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
+	if (new && new->type == KVM_IRQ_ROUTING_MSI) {
+		kvm_set_msi_irq(kvm, new, &irq);
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
+					    irqfd->gsi, new, vcpu, irq.vector);
+}
+
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
 {
@@ -13581,8 +13618,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 	irqfd->producer = prod;
 
 	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
-		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
-						   irqfd->gsi, &irqfd->irq_entry);
+		ret = kvm_pi_update_irte(irqfd, NULL, &irqfd->irq_entry);
 		if (ret)
 			kvm_arch_end_assignment(irqfd->kvm);
 	}
@@ -13610,8 +13646,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
-		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
-						   irqfd->gsi, NULL);
+		ret = kvm_pi_update_irte(irqfd, &irqfd->irq_entry, NULL);
 		if (ret)
 			pr_info("irq bypass consumer (token %p) unregistration fails: %d\n",
 				irqfd->consumer.token, ret);
@@ -13628,8 +13663,7 @@ int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				  struct kvm_kernel_irq_routing_entry *old,
 				  struct kvm_kernel_irq_routing_entry *new)
 {
-	return kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, irqfd->producer->irq,
-					    irqfd->gsi, new);
+	return kvm_pi_update_irte(irqfd, old, new);
 }
 
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
-- 
2.49.0.504.g3bcea36a83-goog


