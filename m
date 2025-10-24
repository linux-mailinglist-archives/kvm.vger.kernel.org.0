Return-Path: <kvm+bounces-60963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5F2DC0481B
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:35:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECF963B9C73
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2490270552;
	Fri, 24 Oct 2025 06:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DY0Ab5Qr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7A3259CB3
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287687; cv=none; b=tg7J9z/SnbqnL0jhmNfje4VrTDbH350+kldIIgX/6bbSQR6U6pO/SfZOQbaiL3gJUgH5tmzBnCxq8dFZtITv1r0bOybqWtC+SpM0lPKiaSdE4NxQ+8Z5GxFCKyTmlzN1yBOzl4TQ4KGiIpbD6Sga+9nS8sMYhvfhLPOXVwBa4PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287687; c=relaxed/simple;
	bh=b6plKWihII+6RJhuLKcgMFrd7Qpmmp9/C3krzhBvVSw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rjM3st6iozsSpY4qhHAcQemTsywNO1co9BJ0tClN7Vc84NSmwVnN9HZQe1UP8zhCfecu/EF4oR/4nC/slEBAijsemeNh5UZtGNoYhq8v6oxznaYeKfHaT5KGTZiW+mRVDUG7nb0NUUSIQSFYhzR4dhoLDoZIF9m+prS7p/Gq4Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DY0Ab5Qr; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287686; x=1792823686;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b6plKWihII+6RJhuLKcgMFrd7Qpmmp9/C3krzhBvVSw=;
  b=DY0Ab5Qr0opb1IVgr7t8ahN0DmFge5HLSukrGRaT4dmO0BY/q3UwJckx
   HveuLqG6wVriunoAFW8XAZM3trcoxMC7iqegYMAhk1FjAVh0d4XlSGVf2
   JYjtJbSJI4MCAWp6FjrU1iQe7gcx22jJ/NhIoZw6g6LudDxaomUR6X2Qa
   hzVgr+/1n+TM8b9AGOJtpgc4mu+04zzBdX8gcea1pb+SKhuUrS5KDhuXK
   /1KvXfLS/SAbYi7OrUQErGvHyVRa7mheKnqHof7+Z1YKazOMWjfQT3yAX
   FunNlbnBLyj1ZNKp22QxPnxKoQwd/kdgJ2a7TUNp5FFjPA3/lyy6FR0Jy
   w==;
X-CSE-ConnectionGUID: afI0GS/+T02ZUh5OpbXoNQ==
X-CSE-MsgGUID: +Fwn6KLWReyKCIdSn8P+sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="86095547"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="86095547"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:34:46 -0700
X-CSE-ConnectionGUID: 0QUAmH1gS9qrgLL/Dkmxkw==
X-CSE-MsgGUID: wy5mimrYRdKnHSHnHgvAzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184275882"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:34:41 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 02/20] i386/cpu: Clean up indent style of x86_ext_save_areas[]
Date: Fri, 24 Oct 2025 14:56:14 +0800
Message-Id: <20251024065632.1448606-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024065632.1448606-1-zhao1.liu@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 58 +++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 0a66e1fec939..f0e179c2d235 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2028,38 +2028,46 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
         .feature = FEAT_1_ECX, .bits = CPUID_EXT_XSAVE,
         .size = sizeof(X86LegacyXSaveArea) + sizeof(X86XSaveHeader),
     },
-    [XSTATE_YMM_BIT] =
-          { .feature = FEAT_1_ECX, .bits = CPUID_EXT_AVX,
-            .size = sizeof(XSaveAVX) },
-    [XSTATE_BNDREGS_BIT] =
-          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
-            .size = sizeof(XSaveBNDREG)  },
-    [XSTATE_BNDCSR_BIT] =
-          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
-            .size = sizeof(XSaveBNDCSR)  },
-    [XSTATE_OPMASK_BIT] =
-          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
-            .size = sizeof(XSaveOpmask) },
-    [XSTATE_ZMM_Hi256_BIT] =
-          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
-            .size = sizeof(XSaveZMM_Hi256) },
-    [XSTATE_Hi16_ZMM_BIT] =
-          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
-            .size = sizeof(XSaveHi16_ZMM) },
-    [XSTATE_PKRU_BIT] =
-          { .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_PKU,
-            .size = sizeof(XSavePKRU) },
+    [XSTATE_YMM_BIT] = {
+        .feature = FEAT_1_ECX, .bits = CPUID_EXT_AVX,
+        .size = sizeof(XSaveAVX),
+    },
+    [XSTATE_BNDREGS_BIT] = {
+        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
+        .size = sizeof(XSaveBNDREG),
+    },
+    [XSTATE_BNDCSR_BIT] = {
+        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
+        .size = sizeof(XSaveBNDCSR),
+    },
+    [XSTATE_OPMASK_BIT] = {
+        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
+        .size = sizeof(XSaveOpmask),
+    },
+    [XSTATE_ZMM_Hi256_BIT] = {
+        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
+        .size = sizeof(XSaveZMM_Hi256),
+    },
+    [XSTATE_Hi16_ZMM_BIT] = {
+        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
+        .size = sizeof(XSaveHi16_ZMM),
+    },
+    [XSTATE_PKRU_BIT] = {
+        .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_PKU,
+        .size = sizeof(XSavePKRU),
+    },
     [XSTATE_ARCH_LBR_BIT] = {
-            .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
-            .offset = 0 /*supervisor mode component, offset = 0 */,
-            .size = sizeof(XSavesArchLBR) },
+        .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
+        .offset = 0 /*supervisor mode component, offset = 0 */,
+        .size = sizeof(XSavesArchLBR),
+    },
     [XSTATE_XTILE_CFG_BIT] = {
         .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
         .size = sizeof(XSaveXTILECFG),
     },
     [XSTATE_XTILE_DATA_BIT] = {
         .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
-        .size = sizeof(XSaveXTILEDATA)
+        .size = sizeof(XSaveXTILEDATA),
     },
 };
 
-- 
2.34.1


