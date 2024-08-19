Return-Path: <kvm+bounces-24486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 253D59563C5
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 08:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D0F81F22176
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 06:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BE115383C;
	Mon, 19 Aug 2024 06:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iZGmju57"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9882314B95A
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 06:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724048817; cv=none; b=lZ5plUl7kKMmhXLDQ6reCGXj1SgwPHsLi7SIyTMenQAZrcdkJNsQxnTwpR9tekw3SbUQ/cavm9o8x6ePXDnzcjxGFxWFQFeBgzBVmgZI2OhccfVHolIrAJdOEcri8jfQ5AYV/nx1lrd9JkLAsrOC880BEZNbyf2+xrogFwoDcjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724048817; c=relaxed/simple;
	bh=ZyC5YZQzxWPtWPLVFEv8t00OqJbj3jDVblF8B5YSo7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fskHv3Va4wKoOUclB6izNqi7hlQPqBNtsehUYrWWpEIUmJSN+9KIUDn+srNpLW/HCbi+xAXhe2IgKsy73+92S7YGDf4hhoaEZPJb66TxSrYFxH2gC65AyXtEcVsbc1CPw6U0rzYZ9YqmbQROGyf7366WAPp7B/Y0E9oEx1RG7Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iZGmju57; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724048816; x=1755584816;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZyC5YZQzxWPtWPLVFEv8t00OqJbj3jDVblF8B5YSo7Q=;
  b=iZGmju57bqWiV2FYSBYvMzac4J6sZrssusBWhZP5zBoPujcCs5TJNeAP
   ROGgJK7zUlfEExskrhGMfN9LdcYbo6cIyM4oPjMXimqdthmjP3sxBKrCV
   l9cPS/34UTAZZ+CfHx4vPXu1hkP1MsFK/Wmm+/YZLTekR9WAu1uc4ugq3
   QNkilcCtd2BPxDwaUaLlsLBM+ECMWZtjs2hltaEqOpitUiaSmltgMJdCj
   QZRmvWliK34kPDg5juaDn7rKs5hjV084ObnsWTpcRzPcByZHFuTFVHezk
   CWf72ufHsDLQP9GeheYuvuEn7S7mlQHinNE8jEii4duyG+xEHiik3WC7Y
   g==;
X-CSE-ConnectionGUID: B7/zXhhiRfqZFHtWs1/dWA==
X-CSE-MsgGUID: 54Y0pQvrR4GYyEKQNn03qw==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="32901854"
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="32901854"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2024 23:26:55 -0700
X-CSE-ConnectionGUID: z7468B5yT2K0l24wD6hi7A==
X-CSE-MsgGUID: LhZ8CN99TpSlY9Yqg4EI1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="65104775"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by orviesa003.jf.intel.com with ESMTP; 18 Aug 2024 23:26:53 -0700
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH v3] KVM: x86: Advertise AVX10.1 CPUID to userspace
Date: Mon, 19 Aug 2024 14:23:27 +0800
Message-Id: <20240819062327.3269720-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Advertise AVX10.1 related CPUIDs, i.e. report AVX10 support bit via
CPUID.(EAX=07H, ECX=01H):EDX[bit 19] and new CPUID leaf 0x24H so that
guest OS and applications can query the AVX10.1 CPUIDs directly. Intel
AVX10 represents the first major new vector ISA since the introduction of
Intel AVX512, which will establish a common, converged vector instruction
set across all Intel architectures[1].

AVX10.1 is an early version of AVX10, that enumerates the Intel AVX512
instruction set at 128, 256, and 512 bits which is enabled on
Granite Rapids. I.e., AVX10.1 is only a new CPUID enumeration with no
VMX capability, Embedded rounding and Suppress All Exceptions (SAE),
which will be introduced in AVX10.2.

Advertising AVX10.1 is safe because there is nothing to enable for AVX10.1,
i.e. it's purely a new way to enumerate support, thus there will never be
anything for the kernel to enable. Note just the CPUID checking is changed
when using AVX512 related instructions, e.g. if using one AVX512
instruction needs to check (AVX512 AND AVX512DQ), it can check
((AVX512 AND AVX512DQ) OR AVX10.1) after checking XCR0[7:5].

The versions of AVX10 are expected to be inclusive, e.g. version N+1 is
a superset of version N. Per the spec, the version can never be 0, just
advertise AVX10.1 if it's supported in hardware. Moreover, advertising
AVX10_{128,256,512} needs to land in this patch because otherwise KVM
would advertise an impossible CPU model, e.g. with AVX512 but not
AVX10.1/512, which per spec should be impossible.

As more and more AVX related CPUIDs are added (it would have resulted in
around 40-50 CPUID flags when developing AVX10), the versioning approach
is introduced. But incrementing version numbers are bad for virtualization.
E.g. if AVX10.2 has a feature that shouldn't be enumerated to guests for
whatever reason, then KVM can't enumerate any "later" features either,
because the only way to hide the problematic AVX10.2 feature is to set the
version to AVX10.1 or lower[2]. But most AVX features are just passed
through and don't have virtualization controls, so AVX10 should not be
problematic in practice.

