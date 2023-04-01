Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9851A6D3193
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 16:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjDAOow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 10:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjDAOok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 10:44:40 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB74A20C1E;
        Sat,  1 Apr 2023 07:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680360279; x=1711896279;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r+71o8G6Wo9sr6JKZnAb0/po7K9Eq9HOWBlcp5zMc44=;
  b=ZBFu/Ap+M6dMT9a0dGOSGmmVfbIY7x8Fl16M3gZYnrP9g3Ko1j7SLOw6
   6aDDnoU0BMOtGrLY0bTiChlG8IjT8VAZQCJscZzZdGoEsxp4b7geNsPNA
   FUIOTc0dtUUbkoRkCHHmRBUKJhDB4q+kx6ehTg6P5v5CpKK95/dV7yyLA
   2Igjo8X9SHq4/hN/JoiMy2icEWIO5oEj/AT/rrKkmktoh0G3pxkTfQZgg
   e4NT2tOguVfBmGKjX4YI3NC7V8Xv0d+zwxCDfieddnfXIkjpFwJdCCwYN
   fLuei1lO+m3Xh9V6YGjOQpi35VM2Wjx/Q6C9Ku2ME60aK1Mck4F6gM7z8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="340385163"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="340385163"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 07:44:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="662705855"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="662705855"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 01 Apr 2023 07:44:38 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: [PATCH v3 10/12] vfio: Mark cdev usage in vfio_device
Date:   Sat,  1 Apr 2023 07:44:27 -0700
Message-Id: <20230401144429.88673-11-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401144429.88673-1-yi.l.liu@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are users that need to check if vfio_device is opened as cdev.
e.g. vfio-pci. This adds a flag in vfio_device, it will be set in the
cdev path when device is opened. This is not used at this moment, but
a preparation for vfio device cdev support.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 include/linux/vfio.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index f8fb9ab25188..d9a0770e5fc1 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -62,6 +62,7 @@ struct vfio_device {
 	struct iommufd_device *iommufd_device;
 	bool iommufd_attached;
 #endif
+	bool cdev_opened;
 };
 
 /**
@@ -151,6 +152,12 @@ vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id)
 	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
 #endif
 
+static inline bool vfio_device_cdev_opened(struct vfio_device *device)
+{
+	lockdep_assert_held(&device->dev_set->lock);
+	return device->cdev_opened;
+}
+
 /**
  * @migration_set_state: Optional callback to change the migration state for
  *         devices that support migration. It's mandatory for
-- 
2.34.1

