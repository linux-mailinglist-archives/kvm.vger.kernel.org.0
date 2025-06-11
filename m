Return-Path: <kvm+bounces-49153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86944AD6307
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4336816C524
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E3A225CC57;
	Wed, 11 Jun 2025 22:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pi2VYJ5W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0B425DD0C
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682030; cv=none; b=m1ysoYI8cTosFG4GqfsYTJ8yXySj0xheE/3u0GbWxDZeWsqsM1iCfB7MnZI0PbhOgi7/yunOeiyy2pMMP7Y6AOICUkjTT4wQKbtAS8tmeQNxsGs2G9vJlfRL9YaMPTVGW/DOa51z1fLyVWFJ7K2hQb+CnMgxbceH4Nm3h89W4to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682030; c=relaxed/simple;
	bh=veIQi8e0iCtzXQM8NcdDzO8ccwAXQEovrCAVSPv1kJ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ya/CQT7vU3RDuqVkjZnHZR2az6EeRqJlkuZIiE9JJyiUxXSintvJ8PqxES+h8HzxBThRVRWjZBl9Mqv0Dy/uXDeI27xn9EpwzHYAATiOL45ShTNym4w3W8juknRbCg/5c2OxzC6Gwl7S2NZyKoCSGlo3Yf1pGCphigxhmK8ykhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pi2VYJ5W; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747fa83d81dso252763b3a.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682028; x=1750286828; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tDZohEtmrHKYD6EovcSC8/ZzfIWWO2Pel/+WswkGVp8=;
        b=Pi2VYJ5W9n5OOGnU0KlvTDsPZ5rNyJN2cw5CKIHSMAhC5stobddUEW2/k/BygJhaXW
         WE/YdnJgVs1zGFemZkGg5vW2jNZQk2M2a0lL0m1mlKDYqiCSceC64XFQWZualjSzd5x6
         3k09b3pm+tTPi7WkKcPrBuF8fAecG+iIruriGqYROJpRVF3t6+1qM2WQvp8Gc9Gy1axc
         mG5O75tVHaCP437YgnG/XJhVMUr4bqpV0vNAGmWxYH7SMC/T/qSyNx8VTrhTy+wGwUCP
         nkRMb3U/mMCwF3z3GKKw9l9jYIqX9Txt8pyFrY3dRnCuRigBn/GqZSjOdHRKOMI8mh89
         YoBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682028; x=1750286828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tDZohEtmrHKYD6EovcSC8/ZzfIWWO2Pel/+WswkGVp8=;
        b=wOcKcx0s9PfNTwEmNkJfq68eyCYxb641BDPusdbLCUs5HoCZFV+P81ivB90LTRoGmP
         BebFbOKcdSSV5M6zpcYAtyr6XV+0iPrmtr2CM2robG2s4VAw69yRcVBu0H9nz9MP35Do
         kdMCggk28NBTblS4Vm4mkWk0uGWnoZ4+hHIWhOgJOw9YIsAtT1rzhN3FY4fqUVM1mZGD
         FjkX4nEbrjg07PVP9iyMznbXQuQKE+5iiyt8v+UBEyA86HEpfprPf3iB96a4Rzaum/+R
         D3hu93wcRbxUjN7oQvrpTLFozwXNxUYAxbCVLl6r51nvo1eFoWbQbUmYLRUPZchWKUjF
         +sRA==
X-Forwarded-Encrypted: i=1; AJvYcCVaKyqDbaAKlqClwzbSugvHtrw0nD9o8vAaq/PohDV+qX9Gynr495t6az478pJM0Bq0Fso=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBu6XTjLfROOaQdsNkrVPe/z4u4/do/wIWH8TgBFsyg9wwATl5
	ub+13YVH8OfQrqJktgrjPYuQJHNYO/6fVG7USSK88uv4jovXuCwtN/395Tm3qmYAP+ghA5k9OhG
	naUFdRA==
X-Google-Smtp-Source: AGHT+IHgXSfJU2sxyG9OW4VojMH2BSFfhS8bYIS64Jcg4Y6OGr2dvtrGuU93NG67KzexoKMXwohALrIyyio=
X-Received: from pfic6.prod.google.com ([2002:a62:e806:0:b0:746:2117:6f55])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2294:b0:742:a111:ee6f
 with SMTP id d2e1a72fcca58-7487c21ba8bmr1432295b3a.10.1749682028151; Wed, 11
 Jun 2025 15:47:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:10 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-9-seanjc@google.com>
Subject: [PATCH v3 07/62] KVM: SVM: Delete IRTE link from previous vCPU
 irrespective of new routing
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
2.50.0.rc1.591.g9c95f17f64-goog


