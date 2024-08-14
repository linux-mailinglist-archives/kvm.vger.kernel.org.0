Return-Path: <kvm+bounces-24105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8540B951601
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:02:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B90B1F22CB5
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9870E13D53B;
	Wed, 14 Aug 2024 08:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S1zkU7wU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F7977F11
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723622557; cv=none; b=PSa9N2fEcKUhhpGVHdSqW+B38LMp/E61jRhHOZOq0X4WNKLqdk7I8VHiZQ1FQ76zX0D5CuLI1kXrVPqn1C/akoQxyWvC7QXKM+mZynf1mPCecPxIoE08qK7m9IdNXlRPrv0pEZOnmHa3+LQXHedNTZ4/cMmfE5yRxOy+9aV3ybs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723622557; c=relaxed/simple;
	bh=Cg5NURAi8EL/prAcQEbdCLOiFO5T+SW5x3k5dhQ2JYo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MZ2CY3FjhnmeVP/HU7RH96B06djXE39McOVXYVC8oDiRx8i2+ehSYxQ9JLuUb+V+7nHSOdFzsT/Z1KzOgnr6RvBTet0ZB2+IgGjQfhl0j95MukylVvOgo6F283dpFIP4qgcCcW6tCQrwIzORcCdLdCKDdELZAd7BphRY5HSOSZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S1zkU7wU; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723622557; x=1755158557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cg5NURAi8EL/prAcQEbdCLOiFO5T+SW5x3k5dhQ2JYo=;
  b=S1zkU7wUYI3ioMJL7ZrgfUIVd17WEFG2SnY995nbZ6GKhu7Ic+MfaXtY
   c8bwihJqV4KgqZHzrFOYkn6lCiVwH9h1SrFK3NgP0AtaEpY2OS/qqp67D
   puUhzCDmkO0ysZWhgH251M8Mwb+G80AqEiDQ7Dz8nFhQyEzmZYzJGFW+F
   aC45KU+qI1etJH5Qb1E8jPqumlqzLTsJ/7UmCdelRPbTc43pLXt7BwDBE
   CKwOOiF1RFGb1HkjqQ1fMqSZ45xh01DYPK6Utltyhr4EQaCiPiwMBGSIK
   aLJsXZU1temUqLVZjQvUj2oD6Id5OLnwvdhAqnA8GleNN4OB4hBzHYvKq
   g==;
X-CSE-ConnectionGUID: 6x6qhaEvRuKrCTVVX66xug==
X-CSE-MsgGUID: KoOMNPR4RTiGGtxzKUH/CA==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25584470"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="25584470"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 01:02:36 -0700
X-CSE-ConnectionGUID: MkQ/j6iMStqhvnomGk60Ew==
X-CSE-MsgGUID: m4F72zKTRqiPog9YBMx+XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59048946"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Aug 2024 01:02:34 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH 2/9] i386/cpu: Enable fdp-excptn-only and zero-fcs-fds
Date: Wed, 14 Aug 2024 03:54:24 -0400
Message-Id: <20240814075431.339209-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240814075431.339209-1-xiaoyao.li@intel.com>
References: <20240814075431.339209-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- CPUID.(EAX=07H,ECX=0H):EBX[bit 6]: x87 FPU Data Pointer updated only
  on x87 exceptions if 1.

- CPUID.(EAX=07H,ECX=0H):EBX[bit 13]: Deprecates FPU CS and FPU DS
  values if 1. i.e., X87 FCS and FDS are always zero.

Define names for them so that they can be exposed to guest with -cpu host.

Also define the bit field MACROs so that named cpu models can add it as
well in the future.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 4 ++--
 target/i386/cpu.h | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 85ef7452c04e..e60d9dd58b60 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1054,9 +1054,9 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
             "fsgsbase", "tsc-adjust", "sgx", "bmi1",
-            "hle", "avx2", NULL, "smep",
+            "hle", "avx2", "fdp-excptn-only", "smep",
             "bmi2", "erms", "invpcid", "rtm",
-            NULL, NULL, "mpx", NULL,
+            NULL, "zero-fcs-fds", "mpx", NULL,
             "avx512f", "avx512dq", "rdseed", "adx",
             "smap", "avx512ifma", "pcommit", "clflushopt",
             "clwb", "intel-pt", "avx512pf", "avx512er",
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index c6cc035df3d8..542512f65dec 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -826,6 +826,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_0_EBX_HLE               (1U << 4)
 /* Intel Advanced Vector Extensions 2 */
 #define CPUID_7_0_EBX_AVX2              (1U << 5)
+/* FPU data pointer updated only on x87 exceptions */
+#define CPUID_7_0_EBX_FDP_EXCPTN_ONLY (1u << 6)
 /* Supervisor-mode Execution Prevention */
 #define CPUID_7_0_EBX_SMEP              (1U << 7)
 /* 2nd Group of Advanced Bit Manipulation Extensions */
@@ -836,6 +838,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_0_EBX_INVPCID           (1U << 10)
 /* Restricted Transactional Memory */
 #define CPUID_7_0_EBX_RTM               (1U << 11)
+/* Zero out FPU CS and FPU DS */
+#define CPUID_7_0_EBX_ZERO_FCS_FDS      (1U << 13)
 /* Memory Protection Extension */
 #define CPUID_7_0_EBX_MPX               (1U << 14)
 /* AVX-512 Foundation */
-- 
2.34.1


