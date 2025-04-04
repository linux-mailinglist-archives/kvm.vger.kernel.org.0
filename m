Return-Path: <kvm+bounces-42702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 974A0A7C498
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E84A5178D58
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 20:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1391226177;
	Fri,  4 Apr 2025 19:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sm8m+KMp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432A92206A6
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795617; cv=none; b=gj+V4LYMHVQ5G6V49RkmDPCG5XsZD1EJzE5l7QWpUISz4m8byuwPxwqZREPrs6e4DBwag28p2oMNSWgezxjSrsHjrf1EWzZnkZVzmueYbNR0rzREINF4uKD6Y1sYU6+6eLcneO1qjbqOe8icKDjqP6hvAqyHxDg7AUAyKfVt2RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795617; c=relaxed/simple;
	bh=5pcNK2/F2mUD0tglxtkkvS4t6gF1WjE0uv3B3h/LLIU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pI7msuywo0+CCoOWKPuye8Qpky99vGtiu2V/j6BKkE/jMqgPFsCW/oUl2nnSEkq+1+7JGaCHlSEKAKgewDl7X+MeD9Dqnfuy7MJqOfBrZm1AwqCzSjiwb0xMcygIijYaYi07k5T5uBaCmpvrz87/PUFkcefxLPmK7c4i9OQfX6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sm8m+KMp; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2265a09dbfcso29811935ad.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795614; x=1744400414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xGc410CdItV9i0XHHpZ/RMSaoI91XXBZ8UWJ2P2MUyk=;
        b=Sm8m+KMpEXHRY0LbMZcaS4gqHs9inVmDUniOFX9zK6bkWNwtjozjkZgBZLZ3E4iOdP
         WRqYj2izdeIED27bH7h+HA8nH46gmuuAdMvBD512JQn7gH/Le83cKWBDk+zzUyuRUNqt
         PTzgQrC6urgwyPleQMDal3bdVUJ3m78TBWSl1fVpwrgUD1NcBQLkm1fzEXa6fFgJiHx7
         C18xVSI2lwQB5GWn1lld1cCsEYwgP8pvmUvaZ73mLicsBFHaxlj5GTEQcnogrAJokoOa
         X4cdRsabQKbIN/seASHMrVCDfoSWHlSIbN8RIYFuMeidHWMU+ZKz21drSMogKp9mG7Mx
         SXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795614; x=1744400414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xGc410CdItV9i0XHHpZ/RMSaoI91XXBZ8UWJ2P2MUyk=;
        b=XztJ2GGj+jYJUravfz1/dGZME3SNhu45VLEHRA2hsbsLxZBW95k7wlla43YEWfuCQJ
         o+CBPmk7bt8/5iaSKFsj3zGo7CpSMgY3QTwHypkkn+cbZ/4wP6d4nfp2Uvyuu9TE+OU+
         D157QcU91L8UdnuvwxZRW8zmERmiR3oM+xSh6Y2GErlL+y5Lef4XpWesmgd21cdeQ8H0
         +JPI7KcbnWEhkqdObA2cOgIF0BLI4G2KJgFX7g939buksmn9Ss0gl2Ctx37VF2xArJZF
         d9IziAQI4czs516A0Jde6xVrZMj1cKxGECveliVbSDu0HDgm4BJj2oNdw6kt5ljpcpwG
         Oinw==
X-Gm-Message-State: AOJu0YwnRwsee8aXBmUthktOHDKk7h5kXrbb3PRvh/tNqLrxoDwpvc+r
	m9rOids6zy0uEQoLntX6MySkPDHyjdUUopKX2g7zrdhxBYInFutq1YDVtDOG+lP8f27ct6au6ot
	zzw==
X-Google-Smtp-Source: AGHT+IHtyu5/n45SoUCdmyRwx78ZExMmcLv2DVkaCFXoZBFEW/oA9gYZTnVIAZvyMAiWmV0cdXBxBQzi80A=
X-Received: from pfks21.prod.google.com ([2002:a05:6a00:1955:b0:730:848d:a5a3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41d0:b0:223:4bd6:3869
 with SMTP id d9443c01a7336-22a8a85adcbmr56111145ad.15.1743795614550; Fri, 04
 Apr 2025 12:40:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:31 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-17-seanjc@google.com>
Subject: [PATCH 16/67] KVM: SVM: Inhibit AVIC if ID is too big instead of
 rejecting vCPU creation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  9 ++++++++-
 arch/x86/kvm/svm/avic.c         | 16 ++++++++++++++--
 arch/x86/kvm/svm/svm.h          |  3 ++-
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 54f3cf73329b..0583d8a9c8d4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1304,6 +1304,12 @@ enum kvm_apicv_inhibit {
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
 
@@ -1322,7 +1328,8 @@ enum kvm_apicv_inhibit {
 	__APICV_INHIBIT_REASON(IRQWIN),			\
 	__APICV_INHIBIT_REASON(PIT_REINJ),		\
 	__APICV_INHIBIT_REASON(SEV),			\
-	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
+	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED),	\
+	__APICV_INHIBIT_REASON(PHYSICAL_ID_TOO_BIG)
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index c8ba2ce4cfd8..ba8dfc8a12f4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -286,9 +286,21 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/*
+	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
+	 * hardware.  Do so immediately, i.e. don't defer the update via a
+	 * request, as avic_vcpu_load() expects to be called if and only if the
+	 * vCPU has fully initialized AVIC.  Immediately clear apicv_active,
+	 * as avic_vcpu_load() assumes avic_physical_id_cache is valid, i.e.
+	 * waiting until KVM_REQ_APICV_UPDATE is processed on the first KVM_RUN
+	 * will result in an NULL pointer deference when loading the vCPU.
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
index 1cc4e145577c..7af28802ebee 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -715,7 +715,8 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
-	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED)	\
+	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED) |	\
+	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG)	\
 )
 
 bool avic_hardware_setup(void);
-- 
2.49.0.504.g3bcea36a83-goog


