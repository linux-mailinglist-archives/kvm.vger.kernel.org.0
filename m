Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB2F5E7700
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 11:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiIWJ1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 05:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiIWJ11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 05:27:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52745B56F6;
        Fri, 23 Sep 2022 02:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=BCwKNO7p6ZrQ17y/6nQVDaD6cJ2tHmteDWrP1e6xqX0=; b=n9hepubPbW1tMD7Ec8QsC8TNDV
        12CbYMaEqA8sXT5tvrocliJB+zVQgj5vaMhMMWBmVT/0KCadfzCyrkGaCOxxRwUFWWsLHfQMOLuTv
        kReMn/zqnT0niuc6+urTJH/4EReGlFMucPpOPNXiU35LpTvmQFQQ9ioIoSk26xOBmOQ81Xac8rAyT
        IGO2tnlYj3RfcEhD+po/Q4cCc6JgHnlJNwPtl6Kqx6v7GCcUgYhgbmrVO9xPT4Kp11aB6MfQL1WN6
        8zcsuWQMY3/bTydegC7V3dgpabvAK6ijBQQnfqlZ01LrbDqsDjK27aEHAtcPBU7z4aMS8R3cCWDJY
        BrR4vMjA==;
Received: from ip4d15bec4.dynamic.kabel-deutschland.de ([77.21.190.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obexn-003Jpg-Be; Fri, 23 Sep 2022 09:27:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 08/14] vfio/mdev: remove mdev_parent_dev
Date:   Fri, 23 Sep 2022 11:26:46 +0200
Message-Id: <20220923092652.100656-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220923092652.100656-1-hch@lst.de>
References: <20220923092652.100656-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just open code the dereferences in the only user.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 Documentation/driver-api/vfio-mediated-device.rst | 3 ---
 drivers/gpu/drm/i915/gvt/kvmgt.c                  | 2 +-
 drivers/vfio/mdev/mdev_core.c                     | 6 ------
 include/linux/mdev.h                              | 1 -
 4 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index ff7342d2e332d..7b660f3fa2c92 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -200,9 +200,6 @@ Directories and files under the sysfs for Each Physical Device
 
 	sprintf(buf, "%s-%s", dev_driver_string(parent->dev), group->name);
 
-  (or using mdev_parent_dev(mdev) to arrive at the parent device outside
-  of the core mdev code)
-
 * device_api
 
   This attribute should show which device API is being created, for example,
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index ce6b8cb37be0c..1947f553fcd38 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1488,7 +1488,7 @@ static int intel_vgpu_init_dev(struct vfio_device *vfio_dev)
 	struct intel_vgpu_type *type =
 		container_of(mdev->type, struct intel_vgpu_type, type);
 
-	vgpu->gvt = kdev_to_i915(mdev_parent_dev(mdev))->gvt;
+	vgpu->gvt = kdev_to_i915(mdev->type->parent->dev)->gvt;
 	return intel_gvt_create_vgpu(vgpu, type->conf);
 }
 
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index bde7ce620dae0..75628759a3bf0 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -23,12 +23,6 @@ static struct class_compat *mdev_bus_compat_class;
 static LIST_HEAD(mdev_list);
 static DEFINE_MUTEX(mdev_list_lock);
 
-struct device *mdev_parent_dev(struct mdev_device *mdev)
-{
-	return mdev->type->parent->dev;
-}
-EXPORT_SYMBOL(mdev_parent_dev);
-
 /*
  * Used in mdev_type_attribute sysfs functions to return the parent struct
  * device
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 6c179d2b89274..bbedffcb38d48 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -95,7 +95,6 @@ void mdev_unregister_parent(struct mdev_parent *parent);
 int mdev_register_driver(struct mdev_driver *drv);
 void mdev_unregister_driver(struct mdev_driver *drv);
 
-struct device *mdev_parent_dev(struct mdev_device *mdev);
 static inline struct device *mdev_dev(struct mdev_device *mdev)
 {
 	return &mdev->dev;
-- 
2.30.2

