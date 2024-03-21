Return-Path: <kvm+bounces-12384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5578E885AA6
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:27:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BFFD282B74
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B27028527D;
	Thu, 21 Mar 2024 14:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KXKZeQNQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F387F84FD8
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031243; cv=none; b=Ti/k6hzoUxwMnYfIfqRIm+H1Xnu424aN6lcfNZI+nuTeEW4e/ob31jfQNBd4+vKhPwaYVBEARZJGofeuqedXOloIyiOYU5T5lB2X2UL8V+XdgAWGEQKkkOOqwwWTR4IzMt7edvCknuVyG0kbMQlJ9tNSR7H/bL+kk2RljqEqE2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031243; c=relaxed/simple;
	bh=lzFCM7hzDzVOEt2eiczVXmyNZngO0ts9zmWVhXGU1nY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q8beNoBpqNpGUfZXLuZHzk3w7L4edxfSfLt1HglE8EX6p7276W1SGU5wYisYuG51sawf/Yt/2I3mOqKinLYkJslMQVDhZr2pXLV+lpwK9uXxTmG3MO1xJR8NdpDW3FLl00lTt0x/+D/ELr8ROWvMaLHLRu9B1KkmTOY3tryZUOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KXKZeQNQ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031243; x=1742567243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lzFCM7hzDzVOEt2eiczVXmyNZngO0ts9zmWVhXGU1nY=;
  b=KXKZeQNQG9b3n6j243/PtA4Uqa5hU+GZlXW4RkA44+iE0SOZK7Mo6o/t
   ZqASdlDJAtR4Xp7mtO2yppNa1v2fJqFjtyl2aLMK/ZKPU9Knq2p2vTYMS
   FmfNuNktPACD3sFqrHznkrj+J5pAV4YyJBcuzvnMxYpaKmtK4oYujtixu
   U4trzlk8ssq5hqSiKktgOfg9QPlZvLJCawUqm0PAm3g2R0Sb7Pj+M7VcG
   W9iTgwxdYginJtlAKv/JUezQewiEcgpAeuPslxie9vfk3BHtlb0u9aA7o
   QtY96TXHdvBIqYswc3WaoxUWwvtxfevQquRxgOyBcHVp4cs0z+AHE70UX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806369"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806369"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:27:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14527816"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:27:17 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v10 02/21] hw/core/machine: Support modules in -smp
Date: Thu, 21 Mar 2024 22:40:29 +0800
Message-Id: <20240321144048.3699388-3-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
References: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Add "modules" parameter parsing support in -smp.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Acked-by: Markus Armbruster <armbru@redhat.com>
---
Changes since v9:
 * Rebased on the SMP changes about unsupported "parameter=1"
   configurations. (Philippe)
 * Fixed typo about topology field. (Dapeng)

Changes since v8:
 * Added module description in qemu_smp_opts.

Changes since v7:
 * New commit to introduce module level in -smp.
---
 hw/core/machine-smp.c | 39 +++++++++++++++++++++++++++++++++------
 hw/core/machine.c     |  1 +
 qapi/machine.json     |  3 +++
 system/vl.c           |  3 +++
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index 2e68fcfdfd79..2b93fa99c943 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -51,6 +51,10 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
         g_string_append_printf(s, " * clusters (%u)", ms->smp.clusters);
     }
 
+    if (mc->smp_props.modules_supported) {
+        g_string_append_printf(s, " * modules (%u)", ms->smp.modules);
+    }
+
     g_string_append_printf(s, " * cores (%u)", ms->smp.cores);
     g_string_append_printf(s, " * threads (%u)", ms->smp.threads);
 
