Return-Path: <kvm+bounces-18382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0398D8D4912
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 12:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B3C71C21B85
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 10:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA4C1761AB;
	Thu, 30 May 2024 10:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OTgs4dQH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804BE176190
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 10:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717063240; cv=none; b=KpiTsBeYS7CfvRiomToPCPql2d578FHCnai5Przjj2RRUL20Jhfd77Ej0qN+CgCZCH3i6QUB4B/foamMLB8HH8LKNR4wH4r6XdRjO9/sJZ3cIBJEq2bEhvGOrNjpuvn2TlBvduPRbU9VyNM5p2SVB6n0R3+YFTNqrU3TEK+/dFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717063240; c=relaxed/simple;
	bh=OUEY1PzrLtaJGQxKv2sq6ylcBSILR8gNfsV/1RqA31Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eAiYayAPHbEclUunP2qiNW7DiB/KaFN+h+/yNSUBE/JcoC/HwU/X1RgILvVBcODAvYmk+xxhHbwGOOJa9SbpY4wSIHCi/qIi6l9H+sLEJkDDTpl0AHZBtLwdqtIFm407vWVGp38eLdIImmaAMwVRYxeOXTMOzYMm1mVNjN7FfBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OTgs4dQH; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717063239; x=1748599239;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OUEY1PzrLtaJGQxKv2sq6ylcBSILR8gNfsV/1RqA31Y=;
  b=OTgs4dQHcvafOiHpuQhWTjgDImFc67+wa1w8c4orsv6b8aUutgN0BwVQ
   cktnHri7cK96VB/OVWh0FkyxAnJT15H4uQI5Wzqm9+ugDjrLCn9Z6Cb0j
   N8bcx6RzNi+bRnGbF+R3ZbJUxaecQRGLz75+KrQ/Cl2y3+kQmn/jO2tGe
   p+JrDC//BmfdNRCZh/2fjqFl/HabKp7/G5wWf9BJr0MhGz83NoMsSWe45
   BSgQU14ghXy3HreXOB013iArBELVpOEoij4jQqaId7X5rzOAytUdKb44C
   PdYFM7R6NhdjVFXFWga0hzr9nhAyhV4qD74myK//pngVef5p2l0F5+gmn
   A==;
X-CSE-ConnectionGUID: 8WUFXgwnSkS4shkgZaTCLA==
X-CSE-MsgGUID: wuM5jJ/JQf+57ezZSE1BUg==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="31032448"
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="31032448"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 03:00:37 -0700
X-CSE-ConnectionGUID: TKXLj6QZRxOqLu9u46k3EQ==
X-CSE-MsgGUID: dl3u8jibTlSRrNV7RvOg9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="35705007"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 30 May 2024 03:00:29 -0700
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
Subject: [RFC v2 2/7] hw/core: Define cache topology for machine
Date: Thu, 30 May 2024 18:15:34 +0800
Message-Id: <20240530101539.768484-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530101539.768484-1-zhao1.liu@intel.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define the cache topology based on CPU topology level for two reasons:

1. In practice, a cache will always be bound to the CPU container
   (either private in the CPU container or shared among multiple
   containers), and CPU container is often expressed in terms of CPU
   topology level.
2. The x86's cache-related CPUIDs encode cache topology based on APIC
   ID's CPU topology layout. And the ACPI PPTT table that ARM/RISCV
   relies on also requires CPU containers to help indicate the private
   shared hierarchy of the cache. Therefore, for SMP systems, it is
   natural to use the CPU topology hierarchy directly in QEMU to define
   the cache topology.

Currently, separated L1 cache (L1 data cache and L1 instruction cache)
with unified higher-level cache (e.g., unified L2 and L3 caches), is the
most common cache architectures.

Therefore, define the topology for L1 D-cache, L1 I-cache, L2 cache and
L3 cache in machine as the basic cache topology support.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/machine.c   |  5 +++++
 include/hw/boards.h | 25 +++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 8087026b45da..e31d0f3cb4b0 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1175,6 +1175,11 @@ static void machine_initfn(Object *obj)
     ms->smp.cores = 1;
     ms->smp.threads = 1;
 
+    ms->smp_cache.l1d = CPU_TOPO_LEVEL_INVALID;
+    ms->smp_cache.l1i = CPU_TOPO_LEVEL_INVALID;
+    ms->smp_cache.l2 = CPU_TOPO_LEVEL_INVALID;
+    ms->smp_cache.l3 = CPU_TOPO_LEVEL_INVALID;
+
     machine_copy_boot_config(ms, &(BootConfiguration){ 0 });
 }
 
diff --git a/include/hw/boards.h b/include/hw/boards.h
index c1737f2a5736..e70b2a1bdca2 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -10,6 +10,7 @@
 #include "qemu/module.h"
 #include "qom/object.h"
 #include "hw/core/cpu.h"
+#include "hw/core/cpu-topology.h"
 
 #define TYPE_MACHINE_SUFFIX "-machine"
 
@@ -145,6 +146,12 @@ typedef struct {
  * @books_supported - whether books are supported by the machine
  * @drawers_supported - whether drawers are supported by the machine
  * @modules_supported - whether modules are supported by the machine
+ * @l1_separated_cache_supported - whether l1 data and instruction cache
+ *                                 topology are supported by the machine
+ * @l2_unified_cache_supported - whether l2 unified cache topology are
+ *                               supported by the machine
+ * @l3_unified_cache_supported - whether l3 unified cache topology are
+ *                               supported by the machine
  */
 typedef struct {
     bool prefer_sockets;
@@ -154,6 +161,9 @@ typedef struct {
     bool books_supported;
     bool drawers_supported;
     bool modules_supported;
+    bool l1_separated_cache_supported;
+    bool l2_unified_cache_supported;
+    bool l3_unified_cache_supported;
 } SMPCompatProps;
 
 /**
@@ -359,6 +369,20 @@ typedef struct CPUTopology {
     unsigned int max_cpus;
 } CPUTopology;
 
+/**
+ * CPUTopology:
+ * @l1d: the CPU topology hierarchy the L1 data cache is shared at.
+ * @l1i: the CPU topology hierarchy the L1 instruction cache is shared at.
+ * @l2: the CPU topology hierarchy the L2 (unified) cache is shared at.
+ * @l3: the CPU topology hierarchy the L3 (unified) cache is shared at.
+ */
+typedef struct CacheTopology {
+    CPUTopoLevel l1d;
+    CPUTopoLevel l1i;
+    CPUTopoLevel l2;
+    CPUTopoLevel l3;
+} CacheTopology;
+
 /**
  * MachineState:
  */
@@ -410,6 +434,7 @@ struct MachineState {
     AccelState *accelerator;
     CPUArchIdList *possible_cpus;
     CPUTopology smp;
+    CacheTopology smp_cache;
     struct NVDIMMState *nvdimms_state;
     struct NumaState *numa_state;
 };
-- 
2.34.1


