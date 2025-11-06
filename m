Return-Path: <kvm+bounces-62238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57209C3D339
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 20:12:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62463189529D
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 19:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB2C34EF1D;
	Thu,  6 Nov 2025 19:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lfyoAiu4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6837233DEF9
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 19:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762456357; cv=none; b=mt4jnKAzw2OGHKiCh1guZOc8sPt78DIGMQtAIA4gRH/3Br4oHRqN86unEZz3t22nkkzXmlpl0cRVwVE0vUMQQhjT6Y81p3eJjcFDw/5QlsEngW9bSCLVqJp5PQGNivAu9UOMJ7cWjCc3/xyUX9rA8BSZlh9Se3XfhPQSK3J6q0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762456357; c=relaxed/simple;
	bh=vhb9OOG/2wa0RY6+WBcMVvHJDBno9LQEHZQptygwtWY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ixFYC2+AzK3VE6oo0X4NslFLK+pY+BhwqhymxmytIRdu9AJbYckK556OKQHABlQ0s5xPbRbqrDtvMjzgoKGf4FHj5vDHvsG9qBhTuOBYvi+2lFrk7njGgo8f9Oq1MCFMhgE4ruOprbMiBH/U8IP+IhYtwafXItKsDq9JEvxKDz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lfyoAiu4; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-294df925293so15773655ad.2
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 11:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762456356; x=1763061156; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2niLtjpgwATPK3kVZ1bxulXAUvRLtF8jTSC13rQHMxA=;
        b=lfyoAiu4JtjtZYjfv+n4hncebE0JHoGIqkbKWjHCSZJHw7EZlWVaUpTdu9RqlMt36G
         3YHgMJ1Xpy7K2y3NLoSKC2k7A6ekaFv4VjAjAKerp8Vs7Jnk5eLttuItf5YKfuH4Xt2I
         hhP0PHO/DomS8VraWnxA2A7U9HQKkNCNFou6+QilRHATTvJFtLDz68Crfnr2inM9zFej
         ksoj76XNX1/5tqXiUaxjXXoxcgA3uhMp8qhZ6PlA7/SgY/agH1nXJTDI2u1UtUYH56hT
         DsgTrRw33QK7dZoBLBUdqCojFgsLCDWTXAh7sw94q6b965Unywbg6tFE1btoVNmYh5tH
         Ibrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762456356; x=1763061156;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2niLtjpgwATPK3kVZ1bxulXAUvRLtF8jTSC13rQHMxA=;
        b=vkkg2wycQF6H7DaR9tNGZqUb99i42opMfOlo/1mab0w0lRdBtl2jM5DF4AJ8pMyBL6
         ot7t48dqyp6+WoG0G9lJWAI6u4Z/84bsxn9nf+7KZ7r054vWIUsGddbp1D+Dswpe76V8
         rGlKXTZYEFU9qCli1yMofRsfVBorlqlvVoEKCB07ys9B2m13gN5IBO2TQTV4vE6pVz60
         AxBbiHEM52iDcqONRz7lX8CZ9sbfMum8a4jCbzlTGJwbsWB8ojtL2OQDathlaTZZY3rT
         ki+wgaP178e2WDdNaljFkHTv2OGWzzTkpW+mYxj28Lkx9nbt05m2fJfo+q9T5Sep38tB
         pZwQ==
X-Gm-Message-State: AOJu0YwsmCPHk2fuQgv/QXJpORb9Kf+laClBvY2XCp657luBtdYZGJJN
	BYtm1G8Z+qBcqxxzApf+5rOeZnZ+RhRoIIPj0XdWqUHzYiNjya7XlI0nOBB7YLCCj4xLmwszndC
	YaQ2+fw==
