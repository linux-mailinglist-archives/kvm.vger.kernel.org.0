Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E3074E4C5
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 04:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjGKC7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 22:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjGKC7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 22:59:47 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222A4E6C;
        Mon, 10 Jul 2023 19:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689044383; x=1720580383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w64PBZBpwikwjApBh0qcsx7B85QSOftXwQDkYqhx5Os=;
  b=n3JnFb+3eRrCU1bMPFI9UnWTa3mAEkBFigLw/Hf8QD6GIb1ALnkDNBi4
   Hch5bH/ai9eeyHqNpJAhSKCmRUZZk7ACCEP4PDmtR5d9tqrFCY9UgQsBB
   CiwAsYOhX35S0IfF17DQhY7JI2CE0pljjfPLO58iIlYZ7rbjcWq6S4VBf
   YvOwv+/MuwvV8oXm6E9Pvi1SkB57345WqerLG5Yx+ze0sD4t9NMg5a4Kn
   s1eH8rJgvEKMNhYKIENeR5WcAOFUrnVt8WTRejLL1qD3l3768fYzSWR9D
   amJXkIitx+mRZAD3OZpWdxogM2S967CB1fUep+BiuBQ4Af9mU8ZstfWgY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="361973063"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="361973063"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 19:59:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="724250812"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="724250812"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jul 2023 19:59:38 -0700
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
Subject: [PATCH v14 09/26] vfio: Make vfio_df_open() single open for device cdev path
Date:   Mon, 10 Jul 2023 19:59:11 -0700
Message-Id: <20230711025928.6438-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711025928.6438-1-yi.l.liu@intel.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO group has historically allowed multi-open of the device FD. This
was made secure because the "open" was executed via an ioctl to the
group FD which is itself only single open.

However, no known use of multiple device FDs today. It is kind of a
strange thing to do because new device FDs can naturally be created
via dup().

When we implement the new device uAPI (only used in cdev path) there is
no natural way to allow the device itself from being multi-opened in a
secure manner. Without the group FD we cannot prove the security context
of the opener.

Thus, when moving to the new uAPI we block the ability of opening
a device multiple times. Given old group path still allows it we store
a vfio_group pointer in struct vfio_device_file to differentiate.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 2 ++
 drivers/vfio/vfio.h      | 1 +
 drivers/vfio/vfio_main.c | 7 +++++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 2751d61689c4..4e6277191eb4 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -245,6 +245,8 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 		goto err_out;
 	}
 
+	df->group = device->group;
+
 	ret = vfio_df_group_open(df);
 	if (ret)
 		goto err_free;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index ae7dd2ca14b9..85484a971a3e 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -18,6 +18,7 @@ struct vfio_container;
 
 struct vfio_device_file {
 	struct vfio_device *device;
+	struct vfio_group *group;
 
 	u8 access_granted;
 	spinlock_t kvm_ref_lock; /* protect kvm field */
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index c37fc14599d0..be5e4ddd5901 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -492,6 +492,13 @@ int vfio_df_open(struct vfio_device_file *df)
 
 	lockdep_assert_held(&device->dev_set->lock);
 
+	/*
+	 * Only the group path allows the device to be opened multiple
+	 * times.  The device cdev path doesn't have a secure way for it.
+	 */
+	if (device->open_count != 0 && !df->group)
+		return -EINVAL;
+
 	device->open_count++;
 	if (device->open_count == 1) {
 		ret = vfio_df_device_first_open(df);
-- 
2.34.1

