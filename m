Return-Path: <kvm+bounces-64261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B33B5C7BD81
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 23:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E04DE381636
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 22:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB0730C357;
	Fri, 21 Nov 2025 22:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OS6SWsqi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BBB30BBBA
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 22:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763763623; cv=none; b=uqFliMGNIc1cCQdmpAdvwsB5npPkdG6ozQbnqbgk8DejjyuTSjckQpgq+yWtlDN3FTFW3rRhRNPE3EVEXPcn2QYC2tYjkoJBjazUp0ioe9GZ4LTXJ+lg9YxyZrFwqwtNfaiII2Bv+dgf20kdKtSnCxG+527dUoQPCkoFSm14/PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763763623; c=relaxed/simple;
	bh=8WpqYiGPCKqUwM2MjhFbv9yhuD0e4K6scqBG5rwtYgk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sVDzfZh3r9IQPpAtwnyA/AVANOzH3TwMlmLzLSwcZuNLco99sBKi8QMIIQOHmdUhxjjAeCm5yNx9XGKHFevvWu4rHA7bB8iEzL/vIDxnEixegqxPvj0GcDKN5msW0XyexD9Mzi6ehVbGyz0SXzXiItG5RFRjXZsuD36LObTZJEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OS6SWsqi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34385d7c4a7so1735813a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763763621; x=1764368421; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+gI0WWC5QegPbFsQlBjgG9Al8K6d0pQkeiFW6ExIUFM=;
        b=OS6SWsqi0/Q2rkm7UjRxx5PZBRdpP/bW8iTlImxE4KUiwRU57KNNdFbsHa7LFDY985
         EpYimsqfMBFVoRzBJHgfpbU5ooBZRStUjxHuJjCcrtlHgjl2iIwXVTlkHkViuWyYByUi
         iQ/9VvQE5JsNe2w+uqzUeeVAP9icCVYHQyiPga0bvNnpua9FgRIbu7oha/ETAwzF5YD3
         KEuMD+F/5T4SSKTZpRFYGCtbfx7LDV/GPeAfsm5hKwwGLiPjesETu205ZUp6/nx7n3sx
         RmcfRuHpR2B6QwDwZy5/pdHmhiXGHMlX1OkgVJbmilwShUAUqyh+OqUsl6DEtv9g9iSM
         bxxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763763621; x=1764368421;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+gI0WWC5QegPbFsQlBjgG9Al8K6d0pQkeiFW6ExIUFM=;
        b=OwsgHznX0dl8+fEvyGZCiJs89Cu3fRgIyhFERIuxqpytdibytXpzL3uXVtrOgQ86lI
         RiJ0URyClS1UYzT4pI2ro9xEkhFc91fMfF8YHBgCAPvtqdpiiOqVHchQy3dICfUMa39F
         ljbminUHKJKD4T5QZ1SKi6TLXSRQbDJGQGKUu1X50H9Jrh7Urmt1r9SwmaDFPg2EA2CS
         QLac+9WA9DGJ7XUzthMXfxiiaxVYjBMFjpGgIEyuUeR4dHVhR8nV2JQwDNoSEPpInYkF
         nHW9lzNvFM/U8e4yuMSfxZTe7Jj0FJjkd+Lyn5KGRbyVhHBLocp2CdipuKit0TN0cfwq
         D2Og==
X-Gm-Message-State: AOJu0YwRKMBya4LqGOjL6D7x0niAEwO39JXcKr3Rf5EZdfYlUFetbNN5
	jQ0Pd3dTc5TkDM19c7Atlvfi+Y0+8nbhBQs0yK3yERrsE4urjKeA6DuzEKiAiLu14WsgvZpA5AA
	AdkmHQA==
