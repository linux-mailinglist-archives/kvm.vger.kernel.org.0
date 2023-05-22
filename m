Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA8F70BCB1
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 13:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbjEVL62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 07:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbjEVL6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 07:58:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68F2B3;
        Mon, 22 May 2023 04:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684756692; x=1716292692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IzrAn20ByJL63NIYU7HEQmy4xx7HzzCXurkAzXmi5jA=;
  b=AS0NXIXBXaDantEFcRBJyT/mlFVut4bb63yqwjeH7fH9JslKSQEAYpaD
   NQ3SzuHHU2QRJwArlWP1kDqIu8mOsmIf/B2lMesA4SpI6nE8XsnfKfue8
   3DzW2/WhNDxSdkVSX5p0r0SH9wPITFRAJiK+uOf/4aVoVN4IHVslIij/2
   0NeWIFLmA+WPetOQhAastViH+FHnQ6w8fwCE5CYcUx72LQbjjSevdU8V0
   xF7zM2E7/18NWggmLbun0o4l8biCTiCiYQwvGNSyRaVb3fb+iPAjPsVaa
   cR+QeWE4rO/hiAdRaX4Ox/oVFgON9ldsJsS48eeyiQg+5RV/EPUk00ize
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="356128208"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="356128208"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 04:58:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="815660213"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="815660213"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga002.fm.intel.com with ESMTP; 22 May 2023 04:58:00 -0700
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
Subject: [PATCH v6 07/10] vfio: Mark cdev usage in vfio_device
Date:   Mon, 22 May 2023 04:57:48 -0700
Message-Id: <20230522115751.326947-8-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230522115751.326947-1-yi.l.liu@intel.com>
References: <20230522115751.326947-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This can be used to differentiate whether to report group_id or devid in
the revised VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. At this moment, no
cdev path yet, so the vfio_device_cdev_opened() helper always returns false.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 include/linux/vfio.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 2c137ea94a3e..2a45853773a6 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -139,6 +139,11 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
 #endif
 
+static inline bool vfio_device_cdev_opened(struct vfio_device *device)
+{
+	return false;
+}
+
 /**
  * struct vfio_migration_ops - VFIO bus device driver migration callbacks
  *
-- 
2.34.1

