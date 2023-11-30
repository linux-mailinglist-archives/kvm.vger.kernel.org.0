Return-Path: <kvm+bounces-2931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BAC47FF1D9
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:31:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34D881F20F4F
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DBE51C34;
	Thu, 30 Nov 2023 14:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UrcGRvFn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD0685
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354709; x=1732890709;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FvkKzJCE6FUWENQ9f97m08P62P/QoMoZpAQ1rnP03oI=;
  b=UrcGRvFnCAnzdiNOM4AYpNGm+Ui5Ukg46b9RnRhw7MtlrcKLxFtdklZc
   0ThvUH9qT7RHY1teggUxrhswQ7kv0XIrE/k7xZnReSyYPcqu1iaapInBe
   o7DFrWV4L9rqDOuSax5dDX3bWJCdbUBeZ0QMEYZ99GWfKwG+NHmntoNMq
   CDrDZQnrudMWwDp//KrBQhTCnPl52Kk84WB5UflLFSq9nUlLYUZ/ktE1s
   2zng7EqBIiMSTEMhoaaM2WwxWfdMiivvxEXaEjHvDt9egh8lb1d3Uxyzk
   MoTKkkPmgldXgcJzOteGBwCk8c6i6Ybgw35NmW/2efLSV4Xb+tnm5aDrx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479531146"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479531146"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:31:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942729654"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942729654"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:31:10 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org,
	qemu-arm@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 05/41] qdev: Set device parent and id after setting properties
Date: Thu, 30 Nov 2023 22:41:27 +0800
Message-Id: <20231130144203.2307629-6-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
References: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

The properties setting does not conflict with the creation of child<>
property.

Pre-setting the device's properties can help the device's parent
selection. Some topology devices (e.g., CPUs that support hotplug)
usually define topology sub indexes as properties, and the selection of
their parent needs to be based on these proteries.

Move qdev_set_id() after properties setting to help the next user-child
introduction.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 system/qdev-monitor.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/system/qdev-monitor.c b/system/qdev-monitor.c
index 7ee33a50142a..107411bb50cc 100644
--- a/system/qdev-monitor.c
+++ b/system/qdev-monitor.c
@@ -700,14 +700,7 @@ DeviceState *qdev_device_add_from_qdict(const QDict *opts, long *category,
         }
     }
 
-    /*
-     * set dev's parent and register its id.
-     * If it fails it means the id is already taken.
-     */
     id = g_strdup(qdict_get_try_str(opts, "id"));
-    if (!qdev_set_id(dev, id, errp)) {
-        goto err_del_dev;
-    }
 
     /* set properties */
     dev->opts = qdict_clone_shallow(opts);
@@ -721,6 +714,14 @@ DeviceState *qdev_device_add_from_qdict(const QDict *opts, long *category,
         goto err_del_dev;
     }
 
+    /*
+     * set dev's parent and register its id.
+     * If it fails it means the id is already taken.
+     */
+    if (!qdev_set_id(dev, id, errp)) {
+        goto err_del_dev;
+    }
+
     if (!qdev_realize(dev, bus, errp)) {
         goto err_del_dev;
     }
-- 
2.34.1


