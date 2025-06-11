Return-Path: <kvm+bounces-49150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FEA5AD6302
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:50:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 799953AC2C8
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390C225CC46;
	Wed, 11 Jun 2025 22:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aUM3UL0Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499E225B308
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682025; cv=none; b=cGT6k06IqCDYR+b6isUGEivl35fnNjqGn6eYwZMX4BjmWqFvOGWLBCWX4tV7bfXYK3VvqwhhjeiQC26/c5VXKakRQWmcOPrCMMkRRCRJs03w4mhfH2u2g+J6vsnmE0tzhkZzjCQi2wVj/Jx3rw5EKg/vI+hZgYVyRI/LyNjEIZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682025; c=relaxed/simple;
	bh=hEB9ydD2wj9v4e40u+T69aKr6eS5S9Wzrqay28yMJ+I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SLAiJJk4sjdAT0x73DnapB1nYjIteE22YXpJpIEZgrT/nMzZHaaQDFoKjj2i5kDj2b1ygaKQbR75Orq02IfRIWmV/Nnfts9T6u0gDriwtOr4Ral6TMTlV02kO5zWmHCYBa3nQmEq/t4rMT6ZYSW4TlUOPCntkSylvN+Zg6L6teE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aUM3UL0Z; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234b133b428so1773745ad.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682022; x=1750286822; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AigF+Y9MYNfRX+27Mz1zGJDa9Ruxb1FfbdKOr62V2pU=;
        b=aUM3UL0Z9Ag5K6rV3sDgNzGXL4m4AdfaTEJsPyYX+TEy0U/83830oHveoZNI3N/G3H
         k2d4Vw6NifsuoFLu4KB5w9UsB1n/74AcnI3B7VoVJZSHys2MZNvhy8I9flTdFJDwGJ2q
         XxTeZ3PXO42m5BczMLBPeIeJE3e5LHNHohiW/kaYGOBb67eV8ul3TI7J7rjRXAmCbXuu
         38lsvOHi9oOEbcui6/tafmh52qHofE843uYiRDlEEdhM6zobkwGipQq6+MUjJsUZEWzO
         qJuLdK5VBgkrwNXjXEGhlnoKckSt2f5th7x4b/5g5bMuA3dTRah+yCYLe7NSHn7yBofH
         4ZDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682022; x=1750286822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AigF+Y9MYNfRX+27Mz1zGJDa9Ruxb1FfbdKOr62V2pU=;
        b=Xanxa6pRGaV3L2Z5GW5IL6L97F2Z/thCxad9hnfQn+dNsGYTvdNlBj6pb81rdDv3GQ
         3h33sHlit7mtdrY9HSQxzer294yFRn0oNYL8XrdZ+jOMclAje5ei15VOYQN6LOb9C16E
         oopErIlPlVlmf0L1d09pew3L3y7OaDPzmNDG/2QIX6ss1VLHViLmfqnh58BdBhtt1G7C
         s2H3OEgX+4s/91eBP8oQ1u7QWNcBdu35cE4L54Z2GmwAg9F1Un+12agXKz1t1UajoyP4
         X+k77Z/DCEeX/XkhBa1LJWKPzFDTQOe9rpuz8IvPCyz/Reqf8TmSxkscoSb6Gwu/Qo1H
         4Mfw==
X-Forwarded-Encrypted: i=1; AJvYcCXWGfva9ThQ2AO8l7J82GW73GMreRSgrXVvb39G2EzCwgG0PcEuHJjDy8H4eq9GutGrjTw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaPrAkrS9LoR5aowP9/o6mm/nYntj60fLS48Vjegaer5BMTUa/
	X18s9SrPFGbs1kVriSljUp9Vu4fZoHPu9GhQD5nLyvnanFFWVlPTkSf7yz4w17kLsmud7+vw0pU
	io+lIPg==
