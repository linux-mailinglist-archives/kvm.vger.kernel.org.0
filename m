Return-Path: <kvm+bounces-53867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D01B189D6
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 02:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 783253A590C
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 00:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CFBB1534EC;
	Sat,  2 Aug 2025 00:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="hV4sIAdy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6C8AD5A;
	Sat,  2 Aug 2025 00:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754093767; cv=none; b=Xy5mnjQ+RDnMs7o0Vo2BJTkVsQIOZDOtWTrrqKaLUMhnZ2wuFU0AbwkDs6hPPBnKV4gtqQRy/JG4XrqLYZWExn+kaMo+cdxLg+jk8ponrmrWazlbVMMSrPkTGcmpSxRTdWMRpzfXZg86Vx/ePv4innfKa/KpJp6lPec/7kGPsfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754093767; c=relaxed/simple;
	bh=m4mv9f3JoJDnlvqdbJAJf2RS/nXE7O/g/4cLPilXESQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFzYWWpnJoSC83Ot2/XROVDR7CK1m5UCwI9avm/2bvw2QAGs0Alb2t4yJb06S7un/DHEHkqxa57rTlejb+0FssugTb7ORdTUkScpE2NqwQVR00XED4J51h/SAFYE6sb1mHs2bXpAZsbjQVqBZYGGlifD+Nf4ZdsD8fg1DnWEUzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=hV4sIAdy; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5720FKpJ3142596
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 1 Aug 2025 17:15:30 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5720FKpJ3142596
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1754093730;
	bh=EwOm5ekFj/uGCcPOwfD3nwFQMgDOLAgJ2zHWQhQh4jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hV4sIAdybuo8GZYSsFU0MlcVLOEivweake7C7rxCmJO1UgioiLmFfDgrDK8ldCs7t
	 nXKOrIha/+lnIigXHhlSpg1cErOyX8SFIFWZNiTkzxIh0AkgYIubpxKkeAeeNTcxJ1
	 Ez1pRPMWOXfhmooCJ8TuXkGeVfCl/OTP4zWaKRH6W98TqDe3+C+yP2JXztp3y4Ubta
	 qBrMjWnboeqzu0fEg6m/IKD/CrahLqd/19VHiPjB71O1ihSrFbWyWtNyDOM6Qx7aho
	 k1/t3RRbPm1Io9Sa7XxVrDI4px0B7ErXf7SeHCJmytcU/GKLnGYAhJeI2p5jAtiyK0
	 offhogwa9EEjg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, chao.gao@intel.com
Subject: [PATCH v2 4/4] KVM: x86: Advertise support for the immediate form of MSR instructions
Date: Fri,  1 Aug 2025 17:15:20 -0700
Message-ID: <20250802001520.3142577-5-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250802001520.3142577-1-xin@zytor.com>
References: <20250802001520.3142577-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Advertise support for the immediate form of MSR instructions to userspace
if the instructions are supported by the underlying CPU.

The immediate form of MSR access instructions are primarily motivated
by performance, not code size: by having the MSR number in an immediate,
it is available *much* earlier in the pipeline, which allows the
hardware much more leeway about how a particular MSR is handled.

Explicitly clear the capability in SVM, as its handling is only added for
VMX.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---

Change in v2:
*) Cleared the capability in SVM (Sean).
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/cpuid.c            | 6 +++++-
 arch/x86/kvm/reverse_cpuid.h    | 5 +++++
 arch/x86/kvm/svm/svm.c          | 6 +++++-
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c5d0082cf0a5..2a7d0dcc1d70 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -771,6 +771,7 @@ enum kvm_only_cpuid_leafs {
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
index 4abc34b7c2c7..57bcd92125a3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5301,8 +5301,12 @@ static __init void svm_set_cpu_caps(void)
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
2.50.1


