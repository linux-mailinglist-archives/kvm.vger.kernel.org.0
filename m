Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B6523BB87
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 15:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgHDN4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 09:56:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:51588 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgHDN42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 09:56:28 -0400
IronPort-SDR: voATJnc/sswHb5kLwOpUaMX7IicBrKKf62v1Tn5Z4IOneJk1ljFWE2xAAs0QwS36Z9ocYT7u6v
 gHjOo/ldl8bQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="237170552"
X-IronPort-AV: E=Sophos;i="5.75,434,1589266800"; 
   d="scan'208";a="237170552"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 06:56:26 -0700
IronPort-SDR: 57O1IX73IgUM+mN6NBg+lrNuHF+iCZ9XBdzoZgVlBCCoQN5s0nqS40/M2O8FUO5iY7mqivH7gG
 AdexYfJtPnzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,434,1589266800"; 
   d="scan'208";a="492901361"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 04 Aug 2020 06:56:24 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 83A2F11C; Tue,  4 Aug 2020 16:56:23 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] vfio: platform: use platform_get_resource()
Date:   Tue,  4 Aug 2020 16:56:22 +0300
Message-Id: <20200804135622.11952-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use platform_get_resource() to fetch the memory resource
instead of open-coded variant.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/vfio/platform/vfio_platform.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 1e2769010089..d216126a31c4 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -25,19 +25,13 @@ static struct resource *get_platform_resource(struct vfio_platform_device *vdev,
 					      int num)
 {
 	struct platform_device *dev = (struct platform_device *) vdev->opaque;
-	int i;
+	struct resource *res;
 
-	for (i = 0; i < dev->num_resources; i++) {
-		struct resource *r = &dev->resource[i];
+	res = platform_get_resource(dev, IORESOURCE_MEM, num);
+	if (res)
+		return res;
 
-		if (resource_type(r) & (IORESOURCE_MEM|IORESOURCE_IO)) {
-			if (!num)
-				return r;
-
-			num--;
-		}
-	}
-	return NULL;
+	return platform_get_resource(dev, IORESOURCE_IO, num);
 }
 
 static int get_platform_irq(struct vfio_platform_device *vdev, int i)
-- 
2.27.0

