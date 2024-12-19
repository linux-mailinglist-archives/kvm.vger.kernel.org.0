Return-Path: <kvm+bounces-34123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 556C69F76FF
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 09:14:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04C661885F70
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 08:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF035217735;
	Thu, 19 Dec 2024 08:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NfNvckpN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E953D1E47B6
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 08:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734596067; cv=none; b=VetO+Ge32I3u6QiB/2MexpNRWSb5rwKn7uhrjfDrt7/rXWbP9Vji7xrz2M7IeKzxYYP9666KmC5M0ObKsX5v1P37c7A8dxUKYKQP5xnL5oR9ZG3QJZfm9swDQiJ+YWs5PyOMyCXWS56bwN7qROG5yZjXwrAjOEGCSDLgfAFv07U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734596067; c=relaxed/simple;
	bh=Mb+owqHinrMW3eAUEPbSCPKa36X0p17DRzeg/seqFZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aVfvKtWywk4K1vxGZtnSU5HxgopjtDZ/CkQm2ETFkgnCkaTICCyrDtEmxw0PBunYWoOToGdDZROhuXegSuUlBWmKkmZDa9LD70nn0053SCansyYLxpXOw4Ya6SyZjxrcCbKcXjpeblgWBWIdIj2ERWZrvVwsrXe7YCoGz3eyeS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NfNvckpN; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734596066; x=1766132066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mb+owqHinrMW3eAUEPbSCPKa36X0p17DRzeg/seqFZs=;
  b=NfNvckpNEeo2afF8KmQyILhLchVebfLHYpaIaL3tMwB7Jx1tuMjXnHHQ
   6tRyfQVWlhaD9xmeKFlYU0u4pFRnRXQqGGmWH5sfwDGnkTN3QDjdyMoSz
   BEhgq15ppmFIzjAJt4KEtt8O5rI8uB+wYRHkmqt9pRLU0796Ge6hhKtLi
   zE/qEP7BBE8fuqVEdmniB7U3rAKV24Zj9xfXaxwHTlRSs0Qp02Ca0A6Te
   /u156x8sjSjvUP5bfyR9FF3VK8C0knIhliRghPfO/yKP76r1d6MZtzkWz
   zGwdRK/fqAamV1K/LZCnGoCShWugnoncc3qnO67yG5Ho6bMX4kOecM/Vo
   w==;
X-CSE-ConnectionGUID: SVdig6PvSc6ae/O+K+nXhA==
X-CSE-MsgGUID: 6zXjxTknSVumaH3dB+eWzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="34378653"
X-IronPort-AV: E=Sophos;i="6.12,247,1728975600"; 
   d="scan'208";a="34378653"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 00:14:26 -0800
X-CSE-ConnectionGUID: e19KNwlHRdS/CObwwXSWzA==
X-CSE-MsgGUID: 4TUEQGL0TmS/GCoIpGNGdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="129097549"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 19 Dec 2024 00:14:22 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v6 3/4] i386/pc: Support cache topology in -machine for PC machine
Date: Thu, 19 Dec 2024 16:32:36 +0800
Message-Id: <20241219083237.265419-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241219083237.265419-1-zhao1.liu@intel.com>
References: <20241219083237.265419-1-zhao1.liu@intel.com>
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
Changes since Patch v3:
 * Described the omitting cache will use "default" level and described
   the default cache topology model of i386 PC machine. (Daniel)
---
 hw/i386/pc.c    |  4 ++++
 qemu-options.hx | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 92047ce8c9df..7804991229f1 100644
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
index cc694d3b890c..257563437c05 100644
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
@@ -159,6 +160,34 @@ SRST
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
+        CPU topology levels including ``thread``, ``core``, ``module``,
+        ``cluster``, ``die``, ``socket``, ``book``, ``drawer`` and a special
+        value ``default``. If ``default`` is set, then the cache topology will
+        follow the architecture's default cache topology model. If another
+        topology level is set, the cache will be shared at corresponding CPU
+        topology level. For example, ``topology=core`` makes the cache shared
+        by all threads within a core. The omitting cache will default to using
+        the ``default`` level.
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


