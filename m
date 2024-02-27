Return-Path: <kvm+bounces-10062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89199868D51
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:21:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00D281F2752D
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FF71384B1;
	Tue, 27 Feb 2024 10:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cd3N8jxP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE7F1384AD
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709029227; cv=none; b=n3PmwzEdbNsEMuC7pHoHcTZLlv/J3JjSDbJCYDgaiDvl+8PfN5QfbjWLgrkv0KwNQHvstnwgysYDMDEKrrWt+WMY73mvIQWPL0lSOolxJ5CcUxf4ne2TENfbhHrShCRzEX4qTYAx2e9AzWtbpV4n2cY5fhX16y/q6VaCmJd44yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709029227; c=relaxed/simple;
	bh=WE+yg3E+gmPd/IZEoC7RQitGeBNtyR3NYawZF3AIMbc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dIkldpZi4i0/vPDO47CB2zHts3JAGK5EcX+Oc0U2mrD6m7hFOLyENCTNjXoQM2imtT9wtN7nQZfoprsqChQetFfxM4BEqjJRQJ6PK7saCUIwDCHcoAAUfvI1sy9Xs7MKDVteYXJDtOhj/qmHxE6uzPKl42avjy3245gkthVDzzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cd3N8jxP; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709029226; x=1740565226;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WE+yg3E+gmPd/IZEoC7RQitGeBNtyR3NYawZF3AIMbc=;
  b=cd3N8jxPQtz2dC0kTNAJAIevGs04nOrS50/02LX3qISTxNY6oT184dVY
   J2tlvh2X74Dq1S/yPocC7Ccmg8PLUrSAK1+QEUyfL1djB2TO7waYs4buV
   LIbn83pq2kj+G96fn5m5sO1jjvSdWchnM/b+Yf5qjIB0mAR2LQQ4wIe5U
   KTfoI8jQzqN/EAVrMC2zfIl4OVx4EbYG1LM+Fmbs+zD515iV+mxuXAICX
   rWKr1sgglJDFh3reSiI+W5XdwQc3TymetS+f1XwqJlSptjGDEii2KxJl5
   B+ib2VAX7RpPIJKNcF0YwAyuUOzht92vkJCQWLjqmroN62gZ+Id62SqJj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="6310413"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6310413"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 02:20:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6955024"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 27 Feb 2024 02:20:02 -0800
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
Subject: [PATCH v9 15/21] i386: Support module_id in X86CPUTopoIDs
Date: Tue, 27 Feb 2024 18:32:25 +0800
Message-Id: <20240227103231.1556302-16-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Add module_id member in X86CPUTopoIDs.

module_id can be parsed from APIC ID, so also update APIC ID parsing
rule to support module level. With this support, the conversions with
module level between X86CPUTopoIDs, X86CPUTopoInfo and APIC ID are
completed.

module_id can be also generated from cpu topology, and before i386
supports "modules" in smp, the default "modules per die" (modules *
clusters) is only 1, thus the module_id generated in this way is 0,
so that it will not conflict with the module_id generated by APIC ID.

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v7:
 * Mapped x86 module to the smp module instead of cluster.
 * Dropped Michael/Babu's ACKed/Tested tags since the code change.
 * Re-added Yongwei's Tested tag For his re-testing.

Changes since v1:
 * Merged the patch "i386: Update APIC ID parsing rule to support module
   level" into this one. (Yanan)
 * Moved the apicid_module_width() and apicid_module_offset() support
   into the previous modules_per_die related patch. (Yanan)
---
 hw/i386/x86.c              | 31 +++++++++++++++++++++----------
 include/hw/i386/topology.h | 17 +++++++++++++----
 2 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index b668cd537cec..33063ce3888b 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -332,12 +332,9 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
 
     /*
      * If APIC ID is not set,
-     * set it based on socket/die/core/thread properties.
+     * set it based on socket/die/module/core/thread properties.
      */
     if (cpu->apic_id == UNASSIGNED_APIC_ID) {
-        int max_socket = (ms->smp.max_cpus - 1) /
-                                smp_threads / smp_cores / ms->smp.dies;
-
         /*
          * die-id was optional in QEMU 4.0 and older, so keep it optional
          * if there's only one die per socket.
@@ -349,9 +346,9 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
         if (cpu->socket_id < 0) {
             error_setg(errp, "CPU socket-id is not set");
             return;
-        } else if (cpu->socket_id > max_socket) {
+        } else if (cpu->socket_id > ms->smp.sockets - 1) {
             error_setg(errp, "Invalid CPU socket-id: %u must be in range 0:%u",
-                       cpu->socket_id, max_socket);
+                       cpu->socket_id, ms->smp.sockets - 1);
             return;
         }
         if (cpu->die_id < 0) {
@@ -383,17 +380,27 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
         topo_ids.die_id = cpu->die_id;
         topo_ids.core_id = cpu->core_id;
         topo_ids.smt_id = cpu->thread_id;
+
+        /*
+         * TODO: This is the temporary initialization for topo_ids.module_id to
+         * avoid "maybe-uninitialized" compilation errors. Will remove when
+         * X86CPU supports module_id.
+         */
+        topo_ids.module_id = 0;
+
         cpu->apic_id = x86_apicid_from_topo_ids(&topo_info, &topo_ids);
     }
 
     cpu_slot = x86_find_cpu_slot(MACHINE(x86ms), cpu->apic_id, &idx);
     if (!cpu_slot) {
         x86_topo_ids_from_apicid(cpu->apic_id, &topo_info, &topo_ids);
+
         error_setg(errp,
-            "Invalid CPU [socket: %u, die: %u, core: %u, thread: %u] with"
-            " APIC ID %" PRIu32 ", valid index range 0:%d",
-            topo_ids.pkg_id, topo_ids.die_id, topo_ids.core_id, topo_ids.smt_id,
-            cpu->apic_id, ms->possible_cpus->len - 1);
+            "Invalid CPU [socket: %u, die: %u, module: %u, core: %u, thread: %u]"
+            " with APIC ID %" PRIu32 ", valid index range 0:%d",
+            topo_ids.pkg_id, topo_ids.die_id, topo_ids.module_id,
+            topo_ids.core_id, topo_ids.smt_id, cpu->apic_id,
+            ms->possible_cpus->len - 1);
         return;
     }
 
