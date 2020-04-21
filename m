Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EB91B2F57
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgDUSmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:42:55 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:62315 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729501AbgDUSmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494573; x=1619030573;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hCVuFtt9M+P1AunrCOwfanKEEX8ct24ptrnRC6w3jCI=;
  b=LFal6lDDDpQAQe4W5FE/CYdts/ePXeYeQIFCQRrqEyP9npZjdAV/Eqhn
   RNkq4Y83Hv2FLjoqPJB6kZVobmkXBz5U9Kg8+E+rPdWmf9TBHdXbfRwQB
   mt5EIsF+RNHkYQZVyY9C4bvb09D5mmvQmiKDiXM3QmSAm+Suc3K9jcLp9
   k=;
IronPort-SDR: 1eC9AHuypUgqQi5opmT0fPhKBsynrA/xsnzQcjJ3chmR2ilYNEKVDxbhhhg6KHfRej3AuCpfui
 3PJktKAyrvAw==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="39978453"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Apr 2020 18:42:53 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id D58C6A1DC5;
        Tue, 21 Apr 2020 18:42:51 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:42:51 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:42:42 +0000
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
Subject: [PATCH v1 05/15] nitro_enclaves: Handle PCI device command requests
Date:   Tue, 21 Apr 2020 21:41:40 +0300
Message-ID: <20200421184150.68011-6-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200421184150.68011-1-andraprs@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D37UWC004.ant.amazon.com (10.43.162.212) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Nitro Enclaves PCI device exposes a MMIO space that this driver
uses to submit command requests and to receive command replies e.g. for
enclave creation / termination or setting enclave resources.

Add logic for handling PCI device command requests based on the given
command type.

Register an MSI-X interrupt vector for command reply notifications to
handle this type of communication events.

Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 .../virt/amazon/nitro_enclaves/ne_pci_dev.c   | 264 ++++++++++++++++++
 1 file changed, 264 insertions(+)

