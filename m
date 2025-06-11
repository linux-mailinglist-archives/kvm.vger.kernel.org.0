Return-Path: <kvm+bounces-49169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D7ECAD6327
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24D871786BE
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFE672DCBEB;
	Wed, 11 Jun 2025 22:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2y0WkDKl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D0A2DCBFD
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682057; cv=none; b=UgQOdAzbqi+5A7rbHyf8kbtBnv7nuphFTwZ1YUaJVyAq2m9fPojxo80zBFlI+f95L5s8quN7aOUvI+PdJQYVEOKLW1/Ub4kFDJfoimJI5WxXnGGbZf7g9SCXldYkC/mgaQb/o5M3+/7m+gVJkmOavSSODjxXHUGgAxVXrHuYLOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682057; c=relaxed/simple;
	bh=0j9rjncNIqA99xT7ntd8FNb/aJpNqCnKYRV513GAehY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RoiYSpCeD6mQBrz9rMrP6vTPQG+/u4Ruhi2Qyna4+sOUCBzMivaWt+G/lKvwUj+sgvULFsMIsIr3FqEhF1L49YdJRe2obIWdfRrpB4PuisQoFhr/fZEjOIAOwYitKn8XE4Jo0iENqCR8kBcliBqIZ2dfM1m89EcZ2mMuNWbIMxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2y0WkDKl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31315427249so372227a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682055; x=1750286855; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Lz6FPWK+2KaUOt8OyhBi1B9mdgWpelrW27yDhfYYvM0=;
        b=2y0WkDKlOCQgnjyg8mHvM3SEJitwbsRvIlRZ4F4T54HjZKK42hMPZgqrUS9lafBZ6Q
         fNreb9WYuIbeGbLaMKL2BcBlZZOieCx6NWl+KNtKjnWv2YYa0y5/AKM9ouytcSeVsl80
         KSgLzzKUj9BtrX7m+fGBIGxo2KcFsUZCniwhDCtxeQU0RWzRvWoobFbg7mBWJ7NVCS5k
         /9dfFeZxSMZVJqQQY8sgz5YHANL98nu0VSlicZeP2d4kMpHWamSDxx13n9z7c8mCJHVr
         4PUerzz6mgdhhzHcka3PMqiDbyuE/efiLnM3YjB56g3XRnJz+yJjMI8gxT0lQLffTh41
         siJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682055; x=1750286855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lz6FPWK+2KaUOt8OyhBi1B9mdgWpelrW27yDhfYYvM0=;
        b=PV1Rew9Q4Qurevv0ogsgzcPtI6tQMCBX/zesDn1MLtkkDQJRlbXzkYcEY0VJfkRvD5
         CHalNP7RQvuP0fRsCTwiAGPLq+ky0Y4uFG+UgFUgI2AzngWeHQ+lAT8Et+eTHejsW00K
         Xp+vNbMz9WC87bUw+3qBekHtfm638ahYvjxeGvopTtmkQokGpPTDh9/2eq39IZwFoUrZ
         ExWcmfpVyGhgxSA8KVus+wIY30+sQHYLq0lMhGjAB0kRiP7eXLae5J556a4OAOH/chcK
         jH0k8Fo25NdN2O63LqRhDJn9Dh7P64Ebm7DO+KVB2gw1otpy98ZBI5rtwczweT8iqVHP
         JCIA==
X-Forwarded-Encrypted: i=1; AJvYcCVQfydHA86wbezn2U6fLvI0ozVYRLvVplP2J1ImlLGyDdWPswqJsOrBc0K5LBdpxSQTHO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJlqTl03kXhrVHpzrRR08garWCJEKtub4Tpjug0mpHd1/uUZe6
	Bod4sSfv9SISzdQ/QUmmY2Hh04e4eSyYUaMWQxe8riBj0ek7Zo8ER+tPr/kqsaCpxTJa+0XWogl
	LAzJkZQ==
X-Google-Smtp-Source: AGHT+IHo1u0Z7FhSnHxyOYsMun3zcxJWYCXnnXBCwZMuIkgbN7vyWFArERANVwiRl4h7mR2M/XSqyhw5t/4=
X-Received: from pjbsm18.prod.google.com ([2002:a17:90b:2e52:b0:311:c7f9:ca1c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3944:b0:311:b5ac:6f5d
 with SMTP id 98e67ed59e1d1-313af204368mr7511964a91.29.1749682055441; Wed, 11
 Jun 2025 15:47:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:26 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-25-seanjc@google.com>
Subject: [PATCH v3 23/62] KVM: SVM: Stop walking list of routing table entries
 when updating IRTE
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

Now that KVM explicitly passes the new/current GSI routing to
pi_update_irte(), simply use the provided routing entry and stop walking
the routing table to find that entry.  KVM, via setup_routing_entry() and
sanity checked by kvm_get_msi_route(), disallows having a GSI configured
to trigger multiple MSIs.

I.e. this is subtly a glorified nop, as KVM allows at most one MSI per
GSI, the for-loop can only ever process one entry, and that entry is the
new/current entry (see the WARN_ON_ONCE() added by "KVM: x86: Pass new
routing entries and irqfd when updating IRTEs" to ensure @new matches the
entry found in the routing table).

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 109 ++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 65 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6260bf3697ba..a83769bb8123 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -843,11 +843,10 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			unsigned int host_irq, uint32_t guest_irq,
 			struct kvm_kernel_irq_routing_entry *new)
 {
-	struct kvm_kernel_irq_routing_entry *e;
-	struct kvm_irq_routing_table *irq_rt;
 	bool enable_remapped_mode = true;
-	bool set = !!new;
-	int idx, ret = 0;
+	struct vcpu_data vcpu_info;
+	struct vcpu_svm *svm = NULL;
+	int ret = 0;
 
 	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
 		return 0;
@@ -859,72 +858,53 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	svm_ir_list_del(irqfd);
 
 	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
-		 __func__, host_irq, guest_irq, set);
+		 __func__, host_irq, guest_irq, !!new);
 
