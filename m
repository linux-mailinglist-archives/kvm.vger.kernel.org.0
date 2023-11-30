Return-Path: <kvm+bounces-2964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F37F7FF227
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:36:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 293E42840E0
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4177A4A9BB;
	Thu, 30 Nov 2023 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YfvDLSPS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D2993
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701355002; x=1732891002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RjfOv7ECY6GXSAStu2RlCVg7nYnpovILbpK6PYk0aaQ=;
  b=YfvDLSPSVYsjfHrF8s7LQC2AvSunpxc+civBIgarkBMy1uCM4cYU61xq
   rjCkthStyNYzoJZh/09PHKYtBQh2CrV9T7hlqdAnOt1Z9EPjo+ClppRkW
   XoYbLlB4hZ7sJQqRsyZ+nA6y22BD3/UUwFDzud51tpPVaFZHZJb8YBmVF
   nrgXuV3ObtFddkUMWMn0sKnp/Uvi39SiqviUgcrQyHDJvBEDbFDOtda/3
   1Vjxc2zIMfcWIawNER9eMXunqZCRqkh0NQaHJDaEBqmywcJE8u9Tg259h
   +60cq6wpjkt20xlo+Fin0rZbQEpwiFdIttV/nikayztj+vqfNO7Erf8/t
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532723"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532723"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:36:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730519"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730519"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:36:24 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org,
	qemu-arm@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 38/41] hw/i386: Wrap apic id and topology sub ids assigning as helpers
Date: Thu, 30 Nov 2023 22:42:00 +0800
Message-Id: <20231130144203.2307629-39-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
References: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

For QOM topology, these 2 helpers are needed for hotplugged CPU to
verify its topology sub indexes and then search its parent core.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/x86.c | 173 ++++++++++++++++++++++++++++----------------------
 1 file changed, 96 insertions(+), 77 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index febffed92a83..04edd6de6aeb 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -306,6 +306,98 @@ void x86_cpu_unplug_cb(HotplugHandler *hotplug_dev,
     error_propagate(errp, local_err);
 }
 
