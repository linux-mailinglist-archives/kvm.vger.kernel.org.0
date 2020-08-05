Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4501823C8CB
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 11:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgHEJMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 05:12:36 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:58766 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbgHEJLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 05:11:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596618703; x=1628154703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZronyD2XkhBmFSaKHRiozvNzsOcMNsD5kSWwUfxdedM=;
  b=oX2812bXmpcI+DCG0Fg0lt+KKoRUz0fjqBF9wbTOcjVcU68j8qRqmTPy
   1jHzz1oefSNq1zZ+Bza2JfaOv9jRJy+BDCQh4xg2i/UMN3NElJdkNiFzr
   ODVF68Rt0D3thkekSlrwkxRqhA9ooxumkBZAFVCAUq+2zQfkbOVdKL1nM
   s=;
IronPort-SDR: ffVt6N+M+QD0uPBP+l77ZzIAeyauyAvGCkfHMF3d27xgizNsyNtQwqkS2Z1gJtcoUueoGpxDmO
 ANWuYFWKFIww==
X-IronPort-AV: E=Sophos;i="5.75,436,1589241600"; 
   d="scan'208";a="46143536"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 05 Aug 2020 09:11:38 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 5DD4FA1F49;
        Wed,  5 Aug 2020 09:11:36 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:11:35 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.100) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:11:25 +0000
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
Subject: [PATCH v6 06/18] nitro_enclaves: Handle out-of-band PCI device events
Date:   Wed, 5 Aug 2020 12:10:05 +0300
Message-ID: <20200805091017.86203-7-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200805091017.86203-1-andraprs@amazon.com>
References: <20200805091017.86203-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D18UWC001.ant.amazon.com (10.43.162.105) To
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
enclave process that is using a polling mechanism on the enclave fd.

Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

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
* Update goto labels to match their purpose.
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 116 +++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 77ccbc43bce3..a898fae066d9 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -214,6 +214,88 @@ static irqreturn_t ne_reply_handler(int irq, void *args)
 	return IRQ_HANDLED;
 }
 
+/**
+ * ne_event_work_handler() - Work queue handler for notifying enclaves on a
+ *			     state change received by the event interrupt
+ *			     handler.
+ * @work:	Item containing the NE PCI device for which an out-of-band event
+ *		was issued.
+ *
+ * An out-of-band event is being issued by the Nitro Hypervisor when at least
+ * one enclave is changing state without client interaction.
+ *
+ * Context: Work queue context.
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
+	list_for_each_entry(ne_enclave, &ne_pci_dev->enclaves_list, enclave_list_entry) {
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
+				   sizeof(slot_info_req), &cmd_reply, sizeof(cmd_reply));
+		if (rc < 0)
+			dev_err(&ne_enclave->pdev->dev, "Error in slot info [rc=%d]\n", rc);
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
+ * ne_event_handler() - Interrupt handler for PCI device out-of-band events.
+ *			This interrupt does not supply any data in the MMIO
+ *			region. It notifies a change in the state of any of
+ *			the launched enclaves.
+ * @irq:	Received interrupt for an out-of-band event.
+ * @args:	PCI device private data structure.
+ *
+ * Context: Interrupt context.
+ * Return:
+ * * IRQ_HANDLED on handled interrupt.
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
  * ne_setup_msix() - Setup MSI-X vectors for the PCI device.
  * @pdev:	PCI device to setup the MSI-X for.
@@ -258,8 +340,36 @@ static int ne_setup_msix(struct pci_dev *pdev)
 		goto free_irq_vectors;
 	}
 
+	ne_pci_dev->event_wq = create_singlethread_workqueue("ne_pci_dev_wq");
+	if (!ne_pci_dev->event_wq) {
+		rc = -ENOMEM;
+
+		dev_err(&pdev->dev, "Cannot get wq for dev events [rc=%d]\n", rc);
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
+	rc = request_irq(pci_irq_vector(pdev, NE_VEC_EVENT), ne_event_handler,
+			 0, "enclave_evt", ne_pci_dev);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error in request irq event [rc=%d]\n", rc);
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
 
@@ -276,6 +386,12 @@ static void ne_teardown_msix(struct pci_dev *pdev)
 {
 	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
 
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

