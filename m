Return-Path: <kvm+bounces-48059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0CE5AC853E
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 992681C0093D
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5DC526A0C7;
	Thu, 29 May 2025 23:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DkEmLBI/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C4E2690C8
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562058; cv=none; b=pQAs51rz+ATVNBGFZgGMTqmjUV5EFQ2fWrZHtlA0/vLGZZ+z2cMryj5kpuD22beswQsG3GsFmINYz1SHdDlf0QD4N3h2UjCMzLkqEgFbDZ8H5DHuaUE8kBXmbqYQkd76Pi3V9MF3vmmrZiUIo1KDpnhZFx0uREIdi25zcxuggVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562058; c=relaxed/simple;
	bh=wiSfnvg+3ob6BZ0Eu3gekeRK967P9Nv3tIdvcIcKxQ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FOF7c1HWPPddH63RirNAM11+BboLGwcsOvhuOL1h+y3SLe8IkagMhv4e/NUbXPrHrN9Fdhu/8B7f/8Uw+1uK5xssh4xGg7SjBhk08QApT2O9az1wWUMSJ5ghR9OpvmSGjio9bg2oDLLF5PEml/nuXlx6DD5gQfBzNXZPCyfnMKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DkEmLBI/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-310efe825ccso1375116a91.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562056; x=1749166856; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+CgyWByAaHVV85PeVC13Q9ehun1/Wd3oFQ4GzRhsXCQ=;
        b=DkEmLBI/LEgYd2QJSbA27/HwX3AD0dc6dmG+tJ6rveX4K/IKKAfIlDZ1erOfPsICPv
         6vqm41i1/74DNCm/p8vtbWRb1Jci6r0UokkM/zYM6+/Pmn+cnlSCEyhSiBxuzGfrOfBm
         4rnQA1VxotQ58nk03g6Q6WY8h6AeIAdw+XOCQjvw1IP4vlCc05pdUN/d+uQEaXiesOHt
         esXM0ioW9sAOWt5y4CO2WfactTjOXtW+5rXsECHRlq/4caGcd2+ClKZQXvFIoyy6V58z
         /T3HCnISGnJy1/6yrnth5mxutGF8rEvTa09VwD2cJN2ms5WrhVFpH/ruD5n2SmEb7+xu
         x/RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562056; x=1749166856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+CgyWByAaHVV85PeVC13Q9ehun1/Wd3oFQ4GzRhsXCQ=;
        b=pZPouPCQabdWL8hP3aFq4HqIVJaXUqAvvjT+tTmc/1Z5aNyKecezj/pqHGGmlKNW7K
         2IQ4tejsTh9yf9slLRF0/p6HFm1jIAi6ndpMLjovkdqIbN1MVjj2RF7aZ4saukQCCFrM
         vuNrkmy0YMu0FlN3DxWA8obdLT3SP+lz0k+wwCUalERRBNExhRGktC9amTNoezWozimi
         vpAprqsvDJsMdDSI2+cz1sR7wHvwHo5a21bysgXVNWRWbCCLwfVILTuHui3UHcfYMNGV
         zy/LipQfM5l/AnAQ8XMWS8ZtTKpAFGJK8vY2L55A9Y9kXakVnnDisEBP4qeXvuCGc+aw
         ENUA==
X-Gm-Message-State: AOJu0YzsFgWQ2XQ7hknZKnSMToIkPcizEklsnhiMaWfeb1Lgob+xyfIB
	c6XYz++De6tF2+nrECT1r8QmRkx3J1Bb8lOyeUzd7H3VIVFmZrtOz+nacjP3QzTko4Kji9R2UJr
	3tSwe7A==
X-Google-Smtp-Source: AGHT+IGo71TMXPlGjlEtx+9KCFpk1shtfB/J83ECXF+TfIzjn3vXYzFl65S88oW17CFw5334ijpYDq8c4lw=
X-Received: from pjp3.prod.google.com ([2002:a17:90b:55c3:b0:312:a03:ef54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f4b:b0:311:c939:c851
 with SMTP id 98e67ed59e1d1-312413f92e6mr2030455a91.4.1748562056573; Thu, 29
 May 2025 16:40:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:40:08 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-24-seanjc@google.com>
Subject: [PATCH 23/28] KVM: SVM: Move svm_msrpm_offset() to nested.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Move svm_msrpm_offset() from svm.c to nested.c now that all usage of the
u32-index offsets is nested virtualization specific.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c    | 27 ---------------------------
 arch/x86/kvm/svm/svm.h    |  1 -
 3 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0026d2adb809..5d6525627681 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -187,6 +187,33 @@ void recalc_intercepts(struct vcpu_svm *svm)
 static int nested_svm_msrpm_merge_offsets[6] __ro_after_init;
 static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
 
+static const u32 msrpm_ranges[] = {
+	SVM_MSRPM_RANGE_0_BASE_MSR,
+	SVM_MSRPM_RANGE_1_BASE_MSR,
+	SVM_MSRPM_RANGE_2_BASE_MSR
+};
+
+static u32 svm_msrpm_offset(u32 msr)
+{
+	u32 offset;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(msrpm_ranges); i++) {
+		if (msr < msrpm_ranges[i] ||
+		    msr >= msrpm_ranges[i] + SVM_MSRS_PER_RANGE)
+			continue;
+
+		offset  = (msr - msrpm_ranges[i]) / SVM_MSRS_PER_BYTE;
+		offset += (i * SVM_MSRPM_BYTES_PER_RANGE);  /* add range offset */
+
+		/* Now we have the u8 offset - but need the u32 offset */
+		return offset / 4;
+	}
+
+	/* MSR not in any range */
+	return MSR_INVALID;
+}
+
 int __init nested_svm_init_msrpm_merge_offsets(void)
 {
 	const u32 merge_msrs[] = {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9d01776d82d4..fa2df1c869db 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -195,33 +195,6 @@ static DEFINE_MUTEX(vmcb_dump_mutex);
  */
 static int tsc_aux_uret_slot __read_mostly = -1;
 
-static const u32 msrpm_ranges[] = {
-	SVM_MSRPM_RANGE_0_BASE_MSR,
-	SVM_MSRPM_RANGE_1_BASE_MSR,
-	SVM_MSRPM_RANGE_2_BASE_MSR
-};
-
-u32 svm_msrpm_offset(u32 msr)
-{
-	u32 offset;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(msrpm_ranges); i++) {
-		if (msr < msrpm_ranges[i] ||
-		    msr >= msrpm_ranges[i] + SVM_MSRS_PER_RANGE)
-			continue;
-
-		offset  = (msr - msrpm_ranges[i]) / SVM_MSRS_PER_BYTE;
-		offset += (i * SVM_MSRPM_BYTES_PER_RANGE);  /* add range offset */
-
-		/* Now we have the u8 offset - but need the u32 offset */
-		return offset / 4;
-	}
-
-	/* MSR not in any range */
-	return MSR_INVALID;
-}
-
 static int get_npt_level(void)
 {
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 23e1e3ae30b0..d146c35b9bd2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -673,7 +673,6 @@ BUILD_SVM_MSR_BITMAP_HELPERS(void, set, __set)
 /* svm.c */
 extern bool dump_invalid_vmcb;
 
-u32 svm_msrpm_offset(u32 msr);
 u32 *svm_vcpu_alloc_msrpm(void);
 void svm_vcpu_free_msrpm(u32 *msrpm);
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
-- 
2.49.0.1204.g71687c7c1d-goog


