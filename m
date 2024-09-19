Return-Path: <kvm+bounces-27116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13A7A97C292
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:41:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88EBE1F21AC1
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B5FD1865C;
	Thu, 19 Sep 2024 01:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cFftb/0n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAEC1DFD1
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710079; cv=none; b=iPNtsPnlGtmdYn0ivFDL+XtuxuRUa9NlyPvTL2Rx5RMKhvHajt/B3qLB87IO3yX9DR65Kuvkjcdrvi7I/p2wD2Pt7Vygt11bh46sGeOJgHxnAg7DYgfJ4aW9RC3jzSxqQuDfrB6vkV+hwF6DWLkz+V9JFMMP/yaTHM2+kJV4ie0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710079; c=relaxed/simple;
	bh=e8uNe2XyBy//pc+Jdrf2eDU6ylT8TdayHazakj6xvUI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gZ+Mv0UhXFFG5UIOgI4msitEQgJsmve014UD0kebNJnW5pZOgIzdjqiXRD2X37oBaTOinyGfMuIFwLji7Sz4GGP80q6zkyH9aFUuNBJI+A9HGtKQ0jlOYq7snK5GA5I3JflEpNnCTJYiBHN/2/KUFUd8NZeZkRxU3vFrIYUVmKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cFftb/0n; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710078; x=1758246078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e8uNe2XyBy//pc+Jdrf2eDU6ylT8TdayHazakj6xvUI=;
  b=cFftb/0ne249EziHhOfrZL8RwPwQl5BZ9AxyZVgkHbJ0MAprWHKIDZtQ
   AivRqW3QAHU9pC2x2zaob8zFOsOeAHxLfl9msqFPTApKjHv+A+37ZZK7J
   Hl9xG6SxWbBRhaYLX0jUErrG5EJzWd02zjinpe5o3XjWbcUKs3Eg19mJu
   mjXN49Gk6zb9+gw1FHDNPfl3oO2QFf65D4yVH7lK1abI8u+AEuGfvBadx
   COo28Rr/IxUExx+JqXMuntRjjif6b5uGFrogm6u5NDi7DaKN1oZNfMOeP
   vCzXY0tWXKdkP9pvFdpyhnP+TAMKIh9vQqAgpUJzwbZ/nGXsXSupGXKS+
   w==;
X-CSE-ConnectionGUID: k95Mw5zATd6AsJP2JBduAQ==
X-CSE-MsgGUID: 3YeYXqsJT72SIUq7Ez5+tg==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25798104"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25798104"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:41:17 -0700
X-CSE-ConnectionGUID: FdACOWMXSMOp94R+MXOELA==
X-CSE-MsgGUID: Wk9cMGQHQpOW5if6nrEZ5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058986"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:41:11 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 14/15] i386/cpu: Support CPU plugged in topology tree via bus-finder
Date: Thu, 19 Sep 2024 09:55:32 +0800
Message-Id: <20240919015533.766754-15-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919015533.766754-1-zhao1.liu@intel.com>
References: <20240919015533.766754-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use topology sub IDs or APIC ID to locate parent topology device and
bus.

This process naturally verifies the correctness of topology-related IDs,
making it possible to drop the existing topology ID sanity checks once
x86 machine supports topology tree.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/x86-common.c  | 99 ++++++++++++++++++++++++++++++++++---------
 include/hw/i386/x86.h |  2 +
 target/i386/cpu.c     | 11 +++++
 3 files changed, 91 insertions(+), 21 deletions(-)

diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index a7f082b0a90b..d837aadc9dea 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -208,6 +208,65 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
     }
 }
 
+static void x86_fixup_topo_ids(MachineState *ms, X86CPU *cpu)
+{
+    /*
+     * die-id was optional in QEMU 4.0 and older, so keep it optional
+     * if there's only one die per socket.
+     */
+    if (cpu->module_id < 0 && ms->smp.modules == 1) {
+        cpu->module_id = 0;
+    }
+
+    /*
+     * module-id was optional in QEMU 9.0 and older, so keep it optional
+     * if there's only one module per die.
+     */
+    if (cpu->die_id < 0 && ms->smp.dies == 1) {
+        cpu->die_id = 0;
+    }
+}
+
+BusState *x86_cpu_get_parent_bus(DeviceState *dev)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+    X86MachineState *x86ms = X86_MACHINE(ms);
+    X86CPU *cpu = X86_CPU(dev);
+    X86CPUTopoIDs topo_ids;
+    X86CPUTopoInfo topo_info;
+    BusState *bus;
+
+    x86_fixup_topo_ids(ms, cpu);
+    init_topo_info(&topo_info, x86ms);
+
+    if (cpu->apic_id == UNASSIGNED_APIC_ID) {
+        /* TODO: Make the thread_id and bus index of CPU the same. */
+        topo_ids.smt_id = cpu->thread_id;
+        topo_ids.core_id = cpu->core_id;
+        topo_ids.module_id = cpu->module_id;
+        topo_ids.die_id = cpu->die_id;
+        topo_ids.pkg_id = cpu->socket_id;
+    } else {
+        x86_topo_ids_from_apicid(cpu->apic_id, &topo_info, &topo_ids);
+    }
+
+    bus = x86_find_topo_bus(ms, &topo_ids);
+
+    /*
+     * If APIC ID is not set,
+     * set it based on socket/die/module/core/thread properties.
+     *
+     * The children walking result proves topo ids are valid.
+     * Though module and die are optional, topology tree will create
+     * at least 1 instance by default if the machine supports.
+     */
+    if (bus && cpu->apic_id == UNASSIGNED_APIC_ID) {
+        cpu->apic_id = x86_apicid_from_topo_ids(&topo_info, &topo_ids);
+    }
+
+    return bus;
+}
+
 void x86_rtc_set_cpus_count(ISADevice *s, uint16_t cpus_count)
 {
     MC146818RtcState *rtc = MC146818_RTC(s);
@@ -340,6 +399,7 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
     X86CPU *cpu = X86_CPU(dev);
     CPUX86State *env = &cpu->env;
     MachineState *ms = MACHINE(hotplug_dev);
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
     X86MachineState *x86ms = X86_MACHINE(hotplug_dev);
     unsigned int smp_cores = ms->smp.cores;
     unsigned int smp_threads = ms->smp.threads;
@@ -374,26 +434,9 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
         set_bit(CPU_TOPOLOGY_LEVEL_DIE, env->avail_cpu_topo);
     }
 
