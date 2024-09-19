Return-Path: <kvm+bounces-27109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B7C97C287
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38DDE1F21A80
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF43418E11;
	Thu, 19 Sep 2024 01:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jAyV+GEl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC1F1DA23
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710034; cv=none; b=HRTHWUlvY1gd+fd+rgdRRjQOWddlljHHPLPBjrTIfuEQmLw7EDz2pP8Qdc1XxjOkkuoqW7lGhrSIVPEH4NxbkBxN1acxagUGQ3huTA5QIddjIzTzRuFkik6tLfz12jL6Qlqu3ghM77uDDf2VQA2MQkoSOrUmkI590U0X9kiUlvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710034; c=relaxed/simple;
	bh=GsWICJ5+g1+q1v0KglBy1lWu3UY61FHqayyy9q2Rqsk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ku9dhIHEmEWcxTCYhDKEoQ+q60sDLcdOOAvxiOJEJOHGUbxFS88Y79UUft2d5wJ+dFc0/2VWdg7WuJtwV0WZxIYVhxbf0k8JUjk/XelP4YY8tU1ZAlhQT34jHD18ZuT3qp5SNpJ9+/sSW03l3DiRJpe7I6enZP4iAXNmc5Q6mH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jAyV+GEl; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710033; x=1758246033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GsWICJ5+g1+q1v0KglBy1lWu3UY61FHqayyy9q2Rqsk=;
  b=jAyV+GElpZchTCz5wRtKmy0OsD6ubtEHOR0nP0GcrejOhlUHCC/OUfM0
   CZg/cST3+j6OdHF1YrXUVKuy+j/vE9N+G/BExbyxK9fisknKYGP1q6vAW
   z70BVpyR6jUyqMXdWBZR/gVZ5i0PzWdoo9QMbEKpLiKKRq4OicbxvQMYn
   oNwXnSlO7enMB6VLNccMmYPc0Lk0Jc11MzRBluxgBmN7ZoMRsw6kl1/P4
   26QkN4CJUDPvZmj0wwrxFVZztyAM93VwDPl4JbxclWuiF6VtDJLVxLnvW
   quNxjU66fW9RgajXxB4Q2jCbRP69o5TqnGDKghjJCbeSgxaGy7WYo/CNk
   w==;
X-CSE-ConnectionGUID: lEXTSLawTsmE7FAULLQl3Q==
X-CSE-MsgGUID: 8rjsVyd5SQqKzmrrflzZrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25797905"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25797905"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:40:32 -0700
X-CSE-ConnectionGUID: BVbtC0uyT5+cD6+BxlQqYA==
X-CSE-MsgGUID: ZRQq89eASbGRoUgWB8SFRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058791"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:40:25 -0700
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
Subject: [RFC v2 07/15] hw/core/cpu: Convert CPU from general device to topology device
Date: Thu, 19 Sep 2024 09:55:25 +0800
Message-Id: <20240919015533.766754-8-zhao1.liu@intel.com>
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

Convert CPU to topology device then it can be added into topology tree.

