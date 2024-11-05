Return-Path: <kvm+bounces-30625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 825339BC50C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:56:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45966280FC1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BB0A1FF609;
	Tue,  5 Nov 2024 05:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U2/DdAYy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C48C383
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730786065; cv=none; b=um7BD97xHNnKJiSIVHBMOqdCLiiY7yo04qcgsF3p6QwN1LXfNbpbTjlPPvYVn09S2ZjuIMlgJREdwPbtbRpHY/bqQHVwmmiPcq51C5W0LrfuyXLegDke66ZPITCQ35TA+3TiSwVCuE78pFPcwZjvigQrlT685QlmwnDYO0MkZuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730786065; c=relaxed/simple;
	bh=0OoOzBhx74szUGlwCfmlNKffvLdHmqvKY7RGCMHDX5g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NHlbv31rV5nyId+IAwAZzZ0kapHrRew8hmbj/mU+5/u92aHJxAvQLTlH4gXQ6/ESgPhjXYyUhBRspfPBoeoKLY105PjqeTIGkV5ZyuVpo9CCfCua9j+1uqfxUFSG9mrWB9kx6dYAGQruCOic5c5hdNqtAr8VGzlnQAhN3IWbvpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U2/DdAYy; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730786064; x=1762322064;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0OoOzBhx74szUGlwCfmlNKffvLdHmqvKY7RGCMHDX5g=;
  b=U2/DdAYyy4XyIlOB3LjRkMKVenVWMKLK0Pl21wteKcJI2YgQko8VCR+h
   aRfElNzam4jdl3mXcghV+hMMdypHrBAJHItMmw0vhh2BVDKPS0yT0sMG5
   zmmwXMIG7XFJW31qa3UcWLIrEIHkYbKyuHYIgMh6JCCzNKEbfEjTHUFZw
   lDz9mFfGh6m+HRfCJ/6qmhnOfgulSR7N05ZRsl45VRT80IgMxAYLGuTfN
   z36etnvCj8hi81TfPaFS3aIetPMnxWr6zW7EOVa/dOi6pxAfe9gZROBE6
   BMG0jTDGyVEnXn7gP4aQpjuRysbrB5/q4s4GsLqG4LCtm0hq9YBQpgM26
   w==;
X-CSE-ConnectionGUID: keYwzsFQTdGGxu8jz3mhVA==
X-CSE-MsgGUID: 40O3IkWJSFGZbPE8VeIG+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="18131176"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="18131176"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:54:22 -0800
X-CSE-ConnectionGUID: 2+4PkHRBR4qQrPgiR9OQsw==
X-CSE-MsgGUID: lspzd9fQShCpuIDTMxksNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83995577"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by orviesa006.jf.intel.com with ESMTP; 04 Nov 2024 21:54:19 -0800
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org,
	x86@kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	jiaan.lu@intel.com,
	xuelian.guo@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH v2] x86: KVM: Advertise CPUIDs for new instructions in Clearwater Forest
Date: Tue,  5 Nov 2024 13:48:25 +0800
Message-Id: <20241105054825.870939-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Latest Intel platform Clearwater Forest has introduced new instructions
enumerated by CPUIDs of SHA512, SM3, SM4 and AVX-VNNI-INT16. Advertise
these CPUIDs to userspace so that guests can query them directly.

SHA512, SM3 and SM4 are on an expected-dense CPUID leaf and some other
bits on this leaf have kernel usages. Considering they have not truly
kernel usages, hide them in /proc/cpuinfo.

These new instructions only operate in xmm, ymm registers and have no new
VMX controls, so there is no additional host enabling required for guests
to use these instructions, i.e. advertising these CPUIDs to userspace is
safe.

Tested-by: Jiaan Lu <jiaan.lu@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
Changelog:
v1->v2:
 - Merge whole patch set into a single patch. (Borislav)
 - Drop duplicate description in commit message. (Dave)

v1: https://lore.kernel.org/all/20241104063559.727228-1-tao1.su@linux.intel.com/
---
 arch/x86/include/asm/cpufeatures.h |  3 +++
 arch/x86/kvm/cpuid.c               | 10 +++++-----
 arch/x86/kvm/reverse_cpuid.h       |  1 +
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 913fd3a7bac6..d96277dceabf 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -317,6 +317,9 @@
 #define X86_FEATURE_ZEN1		(11*32+31) /* CPU based on Zen1 microarchitecture */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
+#define X86_FEATURE_SHA512		(12*32+ 0) /* SHA512 instructions */
+#define X86_FEATURE_SM3			(12*32+ 1) /* SM3 instructions */
+#define X86_FEATURE_SM4			(12*32+ 2) /* SM4 instructions */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* "avx_vnni" AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* "avx512_bf16" AVX512 BFLOAT16 instructions */
 #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 41786b834b16..bc98e19a3f36 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -698,14 +698,14 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
-		F(FZRM) | F(FSRS) | F(FSRC) |
-		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
+		F(SHA512) | F(SM3) | F(SM4) | F(AVX_VNNI) | F(AVX512_BF16) |
+		F(CMPCCXADD) | F(FZRM) | F(FSRS) | F(FSRC) | F(AMX_FP16) |
+		F(AVX_IFMA) | F(LAM)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
-		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
-		F(AMX_COMPLEX) | F(AVX10)
+		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(AMX_COMPLEX) |
+		F(AVX_VNNI_INT16) | F(PREFETCHITI) | F(AVX10)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 0d17d6b70639..e46220ece83c 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -46,6 +46,7 @@ enum kvm_only_cpuid_leafs {
 #define X86_FEATURE_AVX_VNNI_INT8       KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
 #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
 #define X86_FEATURE_AMX_COMPLEX         KVM_X86_FEATURE(CPUID_7_1_EDX, 8)
+#define X86_FEATURE_AVX_VNNI_INT16      KVM_X86_FEATURE(CPUID_7_1_EDX, 10)
 #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
 #define X86_FEATURE_AVX10               KVM_X86_FEATURE(CPUID_7_1_EDX, 19)
 

base-commit: 2e1b3cc9d7f790145a80cb705b168f05dab65df2
-- 
2.34.1


