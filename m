Return-Path: <kvm+bounces-19822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4491190BC91
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 23:05:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AECB1C23A1D
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 21:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8837F1993BB;
	Mon, 17 Jun 2024 21:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T9S7Qxqr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDFD199224
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 21:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658283; cv=none; b=BUS2iK4FZMCtzDrOtLhszbn1uupPj0USz623/Wr4ReYKm6Jcw7GAsMDYy1abdF7j0AVGVvjOgFGk78XZhKeIuW8mwhpVFOQmWEJNws5c7U0Ho53piWPHNz31ORelttLS9eU2GE42w6lbrSG3RTlC8dP4AjLxTeXlMBd5G35KP2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658283; c=relaxed/simple;
	bh=hW9s4YrD2rYCAtJQRgt3dFVi5jTxIwhW6X+oURrgKkE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EsnDiluVQV9YV8Au6uSva2wHj7D6js1DpWwarekBWWyBKocvBXBJRbEP30KExVOdZRegmobkCRCoivkZDAdPYoQ2NAxuUWgSguRpJW2nvyME00jhiugqoJI2W7vtQc4aARtHv+eFxQp5X1n8Ppla87glc4JthRh0EHiXzfQz61U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T9S7Qxqr; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f6174d0421so40122105ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 14:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718658282; x=1719263082; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Elx1e+10wUymCoKo0AgjMeEwTIxlGaxO8TxJhQWkuZw=;
        b=T9S7QxqrZ+ulfy8M51ARGUBFCTwVo1ZMj3qOP+hLySX12kR4eu8QfRj8uUOP9tc4gX
         pp69/jYpB0SnoVH/4DhrIsUNPeib4VSF9XWPN5kCyhpzrUqM3En9kF6tDCluEv2AA1Gq
         y5egr/BpD+UkVP9aMgfu0NautNm2AZctYzmDECFR5uXv6CahONvvI6ictdGs6/fnJBWL
         f7q5+vm5Ga1/EjnFwQToIS2tpfU0DFq1j08yAKKKRXpb37WadrPIk8WbLqh8yU76KOjg
         zwlbFzhYVwWaiL3bVZMIv8EJRJ+zp9lpuqX2/yYFFVLaTfBTmNyfeFDsB4HxGcla+pqq
         bnHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718658282; x=1719263082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Elx1e+10wUymCoKo0AgjMeEwTIxlGaxO8TxJhQWkuZw=;
        b=ArdESWBX5QIvyEMaffh5qkeuJZei477+q6r4qoLkwoE7QcJ9i+sl0je2j4rcIMGmw5
         2UxtCqRvlCzAnyRX21zc/APBa71/0dfWMUO3e0Jwyl/3ylcQZpDXoTqgb8SgxRQ3iqHJ
         jNz+y80CTIXK2uXYTlhPaeHfyA8Ar/GivMimtw1Jw0WyroirrXKzYO+fShDgADQEs0oY
         Ltet3190FSMwtk4+Y7rqyycdN2SNu3jKbZssxaCtOnExRNDZUMNn7mvvjLmPWiMNiDHU
         SdVR9mvtkJhXCNGIfEGvPtl7vA4ieRE/G0TBd7KCoG1o7MczBg25i3OTW6U5tN67WHhU
         rmTg==
X-Gm-Message-State: AOJu0YzqO0/e4ajCjOaSSWCN6aK2Loc3hmkj33IuizgHR7xYioDloC7Q
	K6I9IeFF7OZ1/Mzy/1Tm+qf76NBCUW+eeA2fuEbqAWrZ5uk/c2L0KjLD/XosAMhmpkTLSsitpnQ
	/fQ==
X-Google-Smtp-Source: AGHT+IHVcy4Y7j/c4US2yEpq6Hsh5op4svsWFM9kBP2pbYfmm5OrsaaeQugHwwc3NlorTSy3w0NBPfkPyY8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2452:b0:1f7:3bb3:abe2 with SMTP id
 d9443c01a7336-1f8629fcc75mr1488075ad.12.1718658281620; Mon, 17 Jun 2024
 14:04:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 17 Jun 2024 14:04:31 -0700
In-Reply-To: <20240617210432.1642542-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240617210432.1642542-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Message-ID: <20240617210432.1642542-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: SVM: Use sev_es_host_save_area() helper when
 initializing tsc_aux
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"

Use sev_es_host_save_area() instead of open coding an equivalent when
setting the MSR_TSC_AUX field during setup.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0a36c82b316f..cf285472fea6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -570,6 +570,11 @@ static void __svm_write_tsc_multiplier(u64 multiplier)
 	__this_cpu_write(current_tsc_ratio, multiplier);
 }
 
+static __always_inline struct sev_es_save_area *sev_es_host_save_area(struct svm_cpu_data *sd)
+{
+	return page_address(sd->save_area) + 0x400;
+}
+
 static inline void kvm_cpu_svm_disable(void)
 {
 	uint64_t efer;
@@ -674,12 +679,9 @@ static int svm_hardware_enable(void)
 	 * TSC_AUX field now to avoid a RDMSR on every vCPU run.
 	 */
 	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
-		struct sev_es_save_area *hostsa;
 		u32 __maybe_unused msr_hi;
 
-		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
-
-		rdmsr(MSR_TSC_AUX, hostsa->tsc_aux, msr_hi);
+		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
 	}
 
 	return 0;
@@ -1504,11 +1506,6 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
 }
 
-static __always_inline struct sev_es_save_area *sev_es_host_save_area(struct svm_cpu_data *sd)
-{
-	return page_address(sd->save_area) + 0x400;
-}
-
 static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-- 
2.45.2.627.g7a2c4fd464-goog


