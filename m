Return-Path: <kvm+bounces-48913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 29FCAAD4666
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4ED4A7AD0B4
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B8E2D104B;
	Tue, 10 Jun 2025 22:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H08fBhPl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6222728EF
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596311; cv=none; b=YYhtOxdHUPWQ58Jvhb3LK//Unh0nVArUbLr2IA1z6d28NOoWCpJ8tKT3h7gDyT2rH44zhji2e59Hjqi9omgye/SKgLQ8BX9ZrT3nNUSKKZsdw3uRy8fnL2w4/E2u4yiLEgHT79BPnA3TnBsilyTUMNN2sqOaBFvSImK3qmYpRVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596311; c=relaxed/simple;
	bh=8NMBQOCUZTnUF9bMbeLcv+0oeOUiSq+zhN1NQGpaPdI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=klwIVZXAtG3awhERErdPeyEwVdLmAEXdQXLwf9Fde4NbwULI1zPux5eVTQCA4GaCbYqt8BpFBoARtdnF2z2/eSjKu51b5BIDrxj6F/kw8cZJXwRh37NflJD8eQhFzWq5xXjyb9398N12VaIDk5lDVpiaWcADfIX+cAI6lkjTUYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H08fBhPl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a39fa0765so8614680a91.3
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596310; x=1750201110; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ercvOy9gSaz/2KYqxyQat5mFHIbfugbgpQQnPekIEBg=;
        b=H08fBhPlhd/gYyBg/27O+2e/reVllsvC/hx5HQGAM7yvx21igWobfKLzOMvbbMKeVd
         5QSA6cXXZA1CYjl3bJjZStpDW4VC+ydHwdQDUwB+5VT54Fx4zs6TY3JkdDv0uckbt+IV
         Y2Da7PYm0DPqR3+J6Zfw1qDDRcUFpqp0wQxYl/xXx/EOj5d0//HadkaX3yp9P67koGcq
         0l1ItOcYE3MDaiVIOqZxERFJEyqeGlCCEihe5CHXWlp/PsLg5TitUF+nCl4ZvzQ1pl97
         RWQoD1R0OWlibF4NduDh/ey0iebvBJlGCaAMj0bX4hyKkiB7tNaDZfkjLIL/Vcqsj5Nj
         11fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596310; x=1750201110;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ercvOy9gSaz/2KYqxyQat5mFHIbfugbgpQQnPekIEBg=;
        b=FvCWhegXMbGj6fayoDqHIjH/X+fl0y8TWdh/t559UeP/4mqGuIqazlXm9WTa/wp4AN
         5/bUdrGYv/B4qjL4d0CLsvFXSPP2/q+2Pgw0sf4+jazKtmIzqeB7C4Yg4lZNpR2HYMGZ
         i/Zs9f7mz6Pfsp5PBVk5yczgoS2a/j/viC4DMfVPaONuJNeSluPBNeof3iPSz6kXFzWp
         940bU3WZJH4iQjVgHLfi8+GU5efCS2iwssHviX9XiQ7FxouG+BTtNsEvjLkuis9h6gpj
         SdalkLIMVlUdGOlmlRxa8yr/36KbCgCKM5FsEE54C2FSmb0QXZdWyUl7QVEosEc5GSgH
         c0nw==
X-Gm-Message-State: AOJu0Yx76lm6iZNLd0VifY+CYIIOyIxiXZ03H+/G/zpCNSPMoHdS0HTM
	gV7bweaueiEayfCU/14fbIkPn1KGzfy570KlZ1i0MyfThaQ9uZGXYtn1mf24fOVCemjE6XAl50V
	Xz5iOTw==
X-Google-Smtp-Source: AGHT+IEmRs2SQrVc9GLzODa7Y2S+4DXyFTYFnYNrEP6EPnF+UanD+KwvLvf3wI3VyrpU1ZlG6ydbLvn4nsI=
X-Received: from pjbos6.prod.google.com ([2002:a17:90b:1cc6:b0:313:245:8921])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2809:b0:311:fde5:e224
 with SMTP id 98e67ed59e1d1-313af0fd089mr1614276a91.6.1749596309756; Tue, 10
 Jun 2025 15:58:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:34 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-30-seanjc@google.com>
Subject: [PATCH v2 29/32] KVM: nSVM: Merge MSRPM in 64-bit chunks on 64-bit kernels
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

When merging L0 and L1 MSRPMs as part of nested VMRUN emulation, access
the bitmaps using "unsigned long" chunks, i.e. use 8-byte access for
64-bit kernels instead of arbitrarily working on 4-byte chunks.

Opportunistically rename local variables in nested_svm_merge_msrpm() to
more precisely/accurately reflect their purpose ("offset" in particular is
extremely ambiguous).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7ca45361ced3..749f7b866ac8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -196,6 +196,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
  */
 static int nested_svm_msrpm_merge_offsets[6] __ro_after_init;
 static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
+typedef unsigned long nsvm_msrpm_merge_t;
 
 int __init nested_svm_init_msrpm_merge_offsets(void)
 {
@@ -230,10 +231,10 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
 			return -EIO;
 
 		/*
-		 * Merging is done in 32-bit chunks to reduce the number of
-		 * accesses to L1's bitmap.
+		 * Merging is done in chunks to reduce the number of accesses
+		 * to L1's bitmap.
 		 */
-		offset = bit_nr / BITS_PER_BYTE / sizeof(u32);
+		offset = bit_nr / BITS_PER_BYTE / sizeof(nsvm_msrpm_merge_t);
 
 		for (j = 0; j < nested_svm_nr_msrpm_merge_offsets; j++) {
 			if (nested_svm_msrpm_merge_offsets[j] == offset)
@@ -261,8 +262,8 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
 static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 *msrpm02 = svm->nested.msrpm;
-	u32 *msrpm01 = svm->msrpm;
+	nsvm_msrpm_merge_t *msrpm02 = svm->nested.msrpm;
+	nsvm_msrpm_merge_t *msrpm01 = svm->msrpm;
 	int i;
 
 	/*
@@ -289,15 +290,15 @@ static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < nested_svm_nr_msrpm_merge_offsets; i++) {
 		const int p = nested_svm_msrpm_merge_offsets[i];
-		u32 value;
-		u64 offset;
+		nsvm_msrpm_merge_t l1_val;
+		gpa_t gpa;
 
-		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
+		gpa = svm->nested.ctl.msrpm_base_pa + (p * sizeof(l1_val));
 
-		if (kvm_vcpu_read_guest(vcpu, offset, &value, 4))
+		if (kvm_vcpu_read_guest(vcpu, gpa, &l1_val, sizeof(l1_val)))
 			return false;
 
-		msrpm02[p] = msrpm01[p] | value;
+		msrpm02[p] = msrpm01[p] | l1_val;
 	}
 
 	svm->nested.force_msr_bitmap_recalc = false;
-- 
2.50.0.rc0.642.g800a2b2222-goog


