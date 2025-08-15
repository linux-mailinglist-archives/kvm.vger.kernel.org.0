Return-Path: <kvm+bounces-54727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 049AEB273C3
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:26:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ED343A706C
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FCDD186284;
	Fri, 15 Aug 2025 00:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qiimAUyz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEEFA926
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755217549; cv=none; b=S+FFzjxPd8wEJSipgeku5DjfdQRUwD4zxo/3VJp9slP9TPyNWvHCuRvHRmLpYsZl9RWiNbkktZFLi0TPXaVMHk84yPAWss0h4vxfVpRfvRMnpEIc5EeXO09t/xXdkw+9KYJHjjjhCytfRAKfFzEmI0mby+Ornsr5eeUYJoViOsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755217549; c=relaxed/simple;
	bh=zlXQ4ZU3VrvB4sXa+ComF+joHtt5NQVT6oPd7DEUt/w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ow1cwDyVbArJlA80PZ/73wItjQAaDC6NBEUfPv4k0aQtkxIxKUJ/0oJXjF+OA+hAkFJNrzZ5fZ3AnPL8XXV3koSwg3DrMly0zADkgE7xhQoj1NQB5it+EELb5BIv3PDylTNzydwp1JvBhOdZ3wb5/7UaS8I8Jf/2E54rAkqX4xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qiimAUyz; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47174bdce2so983706a12.2
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755217547; x=1755822347; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yJbizRUw+p2hqJq2yCwI8a4ldo76XC44biSplLoJEII=;
        b=qiimAUyzraPefwblgC5Yk+HekGKLYhJUZ1ZfwGQ2RXcu0j4RFkw6saA97zQcIEgs4+
         1qf8Qa+dNJHrPrd9DyES8bW0oCbFcLzn69Btip+UoT3p+a7LrPSwuXPUFoBVnAtdixSi
         +J51g0kbafbjpOP18AolvHyWgy/Ho7a++hJxFIRtcV5g9mV6lKg45i8cyOMebk8w15ZU
         bPZp6d835sehvlmnLCEbRrP89ZHad48zgF8KqtzRPOZtIbvMiR24mo4Xcc2Bt86U2Ej3
         fkrkUlXZGxfiMVQ8SqSkMQr6TgCaaQScv3ia1m4zKpGvDRvtE/Ie6dva7c5hetelh0ej
         ejSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755217547; x=1755822347;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yJbizRUw+p2hqJq2yCwI8a4ldo76XC44biSplLoJEII=;
        b=W7613HtGqriHyMm11cZ6yIHzn/tyv0gaL5Sp5ilGaz3+8fIO72fYo2A2Pmp7+g99wS
         U2D8iR3pzEIvDVK6eP+hDiY+0+xGNEKh1S3CFhaMdnkxS2+Rr0C/zKDZlpWbvZ7rxGzk
         CWa/YOSA8XX85rAeefG1vmoAEtTHZxwuSXMlfSAs2+qIbM6L1vDkJjd/FmUkszAs/xpL
         KPqLITI7dudqzIGVHg2XH9y1pVMAy/lPjP1jIAOzdc6iYRnTwGFX71N+OCa1nSfxhHJU
         08sxwVHu+nkqi0DRtLdIQibBsIx5fQnBqJJJpGH0l/oIYsxy32kGb/4f4JyiemlJeaNx
         Raow==
X-Gm-Message-State: AOJu0YwTcNvYbhV4aZtMHPPa+dTvZvnWG2jxuN7ouoWLf4T77JxFbEJk
	LWRQyG6Cql0jEhKycsSC9ZKKGLWG2q8jR1wrOMg/4qIbvyBLxtsqsvaCSwKKQjemHKuYEEod0UB
	4uHaifw==
X-Google-Smtp-Source: AGHT+IG6sETl/uXVyld3Bdf7Q1Ak70AHDx6bGGr2qU8sVh2rUEa7JPwLnAYaVKdFIqbssWVjeI35rrCmp5g=
X-Received: from pgar2.prod.google.com ([2002:a05:6a02:2e82:b0:b2b:f469:cf78])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1590:b0:240:356:f06e
 with SMTP id adf61e73a8af0-240d2dc43a8mr333204637.0.1755217547650; Thu, 14
 Aug 2025 17:25:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:25:22 -0700
In-Reply-To: <20250815002540.2375664-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815002540.2375664-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815002540.2375664-3-seanjc@google.com>
Subject: [PATCH 6.6.y 02/20] KVM: SVM: Set RFLAGS.IF=1 in C code, to get VMRUN
 out of the STI shadow
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit be45bc4eff33d9a7dae84a2150f242a91a617402 ]

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
Reviewed-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20250224165442.2338294-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[sean: resolve minor syntatic conflict in __svm_sev_es_vcpu_run()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c     | 14 ++++++++++++++
 arch/x86/kvm/svm/vmenter.S |  9 +--------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 86c50747e158..abbb84ddfe02 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4170,6 +4170,18 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 
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
@@ -4177,6 +4189,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	else
 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
 
+	raw_local_irq_disable();
+
 	guest_state_exit_irqoff();
 }
 
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 56fe34d9397f..81ecb9e1101d 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -171,12 +171,8 @@ SYM_FUNC_START(__svm_vcpu_run)
 	VM_CLEAR_CPU_BUFFERS
 
 	/* Enter guest mode */
-	sti
-
 3:	vmrun %_ASM_AX
 4:
-	cli
-
 	/* Pop @svm to RAX while it's the only available register. */
 	pop %_ASM_AX
 
@@ -341,11 +337,8 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	VM_CLEAR_CPU_BUFFERS
 
 	/* Enter guest mode */
-	sti
-
 1:	vmrun %_ASM_AX
-
-2:	cli
+2:
 
 	/* Pop @svm to RDI, guest registers have been saved already. */
 	pop %_ASM_DI
-- 
2.51.0.rc1.163.g2494970778-goog


