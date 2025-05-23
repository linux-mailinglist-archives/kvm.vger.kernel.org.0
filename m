Return-Path: <kvm+bounces-47496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75FA5AC197F
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:16:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 272C47BE60E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC8C21C183;
	Fri, 23 May 2025 01:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mfGD89c5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0CC21B9F5
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962090; cv=none; b=dStcFNtO2eOQmpuMVNL1y/CGt6QNCLgdU/YIfh2ymjHPw7G7Etherj0gCvAPhJ5nGl03uCaTRNlDf5WzmmzFbbmKUKJKNZn/8oKLz12ucDpFqSkTnFT6qjqTYmDfTQA05zam+hUW0uDa2Scko2r9oD/Voyxj4cotptekDVO81W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962090; c=relaxed/simple;
	bh=axZocm4dvPcmbiB/ZwqdO3wy7w4x+of0K0yBbiaqjq8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fbF9zj1zPmTOjnA9Xy70XbzTMciERT99e0Y1BmuvGOe4R67/RF6VUhkgFrz2LBQ+UZT8dQ3AMn1dA+cwhNHBMW7yTGmIorzIOo+9PnHXxTPl5uwlft3WD8UAS96B5WAbHom/sDRin/YP718cMjmIY7oXWpDLbWych0ZKWG7I8oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mfGD89c5; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7394792f83cso6893082b3a.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962088; x=1748566888; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=i45otOSm+TkhMTHaG59UwoG0Q0Wz+ReqP6qkOsiZs3I=;
        b=mfGD89c5GaGeqR1CxkeZPlwOStK94+B6TBO6SfWFs1J6kXCCmUo45YSwqz8xluBne8
         A6qA5V5rdwoulengwCAHkWnGj6R8nQMoEypRzhqmaLZQRVK3WduTPBXdb6w/gF+u8FVo
         t/BLG8e84TrWuGUoljIJ60BR6wWWy6blkV/7/EiYY32weq7bQlegtcBBCQS/SpTmx2Nz
         GhiSotX1q0Y1BotZzR+lxxO0tjqBSA9mgzK20vvU3Z1xgKFmABun7qNzDsiRyms9hG0A
         CoDlGf6vrLislIVU0TsoCtk/TxwglpR195f4scbP7QSFr8IaVjm4ASv4xklNETpgv+P0
         9hDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962088; x=1748566888;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i45otOSm+TkhMTHaG59UwoG0Q0Wz+ReqP6qkOsiZs3I=;
        b=Wd/qmpk0K804uyemvZ6iUd9xMVNMxBLVSfGlc2pS239FgeH/CthS8sF+k5PIZ7lsMj
         ejLIhv4v7gZi17jy6qVLyehYEECu09SF+K3+7JgSKWOqcqDLhWrveWXXvpaMj+UJaaik
         Z7nj7ogeu8zGeSEhdwSLdrFSVZZ6Y4sITlG8C2SP3FTWHiF60behVBH5kIqG0P3qEPFQ
         20FXwcg4yTxu9QRZGhzsDKEWobgZO/fk80ED5M7xc6KEBGgUpOXb6zJW81qRaewZg8aI
         b4Ntz7QDOd7l/xkcKUpc5sZ/ShCdGcFlUJV5f5aicHDUMIdWu+Z6ghxmAxLbd8sfAtoZ
         TAwA==
X-Gm-Message-State: AOJu0YzeHiamLfuTcyeW5KAqya7Cv9qQHlI7Q10iNXQVOHrwJidYK88p
	p0KieHnIukw5TM9xpIAWBM0BxzFXZz29847ZeMvV00Y2QY1cAaNkDtxjGMYBanIw4I1u0A2+H9V
	tSlP1FA==
X-Google-Smtp-Source: AGHT+IGKXUDv5+WdC/0P78GDw78LzUL5LFq8JfcqEQP/cHtEYBO78G4z6PZ0oz9z2Xbic1SU/rHQzxKGAu0=
X-Received: from pfbgx21.prod.google.com ([2002:a05:6a00:1e15:b0:741:cbad:dafb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:928c:b0:742:a77b:8c3
 with SMTP id d2e1a72fcca58-742a978715fmr38003734b3a.4.1747962087855; Thu, 22
 May 2025 18:01:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:51 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-47-seanjc@google.com>
Subject: [PATCH v2 46/59] KVM: SVM: WARN if updating IRTE GA fields in IOMMU fails
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN if updating GA information for an IRTE entry fails as modifying an
IRTE should only fail if KVM is buggy, e.g. has stale metadata, and
because returning an error that is always ignored is pointless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 24e07f075646..d1f7b35c1b02 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -834,9 +834,8 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
-static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
+static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
 {
-	int ret = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_kernel_irqfd *irqfd;
 
@@ -847,12 +846,10 @@ static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu
 	 * interrupt remapping table entry targeting this vcpu.
 	 */
 	if (list_empty(&svm->ir_list))
-		return 0;
+		return;
 
 	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list)
-		ret = amd_iommu_update_ga(cpu, irqfd->irq_bypass_data);
-
-	return ret;
+		WARN_ON_ONCE(amd_iommu_update_ga(cpu, irqfd->irq_bypass_data));
 }
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
-- 
2.49.0.1151.ga128411c76-goog


