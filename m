Return-Path: <kvm+bounces-42688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1296A7C3FC
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 787A317B731
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA91E221569;
	Fri,  4 Apr 2025 19:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uh88uJht"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1826A21E091
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795592; cv=none; b=WvCncUrxO7/TcQMXN1o08WpsaU7+wl5zeKWERMZDtDJ2ch+81SRgPl000mywuEN2DZKfwqH9V0xSiZeyCig4oH21D78TZ7g6t86P+7ruATux2vZOy9+rqCwMoDKhkCkFaHulxfY1o5qVeF9BAXawTgN/DxBLoWedyPAY0oZYHg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795592; c=relaxed/simple;
	bh=4f35MFyB5Z66tYnl+4xh20T32heL9hmqCIpxVPqs8rM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oqPN8LqKHZumez3GxME37ZY+aSSiq26UJ7ZBSg8oBKIWIr6zQkKVTlaYgUugu2Z0hiAE5dQjoDVi1x3f0h2ExmItRcMrRmTIn8Td+ffm4ijf0Vpq6BGuQf5uaJsJPIjouXx8hYF6YcJg2oP2jbtQ/AHQUoh75DKKGgXCDUJiF88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uh88uJht; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736c89461d1so3576252b3a.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795590; x=1744400390; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HBQQg5RBDKCscBapgjJpO3Swz5o+MtJx/38zhYtsnTI=;
        b=Uh88uJhtM6Rk9le3L499gt4RHqSvoqNQDnJUoDFcnnmL/cXnYG6+slpA8ssKKhFZGK
         7zd6v9XjF8ryaA49TDaL6JkC/D1cvPBN0wyzs6Qu1UmTLBkLcdImpUCAyid+NI+FOp2m
         xqBvEPnR3poYqx0odl3/mRzcvkaDtVHZzd+4OcrkLQnOFARKDWebcX8iWzDoYg7zOHIF
         qanaFM8GeODeAx25c6SPwPvB4Gu09SDeOTjGixgE4ct5Fl7QD7wwGKTNnsgh0LY/mrY7
         5OkURNW0MM2N359MJ8ChKSUAvwP7ENFVi0C25x1unzoENGwzyDsoO5nAKnyRn5bEqmoT
         WG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795590; x=1744400390;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HBQQg5RBDKCscBapgjJpO3Swz5o+MtJx/38zhYtsnTI=;
        b=R5ktvdjLfvasiaTe9KAKHIHM2enqfoCgm0zjMZiUpinEYw7WgotB//LaMwTGkhz5pf
         Mbvtaj6izC+DirPGg49s3cWGrErfrNcoAlD/o6n2MlASE+WIgMaf7HnHQslN//77RGGD
         WaSunFzG0VLuMEN5fxmHF3msccmq0qHkpfDn4su0gEJMnOSJMa0G2Q/imQmYrywO1XWg
         KySBIPiCv2J2NyeiykGVO2N/KPbXuKFiwAb4VyaIJUXqCYNWPeQTX+0HRq5qnGmzKz0y
         tUsHJcUFA63EisJ9LUcYcoptboZCW1nIjsuEEczXeFYqW2j+iT2bHdNyLIoWzKSzXBNa
         aPdg==
X-Gm-Message-State: AOJu0YzyD3UFFixDrKvJCIutQMaTKwabv+iTdANc2fLg0FJe13ov8sI/
	MtQ+1Ohk0RXt47qnJMucSMGi/hWLrsn1UGsrSFxuBr3Bo5sHjyfBotPJLxlxuCCV1Ym/4iwvOx1
	IiA==