-	idx = srcu_read_lock(&kvm->irq_srcu);
-	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
+	/**
+	 * Here, we setup with legacy mode in the following cases:
+	 * 1. When cannot target interrupt to a specific vcpu.
+	 * 2. Unsetting posted interrupt.
+	 * 3. APIC virtualization is disabled for the vcpu.
+	 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
+	 */
+	if (new && new->type == KVM_IRQ_ROUTING_MSI &&
+	    !get_pi_vcpu_info(kvm, new, &vcpu_info, &svm) &&
+	    kvm_vcpu_apicv_active(&svm->vcpu)) {
+		struct amd_iommu_pi_data pi;
 
-	if (guest_irq >= irq_rt->nr_rt_entries ||
-		hlist_empty(&irq_rt->map[guest_irq])) {
-		pr_warn_once("no route for guest_irq %u/%u (broken user space?)\n",
-			     guest_irq, irq_rt->nr_rt_entries);
-		goto out;
-	}
+		enable_remapped_mode = false;
 
-	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
-		struct vcpu_data vcpu_info;
-		struct vcpu_svm *svm = NULL;
-
-		if (e->type != KVM_IRQ_ROUTING_MSI)
-			continue;
-
-		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
+		/*
+		 * Try to enable guest_mode in IRTE.  Note, the address
+		 * of the vCPU's AVIC backing page is passed to the
+		 * IOMMU via vcpu_info->pi_desc_addr.
+		 */
+		pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
+					     svm->vcpu.vcpu_id);
+		pi.is_guest_mode = true;
+		pi.vcpu_data = &vcpu_info;
+		ret = irq_set_vcpu_affinity(host_irq, &pi);
 
 		/**
-		 * Here, we setup with legacy mode in the following cases:
-		 * 1. When cannot target interrupt to a specific vcpu.
-		 * 2. Unsetting posted interrupt.
-		 * 3. APIC virtualization is disabled for the vcpu.
-		 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
+		 * Here, we successfully setting up vcpu affinity in
+		 * IOMMU guest mode. Now, we need to store the posted
+		 * interrupt information in a per-vcpu ir_list so that
+		 * we can reference to them directly when we update vcpu
+		 * scheduling information in IOMMU irte.
 		 */
-		if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set &&
-		    kvm_vcpu_apicv_active(&svm->vcpu)) {
-			struct amd_iommu_pi_data pi;
-
-			enable_remapped_mode = false;
-
-			/*
-			 * Try to enable guest_mode in IRTE.  Note, the address
-			 * of the vCPU's AVIC backing page is passed to the
-			 * IOMMU via vcpu_info->pi_desc_addr.
-			 */
-			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
-						     svm->vcpu.vcpu_id);
-			pi.is_guest_mode = true;
-			pi.vcpu_data = &vcpu_info;
-			ret = irq_set_vcpu_affinity(host_irq, &pi);
-
-			/**
-			 * Here, we successfully setting up vcpu affinity in
-			 * IOMMU guest mode. Now, we need to store the posted
-			 * interrupt information in a per-vcpu ir_list so that
-			 * we can reference to them directly when we update vcpu
-			 * scheduling information in IOMMU irte.
-			 */
-			if (!ret && pi.is_guest_mode)
-				svm_ir_list_add(svm, irqfd, &pi);
-		}
-
-		if (!ret && svm) {
-			trace_kvm_pi_irte_update(host_irq, svm->vcpu.vcpu_id,
-						 e->gsi, vcpu_info.vector,
-						 vcpu_info.pi_desc_addr, set);
-		}
-
-		if (ret < 0) {
-			pr_err("%s: failed to update PI IRTE\n", __func__);
-			goto out;
-		}
+		if (!ret)
+			ret = svm_ir_list_add(svm, irqfd, &pi);
+	}
+
+	if (!ret && svm) {
+		trace_kvm_pi_irte_update(host_irq, svm->vcpu.vcpu_id,
+					 guest_irq, vcpu_info.vector,
+					 vcpu_info.pi_desc_addr, !!new);
+	}
+
+	if (ret < 0) {
+		pr_err("%s: failed to update PI IRTE\n", __func__);
+		goto out;
 	}
 
 	if (enable_remapped_mode)
@@ -932,7 +912,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	else
 		ret = 0;
 out:
-	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return ret;
 }
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog


