Return-Path: <kvm+bounces-48056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA97AC853D
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26014A4339E
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99755268FDC;
	Thu, 29 May 2025 23:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LEO4PJKo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E220267B9F
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562053; cv=none; b=RLq7Fz+tqfasz/WhH6WpflAnwxCRFTWApNDttlb6BZ3TbW4uRF94Qz9kEaqoizRQrhFr80vqJQ3+V33VM1MIhY6q7Hq7ttKqTVJLGrIqiauopSCuXscMlZpgbdGVs/ivtP3Mc0nbAeGvIV4rMh1FM01OW+R05z4Fh82nIl7F6wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562053; c=relaxed/simple;
	bh=NMpozlc+ss875qK0wUIqjUpEbG1y7oMO4uIXzZ+fxbw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=soiPt0WCCEpnaeUFRgWdosN8Unwy5R8HI9itYKpX2MiFqZuoJdjPs6ROCnI2Vw9ga9wXNaDcyYwCzC3IbCVeHq5dLGXmb/XDkfS6LjUmhsomhDuVjb6Yv7st+3x7IbbeLDVO56jjtDGPIFUNO4Bm/juK/7J/+iWQg0afhaPvyHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LEO4PJKo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3119ba092aeso2166858a91.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562051; x=1749166851; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3U6kOnBx1q2vhTYY8N27dofDiZJr3M0o4KlDwfSt6+A=;
        b=LEO4PJKo3vcOVVPly/IqjjQL88b59QSvaVcKngV7J8caai7iW/fkJ2GvguAMqHykQs
         qq3KuvGcSCu8LoiStRU0/+OoJmJj7K5oSplc7jYXRp/WA0nlwV8Twh8kC5oXrSFsy1wt
         UoZO2g5aBagJvpjt+xWyMqlFIMNPwf1y13W2/SkL2hMl+bf7TX+T1g5GlQgGzc/txVW5
         +QS+Zkn39BnS2DrOe9KepkjyKoo5xbN6xswx+6R+Q4F0IdF2maKkBilG1QvYUMsdWNyb
         Vhm1MH9U4BNNqvVxmKi/wHQmyiMeiaIr+5yoyq2be8v8qiL/FNmlOnN+Dtfd9fSnCUTa
         PYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562051; x=1749166851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3U6kOnBx1q2vhTYY8N27dofDiZJr3M0o4KlDwfSt6+A=;
        b=iuJOrUOQVLX3vOW4ImnlDiSiKvzD1zza96wBj6VgXdGXsrX6aciu2EgYaWA5WuyU+r
         nrz692uQXTLGcxq0X5nYEZ500DWrxJ5cQ8XmBiJ29RH/Vl0QwymaE6s/yBWIAheUfN1e
         Vxub04THASrhtTY2LRsd8XBox5Nq8yPJDG3hl48urY5pSRPaoSoqGBn2VodctuSON6T5
         qxhpw9luhtr2tXOLz1Oo1VvgMOzOO+7McXJS18xuKcaalqr6BcfnpV0ddWCWjkwiOzE7
         JYn8joC4/o+MVYST7leofteQz1zf/MnUw/3w0m1YoOcMMHaEOvS1YcuP/B5GI+Z/eCc9
         wAwA==
X-Gm-Message-State: AOJu0YxxYuNarbKsrPWcyQwFYe4URbfD3x4D4E97Q6E3dJiLbpXYXiDM
	rjzDxVfrePruJNFP1CUABvDT8EX7WTA/I54oU9TA66m6JXEq2oZlJg+J+YR0v1KNgW2nFyFjw/1
	HjehcIQ==
X-Google-Smtp-Source: AGHT+IFOI3AcdrOSreQhGPi1kh2avodZ537x4ilDYyYFqVyh9QPEJSmEBTDx34aDzyQtf/NUW2PW7hmhSdc=
X-Received: from pjbss4.prod.google.com ([2002:a17:90b:2ec4:b0:311:2058:21e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5448:b0:311:f05b:869a
 with SMTP id 98e67ed59e1d1-312415334f2mr1913449a91.8.1748562051548; Thu, 29
 May 2025 16:40:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:40:05 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-21-seanjc@google.com>
Subject: [PATCH 20/28] KVM: SVM: Fold svm_vcpu_init_msrpm() into its sole caller
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
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
index bbd1d89d9a3b..12fbfbf9acad 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -787,21 +787,6 @@ static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
 
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
@@ -860,7 +845,17 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
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
2.49.0.1204.g71687c7c1d-goog


