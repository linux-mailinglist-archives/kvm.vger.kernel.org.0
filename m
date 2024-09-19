Return-Path: <kvm+bounces-27162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C86D97C3FD
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 07:56:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E91CC1F224C5
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 05:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC6377110;
	Thu, 19 Sep 2024 05:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dBKR5pCx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA3374424
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 05:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726725369; cv=none; b=kUKBe+xrhYpBLok77dhxxJrn9mq2OiY+VVTSmOCr1y/NTNrQUFrbHvErDHzWW3eldVUpcXthgmFRbr6wPHxBufj0WE+/KqTzBlX2cD/eQY3YaTjRoI3bMdFNz9pJMD4ArWP6kZqrnsikXU2zmOHn2i1Ej+/rGzDVFhk41HQw7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726725369; c=relaxed/simple;
	bh=8gzS+6OwF3KgPtXFuFeQ8LrUaVl5pHIgZpajPFYb5x4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bBU1hMsxnWWM/W3/FPI3ovNcoXHEREAudcE473ETC7NgkthgYP6oj/3HfJ2rnGeKlKylxL80gHi0PTBN3v8yerKnpA0F08PEY0E4gDoh6M/AxOfL1XlaltysD6XjUtHX839KvJyGQvYdfd4qbn3XxWOIFpFNdA6OY3VBN7/GF4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dBKR5pCx; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726725368; x=1758261368;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8gzS+6OwF3KgPtXFuFeQ8LrUaVl5pHIgZpajPFYb5x4=;
  b=dBKR5pCx73/q14nE9Sj85eck5FGfW32c+aZpy2lHyUtAV/r+mFWp+Pqd
   CyLszzkXxF+pc3RcRLprNrq5L7RnyyrIXPoo4MPuOt1lbaGH/JfnNFEqp
   NdVA8GMyB3LLbBPqLsWqsYHodlA/h0seYLU+QKusSs1uywFuerUpBqLKr
   Y/gDIuLeYjUstCSFz7HT5OCCbEopHqdd8cmf7NNj0/V+IDk6F3+Z8/N+J
   TInSrd+JeCdlNkglaz1jGwfIL/KHgWlRvMxAqupyaRRLl3U7MgeI85q5b
   j+jmvOZudTyTBt4zA00nfhz5zgVeqWinjRtorRciwFoTilVBzWW+vrJj5
   w==;
X-CSE-ConnectionGUID: 1wRQFCRKRfeyAw+cP9276w==
X-CSE-MsgGUID: rwp8HsXYRNe2rBEMs4iztw==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25813608"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25813608"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 22:56:07 -0700
X-CSE-ConnectionGUID: gUHshS+6Qa+f/5DU/ygquA==
X-CSE-MsgGUID: cvkL99LVRG6pb7HnWQ57VQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="69418731"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 18 Sep 2024 22:56:01 -0700
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
	Sergio Lopez <slp@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 06/12] hw/cpu: Constrain CPU topology tree with max_limit
Date: Thu, 19 Sep 2024 14:11:22 +0800
Message-Id: <20240919061128.769139-7-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919061128.769139-1-zhao1.liu@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Apply max_limit to CPU topology and prevent the number of topology
devices from exceeding the max limitation configured by user.

Additionally, ensure that CPUs created from the CLI via custom topology
meet at least the requirements of smp.cpus. This guarantees that custom
topology will always have CPUs.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/machine.c         |  4 ++++
 hw/cpu/cpu-slot.c         | 32 ++++++++++++++++++++++++++++++++
 include/hw/cpu/cpu-slot.h |  1 +
 include/hw/qdev-core.h    |  5 +++++
 4 files changed, 42 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index dedabd75c825..54fca9eb7265 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1684,6 +1684,10 @@ void machine_run_board_post_init(MachineState *machine, Error **errp)
 {
     MachineClass *machine_class = MACHINE_GET_CLASS(machine);
 
+    if (!machine_validate_topo_tree(machine, errp)) {
+        return;
+    }
+
     if (machine_class->post_init) {
         machine_class->post_init(machine);
     }
diff --git a/hw/cpu/cpu-slot.c b/hw/cpu/cpu-slot.c
index 2d16a2729501..f2b9c412926f 100644
--- a/hw/cpu/cpu-slot.c
+++ b/hw/cpu/cpu-slot.c
@@ -47,6 +47,7 @@ static void cpu_slot_device_realize(DeviceListener *listener,
 {
     CPUSlot *slot = container_of(listener, CPUSlot, listener);
     CPUTopoState *topo;
+    int max_children;
 
     if (!object_dynamic_cast(OBJECT(dev), TYPE_CPU_TOPO)) {
         return;
@@ -54,6 +55,13 @@ static void cpu_slot_device_realize(DeviceListener *listener,
 
     topo = CPU_TOPO(dev);
     cpu_slot_add_topo_info(slot, topo);
+
+    if (dev->parent_bus) {
+        max_children = slot->stat.entries[GET_CPU_TOPO_LEVEL(topo)].max_limit;
+        if (dev->parent_bus->num_children == max_children) {
+            qbus_mark_full(dev->parent_bus);
+        }
+    }
 }
 
 static void cpu_slot_del_topo_info(CPUSlot *slot, CPUTopoState *topo)
@@ -79,6 +87,10 @@ static void cpu_slot_device_unrealize(DeviceListener *listener,
 
     topo = CPU_TOPO(dev);
     cpu_slot_del_topo_info(slot, topo);
+
+    if (dev->parent_bus) {
+        qbus_mask_full(dev->parent_bus);
+    }
 }
 
 DeviceListener cpu_slot_device_listener = {
@@ -443,3 +455,23 @@ bool machine_parse_custom_topo_config(MachineState *ms,
 
     return true;
 }
+
+bool machine_validate_topo_tree(MachineState *ms, Error **errp)
+{
+    int cpus;
+
+    if (!ms->topo || !ms->topo->custom_topo_enabled) {
+        return true;
+    }
+
+    cpus = ms->topo->stat.entries[CPU_TOPOLOGY_LEVEL_THREAD].total_instances;
+    if (cpus < ms->smp.cpus) {
+        error_setg(errp, "machine requires at least %d online CPUs, "
+                   "but currently only %d CPUs",
+                   ms->smp.cpus, cpus);
+        return false;
+    }
+
+    /* TODO: Add checks for other levels to honor more -smp parameters. */
+    return true;
+}
diff --git a/include/hw/cpu/cpu-slot.h b/include/hw/cpu/cpu-slot.h
index 8d7e35aa1851..f56a0b08dca4 100644
--- a/include/hw/cpu/cpu-slot.h
+++ b/include/hw/cpu/cpu-slot.h
@@ -84,5 +84,6 @@ int get_max_topo_by_level(const MachineState *ms, CpuTopologyLevel level);
 bool machine_parse_custom_topo_config(MachineState *ms,
                                       const SMPConfiguration *config,
                                       Error **errp);
+bool machine_validate_topo_tree(MachineState *ms, Error **errp);
 
 #endif /* CPU_SLOT_H */
diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
index ddcaa329e3ec..3f2117e08774 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -1063,6 +1063,11 @@ static inline void qbus_mark_full(BusState *bus)
     bus->full = true;
 }
 
+static inline void qbus_mask_full(BusState *bus)
+{
+    bus->full = false;
+}
+
 void device_listener_register(DeviceListener *listener);
 void device_listener_unregister(DeviceListener *listener);
 
-- 
2.34.1


