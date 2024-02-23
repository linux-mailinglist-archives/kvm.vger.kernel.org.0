Return-Path: <kvm+bounces-9580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A95B9861DF1
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:45:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56EEB1F24FAB
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 20:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1E0156962;
	Fri, 23 Feb 2024 20:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dno+02JK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB237153509
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 20:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708720963; cv=none; b=bCEAxEvbTrh7A8+x0nSxSsKcKJfJDIdp97tcYdfp32DRe6qyaCI6osYpfZxP6r+YoczVTTAU7tyS3FOEnai7RkK6CeP5WzPOBolM7OTxJ19APfpPrsw3AuAGzG+a/+KZh/zguJiDMK6DebBtWmh0gpekJfW0eGW2wtZ3pjCKbKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708720963; c=relaxed/simple;
	bh=k0eGgIhqmjJk6wFzrviaHr5FNb9k9KBeDzh45p9EPkE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gcWVYv/c6Mpyt3jp5eieCfATBdXXvtC5eswmaV76ZX00zMqnLIytVVGdYq4VxIWZlUD9KR6cK1MIhGqSM7cOaW1UiIbkxXZ/34bXdUPFIopbA+jPVgpFNN/nC+R7ZsYDKcx96b8esA9cE1E4tDZItjvAUEceQY9NpyGC+9JrDZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dno+02JK; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b2682870so1187261276.0
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 12:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708720960; x=1709325760; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WHWPH6O3SBPytu8N+jRZuhsLbq0a353cKtc0xEMWOV0=;
        b=dno+02JKufZVXMr37vf5CotMKuga5zSxsabS32iTiMM1k56KTsx3vGFZED7Rev4Vfs
         +530DogWR47+EQxVcqD6z2hrIpOA/zY0PZA78QHRItubM0X/6cLa1wXusMzQJgBs0aLd
         O7q61K/mAN5EoYVNJqPtL/aPiPeI9UcPLhIMo5jnDekNv7qR38eqdCuyDQt5thpqSBhY
         rzKWfY8vmpYEi4E6bHfyhY+AF537Ug0pnXmHV4tdK9nyYFc/bXx2gdeT1efBCTWSc4ax
         wNuL9M/aIazC4eZbuY5JlC/tdK1o6FsLKyI5dqqXDRiZ/IfdSRuWs8mENN79UGl6kSUe
         dMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708720960; x=1709325760;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WHWPH6O3SBPytu8N+jRZuhsLbq0a353cKtc0xEMWOV0=;
        b=UblAGa4fCfZerpcgDPFBccnQXGSwTC0dKdauLPW//bCj0GMc9C2XuzwjrFv2wFRUIA
         ClJHd562fIlqmKRd39NjldcnekjtHOD3MmNiRGnYVoOnD1AYfTgSX+ZJeqeO/DKtaksX
         cBZmrTXin53KaDpsYDmuIFlcDLNgz8bW5StrfE1rgZ0u5CNhQBmRWYXKUKx9p3LVyJNL
         QcQvzPv6KjFR5CHdAQx199IK9IM1QbCfkdOxceWhaALO8Yin3gVO3NI8+ph4lk+9uMmq
         nN9grA8qewqyfshiXL7eXUQMtRYigTtLSl/GHctJzH6G6PEAkbTxzP26eWNXsRAPVxxd
         XFJQ==
X-Gm-Message-State: AOJu0YyJwExB1KKUFIkIIIFhbj+JLtn0kFhRW5bsI9f6IFVrRum1Tx92
	FJHzpt5mVQCe3D5Q0Z+3bhbkncwWhWAwSKAte7AGkRe60HkmqsHbyzuKJ954aDffqBoVDjFG9z6
	tPA==
