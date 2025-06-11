Return-Path: <kvm+bounces-49183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B58CAD6350
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87ACD3AB450
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F4C2E765F;
	Wed, 11 Jun 2025 22:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LnikrU/w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4C72D6621
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682081; cv=none; b=reAUjNudsRxR6dAOQe1iAkDjFmQeENJIGzCLvtYqjq/uDT3uojg+Pd8j2mGqBT31IYTT4pggBYmbdcvc8qhZ2DI+fLKVP28IuAOctOfsk+4Ve2P/d9Ha4j94jKaDIXhB4FAHahBL+yYn2XqocsORVbNogKk3fyfJb4mOW74No3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682081; c=relaxed/simple;
	bh=RgmzZvbjCfA1K5gasv3IPOtqiGQBqzN7YP3Tbk95zwo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oLdV50YT+Kb2U+yQnVXNzOnKQ/TzwQ/muYj98a8t8aPRVPoh1BfT8BBaxdEsFld+tW7nLG6p10d4iZx3BlH/9xrtEuZu1rpURIH05M2Sn3sus8KMmvXED5ftOkZWRiUeSBNVP1t3KeVQJv2Q2GQeS62f7zzEthg9ymA3tNNvqnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LnikrU/w; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7377139d8b1so263434b3a.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682079; x=1750286879; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=v1flKB2rjVjkv7C0HFQg1l92d+sykuVaruHJBCaF8LA=;
        b=LnikrU/wnoafU3QT+4pGuISqL9pyjLGQvR2u2lXGEKWE/9j36N7THGhqUUmAVvXzgF
         pdUYyCSdhFWY2lKPXTHftlPRyGBpDPIk2b8TIN3JeJaAjVmhkuhbmehY1FMypMVClyw2
         cJu20/IMPwwoO3eLSsvZEKxBR8rit0ju6d73W0PblasKX2I0/FMbPcvCorsA20VrZxf/
         0M9x7ieq5OB4CezXg2mFt2FBsWx4JIZccgZeyrixCxTmtKs8GqpOYPtpE0gCzpQYMm18
         ts4EEAY2DohMzC88wSHeD+6fOhvu6fZ3J+KBFW9RfVglJBHVVYrqbtu5mzqA9rzQvEd8
         wcKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682079; x=1750286879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v1flKB2rjVjkv7C0HFQg1l92d+sykuVaruHJBCaF8LA=;
        b=P/lL0o2epVqZysqwFYOxAs7bbhRG8VndfyncLse7Qbh5IrTAjfZ3F5t3jhvh7TTnR6
         bFHv0gZhDIA7ZcwZLxeAhS+hiAX2mtx7VRVxSPszIZybKepShaqA0iPSoTOeRfJmHk5/
         e+e0yk/9BqLyhiK+M46veOUhVxTARJQ3XyX8wT6Ws7brporEcYHLINcuUEo52AGEJ/7u
         L86eLDit0SFmYs4RzAHQ6p+rqpGrKg6ueRQHcHn86UGnqcF5x0iyz8EEI3cP1ZgINSNp
         dYoMUT6zQOIQCvZcQRVe2KNbTfySu1TMKk1ZbY6wtcwvQakBT3euDImu7KTZPCYRo94l
         E05w==
X-Forwarded-Encrypted: i=1; AJvYcCVNsjFtsiw3p79VxlD4GoelMQUIXkwXhGcpV8Rg2LA/JDyDSeqI0NcnRAf+OJMG9+S/rA8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqCR0h3WTPb9TWrp63ygPAfy67sj0TjzbbfxpX5Bc6h99iM9YS
	zAsRpLyUlZpZhCSjxL/NmWSsmONrPchvtM7/QVfhmK1eTQmQ8B+XgprhsZ0VUiVtXOQ0bGd4PHY
	9Q7ul9Q==
X-Google-Smtp-Source: AGHT+IHuGa3sQaIRlgIMVwUeJGMvQqMviqpQnF96PVE++cQNjn6g/w0sfScCYFw1komkaHU5/0t+EZgb2Qc=
X-Received: from pflc8.prod.google.com ([2002:a05:6a00:ac8:b0:746:1e60:660e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:14c3:b0:742:ae7e:7da8
 with SMTP id d2e1a72fcca58-7487e0f4792mr1105962b3a.8.1749682079546; Wed, 11
 Jun 2025 15:47:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:40 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-39-seanjc@google.com>
Subject: [PATCH v3 37/62] KVM: SVM: Revert IRTE to legacy mode if IOMMU
 doesn't provide IR metadata
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

Revert the IRTE back to remapping mode if the AMD IOMMU driver mucks up
and doesn't provide the necessary metadata.  Returning an error up the
stack without actually handling the error is useless and confusing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 97b747e82012..f1e9f0dd43e8 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -769,16 +769,13 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 	spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
 }
 
-static int svm_ir_list_add(struct vcpu_svm *svm,
-			   struct kvm_kernel_irqfd *irqfd,
-			   struct amd_iommu_pi_data *pi)
+static void svm_ir_list_add(struct vcpu_svm *svm,
+			    struct kvm_kernel_irqfd *irqfd,
+			    struct amd_iommu_pi_data *pi)
 {
 	unsigned long flags;
 	u64 entry;
 
-	if (WARN_ON_ONCE(!pi->ir_data))
-		return -EINVAL;
-
 	irqfd->irq_bypass_data = pi->ir_data;
 
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
@@ -796,7 +793,6 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
 
 	list_add(&irqfd->vcpu_list, &svm->ir_list);
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-	return 0;
 }
 
 int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
@@ -833,6 +829,16 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		if (ret)
 			return ret;
 
+		/*
+		 * Revert to legacy mode if the IOMMU didn't provide metadata
+		 * for the IRTE, which KVM needs to keep the IRTE up-to-date,
+		 * e.g. if the vCPU is migrated or AVIC is disabled.
+		 */
+		if (WARN_ON_ONCE(!pi_data.ir_data)) {
+			irq_set_vcpu_affinity(host_irq, NULL);
+			return -EIO;
+		}
+
 		/**
 		 * Here, we successfully setting up vcpu affinity in
 		 * IOMMU guest mode. Now, we need to store the posted
@@ -840,7 +846,8 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 * we can reference to them directly when we update vcpu
 		 * scheduling information in IOMMU irte.
 		 */
-		return svm_ir_list_add(to_svm(vcpu), irqfd, &pi_data);
+		svm_ir_list_add(to_svm(vcpu), irqfd, &pi_data);
+		return 0;
 	}
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
-- 
2.50.0.rc1.591.g9c95f17f64-goog


