Return-Path: <kvm+bounces-60969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D4D7C0482A
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:35:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F1EBE4F5084
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5275B26E6E3;
	Fri, 24 Oct 2025 06:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jsUUyBHi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9971E990E
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287711; cv=none; b=f9i8W/gc3wshrF53SHgP38OMsBSPYuTVXM15sKQFTavBpwdijwzeLPLtrCEmCE5JZERwdxVihW5uea4KL+vO/YY6OGYMDSut7/sek+PSg1s6SxEfFeJXuftxiFsQPT1fem019Hxd9ZhzHz91g95kol0lSLIOGoBY7Vw4Eyk2tsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287711; c=relaxed/simple;
	bh=hgZVF5yOjTiT/cqOb4vICgZJdehG/NoYvKjkMr72MLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N0y8/YDKivGe6K9Gq0IWrmRSDP1MSelOGBmxwNzUn140kqNb6rDLSxi28IOj0zhFOCJLGz1UEwMT2c6MOZYHQN7iC8PbaGt1qZySAnaKSSRiK+BQZRFmwPA/l6GC58HOULj4JH8Egnxmj7IN4OXuKFsBQz0cGsOkLbv/qM8jg+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jsUUyBHi; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287711; x=1792823711;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hgZVF5yOjTiT/cqOb4vICgZJdehG/NoYvKjkMr72MLQ=;
  b=jsUUyBHirlmdg3nDAoh0gxnHEN8/Ovv1369plhXApV4ArfSFGWH9zYSu
   oxip7a9YdA/LEoxQtxlmJUpHKZVJjMxCM5m5h8OCMG06MTSP3AZkjrVlH
   BWmK4P3tqbdGqCySiiH0GnTaPxzI88sHa48xZTROYyh32obLlbXPk5obZ
   VP/UbUF53MTcR43S2QHyP7YCAFH9X+f30y8elAZzd8hlLB0TzqAMoePT5
   UUnPQFcX56vXQMYj6PzV8egfEPK+RvQ+MeyfBtGUbG19bOJP24MQdte5h
   7CpyqolU+8cutvhL33LWgs2qdpgjZIzQFrKzemTcGI1TYJ8SV8h6tHoDB
   w==;
X-CSE-ConnectionGUID: wNQf0WwtQHefvEr+eC/epA==
X-CSE-MsgGUID: FfZyN4zCQQ+qr35BU42UUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="86095582"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="86095582"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:35:10 -0700
X-CSE-ConnectionGUID: k+loaOomT4esGWD24LR1Hg==
X-CSE-MsgGUID: JXZ5mRxMRDa0NViqr9Tl8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184276030"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:35:06 -0700
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
Subject: [PATCH v3 08/20] i386/cpu: Drop pmu check in CPUID 0x1C encoding
Date: Fri, 24 Oct 2025 14:56:20 +0800
Message-Id: <20251024065632.1448606-9-zhao1.liu@intel.com>
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

Since CPUID_7_0_EDX_ARCH_LBR will be masked off if pmu is disabled,
there's no need to check CPUID_7_0_EDX_ARCH_LBR feature with pmu.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5b7a81fcdb1b..5cd335bb5574 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8275,11 +8275,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         }
         break;
     }
-    case 0x1C:
-        if (cpu->enable_pmu && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
-            x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
-            *edx = 0;
+    case 0x1C: /* Last Branch Records Information Leaf */
+        *eax = 0;
+        *ebx = 0;
+        *ecx = 0;
+        *edx = 0;
+        if (!(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
+            break;
         }
+        x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
+        *edx = 0; /* EDX is reserved. */
         break;
     case 0x1D: {
         /* AMX TILE, for now hardcoded for Sapphire Rapids*/
-- 
2.34.1


