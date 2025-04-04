Return-Path: <kvm+bounces-42717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7EE7A7C458
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:58:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FF543BC820
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC6722D7AF;
	Fri,  4 Apr 2025 19:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DV3SkB0s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE8322D4EF
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795643; cv=none; b=VtKbCsIu0SoNHB7vD5Vme9U7BxvZp/ciCMJ+q6QIdyNrC5HtPD9Ltk7YOw4hY2dLtSSGe9IXKQFZIx2i6t0Yj89B3Q/xUm0Uiowxsbra0ZLG4FQiOwq3DTxAGkwbk3IO4s26RqQ1SVmJp8P5FMY85F6vsnwjDERjIJMu7PfwJ4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795643; c=relaxed/simple;
	bh=E1NTSYzgy3mSFQ63wZRuWK8nkdF2D1eAwMnNqU4u4CA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LY5azeVk5dUt50CMlTRlCX+dNDEzQ/OBV8e2WjuymcGQdfq8JmGfNVp93mc8BiDhCnUr7ILFlMA71cBHKREfZUpoQ6sw0v33QpGOtv2TmAYijSp/Oh2lxBCFzKRCQBj1dNsyEr0J/JN9Fh6MjCi6zT2tfsfqM9gQVUJhnC8Z88I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DV3SkB0s; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff52e1c56fso3249978a91.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795640; x=1744400440; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PKAF7zUVxQgoLKs13cGz/YuTc8j2bNHXwpMbzBSsKQY=;
        b=DV3SkB0sUF8pxIoS1k2zYDbccdAWQTugYWebAzsA/Cp0vIfGV3DuvwzQP8w1xcfhsE
         Ijg9CA7Avwy0+xjGpsGTY+3ZRZqLbMON0gsPRcG+cyMbbtoJLsL+h5kGq5qO/xzFE//E
         IFxF0yp1V2Olp6JEMSSu3x8bcCzgx0cNSLNVKI3Hc2jP1nG1z1i5k4+50UItsnuKjf3I
         GMqeW42XYv78B5N4rm/fCDnrXUC5y+vuUcQ5/FWDnJtu95QcKzlgPr8e4dFOqpKUUlqh
         uKr1YmbRqsu6V/pfhnIrDsb5uiud6QzMZlKP1gQt8Dww50N7geFlfLlywGcM46p1RygD
         CV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795640; x=1744400440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PKAF7zUVxQgoLKs13cGz/YuTc8j2bNHXwpMbzBSsKQY=;
        b=c6W/KfrayyBFOprWZn4D80KpBeSFZgIms63JwPpclSIJ+tlvO6Akq9SxNdDvZn1oDz
         fF57C6wGlAjVfxhF1+aGlVNFEM7aZGuZZ7GGmXR3h05C/YJwEbb5Pqph+gRHT0jzBVNc
         jlLVRtaefmM/aBFvk/2RTdckr9Ri4j608IgiHRcDu1P3/KpRxF1j+Zu1AtBKNQMQddNe
         gpb9fG5fruBuP6l3SvSZmz3T82NHYLNV7Mbh1qTuj8JY+EGBYFVDPIoIO0lXtWco/YUk
         gVM+baItI4iNAscuUNTG9x0lwcM19aB70Fhg6PcBiO7/I4kBlU/vz8MNH0esHb/vhJZL
         g1TQ==
X-Gm-Message-State: AOJu0YxviH0MmT8uxigNCqtY0ruxUbaum2GAP8kcrJGSaS7n+gdxfR47
	80bzWjB1kWAfMFX3eQBdD+WhS3CtwDR/2EXS9/i6+h6C8k1gEsN3I20Pl7w8eRUp0OMQdKbEpbk
	BGg==
