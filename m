Return-Path: <kvm+bounces-42695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2057AA7C437
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:53:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB7533A84B4
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74AE21E098;
	Fri,  4 Apr 2025 19:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fGegI5Dt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B99D222570
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795604; cv=none; b=eYEhLv1zNdE8QPBwMli8WoryhfVzOvUIvS89+enz0dC6oiCIph2lHJpbpfKBUIi6ZncX9IuoGa86iVPJ347MloXhjn5k1ncjVAbtMf+fd6USC4Fwtr9ABP8Ah5hDSYqSfMbgphXCTdypspmYpkAhxv2+bADHOPqN5WT6iSd5/oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795604; c=relaxed/simple;
	bh=Gz9aIMimbdwkNGt7OPfLnkRhIKwp18RPumjkvSLqEHM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=faqdFFfZAFIVvH0i+nueJ+0+RCqc5TJoTAJHTWLGzhkI/MybpbY3ma64//zH5Hiab4TfGsMtvVrg9I9+FilA5fjDndWIplzDA2RSCFVWIJal4QRX2CR2i1X/Kd1y2MoHTyA2tNfoCbRI60/UjnKDISNbTSDOqt/Ki4aGP0HNFBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fGegI5Dt; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736cd36189bso3496700b3a.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795602; x=1744400402; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NJ2AwZ96IG0rnLVApDhmCehhnZWDzfbxNCDQQeJNmJo=;
        b=fGegI5DtjFeDLuxNLMx33FbVQzftJpufxMA6mn6QfY8vuXHcD3A60A+5PjrH8vGLOw
         oNp24lRYo53CZmFT61DQABQAgt/JvIoVOynPM7is8YVUAwJJhv6CNLrFxsKSm3mcxZtq
         juAI1P4cpta82mI2OEFWCtlq3szdrgR/KTF7xkxfk1EwtZroORfeOVi2MsS9+tVgTQts
         NsfbJfIr+yb4DnbGtZJW9USwIinHxmbWaPlkx79M1e2YiRVnlxXYKsB9en+GKgtLL0UW
         bN0OWo3aS7h32TQWS7wHvWP75OMI01chweM66d/kYisFgEJFwO2aso2QGZfCxlGnUQoG
         1yYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795602; x=1744400402;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NJ2AwZ96IG0rnLVApDhmCehhnZWDzfbxNCDQQeJNmJo=;
        b=aI8KOpDeJ9ACucpKqxnkM+R/3BDssemAnl8MM+ha9peFDW6MVL+K9v56hWr2syP34s
         1ZreFrHsoAmYMc0xPDASwfHUN4SuqOm07Tx822rPEFsDx76tETDOisyYliCzDOaOtCs2
         WcxGs4VDVsi7PtHp9/aRITo7pQy70/NcOo0c8nLTq/3rLyPC4/M5ZAkQ6UJ0H/Q5jHtM
         CLA7WLze9Zm0bMQaXoSXp4ivepeTMqIPsSBELI7xQ1gTqzOtqrqfbrNVBn8jecsPHX/i
         CwgnOJaWZFQnpayQuH+ePsfLuoOjE8tfFiLzpxuyd4vdxJ9L1fydj7ZOzAVB9yUFbjKK
         JEWw==
X-Gm-Message-State: AOJu0YxZt2kF3LDZpWqbc9q8GXN10iv03GfE57Cc9sp0eQ5aiX/PEvib
	4I4JtEQQsss1ywDiMsTNSBcu8lLs1MMpcSP29xcZO+54bvcvVm+5zENqz7v4q1IkL/N3vHbnPPX
	JPw==
X-Google-Smtp-Source: AGHT+IHUTfAFvmnRXzxBNmSCJ462dhgG2sdJTjm66unWjPqXxcSiOT2PYCNJZf1pPqjK0XlU7MmQ9tlS5gg=
X-Received: from pfmx24.prod.google.com ([2002:a62:fb18:0:b0:736:5012:3564])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:13a6:b0:736:42a8:a742
 with SMTP id d2e1a72fcca58-739e4b4aa8bmr5807564b3a.11.1743795602558; Fri, 04
 Apr 2025 12:40:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:24 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-10-seanjc@google.com>
Subject: [PATCH 09/67] KVM: SVM: Track per-vCPU IRTEs using kvm_kernel_irqfd structure
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Track the IRTEs that are posting to an SVM vCPU via the associated irqfd
structure and GSI routing instead of dynamically allocating a separate
data structure.  In addition to eliminating an atomic allocation, this
will allow hoisting much of the IRTE update logic to common x86.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c   | 49 ++++++++++++++++-----------------------
 include/linux/kvm_irqfd.h |  3 +++
 2 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 04dfd898ea8d..967618ba743a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -774,27 +774,30 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
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
@@ -811,25 +814,14 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
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
 
@@ -844,10 +836,9 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
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
@@ -951,7 +942,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			 * scheduling information in IOMMU irte.
 			 */
 			if (!ret && pi.is_guest_mode)
-				svm_ir_list_add(svm, &pi);
+				svm_ir_list_add(svm, irqfd, &pi);
 		}
 
 		if (!ret && svm) {
@@ -991,7 +982,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 
 			vcpu = kvm_get_vcpu_by_id(kvm, id);
 			if (vcpu)
-				svm_ir_list_del(to_svm(vcpu), &pi);
+				svm_ir_list_del(to_svm(vcpu), irqfd, &pi);
 		}
 	} else {
 		ret = 0;
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
2.49.0.504.g3bcea36a83-goog


