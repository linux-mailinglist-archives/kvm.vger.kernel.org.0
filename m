Return-Path: <kvm+bounces-18969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 223F18FDA58
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:22:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD7A11F21B7E
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D21217F4F4;
	Wed,  5 Jun 2024 23:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B4QS+F4v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6727417E900
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629583; cv=none; b=dmDyCse/SsdkReYsttgUvlSu46VwyseXxxdU6rOBg1iKMlDMrDPiL54RIK4dk5enffsM9w1YuoLzl6FmIveGZ+QWQNFZ+Biv+8AzW3BawGJy/hQm7dibnYBNuFT4UK/w+ur8ZIgQVtNh6CvJE5e9sctCjrAnRC9AMi2ARYVE1hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629583; c=relaxed/simple;
	bh=m+g0SZx3U4yfgg2ZJiCqAqn/IhUW6hBzAmPzCOMr/Nk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AZeB5+s9Q6R5RA0TIp0jvepMfVKZMwv0UsCY53DGKaAi2JQvrjagwD20wGT0cUkZ33KS1J9YawrB4iJ/Awso1V1ECPQPYbsd0MwXoTN28oZjaAA/DOI19MzazVSErOhePZD1Kg1qO5HWPGkbuca3G584ZOFfd5DUClJTc6+mqI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B4QS+F4v; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfa8ab88a8cso690534276.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629580; x=1718234380; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fogQWPs5nieObQ0xgx1BEa2/fnrhPHybbu4f2xGt2Gw=;
        b=B4QS+F4vYzLi9qjNVcKG3/1odMbcmjRvnB037IAIYJ2QZGrr3Mkyhew0mKft15xpV8
         u05DyZQFlf/QbrSr0OBcwnbJ03/ujFrlqAcQU0altn804zmmYyZP5+7YlkfAi21can/+
         5TeY1M8+R5N90yOhLcXBNANOgw+2cq4kLFwrzKDOsEiF8nj2OpuwuSWYRc8sCAVAW34d
         6FecIvc9fV9HerD+7iB58ROxPKKhmEhe5UZ17CroTl8Esv4W9wkIj28MIuIA44xtejrc
         XiX7J7GcLLzvCexlPn+V3LmWlvYfPAz+vcnzH/q1mAdG7tThTDJHV4odTdvq0qSQsaxj
         EcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629580; x=1718234380;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fogQWPs5nieObQ0xgx1BEa2/fnrhPHybbu4f2xGt2Gw=;
        b=jJvb9waaraRd3T2foPct4AC5cBB43FX3YSHPV9XxbK58PPsYf6HvGAo4fVIYjTJcEX
         7tpkHreG1IyUCK/FIizoE4o8BbShqhZ7jhe7pUGH1AewJg9QL0++hUqBPHjNvmRpQRMk
         L68ynYuwUxrfUhvg5Wm3MzwfRO1LGPxd+wRSc75IzaGp8nu38GIHgxhk7J0QEjitelWm
         pzoGGk+2NIlDe3t5jNqbjYrPWqNb7V3nNOIImbQNcwz8YJ+eJTWQSjx//HrIeOMcu6B4
         bl3mEi7l9MaSwYu+k7G4MmUnNWTDWeh3ZSfeIZ9ZW8JomuQJl3PLeldPumL5lpL4iUZ+
         bibQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbwrh0MUK9E0fYK+rjk7t6frakWIbqWkLJhBqju9zcg9Zieej+w0PuyDeIbzMJPDgFdIsCRU+Gr8VRzEYs457/GTiA
X-Gm-Message-State: AOJu0YwvDqHM60fH0RRiiSENDM3jpeQheTJgJhbk6klZOFh0SsSjBvWG
	s38z52ZYVMBedzbIFHkvUlp/tnGok1/o2i5c/f8gD5CYnpYAd3g+kckNtj2bacJCUjuXzgZe/qj
	1pg==
X-Google-Smtp-Source: AGHT+IGaGsziZpt9w1pgEZdTBlz3ttQUJRstsickABcDEPtPL4e6DcRmnD/S+IdpyACJCnyiutt0q3ZKhKk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b93:b0:dfa:b352:824c with SMTP id
 3f1490d57ef6-dfacac6e1a6mr1150612276.7.1717629580377; Wed, 05 Jun 2024
 16:19:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  5 Jun 2024 16:19:18 -0700
In-Reply-To: <20240605231918.2915961-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605231918.2915961-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <20240605231918.2915961-11-seanjc@google.com>
Subject: [PATCH v8 10/10] KVM: nVMX: Use macros and #defines in vmx_restore_vmx_misc()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin3.li@intel.com>

Use macros in vmx_restore_vmx_misc() instead of open coding everything
using BIT_ULL() and GENMASK_ULL().  Opportunistically split feature bits
and reserved bits into separate variables, and add a comment explaining
the subset logic (it's not immediately obvious that the set of feature
bits is NOT the set of _supported_ feature bits).

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog, drop #defines]
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 623e8fcbf427..4e3a2303fd9c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1344,16 +1344,29 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 
 static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
 {
-	const u64 feature_and_reserved_bits =
-		/* feature */
-		BIT_ULL(5) | GENMASK_ULL(8, 6) | BIT_ULL(14) | BIT_ULL(15) |
-		BIT_ULL(28) | BIT_ULL(29) | BIT_ULL(30) |
-		/* reserved */
-		GENMASK_ULL(13, 9) | BIT_ULL(31);
+	const u64 feature_bits = VMX_MISC_SAVE_EFER_LMA |
+				 VMX_MISC_ACTIVITY_HLT |
+				 VMX_MISC_ACTIVITY_SHUTDOWN |
+				 VMX_MISC_ACTIVITY_WAIT_SIPI |
+				 VMX_MISC_INTEL_PT |
+				 VMX_MISC_RDMSR_IN_SMM |
+				 VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
+				 VMX_MISC_VMXOFF_BLOCK_SMI |
+				 VMX_MISC_ZERO_LEN_INS;
+
+	const u64 reserved_bits = BIT_ULL(31) | GENMASK_ULL(13, 9);
+
 	u64 vmx_misc = vmx_control_msr(vmcs_config.nested.misc_low,
 				       vmcs_config.nested.misc_high);
 
-	if (!is_bitwise_subset(vmx_misc, data, feature_and_reserved_bits))
+	BUILD_BUG_ON(feature_bits & reserved_bits);
+
+	/*
+	 * The incoming value must not set feature bits or reserved bits that
+	 * aren't allowed/supported by KVM.  Fields, i.e. multi-bit values, are
+	 * explicitly checked below.
+	 */
+	if (!is_bitwise_subset(vmx_misc, data, feature_bits | reserved_bits))
 		return -EINVAL;
 
 	if ((vmx->nested.msrs.pinbased_ctls_high &
-- 
2.45.1.467.gbab1589fc0-goog


