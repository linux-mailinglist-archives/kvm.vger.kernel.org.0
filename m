Return-Path: <kvm+bounces-10049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C6590868D34
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:19:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 665D2B2175E
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874511384B4;
	Tue, 27 Feb 2024 10:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AtBFe6Fr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8FE137C5E
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709029151; cv=none; b=U1bnvXtNlhTu4mAXLXCWt4VY+dsbU/mjwHIdIj8tP/3IuRfcrziAIc743hlK2w+6N5HGor3+ArxCAThbz5EMwBFonEVfLW5PJqtj3SsEMX06Ejan3BlAjSHzUTu/1XFBUC9G2F2/PTPGrktSwznsfALRyDjIsjfzucGeM7p+uxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709029151; c=relaxed/simple;
	bh=mKdfzIPsOw63Y6tcpFyHMTH04ZZmgqO/zY17ht70xyQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rudVDVd4fh0Cm/+QwzXtOsWyQK+GEBrj4TbR81suhMIjy4ujuNSWmrF47H3z7W+3MB4atax5sbf8eMf5f59+rUsfNlJGGc1BZKFIPlC0dLbb3nbo1wOGkP4sLTrh462qFn+rAYxehatjjYm1SiTxJvVP51iV4kZp1JyYKJWegWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AtBFe6Fr; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709029150; x=1740565150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mKdfzIPsOw63Y6tcpFyHMTH04ZZmgqO/zY17ht70xyQ=;
  b=AtBFe6Frlo1aYTdEp7uNUklyYFmo4TqkDQeLYhE2Ehu4e20ciT0I3wf7
   R71ZzcTkSZQasbKox4RxVfxG93fnI7pkO71kIu0gpuGfF7oEqYnk6LTA3
   SK0C3syv38nWSwVxk6xygUKzP3xn/hmuF4iqESjFKfiL33EU383ypjrOY
   u1E8hNYYgaKqKmw251lDHumyKFdqySSbWx7PMFwDEOOMu/hA25CbQY4y2
   JrCNNWJkaJ0uCJxUW+swMX60TknJdlmDDz8GR9D24txsCN9kZHn6ptuwE
   TfljUQ4r3iWVczi6zS9LuCaEuLoO4+9f77aKkjxFsXY5K+XHSQxkbPYW4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="6310223"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6310223"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 02:19:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6954765"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 27 Feb 2024 02:19:05 -0800
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
Subject: [PATCH v9 03/21] hw/core: Introduce module-id as the topology subindex
Date: Tue, 27 Feb 2024 18:32:13 +0800
Message-Id: <20240227103231.1556302-4-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
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
index 5233a8947556..32b583ad187f 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -933,6 +933,9 @@
 # @cluster-id: cluster number within the parent container the CPU
 #     belongs to (since 7.1)
 #
+# @module-id: module number within the parent container the CPU
+#     belongs to (since 9.0)
+#
 # @core-id: core number within the parent container the CPU
 #     belongs to
 #
@@ -951,6 +954,7 @@
             '*socket-id': 'int',
             '*die-id': 'int',
             '*cluster-id': 'int',
+            '*module-id': 'int',
             '*core-id': 'int',
             '*thread-id': 'int'
   }
-- 
2.34.1


