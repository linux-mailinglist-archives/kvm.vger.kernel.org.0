Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC1259B93D
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 08:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbiHVGWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 02:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiHVGWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 02:22:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BB027177;
        Sun, 21 Aug 2022 23:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=jx+VLNzHA/HkXTZLdSauQ49X7tNoODw4sCYZ46qw/9g=; b=GteyuaHJ9u6QGYk65RopZTZBQR
        c04TIvIk72G6fwVSZQROKo1uSjmtYQL8gUUUn9j5X3MJWOJTSVVNAiKSHfCunFKMU9xhK2tniionx
        KehbLrDqEAJmcNrMHPF1BaGSKeUo91RAiw+j0YZcY2GC5Nx3z/xjVOEhl+0i2wLiQ6kFsR1tsXN9A
        OBSlasaLbaAShenfDTBwlisy3IdCrOmJ+1Ctc+xI8Y2NxZ4IK7tl7eQRj4Z/gPU6GDBsfjw9ZC4v2
        u2NieFdBmmb4HLz+Xf9+vXgLeqBaBkTfSoRB9/3tafJAblM7TZ38cTJhuxNsTX/NctvOm+hh74MMx
        R4uQqlcg==;
Received: from [2001:4bb8:198:6528:7eb3:3a42:932d:eeba] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oQ0pY-005NaP-5L; Mon, 22 Aug 2022 06:22:36 +0000
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
Subject: [PATCH 09/14] vfio/mdev: remove mtype_get_parent_dev
Date:   Mon, 22 Aug 2022 08:22:03 +0200
Message-Id: <20220822062208.152745-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220822062208.152745-1-hch@lst.de>
References: <20220822062208.152745-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just open code the dereferences in the only user.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_ops.c |  3 +--
 drivers/vfio/mdev/mdev_core.c   | 10 ----------
 include/linux/mdev.h            |  2 --
 3 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 4136e1c100c8a..0ec0e310c91ea 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -62,8 +62,7 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 					struct mdev_type_attribute *attr,
 					char *buf)
 {
-	struct vfio_ccw_private *private =
-		dev_get_drvdata(mtype_get_parent_dev(mtype));
+	struct vfio_ccw_private *private = dev_get_drvdata(mtype->parent->dev);
 
 	return sprintf(buf, "%d\n", atomic_read(&private->avail));
 }
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 75628759a3bf0..93f8caf2e5f77 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -23,16 +23,6 @@ static struct class_compat *mdev_bus_compat_class;
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
index bbedffcb38d48..e445f809ceca3 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -51,8 +51,6 @@ static inline struct mdev_device *to_mdev_device(struct device *dev)
 	return container_of(dev, struct mdev_device, dev);
 }
 
-struct device *mtype_get_parent_dev(struct mdev_type *mtype);
-
 /* interface for exporting mdev supported type attributes */
 struct mdev_type_attribute {
 	struct attribute attr;
-- 
2.30.2

