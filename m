Return-Path: <kvm+bounces-27108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6417A97C286
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3A281F22374
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB0CA1865C;
	Thu, 19 Sep 2024 01:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PUwFbrQW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD4B1CFB9
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710026; cv=none; b=AfD8GZmBturgFEeiKhgs1ZNbJUg98vxUf7shdq4sINlTn4+DU2MZBFHKXgcni6S/B9Zyfit+jbM4RwzR/+skkpFhevyBeJHsk+8cstpNy4HfOjkwpVg6KwD+4R6mGUk4dup5FKj5uXzLbMjPz/CdbnC/5WYVuIXqn4QnC/RA+Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710026; c=relaxed/simple;
	bh=+kEYgTEqzxM7Ze52eMLk4clqkl8mXjIJEkgs/jlv98A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mT7acOUkPKCAJfuB7gKuWZ8farvopNEFJ0Q1MrgXWJK7rrkL38CnGWTO43vtjTB5n6iLyHhDI64vpPmRLNdIbUN6NXjjjtJu/3VsFowQWUOSdjkVKP6gPZ/ZYzgwpdMWSgmWvizCyx21T2D5yq/B3uuF1Dx9jxT/yjmRt8VXBds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PUwFbrQW; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710025; x=1758246025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+kEYgTEqzxM7Ze52eMLk4clqkl8mXjIJEkgs/jlv98A=;
  b=PUwFbrQWt/7ErKYUG/2LZ0ar++JWc4NkUm0Iv8trfaLo2jgxRv9rBZIP
   TXm/3oO5TMUaSv4h1RPGeQP66gGvzHS6TGaYLJ7yBDNpvXh9SLqBh5LNv
   iSXkQ0g5+2qaSUcKeraSIVYXcdgW6Ev0/gNXXwvVZXJjqxU/r+gEfBbQ/
   CKgdWTdgGt+YREX08MdERhj4VeWuJxViaN5FBrdkWTJeeEJDdBxP5Hrmy
   UHfjUChfeFWl6KbhTToOZ8nFZJjiGX94Tav1yxCuyTbSAUe2juhnpAfn4
   0GJ7EIb7umaW4IVJ8FKz3Dggirn/V9MzsE7O+e4C0rjHrW+TPKycAa+U2
   Q==;
X-CSE-ConnectionGUID: Lh9NtVtDRnKFW16vdvZ45g==
X-CSE-MsgGUID: RDgH4FfARCqbBMK/UQoP+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25797883"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25797883"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:40:25 -0700
X-CSE-ConnectionGUID: /WO5kkQtTAmAANN0ooMDVw==
X-CSE-MsgGUID: Z1ZnLU9xQpuscAGPUNlugQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058743"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:40:19 -0700
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
Subject: [RFC v2 06/15] hw/core: Create CPU slot in MachineState to manage CPU topology tree
Date: Thu, 19 Sep 2024 09:55:24 +0800
Message-Id: <20240919015533.766754-7-zhao1.liu@intel.com>
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

With CPU slot support, the machine can manage the CPU topology tree. To
enable hot-plug support for topology devices, use the machine as the
hotplug handler for the CPU bus.

Additionally, since not all machines support the topology tree from the
start, add a "topo_tree_supported" flag to indicate whether a machine
supports the topology tree. And create the CPU slot as the topology root
only for machines that support it.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/machine.c         |  2 ++
 hw/cpu/cpu-slot.c         | 34 ++++++++++++++++++++++++++++++++++
 include/hw/boards.h       |  9 +++++++++
 include/hw/cpu/cpu-slot.h |  2 ++
 system/vl.c               |  4 ++++
 5 files changed, 51 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 518beb9f883a..b6258d95b1e8 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1239,6 +1239,8 @@ static void machine_initfn(Object *obj)
         ms->smp_cache.props[i].topology = CPU_TOPOLOGY_LEVEL_DEFAULT;
     }
 
+    ms->topo = NULL;
+
     machine_copy_boot_config(ms, &(BootConfiguration){ 0 });
 }
 