X-Google-Smtp-Source: AGHT+IFD1risaw3iIrumvs5iCdJKlGSJfuM1C6nGfE4JDgOTzHXCStW3upmYfMaMHXW5LZH9425dtGtKXgg=
X-Received: from pfbjc20.prod.google.com ([2002:a05:6a00:6c94:b0:736:451f:b9f4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:230d:b0:736:35d4:f03f
 with SMTP id d2e1a72fcca58-739e6ff6b7fmr4703818b3a.6.1743795590459; Fri, 04
 Apr 2025 12:39:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:17 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-3-seanjc@google.com>
Subject: [PATCH 02/67] KVM: x86: Reset IRTE to host control if *new* route
 isn't postable
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Restore an IRTE back to host control (remapped or posted MSI mode) if the
*new* GSI route prevents posting the IRQ directly to a vCPU, regardless of
the GSI routing type.  Updating the IRTE if and only if the new GSI is an
MSI results in KVM leaving an IRTE posting to a vCPU.

The dangling IRTE can result in interrupts being incorrectly delivered to
the guest, and in the worst case scenario can result in use-after-free,
e.g. if the VM is torn down, but the underlying host IRQ isn't freed.

Fixes: efc644048ecd ("KVM: x86: Update IRTE for posted-interrupts")
Fixes: 411b44ba80ab ("svm: Implements update_pi_irte hook to setup posted interrupt")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c        | 61 ++++++++++++++++++----------------
 arch/x86/kvm/vmx/posted_intr.c | 28 ++++++----------
 2 files changed, 43 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a961e6e67050..ef08356fdb1c 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -896,6 +896,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_routing_table *irq_rt;
+	bool enable_remapped_mode = true;
 	int idx, ret = 0;
 
 	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
@@ -932,6 +933,8 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 		    kvm_vcpu_apicv_active(&svm->vcpu)) {
 			struct amd_iommu_pi_data pi;
 
+			enable_remapped_mode = false;
+
 			/* Try to enable guest_mode in IRTE */
 			pi.base = __sme_set(page_to_phys(svm->avic_backing_page) &
 					    AVIC_HPA_MASK);
@@ -950,33 +953,6 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 			 */
 			if (!ret && pi.is_guest_mode)
 				svm_ir_list_add(svm, &pi);
-		} else {
-			/* Use legacy mode in IRTE */
-			struct amd_iommu_pi_data pi;
-
-			/**
-			 * Here, pi is used to:
-			 * - Tell IOMMU to use legacy mode for this interrupt.
-			 * - Retrieve ga_tag of prior interrupt remapping data.
-			 */
-			pi.prev_ga_tag = 0;
-			pi.is_guest_mode = false;
-			ret = irq_set_vcpu_affinity(host_irq, &pi);
-
-			/**
-			 * Check if the posted interrupt was previously
-			 * setup with the guest_mode by checking if the ga_tag
-			 * was cached. If so, we need to clean up the per-vcpu
-			 * ir_list.
-			 */
-			if (!ret && pi.prev_ga_tag) {
-				int id = AVIC_GATAG_TO_VCPUID(pi.prev_ga_tag);
-				struct kvm_vcpu *vcpu;
-
-				vcpu = kvm_get_vcpu_by_id(kvm, id);
-				if (vcpu)
-					svm_ir_list_del(to_svm(vcpu), &pi);
-			}
 		}
 
 		if (!ret && svm) {
@@ -991,7 +967,36 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 		}
 	}
 
-	ret = 0;
+	if (enable_remapped_mode) {
+		/* Use legacy mode in IRTE */
+		struct amd_iommu_pi_data pi;
+
+		/**
+		 * Here, pi is used to:
+		 * - Tell IOMMU to use legacy mode for this interrupt.
+		 * - Retrieve ga_tag of prior interrupt remapping data.
+		 */
+		pi.prev_ga_tag = 0;
+		pi.is_guest_mode = false;
+		ret = irq_set_vcpu_affinity(host_irq, &pi);
+
+		/**
+		 * Check if the posted interrupt was previously
+		 * setup with the guest_mode by checking if the ga_tag
+		 * was cached. If so, we need to clean up the per-vcpu
+		 * ir_list.
+		 */
+		if (!ret && pi.prev_ga_tag) {
+			int id = AVIC_GATAG_TO_VCPUID(pi.prev_ga_tag);
+			struct kvm_vcpu *vcpu;
+
+			vcpu = kvm_get_vcpu_by_id(kvm, id);
+			if (vcpu)
+				svm_ir_list_del(to_svm(vcpu), &pi);
+		}
+	} else {
+		ret = 0;
+	}
 out:
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return ret;
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 16121d29dfd9..78ba3d638fe8 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -273,6 +273,7 @@ int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_routing_table *irq_rt;
+	bool enable_remapped_mode = true;
 	struct kvm_lapic_irq irq;
 	struct kvm_vcpu *vcpu;
 	struct vcpu_data vcpu_info;
@@ -311,21 +312,8 @@ int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 
 		kvm_set_msi_irq(kvm, e, &irq);
 		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
-		    !kvm_irq_is_postable(&irq)) {
-			/*
-			 * Make sure the IRTE is in remapped mode if
-			 * we don't handle it in posted mode.
-			 */
-			ret = irq_set_vcpu_affinity(host_irq, NULL);
-			if (ret < 0) {
-				printk(KERN_INFO
-				   "failed to back to remapped mode, irq: %u\n",
-				   host_irq);
-				goto out;
-			}
-
+		    !kvm_irq_is_postable(&irq))
 			continue;
-		}
 
 		vcpu_info.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu));
 		vcpu_info.vector = irq.vector;
@@ -333,11 +321,12 @@ int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, e->gsi,
 				vcpu_info.vector, vcpu_info.pi_desc_addr, set);
 
-		if (set)
-			ret = irq_set_vcpu_affinity(host_irq, &vcpu_info);
-		else
-			ret = irq_set_vcpu_affinity(host_irq, NULL);
+		if (!set)
+			continue;
 
+		enable_remapped_mode = false;
+
+		ret = irq_set_vcpu_affinity(host_irq, &vcpu_info);
 		if (ret < 0) {
 			printk(KERN_INFO "%s: failed to update PI IRTE\n",
 					__func__);
@@ -345,6 +334,9 @@ int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 		}
 	}
 
+	if (enable_remapped_mode)
+		ret = irq_set_vcpu_affinity(host_irq, NULL);
+
 	ret = 0;
 out:
 	srcu_read_unlock(&kvm->irq_srcu, idx);
-- 
2.49.0.504.g3bcea36a83-goog


