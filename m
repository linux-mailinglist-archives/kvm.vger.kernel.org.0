Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39892723A3
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 14:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgIUMTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 08:19:13 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:20055 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgIUMTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 08:19:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600690752; x=1632226752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8OqsOhldukack5SuPpNuBdqBAVngNkyOwLmGgxC7RcQ=;
  b=N2W65veMbC1SKIIzM9KfvhneEm2FD3hYas/kSYIb4lYFUw+VcsecVPRs
   3zDi3Rdofkd54h69aPu0DEt2VRitmdAc8rxB/7kLqwWma4r9IhQLU60T4
   df1YpfRdD/Pmz9/F8uqT+6OLjIZ6NQx3++8xNbRW1nWYMr5ZsjeCzeAvh
   Q=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="55088245"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 21 Sep 2020 12:19:12 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 1DEE8A184B;
        Mon, 21 Sep 2020 12:19:08 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.229) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 12:18:57 +0000
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
Subject: [PATCH v10 06/18] nitro_enclaves: Handle out-of-band PCI device events
Date:   Mon, 21 Sep 2020 15:17:20 +0300
Message-ID: <20200921121732.44291-7-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200921121732.44291-1-andraprs@amazon.com>
References: <20200921121732.44291-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D28UWB002.ant.amazon.com (10.43.161.140) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

Changelog

v9 -> v10

* Update commit message to include the changelog before the SoB tag(s).

v8 -> v9

* Use the reference to the pdev directly from the ne_pci_dev instead of
  the one from the enclave data structure.

v7 -> v8

* No changes.

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
* Update goto labels to match their purpose.

Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 118 +++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index cedc4dd2dd39..6654cc8a1bc3 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -199,6 +199,90 @@ static irqreturn_t ne_reply_handler(int irq, void *args)
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
+	struct pci_dev *pdev = ne_pci_dev->pdev;
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
+		rc = ne_do_request(pdev, SLOT_INFO,
+				   &slot_info_req, sizeof(slot_info_req),
+				   &cmd_reply, sizeof(cmd_reply));
+		if (rc < 0)
+			dev_err(&pdev->dev, "Error in slot info [rc=%d]\n", rc);
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
@@ -243,8 +327,36 @@ static int ne_setup_msix(struct pci_dev *pdev)
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
 
@@ -261,6 +373,12 @@ static void ne_teardown_msix(struct pci_dev *pdev)
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

