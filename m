Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D8A27239D
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 14:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgIUMSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 08:18:43 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:19929 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgIUMSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 08:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600690720; x=1632226720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wp9kpM0S1kv/5klFfURtWN1jGFj2nrPGiZshjl/mfSY=;
  b=o+RTa9b7ofkL4TTmdtdkSgQ8Ddb1Zyc5RJ3OSm5CDDpllCKIaJ5kmCGG
   SSHcBrPlcbtdS+HPfgsCC0Re1e91/Ud03TRo7qRjCjFa16asiuVQ5fh7H
   qKkPl0+5CVvwwWj6MBUgQoTANOyVL/8SEK/H952w2DTN75E5bpdVfKYzY
   I=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="55088088"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 21 Sep 2020 12:18:39 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id E028DA1FD6;
        Mon, 21 Sep 2020 12:18:36 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.229) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 12:18:25 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Karen Noel" <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v10 04/18] nitro_enclaves: Init PCI device driver
Date:   Mon, 21 Sep 2020 15:17:18 +0300
Message-ID: <20200921121732.44291-5-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200921121732.44291-1-andraprs@amazon.com>
References: <20200921121732.44291-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D36UWB001.ant.amazon.com (10.43.161.84) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Nitro Enclaves PCI device is used by the kernel driver as a means of
communication with the hypervisor on the host where the primary VM and
the enclaves run. It handles requests with regard to enclave lifetime.

Setup the PCI device driver and add support for MSI-X interrupts.

Changelog

v9 -> v10

* Update commit message to include the changelog before the SoB tag(s).

v8 -> v9

* Init the reference to the ne_pci_dev in the ne_devs data structure.

v7 -> v8

* Add NE PCI driver shutdown logic.

v6 -> v7

* No changes.

v5 -> v6

* Update documentation to kernel-doc format.

v4 -> v5

* Remove sanity checks for situations that shouldn't happen, only if
  buggy system or broken logic at all.

v3 -> v4

* Use dev_err instead of custom NE log pattern.
* Update NE PCI driver name to "nitro_enclaves".

v2 -> v3

* Remove the GPL additional wording as SPDX-License-Identifier is
  already in place.
* Remove the WARN_ON calls.
* Remove linux/bug include that is not needed.
* Update static calls sanity checks.
* Remove "ratelimited" from the logs that are not in the ioctl call
  paths.
* Update kzfree() calls to kfree().

v1 -> v2

* Add log pattern for NE.
* Update PCI device setup functions to receive PCI device data structure and
  then get private data from it inside the functions logic.
