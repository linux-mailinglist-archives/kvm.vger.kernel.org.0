Return-Path: <kvm+bounces-48047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DEC0AC8527
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:43:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F6F917ADDE
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FDE42609C5;
	Thu, 29 May 2025 23:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tzFEL99i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CDA25F796
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562037; cv=none; b=F9Xwk2+XfR+G2+QRAoCvjLF5DahJnaIzqFx68aumcz3Gu1/qLtpTf2iNeDttDkpAYew0N0bLZrd+LeV6YDd+4TjAlmEdcHtn2R078JZBdffsC1lClvN2vopLkYXb06GDZD2xS8d+AEOebD4FI0NFGSk+qnwjxxALAr1m7zJAEv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562037; c=relaxed/simple;
	bh=f/wMtMq9/qFZgaQDGeY3gfCebyaJeJqlly2GqDjC49M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tDrjQ5sGhYgZT4HuyHImbqZaQ1ciMCDFzifuFIsuHLqXfSoS4zsXI5YNGh84ezEXxVLOBbT0/jCp7Aq4jbHvQDECe4w1MZFD+0DeH5AQk7mpxixDZRee5Emudc9cGiqN/Vb6Cu9bbdB1CfWDFenhfXfXVNvgpCUHuC1iXnKcS6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tzFEL99i; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-740774348f6so1323109b3a.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562035; x=1749166835; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DgmzrcqPi/+ObwfNCcpwV/4+Tj3W+pwfcdwRavqA9es=;
        b=tzFEL99iR7hqHT/J7NFiwQ0bnrJDepqHUJJ6BWKCHEyGTLv7wmKkq5P8tXjhECWwEV
         eOCxRtwGINuRpGbrb/SX0NpVIaG8ngBjvR/SfJ7CH2ZLnMcAufq8ws2XeohCKf3+pghA
         c4VnKwT8YW3Ouq70sw+WPCv9V6YKW5E4SP5y/5/Dt3WpDffK3ZQsoKhTSJKJ6JugEg+L
         R/4Ck/dwUMXQ5gOx1wNRsiKwEdMzZEzwXOXpe8F59/ETNG8UbEFRRzjx6a/0dUlwoD/Z
         Tjx/mju3TmgRWOn5JmVUq0qswdVcZpt79nNKYxcECn4TdqVv1t64PipBFoMLOh8jUrVJ
         RqSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562035; x=1749166835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DgmzrcqPi/+ObwfNCcpwV/4+Tj3W+pwfcdwRavqA9es=;
        b=aCp9Iy+y/zkyKXwbjUIa+2SQw3qJXPlvUM3RFYs+51oa6WYCRAeOXxtPjhyzNN+luT
         9SoOhfjhF7JA38qHLsyhAUyQcXouseNKxBPeY2tXOIv6xaFcn/D2bdfxC9o4jaHz9F0o
         F5L2D4R2OK4lCQuNRSf1Qp8KySfca7vUIyIKG1gwlI6jEmQeC0rSM6U93v0Nz6DpX+B5
         hpxCUzDChd9B/23BcHHaU8EWII9lALk7bge4NoH4LT25ex2jAwPqcBBmbgUIVw8MxHnB
         glmU8tU6X0Er4GoTdfEOMtopnOY6fo7dCK83b92SbDW5WerfHBExOaFIuXkGUXDz9iPy
         aWbQ==
X-Gm-Message-State: AOJu0Yzeyu67d0LCAjAPllb0sobCDzClfNlJvsXyfJaNXMbt1GR/ClMb
	XNKrP7ObS452HUAVD6qxQf+u376S063xU2F2ppoRUNLJF1Px4meS5+Y/K0gTi70mGY0YMXG5hBR
	yh32zdA==
X-Google-Smtp-Source: AGHT+IEGoGqTFlgBAxp0OiVZzye1WjZwmg2sJ3WCHTGH1fBGGVEDOhHGqOLLyoh99i5qsX1y08VNc4toLuw=
X-Received: from pgot2.prod.google.com ([2002:a63:b242:0:b0:af2:4edb:7793])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:110:b0:21a:d503:f47c
 with SMTP id adf61e73a8af0-21ae00b15c1mr203741637.28.1748562034978; Thu, 29
 May 2025 16:40:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:56 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-12-seanjc@google.com>
Subject: [PATCH 11/28] KVM: SVM: Add helpers for accessing MSR bitmap that
 don't rely on offsets
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add macro-built helpers for testing, setting, and clearing MSRPM entries
without relying on precomputed offsets.  This sets the stage for eventually
removing general KVM use of precomputed offsets, which are quite confusing
and rather inefficient for the vast majority of KVM's usage.

Outside of merging L0 and L1 bitmaps for nested SVM, using u32-indexed
offsets and accesses is at best unnecessary, and at worst introduces extra
operations to retrieve the individual bit from within the offset u32 value.
And simply calling them "offsets" is very confusing, as the "unit" of the
offset isn't immediately obvious.

Use the new helpers in set_msr_interception_bitmap() and
msr_write_intercepted() to verify the math and operations, but keep the
existing offset-based logic set_msr_interception_bitmap() to sanity check
the "clear" and "set" operations.  Manipulating MSR interceptions isn't a
hot path and no kernel release is ever expected to contain this specific
version of set_msr_interception_bitmap() (it will be removed entirely in
the near future).

