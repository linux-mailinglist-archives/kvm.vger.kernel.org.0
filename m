Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C281425E101
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 19:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgIDRin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 13:38:43 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:50006 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbgIDRid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 13:38:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599241111; x=1630777111;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L4/dDnWumHZ2zxQUErq4vmdHts70qp38paag+MgVKac=;
  b=GF80BcJOswdcnPm3fbYDeT4eIGT+cT4lSV/oqdyhN+YXXhrPuZ9D0Zuf
   8T2hwyhwDOnKsuulrcCBQnvDiOw4Jah8zaHhD6Ow0qd87NaEKVlv8c7GM
   8CbJXAlhOb/WsEOMD8AzdjuZN/xYjXRHzBk7F9UgHMN8vVYSOPG4qcqMP
   A=;
X-IronPort-AV: E=Sophos;i="5.76,390,1592870400"; 
   d="scan'208";a="52178914"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 04 Sep 2020 17:38:31 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id A7729A2132;
        Fri,  4 Sep 2020 17:38:28 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.85) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Sep 2020 17:38:18 +0000
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
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v8 05/18] nitro_enclaves: Handle PCI device command requests
Date:   Fri, 4 Sep 2020 20:37:05 +0300
Message-ID: <20200904173718.64857-6-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200904173718.64857-1-andraprs@amazon.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D02UWC003.ant.amazon.com (10.43.162.199) To
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
Reviewed-by: Alexander Graf <graf@amazon.com>
---
Changelog

v7 -> v8

* Update function signature for submit request and retrive reply
  functions as they only returned 0, no error code.
* Include command type value in the error logs of ne_do_request().

v6 -> v7

* No changes.

v5 -> v6

* Update documentation to kernel-doc format.

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
* Add fix for kbuild report:
  https://lore.kernel.org/lkml/202004231644.xTmN4Z1z%25lkp@intel.com/
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 189 +++++++++++++++++++++++
 1 file changed, 189 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index daf8b36383f1..e9e3ff882cc7 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -33,6 +33,172 @@ static const struct pci_device_id ne_pci_ids[] = {
 
 MODULE_DEVICE_TABLE(pci, ne_pci_ids);
 
+/**
+ * ne_submit_request() - Submit command request to the PCI device based on the
+ *			 command type.
+ * @pdev:		PCI device to send the command to.
+ * @cmd_type:		Command type of the request sent to the PCI device.
+ * @cmd_request:	Command request payload.
+ * @cmd_request_size:	Size of the command request payload.
+ *
+ * Context: Process context. This function is called with the ne_pci_dev mutex held.
+ */
+static void ne_submit_request(struct pci_dev *pdev, enum ne_pci_dev_cmd_type cmd_type,
+			      void *cmd_request, size_t cmd_request_size)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+
+	memcpy_toio(ne_pci_dev->iomem_base + NE_SEND_DATA, cmd_request, cmd_request_size);
+
+	iowrite32(cmd_type, ne_pci_dev->iomem_base + NE_COMMAND);
+}
+
+/**
+ * ne_retrieve_reply() - Retrieve reply from the PCI device.
+ * @pdev:		PCI device to receive the reply from.
+ * @cmd_reply:		Command reply payload.
+ * @cmd_reply_size:	Size of the command reply payload.
+ *
+ * Context: Process context. This function is called with the ne_pci_dev mutex held.
+ */
+static void ne_retrieve_reply(struct pci_dev *pdev, struct ne_pci_dev_cmd_reply *cmd_reply,
+			      size_t cmd_reply_size)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+
+	memcpy_fromio(cmd_reply, ne_pci_dev->iomem_base + NE_RECV_DATA, cmd_reply_size);
+}
+
+/**
+ * ne_wait_for_reply() - Wait for a reply of a PCI device command.
+ * @pdev:	PCI device for which a reply is waited.
+ *
+ * Context: Process context. This function is called with the ne_pci_dev mutex held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_wait_for_reply(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	int rc = -EINVAL;
+
+	/*
+	 * TODO: Update to _interruptible and handle interrupted wait event
+	 * e.g. -ERESTARTSYS, incoming signals + update timeout, if needed.
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
+		dev_err_ratelimited(&pdev->dev, "Null cmd request for cmd type=%u\n",
+				    cmd_type);
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
+		dev_err_ratelimited(&pdev->dev, "Null cmd reply for cmd type=%u\n",
+				    cmd_type);
+
+		return -EINVAL;
+	}
+
+	if (cmd_reply_size > NE_RECV_DATA_SIZE) {
+		dev_err_ratelimited(&pdev->dev, "Invalid reply size=%zu for cmd type=%u\n",
+				    cmd_reply_size, cmd_type);
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
+	ne_submit_request(pdev, cmd_type, cmd_request, cmd_request_size);
+
+	rc = ne_wait_for_reply(pdev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev, "Error in wait for reply for cmd type=%u [rc=%d]\n",
+				    cmd_type, rc);
+
+		goto unlock_mutex;
+	}
+
+	ne_retrieve_reply(pdev, cmd_reply, cmd_reply_size);
+
+	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
+
+	if (cmd_reply->rc < 0) {
+		rc = cmd_reply->rc;
+
+		dev_err_ratelimited(&pdev->dev, "Error in cmd process logic, cmd type=%u [rc=%d]\n",
+				    cmd_type, rc);
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
+ * ne_reply_handler() - Interrupt handler for retrieving a reply matching a
+ *			request sent to the PCI device for enclave lifetime
+ *			management.
+ * @irq:	Received interrupt for a reply sent by the PCI device.
+ * @args:	PCI device private data structure.
+ *
+ * Context: Interrupt context.
+ * Return:
+ * * IRQ_HANDLED on handled interrupt.
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
  * ne_setup_msix() - Setup MSI-X vectors for the PCI device.
  * @pdev:	PCI device to setup the MSI-X for.
@@ -44,6 +210,7 @@ MODULE_DEVICE_TABLE(pci, ne_pci_ids);
  */
 static int ne_setup_msix(struct pci_dev *pdev)
 {
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
 	int nr_vecs = 0;
 	int rc = -EINVAL;
 
@@ -63,7 +230,25 @@ static int ne_setup_msix(struct pci_dev *pdev)
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
@@ -74,6 +259,10 @@ static int ne_setup_msix(struct pci_dev *pdev)
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

