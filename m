Return-Path: <kvm+bounces-42729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02A90A7C481
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2988E17E9E3
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 20:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3732923A99A;
	Fri,  4 Apr 2025 19:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C30Ju5lJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A100238D22
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795663; cv=none; b=KP//TeYW8YUU+lkrpHVtl5m9HrYL6n6CrC1b7wFJbel/rE+hE//+JGroOUNVDpIdA6cIzb1U9R9/g9wJquijbpu9YUCJUWJnGgwxWnvj3ch3DqByJz3Joh5h4YN4kSBT8OQUQiVE1qE+40CfSsWNN6KV7E/sAWvMUU5X0PbIYZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795663; c=relaxed/simple;
	bh=7VgjiMaGTFBOMGgiyqbv9zdOnH8E7mg/DuwwYhcUp9g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TxUxcAmO+5qmpqXxSLl5i43EusFnqpEHFEMo85Yh+mqqO/acBk2sIK+Pw1aE8Fp+aTHusKKiAa/KyA1CAJgpp4vbAKvB+qkVKo3Lnae65Kt4Btja1UK/bPti1NrVaSIo5zw/7rE9WE3WY/l8+2b2tgdJ/CRn7q5ADknz6kDWRNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C30Ju5lJ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-225974c6272so19010675ad.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795661; x=1744400461; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=h02XDjR76RTBA1GQO1S8bkavF6bTLez7Lecbdt0M7Kc=;
        b=C30Ju5lJnOdN+aZrtTVvxLcpeQphpV9GRM2tvQb7MS/xe0KwAwVbsrxkm3dt3/tIeX
         wgMFIk53meFe4A9CfzYiZOwC3NdSmNgYcr2GQFT5Sr2V5lNsQnW0FHJBw6PYEGfQoMjg
         eoLVPAkIsxY0wjbk8ncvjTW+9ZytnMrG33QkrBmgr+mO2wCSdF4Qp72QsBMciFDwhTRO
         O/AcF7tIgnH6Xozclm5haGELTErC/2w9yJIXOvn25C++eJcrPoJ5KyG6+XVJyYbtOpfP
         YBsfpoyu0vGjrle60ilCP67/FWZEXFmyQiUwWCLl4VWeTjClGUFmsvzVdnpLDrch0guN
         MXzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795661; x=1744400461;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h02XDjR76RTBA1GQO1S8bkavF6bTLez7Lecbdt0M7Kc=;
        b=Ngok4WhXlIgTng72EFH9tuYLJMgnT13ZWG3vV4KuSiGIkq5MXxNcI1PVMP4ARwN4MQ
         GoAr/BWdPE+PWb0nRSsAw729qOwLOR7Lmvvq9lUdNnYlb60oUNASMycT3yqHo/yB0E9Z
         byWs38kaWe2nb5+6tBG1QpcZXzkvLBjNgf8ihMKl3Di99dI/D2WwsGSbvGbWt9fEV6OY
         563cwV1hhpgDPyn14qf3bnTMhxr/0LyiLVKnPayComCrY1pwQVqP62+UJKxBlC662dhs
         BZ4VXT4yK1NYr03tLt9QAngXPdRVFc6TFppT3PLM2AX6WZIN90wzKTWGsXiocQMyliII
         bI2g==
X-Gm-Message-State: AOJu0Yyuip/cfyWkj+7VKuQ95rysPl0/68lQPb+V2ASTPz1Koe6AZgYm
	89G+AwrDBedE/VroMz0Lydg90fqQNLhSGlgGIpSSX+6FlKf1nauKGmWudH1x0B2fwQvPFIeX2Zr
	/5g==
X-Google-Smtp-Source: AGHT+IEi0ecP0t6WaN3K44IuMTG4PJkM768UFLXNdGKuUWq2dVHcpJjFVEGtG9zdypCiTJZBV1oUciTfEUw=
X-Received: from pfbgq31.prod.google.com ([2002:a05:6a00:3bdf:b0:736:3e92:66d7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:18e:b0:21f:6dcf:fd2b
 with SMTP id d9443c01a7336-229765a4fd7mr111593955ad.1.1743795661006; Fri, 04
 Apr 2025 12:41:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:58 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-44-seanjc@google.com>
Subject: [PATCH 43/67] KVM: SVM: Take and hold ir_list_lock across IRTE
 updates in IOMMU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
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
index 22fa49fc9717..4dbbb5a6cacc 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -778,32 +778,6 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
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
 			struct kvm_kernel_irq_routing_entry *new,
@@ -833,8 +807,18 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
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
@@ -849,14 +833,19 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
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
2.49.0.504.g3bcea36a83-goog


