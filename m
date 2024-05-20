Return-Path: <kvm+bounces-17740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC5E8C97E8
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 04:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0752F2851A6
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 02:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65875A937;
	Mon, 20 May 2024 02:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G4hHBeCM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D43E552
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 02:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716171716; cv=none; b=Z2SDX0JbWxjrRj/7uX8lBLL3hOFLbbH0QdTGsDylB/GPkKakGYhbNUdbKScRsJ9htT+RVy4U/M/1UEzXRs4LoZ/5SJD6HN1xgzpvdNX0sgRy8ICGjtsDR+fYH+PNOVwVACrTLiEhY/yTsdml5PlmzpeVXH2AUEaTviAaw78IDhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716171716; c=relaxed/simple;
	bh=mYRqEBC5MGEjOQQe/kms6BK1VSWz+BSJENKqOfBTr8k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y+Gd8xevR4xYLI3vcCKc1FgBIXzzwtJXIId1exPYW2eAPW4Wq2/FcVAUK4Yqc7ME3zLFlYNXGMw4TWsq+C+AqHgNVRR0QvCLOn8jgvnVuvZ5EedbzW7LUrTZQEBoRBsxyUeaSxWxUpnEs4yIbAcbEoHyZgGCxNR+frMS2DOixdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G4hHBeCM; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716171715; x=1747707715;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mYRqEBC5MGEjOQQe/kms6BK1VSWz+BSJENKqOfBTr8k=;
  b=G4hHBeCMi9QWEA3Xuf9bSwuQJGj8l+8PPZA554BCQo8MAecy33BSCWLv
   LBVgCvhPVJ26rwV5tWOByNRLT9eEKjU8HOvhVnOpDVhLm5frEfxCx+ntD
   2Fv5aaersYjOVTgWLuCP1RcqnvT3daZf8XTde7SJ81s3z6HxeZ6nplfwJ
   +DwhfMCewKVXHO73R9MuypPpfpJDq1ZumsxOLUJjUrbjoh4fSVyMkiq4x
   6N8GFBu5psNlW/yeWjyqLbbkAEaXNbMcqcD9Yt7Hv4dvDtdbIJ6MJt+LG
   QQxAWVEkuulLja5mBr/kjg9sCURUn4EYBaZqwJf/80YmJecW7ueimjqPg
   g==;
X-CSE-ConnectionGUID: +dSRjOZjSXaiiGzANNd9VA==
X-CSE-MsgGUID: 8YE+RAOaQm6x0l617cyLrA==
X-IronPort-AV: E=McAfee;i="6600,9927,11077"; a="12501598"
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="12501598"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2024 19:21:54 -0700
X-CSE-ConnectionGUID: iwT51rEuTVyzZX4GMDb35w==
X-CSE-MsgGUID: hnhUWlOJTFGr2+q+IVZZ6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="63608217"
Received: from unknown (HELO st-server.bj.intel.com) ([10.240.193.102])
  by fmviesa001.fm.intel.com with ESMTP; 19 May 2024 19:21:52 -0700
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH] KVM: x86: Advertise AVX10.1 CPUID to userspace
Date: Mon, 20 May 2024 10:20:02 +0800
Message-Id: <20240520022002.1494056-1-tao1.su@linux.intel.com>
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
Granite Rapids. I.e., AVX10.1 is only a new CPUID enumeration without
any VMX controls.

Advertising AVX10.1 is safe because kernel doesn't enable AVX10.1 which is
on KVM-only leaf now, just the CPUID checking is changed when using AVX512
related instructions, e.g. if using one AVX512 instruction needs to check
(AVX512 AND AVX512DQ), it can check ((AVX512 AND AVX512DQ) OR AVX10.1)
after checking XCR0[7:5].

The versions of AVX10 are expected to be inclusive, e.g. version N+1 is
a superset of version N, so just advertise AVX10.1 if it's supported in
hardware.

[1] https://cdrdv2.intel.com/v1/dl/getContent/784267

Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
 arch/x86/include/asm/cpuid.h |  1 +
 arch/x86/kvm/cpuid.c         | 20 ++++++++++++++++++--
 arch/x86/kvm/reverse_cpuid.h |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

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
index f2f2be5d1141..ef9e3a4ed461 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -693,7 +693,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
 		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
-		F(AMX_COMPLEX)
+		F(AMX_COMPLEX) | F(AVX10)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
@@ -937,7 +937,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	switch (function) {
 	case 0:
 		/* Limited to the highest leaf implemented in KVM. */
-		entry->eax = min(entry->eax, 0x1fU);
+		entry->eax = min(entry->eax, 0x24U);
 		break;
 	case 1:
 		cpuid_entry_override(entry, CPUID_1_EDX);
@@ -1162,6 +1162,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			break;
 		}
 		break;
+	case 0x24: {
+		u8 avx10_version;
+		u32 vector_support;
+
+		if (!kvm_cpu_cap_has(X86_FEATURE_AVX10)) {
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
+		avx10_version = min(entry->ebx & 0xff, 1);
+		vector_support = entry->ebx & GENMASK(18, 16);
+		entry->eax = 0;
+		entry->ebx = vector_support | avx10_version;
+		entry->ecx = 0;
+		entry->edx = 0;
+		break;
+	}
 	case KVM_CPUID_SIGNATURE: {
 		const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
 		entry->eax = KVM_CPUID_FEATURES;
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 2f4e155080ba..695e1fb8d5bc 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -46,6 +46,7 @@ enum kvm_only_cpuid_leafs {
 #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
 #define X86_FEATURE_AMX_COMPLEX         KVM_X86_FEATURE(CPUID_7_1_EDX, 8)
 #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
+#define X86_FEATURE_AVX10               KVM_X86_FEATURE(CPUID_7_1_EDX, 19)
 
 /* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX) */
 #define X86_FEATURE_INTEL_PSFD		KVM_X86_FEATURE(CPUID_7_2_EDX, 0)

base-commit: eb6a9339efeb6f3d2b5c86fdf2382cdc293eca2c
-- 
2.34.1