Because CPU then inherits properties and settings of topology device,
make the following changes to take into account the special case for CPU:

 * Omit setting category since topology device has already set.

 * Make realize() of topology device as the parent realize().

 * Clean up some cases that assume parent obj is DeviceState and access
   parent_obj directly.

 * Set CPU's topology level as thread.

 * And one complex change: mask bus_type as NULL.

    - This is because for the arches don't support topology tree,
      there's no CPU bus bridge so that CPUs of these arches can't be
      created. So, only the CPU with arch supporting topology tree
      should override the bus_type field.

 * Further, support cpu_create() for the CPU with bus_type.

    - This is a corner case, some arch CPUs may set bus_type, and
      cpu_create() would be called in system emulation case (e.g., none
      machine). To handle such case, try to find the machine's CPU bus
      in cpu_create().

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 accel/kvm/kvm-all.c   |  4 ++--
 hw/core/cpu-common.c  | 42 +++++++++++++++++++++++++++++++++++++-----
 include/hw/core/cpu.h |  7 +++++--
 target/ppc/kvm.c      |  2 +-
 4 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index beb1988d12cf..48c040f6861d 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -4173,7 +4173,7 @@ static void query_stats(StatsResultList **result, StatsTarget target,
         break;
     case STATS_TARGET_VCPU:
         add_stats_entry(result, STATS_PROVIDER_KVM,
-                        cpu->parent_obj.canonical_path,
+                        DEVICE(cpu)->canonical_path,
                         stats_list);
         break;
     default:
@@ -4265,7 +4265,7 @@ static void query_stats_cb(StatsResultList **result, StatsTarget target,
         stats_args.names = names;
         stats_args.errp = errp;
         CPU_FOREACH(cpu) {
-            if (!apply_str_list_filter(cpu->parent_obj.canonical_path, targets)) {
+            if (!apply_str_list_filter(DEVICE(cpu)->canonical_path, targets)) {
                 continue;
             }
             query_stats_vcpu(cpu, &stats_args);
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index 7982ecd39a53..08f2d536ff6d 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -57,7 +57,19 @@ CPUState *cpu_create(const char *typename)
 {
     Error *err = NULL;
     CPUState *cpu = CPU(object_new(typename));
-    if (!qdev_realize(DEVICE(cpu), NULL, &err)) {
+    BusState *bus = NULL;
+
+    if (DEVICE_GET_CLASS(cpu)->bus_type) {
+        MachineState *ms;
+
+        ms = (MachineState *)object_dynamic_cast(qdev_get_machine(),
+                                                 TYPE_MACHINE);
+        if (ms) {
+            bus = BUS(&ms->topo->bus);
+        }
+    }
+
+    if (!qdev_realize(DEVICE(cpu), bus, &err)) {
         error_report_err(err);
         object_unref(OBJECT(cpu));
         exit(EXIT_FAILURE);
@@ -196,6 +208,12 @@ static void cpu_common_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cpu = CPU(dev);
     Object *machine = qdev_get_machine();
+    CPUClass *cc = CPU_GET_CLASS(cpu);
+
+    cc->parent_realize(dev, errp);
+    if (*errp) {
+        return;
+    }
 
     /* qdev_get_machine() can return something that's not TYPE_MACHINE
      * if this is one of the user-only emulators; in that case there's
@@ -302,6 +320,7 @@ static void cpu_common_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
     ResettableClass *rc = RESETTABLE_CLASS(klass);
+    CPUTopoClass *tc = CPU_TOPO_CLASS(klass);
     CPUClass *k = CPU_CLASS(klass);
 
     k->parse_features = cpu_common_parse_features;
@@ -309,9 +328,6 @@ static void cpu_common_class_init(ObjectClass *klass, void *data)
     k->has_work = cpu_common_has_work;
     k->gdb_read_register = cpu_common_gdb_read_register;
     k->gdb_write_register = cpu_common_gdb_write_register;
-    set_bit(DEVICE_CATEGORY_CPU, dc->categories);
-    dc->realize = cpu_common_realizefn;
-    dc->unrealize = cpu_common_unrealizefn;
     rc->phases.hold = cpu_common_reset_hold;
     cpu_class_init_props(dc);
     /*
@@ -319,11 +335,27 @@ static void cpu_common_class_init(ObjectClass *klass, void *data)
      * IRQs, adding reset handlers, halting non-first CPUs, ...
      */
     dc->user_creatable = false;
+    /*
+     * CPU is the minimum granularity for hotplug in most case, and
+     * often its hotplug handler is ultimately decided by the machine.
+     * For generality, set this flag to avoid blocking possible hotplug
+     * support.
+     */
+    dc->hotpluggable = true;
+    device_class_set_parent_realize(dc, cpu_common_realizefn,
+                                    &k->parent_realize);
+    dc->unrealize = cpu_common_unrealizefn;
+    /*
+     * Avoid archs that do not support topology device trees from
+     * encountering error when creating CPUs.
+     */
+    dc->bus_type = NULL;
+    tc->level = CPU_TOPOLOGY_LEVEL_THREAD;
 }
 
 static const TypeInfo cpu_type_info = {
     .name = TYPE_CPU,
-    .parent = TYPE_DEVICE,
+    .parent = TYPE_CPU_TOPO,
     .instance_size = sizeof(CPUState),
     .instance_init = cpu_common_initfn,
     .instance_finalize = cpu_common_finalize,
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 1c9c775df658..d7268bcb48cb 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -20,6 +20,7 @@
 #ifndef QEMU_CPU_H
 #define QEMU_CPU_H
 
+#include "hw/cpu/cpu-topology.h"
 #include "hw/qdev-core.h"
 #include "disas/dis-asm.h"
 #include "exec/breakpoint.h"
@@ -144,7 +145,7 @@ struct SysemuCPUOps;
  */
 struct CPUClass {
     /*< private >*/
-    DeviceClass parent_class;
+    CPUTopoClass parent_class;
     /*< public >*/
 
     ObjectClass *(*class_by_name)(const char *cpu_model);
@@ -189,6 +190,8 @@ struct CPUClass {
     int reset_dump_flags;
     int gdb_num_core_regs;
     bool gdb_stop_before_watchpoint;
+
+    DeviceRealize parent_realize;
 };
 
 /*
@@ -456,7 +459,7 @@ struct qemu_work_item;
  */
 struct CPUState {
     /*< private >*/
-    DeviceState parent_obj;
+    CPUTopoState parent_obj;
     /* cache to avoid expensive CPU_GET_CLASS */
     CPUClass *cc;
     /*< public >*/
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 907dba60d1b5..b3cc42e545af 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2351,7 +2351,7 @@ static void alter_insns(uint64_t *word, uint64_t flags, bool on)
 static bool kvmppc_cpu_realize(CPUState *cs, Error **errp)
 {
     int ret;
-    const char *vcpu_str = (cs->parent_obj.hotplugged == true) ?
+    const char *vcpu_str = (DEVICE(cs)->hotplugged == true) ?
                            "hotplug" : "create";
     cs->cpu_index = cpu_get_free_index();
 
-- 
2.34.1