X-Google-Smtp-Source: AGHT+IHS66hbUYvEthhYNn2eh5hCqhXHO2oVLEnIn4lAuIWnM95mZ0h6azbKWrxY/KyAJXB/Y+Eb1TOSdY0=
X-Received: from plwp1.prod.google.com ([2002:a17:903:2481:b0:268:eb:3b3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a85:b0:295:5945:2920
 with SMTP id d9443c01a7336-297c0464bb0mr6320535ad.34.1762456355747; Thu, 06
 Nov 2025 11:12:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  6 Nov 2025 11:12:30 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251106191230.182393-1-seanjc@google.com>
Subject: [PATCH v2] KVM: SVM: Ensure SPEC_CTRL[63:32] is context switched
 between guest and host
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Uros Bizjak <ubizjak@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: Uros Bizjak <ubizjak@gmail.com>

SPEC_CTRL is an MSR, i.e. a 64-bit value, but the VMRUN assembly code
assumes bits 63:32 are always zero.  The bug is _currently_ benign because
neither KVM nor the kernel support setting any of bits 63:32, but it's
still a bug that needs to be fixed.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2: Load the host's value into RDX and CMP against the guest's value from
    memory to avoid loading the host's value twice.  Swap the order of loads
    for 32-bit to match. [Uros]

v1: https://lore.kernel.org/all/20251106011330.75571-1-seanjc@google.com

 arch/x86/kvm/svm/vmenter.S | 43 +++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 235c4af6b692..22be0acf2a41 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -52,11 +52,23 @@
 	 * there must not be any returns or indirect branches between this code
 	 * and vmentry.
 	 */
-	movl SVM_spec_ctrl(%_ASM_DI), %eax
-	cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
+#ifdef CONFIG_X86_64
+	mov SVM_spec_ctrl(%rdi), %rdx
+	cmp PER_CPU_VAR(x86_spec_ctrl_current), %rdx
 	je 801b
+	movl %edx, %eax
+	shr $32, %rdx
+#else
+	mov SVM_spec_ctrl(%edi), %eax
+	mov PER_CPU_VAR(x86_spec_ctrl_current), %ecx
+	xor %eax, %ecx
+	mov SVM_spec_ctrl + 4(%edi), %edx
+	mov PER_CPU_VAR(x86_spec_ctrl_current + 4), %esi
+	xor %edx, %esi
+	or %esi, %ecx
+	je 801b
+#endif
 	mov $MSR_IA32_SPEC_CTRL, %ecx
-	xor %edx, %edx
 	wrmsr
 	jmp 801b
 .endm
@@ -81,13 +93,25 @@
 	jnz 998f
 	rdmsr
 	movl %eax, SVM_spec_ctrl(%_ASM_DI)
+	movl %edx, SVM_spec_ctrl + 4(%_ASM_DI)
 998:
-
 	/* Now restore the host value of the MSR if different from the guest's.  */
-	movl PER_CPU_VAR(x86_spec_ctrl_current), %eax
-	cmp SVM_spec_ctrl(%_ASM_DI), %eax
+#ifdef CONFIG_X86_64
+	mov PER_CPU_VAR(x86_spec_ctrl_current), %rdx
+	cmp SVM_spec_ctrl(%rdi), %rdx
 	je 901b
-	xor %edx, %edx
+	movl %edx, %eax
+	shr $32, %rdx
+#else
+	mov PER_CPU_VAR(x86_spec_ctrl_current), %eax
+	mov SVM_spec_ctrl(%edi), %esi
+	xor %eax, %esi
+	mov PER_CPU_VAR(x86_spec_ctrl_current + 4), %edx
+	mov SVM_spec_ctrl + 4(%edi), %edi
+	xor %edx, %edi
+	or %edi, %esi
+	je 901b
+#endif
 	wrmsr
 	jmp 901b
 .endm
@@ -211,7 +235,10 @@ SYM_FUNC_START(__svm_vcpu_run)
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
 
-	/* Clobbers RAX, RCX, RDX.  */
+	/*
+	 * Clobbers RAX, RCX, RDX (and EDI on 32-bit), consumes RDI (@svm) and
+	 * RSP (pointer to @spec_ctrl_intercepted).
+	 */
 	RESTORE_HOST_SPEC_CTRL
 
 	/*

base-commit: a996dd2a5e1ec54dcf7d7b93915ea3f97e14e68a
-- 
2.51.2.1041.gc1ab5b90ca-goog


