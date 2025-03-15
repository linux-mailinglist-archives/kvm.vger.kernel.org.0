Return-Path: <kvm+bounces-41136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD0DA624D7
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:44:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A38218991F6
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 02:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F489189905;
	Sat, 15 Mar 2025 02:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nj77oJSr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3ECC139
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 02:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742006648; cv=none; b=DbyPnAyZ+vzhuO9VfK+07AH025/P8QWg5EiCwlxA82lXr1nMidd089mNTPxaL2cuzTpogxjvjdlXr3qdh5sgYeBZY+2ouAKyECs/nWpGyLNoWfJHJEwLOkpTzL23tXqFZ6HEb8UNTSAoE+wwVJLSn8GBrZHgS/ZjXlPijutu72M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742006648; c=relaxed/simple;
	bh=Q9GhAZbLUgE7P+QE7UyBDJ6RvNUgtdG9IcwaRMI1BWg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oOfbCbCcpG2cVgH+ulCOHVTnNmwB0ddemmLs1VEOCnce2N6Xoh8pKY2DhUgZHJkghux7MktAFm19aS9EaH5346+eRCG+bGtJxDO+4BvyuRgqdSA4+rEgaJBuh25oV6N/63WV9tYxXxF3qRvHzdjMtkhf5B5L6ahLv46Ashho8iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nj77oJSr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3011bee1751so507273a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 19:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742006645; x=1742611445; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZnnXdp56AgiA6BzKaPpHQxKIs/38n2t0PPH76FwESSg=;
        b=Nj77oJSrNeoVZPDPlnqVd/N1o/7ZkpJj0auI/IVFKuV8OK8z/iRZTe2pMaomu+e2Zr
         ipUuWoN/TCC/68H7uIgMLitu4h7knJ575Vfi8l3riJtvqSP80EyNp+YsjBoKGis8RVGN
         QujrEI1RZBMqb3YnoVQ4xSThY8Qtw141ShLLGYmYWL19EpqGO+mYKRkZAcpZyx/SMZ2I
         PB4LK25dEMzkFo+ifdJhCXPNuB3la+RrSa6EpoQPZfF/9nroL0QgMbi+69uxZJRFgwpL
         NY8mHyyNnS/nRGOsNDSbiaJTkyIQ1NYx8T9fsiAUQJfWTYT24hRMYU1rJJ/EaFU/iEWv
         jCrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742006645; x=1742611445;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZnnXdp56AgiA6BzKaPpHQxKIs/38n2t0PPH76FwESSg=;
        b=LxF/zAWtEr3nDZYS9+e6INESgEtsR8ixgSSrwWZITnWzDmjOnWpueirjaYvdJsHgO2
         D2c21Y010p5bnfyWkz98sTFL2YbDtXjHCe3Q02svPjx6a57ojt7/A91Dh3dS2Eo4dN78
         6jDp9VEs1V4radBgV449NAAQ9aymNLLAHvXPPszrf1XJZoCE3lKqIG18h44GslRXAVsX
         xParoYBSPNb3VByckcKDnNJFjyrwYKXb7aXjAQJU0bIVQgDTt5ZQA97pNDkGZq6s6BD9
         T9aTwy2DsP7HKTW26kh4BtwkO2v2b8SDcOdTeSIC22PK+tiQGNGma2hJ4afwdh6Qk5ZR
         ZnAQ==
X-Gm-Message-State: AOJu0Yxp/ahCJgbOOjY0GgqsSTacGBpBFDgofho560tE/4DP8I/TjUtf
	hSoqvlj8Map2ucaE3LrFXCrrswvRZrVU1hq1eqH6oAr/jZbMJh31Df9mlNWJMRnDHFMUlYX6yNQ
	I8Q==
