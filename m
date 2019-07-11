Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48D465912
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbfGKOcO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:32:14 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:45803 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbfGKOcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:32:14 -0400
X-Originating-IP: 92.137.69.152
Received: from localhost (alyon-656-1-672-152.w92-137.abo.wanadoo.fr [92.137.69.152])
        (Authenticated sender: gregory.clement@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 094D24000B;
        Thu, 11 Jul 2019 14:32:11 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH] vfio: platform: reset: add support for XHCI reset hook
Date:   Thu, 11 Jul 2019 16:31:59 +0200
Message-Id: <20190711143159.21961-1-gregory.clement@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VFIO reset hook is called every time a platform device is passed
to a guest or removed from a guest.

When the XHCI device is unbound from the host, the host driver
disables the XHCI clocks/phys/regulators so when the device is passed
to the guest it becomes dis-functional.

This initial implementation uses the VFIO reset hook to enable the
XHCI clocks/phys on behalf of the guest.

Ported from Marvell LSP code originally written by Yehuda Yitschak

Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
---
 drivers/vfio/platform/reset/Kconfig           |  8 +++
 drivers/vfio/platform/reset/Makefile          |  2 +
 .../vfio/platform/reset/vfio_platform_xhci.c  | 60 +++++++++++++++++++
 3 files changed, 70 insertions(+)
 create mode 100644 drivers/vfio/platform/reset/vfio_platform_xhci.c

diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
index 392e3c09def0..14f620fd250d 100644
--- a/drivers/vfio/platform/reset/Kconfig
+++ b/drivers/vfio/platform/reset/Kconfig
@@ -22,3 +22,11 @@ config VFIO_PLATFORM_BCMFLEXRM_RESET
 	  Enables the VFIO platform driver to handle reset for Broadcom FlexRM
 
 	  If you don't know what to do here, say N.
+
+config VFIO_PLATFORM_XHCI_RESET
+	tristate "VFIO support for USB XHCI reset"
+	depends on VFIO_PLATFORM
+	help
+	  Enables the VFIO platform driver to handle reset for USB XHCI
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/platform/reset/Makefile b/drivers/vfio/platform/reset/Makefile
index 7294c5ea122e..d84c4d3dc041 100644
--- a/drivers/vfio/platform/reset/Makefile
+++ b/drivers/vfio/platform/reset/Makefile
@@ -1,7 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 vfio-platform-calxedaxgmac-y := vfio_platform_calxedaxgmac.o
 vfio-platform-amdxgbe-y := vfio_platform_amdxgbe.o
+vfio-platform-xhci-y := vfio_platform_xhci.o
 
 obj-$(CONFIG_VFIO_PLATFORM_CALXEDAXGMAC_RESET) += vfio-platform-calxedaxgmac.o
 obj-$(CONFIG_VFIO_PLATFORM_AMDXGBE_RESET) += vfio-platform-amdxgbe.o
 obj-$(CONFIG_VFIO_PLATFORM_BCMFLEXRM_RESET) += vfio_platform_bcmflexrm.o
+obj-$(CONFIG_VFIO_PLATFORM_XHCI_RESET) += vfio-platform-xhci.o
diff --git a/drivers/vfio/platform/reset/vfio_platform_xhci.c b/drivers/vfio/platform/reset/vfio_platform_xhci.c
new file mode 100644
index 000000000000..7b75a04402ee
--- /dev/null
+++ b/drivers/vfio/platform/reset/vfio_platform_xhci.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * VFIO platform driver specialized for XHCI reset
+ *
+ * Copyright 2016 Marvell Semiconductors, Inc.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/phy/phy.h>
+#include <linux/usb/phy.h>
+
+#include "../vfio_platform_private.h"
+
+#define MAX_XHCI_CLOCKS		4
+#define MAX_XHCI_PHYS		2
+
+int vfio_platform_xhci_reset(struct vfio_platform_device *vdev)
+{
+	struct device *dev = vdev->device;
+	struct device_node *np = dev->of_node;
+	struct usb_phy *usb_phy;
+	struct clk *clk;
+	int ret, i;
+
+	/*
+	 * Compared to the native driver, no need to handle the
+	 * deferred case, because the resources are already
+	 * there
+	 */
+	for (i = 0; i < MAX_XHCI_CLOCKS; i++) {
+		clk = of_clk_get(np, i);
+		if (!IS_ERR(clk)) {
+			ret = clk_prepare_enable(clk);
+			if (ret)
+				return -ENODEV;
+		}
+	}
+
+	usb_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
+	if (!IS_ERR(usb_phy)) {
+		ret = usb_phy_init(usb_phy);
+		if (ret)
+			return -ENODEV;
+	}
+
+	return 0;
+}
+
+module_vfio_reset_handler("generic-xhci", vfio_platform_xhci_reset);
+
+MODULE_AUTHOR("Yehuda Yitschak");
+MODULE_DESCRIPTION("Reset support for XHCI vfio platform device");
+MODULE_LICENSE("GPL");
-- 
2.20.1

