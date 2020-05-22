Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157E71DDFD9
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 08:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgEVGbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 02:31:01 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:8199 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728267AbgEVGa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 02:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590129056; x=1621665056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oyw7kch753GXE+C8RzyOWUNgZGNNk4NQ14vTj0zqGXs=;
  b=BaNu6Kl03CaDe3MCGMEUPsWgn9OLj6pyQlenRcGAsg7AuO3E3DZTZwNW
   ptzb9M16L7m/mEGMCEj4HOH8lyfgS4KylHb5sjxOd/EvQUbwsnFsu2Jvd
   5bqLxnLfimdDKWY1Je9/tUFQXO4Yb3WdHBHDSCTwySe8m3I+gAOACkyrf
   U=;
IronPort-SDR: gGxSPSc/gSTq3iFvf7oJoC6msT+BrUDA8nMkqOmWTnv9gAR2sW6HVGsYFaz5Bus/7mF9x8SJln
 vFQv6WxQIcdw==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="46674930"
Received: from sea32-co-svc-lb4-vlan2.sea.corp.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.47.23.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 22 May 2020 06:30:53 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id B7D31A22D3;
        Fri, 22 May 2020 06:30:51 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:30:50 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.50) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:30:40 +0000
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
        Andra Paraschiv <andraprs@amazon.com>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH v2 05/18] nitro_enclaves: Handle PCI device command requests
Date:   Fri, 22 May 2020 09:29:33 +0300
Message-ID: <20200522062946.28973-6-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200522062946.28973-1-andraprs@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D06UWC004.ant.amazon.com (10.43.162.97) To
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

Fix issue reported in:
https://lore.kernel.org/lkml/202004231644.xTmN4Z1z%25lkp@intel.com/

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 284 +++++++++++++++++++++++
 1 file changed, 284 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 8e39e30c882f..7b2d8e1b49a5 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -42,6 +42,268 @@ static const struct pci_device_id ne_pci_ids[] = {
 
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
+	if (WARN_ON(!pdev))
+		return -EINVAL;
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	if (WARN_ON(!ne_pci_dev) || WARN_ON(!ne_pci_dev->iomem_base))
+		return -EINVAL;
+
+	if (cmd_type <= INVALID_CMD || cmd_type >= MAX_CMD) {
+		dev_err_ratelimited(&pdev->dev, NE "Invalid cmd type=%u\n",
+				    cmd_type);
+
+		return -EINVAL;
+	}
+
+	if (!cmd_request) {
+		dev_err_ratelimited(&pdev->dev, NE "Null cmd request\n");
+
+		return -EINVAL;
+	}
+
+	if (cmd_request_size > NE_SEND_DATA_SIZE) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Invalid req size=%zu for cmd type=%u\n",
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
+	if (WARN_ON(!pdev))
+		return -EINVAL;
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	if (WARN_ON(!ne_pci_dev) || WARN_ON(!ne_pci_dev->iomem_base))
+		return -EINVAL;
+
+	if (!cmd_reply) {
+		dev_err_ratelimited(&pdev->dev, NE "Null cmd reply\n");
+
+		return -EINVAL;
+	}
+
+	if (cmd_reply_size > NE_RECV_DATA_SIZE) {
+		dev_err_ratelimited(&pdev->dev, NE "Invalid reply size=%zu\n",
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
+	if (WARN_ON(!pdev))
+		return -EINVAL;
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	if (WARN_ON(!ne_pci_dev))
+		return -EINVAL;
+
+	/*
+	 * TODO: Update to _interruptible and handle interrupted wait event
+	 * e.g. -ERESTARTSYS, incoming signals + add / update timeout.
+	 */
+	rc = wait_event_timeout(ne_pci_dev->cmd_reply_wait_q,
+				atomic_read(&ne_pci_dev->cmd_reply_avail) != 0,
+				msecs_to_jiffies(DEFAULT_TIMEOUT_MSECS));
+	if (!rc) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Timeout in wait for reply\n");
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
+	if (WARN_ON(!pdev))
+		return -EINVAL;
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	if (WARN_ON(!ne_pci_dev) || WARN_ON(!ne_pci_dev->iomem_base))
+		return -EINVAL;
+
+	if (cmd_type <= INVALID_CMD || cmd_type >= MAX_CMD) {
+		dev_err_ratelimited(&pdev->dev, NE "Invalid cmd type=%u\n",
+				    cmd_type);
+
+		return -EINVAL;
+	}
+
+	if (!cmd_request) {
+		dev_err_ratelimited(&pdev->dev, NE "Null cmd request\n");
+
+		return -EINVAL;
+	}
+
+	if (cmd_request_size > NE_SEND_DATA_SIZE) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Invalid req size=%zu for cmd type=%u\n",
+				    cmd_request_size, cmd_type);
+
+		return -EINVAL;
+	}
+
+	if (!cmd_reply) {
+		dev_err_ratelimited(&pdev->dev, NE "Null cmd reply\n");
+
+		return -EINVAL;
+	}
+
+	if (cmd_reply_size > NE_RECV_DATA_SIZE) {
+		dev_err_ratelimited(&pdev->dev, NE "Invalid reply size=%zu\n",
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
+				    NE "Error in submit request [rc=%d]\n",
+				    rc);
+
+		goto unlock_mutex;
+	}
+
+	rc = ne_wait_for_reply(pdev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in wait for reply [rc=%d]\n",
+				    rc);
+
+		goto unlock_mutex;
+	}
+
+	rc = ne_retrieve_reply(pdev, cmd_reply, cmd_reply_size);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in retrieve reply [rc=%d]\n",
+				    rc);
+
+		goto unlock_mutex;
+	}
+
+	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
+
+	if (cmd_reply->rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in cmd process logic [rc=%d]\n",
+				    cmd_reply->rc);
+
+		rc = cmd_reply->rc;
+
+		goto unlock_mutex;
+	}
+
+	mutex_unlock(&ne_pci_dev->pci_dev_mutex);
+
+	return 0;
+
+unlock_mutex:
+	mutex_unlock(&ne_pci_dev->pci_dev_mutex);
+
+	return rc;
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
@@ -82,7 +344,27 @@ static int ne_setup_msix(struct pci_dev *pdev)
 		return rc;
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
+				    NE "Error in request irq reply [rc=%d]\n",
+				    rc);
+
+		goto free_irq_vectors;
+	}
+
 	return 0;
+
+free_irq_vectors:
+	pci_free_irq_vectors(pdev);
+
+	return rc;
 }
 
 /**
@@ -101,6 +383,8 @@ static void ne_teardown_msix(struct pci_dev *pdev)
 	if (WARN_ON(!ne_pci_dev))
 		return;
 
+	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
+
 	pci_free_irq_vectors(pdev);
 }
 
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

