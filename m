Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD4327BEF7
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 10:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbgI2IPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 04:15:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:6009 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgI2IPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 04:15:13 -0400
IronPort-SDR: J9cX7kLAZ5XUAARyemAX9Ny7+zpASNeE0ucKIj6+pp0ZYvDf1qqKUfFEwQ0AjexzfejSgLNuKE
 /HS9yYbz9NOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="141546655"
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="141546655"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 01:15:11 -0700
IronPort-SDR: HdJEXw08RW2OmX8vo3ukX1Qwk5R1r9o2nTX3SKpagcWgz+VVDf6bA97Y6oSDzNrn7hKWI2yc+G
 1PYnviIZyXYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="345187563"
Received: from cfl-host.sh.intel.com ([10.239.158.142])
  by fmsmga002.fm.intel.com with ESMTP; 29 Sep 2020 01:15:07 -0700
From:   Fred Gao <fred.gao@intel.com>
To:     kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc:     Fred Gao <fred.gao@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Hang Yuan <hang.yuan@linux.intel.com>,
        Stuart Summers <stuart.summers@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH v2] vfio/pci: Refine Intel IGD OpRegion support
Date:   Wed, 30 Sep 2020 00:10:38 +0800
Message-Id: <20200929161038.15465-1-fred.gao@intel.com>
X-Mailer: git-send-email 2.24.1.1.gb6d4d82bd5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bypass the IGD initialization for Intel's dgfx devices with own expansion
ROM and the host/LPC bridge config space are no longer accessed.

v2: simply test if discrete or integrated gfx device
    with root bus. (Alex Williamson)

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Xiong Zhang <xiong.y.zhang@intel.com>
Cc: Hang Yuan <hang.yuan@linux.intel.com>
Cc: Stuart Summers <stuart.summers@intel.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Fred Gao <fred.gao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f634c81998bb..9258ccfadb79 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -336,10 +336,11 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
-
+	/* Intel's dgfx should not appear on root bus */
 	if (vfio_pci_is_vga(pdev) &&
 	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
+	    IS_ENABLED(CONFIG_VFIO_PCI_IGD) &&
+	    pci_is_root_bus(pdev->bus)) {
 		ret = vfio_pci_igd_init(vdev);
 		if (ret) {
 			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
-- 
2.24.1.1.gb6d4d82bd5

