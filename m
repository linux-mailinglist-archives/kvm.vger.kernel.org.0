Return-Path: <kvm+bounces-2965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CC017FF22B
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:37:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4801D284263
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 212934A9A8;
	Thu, 30 Nov 2023 14:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nUj74zqD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BA1B5
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701355004; x=1732891004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q0lEBoFOr9b0x5amAD6sBLj9mxt45Se06XmWgm72SHY=;
  b=nUj74zqDINuxUZOlgNtCRJHq2FD1g5s9yi+zws0qeYENwPxDkYRTVua7
   bY6WNGp5r16CeksvgdFGj/fgmOcYh29mIzS5glhSn4DPWopLTcxfoqfZ2
   aK7BTyLmE8mldRzx51qiPe8joqRH9C+oNBT6D4qIqEHuX9b2EY6YxMWny
   RiLG9UbBNR8Inlfv+Cpqla+xuj9wOpaqSF+S6UYxu1GiQMGIQe0vaeELg
   CSKeFwOXQXNK1MixE1ocTuLyB8qtT0Mhq4FGp9zh0C1Gpq/pVwMZ/Nmie
   gwk2Q1/Y8Ss3SHCuspupey40gfsz2Kv7PyIqRpmsp4w8B4DmQilTMXqZm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532780"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532780"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:36:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730530"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730530"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:36:33 -0800
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
Subject: [RFC 39/41] hw/i386: Add the interface to search parent for QOM topology
Date: Thu, 30 Nov 2023 22:42:01 +0800
Message-Id: <20231130144203.2307629-40-zhao1.liu@linux.intel.com>
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

QOM topology needs to search parent cpu-core for hotplugged CPU to
create topology child<> property in qdev_set_id().

This process is before x86_cpu_pre_plug(), thus place 2 helpers
x86_cpu_assign_apic_id() and x86_cpu_assign_topo_id() in
x86_cpu_search_parent_pre_plug() to help get the correct topology sub
indexes. Then x86_cpu_search_parent_pre_plug() searches the parent
cpu-core with these sub indexes.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/x86.c         | 128 +++++++++++++++++++++++++++++++++++++++---
 include/hw/i386/x86.h |   3 +
 2 files changed, 122 insertions(+), 9 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 04edd6de6aeb..595d4365fdd1 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -460,16 +460,18 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
         return;
     }
 
-    /* if 'address' properties socket-id/core-id/thread-id are not set, set them
-     * so that machine_query_hotpluggable_cpus would show correct values
+    /*
+     * possible_cpus_qom_granu means the QOM topology support.
+     *
+     * TODO: Drop the "!mc->smp_props.possible_cpus_qom_granu" case when
+     * i386 completes QOM topology support.
      */
