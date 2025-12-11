Return-Path: <kvm+bounces-65700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C876CB4CB9
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 212393019B63
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48952256C71;
	Thu, 11 Dec 2025 05:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jukfTsHl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D66928C854
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431830; cv=none; b=JGLOHf+5LoxmA186yklYkEI30RJQ1n7dBC3cNLFom+JwKOqkdBz25Gh4ZGuUZ/2C2h1M0tF+G80Os2VRWYgNrly4yHDCBlpiXcYYtZXaE9JYqpTAfzW7Ze7TgoX1/3KHtbVdPEOQUiCdfwLQvcr6PmqkflHtrQuiwgeDmD2MVm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431830; c=relaxed/simple;
	bh=OLmeyBkc275l2fFpoH7p7H8roBE/4ZOOO8W3RLBkAq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=La+gsz/0hNrI/mFs1E/Si2QKCPIRijhyO0iUzaHM8Gbf0DTHCN2P43k2BUv+5l/aBn4qeQFihHjl4ykEJjbajRPI+ZJKjgpk86mQ3oi8h5fnRV4fo5blE4kQnh6VnNhdMEm0ys7VNYTJwAFpJ4bavSjE7yr6bc4QvcUX+OWCG78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jukfTsHl; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431828; x=1796967828;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OLmeyBkc275l2fFpoH7p7H8roBE/4ZOOO8W3RLBkAq8=;
  b=jukfTsHlhkJv6dYG7wOXYwvGoOYxJ3Z1Rwv9Gi02y/4pEw1OmFvo/CoX
   sUZwcWd9Wf7pPAZMuxoevMa83G9s5KKJDI/1ItAObNGmYGvFX5mWy5zg4
   cEIyGD6LOJxyif4F7RVP3eCZ91Y9O3Ee2Mm9qJ5THJRTsmD2YmMbJcQz/
   5SiXbRzildvLA3Kma6rRNwXbalXdWrqLmuL9pQAg2+eDzPWAnVNEDohq9
   QpgRK4ZNuWwRPTy8faqgqVvr7PpXLbFakHOOc8DoMC6o0fpKCxlQtB+Mq
   FaNE/K2QHtBOTVXYD+PW6BIXMG/2gADe2J7zdhaZb70bAJ/OGii3rs5qb
   w==;
X-CSE-ConnectionGUID: GeL6DHcSRXSZfUcgOIZxBw==
X-CSE-MsgGUID: 3lZxPq++RT2EVIfToUcLow==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409867"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409867"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:43:48 -0800
X-CSE-ConnectionGUID: 0mfNbpUGSmKzsAOP+ctacg==
X-CSE-MsgGUID: vlX8I5qaT2qZyP9vFByNDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366054"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:43:44 -0800
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
Subject: [PATCH v5 07/22] i386/cpu: Reorganize dependency check for arch lbr state
Date: Thu, 11 Dec 2025 14:07:46 +0800
Message-Id: <20251211060801.3600039-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211060801.3600039-1-zhao1.liu@intel.com>
References: <20251211060801.3600039-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The arch lbr state has 2 dependencies:
 * Arch lbr feature bit (CPUID 0x7.0x0:EDX[bit 19]):

   This bit also depends on pmu property. Mask it off if pmu is disabled
   in x86_cpu_expand_features(), so that it is not needed to repeatedly
   check whether this bit is set as well as pmu is enabled.

   Note this doesn't need compat option, since even KVM hasn't support
   arch lbr yet.

   The supported xstate is constructed based such dependency in
   cpuid_has_xsave_feature(), so if pmu is disabled and arch lbr bit is
   masked off, then arch lbr state won't be included in supported
   xstates.

   Thus it's safe to drop the check on arch lbr bit in CPUID 0xD
   encoding.

 * XSAVES feature bit (CPUID 0xD.0x1.EAX[bit 3]):

   Arch lbr state is a supervisor state, which requires the XSAVES
   feature support. Enumerate supported supervisor state based on XSAVES
   feature bit in x86_cpu_enable_xsave_components().

   Then it's safe to drop the check on XSAVES feature support during
   CPUID 0XD encoding.

Suggested-by: Zide Chen <zide.chen@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index f3bf7f892214..56b4c57969c1 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8179,20 +8179,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *ebx = xsave_area_size(xstate, true);
             *ecx = env->features[FEAT_XSAVE_XSS_LO];
             *edx = env->features[FEAT_XSAVE_XSS_HI];
-            if (kvm_enabled() && cpu->enable_pmu &&
-                (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR) &&
-                (*eax & CPUID_XSAVE_XSAVES)) {
-                *ecx |= XSTATE_ARCH_LBR_MASK;
-            } else {
-                *ecx &= ~XSTATE_ARCH_LBR_MASK;
-            }
-        } else if (count == 0xf && cpu->enable_pmu
-                   && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
-            const ExtSaveArea *esa = &x86_ext_save_areas[count];
-
-            *eax = esa->size;
-            *ebx = esa->offset;
-            *ecx = esa->ecx;
         } else if (count < ARRAY_SIZE(x86_ext_save_areas)) {
             const ExtSaveArea *esa = &x86_ext_save_areas[count];
 
@@ -8910,6 +8896,12 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
 
     mask = 0;
     for (i = 0; i < ARRAY_SIZE(x86_ext_save_areas); i++) {
+        /* Skip supervisor states if XSAVES is not supported. */
+        if (CPUID_XSTATE_XSS_MASK & (1 << i) &&
+            !(env->features[FEAT_XSAVE] & CPUID_XSAVE_XSAVES)) {
+            continue;
+        }
+
         const ExtSaveArea *esa = &x86_ext_save_areas[i];
         if (cpuid_has_xsave_feature(env, esa)) {
             mask |= (1ULL << i);
@@ -9027,11 +9019,13 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
         }
     }
 
-    if (!cpu->pdcm_on_even_without_pmu) {
+    if (!cpu->enable_pmu) {
         /* PDCM is fixed1 bit for TDX */
-        if (!cpu->enable_pmu && !is_tdx_vm()) {
+        if (!cpu->pdcm_on_even_without_pmu && !is_tdx_vm()) {
             env->features[FEAT_1_ECX] &= ~CPUID_EXT_PDCM;
         }
+
+        env->features[FEAT_7_0_EDX] &= ~CPUID_7_0_EDX_ARCH_LBR;
     }
 
     for (i = 0; i < ARRAY_SIZE(feature_dependencies); i++) {
-- 
2.34.1


