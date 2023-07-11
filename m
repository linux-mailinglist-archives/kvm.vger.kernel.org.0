Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CD274E500
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 05:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjGKDBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 23:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjGKDB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 23:01:27 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE4F172A;
        Mon, 10 Jul 2023 20:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689044460; x=1720580460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IFiYjdY15PqcUT04+fSZ0uEDgkZItrEBuKXrRn7wYT4=;
  b=Ip1N1Knvxj5gMKpyIxMc2lCwzLJa/DSi2PdtBdKwnnNcczBkLLmGLw1b
   rdSEf44ikoWfQGKJjkBoofAIr/wFkbDiXS6MkcZ+WS0+V1zH0919C/vcz
   nLTHUx50+Ktc6geq1HtbmX7eu3wzJ+p0Vbi1QvgKYaaeNP8Kdw+wNkVB0
   +qOf0wt0irwEI0y7RiNBejrf1l8FO8F9IB4Pu2P/eL+WuwyD7Ke989q8M
   S++0W+1rfToA4dL/hYL4wZMa5TKpfbNPlf4EzRvnmYVNzB5I9v9lfxEy8
   d9WOaoBGMTPzKdtopQpd7Zl423VykAreNZQ4RR3Epn3qf39GV5QMBKm0b
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="361973194"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="361973194"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 19:59:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="724250923"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="724250923"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jul 2023 19:59:51 -0700
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
Subject: [PATCH v14 21/26] vfio: Avoid repeated user pointer cast in vfio_device_fops_unl_ioctl()
Date:   Mon, 10 Jul 2023 19:59:23 -0700
Message-Id: <20230711025928.6438-22-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711025928.6438-1-yi.l.liu@intel.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds a local variable to store the user pointer cast result from arg.
It avoids the repeated casts in the code when more ioctls are added.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5f7c3151d8c0..a2744cb64c6d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1146,6 +1146,7 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	void __user *uptr = (void __user *)arg;
 	int ret;
 
 	/* Paired with smp_store_release() following vfio_df_open() */
@@ -1158,7 +1159,7 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 
 	switch (cmd) {
 	case VFIO_DEVICE_FEATURE:
-		ret = vfio_ioctl_device_feature(device, (void __user *)arg);
+		ret = vfio_ioctl_device_feature(device, uptr);
 		break;
 
 	default:
-- 
2.34.1

