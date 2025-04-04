Return-Path: <kvm+bounces-42725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E10E4A7C483
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55AD77A4AAB
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 20:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AECE233730;
	Fri,  4 Apr 2025 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3j+Tjnhz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37AB22173D
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795656; cv=none; b=btjD+5uorYgbPviwvGElnqrGDDgoLlHZR2rGiUdw+ZFM0CiO8pAm+z7OrlcN4X8E8tLk1af/HiMm5jf2QZwp0AZ9pcm5y8aRCNBi462YWfujMA3EdArhuLRUgm9w79NsIrvp5/cSaayX1srZm9R/PyGl77jabTOIahYY6rj8LCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795656; c=relaxed/simple;
	bh=7iUSFx5D3yR25IHThTgAc/IOAW4zYfJ9SgblmRez7ms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jh72X8sP2YDNc6tls+sofbIVHGJQShNgUr22uPQ1VFwlJJ4vE28i+NL7XtgvmOG+wiMkIau3w8cPPn6Y9xRqKVsfI395uTfuuhljGsuOErdzyuO1bpj6r+QNm1XiwLHlgD1ZZDYXwpUSlg49BzOg/aaclvZXRl7eQhg+B4Htiu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3j+Tjnhz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff58318acaso3859465a91.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795654; x=1744400454; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4e9ffwdEp7Gqw+G1mVFy+m5vTrdwBux5yCWrxBIAEu0=;
        b=3j+Tjnhz8z7z2FPkWIJ8C7hlfq8ctahfr5jeWFcYVCJoJIODcyQL3hir0LYRfPKa6F
         3r45gAHbDP3tGpZlqgOl70ylZrxke5A8E2ycuOs1WtHCwkUfaer6urwWNa81EJ/4w//A
         6jueSE00wS8RSFvhdSXy/mt0zKH1SSkRxOMmAaSSay/4xdON8qV8Ug7ghZwyGrgDuMNV
         69HYIu8utRw0G5dR3Cjvexa2sTC8gpAqy9dHcyM4S68nWp4Q/pOqeItpYxZJP0wcTNqJ
         bazR+1EUr9Q3gn88fE0AE3q4JzugSbNVUusayJ8unhlJQ6OssWLen6ANSdPro8/OZk8a
         eIDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795654; x=1744400454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4e9ffwdEp7Gqw+G1mVFy+m5vTrdwBux5yCWrxBIAEu0=;
        b=JNG7tb+HgmJkZbfLGu9TrBADXMvMg6QovVjboR23GMggrqIWugxD5EM5j8CxJ+Thxp
         v6pRvekwPCJQq8/QSXb7+/XlNg7BZ1ckdj0djhcXorFk89mIEfyLAjX5g6Z9Gt7U3oqh
         YCbG+7K6HbpfagV9LuOe+VZWoq0QK4z26e9joBJQfk9WkOaXOmFxsT8vWEZqSDX+3QWM
         B1+MvWwyLTiDVdMBPORwp6ZENGWlsZcp4yYlYJnyc8gqDFA/V0KBfmY18nijYxz+9YNr
         HUBu42R0T069nY+OcMIUXlvfkM3WowOM/Rme+BzPPv40ibS/hJrD3ph1V/a3tlwA0+lW
         WpGQ==
X-Gm-Message-State: AOJu0YyXsEYtN1ASyQEn+MEHxJW/xfjyEBhQ27g4N9aqeoiZSPxkJoRV
	GwrTwIgpovpJA6pW2wWExQpt6ok0Ww0UR5+AeOER6m/ghSv0V9jDVCJ70dLu6bDLx5T2v4BTyuW
	2fw==
X-Google-Smtp-Source: AGHT+IHq0WDQdQXdmkR68srWyYUi8Jk0ER178ssR+69T3RU1Hrt5+d4NUY61J9tgaeNmx2ouyINmHwrWyBg=
X-Received: from pjbqn3.prod.google.com ([2002:a17:90b:3d43:b0:2fc:c98:ea47])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2d0:b0:2ee:d193:f3d5
 with SMTP id 98e67ed59e1d1-306a6120999mr5163910a91.7.1743795654132; Fri, 04
 Apr 2025 12:40:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:54 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-40-seanjc@google.com>
Subject: [PATCH 39/67] KVM: x86: Track irq_bypass_vcpu in common x86 code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Track the vCPU that is being targeted for IRQ bypass, a.k.a. for a posted
IRQ, in common x86 code.  This will allow for additional consolidation of
the SVM and VMX code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 4 ----
 arch/x86/kvm/x86.c      | 7 ++++++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 355673f95b70..bd1fcf2ea1e5 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -776,22 +776,18 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 36d4a9ed144d..0d9bd8535f61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13604,8 +13604,13 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 
 	r = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, host_irq, irqfd->gsi,
 					 new, vcpu, irq.vector);
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
-- 
2.49.0.504.g3bcea36a83-goog


