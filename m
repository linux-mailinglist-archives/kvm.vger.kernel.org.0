Return-Path: <kvm+bounces-42696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2EB4A7C45E
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51A291B61836
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76A42236F8;
	Fri,  4 Apr 2025 19:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gklIrjd/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD11C222599
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795606; cv=none; b=JMFFr1Vym1xh33o9Ba/nr6V/ZHPLYfbog8+/GSUtgeMzaz2QlwI0e/Acs3rqbgdH1yyicJ7VEEaYbxIKzv76PVFsxIvx4tgw0jNb+W8brLswfuveohRwCGN6h7EBn9X9oYzWvimwgPXOxIt+rXnyCPOYlP4q1h/FFpDeMi2tkWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795606; c=relaxed/simple;
	bh=oivgLMsYP6m5xV9KLWqFEzyIJWf/41dvsC/fZbkUGSA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cM96bd4bgfD/DZn/Ccn9eka52PQUSdmYSZjz+YYt4Vh808B2l1y3+mhJArc16xwmn9+Rxg78zeLe6Er6YlXEAQdsXgI+iCvBdI21hZNTuFw0BT7qI8fCJ5sEGbpjrD1gfakwtzHUfZczSy4Mscv8iuNQIloLxb7pzyatf4/+7gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gklIrjd/; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7398d70abbfso3439769b3a.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795604; x=1744400404; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ocleBBvlKr6feyKde42bUZgR4JDW1n63+aHvVvZVcGU=;
        b=gklIrjd/TRu8S+2bmwoRKc6RhdQI7TSJ9kHAVRlsp/T0vxnzkLGm2jY2XPjLu1/9+Q
         F5uM/L2DyXp0ZGijN6u2yEJNgwAeTdEjKeWWb1+zfSOthrRbJi2iuZEPsxYZDnpCOmvV
         lgqZwYiJKYgEvPsbTRz+CvXDR0EC2mR06ZTvYp0ehWdydyhcnz6p+tQsBMz7DMM6M8lZ
         H6Ols1R/FFWmCtf2iSYmACJuVe/v3R3+RHQBcusIerHyNtM+fccMMUf2ae/fVvSjdu+3
         Tzkri9nEYLauTdO1jC149F57sisk83s7GMOEAF579tV+r4ZDwTMJiml7fa0gC6ttBkbD
         l/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795604; x=1744400404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ocleBBvlKr6feyKde42bUZgR4JDW1n63+aHvVvZVcGU=;
        b=XQE7Gw86E+BaostmmPd7+c5KR7BPG/vhBZClklNaBSdiiPirlPVOdBR5Px2nd5Cmdd
         3shuXUKrI/RVx1fHvw/ngc6j9q7Qo88qbI/ZnyjEVtQf86ukS9G481nrV1e3bpDN9Vlb
         rg9nz6lo5Kx7mVf5JcovfeN+KB7sMiWbUrBCw1Qyd8ftz9FeiKrziEaoVRt3MXbBREsZ
         fVXZBaT5ObIPxavt3mga8iqaQv147DmQDJleDhkQBnHbJ4z8OFxFFKB4318tKk/st/GZ
         TIxmHwqxPN0tzOrDcV4IblRt2zQ/IVLTXOgb8bDE+k/9eM2zqlcN36JvfKKSf53Jwqge
         /WWw==
X-Gm-Message-State: AOJu0Yya2jyGJeDyBiHEZlYnXrgvP3pR93rePkqHtzCSH6ycVXNNbSSL
	bwTRTBswruFGAbzRVA+StUvlEoe3xtcBmLDaqoIiyFie9wam6O9fg6XNA4EepVrOI7IpMhI1FSK
	IeA==
X-Google-Smtp-Source: AGHT+IH2fhk1BClfEw9pVUM6hqP/FRNe9lFGePO9NibjY1q3A6Bve4xhICh/FTFH3jra1e+6rrGPO6LW4yo=
X-Received: from pfxa29.prod.google.com ([2002:a05:6a00:1d1d:b0:736:a983:dc43])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a04:b0:736:3e50:bfec
 with SMTP id d2e1a72fcca58-73b6aa3d9b9mr861903b3a.8.1743795604041; Fri, 04
 Apr 2025 12:40:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:25 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-11-seanjc@google.com>
Subject: [PATCH 10/67] KVM: SVM: Delete IRTE link from previous vCPU before
 setting new IRTE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Delete the previous per-vCPU IRTE link prior to modifying the IRTE.  If
