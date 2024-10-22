Return-Path: <kvm+bounces-29409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6D39AA347
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 15:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FA121F21B6C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 13:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33ED419E97C;
	Tue, 22 Oct 2024 13:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dnM2os3U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB69019D8A8
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729604190; cv=none; b=T5pr1spVDV0V7bDlSqOrxateaEsaTEt85DJKyXz7dwiE7xkagWp+ghQ7HaIYWMdVdUYbM26eZiporl4CMltQeQUlgFIMG5es5B+jI1niuT1FB7XYJZBi/H+0PbG57pUCFpHYdHS8H58OzyVGb1bFBPAm4Fr7JtNKk6qEv3fz3Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729604190; c=relaxed/simple;
	bh=v5TiGfpxtPYi3dX2SWWuKk9xXE8fMz5ejTsMCeSkh9w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kd5B5uTgKDW06mxGjcsKcUY3VS+/7HaZ9o7bGbaYS/DqxoWSKIkSVnoKJJ0nNbz0wS+y5TEpxm4mG16aeoNdHSrvD69I6EwPPZRC7sMfKXzllWcUjOApki0pmeN3tPfnaGv/tyWnT72IGEawmWG2oVVCm8fMjYviHH4RBk/PT8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dnM2os3U; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729604188; x=1761140188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v5TiGfpxtPYi3dX2SWWuKk9xXE8fMz5ejTsMCeSkh9w=;
  b=dnM2os3UpyMWwHVHLl1DisfNa6ByjxdJ+FKRoIgJxidtavRGjpZ6LKFE
   4QRLELsorJI0lc83gvxBCcgGhzJDHIhgJz+zLmYSsWjCpAiThDW57SMdI
   ueZlwNjGxCYl2BeXZAX4UxpSkglUgRc4pf2iWo9nQ0GU8lZbe0b65tZqt
   hPsv9Qj7lyDk8KZnv87OXn+8NVAV2jZD4piULnyoL3wxBo2ld8PKbJ3fo
   oNm5DwiMIfU/ylSfPieYw6aJanflBI2+eO8pI4A51elMwEq+Kxs91IeYA
   QB9aEImAyV/Gn4DKAFQdDGoaSIbEzc32Y5ASjrtvDqSjUrBX79Dn3INQQ
   g==;
X-CSE-ConnectionGUID: sqiF6wQ4RECZu4zwWKrBQA==
X-CSE-MsgGUID: adWhjDi3S/ikPBdaAfXSEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="46603684"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="46603684"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 06:36:28 -0700
X-CSE-ConnectionGUID: bbz1toxaTLeTW4jo0tZrGw==
X-CSE-MsgGUID: kKpqBDGMQhmbIvVHDl74SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="79782373"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 22 Oct 2024 06:36:23 -0700
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
	Zhao Liu <zhao1.liu@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v4 4/9] hw/core: Check smp cache topology support for machine
Date: Tue, 22 Oct 2024 21:51:46 +0800
Message-Id: <20241022135151.2052198-5-zhao1.liu@intel.com>
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

Add cache_supported flags in SMPCompatProps to allow machines to
configure various caches support.

And check the compatibility of the cache properties with the
machine support in machine_parse_smp_cache().

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
Changes since Patch v3:
 * Dropped cache level check because if some fields is marked as
   default, then we can't guarentee the hierarchies are correct.
   (Daniel)
---
 hw/core/machine-smp.c | 41 +++++++++++++++++++++++++++++++++++++++++
 include/hw/boards.h   |  3 +++
 2 files changed, 44 insertions(+)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index c6d90cd6d413..ebb7a134a7be 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -261,10 +261,32 @@ void machine_parse_smp_config(MachineState *ms,
     }
 }
 
+static bool machine_check_topo_support(MachineState *ms,
+                                       CpuTopologyLevel topo,
+                                       Error **errp)
+{
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+
+    if ((topo == CPU_TOPOLOGY_LEVEL_MODULE && !mc->smp_props.modules_supported) ||
+        (topo == CPU_TOPOLOGY_LEVEL_CLUSTER && !mc->smp_props.clusters_supported) ||
+        (topo == CPU_TOPOLOGY_LEVEL_DIE && !mc->smp_props.dies_supported) ||
+        (topo == CPU_TOPOLOGY_LEVEL_BOOK && !mc->smp_props.books_supported) ||
+        (topo == CPU_TOPOLOGY_LEVEL_DRAWER && !mc->smp_props.drawers_supported)) {
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
 bool machine_parse_smp_cache(MachineState *ms,
                              const SmpCachePropertiesList *caches,
                              Error **errp)
 {
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
     const SmpCachePropertiesList *node;
     DECLARE_BITMAP(caches_bitmap, CACHE_LEVEL_AND_TYPE__MAX);
 
@@ -283,6 +305,25 @@ bool machine_parse_smp_cache(MachineState *ms,
         set_bit(node->value->cache, caches_bitmap);
     }
 
+    for (int i = 0; i < CACHE_LEVEL_AND_TYPE__MAX; i++) {
+        const SmpCacheProperties *props = &ms->smp_cache.props[i];
+
+        /*
+         * Reject non "default" topology level if the cache isn't
+         * supported by the machine.
+         */
+        if (props->topology != CPU_TOPOLOGY_LEVEL_DEFAULT &&
+            !mc->smp_props.cache_supported[props->cache]) {
+            error_setg(errp,
+                       "%s cache topology not supported by this machine",
+                       CacheLevelAndType_str(node->value->cache));
+            return false;
+        }
+
+        if (!machine_check_topo_support(ms, props->topology, errp)) {
+            return false;
+        }
+    }
     return true;
 }
 
diff --git a/include/hw/boards.h b/include/hw/boards.h
index f7591d54a3d3..3d6cb5acd6c7 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -153,6 +153,8 @@ typedef struct {
  * @books_supported - whether books are supported by the machine
  * @drawers_supported - whether drawers are supported by the machine
  * @modules_supported - whether modules are supported by the machine
+ * @cache_supported - whether cache (l1d, l1i, l2 and l3) configuration are
+ *                    supported by the machine
  */
 typedef struct {
     bool prefer_sockets;
@@ -162,6 +164,7 @@ typedef struct {
     bool books_supported;
     bool drawers_supported;
     bool modules_supported;
+    bool cache_supported[CACHE_LEVEL_AND_TYPE__MAX];
 } SMPCompatProps;
 
 /**
-- 
2.34.1