Add compile-time asserts to verify the bit number calculations, and also
to provide a simple demonstration of the layout (SVM and VMX use the same
concept of a bitmap, but with different layouts).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 30 ++++++++++++++--------------
 arch/x86/kvm/svm/svm.h | 44 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d97711bdbfc9..76d074440bcc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -806,11 +806,6 @@ static bool valid_msr_intercept(u32 index)
 
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 {
-	u8 bit_write;
-	unsigned long tmp;
-	u32 offset;
-	u32 *msrpm;
-
 	/*
 	 * For non-nested case:
 	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
@@ -820,17 +815,10 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
 	 * save it.
 	 */
-	msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm:
-				      to_svm(vcpu)->msrpm;
+	void *msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm:
+					    to_svm(vcpu)->msrpm;
 
-	offset    = svm_msrpm_offset(msr);
-	bit_write = 2 * (msr & 0x0f) + 1;
-	tmp       = msrpm[offset];
-
-	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
-		return false;
-
-	return test_bit(bit_write, &tmp);
+	return svm_test_msr_bitmap_write(msrpm, msr);
 }
 
 static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
@@ -865,7 +853,17 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	read  ? __clear_bit(bit_read,  &tmp) : __set_bit(bit_read,  &tmp);
 	write ? __clear_bit(bit_write, &tmp) : __set_bit(bit_write, &tmp);
 
-	msrpm[offset] = tmp;
+	if (read)
+		svm_clear_msr_bitmap_read((void *)msrpm, msr);
+	else
+		svm_set_msr_bitmap_read((void *)msrpm, msr);
+
+	if (write)
+		svm_clear_msr_bitmap_write((void *)msrpm, msr);
+	else
+		svm_set_msr_bitmap_write((void *)msrpm, msr);
+
+	WARN_ON_ONCE(msrpm[offset] != (u32)tmp);
 
 	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
 	svm->nested.force_msr_bitmap_recalc = true;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 47a36a9a7fe5..e432cd7a7889 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -628,6 +628,50 @@ static_assert(SVM_MSRS_PER_RANGE == 8192);
 #define SVM_MSRPM_RANGE_1_BASE_MSR	0xc0000000
 #define SVM_MSRPM_RANGE_2_BASE_MSR	0xc0010000
 
+#define SVM_MSRPM_FIRST_MSR(range_nr)	\
+	(SVM_MSRPM_RANGE_## range_nr ##_BASE_MSR)
+#define SVM_MSRPM_LAST_MSR(range_nr)	\
+	(SVM_MSRPM_RANGE_## range_nr ##_BASE_MSR + SVM_MSRS_PER_RANGE - 1)
+
+#define SVM_MSRPM_BIT_NR(range_nr, msr)						\
+	(range_nr * SVM_MSRPM_BYTES_PER_RANGE * BITS_PER_BYTE +			\
+	 (msr - SVM_MSRPM_RANGE_## range_nr ##_BASE_MSR) * SVM_BITS_PER_MSR)
+
+#define SVM_MSRPM_SANITY_CHECK_BITS(range_nr)					\
+static_assert(SVM_MSRPM_BIT_NR(range_nr, SVM_MSRPM_FIRST_MSR(range_nr) + 1) ==	\
+	      range_nr * 2048 * 8 + 2);						\
+static_assert(SVM_MSRPM_BIT_NR(range_nr, SVM_MSRPM_FIRST_MSR(range_nr) + 7) ==	\
+	      range_nr * 2048 * 8 + 14);
+
+SVM_MSRPM_SANITY_CHECK_BITS(0);
+SVM_MSRPM_SANITY_CHECK_BITS(1);
+SVM_MSRPM_SANITY_CHECK_BITS(2);
+
+#define SVM_BUILD_MSR_BITMAP_CASE(bitmap, range_nr, msr, bitop, bit_rw)		\
+	case SVM_MSRPM_FIRST_MSR(range_nr) ... SVM_MSRPM_LAST_MSR(range_nr):	\
+		return bitop##_bit(SVM_MSRPM_BIT_NR(range_nr, msr) + bit_rw, bitmap);
+
+#define __BUILD_SVM_MSR_BITMAP_HELPER(rtype, action, bitop, access, bit_rw)	\
+static inline rtype svm_##action##_msr_bitmap_##access(unsigned long *bitmap,	\
+						       u32 msr)			\
+{										\
+	switch (msr) {								\
+	SVM_BUILD_MSR_BITMAP_CASE(bitmap, 0, msr, bitop, bit_rw)		\
+	SVM_BUILD_MSR_BITMAP_CASE(bitmap, 1, msr, bitop, bit_rw)		\
+	SVM_BUILD_MSR_BITMAP_CASE(bitmap, 2, msr, bitop, bit_rw)		\
+	default:								\
+		return (rtype)true;						\
+	}									\
+										\
+}
+#define BUILD_SVM_MSR_BITMAP_HELPERS(ret_type, action, bitop)			\
+	__BUILD_SVM_MSR_BITMAP_HELPER(ret_type, action, bitop, read,  0)	\
+	__BUILD_SVM_MSR_BITMAP_HELPER(ret_type, action, bitop, write, 1)
+
+BUILD_SVM_MSR_BITMAP_HELPERS(bool, test, test)
+BUILD_SVM_MSR_BITMAP_HELPERS(void, clear, __clear)
+BUILD_SVM_MSR_BITMAP_HELPERS(void, set, __set)
+
 #define MSR_INVALID				0xffffffffU
 
 #define DEBUGCTL_RESERVED_BITS (~DEBUGCTLMSR_LBR)
-- 
2.49.0.1204.g71687c7c1d-goog


