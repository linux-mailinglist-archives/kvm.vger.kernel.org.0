Return-Path: <kvm+bounces-49168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B322AD6330
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD5D91BC53C1
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F192DFA2E;
	Wed, 11 Jun 2025 22:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dJZSaasR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0902DCBEB
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682056; cv=none; b=WRZ3VEmomV8OIzt6g1eTbGI0sE3K36qe6bdFycYBNnRHGcxvTmPXUP5OCSuj7DuUqDl35wRxGFq62SbRTvpKepWhr7orbeegLockjyQP4iy/rYXJUTMBnbszThKchxdE/bMydvbgqd5nUITe4NvIdzb9Bgr8qxNyPuDCLtCh0uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682056; c=relaxed/simple;
	bh=Msv0GWvGGG8y6O2DyZ8k7WL4kXdKK4vDTwajtNxdEIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sEIVsktZ3INCV0YSolTw+rZNu0pp+USinOE5nUhu2Mmis7t4e06vCWV1H39xymMQwHzC+2pFrGv3k6DpAfEQLzT1k7wRz98GTy6baI7T43s6UlNnRYwKc9CMfSckNIswPBLUYqx7l7oeuwfmU0hlmDiqf5n835X7dbJN53Rdo2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dJZSaasR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31220ecc586so294885a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682053; x=1750286853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZIGTXeypHh9nAzQZBQedf1Xm+LoLGaDX4jKjQeTbIE=;
        b=dJZSaasRzIJqZSSHVab+5Ko5pnsL3qPBAqXfSBdcWKxO6+472T8tvhphpR2zzhMPf6
         nV7Qv78xPoGmO053tW6x5P8ef7uWZrQsZqSqkhk0bjTkXsvskJRYBKy6RejBPIFkXOqW
         /OcszNQzKzuZJUjQrjw+qiVbCqiuAkSzQTcqBZuHgjBwzHvjrf8y1tuAV5d+ZuueYM2W
         +rQGc+h6Ga08ksKVNfAbk9TQaPqCC9cs2oz9EtO7zaLzS67vgKp0MK9yKfS4cg/OTHiV
         Vj3GE81QT6bUxlXeJX8tVWxo8org1P0oR+/q2S6r4S8RcLW4x7zGhy+RZ7cdiDOxrdgk
         DoWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682053; x=1750286853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/ZIGTXeypHh9nAzQZBQedf1Xm+LoLGaDX4jKjQeTbIE=;
        b=GVrIzNhZCe9phhONlo6rmT0VQsMxCme4IH0nGvVpghVZ8rSdaBwxewG/5hMP3p7DNI
         nZHrWcgH3wNJKhHYOmaF+2JBbc3SDA9HJzGdRwmHlpky/kHdwFhB4y9ofUf7ob15lnMc
         dzRZ8cxeU6F2DEXqqjllzTDT5eGHIWBKKU4sd7Uq3unQ8iLoVxyDZma2UI4yjCuxVsK+
         WnS8PKjCoW85uP83uVlGQZ+QH8e+6FA95sIISwUaCQBbCUcKPElyR22mxHdmGKKzilaR
         oRBLJNDLSwckwwJ8cbvPlV88diCHVjows206qPCTbuU8e7sevFe4RQDIUIsdjRK4B7S9
         9bcw==
X-Forwarded-Encrypted: i=1; AJvYcCX0FZZI9PrZozTMZsGs+VCZvvB42C7rItfgLZJkKx3TK9+gbGsW1HP2WBrFJmoRDMaqv5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVDGOottLIbrIyuvdfs5+aLg9wNonaoCxbYdXPj8Qwo+lHBGZm
	g5OqoCSk3L/C1TZejlMu0grRlZ65ut10lUeV9+ZEMDcV8bzR4ESaB+pKiqiLSCWranrYj8bOweK
	3oNWPtg==
X-Google-Smtp-Source: AGHT+IEMDc4s/X6k49FZuDgV3o04isaOgZ+4Gyq7hnGZguC+YKTMyGOmyVtkAPikERIj/O7QNBKSeMcDWAk=
X-Received: from pjh14.prod.google.com ([2002:a17:90b:3f8e:b0:313:274d:3007])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:540f:b0:311:eb85:96df
 with SMTP id 98e67ed59e1d1-313af1abb7bmr8018754a91.17.1749682053580; Wed, 11
 Jun 2025 15:47:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:25 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-24-seanjc@google.com>
Subject: [PATCH v3 22/62] iommu/amd: KVM: SVM: Pass NULL @vcpu_info to
 indicate "not guest mode"
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

Pass NULL to amd_ir_set_vcpu_affinity() to communicate "don't post to a
vCPU" now that there's no need to communicate information back to KVM
about the previous vCPU (KVM does its own tracking).

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c   | 16 ++++------------
 drivers/iommu/amd/iommu.c | 10 +++++++---
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 461300bc5608..6260bf3697ba 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -927,18 +927,10 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		}
 	}
 
-	ret = 0;
-	if (enable_remapped_mode) {
-		/* Use legacy mode in IRTE */
-		struct amd_iommu_pi_data pi;
-
-		/**
-		 * Here, pi is used to:
-		 * - Tell IOMMU to use legacy mode for this interrupt.
-		 */
-		pi.is_guest_mode = false;
-		ret = irq_set_vcpu_affinity(host_irq, &pi);
-	}
+	if (enable_remapped_mode)
+		ret = irq_set_vcpu_affinity(host_irq, NULL);
+	else
+		ret = 0;
 out:
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return ret;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 512167f7aef4..5141507587e1 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3864,7 +3864,6 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
 {
 	int ret;
 	struct amd_iommu_pi_data *pi_data = vcpu_info;
-	struct vcpu_data *vcpu_pi_info = pi_data->vcpu_data;
 	struct amd_ir_data *ir_data = data->chip_data;
 	struct irq_2_irte *irte_info = &ir_data->irq_2_irte;
 	struct iommu_dev_data *dev_data;
@@ -3885,9 +3884,14 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
 		return -EINVAL;
 
 	ir_data->cfg = irqd_cfg(data);
-	pi_data->ir_data = ir_data;
 
-	if (pi_data->is_guest_mode) {
+	if (pi_data) {
+		struct vcpu_data *vcpu_pi_info = pi_data->vcpu_data;
+
+		pi_data->ir_data = ir_data;
+
+		WARN_ON_ONCE(!pi_data->is_guest_mode);
+
 		ir_data->ga_root_ptr = (vcpu_pi_info->pi_desc_addr >> 12);
 		ir_data->ga_vector = vcpu_pi_info->vector;
 		ir_data->ga_tag = pi_data->ga_tag;
-- 
2.50.0.rc1.591.g9c95f17f64-goog