diff --git a/hw/cpu/cpu-slot.c b/hw/cpu/cpu-slot.c
index 66ef8d9faa97..4dbd5b7b7e00 100644
--- a/hw/cpu/cpu-slot.c
+++ b/hw/cpu/cpu-slot.c
@@ -138,3 +138,37 @@ static void cpu_slot_register_types(void)
 }
 
 type_init(cpu_slot_register_types)
+
+void machine_plug_cpu_slot(MachineState *ms)
+{
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+    CPUSlot *slot;
+
+    slot = CPU_SLOT(qdev_new(TYPE_CPU_SLOT));
+    set_bit(CPU_TOPOLOGY_LEVEL_THREAD, slot->supported_levels);
+    set_bit(CPU_TOPOLOGY_LEVEL_CORE, slot->supported_levels);
+    set_bit(CPU_TOPOLOGY_LEVEL_SOCKET, slot->supported_levels);
+
+    /*
+     * Now just consider the levels that x86 supports.
+     * TODO: Supports other levels.
+     */
+    if (mc->smp_props.modules_supported) {
+        set_bit(CPU_TOPOLOGY_LEVEL_MODULE, slot->supported_levels);
+    }
+
+    if (mc->smp_props.dies_supported) {
+        set_bit(CPU_TOPOLOGY_LEVEL_DIE, slot->supported_levels);
+    }
+
+    ms->topo = slot;
+    object_property_add_child(container_get(OBJECT(ms), "/peripheral"),
+                              "cpu-slot", OBJECT(ms->topo));
+    DEVICE(ms->topo)->id = g_strdup_printf("%s", "cpu-slot");
+
+    sysbus_realize(SYS_BUS_DEVICE(slot), &error_abort);
+
+    if (mc->get_hotplug_handler) {
+        qbus_set_hotplug_handler(BUS(&slot->bus), OBJECT(ms));
+    }
+}
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 2dd8decf640a..eeb4e7e2ce9f 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -10,6 +10,7 @@
 #include "qemu/module.h"
 #include "qom/object.h"
 #include "hw/core/cpu.h"
+#include "hw/cpu/cpu-slot.h"
 
 #define TYPE_MACHINE_SUFFIX "-machine"
 
@@ -152,6 +153,8 @@ typedef struct {
  * @modules_supported - whether modules are supported by the machine
  * @cache_supported - whether cache topologies (l1d, l1i, l2 and l3) are
  *                    supported by the machine
+ * @topo_tree_supported - whether QOM topology tree is supported by the
+ *                        machine
  */
 typedef struct {
     bool prefer_sockets;
@@ -162,6 +165,7 @@ typedef struct {
     bool drawers_supported;
     bool modules_supported;
     bool cache_supported[CACHE_LEVEL_AND_TYPE__MAX];
+    bool topo_tree_supported;
 } SMPCompatProps;
 
 /**
@@ -431,6 +435,11 @@ struct MachineState {
     CPUArchIdList *possible_cpus;
     CpuTopology smp;
     SmpCache smp_cache;
+    /*
+     * TODO: get rid of "smp" and merge it into "topo" when all arches
+     * support QOM topology.
+     */
+    CPUSlot *topo;
     struct NVDIMMState *nvdimms_state;
     struct NumaState *numa_state;
 };
diff --git a/include/hw/cpu/cpu-slot.h b/include/hw/cpu/cpu-slot.h
index 9d02d5de578e..24e122013bf7 100644
--- a/include/hw/cpu/cpu-slot.h
+++ b/include/hw/cpu/cpu-slot.h
@@ -69,4 +69,6 @@ struct CPUSlot {
     DeviceListener listener;
 };
 
+void machine_plug_cpu_slot(MachineState *ms);
+
 #endif /* CPU_SLOT_H */
diff --git a/system/vl.c b/system/vl.c
index fe547ca47c27..193e7049ccbe 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -2151,6 +2151,10 @@ static void qemu_create_machine(QDict *qdict)
                                           false, &error_abort);
         qobject_unref(default_opts);
     }
+
+    if (machine_class->smp_props.topo_tree_supported) {
+        machine_plug_cpu_slot(current_machine);
+    }
 }
 
 static int global_init_func(void *opaque, QemuOpts *opts, Error **errp)
-- 
2.34.1


