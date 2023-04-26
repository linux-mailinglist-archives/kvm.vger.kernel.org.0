Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C3D6EF6DA
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 16:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241307AbjDZOyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 10:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241285AbjDZOyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 10:54:36 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1917C7AA4;
        Wed, 26 Apr 2023 07:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682520875; x=1714056875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=io8hL9bTUpAjOWSG+LYha6CPKcMkhPDUJOxDgMz4F3c=;
  b=di0q9kjddOmMibLKyv3hwMmpwoEqs2DfvTGMsVHkLGHkcpRXOOVphFi1
   LnclwTjfu1iXZtDVGrHN4vvQJbcrtQfXCSLyPxkO1tMlN1/UarYgmgBb7
   S68Ei4h/gJ567LigzfYgyF3mV3CTAV7c2aWLvhTWxgWl+53ztTljiFPxF
   ND5hKFL85CQKEq9TfTVViraiLMkWEHkY9OZ4jNJ2g7BJvHXEFzVtcm1bU
   MEzWSoXdluBVQdYnq6IZWsxNKIU7mLzHtzuL6nhi7vnsTAADgWrdMQQXK
   QfqPR0cjh6AGhtH1J7vmMok1ex6OqRDMMY+WiV53wmC/YwViy1K6240CC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="433410316"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="433410316"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 07:54:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="758644033"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="758644033"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2023 07:54:34 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com
Subject: [PATCH v4 5/9] vfio: Mark cdev usage in vfio_device
Date:   Wed, 26 Apr 2023 07:54:15 -0700
Message-Id: <20230426145419.450922-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230426145419.450922-1-yi.l.liu@intel.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use it to differentiate whether to report group_id or dev_id in revised
VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. Though it is not set at this
moment introducing it now allows us to get hot reset ready for cdev.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 include/linux/vfio.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 4ee613924435..298f4ef16be7 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -63,6 +63,7 @@ struct vfio_device {
 	bool iommufd_attached;
 #endif
 	bool noiommu;
+	bool cdev_opened;
 };
 
 /**
@@ -140,6 +141,12 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
 #endif
 
+static inline bool vfio_device_cdev_opened(struct vfio_device *device)
+{
+	lockdep_assert_held(&device->dev_set->lock);
+	return device->cdev_opened;
+}
+
 /**
  * struct vfio_migration_ops - VFIO bus device driver migration callbacks
  *
-- 
2.34.1

