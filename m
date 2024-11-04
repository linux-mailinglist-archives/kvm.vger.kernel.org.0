Return-Path: <kvm+bounces-30442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E600D9BACAF
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC0E42819CA
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 06:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77EAA18E055;
	Mon,  4 Nov 2024 06:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ni8R8ihN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F4518E029
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 06:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730702521; cv=none; b=dUXV7j48TeTP3o5KoT5IoYcGPnCwW3rcUaLC9HSVaXTZw/YOdwroZ63p5s1zbJ1CjIbizSm/tZFYBF4S7JO7SZ/+bGC0PS78VMwcDfN68Tit/zIZBnMfHGeUDygr1LDLM/HJLlxR62K33arqtwrth0RBMrbKHeR1HUi9pDa0w/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730702521; c=relaxed/simple;
	bh=N2fSIGhMajMWUCachOEa/v12nbDbD5r0DvE4Ja1Lwjc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oAuCNbzT5WddMJyFkmeLxpJJw5BYqfUDKqThxu0WVEu93gvfA+JHkkPv93yjEDclvP2kcfNSAshHpLb5RhREC1QSEy2dv7aZvikWDf4aIeIyTB0RP7lAM46ZMv5DtWQ9yVT0aElhhJC74T03MlfD2dUCXmUDAu+hgsDh3sPm3jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ni8R8ihN; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730702521; x=1762238521;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N2fSIGhMajMWUCachOEa/v12nbDbD5r0DvE4Ja1Lwjc=;
  b=Ni8R8ihN6wFOOJjO7V4XDGzBrPBdW8YBnFzTmtNA3AOHfq28TmlaFVIe
   UQlP7Bwr6JomQ5cRsGJpkwIiGu7S+FN490uh2ohY3HrLT2OgvqSn2uAiY
   DVC43hYGOxn+smCaSMpSD89CDNQZlRdLkILOFqmWFI4o0FgbseH5cCWCC
   5mxuEXPmm1Rh/9uCAD1GgrRHE0SP9qoFRwDwt6ycPOLaXZqRgHw/ZpzTA
   lfOJs1Sy988aXXRdD3U1PUw3dsAZpC9Q6+JdjvzdUUp2kTX8YTAquUnfS
   aNtijwyY8K9paVh/qAdbr8aT1+iXwt1r0Xcw9a0VDy5oSprKwRg2Oj+Ga
   g==;
X-CSE-ConnectionGUID: wnF/LyXaQTuvB/J2yecCfg==
X-CSE-MsgGUID: WxMYlfbNQiCJSaG45amegw==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="41776711"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="41776711"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 22:42:00 -0800
X-CSE-ConnectionGUID: Nhmm51BjQAu+aE814hEk2Q==
X-CSE-MsgGUID: J1A8yY7GSVyVSoOa1XTqfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83902905"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmviesa010.fm.intel.com with ESMTP; 03 Nov 2024 22:41:57 -0800
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
Subject: [PATCH 2/4] x86: KVM: Advertise SM3 CPUID to userspace
Date: Mon,  4 Nov 2024 14:35:57 +0800
Message-Id: <20241104063559.727228-3-tao1.su@linux.intel.com>
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

SM3 is a new set of instructions in the latest Intel platform Clearwater
Forest, which contains VSM3MSG1, VSM3MSG2, VSM3RNDS2.

SM3 is enumerated via CPUID.(EAX=7,ECX=1):EAX[bit 1].

SM3 is on an expected-dense CPUID leaf and some other bits on this leaf
have kernel usages. Considering SM3 itself has no truly kernel usages,
hide this one in /proc/cpuinfo.

These instructions only operate in xmm registers and have no new VMX
controls, so there is no additional host enabling required for guests to
use these instructions, i.e. advertising SM3 CPUID to userspace is safe.

Tested-by: Jiaan Lu <jiaan.lu@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 896794528b81..460f4f93b039 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -318,6 +318,7 @@
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_SHA512		(12*32+ 0) /* SHA512 instructions */
+#define X86_FEATURE_SM3			(12*32+ 1) /* SM3 instructions */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* "avx_vnni" AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* "avx512_bf16" AVX512 BFLOAT16 instructions */
 #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5c7772567a4e..e9f7489ba569 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -698,8 +698,8 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(SHA512) | F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
-		F(FZRM) | F(FSRS) | F(FSRC) |
+		F(SHA512) | F(SM3) | F(AVX_VNNI) | F(AVX512_BF16) |
+		F(CMPCCXADD) | F(FZRM) | F(FSRS) | F(FSRC) |
 		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
 	);
 
-- 
2.34.1


