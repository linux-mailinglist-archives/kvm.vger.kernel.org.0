Return-Path: <kvm+bounces-48897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCFFDAD4643
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEED23A72DB
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 466952D3A74;
	Tue, 10 Jun 2025 22:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2NlBr9S1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F2D2D1F42
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596285; cv=none; b=DFtu0HBdusPKseRON4SNoERGGWAsgSTJ0PKQJ1ZeRkk80p5gxcfVxNzvV+iZFV5TGxbKZyTkWshu8RK1fn7ApfGLhcPRoAJhap2dg9g++N+nASGMyZx3TFOz7JCY/8idgS0iGldD1886nkYPEA2QVJfGDjA+BVYF6BAkOESDYwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596285; c=relaxed/simple;
	bh=F7byfDS1OPglN3Pg5TfkZNppi+cSONHtmO+WO68c9Zc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JOyAlsQTMydugRj2E83ZGIGapdOJRPumiug+jlhTDjpzW8y6fvU6dpvl1k8fHMmX1Z0OzJQ0jeMwZqiwttHt21qr1MCf5sjUvERQ9lD4V8Od2XL4+GtC09HQ0jaTcVQT2rUq4zURaZe/m2uLJQwJGg46+BqyxOqxypWHxxwKVDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2NlBr9S1; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b1fa2cad5c9so3572937a12.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596282; x=1750201082; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=70EChDkss4iyISwb9qAdpZ1UkxLXALCTNQzkODa6bJw=;
        b=2NlBr9S1nLrxcCXAjppyggx5JuEIjC3EwmNAzkeVwDMXeeEQRYc8kaZ0oomsE7Y92h
         wSwRtMC99FTX5IFFASegNNXSbWmK1k1rNOH+ErHjefOKJxXfx15YUNYGEc5adt9Jg8hV
         egwy0NIUuYZMyRVciwgkQ1OYxVf50Y5YteK1R4L1YO/HFyXn5SzaQN4lnrbOiznkRrSZ
         ZXGC88w116qHbU6JvUwBPA/T8o6u50PpAUHgBL4yE5U6JKkU28pFE2BH7gL/sxtqRbRN
         z1GxCFGTqiA/fUCkD6kVBtFmv+5aLVgJpaXBwgpvqVrR9Y2BE65hQ4hb1YO5Qxi6FOvo
         6RWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596282; x=1750201082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=70EChDkss4iyISwb9qAdpZ1UkxLXALCTNQzkODa6bJw=;
        b=g/G++yFenbaO6eIyz+vwkW6vp2JQkDo+Gvi1EBm/Tt4OUdSFo5toF63ELtnCmnlzjD
         rnk18/cc0tTrliXhIzD0dkzgiKNm+YplqI5cbONQptxb2198e/ORYTPUmylD8Iniadpp
         PC17iOToxKCcJYP6+M1H/vNwVdi1Hi/ufiGCBQjXk5rbinYNT65Ba2CEImDcC/RWqsC6
         6NjRmnCww/FpdoqYQNmzlhh63NSoZ7Qqudr+IQEFCiCfLZwv44nuWEZz8c6e0BgSaAo+
         OERVIXxkynZi7h/joQRfaeva1X+QHyPiGejPqMKZn+Xfji93za9JdPwhst7rsYwLm2Ma
         i2yA==
X-Gm-Message-State: AOJu0YypCdOsjNwUfVr55uhxT6ramo2QwSnCNTAisVDJ0bukh1TykmaI
	RwIwoc3lS7Y1weTU3SmX1OrHiacHyqGtDLQsKmW1vfaDtuFNwsGhGupSGcK+o+uLx9u4Vfv+F5b
	FTTu9aQ==
X-Google-Smtp-Source: AGHT+IHCFx8oRZxcJqlQMY09Po25mVfvwzM98pO2svurXJMBSFUeg/uaVz9XPdxA6tzpfP1YBy+pnbR2ON8=
X-Received: from pga13.prod.google.com ([2002:a05:6a02:4f8d:b0:b2f:c26a:8705])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a121:b0:21a:d503:f47c
 with SMTP id adf61e73a8af0-21f890ea5eamr743170637.28.1749596282682; Tue, 10
 Jun 2025 15:58:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:18 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-14-seanjc@google.com>
