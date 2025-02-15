Return-Path: <kvm+bounces-38234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75597A36AA7
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1ED2C169BA5
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B483D14A08E;
	Sat, 15 Feb 2025 01:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ELxEQLbc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F7674BE1
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739581792; cv=none; b=EMHoFtM2BGFbINE7VSLMUgslgpU7yy+xb7tHCHcOLVNscHqBm24+iKK1So43O0J5cRD0tVEKd/blW4hLRzbOFibdGrej/0CgMUVyPYsXxpm3hA5amn3RWW81H6FTkpPaz2Om3yI+enuyXFkF/XiwuRowFOAnsZJsqzybTkEUCv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739581792; c=relaxed/simple;
	bh=K+YrvtF/PJ1uCc+2T0XG7iYvk/7/1XrAkwuhbsXzdio=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iCEiZWkqO5D+R89VSFyEubBywebxqvddFuJf7XcGJBp7lVP29Hxnt9Hf2LJ6c/C6iNSRJGLUHpdRBf4gJomOToLvHx9ql6Sfc+R1rQw+i7ZLtyAGP3Ve7Ks1ImBh35w3pl5yF0+4JFiW5fQVQRERiQXo+bNX7PSLT59IVK7VAyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ELxEQLbc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc2fee4425so3386723a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739581790; x=1740186590; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KF1a5SRq4o2UjN9KAy8jU6n0CzexHKnuO4cjsTur5ZQ=;
        b=ELxEQLbcPRNt5H9Qlj3sQdcICNt1jBjFWl+ArlCg7RvJ/O1gW/sFFdhtLKXYWr6unB
         DEhm02Rpg8fib+Wm6TrABQYi9koUnFwSHp5b3cyaUQhfQwvUImJe2yEk8Rqt9vHeNXzk
         LrnV27GdDfKQH5o3a6/iSJTypNAwyF6FzSa7uWwiw2CzjlJZxEgiqoiEKHB/aRSnFCsw
         +iwL82p3UsJB4d7hNCw4vgvZPdhP0BKKx73oz91XBhmQEJZ+fpefzBq0IbseEaaAgIXO
         RiXfWRPx/C6Sz6LBpDVJrIt8xsLLJ3wPgqn9X5PJ87yTBQ93NoQEk5TLHPbwnOoutALM
         YClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739581790; x=1740186590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KF1a5SRq4o2UjN9KAy8jU6n0CzexHKnuO4cjsTur5ZQ=;
        b=ABaluJK0rFFYLSso51+3CUXu4EPQP17bxwYjCNPWctvRK9ok5f3DQ4QLgM/Qds0b3H
         qLjHklbgYu8I17r1XNOwvrapJNjFGH1hphr+dNUaleb+G28Ae7g/pE2bZSELhwETQ0Jf
         QbocSEvfe89pZVelO+A3oW9qqycr5cVHN4Png0Ua9J91Si+cAusHYZ6uLug52hoLgpvX
         sr7XSUXwIbcuyDU4fZyAulC9X9C33TOohiuAKExODka3fwTnia1hHM5ldcAsZVQOxYAK
         PCBWiNzA24m91CyKzQ/DhKFKqPg0cPMGu1EhGBOF60qMOGbvnrhez43Q9/QE8zUoRl8e
         5v0Q==
X-Gm-Message-State: AOJu0Yy6e84b6450dXR9BXqFNp7ACBDmbmWUfxUjM0yZKyWrwlxei0bz
	xHSstHipIXRMcHHKaU6lQLhpRf+VYwPjMiuvtyDvDxLlf2EaBgwaT1ac06pZwW1YcV+G+W0oq8E
	blQ==