X-Google-Smtp-Source: AGHT+IFlHFoDJiHaf8ZaqB6R4bcybwOD+6uqLjYU2d2GeKrU5dbhxs/pYDmnXdotD4hqzCWv7yN8+1L74xw=
X-Received: from pjbbb13.prod.google.com ([2002:a17:90b:8d:b0:33b:b0fe:e54d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b8f:b0:343:85eb:4fc7
 with SMTP id 98e67ed59e1d1-347298501abmr8536259a91.6.1763763620929; Fri, 21
 Nov 2025 14:20:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 14:20:18 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121222018.348987-1-seanjc@google.com>
Subject: [PATCH] KVM: VMX: Always reflect SGX EPCM #PFs back into the guest
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

When handling intercepted #PFs, reflect EPCM (Enclave Page Cache Map)
violations, i.e. #PFs with the SGX flag set, back into the guest.  KVM
doesn't shadow EPCM entries (the EPCM deals only with virtual/linear
addresses), and so EPCM violation cannot be due to KVM interference,
and more importantly can't be resolved by KVM.

On pre-SGX2 hardware, EPCM violations are delivered as #GP(0) faults, but
on SGX2+ hardware, they are delivered as #PF(SGX).  Failure to account for
the SGX2 behavior could put a vCPU into an infinite loop due to KVM not
realizing the #PF is the guest's responsibility.

Take care to deliver the EPCM violation as a #GP(0) if the _guest_ CPU
model is only SGX1.

Fixes: 72add915fbd5 ("KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC")
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

SGX side of things is compile tested only.

 arch/x86/kvm/vmx/vmx.c | 58 ++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4cbe8c84b636..7c4080d780b5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5303,12 +5303,53 @@ static bool is_xfd_nm_fault(struct kvm_vcpu *vcpu)
 	       !kvm_is_cr0_bit_set(vcpu, X86_CR0_TS);
 }
 
+static int vmx_handle_page_fault(struct kvm_vcpu *vcpu, u32 error_code)
+{
+	unsigned long cr2 = vmx_get_exit_qual(vcpu);
+
+	if (vcpu->arch.apf.host_apf_flags)
+		goto handle_pf;
+
+	/* When using EPT, KVM intercepts #PF only to detect illegal GPAs. */
+	WARN_ON_ONCE(enable_ept && !allow_smaller_maxphyaddr);
+
+	/*
+	 * On SGX2 hardware, EPCM violations are delivered as #PF with the SGX
+	 * flag set in the error code (SGX1 hardware generates #GP(0)).  EPCM
+	 * violations have nothing to do with shadow paging and can never be
+	 * resolved by KVM; always reflect them into the guest.
+	 */
+	if (error_code & PFERR_SGX_MASK) {
+		WARN_ON_ONCE(!IS_ENABLED(CONFIG_X86_SGX_KVM) ||
+			     !cpu_feature_enabled(X86_FEATURE_SGX2));
+
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_SGX2))
+			kvm_fixup_and_inject_pf_error(vcpu, cr2, error_code);
+		else
+			kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	/*
+	 * If EPT is enabled, fixup and inject the #PF.  KVM intercepts #PFs
+	 * only to set PFERR_RSVD as appropriate (hardware won't set RSVD due
+	 * to the GPA being legal with respect to host.MAXPHYADDR).
+	 */
+	if (enable_ept) {
+		kvm_fixup_and_inject_pf_error(vcpu, cr2, error_code);
+		return 1;
+	}
+
+handle_pf:
+	return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
+}
+
 static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 intr_info, ex_no, error_code;
-	unsigned long cr2, dr6;
+	unsigned long dr6;
 	u32 vect_info;
 
 	vect_info = vmx->idt_vectoring_info;
@@ -5383,19 +5424,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (is_page_fault(intr_info)) {
-		cr2 = vmx_get_exit_qual(vcpu);
-		if (enable_ept && !vcpu->arch.apf.host_apf_flags) {
-			/*
-			 * EPT will cause page fault only if we need to
-			 * detect illegal GPAs.
-			 */
-			WARN_ON_ONCE(!allow_smaller_maxphyaddr);
-			kvm_fixup_and_inject_pf_error(vcpu, cr2, error_code);
-			return 1;
-		} else
-			return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
-	}
+	if (is_page_fault(intr_info))
+		return vmx_handle_page_fault(vcpu, error_code);
 
 	ex_no = intr_info & INTR_INFO_VECTOR_MASK;
 

base-commit: 0c3b67dddd1051015f5504389a551ecd260488a5
-- 
2.52.0.rc2.455.g230fcf2819-goog


