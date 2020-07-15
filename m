Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6996E221560
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 21:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgGOTrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 15:47:07 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:5493 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgGOTrG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 15:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594842424; x=1626378424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yugx5GlonK1+GKnQOKIgIsWKdOPiieSZcZDKp9NzkKo=;
  b=K4p5V3ucjrn20WmhbF+xKBwRI55i1chAAHcFCyxpQQGCaYEnqmWI2oxk
   6VzZEilidlQALyfmb9WTemIdZm+ijEPBZ8GsfNJbeGFGBiARh1iS1VbBd
   9B4SBqQD3ppw4GQRIvUBlilGCpwBaGExqAw1SVWnSGpRfMUhehAyM64Y4
   U=;
IronPort-SDR: Z1SkpJPajPsdsFMZl7LHom+ACDYlg02TwBYx6AKhi6zdBv+McDEBH2DgWfN1+9x9f49HLKOAl5
 cna+uFgjdkRA==
X-IronPort-AV: E=Sophos;i="5.75,356,1589241600"; 
   d="scan'208";a="43560370"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 15 Jul 2020 19:47:03 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 0E5D92272B7;
        Wed, 15 Jul 2020 19:47:02 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:47:01 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.214) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:46:51 +0000
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
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v5 06/18] nitro_enclaves: Handle out-of-band PCI device events
Date:   Wed, 15 Jul 2020 22:45:28 +0300
Message-ID: <20200715194540.45532-7-andraprs@amazon.com>
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
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 112 +++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 738b8f4d8faf..e12a8f8bf0be 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -206,6 +206,84 @@ static irqreturn_t ne_reply_handler(int irq, void *args)
 	return IRQ_HANDLED;
 }
 
+/**
+ * ne_event_work_handler - Work queue handler for notifying enclaves on
+ * a state change received by the event interrupt handler.
+ *
+ * An out-of-band event is being issued by the Nitro Hypervisor when at least
+ * one enclave is changing state without client interaction.
+ *
+ * @work: item containing the Nitro Enclaves PCI device for which an
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
@@ -248,8 +326,36 @@ static int ne_setup_msix(struct pci_dev *pdev)
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
 
@@ -265,6 +371,12 @@ static void ne_teardown_msix(struct pci_dev *pdev)
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

