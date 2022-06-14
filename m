Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F47B54A870
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 06:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347314AbiFNEzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 00:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344415AbiFNEyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 00:54:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF56E37BDC;
        Mon, 13 Jun 2022 21:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yWgwBd01q1i40kokmt0dpMTuHq9q3ZmdNDZ448P4wTM=; b=TvyqgNSyF/EXJ689dgOYVovPO7
        ASMD/bSmT4Rr2TzxnRa2Rq3U9jIabnOphDZGcY7COYygRTM+1QrHCURcfqXk2eW2Zu/rvOt08xW7z
        4ouNBYulMEYoxAHHq798m6SGtxoM4++Elt0owbRerLMgQEUoTkoQN32zZbv7+SedY8tDQPazFJI/o
        JWGnURIVDy1fzWY7libLzTLXcFwLUJb9syvHtZCuYkOzI7mji1Xg77HmiXeotALsAlEQwdxB5Inq3
        5MTZYX3NsP3LtnKPjRTRz94DazDX2H93Yy1SIcYnml1mggTav1zSryaeLwwi3//Jq93XqH/9RDFiF
        XkN5iFAA==;
Received: from [2001:4bb8:180:36f6:1fed:6d48:cf16:d13c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o0yZn-0072hb-JD; Tue, 14 Jun 2022 04:54:52 +0000
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
        intel-gvt-dev@lists.freedesktop.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 08/13] vfio/mdev: remove mtype_get_parent_dev
Date:   Tue, 14 Jun 2022 06:54:23 +0200
Message-Id: <20220614045428.278494-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220614045428.278494-1-hch@lst.de>
References: <20220614045428.278494-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just open code the dereferences in the only user.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/s390/cio/vfio_ccw_ops.c |  3 +--
 drivers/vfio/mdev/mdev_core.c   | 10 ----------
 include/linux/mdev.h            |  2 --
 3 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 25b8d42a522ac..43d53736dfe3c 100644
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
index 479ae5ed6c392..20513b7f6b5eb 100644
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
index 83c85a0247f25..ecf964d34f2ca 100644
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

