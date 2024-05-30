Return-Path: <kvm+bounces-18383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4628D4913
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 12:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 568851F2482A
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 10:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29879176AAA;
	Thu, 30 May 2024 10:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LsvaZVh1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606701761AD
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 10:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717063243; cv=none; b=NIgBFQAm/h7tKZnQmlf8ZeToJBcO4Ai5yNO/6JD91pPINiF1xkfCs/lXGVyDyE/S6RR2fGEjKDBfEhccGGsji/pUvR3mUUCumAWYQgnqUOPTBviptbC32K0MzdDyxvvdCjfF3xBhIFTU1PtilldaL+OmDvMCdNOeBzFf+SyqJpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717063243; c=relaxed/simple;
	bh=DM8SHXAESp5cUPfmMy9YxorSHMNJrW8VYCNoamCx3L0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=trpRpi7eutV3Olu8ejZDII8s/JcXh55z3yXERcLc0/P3vCRDupIWnYTzLZGYUG47RfQQfPgTSCagtc85Y1xZOYfilH/V5phAn58IXf8ythdYqq7v5zK6Wc+/lIHebOATKvl9wAnL3PnVzKxwSGm50lfnb3iWd6IW4S4VF1zr7RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LsvaZVh1; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717063242; x=1748599242;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DM8SHXAESp5cUPfmMy9YxorSHMNJrW8VYCNoamCx3L0=;
  b=LsvaZVh1O0VnlSFp76CTi4I9T+GsBFDtj4CyJ99fidLDUp60bGuYD1g6
   g+zZT5IO0O1lgWzi3KlISeEI+6JXPyXyhBPKE192Q0e7JKKHCiEn4rMOs
   W3r54ExEyf340xxHwjKuybhVx9hqkrvnekEqDqqr6KtgEK1oLYzMVwP3e
   ypRl4AJBVBvBBleQdLafr73HVUSzD1k6/6mroTxmseB1NkQRAHZqK+7v0
   pzvEq/NxXjQdKf2v8d3egXQeR34M1+RfX7/GV5JWV/03XtOcF2orw4knj
   tAECAyrcBUhmc0zXwlPrXR1dxvquZi2S9ClthM2es2wjvKmU2ACEg31wS
   w==;
X-CSE-ConnectionGUID: 9C7dSUjPRUW3iMtvvYRKCA==
X-CSE-MsgGUID: pfSetHCDQRWr4DjqQ92U9Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="31032465"
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="31032465"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 03:00:41 -0700
X-CSE-ConnectionGUID: /NjwT4NcRqGZr2YKdyF1wQ==
X-CSE-MsgGUID: t6VNuZuoRAKAcrDirpQULA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="35705049"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 30 May 2024 03:00:36 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 3/7] hw/core: Add cache topology options in -smp
Date: Thu, 30 May 2024 18:15:35 +0800
Message-Id: <20240530101539.768484-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530101539.768484-1-zhao1.liu@intel.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add "l1d-cache", "l1i-cache". "l2-cache", and "l3-cache" options in
-smp to define the cache topology for SMP system.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since RFC v1:
 * Set has_*_cache field in machine_get_smp(). (JeeHeng)
 * Adjust string breaking style in error_setg() for more semantic
   sentence breaking conventions. (Jonathan)
 * Add more description about cache options. (Markus)
 * Now in v2, config->*_cache field stores topology enumeration instead
   of string, no need to parse, so just make machine_check_cache_topo()
   return boolean.
---
 hw/core/machine-smp.c  | 146 +++++++++++++++++++++++++++++++++++++++++
 hw/core/machine.c      |  20 ++++++
 qapi/machine.json      |  23 ++++++-
 system/vl.c            |  12 ++++
 tests/unit/meson.build |   3 +-
 5 files changed, 202 insertions(+), 2 deletions(-)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index 5d8d7edcbd3f..c79464cf3d2c 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -61,6 +61,150 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
     return g_string_free(s, false);
 }
 
