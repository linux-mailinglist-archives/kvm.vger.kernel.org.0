Return-Path: <kvm+bounces-63468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F059C671C8
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5AF2E4E1562
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA8B328B6E;
	Tue, 18 Nov 2025 03:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h+Ed/Yxu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4E630FC25
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436046; cv=none; b=AyYvUMvsgDWdTlXYqAg4OlzDSMND6AClnPVcC5kNoISbtxtOBee+KAIYGQgLyp/qlbv4R6WAJaDwZveRwcIi/Mb3Ih3+h2WLtfleuIZmZ9XQI2nbfmNZ985HCFD2EgtOlXW52z5vQtIiyPORwY5mL/aP71AAHBJQiOrGqSsqGLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436046; c=relaxed/simple;
	bh=OLmeyBkc275l2fFpoH7p7H8roBE/4ZOOO8W3RLBkAq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I0jznpIlKUxfWgBzuCX6MIBjWGo0LnL26yEIcOSa+rjfuOBfaobiOm3eyumCB4ZvuFclA01c9qe28J6q4nvNyVUU/KczgpCUfydbTpE7G0q/OMEgmvMf7/gM0iXsHb8TkhMeZYHA05iPulx3bYjpg/s8LJbgVy8lWW8kkOd1/2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h+Ed/Yxu; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436045; x=1794972045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OLmeyBkc275l2fFpoH7p7H8roBE/4ZOOO8W3RLBkAq8=;
  b=h+Ed/YxuN62bhgFRgihQIQeq3gu9DMd6LzVz//AqensgbEWbatv4GDrN
   OGuGfRLje50OCYw81vm5AngD1E65aaCBwAPArmlDjwdt7DsFkwBw8jLgu
   R316Tqb/yvQxVqrMsewKrnGZozetQ4uP7zWwtQYfQLdaqDeK+RMtqbKJ3
   XDpMrc/CNfaQiouV/Nide++I/eoZykAK5heeSAgqWLCf2uoI7CJ27sPhc
   sWhs4pPmeQ3LGmSZWSOZ8MW1Jq66ii/J20wqEjnSgkvVGG5PvQQ+jXOFk
   6PIH+hTqj9UVFq5JviThhvbxT4zTqSUqokO5nj7b3Mefzdkn3XQ8pqLJR
   w==;
X-CSE-ConnectionGUID: 5q5xpoTeS2i1PmkN+2psLA==
X-CSE-MsgGUID: 9HLdGbytS2ubvN6rFE1BFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053794"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053794"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:20:45 -0800
X-CSE-ConnectionGUID: rsUv9q5nRhqTvG/ZYEl54Q==
X-CSE-MsgGUID: NHwk3NPIQHuy7ij2VwlLlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537181"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:20:41 -0800
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
Subject: [PATCH v4 08/23] i386/cpu: Reorganize dependency check for arch lbr state
Date: Tue, 18 Nov 2025 11:42:16 +0800
Message-Id: <20251118034231.704240-9-zhao1.liu@intel.com>
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


