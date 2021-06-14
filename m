Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9CB3A69BA
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 17:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhFNPLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 11:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbhFNPLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 11:11:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCA3C061766;
        Mon, 14 Jun 2021 08:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=NwFt6Rh6oe+pwJn0pLaLOHbSwglWoxkKqpc719j6xiw=; b=OKtlELdG+PLca2hx24e+oHg1Kb
        R5nJ+5N9Z1yAkGsnJlMBq6Wz9B3p3Er1hnRqbeViYXwE0jGVI2zyu3a3AfmVv1260bjigBkKI1Cac
        OqeNbuCBI3E9J+j19nBRYc/0SIQAcWAyAlKlw5nkcrXhw2nrMG41ByAIlzdMEmLN2pzEM67RnMsvQ
        DVaaW4GrTm34DVl07c3gPi1CcO9BZf9kLSXMq2mpczexxuF5SMQN9Jt+iwLhOzEK6Yt+9gwUIzKJb
        vn++GQQ072dlRDqe1IDMVVd0Zdz6t3WdGf2swBXcgkEML7qN/rdJAJPotEke79oBwdzSmg/oQ7Qn5
        6nNf7n3Q==;
Received: from [2001:4bb8:19b:fdce:4b1a:b4aa:22d8:1629] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lsoD3-00Efid-TB; Mon, 14 Jun 2021 15:09:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 05/10] driver core: Export device_driver_attach()
Date:   Mon, 14 Jun 2021 17:08:41 +0200
Message-Id: <20210614150846.4111871-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210614150846.4111871-1-hch@lst.de>
References: <20210614150846.4111871-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

This is intended as a replacement API for device_bind_driver(). It has at
least the following benefits:

- Internal locking. Few of the users of device_bind_driver() follow the
  locking rules

- Calls device driver probe() internally. Notably this means that devm
  support for probe works correctly as probe() error will call
  devres_release_all()

- struct device_driver -> dev_groups is supported

- Simplified calling convention, no need to manually call probe().

The general usage is for situations that already know what driver to bind
and need to ensure the bind is synchronized with other logic. Call
device_driver_attach() after device_add().

If probe() returns a failure then this will be preserved up through to the
error return of device_driver_attach().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/base/base.h    | 1 -
 drivers/base/dd.c      | 3 +++
 include/linux/device.h | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index e5f9b7e656c3..404db83ee5ec 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -152,7 +152,6 @@ extern int driver_add_groups(struct device_driver *drv,
 			     const struct attribute_group **groups);
 extern void driver_remove_groups(struct device_driver *drv,
 				 const struct attribute_group **groups);
-int device_driver_attach(struct device_driver *drv, struct device *dev);
 void device_driver_detach(struct device *dev);
 
 extern char *make_class_name(const char *name, struct kobject *kobj);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 8c65673e344c..aab47c0b356f 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -471,6 +471,8 @@ static void driver_sysfs_remove(struct device *dev)
  * (It is ok to call with no other effort from a driver's probe() method.)
  *
  * This function must be called with the device lock held.
+ *
+ * Callers should prefer to use device_driver_attach() instead.
  */
 int device_bind_driver(struct device *dev)
 {
@@ -1063,6 +1065,7 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
 		return -EAGAIN;
 	return ret;
 }
+EXPORT_SYMBOL_GPL(device_driver_attach);
 
 static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index f1a00040fa53..d8b9c9e7d493 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -845,6 +845,8 @@ static inline void *dev_get_platdata(const struct device *dev)
  * Manual binding of a device to driver. See drivers/base/bus.c
  * for information on use.
  */
+int __must_check device_driver_attach(struct device_driver *drv,
+				      struct device *dev);
 int __must_check device_bind_driver(struct device *dev);
 void device_release_driver(struct device *dev);
 int  __must_check device_attach(struct device *dev);
-- 
2.30.2