X-Google-Smtp-Source: AGHT+IGxCjaniKdavPPMMvuiGundFpjuNeVg+TFHSMJ1qALPEH53iQGqirqeLNvBjMX9MFSxQVH8vbN0his=
X-Received: from pfbc6.prod.google.com ([2002:a05:6a00:ad06:b0:72b:ccb:c99b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:394b:b0:1ee:6032:b1e4
 with SMTP id adf61e73a8af0-1ee8cb0bb12mr3215621637.18.1739581790691; Fri, 14
 Feb 2025 17:09:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:09:45 -0800
In-Reply-To: <20250215010946.1201353-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215010946.1201353-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215010946.1201353-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: SVM: Set RFLAGS.IF=1 in C code, to get VMRUN out of
 the STI shadow
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Doug Covelli <doug.covelli@broadcom.com>
Content-Type: text/plain; charset="UTF-8"

Enable/disable local IRQs, i.e. set/clear RFLAGS.IF, in the common
svm_vcpu_enter_exit() just after/before guest_state_{enter,exit}_irqoff()
so that VMRUN is not executed in an STI shadow.  AMD CPUs have a quirk
(some would say "bug"), where the STI shadow bleeds into the guest's
intr_state field if a #VMEXIT occurs during injection of an event, i.e. if
the VMRUN doesn't complete before the subsequent #VMEXIT.

The spurious "interrupts masked" state is relatively benign, as it only
occurs during event injection and is transient.  Because KVM is already
injecting an event, the guest can't be in HLT, and if KVM is querying IRQ
blocking for injection, then KVM would need to force an immediate exit
anyways since injecting multiple events is impossible.

However, because KVM copies int_state verbatim from vmcb02 to vmcb12, the
spurious STI shadow is visible to L1 when running a nested VM, which can
trip sanity checks, e.g. in VMware's VMM.

Hoist the STI+CLI all the way to C code, as the aforementioned calls to
guest_state_{enter,exit}_irqoff() already inform lockdep that IRQs are
enabled/disabled, and taking a fault on VMRUN with RFLAGS.IF=1 is already
possible.  I.e. if there's kernel code that is confused by running with
RFLAGS.IF=1, then it's already a problem.  In practice, since GIF=0 also
blocks NMIs, the only change in exposure to non-KVM code (relative to
surrounding VMRUN with STI+CLI) is exception handling code, and except for
the kvm_rebooting=1 case, all exception in the core VM-Enter/VM-Exit path
are fatal.

Oppurtunstically document why KVM needs to do STI in the first place.

Reported-by: Doug Covelli <doug.covelli@broadcom.com>
Closes: https://lore.kernel.org/all/CADH9ctBs1YPmE4aCfGPNBwA10cA8RuAk2gO7542DjMZgs4uzJQ@mail.gmail.com
Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c     | 14 ++++++++++++++
 arch/x86/kvm/svm/vmenter.S | 10 +---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7640a84e554a..fa0687711c48 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4189,6 +4189,18 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 
 	guest_state_enter_irqoff();
 
+	/*
+	 * Set RFLAGS.IF prior to VMRUN, as the host's RFLAGS.IF at the time of
+	 * VMRUN controls whether or not physical IRQs are masked (KVM always
+	 * runs with V_INTR_MASKING_MASK).  Toggle RFLAGS.IF here to avoid the
+	 * temptation to do STI+VMRUN+CLI, as AMD CPUs bleed the STI shadow
+	 * into guest state if delivery of an event during VMRUN triggers a
+	 * #VMEXIT, and the guest_state transitions already tell lockdep that
+	 * IRQs are being enabled/disabled.  Note!  GIF=0 for the entirety of
+	 * this path, so IRQs aren't actually unmasked while running host code.
+	 */
+	local_irq_enable();
+
 	amd_clear_divider();
 
 	if (sev_es_guest(vcpu->kvm))
@@ -4197,6 +4209,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	else
 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
 
+	local_irq_disable();
+
 	guest_state_exit_irqoff();
 }
 
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 2ed80aea3bb1..0c61153b275f 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -170,12 +170,8 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
 
 	/* Enter guest mode */
-	sti
-
 3:	vmrun %_ASM_AX
 4:
-	cli
-
 	/* Pop @svm to RAX while it's the only available register. */
 	pop %_ASM_AX
 
@@ -340,12 +336,8 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	mov KVM_VMCB_pa(%rax), %rax
 
 	/* Enter guest mode */
-	sti
-
 1:	vmrun %rax
-
-2:	cli
-
+2:
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
 
-- 
2.48.1.601.g30ceb7b040-goog