X-Google-Smtp-Source: AGHT+IEyipb6CSG32fPdkBnIH7AX3Zq2Z2jB0QyZC6+PFK6cFG6DODigZnV9KthZcAYR6p98mMBWNxQJtN0=
X-Received: from pjqq12.prod.google.com ([2002:a17:90b:584c:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:18c:b0:234:c8cf:a0e6
 with SMTP id d9443c01a7336-23641b199c4mr70063175ad.24.1749682022639; Wed, 11
 Jun 2025 15:47:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:07 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-6-seanjc@google.com>
Subject: [PATCH v3 04/62] KVM: SVM: Track per-vCPU IRTEs using
 kvm_kernel_irqfd structure
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

Track the IRTEs that are posting to an SVM vCPU via the associated irqfd
structure and GSI routing instead of dynamically allocating a separate
data structure.  In addition to eliminating an atomic allocation, this
will allow hoisting much of the IRTE update logic to common x86.

Cc: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c   | 71 +++++++++++++++------------------------
 arch/x86/kvm/svm/svm.h    | 10 +++---
 include/linux/kvm_irqfd.h |  3 ++
 3 files changed, 36 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index adacf00d6664..d33c01379421 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -75,14 +75,6 @@ static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
 bool x2avic_enabled;
 
-/*
- * This is a wrapper of struct amd_iommu_ir_data.
- */
-struct amd_svm_iommu_ir {
-	struct list_head node;	/* Used by SVM for per-vcpu ir_list */
-	void *data;		/* Storing pointer to struct amd_ir_data */
-};
-
 static void avic_activate_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
@@ -746,8 +738,8 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int ret = 0;
 	unsigned long flags;
-	struct amd_svm_iommu_ir *ir;
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_kernel_irqfd *irqfd;
 
 	if (!kvm_arch_has_assigned_device(vcpu->kvm))
 		return 0;
@@ -761,11 +753,11 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 	if (list_empty(&svm->ir_list))
 		goto out;
 
-	list_for_each_entry(ir, &svm->ir_list, node) {
+	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list) {
 		if (activate)
-			ret = amd_iommu_activate_guest_mode(ir->data);
+			ret = amd_iommu_activate_guest_mode(irqfd->irq_bypass_data);
 		else
-			ret = amd_iommu_deactivate_guest_mode(ir->data);
+			ret = amd_iommu_deactivate_guest_mode(irqfd->irq_bypass_data);
 		if (ret)
 			break;
 	}
@@ -774,27 +766,30 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 	return ret;
 }
 
-static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
+static void svm_ir_list_del(struct vcpu_svm *svm,
+			    struct kvm_kernel_irqfd *irqfd,
+			    struct amd_iommu_pi_data *pi)
 {
 	unsigned long flags;
-	struct amd_svm_iommu_ir *cur;
+	struct kvm_kernel_irqfd *cur;
 
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
-	list_for_each_entry(cur, &svm->ir_list, node) {
-		if (cur->data != pi->ir_data)
+	list_for_each_entry(cur, &svm->ir_list, vcpu_list) {
+		if (cur->irq_bypass_data != pi->ir_data)
 			continue;
-		list_del(&cur->node);
-		kfree(cur);
+		if (WARN_ON_ONCE(cur != irqfd))
+			continue;
+		list_del(&irqfd->vcpu_list);
 		break;
 	}
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
 
-static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
+static int svm_ir_list_add(struct vcpu_svm *svm,
+			   struct kvm_kernel_irqfd *irqfd,
+			   struct amd_iommu_pi_data *pi)
 {
-	int ret = 0;
 	unsigned long flags;
-	struct amd_svm_iommu_ir *ir;
 	u64 entry;
 
 	if (WARN_ON_ONCE(!pi->ir_data))
@@ -811,25 +806,14 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 		struct kvm_vcpu *prev_vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
 		struct vcpu_svm *prev_svm;
 
-		if (!prev_vcpu) {
-			ret = -EINVAL;
-			goto out;
-		}
+		if (!prev_vcpu)
+			return -EINVAL;
 
 		prev_svm = to_svm(prev_vcpu);
-		svm_ir_list_del(prev_svm, pi);
+		svm_ir_list_del(prev_svm, irqfd, pi);
 	}
 
-	/**
-	 * Allocating new amd_iommu_pi_data, which will get
-	 * add to the per-vcpu ir_list.
-	 */
-	ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_ATOMIC | __GFP_ACCOUNT);
-	if (!ir) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	ir->data = pi->ir_data;
+	irqfd->irq_bypass_data = pi->ir_data;
 
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
@@ -844,10 +828,9 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
 				    true, pi->ir_data);
 
-	list_add(&ir->node, &svm->ir_list);
+	list_add(&irqfd->vcpu_list, &svm->ir_list);
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-out:
-	return ret;
+	return 0;
 }
 
 /*
@@ -951,7 +934,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			 * scheduling information in IOMMU irte.
 			 */
 			if (!ret && pi.is_guest_mode)
-				svm_ir_list_add(svm, &pi);
+				svm_ir_list_add(svm, irqfd, &pi);
 		}
 
 		if (!ret && svm) {
@@ -992,7 +975,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 
 			vcpu = kvm_get_vcpu_by_id(kvm, id);
 			if (vcpu)
-				svm_ir_list_del(to_svm(vcpu), &pi);
+				svm_ir_list_del(to_svm(vcpu), irqfd, &pi);
 		}
 	}
 out:
@@ -1004,8 +987,8 @@ static inline int
 avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 {
 	int ret = 0;
-	struct amd_svm_iommu_ir *ir;
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_kernel_irqfd *irqfd;
 
 	lockdep_assert_held(&svm->ir_list_lock);
 
@@ -1019,8 +1002,8 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 	if (list_empty(&svm->ir_list))
 		return 0;
 
-	list_for_each_entry(ir, &svm->ir_list, node) {
-		ret = amd_iommu_update_ga(cpu, r, ir->data);
+	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list) {
+		ret = amd_iommu_update_ga(cpu, r, irqfd->irq_bypass_data);
 		if (ret)
 			return ret;
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b35fce30d923..cc27877d69ae 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -310,10 +310,12 @@ struct vcpu_svm {
 	u64 *avic_physical_id_cache;
 
 	/*
-	 * Per-vcpu list of struct amd_svm_iommu_ir:
-	 * This is used mainly to store interrupt remapping information used
-	 * when update the vcpu affinity. This avoids the need to scan for
-	 * IRTE and try to match ga_tag in the IOMMU driver.
+	 * Per-vCPU list of irqfds that are eligible to post IRQs directly to
+	 * the vCPU (a.k.a. device posted IRQs, a.k.a. IRQ bypass).  The list
+	 * is used to reconfigure IRTEs when the vCPU is loaded/put (to set the
+	 * target pCPU), when AVIC is toggled on/off (to (de)activate bypass),
+	 * and if the irqfd becomes ineligible for posting (to put the IRTE
+	 * back into remapped mode).
 	 */
 	struct list_head ir_list;
 	spinlock_t ir_list_lock;
diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
index 8ad43692e3bb..6510a48e62aa 100644
--- a/include/linux/kvm_irqfd.h
+++ b/include/linux/kvm_irqfd.h
@@ -59,6 +59,9 @@ struct kvm_kernel_irqfd {
 	struct work_struct shutdown;
 	struct irq_bypass_consumer consumer;
 	struct irq_bypass_producer *producer;
+
+	struct list_head vcpu_list;
+	void *irq_bypass_data;
 };
 
 #endif /* __LINUX_KVM_IRQFD_H */
-- 
2.50.0.rc1.591.g9c95f17f64-goog