+static void x86_cpu_assign_apic_id(MachineState *ms, X86CPU *cpu,
+                                   X86CPUTopoIDs *topo_ids,
+                                   X86CPUTopoInfo *topo_info,
+                                   Error **errp)
+{
+    int max_socket = (ms->smp.max_cpus - 1) /
+                     ms->smp.threads / ms->smp.cores / ms->smp.dies;
+
+    /*
+     * die-id was optional in QEMU 4.0 and older, so keep it optional
+     * if there's only one die per socket.
+     */
+    if (cpu->die_id < 0 && ms->smp.dies == 1) {
+        cpu->die_id = 0;
+    }
+
+    if (cpu->socket_id < 0) {
+        error_setg(errp, "CPU socket-id is not set");
+        return;
+    } else if (cpu->socket_id > max_socket) {
+        error_setg(errp, "Invalid CPU socket-id: %u must be in range 0:%u",
+                   cpu->socket_id, max_socket);
+        return;
+    }
+    if (cpu->die_id < 0) {
+        error_setg(errp, "CPU die-id is not set");
+        return;
+    } else if (cpu->die_id > ms->smp.dies - 1) {
+        error_setg(errp, "Invalid CPU die-id: %u must be in range 0:%u",
+                   cpu->die_id, ms->smp.dies - 1);
+        return;
+    }
+    if (cpu->core_id < 0) {
+        error_setg(errp, "CPU core-id is not set");
+        return;
+    } else if (cpu->core_id > (ms->smp.cores - 1)) {
+        error_setg(errp, "Invalid CPU core-id: %u must be in range 0:%u",
+                   cpu->core_id, ms->smp.cores - 1);
+        return;
+    }
+    if (cpu->thread_id < 0) {
+        error_setg(errp, "CPU thread-id is not set");
+        return;
+    } else if (cpu->thread_id > (ms->smp.threads - 1)) {
+        error_setg(errp, "Invalid CPU thread-id: %u must be in range 0:%u",
+                   cpu->thread_id, ms->smp.threads - 1);
+        return;
+    }
+
+    topo_ids->pkg_id = cpu->socket_id;
+    topo_ids->die_id = cpu->die_id;
+    topo_ids->core_id = cpu->core_id;
+    topo_ids->smt_id = cpu->thread_id;
+    cpu->apic_id = x86_apicid_from_topo_ids(topo_info, topo_ids);
+}
+
+static void x86_cpu_assign_topo_id(X86CPU *cpu,
+                                   X86CPUTopoIDs *topo_ids,
+                                   Error **errp)
+{
+    if (cpu->socket_id != -1 && cpu->socket_id != topo_ids->pkg_id) {
+        error_setg(errp, "property socket-id: %u doesn't match set apic-id:"
+            " 0x%x (socket-id: %u)", cpu->socket_id, cpu->apic_id,
+            topo_ids->pkg_id);
+        return;
+    }
+    cpu->socket_id = topo_ids->pkg_id;
+
+    if (cpu->die_id != -1 && cpu->die_id != topo_ids->die_id) {
+        error_setg(errp, "property die-id: %u doesn't match set apic-id:"
+            " 0x%x (die-id: %u)", cpu->die_id, cpu->apic_id, topo_ids->die_id);
+        return;
+    }
+    cpu->die_id = topo_ids->die_id;
+
+    if (cpu->core_id != -1 && cpu->core_id != topo_ids->core_id) {
+        error_setg(errp, "property core-id: %u doesn't match set apic-id:"
+            " 0x%x (core-id: %u)", cpu->core_id, cpu->apic_id,
+            topo_ids->core_id);
+        return;
+    }
+    cpu->core_id = topo_ids->core_id;
+
+    if (cpu->thread_id != -1 && cpu->thread_id != topo_ids->smt_id) {
+        error_setg(errp, "property thread-id: %u doesn't match set apic-id:"
+            " 0x%x (thread-id: %u)", cpu->thread_id, cpu->apic_id,
+            topo_ids->smt_id);
+        return;
+    }
+    cpu->thread_id = topo_ids->smt_id;
+}
+
 void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
                       DeviceState *dev, Error **errp)
 {
@@ -317,8 +409,6 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
     CPUX86State *env = &cpu->env;
     MachineState *ms = MACHINE(hotplug_dev);
     X86MachineState *x86ms = X86_MACHINE(hotplug_dev);
-    unsigned int smp_cores = ms->smp.cores;
-    unsigned int smp_threads = ms->smp.threads;
     X86CPUTopoInfo topo_info;
 
     if (!object_dynamic_cast(OBJECT(cpu), ms->cpu_type)) {
@@ -347,55 +437,10 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
      * set it based on socket/die/core/thread properties.
      */
     if (cpu->apic_id == UNASSIGNED_APIC_ID) {
-        int max_socket = (ms->smp.max_cpus - 1) /
-                                smp_threads / smp_cores / ms->smp.dies;
-
-        /*
-         * die-id was optional in QEMU 4.0 and older, so keep it optional
-         * if there's only one die per socket.
-         */
-        if (cpu->die_id < 0 && ms->smp.dies == 1) {
-            cpu->die_id = 0;
-        }
-
-        if (cpu->socket_id < 0) {
-            error_setg(errp, "CPU socket-id is not set");
-            return;
-        } else if (cpu->socket_id > max_socket) {
-            error_setg(errp, "Invalid CPU socket-id: %u must be in range 0:%u",
-                       cpu->socket_id, max_socket);
+        x86_cpu_assign_apic_id(ms, cpu, &topo_ids, &topo_info, errp);
+        if (*errp) {
             return;
         }
-        if (cpu->die_id < 0) {
-            error_setg(errp, "CPU die-id is not set");
-            return;
-        } else if (cpu->die_id > ms->smp.dies - 1) {
-            error_setg(errp, "Invalid CPU die-id: %u must be in range 0:%u",
-                       cpu->die_id, ms->smp.dies - 1);
-            return;
-        }
-        if (cpu->core_id < 0) {
-            error_setg(errp, "CPU core-id is not set");
-            return;
-        } else if (cpu->core_id > (smp_cores - 1)) {
-            error_setg(errp, "Invalid CPU core-id: %u must be in range 0:%u",
-                       cpu->core_id, smp_cores - 1);
-            return;
-        }
-        if (cpu->thread_id < 0) {
-            error_setg(errp, "CPU thread-id is not set");
-            return;
-        } else if (cpu->thread_id > (smp_threads - 1)) {
-            error_setg(errp, "Invalid CPU thread-id: %u must be in range 0:%u",
-                       cpu->thread_id, smp_threads - 1);
-            return;
-        }
-
-        topo_ids.pkg_id = cpu->socket_id;
-        topo_ids.die_id = cpu->die_id;
-        topo_ids.core_id = cpu->core_id;
-        topo_ids.smt_id = cpu->thread_id;
-        cpu->apic_id = x86_apicid_from_topo_ids(&topo_info, &topo_ids);
     }
 
     cpu_slot = x86_find_cpu_slot(MACHINE(x86ms), cpu->apic_id, &idx);
@@ -422,36 +467,10 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
      * once -smp refactoring is complete and there will be CPU private
      * CPUState::nr_cores and CPUState::nr_threads fields instead of globals */
     x86_topo_ids_from_apicid(cpu->apic_id, &topo_info, &topo_ids);
-    if (cpu->socket_id != -1 && cpu->socket_id != topo_ids.pkg_id) {
-        error_setg(errp, "property socket-id: %u doesn't match set apic-id:"
-            " 0x%x (socket-id: %u)", cpu->socket_id, cpu->apic_id,
-            topo_ids.pkg_id);
-        return;
-    }
-    cpu->socket_id = topo_ids.pkg_id;
-
-    if (cpu->die_id != -1 && cpu->die_id != topo_ids.die_id) {
-        error_setg(errp, "property die-id: %u doesn't match set apic-id:"
-            " 0x%x (die-id: %u)", cpu->die_id, cpu->apic_id, topo_ids.die_id);
-        return;
-    }
-    cpu->die_id = topo_ids.die_id;
-
-    if (cpu->core_id != -1 && cpu->core_id != topo_ids.core_id) {
-        error_setg(errp, "property core-id: %u doesn't match set apic-id:"
-            " 0x%x (core-id: %u)", cpu->core_id, cpu->apic_id,
-            topo_ids.core_id);
-        return;
-    }
-    cpu->core_id = topo_ids.core_id;
-
-    if (cpu->thread_id != -1 && cpu->thread_id != topo_ids.smt_id) {
-        error_setg(errp, "property thread-id: %u doesn't match set apic-id:"
-            " 0x%x (thread-id: %u)", cpu->thread_id, cpu->apic_id,
-            topo_ids.smt_id);
+    x86_cpu_assign_topo_id(cpu, &topo_ids, errp);
+    if (*errp) {
         return;
     }
-    cpu->thread_id = topo_ids.smt_id;
 
     if (hyperv_feat_enabled(cpu, HYPERV_FEAT_VPINDEX) &&
         kvm_enabled() && !kvm_hv_vpindex_settable()) {
-- 
2.34.1


