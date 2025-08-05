Return-Path: <kvm+bounces-54060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F62AB1BB62
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 22:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1909B628085
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 20:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0738129C33F;
	Tue,  5 Aug 2025 20:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M2GxXJ5B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B8D29B777
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 20:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754425361; cv=none; b=g8BMALX+5x6U124Hd27mK+E8NRV5Pbwsnh/0VPoajR0EkrHFDXe9rhOsCtiTggSOlz63G5qwt4R7aEXf77GTnw2oJK8akWZCKyuW37FXmqxi9FebhUDquqm4TqxAOp+m30fLDjtAi0wsat8Ez5h8/YvZNou9XCjv3zm98spDbEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754425361; c=relaxed/simple;
	bh=/74tP/uL8VD1igiEhMrK02lCdVn9JNfbzbe9m1VzDeE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HL7J/dXhw/2vtVWgiWrQeRAKPKNAbZlcKRX7zSdRcqt/LGyd0R52SBNHgy+o/sFF7uI4Vf46qwnCnKyv8w4Bzr4GRG90giaGIf1zGQbFSNPqINMFUG7kxj0QEa0xp8Ljxhw24/0QJd2g3KAAAb5AQMhHmGLkWfDvXYo2VyuCmng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M2GxXJ5B; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31ea14cc097so4977021a91.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 13:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754425359; x=1755030159; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1f+f9oC1bVjCd62ipVbDNWs3Q33jM/p7vFWYLjp/MqM=;
        b=M2GxXJ5Bgk3HSyR9FnJ4qJyry6N57mFGMFH4T+oAPL/m97oS88kqB0XC4ENo4DEtNg
         Ht0E8P5Aer7acJ0DwDRaVaKI7M+3Z4+akgsR6uqw3Qe4pPtALS/VZ4c458DmYx6LeLe3
         QHi50Om5W6Xt0zmIDH4Vdilz7DeR6DzhJidDD8R3gzMHi2p91cRPXJcIf/GA4RYaYlZD
         2RhROFJ85sEhvGRN9FCgDiGzZg7XTbrC+ZNiVXIXO8kMn15ApgkhutobA08WYoRJevPC
         iILhtEQJCypodI/kdDm+xy5Ws6JlcYFklrCmM8PuraLD+LolaHx7u70utMRk1nAEHuQO
         U75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754425359; x=1755030159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1f+f9oC1bVjCd62ipVbDNWs3Q33jM/p7vFWYLjp/MqM=;
        b=BNkVQskejY26GzFCUK80vRlWFBQNdLpJUbEiy6kWBnzJI3x08jFBFh6PwsuVtWd4BE
         HeIOrbVLbelWk4DgbDYvjPLXCgyLeDVl+EF8xyKQqlYNcf+FKI9n88E8nK/C998i1uz/
         hEVzVPKAInC9lxfo0oJPYAJDWI3Zpf5kJsexVcB1QepZ9L+4J4oQ41JNleBycoj19Akb
         pBtPPo0FRIYxlfWsIDg9ORfwoQCtSOfvsFs/wEwLLi4eblINGSc0rdCFPLesswksDtza
         /I4MRZLwNA7I7RciVhe5cMM6ege1P7CSsXOxxIYf0pv2bn8Rf7w6ooOFrPeJfjtdbFiF
         Brug==
X-Gm-Message-State: AOJu0YzkDjeY6orohRHrNso/Z2s+LFhUb35UvU3YDcmzQhL9x11Y4xtL
	hoZnvIFnvtXmCb52nzZ5B7RiZ5mjaCNvusuzpAeQ5om9S0kGP3oeIiwTIsnRg0D75fEBUG0NdGV
	iAOAoGw==
