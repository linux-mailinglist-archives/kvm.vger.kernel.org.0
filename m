Return-Path: <kvm+bounces-49180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F26AD634A
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C863F3AE20E
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78EC32BFC95;
	Wed, 11 Jun 2025 22:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L/bUNBmQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF51A2E0B7A
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682076; cv=none; b=FVcE+iJ7zwBOLDPMqq3W3FZrb9rcRMLeFQEQMBSlnE1g/JFvwryY3mcNIKXQzQ7DzEC6v7i8fDZ6F3sjNP3kQBA/ZqDACObrVeJ5hFoe/V/qEMZd1YTw8m0mzAzSyrJERJ/0+B6gJbAl8bePn73Q+chRl9FB16TXheTCA9lTVtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682076; c=relaxed/simple;
	bh=kywKfKPTKKbP5xL2C71yOUcn3SiU0Y8qTPlvnXK8BT8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UD2WaelGd6aRZoxA4iEi/s+fCC5WvUZITrSZgp8WNXz7ZOu+CbFIV4iuW6wfNJ+dMBj3Vih2OrOEBDmQpGVqEZqulkZGUgEgXNBOfCxJ6rF9QvGvscjE5z6sxAhwYomQ3dtnNInEPet3EeZFZtCpQP9cOTPLXCJ1nd4d8kKgtGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L/bUNBmQ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2358de17665so2295355ad.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682074; x=1750286874; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=t1v5tfF/UZZJDfH96jk5AIZx6aa1AacPrxrUndI2qrI=;
        b=L/bUNBmQPQferoAqoy2cLDu73Tc/emyawOvHOFWh+nDY2YDuzp5e7bKXncIPHtuoNo
         5Vq7n4fFqvBQV2gb1Rp0PrtyOtk4vUc08rG7wv8RPFcVmBWMUOeYuV+gnfpMMtrCPO4L
         qKjOF27GgH8xGSSS1kOJcG/YiPoG0/jBm8Ly48NVfYR+uvjmlrmlrbg97KmoPxwR1/P4
         r2wZe+Dg5pdZemfFNE0SL249+KqYdSiYHBrAv1hCqUPBcQEKC3HenJaJtJz9l1fW+Ti4
         0pWEG/QH0irX+DC2I2rQtk9sD8o2EWJq6tHCWL1SBKcRZ6tnQpbG4kzrl0h5KucLS3Y9
         KS/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682074; x=1750286874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t1v5tfF/UZZJDfH96jk5AIZx6aa1AacPrxrUndI2qrI=;
        b=Hr/SSkzutUesovmnzHICnvYfuK6CUqUwSj2hMcFwasG60DO2/dmYlPMrGoqJRC5awJ
         DkTJ2t/6ZZsbMc3Wc0xqyRKhDwKuWxybbyjk0h8EQx4GFAM10E2nhg4rzz5KMrhK7YNF
         4yWkg26FyxW8oOf0T7GQ9xHdk9DqWQCd/CwCLcGd+ZweO3m5I8SyP5m1Ol3cYopeAcNy
         2jtL5dboNG5MVnN9SMJ39YOnRG4JKKX3f1pcPmV1qmer4kA/tEYAFZ1LyR6r2RfxpufB
         vcqPb8+aI0PmFPxN2U8bvQwqGYBkBBwrHxePwJs+JINAcZyvMSou+ir5zOTf1ZHJef06
         k4Ww==
X-Forwarded-Encrypted: i=1; AJvYcCXiTC7rFSV85Crfhb6fIn7Xggq8/iIhqrFlK0oBizfetuQ6kNdCKpH87SeThlXMOfYFSwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUkHQAwd6CUzaO7sysO8tA5xWlK863tmnt/69adfBwnsd5HPpr
	eE7aIqk/zrnVIyIxC+MMbm2T7dQO01lIDY1V9kscwWRFlD9pkoVUsQ/JEDO0mjzJniMCMvQHbCO
	tOgik9g==
X-Google-Smtp-Source: AGHT+IHIOpTSYBslk2iwZ1Yvx7LxGgsjWNiUHu2s2XYfcpOZTsc6ZoL/od1AWVcDdNAHt+Yg97+L8Wtz5XQ=
X-Received: from pjbta5.prod.google.com ([2002:a17:90b:4ec5:b0:311:8076:14f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f4e:b0:234:cb4a:bc1b
 with SMTP id d9443c01a7336-2364d90f8acmr10461455ad.49.1749682074268; Wed, 11
 Jun 2025 15:47:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:37 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-36-seanjc@google.com>
Subject: [PATCH v3 34/62] KVM: x86: Track irq_bypass_vcpu in common x86 code
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

Track the vCPU that is being targeted for IRQ bypass, a.k.a. for a posted
IRQ, in common x86 code.  This will allow for additional consolidation of
the SVM and VMX code.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c      | 7 ++++++-
 arch/x86/kvm/svm/avic.c | 4 ----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 48134aebb541..6447ea518d01 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -544,8 +544,13 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 
 	r = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, host_irq, irqfd->gsi,
 					 vcpu, irq.vector);
-	if (r)
+	if (r) {
+		WARN_ON_ONCE(irqfd->irq_bypass_vcpu && !vcpu);
+		irqfd->irq_bypass_vcpu = NULL;
 		return r;
+	}
+
+	irqfd->irq_bypass_vcpu = vcpu;
 
 	trace_kvm_pi_irte_update(host_irq, vcpu, irqfd->gsi, irq.vector, !!vcpu);
 	return 0;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6085a629c5e6..97b747e82012 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -767,22 +767,18 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 	spin_lock_irqsave(&to_svm(vcpu)->ir_list_lock, flags);
 	list_del(&irqfd->vcpu_list);
 	spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
-
-	irqfd->irq_bypass_vcpu = NULL;
 }
 
 static int svm_ir_list_add(struct vcpu_svm *svm,
 			   struct kvm_kernel_irqfd *irqfd,
 			   struct amd_iommu_pi_data *pi)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
 	unsigned long flags;
 	u64 entry;
 
 	if (WARN_ON_ONCE(!pi->ir_data))
 		return -EINVAL;
 
-	irqfd->irq_bypass_vcpu = vcpu;
 	irqfd->irq_bypass_data = pi->ir_data;
 
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
-- 
2.50.0.rc1.591.g9c95f17f64-goog


