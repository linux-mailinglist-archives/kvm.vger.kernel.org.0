Return-Path: <kvm+bounces-63112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B3EC5AAB0
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:45:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1ED544E734A
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D593331234;
	Thu, 13 Nov 2025 23:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3RSY+WCH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9150D330329
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763077082; cv=none; b=B5O1VES7hBcLDEjziqtPvX4SunWZBp5pa29PYEmMO79e2i/kU2Gyw76XvpAtcb+o3ju/AXATL3fmPbijRYnKEf6Y31kzSkfRQvVzEgFts+H4F1GSkRsRR2itFBStkDNESQCdDdhIPXQI2mX4JCvRJSOblt35Dweni96kAPR6Org=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763077082; c=relaxed/simple;
	bh=0snOzrDQ95f27zuaBEn47BWb8Pruz/6zOIKlPuSWTV4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HAeQZPkso0ovpTG/iSfznRJhnufb0anb0JMN9tFv0AP+ANQSDZF7lIIGwKdRW+hS67R1ELWzl8c7Kra02wFC6QHId5PJe/txP4tSv7ZnnUkx+qsYG8y31E+/wWt2bEOQOcc6FQo+P8WqyelxnMNiTlodVUpcXDQ6MuYzVLFU0j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3RSY+WCH; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b9208e1976so1409419b3a.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763077079; x=1763681879; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Wv5BfAollS99XFhIeOpKfkgpNs04gEhUuvVsDJUAfOk=;
        b=3RSY+WCH9/WGLFURTJaEXlSc22WizYLQ+UxZEugQWcgtdrM5AA9hkxj6N6LZSwMaHK
         Vpoecu0wavw/nmsfqI3i+mOEH5mPEryRmxi7fER8mgiEqOmWPyyYzCD7kLTwQ39z0cNt
         RzHBq67XuBUyN6ZV8cvmlCmOuUEK7RCH+SmmdHY72Aqlg0nlZIPxcVOEy/HmDv7qVlmV
         ShGWy5wzSG7kUYQpr0cnVukoLE6ApU66VfxGomozsHvrAxelWtGtWwUQaIcxWUjXG7Dc
         E+0lfgSpZJuZKYISg/VN6mkEQkDK3PMbN4qlVLbe3XSeIJxwyQKOWtwN/UiRk5C9BKrs
         AEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763077079; x=1763681879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wv5BfAollS99XFhIeOpKfkgpNs04gEhUuvVsDJUAfOk=;
        b=RGpH614ftnWZnZGptMXheUNse3JcuZeLxoPaOg901edCbb43RUe3mSYUrWA1JhGRT9
         KMdMPoDPWopE41vUmZWnsm7r1dkm/CYo+LfwXF6EAgiRRtkq9s4T84D+GKzuZsEaytBl
         yyE16eZ+pcaBEQhwlegyY57ZTE0zB1xTf5vP4y90X9CJZzH1T5wNrvdgK6estSteDTia
         l/eTaE5HUnSREUvxEfB9p6PeEjoLlQS2SDTlXaaVOcZ7Tf6Xt4rHWV7JonuFCCmsBnXs
         F1vMAZru5CbyXOyEfttXQU6g30XlVnL94HmnjLqBUJkDGhHkiPN/TtTEsSYjl34GGgLW
         prnw==
X-Gm-Message-State: AOJu0YybGLhv7NJ4kn8lx1JiX2M82TkqCETnbipjlNSTjzYw5o6ToPIH
	b7Krzn8AY+2St9Fu5L2RLYPVrjLFQPJS3sVyvwl+lmv4WgVPxqLlsIvOeRBNsjVIR12DYTTEDJE
	y5n9eFQ==
X-Google-Smtp-Source: AGHT+IEbtSUSfVPD1OTBTXG3h1YJ+Su4Df2wRMJHldoJY/HJ5rz+ppkYTp4GcI5dxuBKeGbAnXDLEg3pOLQ=
X-Received: from pgbfe16.prod.google.com ([2002:a05:6a02:2890:b0:bac:a20:5f0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12d2:b0:348:9a99:6253
 with SMTP id adf61e73a8af0-35ba2796ff5mr1438155637.57.1763077078702; Thu, 13
 Nov 2025 15:37:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:37:43 -0800
In-Reply-To: <20251113233746.1703361-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113233746.1703361-7-seanjc@google.com>
Subject: [PATCH v5 6/9] x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM as SVM_CLEAR_CPU_BUFFERS
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that VMX encodes its own sequence for clearing CPU buffers, move
VM_CLEAR_CPU_BUFFERS into SVM to minimize the chances of KVM botching a
mitigation in the future, e.g. using VM_CLEAR_CPU_BUFFERS instead of
checking multiple mitigation flags.

No functional change intended.

Reviewed-by: Brendan Jackman <jackmanb@google.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/nospec-branch.h | 3 ---
 arch/x86/kvm/svm/vmenter.S           | 6 ++++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index b1b1811216c5..3a5ac39877a0 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -324,9 +324,6 @@
 #define CLEAR_CPU_BUFFERS \
 	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF
 
-#define VM_CLEAR_CPU_BUFFERS \
-	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
-
 #ifdef CONFIG_X86_64
 .macro CLEAR_BRANCH_HISTORY
 	ALTERNATIVE "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_LOOP
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 98bfa2e00d88..3392bcadfb89 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -116,6 +116,8 @@
 	jmp 901b
 .endm
 
+#define SVM_CLEAR_CPU_BUFFERS \
+	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
 
 /**
  * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
@@ -194,7 +196,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
 
 	/* Clobbers EFLAGS.ZF */
-	VM_CLEAR_CPU_BUFFERS
+	SVM_CLEAR_CPU_BUFFERS
 
 	/* Enter guest mode */
 3:	vmrun %_ASM_AX
@@ -366,7 +368,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	mov KVM_VMCB_pa(%rax), %rax
 
 	/* Clobbers EFLAGS.ZF */
-	VM_CLEAR_CPU_BUFFERS
+	SVM_CLEAR_CPU_BUFFERS
 
 	/* Enter guest mode */
 1:	vmrun %rax
-- 
2.52.0.rc1.455.g30608eb744-goog


