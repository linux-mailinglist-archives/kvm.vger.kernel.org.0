Return-Path: <kvm+bounces-53740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 682EFB165C3
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 19:47:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D2E73B0D64
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 17:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6484C2E1730;
	Wed, 30 Jul 2025 17:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="hwNAxNs6"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079BA1D61BC;
	Wed, 30 Jul 2025 17:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753897627; cv=none; b=SxUo+dC3nQrrZYKZg5udPKKfEJItSDS3OtAm4gtYIZILbvcl2EL6YR7t1q35zEFMM2JXCJV7IF/sPvI2Fu9NdFuZDLKu/orpSkT3+PNJLBTyrqa8FCXLMcqoA79UWG7x4/fjo9CV1Jzydiv87Lzy8eyfyFdKWrrRYHC+xpQWUYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753897627; c=relaxed/simple;
	bh=aaJMFoE37sgh+wzwzWl7WM582mW1fTk3P3KpLRSZlUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7o2j+Nfr87PNNWLP9ZcQq22+ZrxIOhxCMFzPcJCc2O3Q/+LbvnioqFeTO+CtZzlkRLnu4eYCzEEbtVVZGt6En5sbKqxxug4RjgbGOZmruQNFm0j/BNQ1ycK/1Af+q2YYY3XTp04MlRAVYOewT6HCGpP7KNQH530TKpvSnac2Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=hwNAxNs6; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56UHk6nC1614815
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 30 Jul 2025 10:46:32 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56UHk6nC1614815
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753897593;
	bh=eHxfJAy9AKvLAEmlOqmd8PluQcEtX+QucQ1qvOJZ5Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwNAxNs6zzacAi8vw8nrlsL0988mIY3QNmkVk/vW131nWyQNbzzgIYXazB65qhIqZ
	 3z4Ol83WiBzpyRH9n0Ndpzu+dQsV5cXUYYDzXZss1jxqN+fXsLtoX/ywxR/geKahNx
	 pbaFXxGKWCEtzTDO8r9+bfh3ETI6SdrMdh4VxVYAHwFWaSMByQTIzzja8cumCs/BB1
	 fLiu2rNqMfgaeo9c0szkkyUMWuTYcih+G8YzGfkpH9JTWlF+MwuDgZ9LKQDRT4RRhg
	 cUHKz+gOnTCw0cj58pe1+mRwiUAn1u+PmJCcYI+mIgIXBA+veK8CwSwdZjX2Jt4/uZ
	 9T2KqCEJVrT3g==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, chao.gao@intel.com
Subject: [PATCH v1 4/4] KVM: x86: Advertise support for the immediate form of MSR instructions
Date: Wed, 30 Jul 2025 10:46:05 -0700
Message-ID: <20250730174605.1614792-5-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730174605.1614792-1-xin@zytor.com>
References: <20250730174605.1614792-1-xin@zytor.com>
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

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/cpuid.c            | 6 +++++-
 arch/x86/kvm/reverse_cpuid.h    | 5 +++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8d85efd47b6..9ca7ec17c1c5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -772,6 +772,7 @@ enum kvm_only_cpuid_leafs {
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
-- 
2.50.1