X-Google-Smtp-Source: AGHT+IF7aV7vIgQiVQyfCnIlHhs7ynxCvi33qThdlWSuQSHsGSJr9KXKrmMS3Or+kU5DYfPu8Q+fOei9d1c=
X-Received: from pjbsk12.prod.google.com ([2002:a17:90b:2dcc:b0:2ff:5516:6add])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:f950:b0:2fe:b907:562f
 with SMTP id 98e67ed59e1d1-306af732f86mr787774a91.14.1743795640626; Fri, 04
 Apr 2025 12:40:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:46 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-32-seanjc@google.com>
Subject: [PATCH 31/67] KVM: SVM: Extract SVM specific code out of get_pi_vcpu_info()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Genericize SVM's get_pi_vcpu_info() so that it can be shared with VMX.
The only SVM specific information it provides is the AVIC back page, and
that can be trivially retrieved by its sole caller.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 685a7b01194b..ea6eae72b941 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -825,14 +825,14 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
  */
 static int
 get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
-		 struct vcpu_data *vcpu_info, struct vcpu_svm **svm)
+		 struct vcpu_data *vcpu_info, struct kvm_vcpu **vcpu)
 {
 	struct kvm_lapic_irq irq;
-	struct kvm_vcpu *vcpu = NULL;
+	*vcpu = NULL;
 
 	kvm_set_msi_irq(kvm, e, &irq);
 
-	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
+	if (!kvm_intr_is_single_vcpu(kvm, &irq, vcpu) ||
 	    !kvm_irq_is_postable(&irq)) {
 		pr_debug("SVM: %s: use legacy intr remap mode for irq %u\n",
 			 __func__, irq.vector);
@@ -841,8 +841,6 @@ get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 
 	pr_debug("SVM: %s: use GA mode for irq %u\n", __func__,
 		 irq.vector);
-	*svm = to_svm(vcpu);
-	vcpu_info->pi_desc_addr = avic_get_backing_page_address(*svm);
 	vcpu_info->vector = irq.vector;
 
 	return 0;
@@ -854,7 +852,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 {
 	bool enable_remapped_mode = true;
 	struct vcpu_data vcpu_info;
-	struct vcpu_svm *svm = NULL;
+	struct kvm_vcpu *vcpu = NULL;
 	int ret = 0;
 
 	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
@@ -876,20 +874,21 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	 * 3. APIC virtualization is disabled for the vcpu.
 	 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
 	 */
-	if (new && new->type == KVM_IRQ_ROUTING_MSI &&
-	    !get_pi_vcpu_info(kvm, new, &vcpu_info, &svm) &&
-	    kvm_vcpu_apicv_active(&svm->vcpu)) {
+	if (new && new && new->type == KVM_IRQ_ROUTING_MSI &&
+	    !get_pi_vcpu_info(kvm, new, &vcpu_info, &vcpu) &&
+	    kvm_vcpu_apicv_active(vcpu)) {
 		struct amd_iommu_pi_data pi;
 
 		enable_remapped_mode = false;
 
+		vcpu_info.pi_desc_addr = avic_get_backing_page_address(to_svm(vcpu));
+
 		/*
 		 * Try to enable guest_mode in IRTE.  Note, the address
 		 * of the vCPU's AVIC backing page is passed to the
 		 * IOMMU via vcpu_info->pi_desc_addr.
 		 */
-		pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
-					     svm->vcpu.vcpu_id);
+		pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id, vcpu->vcpu_id);
 		pi.is_guest_mode = true;
 		pi.vcpu_data = &vcpu_info;
 		ret = irq_set_vcpu_affinity(host_irq, &pi);
@@ -902,11 +901,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 * scheduling information in IOMMU irte.
 		 */
 		if (!ret)
-			ret = svm_ir_list_add(svm, irqfd, &pi);
+			ret = svm_ir_list_add(to_svm(vcpu), irqfd, &pi);
 	}
 
-	if (!ret && svm) {
-		trace_kvm_pi_irte_update(host_irq, svm->vcpu.vcpu_id,
+	if (!ret && vcpu) {
+		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id,
 					 guest_irq, vcpu_info.vector,
 					 vcpu_info.pi_desc_addr, !!new);
 	}
-- 
2.49.0.504.g3bcea36a83-goog


