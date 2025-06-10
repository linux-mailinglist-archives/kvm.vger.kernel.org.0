Return-Path: <kvm+bounces-48900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60652AD4648
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:01:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10E65168438
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8DB52D8DCC;
	Tue, 10 Jun 2025 22:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O1YpCqGJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6485F2D4B5B
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596290; cv=none; b=ll01ULK+2ZD1H8lxlzWrtxaiKjfInKgwtRnTyviDumFGi/rFFcfIC/cr3dY0V5b7F9JTdo8jk75IRY6UcUBUAZiQIysPwga8rrJaKmwPmNWmvRVr0kZrnLQuO5Xa5dXQmn9drSDHrGtehlJ5xt1IdOV8Ya+eVyhf+5Ij5pKQx14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596290; c=relaxed/simple;
	bh=wYLpwmDtesBuFCExIUc711ksu3V78L4qfQX7Br6OoLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I7fTXY75Q+gg3VkeIP4U3v5g9klLtotlZTooHx0j9AaDOav8IVhsJ3aepnXF2UVtVTa7rkFPNa7K7k9d8uHtK4QXXYCj4eg8ulvScj1AUULdyTRYYCvl2aduhyh7PTkH9uzECYyZT7Sjg08qtDZYiudh423nztk1hdCdTbO0JJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O1YpCqGJ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26e73d375aso6679854a12.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596288; x=1750201088; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RDL4hQFiK+ASur5aaDJFnTccNINaia2n1YWKrBZy1is=;
        b=O1YpCqGJZF8U2kMl7qN3o8NCxfw2P7SK11mPObWiJu9Ydileuuutr7RoBoNZxMYqsV
         SnnDxjhJRuqucoaZnmJ6xZhl8rEhhK4ZKBAdy1FA9HxW+IuO+X7xHPsDW85hHMC9Ei+A
         KqXh0KBd+FAwY7TYKKLwniMQ0akCR0ZindIFGXCSDneU7dO1kMNb2F0lQJsdfbJfNrX7
         uxyTCAGNfBIdGBYBcZ0XxFIdZFbeyUnsQfTjDiJdbdU8qNe3BFMseQkJarcWqBHrksHW
         9KILVPhqV3XvZp12Y2s8N02k3kIWJ8hqywakAWzvSAGl9xD5qMKhXXOWqTJDImiQHk9m
         edpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596288; x=1750201088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RDL4hQFiK+ASur5aaDJFnTccNINaia2n1YWKrBZy1is=;
        b=AMTVTYA2N3gU5FLXxWVlGCTMzlPkQ0ph/Ri8MclO1OerXukpXYWmmpLCiTjH1bniMA
         GzR5boRxFemI0437IBv/OCYrZNre6OFJWdlTA6q3m6FCqAJPJsoKakLb0ZXGYn5LNzAY
         hu9SULzf7KfVBPU6OiMDYT3T1uveu6c86PsBmEdoKWMc28ld4YPcctWzh7WsDFydpGzZ
         iv2XGZaFYDyJbZ+Juq5phkvYAU06iqPYfFgJ2srz3PqbqcSVarBZ1vr8nLNAk7qM5W0H
         odL5nCMCqWa6k+0uPwURCAegGn8z13zbERqHjayuHrevG3P00vs6tr4MZyeMpKnCOBYg
         lsxQ==
X-Gm-Message-State: AOJu0YziPojglgtOnqPI5izqGoKkE0ZP/l6H0d08gT+28hxp5sQGwgsV
	+tnBAEBCHyt81FzO48KSi79zgpar6mMDtnYsXb02m3nk+oZOPV7AGviFlU+VYqHXbm+2NdPf8CZ
	Lq2LmCg==
