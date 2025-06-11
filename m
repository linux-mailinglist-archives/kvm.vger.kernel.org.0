Return-Path: <kvm+bounces-49198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CC2AD6373
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:05:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 957DB3AED88
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25DD2D8777;
	Wed, 11 Jun 2025 22:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IGVh95n3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650942EBDDB
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682107; cv=none; b=eNCNtMJ/Lr7no7xUlCeGCDRDbBCJkTzmKVj2urnpz++6FPhGhyJk9l2E3mU3/MegwqlIzwLluMcsoJ5A40oFFFXt4QWMdV6lsxx2ABuzXYLcp7Dt3TtDWyZHfWetBUjwEJpEprvNeBpVPByyt3iLF4AhiGQJi3iBQpaxxy1NENQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682107; c=relaxed/simple;
	bh=r1qowrD+5mrr7O3Q5l0aT1/ECvFqb3PfiIao4Lw8ZLM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CeDf8sRXpgRnsdmvgdMDixvSX+2WNC/qQNZloJCPePC9mPFMjuJG7qo3OakkE04Z7Df7phjqL6WIwubyrnesk3okK6QO/meCMAZVObrmeLeSWjx1vEhEMxxJl2LCg6IVuv07vL9IOnBcHZxLS+IAnXHPc3j33PN0s+cPIUSkRA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IGVh95n3; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313b0a63c41so437786a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682106; x=1750286906; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IGf99uYfCeKKIiWjOntmH0IBPd07aaYxxPMUaWxgCJ4=;
        b=IGVh95n3/e0lQVwTcg8KeZg5hrVjTrNWE3Caj+VeMjTAkMKzC4kN8hkYtg2FCT/vr7
         ou6Y1gaBefeDW4uaKzlgduxSAcZvA6ZOsCHwmffrOqaMfXRiEEByN5lImsD5BpXd639Q
         l2figzAO2lEfXJlsIUupMIKrs4p5QPIhKLU5Cn05+/sg4te43UfF3mH9Gq/WbQxqU4ec
         yq+wtaJnsqrbS8IC9YFuC5VQDaDu4bjA0zOCxl1ALgjEe/hpt2BCpbIpO+sJ5Brtoxw6
         fL5evOk1j/KnnPG3noa71WCTl5AH20ryJ/UPac61QGIUbYvgXcL+O6ZhZD94wBKVolPg
         SkrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682106; x=1750286906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IGf99uYfCeKKIiWjOntmH0IBPd07aaYxxPMUaWxgCJ4=;
        b=pR9fWk1jhkde7Zw5v1KI7JcCOVumBsLnws/gzy4EMLPGL/peUjwHnECHxr752vZ1gy
         NFdaRYMvrBA9+osySYCCYhZFx6kXMwfSmewgyDKezSISDDHbxkwIcM5EQSRJNYmnwUU2
         KQ+G7mWM+vXHW5WRVfxIuISoZrgPvI1BBcCJheGOT+kCZdQ5geKRTNRP8OY+MCepdrMM
         67Ghk1qFd6PAwiMkmXlORTf1y8M/y3+TE1Me8QqhvK2hlS9GqA5KzQwM81Uez4MukivA
         sYdgtCbwNmyb2hYdAkwXGTAmQ5JQ9P/Llush2xFnB4s/qDhUAEtMWeUzpAAzj7nhZaMC
         zRMQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5bcBc/6aK6uf1bEBRsq25F4y9slct6pefxZOquikEjrxjB/0z337OrhTLGEBnCVp7hpg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2ncAcpJvLE+RJfebdos0PB+hkgoI05uk1/WPbcj5IcUXtcvzG
	Gg+QoMplwKt/kMR1oTNhSFoUqAAkSUZPJ7xWJQmcX+YImQ24VtbGgMGCcadKeASVantBn0Z9BZd
	G4gY2RQ==
X-Google-Smtp-Source: AGHT+IGG/WcYDrf0RYZY38gj5X+aWB3PmGw41sTQaNqsS8Agp4VOiMJxViIe5RHbEl0OLW/p9vLLmH6GAsE=
X-Received: from pjee8.prod.google.com ([2002:a17:90b:5788:b0:313:285a:5547])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3510:b0:308:7270:d6ea
 with SMTP id 98e67ed59e1d1-313af22d60bmr7017390a91.30.1749682105816; Wed, 11
 Jun 2025 15:48:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:55 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-54-seanjc@google.com>
Subject: [PATCH v3 52/62] KVM: SVM: WARN if ir_list is non-empty at vCPU free
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
index d1f7b35c1b02..c55cbb0610b4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -704,6 +704,9 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	int ret;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
+	INIT_LIST_HEAD(&svm->ir_list);
+	spin_lock_init(&svm->ir_list_lock);
+
 	if (!enable_apicv || !irqchip_in_kernel(vcpu->kvm))
 		return 0;
 
@@ -711,8 +714,6 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	if (ret)
 		return ret;
 
-	INIT_LIST_HEAD(&svm->ir_list);
-	spin_lock_init(&svm->ir_list_lock);
 	svm->dfr_reg = APIC_DFR_FLAT;
 
 	return ret;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 56d11f7b4bef..2cd991062acb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1497,6 +1497,8 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	WARN_ON_ONCE(!list_empty(&svm->ir_list));
+
 	svm_leave_nested(vcpu);
 	svm_free_nested(svm);
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog


