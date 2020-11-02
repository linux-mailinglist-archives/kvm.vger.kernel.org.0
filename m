Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B18D2A27B4
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 11:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgKBKG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 05:06:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:47414 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbgKBKG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 05:06:29 -0500
IronPort-SDR: HE8E9QULEDf2ch5+Wsg7z+OgUV1LESyi9krEynIAc1XAEEpHzWWRvUcFs+1RvV1tJGNVuFFu4m
 KQperzu9iWJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9792"; a="186692421"
X-IronPort-AV: E=Sophos;i="5.77,444,1596524400"; 
   d="scan'208";a="186692421"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 02:06:28 -0800
IronPort-SDR: dOcdvCG/tii0EzWUK+yCLhpjz/Z99X5uQxcVBlpB+z/PyrSQ+5MNTAlzS3z2R9arPLoXhtVH3D
 /RFj2QOzDdTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,444,1596524400"; 
   d="scan'208";a="336121710"
Received: from cfl-host.sh.intel.com ([10.239.158.142])
  by orsmga002.jf.intel.com with ESMTP; 02 Nov 2020 02:06:26 -0800
From:   Fred Gao <fred.gao@intel.com>
To:     kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc:     Fred Gao <fred.gao@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Hang Yuan <hang.yuan@linux.intel.com>,
        Stuart Summers <stuart.summers@intel.com>
Subject: [PATCH v3] vfio/pci: Bypass IGD init in case of -ENODEV
Date:   Tue,  3 Nov 2020 02:01:20 +0800
Message-Id: <20201102180120.25319-1-fred.gao@intel.com>
X-Mailer: git-send-email 2.24.1.1.gb6d4d82bd5
In-Reply-To: <20200929161038.15465-1-fred.gao@intel.com>
References: <20200929161038.15465-1-fred.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bypass the IGD initialization when -ENODEV returns,
that should be the case if opregion is not available for IGD
or within discrete graphics device's option ROM,
or host/lpc bridge is not found.

Then use of -ENODEV here means no special device resources found
which needs special care for VFIO, but we still allow other normal
device resource access.

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Xiong Zhang <xiong.y.zhang@intel.com>
Cc: Hang Yuan <hang.yuan@linux.intel.com>
Cc: Stuart Summers <stuart.summers@intel.com>
Signed-off-by: Fred Gao <fred.gao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f634c81998bb..c88cf9937469 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -341,7 +341,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
 	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
 		ret = vfio_pci_igd_init(vdev);
-		if (ret) {
+		if (ret && ret != -ENODEV) {
 			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
 			goto disable_exit;
 		}
-- 
2.24.1.1.gb6d4d82bd5

