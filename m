Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462E96D3240
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 17:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjDAPTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 11:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbjDAPSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 11:18:55 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA2920DA5;
        Sat,  1 Apr 2023 08:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680362329; x=1711898329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UGMAQSzJDGu2jFNVvQm9xR08gZhYc2KjsQ3tE+TSPbo=;
  b=I3Ib251aybZK56aZcr/SLcar1r5nJyaUsasTvDNlZKlGBeJuEm5kScXi
   CIZnuNUjV4pOc1UkGE88+a+xS9dIjx+MvOVSsNg0pZQvAPIGDCmUKBxd3
   WBTHt/t8BuZawWnDjA7k+vQfmhsyc25uFSzeYvkBUyrjyyQJIcbRKQCnD
   OuIozDDBgyyh4NRa9Hb2NAKwE7mR8WjzDsBX1X39+N1/1QAa89OsyCiQo
   adftWXti0Sc8T272Gbtd8rEvNwqaRZ/h1EqeF8SUFrDMShy8xM6u50LDL
   x2hDtcqe5P5AmVd2RFo7KCtZcyB9ECD5ddKtrXeXjQ4+sn19g+JBBRN1e
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="404411366"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="404411366"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 08:18:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="678937225"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="678937225"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 01 Apr 2023 08:18:46 -0700
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
        yanting.jiang@intel.com
Subject: [PATCH v9 20/25] vfio: Move vfio_device_group_unregister() to be the first operation in unregister
Date:   Sat,  1 Apr 2023 08:18:28 -0700
Message-Id: <20230401151833.124749-21-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401151833.124749-1-yi.l.liu@intel.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This can avoid endless vfio_device refcount increasement by userspace,
which would keep blocking the vfio_unregister_group_dev().

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 0337d1ace716..6c31212740fa 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -320,6 +320,12 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	bool interrupted = false;
 	long rc;
 
+	/*
+	 * Prevent new device opened by userspace via the
+	 * VFIO_GROUP_GET_DEVICE_FD in the group path.
+	 */
+	vfio_device_group_unregister(device);
+
 	vfio_device_put_registration(device);
 	rc = try_wait_for_completion(&device->comp);
 	while (rc <= 0) {
@@ -343,8 +349,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 		}
 	}
 
-	vfio_device_group_unregister(device);
-
 	/* Balances device_add in register path */
 	device_del(&device->device);
 
-- 
2.34.1

