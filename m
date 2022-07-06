Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2A4568062
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 09:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiGFHnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 03:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiGFHnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 03:43:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC98237DB;
        Wed,  6 Jul 2022 00:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=MJquY0cBq6HegNcR5aAGNBle4qpO78JnndWMh/mUJG4=; b=o5kuXD0Bh4AZF6SDYhzKkyYYql
        Spdlv6gI4ank/TDlgzN+r4Ky+PgoIvvfvPfpaoLjwzkYbsQ/MkTz216sT6DJUMqgGN3X7M1BD0V2j
        EIogYos8eO2FhQ4TEOea6A6LT0wEkqT+BPTqlgpBpiwgksT37kKqmF4pnZDvKdke7o6NPfFOYXkqD
        0Swv4iskKx/Ymrpv2rUyjAku38Dh0RIMWoeWt5xGef8al1FvxhEVQOyyJN95+uL7eAb2LhBkBW54Q
        a6u0AW19ULRqGZrnRKmAQ7uvcDZcNF5SbD4e6aaLcnvhj0lpO5MR2yjZehULieVcvsX12eHkMHgYu
        cHeEJ2OQ==;
Received: from [2001:4bb8:189:3c4a:34cd:2d1d:8766:aad] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8zgi-007A0x-Ud; Wed, 06 Jul 2022 07:43:09 +0000
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
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org
Subject: [PATCH 15/15] vfio/mdev: remove an extra parent kobject reference
Date:   Wed,  6 Jul 2022 09:42:19 +0200
Message-Id: <20220706074219.3614-16-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706074219.3614-1-hch@lst.de>
References: <20220706074219.3614-1-hch@lst.de>
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

The mdev_type already holds a reference to the parent through
mdev_types_kset, so drop the extra reference.

Suggested-by: Kirti Wankhede <kwankhede@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/mdev/mdev_sysfs.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index c5cd035d591d0..e2087cac1c859 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -153,8 +153,6 @@ static void mdev_type_release(struct kobject *kobj)
 	struct mdev_type *type = to_mdev_type(kobj);
 
 	pr_debug("Releasing group %s\n", kobj->name);
-	/* Pairs with the get in add_mdev_supported_type() */
-	put_device(type->parent->dev);
 	kfree(type);
 }
 
@@ -170,16 +168,12 @@ static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
 
 	type->kobj.kset = parent->mdev_types_kset;
 	type->parent = parent;
-	/* Pairs with the put in mdev_type_release() */
-	get_device(parent->dev);
 
 	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
 				   "%s-%s", dev_driver_string(parent->dev),
 				   type->sysfs_name);
-	if (ret) {
-		kobject_put(&type->kobj);
+	if (ret)
 		return ret;
-	}
 
 	type->devices_kobj = kobject_create_and_add("devices", &type->kobj);
 	if (!type->devices_kobj) {
@@ -191,7 +185,6 @@ static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
 
 attr_devices_failed:
 	kobject_del(&type->kobj);
-	kobject_put(&type->kobj);
 	return ret;
 }
 
-- 
2.30.2

