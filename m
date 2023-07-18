Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F1A7579D9
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 12:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjGRK4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 06:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjGRKzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 06:55:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1000C10EB;
        Tue, 18 Jul 2023 03:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689677748; x=1721213748;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GvTsJEYrbjbwvyNF6dh2G0YfWZKd/cpA4xcAI01AMx4=;
  b=fN3Z/FVhY0IiNcwo8HZyJ43s823ClqONUAWJborq/j8eIG/cZAgTYQxY
   byICXFLk8WbiW1pSMS+2ytAEJhfXnmxsW7U3a/x+uJ8XfQJKivuHK2y49
   EZMMjZ4HjPNIcgWQjZYzYzXYMSOIEHJWJN4X1Tl7ODfByT9vqTBNxMsi0
   VF7mUudz3q8x+8vWunQGapzs68OrZFGO39YcwoZ78bwsdSpALGYcKw1t8
   pmYWJv7ZOevSRB/0LO6H6y06A0IvYBwvwwEYIWVK0mMyVi4GJPu0J4BV9
   lhGkEp0ujOiJa3B1rl+8NELU8qKBwM8SGmq4MRJEhkMJobrCnuvoka/ke
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="452553561"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="452553561"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 03:55:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="673863808"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="673863808"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga003.jf.intel.com with ESMTP; 18 Jul 2023 03:55:46 -0700
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
Subject: [PATCH v10 05/10] iommufd: Add helper to retrieve iommufd_ctx and devid
Date:   Tue, 18 Jul 2023 03:55:37 -0700
Message-Id: <20230718105542.4138-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230718105542.4138-1-yi.l.liu@intel.com>
References: <20230718105542.4138-1-yi.l.liu@intel.com>
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
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

