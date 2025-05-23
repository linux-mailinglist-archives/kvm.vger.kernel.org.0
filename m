Return-Path: <kvm+bounces-47482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 256C9AC1950
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89E0AA46574
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F48927D77B;
	Fri, 23 May 2025 01:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F6oWaVrY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADB227FB02
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962066; cv=none; b=hJPI2Iva04mGhVRH54wAaEnvCjOmfOTP7MM0VF7gy46IXV4Ng09i4EZpZxWZesVMPsyjj66ulT0vPCqr8SeV+UqDOeDyDtQ6WrjsGbX42xqVcv9wRo6Nl+lDFmG35mlRbXC7uDhOK4hELYuIkM1srZwMxqlvLWKbFKTtZghUu0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962066; c=relaxed/simple;
	bh=lF7pC8sohabNgcaIb1E8HB/O7nTwbIatU6uqVNQw5dg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DRHHGZZdv61rEQbDulNFCgmz0EtLbakvD3xbRBuaWe4SrHhA50NeWRX33acIRLNc2diq5A45h5qD7FhLc01JpouVtc675zksPzp8LB7EHfdBbw3HrViNv5/amKwBMzeRe8i7/qngeeThUPJ4iz319vhM+ByQhJ23RuT73BTBwRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F6oWaVrY; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26e33ae9d5so8986422a12.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962064; x=1748566864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VEEMumgPPOxuu5AKa6Opm2ERFPwrtqEfeM08GKoEFwc=;
        b=F6oWaVrYaVXLtdfVpgmSmF+lqbZFv3xWF3l9OcfkamoAEi3o6ABXB2eVhwo4RgOAvz
         /zxu+wBzoLoCdsNI5p9UOriY0tUA4PyQA0Hj1IzhyWZJNmQlBZEFeiOa47cpLIyKQYlJ
         t+KTWQspbYa/us7Q83VMfToKUgiz8ALSHgtuincC3Uwo6BxRmC81vJ/sqVnQLvSMrnnS
         YqWeHHiRiZMMMXAj2eiGMLgjvA7fqUBCZxUBxrCnlac2AyRXk9TwAq2i/pW2B+AIE7cI
         cwIaQjNa7gFod/JpBBe839ssb8uvwkOKMUePGzYvst2ZLxyoOUm9r9Y10esNVLkN5mbn
         aSwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962064; x=1748566864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VEEMumgPPOxuu5AKa6Opm2ERFPwrtqEfeM08GKoEFwc=;
        b=c6sm0GIhJDZuUdKCDIs1HQKr1mZwQC4mKNK21sKTS5EBIUz6VkyLystNugHvY6Lwkg
         g+HTejsVnxAy18E6YNqmlHt15+5x2VS9K/gP8MAVsyCRK9Y7aJcEWWG5ycs7Gd1eCfhs
         riKVnAPjfzlNsIgZXNN7ono9Fnd/NKx62l3SIBMpaCDb8LSBvKIFe/nmNDmLPzdAwmEJ
         msc9l2Z05sWnhZWyrtQh/0g/+BTOwyUsO4IVeqLby71PZZm9qWqGzbPzw/PN5y9APGap
         U17KqFC/wIhkKpj/zySHD2u3ngDIhkRIbXU2ThcmQwoyTU5/CiqS5nPfqoVuJnqJescI
         GbrQ==
X-Gm-Message-State: AOJu0YxCQuOO9j3K2inJcXXqzDOlil3Jb7iX2vvqzmSjeC1DJ0+w8EsO
	R2puFn2FMzEP39jwFpma3nob98cKEi87DBU8soDbGbXS0ITGnPs1DxaMZRiKlhudrMzxPMRvegi
	+VbopNg==
X-Google-Smtp-Source: AGHT+IETqKO87aMFsUZqxCg0LdZa+zJR5n+2fRyhOgSEe0vCrHKlfeYquaUmcKRaIo3hs3+dxPHGjYw4zFc=
X-Received: from pgbfq25.prod.google.com ([2002:a05:6a02:2999:b0:b26:e54d:d7dd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a129:b0:1f5:8e54:9f10
 with SMTP id adf61e73a8af0-2170cde51b5mr47706400637.34.1747962064242; Thu, 22
 May 2025 18:01:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:37 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-33-seanjc@google.com>
Subject: [PATCH v2 32/59] KVM: x86: Track irq_bypass_vcpu in common x86 code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
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
index 582fc17ae02b..3a0f28e98429 100644
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
2.49.0.1151.ga128411c76-goog


