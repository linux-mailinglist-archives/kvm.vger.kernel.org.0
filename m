Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D325655F0
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 14:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbiGDMwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 08:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbiGDMwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 08:52:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4130411169;
        Mon,  4 Jul 2022 05:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=I0iofj79GlK4ZjKVtTaAGmfcGkld8bbEYYeqbMBSm7Q=; b=wHGbcP9Gy/QEUHukp4ut0PDQvg
        bnsqxZUfYEmH67YsYxlsTKrj7s9Ji7QHQFyteKHvfetjLjgeMm3nXWX9szp9TX6nlVQ48CXDvfsi9
        UP/QNUgyHuUZ753BmW1G2jyFtWnWnylEgarlwy7KEO0FTZy0KqnkbTbQNLsNzgoFHFRQhR4y5PzIW
        d1bWq/0nOmT7QC53S14AsUd4bf5VXNYv7on9FMilWdBuZJ+FyJiGD7iU3XPj65kNgdA4dcqXexX7D
        by2IyBlcdim+XOtHfYoM/7NJCDpLWJVUGpyAjXcZDVHk5U+8F52EALrqbaR+oI9vaVenNCvxP0HV0
        wJClapgA==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LYa-008wQI-AB; Mon, 04 Jul 2022 12:52:04 +0000
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
Subject: [PATCH 06/14] vfio/mdev: remove mdev_from_dev
Date:   Mon,  4 Jul 2022 14:51:36 +0200
Message-Id: <20220704125144.157288-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220704125144.157288-1-hch@lst.de>
References: <20220704125144.157288-1-hch@lst.de>
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

Just open code it in the only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed By: Kirti Wankhede <kwankhede@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c | 6 ++----
 include/linux/mdev.h          | 4 ----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 2d95a497fd3b2..bde7ce620dae0 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -53,10 +53,8 @@ static void mdev_device_remove_common(struct mdev_device *mdev)
 
 static int mdev_device_remove_cb(struct device *dev, void *data)
 {
-	struct mdev_device *mdev = mdev_from_dev(dev);
-
-	if (mdev)
-		mdev_device_remove_common(mdev);
+	if (dev->bus == &mdev_bus_type)
+		mdev_device_remove_common(to_mdev_device(dev));
 	return 0;
 }
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index cc70cc1e25d91..411b655c36ab2 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -107,9 +107,5 @@ static inline struct device *mdev_dev(struct mdev_device *mdev)
 {
 	return &mdev->dev;
 }
-static inline struct mdev_device *mdev_from_dev(struct device *dev)
-{
-	return dev->bus == &mdev_bus_type ? to_mdev_device(dev) : NULL;
-}
 
 #endif /* MDEV_H */
-- 
2.30.2

