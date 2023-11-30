Return-Path: <kvm+bounces-2927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B6437FF1C7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:30:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AA1C1C20C5E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 984B35103A;
	Thu, 30 Nov 2023 14:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hqYaGFJw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9864BD
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354643; x=1732890643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GonVMos5FsS7CHBj98lIck+6Zgp9gIFuSW7kS7bFSf0=;
  b=hqYaGFJwxeX6PWEI7zb0Gw9Y9LmbYQtgFax+DrT/rq1OYrXH2mTEVkOY
   b9YoehCmz4hJ7Rub1Gz2cs/uurBkYVYWBgzMGGQOp28AfzFLl2TpOF8Un
   A5Mc8XuJV9FGyu6cMqiQQG+s6GyZjGZIWKuvEwdTRArENKn3cnSYAVlYB
   cxNQB5Gf493sx1dWPn9IYQEfjKDovHJNQdtYmKUOxliz14RuuS3QkME1s
   oYgNVnu/7irBO9i+Qs9jP+vPUjFmCEmPxSac4fS6WLPYExnP/kno2F/S+
   6VbXCKUyXl3RvsZ/2zLwBXdLAL55Bu5XIERoYBALerIkMX2zxmju1B77k
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479530853"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479530853"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:30:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942729601"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942729601"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:30:33 -0800
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
Subject: [RFC 01/41] qdev: Introduce new device category to cover basic topology device
Date: Thu, 30 Nov 2023 22:41:23 +0800
Message-Id: <20231130144203.2307629-2-zhao1.liu@linux.intel.com>
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

Topology devices are used to define CPUs and need to be created and
realized before the board initialization.

Use this new catogory to identify such special devices.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 include/hw/qdev-core.h | 1 +
 system/qdev-monitor.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
index 151d9682380d..97b7cfd04e35 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -86,6 +86,7 @@ typedef enum DeviceCategory {
     DEVICE_CATEGORY_SOUND,
     DEVICE_CATEGORY_MISC,
     DEVICE_CATEGORY_CPU,
+    DEVICE_CATEGORY_CPU_DEF,
     DEVICE_CATEGORY_WATCHDOG,
     DEVICE_CATEGORY_MAX
 } DeviceCategory;
diff --git a/system/qdev-monitor.c b/system/qdev-monitor.c
index a13db763e5dd..0f163b2d0310 100644
--- a/system/qdev-monitor.c
+++ b/system/qdev-monitor.c
@@ -173,6 +173,7 @@ static void qdev_print_devinfos(bool show_no_user)
         [DEVICE_CATEGORY_SOUND]   = "Sound",
         [DEVICE_CATEGORY_MISC]    = "Misc",
         [DEVICE_CATEGORY_CPU]     = "CPU",
+        [DEVICE_CATEGORY_CPU_DEF] = "CPU Definition",
         [DEVICE_CATEGORY_WATCHDOG]= "Watchdog",
         [DEVICE_CATEGORY_MAX]     = "Uncategorized",
     };
-- 
2.34.1


