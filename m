Return-Path: <kvm+bounces-29410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D6AEF9AA348
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 15:36:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3BB6CB2260C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 13:36:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FF8E19E833;
	Tue, 22 Oct 2024 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hDy9n6ee"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C151919D8A8
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729604196; cv=none; b=iCOuD1AyknaKBg+SErWIQggsdG0M9rR4K9HG25n0iV4H5/DYJ6EcQ5LLDkV1KB3ikZ+NkCWR8R8ma+4LnvxuKb5KG7if68dC3mOYBo3xnxTqI2Oa07x3l1Yn6ItkTd9Yikow0ErvPtwmlfKmyqmJuVG9oxjAwYU6xIx9A/utHHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729604196; c=relaxed/simple;
	bh=Git+7j02oNMDGgTgXnT+j1SOHf1VUhf6k7CHTi5Pq3w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S8WwnqguHx35gjgbsgcv05Y8rH48J5P7AqZO4xUy+sxeUW4lDX65WGyNMGtC/7ORD4bf81quXgAuHDHoKHgjVbpX4HVX+Z1AK9OAi/TTslbO8XrquuDcQd1FU8/SSs0Ja6fpQETfaXRjiMB8EeWpdg5g8Qc/eBpmGAW8a7xQxo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hDy9n6ee; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729604194; x=1761140194;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Git+7j02oNMDGgTgXnT+j1SOHf1VUhf6k7CHTi5Pq3w=;
  b=hDy9n6eeSikF5Bpi1aaeA2VryDRqViAOjrab61NwzSDYvULdmYWv8hMG
   Y29dPl+WtFjqS9z/mUZ2ogYSUUds7DlCjgrRza+Y0v4AbAMOWe/jtURvu
   Tdi5o5XDZ0Xv3yII17TGG9Xt10CUaORYE2moZcyzGABJQ5vL9mpOI6Kw0
   HHjJ5jCmx2ulZm0AukEy6+UzgNo1uKWw/B7Mrl6jyHtA8fsgXu3y9vfJz
   KTf55MtNbYrs9fqulgCmkKYrGjJR7YqI84oq4uB91cfg7SzFcfFBivYpr
   NcJNj2p5mO+pWlntH0Xe4HEphRXHTkngBK/Y9G3n9k5L6Z0gDr1iOojYz
   Q==;
X-CSE-ConnectionGUID: M9K2EQB+SBSJK7AMSHU4SA==
X-CSE-MsgGUID: IvaWKaBvSceE1HyM2Dupow==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="46603701"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="46603701"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 06:36:34 -0700
X-CSE-ConnectionGUID: Zu/J4WhNRKCC4Y6LAfIRJg==
X-CSE-MsgGUID: Ih/MATrcSBepcRjmz4lYDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="79782388"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 22 Oct 2024 06:36:29 -0700
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
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 5/9] hw/core: Add a helper to check the cache topology level
Date: Tue, 22 Oct 2024 21:51:47 +0800
Message-Id: <20241022135151.2052198-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241022135151.2052198-1-zhao1.liu@intel.com>
References: <20241022135151.2052198-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, we have no way to expose the arch-specific default cache
model because the cache model is sometimes related to the CPU model
(e.g., i386).

Since the user might configure "default" level, any comparison with
"default" is meaningless before the machine knows the specific level
that "default" refers to.

We can only check the correctness of the cache topology after the arch
loads the user-configured cache model from MachineState.smp_cache and
consumes the special "default" level by replacing it with the specific
level.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since Patch v3:
 * New commit to make cache topology check as a separate helper, so that
   arch-specific code could use this helper to check cache topology.
---
 hw/core/machine-smp.c | 48 +++++++++++++++++++++++++++++++++++++++++++
 include/hw/boards.h   |  1 +
 2 files changed, 49 insertions(+)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index ebb7a134a7be..640b2114b429 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -348,3 +348,51 @@ void machine_set_cache_topo_level(MachineState *ms, CacheLevelAndType cache,
 {
     ms->smp_cache.props[cache].topology = level;
 }
+
+/*
+ * When both cache1 and cache2 are configured with specific topology levels
+ * (not default level), is cache1's topology level higher than cache2?
+ */
+static bool smp_cache_topo_cmp(const SmpCache *smp_cache,
+                               CacheLevelAndType cache1,
+                               CacheLevelAndType cache2)
+{
+    /*
+     * Before comparing, the "default" topology level should be replaced
+     * with the specific level.
+     */
+    assert(smp_cache->props[cache1].topology != CPU_TOPOLOGY_LEVEL_DEFAULT);
+
+    return smp_cache->props[cache1].topology > smp_cache->props[cache2].topology;
+}
+
+/*
+ * Currently, we have no way to expose the arch-specific default cache model
+ * because the cache model is sometimes related to the CPU model (e.g., i386).
+ *
+ * We can only check the correctness of the cache topology after the arch loads
+ * the user-configured cache model from MachineState and consumes the special
+ * "default" level by replacing it with the specific level.
+ */
+bool machine_check_smp_cache(const MachineState *ms, Error **errp)
+{
+    if (smp_cache_topo_cmp(&ms->smp_cache, CACHE_LEVEL_AND_TYPE_L1D,
+                           CACHE_LEVEL_AND_TYPE_L2) ||
+        smp_cache_topo_cmp(&ms->smp_cache, CACHE_LEVEL_AND_TYPE_L1I,
+                           CACHE_LEVEL_AND_TYPE_L2)) {
+        error_setg(errp,
+                   "Invalid smp cache topology. "
+                   "L2 cache topology level shouldn't be lower than L1 cache");
+        return false;
+    }
+
+    if (smp_cache_topo_cmp(&ms->smp_cache, CACHE_LEVEL_AND_TYPE_L2,
+                           CACHE_LEVEL_AND_TYPE_L3)) {
+        error_setg(errp,
+                   "Invalid smp cache topology. "
+                   "L3 cache topology level shouldn't be lower than L2 cache");
+        return false;
+    }
+
+    return true;
+}
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 3d6cb5acd6c7..192f78539a6e 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -53,6 +53,7 @@ CpuTopologyLevel machine_get_cache_topo_level(const MachineState *ms,
                                               CacheLevelAndType cache);
 void machine_set_cache_topo_level(MachineState *ms, CacheLevelAndType cache,
                                   CpuTopologyLevel level);
+bool machine_check_smp_cache(const MachineState *ms, Error **errp);
 void machine_memory_devices_init(MachineState *ms, hwaddr base, uint64_t size);
 
 /**
-- 
2.34.1


