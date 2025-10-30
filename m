Return-Path: <kvm+bounces-61599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8055EC2297D
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 23:45:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAC643AE131
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 22:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D243D33E355;
	Thu, 30 Oct 2025 22:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AkTAIJUI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FD333BBCE
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 22:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761864175; cv=none; b=fRsePPo6peSXV7EXoBo9GhMhoicM32ZETZrhWy8BafH+atdlx31FIqCTyXW29kkNo5DKdqVSxyTxOIpQOBnqlpIPiODxTypsKEKbJScPbEjI5YcDTrjG0g6czodRojY5AvyiYKGDofJCA0IQqYWdGZiHv+QcUeNan3rWSOrrGhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761864175; c=relaxed/simple;
	bh=04xnJwAcMICbMnebLnR0u9v2H7m/YSJO+W1jRIi4Fmk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FjF72VwjeD5CPEqtpW5SnPwRiVqJd9lLswZ+U3WWt3H5ot2VmfUDU7fSBtSq37ew1FCz1Tikn7Wlsolbh1wzcTj67ppY0ru2MmNKoKG5v30xjpVlwssvosvlXAuDOV3USRFGXszVDMF9K5MZNDljbvyipht2Yqs7gHEfWYOjZn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AkTAIJUI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33d75897745so4097047a91.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 15:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761864173; x=1762468973; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KcDGQ+FJrmPj33uuNnd2ahLYzOoCImQQ4AQmI9v7NVo=;
        b=AkTAIJUIq7/4uIq3vWJf8R+uq27BO8eexJGSDgubATx/eP9hsDmQSZ8UCHs618aaC8
         wrblfp9A3Ow4OVM3P4Rmhe3VMIzHwpJfZQSqY82XReQqrm77anUUBrT67ZZvOFxNC2eb
         pnS1DtAQrI1tRB0MM/J/Gs+JGyY6e9dwYsBVkaJqREaBY5IoXPe4qxbwi+4fP6ii2Esb
         HW2F9dpQ5l/AOMIIqxRQmLMu0RVU1RMhZAcYf7RBgWnWGGfZRfvKHyjicMlfCxRxoRSq
         Q2CHbaVSvN9f4nm8gam0XXNTpXxap9CpadnVpxKZ1tyiR4ac7UBRnHQNBAqLy8IB5paj
         wMOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761864173; x=1762468973;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KcDGQ+FJrmPj33uuNnd2ahLYzOoCImQQ4AQmI9v7NVo=;
        b=S8H3fgKCtUjEsGB5/NWpVXNF/7+NFWoeNhy1ch3agZxm9TBUGlKOeahArs6sZ6nOAt
         LhMShGCUNPR2FOhP6bZxNAC2qABq27T+pRU2fb02y0VcseeZURyOHnt+BXgxROc001Uv
         bqrUQ7XwwnA0dgDKctAbW+sAu+HJJoZesX7UQfynSQqLO8koLTPgO/Gx4ZumVcprnr4d
         Rg8z8qKWj8avFh+4EEQals3SRHM1ANkiIfiCgIBBGZ7Gwjz5AlZV5HrbyTp1SRs3npYW
         tkzWLRbfmmhj1BKDy6thXAv5KYXE98P0WpOqj49fF8T8Vq29BmeIy9BTkdzPGTXCND7E
         tOLA==
X-Gm-Message-State: AOJu0YxqJwEM+c95mmBP84X0fvNEfsTY6ByKQAbfJpeSWeRfBpO3oAI9
	YdF0qYBTUUA5KFTYbWO3CRysqtLRkrc/uIpyls+dcEWKb8F+3mqS9KYlbNf47XPOILfDccxS9eu
	CGKkPxg==
X-Google-Smtp-Source: AGHT+IHx3r5KOxD+Pa4cYbZxXLFPXjy7LS9ZHDQFrKCaQ27ZyUwu5YQC2zgibVU8pjv1FCMn6Ev8njqyhHo=
X-Received: from pjuy3.prod.google.com ([2002:a17:90a:d703:b0:33b:51fe:1a91])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2886:b0:33b:8ac4:1ac4
 with SMTP id 98e67ed59e1d1-34083089b28mr1743813a91.35.1761864172829; Thu, 30
 Oct 2025 15:42:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 15:42:43 -0700
In-Reply-To: <20251030224246.3456492-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030224246.3456492-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030224246.3456492-2-seanjc@google.com>
Subject: [PATCH 1/4] KVM: SVM: Handle #MCs in guest outside of fastpath
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jon Kohler <jon@nutanix.com>
Content-Type: text/plain; charset="UTF-8"

Handle Machine Checks (#MC) that happen in the guest (by forwarding them
to the host) outside of KVM's fastpath so that as much host state as
possible is re-loaded before invoking the kernel's #MC handler.  The only
requirement is that KVM invokes the #MC handler before enabling IRQs (and
even that could _probably_ be relaxed to handling #MCs before enabling
preemption).

Waiting to handle #MCs until "more" host state is loaded hardens KVM
against flaws in the #MC handler, which has historically been quite
brittle. E.g. prior to commit 5567d11c21a1 ("x86/mce: Send #MC singal from
task work"), the #MC code could trigger a schedule() with IRQs and
preemption disabled.  That led to a KVM hack-a-fix in commit 1811d979c716
("x86/kvm: move kvm_load/put_guest_xcr0 into atomic context").

Note, except for #MCs on VM-Enter, VMX already handles #MCs outside of the
fastpath.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f14709a511aa..e8b158f73c79 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4335,14 +4335,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 
 	vcpu->arch.regs_avail &= ~SVM_REGS_LAZY_LOAD_SET;
 
-	/*
-	 * We need to handle MC intercepts here before the vcpu has a chance to
-	 * change the physical cpu
-	 */
-	if (unlikely(svm->vmcb->control.exit_code ==
-		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
-		svm_handle_mce(vcpu);
-
 	trace_kvm_exit(vcpu, KVM_ISA_SVM);
 
 	svm_complete_interrupts(vcpu);
@@ -4631,8 +4623,16 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 
 static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
-	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_INTR)
+	switch (to_svm(vcpu)->vmcb->control.exit_code) {
+	case SVM_EXIT_EXCP_BASE + MC_VECTOR:
+		svm_handle_mce(vcpu);
+		break;
+	case SVM_EXIT_INTR:
 		vcpu->arch.at_instruction_boundary = true;
+		break;
+	default:
+		break;
+	}
 }
 
 static void svm_setup_mce(struct kvm_vcpu *vcpu)
-- 
2.51.1.930.gacf6e81ea2-goog


