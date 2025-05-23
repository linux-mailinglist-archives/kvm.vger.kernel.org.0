Return-Path: <kvm+bounces-47455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 06993AC1910
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:01:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 651731BA5BCD
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0903B204C2E;
	Fri, 23 May 2025 01:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ciLt02Hg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E81216E1B
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962021; cv=none; b=KOMyfaOH7oBjIklLb4JxYVjRz9qP3budJq8GRagz5WehzKCen9qr7ryuh3KWe0bZ4fKbfww+yo9Y5bASzgYX8EQqN5dVRN5elWGJp4SEmHXubf1lbDTuf7Jm0eHdd2T3J4PfFFK0JLkjCWJul7+VcAfdU1Fbehyn2EUXhhqikVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962021; c=relaxed/simple;
	bh=xtpaD7HVsJFlh7tiOLocGEu9Ud8v7ZkKhAZvNZl2KIA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ICxaLlry4TWuxV006LkwGWdNnR2xwttok8QM3Uhez+T1pWg+rfypFw30a4tjhL2sgjHATNgKUw3k+aS5sdfjVaUHjyyx0/paxRDrewGJvuQRRcgGgpXB75qsvuGZBv8kpvXrlmBBg7p3kfJ+XS4/kg6XjLwGNOnzw9f6e3VZPQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ciLt02Hg; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-742aa6581caso6200769b3a.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962019; x=1748566819; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8ehtQMuf6IARUqP5Cyf64+dJov4SLh6VlRU3VKIIQ8=;
        b=ciLt02HgPiHJRw6qX2Apjld6eBoa5n3mYLT5FRj3un8UEcUV3X1Rckh74XtHUc+A+4
         3vPUZH9LffAtwjwHXNnb1ICph2p3uFPsZhKcwD83OkKJwQlPdBMvA9zkYKBKss80nJvN
         QJDlZUsmyuEEqwXhvT02pU4+BdIHAAu2nf+iamghw8+13crn5qen+a7gWtP7DSqME4/m
         zerJZUSGx4F89rL3EO2zvBYryL7Penu9aOUFDz5s90MK/kRngKXtvt26a+FMVEYerDwD
         VIsVQXKoFQPKouPBWRB0piPMR/5ualHJwWDq/zeO1Ye4DQU1WDN9oulWHFWc4xfR7Gn5
         Bdng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962019; x=1748566819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y8ehtQMuf6IARUqP5Cyf64+dJov4SLh6VlRU3VKIIQ8=;
        b=hhgfTrf1d3F+pD96ap9ehWBxJ0rXozjRcCmvYPVBdcTdNNbMf0WAdCJrT0cdHEjad6
         mvsIuRbXs5UImyz09RcaKiczar9FWkkniv9hrmal0VH8F356rZ8CJRfNgxII5eFuXCp1
         tidYQK6hCm7Q27QoAIlWrxykwF1+kAZJcMWaqJWVcVxZnbUC8zouzfoZk+Z7xBwwvOk2
         tjs+HjDxW4XHc2HpT/be8elp2hBkfjN7WpVa1zuRFz86rRX+atRACjPuP1FT9NR+vOyg
         fW/V6U4fiRRl5Ynq9o6od8tYv70bGz3A8LL+NJUdDUtOWKr56nl1EDSmPpP0v0N+UL+U
         Fo/g==
X-Gm-Message-State: AOJu0YxVCM7NQBCMNd2YxaKK73+aWfF/l1YcLzESYMDV11/Vl4S0FDDy
	nGFq5VS+uHHXSrP+a/QCn6EitQ+UiWfrhFjnTLAmLA1qAFIhesxYiLKzQWZNikRqg1wbedjYKe4
	0V2SBMQ==
X-Google-Smtp-Source: AGHT+IEHm61pElXc5o66L35Mfu9cWxQa9x3UMSXO1VOYhFDjyuiVflcnZ6ZC6JzEj6wH5WWXGFCHISdtxs8=
X-Received: from pfoi12.prod.google.com ([2002:aa7:87cc:0:b0:73e:665:360])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9144:b0:736:4d05:2e2e
 with SMTP id d2e1a72fcca58-742accc2342mr33071193b3a.6.1747962018848; Thu, 22
 May 2025 18:00:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:10 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-6-seanjc@google.com>
Subject: [PATCH v2 05/59] KVM: SVM: Delete IRTE link from previous vCPU
 irrespective of new routing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Delete the IRTE link from the previous vCPU irrespective of the new
routing state, i.e. even if the IRTE won't be configured to post IRQs to a
vCPU.  Whether or not the new route is postable as no bearing on the *old*
route.  Failure to delete the link can result in KVM incorrectly updating
the IRTE, e.g. if the "old" vCPU is scheduled in/out.

Fixes: 411b44ba80ab ("svm: Implements update_pi_irte hook to setup posted interrupt")
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4e8380d2f017..c981ce764b45 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -861,6 +861,12 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
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
 
@@ -883,8 +889,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 
 		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
 
-		svm_ir_list_del(irqfd);
-
 		/**
 		 * Here, we setup with legacy mode in the following cases:
 		 * 1. When cannot target interrupt to a specific vcpu.
-- 
2.49.0.1151.ga128411c76-goog


