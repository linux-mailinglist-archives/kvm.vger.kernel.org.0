Return-Path: <kvm+bounces-18597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4C488D7BD1
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 08:43:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70D81282397
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 06:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3E138DF9;
	Mon,  3 Jun 2024 06:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i87x0iIX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A7B2942A
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 06:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717396918; cv=none; b=mgxsZrpayXHYA0vZ0iUxTchHN6F460BgY9QUn4m57lHRRlohkNYjFAnxPOGbZno/kHlIrTkkuuuECy8P3JFHEQWe++z9ZG+/8XdRhGa0BM70ZQ8rAYg5tdQBa9g5/o6cFCxWMicwTPsN/wk8WDsxNQEpNTrqHrFjmsKCq1e3CdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717396918; c=relaxed/simple;
	bh=cPYvHVW9vmAhPZl/2mWovZH34s4ezLVnYM8VYmx3Pcc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=iM0y5LdYpGfjGnS7mRFZ86YqGrjnViSGXB3pstUHshe8cNvOF6u3gTOOWh4QCkl4uygXEVlKEc5X2K8YRnNLA9SABNnkCZ7GivHh4LC0eomrQbsXbF306zFct7M6xM1XGtj21Bhzg68HyiAZIdfo7QE4MFKCUfIwZ1enTzyURuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i87x0iIX; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717396917; x=1748932917;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cPYvHVW9vmAhPZl/2mWovZH34s4ezLVnYM8VYmx3Pcc=;
  b=i87x0iIXxvVQYbuZ83AHrTDC81yrJbCjaqe8+gI6d1SC2svgTnrqteUk
   IGto8OzDwPYzQHgbduPhiPfTS+pva1oM63Efes9Gnfcnqo9YUko0NUmgo
   fWhCFeeGyFHAf2ZxiXQwdQHo5DyC9ZxU+HEWaIYjI/PiO5z1bwjymaGD+
   VOGycwL48Y4AD9lI4kt3HEbJypSFedg7oUTnzgaUzER49G9OBHnsVzIGK
   hRdJlHB9GYZdhxs2wFCHqY31yAwgR9YucBJZX8ZEv/gPZlDn5mn2xf/9E
   S5JlZlxtl0nj1lHxbnM4pY4FArQqZxwxCPX4wWZxnxUtgdueYK9HPZ4e8
   Q==;
X-CSE-ConnectionGUID: fRapJjhoSnaEHA20VxNz9A==
X-CSE-MsgGUID: 9rnu9VKdTTGxKazch3mUZg==
X-IronPort-AV: E=McAfee;i="6600,9927,11091"; a="13723253"
X-IronPort-AV: E=Sophos;i="6.08,210,1712646000"; 
   d="scan'208";a="13723253"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2024 23:41:56 -0700
X-CSE-ConnectionGUID: Utgkcnd+RWmNKuQFQcYkzw==
X-CSE-MsgGUID: 7TfLIFeVR5idNbH1l885kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,210,1712646000"; 
   d="scan'208";a="41869800"
Received: from unknown (HELO st-server.bj.intel.com) ([10.240.193.102])
  by orviesa004.jf.intel.com with ESMTP; 02 Jun 2024 23:41:54 -0700
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH v2] KVM: x86: Advertise AVX10.1 CPUID to userspace
Date: Mon,  3 Jun 2024 14:40:02 +0800
Message-Id: <20240603064002.266116-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Advertising AVX10.1 is safe because kernel doesn't enable AVX10.1 which is
on KVM-only leaf now, just the CPUID checking is changed when using AVX512
related instructions, e.g. if using one AVX512 instruction needs to check
(AVX512 AND AVX512DQ), it can check ((AVX512 AND AVX512DQ) OR AVX10.1)
after checking XCR0[7:5].

The versions of AVX10 are expected to be inclusive, e.g. version N+1 is
a superset of version N. Per the spec, the version can never be 0, just
advertise AVX10.1 if it's supported in hardware.

As more and more AVX related CPUIDs are added (it would have resulted in
around 40-50 CPUID flags when developing AVX10), the versioning approach
is introduced. But incrementing version numbers are bad for virtualization.
E.g. if AVX10.2 has a feature that shouldn't be enumerated to guests for
whatever reason, then KVM can't enumerate any "later" features either,
because the only way to hide the problematic AVX10.2 feature is to set the
version to AVX10.1 or lower[2]. But most AVX features are just passed
through and don’t have virtualization controls, so AVX10 should not be
problematic in practice.

[1] https://cdrdv2.intel.com/v1/dl/getContent/784267
[2] https://lore.kernel.org/all/Zkz5Ak0PQlAN8DxK@google.com/

Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
Changelog:
v1 -> v2:
 - Directly advertise version 1 because version can never be 0.
 - Add and advertise feature bits for the supported vector sizes.

v1: https://lore.kernel.org/all/20240520022002.1494056-1-tao1.su@linux.intel.com/
---
 arch/x86/include/asm/cpuid.h |  1 +
 arch/x86/kvm/cpuid.c         | 21 +++++++++++++++++++--
 arch/x86/kvm/reverse_cpuid.h |  8 ++++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

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
index f2f2be5d1141..6717a5b7d9cd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -693,7 +693,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
 		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
-		F(AMX_COMPLEX)
+		F(AMX_COMPLEX) | F(AVX10)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
@@ -709,6 +709,10 @@ void kvm_set_cpu_caps(void)
 		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
 	);
 
+	kvm_cpu_cap_init_kvm_defined(CPUID_24_0_EBX,
+		F(AVX10_128) | F(AVX10_256) | F(AVX10_512)
+	);
+
 	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
 		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
@@ -937,7 +941,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	switch (function) {
 	case 0:
 		/* Limited to the highest leaf implemented in KVM. */
-		entry->eax = min(entry->eax, 0x1fU);
+		entry->eax = min(entry->eax, 0x24U);
 		break;
 	case 1:
 		cpuid_entry_override(entry, CPUID_1_EDX);
@@ -1162,6 +1166,19 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			break;
 		}
 		break;
+	case 0x24: {
+		if (!kvm_cpu_cap_has(X86_FEATURE_AVX10)) {
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
+		entry->eax = 0;
+		cpuid_entry_override(entry, CPUID_24_0_EBX);
+		/* EBX[7:0] hold the AVX10 version; KVM supports version '1'. */
+		entry->ebx |= 1;
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

base-commit: c3f38fa61af77b49866b006939479069cd451173
-- 
2.34.1


