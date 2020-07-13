Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA803219C75
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 11:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgGIJkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 05:40:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:64250 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgGIJkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 05:40:36 -0400
IronPort-SDR: TUkDxrYm0K5oUPtaq4IjJlPWrmr7Z9kdYaogTLtZhsel16XKu0DS6MKH5u8uqFvEX2ty1QEgP9
 CsMWhuSGhqNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="232839669"
X-IronPort-AV: E=Sophos;i="5.75,331,1589266800"; 
   d="scan'208";a="232839669"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 02:40:35 -0700
IronPort-SDR: BQZMK4+YVHFcQ3SFU++emTwOsWZRlVqRXLbj84UqiIH3Y0eiw1WJ6TBuC6RgMHZkLrrJnSsrRw
 nCR8s9KvXOQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,331,1589266800"; 
   d="scan'208";a="483735424"
Received: from cfl-host.sh.intel.com ([10.239.158.139])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jul 2020 02:40:33 -0700
From:   Fred Gao <fred.gao@intel.com>
To:     fred.gao@intel.com, kvm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Hang Yuan <hang.yuan@linux.intel.com>,
        Stuart Summers <stuart.summers@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH v1] vfio/pci: Refine Intel IGD OpRegion support
Date:   Fri, 10 Jul 2020 01:37:07 +0800
Message-Id: <20200709173707.29808-1-fred.gao@intel.com>
X-Mailer: git-send-email 2.24.1.1.gb6d4d82bd5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bypass the IGD initialization for Intel's dgfx devices with own expansion
ROM and the host/LPC bridge config space are no longer accessed.

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Xiong Zhang <xiong.y.zhang@intel.com>
Cc: Hang Yuan <hang.yuan@linux.intel.com>
Cc: Stuart Summers <stuart.summers@intel.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Fred Gao <fred.gao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f634c81998bb..0f4a34849836 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -28,6 +28,8 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 
+#include <drm/i915_pciids.h>
+
 #include "vfio_pci_private.h"
 
 #define DRIVER_VERSION  "0.2"
@@ -60,6 +62,12 @@ module_param(enable_sriov, bool, 0644);
 MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  Enabling SR-IOV on a PF typically requires support of the userspace PF driver, enabling VFs without such support may result in non-functional VFs or PF.");
 #endif
 
+/* Intel's dgfx is not IGD, so don't handle them the same way */
+static const struct pci_device_id intel_dgfx_pciids[] = {
+	INTEL_DG1_IDS(0),
+	{ }
+};
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -339,7 +347,8 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 
 	if (vfio_pci_is_vga(pdev) &&
 	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
+	    IS_ENABLED(CONFIG_VFIO_PCI_IGD) &&
+	    !pci_match_id(intel_dgfx_pciids, pdev)) {
 		ret = vfio_pci_igd_init(vdev);
 		if (ret) {
 			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
-- 
2.24.1.1.gb6d4d82bd5

