Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730D453C4FB
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 08:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241533AbiFCGd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 02:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241519AbiFCGdy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 02:33:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751C56152;
        Thu,  2 Jun 2022 23:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=sIeqtTACFgi4lijjqlCq2evxEsTljhdEQuQfW516b88=; b=hmxRgHqun9L2tSj5lJ3K33sVKX
        /5RAhQxgt/HzmY2bWmxqVfxSUIfoN3iounTQDTOfiayczhpQ91ZjqJ3Kc3kXp7Mf16mi/mOiR8Aol
        CwBLzXPTRyvyFvw7oNWCoe0hY8fRx/bico2SsHSILXPshc7CIuoYVtEXN0G1yiWfBt6u5ywIPnpWA
        CMse77d3LhIt7SIXx1WgtjQBTEKiMQXleD6Uz03LWuwYqDqp0c6G51Bz1nWX46Jmj/d4T9mwlTpy2
        UcGtf8VFkZOW/VfojXljLP/5CRsGnRZwiAO2pNKNFhX6C3dJY/fENE731Uwh/M1YpEZ6pCCMs4bEG
        8S5fs69w==;
Received: from [2001:4bb8:185:a81e:b29a:8b56:eb9a:ca3b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nx0sY-00615N-2u; Fri, 03 Jun 2022 06:33:50 +0000
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
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: [PATCH 7/8] vfio/mdev: remove mdev_parent_dev
Date:   Fri,  3 Jun 2022 08:33:27 +0200
Message-Id: <20220603063328.3715-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220603063328.3715-1-hch@lst.de>
References: <20220603063328.3715-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just open code the dereferences in the only user.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/driver-api/vfio-mediated-device.rst | 3 ---
 drivers/gpu/drm/i915/gvt/kvmgt.c                  | 2 +-
 drivers/vfio/mdev/mdev_core.c                     | 6 ------
 include/linux/mdev.h                              | 1 -
 4 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 8ff463aa9e2be..0d74ac2a218f2 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -201,9 +201,6 @@ Directories and files under the sysfs for Each Physical Device
 
 	sprintf(buf, "%s-%s", dev_driver_string(parent->dev), group->name);
 
-  (or using mdev_parent_dev(mdev) to arrive at the parent device outside
-  of the core mdev code)
-
 * device_api
 
   This attribute should show which device API is being created, for example,
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 06b8acc6a995d..f3c4ce475ce86 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1554,7 +1554,7 @@ static const struct vfio_device_ops intel_vgpu_dev_ops = {
 
 static int intel_vgpu_probe(struct mdev_device *mdev)
 {
-	struct device *pdev = mdev_parent_dev(mdev);
+	struct device *pdev = mdev->type->parent->dev;
 	struct intel_gvt *gvt = kdev_to_i915(pdev)->gvt;
 	struct intel_vgpu_type *type =
 		container_of(mdev->type, struct intel_vgpu_type, type);
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 3575e893b5e43..3bdea77d506d9 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -25,12 +25,6 @@ static struct class_compat *mdev_bus_compat_class;
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
index f92b4d8edf0e8..6d0a9b45a9eb6 100644
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