X-Google-Smtp-Source: AGHT+IFd1lC1TQ7LNalTj2sS1eTmECizA8gtNAKxH7sy8aLsEb70foFSXFExtje6PNEdm5ZMeBgM5iGOZIs=
X-Received: from pjbov13.prod.google.com ([2002:a17:90b:258d:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5143:b0:2f7:4cce:ae37
 with SMTP id 98e67ed59e1d1-30151d03d08mr6864864a91.18.1742006644910; Fri, 14
 Mar 2025 19:44:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 19:44:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315024402.2363098-1-seanjc@google.com>
Subject: [PATCH] KVM: nVMX: Check MSR load/store list counts during VM-Enter
 consistency checks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Explicitly verify the MSR load/store list counts are below the advertised
limit as part of the initial consistency checks on the lists, so that code
that consumes the count doesn't need to worry about extreme edge cases.
Enforcing the limit during the initial checks fixes a flaw on 32-bit KVM
where a sufficiently high @count could lead to overflow:

	arch/x86/kvm/vmx/nested.c:834 nested_vmx_check_msr_switch()
	warn: potential user controlled sizeof overflow 'addr + count * 16' '0-u64max + 16-68719476720'

arch/x86/kvm/vmx/nested.c
    827 static int nested_vmx_check_msr_switch(struct kvm_vcpu *vcpu,
    828                                        u32 count, u64 addr)
    829 {
    830         if (count == 0)
    831                 return 0;
    832
    833         if (!kvm_vcpu_is_legal_aligned_gpa(vcpu, addr, 16) ||
--> 834             !kvm_vcpu_is_legal_gpa(vcpu, (addr + count * sizeof(struct vmx_msr_entry) - 1)))
                                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

While the SDM doesn't explicitly state an illegal count results in VM-Fail,
the SDM states that exceeding the limit may result in undefined behavior.
I.e. the SDM gives hardware, and thus KVM, carte blanche to do literally
anything in response to a count that exceeds the "recommended" limit.

  If the limit is exceeded, undefined processor behavior may result
  (including a machine check during the VMX transition).

KVM already enforces the limit when processing the MSRs, i.e. already
signals a late VM-Exit Consistency Check for VM-Enter, and generates a
VMX Abort for VM-Exit.  I.e. explicitly checking the limits simply means
KVM will signal VM-Fail instead of VM-Exit or VMX Abort.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/44961459-2759-4164-b604-f6bd43da8ce9@stanley.mountain
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d06e50d9c0e7..64ea387a14a1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -824,12 +824,30 @@ static int nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u64 vmx_misc = vmx_control_msr(vmx->nested.msrs.misc_low,
+				       vmx->nested.msrs.misc_high);
+
+	return (vmx_misc_max_msr(vmx_misc) + 1) * VMX_MISC_MSR_LIST_MULTIPLIER;
+}
+
 static int nested_vmx_check_msr_switch(struct kvm_vcpu *vcpu,
 				       u32 count, u64 addr)
 {
 	if (count == 0)
 		return 0;
 
+	/*
+	 * Exceeding the limit results in architecturally _undefined_ behavior,
+	 * i.e. KVM is allowed to do literally anything in response to a bad
+	 * limit.  Immediately generate a consistency check so that code that
+	 * consumes the count doesn't need to worry about extreme edge cases.
+	 */
+	if (count > nested_vmx_max_atomic_switch_msrs(vcpu))
+		return -EINVAL;
+
 	if (!kvm_vcpu_is_legal_aligned_gpa(vcpu, addr, 16) ||
 	    !kvm_vcpu_is_legal_gpa(vcpu, (addr + count * sizeof(struct vmx_msr_entry) - 1)))
 		return -EINVAL;
@@ -940,15 +958,6 @@ static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u64 vmx_misc = vmx_control_msr(vmx->nested.msrs.misc_low,
-				       vmx->nested.msrs.misc_high);
-
-	return (vmx_misc_max_msr(vmx_misc) + 1) * VMX_MISC_MSR_LIST_MULTIPLIER;
-}
-
 /*
  * Load guest's/host's msr at nested entry/exit.
  * return 0 for success, entry index for failure.
@@ -965,7 +974,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
 
 	for (i = 0; i < count; i++) {
-		if (unlikely(i >= max_msr_list_size))
+		if (WARN_ON_ONCE(i >= max_msr_list_size))
 			goto fail;
 
 		if (kvm_vcpu_read_guest(vcpu, gpa + i * sizeof(e),
@@ -1053,7 +1062,7 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
 
 	for (i = 0; i < count; i++) {
-		if (unlikely(i >= max_msr_list_size))
+		if (WARN_ON_ONCE(i >= max_msr_list_size))
 			return -EINVAL;
 
 		if (!read_and_check_msr_entry(vcpu, gpa, i, &e))

base-commit: c9ea48bb6ee6b28bbc956c1e8af98044618fed5e
-- 
2.49.0.rc1.451.g8f38331e32-goog


