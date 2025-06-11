Return-Path: <kvm+bounces-49158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE351AD6312
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F5DC460069
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 783852C324F;
	Wed, 11 Jun 2025 22:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bzd2qr87"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99B328DEFF
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682039; cv=none; b=V1Zhg56KQysGJ3tt1aZQ0lTbtTgxnSK1mQewJvMeNEM+HNV7JLWG/72AcAdylAyuO+gtu5kiwmEZ+Ur8o43KIStrcKFuxF5U470jZq3TtstV6RfVpSj5rcDfaHipohSsLr2Hp99wJYx7WB6LaSslFqpkrDXQpaAfh8u5PQH0JY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682039; c=relaxed/simple;
	bh=BWLasIdcw5f8vbjvTCVYvqRanf2FcgiZB1H2kqLovb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jQ/x0mGz2H2VYfnx1AlvhcW2YiZIgPMWTAppkuXCNYwm+PfI6ZbQM+lwbZdSySAcLR7UI+e/dGO7dE7nkLMnKZdOMjpst2d9lYp7lxWTWdzUKagn37I0emwoNQEUcUBXjHkBHVgLNuAHYE3Zkm2epjv/P5oT1vbaSoyGtGiKhAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bzd2qr87; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74880a02689so83593b3a.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682037; x=1750286837; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JgCcXi1lmHYVbCUjIr5w9EjZ1G5EUAljNN15QlkwBdI=;
        b=bzd2qr87VQios6haCQPEVP1MQ1w9PAypTlPcN3qVIWKm8JuuaxI0ChITQP/2DsufJl
         F7mG5AJEiOSFlPd/6A8LUZVwpAwTBxaOkvE/sYYuehYTMKugd8jxawNeMPW1VHm6GDls
         ktqspYUlb1VEM27kMmlgAd73InzdHYYKe7DlWS2K0NMP/GN1Kai05LRHLabRLBecB5+D
         pbqNMS84KhH8bobxoHa+osFPJmKRFS+2I8LeZLm2wuBxyIXwAg4tChHuQn8a7bQpU9BV
         eYjs5CHU5qmwqWpO6mKWR1ZoMO+mzxAtvEwkeMkbUE1cjdOs8kEa17CUpa/GJO8rJRNy
         lo5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682037; x=1750286837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JgCcXi1lmHYVbCUjIr5w9EjZ1G5EUAljNN15QlkwBdI=;
        b=wS+gYd/GOu4g6yPXJqO7nhYsbS5eX8XvRJwEMp+Qi9A3dxMhpG1DmIHPLUM7IX623r
         qOkn39JLhQpEmxZctcELDU2nK93JIzAtMVZzDceELBwn/LeTkxTIZWPNY6zm5HUxzW11
         uHP2cRTneFu9na/kiMAx35k6G++fmJvaXk4CUcHn9mPkpepwaK3Jnv3ms7R7NN0i/ST6
         J4Gt4GnXau0AC20QDvr5UI92tdxQuAX2vyckJpX9WfeyAZ4AyJ2XDb905Tix4T7PMYqn
         8dhycnq8iig5AK1MwOYkazqYwQraye0tnMaW7499kTCe+5nQPGcUpMFxTOUBYfXU1DQU
         sufQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8mx9qCJVlEDDfC8PCmEQJjhTUpPWHFaTrIk+SaPJT5x+hM6TKMEz6fbdHvrQuZwrzLm8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0hEMdUu7R8u2vSQkxOawbUqW79iVmNKZBXOvAjDFqUB2KtgPP
	Te0JGohShoQ/s4pYzprVgw6nNRvY2wpG8bgcqmHypiYM98CLFsz7ECwUQ2LfcNyLBiDomuLNmkB
	Mwjlhyg==
X-Google-Smtp-Source: AGHT+IF4EOTklxmbKRQMt1i+V76Dzg8HGe7ggrexZxq1G9OoEFFOTzeyCP2Mfh9kf82SvgKjm1r87uoXRu8=
X-Received: from pfbna4.prod.google.com ([2002:a05:6a00:3e04:b0:746:2ae9:24a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:8882:0:b0:73d:ff02:8d83
 with SMTP id d2e1a72fcca58-7486cb21c08mr7745118b3a.3.1749682037122; Wed, 11
 Jun 2025 15:47:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:15 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-14-seanjc@google.com>
Subject: [PATCH v3 12/62] KVM: SVM: Inhibit AVIC if ID is too big instead of
 rejecting vCPU creation
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

Inhibit AVIC with a new "ID too big" flag if userspace creates a vCPU with
an ID that is too big, but otherwise allow vCPU creation to succeed.
Rejecting KVM_CREATE_VCPU with EINVAL violates KVM's ABI as KVM advertises
that the max vCPU ID is 4095, but disallows creating vCPUs with IDs bigger
than 254 (AVIC) or 511 (x2AVIC).

Alternatively, KVM could advertise an accurate value depending on which
AVIC mode is in use, but that wouldn't really solve the underlying problem,
e.g. would be a breaking change if KVM were to ever try and enable AVIC or
x2AVIC by default.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  9 ++++++++-
 arch/x86/kvm/svm/avic.c         | 14 ++++++++++++--
 arch/x86/kvm/svm/svm.h          |  3 ++-
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2a6ef1398da7..a9b709db7c59 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1314,6 +1314,12 @@ enum kvm_apicv_inhibit {
 	 */
 	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
 
+	/*
+	 * AVIC is disabled because the vCPU's APIC ID is beyond the max
+	 * supported by AVIC/x2AVIC, i.e. the vCPU is unaddressable.
+	 */
+	APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG,
+
 	NR_APICV_INHIBIT_REASONS,
 };
 
@@ -1332,7 +1338,8 @@ enum kvm_apicv_inhibit {
 	__APICV_INHIBIT_REASON(IRQWIN),			\
 	__APICV_INHIBIT_REASON(PIT_REINJ),		\
 	__APICV_INHIBIT_REASON(SEV),			\
-	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
+	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED),	\
+	__APICV_INHIBIT_REASON(PHYSICAL_ID_TOO_BIG)
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ab228872a19b..f0a74b102c57 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -277,9 +277,19 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/*
+	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
+	 * hardware.  Immediately clear apicv_active, i.e. don't wait until the
+	 * KVM_REQ_APICV_UPDATE request is processed on the first KVM_RUN, as
+	 * avic_vcpu_load() expects to be called if and only if the vCPU has
+	 * fully initialized AVIC.
+	 */
 	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
-	    (id > X2AVIC_MAX_PHYSICAL_ID))
-		return -EINVAL;
+	    (id > X2AVIC_MAX_PHYSICAL_ID)) {
+		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG);
+		vcpu->arch.apic->apicv_active = false;
+		return 0;
+	}
 
 	if (WARN_ON_ONCE(!vcpu->arch.apic->regs))
 		return -EINVAL;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1585288200f4..71e3c003580e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -722,7 +722,8 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
-	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED)	\
+	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED) |	\
+	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG)	\
 )
 
 bool avic_hardware_setup(void);
-- 
2.50.0.rc1.591.g9c95f17f64-goog


