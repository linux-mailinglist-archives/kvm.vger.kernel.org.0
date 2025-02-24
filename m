Return-Path: <kvm+bounces-39005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A1BA42867
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:55:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4B9C1894B9A
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 16:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 774A42641EB;
	Mon, 24 Feb 2025 16:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rHko1+FC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08955263F21
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740416088; cv=none; b=LRO8QYxh8KxqyQxC6WtthCl+bFJfAetUMqgMs5teNogd3PybQfARAi08611/Wn59umqBCHobYR/xtZ7nJjn9aviSsKCkum+qLZVeFnR6/eisY2oX8OIEyAdr/mMK4fzVnF62jhJEKRj3yZnNoqZNTRdJcgJnIuwq6zhRwinMBCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740416088; c=relaxed/simple;
	bh=l6+UgceNnntZd11WS3K/VkPrhV4bTFxROks7VDhHDt4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ud5HF/gb2bu4xARzVvLr/oC8jpdG+am20U0cC8RxHSHvcIZ5raItDJj3o+1AsVD6Q+S2mTIRF8E2hbyiccAeklKUKpFlmcUYtQoSYi8Lm9Kl/eHihX4/XtWodlrFYe8C49qDMgYSWqNdufAoK2fUTvmtIjCWlcz8ZvsxmvGpIk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rHko1+FC; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1c7c8396so9562014a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 08:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740416086; x=1741020886; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FdhSq59XhU0FyUWTPTJyf9MJm43UgRUBo6YYKsIpDDY=;
        b=rHko1+FCbxIDa+I+dAipTsXiGoWo4jNsScjxf7jmcgyb8GggeMn9hKnBXv3IagRHpm
         8KeZbNMWKyolmSQjRoSaloS48mOXBanFH3TeOuaNft/USHrFR05gu4WOyVk8Z/wARD5J
         GzisB+E630P7Txx9GdfVRf73fJAhc4OGh419qKXv137S+p5F5DmyvLtYND+2W7NY0G4M
         QlWOtEsSpe/yOc9yNk7DvfkpLYtE2VBXUHe2NUxdfy2x4SPafYO/vqhpD22Yy3WE5SHk
         Rqix70MgA1xt1qWAk5zu6/0+0ffgelsnQ1MyiGEjG0PwUWzzWqMcY5erQhQWbEr0NH7v
         r7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740416086; x=1741020886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FdhSq59XhU0FyUWTPTJyf9MJm43UgRUBo6YYKsIpDDY=;
        b=Srun38+OuosdI4Ddb7Ct3eeGJHop6pgifDX8Z4hv10xPDqPTU5tFTzRhdpQ0h32r16
         LaG99PLhADzzDldcpv7u9UakuvXRU1DvZVJCCrMNA8rKsZJAwjxyzJVfB0n/ff45Ct6X
         zfZCZJZ8Anael+LrSd1mZyUzq8QhGangvdmItpSR80umoXrahDenyLmybj23ovvWNvOk
         UHxHkCtw4mwJ4SsMluZFU0cfBW+A8QfBnK1mW+babVrW3RzD+3JDCgu8woo88TZf8QOj
         ALM9habEj2Iq+vpVO7/p/nTc0o7LsHQpfEjHhBHSa2AyAk7viARUmwMcfNHm8nxKi9/u
         uljA==
X-Gm-Message-State: AOJu0Yx2zcH1+EhU3AGduy+lEcO7TjkwdmXRcJrEUjJGjEMrtPKF10Pq
	EKQmWhacrbpfQrTtTuhJRwBOwEwMhrcC1s0R7Hsex6flUl+gUrQBA+8j1VUelp8ZnalrsrLB9BX
	ohg==
X-Google-Smtp-Source: AGHT+IFSrtAKmj8Gq/INI+PFQV3lvbZ1NNr6PG1+wrG9VH16gYz3Az2kA6DLNGmb/eanLpAY4R2Dm5bmv6U=
X-Received: from pjbsx15.prod.google.com ([2002:a17:90b:2ccf:b0:2fb:fa62:d40])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d0d:b0:2ee:8430:b831
 with SMTP id 98e67ed59e1d1-2fce868c84cmr23717052a91.2.1740416086342; Mon, 24
 Feb 2025 08:54:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 08:54:41 -0800
In-Reply-To: <20250224165442.2338294-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224165442.2338294-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250224165442.2338294-2-seanjc@google.com>
Subject: [PATCH v2 1/2] KVM: SVM: Set RFLAGS.IF=1 in C code, to get VMRUN out
 of the STI shadow
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

Use the "raw" variants to enable/disable IRQs to avoid tracing in the
"no instrumentation" code; the guest state helpers also take care of
tracing IRQ state.

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
index b8aa0f36850f..df5c23613b95 100644
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
+	raw_local_irq_enable();
+
 	amd_clear_divider();
 
 	if (sev_es_guest(vcpu->kvm))
@@ -4197,6 +4209,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	else
 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
 
+	raw_local_irq_disable();
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


