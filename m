Return-Path: <kvm+bounces-41569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF9A7A6A886
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 15:30:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5155188A761
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA39422541D;
	Thu, 20 Mar 2025 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nDY13dpN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C55224AF3
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 14:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742480430; cv=none; b=qzfc9F2asQ5SuTwEm29jTfuQ6HDD2b9CQ7jOpwSdtFFiZHd0qDfcRITLkbaRPKK1sU6k5M7sXIbMZMwkzCYLjj02N5eb6TUpkP7Tz9bcQ7Ymzu3S6h+Ek2Xnv7JVdtEWOIpV621xDoc9DHXw/gYFlnSggeCYHTZ/W75Gmu/M0GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742480430; c=relaxed/simple;
	bh=ovEPl2bVEO0eSqvBoa1vZD9IRo9Jr6lVc7JfrYVpvGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YlV1h0BWzKoXnLa5rvsmEhOpROXYCtdupNVe0Q48BUvqH5U1UoMW2gER8yDvXBUGISOulXCqpf2oqzYT3f8GueKsKHoqr39iZve0Ju3J7A2sJU/BNKz1DdYqOj3JHd+R38IYZIlPK5glJBwkXiDNgyvUNBOzus2+P6PQohKsDPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nDY13dpN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff6943febeso1114243a91.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 07:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742480428; x=1743085228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fVHuVoUkv5HXmPF3k2h1n5WUDzdvxcafccuisAmJQYw=;
        b=nDY13dpNtarNCgDNOtRGa5TevRHJS+KepR5xqN11HAk2tEnw0Syc3Oj+678XSjARsD
         Ns2+xJdZVFGlA1F9UcHSS4lkczjNxK101nFqPlgaym5+NrHQ2wSC07hcTHLtRD2L24Re
         bAWZ3cy+BP+CkBSxecu1nadGgeK909gBFJocQ1dDEVZgviQ3xFG5p/VRTPMVpNwnN3tP
         SsVDTWnp8JZv68IbkZBjThIEZpFpbxvpPNWOjyvhQgKXmhSJm/qnyAiSb4F6t4DgKMQs
         r+GXHatxnohkEzV+iy1Z3hnfvCALAz2Vc4Kx0jhqrohN1f1t3biHQ39k28uEiAx5blXt
         tjCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742480428; x=1743085228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fVHuVoUkv5HXmPF3k2h1n5WUDzdvxcafccuisAmJQYw=;
        b=Y/K8bDuWE99O5qMPVgFL3ms4zWF960g3isS5/vtGAFe0gpc2AxLr74pK7Rn9rQU9z1
         Pwt+1rDW4XCZdadN0cSSDCGlIn23IMcRnmlTxXTE47z3NVOBU6SwHb3PLyAWnkthVMBx
         5IUJ9wfBJNtnCUqmCd3lo7IFq5/BQuou8Ac66eJvqwE5psFplBi9tnQVqPRc01mQvGq1
         XbD8+a4GyeWCcwvMxSYM7XvaHbrPFfSmwqyOgaMfCLwvqyCQyuFy8ClU7r/KPe8EYOtL
         hOVFdqRxn4hM6wCt5XUHH8ZrVej/QX7M9AHcXyei21SldkNvaHkYA/U5KhWLnwJEuqej
         CNUA==
X-Gm-Message-State: AOJu0YxUJFAPGThpzCYkNdpe+2JLa63fKR15Wa04jMWjdvliOZMVo4Mj
	Exm3de2Pt4EKQDYs5cSPTsU6fUcwwP5wqElUeqlHHOWt9xP81ONi9YvG+RmW6n0RRARsezFC6C5
	N1A==
X-Google-Smtp-Source: AGHT+IFbPO/3Zgwol8ARgIf0jQNXI18k8lFWGe70dLm0WMUhi+BbpfRpAvT6wHo2NxigqM0VjclDH/escmU=
X-Received: from pjbmf11.prod.google.com ([2002:a17:90b:184b:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d2cb:b0:2fa:42f3:e3e4
 with SMTP id 98e67ed59e1d1-301d426aa83mr5355104a91.3.1742480428033; Thu, 20
 Mar 2025 07:20:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Mar 2025 07:20:21 -0700
In-Reply-To: <20250320142022.766201-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250320142022.766201-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250320142022.766201-3-seanjc@google.com>
Subject: [PATCH v2 2/3] KVM: SVM: Don't update IRTEs if APICv/AVIC is disable
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Skip IRTE updates if AVIC is disabled/unsupported, as forcing the IRTE
into remapped mode (kvm_vcpu_apicv_active() will never be true) is
unnecessary and wasteful.  The IOMMU driver is responsible for putting
IRTEs into remapped mode when an IRQ is allocated by a device, long before
that device is assigned to a VM.  I.e. the kernel as a whole has major
issues if the IRTE isn't already in remapped mode.

Opportunsitically kvm_arch_has_irq_bypass() to query for APICv/AVIC, so
so that all checks in KVM x86 incorporate the same information.

Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 65fd245a9953..901d8d2dc169 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -898,8 +898,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 	struct kvm_irq_routing_table *irq_rt;
 	int idx, ret = 0;
 
-	if (!kvm_arch_has_assigned_device(kvm) ||
-	    !irq_remapping_cap(IRQ_POSTING_CAP))
+	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
 		return 0;
 
 	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
-- 
2.49.0.395.g12beb8f557-goog


