Return-Path: <kvm+bounces-39035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9749BA42ACE
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 19:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D792F3AED2D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 010042661AC;
	Mon, 24 Feb 2025 18:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y1yCJ+DW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A11A264FA1
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 18:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740420804; cv=none; b=IIDcedJQwIS3+VURPzzrxolPh5NYSp0J7oLVkpLug3kQr+zCI8csGtCMKRARU9H6QAp2RFsqE1g2OlPiTFc2c5Y+WYuaDZbz1btfIjiTv+Rtd6Vc5c0aNUXqI70DH0KD7xjJulY75ciSQU+rBg6FQZMbczkXuGju1Ngoo/vzyek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740420804; c=relaxed/simple;
	bh=vN/eNE88oaBJnDBhwlNFxVO+p0HRkL3z/lFmoE6TLSU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mA/yY3YCxl0Ai0jmDYfwVQZqbhk+0y7RouzCLsc2quP+PRcHJV0ZzaOY1VSulEB+iTZKygKKPjC34QKhFPW12y0d0Bb4qLyY/phrYxuspPw3xXhmODgtMbU7b5Qz/pS2FVuw5y5XHDwCwFuzdGME3XPqUYynZvEu82WOC7dBMbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y1yCJ+DW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so10165607a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 10:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740420800; x=1741025600; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=F4R7WnGFsL3kL6doD4mCTe3Xz6e56UmxS2U2ziKjVXs=;
        b=Y1yCJ+DWiwQ+P2ChUleodDW+jSTAZ3fwOOuUBqk01lWNF/NZNEbdGbPVQhiSWoZy5c
         V01qcDuJHeLQD5/2fT/aPya0vqEYkkHDjWxP2+A1nEYFcolNqgbHQhJ0/sNviyBHavGZ
         9f0bzHica1pD6BRfoX0jYAD5FnwVcPyRdWJ5ZFB6zMt6qKo+m6vj6hQxUxEmtN8p/a7H
         Zhzv630LcEoR1yV+MniClWEiKtSD+/3B9aCXspjp1BfuPV+9nDyXma+GHRFJIZ55bo6i
         DqMEF5PLyTzLK5vXd44Nvr/7x6ih8xfllJQKIbp+skeaoqigveqeh4u53KTBQzHeG7C9
         nAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740420800; x=1741025600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F4R7WnGFsL3kL6doD4mCTe3Xz6e56UmxS2U2ziKjVXs=;
        b=xNpP/S7/USvBGDPFtApfnL3fV9keqk7xLbSuoXzdpKhNOngXXp1Bzbn5HdSCaUgEnO
         sJXtpqlvi5+HsQhhy928ybcJDVL1Aj9MQiC7XIjVThvrEuLN+WXO4Q3HvoaUOkqyxr7j
         FvwLEsyDebVyFNwlwAZ/dDSECr/suTwKliioT1QisH7YYyqw9gRKSbkJaWsL3pMctItA
         Uw3nc/k73kfWgcDmNSpkMn1heTU/waAIQOaMcAUo1QO+vDOfwVVDtNT6vVQqT+AOdE2t
         AzVF1M/dr2lTWhrSAa5ugR8KnBBLOdh8/WpL0pxsyGHPcx65SDXxKOdGs2Eu2MpNBbqU
         0kqg==
X-Gm-Message-State: AOJu0YzL8tGtpzT5sMjX5n6C87TVBIda/f8KpkHs3h05au6ghrN8yxAu
	ssjfJFf1Sh2TjH/8A7wAlMMwWZUfFsVKqyxvTm/lQUe8UFyZZE9wEf2q+47BtY1iQV1Ff6xr/ve
	5MA==
X-Google-Smtp-Source: AGHT+IEkWjLWqfrHGmJqcmECY42kHu9FpsyZxRZXM9MU8IhIeRa/Mtd1C3xZad6PO0xUWbPxHDpEpPRuIRo=
X-Received: from pjyp8.prod.google.com ([2002:a17:90a:e708:b0:2fc:d2ac:1724])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:180d:b0:2f7:e201:a8cc
 with SMTP id 98e67ed59e1d1-2fce78ad6e0mr27310678a91.18.1740420800405; Mon, 24
 Feb 2025 10:13:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 10:13:13 -0800
In-Reply-To: <20250224181315.2376869-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224181315.2376869-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224181315.2376869-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: x86: Snapshot the host's DEBUGCTL in common x86
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rangemachine@gmail.com, 
	whanos@sergal.fun, Ravi Bangoria <ravi.bangoria@amd.com>, 
	Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"

Move KVM's snapshot of DEBUGCTL to kvm_vcpu_arch and take the snapshot in
common x86, so that SVM can also use the snapshot.

Opportunistically change the field to a u64.  While bits 63:32 are reserved
on AMD, not mentioned at all in Intel's SDM, and managed as an "unsigned
long" by the kernel, DEBUGCTL is an MSR and therefore a 64-bit value.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/vmx.c          | 8 ++------
 arch/x86/kvm/vmx/vmx.h          | 2 --
 arch/x86/kvm/x86.c              | 1 +
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3506f497741b..02bffe6b54c8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -781,6 +781,7 @@ struct kvm_vcpu_arch {
 	u32 pkru;
 	u32 hflags;
 	u64 efer;
+	u64 host_debugctl;
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
 	bool load_eoi_exitmap_pending;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b71392989609..729c224b72dd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1514,16 +1514,12 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
  */
 void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
 	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
 		shrink_ple_window(vcpu);
 
 	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
-
-	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
 void vmx_vcpu_put(struct kvm_vcpu *vcpu)
@@ -7458,8 +7454,8 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	}
 
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
-	if (vmx->host_debugctlmsr)
-		update_debugctlmsr(vmx->host_debugctlmsr);
+	if (vcpu->arch.host_debugctl)
+		update_debugctlmsr(vcpu->arch.host_debugctl);
 
 #ifndef CONFIG_X86_64
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 8b111ce1087c..951e44dc9d0e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -340,8 +340,6 @@ struct vcpu_vmx {
 	/* apic deadline value in host tsc */
 	u64 hv_deadline_tsc;
 
-	unsigned long host_debugctlmsr;
-
 	/*
 	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
 	 * msr_ia32_feature_control. FEAT_CTL_LOCKED is always included
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58b82d6fd77c..09c3d27cc01a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4991,6 +4991,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
+	vcpu->arch.host_debugctl = get_debugctlmsr();
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
-- 
2.48.1.658.g4767266eb4-goog


