Return-Path: <kvm+bounces-9582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 052EA861DF6
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00756B2329C
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 20:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E289158D60;
	Fri, 23 Feb 2024 20:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CmekOdEZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3C1157E86
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 20:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708720967; cv=none; b=FJtJMUw9hGrdEF0YfqSGpIB1TZi1cgc+/J5QCjF0Oure4TsdbHFM6TW5+ns2XuPGr1lrKYIDc3tmIZCNdcb73baqg6EelBXOAh7JqCQI4z8L1X+Vt9vnA0T5FEWRKuFvNM7YZ7+4AAC3rXL285BZzmzBlTE9bVnh/z23o0egei4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708720967; c=relaxed/simple;
	bh=2NQqn0GS1NXkZhFdQnHQDhlZap/bPRB2/FTisNgRF48=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ASyAgHHwn1YT9an3mOHlrmlcHRF4dwJl7TVL/w31WfZmOuZRG0REDyqvfCeCfVjIkaD+M8ljOsO8AIcDywfELb7SBlDlbU87yp91GXMaNW5zeNV9M9ifEY+5Im16DH2+5G2/bn79TQ+ABwHVZI80j77KTBmQ0KJP2ux463FXRxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CmekOdEZ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6087ffdac8cso13957957b3.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 12:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708720964; x=1709325764; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fjPJ3Hja7aXkfyUdgxA5xTLuvAk9amyqKFMcOEhsGqM=;
        b=CmekOdEZhBlSR+m+qkvetN4vXy6aAs4K2Aqz7+dBGhTrSRGmVUfZcCJCaLRS6Tg1EQ
         +AqV9BdVyxHw7Jh6D1GOnbKsjjy1n6HknPWPbMCAGizEakeSVkNi/TY6W4Xo0tOVZb9Y
         BWupji0dF0NJDVzfNEvYfc1zQxDFrXOue+lO6dTtT/bftQiurEtQ3BbOeEo+CWEXA/8K
         TMCiEJygm01gxqW5BTqTU/qfSAmul6B3MnNlHotgMdPwLz+f25jNcxep49Hduc8CZU/9
         h/sX7rS+e6MDCaTX697ZC/gOKrv2VbiqVhSzL5CTiWHIUbzSNbJq5ld/8t2XfSiOmhXM
         9pdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708720964; x=1709325764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fjPJ3Hja7aXkfyUdgxA5xTLuvAk9amyqKFMcOEhsGqM=;
        b=DqbDOEHQKiJgzzGvqcLvq/f3PGa9DvxQpHHuuDXR0jXB7VOZwhFIzoHSEeOCx/xWdm
         W37ajxQabKqOmuYTzvt+BJVzdcloDATCzF3o9j8EX/nCuD9hbL+oyUHvvVTFK/eL0Sdp
         8aNeHxoD6yhZ3aNDFmSl0buB11vLNfupSE1Dx+NdmlGAkGacd3iz6l/mVXLkzHFxHV9Z
         TuqsxRF/s72YsjpYGwc7WUde6rpkdVOm7SAy8sBvLI4z03kNjoRXkLHNudYZKZP7Wbkd
         q26Y9iuU4BvZGEusJ0TIglKGj/1J1RNnaxfhQR/ejiYiePqESV0yuRNwwE5LCMOTZTCJ
         FyKA==
X-Gm-Message-State: AOJu0YzNMxbz2MkDKIpx2+/hVlq2Vj2OA9HEjYCOLu72b4N3BKiI9WJ1
	XzPutUqlCPJQAWG3mA4ej5UarMDYJgTP/FsunPQ+t0R84tKZAmD0/7TJf75pbQUH6LX9jEWQF8y
	h1A==
X-Google-Smtp-Source: AGHT+IF38vTRLUiuDrGGzTvX81aATDA8TANDbUdAfA3ms+j3X+FiOVp6jsSKOrh+1hU5miP3ns29lCgI6fs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1243:b0:dcd:3172:7265 with SMTP id
 t3-20020a056902124300b00dcd31727265mr244887ybu.8.1708720964754; Fri, 23 Feb
 2024 12:42:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 12:42:30 -0800
In-Reply-To: <20240223204233.3337324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223204233.3337324-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223204233.3337324-6-seanjc@google.com>
Subject: [PATCH 5/8] KVM: SVM: Save/restore non-volatile GPRs in SEV-ES VMRUN
 via host save area
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

Use the host save area to save/restore non-volatile (callee-saved)
registers in __svm_sev_es_vcpu_run() to take advantage of hardware loading
all registers from the save area on #VMEXIT.  KVM still needs to save the
registers it wants restored, but the loads are handled automatically by
hardware.

Aside from less assembly code, letting hardware do the restoration means
stack frames are preserved for the entirety of __svm_sev_es_vcpu_run().

