Return-Path: <kvm+bounces-7560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A735843BA2
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 11:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CF4D1C2114E
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB04C69D37;
	Wed, 31 Jan 2024 10:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NoQ8b9Zx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F01569D2A
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 10:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706695257; cv=none; b=sd7XOIWC3T9EKI5GAEnKow73SUbWlL1ysK082qkqxqi+w2gBeZMeiGrD2uHusPSN+pzULMqWIASmmabH7fdYGLnBaT+pw3PyLuzuvf1Tf6HeMt1F3mn35Il/hD48fUZ8byvYvkCChgLpYn1cXUlPmwQCReDA5UJgAAsRcCtm2c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706695257; c=relaxed/simple;
	bh=xUBlkwxmKLySrd/S0u0lbtkBIZKs5xeWrstxmUgR21g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NCUgd4VwYfYx7CawdMtMd7q+ENPf0wv2wN9FczyxCR+qTYzM5lqv/8pbS+uow3501M+jcRZpXxfSz346K14njZo328B8yyGcU3zMlhUYg7M1FQNYmTbsxAYWU1CbuCnkrF0E9UNJEZKCQWUl+kuw3ODOvqsdbhtiy/lQhldS9HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NoQ8b9Zx; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706695256; x=1738231256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xUBlkwxmKLySrd/S0u0lbtkBIZKs5xeWrstxmUgR21g=;
  b=NoQ8b9ZxGzSYeifpAx6UbqVznKEWd/2W6jyDRs4rHUghg9KSrnBlZ8o6
   1dA0XUTQva65haTrvB1LG7moDE7gftkziOqSs3suPsLrR9a7qVc2k0yAS
   oQSRS1cQ9xftHy8hVC6OfNFoU4oO2t+fJ1Yum+4u010BcYjlnCcsjURRJ
   97bvATCxZQcPxEDaUw+7NjXE6iRzUcL4a1gO6cnchuQWpYQsBmpYYMlPG
   gIPsA98TzFCj7bxNF89sA/D41LY5f6CBgiIgJVtJVJ8zOroNc8n8QmhVp
   4SEsuJTeFGaURY3jFTJDvt6EZ30mdqrP1JFpmEXRyRXwNGcSqKRHH64Xm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="25032538"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="25032538"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 02:00:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="4035948"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 31 Jan 2024 02:00:51 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Babu Moger <babu.moger@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v8 03/21] hw/core: Introduce module-id as the topology subindex
Date: Wed, 31 Jan 2024 18:13:32 +0800
Message-Id: <20240131101350.109512-4-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
References: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
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
index 93ae0a987c3a..dadcbd78a4b3 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -931,6 +931,9 @@
 # @cluster-id: cluster number within the parent container the CPU
 #     belongs to (since 7.1)
 #
+# @module-id: module number within the parent container the CPU
+#     belongs to (since 9.0)
+#
 # @core-id: core number within the parent container the CPU
 #     belongs to
 #
@@ -949,6 +952,7 @@
             '*socket-id': 'int',
             '*die-id': 'int',
             '*cluster-id': 'int',
+            '*module-id': 'int',
             '*core-id': 'int',
             '*thread-id': 'int'
   }
-- 
2.34.1


