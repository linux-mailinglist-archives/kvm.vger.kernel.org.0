Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778F56B091D
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjCHNb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjCHNbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:31:36 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385BF4222;
        Wed,  8 Mar 2023 05:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282189; x=1709818189;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4KV5nYt7nyzNQTkdxfsQ1VW0eB5Eh57ig35tZj0LnWI=;
  b=NI2e6EUfG4pdw+zAWYz8tYU5+ZDIqQ9UKBQAIgRA0LamSvqgWMRSX619
   PXNFQW/5Mm4DUbtDDSSZMyPIZG9LOHZW5HeMLj/BY+HAEFjb8TGfpb+L2
   522TiGpTQzcKrMRps5FUUnMHqaAPqaHurs/0/yfqqsRoF8XPEEOtjiTk0
   WYEklbr7eHSU9DYLOiwflt0PPPLOn9cLvZcrHSwL5sK7IFJ0kaSp5+yd8
   48bzjT4YX38fYlmgS+D/lSzC/S9yHHJWYrRaaJ8wcv+TJqbEprlC/eJUT
   CzuNlK8Ddj/cP3sPXmv0HzjCoCq6Fo6TGcDbm6kOWsEWsSFciEdNSWyEg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="336165195"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="336165195"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:29:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922789347"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="922789347"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 08 Mar 2023 05:29:21 -0800
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: [PATCH v6 09/24] vfio/pci: Only need to check opened devices in the dev_set for hot reset
Date:   Wed,  8 Mar 2023 05:28:48 -0800
Message-Id: <20230308132903.465159-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308132903.465159-1-yi.l.liu@intel.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the affected device is not opened by any user, it is not necessary to
check its ownership as it will not be opened by any user if a user is hot
resetting a device within this dev_set.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++++++++--
 include/uapi/linux/vfio.h        |  8 ++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 65bbef562268..f13b093557a9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2429,10 +2429,23 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 
 	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
 		/*
-		 * Test whether all the affected devices are contained by the
+		 * Test whether all the affected devices can be reset by the
+		 * user.  The affected devices may already been opened or not
+		 * yet.
+		 *
+		 * For the devices not opened yet, user can reset them as it
+		 * reason is that the hot reset is done under the protection
+		 * of the dev_set->lock, and device open is also under this
+		 * lock.  During the hot reset, such devices can not be opened
+		 * by other users.
+		 *
+		 * For the devices that have been opened, needs to check the
+		 * ownership.  If the user provides a set of group fds, test
+		 * whether all the opened affected devices are contained by the
 		 * set of groups provided by the user.
 		 */
-		if (!vfio_dev_in_groups(cur_vma, groups)) {
+		if (cur_vma->vdev.open_count &&
+		    !vfio_dev_in_groups(cur_vma, groups)) {
 			ret = -EINVAL;
 			goto err_undo;
 		}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0552e8dcf0cb..f96e5689cffc 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -673,6 +673,14 @@ struct vfio_pci_hot_reset_info {
  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
  *				    struct vfio_pci_hot_reset)
  *
+ * Userspace requests hot reset for the devices it uses.  Due to the
+ * underlying topology, multiple devices can be affected in the reset
+ * while some might be opened by another user.  To avoid interference
+ * the calling user must ensure all affected devices, if opened, are
+ * owned by itself.
+ *
+ * The ownership is proved by an array of group fds.
+ *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_pci_hot_reset {
-- 
2.34.1

