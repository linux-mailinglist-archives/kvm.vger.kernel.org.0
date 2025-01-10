Return-Path: <kvm+bounces-35053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 435E0A0938A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 15:33:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C17A3A9D8C
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 14:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BACDA211282;
	Fri, 10 Jan 2025 14:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EFVkm2O1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43423211269
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736519588; cv=none; b=Mzj9XLe9C/1NBXZ2HVFHZJl5kYchh1sn4DwEjamVDbtCYNmv4NEhrPck4CXqRrqT26oafS9nsNi1+X90fZAgkIE2UafLZh7+uL+mwdQBevLZtZAEHHniMnKHqHe1uN2wIVaxlx2gc1Y8s/1ttBRK5s1FYmaKc3AkNXV8iLaV9nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736519588; c=relaxed/simple;
	bh=GKO6Z3A/2gq1cK4JeQY1dLFLS2g//H2In2c4J8sWf4w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VfVIVa2tAq2BoVl34g4WS/141MX88hUA99zZDdMAGm5n9AKz/39Z5DH6LdjiUzATUmzTcXf3LUmHuWVbaHMDY0hHN+J0Bt2OZtu64hFOhaiVRskOoODpwWNQi3AzrIf3H/ZwBW0fVaLeSYV5qfbAQttaMSemPNYgzpigO6axndA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EFVkm2O1; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736519587; x=1768055587;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GKO6Z3A/2gq1cK4JeQY1dLFLS2g//H2In2c4J8sWf4w=;
  b=EFVkm2O19ncdZrD/HQxjppW1FDy1YXXtOKS9Y1prlrnoyVayQJROB4R5
   PZ4EXTxUwd3dbbW2VB8jilkrkh2HibNLxF+Y0Cx86s/q8VNlJPAfXndf+
   ezhlNyRlCkc81EGgw1qMFear/DosPEm7XMAzIE+35uL4Cp3EPNzHJszKR
   cdGB75ViDyGKwuVx5SRm+AE+tD7cIf6MmfZs7O13CIadZiVlhLftjBBIs
   Mhz006l+8qQ+W/Dl8TEvC3pTxH1PFaAqNWaqjKJuok8eUWtOyhPjnePke
   TOp9NeUk3SoCjkQ1x40zzuUxPtKHKkmzl7rf604CE2ZsqOkK7pLdaTlaU
   Q==;
X-CSE-ConnectionGUID: XdZN0gKRSxi4y3s8uxO6Pg==
X-CSE-MsgGUID: JKu6RnWWTfaXyNyokKFRiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11311"; a="62185532"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="62185532"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 06:33:07 -0800
X-CSE-ConnectionGUID: Y1SdWWLcSFqJKrQcQ/dT4A==
X-CSE-MsgGUID: KaeEoiZoTgekpe3lth96xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108790913"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 10 Jan 2025 06:33:02 -0800
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
	Zhao Liu <zhao1.liu@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v7 RESEND 4/5] i386/pc: Support cache topology in -machine for PC machine
Date: Fri, 10 Jan 2025 22:51:14 +0800
Message-Id: <20250110145115.1574345-5-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250110145115.1574345-1-zhao1.liu@intel.com>
References: <20250110145115.1574345-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow user to configure l1d, l1i, l2 and l3 cache topologies for PC
machine.

Additionally, add the document of "-machine smp-cache" in
qemu-options.hx.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
Changes since Patch v6:
 * Deleted the "thread" level from the allowed topology level parameters
   in the doc.

Changes since Patch v3:
 * Described the omitting cache will use "default" level and described
   the default cache topology model of i386 PC machine. (Daniel)
---
 hw/i386/pc.c    |  4 ++++
 qemu-options.hx | 30 +++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 53a2f226d038..b9b83d1936ae 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1797,6 +1797,10 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     mc->nvdimm_supported = true;
     mc->smp_props.dies_supported = true;
     mc->smp_props.modules_supported = true;
+    mc->smp_props.cache_supported[CACHE_LEVEL_AND_TYPE_L1D] = true;
+    mc->smp_props.cache_supported[CACHE_LEVEL_AND_TYPE_L1I] = true;
+    mc->smp_props.cache_supported[CACHE_LEVEL_AND_TYPE_L2] = true;
+    mc->smp_props.cache_supported[CACHE_LEVEL_AND_TYPE_L3] = true;
     mc->default_ram_id = "pc.ram";
     pcmc->default_smbios_ep_type = SMBIOS_ENTRY_POINT_TYPE_AUTO;
 
diff --git a/qemu-options.hx b/qemu-options.hx
index cc694d3b890c..60894fe2b52b 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -39,7 +39,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
     "                memory-encryption=@var{} memory encryption object to use (default=none)\n"
     "                hmat=on|off controls ACPI HMAT support (default=off)\n"
     "                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)\n"
-    "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n",
+    "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n"
+    "                smp-cache.0.cache=cachename,smp-cache.0.topology=topologylevel\n",
     QEMU_ARCH_ALL)
 SRST
 ``-machine [type=]name[,prop=value[,...]]``
@@ -159,6 +160,33 @@ SRST
         ::
 
             -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512
+
+    ``smp-cache.0.cache=cachename,smp-cache.0.topology=topologylevel``
+        Define cache properties for SMP system.
+
+        ``cache=cachename`` specifies the cache that the properties will be
+        applied on. This field is the combination of cache level and cache
+        type. It supports ``l1d`` (L1 data cache), ``l1i`` (L1 instruction
+        cache), ``l2`` (L2 unified cache) and ``l3`` (L3 unified cache).
+
+        ``topology=topologylevel`` sets the cache topology level. It accepts
+        CPU topology levels including ``core``, ``module``, ``cluster``, ``die``,
+        ``socket``, ``book``, ``drawer`` and a special value ``default``. If
+        ``default`` is set, then the cache topology will follow the architecture's
+        default cache topology model. If another topology level is set, the cache
+        will be shared at corresponding CPU topology level. For example,
+        ``topology=core`` makes the cache shared by all threads within a core.
+        The omitting cache will default to using the ``default`` level.
+
+        The default cache topology model for an i386 PC machine is as follows:
+        ``l1d``, ``l1i``, and ``l2`` caches are per ``core``, while the ``l3``
+        cache is per ``die``.
+
+        Example:
+
+        ::
+
+            -machine smp-cache.0.cache=l1d,smp-cache.0.topology=core,smp-cache.1.cache=l1i,smp-cache.1.topology=core
 ERST
 
 DEF("M", HAS_ARG, QEMU_OPTION_M,
-- 
2.34.1


