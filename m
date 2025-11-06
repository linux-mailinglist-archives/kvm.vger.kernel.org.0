Return-Path: <kvm+bounces-62142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01166C38ABD
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 02:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE8633B760E
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 01:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57961EEA5D;
	Thu,  6 Nov 2025 01:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ohRlIWGs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3D919F11E
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 01:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762391615; cv=none; b=fRpYLv3gUO+4tp58a0IUbipfGeYZ7EPwka8+ehsZOOIZkpfLK+St7gOsf5Up20L98tqPAGfqrzHox8j/cv8gxiBx9lXcxMqabJIPFeFBsQCY6mgKSStp9KNlEJF+UGgpK1digNn2sHL0Md4/eoIDYK/nNekJd2fCH8ifotht1Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762391615; c=relaxed/simple;
	bh=80Wiat1QmCZkX5CwNMua5eaZtZ21PjI7recyDsW8I40=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Timssz8y9xmxc4WSuJDGlYh1owg5Xez7ZDrGeB+LrB5v932BgrGzkUfOul2fpjAcAE0sHLDaCmg/FrTQTOaYzoryfdKlAe17/m9+Q2rzyiVYnmVNgq2GVwYWYZYbRBEvwXWuIe8oPMoEcDE5gViYgcNRN7OaRDpUIoAfvwpf810=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ohRlIWGs; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-341aec498fdso519692a91.2
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 17:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762391614; x=1762996414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VqKp0CwGeQO+vX6lyD3ithXWPZSPW6/801NskRBS3pw=;
        b=ohRlIWGsD8UHC0TfcA8CecUoXLJRfDqXpqQbcw8VLYF869RQNVityCld8eXZR9Qybr
         hFELxEYK06UYB2xTcztzQXNRz/VkYzdxe4dE3A0DVSJQAv3NyBkZ4z0sf1PC2g9RskQK
         wi0mFs+xBOenfnb9lp09hY4mV8oiLrVowPiz2ezbFmRO2KiDHbiTJNZDi7hP+08sq1f/
         JpyL8jVN1zdzXIm/dhmqr69LhRhBTlgOW9ZL7+Q+8vz28HbYh3Ejbdloyr3yUVFfQQPI
         hyw4ovb+oNfs+jqVy7uCx1YQDE6WKjrTaobUTsLUO8tERoGs5OIkTZq0xzZbtDLsLRuH
         PWNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762391614; x=1762996414;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VqKp0CwGeQO+vX6lyD3ithXWPZSPW6/801NskRBS3pw=;
        b=dj+VVhFAu19oMLCt/uZaTPSbf3ACKKA7fA4jb1p36hyAzguxoIEsoieiR02k67HRpg
         atJIhuLdVR0QzE+iV+eMAPv33qVeX5XQQV6Oh5u75AmsjGTsqIW5jc07IDhvoNxW2oll
         erFRCP1kIynSWdn4gJA2AA95yn0ahhc/XeTn6LeN9P47nD8ZUrz1MAQOnnyDVytrAo8l
         vyt5qgAAjcUh6mcaSceaIyWluMyZu5nzcnQCZo2rWddltjhV1KFZ1nT5QkchLgOKFFsl
         WuJlpxDcIAI1M5DvntgxTv0UA5aprKTY7WrvJRFhcTA7DHnnPHSf9+WNkSMlLc5VbFr8
         nZPQ==
X-Gm-Message-State: AOJu0YwX1UdEFesp/UM3hBUp0N3fgBf90+ificeiIg8qTAtE00Qda+RT
	K84Tcy9PkTM8qpvr+y+ycPgV9L9UpxKVldLEHIC6jmvXrzw+MC0qsTzYa7i4x4UqwzAPotmnGxW
	DW+LWJA==
X-Google-Smtp-Source: AGHT+IGZcQoqqRr+4WmRuSJjj17n9/E5KkIA14kwU5ltSuF7hBvooIAUFHJHZmSE4bAa5nn44H0/G6OGRqY=
X-Received: from plrd7.prod.google.com ([2002:a17:902:aa87:b0:295:70a9:9091])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da8c:b0:295:5948:f5d8
 with SMTP id d9443c01a7336-2962adb0f2fmr71425915ad.48.1762391613676; Wed, 05
 Nov 2025 17:13:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  5 Nov 2025 17:13:30 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251106011330.75571-1-seanjc@google.com>
Subject: [PATCH] KVM: SVM: Ensure SPEC_CTRL[63:32] is context switched between
 guest and host
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
 arch/x86/kvm/svm/vmenter.S | 44 +++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 235c4af6b692..53f45f5b611f 100644
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
@@ -81,13 +93,26 @@
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
+	mov SVM_spec_ctrl(%rdi), %rdx
+	cmp PER_CPU_VAR(x86_spec_ctrl_current), %rdx
 	je 901b
-	xor %edx, %edx
+	mov PER_CPU_VAR(x86_spec_ctrl_current), %rdx
+	movl %edx, %eax
+	shr $32, %rdx
+#else
+	mov SVM_spec_ctrl(%edi), %esi
+	mov PER_CPU_VAR(x86_spec_ctrl_current), %eax
+	xor %eax, %esi
+	mov SVM_spec_ctrl + 4(%edi), %edi
+	mov PER_CPU_VAR(x86_spec_ctrl_current + 4), %edx
+	xor %edx, %edi
+	or %edi, %esi
+	je 901b
+#endif
 	wrmsr
 	jmp 901b
 .endm
@@ -211,7 +236,10 @@ SYM_FUNC_START(__svm_vcpu_run)
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


