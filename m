Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B8B1DDFDA
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 08:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgEVGbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 02:31:06 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:41329 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbgEVGbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 02:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590129062; x=1621665062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BIAcz8LzddijuDlc7ilC9ptMeaoq12NgueDWwEgd1S4=;
  b=qdDor9AwSzUIZ7LnclKUotpA2BCztxPWNRwIi1Qe9epXPC5a7hiU0jt+
   Md4owUxPdeEO0ZyHRVipKUPxMVpDOZBIWn4qWHlEHAiJmE2UnJ6ViHwvL
   rKQT52i8aYs1LH8kiCCjjdw5gjmdQb56crRZNLyH++IDY2euFr1iPgd49
   A=;
IronPort-SDR: uIy4+63jZL1BTjOk48MWEL0v8rA7rCN1wJRm3McH0lk/HeuTNfhc1ngjrHtkIHjRpftpvj3l4k
 x+A/6DYk724A==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="45244137"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 May 2020 06:31:01 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id A1B42A0727;
        Fri, 22 May 2020 06:30:59 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:30:59 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.50) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:30:50 +0000
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
Subject: [PATCH v2 06/18] nitro_enclaves: Handle out-of-band PCI device events
Date:   Fri, 22 May 2020 09:29:34 +0300
Message-ID: <20200522062946.28973-7-andraprs@amazon.com>
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

In addition to the replies sent by the Nitro Enclaves PCI device in
response to command requests, out-of-band enclave events can happen e.g.
an enclave crashes. In this case, the Nitro Enclaves driver needs to be
aware of the event and notify the corresponding user space process that
abstracts the enclave.

Register an MSI-X interrupt vector to be used for this kind of
out-of-band events. The interrupt notifies that the state of an enclave
changed and the driver logic scans the state of each running enclave to
identify for which this notification is intended.

Create an workqueue to handle the out-of-band events. Notify user space
enclave process that is using a polling mechanism on the enclave fd. The
enclave fd is returned as a result of KVM_CREATE_VM ioctl call.

Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 117 +++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 7b2d8e1b49a5..cd2012d9b365 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -304,6 +304,85 @@ static irqreturn_t ne_reply_handler(int irq, void *args)
 	return IRQ_HANDLED;
 }
 
+/**
+ * ne_event_work_handler - Work queue handler for notifying enclaves on
+ * a state change received by the event interrupt handler.
+ *
+ * An out-of-band event is being issued by the Nitro Hypervisor when at least
+ * one enclave is changing state without client interaction.
+ *
+ * @work: item containing the Nitro Enclaves PCI device for which a
+ *	  out-of-band event was issued.
+ */
+static void ne_event_work_handler(struct work_struct *work)
+{
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	struct ne_enclave *ne_enclave = NULL;
+	struct ne_pci_dev *ne_pci_dev =
+		container_of(work, struct ne_pci_dev, notify_work);
+	int rc = -EINVAL;
+	struct slot_info_req slot_info_req = {};
+
+	mutex_lock(&ne_pci_dev->enclaves_list_mutex);
+
+	/*
+	 * Iterate over all enclaves registered for the Nitro Enclaves
+	 * PCI device and determine for which enclave(s) the out-of-band event
+	 * is corresponding to.
+	 */
+	list_for_each_entry(ne_enclave, &ne_pci_dev->enclaves_list,
+			    enclave_list_entry) {
+		mutex_lock(&ne_enclave->enclave_info_mutex);
+
+		/*
+		 * Enclaves that were never started cannot receive out-of-band
+		 * events.
+		 */
+		if (ne_enclave->state != NE_STATE_RUNNING)
+			goto unlock;
+
+		slot_info_req.slot_uid = ne_enclave->slot_uid;
+
+		rc = ne_do_request(ne_enclave->pdev, SLOT_INFO, &slot_info_req,
+				   sizeof(slot_info_req), &cmd_reply,
+				   sizeof(cmd_reply));
+		WARN_ON(rc < 0);
+
+		/* Notify enclave process that the enclave state changed. */
+		if (ne_enclave->state != cmd_reply.state) {
+			ne_enclave->state = cmd_reply.state;
+
+			ne_enclave->has_event = true;
+
+			wake_up_interruptible(&ne_enclave->eventq);
+		}
+
+unlock:
+		 mutex_unlock(&ne_enclave->enclave_info_mutex);
+	}
+
+	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+}
+
+/**
+ * ne_event_handler - Interrupt handler for PCI device out-of-band
+ * events. This interrupt does not supply any data in the MMIO region.
+ * It notifies a change in the state of any of the launched enclaves.
+ *
+ * @irq: received interrupt for an out-of-band event.
+ * @args: PCI device private data structure.
+ *
+ * @returns: IRQ_HANDLED on handled interrupt, IRQ_NONE otherwise.
+ */
+static irqreturn_t ne_event_handler(int irq, void *args)
+{
+	struct ne_pci_dev *ne_pci_dev = (struct ne_pci_dev *)args;
+
+	queue_work(ne_pci_dev->event_wq, &ne_pci_dev->notify_work);
+
+	return IRQ_HANDLED;
+}
+
 /**
  * ne_setup_msix - Setup MSI-X vectors for the PCI device.
  *
@@ -359,8 +438,40 @@ static int ne_setup_msix(struct pci_dev *pdev)
 		goto free_irq_vectors;
 	}
 
+	ne_pci_dev->event_wq = create_singlethread_workqueue("ne_pci_dev_wq");
+	if (!ne_pci_dev->event_wq) {
+		rc = -ENOMEM;
+
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Cannot get wq for dev events [rc=%d]\n",
+				    rc);
+
+		goto free_reply_irq_vec;
+	}
+
+	INIT_WORK(&ne_pci_dev->notify_work, ne_event_work_handler);
+
+	/*
+	 * This IRQ gets triggered every time any enclave's state changes. Its
+	 * handler then scans for the changes and propagates them to the user
+	 * space.
+	 */
+	rc = request_irq(pci_irq_vector(pdev, NE_VEC_EVENT),
+			 ne_event_handler, 0, "enclave_evt", ne_pci_dev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in request irq event [rc=%d]\n",
+				    rc);
+
+		goto destroy_wq;
+	}
+
 	return 0;
 
+destroy_wq:
+	destroy_workqueue(ne_pci_dev->event_wq);
+free_reply_irq_vec:
+	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
 free_irq_vectors:
 	pci_free_irq_vectors(pdev);
 
@@ -383,6 +494,12 @@ static void ne_teardown_msix(struct pci_dev *pdev)
 	if (WARN_ON(!ne_pci_dev))
 		return;
 
+	free_irq(pci_irq_vector(pdev, NE_VEC_EVENT), ne_pci_dev);
+
+	flush_work(&ne_pci_dev->notify_work);
+	flush_workqueue(ne_pci_dev->event_wq);
+	destroy_workqueue(ne_pci_dev->event_wq);
+
 	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
 
 	pci_free_irq_vectors(pdev);
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

