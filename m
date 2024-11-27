Return-Path: <kvm+bounces-32595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75EBA9DAE76
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E7DC281D5B
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B25B2036E8;
	Wed, 27 Nov 2024 20:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0/ZU9ezV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E47203706
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738804; cv=none; b=QGpQZ6ZDwlceFuAKLYIr84JU1/E9F9LbL49S2l4CBFwg7THenodW/9fq9k6PG03NRpTyqlApf9/UQFR+eSRBG7HrGNDUBihZOJZPchOTYIxJ9cwAF5V380800PO+Z3Fy1eZwoEeuvghUs3K3TtfcBTzX355lSNhftnTxvKogFlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738804; c=relaxed/simple;
	bh=eNSVYv5B1xseFGh1DR/QMn9+gQm27dzmcxcCk5toSx0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tyY7wmy1simjydN/794Z6Sxfz2dbvooXdElgkf2Q5CaYoWT4vjH89VX3daJJCu1bu4R0qt6tM2CyPXpRjnTNBo3lBaTSTlnFC3aj0XkFcsAUXcmKn/GO6B1sSrg8tUMano3JQsVkTLSS4mebMO6JZQHqVV/L/rQNtMWFQGQ31KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0/ZU9ezV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea873d84edso124079a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738802; x=1733343602; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r3AUb3S/hhOpmdohfQBrWaKmWg8lsoot3L2/mMn3yIA=;
        b=0/ZU9ezVb2bnkqQAZiuIXqtQSNEVispC1rst8LB9mgZkcJHOsw/KX0Xnb9JEhkVrvJ
         2e3xTv5abkgIMQgyghR7KCNdWZSh4GL9MCRGDAS12itVHkwJ47PcBVK4WAFK27y8yBvl
         LsSyJCkzaavXyJtwvIu8YW4qp6yYA80uwnQxf9Khbd4ibE5WCWuQTTq5x/QOJVTGMz+q
         pYaQdaRPk90Sep2cz6I7JmpAsSFeL+EC3EUNcHkDtKB1ot5sfndpFjJqs1cs66X3mxgm
         YuED1nknZ75Bi/v+PachWu1VgOs1iL15gNDBt33BmgfdJijqrSTj5vqfdXUjv4m0rz4W
         fXdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738802; x=1733343602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r3AUb3S/hhOpmdohfQBrWaKmWg8lsoot3L2/mMn3yIA=;
        b=i6tgfF9Ku18IBnHirkF0BaMemIPN/e2ls6W2PLBS4Ef4p9zj71On5+w9jOY7QKqlO/
         q+UUHo0DrFW5LtvcRq0qmFdztNym+KX9nx/R7xssAz/IfAolL89oQttG2QWjBrrnEbJN
         kG9aKvsIdk4Bj3eRhf/M4BvsjT9kv05IP3Bv2xhXxyIkV/3YUkIjWww1NhZMJSaKqPwC
         6Wc4CleXt98QmMHzexS89LbKT6JDkcRgDksAhR129C0LWZibCBSy5YoMKAtCPmwzgQw/
         v3+Ab5RNYNI5Z1OwMKNSNFWs/dzypUv6px8sRul4xPAEn9uzUL3+HnlbxgG6Zr5gFnMI
         t7Cg==
X-Gm-Message-State: AOJu0Yx9PMZAb1M0c1iBSWbBisV5w/iWV7r6M9eLoS+o14q1w6gXqpBp
	eL1AR7B0kz06bY6fyyVHYbstr/7AmZqPgIZ3ipj+OVfZuokv3lsjy/y05LHq3Hr+F1PTQDBNzIb
	wCcCcnuXgHgU2RrayOq/Vevic5oPUM9p9MHV/4idu/UEwB5B2YdzNdjw33WpCKxyYgDcHbtKLA/
	dWhwESOSeJCcgJeGPutC/jwKyBuIit3yd/69y0Jiy8MuBYZFjTvQ==
X-Google-Smtp-Source: AGHT+IEY/2O8CRDULXauTh88uV8h43PA4CyDCTmAsv15d5dCMigbNTwzXW3+eLa0GHRG3LDP6DUFFUlZpEO7Ut3f
X-Received: from pjbsw12.prod.google.com ([2002:a17:90b:2c8c:b0:2ea:5069:aaac])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ec9:b0:2ea:8565:65bc with SMTP id 98e67ed59e1d1-2ee097c59f0mr5693205a91.23.1732738802086;
 Wed, 27 Nov 2024 12:20:02 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:23 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-10-aaronlewis@google.com>