* Remove the BUG_ON calls.
* Add teardown function for MSI-X setup.
* Update goto labels to match their purpose.
* Implement TODO for NE PCI device disable state check.
* Update function name for NE PCI device probe / remove.

Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
Signed-off-by: Alexandru Ciobotaru <alcioa@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 304 +++++++++++++++++++++++
 1 file changed, 304 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_pci_dev.c

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
new file mode 100644
index 000000000000..32f07345c3b5
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -0,0 +1,304 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ */
+
+/**
+ * DOC: Nitro Enclaves (NE) PCI device driver.
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/nitro_enclaves.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+
+#include "ne_misc_dev.h"
+#include "ne_pci_dev.h"
+
+/**
+ * NE_DEFAULT_TIMEOUT_MSECS - Default timeout to wait for a reply from
+ *			      the NE PCI device.
+ */
+#define NE_DEFAULT_TIMEOUT_MSECS	(120000) /* 120 sec */
+
+static const struct pci_device_id ne_pci_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, PCI_DEVICE_ID_NE) },
+	{ 0, }
+};
+
+MODULE_DEVICE_TABLE(pci, ne_pci_ids);
+
+/**
+ * ne_setup_msix() - Setup MSI-X vectors for the PCI device.
+ * @pdev:	PCI device to setup the MSI-X for.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_setup_msix(struct pci_dev *pdev)
+{
+	int nr_vecs = 0;
+	int rc = -EINVAL;
+
+	nr_vecs = pci_msix_vec_count(pdev);
+	if (nr_vecs < 0) {
+		rc = nr_vecs;
+
+		dev_err(&pdev->dev, "Error in getting vec count [rc=%d]\n", rc);
+
+		return rc;
+	}
+
+	rc = pci_alloc_irq_vectors(pdev, nr_vecs, nr_vecs, PCI_IRQ_MSIX);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error in alloc MSI-X vecs [rc=%d]\n", rc);
+
+		return rc;
+	}
+
+	return 0;
+}
+
+/**
+ * ne_teardown_msix() - Teardown MSI-X vectors for the PCI device.
+ * @pdev:	PCI device to teardown the MSI-X for.
+ *
+ * Context: Process context.
+ */
+static void ne_teardown_msix(struct pci_dev *pdev)
+{
+	pci_free_irq_vectors(pdev);
+}
+
+/**
+ * ne_pci_dev_enable() - Select the PCI device version and enable it.
+ * @pdev:	PCI device to select version for and then enable.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_pci_dev_enable(struct pci_dev *pdev)
+{
+	u8 dev_enable_reply = 0;
+	u16 dev_version_reply = 0;
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+
+	iowrite16(NE_VERSION_MAX, ne_pci_dev->iomem_base + NE_VERSION);
+
+	dev_version_reply = ioread16(ne_pci_dev->iomem_base + NE_VERSION);
+	if (dev_version_reply != NE_VERSION_MAX) {
+		dev_err(&pdev->dev, "Error in pci dev version cmd\n");
+
+		return -EIO;
+	}
+
+	iowrite8(NE_ENABLE_ON, ne_pci_dev->iomem_base + NE_ENABLE);
+
+	dev_enable_reply = ioread8(ne_pci_dev->iomem_base + NE_ENABLE);
+	if (dev_enable_reply != NE_ENABLE_ON) {
+		dev_err(&pdev->dev, "Error in pci dev enable cmd\n");
+
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/**
+ * ne_pci_dev_disable() - Disable the PCI device.
+ * @pdev:	PCI device to disable.
+ *
+ * Context: Process context.
+ */
+static void ne_pci_dev_disable(struct pci_dev *pdev)
+{
+	u8 dev_disable_reply = 0;
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	const unsigned int sleep_time = 10; /* 10 ms */
+	unsigned int sleep_time_count = 0;
+
+	iowrite8(NE_ENABLE_OFF, ne_pci_dev->iomem_base + NE_ENABLE);
+
+	/*
+	 * Check for NE_ENABLE_OFF in a loop, to handle cases when the device
+	 * state is not immediately set to disabled and going through a
+	 * transitory state of disabling.
+	 */
+	while (sleep_time_count < NE_DEFAULT_TIMEOUT_MSECS) {
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
+		dev_err(&pdev->dev, "Error in pci dev disable cmd\n");
+}
+
+/**
+ * ne_pci_probe() - Probe function for the NE PCI device.
+ * @pdev:	PCI device to match with the NE PCI driver.
+ * @id :	PCI device id table associated with the NE PCI driver.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
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
+		dev_err(&pdev->dev, "Error in pci dev enable [rc=%d]\n", rc);
+
+		goto free_ne_pci_dev;
+	}
+
+	rc = pci_request_regions_exclusive(pdev, "nitro_enclaves");
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error in pci request regions [rc=%d]\n", rc);
+
+		goto disable_pci_dev;
+	}
+
+	ne_pci_dev->iomem_base = pci_iomap(pdev, PCI_BAR_NE, 0);
+	if (!ne_pci_dev->iomem_base) {
+		rc = -ENOMEM;
+
+		dev_err(&pdev->dev, "Error in pci iomap [rc=%d]\n", rc);
+
+		goto release_pci_regions;
+	}
+
+	pci_set_drvdata(pdev, ne_pci_dev);
+
+	rc = ne_setup_msix(pdev);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error in pci dev msix setup [rc=%d]\n", rc);
+
+		goto iounmap_pci_bar;
+	}
+
+	ne_pci_dev_disable(pdev);
+
+	rc = ne_pci_dev_enable(pdev);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error in ne_pci_dev enable [rc=%d]\n", rc);
+
+		goto teardown_msix;
+	}
+
+	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
+	init_waitqueue_head(&ne_pci_dev->cmd_reply_wait_q);
+	INIT_LIST_HEAD(&ne_pci_dev->enclaves_list);
+	mutex_init(&ne_pci_dev->enclaves_list_mutex);
+	mutex_init(&ne_pci_dev->pci_dev_mutex);
+	ne_pci_dev->pdev = pdev;
+
+	ne_devs.ne_pci_dev = ne_pci_dev;
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
+	kfree(ne_pci_dev);
+
+	return rc;
+}
+
+/**
+ * ne_pci_remove() - Remove function for the NE PCI device.
+ * @pdev:	PCI device associated with the NE PCI driver.
+ *
+ * Context: Process context.
+ */
+static void ne_pci_remove(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+
+	ne_devs.ne_pci_dev = NULL;
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
+	kfree(ne_pci_dev);
+}
+
+/**
+ * ne_pci_shutdown() - Shutdown function for the NE PCI device.
+ * @pdev:	PCI device associated with the NE PCI driver.
+ *
+ * Context: Process context.
+ */
+static void ne_pci_shutdown(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+
+	if (!ne_pci_dev)
+		return;
+
+	ne_devs.ne_pci_dev = NULL;
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
+	kfree(ne_pci_dev);
+}
+
+/*
+ * TODO: Add suspend / resume functions for power management w/ CONFIG_PM, if
+ * needed.
+ */
+/* NE PCI device driver. */
+struct pci_driver ne_pci_driver = {
+	.name		= "nitro_enclaves",
+	.id_table	= ne_pci_ids,
+	.probe		= ne_pci_probe,
+	.remove		= ne_pci_remove,
+	.shutdown	= ne_pci_shutdown,
+};
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

