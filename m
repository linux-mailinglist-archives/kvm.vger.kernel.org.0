Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD7B2C36AF
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 03:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgKYCS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 21:18:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:3710 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgKYCS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 21:18:28 -0500
IronPort-SDR: mE2EYBsCJ8aWVvveXOTun/vK0rYq/ifdV/q4BxW5GGP62gFWwFREKDR10QcesjQyoVnezk6kUZ
 JWCS4Ae2l65g==
X-IronPort-AV: E=McAfee;i="6000,8403,9815"; a="190186325"
X-IronPort-AV: E=Sophos;i="5.78,367,1599548400"; 
   d="scan'208";a="190186325"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 18:18:27 -0800
IronPort-SDR: PxDT7wIK6vg4ude8q+gVTZm2n/bqdKFL/4Kk0K22bSnazJY6R5cpC6pUfv2wGkpL2iXAVQBULd
 sgzRD+N6EvGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,367,1599548400"; 
   d="scan'208";a="536696759"
Received: from unknown (HELO coxu-arch-shz.sh.intel.com) ([10.239.160.22])
  by fmsmga005.fm.intel.com with ESMTP; 24 Nov 2020 18:18:26 -0800
From:   Colin Xu <colin.xu@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     colin.xu@intel.com, swee.yee.fonn@intel.com
Subject: [RFC PATCH] vfio/pci: Allow force needs_pm_restore as specified by device:vendor
Date:   Wed, 25 Nov 2020 10:18:24 +0800
Message-Id: <20201125021824.27411-1-colin.xu@intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Force specific device listed in params pm_restore_ids to follow
device state save/restore as needs_pm_restore.
Some device has NoSoftRst so will skip current state save/restore enabled
by needs_pm_restore. However once the device experienced power state
D3<->D0 transition, either by idle_d3 or the guest driver changes PM_CTL,
the guest driver won't get correct devie state although the configure
space doesn't change.

Cc: Swee Yee Fonn <swee.yee.fonn@intel.com>
Signed-off-by: Colin Xu <colin.xu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 66 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e6190173482c..50a4141c9e1d 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -34,6 +34,15 @@
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
 
+#define VFIO_MAX_PM_DEV 32
+struct vfio_pm_devs {
+	struct {
+		unsigned short  vendor;
+		unsigned short  device;
+	} ids[VFIO_MAX_PM_DEV];
+	u32 count;
+};
+
 static char ids[1024] __initdata;
 module_param_string(ids, ids, sizeof(ids), 0);
 MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
@@ -64,6 +73,10 @@ static bool disable_denylist;
 module_param(disable_denylist, bool, 0444);
 MODULE_PARM_DESC(disable_denylist, "Disable use of device denylist. Disabling the denylist allows binding to devices with known errata that may lead to exploitable stability or security issues when accessed by untrusted users.");
 
+static char pm_restore_ids[1024] __initdata;
+module_param_string(pm_restore_ids, pm_restore_ids, sizeof(pm_restore_ids), 0);
+MODULE_PARM_DESC(pm_restore_ids, "comma separated device in format of \"vendor:device\"");
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -260,10 +273,50 @@ static bool vfio_pci_nointx(struct pci_dev *pdev)
 	return false;
 }
 
+static struct vfio_pm_devs pm_devs = {0};
+static void __init vfio_pci_fill_pm_ids(void)
+{
+	char *p, *id;
+	int idx = 0;
+
+	/* no ids passed actually */
+	if (pm_restore_ids[0] == '\0')
+		return;
+
+	/* add ids specified in the module parameter */
+	p = pm_restore_ids;
+	while ((id = strsep(&p, ","))) {
+		unsigned int vendor, device = PCI_ANY_ID;
+		int fields;
+
+		if (!strlen(id))
+			continue;
+
+		fields = sscanf(id, "%x:%x", &vendor, &device);
+
+		if (fields != 2) {
+			pr_warn("invalid vendor:device string \"%s\"\n", id);
+			continue;
+		}
+
+		if (idx < VFIO_MAX_PM_DEV) {
+			pm_devs.ids[idx].vendor = vendor;
+			pm_devs.ids[idx].device = device;
+			pm_devs.count++;
+			idx++;
+			pr_info("add [%04x:%04x] for needs_pm_restore\n",
+				vendor, device);
+		} else {
+			pr_warn("Exceed maximum %d, skip adding [%04x:%04x] for needs_pm_restore\n",
+				VFIO_MAX_PM_DEV, vendor, device);
+		}
+	}
+}
+
 static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
-	u16 pmcsr;
+	u16 pmcsr, idx;
 
 	if (!pdev->pm_cap)
 		return;
@@ -271,6 +324,16 @@ static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
 	pci_read_config_word(pdev, pdev->pm_cap + PCI_PM_CTRL, &pmcsr);
 
 	vdev->needs_pm_restore = !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET);
+
+	for (idx = 0; idx < pm_devs.count; idx++) {
+		if (vdev->pdev->vendor == pm_devs.ids[idx].vendor &&
+		    vdev->pdev->device == pm_devs.ids[idx].device) {
+			vdev->needs_pm_restore = true;
+			pr_info("force [%04x:%04x] to needs_pm_restore\n",
+				vdev->pdev->vendor, vdev->pdev->device);
+			break;
+		}
+	}
 }
 
 /*
@@ -2423,6 +2486,7 @@ static int __init vfio_pci_init(void)
 		goto out_driver;
 
 	vfio_pci_fill_ids();
+	vfio_pci_fill_pm_ids();
 
 	if (disable_denylist)
 		pr_warn("device denylist disabled.\n");
-- 
2.29.2

