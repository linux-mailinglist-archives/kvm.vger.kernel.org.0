Return-Path: <kvm+bounces-47460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC27EAC1922
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:04:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EA6C50010D
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57EC2224AFC;
	Fri, 23 May 2025 01:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oYbF9q7k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24A62236F8
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962030; cv=none; b=n/QK3aKnvdw1gD1PREQyp4PaOyTN2L+dNvZ+k6RQrz605ZoezfY+mLXQqNT1Gj9vWeSLDBRLdXc41FWX8RigWUkZFAvtfeVATlv4tZdOIO5wQ9O0M0VRk7vahEN4Ukqd9I9kmDQY8cjQ9dLHUjGPL+2gO1o6kr10tYxIswniyMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962030; c=relaxed/simple;
	bh=OynwmpZzE+tOR+c6k83RPGCMFRJPHQO+vuelylIgD9s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Waw0eV0yVtlexr5ooj4A6Fam66DVt/avRUwvdggMdJRGdKL3PA9jPTYktjQpdb8jrnvWnvPrfJm9clO06gqhXq044Ogrq7Cl92yVBuyGHVc2Xne83bv75pOxSTkcOpltGFiFW+br35eOJeaQDewUAdifj8YXuIO656OYhJUsdBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oYbF9q7k; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30eac9886ffso4644979a91.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962028; x=1748566828; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=la0aXzVeKKVBiy8uaO6FAWX8ZpsMttxn3OpIPvBkLxA=;
        b=oYbF9q7kbDqIdGDE5LmRDxh2iSJnlpGLe+8nje7170u12thsBHr5ocsBk4f8GsL3cL
         kvPl/c/2A/cQG5F0mLLhgE3WE/yQNlQ3PUkXpwUeXvzBHF+bG9F0w6U0f1HTZYJ2k0e9
         e3NXlTp/FPjlUgDN44sdel+i9dSgevSOlbzGCBUteX9apD/Ql8j/lYWqdcZxJY9Zo9ui
         PcJryJgKQx11jurQ2LP5EQ8btsZOVC77TashGOGBvzmFKfeksrqOlXRA2jjqatge4H1/
         AucJSl7ljrkwayoee3UHeW5zG7bbb7ah+RIgEZlH1LIL+yAXnsvIeR+nrk3gp1VQdCw4
         z5vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962028; x=1748566828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=la0aXzVeKKVBiy8uaO6FAWX8ZpsMttxn3OpIPvBkLxA=;
        b=StanG9Jmo61qukeAJGw7ODey6w2/W4jINGX2K1m7WXOW65yAf3ZLHDcnD0PHK8XE87
         rHhSKHl7GnpVz3l0ReSWGdv78nliHEbYWXsADbdTqiB7LqOFCMctfo4jd7eIW7wA3wM3
         MqL5YYxN8pOfbnaS7J4sglGGsgr8WkO3Q8PoPLwi/YvmsZ+R1Qegl/4T1J2PHDksP6Lq
         LKO5tnQHZlCM0QzrvGW41lueQ8xghlpzZBqVwxu51a2MiFBZKzWjOjVFvLIzZLgsy7+n
         xR/Hm/f7DIHZ22XY8aVEOjBnhtcnBm3+InKpEdW5EvoIlrzpCOiWZqVs07kyD8s/d5PK
         hUBg==
X-Gm-Message-State: AOJu0YzC/6SDRbod79ZaOPJr0PxPsg+jm4guSVM3t9sYnkXCqltt9dDL
	M+FZ4xON5oQZRndSUHJIw9nvRMtp0pRk1pXD00mA7lm4xwAeJ5OIf+f+dKu0Djamy/1d1pB6jYG
	oH5XfOw==
X-Google-Smtp-Source: AGHT+IFB3ajdgTxrTXVysFpFaHJbw/mIl1eAI1Y8d57Q56yfcB9pR6oBP4Leg9XUSb1oftSrh5d450so4NU=
X-Received: from pjbpl16.prod.google.com ([2002:a17:90b:2690:b0:30e:7003:7604])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d44e:b0:2ee:d63f:d8f
 with SMTP id 98e67ed59e1d1-310e96c9598mr1763628a91.13.1747962028063; Thu, 22
 May 2025 18:00:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:15 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-11-seanjc@google.com>
Subject: [PATCH v2 10/59] KVM: SVM: Inhibit AVIC if ID is too big instead of
 rejecting vCPU creation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
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
2.49.0.1151.ga128411c76-goog


