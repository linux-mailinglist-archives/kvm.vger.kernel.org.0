Return-Path: <kvm+bounces-7571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 709DE843BB7
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 11:02:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAACE1F2CA7E
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C0D56996E;
	Wed, 31 Jan 2024 10:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DTiJsGwX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9206773D
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 10:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706695302; cv=none; b=eIiC0eU/JZ82v+GLQWVwnt902CGuejWBPJzlfGSfyIDD+7AnrgFq31neNxKzrSJiaIczhNC2/2QJ5J0nRuyJxqItbAppu9cF2M+Epp0UBLacrtuD8XKRTLRuXuATS8L4islnCqJSV9twi6Y7ZpohqOpei3hh56rUNtKWNhVXanU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706695302; c=relaxed/simple;
	bh=8ItWfszIdE606/gOBvk0DdLoS+CDP3rDvMWP1Br53Z4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ri/FtB2lwQ56fssMjXbgUZultnBsTDDgz4mpz9p1t00sMpp3dzaFGafvY0mV5VG2vW1KslFx710Mpkc9e7EHfTF9Lps2xtDdfqfMCEwfE2+KLOcp3UZ41BjNhD2iEGZ1nD3JGJzDbTzeMX2yTNv1iNJuBtPVLAqHdE38801WjT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DTiJsGwX; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706695300; x=1738231300;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8ItWfszIdE606/gOBvk0DdLoS+CDP3rDvMWP1Br53Z4=;
  b=DTiJsGwXw41D53klI/c+IKrx1TCmZ7l//wBRHUoMO4kebqJJ6ji3h4rb
   GfCRUvd60QV4hWvrBXtHV92j1/IlbtkXsjI1mz5gNvBha0ZEeJMaYPFlA
   KuU2CzpYNninpNWkRHBaVzpSkcHEpAqH1Pb3XDmxW4gSS2XvrDXPORZVT
   ZB2T2v29ygtKW+PVyIJHAGQMeTubnMF+PYSVFeyA2syGT5GVYt72aLcRS
   RUx9vhGUkOOLNqkJ0M4bo/ns+P3AO+9wlOEK0JRfqPAOlI7h5XGCd9imK
   kGYcoRN9ke2fFVDt/kL2VHZfpKCg1Ivy6FRZ3iVyZJVUDX/XIt71gxNCD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="25032876"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="25032876"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 02:01:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="4036145"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 31 Jan 2024 02:01:34 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Babu Moger <babu.moger@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v8 13/21] i386: Support modules_per_die in X86CPUTopoInfo
Date: Wed, 31 Jan 2024 18:13:42 +0800
Message-Id: <20240131101350.109512-14-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
References: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Support module level in i386 cpu topology structure "X86CPUTopoInfo".

Since x86 does not yet support the "modules" parameter in "-smp",
X86CPUTopoInfo.modules_per_die is currently always 1.

Therefore, the module level width in APIC ID, which can be calculated by
"apicid_bitwidth_for_count(topo_info->modules_per_die)", is always 0 for
now, so we can directly add APIC ID related helpers to support module
level parsing.

In addition, update topology structure in test-x86-topo.c.

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v7:
 * Mapped x86 module to smp module instead of cluster.
 * Dropped Michael/Babu's ACKed/Tested tags since the code change.
 * Re-added Yongwei's Tested tag For his re-testing.

Changes since v3:
 * Droped the description about not exposing module level in commit
   message.
 * Updated topology related calculation in newly added helpers:
   num_cpus_by_topo_level() and apicid_offset_by_topo_level().

Changes since v1:
 * Included module level related helpers (apicid_module_width() and
   apicid_module_offset()) in this patch. (Yanan)
---
 hw/i386/x86.c              |  9 +++++++-
 include/hw/i386/topology.h | 22 +++++++++++++++----
 target/i386/cpu.c          | 13 ++++++-----
 tests/unit/test-x86-topo.c | 45 ++++++++++++++++++++------------------
 4 files changed, 58 insertions(+), 31 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 2ead995b0197..9d41bc2824e3 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -72,7 +72,14 @@ static void init_topo_info(X86CPUTopoInfo *topo_info,
     MachineState *ms = MACHINE(x86ms);
 
     topo_info->dies_per_pkg = ms->smp.dies;
-    topo_info->cores_per_die = ms->smp.cores;
+    /*
+     * Though smp.modules means the number of modules in one cluster,
+     * i386 doesn't support cluster level so that the smp.clusters
+     * always defaults to 1, therefore using smp.modules directly is
+     * fine here.
+     */
+    topo_info->modules_per_die = ms->smp.modules;
+    topo_info->cores_per_module = ms->smp.cores;
     topo_info->threads_per_core = ms->smp.threads;
 }
 
diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
index befeb92b0b19..7622d806932c 100644
--- a/include/hw/i386/topology.h
+++ b/include/hw/i386/topology.h
@@ -56,7 +56,8 @@ typedef struct X86CPUTopoIDs {
 
 typedef struct X86CPUTopoInfo {
     unsigned dies_per_pkg;
-    unsigned cores_per_die;
+    unsigned modules_per_die;
+    unsigned cores_per_module;
     unsigned threads_per_core;
 } X86CPUTopoInfo;
 
@@ -92,7 +93,13 @@ static inline unsigned apicid_smt_width(X86CPUTopoInfo *topo_info)
 /* Bit width of the Core_ID field */
 static inline unsigned apicid_core_width(X86CPUTopoInfo *topo_info)
 {
-    return apicid_bitwidth_for_count(topo_info->cores_per_die);
+    return apicid_bitwidth_for_count(topo_info->cores_per_module);
+}
+
+/* Bit width of the Module_ID field */
+static inline unsigned apicid_module_width(X86CPUTopoInfo *topo_info)
+{
+    return apicid_bitwidth_for_count(topo_info->modules_per_die);
 }
 
 /* Bit width of the Die_ID field */
@@ -107,10 +114,16 @@ static inline unsigned apicid_core_offset(X86CPUTopoInfo *topo_info)
     return apicid_smt_width(topo_info);
 }
 
+/* Bit offset of the Module_ID field */
+static inline unsigned apicid_module_offset(X86CPUTopoInfo *topo_info)
+{
+    return apicid_core_offset(topo_info) + apicid_core_width(topo_info);
+}
+
 /* Bit offset of the Die_ID field */
 static inline unsigned apicid_die_offset(X86CPUTopoInfo *topo_info)
 {
-    return apicid_core_offset(topo_info) + apicid_core_width(topo_info);
+    return apicid_module_offset(topo_info) + apicid_module_width(topo_info);
 }
 
 /* Bit offset of the Pkg_ID (socket ID) field */
@@ -142,7 +155,8 @@ static inline void x86_topo_ids_from_idx(X86CPUTopoInfo *topo_info,
                                          X86CPUTopoIDs *topo_ids)
 {
     unsigned nr_dies = topo_info->dies_per_pkg;
-    unsigned nr_cores = topo_info->cores_per_die;
+    unsigned nr_cores = topo_info->cores_per_module *
+                        topo_info->modules_per_die;
     unsigned nr_threads = topo_info->threads_per_core;
 
     topo_ids->pkg_id = cpu_index / (nr_dies * nr_cores * nr_threads);
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index f1a0aa77a873..a5a1411285c0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -278,10 +278,11 @@ static uint32_t num_threads_by_topo_level(X86CPUTopoInfo *topo_info,
     case CPU_TOPO_LEVEL_CORE:
         return topo_info->threads_per_core;
     case CPU_TOPO_LEVEL_DIE:
-        return topo_info->threads_per_core * topo_info->cores_per_die;
+        return topo_info->threads_per_core * topo_info->cores_per_module *
+               topo_info->modules_per_die;
     case CPU_TOPO_LEVEL_PACKAGE:
-        return topo_info->threads_per_core * topo_info->cores_per_die *
-               topo_info->dies_per_pkg;
+        return topo_info->threads_per_core * topo_info->cores_per_module *
+               topo_info->modules_per_die * topo_info->dies_per_pkg;
     default:
         g_assert_not_reached();
     }
@@ -6132,10 +6133,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
     uint32_t threads_per_pkg;
 
     topo_info.dies_per_pkg = env->nr_dies;
-    topo_info.cores_per_die = cs->nr_cores / env->nr_dies;
+    topo_info.modules_per_die = env->nr_modules;
+    topo_info.cores_per_module = cs->nr_cores / env->nr_dies / env->nr_modules;
     topo_info.threads_per_core = cs->nr_threads;
 
-    cores_per_pkg = topo_info.cores_per_die * topo_info.dies_per_pkg;
+    cores_per_pkg = topo_info.cores_per_module * topo_info.modules_per_die *
+                    topo_info.dies_per_pkg;
     threads_per_pkg = cores_per_pkg * topo_info.threads_per_core;
 
     /* Calculate & apply limits for different index ranges */
diff --git a/tests/unit/test-x86-topo.c b/tests/unit/test-x86-topo.c
index 2b104f86d7c2..f21b8a5d95c2 100644
--- a/tests/unit/test-x86-topo.c
+++ b/tests/unit/test-x86-topo.c
@@ -30,13 +30,16 @@ static void test_topo_bits(void)
 {
     X86CPUTopoInfo topo_info = {0};
 
-    /* simple tests for 1 thread per core, 1 core per die, 1 die per package */
-    topo_info = (X86CPUTopoInfo) {1, 1, 1};
+    /*
+     * simple tests for 1 thread per core, 1 core per module,
+     *                  1 module per die, 1 die per package
+     */
+    topo_info = (X86CPUTopoInfo) {1, 1, 1, 1};
     g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 0);
     g_assert_cmpuint(apicid_core_width(&topo_info), ==, 0);
     g_assert_cmpuint(apicid_die_width(&topo_info), ==, 0);
 
-    topo_info = (X86CPUTopoInfo) {1, 1, 1};
+    topo_info = (X86CPUTopoInfo) {1, 1, 1, 1};
     g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 0), ==, 0);
     g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 1), ==, 1);
     g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 2), ==, 2);
