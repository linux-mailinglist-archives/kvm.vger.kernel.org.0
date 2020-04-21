Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BCF1B2F54
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgDUSmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:42:42 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:53454 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbgDUSmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:42:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494559; x=1619030559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aMA7GuRQk9xRyNRDUSC1CF1PbdsE/6li9LlY6g7pMyo=;
  b=kLd2F00OkmG3kfJyj6m1+3dYrRJ1i7dbhver5u3+1hlPrBajKHq0+kfG
   pfyX4wN+yUdk1zksPU0+9c0/PioB8lKuetMwxVv4bMc3zirPEz3ufBrEl
   uveJuFYLTQ1vCe2xCMTvuCPqLk5X1m7kmLRbW62IOpbvE2qU1yoQOTAI1
   Q=;
IronPort-SDR: QqqpYh2L/trLOag45i9lRLGDT6tMUArdG6WL8Lsrs/LDr5xJ0RWar4I6doUWfh3xjW+GiSwVd2
 phx0d9bE3bHw==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="38565694"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 21 Apr 2020 18:42:39 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id 0E67CA070F;
        Tue, 21 Apr 2020 18:42:37 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:42:37 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:42:28 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v1 04/15] nitro_enclaves: Init PCI device driver
Date:   Tue, 21 Apr 2020 21:41:39 +0300
Message-ID: <20200421184150.68011-5-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200421184150.68011-1-andraprs@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D25UWC004.ant.amazon.com (10.43.162.201) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Nitro Enclaves PCI device is used by the kernel driver as a means of
communication with the hypervisor on the host where the primary VM and
the enclaves run. It handles requests with regard to enclave lifetime.

Setup the PCI device driver and add support for MSI-X interrupts.

Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
Signed-off-by: Alexandru Ciobotaru <alcioa@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 .../virt/amazon/nitro_enclaves/ne_pci_dev.c   | 278 ++++++++++++++++++
 1 file changed, 278 insertions(+)
 create mode 100644 drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c

