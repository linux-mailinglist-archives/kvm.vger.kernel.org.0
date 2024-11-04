Return-Path: <kvm+bounces-30443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF2029BACB0
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:42:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2B532819A3
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 06:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1821C18D633;
	Mon,  4 Nov 2024 06:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i1hOTACE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC76518E356
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 06:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730702524; cv=none; b=tiu6qUGLABcDlO0fXOhoQsOHa4UDfBnmjsEVu6yM8BKwQWWEjDw+LJPdK0g8eJgAYdV1hbDytHbK6briciF+raHeYgK+ziz3ePsuSpMdTKgW/viLsW9aHxo2VACcNj/LSWrpwwN+QKe2z3dgJz8NzRQnmnSXBxi+nU5ueuXjlaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730702524; c=relaxed/simple;
	bh=Sz9nXZkjuqr6cLwg0vipLsP0jCBbB9PPjpaJUULbvg4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MFMM5/wgGxd6OcOpKu/DtwgzbtoklYV4TkGxOgyPLfKbX7lLRj48J6PL7gxz2JEGm/swjkyF5mhQDTSDl8n5Y+ORghZ/B+qe1S0f0r+gigZBWKjU8kKJ/t86WtfAFCr5ygqLIrLaltQuEubkV96cENeZ9gwJtwByQF4rMhFlpmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i1hOTACE; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730702523; x=1762238523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sz9nXZkjuqr6cLwg0vipLsP0jCBbB9PPjpaJUULbvg4=;
  b=i1hOTACE30uXF73/IzzNKar3qIywA9yq0ID0y6E6pEAv7Q8daZSqth5J
   AplqbKDC2/dqXjvWvQ2DAsj4QLc+J3yQcoYnQw4WRzIwIALBI/XC+tZZm
   nxUG33eDQbdpG3xjfbLbcqT1f4dxIsk/NR4Bhvf7Wk1sB0IlcWuGOLIE+
   GSddAynfDBpRuwBlXiS3PtEH70M1U3ucbQeXm8JOWEjvYA7R/aICF/ECq
   WRxhR2cvMue8wQKlm3wU5WuXtdx3MmSTzKDs5kmNOnQlbp8X9NvHBvLJs
   JqztrSIctAO9bAB5/T2A0uRW1xFZ++cvTtfJFQqjt8da8xgxGp4pxvqct
   A==;
X-CSE-ConnectionGUID: Lz3c/RlfSuypbhlIA8nZ/A==
X-CSE-MsgGUID: oVmCpFXSSvKsMHsfa0CBrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="41776717"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="41776717"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 22:42:03 -0800
X-CSE-ConnectionGUID: X+Z4dH4xTc+aVejyzKDm/w==
X-CSE-MsgGUID: RiLsELtzRgCM+r3GP7gZxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83902915"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmviesa010.fm.intel.com with ESMTP; 03 Nov 2024 22:42:00 -0800
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
Subject: [PATCH 3/4] x86: KVM: Advertise SM4 CPUID to userspace
Date: Mon,  4 Nov 2024 14:35:58 +0800
Message-Id: <20241104063559.727228-4-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104063559.727228-1-tao1.su@linux.intel.com>
References: <20241104063559.727228-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SM4 is a new set of instructions in the latest Intel platform
Clearwater Forest, which contains VSM4KEY4, VSM4RNDS4.

SM4 is enumerated via CPUID.(EAX=7,ECX=1):EAX[bit 2].

SM4 is on an expected-dense CPUID leaf and some other bits on this leaf
have kernel usages. Considering SM4 itself has no truly kernel usages,
hide this one in /proc/cpuinfo.

These instructions only operate in xmm, ymm registers and have no new VMX
controls, so there is no additional host enabling required for guests to
use these instructions, i.e. advertising SM4 CPUID to userspace is safe.

Tested-by: Jiaan Lu <jiaan.lu@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 460f4f93b039..d96277dceabf 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -319,6 +319,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_SHA512		(12*32+ 0) /* SHA512 instructions */
 #define X86_FEATURE_SM3			(12*32+ 1) /* SM3 instructions */
+#define X86_FEATURE_SM4			(12*32+ 2) /* SM4 instructions */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* "avx_vnni" AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* "avx512_bf16" AVX512 BFLOAT16 instructions */
 #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e9f7489ba569..160b060121b2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -698,7 +698,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(SHA512) | F(SM3) | F(AVX_VNNI) | F(AVX512_BF16) |
+		F(SHA512) | F(SM3) | F(SM4) | F(AVX_VNNI) | F(AVX512_BF16) |
 		F(CMPCCXADD) | F(FZRM) | F(FSRS) | F(FSRC) |
 		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
 	);
-- 
2.34.1