+static bool machine_check_topo_support(MachineState *ms,
+                                       CPUTopoLevel topo)
+{
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+
+    if (topo == CPU_TOPO_LEVEL_MODULE && !mc->smp_props.modules_supported) {
+        return false;
+    }
+
+    if (topo == CPU_TOPO_LEVEL_CLUSTER && !mc->smp_props.clusters_supported) {
+        return false;
+    }
+
+    if (topo == CPU_TOPO_LEVEL_DIE && !mc->smp_props.dies_supported) {
+        return false;
+    }
+
+    if (topo == CPU_TOPO_LEVEL_BOOK && !mc->smp_props.books_supported) {
+        return false;
+    }
+
+    if (topo == CPU_TOPO_LEVEL_DRAWER && !mc->smp_props.drawers_supported) {
+        return false;
+    }
+
+    return true;
+}
+
+static bool machine_check_cache_topo(MachineState *ms,
+                                     CPUTopoLevel topo,
+                                     Error **errp)
+{
+    if (topo == CPU_TOPO_LEVEL__MAX || topo == CPU_TOPO_LEVEL_INVALID) {
+        error_setg(errp,
+                   "Invalid cache topology level: %s. "
+                   "The cache topology should match the "
+                   "valid CPU topology level",
+                   cpu_topo_to_string(topo));
+        return false;
+    }
+
+    if (!machine_check_topo_support(ms, topo)) {
+        error_setg(errp,
+                   "Invalid cache topology level: %s. "
+                   "The topology level is not supported by this machine",
+                   cpu_topo_to_string(topo));
+        return false;
+    }
+
+    return true;
+}
+
+static void machine_parse_smp_cache_config(MachineState *ms,
+                                           const SMPConfiguration *config,
+                                           Error **errp)
+{
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+
+    /*
+     * The cache topology does not support a default entry similar to
+     * CPU topology with parameters=1. So when the machine explicitly
+     * does not support cache topology, return the error.
+     */
+    if (config->has_l1d_cache) {
+        if (!mc->smp_props.l1_separated_cache_supported) {
+            error_setg(errp,
+                       "L1 D-cache topology not supported by this machine");
+            return;
+        }
+
+        if (!machine_check_cache_topo(ms, config->l1d_cache, errp)) {
+            return;
+        }
+
+        ms->smp_cache.l1d = config->l1d_cache;
+    }
+
+    if (config->has_l1i_cache) {
+        if (!mc->smp_props.l1_separated_cache_supported) {
+            error_setg(errp,
+                       "L1 I-cache topology not supported by this machine");
+            return;
+        }
+
+        if (!machine_check_cache_topo(ms, config->l1i_cache, errp)) {
+            return;
+        }
+
+        ms->smp_cache.l1i = config->l1i_cache;
+    }
+
+    if (config->has_l2_cache) {
+        if (!mc->smp_props.l2_unified_cache_supported) {
+            error_setg(errp,
+                       "L2 cache topology not supported by this machine");
+            return;
+        }
+
+        if (!machine_check_cache_topo(ms, config->l2_cache, errp)) {
+            return;
+        }
+
+        ms->smp_cache.l2 = config->l2_cache;
+
+        /*
+         * Cache topology is initialized by default to CPU_TOPO_LEVEL_INVALID,
+         * which is the lowest level, so such a check is OK, even if the config
+         * doesn't override that field.
+         */
+        if (ms->smp_cache.l1d > ms->smp_cache.l2 ||
+            ms->smp_cache.l1i > ms->smp_cache.l2) {
+            error_setg(errp,
+                       "Invalid L2 cache topology. "
+                       "L2 cache topology level should not be lower than "
+                       "L1 D-cache/L1 I-cache");
+            return;
+        }
+    }
+
+    if (config->has_l3_cache) {
+        if (!mc->smp_props.l2_unified_cache_supported) {
+            error_setg(errp,
+                       "L3 cache topology not supported by this machine");
+            return;
+        }
+
+        if (!machine_check_cache_topo(ms, config->l3_cache, errp)) {
+            return;
+        }
+
+        ms->smp_cache.l3 = config->l3_cache;
+
+        if (ms->smp_cache.l1d > ms->smp_cache.l3 ||
+            ms->smp_cache.l1i > ms->smp_cache.l3 ||
+            ms->smp_cache.l2 > ms->smp_cache.l3) {
+            error_setg(errp,
+                       "Invalid L3 cache topology. "
+                       "L3 cache topology level should not be lower than "
+                       "L1 D-cache/L1 I-cache/L2 cache");
+            return;
+        }
+    }
+}
+
 /*
  * machine_parse_smp_config: Generic function used to parse the given
  *                           SMP configuration
@@ -259,6 +403,8 @@ void machine_parse_smp_config(MachineState *ms,
                    mc->name, mc->max_cpus);
         return;
     }
+
+    machine_parse_smp_cache_config(ms, config, errp);
 }
 
 unsigned int machine_topo_get_cores_per_socket(const MachineState *ms)
diff --git a/hw/core/machine.c b/hw/core/machine.c
index e31d0f3cb4b0..f705485f83c0 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -900,6 +900,26 @@ static void machine_get_smp(Object *obj, Visitor *v, const char *name,
         .has_maxcpus = true, .maxcpus = ms->smp.max_cpus,
     };
 
+    if (ms->smp_cache.l1d != CPU_TOPO_LEVEL_INVALID) {
+        config->has_l1d_cache = true;
+        config->l1d_cache = ms->smp_cache.l1d;
+    }
+
+    if (ms->smp_cache.l1i != CPU_TOPO_LEVEL_INVALID) {
+        config->has_l1i_cache = true;
+        config->l1i_cache = ms->smp_cache.l1i;
+    }
+
+    if (ms->smp_cache.l2 != CPU_TOPO_LEVEL_INVALID) {
+        config->has_l2_cache = true;
+        config->l2_cache = ms->smp_cache.l2;
+    }
+
+    if (ms->smp_cache.l3 != CPU_TOPO_LEVEL_INVALID) {
+        config->has_l3_cache = true;
+        config->l3_cache = ms->smp_cache.l3;
+    }
+
     if (!visit_type_SMPConfiguration(v, name, &config, &error_abort)) {
         return;
     }
diff --git a/qapi/machine.json b/qapi/machine.json
index 7ac5a05bb9c9..8fa5af69b1bf 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -1746,6 +1746,23 @@
 #
 # @threads: number of threads per core
 #
+# @l1d-cache: topology hierarchy of L1 data cache. It accepts the CPU
+#     topology enumeration as the parameter, i.e., CPUs in the same
+#     topology container share the same L1 data cache. (since 9.1)
+#
+# @l1i-cache: topology hierarchy of L1 instruction cache. It accepts
+#     the CPU topology enumeration as the parameter, i.e., CPUs in the
+#     same topology container share the same L1 instruction cache.
+#     (since 9.1)
+#
+# @l2-cache: topology hierarchy of L2 unified cache. It accepts the CPU
+#     topology enumeration as the parameter, i.e., CPUs in the same
+#     topology container share the same L2 unified cache. (since 9.1)
+#
+# @l3-cache: topology hierarchy of L3 unified cache. It accepts the CPU
+#     topology enumeration as the parameter, i.e., CPUs in the same
+#     topology container share the same L3 unified cache. (since 9.1)
+#
 # Since: 6.1
 ##
 { 'struct': 'SMPConfiguration', 'data': {
@@ -1758,7 +1775,11 @@
      '*modules': 'int',
      '*cores': 'int',
      '*threads': 'int',
-     '*maxcpus': 'int' } }
+     '*maxcpus': 'int',
+     '*l1d-cache': 'CPUTopoLevel',
+     '*l1i-cache': 'CPUTopoLevel',
+     '*l2-cache': 'CPUTopoLevel',
+     '*l3-cache': 'CPUTopoLevel' } }
 
 ##
 # @x-query-irq:
diff --git a/system/vl.c b/system/vl.c
index a3eede5fa5b8..c7c94d41bd01 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -753,6 +753,18 @@ static QemuOptsList qemu_smp_opts = {
         }, {
             .name = "maxcpus",
             .type = QEMU_OPT_NUMBER,
+        }, {
+            .name = "l1d-cache",
+            .type = QEMU_OPT_STRING,
+        }, {
+            .name = "l1i-cache",
+            .type = QEMU_OPT_STRING,
+        }, {
+            .name = "l2-cache",
+            .type = QEMU_OPT_STRING,
+        }, {
+            .name = "l3-cache",
+            .type = QEMU_OPT_STRING,
         },
         { /*End of list */ }
     },
diff --git a/tests/unit/meson.build b/tests/unit/meson.build
index 26c109c968ce..8877dbbc00c9 100644
--- a/tests/unit/meson.build
+++ b/tests/unit/meson.build
@@ -138,7 +138,8 @@ if have_system
     'test-util-sockets': ['socket-helpers.c'],
     'test-base64': [],
     'test-bufferiszero': [],
-    'test-smp-parse': [qom, meson.project_source_root() / 'hw/core/machine-smp.c'],
+    'test-smp-parse': [qom, meson.project_source_root() / 'hw/core/machine-smp.c',
+                       meson.project_source_root() / 'hw/core/cpu-topology.c'],
     'test-vmstate': [migration, io],
     'test-yank': ['socket-helpers.c', qom, io, chardev]
   }
-- 
2.34.1