X-Google-Smtp-Source: AGHT+IEs8R1+cXtTADIm679PXjQV+EhmLQgYPjuzJbrMcPnC6qlCVjp69a/NLgbvariU2BnkW2q+mhoIrzo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aae5:0:b0:dc7:7ce9:fb4d with SMTP id
 t92-20020a25aae5000000b00dc77ce9fb4dmr242093ybi.12.1708720960791; Fri, 23 Feb
 2024 12:42:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 12:42:28 -0800
In-Reply-To: <20240223204233.3337324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223204233.3337324-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223204233.3337324-4-seanjc@google.com>
Subject: [PATCH 3/8] KVM: SVM: Drop 32-bit "support" from __svm_sev_es_vcpu_run()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

Drop 32-bit "support" from __svm_sev_es_vcpu_run(), as SEV/SEV-ES firmly
64-bit only.  The "support" was purely the result of bad copy+paste from
__svm_vcpu_run(), which in turn was slightly less bad copy+paste from
__vmx_vcpu_run().

Opportunistically convert to unadulterated register accesses so that it's
easier (but still not easy) to follow which registers hold what arguments,
and when.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/vmenter.S | 44 +++++++++++---------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 7ee363d7517c..0026b4a56d25 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -298,17 +298,12 @@ SYM_FUNC_END(__svm_vcpu_run)
  * @spec_ctrl_intercepted: bool
  */
 SYM_FUNC_START(__svm_sev_es_vcpu_run)
-	push %_ASM_BP
-#ifdef CONFIG_X86_64
+	push %rbp
 	push %r15
 	push %r14
 	push %r13
 	push %r12
-#else
-	push %edi
-	push %esi
-#endif
-	push %_ASM_BX
+	push %rbx
 
 	/*
 	 * Save variables needed after vmexit on the stack, in inverse
@@ -316,39 +311,31 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	 */
 
 	/* Accessed directly from the stack in RESTORE_HOST_SPEC_CTRL.  */
-	push %_ASM_ARG2
+	push %rsi
 
 	/* Save @svm. */
-	push %_ASM_ARG1
-
-.ifnc _ASM_ARG1, _ASM_DI
-	/*
-	 * Stash @svm in RDI early. On 32-bit, arguments are in RAX, RCX
-	 * and RDX which are clobbered by RESTORE_GUEST_SPEC_CTRL.
-	 */
-	mov %_ASM_ARG1, %_ASM_DI
-.endif
+	push %rdi
 
 	/* Clobbers RAX, RCX, RDX.  */
 	RESTORE_GUEST_SPEC_CTRL
 
 	/* Get svm->current_vmcb->pa into RAX. */
-	mov SVM_current_vmcb(%_ASM_DI), %_ASM_AX
-	mov KVM_VMCB_pa(%_ASM_AX), %_ASM_AX
+	mov SVM_current_vmcb(%rdi), %rax
+	mov KVM_VMCB_pa(%rax), %rax
 
 	/* Enter guest mode */
 	sti
 
-1:	vmrun %_ASM_AX
+1:	vmrun %rax
 
 2:	cli
 
 	/* Pop @svm to RDI, guest registers have been saved already. */
-	pop %_ASM_DI
+	pop %rdi
 
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
-	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
+	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
 
 	/* Clobbers RAX, RCX, RDX.  */
@@ -364,26 +351,21 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	UNTRAIN_RET_VM
 
 	/* "Pop" @spec_ctrl_intercepted.  */
-	pop %_ASM_BX
+	pop %rbx
 
-	pop %_ASM_BX
+	pop %rbx
 
-#ifdef CONFIG_X86_64
 	pop %r12
 	pop %r13
 	pop %r14
 	pop %r15
-#else
-	pop %esi
-	pop %edi
-#endif
-	pop %_ASM_BP
+	pop %rbp
 	RET
 
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY
 
-3:	cmpb $0, _ASM_RIP(kvm_rebooting)
+3:	cmpb $0, kvm_rebooting(%rip)
 	jne 2b
 	ud2
 
-- 
2.44.0.rc0.258.g7320e95886-goog


