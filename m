Return-Path: <kvm+bounces-61627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF4AC22C9D
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 01:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 39E8F4E25B5
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 00:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856722222AF;
	Fri, 31 Oct 2025 00:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UyN/0dBI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD121A0BD6
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 00:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761870657; cv=none; b=nr7GRd4jBg+R4m1gDfdhEoA7FVzlAlseTj8tu/QIngWNULfH3zM65H/VBdeYVxwSoXOV2oyvV1X0BtD7cfLfNVTm3kELwhqSmiEo+jpeB+hqnRjW/GFsnBM21fWxSsWs5mRCSxMD9zYCDZdnfhUX6H01mltcpYBYhP6q7eAdUNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761870657; c=relaxed/simple;
	bh=CKcaOTjItVz4WLo4iTzMHZzjSrJXPFSfhk1I27YzRz8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PSoLSNqZouwgHAICihJbAvgsmNg+PA6MdN6ADI6sp/XwMo41YE2773wf9Ps1rwW5al/l57JvfQcoTNxHFDb4v/RVgTsKGs/oBfz0BT+u0phCMDwRoOW8RGVfnih6hfQ9MtlQutcJ8uQC8F9eN5aheA03NAx8mPRC7HK1fg2KMq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UyN/0dBI; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b60992e3b27so1273060a12.3
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 17:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761870655; x=1762475455; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=plvc6sr/HSiAC52HAJ4IaJ4vyv8ZKviRrYeEAUlJ9Xc=;
        b=UyN/0dBIOtL71t37zvUkgh4S0/e/HronxyDumSllbzwO6S3qzY8iR7/vWMLFGI7ZE3
         KFp1KcvQQcXL7Iomgx/ip+IjYR/Ep28rjJjbHCgoxk87b+QOsBTafGIwD74XBGStJq4g
         DAnR+JOZ23bksw46fHUT/VKGDuqevGjyJ6lGfxaG3z2mG3wbSJDg3ojPeTBC45ZgfDkt
         u2/0ATBizzVyNGaM1gzLkehQUeJco+pSq2Ur7u2VaSlCgJQsOg7vyTS77REeFb6ntEfa
         cEQxp+aOoI/eVo5GweOg8Uzmy0BHWttot8aiBNdAn/bjOb93vZCp6+5GX/LMdvagf17h
         K7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761870655; x=1762475455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=plvc6sr/HSiAC52HAJ4IaJ4vyv8ZKviRrYeEAUlJ9Xc=;
        b=F8AtHClyPjH4wBqyNjAAUkKXcyKhDn23Blhnjmuwz2scxGDy/yidojwosC4CPw3J2x
         bBcyt7nyVk8j/7SM5ewUW6d5PMrG6qZk2CkMUAt4JZ8UiY2AojvvRRh5gahMLmRc0FXs
         fpT/gCBRyZXw+uQsSSVUN/jlWsnubCn6XU/Og6eLmRki77rwgveU6h0nzTWA6JwP9kEZ
         Toyn5MupYQ4KAeB7jvRVuxvrAUKjmVdEgzJlUu9+yDzSxKD1B5QJis9mJevqJ8UYjwjy
         DPXbEcKOFlru1D3GDn2ZW5c3bwCUuXDKHEmdMt+fUZCdwdsBbh0deK/jZPkciJ0y0Qwj
         xFTQ==
X-Gm-Message-State: AOJu0YySAfSHPI1rYva3C5fquSQ+310NzMwyLargPciAxRNv+xj24PRP
	fcxtPfXNfQa5yLbPshwfvylucZ4QRfk63y/YMm5TTqJxtvUdaC5ZnvxMrS1sPZMMZOs5hwtltTT
	DeQoX2g==
X-Google-Smtp-Source: AGHT+IFIzJ7ZEinVQ37x8dGUbzHaunbWA0l4ceoWMJoW0i44376UHeVDoVTVqIoOKauus5lpArxJCTtPusU=
X-Received: from pjbcf5.prod.google.com ([2002:a17:90a:ebc5:b0:32d:a4d4:bb17])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e212:b0:340:fce2:a152
 with SMTP id adf61e73a8af0-348cca00f0bmr2183966637.55.1761870655555; Thu, 30
 Oct 2025 17:30:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 17:30:37 -0700
In-Reply-To: <20251031003040.3491385-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031003040.3491385-6-seanjc@google.com>
Subject: [PATCH v4 5/8] x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM as SVM_CLEAR_CPU_BUFFERS
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that VMX encodes its own sequency for clearing CPU buffers, move
VM_CLEAR_CPU_BUFFERS into SVM to minimize the chances of KVM botching a
mitigation in the future, e.g. using VM_CLEAR_CPU_BUFFERS instead of
checking multiple mitigation flags.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/nospec-branch.h | 3 ---
 arch/x86/kvm/svm/vmenter.S           | 6 ++++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index b29df45b1edb..88fe40d6949a 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -323,9 +323,6 @@
 #define CLEAR_CPU_BUFFERS \
 	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF
 
-#define VM_CLEAR_CPU_BUFFERS \
-	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
-
 #ifdef CONFIG_X86_64
 .macro CLEAR_BRANCH_HISTORY
 	ALTERNATIVE "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_LOOP
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 235c4af6b692..da5f481cb17e 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -92,6 +92,8 @@
 	jmp 901b
 .endm
 
+#define SVM_CLEAR_CPU_BUFFERS \
+	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
 
 /**
  * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
@@ -170,7 +172,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
 
 	/* Clobbers EFLAGS.ZF */
-	VM_CLEAR_CPU_BUFFERS
+	SVM_CLEAR_CPU_BUFFERS
 
 	/* Enter guest mode */
 3:	vmrun %_ASM_AX
@@ -339,7 +341,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	mov KVM_VMCB_pa(%rax), %rax
 
 	/* Clobbers EFLAGS.ZF */
-	VM_CLEAR_CPU_BUFFERS
+	SVM_CLEAR_CPU_BUFFERS
 
 	/* Enter guest mode */
 1:	vmrun %rax
-- 
2.51.1.930.gacf6e81ea2-goog