@@ -45,39 +48,39 @@ static void test_topo_bits(void)
 
     /* Test field width calculation for multiple values
      */
-    topo_info = (X86CPUTopoInfo) {1, 1, 2};
+    topo_info = (X86CPUTopoInfo) {1, 1, 1, 2};
     g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 1);
-    topo_info = (X86CPUTopoInfo) {1, 1, 3};
+    topo_info = (X86CPUTopoInfo) {1, 1, 1, 3};
     g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 2);
-    topo_info = (X86CPUTopoInfo) {1, 1, 4};
+    topo_info = (X86CPUTopoInfo) {1, 1, 1, 4};
     g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 2);
 
-    topo_info = (X86CPUTopoInfo) {1, 1, 14};
+    topo_info = (X86CPUTopoInfo) {1, 1, 1, 14};
     g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 4);
-    topo_info = (X86CPUTopoInfo) {1, 1, 15};
+    topo_info = (X86CPUTopoInfo) {1, 1, 1, 15};
     g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 4);
-    topo_info = (X86CPUTopoInfo) {1, 1, 16};
+    topo_info = (X86CPUTopoInfo) {1, 1, 1, 16};
     g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 4);
-    topo_info = (X86CPUTopoInfo) {1, 1, 17};
+    topo_info = (X86CPUTopoInfo) {1, 1, 1, 17};
     g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 5);
 
 
-    topo_info = (X86CPUTopoInfo) {1, 30, 2};
+    topo_info = (X86CPUTopoInfo) {1, 1, 30, 2};
     g_assert_cmpuint(apicid_core_width(&topo_info), ==, 5);
-    topo_info = (X86CPUTopoInfo) {1, 31, 2};
+    topo_info = (X86CPUTopoInfo) {1, 1, 31, 2};
     g_assert_cmpuint(apicid_core_width(&topo_info), ==, 5);
-    topo_info = (X86CPUTopoInfo) {1, 32, 2};
+    topo_info = (X86CPUTopoInfo) {1, 1, 32, 2};
     g_assert_cmpuint(apicid_core_width(&topo_info), ==, 5);
-    topo_info = (X86CPUTopoInfo) {1, 33, 2};
+    topo_info = (X86CPUTopoInfo) {1, 1, 33, 2};
     g_assert_cmpuint(apicid_core_width(&topo_info), ==, 6);
 
-    topo_info = (X86CPUTopoInfo) {1, 30, 2};
+    topo_info = (X86CPUTopoInfo) {1, 1, 30, 2};
     g_assert_cmpuint(apicid_die_width(&topo_info), ==, 0);
-    topo_info = (X86CPUTopoInfo) {2, 30, 2};
+    topo_info = (X86CPUTopoInfo) {2, 1, 30, 2};
     g_assert_cmpuint(apicid_die_width(&topo_info), ==, 1);
-    topo_info = (X86CPUTopoInfo) {3, 30, 2};
+    topo_info = (X86CPUTopoInfo) {3, 1, 30, 2};
     g_assert_cmpuint(apicid_die_width(&topo_info), ==, 2);
-    topo_info = (X86CPUTopoInfo) {4, 30, 2};
+    topo_info = (X86CPUTopoInfo) {4, 1, 30, 2};
     g_assert_cmpuint(apicid_die_width(&topo_info), ==, 2);
 
     /* build a weird topology and see if IDs are calculated correctly
@@ -85,18 +88,18 @@ static void test_topo_bits(void)
 
     /* This will use 2 bits for thread ID and 3 bits for core ID
      */
-    topo_info = (X86CPUTopoInfo) {1, 6, 3};
+    topo_info = (X86CPUTopoInfo) {1, 1, 6, 3};
     g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 2);
     g_assert_cmpuint(apicid_core_offset(&topo_info), ==, 2);
     g_assert_cmpuint(apicid_die_offset(&topo_info), ==, 5);
     g_assert_cmpuint(apicid_pkg_offset(&topo_info), ==, 5);
 
-    topo_info = (X86CPUTopoInfo) {1, 6, 3};
+    topo_info = (X86CPUTopoInfo) {1, 1, 6, 3};
     g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 0), ==, 0);
     g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 1), ==, 1);
     g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 2), ==, 2);
 
-    topo_info = (X86CPUTopoInfo) {1, 6, 3};
+    topo_info = (X86CPUTopoInfo) {1, 1, 6, 3};
     g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 1 * 3 + 0), ==,
                      (1 << 2) | 0);
     g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 1 * 3 + 1), ==,
-- 
2.34.1


