Return-Path: <kvm+bounces-34786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F3DCA05F3B
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3031D1884AE0
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 14:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3D91FF617;
	Wed,  8 Jan 2025 14:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nRgATMrx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A551FECC1
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736347414; cv=none; b=LA/ZUiPble1nf6CrDriVOBmYJqNxJ19o1pYD7L474l/N2kYydwX4X0EzmlsiTaDfspnjz2ORwJLYij5hXle2Zv9SX4vGKEu4iK8PMmXJJ6tl66VyyMdJJVkBX4XY9TqEk8bQf8tQ95OwJVTWw02mrdSdaru8j+mI+OznAn9yK/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736347414; c=relaxed/simple;
	bh=o68AVswZC8MMXvOqV0CQg1sP/nxOf+4m/m/wx22k+98=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UeP/SmM8MRNfCc0e64J4dUehgOTe91Rlraeh92S7YvaphjF307w/kRKXiFwVjju2BDK4qz+xmVfKZ8CUebH2xN95sdnll1UMb0O4CUgCFN2QwYFDLmEr3Q1AZjXI3/YFbqGjMnzd595qBvweq76xs2f2K4LmFGm+uZBF5uV6rNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nRgATMrx; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736347413; x=1767883413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o68AVswZC8MMXvOqV0CQg1sP/nxOf+4m/m/wx22k+98=;
  b=nRgATMrxsna2XJ2Z+t7VATrQdlfFE0liirdQ3h8k4/ZpKr+Frxp8mYxa
   AYpqtWVz+39QEIApKaMu8nDodHmPTmRrbR9Vn4zYjC373VGYcxz0a4uie
   prmXaMLuas7zHTU9HeoRy7mQ5UsNCWaRih7cYqz5nfBAA64jxzEnqDNIU
   MI3Pz7eGrbaH5Ftz3Gm3OgibWQ4ynnN8zCWuGjRlO9C6jlfVTi8mVRPSp
   1Nc1Y+xblJOToOW6O2SFvMVSFDnddgWu7wgYonn2efwzDkDeIlCaClsJl
   JL1jbqQe+xbmRff08t/CQlx+POf4kwtQxZWmhF0XtUEnjtoPFWEtQFHvJ
   A==;
X-CSE-ConnectionGUID: m9I1ZzKITo+VNJ0Zh7pVdA==
X-CSE-MsgGUID: PoDcTemWR8eoKq2viibkqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36737411"
X-IronPort-AV: E=Sophos;i="6.12,298,1728975600"; 
   d="scan'208";a="36737411"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 06:43:33 -0800
X-CSE-ConnectionGUID: A1Fh/xaFStmV8MFQjqItgA==
X-CSE-MsgGUID: UeLOM+hbSY6U9SaaFq4sLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103969407"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa008.jf.intel.com with ESMTP; 08 Jan 2025 06:43:29 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v7 5/5] i386/cpu: add has_caches flag to check smp_cache configuration
Date: Wed,  8 Jan 2025 23:01:50 +0800
Message-Id: <20250108150150.1258529-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250108150150.1258529-1-zhao1.liu@intel.com>
References: <20250108150150.1258529-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alireza Sanaee <alireza.sanaee@huawei.com>

Add has_caches flag to SMPCompatProps, which helps in avoiding
extra checks for every single layer of caches in x86 (and ARM in
future).

Signed-off-by: Alireza Sanaee <alireza.sanaee@huawei.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
Note: Picked from Alireza's series with the changes:
 * Moved the flag to SMPCompatProps with a new name "has_caches".
   This way, it remains consistent with the function and style of
   "has_clusters" in SMPCompatProps.
 * Dropped my previous TODO with the new flag.
---
Changes since Patch v2:
 * Picked a new patch frome Alireza's ARM smp-cache series.
---
 hw/core/machine-smp.c |  2 ++
 include/hw/boards.h   |  3 +++
 target/i386/cpu.c     | 11 +++++------
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index 4e020c358b66..0be0ac044c22 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -332,6 +332,8 @@ bool machine_parse_smp_cache(MachineState *ms,
             return false;
         }
     }
+
+    mc->smp_props.has_caches = true;
     return true;
 }
 
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 2ad711e56dbe..97125b027070 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -156,6 +156,8 @@ typedef struct {
  * @modules_supported - whether modules are supported by the machine
  * @cache_supported - whether cache (l1d, l1i, l2 and l3) configuration are
  *                    supported by the machine
+ * @has_caches - whether cache properties are explicitly specified in the
+ *               user provided smp-cache configuration
  */
 typedef struct {
     bool prefer_sockets;
@@ -166,6 +168,7 @@ typedef struct {
     bool drawers_supported;
     bool modules_supported;
     bool cache_supported[CACHE_LEVEL_AND_TYPE__MAX];
+    bool has_caches;
 } SMPCompatProps;
 
 /**
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b6d6c4b96d49..7bc619236680 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8040,13 +8040,12 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
 #ifndef CONFIG_USER_ONLY
     MachineState *ms = MACHINE(qdev_get_machine());
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
 
-    /*
-     * TODO: Add a SMPCompatProps.has_caches flag to avoid useless updates
-     * if user didn't set smp_cache.
-     */
-    if (!x86_cpu_update_smp_cache_topo(ms, cpu, errp)) {
-        return;
+    if (mc->smp_props.has_caches) {
+        if (!x86_cpu_update_smp_cache_topo(ms, cpu, errp)) {
+            return;
+        }
     }
 
     qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
-- 
2.34.1


