Return-Path: <kvm+bounces-49176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78047AD6334
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:57:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F04E64605B5
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB9B72E1742;
	Wed, 11 Jun 2025 22:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EhIxE4HN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100032E0B59
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682069; cv=none; b=AUtCuIWOR6ZdRj2YjfkAMeZBDJaupPYKXOEkqwpxv2eW4JFicQfIbzEyjjubvyM9YJ36hAU+ZFjqBVezchaH5G1NXolDr17M/ynI4lkONoGJHRvpzxtOLGRFNTo7tGmCk10v88uChD60Z+sDJ3K93J3PewUulBgpYVp0frsF+cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682069; c=relaxed/simple;
	bh=qt8zb5uI4+X1TebyXBfKCY7Oiv/Cu3N97xLB9PqUJ80=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VG6RbtGvt3w09hoBomQjbqTnBriU+f5lpGbZVO2yPhG5Q0D3SwS3BWWbORqo3GvogPKYkPLQX9QY1DH8LGi6H0iyshSRJk5k5fQcELWZcYFZ8B2NZKsu9a2Pc1nCz760i2TQseoyoVRmoLiHrLDSXLmZcFWly5UVKsYo6Ps4RYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EhIxE4HN; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b115383fcecso117851a12.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682067; x=1750286867; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+DtVGJXTI5NZcLSNxUulZl3FS9wdQHA/Njni8dB9YZ8=;
        b=EhIxE4HNhFmRuPIVVCm18pZe6jYoP9eu9Nx0i9b2bCuQ1UgkWR5e4YYthjQBuo5sSC
         Qb72cBFZ452hfK4tMm8HY+UVRyUUI9D87ydc8eCVlweWvKNbeNE2nRBER/mCmmfDfwJ5
         3VX7O16LUt7Ds3kutwGsY/X4AGaUDw9Ps04QWKw7o/JuoPmGxIt8DBtkULf/H2Z5evMZ
         pwF9Y2moSvVvGHTqLNF5WAz1kwSKlq23hBdDAtp9OJ4BIZ5lqfsAkBgEHHgVggA0qJ2n
         NdfjfkGEaSltE0UDKNvGIvyCzOQZ/HEhF7YI126q7N/CxCLRXRg+NWosJMYlTI134b1j
         y/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682067; x=1750286867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+DtVGJXTI5NZcLSNxUulZl3FS9wdQHA/Njni8dB9YZ8=;
        b=pKwLj4t3MkDsFiSBRB1v6V6vbfxNQa8orV4YAuEChMIuPYpekXKBCQbkH2SqAYu9VJ
         PaOJHe2Ki/bAQ2RsntWWusJ4FYFHofJEqhio/TCjR3WCNf7TaottFOa1MA+bFgrS8Xz6
         MuCUcgNKXeNEQY+dE8//gC5zcpuk68+01iGEVe2vyuORzwAn4YpEb3KmDlur0o9QdQr0
         j0ocHLGnekexjEo+ibFlSroTZAcdDSLr1I+29s9QSjPjs43d2car9zMNSdT/R4vdzvK2
         ZQG6o0/VzLivt21n5kEBQBqAYc7umHwLu6cMv+g5J/QYYDQQ2vQyzSVWL/7zABLsKd1O
         u7iQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyO4CUptW2xP/UBnFWFTEX3+np3ghArl1R4DCCOqmtuVK+cz+FTcLklzA4lVQLlOoJLlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfFbedGVlvdppvo5OIs2Jhje16PyxHKE4/PO5RNdo2+a7oao+b
	LJP+yrCio39H+y6xDhWZerVbPCX9ezlQKP8Nl7eTzivyOS8UcTZQIrIgnNF9fNHY/R7Emsgm2g1
	KR8OgEw==
X-Google-Smtp-Source: AGHT+IFyGDdeorUwj3sAfzICdRUEdg2fKYugNVe8KlRyB4tgk6PAyMC59w8WcXLbD69NI4qphVBoJu3KIY4=
X-Received: from pflc8.prod.google.com ([2002:a05:6a00:ac8:b0:746:1e60:660e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2589:b0:21f:53a9:b72c
 with SMTP id adf61e73a8af0-21f86754dbemr7156966637.38.1749682067486; Wed, 11
 Jun 2025 15:47:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:33 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-32-seanjc@google.com>
Subject: [PATCH v3 30/62] KVM: SVM: Clean up return handling in avic_pi_update_irte()
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

Clean up the return paths for avic_pi_update_irte() now that the
refactoring dust has settled.

Opportunistically drop the pr_err() on IRTE update failures.  Logging that
a failure occurred without _any_ context is quite useless.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d8d50b8f14bb..a0f3cdd2ea3f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -807,8 +807,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			unsigned int host_irq, uint32_t guest_irq,
 			struct kvm_vcpu *vcpu, u32 vector)
 {
-	int ret = 0;
-
 	/*
 	 * If the IRQ was affined to a different vCPU, remove the IRTE metadata
 	 * from the *previous* vCPU's list.
@@ -838,8 +836,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			.is_guest_mode = true,
 			.vcpu_data = &vcpu_info,
 		};
+		int ret;
 
 		ret = irq_set_vcpu_affinity(host_irq, &pi);
+		if (ret)
+			return ret;
 
 		/**
 		 * Here, we successfully setting up vcpu affinity in
@@ -848,20 +849,9 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 * we can reference to them directly when we update vcpu
 		 * scheduling information in IOMMU irte.
 		 */
-		if (!ret)
-			ret = svm_ir_list_add(to_svm(vcpu), irqfd, &pi);
-	} else {
-		ret = irq_set_vcpu_affinity(host_irq, NULL);
+		return svm_ir_list_add(to_svm(vcpu), irqfd, &pi);
 	}
-
-	if (ret < 0) {
-		pr_err("%s: failed to update PI IRTE\n", __func__);
-		goto out;
-	}
-
-	ret = 0;
-out:
-	return ret;
+	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
 static inline int
-- 
2.50.0.rc1.591.g9c95f17f64-goog