diff --git a/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c b/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
new file mode 100644
index 000000000000..8fbee95ea291
--- /dev/null
+++ b/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
@@ -0,0 +1,278 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+/* Nitro Enclaves (NE) PCI device driver. */
+
+#include <linux/bug.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/nitro_enclaves.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+
+#include "ne_misc_dev.h"
+#include "ne_pci_dev.h"
+
+#define DEFAULT_TIMEOUT_MSECS (120000) // 120 sec
+
+static const struct pci_device_id ne_pci_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, PCI_DEVICE_ID_NE) },
+	{ 0, }
+};
+
+MODULE_DEVICE_TABLE(pci, ne_pci_ids);
+
+/**
+ * ne_setup_msix - Setup MSI-X vectors for the PCI device.
+ *
+ * @pdev: PCI device to setup the MSI-X for.
+ * @ne_pci_dev: PCI device private data structure.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_setup_msix(struct pci_dev *pdev, struct ne_pci_dev *ne_pci_dev)
+{
+	int nr_vecs = 0;
+	int rc = -EINVAL;
+
+	BUG_ON(!ne_pci_dev);
+
+	nr_vecs = pci_msix_vec_count(pdev);
+	if (nr_vecs < 0) {
+		rc = nr_vecs;
+
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in getting vec count [rc=%d]\n",
+				    rc);
+
+		return rc;
+	}
+
+	rc = pci_alloc_irq_vectors(pdev, nr_vecs, nr_vecs, PCI_IRQ_MSIX);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in alloc MSI-X vecs [rc=%d]\n",
+				    rc);
+
+		goto err_alloc_irq_vecs;
+	}
+
+	return 0;
+
+err_alloc_irq_vecs:
+	return rc;
+}
+
+/**
+ * ne_pci_dev_enable - Select PCI device version and enable it.
+ *
+ * @pdev: PCI device to select version for and then enable.
+ * @ne_pci_dev: PCI device private data structure.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_pci_dev_enable(struct pci_dev *pdev,
+			     struct ne_pci_dev *ne_pci_dev)
+{
+	u8 dev_enable_reply = 0;
+	u16 dev_version_reply = 0;
+
+	BUG_ON(!pdev);
+	BUG_ON(!ne_pci_dev);
+	BUG_ON(!ne_pci_dev->iomem_base);
+
+	iowrite16(NE_VERSION_MAX, ne_pci_dev->iomem_base + NE_VERSION);
+
+	dev_version_reply = ioread16(ne_pci_dev->iomem_base + NE_VERSION);
+	if (dev_version_reply != NE_VERSION_MAX) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in pci dev version cmd\n");
+
+		return -EIO;
+	}
+
+	iowrite8(NE_ENABLE_ON, ne_pci_dev->iomem_base + NE_ENABLE);
+
+	dev_enable_reply = ioread8(ne_pci_dev->iomem_base + NE_ENABLE);
+	if (dev_enable_reply != NE_ENABLE_ON) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in pci dev enable cmd\n");
+
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/**
+ * ne_pci_dev_disable - Disable PCI device.
+ *
+ * @pdev: PCI device to disable.
+ * @ne_pci_dev: PCI device private data structure.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_pci_dev_disable(struct pci_dev *pdev,
+			      struct ne_pci_dev *ne_pci_dev)
+{
+	u8 dev_disable_reply = 0;
+
+	BUG_ON(!pdev);
+	BUG_ON(!ne_pci_dev);
+	BUG_ON(!ne_pci_dev->iomem_base);
+
+	iowrite8(NE_ENABLE_OFF, ne_pci_dev->iomem_base + NE_ENABLE);
+
+	/*
+	 * TODO: Check for NE_ENABLE_OFF in a loop, to handle cases when the
+	 * device state is not immediately set to disabled and going through a
+	 * transitory state of disabling.
+	 */
+	dev_disable_reply = ioread8(ne_pci_dev->iomem_base + NE_ENABLE);
+	if (dev_disable_reply != NE_ENABLE_OFF) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in pci dev disable cmd\n");
+
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int ne_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct ne_pci_dev *ne_pci_dev = NULL;
+	int rc = -EINVAL;
+
+	ne_pci_dev = kzalloc(sizeof(*ne_pci_dev), GFP_KERNEL);
+	if (!ne_pci_dev)
+		return -ENOMEM;
+
+	rc = pci_enable_device(pdev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in pci dev enable [rc=%d]\n", rc);
+
+		goto err_pci_enable_dev;
+	}
+
+	rc = pci_request_regions_exclusive(pdev, "ne_pci_dev");
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in pci request regions [rc=%d]\n",
+				    rc);
+
+		goto err_req_regions;
+	}
+
+	ne_pci_dev->iomem_base = pci_iomap(pdev, PCI_BAR_NE, 0);
+	if (!ne_pci_dev->iomem_base) {
+		rc = -ENOMEM;
+
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in pci bar mapping [rc=%d]\n", rc);
+
+		goto err_iomap;
+	}
+
+	rc = ne_setup_msix(pdev, ne_pci_dev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in pci dev msix setup [rc=%d]\n",
+				    rc);
+
+		goto err_setup_msix;
+	}
+
+	rc = ne_pci_dev_disable(pdev, ne_pci_dev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in ne_pci_dev disable [rc=%d]\n",
+				    rc);
+
+		goto err_ne_pci_dev_disable;
+	}
+
+	rc = ne_pci_dev_enable(pdev, ne_pci_dev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in ne_pci_dev enable [rc=%d]\n",
+				    rc);
+
+		goto err_ne_pci_dev_enable;
+	}
+
+	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
+	init_waitqueue_head(&ne_pci_dev->cmd_reply_wait_q);
+	INIT_LIST_HEAD(&ne_pci_dev->enclaves_list);
+	mutex_init(&ne_pci_dev->enclaves_list_mutex);
+	mutex_init(&ne_pci_dev->pci_dev_mutex);
+
+	pci_set_drvdata(pdev, ne_pci_dev);
+
+	return 0;
+
+err_ne_pci_dev_enable:
+err_ne_pci_dev_disable:
+	pci_free_irq_vectors(pdev);
+err_setup_msix:
+	pci_iounmap(pdev, ne_pci_dev->iomem_base);
+err_iomap:
+	pci_release_regions(pdev);
+err_req_regions:
+	pci_disable_device(pdev);
+err_pci_enable_dev:
+	kzfree(ne_pci_dev);
+	return rc;
+}
+
+static void ne_remove(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+
+	if (!ne_pci_dev || !ne_pci_dev->iomem_base)
+		return;
+
+	ne_pci_dev_disable(pdev, ne_pci_dev);
+
+	pci_set_drvdata(pdev, NULL);
+
+	pci_free_irq_vectors(pdev);
+
+	pci_iounmap(pdev, ne_pci_dev->iomem_base);
+
+	kzfree(ne_pci_dev);
+
+	pci_release_regions(pdev);
+
+	pci_disable_device(pdev);
+}
+
+/*
+ * TODO: Add suspend / resume functions for power management w/ CONFIG_PM, if
+ * needed.
+ */
+struct pci_driver ne_pci_driver = {
+	.name		= "ne_pci_dev",
+	.id_table	= ne_pci_ids,
+	.probe		= ne_probe,
+	.remove		= ne_remove,
+};
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

