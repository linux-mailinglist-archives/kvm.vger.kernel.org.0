Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B15722B8E6
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 23:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgGWVrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 17:47:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:44379 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728027AbgGWVrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 17:47:33 -0400
IronPort-SDR: OjrFRI8yCtlvV7BSCFEYIC8bZy6GiyOpGCemU0RbCjjV4DBPKFOZWY9Y3TSwHWsca7w4NDWdgu
 RQHn+IyPzfkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="148119987"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="148119987"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 14:47:32 -0700
IronPort-SDR: 1dwkdRzY8w5c6dtMzLClP43u/CEnoOunWElU8Ez6fkiir63mDeNeVzprdP6cmaR28fY7TUxd3o
 hc+T6WxEVXRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="311183983"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga004.fm.intel.com with ESMTP; 23 Jul 2020 14:47:28 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        fiona.trahe@intel.com, qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 2/5] vfio/pci: Add device denylist
Date:   Thu, 23 Jul 2020 22:47:02 +0100
Message-Id: <20200723214705.5399-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723214705.5399-1-giovanni.cabiddu@intel.com>
References: <20200723214705.5399-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add denylist of devices that by default are not probed by vfio-pci.
Devices in this list may be susceptible to untrusted application, even
if the IOMMU is enabled. To be accessed via vfio-pci, the user has to
explicitly disable the denylist.

The denylist can be disabled via the module parameter disable_denylist.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 7c0779018b1b..673f53c4798e 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -60,6 +60,10 @@ module_param(enable_sriov, bool, 0644);
 MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  Enabling SR-IOV on a PF typically requires support of the userspace PF driver, enabling VFs without such support may result in non-functional VFs or PF.");
 #endif
 
+static bool disable_denylist;
+module_param(disable_denylist, bool, 0444);
+MODULE_PARM_DESC(disable_denylist, "Disable use of device denylist. Disabling the denylist prevents binding to devices with known errata that may lead to exploitable stability or security issues when accessed by untrusted users.");
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -69,6 +73,29 @@ static inline bool vfio_vga_disabled(void)
 #endif
 }
 
+static bool vfio_pci_dev_in_denylist(struct pci_dev *pdev)
+{
+	return false;
+}
+
+static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
+{
+	if (!vfio_pci_dev_in_denylist(pdev))
+		return false;
+
+	if (disable_denylist) {
+		pci_warn(pdev,
+			 "device denylist disabled - allowing device %04x:%04x.\n",
+			 pdev->vendor, pdev->device);
+		return false;
+	}
+
+	pci_warn(pdev, "%04x:%04x exists in vfio-pci device denylist, driver probing disallowed.\n",
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
 
+	if (vfio_pci_is_denylisted(pdev))
+		return -EINVAL;
+
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
 		return -EINVAL;
 
@@ -2336,6 +2366,9 @@ static int __init vfio_pci_init(void)
 
 	vfio_pci_fill_ids();
 
+	if (disable_denylist)
+		pr_warn("device denylist disabled.\n");
+
 	return 0;
 
 out_driver:
-- 
2.26.2

