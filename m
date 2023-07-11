Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3716574E42D
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 04:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbjGKCcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 22:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGKCbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 22:31:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672701BE;
        Mon, 10 Jul 2023 19:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689042712; x=1720578712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GVjyZOqJ0QuqIxexj/mjWg5AFyiRs1eaWwzPA1OZI8A=;
  b=NdR9ylpbO0Z9Fay+vZjOV20TtzGEkjFsGi/I71MjGwAt4121ziPF8wFS
   OMFhBYe16shCJ33vC8EQBhPrZD6bE8wXVqdbnGVd3dA323RBv5ZolsrRG
   lBxnd8Cs7Lu2GwNALy/BffQiUM4irounZmeX0mcGq5PnNLxGAGHV+TBt6
   dBKqEEvPNrjpSdGq5JPUA+uKn6lZ50j9XCNRDUfSOkQbteiR1d0FXIVkk
   s+UvYgDQQHvMQItzeMH4zyt8EKB79E2fQwRuJ58f7QpwWAPGS7QOUE5Cl
   PR6ja1+sRn5cmec9y6giBT0bVcoTBKMcFzNyBlkveTZ+UsfXWJ3RysXLF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="368004688"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="368004688"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 19:31:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="720907578"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="720907578"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 10 Jul 2023 19:31:30 -0700
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
Subject: [PATCH v9 05/10] iommufd: Add helper to retrieve iommufd_ctx and devid
Date:   Mon, 10 Jul 2023 19:31:21 -0700
Message-Id: <20230711023126.5531-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711023126.5531-1-yi.l.liu@intel.com>
References: <20230711023126.5531-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is needed by the vfio-pci driver to report affected devices in the
hot-reset for a given device.

Tested-by: Terrence Xu <terrence.xu@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c | 12 ++++++++++++
 include/linux/iommufd.h        |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 693c2155a5da..cd5d8ab907f9 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -146,6 +146,18 @@ void iommufd_device_unbind(struct iommufd_device *idev)
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
 
+struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev)
+{
+	return idev->ictx;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_to_ictx, IOMMUFD);
+
+u32 iommufd_device_to_id(struct iommufd_device *idev)
+{
+	return idev->obj.id;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_to_id, IOMMUFD);
+
 static int iommufd_device_setup_msi(struct iommufd_device *idev,
 				    struct iommufd_hw_pagetable *hwpt,
 				    phys_addr_t sw_msi_start)
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index f241bafa03da..68defed9ea48 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -25,6 +25,9 @@ void iommufd_device_unbind(struct iommufd_device *idev);
 int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
 void iommufd_device_detach(struct iommufd_device *idev);
 
+struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev);
+u32 iommufd_device_to_id(struct iommufd_device *idev);
+
 struct iommufd_access_ops {
 	u8 needs_pin_pages : 1;
 	void (*unmap)(void *data, unsigned long iova, unsigned long length);
-- 
2.34.1

