Return-Path: <kvm+bounces-63107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 816EEC5AAA1
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:44:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 24B4E4EB3EB
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BD8032C95D;
	Thu, 13 Nov 2025 23:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ob92NJyF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2512E6127
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763077073; cv=none; b=ZI0xoZY4uk5MRr5x8GUwYevGuTNmBCsbke4pM97TGfUFJWfxT7TCmVeQjbDGfy0JvRluGvH1AWFANtcWmVkTffIT9RmBDh7ViTNT0GQDIwmJmH6lHwOA0F5WsxNoxaXItZgRaH3TCT9hGnmZDzh8m/C8eFzlT0cOaR0kojvs/k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763077073; c=relaxed/simple;
	bh=emHSFxfSFp3NpgCgRJXcWu5Fv4DN2e5EIL4ys00ENJo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MFC7isyfOK3hmWRjCd3NTsFv0GxL1PE3lYu4/O2clKreWodbNZfAKZXKhsXcyL+Y6wAu9ELyXd9qrqJfTGIdbPNth8pejJba5nO9k8pSFOI8ppB8OSExTwYtgwyNVakUQZjqteES05KH5EeTOGqhxL9fLT0uvXUuUsavoYdmpDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ob92NJyF; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b969f3f5bb1so3140117a12.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763077070; x=1763681870; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Sh+7hNyP4R/KweVRs59CPko6PNfW+Zn6L2KP2TqLiWM=;
        b=Ob92NJyFIQ/rHy875D5TQQnhrWrWxYGLNYKVjjD7JruiPUtjGEYHCVyfKrfmvNIx9x
         9TUUV5b09y0HUna0P+I2SBrUHt79wOwC9nor+DjS/iN5rNvTbt5YTR3e2402KkKltInb
         dtsN4yq+EPNf72gbOOVhzIVsoF09yyVVvU2lT8haNnB186F+WG/DWDLmKdPJJVTUKhj5
         Dw/FRD16n6+2OZdX1FgC/6E5NPwA5Ys1HHnqWYdGXMSJ/e/KNQ7hKaBfwyPKoEDELyDg
         5IMf1tNXm9oCem5XabDQijDAYgi7njYllmxM7csKr5+huUHhJg1W9LKqlzPCINSVhU5W
         WG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763077070; x=1763681870;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sh+7hNyP4R/KweVRs59CPko6PNfW+Zn6L2KP2TqLiWM=;
        b=jqfl5fotyME9V6a7jSFBg94COPxa61gWyfWzpIfhD8/oeWCQo74BP5Pdc1Z26qxhF8
         NZxvXMHFjLRx8eAsjVHkxAix2UdBnbQfuPOLdJE88hyTxS4DUpsLrWnLJaHXAmnr2lyF
         3al0rYwoo6fdgESUqKCgmotWtvfalvRnlY6XaS3tke/zJPNoHNpXQy1Xc+fm5Fm44Wm3
         nuWumr0ocj6blJP4QW9sreDn+Lm3jYT2DNc3m3QO1cKObPcQGzEzDSp2KEx/1M7R0kN0
         eIwKSH/WYAaSg3ZKrF+FOpC/MC1/Y0coic8hB8mFM5UEn1V9CNG67xFM/3GXnfjPRojq
         WY4w==
X-Gm-Message-State: AOJu0YztlcO8w3uQXZ5d1SWHlU1TjSsPFfBPwLkcJxJ5UDY8MgIWiuok
	aYDiRSlgbL8qhz+767IXHy16h33GpevifIrB3AGBJxyQ4GquMHxaHTKK4swAB/4ExrcDw/yNMQJ
	iMtkVQw==
X-Google-Smtp-Source: AGHT+IGzLeYY2NjluaD76UX5FC2xrHwdrPlvbPSe57TwgtfK0eclvj5UDY23Mz7ZaJE6y8GEb4pxALgqZUw=
X-Received: from pgbcz2.prod.google.com ([2002:a05:6a02:2302:b0:bc3:ac3:8769])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6da1:b0:34e:a1b2:a35f
 with SMTP id adf61e73a8af0-35ba2692da8mr1659168637.53.1763077070183; Thu, 13
 Nov 2025 15:37:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:37:38 -0800
In-Reply-To: <20251113233746.1703361-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113233746.1703361-2-seanjc@google.com>
Subject: [PATCH v5 1/9] KVM: VMX: Use on-stack copy of @flags in __vmx_vcpu_run()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

When testing for VMLAUNCH vs. VMRESUME, use the copy of @flags from the
stack instead of first moving it to EBX, and then propagating
VMX_RUN_VMRESUME to RFLAGS.CF (because RBX is clobbered with the guest
value prior to the conditional branch to VMLAUNCH).  Stashing information
in RFLAGS is gross, especially with the writer and reader being bifurcated
by yet more gnarly assembly code.

Opportunistically drop the SHIFT macros as they existed purely to allow
the VM-Enter flow to use Bit Test.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/run_flags.h | 10 +++-------
 arch/x86/kvm/vmx/vmenter.S   | 13 ++++---------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
index 2f20fb170def..6a87a12135fb 100644
--- a/arch/x86/kvm/vmx/run_flags.h
+++ b/arch/x86/kvm/vmx/run_flags.h
@@ -2,12 +2,8 @@
 #ifndef __KVM_X86_VMX_RUN_FLAGS_H
 #define __KVM_X86_VMX_RUN_FLAGS_H
 
-#define VMX_RUN_VMRESUME_SHIFT				0
-#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT			1
-#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT	2
-
-#define VMX_RUN_VMRESUME			BIT(VMX_RUN_VMRESUME_SHIFT)
-#define VMX_RUN_SAVE_SPEC_CTRL			BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
-#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT)
+#define VMX_RUN_VMRESUME			BIT(0)
+#define VMX_RUN_SAVE_SPEC_CTRL			BIT(1)
+#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO	BIT(2)
 
 #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 574159a84ee9..93cf2ca7919a 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -92,7 +92,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Save @vmx for SPEC_CTRL handling */
 	push %_ASM_ARG1
 
-	/* Save @flags for SPEC_CTRL handling */
+	/* Save @flags (used for VMLAUNCH vs. VMRESUME and mitigations). */
 	push %_ASM_ARG3
 
 	/*
@@ -101,9 +101,6 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	 */
 	push %_ASM_ARG2
 
-	/* Copy @flags to EBX, _ASM_ARG3 is volatile. */
-	mov %_ASM_ARG3L, %ebx
-
 	lea (%_ASM_SP), %_ASM_ARG2
 	call vmx_update_host_rsp
 
@@ -147,9 +144,6 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Load @regs to RAX. */
 	mov (%_ASM_SP), %_ASM_AX
 
-	/* Check if vmlaunch or vmresume is needed */
-	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
-
 	/* Load guest registers.  Don't clobber flags. */
 	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
 	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
@@ -173,8 +167,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Clobbers EFLAGS.ZF */
 	CLEAR_CPU_BUFFERS
 
-	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
-	jnc .Lvmlaunch
+	/* Check @flags to see if vmlaunch or vmresume is needed. */
+	testl $VMX_RUN_VMRESUME, WORD_SIZE(%_ASM_SP)
+	jz .Lvmlaunch
 
 	/*
 	 * After a successful VMRESUME/VMLAUNCH, control flow "magically"
-- 
2.52.0.rc1.455.g30608eb744-goog


