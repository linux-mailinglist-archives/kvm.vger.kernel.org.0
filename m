Return-Path: <kvm+bounces-30288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BAC39B8CC7
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 09:16:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F2391C223BC
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 08:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1E3156F3B;
	Fri,  1 Nov 2024 08:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PUVHH3dj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5DF149C47
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 08:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730448989; cv=none; b=lIlCqfiwzXlUpva7lwCdchko1ErbpgHXm8giXxWPSiTcJG/ac20HJItyiTM8/iR69tn/CzJMZ2tASB0z+O2LHvbHZosYGwqClrXRRsS93UAdAhkwovqs5t776kFbcHBurxievWN+UWxcmv+/gbdWJmiAyXQgdQ5vb7f1HGG8Yh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730448989; c=relaxed/simple;
	bh=hWW510RNnBQVWsS5NN5EuNjpKq2iNzrMpdnodY3x60Y=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LffkdGSpc//ttpuWjDawEiXGF6D/WZQEEj0xfN10uAYGi8Qc3iYNoahGqKS52vy6cNXQVARC/2VQXy1Dgqa9sXa+rYanXZ4YeNadOBn+cwRYtgoaoWsJCMIQttHnP4o//nl7liIMOUn6fQjFy3W3FEmrzHR6SJfAU6q0+SlYc6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PUVHH3dj; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730448988; x=1761984988;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=hWW510RNnBQVWsS5NN5EuNjpKq2iNzrMpdnodY3x60Y=;
  b=PUVHH3dj+HgL+zXhmvOtRq/3CWt3/NuOUnUF3QMM0y0acEvlvwq+RhyG
   ArmMEAGLL9SuzzCgiCH2TG1EIzStl9SWh2eoctj1mtOs8tHTOgvWZu9DX
   rnLwgniJJjNPucASKwF6OVHiYhGRJe01IBYh02xVLWr0aYC6Gm7Q4YzvJ
   noN+ak6lSSMh0F7f5X8Ec5kg/VJqP7Pysgsda3wiQYHgRiQhVfUZ71bie
   id6iC5W/G9nXeuns35oEdNCBqWq4PkouYWxbzj8WQGanp3rSJFNHA+Rjr
   1h18TIOImvPCo5zE9me2XroHVOmi4NAc1xvdgOcHqmmflZO1Mlf4pDXCO
   A==;
X-CSE-ConnectionGUID: 6XCgaF9mSbq+vh12JpDvvQ==
X-CSE-MsgGUID: s+Y71eHgRAy2tEfuon4IzQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="17846054"
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="17846054"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 01:16:27 -0700
X-CSE-ConnectionGUID: p/96yex/QsCHlmwk96VuAQ==
X-CSE-MsgGUID: bNhx6skIRDeQj4RNqMaPAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="86834620"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 01 Nov 2024 01:16:22 -0700
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
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 5/9] hw/core: Add a helper to check the cache topology level
Date: Fri,  1 Nov 2024 16:33:27 +0800
Message-Id: <20241101083331.340178-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241101083331.340178-1-zhao1.liu@intel.com>
References: <20241101083331.340178-1-zhao1.liu@intel.com>
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
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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
index cda12070fc52..e07fcf0983e1 100644
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


