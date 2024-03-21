Return-Path: <kvm+bounces-12385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2608885AA7
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F485282F4F
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC7385287;
	Thu, 21 Mar 2024 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kbQEAsSZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B9284FD8
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031248; cv=none; b=G5q7za1pFIx5ENtgXCxDKiEYkdPkz/GzjAqrHQsldNuxnGMKML/9cjEi03siwAmDuXKK9nVk2/xKdgspU42qaTv4m1S8VF+0llipIpR1sdYY1I2Z2ICFLqFFRBuQoLIJ3Szo1dYrbxYpLxDxAk5yVJJQjRDtkarXGN8HMqeDzEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031248; c=relaxed/simple;
	bh=pozxmkQYFmo9TvNo/qUS3XdyUCJrRFtdxe3SYZYL0jA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TEzlY5oXXFf/pOBrdU05WLBSEeTmowvAqhKaC/uWUt/5J+1PLz4X3J6SAdK6eTW2s7egqGO+D1HdN9FXzx2WmoKK+oN63M3+EZI9anLVrs24YfYdVyBfJsLLZrywPsK3wpJ3V4HBApAsi9N/OMyaJvQ09MKSkDdqw9gpifWnZXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kbQEAsSZ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031247; x=1742567247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pozxmkQYFmo9TvNo/qUS3XdyUCJrRFtdxe3SYZYL0jA=;
  b=kbQEAsSZRggr2sZY5mYuo8jZP5SEaQHdT5WplEceL9iuLxtYOJ54tdoq
   BnG8+x0E360DFUaMiR3xC8x++vRqhmZILEJQc3P1kmXdORBBeEwYrVwmk
   +8zbBi1U2vhMX3sRaVuYDqtb86SZU4DcRrI9I3RjmGP/5YdwMZ1Cmq7mG
   DA71dR5QB7DBE41eNlGSPlIKN3/RvDuF/306fUEKtuEWMUn3tqeIykeWx
   paGd5LsDsn9nK8AcJLKaJfJfFMUUgtTwt6zLPfNJTr8VbhXj5NYjVgBR/
   rRIa8lA1RwbPeDWF8TML/9LmsMk3WdsUrsz8pF2ksoGObPkI553hGwTJ1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806386"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806386"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:27:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14527827"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:27:22 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v10 03/21] hw/core: Introduce module-id as the topology subindex
Date: Thu, 21 Mar 2024 22:40:30 +0800
Message-Id: <20240321144048.3699388-4-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
References: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Add module-id in CpuInstanceProperties, to locate the CPU with module
level.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Acked-by: Markus Armbruster <armbru@redhat.com>
---
Changes since v7:
 * New commit to introduce module_id to locate the CPU with module
   level.
---
 hw/core/machine-hmp-cmds.c | 4 ++++
 qapi/machine.json          | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/hw/core/machine-hmp-cmds.c b/hw/core/machine-hmp-cmds.c
index a6ff6a487583..8701f00cc7cc 100644
--- a/hw/core/machine-hmp-cmds.c
+++ b/hw/core/machine-hmp-cmds.c
@@ -87,6 +87,10 @@ void hmp_hotpluggable_cpus(Monitor *mon, const QDict *qdict)
             monitor_printf(mon, "    cluster-id: \"%" PRIu64 "\"\n",
                            c->cluster_id);
         }
+        if (c->has_module_id) {
+            monitor_printf(mon, "    module-id: \"%" PRIu64 "\"\n",
+                           c->module_id);
+        }
         if (c->has_core_id) {
             monitor_printf(mon, "    core-id: \"%" PRIu64 "\"\n", c->core_id);
         }
diff --git a/qapi/machine.json b/qapi/machine.json
index 3f6a5af10ba8..366da6244ab6 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -925,6 +925,9 @@
 # @cluster-id: cluster number within the parent container the CPU
 #     belongs to (since 7.1)
 #
+# @module-id: module number within the parent container the CPU
+#     belongs to (since 9.1)
+#
 # @core-id: core number within the parent container the CPU
 #     belongs to
 #
@@ -943,6 +946,7 @@
             '*socket-id': 'int',
             '*die-id': 'int',
             '*cluster-id': 'int',
+            '*module-id': 'int',
             '*core-id': 'int',
             '*thread-id': 'int'
   }
-- 
2.34.1


