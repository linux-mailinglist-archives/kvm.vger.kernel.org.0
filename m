Return-Path: <kvm+bounces-48906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2E42AD4650
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C98161652D6
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C32260561;
	Tue, 10 Jun 2025 22:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UFJG4Hlu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F1D2E62A2
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596301; cv=none; b=ICdWNGdg7Kzx4BZjMeif3YhC6mXT+HcdRn/yrJ1jsN7yMgVg29J6m3uCafuhbh0T56FmZDwQcUIrZ/e1XMo0QgB5KYIRtKbRz+iS94hQOLhIq/L6fbbFCwosqkGvimwWFgADEn1+9WXOLtmttFyNXQA1Aq80GJWwSIpYZ/juaEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596301; c=relaxed/simple;
	bh=nUK0SeMAHpZWR9VEMLwQ2wHnXQVmswQ/I2nW72+0fj8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a2fmkcJbHsOGiIXbOAyzM+H+Eo7ahJP9bKxDqpiyEKO0ziDCSGI27IIzFw09HSfDH/ZY5gZN+6ONwAWrzMlPC+Ox497xRpQEn1Mh6dhD/2NNQqCKx70uctnf4S21DzRibldF3p48AhoZu0gX3HrpzjYs/A9bSaRVDbCO91LKI2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UFJG4Hlu; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235f6b829cfso42313565ad.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596298; x=1750201098; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ac+Cbfu6uBI7SW7IA1xemqMCAvuIHQqDioO25y7DkVY=;
        b=UFJG4HlupvmTJXPvl9ioUEXDcH3GsIgUJLhr437NCPT+WU+fMT8FLm8ZcWurur4xtd
         uG9Gc0YRWKGQa3vKhxAuJ188nNVyRUdrdBjh4iOpilByDBUC6N+wE8pYH+esH7csYfZf
         VGGCSTxQifI1UR/zwhIDeowd+ttcxKkzEEkdKXJ+TzykUwjXlGf1Kek5nwqy8W+BaHi4
         wv8X32KD5fzflPWJCnoIYZStwh0SpnkgvSm8JQfBPEsNaCfR3td8QSDXGK1h7ggNYTOr
         q0PpAv44Gy/AmDhRe5qrbv7fQijixligN/8s7CKQJuufHjndHTJSPqeDv4CndL8zW5W1
         QMSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596298; x=1750201098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ac+Cbfu6uBI7SW7IA1xemqMCAvuIHQqDioO25y7DkVY=;
        b=qyMclt9SvxotMlx2LETvOslyUu1kjekgvA5y8PxM8WCCuvvVOmycutLyKlx/lpa0Vt
         f17FZlVjHcky7MSv41VnwrwzshnX6NDVSBoVaPRtYxvUM+gP3OVKpd8Z3f1F/GwkpmC4
         ixQWFNo+9nc34BXsnuPlmzF/EcAtIjKRD5IB3w8/c/2XKjCX2+9ZH7I8zxmlcw/FlXKz
         sb2nQOzVnV5le78CyGY/TbAYcd6BzRSA69yzqZ+8CB2zd+fDoqYv6izbm2rmBt02yktB
         LDFXLm1bEKiUd+FAwU9hsVpFvJNJnYmoxWJs6jEAsdPjbie8Ew86E/eoqaoFCTUqjpbd
         0LhQ==
X-Gm-Message-State: AOJu0Yzsgn8te2q2SibI1h7OJAw7aaSpH+hfMRipt+AtAyj6Nv1pGIQt
	tk4okgIGtWOn7O3o3X4qqtV70Jba6PL+IobfXTkJUCFCN5t3sURwIwBdNs0l3oLG9EqrSvgAcA5
	U83F/Gw==
X-Google-Smtp-Source: AGHT+IFvfEiSl9bbSkg4PnNv9/YyrCUYvpHRFr097xwXo2xZysRVCZpLBkRJGDENwp9UGHQRHq010H7iJ0I=
X-Received: from pjl7.prod.google.com ([2002:a17:90b:2f87:b0:312:1dae:6bf0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1cf:b0:234:a139:11ec
 with SMTP id d9443c01a7336-2364260edadmr7589675ad.20.1749596298103; Tue, 10
 Jun 2025 15:58:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:27 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-23-seanjc@google.com>
Subject: [PATCH v2 22/32] KVM: SVM: Fold svm_vcpu_init_msrpm() into its sole caller
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Fold svm_vcpu_init_msrpm() into svm_recalc_msr_intercepts() now that there
is only the one caller (and because the "init" misnomer is even more
misleading than it was in the past).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1e3250ed2954..be2e6914e9d9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -779,21 +779,6 @@ static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
 		svm_set_intercept_for_msr(vcpu, MSR_IA32_DEBUGCTLMSR, MSR_TYPE_RW, intercept);
 }
 
-static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu)
-{
-	svm_disable_intercept_for_msr(vcpu, MSR_STAR, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
-
-#ifdef CONFIG_X86_64
-	svm_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_LSTAR, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_CSTAR, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_SYSCALL_MASK, MSR_TYPE_RW);
-#endif
-}
-
 void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 {
 	static const u32 x2avic_passthrough_msrs[] = {
@@ -852,7 +837,17 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm_vcpu_init_msrpm(vcpu);
+	svm_disable_intercept_for_msr(vcpu, MSR_STAR, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
+
+#ifdef CONFIG_X86_64
+	svm_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_LSTAR, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_CSTAR, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_SYSCALL_MASK, MSR_TYPE_RW);
+#endif
 
 	if (lbrv)
 		svm_recalc_lbr_msr_intercepts(vcpu);
-- 
2.50.0.rc0.642.g800a2b2222-goog