forcing the IRTE back to remapped mode fails, the IRQ is already broken;
keeping stale metadata won't change that, and the IOMMU should be
sufficiently paranoid to sanitize the IRTE when the IRQ is freed and
reallocated.

This will allow hoisting the vCPU tracking to common x86, which in turn
will allow most of the IRTE update code to be deduplicated.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c   | 61 +++++++++------------------------------
 include/linux/kvm_irqfd.h |  1 +
 2 files changed, 15 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 967618ba743a..02b6f0007436 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -81,6 +81,7 @@ bool x2avic_enabled;
 struct amd_svm_iommu_ir {
 	struct list_head node;	/* Used by SVM for per-vcpu ir_list */
 	void *data;		/* Storing pointer to struct amd_ir_data */
+	struct vcpu_svm *svm;
 };
 
 static void avic_activate_vmcb(struct vcpu_svm *svm)
@@ -774,23 +775,19 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 	return ret;
 }
 
-static void svm_ir_list_del(struct vcpu_svm *svm,
-			    struct kvm_kernel_irqfd *irqfd,
-			    struct amd_iommu_pi_data *pi)
+static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 {
+	struct kvm_vcpu *vcpu = irqfd->irq_bypass_vcpu;
 	unsigned long flags;
-	struct kvm_kernel_irqfd *cur;
 
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
-	list_for_each_entry(cur, &svm->ir_list, vcpu_list) {
-		if (cur->irq_bypass_data != pi->ir_data)
-			continue;
-		if (WARN_ON_ONCE(cur != irqfd))
-			continue;
-		list_del(&irqfd->vcpu_list);
-		break;
-	}
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+	if (!vcpu)
+		return;
+
+	spin_lock_irqsave(&to_svm(vcpu)->ir_list_lock, flags);
+	list_del(&irqfd->vcpu_list);
+	spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
+
+	irqfd->irq_bypass_vcpu = NULL;
 }
 
 static int svm_ir_list_add(struct vcpu_svm *svm,
@@ -803,24 +800,7 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
 	if (WARN_ON_ONCE(!pi->ir_data))
 		return -EINVAL;
 
-	/**
-	 * In some cases, the existing irte is updated and re-set,
-	 * so we need to check here if it's already been * added
-	 * to the ir_list.
-	 */
-	if (pi->prev_ga_tag) {
-		struct kvm *kvm = svm->vcpu.kvm;
-		u32 vcpu_id = AVIC_GATAG_TO_VCPUID(pi->prev_ga_tag);
-		struct kvm_vcpu *prev_vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
-		struct vcpu_svm *prev_svm;
-
-		if (!prev_vcpu)
-			return -EINVAL;
-
-		prev_svm = to_svm(prev_vcpu);
-		svm_ir_list_del(prev_svm, irqfd, pi);
-	}
-
+	irqfd->irq_bypass_vcpu = &svm->vcpu;
 	irqfd->irq_bypass_data = pi->ir_data;
 
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
@@ -912,6 +892,8 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 
 		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
 
+		svm_ir_list_del(irqfd);
+
 		/**
 		 * Here, we setup with legacy mode in the following cases:
 		 * 1. When cannot target interrupt to a specific vcpu.
@@ -969,21 +951,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		pi.prev_ga_tag = 0;
 		pi.is_guest_mode = false;
 		ret = irq_set_vcpu_affinity(host_irq, &pi);
-
-		/**
-		 * Check if the posted interrupt was previously
-		 * setup with the guest_mode by checking if the ga_tag
-		 * was cached. If so, we need to clean up the per-vcpu
-		 * ir_list.
-		 */
-		if (!ret && pi.prev_ga_tag) {
-			int id = AVIC_GATAG_TO_VCPUID(pi.prev_ga_tag);
-			struct kvm_vcpu *vcpu;
-
-			vcpu = kvm_get_vcpu_by_id(kvm, id);
-			if (vcpu)
-				svm_ir_list_del(to_svm(vcpu), irqfd, &pi);
-		}
 	} else {
 		ret = 0;
 	}
diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
index 6510a48e62aa..361c07f4466d 100644
--- a/include/linux/kvm_irqfd.h
+++ b/include/linux/kvm_irqfd.h
@@ -60,6 +60,7 @@ struct kvm_kernel_irqfd {
 	struct irq_bypass_consumer consumer;
 	struct irq_bypass_producer *producer;
 
+	struct kvm_vcpu *irq_bypass_vcpu;
 	struct list_head vcpu_list;
 	void *irq_bypass_data;
 };
-- 
2.49.0.504.g3bcea36a83-goog


