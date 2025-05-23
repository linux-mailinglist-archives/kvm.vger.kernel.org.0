Return-Path: <kvm+bounces-47459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3955AC191F
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2157817C3A8
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D236223710;
	Fri, 23 May 2025 01:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0gbdXoOn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE189221FA9
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962028; cv=none; b=iTkoutS3sG81Ue9bfVwb/ONBwuZOSUoGdZdGgMfmT/87Zp0LXIuYywz6Erzc4G/cNFDAXXpYoghTK2LsUtRY8bvrkk7w1Y+3CwoQT1FTzk/kNkdIPAzHinelnpU2iuNGskGPTJQx/KkQczTf4y6wgnxf1vWkpT0xH/+M+Wzxd+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962028; c=relaxed/simple;
	bh=j0ASWP3bWTrNWVjsJSKCYoX8Gmsgdig5lrhdNEmpSMQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OR+Au4P/YM+/uNz86Kg5coxAHae04QjMuraUDH9QVhtXQKWGPVDU2XDXSrDo3boZcD3Zk6u8PQZIwf6vM4RIxx12iDkIinzGptPHKiKq3yT2m1K5cXkr8Xx3a7E52O9NN4pepHkGs457rTOqX4oeQ05jDQKw7pBzm2IICjLZ18U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0gbdXoOn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e9e81d4b0so8245869a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962026; x=1748566826; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HLLwB8uaam+w+auGeOJdoWeeiO/rpte3+zLDk0hPf3k=;
        b=0gbdXoOnbnkwvcfdi5czcvmS1vEb7+1V79ug5irBpATMiHlVvJOk/JGVeUYnrVnYr6
         OvdSlGoHwaNpHb0VNTWiP2RhPCaD3+qJ+7CR0GBDfjt+OfY+uliHueDdLQFeNxC4o1uJ
         EH+W+l1/cPsm/DGp2QFkhSWXbThY+MQqwckRuggH+EC3OgAlrGvix2GFiAk6Ma5m+cV4
         lzuT/xP6vM8Fkg+/9Z+zVXYhFiC65Q40ebG+vICbuOqBuZ34dPiAPqWwI1Ykl7w3I/H+
         ACUNXJBZ0T5AwXq+w9VQ/z6hxBxKw1aSQDvQFSpUEjX0Zh2es7bHcThQlby+HrYgcVwS
         2VMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962026; x=1748566826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HLLwB8uaam+w+auGeOJdoWeeiO/rpte3+zLDk0hPf3k=;
        b=OceWJmowEPZ6SYthe8eqwkbstTO/VYRXT5IZ0tNXn/DVITHKKM7hVI8MSvw4PyJXjr
         4YNpa1b1O70rYUOyaPIPXsElRiM4NPIWXZ4Dcdv+kEvmVPXCwalTXM4QR/MyilURarwK
         6KSSxQ3istxkk8h9kmbJWOAXr1L6bKPuBk2pJA/YoYtikrAZyP3g0FhRT7cR82Gf37/0
         XeYdePtByVwjdoWuC1/LY7blb2MRfHhZEXtdoW+MNkp37dKkJjdZxegv8S8As5NPYeQo
         9bV9UJG76KLrRVsqg+3cxuKQNLamXy8tSsQLc3J4o/2zcIZPGIpgxtSmwkCxxsayGoFP
         uuQw==
X-Gm-Message-State: AOJu0YyknP6VoK6es3rpS1zRfqUMhgJl6di44lzty5/D2KVWCLYTp245
	oAaTngDbW3GGtEYz3BMabVQLrxgBw8cP2MtiNtfyxSNAGvHRSflQTflZz04co7upI7QBY96yiHV
	yJYzkog==
X-Google-Smtp-Source: AGHT+IFfuPhNF4QHWjfa9+uUgFQmIGeujJj5PfNmNyVQGzTqn6A2kUoJFJoVip3tZ9o2B4MRTJUIsR9I0NA=
X-Received: from pjbrr6.prod.google.com ([2002:a17:90b:2b46:b0:30a:89a8:cef0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e18b:b0:2fe:a515:4a98
 with SMTP id 98e67ed59e1d1-30e8323ecdfmr32685566a91.31.1747962026242; Thu, 22
 May 2025 18:00:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:14 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-10-seanjc@google.com>
Subject: [PATCH v2 09/59] KVM: SVM: Drop vcpu_svm's pointless
 avic_backing_page field
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop vcpu_svm's avic_backing_page pointer and instead grab the physical
address of KVM's vAPIC page directly from the source.  Getting a physical
address from a kernel virtual address is not an expensive operation, and
getting the physical address from a struct page is *more* expensive for
CONFIG_SPARSEMEM=y kernels.  Regardless, none of the paths that consume
the address are hot paths, i.e. shaving cycles is not a priority.

Eliminating the "cache" means KVM doesn't have to worry about the cache
being invalid, which will simplify a future fix when dealing with vCPU IDs
that are too big.

WARN if KVM attempts to allocate a vCPU's AVIC backing page without an
in-kernel local APIC.  avic_init_vcpu() bails early if the APIC is not
in-kernel, and KVM disallows enabling an in-kernel APIC after vCPUs have
been created, i.e. it should be impossible to reach
avic_init_backing_page() without the vAPIC being allocated.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 6 ++----
 arch/x86/kvm/svm/svm.h  | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index c36f7db9252e..ab228872a19b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -236,7 +236,7 @@ int avic_vm_init(struct kvm *kvm)
 
 static phys_addr_t avic_get_backing_page_address(struct vcpu_svm *svm)
 {
-	return __sme_set(page_to_phys(svm->avic_backing_page));
+	return __sme_set(__pa(svm->vcpu.arch.apic->regs));
 }
 
 void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
@@ -281,7 +281,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	    (id > X2AVIC_MAX_PHYSICAL_ID))
 		return -EINVAL;
 
-	if (!vcpu->arch.apic->regs)
+	if (WARN_ON_ONCE(!vcpu->arch.apic->regs))
 		return -EINVAL;
 
 	if (kvm_apicv_activated(vcpu->kvm)) {
@@ -298,8 +298,6 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	svm->avic_backing_page = virt_to_page(vcpu->arch.apic->regs);
-
 	/* Setting AVIC backing page address in the phy APIC ID table */
 	entry = avic_get_physical_id_entry(vcpu, id);
 	if (!entry)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index cc27877d69ae..1585288200f4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -306,7 +306,6 @@ struct vcpu_svm {
 
 	u32 ldr_reg;
 	u32 dfr_reg;
-	struct page *avic_backing_page;
 	u64 *avic_physical_id_cache;
 
 	/*
-- 
2.49.0.1151.ga128411c76-goog


