Return-Path: <kvm+bounces-42697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA3FA7C44F
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0137D1B62B2D
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D333F224231;
	Fri,  4 Apr 2025 19:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DKNY5UbK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B576223336
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795608; cv=none; b=n908ZBhokgmB0VxqHXOX6j8LdAVYM1N+VJCuJlSijOauWbQ/XsJGlDUxBUM6ElAVdtAKhw8619ZIErbcZ2ptDMQjXF8GPsrh8PFvLUjPNOBVl7u8XeUTxo3zTcWxaBRDMeBq+llR7lTDcHQkbiLNup00t/2bidqzfVB+pF+PUmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795608; c=relaxed/simple;
	bh=ymgLNvDMBazjcOWHdM4TRBB8fRza/15wPWUAsosttHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WZOxByxtx8SYKN2NN4XxwbQqxhjzA1avVeW5j1c+88VJo4T7K4Gs2wj/4DNSALJgPGoze9ha0jgtcajPrfDehAbw1jQaE86TJGr288y/skY2TqvzKeQiGGdvN62csQU/ugPWSsuzpTTG8W+Ts0fIN3GNx9EhE2zPp1010ftOh2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DKNY5UbK; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7370e73f690so2788759b3a.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795606; x=1744400406; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FiKuf+KLGMevEl1JcUq8+wDFjGbG6tG3veWOyXB7Hl0=;
        b=DKNY5UbKgwbgnpH8+tO8cF4nRJPTau2T4BuMH7aMan1MGphtVL9al3OGl6W0AIthwM
         f/uzf7ZeT2/qX0tMsLGFMEr4JZCwJpHsHH6SqZavgvUZk2QdE3nWARBo0GtN1oIPVmGw
         HKo/Lio+WQXeqvCq4nlYFMxoABEO9yHbgCOG6BDG6f7Qx8Rg2p63DBh3BYLDzvbSK3pj
         ERuF3VPO09qeMENAHX1LxVKLoTD67zNNMO8wYb29fTFKjOtTqqBvBOQSepTHXiaCiV3X
         Yu5e+GFQKKMCgp00bJCf4+gVOUtWdYBc4X46HZgR9TGZbLd+no70lJ2zitDjwEqcbv47
         dWIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795606; x=1744400406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FiKuf+KLGMevEl1JcUq8+wDFjGbG6tG3veWOyXB7Hl0=;
        b=Ub7rmzi5mJBRGK4PHmxH3750YGMScxswCiHdUf0G76zfADSsiH/Nx7hM9aPUw5ONPw
         4QBXB+Qc0d2x2mFfXK6q/nHG54Wg6+4M7YnhbMqnFQdGeBxoGKwCRJq2lgP1CzU9+PEu
         f/MMgrl7daIQw+J/XofNFJUJTNXdzCVzYjGBNQ0Tu+DjmqhPir3JCVOU864m/mwMDQjl
         2V/hwvembcHfIk+NIsJK19KcESMoMD3wPVpPHE2N90LvK+1cr5t16edx3T8pj2WTJPWT
         y4mN0gLESztfCQgtTGqijbRLabWVFb2eKHYNuVKLN/J31QsoQxMEPu2bnbpcO7eGvJbp
         ddQw==
X-Gm-Message-State: AOJu0YxrVH5iWDecV608XaqYcaaC2k7ZKwW6Z0PH8vYnMo3SBn3Hfov+
	flsFjybRylnpfCs9PmWpbIFqwLjTIVCt+ECaCEMJ/WFPvIdHLXwMztfSgzKa+7C2lf9OuM6jVGn
	N6A==
X-Google-Smtp-Source: AGHT+IFtyda/QQ9X0Y9KdE3cg1eDpGK8RDILaxqr6131sPdJg3+eJBnN0Hdt1DkeEPmuLwr7hr23wisO9LY=
X-Received: from pfoi21.prod.google.com ([2002:aa7:87d5:0:b0:732:6c92:3f75])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1941:b0:736:4e02:c543
 with SMTP id d2e1a72fcca58-73b6aa3d952mr644845b3a.9.1743795605825; Fri, 04
 Apr 2025 12:40:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:26 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-12-seanjc@google.com>
Subject: [PATCH 11/67] KVM: SVM: Delete IRTE link from previous vCPU
 irrespective of new routing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Delete the IRTE link from the previous vCPU irrespective of the new
routing state.  This is a glorified nop (only the ordering changes), as
both the "posting" and "remapped" mode paths pre-delete the link.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 02b6f0007436..e9ded2488a0b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -870,6 +870,12 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
 		return 0;
 
+	/*
+	 * If the IRQ was affined to a different vCPU, remove the IRTE metadata
+	 * from the *previous* vCPU's list.
+	 */
+	svm_ir_list_del(irqfd);
+
 	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
 		 __func__, host_irq, guest_irq, set);
 
@@ -892,8 +898,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 
 		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
 
-		svm_ir_list_del(irqfd);
-
 		/**
 		 * Here, we setup with legacy mode in the following cases:
 		 * 1. When cannot target interrupt to a specific vcpu.
-- 
2.49.0.504.g3bcea36a83-goog


