Return-Path: <kvm+bounces-20929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AE37926DC0
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 05:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D3B81C20ECE
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 03:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2CFC1AAD7;
	Thu,  4 Jul 2024 03:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ON2jORmW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15591B7E4
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 03:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720062056; cv=none; b=Jfh9B+h14yddFJzBqh4G0HqscHQHEwviGTn+M55gpub226F4cpZ3meCXH3lRQERFx8zgz20qSzyHWryrHvdPLaSom1hwzOcY1sF7adg5nqvdGDzlZM0FnW14rYBst/epvwd1YwadwPALBB9IZrA5mZfQVPhr6R4JIRHZSkupnyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720062056; c=relaxed/simple;
	bh=cJpn7XSiZ7Mb8L0aHM8P5RDmFvQhG9OIMsLWeDo6r70=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JwTq/a3tutfS65Pg4igpX08u/qQvzd6JeapgmK755N/CPcWcESW4zfFIYtk3C208HT64U/SKLDKT1VRyYSN5dzTu9UiyNTWf/xVhJKpaCUL3xf+tMABDYJZAMm7X30S4H9YpjIDwZz/ViXJSojNFDN+1V1yR6/rG8qvKM5oJBEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ON2jORmW; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720062055; x=1751598055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cJpn7XSiZ7Mb8L0aHM8P5RDmFvQhG9OIMsLWeDo6r70=;
  b=ON2jORmWUw3IndwrYxxBhTD6SgQbLu4/SiL0v9DMLRobTiu/l1y8JMIQ
   5f3QlUhFIclXuuLao/86kLFcpKKOM8nHWY3eeZpLWN+jd5rMKBKhONOID
   BngpS6M4CxteB1QmOc5rSnasE9LotA5WSaJklGYO8DzXVbEonSFT7HWHy
   nTnp7S9Ge6AYWcpPBdzXneJyleE3kCaJ1iAuklwivarezwWMIiH70hBjJ
   R1LiRKrTEhhJy93UmZfFXOTKG/iUJ2R5WRrc2lB/VOeMifD4o6l7KR+r+
   hvgWn3bYvqQ6dbjNcZJFYC3PsOYN5G7qw6OHpa1edPZYkWyUt0lQztDp8
   A==;
X-CSE-ConnectionGUID: C5PzgsREQrSlanXZud/KhQ==
X-CSE-MsgGUID: tvVjVIRLR+2CsEbzpxrPGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="39838118"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="39838118"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 20:00:53 -0700
X-CSE-ConnectionGUID: ng4MCgfcS9SjCwgQvP5iWg==
X-CSE-MsgGUID: AHgzNJo6RNOHpJb5KadZig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51052298"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 03 Jul 2024 20:00:48 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 4/8] hw/core: Check smp cache topology support for machine
Date: Thu,  4 Jul 2024 11:15:59 +0800
Message-Id: <20240704031603.1744546-5-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240704031603.1744546-1-zhao1.liu@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add cache_supported flags in SMPCompatProps to allow machines to
configure various caches support.

And implement check() method for machine's "smp-cache" link property,
which will check the compatibility of the cache properties with the
machine support.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since RFC v2:
 * Split as a separate commit to just include compatibility checking and
   topology checking.
 * Allow setting "default" topology level even though the cache
   isn't supported by machine. (Daniel)
