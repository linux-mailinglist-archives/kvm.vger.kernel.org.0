Return-Path: <kvm+bounces-49189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 163FBAD6360
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:02:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A002188811A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6E5277C8E;
	Wed, 11 Jun 2025 22:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AtQaoEbN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573CB2E92BD
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682093; cv=none; b=UHV26j6ZYItCpv6/xuyVybQfL38YbKgwxc7nQep40hl7iGnoWLBRDKKHN5j4CZW6RHc5L/Q2hP6A2UY227mVVrXlDWdE20YwlWPuJN+MTCpZZrA7GFvMOs9wuJ3t4Qq5v+S4FC4xeKJ+8T3I5m8YXTRX+T+3evIi00yrv5lNNRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682093; c=relaxed/simple;
	bh=NRIbkwHZgJe1eOAVp07nJM0qpUotjJb3D6s38m9ceNE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WBQes28fSDpGd8zioD86GM44x1eoB92No1WCHCKhcLSnjE9n3Zn8gNPOF5+beK4/Dv2zEg/BLXf+XPFgX7ycLvCLAGIJnccB96u/nlP4cUm8rgdmlHP2KfFrn/NpGaXAfIEMHTDbTpKWW1mSbgoQVUMv1Q1J/iQmk2LTZszbNrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AtQaoEbN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23632fd6248so2069515ad.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682090; x=1750286890; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=d8u9n7/qtcddPkohDHss1zptLYbY60ll3w/DwpskJQs=;
        b=AtQaoEbNzJ03kFP7xNUhSqWgthoowawDDjIi0mD4s1Q2TSUbDuIMBx/zZ8cN8Z28Tv
         o0sKyBPHmhAMF6NGliYYTNBN/F6WsEcigzvaUtNVThVeJl3v1aqgw30O+drhdNBWVxt5
         a2n4tBkKHHT9MGWINhaqkd//eexAEZfOnfQ16VnrRvjaPZtclOT+Gn6XCyrUxnLx/fRT
         IzMkpeT/f74Ogn5WyNfIipYeka1j6dHbJSVdFsMdyF8IEQXpDdg9fdivVymZb6we+es0
         S7SSj5HRkb22rEcUEdCBHdIFy9MWx864u/pUaIh9n8Mkc/R+7zra7u7LK/yl/ACS2yMK
         KqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682090; x=1750286890;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d8u9n7/qtcddPkohDHss1zptLYbY60ll3w/DwpskJQs=;
        b=pMOEcG5624zAJt2ow6VDZuoecynk0LSbkW+Uh/2FWNglf4iJp8/4gIFguW9YUpEBJx
         HJ77PedTf6Yt2VQNIy7q50Yk9bjNsM2m9Yqwm2pXIiKJmhogYEdVQaLQePZT+LWUnAhD
         Jz6HZpiyeTfVeEvTam2tqp1Fpy09iH3GlFzpcny0+lhudj5Z8uTyE9+jjA1PS0q4V0cG
         8i9jxHCkOCCE6TQAsfvSlpIAT2vewIpTq8j1Tk+a6CGUXo/bvSyiWmPL2eyTJV6kMZNE
         wGrVcJ3D4+VrLHomP5I/+tVDkFvp4HTx2SG8cNAM28da2DFbxTpjA/og4t+sDARYBDr6
         Y9Nw==
X-Forwarded-Encrypted: i=1; AJvYcCUBR+rp/iRaRshqHF2r7T2w+/w1NPSDqqJMGJGTRMaTxp72ZYJJN2dM83PAGymrsNE8W/4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHQp6PUNn/fEP1rqwIhAxdxyzYaYo6nqqWGHecQUiufG8rA0YX
	QZKBlxCfha5HJ40n3pcYKl4k09sdIuPFFo6I4wrAD58+AeXx0+mHpeOJH6CGm53YG9UZicI9cd4
	RLd7zbA==
X-Google-Smtp-Source: AGHT+IHWJyMnlyFo6yhSGVaRZ8z5iHrg3t+Cz3M8yTQ7oInJuByhEts6I2Tl4zgp4CW7ntx2+eMqbSXS/nA=
X-Received: from plad20.prod.google.com ([2002:a17:902:e154:b0:234:c8e7:6fe2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c23:b0:234:d7b2:2ab4
 with SMTP id d9443c01a7336-2364c8d18d9mr15462635ad.17.1749682090185; Wed, 11
 Jun 2025 15:48:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:46 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-45-seanjc@google.com>
Subject: [PATCH v3 43/62] iommu/amd: KVM: SVM: Add IRTE metadata to affined
 vCPU's list if AVIC is inhibited
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

If an IRQ can be posted to a vCPU, but AVIC is currently inhibited on the
vCPU, go through the dance of "affining" the IRTE to the vCPU, but leave
the actual IRTE in remapped mode.  KVM already handles the case where AVIC
is inhibited => uninhibited with posted IRQs (see avic_set_pi_irte_mode()),
but doesn't handle the scenario where a postable IRQ comes along while AVIC
is inhibited.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c   | 16 ++++++----------
 drivers/iommu/amd/iommu.c |  5 ++++-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 16557328aa58..2e3a8fda0355 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -780,21 +780,17 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	 */
 	svm_ir_list_del(irqfd);
 
-	/**
-	 * Here, we setup with legacy mode in the following cases:
-	 * 1. When cannot target interrupt to a specific vcpu.
-	 * 2. Unsetting posted interrupt.
-	 * 3. APIC virtualization is disabled for the vcpu.
-	 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
-	 */
-	if (vcpu && kvm_vcpu_apicv_active(vcpu)) {
+	if (vcpu) {
 		/*
-		 * Try to enable guest_mode in IRTE.
+		 * Try to enable guest_mode in IRTE, unless AVIC is inhibited,
+		 * in which case configure the IRTE for legacy mode, but track
+		 * the IRTE metadata so that it can be converted to guest mode
+		 * if AVIC is enabled/uninhibited in the future.
 		 */
 		struct amd_iommu_pi_data pi_data = {
 			.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
 					     vcpu->vcpu_id),
-			.is_guest_mode = true,
+			.is_guest_mode = kvm_vcpu_apicv_active(vcpu),
 			.vapic_addr = avic_get_backing_page_address(to_svm(vcpu)),
 			.vector = vector,
 		};
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 718bd9604f71..becef69a306d 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3939,7 +3939,10 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *info)
 		ir_data->ga_root_ptr = (pi_data->vapic_addr >> 12);
 		ir_data->ga_vector = pi_data->vector;
 		ir_data->ga_tag = pi_data->ga_tag;
-		ret = amd_iommu_activate_guest_mode(ir_data, pi_data->cpu);
+		if (pi_data->is_guest_mode)
+			ret = amd_iommu_activate_guest_mode(ir_data, pi_data->cpu);
+		else
+			ret = amd_iommu_deactivate_guest_mode(ir_data);
 	} else {
 		ret = amd_iommu_deactivate_guest_mode(ir_data);
 	}
-- 
2.50.0.rc1.591.g9c95f17f64-goog


