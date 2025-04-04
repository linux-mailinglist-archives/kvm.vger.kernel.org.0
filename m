Return-Path: <kvm+bounces-42742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF98AA7C413
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:48:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BEFB3B43FE
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CCD24888E;
	Fri,  4 Apr 2025 19:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X1by/HJM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D452459EA
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795685; cv=none; b=mBha8VmfuLGGVO6mM3CGFMgT7hSLr8Hraop211114xr65BVx6gXEsFnYmlXYW04svOpuN2cXpHnpFSVFZSCokiIdBWg83p3j6rTzti3D9tFdVyfZ0CMahSFJWXCC9lfqeJIX6oBZyrHFxFj3AXyoPJPwGBMsKLrGInq1U8GBiJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795685; c=relaxed/simple;
	bh=mBywmRA4/NC4/3ktj7swW5HzxdRaFgk8AKVqnst2exc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bQntZGaw0r8zToVQyhY2R6P0vwpviPFjCWSWtgO4/awVt/OFCrT6lhmXcM9eSpwE6j810/jlO2u6BnXPke8t/jro1GGjL6k0IONp422VRzz0z+h/RdBobjd32uT953Xczn8BMkqORdUncb2OMJ97Equ+Bd+1RfKvqIOIvqTnulk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X1by/HJM; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-739515de999so1998340b3a.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795684; x=1744400484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BWR485RXwpxC9/TJjlnr5W4WV3qeOulIgWhB0Aow57s=;
        b=X1by/HJMe+mJG9IaI14nurtnK0RBLXmXZccWzR/PTdN/dnn7kzXmaKM7UMYMVuyRzE
         LNdw2c9rOgPMHRjuYVx2e9SHD+qGZUOOv4TWl3nJrop/i81L8O3GRw07hunskMqJ/qK3
         IkD7eD+cYi9P2hz6fp8p8JtGfvQV2azQgB25AvCGsqkeGaKAvjg5cgdIWcw9wRVfRVum
         78RbxTkRUzolHN/EaxnFRyPUkiD9sKam/l84bkjk8EXLgFS9J4AH7vCck6SthVdlWg0Y
         15virr83/BxpgXdYglI45gHrzErS6bLb8ahnBI18xFP56nea66vHcdyv42Z039sI1i1F
         hHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795684; x=1744400484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BWR485RXwpxC9/TJjlnr5W4WV3qeOulIgWhB0Aow57s=;
        b=jWG8jUwADW7Y9xCuHKO+tvzayGGIKtUmhm0Da+Kh2V/+dfGutnz+wq+szcYnnAhwpW
         oCIUTsyTpzA3GTRKT1h0ayhwEaMxzGzlOMHunoFbM9VO3rVsyYHV+HbKPjUEMyGjeJQ5
         eRvdZCeIQ0Zl0H+hcmZR+yDFbyZyZybR2JI8kCXZgYKa2lXklKD3GzrOO2FdGb4AMxDF
         pNJCSRq4Ky5IdmrD4+vfEjPkJqT6hiiiJA4cqRN4wq+mSI1Wsh8BstrBbcKrLPMKY4Rj
         qo4zVddAGYN/XRoB2upS/c4kDeS9MoC3UgW4KGGI4zY+cFlV9CHGdf/o4u+rq4lOznQ2
         yzPA==
X-Gm-Message-State: AOJu0YyVFBmCcPTYBEXIBeLitX0VWXJm5XdmZ0ejxSmRjOoVP2L+dF2V
	1KBnv9qB2NQ4siYu7HOZHcrDyMHPlWhelWtAW9PLoYRv4PbcOOg0TXj2uH1f82+o5VO0Q0rghmM
	Y+A==
X-Google-Smtp-Source: AGHT+IFrhugesHcYwD2EtEVR8p7v599AXO0yZ1dLVE7YlsaYY7QqtLthcLHvdmvsan5d8gnX4rE1BdgAjQI=
X-Received: from pgc8.prod.google.com ([2002:a05:6a02:2f88:b0:af8:c3c6:e3f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1304:b0:1ee:ce5b:853d
 with SMTP id adf61e73a8af0-201081b2d99mr5653839637.39.1743795683722; Fri, 04
 Apr 2025 12:41:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:11 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-57-seanjc@google.com>
Subject: [PATCH 56/67] KVM: SVM: WARN if ir_list is non-empty at vCPU free
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that AVIC IRTE tracking is in a mostly sane state, WARN if a vCPU is
freed with ir_list entries, i.e. if KVM leaves a dangling IRTE.

Initialize the per-vCPU interrupt remapping list and its lock even if AVIC
is disabled so that the WARN doesn't hit false positives (and so that KVM
doesn't need to call into AVIC code for a simple sanity check).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 5 +++--
 arch/x86/kvm/svm/svm.c  | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a932eba1f42c..d2cbb7ac91f4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -713,6 +713,9 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	int ret;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
+	INIT_LIST_HEAD(&svm->ir_list);
+	spin_lock_init(&svm->ir_list_lock);
+
 	if (!enable_apicv || !irqchip_in_kernel(vcpu->kvm))
 		return 0;
 
@@ -720,8 +723,6 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	if (ret)
 		return ret;
 
-	INIT_LIST_HEAD(&svm->ir_list);
-	spin_lock_init(&svm->ir_list_lock);
 	svm->dfr_reg = APIC_DFR_FLAT;
 
 	return ret;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 43c4933d7da6..71b52ad13577 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1499,6 +1499,8 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	WARN_ON_ONCE(!list_empty(&svm->ir_list));
+
 	/*
 	 * The vmcb page can be recycled, causing a false negative in
 	 * svm_vcpu_load(). So, ensure that no logical CPU has this
-- 
2.49.0.504.g3bcea36a83-goog