[1] https://cdrdv2.intel.com/v1/dl/getContent/784267
[2] https://lore.kernel.org/all/Zkz5Ak0PQlAN8DxK@google.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
Changelog:
v2 -> v3:
 - Call out advertising AVX10_{128,256,512} needs to land in the same patch.
 - Introduce avx10_version and min_t for the upcoming AVX10.2.
 - Add Sean's Suggested-by.

v2: https://lore.kernel.org/all/20240603064002.266116-1-tao1.su@linux.intel.com/

v1: https://lore.kernel.org/all/20240520022002.1494056-1-tao1.su@linux.intel.com/
---
 arch/x86/include/asm/cpuid.h |  1 +
 arch/x86/kvm/cpuid.c         | 30 ++++++++++++++++++++++++++++--
 arch/x86/kvm/reverse_cpuid.h |  8 ++++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpuid.h b/arch/x86/include/asm/cpuid.h
index 6b122a31da06..aa21c105eef1 100644
--- a/arch/x86/include/asm/cpuid.h
+++ b/arch/x86/include/asm/cpuid.h
@@ -179,6 +179,7 @@ static __always_inline bool cpuid_function_is_indexed(u32 function)
 	case 0x1d:
 	case 0x1e:
 	case 0x1f:
+	case 0x24:
 	case 0x8000001d:
 		return true;
 	}
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2617be544480..41786b834b16 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -705,7 +705,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
 		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
-		F(AMX_COMPLEX)
+		F(AMX_COMPLEX) | F(AVX10)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
@@ -721,6 +721,10 @@ void kvm_set_cpu_caps(void)
 		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
 	);
 
+	kvm_cpu_cap_init_kvm_defined(CPUID_24_0_EBX,
+		F(AVX10_128) | F(AVX10_256) | F(AVX10_512)
+	);
+
 	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
 		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
@@ -949,7 +953,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	switch (function) {
 	case 0:
 		/* Limited to the highest leaf implemented in KVM. */
-		entry->eax = min(entry->eax, 0x1fU);
+		entry->eax = min(entry->eax, 0x24U);
 		break;
 	case 1:
 		cpuid_entry_override(entry, CPUID_1_EDX);
@@ -1174,6 +1178,28 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			break;
 		}
 		break;
+	case 0x24: {
+		u8 avx10_version;
+
+		if (!kvm_cpu_cap_has(X86_FEATURE_AVX10)) {
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
+
+		/*
+		 * The AVX10 version is encoded in EBX[7:0].  Note, the version
+		 * is guaranteed to be >=1 if AVX10 is supported.  Note #2, the
+		 * version needs to be captured before overriding EBX features!
+		 */
+		avx10_version = min_t(u8, entry->ebx & 0xff, 1);
+		cpuid_entry_override(entry, CPUID_24_0_EBX);
+		entry->ebx |= avx10_version;
+
+		entry->eax = 0;
+		entry->ecx = 0;
+		entry->edx = 0;
+		break;
+	}
 	case KVM_CPUID_SIGNATURE: {
 		const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
 		entry->eax = KVM_CPUID_FEATURES;
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 2f4e155080ba..0d17d6b70639 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -17,6 +17,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_8000_0007_EDX,
 	CPUID_8000_0022_EAX,
 	CPUID_7_2_EDX,
+	CPUID_24_0_EBX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -46,6 +47,7 @@ enum kvm_only_cpuid_leafs {
 #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
 #define X86_FEATURE_AMX_COMPLEX         KVM_X86_FEATURE(CPUID_7_1_EDX, 8)
 #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
+#define X86_FEATURE_AVX10               KVM_X86_FEATURE(CPUID_7_1_EDX, 19)
 
 /* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX) */
 #define X86_FEATURE_INTEL_PSFD		KVM_X86_FEATURE(CPUID_7_2_EDX, 0)
@@ -55,6 +57,11 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_BHI_CTRL	KVM_X86_FEATURE(CPUID_7_2_EDX, 4)
 #define X86_FEATURE_MCDT_NO		KVM_X86_FEATURE(CPUID_7_2_EDX, 5)
 
+/* Intel-defined sub-features, CPUID level 0x00000024:0 (EBX) */
+#define X86_FEATURE_AVX10_128		KVM_X86_FEATURE(CPUID_24_0_EBX, 16)
+#define X86_FEATURE_AVX10_256		KVM_X86_FEATURE(CPUID_24_0_EBX, 17)
+#define X86_FEATURE_AVX10_512		KVM_X86_FEATURE(CPUID_24_0_EBX, 18)
+
 /* CPUID level 0x80000007 (EDX). */
 #define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
 
@@ -90,6 +97,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
 	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
+	[CPUID_24_0_EBX]      = {      0x24, 0, CPUID_EBX},
 };
 
 /*

base-commit: 47ac09b91befbb6a235ab620c32af719f8208399
-- 
2.34.1