X-Google-Smtp-Source: AGHT+IHZ/g6IkvQh+wtJNRTX/Z8bV3lPAyMKeTBSbjFw/87pPVIOdLl4wFCVuUsULL6TbhyNjR2oIf8cVRQ=
X-Received: from pfsq11.prod.google.com ([2002:a05:6a00:2ab:b0:73b:bbec:17e9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:244b:b0:1f5:9175:2596
 with SMTP id adf61e73a8af0-21f88feb7camr766854637.13.1749596287890; Tue, 10
 Jun 2025 15:58:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:21 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-17-seanjc@google.com>
Subject: [PATCH v2 16/32] KVM: SVM: Drop "always" flag from list of possible
 passthrough MSRs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Drop the "always" flag from the array of possible passthrough MSRs, and
instead manually initialize the permissions for the handful of MSRs that
KVM passes through by default.  In addition to cutting down on boilerplate
copy+paste code and eliminating a misleading flag (the MSRs aren't always
passed through, e.g. thanks to MSR filters), this will allow for removing
the direct_access_msrs array entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 124 ++++++++++++++++++++---------------------
 1 file changed, 62 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7747f9bc3e9d..4ee92e444dde 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -83,51 +83,48 @@ static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
 #define X2APIC_MSR(x)	(APIC_BASE_MSR + (x >> 4))
 
-static const struct svm_direct_access_msrs {
-	u32 index;   /* Index of the MSR */
-	bool always; /* True if intercept is initially cleared */
-} direct_access_msrs[] = {
-	{ .index = MSR_STAR,				.always = true  },
-	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
-	{ .index = MSR_IA32_SYSENTER_EIP,		.always = false },
-	{ .index = MSR_IA32_SYSENTER_ESP,		.always = false },
+static const u32 direct_access_msrs[] = {
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
@@ -136,14 +133,14 @@ static const struct svm_direct_access_msrs {
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
+	X2APIC_MSR(APIC_LVTTHMR),
+	X2APIC_MSR(APIC_LVTPC),
+	X2APIC_MSR(APIC_LVT0),
+	X2APIC_MSR(APIC_LVT1),
+	X2APIC_MSR(APIC_LVTERR),
+	X2APIC_MSR(APIC_TMICT),
+	X2APIC_MSR(APIC_TMCCT),
+	X2APIC_MSR(APIC_TDCR),
 };
 
 static_assert(ARRAY_SIZE(direct_access_msrs) ==
@@ -767,7 +764,7 @@ static int direct_access_msr_slot(u32 msr)
 	u32 i;
 
 	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
-		if (direct_access_msrs[i].index == msr)
+		if (direct_access_msrs[i] == msr)
 			return i;
 	}
 
@@ -931,14 +928,17 @@ u32 *svm_vcpu_alloc_msrpm(void)
 
 static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu)
 {
-	int i;
+	svm_disable_intercept_for_msr(vcpu, MSR_STAR, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
 
-	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
-		if (!direct_access_msrs[i].always)
-			continue;
-		svm_disable_intercept_for_msr(vcpu, direct_access_msrs[i].index,
-					      MSR_TYPE_RW);
-	}
+#ifdef CONFIG_X86_64
+	svm_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_LSTAR, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_CSTAR, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_SYSCALL_MASK, MSR_TYPE_RW);
+#endif
 }
 
 void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
@@ -952,7 +952,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
-		int index = direct_access_msrs[i].index;
+		int index = direct_access_msrs[i];
 
 		if ((index < APIC_BASE_MSR) ||
 		    (index > APIC_BASE_MSR + 0xff))
@@ -980,7 +980,7 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 	 * back in sync after this.
 	 */
 	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
-		u32 msr = direct_access_msrs[i].index;
+		u32 msr = direct_access_msrs[i];
 		u32 read = test_bit(i, svm->shadow_msr_intercept.read);
 		u32 write = test_bit(i, svm->shadow_msr_intercept.write);
 
@@ -1020,7 +1020,7 @@ static __init int init_msrpm_offsets(void)
 	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
 		u32 offset;
 
-		offset = svm_msrpm_offset(direct_access_msrs[i].index);
+		offset = svm_msrpm_offset(direct_access_msrs[i]);
 		if (WARN_ON(offset == MSR_INVALID))
 			return -EIO;
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


