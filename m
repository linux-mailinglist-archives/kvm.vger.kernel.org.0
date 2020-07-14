Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470B621E85C
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 08:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGNGgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 02:36:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:13263 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbgGNGgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 02:36:50 -0400
IronPort-SDR: asnV7qex4pWT+nEBhN7DvVhRQmdW/PvtB3hWahBxBqBaoZKk3X1PSfXRy1we6e4cYcbXDphSk2
 gn7DZC7xSLBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="210355838"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="210355838"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 23:36:49 -0700
IronPort-SDR: 8iJ3H4LEE9axovPwmLmrxX1dmgjtemI62YSFo+gPmAmRAiE0okjkL2R7TM/n6q9kEO+pb9U3dQ
 71+PEbWiQG4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="299435545"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga002.jf.intel.com with ESMTP; 13 Jul 2020 23:36:44 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 2/5] vfio/pci: Add device blocklist
Date:   Tue, 14 Jul 2020 07:36:07 +0100
Message-Id: <20200714063610.849858-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714063610.849858-1-giovanni.cabiddu@intel.com>
References: <20200714063610.849858-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add blocklist of devices that by default are not probed by vfio-pci.
Devices in this list may be susceptible to untrusted application, even
if the IOMMU is enabled. To be accessed via vfio-pci, the user has to
explicitly disable the blocklist.

The blocklist can be disabled via the module parameter disable_blocklist.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 7c0779018b1b..ea5904ca6cbf 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -60,6 +60,10 @@ module_param(enable_sriov, bool, 0644);
 MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  Enabling SR-IOV on a PF typically requires support of the userspace PF driver, enabling VFs without such support may result in non-functional VFs or PF.");
 #endif
 
+static bool disable_blocklist;
+module_param(disable_blocklist, bool, 0444);
+MODULE_PARM_DESC(disable_blocklist, "Disable device blocklist. If set, i.e. blocklist disabled, then blocklisted devices are allowed to be probed by vfio-pci.");
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -69,6 +73,29 @@ static inline bool vfio_vga_disabled(void)
 #endif
 }
 
+static bool vfio_pci_dev_in_blocklist(struct pci_dev *pdev)
+{
+	return false;
+}
+
+static bool vfio_pci_is_blocklisted(struct pci_dev *pdev)
+{
+	if (!vfio_pci_dev_in_blocklist(pdev))
+		return false;
+
+	if (disable_blocklist) {
+		pci_warn(pdev,
+			 "device blocklist disabled - allowing device %04x:%04x.\n",
+			 pdev->vendor, pdev->device);
+		return false;
+	}
+
+	pci_warn(pdev, "%04x:%04x is blocklisted - probe will fail.\n",
+		 pdev->vendor, pdev->device);
+
+	return true;
+}
+
 /*
  * Our VGA arbiter participation is limited since we don't know anything
  * about the device itself.  However, if the device is the only VGA device
@@ -1847,6 +1874,9 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct iommu_group *group;
 	int ret;
 
+	if (vfio_pci_is_blocklisted(pdev))
+		return -EINVAL;
+
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
 		return -EINVAL;
 
@@ -2336,6 +2366,9 @@ static int __init vfio_pci_init(void)
 
 	vfio_pci_fill_ids();
 
+	if (disable_blocklist)
+		pr_warn("device blocklist disabled.\n");
+
 	return 0;
 
 out_driver:
-- 
2.26.2