X-Google-Smtp-Source: AGHT+IGSm11toOjPwvtC633w4IWObqyBZzDlcAWaJmjXYtr4+m7SO4dsAZJxrRV/oUi4bYeNSpO/Jtzrkyw=
X-Received: from pjbkl16.prod.google.com ([2002:a17:90b:4990:b0:311:c20d:676d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ac1:b0:31e:cb27:9de4
 with SMTP id 98e67ed59e1d1-32166cb2fb2mr191994a91.24.1754425359238; Tue, 05
 Aug 2025 13:22:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 13:22:24 -0700
In-Reply-To: <20250805202224.1475590-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805202224.1475590-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805202224.1475590-7-seanjc@google.com>
Subject: [PATCH v3 6/6] KVM: x86: Advertise support for the immediate form of
 MSR instructions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin@zytor.com>

Advertise support for the immediate form of MSR instructions to userspace
if the instructions are supported by the underlying CPU, and KVM is using
VMX, i.e. is running on an Intel-compatible CPU.

For SVM, explicitly clear X86_FEATURE_MSR_IMM to ensure KVM doesn't over-
report support if AMD-compatible CPUs ever implement the immediate forms,
as SVM will likely require explicit enablement in KVM.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/cpuid.c            | 6 +++++-
 arch/x86/kvm/reverse_cpuid.h    | 5 +++++
 arch/x86/kvm/svm/svm.c          | 6 +++++-
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dbdec6025fde..735b5d1e62dd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -774,6 +774,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_7_2_EDX,
 	CPUID_24_0_EBX,
 	CPUID_8000_0021_ECX,
+	CPUID_7_1_ECX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e2836a255b16..eaaa9203d4d9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -985,6 +985,10 @@ void kvm_set_cpu_caps(void)
 		F(LAM),
 	);
 
+	kvm_cpu_cap_init(CPUID_7_1_ECX,
+		SCATTERED_F(MSR_IMM),
+	);
+
 	kvm_cpu_cap_init(CPUID_7_1_EDX,
 		F(AVX_VNNI_INT8),
 		F(AVX_NE_CONVERT),
@@ -1411,9 +1415,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 				goto out;
 
 			cpuid_entry_override(entry, CPUID_7_1_EAX);
+			cpuid_entry_override(entry, CPUID_7_1_ECX);
 			cpuid_entry_override(entry, CPUID_7_1_EDX);
 			entry->ebx = 0;
-			entry->ecx = 0;
 		}
 		if (max_idx >= 2) {
 			entry = do_host_cpuid(array, function, 2);
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index c53b92379e6e..743ab25ba787 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -25,6 +25,9 @@
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 #define KVM_X86_FEATURE_SGX_EDECCSSA	KVM_X86_FEATURE(CPUID_12_EAX, 11)
 
+/* Intel-defined sub-features, CPUID level 0x00000007:1 (ECX) */
+#define KVM_X86_FEATURE_MSR_IMM		KVM_X86_FEATURE(CPUID_7_1_ECX, 5)
+
 /* Intel-defined sub-features, CPUID level 0x00000007:1 (EDX) */
 #define X86_FEATURE_AVX_VNNI_INT8       KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
 #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
@@ -87,6 +90,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
 	[CPUID_24_0_EBX]      = {      0x24, 0, CPUID_EBX},
 	[CPUID_8000_0021_ECX] = {0x80000021, 0, CPUID_ECX},
+	[CPUID_7_1_ECX]       = {         7, 1, CPUID_ECX},
 };
 
 /*
@@ -128,6 +132,7 @@ static __always_inline u32 __feature_translate(int x86_feature)
 	KVM_X86_TRANSLATE_FEATURE(BHI_CTRL);
 	KVM_X86_TRANSLATE_FEATURE(TSA_SQ_NO);
 	KVM_X86_TRANSLATE_FEATURE(TSA_L1_NO);
+	KVM_X86_TRANSLATE_FEATURE(MSR_IMM);
 	default:
 		return x86_feature;
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca550c4fa174..7e7821ee8ee1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5311,8 +5311,12 @@ static __init void svm_set_cpu_caps(void)
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
 
-	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
+	/*
+	 * Clear capabilities that are automatically configured by common code,
+	 * but that require explicit SVM support (that isn't yet implemented).
+	 */
 	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
+	kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
 }
 
 static __init int svm_hardware_setup(void)
-- 
2.50.1.565.gc32cd1483b-goog


