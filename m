Return-Path: <kvm+bounces-60967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D4354C04824
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:35:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 77BA835337F
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E594274643;
	Fri, 24 Oct 2025 06:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="maYZM4PQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA782264A0
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287704; cv=none; b=V90VkraCO2OazpM7cesc+cC5UsX6Yk9INBceKHzuE582ZNe/6FQv8kt0ZYlHW1hlsJTIaPwdO5BoBJv79PP9PNwmZqLh03tetC1YGfmwjPKJzaT2kEex34B7Exm4wR5kR6lsKvSaWUuMIIo6Q1wxQ+n1Wi+C5M1PYMHR4EWCCoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287704; c=relaxed/simple;
	bh=MDD3UDmX4/TjoBSUbSkkNvFBKgw/jTaSm8KWZIYQic8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mT+fPkGZaKPJE2tdXIA8tyuuQyq8ImN6dN3Wu6+Sr98+1ozdPje6VecC/v8ZTG3XP10gwHjDSLfXAq7ZcPY+6pEO2ZfZ/zeougM0fIzf3Y+e03BSoTxtPbMlyAnK/MZv8CY2Ye1bUDb4YSbaXQCAgc7CNJKUETWcP53jshCdEsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=maYZM4PQ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287703; x=1792823703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MDD3UDmX4/TjoBSUbSkkNvFBKgw/jTaSm8KWZIYQic8=;
  b=maYZM4PQUxcernYqQl+6GLhTqy18PgEx4XjFi/InGj6RmYXZtSVD3Wf7
   MRfqCV8VD6MRqHSDyF6xpLxYIeXlquKc2oBD/HPH37m0DTDJ7OboWkwSN
   gqyrUk8DzRC6dRb9RygzLMv1lUU9teAsrjYJq1QweLnuupJjz7IkGtBuN
   HA0wXmoAsnx1jw80JkLwzOvARZIEPyuEunNOi/k7TlsnB8xsgxomaTJBf
   +QaVFzvJ1XpZRWFHVCRxT5W3zTrmgKDoMCo1IoSr9Qn9gmVFqFEwJCWgo
   VqCpo0NjSUCgLUlIl/omxX/rgoTHV3gB9Y6Iv8BMgXFub9VSx5xRvgwnK
   w==;
X-CSE-ConnectionGUID: IImyyPDvR8WKaqPbugetkQ==
X-CSE-MsgGUID: xsVtW+jEScKlUFO+btetig==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="86095579"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="86095579"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:35:03 -0700
X-CSE-ConnectionGUID: Jb4PQH+FRyaVh2fd2GrpTg==
X-CSE-MsgGUID: n6YJ5yxRQHa/JhPyDhbFFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184275952"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:34:59 -0700
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
Subject: [PATCH v3 06/20] i386/cpu: Add avx10 dependency for Opmask/ZMM_Hi256/Hi16_ZMM
Date: Fri, 24 Oct 2025 14:56:18 +0800
Message-Id: <20251024065632.1448606-7-zhao1.liu@intel.com>
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

With feature array in ExtSaveArea, add avx10 as the second dependency
for Opmask/ZMM_Hi256/Hi16_ZMM xsave components, and drop the special
check in cpuid_has_xsave_feature().

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index cd269d15ce0b..236a2f3a9426 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2054,18 +2054,21 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
         .size = sizeof(XSaveOpmask),
         .features = {
             { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
+            { FEAT_7_1_EDX,         CPUID_7_1_EDX_AVX10   },
         },
     },
     [XSTATE_ZMM_Hi256_BIT] = {
         .size = sizeof(XSaveZMM_Hi256),
         .features = {
             { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
+            { FEAT_7_1_EDX,         CPUID_7_1_EDX_AVX10   },
         },
     },
     [XSTATE_Hi16_ZMM_BIT] = {
         .size = sizeof(XSaveHi16_ZMM),
         .features = {
             { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
+            { FEAT_7_1_EDX,         CPUID_7_1_EDX_AVX10   },
         },
     },
     [XSTATE_PKRU_BIT] = {
@@ -8643,12 +8646,6 @@ static bool cpuid_has_xsave_feature(CPUX86State *env, const ExtSaveArea *esa)
         }
     }
 
-    if (esa->features[0].index == FEAT_7_0_EBX &&
-        esa->features[0].mask == CPUID_7_0_EBX_AVX512F &&
-        (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10)) {
-        return true;
-    }
-
     return false;
 }
 
-- 
2.34.1


