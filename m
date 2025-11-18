Return-Path: <kvm+bounces-63473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CA47C671D4
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:21:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2C6BC3623C2
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19BBA322DB7;
	Tue, 18 Nov 2025 03:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pgw7ZBS0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C41328607
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436064; cv=none; b=PXv0WV1IU3A/gmuXc6DhnTFU/aYGtRvgp/k0sZD763iU2ZczbfH0KZ54FqKM+GqSNowFh0fUEjvtu13Lt+GLJWzxcS+BIL8oN9YvfuzYCbmgU0GjyDUeMz30n2SCy2GVgOPEaXWir+WuNTe14rCIac284fALNXnOZqYQ/K3vgaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436064; c=relaxed/simple;
	bh=FtN3GnlS9XpEdZZ5ADMYto6Z66Ic1LkzQp5aPpZOx4E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e9WCaEi/K6CSRMd8/Nbm8178U09oeuu+F0cWmxytyxfACaZah7S9iFTRY/3zvvXoWLJSsBweOE2SjJfHmslmMXe36ciaSOwrExdDGVRtftlxDEqjZZ+z+sQWj9O1anenS/q5U/fPQrqhMuPLPoH3sdho2bDUt9TKGP8RaPNa/WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pgw7ZBS0; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436062; x=1794972062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FtN3GnlS9XpEdZZ5ADMYto6Z66Ic1LkzQp5aPpZOx4E=;
  b=Pgw7ZBS0Sfw6Cq3NgmaZAgR947AYWMrTpXfTwMGHuRWMoLXYcnaCTora
   NQBDGdRzdLDW/ZNsH8ed1TeNHPCuaHaKrRK2l+YX3l7JTLEN09kxWNIEt
   abdHotkK4qt9KItv/xcMC6tRl8TOkzCpTwuVXQWfWR98iD2x5QtDczuyZ
   H3rKhmqzZWx8A8bqa4Myc9NplvQiHhh+XbiY1gO33qaHgAv5ncf52xKIO
   LymF8XAhRAovqD/TYzPTLI48JRP+RW/ELdk1uxWmdxJd33nBTiRRfQs8p
   754hhy3AtnzPaUMu7o2wzwuIY3T081j0yLXk8PNyiU3yGayiTp8y4FmPH
   w==;
X-CSE-ConnectionGUID: AMFFE+CyTiaUo4CHDCzoLw==
X-CSE-MsgGUID: uo7b3LrfQwSKPLjxUAcWLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053857"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053857"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:21:02 -0800
X-CSE-ConnectionGUID: EsWihIMhRZG0T8NjBlfN/A==
X-CSE-MsgGUID: 9jIsDCHTR1CiHx3n6juJ2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537237"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:20:58 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 13/23] i386/cpu: Add CET support in CR4
Date: Tue, 18 Nov 2025 11:42:21 +0800
Message-Id: <20251118034231.704240-14-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118034231.704240-1-zhao1.liu@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CR4.CET bit (bit 23) is as master enable for CET.
Check and adjust CR4.CET bit based on CET CPUIDs.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - Reorder CR4_RESERVED_MASK.
---
 target/i386/cpu.h    |  9 +++++++--
 target/i386/helper.c | 12 ++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index bfc38830e29e..f4cb1dc49b71 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -257,6 +257,7 @@ typedef enum X86Seg {
 #define CR4_SMEP_MASK   (1U << 20)
 #define CR4_SMAP_MASK   (1U << 21)
 #define CR4_PKE_MASK   (1U << 22)
+#define CR4_CET_MASK   (1U << 23)
 #define CR4_PKS_MASK   (1U << 24)
 #define CR4_LAM_SUP_MASK (1U << 28)
 
@@ -273,8 +274,8 @@ typedef enum X86Seg {
                 | CR4_OSFXSR_MASK | CR4_OSXMMEXCPT_MASK | CR4_UMIP_MASK \
                 | CR4_LA57_MASK \
                 | CR4_FSGSBASE_MASK | CR4_PCIDE_MASK | CR4_OSXSAVE_MASK \
-                | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK \
-                | CR4_LAM_SUP_MASK | CR4_FRED_MASK))
+                | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_CET_MASK \
+                | CR4_PKS_MASK | CR4_LAM_SUP_MASK | CR4_FRED_MASK))
 
 #define DR6_BD          (1 << 13)
 #define DR6_BS          (1 << 14)
@@ -2951,6 +2952,10 @@ static inline uint64_t cr4_reserved_bits(CPUX86State *env)
     if (!(env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED)) {
         reserved_bits |= CR4_FRED_MASK;
     }
+    if (!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) &&
+        !(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT)) {
+        reserved_bits |= CR4_CET_MASK;
+    }
     return reserved_bits;
 }
 
diff --git a/target/i386/helper.c b/target/i386/helper.c
index 72b2e195a31e..3f179c6c11f8 100644
--- a/target/i386/helper.c
+++ b/target/i386/helper.c
@@ -232,6 +232,18 @@ void cpu_x86_update_cr4(CPUX86State *env, uint32_t new_cr4)
         new_cr4 &= ~CR4_LAM_SUP_MASK;
     }
 
+    /*
+     * In fact, "CR4.CET can be set only if CR0.WP is set, and it must be
+     * clear before CR0.WP can be cleared". However, here we only check
+     * CR4.CET based on the supported CPUID CET bit, without checking the
+     * dependency on CR4.WP - the latter need to be determined by the
+     * underlying accelerators.
+     */
+    if (!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) &&
+        !(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT)) {
+        new_cr4 &= ~CR4_CET_MASK;
+    }
+
     env->cr[4] = new_cr4;
     env->hflags = hflags;
 
-- 
2.34.1