Subject: [PATCH v2 13/32] KVM: SVM: Add helpers for accessing MSR bitmap that
 don't rely on offsets
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
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
existing offset-based logic in set_msr_interception_bitmap() to sanity
check the "clear" and "set" operations.  Manipulating MSR interceptions
isn't a hot path and no kernel release is ever expected to contain this
specific version of set_msr_interception_bitmap() (it will be removed
entirely in the near future).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 30 ++++++++++++++--------------
 arch/x86/kvm/svm/svm.h | 44 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 798d33a76796..cd1e0ca964b0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -802,11 +802,6 @@ static bool valid_msr_intercept(u32 index)
 
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
@@ -816,17 +811,10 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
 	 * save it.
 	 */
-	msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm:
-				      to_svm(vcpu)->msrpm;
+	void *msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm :
+					    to_svm(vcpu)->msrpm;
 
-	offset    = svm_msrpm_offset(msr);
-	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
-		return false;
-
-	bit_write = 2 * (msr & 0x0f) + 1;
-	tmp       = msrpm[offset];
-
-	return test_bit(bit_write, &tmp);
+	return svm_test_msr_bitmap_write(msrpm, msr);
 }
 
 static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
@@ -861,7 +849,17 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
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
index bce66afafa11..a2be18579e09 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -623,9 +623,53 @@ static inline void svm_vmgexit_no_action(struct vcpu_svm *svm, u64 data)
 #define SVM_MSRS_PER_BYTE (BITS_PER_BYTE / SVM_BITS_PER_MSR)
 #define SVM_MSRS_PER_RANGE (SVM_MSRPM_BYTES_PER_RANGE * SVM_MSRS_PER_BYTE)
 static_assert(SVM_MSRS_PER_RANGE == 8192);
+#define SVM_MSRPM_OFFSET_MASK (SVM_MSRS_PER_RANGE - 1)
 
 #define MSR_INVALID				0xffffffffU
 
+static __always_inline u32 svm_msrpm_bit_nr(u32 msr)
+{
+	int range_nr;
+
+	switch (msr & ~SVM_MSRPM_OFFSET_MASK) {
+	case 0:
+		range_nr = 0;
+		break;
+	case 0xc0000000:
+		range_nr = 1;
+		break;
+	case 0xc0010000:
+		range_nr = 2;
+		break;
+	default:
+		return MSR_INVALID;
+	}
+
+	return range_nr * SVM_MSRPM_BYTES_PER_RANGE * BITS_PER_BYTE +
+	       (msr & SVM_MSRPM_OFFSET_MASK) * SVM_BITS_PER_MSR;
+}
+
+#define __BUILD_SVM_MSR_BITMAP_HELPER(rtype, action, bitop, access, bit_rw)	\
+static inline rtype svm_##action##_msr_bitmap_##access(unsigned long *bitmap,	\
+						       u32 msr)			\
+{										\
+	u32 bit_nr;								\
+										\
+	bit_nr = svm_msrpm_bit_nr(msr);						\
+	if (bit_nr == MSR_INVALID)								\
+		return (rtype)true;						\
+										\
+	return bitop##_bit(bit_nr + bit_rw, bitmap);				\
+}
+
+#define BUILD_SVM_MSR_BITMAP_HELPERS(ret_type, action, bitop)			\
+	__BUILD_SVM_MSR_BITMAP_HELPER(ret_type, action, bitop, read,  0)	\
+	__BUILD_SVM_MSR_BITMAP_HELPER(ret_type, action, bitop, write, 1)
+
+BUILD_SVM_MSR_BITMAP_HELPERS(bool, test, test)
+BUILD_SVM_MSR_BITMAP_HELPERS(void, clear, __clear)
+BUILD_SVM_MSR_BITMAP_HELPERS(void, set, __set)
+
 #define DEBUGCTL_RESERVED_BITS (~DEBUGCTLMSR_LBR)
 
 /* svm.c */
-- 
2.50.0.rc0.642.g800a2b2222-goog


