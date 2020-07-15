Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A84D22155E
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 21:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgGOTq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 15:46:57 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:25127 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbgGOTq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 15:46:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594842416; x=1626378416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jBFz3JyD+ktSHGjIufQ6SCKpoNFYh1Mny1rhW34gR2k=;
  b=QUIDlGGm4NzyOgbFMwrdId9tk3WTln/F9GsPbGcZD3U4roAezW7x66sc
   wvPUKBPq+4zefFkaQp30OmRe6JVORa0dhK4p2q7uR1lPdjUtvT68qsw7r
   mAJtrx9xqggxKtnCt87JxX5ScBi9yl9RqciooKKeogS2L+OjGtD3MA1cK
   c=;
IronPort-SDR: Dqe7VBTO+p4kEv4xuChF8KoAd8rNyBTbGSD2mECUsIot6x0D7vcJTL3tLPsCqY2AK52NT2gCAB
 9V4N5TVXXorw==
X-IronPort-AV: E=Sophos;i="5.75,356,1589241600"; 
   d="scan'208";a="42071558"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 15 Jul 2020 19:46:54 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id 25267A262D;
        Wed, 15 Jul 2020 19:46:52 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:46:51 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.214) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:46:41 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
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
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH v5 05/18] nitro_enclaves: Handle PCI device command requests
Date:   Wed, 15 Jul 2020 22:45:27 +0300
Message-ID: <20200715194540.45532-6-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200715194540.45532-1-andraprs@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.214]
X-ClientProxiedBy: EX13D46UWB001.ant.amazon.com (10.43.161.16) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
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
Changelog

v4 -> v5

* Remove sanity checks for situations that shouldn't happen, only if
  buggy system or broken logic at all.

v3 -> v4

* Use dev_err instead of custom NE log pattern.
* Return IRQ_NONE when interrupts are not handled.

v2 -> v3

* Remove the WARN_ON calls.
* Update static calls sanity checks.
* Remove "ratelimited" from the logs that are not in the ioctl call
  paths.

v1 -> v2

* Add log pattern for NE.
* Remove the BUG_ON calls.
* Update goto labels to match their purpose.
* Add fix for kbuild report.
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 202 +++++++++++++++++++++++
 1 file changed, 202 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index dd23caecd57d..738b8f4d8faf 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -27,6 +27,185 @@ static const struct pci_device_id ne_pci_ids[] = {
 
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
+static int ne_submit_request(struct pci_dev *pdev, enum ne_pci_dev_cmd_type cmd_type,
+			     void *cmd_request, size_t cmd_request_size)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+
+	memcpy_toio(ne_pci_dev->iomem_base + NE_SEND_DATA, cmd_request, cmd_request_size);
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
+static int ne_retrieve_reply(struct pci_dev *pdev, struct ne_pci_dev_cmd_reply *cmd_reply,
+			     size_t cmd_reply_size)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+
+	memcpy_fromio(cmd_reply, ne_pci_dev->iomem_base + NE_RECV_DATA, cmd_reply_size);
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
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	int rc = -EINVAL;
+
+	/*
+	 * TODO: Update to _interruptible and handle interrupted wait event
+	 * e.g. -ERESTARTSYS, incoming signals + add / update timeout.
+	 */
+	rc = wait_event_timeout(ne_pci_dev->cmd_reply_wait_q,
+				atomic_read(&ne_pci_dev->cmd_reply_avail) != 0,
+				msecs_to_jiffies(NE_DEFAULT_TIMEOUT_MSECS));
+	if (!rc)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+int ne_do_request(struct pci_dev *pdev, enum ne_pci_dev_cmd_type cmd_type,
+		  void *cmd_request, size_t cmd_request_size,
+		  struct ne_pci_dev_cmd_reply *cmd_reply, size_t cmd_reply_size)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	int rc = -EINVAL;
+
+	if (cmd_type <= INVALID_CMD || cmd_type >= MAX_CMD) {
+		dev_err_ratelimited(&pdev->dev, "Invalid cmd type=%u\n", cmd_type);
+
+		return -EINVAL;
+	}
+
+	if (!cmd_request) {
+		dev_err_ratelimited(&pdev->dev, "Null cmd request\n");
+
+		return -EINVAL;
+	}
+
+	if (cmd_request_size > NE_SEND_DATA_SIZE) {
+		dev_err_ratelimited(&pdev->dev, "Invalid req size=%zu for cmd type=%u\n",
+				    cmd_request_size, cmd_type);
+
+		return -EINVAL;
+	}
+
+	if (!cmd_reply) {
+		dev_err_ratelimited(&pdev->dev, "Null cmd reply\n");
+
+		return -EINVAL;
+	}
+
+	if (cmd_reply_size > NE_RECV_DATA_SIZE) {
+		dev_err_ratelimited(&pdev->dev, "Invalid reply size=%zu\n", cmd_reply_size);
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
+		dev_err_ratelimited(&pdev->dev, "Error in submit request [rc=%d]\n", rc);
+
+		goto unlock_mutex;
+	}
+
+	rc = ne_wait_for_reply(pdev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev, "Error in wait for reply [rc=%d]\n", rc);
+
+		goto unlock_mutex;
+	}
+
+	rc = ne_retrieve_reply(pdev, cmd_reply, cmd_reply_size);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev, "Error in retrieve reply [rc=%d]\n", rc);
+
+		goto unlock_mutex;
+	}
+
+	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
+
+	if (cmd_reply->rc < 0) {
+		rc = cmd_reply->rc;
+
+		dev_err_ratelimited(&pdev->dev, "Error in cmd process logic [rc=%d]\n", rc);
+
+		goto unlock_mutex;
+	}
+
+	rc = 0;
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
@@ -36,6 +215,7 @@ MODULE_DEVICE_TABLE(pci, ne_pci_ids);
  */
 static int ne_setup_msix(struct pci_dev *pdev)
 {
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
 	int nr_vecs = 0;
 	int rc = -EINVAL;
 
@@ -55,7 +235,25 @@ static int ne_setup_msix(struct pci_dev *pdev)
 		return rc;
 	}
 
+	/*
+	 * This IRQ gets triggered every time the PCI device responds to a
+	 * command request. The reply is then retrieved, reading from the MMIO
+	 * space of the PCI device.
+	 */
+	rc = request_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_reply_handler,
+			 0, "enclave_cmd", ne_pci_dev);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error in request irq reply [rc=%d]\n", rc);
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
@@ -65,6 +263,10 @@ static int ne_setup_msix(struct pci_dev *pdev)
  */
 static void ne_teardown_msix(struct pci_dev *pdev)
 {
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+
+	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
+
 	pci_free_irq_vectors(pdev);
 }
 
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

