Return-Path: <kvm+bounces-10193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C999D86A6BF
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:43:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F615287B7A
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7730250F6;
	Wed, 28 Feb 2024 02:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="36imo14K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBA122F11
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088125; cv=none; b=cXZmr5iKMTL4f3w8MUY6DnRDDt3Ty0Rt7lYFNqFa7q8YNNaQH+e7LnN4kWdX/59bTtQqhcP89CSXTJyiSVd9Nch6Gbmdg2qu/HA1liPHi1MBaq8evZJ8gHlGB4+tQ1VnG+KQIeFrazPWuFB2fJR/3lgayR6B+SpfH2QFqPBYDRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088125; c=relaxed/simple;
	bh=L+IvU42/MjztgCK7ijdWOl+7+6gX/ME9VFnO9RlLhcM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F9ruXaH9f4ZAOffnrGSof7QOUYX5vAoUqrbQSLD/tL06U9/q6QE0Ch0iJb7mjlWYz9BmMaIY8JDlG4Dgno9SZKBKigUZ5qoZdRbPxS70nho+Hfq+OHiXWllCmuGP58mbgEhnArqWShojqs7485EfIeYUcnZxwWRX+CD1EEiR8EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=36imo14K; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e568271a21so18239b3a.3
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088124; x=1709692924; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=K1OBRBk3Vku2bidIof7TOH5MpGEdlnRqjgwLLM8pKvQ=;
        b=36imo14K2mj75sRhHOFdmZqXxsk4fKgN5mdj1SxJvCB4aTXpxsKec8kRZ/s3y80NKg
         Cmb1nugw8vHc0/BoCO2dZiaceUfuCXGX1GIhOaTJVjD06w1nwstw86zDulVUEExiQug7
         ttQm0KqKUi7+UByKYvmWuxKYMbvdn4XEKlnmgCMmD4Lps/qneG9vEJhM/RQMEV47tjEt
         Kt4d6c+kkwv4OTYDdCCFzYb7XeP/l2LfaE7XPQHywZXaBew+vAHi5WGmRU6zYwxkwA6N
         R8jbSS0BuuHRENoFmsPXfP540dJR4/RBNLymQkT58aMI83bMhThh66yKTmn2wdpmm2vD
         Xb/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088124; x=1709692924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K1OBRBk3Vku2bidIof7TOH5MpGEdlnRqjgwLLM8pKvQ=;
        b=PJ9Scx6jAQhIHQ0kUGoeTt0eoSE8sYHPsPFqdigfpLNMqbEoLBQNVkWutwU6YHI0MA
         2QN9eks5/NST5GQWT+l94tVIw1D2O0pp7uSYcuRNvNnkmwyCssvUHtRNVM8JwjwuA31d
         JyyzLYXwPwisfBy8IuM8LJ3un7IQjiHlIpiDhPNq5FOwqeMZl6u/gcsCQFbQzm092m0X
         nNRW+6R1QO7MriUjM2mrcSaNB3gN/Mp/23eGYL5iTKsphTG7SBnmB10BCAygkHgnrMI9
         w6+Hjqv74WWQmaZBOiJg3N6C6+MJclnKwXMuzMCCgix8sE0dgcfDmkso0amMXEZc98xC
         llaw==
X-Gm-Message-State: AOJu0Yy+69MPrD3dfh9crhaKC7gRfiQK38IVp64cx5LXX4pKJlF6rGHS
	mujFO0UFd2h4wI8Y6pMafSJgsB8MbxpN19WRF6cChJalC836vZoXe4KzjgtMGtFaVlDNKW5bCUl
	CJg==
X-Google-Smtp-Source: AGHT+IGQjZ5u9lsKdd55GvF9bKJDkjcEFySqssBNTDbI7xO0OMlG4FC/aQm6rWPNPLP5+jfE28ifC4/mWLY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1aca:b0:6e5:1196:1277 with SMTP id
 f10-20020a056a001aca00b006e511961277mr75263pfv.6.1709088123599; Tue, 27 Feb
 2024 18:42:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:38 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-8-seanjc@google.com>
Subject: [PATCH 07/16] KVM: x86: Move synthetic PFERR_* sanity checks to SVM's
 #NPF handler
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the sanity check that hardware never sets bits that collide with KVM-
define synthetic bits from kvm_mmu_page_fault() to npf_interception(),
i.e. make the sanity check #NPF specific.  The legacy #PF path already
WARNs if _any_ of bits 63:32 are set, and the error code that comes from
VMX's EPT Violatation and Misconfig is 100% synthesized (KVM morphs VMX's
EXIT_QUALIFICATION into error code flags).

Add a compile-time assert in the legacy #PF handler to make sure that KVM-
define flags are covered by its existing sanity check on the upper bits.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 +++---------
 arch/x86/kvm/svm/svm.c |  9 +++++++++
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5d892bd59c97..bd342ebd0809 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4561,6 +4561,9 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 	if (WARN_ON_ONCE(error_code >> 32))
 		error_code = lower_32_bits(error_code);
 
+	/* Ensure the above sanity check also covers KVM-defined flags. */
+	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
+
 	vcpu->arch.l1tf_flush_l1d = true;
 	if (!flags) {
 		trace_kvm_page_fault(vcpu, fault_address, error_code);
@@ -5845,15 +5848,6 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	int r, emulation_type = EMULTYPE_PF;
 	bool direct = vcpu->arch.mmu->root_role.direct;
 
-	/*
-	 * WARN if hardware generates a fault with an error code that collides
-	 * with KVM-defined sythentic flags.  Clear the flags and continue on,
-	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
-	 * flag that KVM doesn't know about.
-	 */
-	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
-		error_code &= ~PFERR_SYNTHETIC_MASK;
-
 	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..199c4dd8d214 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2055,6 +2055,15 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
+	/*
+	 * WARN if hardware generates a fault with an error code that collides
+	 * with KVM-defined sythentic flags.  Clear the flags and continue on,
+	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
+	 * flag that KVM doesn't know about.
+	 */
+	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
+		error_code &= ~PFERR_SYNTHETIC_MASK;
+
 	trace_kvm_page_fault(vcpu, fault_address, error_code);
 	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
-- 
2.44.0.278.ge034bb2e1d-goog