diff --git a/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c b/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
index 8fbee95ea291..7453d129689a 100644
--- a/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
@@ -40,6 +40,251 @@ static const struct pci_device_id ne_pci_ids[] = {
 
 MODULE_DEVICE_TABLE(pci, ne_pci_ids);
 
+/**
+ * ne_submit_request - Submit command request to the PCI device based on the
+ * command type.
+ *
+ * This function gets called with the ne_pci_dev mutex held.
+ *
+ * @pdev: PCI device to send the command to.
+ * @cmd_type: command type of the request sent to the PCI device.
+ * @cmd_request: command request payload.
+ * @cmd_request_size: size of the command request payload.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_submit_request(struct pci_dev *pdev,
+			     enum ne_pci_dev_cmd_type cmd_type,
+			     void *cmd_request, size_t cmd_request_size)
+{
+	struct ne_pci_dev *ne_pci_dev = NULL;
+
+	BUG_ON(!pdev);
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	BUG_ON(!ne_pci_dev);
+	BUG_ON(!ne_pci_dev->iomem_base);
+
+	if (WARN_ON(cmd_type <= INVALID_CMD || cmd_type >= MAX_CMD)) {
+		dev_err_ratelimited(&pdev->dev, "Invalid cmd type=%d\n",
+				    cmd_type);
+
+		return -EINVAL;
+	}
+
+	if (WARN_ON(!cmd_request))
+		return -EINVAL;
+
+	if (WARN_ON(cmd_request_size > NE_SEND_DATA_SIZE)) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Invalid req size=%ld for cmd type=%d\n",
+				    cmd_request_size, cmd_type);
+
+		return -EINVAL;
+	}
+
+	memcpy_toio(ne_pci_dev->iomem_base + NE_SEND_DATA, cmd_request,
+		    cmd_request_size);
+
+	iowrite32(cmd_type, ne_pci_dev->iomem_base + NE_COMMAND);
+
+	return 0;
+}
+
+/**
+ * ne_retrieve_reply - Retrieve reply from the PCI device.
+ *
+ * This function gets called with the ne_pci_dev mutex held.
+ *
+ * @pdev: PCI device to receive the reply from.
+ * @cmd_reply: command reply payload.
+ * @cmd_reply_size: size of the command reply payload.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_retrieve_reply(struct pci_dev *pdev,
+			     struct ne_pci_dev_cmd_reply *cmd_reply,
+			     size_t cmd_reply_size)
+{
+	struct ne_pci_dev *ne_pci_dev = NULL;
+
+	BUG_ON(!pdev);
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	BUG_ON(!ne_pci_dev);
+	BUG_ON(!ne_pci_dev->iomem_base);
+
+	if (WARN_ON(!cmd_reply))
+		return -EINVAL;
+
+	if (WARN_ON(cmd_reply_size > NE_RECV_DATA_SIZE)) {
+		dev_err_ratelimited(&pdev->dev, "Invalid reply size=%ld\n",
+				    cmd_reply_size);
+
+		return -EINVAL;
+	}
+
+	memcpy_fromio(cmd_reply, ne_pci_dev->iomem_base + NE_RECV_DATA,
+		      cmd_reply_size);
+
+	return 0;
+}
+
+/**
+ * ne_wait_for_reply - Wait for a reply of a PCI command.
+ *
+ * This function gets called with the ne_pci_dev mutex held.
+ *
+ * @pdev: PCI device for which a reply is waited.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_wait_for_reply(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = NULL;
+	int rc = -EINVAL;
+
+	BUG_ON(!pdev);
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	BUG_ON(!ne_pci_dev);
+
+	/*
+	 * TODO: Update to _interruptible and handle interrupted wait event
+	 * e.g. -ERESTARTSYS, incoming signals + add / update timeout.
+	 */
+	rc = wait_event_timeout(ne_pci_dev->cmd_reply_wait_q,
+				atomic_read(&ne_pci_dev->cmd_reply_avail) != 0,
+				msecs_to_jiffies(DEFAULT_TIMEOUT_MSECS));
+	if (!rc) {
+		pr_err("Wait event timed out when waiting for PCI cmd reply\n");
+
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+int ne_do_request(struct pci_dev *pdev, enum ne_pci_dev_cmd_type cmd_type,
+		  void *cmd_request, size_t cmd_request_size,
+		  struct ne_pci_dev_cmd_reply *cmd_reply, size_t cmd_reply_size)
+{
+	struct ne_pci_dev *ne_pci_dev = NULL;
+	int rc = -EINVAL;
+
+	BUG_ON(!pdev);
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	BUG_ON(!ne_pci_dev);
+	BUG_ON(!ne_pci_dev->iomem_base);
+
+	if (WARN_ON(cmd_type <= INVALID_CMD || cmd_type >= MAX_CMD)) {
+		dev_err_ratelimited(&pdev->dev, "Invalid cmd type=%d\n",
+				    cmd_type);
+
+		return -EINVAL;
+	}
+
+	if (WARN_ON(!cmd_request))
+		return -EINVAL;
+
+	if (WARN_ON(cmd_request_size > NE_SEND_DATA_SIZE)) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Invalid req size=%ld for cmd type=%d\n",
+				    cmd_request_size, cmd_type);
+
+		return -EINVAL;
+	}
+
+	if (WARN_ON(!cmd_reply))
+		return -EINVAL;
+
+	if (WARN_ON(cmd_reply_size > NE_RECV_DATA_SIZE)) {
+		dev_err_ratelimited(&pdev->dev, "Invalid reply size=%ld\n",
+				    cmd_reply_size);
+
+		return -EINVAL;
+	}
+
+	/*
+	 * Use this mutex so that the PCI device handles one command request at
+	 * a time.
+	 */
+	mutex_lock(&ne_pci_dev->pci_dev_mutex);
+
+	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
+
+	rc = ne_submit_request(pdev, cmd_type, cmd_request, cmd_request_size);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in submit cmd request [rc=%d]\n",
+				    rc);
+
+		mutex_unlock(&ne_pci_dev->pci_dev_mutex);
+
+		return rc;
+	}
+
+	rc = ne_wait_for_reply(pdev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in wait cmd reply [rc=%d]\n",
+				    rc);
+
+		mutex_unlock(&ne_pci_dev->pci_dev_mutex);
+
+		return rc;
+	}
+
+	rc = ne_retrieve_reply(pdev, cmd_reply, cmd_reply_size);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in retrieve cmd reply [rc=%d]\n",
+				    rc);
+
+		mutex_unlock(&ne_pci_dev->pci_dev_mutex);
+
+		return rc;
+	}
+
+	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
+
+	if (cmd_reply->rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in cmd process logic [rc=%d]\n",
+				    cmd_reply->rc);
+
+		mutex_unlock(&ne_pci_dev->pci_dev_mutex);
+
+		return cmd_reply->rc;
+	}
+
+	mutex_unlock(&ne_pci_dev->pci_dev_mutex);
+
+	return 0;
+}
+
+/**
+ * ne_reply_handler - Interrupt handler for retrieving a reply matching
+ * a request sent to the PCI device for enclave lifetime management.
+ *
+ * @irq: received interrupt for a reply sent by the PCI device.
+ * @args: PCI device private data structure.
+ *
+ * @returns: IRQ_HANDLED on handled interrupt, IRQ_NONE otherwise.
+ */
+static irqreturn_t ne_reply_handler(int irq, void *args)
+{
+	struct ne_pci_dev *ne_pci_dev = (struct ne_pci_dev *)args;
+
+	atomic_set(&ne_pci_dev->cmd_reply_avail, 1);
+
+	/* TODO: Update to _interruptible. */
+	wake_up(&ne_pci_dev->cmd_reply_wait_q);
+
+	return IRQ_HANDLED;
+}
+
 /**
  * ne_setup_msix - Setup MSI-X vectors for the PCI device.
  *
@@ -75,8 +320,25 @@ static int ne_setup_msix(struct pci_dev *pdev, struct ne_pci_dev *ne_pci_dev)
 		goto err_alloc_irq_vecs;
 	}
 
+	/*
+	 * This IRQ gets triggered every time the PCI device responds to a
+	 * command request. The reply is then retrieved, reading from the MMIO
+	 * space of the PCI device.
+	 */
+	rc = request_irq(pci_irq_vector(pdev, NE_VEC_REPLY),
+			 ne_reply_handler, 0, "enclave_cmd", ne_pci_dev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in allocating irq reply [rc=%d]\n",
+				    rc);
+
+		goto err_req_irq_reply;
+	}
+
 	return 0;
 
+err_req_irq_reply:
+	pci_free_irq_vectors(pdev);
 err_alloc_irq_vecs:
 	return rc;
 }
@@ -232,6 +494,7 @@ static int ne_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_ne_pci_dev_enable:
 err_ne_pci_dev_disable:
+	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
 	pci_free_irq_vectors(pdev);
 err_setup_msix:
 	pci_iounmap(pdev, ne_pci_dev->iomem_base);
@@ -255,6 +518,7 @@ static void ne_remove(struct pci_dev *pdev)
 
 	pci_set_drvdata(pdev, NULL);
 
+	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
 	pci_free_irq_vectors(pdev);
 
 	pci_iounmap(pdev, ne_pci_dev->iomem_base);
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