-    /* TODO: move socket_id/core_id/thread_id checks into x86_cpu_realizefn()
-     * once -smp refactoring is complete and there will be CPU private
-     * CPUState::nr_cores and CPUState::nr_threads fields instead of globals */
-    x86_topo_ids_from_apicid(cpu->apic_id, &topo_info, &topo_ids);
-    x86_cpu_assign_topo_id(cpu, &topo_ids, errp);
-    if (*errp) {
-        return;
+    if (!mc->smp_props.possible_cpus_qom_granu) {
+        x86_topo_ids_from_apicid(cpu->apic_id, &topo_info, &topo_ids);
+        x86_cpu_assign_topo_id(cpu, &topo_ids, errp);
+        if (*errp) {
+            return;
+        }
     }
 
     if (hyperv_feat_enabled(cpu, HYPERV_FEAT_VPINDEX) &&
@@ -484,6 +486,114 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
     numa_cpu_pre_plug(cpu_slot, dev, errp);
 }
 
+static int x86_cpu_get_topo_id_by_level(X86CPU *cpu,
+                                        CPUTopoLevel level)
+{
+    switch (level) {
+    case CPU_TOPO_THREAD:
+        return cpu->thread_id;
+    case CPU_TOPO_CORE:
+        return cpu->core_id;
+    case CPU_TOPO_DIE:
+        return cpu->die_id;
+    case CPU_TOPO_SOCKET:
+        return cpu->socket_id;
+    default:
+        g_assert_not_reached();
+    }
+
+    return -1;
+}
+
+typedef struct SearchCoreCb {
+    X86CPU *cpu;
+    CPUTopoState *parent;
+    int id;
+} SearchCoreCb;
+
+static int x86_cpu_search_parent_core(CPUTopoState *topo,
+                                      void *opaque)
+{
+    SearchCoreCb *cb = opaque;
+    CPUTopoLevel level = CPU_TOPO_LEVEL(topo);
+
+    cb->parent = topo;
+    cb->id = x86_cpu_get_topo_id_by_level(cb->cpu, level);
+
+    if (cb->id == topo->index) {
+        if (level == CPU_TOPO_CORE) {
+            return TOPO_FOREACH_END;
+        }
+        return TOPO_FOREACH_CONTINUE;
+    }
+    return TOPO_FOREACH_SIBLING;
+}
+
+Object *x86_cpu_search_parent_pre_plug(CPUTopoState *topo,
+                                       CPUTopoState *root,
+                                       Error **errp)
+{
+    int ret;
+    SearchCoreCb cb;
+    X86CPUTopoIDs topo_ids;
+    X86CPUTopoInfo topo_info;
+    X86CPU *cpu = X86_CPU(topo);
+    CPUSlot *slot = CPU_SLOT(root);
+    MachineState *ms = slot->ms;
+    DECLARE_BITMAP(foreach_bitmap, USER_AVAIL_LEVEL_NUM);
+
+    topo_info.dies_per_pkg = ms->smp.dies;
+    topo_info.cores_per_die = ms->smp.cores;
+    topo_info.threads_per_core = ms->smp.threads;
+
+    if (cpu->apic_id == UNASSIGNED_APIC_ID) {
+        x86_cpu_assign_apic_id(ms, cpu, &topo_ids, &topo_info, errp);
+        if (*errp) {
+            return NULL;
+        }
+    } else {
+        /*
+         * if 'address' properties socket-id/core-id/thread-id are not set,
+         * set them so that machine_query_hotpluggable_cpus would show
+         * correct values.
+         *
+         * TODO: move socket_id/core_id/thread_id checks into
+         * x86_cpu_realizefn() once -smp refactoring is complete and there
+         * will be CPU private CPUState::nr_cores and CPUState::nr_threads
+         * fields instead of globals.
+         */
+        x86_topo_ids_from_apicid(cpu->apic_id, &topo_info, &topo_ids);
+    }
+
+    x86_cpu_assign_topo_id(cpu, &topo_ids, errp);
+    if (*errp) {
+        return NULL;
+    }
+
+    cb.cpu = cpu;
+    cb.parent = NULL;
+    cb.id = -1;
+    bitmap_fill(foreach_bitmap, USER_AVAIL_LEVEL_NUM);
+    clear_bit(CPU_TOPO_UNKNOWN, foreach_bitmap);
+    clear_bit(CPU_TOPO_THREAD, foreach_bitmap);
+
+    ret = cpu_topo_child_foreach_recursive(root, foreach_bitmap,
+                                           x86_cpu_search_parent_core, &cb);
+    if (ret != TOPO_FOREACH_END) {
+        g_autofree char *search_info = NULL;
+
+        search_info = !cb.parent ? g_strdup("") :
+            g_strdup_printf(" for %s level with id: %d",
+            cpu_topo_level_to_string(CPU_TOPO_LEVEL(cb.parent)), cb.id);
+        error_setg(errp, "Can't find parent%s", search_info);
+        return NULL;
+    }
+
+    /* Keep the index of CPU topology device the same as the thread_id. */
+    topo->index = cpu->thread_id;
+    return OBJECT(cb.parent);
+}
+
 CpuInstanceProperties
 x86_cpu_index_to_props(MachineState *ms, unsigned cpu_index)
 {
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index 19e9f93fe286..e8c9ddc36359 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -104,6 +104,9 @@ int64_t x86_get_default_cpu_node_id(const MachineState *ms, int idx);
 const CPUArchIdList *x86_possible_cpu_arch_ids(MachineState *ms);
 CPUArchId *x86_find_cpu_slot(MachineState *ms, uint32_t id, int *idx);
 void x86_rtc_set_cpus_count(ISADevice *rtc, uint16_t cpus_count);
+Object *x86_cpu_search_parent_pre_plug(CPUTopoState *topo,
+                                       CPUTopoState *root,
+                                       Error **errp);
 void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
                       DeviceState *dev, Error **errp);
 void x86_cpu_plug(HotplugHandler *hotplug_dev,
-- 
2.34.1


