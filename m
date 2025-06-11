Return-Path: <kvm+bounces-49184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E5CCAD6348
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22CEC7AE530
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B65BB2E7F23;
	Wed, 11 Jun 2025 22:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SJbNvcNL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88F62E7643
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682083; cv=none; b=gkonBBa9w6RjlkN3YnAQAJ7wg7p6RVFYpTXiCpbBdyGO4UjPkzSY4x4ceOXTaip9UlhwxeymJKZFIY+aEEx+jqWj5CuybJDgSIFXujGcHj8iA8aZTZ36yEIzwSmvV8eHwCUrL4L/UpD5yKV8qLmxINprkzhr+9mvnnLdtQPNEiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682083; c=relaxed/simple;
	bh=WraQrAhKy40fzLj9OcdqnlOGw8M2B9DE9LsghuQ3E1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NJdRfi0ud5B/qPbWoTOFnGXeYu6ArW+UyeRtiZ7iXwqA8TG3xG6iywfzZhK5eG+U9l3pJ7O2orBX3y0NqFXSL6mhJKDrBPSAjvhpO9Pnj4R3dcPsOnf+NqLQU9BzDTrmFrvs4YMeymQ3+e8dmJx0Cyjl1HZHmaHzNXeuE+LsFPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SJbNvcNL; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-740774348f6so255559b3a.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682081; x=1750286881; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UuyKkic3LG8prk2hzqTBzKdxaSLkUa8zFIKnG1Vnzms=;
        b=SJbNvcNLdKHT4TmdNhicfO+y8BS8i+6tGS40yXypDCNt4cF1eTHE2XAOxEyrABLhyA
         l1+xKAHtM6CFNpEVIEqAYsJPVuTrR4L0rbImG+AzU/oCxlUC0OuLMm7kXuIEKJ78taOI
         Uz7u2wOolEDj9v1xw+kWJDwB3Rxr9ySadvlmaU9FHjEGQGFVo2WRgR8X9EZALHb3evhz
         9LUlzNJBYqKelAOlfontACUD8EPmejfya4Ii6n7dTcywmfGyqezSr2Lwhy3pNSYsTa2h
         vW41G9yO7TDZNv2meVgKvrblFg+bZt2MB0HrTQ28bE6RR8UYCaOlUudFXH2Y45oi3WGi
         pD8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682081; x=1750286881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UuyKkic3LG8prk2hzqTBzKdxaSLkUa8zFIKnG1Vnzms=;
        b=TvweuKkdiRGPI5t4fGprVCVEriLpphOXhDA8QmMLA5tpJdtHRcKgfFkcPrMKlg/xok
         oWvnTYBesxqLJi5HkJUEd24s/O2spC83c/Mn9J5xHUAs5YdNLgykWZaynJ2Wm62VY3Xg
         6kuGL4D81NVHyvLLPSZSFGTeVdBUkDVeiT8MbTv+Glts4FUHiBvyANhHfEb87fTsv9GB
         o4586b8SvCXz/6Zpt8j/cj+EUmYQBbVE7iwdUkESFLt2KyvHuOmudNsZ4ju106veyEvb
         x4Y89RAg5OKL8/8g2xQJ3BwxnZ4s2jhhiFdU0H/RXOetP5xPUB1cRVlczHA+03V8QR33
         tMFw==
X-Forwarded-Encrypted: i=1; AJvYcCUPAklQOlQCl4Yn8Ookyh7aHt7mP165UT3f2L8RaLAsO4N3/TADNTYONKQup69uZgabAY0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjYYSkT9/Al5NvVLLObHyu3cEIMcDQdJh6rexBPYDqLXRmk3F8
	g5WlXf+HQbRHuoKpzhJBiEu5W+KGdSOKW9x3Uqw0Lf8AydOcV1ZhX0JeYLPvV1ewhYLi6hvnrga
	lK2tuRA==
