Return-Path: <kvm+bounces-15833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42F8B8B0EAB
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6699D1C232D7
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246BB16D9AE;
	Wed, 24 Apr 2024 15:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FiE4B8LC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD118161310
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713973037; cv=none; b=RXADN/N3zMFbZ7DJq2kaYMekBJZtp6O8G0dPYbGBABYSxkQlmQJGIDsSkiMJhYQFtkJiasJQT6ofCWQH5whiRW48CYDo5nC+3Zr6mwBt5wWrm8tygon9Qq+/Z/o8ZN9X1amCemnOvRK0mMzdGJJIPmYJ5PutJ+wue6IjCsZbcjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713973037; c=relaxed/simple;
	bh=hDw4iMWbjkMuLGrgQMDf+29cF7BPtG/r8eqgQMycbcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UndsdAg0IWA3nb/n9kb7L7QMKj3au1YzNP0WHpUINVpMnkaUtvcLLasrJYDE3B/yYnNYNUrc344KqzEe8W915eEqU70KfoTEtUbsDr12E+4yxWN6aOZPWHcY7jASjJi3bNnm7RWVu5+VJMw1Alkfj1kzBdFgt8FKm9a357yZQOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FiE4B8LC; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713973036; x=1745509036;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hDw4iMWbjkMuLGrgQMDf+29cF7BPtG/r8eqgQMycbcA=;
  b=FiE4B8LC7DcAnvyAz+YMnyH12v9ySs/tNMIcM6QieAxMAyWrX5yFGutF
   XcwqPd3H7FthumRL96D1QuNIyKnjY13tQctKDpVajSwbiLC4IkqHZYO9B
   K49dJHXcnjj/txVQTZePkoOep1hIXKB7zHIFWCoF5GIR3882gN5Z/Lrxy
   9Eq7Z+/aaN07ZSZMYRIAioGg40y/XAJ32aUD1lyGUrseewhM5fw59ASCE
   M+T4w4suEVBBiskNy21tShdSNfPvtrH3dB6xeRIkncKXtJremmifEhi1X
   RySOWwUYphYubey3Gaa01yrSyILuPk45gNUpzM4IrIUeykPDiurxAVwxJ
   g==;
X-CSE-ConnectionGUID: 601JPF+nRZyMXeMPHrr4Vg==
X-CSE-MsgGUID: KUvsH2U7QBOKN3Sb8aJbrQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="12545791"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="12545791"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:37:11 -0700
X-CSE-ConnectionGUID: YKylTqPITIGgnnFKv19KyA==
X-CSE-MsgGUID: NYFSUtrqRE6dvlney1E0TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="25363320"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 24 Apr 2024 08:37:07 -0700
From: Zhao Liu <zhao1.liu@intel.com>
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
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v11 15/21] i386: Support module_id in X86CPUTopoIDs
Date: Wed, 24 Apr 2024 23:49:23 +0800
Message-Id: <20240424154929.1487382-16-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240424154929.1487382-1-zhao1.liu@intel.com>
References: <20240424154929.1487382-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Tested-by: Babu Moger <babu.moger@amd.com>
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
index 69f56aafeed6..fecff4d833c6 100644
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