Opportunistically add a comment to call out why @svm needs to be saved
across VMRUN->#VMEXIT, as it's not easy to decipher that from the macro
hell.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c     | 17 +++++++++-------
 arch/x86/kvm/svm/svm.h     |  3 ++-
 arch/x86/kvm/svm/vmenter.S | 41 +++++++++++++++++++++-----------------
 3 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..e7c8a48e36eb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1503,6 +1503,11 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
 }
 
+static struct sev_es_save_area *sev_es_host_save_area(struct svm_cpu_data *sd)
+{
+	return page_address(sd->save_area) + 0x400;
+}
+
 static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1519,12 +1524,8 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 * or subsequent vmload of host save area.
 	 */
 	vmsave(sd->save_area_pa);
-	if (sev_es_guest(vcpu->kvm)) {
-		struct sev_es_save_area *hostsa;
-		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
-
-		sev_es_prepare_switch_to_guest(hostsa);
-	}
+	if (sev_es_guest(vcpu->kvm))
+		sev_es_prepare_switch_to_guest(sev_es_host_save_area(sd));
 
 	if (tsc_scaling)
 		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
@@ -4101,6 +4102,7 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 
 static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_intercepted)
 {
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	guest_state_enter_irqoff();
@@ -4108,7 +4110,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	amd_clear_divider();
 
 	if (sev_es_guest(vcpu->kvm))
-		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
+		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted,
+				      sev_es_host_save_area(sd));
 	else
 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8ef95139cd24..b98cced44e48 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -697,7 +697,8 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
 
-void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
+void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted,
+			   struct sev_es_save_area *hostsa);
 void __svm_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
 
 #define DEFINE_KVM_GHCB_ACCESSORS(field)						\
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index edbaadaacba7..e92953427100 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -292,23 +292,35 @@ SYM_FUNC_START(__svm_vcpu_run)
 SYM_FUNC_END(__svm_vcpu_run)
 
 #ifdef CONFIG_KVM_AMD_SEV
+
+
+#ifdef CONFIG_X86_64
+#define SEV_ES_GPRS_BASE 0x300
+#define SEV_ES_RBX	(SEV_ES_GPRS_BASE + __VCPU_REGS_RBX * WORD_SIZE)
+#define SEV_ES_RBP	(SEV_ES_GPRS_BASE + __VCPU_REGS_RBP * WORD_SIZE)
+#define SEV_ES_R12	(SEV_ES_GPRS_BASE + __VCPU_REGS_R12 * WORD_SIZE)
+#define SEV_ES_R13	(SEV_ES_GPRS_BASE + __VCPU_REGS_R13 * WORD_SIZE)
+#define SEV_ES_R14	(SEV_ES_GPRS_BASE + __VCPU_REGS_R14 * WORD_SIZE)
+#define SEV_ES_R15	(SEV_ES_GPRS_BASE + __VCPU_REGS_R15 * WORD_SIZE)
+#endif
+
 /**
  * __svm_sev_es_vcpu_run - Run a SEV-ES vCPU via a transition to SVM guest mode
  * @svm:	struct vcpu_svm *
  * @spec_ctrl_intercepted: bool
  */
 SYM_FUNC_START(__svm_sev_es_vcpu_run)
-	push %rbp
-	push %r15
-	push %r14
-	push %r13
-	push %r12
-	push %rbx
-
 	/*
-	 * Save variables needed after vmexit on the stack, in inverse
-	 * order compared to when they are needed.
+	 * Save non-volatile (callee-saved) registers to the host save area.
+	 * Except for RAX and RSP, all GPRs are restored on #VMEXIT, but not
+	 * saved on VMRUN.
 	 */
+	mov %rbp, SEV_ES_RBP (%rdx)
+	mov %r15, SEV_ES_R15 (%rdx)
+	mov %r14, SEV_ES_R14 (%rdx)
+	mov %r13, SEV_ES_R13 (%rdx)
+	mov %r12, SEV_ES_R12 (%rdx)
+	mov %rbx, SEV_ES_RBX (%rdx)
 
 	/* Accessed directly from the stack in RESTORE_HOST_SPEC_CTRL.  */
 	push %rsi
@@ -316,7 +328,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	/* Save @svm. */
 	push %rdi
 
-	/* Clobbers RAX, RCX, RDX.  */
+	/* Clobbers RAX, RCX, RDX (@hostsa). */
 	RESTORE_GUEST_SPEC_CTRL
 
 	/* Get svm->current_vmcb->pa into RAX. */
@@ -338,7 +350,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
 
-	/* Clobbers RAX, RCX, RDX.  */
+	/* Clobbers RAX, RCX, RDX, consumes RDI (@svm). */
 	RESTORE_HOST_SPEC_CTRL
 
 	/*
@@ -353,13 +365,6 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	/* "Pop" and discard @spec_ctrl_intercepted. */
 	pop %rax
 
-	pop %rbx
-
-	pop %r12
-	pop %r13
-	pop %r14
-	pop %r15
-	pop %rbp
 	RET
 
 	RESTORE_GUEST_SPEC_CTRL_BODY
-- 
2.44.0.rc0.258.g7320e95886-goog


