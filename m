Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093D02D4C0A
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 21:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbgLIUii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 15:38:38 -0500
Received: from mga04.intel.com ([192.55.52.120]:10548 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729213AbgLIUii (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 15:38:38 -0500
IronPort-SDR: 7giOMYbGVopHkmni2utGr3G5+ExGrdo8XsGwLQZelc2ZBvQg5emAEvIlAuNESXZxRGFIMnfh8/
 wVf6qW/6GLuw==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="171570350"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="171570350"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 12:36:46 -0800
IronPort-SDR: FeNYAK3Gyy9HFFGiBtyTiMiIK1351ysdS6Fwu4Q7OrbwlpLs2gX2ZKgIkft8+dRAEFoSAR07FS
 SNLGDb5nusIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="542523753"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 09 Dec 2020 12:36:44 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 7C8641C8; Wed,  9 Dec 2020 22:36:43 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-usb@vger.kernel.org,
        Peng Hao <peng.hao2@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 1/5] driver core: platform: Introduce platform_get_mem_or_io()
Date:   Wed,  9 Dec 2020 22:36:38 +0200
Message-Id: <20201209203642.27648-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are at least few existing users of the proposed API which
retrieves either MEM or IO resource from platform device.

Make it common to utilize in the existing and new users.

Cc: Eric Auger <eric.auger@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: Peng Hao <peng.hao2@zte.com.cn>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
v2: moved to C-file and renamed for the sake of consistency with the rest
    platform code

 drivers/base/platform.c         | 15 +++++++++++++++
 include/linux/platform_device.h |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 88aef93eb4dd..af0c37f720e6 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -63,6 +63,21 @@ struct resource *platform_get_resource(struct platform_device *dev,
 }
 EXPORT_SYMBOL_GPL(platform_get_resource);
 
+struct resource *platform_get_mem_or_io(struct platform_device *dev,
+					unsigned int num)
+{
+	u32 i;
+
+	for (i = 0; i < dev->num_resources; i++) {
+		struct resource *r = &dev->resource[i];
+
+		if ((resource_type(r) & (IORESOURCE_MEM|IORESOURCE_IO)) && num-- == 0)
+			return r;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(platform_get_mem_or_io);
+
 #ifdef CONFIG_HAS_IOMEM
 /**
  * devm_platform_get_and_ioremap_resource - call devm_ioremap_resource() for a
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 77a2aada106d..ee6a9f10c2c7 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -52,6 +52,9 @@ extern struct device platform_bus;
 
 extern struct resource *platform_get_resource(struct platform_device *,
 					      unsigned int, unsigned int);
+extern struct resource *platform_get_mem_or_io(struct platform_device *,
+					       unsigned int);
+
 extern struct device *
 platform_find_device_by_driver(struct device *start,
 			       const struct device_driver *drv);
-- 
2.29.2