Subject: [PATCH 09/15] KVM: SVM: Drop "always" flag from list of possible
 passthrough MSRs
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 134 ++++++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 25d41709a0eaa..3813258497e49 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -81,51 +81,48 @@ static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
 #define X2APIC_MSR(x)	(APIC_BASE_MSR + (x >> 4))
 
-static const struct svm_direct_access_msrs {
-	u32 index;   /* Index of the MSR */
-	bool always; /* True if intercept is initially cleared */
-} direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
-	{ .index = MSR_STAR,				.always = true  },
-	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
-	{ .index = MSR_IA32_SYSENTER_EIP,		.always = false },
-	{ .index = MSR_IA32_SYSENTER_ESP,		.always = false },
+static const u32 direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
+	MSR_STAR,
+	MSR_IA32_SYSENTER_CS,
+	MSR_IA32_SYSENTER_EIP,
+	MSR_IA32_SYSENTER_ESP,
 #ifdef CONFIG_X86_64
-	{ .index = MSR_GS_BASE,				.always = true  },
-	{ .index = MSR_FS_BASE,				.always = true  },
-	{ .index = MSR_KERNEL_GS_BASE,			.always = true  },
-	{ .index = MSR_LSTAR,				.always = true  },
-	{ .index = MSR_CSTAR,				.always = true  },
-	{ .index = MSR_SYSCALL_MASK,			.always = true  },
+	MSR_GS_BASE,
+	MSR_FS_BASE,
+	MSR_KERNEL_GS_BASE,
+	MSR_LSTAR,
+	MSR_CSTAR,
+	MSR_SYSCALL_MASK,
 #endif
-	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
-	{ .index = MSR_IA32_PRED_CMD,			.always = false },
-	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
-	{ .index = MSR_IA32_DEBUGCTLMSR,		.always = false },
-	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
-	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
-	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
-	{ .index = MSR_IA32_LASTINTTOIP,		.always = false },
-	{ .index = MSR_IA32_XSS,			.always = false },
-	{ .index = MSR_EFER,				.always = false },
-	{ .index = MSR_IA32_CR_PAT,			.always = false },
-	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = false },
-	{ .index = MSR_TSC_AUX,				.always = false },
-	{ .index = X2APIC_MSR(APIC_ID),			.always = false },
-	{ .index = X2APIC_MSR(APIC_LVR),		.always = false },
-	{ .index = X2APIC_MSR(APIC_TASKPRI),		.always = false },
-	{ .index = X2APIC_MSR(APIC_ARBPRI),		.always = false },
-	{ .index = X2APIC_MSR(APIC_PROCPRI),		.always = false },
-	{ .index = X2APIC_MSR(APIC_EOI),		.always = false },
-	{ .index = X2APIC_MSR(APIC_RRR),		.always = false },
-	{ .index = X2APIC_MSR(APIC_LDR),		.always = false },
-	{ .index = X2APIC_MSR(APIC_DFR),		.always = false },
-	{ .index = X2APIC_MSR(APIC_SPIV),		.always = false },
-	{ .index = X2APIC_MSR(APIC_ISR),		.always = false },
-	{ .index = X2APIC_MSR(APIC_TMR),		.always = false },
-	{ .index = X2APIC_MSR(APIC_IRR),		.always = false },
-	{ .index = X2APIC_MSR(APIC_ESR),		.always = false },
-	{ .index = X2APIC_MSR(APIC_ICR),		.always = false },
-	{ .index = X2APIC_MSR(APIC_ICR2),		.always = false },
+	MSR_IA32_SPEC_CTRL,
+	MSR_IA32_PRED_CMD,
+	MSR_IA32_FLUSH_CMD,
+	MSR_IA32_DEBUGCTLMSR,
+	MSR_IA32_LASTBRANCHFROMIP,
+	MSR_IA32_LASTBRANCHTOIP,
+	MSR_IA32_LASTINTFROMIP,
+	MSR_IA32_LASTINTTOIP,
+	MSR_IA32_XSS,
+	MSR_EFER,
+	MSR_IA32_CR_PAT,
+	MSR_AMD64_SEV_ES_GHCB,
+	MSR_TSC_AUX,
+	X2APIC_MSR(APIC_ID),
+	X2APIC_MSR(APIC_LVR),
+	X2APIC_MSR(APIC_TASKPRI),
+	X2APIC_MSR(APIC_ARBPRI),
+	X2APIC_MSR(APIC_PROCPRI),
+	X2APIC_MSR(APIC_EOI),
+	X2APIC_MSR(APIC_RRR),
+	X2APIC_MSR(APIC_LDR),
+	X2APIC_MSR(APIC_DFR),
+	X2APIC_MSR(APIC_SPIV),
+	X2APIC_MSR(APIC_ISR),
+	X2APIC_MSR(APIC_TMR),
+	X2APIC_MSR(APIC_IRR),
+	X2APIC_MSR(APIC_ESR),
+	X2APIC_MSR(APIC_ICR),
+	X2APIC_MSR(APIC_ICR2),
 
 	/*
 	 * Note:
@@ -134,15 +131,15 @@ static const struct svm_direct_access_msrs {
 	 * the AVIC hardware would generate GP fault. Therefore, always
 	 * intercept the MSR 0x832, and do not setup direct_access_msr.
 	 */
