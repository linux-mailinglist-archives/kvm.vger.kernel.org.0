Return-Path: <kvm+bounces-49157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD25AD6311
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 893237ABC48
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B7A294A0C;
	Wed, 11 Jun 2025 22:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aSIfgC8f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554DF28DB6D
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682038; cv=none; b=D7EQOZI6WAmsgSY9eHm8na0gH5AAWF/QZvpO70lmQ9kxOSyVYj9jZUybsQX/zQUmvdHPeUvqxwFREbImApfselEhPkO7xpk+D+7IF265TsB+usQI5Ll+dfP8js1/JZPUzlyz2VV+YIxol7+0/86Wxc13DwFL/paR+3xvTzbSA2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682038; c=relaxed/simple;
	bh=ZvxMee+M74yyMDCh1Cp27bOE6Axl+myAAsmFFa1V3xo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XuFpAyA4vB6ZUCeMGRstuZK0IVUUM2VWuOSc2RWECcnifxvd8tID4FKf9NjT0S525cm1zGa/ROCKNQMltjf3sTmoAe86i2s1X5zqHC8YHg94fBytenZTcjDvtTYTlo1LGg7k1OUGAgXdp8uUbpswbrXLBhi9kkpRx1xryUO8jvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aSIfgC8f; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-745e89b0c32so580537b3a.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682035; x=1750286835; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Uk2iCAGJzrguXHDElw3kCcpBtr7DWJxGiIVAHEgt7PU=;
        b=aSIfgC8flkrK6ZpJm+TWY9/0MyoEBRE+/YGTht1K5u3EAwkznB5QBFYgr8BvVJ2jvK
         lDFi2m90EKfBfZz+BaLVpdsM0V6uDsl9nYHOxrEodc7aQjZsRyY3jZgDjmFhZvZ9R3/F
         75RxK86kd9l33wzZkWGoKduUpPPS3xjs0W4frE3AzKm+lx0SoKMBkS/GkzC1FMQrypSz
         FjzjtdyxUFWRJnud3uyQ9pwBxvI0scXZAZGN+G168AHA/m3UKZArbY+HEmTmUGrL7cli
         ZN3CX/dKvNj7nV/CwbvfmXp8/vJasIQH55NhaU6hukVaF0MNiclYVQbvZkWaJRqWICYw
         N+3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682035; x=1750286835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uk2iCAGJzrguXHDElw3kCcpBtr7DWJxGiIVAHEgt7PU=;
        b=J+iDOQqXSfAAwP2ZyvgzSdG4taq+6dYljnCsEr/nclO5z0aSspyuOGHGC1uzxA7OXA
         YZ3SgD6EbUS6S+iG/kp6SjXneLGwxMaPz4LHEdFGa8jVyJ9SM0TMZBTfAfz/NdsZI1Qp
         Qjl3tnsWFeO8VbrG7OgD0eoehSI1SDgmGmHws+k0jyaWd5E4JZGHPXr58zprqryPvJuM
         bL7Vq8PZskXgdl52LMq6RPn+vajDvnbuarh2PoFCK4sk3Pn/36abyd2dmOhmEmxjwcYO
         SxAZuv2xfy57A5WJMxc38HPHP2uy73/+vfh0UyxFzHZ9cpz1VUerigngqjLtx9arNepv
         M9jw==
X-Forwarded-Encrypted: i=1; AJvYcCW8S/bVeD1pukD8Q+PAnzRQEzZU53AiIALb1/GI2AuWmV4IcEfZahTWCRllHMwX1eFcExc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkS/y96sApzRK1AhkPWsgPrUtuXeVPQatz+RTmcOA1/IXHPbm6
	C1ymSWxf/kWV/A+jnhz+Ge5lV/rGTvQPe9CUkyl9AgAnEn2eI5bJ7Z4RImwl/THxrkc8ADAjW/v
	PC4EL3Q==
X-Google-Smtp-Source: AGHT+IGox2X2Zreqz4euwsJYQpeNVHu/PrMeM6P+22mIkRw9tS6EPJEXitiClHg3UaYo284wvAOiHfeC7Dw=
X-Received: from pfbfa12.prod.google.com ([2002:a05:6a00:2d0c:b0:742:a99a:ec52])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b95:b0:73e:598:7e5b
 with SMTP id d2e1a72fcca58-7487c207d5emr1537775b3a.1.1749682035598; Wed, 11
 Jun 2025 15:47:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:14 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-13-seanjc@google.com>
Subject: [PATCH v3 11/62] KVM: SVM: Drop vcpu_svm's pointless
 avic_backing_page field
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
2.50.0.rc1.591.g9c95f17f64-goog


