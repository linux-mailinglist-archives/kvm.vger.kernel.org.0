Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D271B2F5A
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgDUSnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:43:17 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:40570 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbgDUSnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494595; x=1619030595;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L+YfGbNVRac+QAclE7qZ7rnk6HjJJ2K8eilo3W1BJmo=;
  b=UM2/YvuKb3OqXuLG0O86jLegO1vr9VdYFm8Mk+IZzeePocZKUfPEYdKd
   YST4nBURMsETQw82mLAARU1rJv5pk2GrjqKsBd7eqcXNVGWJJXnEnmYN7
   TBI6Yor7lx22FAQwQ5sFyJ+S35x8nBXMCPsYoNv/dq8iy91xQx2amEgCn
   o=;
IronPort-SDR: e775FMH867kBhx9iO8hRDujbCwmXcID2cz+VYNDBr47aF9Og6gt3gpuLGCtHaSBLTyrdzd+PTt
 wwZRwjzvBSsQ==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="26702238"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 21 Apr 2020 18:43:01 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id DEB49A1A13;
        Tue, 21 Apr 2020 18:42:59 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:42:59 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:42:50 +0000
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
Subject: [PATCH v1 06/15] nitro_enclaves: Handle out-of-band PCI device events
Date:   Tue, 21 Apr 2020 21:41:41 +0300
Message-ID: <20200421184150.68011-7-andraprs@amazon.com>
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
 .../virt/amazon/nitro_enclaves/ne_pci_dev.c   | 120 ++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c b/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
index 7453d129689a..884acbb92305 100644
--- a/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
@@ -285,6 +285,85 @@ static irqreturn_t ne_reply_handler(int irq, void *args)
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
@@ -311,6 +390,19 @@ static int ne_setup_msix(struct pci_dev *pdev, struct ne_pci_dev *ne_pci_dev)
 		return rc;
 	}
 
+	ne_pci_dev->event_wq = create_singlethread_workqueue("ne_pci_dev_wq");
+	if (!ne_pci_dev->event_wq) {
+		rc = -ENOMEM;
+
+		dev_err_ratelimited(&pdev->dev,
+				    "Cannot get wq for device events [rc=%d]\n",
+				    rc);
+
+		goto err_create_wq;
+	}
+
+	INIT_WORK(&ne_pci_dev->notify_work, ne_event_work_handler);
+
 	rc = pci_alloc_irq_vectors(pdev, nr_vecs, nr_vecs, PCI_IRQ_MSIX);
 	if (rc < 0) {
 		dev_err_ratelimited(&pdev->dev,
@@ -335,11 +427,30 @@ static int ne_setup_msix(struct pci_dev *pdev, struct ne_pci_dev *ne_pci_dev)
 		goto err_req_irq_reply;
 	}
 
+	/*
+	 * This IRQ gets triggered every time any enclave's state changes. Its
+	 * handler then scans for the changes and propagates them to the user
+	 * space.
+	 */
+	rc = request_irq(pci_irq_vector(pdev, NE_VEC_EVENT),
+			 ne_event_handler, 0, "enclave_evt", ne_pci_dev);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in allocating irq event [rc=%d]\n",
+				    rc);
+
+		goto err_req_irq_event;
+	}
+
 	return 0;
 
+err_req_irq_event:
+	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
 err_req_irq_reply:
 	pci_free_irq_vectors(pdev);
 err_alloc_irq_vecs:
+	destroy_workqueue(ne_pci_dev->event_wq);
+err_create_wq:
 	return rc;
 }
 
@@ -494,8 +605,10 @@ static int ne_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_ne_pci_dev_enable:
 err_ne_pci_dev_disable:
+	free_irq(pci_irq_vector(pdev, NE_VEC_EVENT), ne_pci_dev);
 	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
 	pci_free_irq_vectors(pdev);
+	destroy_workqueue(ne_pci_dev->event_wq);
 err_setup_msix:
 	pci_iounmap(pdev, ne_pci_dev->iomem_base);
 err_iomap:
@@ -518,9 +631,16 @@ static void ne_remove(struct pci_dev *pdev)
 
 	pci_set_drvdata(pdev, NULL);
 
+	free_irq(pci_irq_vector(pdev, NE_VEC_EVENT), ne_pci_dev);
 	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
 	pci_free_irq_vectors(pdev);
 
+	if (ne_pci_dev->event_wq) {
+		flush_work(&ne_pci_dev->notify_work);
+		flush_workqueue(ne_pci_dev->event_wq);
+		destroy_workqueue(ne_pci_dev->event_wq);
+	}
+
 	pci_iounmap(pdev, ne_pci_dev->iomem_base);
 
 	kzfree(ne_pci_dev);
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