---
 hw/core/machine-smp.c | 80 +++++++++++++++++++++++++++++++++++++++++++
 hw/core/machine.c     | 17 +++++++--
 include/hw/boards.h   |  6 ++++
 3 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index 88a73743eb1c..bf6f2f91070d 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -276,3 +276,83 @@ CpuTopologyLevel machine_get_cache_topo_level(const MachineState *ms,
 {
     return ms->smp_cache->props[cache].topo;
 }
+
+static bool machine_check_topo_support(MachineState *ms,
+                                       CpuTopologyLevel topo,
+                                       Error **errp)
+{
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+
+    if ((topo == CPU_TOPO_LEVEL_MODULE && !mc->smp_props.modules_supported) ||
+        (topo == CPU_TOPO_LEVEL_CLUSTER && !mc->smp_props.clusters_supported) ||
+        (topo == CPU_TOPO_LEVEL_DIE && !mc->smp_props.dies_supported) ||
+        (topo == CPU_TOPO_LEVEL_BOOK && !mc->smp_props.books_supported) ||
+        (topo == CPU_TOPO_LEVEL_DRAWER && !mc->smp_props.drawers_supported)) {
+        error_setg(errp,
+                   "Invalid topology level: %s. "
+                   "The topology level is not supported by this machine",
+                   CpuTopologyLevel_str(topo));
+        return false;
+    }
+
+    return true;
+}
+
+/*
+ * When both cache1 and cache2 are configured with specific topology levels
+ * (not default level), is cache1's topology level higher than cache2?
+ */
+static bool smp_cache_topo_cmp(const SMPCache *smp_cache,
+                               SMPCacheName cache1,
+                               SMPCacheName cache2)
+{
+    if (smp_cache->props[cache1].topo != CPU_TOPO_LEVEL_DEFAULT &&
+        smp_cache->props[cache1].topo > smp_cache->props[cache2].topo) {
+        return true;
+    }
+    return false;
+}
+
+bool machine_check_smp_cache_support(MachineState *ms,
+                                     const SMPCache *smp_cache,
+                                     Error **errp)
+{
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+
+    for (int i = 0; i < SMP_CACHE__MAX; i++) {
+        const SMPCacheProperty *prop = &smp_cache->props[i];
+
+        /*
+         * Allow setting "default" topology level even though the cache
+         * isn't supported by machine.
+         */
+        if (prop->topo != CPU_TOPO_LEVEL_DEFAULT &&
+            !mc->smp_props.cache_supported[prop->name]) {
+            error_setg(errp,
+                       "%s cache topology not supported by this machine",
+                       SMPCacheName_str(prop->name));
+            return false;
+        }
+
+        if (!machine_check_topo_support(ms, prop->topo, errp)) {
+            return false;
+        }
+    }
+
+    if (smp_cache_topo_cmp(smp_cache, SMP_CACHE_L1D, SMP_CACHE_L2) ||
+        smp_cache_topo_cmp(smp_cache, SMP_CACHE_L1I, SMP_CACHE_L2)) {
+        error_setg(errp,
+                   "Invalid smp cache topology. "
+                   "L2 cache topology level shouldn't be lower than L1 cache");
+        return false;
+    }
+
+    if (smp_cache_topo_cmp(smp_cache, SMP_CACHE_L2, SMP_CACHE_L3)) {
+        error_setg(errp,
+                   "Invalid smp cache topology. "
+                   "L3 cache topology level shouldn't be lower than L2 cache");
+        return false;
+    }
+
+    return true;
+}
diff --git a/hw/core/machine.c b/hw/core/machine.c
index 09ef9fcd4a0b..802dd56ba717 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -926,6 +926,20 @@ static void machine_set_smp(Object *obj, Visitor *v, const char *name,
     machine_parse_smp_config(ms, config, errp);
 }
 
+static void machine_check_smp_cache(const Object *obj, const char *name,
+                                    Object *child, Error **errp)
+{
+    MachineState *ms = MACHINE(obj);
+    SMPCache *smp_cache = SMP_CACHE(child);
+
+    if (ms->smp_cache) {
+        error_setg(errp, "Invalid smp cache property. which has been set");
+        return;
+    }
+
+    machine_check_smp_cache_support(ms, smp_cache, errp);
+}
+
 static void machine_get_boot(Object *obj, Visitor *v, const char *name,
                             void *opaque, Error **errp)
 {
@@ -1045,11 +1059,10 @@ static void machine_class_init(ObjectClass *oc, void *data)
     object_class_property_set_description(oc, "smp",
         "CPU topology");
 
-    /* TODO: Implement check() method based on machine support. */
     object_class_property_add_link(oc, "smp-cache",
                                    TYPE_SMP_CACHE,
                                    offsetof(MachineState, smp_cache),
-                                   object_property_allow_set_link,
+                                   machine_check_smp_cache,
                                    OBJ_PROP_LINK_STRONG);
     object_class_property_set_description(oc, "smp-cache",
         "SMP cache property");
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 56fa252cfcd2..5455848c3e58 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -47,6 +47,9 @@ unsigned int machine_topo_get_cores_per_socket(const MachineState *ms);
 unsigned int machine_topo_get_threads_per_socket(const MachineState *ms);
 CpuTopologyLevel machine_get_cache_topo_level(const MachineState *ms,
                                               SMPCacheName cache);
+bool machine_check_smp_cache_support(MachineState *ms,
+                                     const SMPCache *smp_cache,
+                                     Error **errp);
 void machine_memory_devices_init(MachineState *ms, hwaddr base, uint64_t size);
 
 /**
@@ -147,6 +150,8 @@ typedef struct {
  * @books_supported - whether books are supported by the machine
  * @drawers_supported - whether drawers are supported by the machine
  * @modules_supported - whether modules are supported by the machine
+ * @cache_supported - whether cache topologies (l1d, l1i, l2 and l3) are
+ *                    supported by the machine
  */
 typedef struct {
     bool prefer_sockets;
@@ -156,6 +161,7 @@ typedef struct {
     bool books_supported;
     bool drawers_supported;
     bool modules_supported;
+    bool cache_supported[SMP_CACHE__MAX];
 } SMPCompatProps;
 
 /**
-- 
2.34.1


