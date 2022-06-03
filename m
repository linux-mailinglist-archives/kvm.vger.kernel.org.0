Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F094853C4FC
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 08:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241519AbiFCGeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 02:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241526AbiFCGd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 02:33:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB716423;
        Thu,  2 Jun 2022 23:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ttx6l+0HMmlrm7lbRX8tgRE+YdXdHO5tJj697DvsFyE=; b=z/ezGGor20mzCtPYfqZmvkuWZ/
        r8xRI+orC5AWUGuBGYl/BoT61Hgo+YKO+lFULckuB9UpEatk/Orp/TOoMTJ/pxGMaWCqtPx79Hw+F
        NrjMjPKaP4CzK6+4N/QTqrCJN4xp//W028TG0Jkyk/0bQVe56LNp2fPRqrYT0dBunSjzm7oUzmkhx
        oh+egGZgRa4Orf4YKHkxd7gdApMCPFcrAVMY8fyM/6c6Gn13eb6A61dosIFOrqHtIISKT3dsuDbuD
        1Dec2m/SLXbG67wH2Vztic/zDc5MaZR8eD3Z5pwKs/OijYVW74AkAh6CYkPtp7+1uE+ddBOO0woJh
        THgIYdEQ==;
Received: from [2001:4bb8:185:a81e:b29a:8b56:eb9a:ca3b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nx0sa-00616R-QN; Fri, 03 Jun 2022 06:33:53 +0000
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
Subject: [PATCH 8/8] vfio/mdev: remove mtype_get_parent_dev
Date:   Fri,  3 Jun 2022 08:33:28 +0200
Message-Id: <20220603063328.3715-9-hch@lst.de>
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
 drivers/s390/cio/vfio_ccw_ops.c |  3 +--
 drivers/vfio/mdev/mdev_core.c   | 10 ----------
 include/linux/mdev.h            |  2 --
 3 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index e219ea3c62fc6..4864271cffc1e 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -88,8 +88,7 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 					struct mdev_type_attribute *attr,
 					char *buf)
 {
-	struct vfio_ccw_private *private =
-		dev_get_drvdata(mtype_get_parent_dev(mtype));
+	struct vfio_ccw_private *private = dev_get_drvdata(mtype->parent->dev);
 
 	return sprintf(buf, "%d\n", atomic_read(&private->avail));
 }
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 3bdea77d506d9..3f51fbdf9393c 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -25,16 +25,6 @@ static struct class_compat *mdev_bus_compat_class;
 static LIST_HEAD(mdev_list);
 static DEFINE_MUTEX(mdev_list_lock);
 
-/*
- * Used in mdev_type_attribute sysfs functions to return the parent struct
- * device
- */
-struct device *mtype_get_parent_dev(struct mdev_type *mtype)
-{
-	return mtype->parent->dev;
-}
-EXPORT_SYMBOL(mtype_get_parent_dev);
-
 /* Caller must hold parent unreg_sem read or write lock */
 static void mdev_device_remove_common(struct mdev_device *mdev)
 {
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 6d0a9b45a9eb6..dbf054d084886 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -48,8 +48,6 @@ int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type,
 void mdev_type_remove(struct mdev_type *type,
 		const struct attribute * const *attrs);
 
-struct device *mtype_get_parent_dev(struct mdev_type *mtype);
-
 /* interface for exporting mdev supported type attributes */
 struct mdev_type_attribute {
 	struct attribute attr;
-- 
2.30.2

