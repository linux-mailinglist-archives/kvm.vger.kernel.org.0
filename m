Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F273F113A6B
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 04:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbfLEDeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 22:34:19 -0500
Received: from mga12.intel.com ([192.55.52.136]:43800 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728821AbfLEDeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 22:34:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 19:34:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,279,1571727600"; 
   d="scan'208";a="243094962"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.9])
  by fmsmga002.fm.intel.com with ESMTP; 04 Dec 2019 19:34:16 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, qemu-devel@nongnu.org, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 2/9] vfio/pci: test existence before calling region->ops
Date:   Wed,  4 Dec 2019 22:25:55 -0500
Message-Id: <20191205032555.29700-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191205032419.29606-1-yan.y.zhao@intel.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For regions registered through vfio_pci_register_dev_region(),
before calling region->ops, first check whether region->ops is not null.

As in the next two patches, dev regions of null region->ops are to be
registered by default on behalf of vendor driver, we need to check here
to prevent null pointer access if vendor driver forgets to handle those
dev regions

Cc: Kevin Tian <kevin.tian@intel.com>

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 55080ff29495..f3730252ee82 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -398,8 +398,12 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 
 	vdev->virq_disabled = false;
 
-	for (i = 0; i < vdev->num_regions; i++)
+	for (i = 0; i < vdev->num_regions; i++) {
+		if (!vdev->region[i].ops || vdev->region[i].ops->release)
+			continue;
+
 		vdev->region[i].ops->release(vdev, &vdev->region[i]);
+	}
 
 	vdev->num_regions = 0;
 	kfree(vdev->region);
@@ -900,7 +904,8 @@ static long vfio_pci_ioctl(void *device_data,
 			if (ret)
 				return ret;
 
-			if (vdev->region[i].ops->add_capability) {
+			if (vdev->region[i].ops &&
+					vdev->region[i].ops->add_capability) {
 				ret = vdev->region[i].ops->add_capability(vdev,
 						&vdev->region[i], &caps);
 				if (ret)
@@ -1251,6 +1256,9 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 		return vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite);
 	default:
 		index -= VFIO_PCI_NUM_REGIONS;
+		if (!vdev->region[index].ops || !vdev->region[index].ops->rw)
+			return -EINVAL;
+
 		return vdev->region[index].ops->rw(vdev, buf,
 						   count, ppos, iswrite);
 	}
-- 
2.17.1

