Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591EF2D4C13
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 21:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbgLIUja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 15:39:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:65313 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729166AbgLIUii (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 15:38:38 -0500
IronPort-SDR: CRglw6bTGdeN0gWBdzXTT1e7Dj8f31Gl1OAILmZLs3igTEpl5uMTEQIGkk63/0OorQuX4IwCBU
 3psgGAtY7Ywg==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="173383933"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="173383933"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 12:36:46 -0800
IronPort-SDR: QT5G4J1IVZQEbh0tSDySV+/0rHVoWLWjDEJxGQq4njrDU8zPIqnzpgMQX66IVCYTCzZfME+nZO
 7bxhnC+1TXUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="408217591"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 09 Dec 2020 12:36:44 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 89D5614B; Wed,  9 Dec 2020 22:36:43 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 2/5] vfio: platform: Switch to use platform_get_mem_or_io()
Date:   Wed,  9 Dec 2020 22:36:39 +0200
Message-Id: <20201209203642.27648-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209203642.27648-1-andriy.shevchenko@linux.intel.com>
References: <20201209203642.27648-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Switch to use new platform_get_mem_or_io() instead of home grown analogue.

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Eric Auger <eric.auger@redhat.com>
---
v2: added tag (Eric)
 drivers/vfio/platform/vfio_platform.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 1e2769010089..9fb6818cea12 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -25,19 +25,8 @@ static struct resource *get_platform_resource(struct vfio_platform_device *vdev,
 					      int num)
 {
 	struct platform_device *dev = (struct platform_device *) vdev->opaque;
-	int i;
 
-	for (i = 0; i < dev->num_resources; i++) {
-		struct resource *r = &dev->resource[i];
-
-		if (resource_type(r) & (IORESOURCE_MEM|IORESOURCE_IO)) {
-			if (!num)
-				return r;
-
-			num--;
-		}
-	}
-	return NULL;
+	return platform_get_mem_or_io(dev, num);
 }
 
 static int get_platform_irq(struct vfio_platform_device *vdev, int i)
-- 
2.29.2

