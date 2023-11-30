Return-Path: <kvm+bounces-2939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9027FF1E9
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:33:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12E20282550
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A25FA51C32;
	Thu, 30 Nov 2023 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R+gEMEfJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AB185
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354774; x=1732890774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rj2qhjfojWttufVsjPIiSdC7tmdmcTNlZ7nywO+2iko=;
  b=R+gEMEfJ4x+WI/5fdTLisnrcJOalq4UZzhUxlxpPROMzdIEOIATj75ak
   VfUQqqw4qU9Ced+B9Lfqs4cC/DueS+yu3U4VDKDhv7LQKvVuLaZBxP+Px
   rq7vyD9HU1qOzcgbFGHx3PdN2aYzQXJDfrL9LJxSt44RBxngB1Y2dOtwM
   nnEmloWhZ5ZGW0yk5/rFb+F9CNuqnEsda83YVjjcwGCZ+2BqI9rUy7seG
   wNH0affpE6X2uWL2NiPs8pP4cOa8R7dSI4+mizlEOmVYkBiZ0QxX+1+FB
   kgSm6abPuC74PMeAIDCacsVx8VmBf9+PKyjSioayCHX5/fEGb7ET+Xvny
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479531710"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479531710"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:32:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942729870"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942729870"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:32:26 -0800
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
Subject: [RFC 13/41] hw/core/cpu: Convert CPU from general device to topology device
Date: Thu, 30 Nov 2023 22:41:35 +0800
Message-Id: <20231130144203.2307629-14-zhao1.liu@linux.intel.com>
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

Convert CPU to topology device then its parent topology devices could
count the number of CPUs when new CPUs are added into topology tree.

Note since CPUs are created from *_init_cpus() in MachineClass.init() or
added from hotplug way, it depends on board initialization. Thus CPU
topology device isn't marked as DEVICE_CATEGORY_CPU_DEF and it will only
be created after board initialization.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 accel/kvm/kvm-all.c   |  4 ++--
 hw/core/cpu-common.c  | 25 +++++++++++++++++++++----
 include/hw/core/cpu.h |  8 ++++++--
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index e39a810a4e92..2eee3eb95907 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3953,7 +3953,7 @@ static void query_stats(StatsResultList **result, StatsTarget target,
         break;
     case STATS_TARGET_VCPU:
         add_stats_entry(result, STATS_PROVIDER_KVM,
-                        cpu->parent_obj.canonical_path,
+                        DEVICE(cpu)->canonical_path,
                         stats_list);
         break;
     default:
@@ -4045,7 +4045,7 @@ static void query_stats_cb(StatsResultList **result, StatsTarget target,
         stats_args.names = names;
         stats_args.errp = errp;
         CPU_FOREACH(cpu) {
-            if (!apply_str_list_filter(cpu->parent_obj.canonical_path, targets)) {
+            if (!apply_str_list_filter(DEVICE(cpu)->canonical_path, targets)) {
                 continue;
             }
             query_stats_vcpu(cpu, &stats_args);
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index 82dae51a550b..e9ed84ff5386 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -195,6 +195,16 @@ static void cpu_common_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cpu = CPU(dev);
     Object *machine = qdev_get_machine();
+    CPUClass *cc = CPU_GET_CLASS(cpu);
+
+    /*
+     * The parent topology realize() must be completed before cpu_resume()
+     * where the CPU starts to run.
+     */
+    cc->parent_realize(dev, errp);
+    if (*errp) {
+        return;
+    }
 
     /* qdev_get_machine() can return something that's not TYPE_MACHINE
      * if this is one of the user-only emulators; in that case there's
@@ -225,6 +235,7 @@ static void cpu_common_realizefn(DeviceState *dev, Error **errp)
 static void cpu_common_unrealizefn(DeviceState *dev)
 {
     CPUState *cpu = CPU(dev);
+    CPUClass *cc = CPU_GET_CLASS(cpu);
 
     /* Call the plugin hook before clearing the cpu is fully unrealized */
     if (tcg_enabled()) {
@@ -233,6 +244,7 @@ static void cpu_common_unrealizefn(DeviceState *dev)
 
     /* NOTE: latest generic point before the cpu is fully unrealized */
     cpu_exec_unrealizefn(cpu);
+    cc->parent_unrealize(dev);
 }
 
 static void cpu_common_initfn(Object *obj)
@@ -275,6 +287,7 @@ static void cpu_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
     ResettableClass *rc = RESETTABLE_CLASS(klass);
+    CPUTopoClass *tc = CPU_TOPO_CLASS(klass);
     CPUClass *k = CPU_CLASS(klass);
 
     k->parse_features = cpu_common_parse_features;
@@ -282,9 +295,6 @@ static void cpu_class_init(ObjectClass *klass, void *data)
     k->has_work = cpu_common_has_work;
     k->gdb_read_register = cpu_common_gdb_read_register;
     k->gdb_write_register = cpu_common_gdb_write_register;
-    set_bit(DEVICE_CATEGORY_CPU, dc->categories);
-    dc->realize = cpu_common_realizefn;
-    dc->unrealize = cpu_common_unrealizefn;
     rc->phases.hold = cpu_common_reset_hold;
     cpu_class_init_props(dc);
     /*
@@ -292,11 +302,18 @@ static void cpu_class_init(ObjectClass *klass, void *data)
      * IRQs, adding reset handlers, halting non-first CPUs, ...
      */
     dc->user_creatable = false;
+    /* CPU is the minimum granularity for hotplug. */
+    dc->hotpluggable = true;
+    device_class_set_parent_realize(dc, cpu_common_realizefn,
+                                    &k->parent_realize);
+    device_class_set_parent_unrealize(dc, cpu_common_unrealizefn,
+                                      &k->parent_unrealize);
+    tc->level = CPU_TOPO_THREAD;
 }
 
 static const TypeInfo cpu_type_info = {
     .name = TYPE_CPU,
-    .parent = TYPE_DEVICE,
+    .parent = TYPE_CPU_TOPO,
     .instance_size = sizeof(CPUState),
     .instance_init = cpu_common_initfn,
     .instance_finalize = cpu_common_finalize,
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index c0c8320413e5..a700f7c39140 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -20,6 +20,7 @@
 #ifndef QEMU_CPU_H
 #define QEMU_CPU_H
 
+#include "hw/core/cpu-topo.h"
 #include "hw/qdev-core.h"
 #include "disas/dis-asm.h"
 #include "exec/cpu-common.h"
@@ -146,7 +147,7 @@ struct SysemuCPUOps;
  */
 struct CPUClass {
     /*< private >*/
-    DeviceClass parent_class;
+    CPUTopoClass parent_class;
     /*< public >*/
 
     ObjectClass *(*class_by_name)(const char *cpu_model);
@@ -191,6 +192,9 @@ struct CPUClass {
     int reset_dump_flags;
     int gdb_num_core_regs;
     bool gdb_stop_before_watchpoint;
+
+    DeviceRealize parent_realize;
+    DeviceUnrealize parent_unrealize;
 };
 
 /*
@@ -456,7 +460,7 @@ struct qemu_work_item;
  */
 struct CPUState {
     /*< private >*/
-    DeviceState parent_obj;
+    CPUTopoState parent_obj;
     /* cache to avoid expensive CPU_GET_CLASS */
     CPUClass *cc;
     /*< public >*/
-- 
2.34.1


