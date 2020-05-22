Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD22E1DDFD3
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 08:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgEVGas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 02:30:48 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:41297 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbgEVGaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 02:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590129046; x=1621665046;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=39me77MSOHxwXqDrOp0ImYHZUNXF9EMGemsZ9hzrmME=;
  b=WkfGRHr5j8lMQ3FmVaeF/cjdbXB1mSXcg4E1okkofzz0aisafnc6ucRp
   di195R7JjtPB6zup139y1qUAbwuCL1PsdJIaf7WGBTShSqK0Umhmf5rTf
   58hrSlnpGmEjUdIMEp706OrLQjhJpU+ldEetljxc7WN2v2ORdGb8v0VhH
   g=;
IronPort-SDR: QRsjsSaA6999NG6AZNcPK6ysbfZPIrKFf5dfRdQ+8HBiSSBWVOHQnKfx30qqxVgQwWquNli0po
 UohXakuxJtig==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="45244095"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 May 2020 06:30:43 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 7595EA1FE1;
        Fri, 22 May 2020 06:30:41 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:30:36 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:30:26 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v2 04/18] nitro_enclaves: Init PCI device driver
Date:   Fri, 22 May 2020 09:29:32 +0300
Message-ID: <20200522062946.28973-5-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200522062946.28973-1-andraprs@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D20UWC004.ant.amazon.com (10.43.162.41) To
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
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 303 +++++++++++++++++++++++
 1 file changed, 303 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_pci_dev.c

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
new file mode 100644
index 000000000000..8e39e30c882f
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -0,0 +1,303 @@
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
+#define NE "nitro_enclaves: "
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
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_setup_msix(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = NULL;
+	int nr_vecs = 0;
+	int rc = -EINVAL;
+
+	if (WARN_ON(!pdev))
+		return -EINVAL;
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	if (WARN_ON(!ne_pci_dev))
+		return -EINVAL;
+
+	nr_vecs = pci_msix_vec_count(pdev);
+	if (nr_vecs < 0) {
+		rc = nr_vecs;
+
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in getting vec count [rc=%d]\n",
+				    rc);
+
+		return rc;
+	}
+
+	rc = pci_alloc_irq_vectors(pdev, nr_vecs, nr_vecs, PCI_IRQ_MSIX);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in alloc MSI-X vecs [rc=%d]\n",
+				    rc);
+
+		return rc;
+	}
+
+	return 0;
+}
+
+/**
+ * ne_teardown_msix - Teardown MSI-X vectors for the PCI device.
+ *
+ * @pdev: PCI device to teardown the MSI-X for.
+ */
+static void ne_teardown_msix(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = NULL;
+
+	if (WARN_ON(!pdev))
+		return;
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	if (WARN_ON(!ne_pci_dev))
+		return;
+
+	pci_free_irq_vectors(pdev);
+}
+
+/**
+ * ne_pci_dev_enable - Select PCI device version and enable it.
+ *
+ * @pdev: PCI device to select version for and then enable.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_pci_dev_enable(struct pci_dev *pdev)
+{
+	u8 dev_enable_reply = 0;
+	u16 dev_version_reply = 0;
+	struct ne_pci_dev *ne_pci_dev = NULL;
+
+	if (WARN_ON(!pdev))
+		return -EINVAL;
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	if (WARN_ON(!ne_pci_dev) || WARN_ON(!ne_pci_dev->iomem_base))
+		return -EINVAL;
+
+	iowrite16(NE_VERSION_MAX, ne_pci_dev->iomem_base + NE_VERSION);
+
+	dev_version_reply = ioread16(ne_pci_dev->iomem_base + NE_VERSION);
+	if (dev_version_reply != NE_VERSION_MAX) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in pci dev version cmd\n");
+
+		return -EIO;
+	}
+
+	iowrite8(NE_ENABLE_ON, ne_pci_dev->iomem_base + NE_ENABLE);
+
+	dev_enable_reply = ioread8(ne_pci_dev->iomem_base + NE_ENABLE);
+	if (dev_enable_reply != NE_ENABLE_ON) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in pci dev enable cmd\n");
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
+ */
+static void ne_pci_dev_disable(struct pci_dev *pdev)
+{
+	u8 dev_disable_reply = 0;
+	struct ne_pci_dev *ne_pci_dev = NULL;
+	const unsigned int sleep_time = 10; // 10 ms
+	unsigned int sleep_time_count = 0;
+
+	if (WARN_ON(!pdev))
+		return;
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	if (WARN_ON(!ne_pci_dev) || WARN_ON(!ne_pci_dev->iomem_base))
+		return;
+
+	iowrite8(NE_ENABLE_OFF, ne_pci_dev->iomem_base + NE_ENABLE);
+
+	/*
+	 * Check for NE_ENABLE_OFF in a loop, to handle cases when the device
+	 * state is not immediately set to disabled and going through a
+	 * transitory state of disabling.
+	 */
+	while (sleep_time_count < DEFAULT_TIMEOUT_MSECS) {
+		dev_disable_reply = ioread8(ne_pci_dev->iomem_base + NE_ENABLE);
+		if (dev_disable_reply == NE_ENABLE_OFF)
+			return;
+
+		msleep_interruptible(sleep_time);
+		sleep_time_count += sleep_time;
+	}
+
+	dev_disable_reply = ioread8(ne_pci_dev->iomem_base + NE_ENABLE);
+	if (dev_disable_reply != NE_ENABLE_OFF)
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in pci dev disable cmd\n");
+}
+
+static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
+				    NE "Error in pci dev enable [rc=%d]\n", rc);
+
+		goto free_ne_pci_dev;
+	}
+
+	rc = pci_request_regions_exclusive(pdev, "ne_pci_dev");
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in pci request regions [rc=%d]\n",
+				    rc);
+
+		goto disable_pci_dev;
+	}
+
+	ne_pci_dev->iomem_base = pci_iomap(pdev, PCI_BAR_NE, 0);
+	if (!ne_pci_dev->iomem_base) {
+		rc = -ENOMEM;
+
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in pci iomap [rc=%d]\n", rc);
+
+		goto release_pci_regions;
+	}
+
+	pci_set_drvdata(pdev, ne_pci_dev);
+
+	rc = ne_setup_msix(pdev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in pci dev msix setup [rc=%d]\n",
+				    rc);
+
+		goto iounmap_pci_bar;
+	}
+
+	ne_pci_dev_disable(pdev);
+
+	rc = ne_pci_dev_enable(pdev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in ne_pci_dev enable [rc=%d]\n",
+				    rc);
+
+		goto teardown_msix;
+	}
+
+	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
+	init_waitqueue_head(&ne_pci_dev->cmd_reply_wait_q);
+	INIT_LIST_HEAD(&ne_pci_dev->enclaves_list);
+	mutex_init(&ne_pci_dev->enclaves_list_mutex);
+	mutex_init(&ne_pci_dev->pci_dev_mutex);
+
+	return 0;
+
+teardown_msix:
+	ne_teardown_msix(pdev);
+iounmap_pci_bar:
+	pci_set_drvdata(pdev, NULL);
+	pci_iounmap(pdev, ne_pci_dev->iomem_base);
+release_pci_regions:
+	pci_release_regions(pdev);
+disable_pci_dev:
+	pci_disable_device(pdev);
+free_ne_pci_dev:
+	kzfree(ne_pci_dev);
+
+	return rc;
+}
+
+static void ne_pci_remove(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+
+	if (!ne_pci_dev || !ne_pci_dev->iomem_base)
+		return;
+
+	ne_pci_dev_disable(pdev);
+
+	ne_teardown_msix(pdev);
+
+	pci_set_drvdata(pdev, NULL);
+
+	pci_iounmap(pdev, ne_pci_dev->iomem_base);
+
+	pci_release_regions(pdev);
+
+	pci_disable_device(pdev);
+
+	kzfree(ne_pci_dev);
+}
+
+/*
+ * TODO: Add suspend / resume functions for power management w/ CONFIG_PM, if
+ * needed.
+ */
+struct pci_driver ne_pci_driver = {
+	.name		= "ne_pci_dev",
+	.id_table	= ne_pci_ids,
+	.probe		= ne_pci_probe,
+	.remove		= ne_pci_remove,
+};
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