@@ -88,6 +92,7 @@ void machine_parse_smp_config(MachineState *ms,
     unsigned sockets = config->has_sockets ? config->sockets : 0;
     unsigned dies    = config->has_dies ? config->dies : 0;
     unsigned clusters = config->has_clusters ? config->clusters : 0;
+    unsigned modules = config->has_modules ? config->modules : 0;
     unsigned cores   = config->has_cores ? config->cores : 0;
     unsigned threads = config->has_threads ? config->threads : 0;
     unsigned maxcpus = config->has_maxcpus ? config->maxcpus : 0;
@@ -103,6 +108,7 @@ void machine_parse_smp_config(MachineState *ms,
         (config->has_sockets && config->sockets == 0) ||
         (config->has_dies && config->dies == 0) ||
         (config->has_clusters && config->clusters == 0) ||
+        (config->has_modules && config->modules == 0) ||
         (config->has_cores && config->cores == 0) ||
         (config->has_threads && config->threads == 0) ||
         (config->has_maxcpus && config->maxcpus == 0)) {
@@ -115,6 +121,20 @@ void machine_parse_smp_config(MachineState *ms,
      * If not supported by the machine, a topology parameter must be
      * omitted.
      */
+    if (!mc->smp_props.modules_supported && config->has_modules) {
+        if (config->modules > 1) {
+            error_setg(errp, "modules not supported by this "
+                       "machine's CPU topology");
+            return;
+        } else {
+            /* Here modules only equals 1 since we've checked zero case. */
+            warn_report("Deprecated CPU topology (considered invalid): "
+                        "Unsupported modules parameter mustn't be "
+                        "specified as 1");
+        }
+    }
+    modules = modules > 0 ? modules : 1;
+
     if (!mc->smp_props.clusters_supported && config->has_clusters) {
         if (config->clusters > 1) {
             error_setg(errp, "clusters not supported by this "
@@ -185,11 +205,13 @@ void machine_parse_smp_config(MachineState *ms,
                 cores = cores > 0 ? cores : 1;
                 threads = threads > 0 ? threads : 1;
                 sockets = maxcpus /
-                          (drawers * books * dies * clusters * cores * threads);
+                          (drawers * books * dies * clusters *
+                           modules * cores * threads);
             } else if (cores == 0) {
                 threads = threads > 0 ? threads : 1;
                 cores = maxcpus /
-                        (drawers * books * sockets * dies * clusters * threads);
+                        (drawers * books * sockets * dies *
+                         clusters * modules * threads);
             }
         } else {
             /* prefer cores over sockets since 6.2 */
@@ -197,22 +219,26 @@ void machine_parse_smp_config(MachineState *ms,
                 sockets = sockets > 0 ? sockets : 1;
                 threads = threads > 0 ? threads : 1;
                 cores = maxcpus /
-                        (drawers * books * sockets * dies * clusters * threads);
+                        (drawers * books * sockets * dies *
+                         clusters * modules * threads);
             } else if (sockets == 0) {
                 threads = threads > 0 ? threads : 1;
                 sockets = maxcpus /
-                          (drawers * books * dies * clusters * cores * threads);
+                          (drawers * books * dies * clusters *
+                           modules * cores * threads);
             }
         }
 
         /* try to calculate omitted threads at last */
         if (threads == 0) {
             threads = maxcpus /
-                      (drawers * books * sockets * dies * clusters * cores);
+                      (drawers * books * sockets * dies *
+                       clusters * modules * cores);
         }
     }
 
-    total_cpus = drawers * books * sockets * dies * clusters * cores * threads;
+    total_cpus = drawers * books * sockets * dies *
+                 clusters * modules * cores * threads;
     maxcpus = maxcpus > 0 ? maxcpus : total_cpus;
     cpus = cpus > 0 ? cpus : maxcpus;
 
@@ -222,6 +248,7 @@ void machine_parse_smp_config(MachineState *ms,
     ms->smp.sockets = sockets;
     ms->smp.dies = dies;
     ms->smp.clusters = clusters;
+    ms->smp.modules = modules;
     ms->smp.cores = cores;
     ms->smp.threads = threads;
     ms->smp.max_cpus = maxcpus;
diff --git a/hw/core/machine.c b/hw/core/machine.c
index fe0579b7a7e9..9ff5170f8e31 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -878,6 +878,7 @@ static void machine_get_smp(Object *obj, Visitor *v, const char *name,
         .has_sockets = true, .sockets = ms->smp.sockets,
         .has_dies = true, .dies = ms->smp.dies,
         .has_clusters = true, .clusters = ms->smp.clusters,
+        .has_modules = true, .modules = ms->smp.modules,
         .has_cores = true, .cores = ms->smp.cores,
         .has_threads = true, .threads = ms->smp.threads,
         .has_maxcpus = true, .maxcpus = ms->smp.max_cpus,
diff --git a/qapi/machine.json b/qapi/machine.json
index 0840c91e70ec..3f6a5af10ba8 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -1635,6 +1635,8 @@
 #
 # @clusters: number of clusters per parent container (since 7.0)
 #
+# @modules: number of modules per parent container (since 9.1)
+#
 # @cores: number of cores per parent container
 #
 # @threads: number of threads per core
@@ -1648,6 +1650,7 @@
      '*sockets': 'int',
      '*dies': 'int',
      '*clusters': 'int',
+     '*modules': 'int',
      '*cores': 'int',
      '*threads': 'int',
      '*maxcpus': 'int' } }
diff --git a/system/vl.c b/system/vl.c
index c64422298245..7756eac81e48 100644
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
-- 
2.34.1


