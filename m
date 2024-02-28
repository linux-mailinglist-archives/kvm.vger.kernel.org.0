Return-Path: <kvm+bounces-10188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E228F86A6B5
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:42:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A052873C7
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F31208C5;
	Wed, 28 Feb 2024 02:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="20r5g6XC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC651F94D
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088117; cv=none; b=efQ9DhFg7AHb+vMN0FkCf4KjK/vWxh/+j+kzLut31ip0ptUG35ZWtC5kdftafdJZXJMf9dNgVjzxP//Z7ljL2XCJN5d1vDv7pTrFV+PCesccwrCz5t2hR4dx3omggobMhMGZjm5J2MMbbaaxR80Lkvwq7pFiq5rJfUVFv406xZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088117; c=relaxed/simple;
	bh=Pbt+JF3UA/8dMtWQFjeGy4m6XEf0EGAmPbiziPcskhM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=stoRyUFRaPbPnb0x9uC2mhJOuzmuKuaNg2MYxkGkBttR8kAZAVVFqWa2PjsrCDYRd5G3upgPuRz2uq2Hq3nB+NN/646AnXRdjYdXnWzXRqlu+OJJpIvL32NQCSkWU8a34Xuhi/WoXz/d6muXtW64NgYjYrucs2f6ReeH8rY8vR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=20r5g6XC; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dce775fa8adso9608423276.1
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088114; x=1709692914; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SB7VJZrxLLlFGrRBdKBxwQcdc7hfIE4p4aRvNnIMDrw=;
        b=20r5g6XCXbfOojC6XcQ3lbgZbmsVRuzdMnK74272/AuKfYcHfkoxYhRmYKiof3oA5G
         usWiH9uzdGmmYy3pJYmZiNg5bOvkc9X6fAGEKBgCBk6jm8jIn3XxKgN9zFwWr4Il72Cr
         i+Rt3+bSBq237oLQNfQs6Wt9l6lXEqafihoS3xxede4iDo/RY9OxrRrtpzmcA9ASg5ty
         IFGDSXAbtKotgxYG/wYhbYEubMn1m6grdZ9wteY52qU75P/+fNUz0FDaAuTVVNU9HE9b
         yITaGc38ktCzMWrtBRXy4HEyuxqUeMlHT3/A1YiVSjtt/euafEHkY4vK0UaFdAVr7fZ0
         FKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088114; x=1709692914;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SB7VJZrxLLlFGrRBdKBxwQcdc7hfIE4p4aRvNnIMDrw=;
        b=rZ0m/ocht8JFuMyqGR2KeOk6BCTD+guicIZ7eKjY07VEqR8+92nMGbI/uNBVzc05Of
         2DKE2+RE3KmmiHyz/ef2vwLIarhKx+rNqyMAD/st2mBqT8TDkPpb88kIAmSfq8aZSqDI
         mncyew6leal3cKL5MXCjjEScktHddHHSS1GvyCLN+zyMzcaqBppPvqKx9fioGKH56EmQ
         zPEQ9h56Qx+aTKDwo+Avwal2U0eCUUX8P9F+wlbzIbvITGW8Ntcs6VzPEclOejV2M6at
         hteTzRv024Z6BN5K9L4oA1d9nYzVep33wsjHpf3nJSjSpSONdYiMAqqKWczHAOTUiyF4
         iQIA==
X-Gm-Message-State: AOJu0YyxqxNzEE0QwXbLFp0j/VIYiWg5XbHXuIzEAGvhXB854n0qPDem
	6Ebypl1r9pcxiaBPwBx8cw1fwGLXpuRD/6t/VzbXeEH8YKala4YFJ3AjxlkwQKW7SKnEIcBUCMH
	+Pw==
X-Google-Smtp-Source: AGHT+IEtr1W2Og4WYHDO0Ie9yHqrThkRgrJTuHJgWLs/TyCSU0i16JcQQLlcsTydtmk6DAVKLy5zekb7Irs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:21c1:0:b0:dcc:e1a6:aca9 with SMTP id
 h184-20020a2521c1000000b00dcce1a6aca9mr381616ybh.9.1709088114564; Tue, 27 Feb
 2024 18:41:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:33 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-3-seanjc@google.com>
Subject: [PATCH 02/16] KVM: x86: Remove separate "bit" defines for page fault
 error code masks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Open code the bit number directly in the PFERR_* masks and drop the
intermediate PFERR_*_BIT defines, as having to bounce through two macros
just to see which flag corresponds to which bit is quite annoying, as is
having to define two macros just to add recognition of a new flag.

Use ilog2() to derive the bit in permission_fault(), the one function that
actually needs the bit number (it does clever shifting to manipulate flags
in order to avoid conditional branches).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 32 ++++++++++----------------------
 arch/x86/kvm/mmu.h              |  4 ++--
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aaf5a25ea7ed..88cc523bafa8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -254,28 +254,16 @@ enum x86_intercept_stage;
 	KVM_GUESTDBG_INJECT_DB | \
 	KVM_GUESTDBG_BLOCKIRQ)
 
-
-#define PFERR_PRESENT_BIT 0
-#define PFERR_WRITE_BIT 1
-#define PFERR_USER_BIT 2
-#define PFERR_RSVD_BIT 3
-#define PFERR_FETCH_BIT 4
-#define PFERR_PK_BIT 5
-#define PFERR_SGX_BIT 15
-#define PFERR_GUEST_FINAL_BIT 32
-#define PFERR_GUEST_PAGE_BIT 33
-#define PFERR_IMPLICIT_ACCESS_BIT 48
-
-#define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
-#define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
-#define PFERR_USER_MASK		BIT(PFERR_USER_BIT)
-#define PFERR_RSVD_MASK		BIT(PFERR_RSVD_BIT)
-#define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
-#define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
-#define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
-#define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
-#define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
-#define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
+#define PFERR_PRESENT_MASK	BIT(0)
+#define PFERR_WRITE_MASK	BIT(1)
+#define PFERR_USER_MASK		BIT(2)
+#define PFERR_RSVD_MASK		BIT(3)
+#define PFERR_FETCH_MASK	BIT(4)
+#define PFERR_PK_MASK		BIT(5)
+#define PFERR_SGX_MASK		BIT(15)
+#define PFERR_GUEST_FINAL_MASK	BIT_ULL(32)
+#define PFERR_GUEST_PAGE_MASK	BIT_ULL(33)
+#define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 60f21bb4c27b..e8b620a85627 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -213,7 +213,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	 */
 	u64 implicit_access = access & PFERR_IMPLICIT_ACCESS;
 	bool not_smap = ((rflags & X86_EFLAGS_AC) | implicit_access) == X86_EFLAGS_AC;
-	int index = (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;
+	int index = (pfec + (not_smap << ilog2(PFERR_RSVD_MASK))) >> 1;
 	u32 errcode = PFERR_PRESENT_MASK;
 	bool fault;
 
@@ -235,7 +235,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
 		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
 		offset = (pfec & ~1) +
-			((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - PT_USER_SHIFT));
+			((pte_access & PT_USER_MASK) << (ilog2(PFERR_RSVD_MASK) - PT_USER_SHIFT));
 
 		pkru_bits &= mmu->pkru_mask >> offset;
 		errcode |= -pkru_bits & PFERR_PK_MASK;
-- 
2.44.0.278.ge034bb2e1d-goog


