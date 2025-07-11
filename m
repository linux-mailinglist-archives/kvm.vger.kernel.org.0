Return-Path: <kvm+bounces-52130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 53D6CB01934
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:02:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8B787BF1DB
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 376BB281355;
	Fri, 11 Jul 2025 10:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vvg+kJJz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B860327F72D
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228082; cv=none; b=V+z4CtR9/n1zadF2/h6/1oMUw1fXUO772EXEYU+XKFpiLieCr3oJrIzy8AMC7EfGvG6XpqltBr4w0JuYqrgw2TUAZYEhOBSHF5leFhKcJhggNkqVWbjEw0WqT/HVgt6+1KnPX8eUxhezcz26sbLoI0gkeBfpYYQgUKlkFkhSxhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228082; c=relaxed/simple;
	bh=k7XAWqK5epSjHbUsK5O+B5YEq6VSgB/UAnTZPzrTEwE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K7MhhQJHwW7xlpl8be41LAH0oRZC55n8nimrNHhIk0+10Bp6YKGgLlkHI+05YMkAm7Qn1YTtK4jbGRrimhakBqxGBtpo3uJbN67XEf9c/ay+MOJTSVgqe4+R57liUB06yEF6MB5iIkHiCGBz+9ifipHuJGdkFOoBSTeK7lQVSv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vvg+kJJz; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228081; x=1783764081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k7XAWqK5epSjHbUsK5O+B5YEq6VSgB/UAnTZPzrTEwE=;
  b=Vvg+kJJzz9NB2c5EkWP+wh+/YtWOM2jZ8rIGZ8VGXozGv6ymTswRRZT+
   MSzBV8s6nJBFIz5y+nQoAYNQ2YWpfuWSpbUSotMaUANyrXutDZu7svzB9
   RgkWvFi9dCcOuprYsEku/ob/N6x6fte+n+Qy/dnqCartZ2uI04iEkHALz
   /dQdOVb1tYZZ8gmw2VrJncMRrMeL3Fl3cp0JuWpHlXMSS/CMBbxVx2u0R
   fYWptW7N3vSW1CX5MA62kSeVsNMU4msiLY/1IlSzUHq9+vpYf2TiMEVG6
   qNB12DNXI5f9DV4iSqiF09Iixz9hEzrXpJdRL0L1QFC7fiGj61Rt86lIl
   g==;
X-CSE-ConnectionGUID: rRmaxxE4QVy9yLTVPlZk+A==
X-CSE-MsgGUID: ovxLT1kXRZaSql5ox3PxtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496379"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496379"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:01:20 -0700
X-CSE-ConnectionGUID: LxjevcRPQD+fhEbi8zGBWw==
X-CSE-MsgGUID: GRVwHIQdQZKqnA4ha5GhOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662114"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:01:15 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Pu Wen <puwen@hygon.cn>,
	Tao Su <tao1.su@intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH v2 12/18] i386/cpu: Add legacy_amd_cache_info cache model
Date: Fri, 11 Jul 2025 18:21:37 +0800
Message-Id: <20250711102143.1622339-13-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250711102143.1622339-1-zhao1.liu@intel.com>
References: <20250711102143.1622339-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Based on legacy_l1d_cachei_amd, legacy_l1i_cache_amd, legacy_l2_cache_amd
and legacy_l3_cache, build a complete legacy AMD cache model, which can
clarify the purpose of these trivial legacy cache models, simplify the
initialization of cache info in X86CPUState, and make it easier to
handle compatibility later.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 112 ++++++++++++++++++++++------------------------
 1 file changed, 53 insertions(+), 59 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6cd942f95779..4a0505004bfb 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -638,60 +638,58 @@ static void encode_topo_cpuid8000001e(X86CPU *cpu, X86CPUTopoInfo *topo_info,
  * These are legacy cache values. If there is a need to change any
  * of these values please use builtin_x86_defs
  */
-static CPUCacheInfo legacy_l1d_cache_amd = {
-    .type = DATA_CACHE,
-    .level = 1,
-    .size = 64 * KiB,
-    .self_init = 1,
-    .line_size = 64,
-    .associativity = 2,
-    .sets = 512,
-    .partitions = 1,
-    .lines_per_tag = 1,
-    .no_invd_sharing = true,
-    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
-};
-
-static CPUCacheInfo legacy_l1i_cache_amd = {
-    .type = INSTRUCTION_CACHE,
-    .level = 1,
-    .size = 64 * KiB,
-    .self_init = 1,
-    .line_size = 64,
-    .associativity = 2,
-    .sets = 512,
-    .partitions = 1,
-    .lines_per_tag = 1,
-    .no_invd_sharing = true,
-    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
-};
-
-static CPUCacheInfo legacy_l2_cache_amd = {
-    .type = UNIFIED_CACHE,
-    .level = 2,
-    .size = 512 * KiB,
-    .line_size = 64,
-    .lines_per_tag = 1,
-    .associativity = 16,
-    .sets = 512,
-    .partitions = 1,
-    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
-};
-
-/* Level 3 unified cache: */
-static CPUCacheInfo legacy_l3_cache = {
-    .type = UNIFIED_CACHE,
-    .level = 3,
-    .size = 16 * MiB,
-    .line_size = 64,
-    .associativity = 16,
-    .sets = 16384,
-    .partitions = 1,
-    .lines_per_tag = 1,
-    .self_init = true,
-    .inclusive = true,
-    .complex_indexing = true,
-    .share_level = CPU_TOPOLOGY_LEVEL_DIE,
+static const CPUCaches legacy_amd_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        .type = DATA_CACHE,
+        .level = 1,
+        .size = 64 * KiB,
+        .self_init = 1,
+        .line_size = 64,
+        .associativity = 2,
+        .sets = 512,
+        .partitions = 1,
+        .lines_per_tag = 1,
+        .no_invd_sharing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l1i_cache = &(CPUCacheInfo) {
+        .type = INSTRUCTION_CACHE,
+        .level = 1,
+        .size = 64 * KiB,
+        .self_init = 1,
+        .line_size = 64,
+        .associativity = 2,
+        .sets = 512,
+        .partitions = 1,
+        .lines_per_tag = 1,
+        .no_invd_sharing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l2_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 2,
+        .size = 512 * KiB,
+        .line_size = 64,
+        .lines_per_tag = 1,
+        .associativity = 16,
+        .sets = 512,
+        .partitions = 1,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l3_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 3,
+        .size = 16 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .sets = 16384,
+        .partitions = 1,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .inclusive = true,
+        .complex_indexing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
+    },
 };
 
 /*
@@ -8991,11 +8989,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
         }
 
         env->cache_info_cpuid4 = legacy_intel_cache_info;
-
-        env->cache_info_amd.l1d_cache = &legacy_l1d_cache_amd;
-        env->cache_info_amd.l1i_cache = &legacy_l1i_cache_amd;
-        env->cache_info_amd.l2_cache = &legacy_l2_cache_amd;
-        env->cache_info_amd.l3_cache = &legacy_l3_cache;
+        env->cache_info_amd = legacy_amd_cache_info;
     }
 
 #ifndef CONFIG_USER_ONLY
-- 
2.34.1


