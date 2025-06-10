Return-Path: <kvm+bounces-48918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BAEC9AD4696
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 720D17A7409
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B399028C2BC;
	Tue, 10 Jun 2025 23:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wAJhDQJG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790BD280021
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 23:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749597617; cv=none; b=YXPRS7kPB4viFpZ3Awm06LarKW+TMyG+CxjTOLSjV8KHATZtfxMbNxas0AJcDvASOtsfI7s9C7K9MISWz0lJ6i5yNQYiNcbn1f1Tugibr7LIy+zfvAp67xzqBOGazW43CVyiD8KWDtfjJsuAcnw2NBPyDsbqj/kSe3HQWFI9ghA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749597617; c=relaxed/simple;
	bh=MmISEUVAZkAYO+3tppVzE59BztQ7B47DiT8C5/3AK3I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZYsLIomHxCY+ihn2VQny5ISQ78K4I6Zck7dgWlNZxFZcTmIRnqMKrADofAsjN1AO3CIZ/H3ibxiJjaPjx00jwEIelyjO1q1721kmx+HFUNXXrSNJSAWS8KJYzTMsXvfyysS09qImpUnH0vRfdeIRnragYW7kr3gvIV7thz/30h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wAJhDQJG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2c37558eccso3793404a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 16:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749597615; x=1750202415; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ku4Jlo0vfxtFTgd99p+Ks+SleUGyUmQc0U3V1r1cPLo=;
        b=wAJhDQJGBwDbE/mLGnLGJr2k7bjlRThyjy2hh1U/WTtSNHd8b7HVCxvsaLXt8Es7za
         5CH1Ff9naNoOJpq1BLvI1LyN+RzryjyhKXj5LqDlrzPIMNoFJPpDcjZM4oWT+gYb9Bq2
         3tGIrBxhHhJtB51V/s/iUnYuyz/RtYnZhL8Bf7qu56+miOmJhuRv0/UkRDDiENcqtm6y
         r4+EPPPZqnEnIvSaHspgvzXjqbCqpUSqluuspkx8FIJy/FKEozBfYK+mO/MNJ1WWsmHe
         0XhFZIL6Pl7+lv+ABwuAng8WstexBomyQpGgLP0sevA5jG8QhrICj63vIglQg8nEVKCG
         ud+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749597615; x=1750202415;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ku4Jlo0vfxtFTgd99p+Ks+SleUGyUmQc0U3V1r1cPLo=;
        b=FUSN7HR1f/CoyA+cCxyMHyqZe0XQ74NvZL0yFN94jm8Fw/STafx90qEcr5QnHfyvKT
         9J5AJ6pQSP4SY0phzIWqlGGKOIqN1qhKYNBF3I6FWzVTf3CmgZ0X7czT4So1dOpRTpL2
         diiaVNs+PhAPLZSMZvZsB2AhANPtRv5yANVBinol64Fnstbaev/edeyFuatPQ4ixqv5Z
         JG2FZMQQ2QM56uBEdbyPq6lSfrQlCrOhKqIju0HvgVsNFO+HsY/2HH1BXNSYeZQ4WQ8h
         jbfjzAf5e9OTnKgNUCvAH0qQbqRj/LL+why/7FmoZoj0tmRFN/f1W/1QWdee1tpu++jT
         9JmA==
X-Gm-Message-State: AOJu0Yyvcv5Q4kUEF9E+wdFGTp7kFWQIDY1dpDckYZwW3eVo8OU0zkI9
	erCj3LDESSOU4Zbddm+0aRBzt0OpT55gML6vyfU5Ys+jMcox1Idx4M+as6oOFPMijcFttYBvv4p
	aTIOkmQ==
X-Google-Smtp-Source: AGHT+IHskFiLR9R0/+qB03P2oZJfiwIk2UJIC6FsIlh4oCPhGlI2xBclplA11XHeDq3Z7tAlav5E6cfk8vE=
X-Received: from pjbos11.prod.google.com ([2002:a17:90b:1ccb:b0:311:4201:4021])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c4f:b0:311:e8cc:425d
 with SMTP id 98e67ed59e1d1-313af11cbb2mr1636619a91.10.1749597614808; Tue, 10
 Jun 2025 16:20:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 16:20:03 -0700
In-Reply-To: <20250610232010.162191-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610232010.162191-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610232010.162191-2-seanjc@google.com>
Subject: [PATCH v6 1/8] KVM: TDX: Use kvm_arch_vcpu.host_debugctl to restore
 the host's DEBUGCTL
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Use the kvm_arch_vcpu.host_debugctl snapshot to restore DEBUGCTL after
running a TD vCPU.  The final TDX series rebase was mishandled, likely due
to commit fb71c7959356 ("KVM: x86: Snapshot the host's DEBUGCTL in common
x86") deleting the same line of code from vmx.h, i.e. creating a semantic
conflict of sorts, but no syntactic conflict.

Using the version in kvm_vcpu_arch picks up the ulong => u64 fix (which
isn't relevant to TDX) as well as the IRQ fix from commit 189ecdb3e112
("KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs").

Link: https://lore.kernel.org/all/20250307212053.2948340-10-pbonzini@redhat.com
Cc: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 8af099037527 ("KVM: TDX: Save and restore IA32_DEBUGCTL")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/common.h | 2 --
 arch/x86/kvm/vmx/tdx.c    | 6 ++----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index a0c5e8781c33..bc5ece76533a 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -53,8 +53,6 @@ struct vcpu_vt {
 #ifdef CONFIG_X86_64
 	u64		msr_host_kernel_gs_base;
 #endif
-
-	unsigned long	host_debugctlmsr;
 };
 
 #ifdef CONFIG_KVM_INTEL_TDX
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..3cfe89aad68e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -778,8 +778,6 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	else
 		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
 
-	vt->host_debugctlmsr = get_debugctlmsr();
-
 	vt->guest_state_loaded = true;
 }
 
@@ -1055,8 +1053,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	tdx_vcpu_enter_exit(vcpu);
 
-	if (vt->host_debugctlmsr & ~TDX_DEBUGCTL_PRESERVED)
-		update_debugctlmsr(vt->host_debugctlmsr);
+	if (vcpu->arch.host_debugctl & ~TDX_DEBUGCTL_PRESERVED)
+		update_debugctlmsr(vcpu->arch.host_debugctl);
 
 	tdx_load_host_xsave_state(vcpu);
 	tdx->guest_entered = true;
-- 
2.50.0.rc0.642.g800a2b2222-goog


