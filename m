Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4653F701738
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 15:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238461AbjEMN2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 May 2023 09:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238477AbjEMN2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 May 2023 09:28:47 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1957F420B;
        Sat, 13 May 2023 06:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683984524; x=1715520524;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DVwKUwEaHGDWyoaeMP28ukFaAT3Cr6lRWJO6ciJeggY=;
  b=FW1+yU9XL0U4WI4A3xai5/+hM7GWZUZ5pC4uMS6Zh3g2xTyHMSMU9Q7f
   1bxFpDrXYwW20TG96mB70oZO2mhCQ5B4cfxD4s6G1GHHEoWxJKAWDg46r
   f3kiBkXOBd0W8iRx1z3+CzhBYuHvDJCYPKqNQZD0Wo7hy1/ufhg7btOTu
   mcuGRTe51qX/r4SekW01k+AQ+5M1kFMT3nWG72Q1e8VQCJQLwa8GnSvXX
   X15mIH0Y+sHMqcd2RnWXlmf7WSdghCFwMDXw67slAzyck7iURXrAZBXsk
   ypbN6LFcCh5R9s9vEae/k/TcJTKs9TpDb9Nw4GbA8QkZeAvL6BzgmEo0T
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="354100712"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="354100712"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 06:28:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="703459486"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="703459486"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 13 May 2023 06:28:42 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v11 09/23] vfio: Make vfio_device_open() single open for device cdev path
Date:   Sat, 13 May 2023 06:28:13 -0700
Message-Id: <20230513132827.39066-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230513132827.39066-1-yi.l.liu@intel.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO group has historically allowed multi-open of the device FD. This
was made secure because the "open" was executed via an ioctl to the
group FD which is itself only single open.

However, no known use of multiple device FDs today. It is kind of a
strange thing to do because new device FDs can naturally be created
via dup().

When we implement the new device uAPI (only used in cdev path) there is
no natural way to allow the device itself from being multi-opened in a
secure manner. Without the group FD we cannot prove the security context
of the opener.

Thus, when moving to the new uAPI we block the ability of opening
a device multiple times. Given old group path still allows it we store
a vfio_group pointer in struct vfio_device_file to differentiate.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 2 ++
 drivers/vfio/vfio.h      | 2 ++
 drivers/vfio/vfio_main.c | 7 +++++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index fd4ddafb6152..a17584e8be15 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -245,6 +245,8 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 		goto err_out;
 	}
 
+	df->group = device->group;
+
 	ret = vfio_device_group_open(df);
 	if (ret)
 		goto err_free;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 3c82d1cc4520..785afc40ece8 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -18,6 +18,8 @@ struct vfio_container;
 
 struct vfio_device_file {
 	struct vfio_device *device;
+	struct vfio_group *group;
+
 	bool access_granted;
 	spinlock_t kvm_ref_lock; /* protect kvm field */
 	struct kvm *kvm;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 224425cb7259..513f9516aed2 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -492,6 +492,13 @@ int vfio_device_open(struct vfio_device_file *df)
 
 	lockdep_assert_held(&device->dev_set->lock);
 
+	/*
+	 * Only the group path allows the device to be opened multiple
+	 * times.  The device cdev path doesn't have a secure way for it.
+	 */
+	if (device->open_count != 0 && !df->group)
+		return -EINVAL;
+
 	device->open_count++;
 	if (device->open_count == 1) {
 		ret = vfio_device_first_open(df);
-- 
2.34.1

