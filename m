Return-Path: <kvm+bounces-49156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F283AD6316
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:52:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C634D188BE63
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238E228FFCF;
	Wed, 11 Jun 2025 22:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="noa33kDE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA6428BAA1
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682036; cv=none; b=kqHFIh/V1324Plvg7kyz0nEqHQpLyfFH5e9EHGEftA/nNAvA4zgOXP46ZfmXp1B+KCRdBz3v71hLJW37/U6JGW31xLeDgNxcbMqH4pt/i5yjHueAWcqIWeePBDszc1mfO48Yg11YknawrJS+v7wq5jej3QuK7AhPiDEozv2egLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682036; c=relaxed/simple;
	bh=Mb6/KTIeYaghJm2wWX89bXOimRdi1XnUBORRm/tOA7c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GTP+ypni2z7dXGRZrWp1JGd//U3+1QAjzvpEf6Yu0Lf9vrAoqZ60H1kQ+fei/Y1QkoMLgLhb75V2s7uxXq6JLpCbQZwfePYsv5aizZPrEggyp6DBGugNu3t7n1rXBRpLYP5TphT/GngYT7UpMiC5F+boPgSkzMomsadlt6C2L58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=noa33kDE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311f4f2e6baso327237a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682034; x=1750286834; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vBV8ONm1woYvPckJRib1WYeJ0sSeMlwaWEnLKoaPZXQ=;
        b=noa33kDE+JQekIOhgGFAVhbgIR30CkA3hWdBeuWCp6wxapv/J4sXWffDKeURO22rbW
         7uIKOql2N7IkJnQ/z8XzmNI/wArlLE3pJiIqd0Le+UaOiz74m8InxkvnDvQytDP/n6Fi
         0/TNPfwSAWcehAgBi1ahM2HeAenpuWVO1Ai163DH3cr0ciToHuEWSmYdkrb+7quZtFRL
         YesX/n58Pnf6cNxE2tnQ4u8ZqyXeqm32JGiBjndwXT3X7Zs/CHJAHrizzPxeI0jvUxua
         NyBVGf4fM9JoubivZE80/KXNsR4CoyjR8/rzq0iw/GZYpQhriytJi/57pqH0jFE2AO/W
         Ho9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682034; x=1750286834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vBV8ONm1woYvPckJRib1WYeJ0sSeMlwaWEnLKoaPZXQ=;
        b=kbC4T99XoY9Jh5rOH2qyUO4F+QF5b5AjqukGQaeMXUiYqDJLiMav3Jxba923hyNQvt
         1MJMAnsqjzav0kh5FGDvf8qgeKWzopadK+htP5RFaGSPgD5iu3NqxkImHilAhKgiTIVg
         n7pqhyLnLRiuN4V4cJvp2q8Ymxe8h7KIncXl0xUG+rRUCuuv9hBY8KKix89FoOgLV5Ry
         /ztDbpGFFOeNu6xRA0DWjtUzHMBbbmVz+mvc3QZiHPzHXF6LUIjKRZ/jJhCIrQF5XEaJ
         E9q6UQb8sQ4aA2LfMMyUUCxsTjRajde0LIQdiv9fmKeP4Q+VWv3Kew0JzSQbWYINLXu5
         yiHw==
X-Forwarded-Encrypted: i=1; AJvYcCUp5H9MSrl01lF9qOPOsX/YF3I87AMQ5AjMJoEM+D3h6p2b+a3bCm1hJAXndi+nt3QH57g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxupRoZODDj/EaIKH0e+Izoh/iAGzCgTBo0jBmnPyAIIMSjP+6N
	+qk5ZTXTN6MG3gqFR0Uq7dEsvluza5IaV0T/Bo6ytMPrhzEZqxgm7K3iabwe3luMLaHMrrSZS+s
	4ocS4LQ==
X-Google-Smtp-Source: AGHT+IEPFYmZzXUCGlwdowyqWkn5bPnHZM+aDnI6sRBuhesrGFICkRbpeSKEZTLooo10gbnXC/Ab4llRnXs=
X-Received: from pjbsv3.prod.google.com ([2002:a17:90b:5383:b0:311:6040:2c7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d4e:b0:311:c1ec:7d0a
 with SMTP id 98e67ed59e1d1-313c08d253fmr1028886a91.25.1749682033852; Wed, 11
 Jun 2025 15:47:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:13 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-12-seanjc@google.com>
Subject: [PATCH v3 10/62] KVM: SVM: Add helper to deduplicate code for getting
 AVIC backing page
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

Add a helper to get the physical address of the AVIC backing page, both
to deduplicate code and to prepare for getting the address directly from
apic->regs, at which point it won't be all that obvious that the address
in question is what SVM calls the AVIC backing page.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4b882148f2c0..c36f7db9252e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -234,14 +234,18 @@ int avic_vm_init(struct kvm *kvm)
 	return err;
 }
 
+static phys_addr_t avic_get_backing_page_address(struct vcpu_svm *svm)
+{
+	return __sme_set(page_to_phys(svm->avic_backing_page));
+}
+
 void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
-	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
 	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
 	phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic_physical_id_table_page));
 
-	vmcb->control.avic_backing_page = bpa;
+	vmcb->control.avic_backing_page = avic_get_backing_page_address(svm);
 	vmcb->control.avic_logical_id = lpa;
 	vmcb->control.avic_physical_id = ppa;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
@@ -305,7 +309,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(__PHYSICAL_MASK_SHIFT >
 		     fls64(AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK));
 
-	new_entry = __sme_set(page_to_phys(svm->avic_backing_page)) |
+	new_entry = avic_get_backing_page_address(svm) |
 		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
 	WRITE_ONCE(*entry, new_entry);
 
@@ -845,7 +849,7 @@ get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 	pr_debug("SVM: %s: use GA mode for irq %u\n", __func__,
 		 irq.vector);
 	*svm = to_svm(vcpu);
-	vcpu_info->pi_desc_addr = __sme_set(page_to_phys((*svm)->avic_backing_page));
+	vcpu_info->pi_desc_addr = avic_get_backing_page_address(*svm);
 	vcpu_info->vector = irq.vector;
 
 	return 0;
@@ -906,7 +910,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			enable_remapped_mode = false;
 
 			/* Try to enable guest_mode in IRTE */
-			pi.base = __sme_set(page_to_phys(svm->avic_backing_page));
+			pi.base = avic_get_backing_page_address(svm);
 			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
 						     svm->vcpu.vcpu_id);
 			pi.is_guest_mode = true;
-- 
2.50.0.rc1.591.g9c95f17f64-goog