@@ -519,6 +526,10 @@ const CPUArchIdList *x86_possible_cpu_arch_ids(MachineState *ms)
             ms->possible_cpus->cpus[i].props.has_die_id = true;
             ms->possible_cpus->cpus[i].props.die_id = topo_ids.die_id;
         }
+        if (ms->smp.modules > 1) {
+            ms->possible_cpus->cpus[i].props.has_module_id = true;
+            ms->possible_cpus->cpus[i].props.module_id = topo_ids.module_id;
+        }
         ms->possible_cpus->cpus[i].props.has_core_id = true;
         ms->possible_cpus->cpus[i].props.core_id = topo_ids.core_id;
         ms->possible_cpus->cpus[i].props.has_thread_id = true;
diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
index ea871045779d..dff49fce1154 100644
--- a/include/hw/i386/topology.h
+++ b/include/hw/i386/topology.h
@@ -50,6 +50,7 @@ typedef uint32_t apic_id_t;
 typedef struct X86CPUTopoIDs {
     unsigned pkg_id;
     unsigned die_id;
+    unsigned module_id;
     unsigned core_id;
     unsigned smt_id;
 } X86CPUTopoIDs;
@@ -143,6 +144,7 @@ static inline apic_id_t x86_apicid_from_topo_ids(X86CPUTopoInfo *topo_info,
 {
     return (topo_ids->pkg_id  << apicid_pkg_offset(topo_info)) |
            (topo_ids->die_id  << apicid_die_offset(topo_info)) |
+           (topo_ids->module_id << apicid_module_offset(topo_info)) |
            (topo_ids->core_id << apicid_core_offset(topo_info)) |
            topo_ids->smt_id;
 }
@@ -156,12 +158,16 @@ static inline void x86_topo_ids_from_idx(X86CPUTopoInfo *topo_info,
                                          X86CPUTopoIDs *topo_ids)
 {
     unsigned nr_dies = topo_info->dies_per_pkg;
-    unsigned nr_cores = topo_info->cores_per_module *
-                        topo_info->modules_per_die;
+    unsigned nr_modules = topo_info->modules_per_die;
+    unsigned nr_cores = topo_info->cores_per_module;
     unsigned nr_threads = topo_info->threads_per_core;
 
-    topo_ids->pkg_id = cpu_index / (nr_dies * nr_cores * nr_threads);
-    topo_ids->die_id = cpu_index / (nr_cores * nr_threads) % nr_dies;
+    topo_ids->pkg_id = cpu_index / (nr_dies * nr_modules *
+                       nr_cores * nr_threads);
+    topo_ids->die_id = cpu_index / (nr_modules * nr_cores *
+                       nr_threads) % nr_dies;
+    topo_ids->module_id = cpu_index / (nr_cores * nr_threads) %
+                          nr_modules;
     topo_ids->core_id = cpu_index / nr_threads % nr_cores;
     topo_ids->smt_id = cpu_index % nr_threads;
 }
@@ -179,6 +185,9 @@ static inline void x86_topo_ids_from_apicid(apic_id_t apicid,
     topo_ids->core_id =
             (apicid >> apicid_core_offset(topo_info)) &
             ~(0xFFFFFFFFUL << apicid_core_width(topo_info));
+    topo_ids->module_id =
+            (apicid >> apicid_module_offset(topo_info)) &
+            ~(0xFFFFFFFFUL << apicid_module_width(topo_info));
     topo_ids->die_id =
             (apicid >> apicid_die_offset(topo_info)) &
             ~(0xFFFFFFFFUL << apicid_die_width(topo_info));
-- 
2.34.1


