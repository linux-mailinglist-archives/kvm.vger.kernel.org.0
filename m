Return-Path: <kvm+bounces-48912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC76CAD4662
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:05:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7A123A8234
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EDBB295DBD;
	Tue, 10 Jun 2025 22:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BKo7RoIF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9984296147
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596310; cv=none; b=NSpIaEmJofRP9npMrtWMPP9o4uFGHAEiy+Hd9aGxhdoaEKLk9vE4qcKCbDMlXOtC9wfGyVI52nqb2t8+nXOBgqAB9JfpNY/c7bRgh/9HEnv5GWK8ebt2ij3lGzjPmZNmtPI3THDaaaMQ5aGEbvRkfMFZUuKiPHTc0+wkeCOwQug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596310; c=relaxed/simple;
	bh=3W8zBfO4us4fjeyfCjy2wBE++xyIbNCjBla8RMXLlM0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VS9keCyvpuSA4bzY3I5cLBSeL0YD47Wjp+AJcOdVomF+b3IQhPDqyYxP+3u9SA8XRAcrZIdHCQ70J9FZSLlTpQz3ZVAF7PMATdalnBHPT+J1mWhH9mGphi3G4UGWiyFlWSw87Rx3TgkYSfekwzw1x78haXmlDPlMZXACN4bsSS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BKo7RoIF; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2323bd7f873so50431325ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596308; x=1750201108; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZO7RReyW+IQoV593Vs023wxtAUsIe6zgC5GuAJ1RIgA=;
        b=BKo7RoIFVtMtDO/60TnK4KznJ6iOAkd6Pbu7oFzMpjYN+EbuAslLHtxY5aMdbtCe8O
         FQmU7kT6tZWNe04kiUlck3/Y8AM9hS9G+5Nwx0GmNaitvSUVtIYHqmkOvA3dP7iswdKU
         x/4ve1GDENxLHWKbBZz4qGqz9COsC/lTS+YouD3dVS4JGekInIUMTVlY7tzL/PuJauSc
         FVjx0zvyhji7qSTm8Q1YeHNvltsqRhe6h7VxGTMiB2d5/E3ek+ex5oKDepy5b3VFQzd5
         weCQSXhpV3tolFji8joyx63CplhLwwsh5PoS5kLBJ5kGMsDlIFcbgjskxhVYwHvnQw58
         Hxqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596308; x=1750201108;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZO7RReyW+IQoV593Vs023wxtAUsIe6zgC5GuAJ1RIgA=;
        b=w3546WxXIJIJohbNcda37rKC6gvWGJtrCgQ+IDoaH5mOlM4RraFJxiRxlXj2/ktycv
         u+YwUTowoa/Qj3yfIpuLRycwJXmrFeZfpoepRFZST/cwbjsnKgpTUFWV5uqYuk7ouBkX
         gfPBl4ISSGrRwVm02tyWd0WWoyJDUqtfwFJn+dH9pCWASGQWAGkc1tS4BHip3CKWYtVO
         Q5gBwL89uNG4SU50zm/eAVdjFNp0fXxv9SThtK98RN30IwxSL+tCOfCS/UQRdy1dZuxm
         d6vLAiQ864Psv8QgqeJG5XWuZgbAIKEkOkALFvvdaJdxMnh3Y8sNiLGwmFexdsMwSsWU
         JIfQ==
X-Gm-Message-State: AOJu0YyxFeI75+l0JYCCSxox4nkZwTEQM5Fjzne9E+byGlPA7zYPjZum
	KgxE2FsK8atIUCZzSbFSwL5WhwLAkAFUlNve9vXaLqTgoiuSNOZ7kp6Oc555mKN1Tvvp6G/kl3+
	b4zjvVg==
X-Google-Smtp-Source: AGHT+IECfBJPvJrhVy9Guqg7jU3P/g39SPPVnfYnG0L9bVcS+Y2ydmzBHa3Br5U+Ll8/B2E54P8107oDqQU=
X-Received: from plbb20.prod.google.com ([2002:a17:903:c14:b0:235:7e3:203])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecc7:b0:235:e309:7dec
 with SMTP id d9443c01a7336-23641b19920mr12346965ad.26.1749596308098; Tue, 10
 Jun 2025 15:58:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:33 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-29-seanjc@google.com>
Subject: [PATCH v2 28/32] KVM: SVM: Return -EINVAL instead of MSR_INVALID to
 signal out-of-range MSR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Return -EINVAL instead of MSR_INVALID from svm_msrpm_bit_nr() to indicate
that the MSR isn't covered by one of the (currently) three MSRPM ranges,
and delete the MSR_INVALID macro now that all users are gone.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 10 +++++-----
 arch/x86/kvm/svm/svm.h    | 10 ++++------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fb0ac87df00a..7ca45361ced3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -223,10 +223,10 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
 	int i, j;
 
 	for (i = 0; i < ARRAY_SIZE(merge_msrs); i++) {
-		u32 bit_nr = svm_msrpm_bit_nr(merge_msrs[i]);
+		int bit_nr = svm_msrpm_bit_nr(merge_msrs[i]);
 		u32 offset;
 
-		if (WARN_ON(bit_nr == MSR_INVALID))
+		if (WARN_ON(bit_nr < 0))
 			return -EIO;
 
 		/*
@@ -1354,9 +1354,9 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
 static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
 	gpa_t base = svm->nested.ctl.msrpm_base_pa;
-	u32 msr, bit_nr;
+	int write, bit_nr;
 	u8 value, mask;
-	int write;
+	u32 msr;
 
 	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return NESTED_EXIT_HOST;
@@ -1365,7 +1365,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	bit_nr = svm_msrpm_bit_nr(msr);
 	write  = svm->vmcb->control.exit_info_1 & 1;
 
-	if (bit_nr == MSR_INVALID)
+	if (bit_nr < 0)
 		return NESTED_EXIT_DONE;
 
 	if (kvm_vcpu_read_guest(&svm->vcpu, base + bit_nr / BITS_PER_BYTE,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e078df15f1d8..489adc2ca3f5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -619,9 +619,7 @@ static inline void svm_vmgexit_no_action(struct vcpu_svm *svm, u64 data)
 static_assert(SVM_MSRS_PER_RANGE == 8192);
 #define SVM_MSRPM_OFFSET_MASK (SVM_MSRS_PER_RANGE - 1)
 
-#define MSR_INVALID				0xffffffffU
-
-static __always_inline u32 svm_msrpm_bit_nr(u32 msr)
+static __always_inline int svm_msrpm_bit_nr(u32 msr)
 {
 	int range_nr;
 
@@ -636,7 +634,7 @@ static __always_inline u32 svm_msrpm_bit_nr(u32 msr)
 		range_nr = 2;
 		break;
 	default:
-		return MSR_INVALID;
+		return -EINVAL;
 	}
 
 	return range_nr * SVM_MSRPM_BYTES_PER_RANGE * BITS_PER_BYTE +
@@ -647,10 +645,10 @@ static __always_inline u32 svm_msrpm_bit_nr(u32 msr)
 static inline rtype svm_##action##_msr_bitmap_##access(unsigned long *bitmap,	\
 						       u32 msr)			\
 {										\
-	u32 bit_nr;								\
+	int bit_nr;								\
 										\
 	bit_nr = svm_msrpm_bit_nr(msr);						\
-	if (bit_nr == MSR_INVALID)								\
+	if (bit_nr < 0)								\
 		return (rtype)true;						\
 										\
 	return bitop##_bit(bit_nr + bit_rw, bitmap);				\
-- 
2.50.0.rc0.642.g800a2b2222-goog


