Return-Path: <kvm+bounces-9157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 469CF85B6F5
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:16:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D9F81F254F8
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06E655FDB0;
	Tue, 20 Feb 2024 09:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lj7sKMtJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A10365BA6
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 09:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708420328; cv=none; b=rBugqlTHBE2RksU5nxg90QvcYmJqHi0lYgec2nEBUaJyu6mxrqtQobf5UH7ZmHPfhOAcYwiHhOpkeM1uJBW4EuQ8oiCYYCDHm9Vv6RLy0AXpob+h1mOL5+Ht1hkjVjtaNSWyp3eVILOmcJfCRaY+QiY9z6vM6waHoUdNtckVsYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708420328; c=relaxed/simple;
	bh=eqNjZBlNcC8WFXOhViSe+F312lyqzht+4UXK0ymAVGc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bpPRGI/a8YFPdpEsEb5TTHoPaQMURqDBFotBO5GNdWctkInHEfejCV2APutlpgZBAD8lFIhGmZtwkM8FxGsR+9e6fXGjb84iQHCK6EMXt6abQIGEqTJI5T3V6jtUcOhqfdxjYg74W2PQcnYPHQ9/Id2nsJO4Ht++TLdQ/o/spqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lj7sKMtJ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708420327; x=1739956327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eqNjZBlNcC8WFXOhViSe+F312lyqzht+4UXK0ymAVGc=;
  b=lj7sKMtJ7BaisgBl/yI2KcxKLapcXb9GVSZtT4HWzK1RlOt2x8ThaXEb
   M62aZLf9Neu+Sabu2yRPEKOZyB8uf9sVGsky8Zs+W5v5wS0QqXr+fwJiX
   /3sBRABFwfkHC5zuGJJ4eOLj6Ne6o3WnDajPJHlMjPX6l/hmcAXuIJ7z5
   wLo79RjKBNsXkwS0yNuEfly+bnwTF2XSw4NQZCkdxY3q+aQAhkNtRZ1NF
   cnmhWBa9bpvhg9DZ0nFDFH57ybMnqxtPFdw/Y5dPIfl8qA3Jd+gmhnBnx
   AT+S8bzxuzwuYPLHpmoCDgroU0FNld4AgBApnMS+5q1Py1xRIR/XGygUo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2374990"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="2374990"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 01:12:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="5012989"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 20 Feb 2024 01:12:01 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
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
Subject: [RFC 4/8] hw/core: Add cache topology options in -smp
Date: Tue, 20 Feb 2024 17:25:00 +0800
Message-Id: <20240220092504.726064-5-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Add "l1d-cache", "l1i-cache". "l2-cache", and "l3-cache" options in
-smp to define the cache topology for SMP system.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/machine-smp.c | 128 ++++++++++++++++++++++++++++++++++++++++++
 hw/core/machine.c     |   4 ++
 qapi/machine.json     |  14 ++++-
 system/vl.c           |  15 +++++
 4 files changed, 160 insertions(+), 1 deletion(-)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index 8a8296b0d05b..2cbd19f4aa57 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -61,6 +61,132 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
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
+static int smp_cache_string_to_topology(MachineState *ms,
+                                        char *topo_str,
+                                        CPUTopoLevel *topo,
+                                        Error **errp)
+{
+    *topo = string_to_cpu_topo(topo_str);
+
+    if (*topo == CPU_TOPO_LEVEL_MAX || *topo == CPU_TOPO_LEVEL_INVALID) {
+        error_setg(errp, "Invalid cache topology level: %s. The cache "
+                   "topology should match the CPU topology level", topo_str);
+        return -1;
+    }
+
+    if (!machine_check_topo_support(ms, *topo)) {
+        error_setg(errp, "Invalid cache topology level: %s. The topology "
+                   "level is not supported by this machine", topo_str);
+        return -1;
+    }
+
+    return 0;
+}
+
+static void machine_parse_smp_cache_config(MachineState *ms,
+                                           const SMPConfiguration *config,
+                                           Error **errp)
+{
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+
+    if (config->l1d_cache) {
+        if (!mc->smp_props.l1_separated_cache_supported) {
+            error_setg(errp, "L1 D-cache topology not "
+                       "supported by this machine");
+            return;
+        }
+
+        if (smp_cache_string_to_topology(ms, config->l1d_cache,
+            &ms->smp_cache.l1d, errp)) {
+            return;
+        }
+    }
+
+    if (config->l1i_cache) {
+        if (!mc->smp_props.l1_separated_cache_supported) {
+            error_setg(errp, "L1 I-cache topology not "
+                       "supported by this machine");
+            return;
+        }
+
+        if (smp_cache_string_to_topology(ms, config->l1i_cache,
+            &ms->smp_cache.l1i, errp)) {
+            return;
+        }
+    }
+
+    if (config->l2_cache) {
+        if (!mc->smp_props.l2_unified_cache_supported) {
+            error_setg(errp, "L2 cache topology not "
+                       "supported by this machine");
+            return;
+        }
+
+        if (smp_cache_string_to_topology(ms, config->l2_cache,
+            &ms->smp_cache.l2, errp)) {
+            return;
+        }
+
+        if (ms->smp_cache.l1d > ms->smp_cache.l2 ||
+            ms->smp_cache.l1i > ms->smp_cache.l2) {
+            error_setg(errp, "Invalid L2 cache topology. "
+                       "L2 cache topology level should not be "
+                       "lower than L1 D-cache/L1 I-cache");
+            return;
+        }
+    }
+
+    if (config->l3_cache) {
+        if (!mc->smp_props.l2_unified_cache_supported) {
+            error_setg(errp, "L3 cache topology not "
+                       "supported by this machine");
+            return;
+        }
+
+        if (smp_cache_string_to_topology(ms, config->l3_cache,
+            &ms->smp_cache.l3, errp)) {
+            return;
+        }
+
+        if (ms->smp_cache.l1d > ms->smp_cache.l3 ||
+            ms->smp_cache.l1i > ms->smp_cache.l3 ||
+            ms->smp_cache.l2 > ms->smp_cache.l3) {
+            error_setg(errp, "Invalid L3 cache topology. "
+                       "L3 cache topology level should not be "
+                       "lower than L1 D-cache/L1 I-cache/L2 cache");
+            return;
+        }
+    }
+}
+
 /*
  * machine_parse_smp_config: Generic function used to parse the given
  *                           SMP configuration
@@ -249,6 +375,8 @@ void machine_parse_smp_config(MachineState *ms,
                    mc->name, mc->max_cpus);
         return;
     }
+
+    machine_parse_smp_cache_config(ms, config, errp);
 }
 
 unsigned int machine_topo_get_cores_per_socket(const MachineState *ms)
diff --git a/hw/core/machine.c b/hw/core/machine.c
index 426f71770a84..cb5173927b0d 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -886,6 +886,10 @@ static void machine_get_smp(Object *obj, Visitor *v, const char *name,
         .has_cores = true, .cores = ms->smp.cores,
         .has_threads = true, .threads = ms->smp.threads,
         .has_maxcpus = true, .maxcpus = ms->smp.max_cpus,
+        .l1d_cache = g_strdup(cpu_topo_to_string(ms->smp_cache.l1d)),
+        .l1i_cache = g_strdup(cpu_topo_to_string(ms->smp_cache.l1i)),
+        .l2_cache = g_strdup(cpu_topo_to_string(ms->smp_cache.l2)),
+        .l3_cache = g_strdup(cpu_topo_to_string(ms->smp_cache.l3)),
     };
 
     if (!visit_type_SMPConfiguration(v, name, &config, &error_abort)) {
diff --git a/qapi/machine.json b/qapi/machine.json
index d0e7f1f615f3..0a923ac38803 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -1650,6 +1650,14 @@
 #
 # @threads: number of threads per core
 #
+# @l1d-cache: topology hierarchy of L1 data cache (since 9.0)
+#
+# @l1i-cache: topology hierarchy of L1 instruction cache (since 9.0)
+#
+# @l2-cache: topology hierarchy of L2 unified cache (since 9.0)
+#
+# @l3-cache: topology hierarchy of L3 unified cache (since 9.0)
+#
 # Since: 6.1
 ##
 { 'struct': 'SMPConfiguration', 'data': {
@@ -1662,7 +1670,11 @@
      '*modules': 'int',
      '*cores': 'int',
      '*threads': 'int',
-     '*maxcpus': 'int' } }
+     '*maxcpus': 'int',
+     '*l1d-cache': 'str',
+     '*l1i-cache': 'str',
+     '*l2-cache': 'str',
+     '*l3-cache': 'str' } }
 
 ##
 # @x-query-irq:
diff --git a/system/vl.c b/system/vl.c
index a82555ae1558..ac95e5ddb656 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -741,6 +741,9 @@ static QemuOptsList qemu_smp_opts = {
         }, {
             .name = "clusters",
             .type = QEMU_OPT_NUMBER,
+        }, {
+            .name = "modules",
+            .type = QEMU_OPT_NUMBER,
         }, {
             .name = "cores",
             .type = QEMU_OPT_NUMBER,
@@ -750,6 +753,18 @@ static QemuOptsList qemu_smp_opts = {
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
-- 
2.34.1


