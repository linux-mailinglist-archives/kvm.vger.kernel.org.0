Return-Path: <kvm+bounces-47470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A40A2AC1936
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:06:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E47D4A15B2
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50FD0276056;
	Fri, 23 May 2025 01:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RTs1nHHs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3206274FEB
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962047; cv=none; b=NHTDxdyyLeHiK1uXquZuTscbpPSIMLv/FYc2KKAT7A7lUwM74J5ZQ56+9B5oaFZEu+SZwMPYGD+gwA719V0s7Jzn8Wg3ZcLPbuaYKXHAQBrU4cbb3Za8Of0BbGQcCm60ScJ69vJxznDQ80vAfY/WJrKP7CtsvspwFpbD0AEQNz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962047; c=relaxed/simple;
	bh=fW2G94RfLD78AMcqDsZ5ps4G4Sno9GFbL+j5/DPryVk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LprhCtsYKXHPWszS/1IcwE6OG/JcuU+0ZExuyyZhJdMFILO+AbpG9/FCGwUfRzFHUaeXk/a7jiRQ4//N+Lydwun7x4x87x6eK8YU5zcqGhvzBLvfKRLsYzeDPjp/p4C5dQ65pfnX5VJvK/slS1+u1T1TLTaE/nEY7H8PzBA6p5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RTs1nHHs; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e9338430eso5418355a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962044; x=1748566844; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LEcBPUoa4oxCDsr/z1+DJV9LnDo6qsS8eDb1DWTU3As=;
        b=RTs1nHHs9KUWdPU3KLg31b8ljMlwp/KoQH3QQ3unj3oXLVSfYzzpPVGtKTpZG6kAXq
         hrJQO+ge/GlQy3gcyxvECWmjRLTcHbzUekKXx+a996a/twxwQLWC1rOiBNLZbAO7QDRJ
         8RAoIxEjJNL85uFe8vqbo/gYqDJgZFQ5xKGu36jBayJXs9QtUO1HAsHnlxSCri985XCX
         bWvtAYkxcH4Bb0l5i0QFdFBITm5lwT0nqUeieWx4lBXCod3vdUhZjZx9xJRpjtq2JnDK
         aX9XRNU/FngkFF7tZSSxXBLmUjLn3ZT0YebT/SoO9v1wGDgphC7XP+fCY3T25Dg496Gj
         yr+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962044; x=1748566844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LEcBPUoa4oxCDsr/z1+DJV9LnDo6qsS8eDb1DWTU3As=;
        b=wOiKKSRSzmEKuOgoAMOqskuOXK0e7cw16pfy0aTl0FMva05vc3xLbbo9u0t0C1M1fN
         NuU334oF+R6hMz6OaTf9/wKQCv2BKcHsfA4ykzL7NzBuoP5E1VBGhPZ0acHMd00/IwIJ
         AXNCY69qJkyF3Jz8TtFshilgwhDID2nqA9+E3GR0evOwbrpdo0AKScrl6cZCPZFgCVU5
         /GkZ9RYCSlCf+13GomI1+NbrG40Wv1N/db7+PChnCxItZtXXPmjFIS0yCaetFHmmJ2CD
         spAXzDjS5Rd6V79wlttgY/yatRolEpcc1MwU3yiKEgNBtjBuwPZ8y3y9eJNfWb+UK4JU
         +gEg==
X-Gm-Message-State: AOJu0Yw/a14TIMJZmQgGc3BF98oVESA+hfCA5rmI+/uszypFRGlGdvVj
	7rVARxMxNG0NMMg0CVXD4EN93n2kW70cJ+n74D6eNyoSJeB2GXDnHUXufKIT0Jb6jOSevtzsPoK
	bZK08og==
X-Google-Smtp-Source: AGHT+IGKaHuHYtNmHM5Kq9jQbWuDh5HQqrhGXZK4H0D0g7q7j+eU/9f1bdcnBIi1ajs832Ec0O94mR8aIqk=
X-Received: from pjbsl8.prod.google.com ([2002:a17:90b:2e08:b0:301:1bf5:2f07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b48:b0:2ee:d433:7c50
 with SMTP id 98e67ed59e1d1-30e7d5ac7ecmr33843110a91.23.1747962044116; Thu, 22
 May 2025 18:00:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:25 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-21-seanjc@google.com>
Subject: [PATCH v2 20/59] iommu/amd: KVM: SVM: Pass NULL @vcpu_info to
 indicate "not guest mode"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
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
2.49.0.1151.ga128411c76-goog