-	{ .index = X2APIC_MSR(APIC_LVTTHMR),		.always = false },
-	{ .index = X2APIC_MSR(APIC_LVTPC),		.always = false },
-	{ .index = X2APIC_MSR(APIC_LVT0),		.always = false },
-	{ .index = X2APIC_MSR(APIC_LVT1),		.always = false },
-	{ .index = X2APIC_MSR(APIC_LVTERR),		.always = false },
-	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
-	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
-	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
-	{ .index = MSR_INVALID,				.always = false },
+	X2APIC_MSR(APIC_LVTTHMR),
+	X2APIC_MSR(APIC_LVTPC),
+	X2APIC_MSR(APIC_LVT0),
+	X2APIC_MSR(APIC_LVT1),
+	X2APIC_MSR(APIC_LVTERR),
+	X2APIC_MSR(APIC_TMICT),
+	X2APIC_MSR(APIC_TMCCT),
+	X2APIC_MSR(APIC_TDCR),
+	MSR_INVALID,
 };
 
 /*
@@ -763,9 +760,10 @@ static int direct_access_msr_slot(u32 msr)
 {
 	u32 i;
 
-	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++)
-		if (direct_access_msrs[i].index == msr)
+	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
+		if (direct_access_msrs[i] == msr)
 			return i;
+	}
 
 	return -ENOENT;
 }
@@ -911,15 +909,17 @@ unsigned long *svm_vcpu_alloc_msrpm(void)
 
 void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, unsigned long *msrpm)
 {
-	int i;
-
-	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
-		if (!direct_access_msrs[i].always)
-			continue;
-		svm_disable_intercept_for_msr(vcpu, direct_access_msrs[i].index,
-					      MSR_TYPE_RW);
-	}
+	svm_disable_intercept_for_msr(vcpu, MSR_STAR, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
 
+#ifdef CONFIG_X86_64
+	svm_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_LSTAR, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_CSTAR, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_SYSCALL_MASK, MSR_TYPE_RW);
+#endif
 	if (sev_es_guest(vcpu->kvm))
 		svm_disable_intercept_for_msr(vcpu, MSR_AMD64_SEV_ES_GHCB, MSR_TYPE_RW);
 }
@@ -935,7 +935,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 		return;
 
 	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
-		int index = direct_access_msrs[i].index;
+		int index = direct_access_msrs[i];
 
 		if ((index < APIC_BASE_MSR) ||
 		    (index > APIC_BASE_MSR + 0xff))
@@ -965,8 +965,8 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 	 * refreshed since KVM is going to intercept them regardless of what
 	 * userspace wants.
 	 */
-	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
-		u32 msr = direct_access_msrs[i].index;
+	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
+		u32 msr = direct_access_msrs[i];
 
 		if (!test_bit(i, svm->shadow_msr_intercept.read))
 			svm_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_R);
@@ -1009,10 +1009,10 @@ static void init_msrpm_offsets(void)
 
 	memset(msrpm_offsets, 0xff, sizeof(msrpm_offsets));
 
-	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
+	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
 		u32 offset;
 
-		offset = svm_msrpm_offset(direct_access_msrs[i].index);
+		offset = svm_msrpm_offset(direct_access_msrs[i]);
 		BUG_ON(offset == MSR_INVALID);
 
 		add_msr_offset(offset);
-- 
2.47.0.338.g60cca15819-goog