X-Google-Smtp-Source: AGHT+IH6Bg4QxP54+67PeSK08rS7fAvMkGbt5o6MmB1679Zom5LQy5Ttbbd7/GIAhTEMvGP3EkZo+NqlUao=
X-Received: from pfbhe19.prod.google.com ([2002:a05:6a00:6613:b0:746:19fc:f077])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:b90:b0:1f5:7eb5:72dc
 with SMTP id adf61e73a8af0-21f97752d70mr2227346637.3.1749682081378; Wed, 11
 Jun 2025 15:48:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:41 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-40-seanjc@google.com>
Subject: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock across IRTE
 updates in IOMMU
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

Now that svm_ir_list_add() isn't overloaded with all manner of weird
things, fold it into avic_pi_update_irte(), and more importantly take
ir_list_lock across the irq_set_vcpu_affinity() calls to ensure the info
that's shoved into the IRTE is fresh.  While preemption (and IRQs) is
disabled on the task performing the IRTE update, thanks to irqfds.lock,
that task doesn't hold the vCPU's mutex, i.e. preemption being disabled
is irrelevant.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 55 +++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f1e9f0dd43e8..4747fb09aca4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -769,32 +769,6 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 	spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
 }
 
-static void svm_ir_list_add(struct vcpu_svm *svm,
-			    struct kvm_kernel_irqfd *irqfd,
-			    struct amd_iommu_pi_data *pi)
-{
-	unsigned long flags;
-	u64 entry;
-
-	irqfd->irq_bypass_data = pi->ir_data;
-
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
-
-	/*
-	 * Update the target pCPU for IOMMU doorbells if the vCPU is running.
-	 * If the vCPU is NOT running, i.e. is blocking or scheduled out, KVM
-	 * will update the pCPU info when the vCPU awkened and/or scheduled in.
-	 * See also avic_vcpu_load().
-	 */
-	entry = svm->avic_physical_id_entry;
-	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
-		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
-				    true, pi->ir_data);
-
-	list_add(&irqfd->vcpu_list, &svm->ir_list);
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-}
-
 int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			unsigned int host_irq, uint32_t guest_irq,
 			struct kvm_vcpu *vcpu, u32 vector)
@@ -823,8 +797,18 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			.vapic_addr = avic_get_backing_page_address(to_svm(vcpu)),
 			.vector = vector,
 		};
+		struct vcpu_svm *svm = to_svm(vcpu);
+		u64 entry;
 		int ret;
 
+		/*
+		 * Prevent the vCPU from being scheduled out or migrated until
+		 * the IRTE is updated and its metadata has been added to the
+		 * list of IRQs being posted to the vCPU, to ensure the IRTE
+		 * isn't programmed with stale pCPU/IsRunning information.
+		 */
+		guard(spinlock_irqsave)(&svm->ir_list_lock);
+
 		ret = irq_set_vcpu_affinity(host_irq, &pi_data);
 		if (ret)
 			return ret;
@@ -839,14 +823,19 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			return -EIO;
 		}
 
-		/**
-		 * Here, we successfully setting up vcpu affinity in
-		 * IOMMU guest mode. Now, we need to store the posted
-		 * interrupt information in a per-vcpu ir_list so that
-		 * we can reference to them directly when we update vcpu
-		 * scheduling information in IOMMU irte.
+		/*
+		 * Update the target pCPU for IOMMU doorbells if the vCPU is
+		 * running.  If the vCPU is NOT running, i.e. is blocking or
+		 * scheduled out, KVM will update the pCPU info when the vCPU
+		 * is awakened and/or scheduled in.  See also avic_vcpu_load().
 		 */
-		svm_ir_list_add(to_svm(vcpu), irqfd, &pi_data);
+		entry = svm->avic_physical_id_entry;
+		if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
+			amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
+					    true, pi_data.ir_data);
+
+		irqfd->irq_bypass_data = pi_data.ir_data;
+		list_add(&irqfd->vcpu_list, &svm->ir_list);
 		return 0;
 	}
 	return irq_set_vcpu_affinity(host_irq, NULL);
-- 
2.50.0.rc1.591.g9c95f17f64-goog


