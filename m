Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428CD29C4D4
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 19:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823242AbgJ0R62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:58:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:41011 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1823232AbgJ0R60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:58:26 -0400
IronPort-SDR: tv2AXyGcjbo/W0fJDYrKQ7Lr7vZE3BmcLCFCroxm09vtSWEnjU4SThl4cmeHo09jtWN4l16te1
 JhvbcIJfzCxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="155910868"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="155910868"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 10:58:09 -0700
IronPort-SDR: FVTLGKaPm2nU8nQKKMMyNr0H3IvtVTsE/+UA5+5KS0SCJgBb4qe1dEnGuDqICwUTjJ1SuENcSU
 Nm6bSf3gOqzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="323036172"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 27 Oct 2020 10:58:07 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 00436178; Tue, 27 Oct 2020 19:58:06 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v1 2/5] vfio: platform: Switch to use platform_get_mem_or_io_resource()
Date:   Tue, 27 Oct 2020 19:58:03 +0200
Message-Id: <20201027175806.20305-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
References: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Switch to use new platform_get_mem_or_io_resource() instead of
home grown analogue.

Cc: Eric Auger <eric.auger@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/vfio/platform/vfio_platform.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 1e2769010089..84afafb6941b 100644
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
+	return platform_get_mem_or_io_resource(dev, num);
 }
 
 static int get_platform_irq(struct vfio_platform_device *vdev, int i)
-- 
2.28.0