-    /*
-     * If APIC ID is not set,
-     * set it based on socket/die/module/core/thread properties.
-     */
-    if (cpu->apic_id == UNASSIGNED_APIC_ID) {
-        /*
-         * die-id was optional in QEMU 4.0 and older, so keep it optional
-         * if there's only one die per socket.
-         */
-        if (cpu->die_id < 0 && ms->smp.dies == 1) {
-            cpu->die_id = 0;
-        }
-
-        /*
-         * module-id was optional in QEMU 9.0 and older, so keep it optional
-         * if there's only one module per die.
-         */
-        if (cpu->module_id < 0 && ms->smp.modules == 1) {
-            cpu->module_id = 0;
-        }
+    if (cpu->apic_id == UNASSIGNED_APIC_ID &&
+        !mc->smp_props.topo_tree_supported) {
+        x86_fixup_topo_ids(ms, cpu);
 
         if (cpu->socket_id < 0) {
             error_setg(errp, "CPU socket-id is not set");
@@ -409,7 +452,6 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
         } else if (cpu->die_id > ms->smp.dies - 1) {
             error_setg(errp, "Invalid CPU die-id: %u must be in range 0:%u",
                        cpu->die_id, ms->smp.dies - 1);
-            return;
         }
         if (cpu->module_id < 0) {
             error_setg(errp, "CPU module-id is not set");
@@ -442,6 +484,21 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
         topo_ids.core_id = cpu->core_id;
         topo_ids.smt_id = cpu->thread_id;
         cpu->apic_id = x86_apicid_from_topo_ids(&topo_info, &topo_ids);
+    } else if (cpu->apic_id == UNASSIGNED_APIC_ID &&
+               mc->smp_props.topo_tree_supported) {
+        /*
+         * For this case, CPU is added by specifying the bus. Under the
+         * topology tree, specifying only the bus should be feasible, but
+         * the topology represented by the bus, topo ids, or apic id must
+         * be consistent.
+         *
+         * To simplify, the case with only the bus specified is not supported
+         * at this time.
+         */
+        if (x86_cpu_get_parent_bus(dev) != dev->parent_bus) {
+            error_setg(errp, "Invalid CPU topology ids");
+            return;
+        }
     }
 
     cpu_slot = x86_find_cpu_slot(MACHINE(x86ms), cpu->apic_id, &idx);
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index d43cb3908e65..2a62b4b8d08c 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -138,6 +138,8 @@ void x86_load_linux(X86MachineState *x86ms,
 bool x86_machine_is_smm_enabled(const X86MachineState *x86ms);
 bool x86_machine_is_acpi_enabled(const X86MachineState *x86ms);
 
+BusState *x86_cpu_get_parent_bus(DeviceState *dev);
+
 /* Global System Interrupts */
 
 #define ACPI_BUILD_PCI_IRQS ((1<<5) | (1<<9) | (1<<10) | (1<<11))
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6d9f7dc0872a..90221ceb7313 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -35,12 +35,14 @@
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "hw/qdev-properties.h"
 #include "hw/i386/topology.h"
+#include "monitor/bus-finder.h"
 #ifndef CONFIG_USER_ONLY
 #include "sysemu/reset.h"
 #include "qapi/qapi-commands-machine-target.h"
 #include "exec/address-spaces.h"
 #include "hw/boards.h"
 #include "hw/i386/sgx-epc.h"
+#include "hw/i386/x86.h"
 #endif
 
 #include "disas/capstone.h"
@@ -8468,6 +8470,11 @@ static void x86_cpu_common_class_init(ObjectClass *oc, void *data)
 
     dc->user_creatable = true;
 
+#ifndef CONFIG_USER_ONLY
+    BusFinderClass *bfc = BUS_FINDER_CLASS(oc);
+    bfc->find_bus = x86_cpu_get_parent_bus;
+#endif
+
     object_class_property_add(oc, "family", "int",
                               x86_cpuid_version_get_family,
                               x86_cpuid_version_set_family, NULL, NULL);
@@ -8520,6 +8527,10 @@ static const TypeInfo x86_cpu_type_info = {
     .abstract = true,
     .class_size = sizeof(X86CPUClass),
     .class_init = x86_cpu_common_class_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_BUS_FINDER },
+        { }
+    }
 };
 
 /* "base" CPU model, used by query-cpu-model-expansion */
-- 
2.34.1


