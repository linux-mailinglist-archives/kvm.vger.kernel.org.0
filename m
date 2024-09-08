Return-Path: <kvm+bounces-26085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3004597078D
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 14:44:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B36811F2156D
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 12:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E8E0166312;
	Sun,  8 Sep 2024 12:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hj0a8+Uj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B418158207
	for <kvm@vger.kernel.org>; Sun,  8 Sep 2024 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725799446; cv=none; b=bIpJJABrvfq1A4QB55fJbbT8s7dl36CmjoQBRZUyrfTh3sU9zUR9FK4A3vTbskUQrf3IFE5FJtCh5tKCjKt+a19xZ38/F/UqRLka5KrvVOADDxmnzZlYx2BXu/tnj0Iue1BS8gRFM9f+az/dZ1wbi6j0+b1A7+0bej6sb6ub8eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725799446; c=relaxed/simple;
	bh=hMYhnFWxXSsAfwWdeOKrX4i9zZGtjRAXTsthyts1mB0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t12zFDT1bjTYKqa5IWEm7aQnKAYHVrgyvvclJ2k0MluksBQGKdDOoT/8SKw+QuDNdGsuwUy6uBesq+M2Tp3qCSEJjjBdrml02HLOtMV/gL31z5fuD2u8Kfba8/Tw8d8vHKp3WOwBcggedF1k+zZ/o+bvf4rBV/sndVw+bGsZbgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hj0a8+Uj; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725799445; x=1757335445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hMYhnFWxXSsAfwWdeOKrX4i9zZGtjRAXTsthyts1mB0=;
  b=Hj0a8+UjeB9Q73cX3ZTxpJg6zIJv6tWA+/Jc6n5ftCUVCf+7A4el0+ie
   1jFSOFHF1XZVzO+9Ov3gFT7a41xLksoqPgzlsTqxb91t4ZQn+v4O/eTmT
   1PakCEfdZfBMmgTloKZHTFnOyg6ZrVDaCGUvH/Bo3+aV1U8e4QkyFmnxS
   lBRnI6/wlodkzUMTw8hZSfB1VIngECKZUO4N1ibKUQ+8DAAdKG9OcLR/O
   7AhaR3SNoKgESYlbxKAcOuMDX+Y3Jp3nlUmVN7DjPuRddgDQKt/h8okmN
   Crd7gDwgOlUUHPLFtqoT8mhhYD4RoyoV/KqwRhUjBiinzXQHdKODjnoXC
   g==;
X-CSE-ConnectionGUID: veBPPWY6SXKTXwlk8POKbA==
X-CSE-MsgGUID: yGknIKSBT7SU3t3Hkn2ekw==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="28238278"
X-IronPort-AV: E=Sophos;i="6.10,212,1719903600"; 
   d="scan'208";a="28238278"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2024 05:44:05 -0700
X-CSE-ConnectionGUID: EjDF+9ZNR2CHqN/InLQCtw==
X-CSE-MsgGUID: RyU6ZH3iQmq7EhvumKf80A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,212,1719903600"; 
   d="scan'208";a="97196680"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 08 Sep 2024 05:43:59 -0700
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
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v2 7/7] i386/pc: Support cache topology in -machine for PC machine
Date: Sun,  8 Sep 2024 20:59:20 +0800
Message-Id: <20240908125920.1160236-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240908125920.1160236-1-zhao1.liu@intel.com>
References: <20240908125920.1160236-1-zhao1.liu@intel.com>
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
---
Changes since Patch v1:
 * Merged document into this patch. (Markus)

Changes since RFC v2:
 * Used cache_supported array.
---
 hw/i386/pc.c    |  4 ++++
 qemu-options.hx | 28 +++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index ba0ff511836c..d562fd25aad2 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1788,6 +1788,10 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
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
index d94e2cbbaeb1..3936ff3e77f9 100644
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
@@ -159,6 +160,31 @@ SRST
         ::
 
             -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512
+
+    ``smp-cache.0.cache=cachename,smp-cache.0.topology=topologylevel``
+        Define cache properties (now only the cache topology level) for SMP
+        system.
+
+        ``cache=cachename`` specifies the cache that the properties will be
+        applied on. This field is the combination of cache level and cache
+        type. Currently it supports ``l1d`` (L1 data cache), ``l1i`` (L1
+        instruction cache), ``l2`` (L2 unified cache) and ``l3`` (L3 unified
+        cache).
+
+        ``topology=topologylevel`` sets the cache topology level. It accepts
+        CPU topology levels including ``thread``, ``core``, ``module``,
+        ``cluster``, ``die``, ``socket``, ``book``, ``drawer`` and a special
+        value ``default``. If ``default`` is set, then the cache topology will
+        follow the architecture's default cache topology model. If other CPU
+        topology level is set, the cache will be shared at corresponding CPU
+        topology level. For example, ``topology=core`` makes the cache shared
+        in a core.
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


