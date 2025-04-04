Return-Path: <kvm+bounces-42728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E859A7C43C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E11FE7A9887
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A723239089;
	Fri,  4 Apr 2025 19:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="knRpO/Td"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1321236A84
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795661; cv=none; b=aZYtbxs2dhaA99ActnvlwY+RGglMssDmwbdTzG0lQEDx5rfsrBrEuCsomZZIDhUOKobqls1VJgqr+NlNiNknFXOCRU8V2e7kdgjamQuM2BLI4jcpmep+p9jSQbAqM7mu20yfaHi3dNtaOR+F3p55Z2hve4KRBo6DcrQtUcoegGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795661; c=relaxed/simple;
	bh=mZVHycZOmEtySRxY0gXT8uvd2my3ZEIARWSKiopHcCE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tew/exT1Jl7MPsz0/hoQm2kzlKtAbyQX0p9RbGAbLm1DbovvnD1dmKWJu2q2hunB1JnoeNzpt0J7J+LAE06U8qu8yHzuUB0iX4+3wkNKfB3Vg5oyq/55HeC/JYs2GGzGo1E/eNBfQE69MKy257oFOIqCBUFqjmu6125g0HfewAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=knRpO/Td; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736b2a25d9fso1983543b3a.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795659; x=1744400459; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7rkr9hfugytVpCiSi0z4IyfwHexjORIFyMklekHAhN8=;
        b=knRpO/Tdb+S0BupljJx0CRhxTvzxuxIE9YmGWy9Zt54MsDRrPNvTAAZTu+v46GN2bG
         4/9TxEkg9FQiDfioPMCS9n5IEXec/YR0culbARlp123+1EV9V0lSJ/TpRulHmgHD2lX/
         7cBwX3NuQPlahrVUqH7QodGnMjp4ovK9jChp8VwlasegAmQ67AjdLlwOi5UvPkAZMf02
         DjIdpSqltu0VsC3MUJcHkSnSehpTR6G5C4MYOGxu9GHOyFCXl2/WiUH7oUUm4XLxGhth
         Pe+1sIWDEjsNrdkfZ6ZFq06yKRVbk3vP6tnO2q69DdaUFi7pDA7DCRZWIEQCrRASNgNp
         TOoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795659; x=1744400459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7rkr9hfugytVpCiSi0z4IyfwHexjORIFyMklekHAhN8=;
        b=ZuhnLDIfATOc44YPf4yEdKQgqx23kieCdhNmOZHSWU2l6+iv87/Z8AHxp6oouLCpa4
         /LnbQXUyxy1df+4vxWvcZ6TuXNYXOwW8wfquSM8HPyA8uEKRc9GYBakezH2m4ucOaFeu
         wFEPVHJ76dGq//bCVtGRQRJxt66UyZ9Bbhtxu6hFpj2j+OizC5sTOUmSe3LOzNh7zaM0
         AhKthstYXhGbfzc4aU+Q2Eb+n/13A2RhLKCqCMxq1E8jkD1foGKmoz+Ni4EY74aTg3Fl
         wTV5QQTbnD74PGaUfM7EJMC4H6URwAqg4OwoCFKOXhlkK6KIlwi8LO/7PxHGv9Jr7M0S
         +nLg==
X-Gm-Message-State: AOJu0Yyo/Ep5CkpMDK6AbGDqTNixC6L4Gx4jds+mZnov5i/JA7qNeQlY
	QiDgaRB4HGvOnSmB4fb0cpep4BA0dRKTgMRs7aIkzmyvLRLttokS/jipwyzxXroBTFDcpn2fYeI
	Lxw==
X-Google-Smtp-Source: AGHT+IEMUGCkESn/3vt+yaprJmAWrzZtMoy46YE4JHJL2Qn/BHhy2Ab6QzLZUQwjmyC7XuNZfNUe6UyzE3o=
X-Received: from pgbcq10.prod.google.com ([2002:a05:6a02:408a:b0:ad5:4c03:2b16])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4392:b0:1f5:6c94:2cc1
 with SMTP id adf61e73a8af0-20108011008mr6057448637.21.1743795659307; Fri, 04
 Apr 2025 12:40:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:57 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-43-seanjc@google.com>
Subject: [PATCH 42/67] KVM: SVM: Revert IRTE to legacy mode if IOMMU doesn't
 provide IR metadata
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Revert the IRTE back to remapping mode if the AMD IOMMU driver mucks up
and doesn't provide the necessary metadata.  Returning an error up the
stack without actually handling the error is useless and confusing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index bd1fcf2ea1e5..22fa49fc9717 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -778,16 +778,13 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
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
@@ -805,7 +802,6 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
 
 	list_add(&irqfd->vcpu_list, &svm->ir_list);
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-	return 0;
 }
 
 int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
@@ -843,6 +839,16 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
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
@@ -850,7 +856,8 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
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
2.49.0.504.g3bcea36a83-goog


