Return-Path: <kvm+bounces-54702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D90B27365
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:13:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6C409E3334
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583BF2A1BA;
	Fri, 15 Aug 2025 00:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QnJSMhGf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF87AD2C
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755216736; cv=none; b=fi08ED+3oLJq8q/+6TodtTG7IYuQgblLvhee+o0MTmOyDFWnzZvYmT6DqJNSedeGaE8+pgf+ggzgZMhz6W8ECef+itu2bc+0xgLSqAtEKVVIAm33spiTr9ygJM0WPyq7zRBSGa1lc044is4CAO3jqKstmpWwiiNwwTuDVZThynY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755216736; c=relaxed/simple;
	bh=QZ7hiEeEodzcf9N5xa+v0EKi7D4cdSZUxTI4oTTqBUM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DV07upgSTyr0LAKLAE8+D6ALKklCZqe7BSkEzGH147aW6jSjxIzeV3asSJUn0/RseyhhmUZHSSGVweV2OCnz/Wg0ugmDaQnZcSTnuUsrTqfqbEWvPvUX0IBFx6jrB6j3d+rmEOavEM/tiP80EoEyGDXT01WwG8G+QMfjIfduoY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QnJSMhGf; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2445806b18aso14742155ad.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755216734; x=1755821534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+3Z7z+GhkYgH9ZaG5Bt9ilPatbNNXsIC5wDZoaGAfW0=;
        b=QnJSMhGf1xkhdlJm+hIeKc4J5S8Y/wvko75pb+7GHk9MjGCUkqE8y35/FGQTison19
         BPSZ/vk+VMfwpX+TjRTm896g4xV9WJlR/Dwe+c/+F3LvN0IsKcAui23Bk3Sf1lHXDZhM
         V6LKbRSgs/8k+vXFDVnv7oZgLeIybS28wo+bEVDf8BlEq037qwmZkaVNampp76RD688a
         DaNlCMUrgjRXIlFrl1I3LB3/+PRyFEKVySy0nDQEeKsYDS62u5G2NAjBhBolOy0Qn7Ny
         b65u+8arDYyhaSRiRP/mxzTiM12WazTJiqujIe8kj394s3gKC+QvCLZQKAydQC8SXnGp
         AaBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755216734; x=1755821534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+3Z7z+GhkYgH9ZaG5Bt9ilPatbNNXsIC5wDZoaGAfW0=;
        b=Bj12Fo04Mn9VrHgFk7dMAWhQa7+Ni8+GuN+XgRsOr+CCqSf2zeow9UFU/vYWAn7/EL
         tr2y+1DnYdLhOVdlYDurSzViq+zQGnOX17p5pBJbeRs3ruNpup2Lk4MeVYtWSw+uQKKX
         v2OVwyHPM/bhBEaLRPhZKyMe/zj+sjjqP+xc6PAGjvcHdfAP91KeYYXnM0q5D4gsUdk7
         bfHQx2et4cvI/p4NNQATxPofIrTzFqovOWmaTI+mvLXnVdB5SGK1bj7Sapg/w+f7taLy
         VzfMSCLWY9dj6Q27fA1HrFOvlFxTQTPX+UCdfRhBf2Mzspxrk5r/+pFghDnM8/J8IRU3
         nR+g==
X-Gm-Message-State: AOJu0YzLEoMNe0Wu14v2hiObhqVP2w1qwWKsjGtQTwatTDun1zYIi5lo
	f2tnbWrTiUiwYQIUp295lqNQpyHC6lqI+zXE6VNq1wpwd2H1+QOq8JdkZpnHA9hFMhjVoufOuzD
	VRt5NuA==
X-Google-Smtp-Source: AGHT+IFeyVWtbJnA+0jK98/KDDcJOwZAstyIgyOg41fad5x07dGh22iBOzCqZIcKbU86Qr8Tb8SFx3dcllQ=
X-Received: from pjbnd12.prod.google.com ([2002:a17:90b:4ccc:b0:31f:36c3:b18a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22c7:b0:242:8a45:a95e
 with SMTP id d9443c01a7336-2446d6e3df4mr1726155ad.15.1755216734230; Thu, 14
 Aug 2025 17:12:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:11:45 -0700
In-Reply-To: <20250815001205.2370711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815001205.2370711-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815001205.2370711-2-seanjc@google.com>
Subject: [PATCH 6.1.y 01/21] KVM: SVM: Set RFLAGS.IF=1 in C code, to get VMRUN
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
index b6bbd0dc4e65..c95a84afc35f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3982,6 +3982,18 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 
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
@@ -3989,6 +4001,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	else
 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
 
+	raw_local_irq_disable();
+
 	guest_state_exit_irqoff();
 }
 
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 42824f9b06a2..48b72625cc45 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -170,12 +170,8 @@ SYM_FUNC_START(__svm_vcpu_run)
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
 
@@ -343,11 +339,8 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
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


