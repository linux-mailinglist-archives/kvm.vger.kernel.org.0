Return-Path: <kvm+bounces-27117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF9A97C293
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60C681C21A04
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1241865C;
	Thu, 19 Sep 2024 01:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nalXFsSb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4460C1DA4C
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710086; cv=none; b=FYE3HlFa4y5jQh+oTSRTB93z09XO0hpWiIXMrz0VFxD9QdQ5pM4/UDs8hiM7Q6/xLvU5WhT0RCIODhbHyOloMWycoeZjDxbhFKf1E0ARDAR+HPG0bnJmTarmaFDTiGkFOHxe7h88lR6TOKB9BmjKB8UC7cajVYxXvL7EZreemOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710086; c=relaxed/simple;
	bh=R/RyqBpSFLfGANKmP2zWrU5SVWm2/qn58wOc7/+Iwms=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=llMwzbrhgcGpTHHtygrys4OrQtdjGNNILhi9/IMtWsHABRI2HhQHoqoiw5h1aGgPPa/hHq6JVjXtZfVLzNvOTwZv3j9AM7MSmvnYZX1uHIUdqGsItyWD7xfBXY9kqp5ZF1saP5hYT/YiwsqydPAzaGsJ4cEARA0FtLvWRRflrho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nalXFsSb; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710085; x=1758246085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R/RyqBpSFLfGANKmP2zWrU5SVWm2/qn58wOc7/+Iwms=;
  b=nalXFsSbHip+jzCewXtj5JAy9egUpwezkWn/9k7VhKHWA8/acQQaNb/Y
   /dzR+k02dgl22aZA4VrHLH1l1jzN3tfUzlz18cnxcxmmHwpYhalnzeJmK
   lN71DsS8P9dSNlKS16IQrgDeQtudofYoQTG8Axx/S+Cqt7/UgevGCNd5d
   eS6wuKMQUxpdl7cXRDRdZUf5piC5Whl1qFCekt5iTT4fg0RwGPQX/9GTM
   tGTjtuMGFjwEJ/m3mWhMsAS5wYo6rknvTpuQlKyom1TLfIr3dNzX8C4Tx
   G1SSMF1IfHOxddiuQwRh/3Lp1YDvjpeFRO52evhmjaS1vKwQL2Bn81HQP
   A==;
X-CSE-ConnectionGUID: 4Jt5BYqGTwm3wmsDvfvkOw==
X-CSE-MsgGUID: DaD6967QRZCpiiLmNpJalA==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25798132"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25798132"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:41:24 -0700
X-CSE-ConnectionGUID: szNCjQVpTIWjD4Z0T6eu4A==
X-CSE-MsgGUID: 4gQNKxRUT0GdnsrB0gseZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70059004"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:41:18 -0700
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
Subject: [RFC v2 15/15] i386: Support topology device tree
Date: Thu, 19 Sep 2024 09:55:33 +0800
Message-Id: <20240919015533.766754-16-zhao1.liu@intel.com>
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

Support complete QOM CPu topology tree for x86 machine, and specify
bus_type for x86 CPU so that all x86 CPUs will be added in the topology
tree.

Since the CPU slot make the machine as the hotplug handler for all
topology devices, hotplug related hooks may used to handle other
topology devices besides the CPU. Thus, make microvm not assume that
the device is only a CPU when implementing the relevant hooks.

Additionally, drop code paths that are not needed by the topology tree
implementation.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/microvm.c    | 13 +++++---
 hw/i386/x86-common.c | 78 +++++---------------------------------------
 hw/i386/x86.c        |  2 ++
 target/i386/cpu.c    |  2 ++
 4 files changed, 21 insertions(+), 74 deletions(-)

diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index 40edcee7af29..49a897db50fc 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -417,16 +417,21 @@ static void microvm_fix_kernel_cmdline(MachineState *machine)
 static void microvm_device_pre_plug_cb(HotplugHandler *hotplug_dev,
                                        DeviceState *dev, Error **errp)
 {
-    X86CPU *cpu = X86_CPU(dev);
+    if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
+        X86CPU *cpu;
+        cpu = X86_CPU(dev);
 
-    cpu->host_phys_bits = true; /* need reliable phys-bits */
-    x86_cpu_pre_plug(hotplug_dev, dev, errp);
+        cpu->host_phys_bits = true; /* need reliable phys-bits */
+        x86_cpu_pre_plug(hotplug_dev, dev, errp);
+    }
 }
 
 static void microvm_device_plug_cb(HotplugHandler *hotplug_dev,
                                    DeviceState *dev, Error **errp)
 {
-    x86_cpu_plug(hotplug_dev, dev, errp);
+    if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
+        x86_cpu_plug(hotplug_dev, dev, errp);
+    }
 }
 
 static void microvm_device_unplug_request_cb(HotplugHandler *hotplug_dev,
diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index d837aadc9dea..75d4b2f3d43a 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -129,26 +129,18 @@ static void x86_cpu_new(X86MachineState *x86ms, int index,
                         int64_t apic_id, Error **errp)
 {
     MachineState *ms = MACHINE(x86ms);
-    MachineClass *mc = MACHINE_GET_CLASS(ms);
     Object *cpu = object_new(ms->cpu_type);
     DeviceState *dev = DEVICE(cpu);
     BusState *bus = NULL;
+    X86CPUTopoIDs topo_ids;
+    X86CPUTopoInfo topo_info;
 
-    /*
-     * Once x86 machine supports topo_tree_supported, x86 CPU would
-     * also have bus_type.
-     */
-    if (mc->smp_props.topo_tree_supported) {
-        X86CPUTopoIDs topo_ids;
-        X86CPUTopoInfo topo_info;
-
-        init_topo_info(&topo_info, x86ms);
-        x86_topo_ids_from_apicid(apic_id, &topo_info, &topo_ids);
-        bus = x86_find_topo_bus(ms, &topo_ids);
+    init_topo_info(&topo_info, x86ms);
+    x86_topo_ids_from_apicid(apic_id, &topo_info, &topo_ids);
+    bus = x86_find_topo_bus(ms, &topo_ids);
 
-        /* Only with dev->id, CPU can be inserted into topology tree. */
-        dev->id = g_strdup_printf("%s[%d]", ms->cpu_type, index);
-    }
+    /* Only with dev->id, CPU can be inserted into topology tree. */
+    dev->id = g_strdup_printf("%s[%d]", ms->cpu_type, index);
 
     if (!object_property_set_uint(cpu, "apic-id", apic_id, errp)) {
         goto out;
@@ -399,10 +391,7 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
     X86CPU *cpu = X86_CPU(dev);
     CPUX86State *env = &cpu->env;
     MachineState *ms = MACHINE(hotplug_dev);
-    MachineClass *mc = MACHINE_GET_CLASS(ms);
     X86MachineState *x86ms = X86_MACHINE(hotplug_dev);
-    unsigned int smp_cores = ms->smp.cores;
-    unsigned int smp_threads = ms->smp.threads;
     X86CPUTopoInfo topo_info;
 
     if (!object_dynamic_cast(OBJECT(cpu), ms->cpu_type)) {
@@ -434,58 +423,7 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
         set_bit(CPU_TOPOLOGY_LEVEL_DIE, env->avail_cpu_topo);
     }
 
-    if (cpu->apic_id == UNASSIGNED_APIC_ID &&
-        !mc->smp_props.topo_tree_supported) {
-        x86_fixup_topo_ids(ms, cpu);
-
-        if (cpu->socket_id < 0) {
-            error_setg(errp, "CPU socket-id is not set");
-            return;
-        } else if (cpu->socket_id > ms->smp.sockets - 1) {
-            error_setg(errp, "Invalid CPU socket-id: %u must be in range 0:%u",
-                       cpu->socket_id, ms->smp.sockets - 1);
-            return;
-        }
-        if (cpu->die_id < 0) {
-            error_setg(errp, "CPU die-id is not set");
-            return;
-        } else if (cpu->die_id > ms->smp.dies - 1) {
-            error_setg(errp, "Invalid CPU die-id: %u must be in range 0:%u",
-                       cpu->die_id, ms->smp.dies - 1);
-        }
-        if (cpu->module_id < 0) {
-            error_setg(errp, "CPU module-id is not set");
-            return;
-        } else if (cpu->module_id > ms->smp.modules - 1) {
-            error_setg(errp, "Invalid CPU module-id: %u must be in range 0:%u",
-                       cpu->module_id, ms->smp.modules - 1);
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
-        topo_ids.module_id = cpu->module_id;
-        topo_ids.core_id = cpu->core_id;
-        topo_ids.smt_id = cpu->thread_id;
-        cpu->apic_id = x86_apicid_from_topo_ids(&topo_info, &topo_ids);
-    } else if (cpu->apic_id == UNASSIGNED_APIC_ID &&
-               mc->smp_props.topo_tree_supported) {
+    if (cpu->apic_id == UNASSIGNED_APIC_ID) {
         /*
          * For this case, CPU is added by specifying the bus. Under the
          * topology tree, specifying only the bus should be feasible, but
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 01fc5e656272..cdf7b81ad0e3 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -381,6 +381,8 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
     mc->cpu_index_to_instance_props = x86_cpu_index_to_props;
     mc->get_default_cpu_node_id = x86_get_default_cpu_node_id;
     mc->possible_cpu_arch_ids = x86_possible_cpu_arch_ids;
+    mc->smp_props.arch_id_topo_level = CPU_TOPOLOGY_LEVEL_THREAD;
+    mc->smp_props.topo_tree_supported = true;
     mc->kvm_type = x86_kvm_type;
     x86mc->save_tsc_khz = true;
     x86mc->fwcfg_dma_enabled = true;
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 90221ceb7313..fb54c2c100a0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8473,6 +8473,8 @@ static void x86_cpu_common_class_init(ObjectClass *oc, void *data)
 #ifndef CONFIG_USER_ONLY
     BusFinderClass *bfc = BUS_FINDER_CLASS(oc);
     bfc->find_bus = x86_cpu_get_parent_bus;
+
+    dc->bus_type = TYPE_CPU_BUS;
 #endif
 
     object_class_property_add(oc, "family", "int",
-- 
2.34.1


