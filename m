Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC721E17B0
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 00:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389045AbgEYWPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 18:15:14 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:8352 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388906AbgEYWPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 18:15:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590444912; x=1621980912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o+NdgI1J6PBp+avZKIKs3vE9zbeSIR5rnLvMu0m+gbI=;
  b=TUVV98PUPgKh0NwQ+U60vKt0qzjp8voLIS3MdkGsPgBftE7ftUIWOqcc
   ODZEGf7KvoTm3E8ySFxbpfbmxwDzxdPjCVuLBhwCxMdIn6cPqXnIiFEmd
   aNnlsyb5K/BFbb2AuOwKS/8QYiSCs7kGCylsoFPHmwsdu4Xrhbp8it2dY
   A=;
IronPort-SDR: iI7PcvtGdv0v5rRFuDbvniBWLWatBMWtVNC3N4G00ixN6R7L14yBxNSpWY4BxlE+RqeIE+moLW
 HOwy5C5xPgzw==
X-IronPort-AV: E=Sophos;i="5.73,435,1583193600"; 
   d="scan'208";a="32159765"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 25 May 2020 22:15:12 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id B40B81417AF;
        Mon, 25 May 2020 22:15:10 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:15:10 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:14:59 +0000
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
Subject: [PATCH v3 08/18] nitro_enclaves: Add logic for enclave vm creation
Date:   Tue, 26 May 2020 01:13:24 +0300
Message-ID: <20200525221334.62966-9-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200525221334.62966-1-andraprs@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D14UWC002.ant.amazon.com (10.43.162.214) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add ioctl command logic for enclave VM creation. It triggers a slot
allocation. The enclave resources will be associated with this slot and
it will be used as an identifier for triggering enclave run.

Return a file descriptor, namely enclave fd. This is further used by the
associated user space enclave process to set enclave resources and
trigger enclave termination.

The poll function is implemented in order to notify the enclave process
when an enclave exits without a specific enclave termination command
trigger e.g. when an enclave crashes.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v2 -> v3

* Remove the WARN_ON calls.
* Update static calls sanity checks.
* Update kzfree() calls to kfree().
* Remove file ops that do nothing for now - open.

v1 -> v2

* Add log pattern for NE.
* Update goto labels to match their purpose.
* Remove the BUG_ON calls.
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 160 ++++++++++++++++++++++
 1 file changed, 160 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 4a6f74cacdb0..8cf1c4ee1812 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -49,9 +49,169 @@ struct ne_cpu_pool {
 
 static struct ne_cpu_pool ne_cpu_pool;
 
+static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	switch (cmd) {
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static int ne_enclave_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static __poll_t ne_enclave_poll(struct file *file, poll_table *wait)
+{
+	__poll_t mask = 0;
+	struct ne_enclave *ne_enclave = file->private_data;
+
+	poll_wait(file, &ne_enclave->eventq, wait);
+
+	if (!ne_enclave->has_event)
+		return mask;
+
+	mask = POLLHUP;
+
+	return mask;
+}
+
+static const struct file_operations ne_enclave_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= noop_llseek,
+	.poll		= ne_enclave_poll,
+	.unlocked_ioctl	= ne_enclave_ioctl,
+	.release	= ne_enclave_release,
+};
+
+/**
+ * ne_create_vm_ioctl - Alloc slot to be associated with an enclave. Create
+ * enclave file descriptor to be further used for enclave resources handling
+ * e.g. memory regions and CPUs.
+ *
+ * This function gets called with the ne_pci_dev enclave mutex held.
+ *
+ * @pdev: PCI device used for enclave lifetime management.
+ * @ne_pci_dev: private data associated with the PCI device.
+ * @type: type of the virtual machine to be created.
+ *
+ * @returns: enclave fd on success, negative return value on failure.
+ */
+static int ne_create_vm_ioctl(struct pci_dev *pdev,
+			      struct ne_pci_dev *ne_pci_dev, unsigned long type)
+{
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	int fd = 0;
+	struct file *file = NULL;
+	struct ne_enclave *ne_enclave = NULL;
+	int rc = -EINVAL;
+	struct slot_alloc_req slot_alloc_req = {};
+
+	ne_enclave = kzalloc(sizeof(*ne_enclave), GFP_KERNEL);
+	if (!ne_enclave)
+		return -ENOMEM;
+
+	if (!zalloc_cpumask_var(&ne_enclave->cpu_siblings, GFP_KERNEL)) {
+		kfree(ne_enclave);
+
+		return -ENOMEM;
+	}
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0) {
+		rc = fd;
+
+		pr_err_ratelimited(NE "Error in getting unused fd [rc=%d]\n",
+				   rc);
+
+		goto free_cpumask;
+	}
+
+	file = anon_inode_getfile("ne-vm", &ne_enclave_fops, ne_enclave,
+				  O_RDWR);
+	if (IS_ERR(file)) {
+		rc = PTR_ERR(file);
+
+		pr_err_ratelimited(NE "Error in anon inode get file [rc=%d]\n",
+				   rc);
+
+		goto put_fd;
+	}
+
+	ne_enclave->pdev = pdev;
+
+	rc = ne_do_request(ne_enclave->pdev, SLOT_ALLOC, &slot_alloc_req,
+			   sizeof(slot_alloc_req), &cmd_reply,
+			   sizeof(cmd_reply));
+	if (rc < 0) {
+		pr_err_ratelimited(NE "Error in slot alloc [rc=%d]\n", rc);
+
+		goto put_file;
+	}
+
+	init_waitqueue_head(&ne_enclave->eventq);
+	ne_enclave->has_event = false;
+	mutex_init(&ne_enclave->enclave_info_mutex);
+	ne_enclave->max_mem_regions = cmd_reply.mem_regions;
+	INIT_LIST_HEAD(&ne_enclave->mem_regions_list);
+	ne_enclave->mm = current->mm;
+	ne_enclave->slot_uid = cmd_reply.slot_uid;
+	ne_enclave->state = NE_STATE_INIT;
+	INIT_LIST_HEAD(&ne_enclave->vcpu_ids_list);
+
+	list_add(&ne_enclave->enclave_list_entry, &ne_pci_dev->enclaves_list);
+
+	fd_install(fd, file);
+
+	return fd;
+
+put_file:
+	fput(file);
+put_fd:
+	put_unused_fd(fd);
+free_cpumask:
+	free_cpumask_var(ne_enclave->cpu_siblings);
+	kfree(ne_enclave);
+
+	return rc;
+}
+
 static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	struct ne_pci_dev *ne_pci_dev = NULL;
+	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_AMAZON,
+					      PCI_DEVICE_ID_NE, NULL);
+
+	if (!pdev)
+		return -EINVAL;
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	if (!ne_pci_dev)
+		return -EINVAL;
+
 	switch (cmd) {
+	case KVM_CREATE_VM: {
+		int rc = -EINVAL;
+		unsigned long type = 0;
+
+		if (copy_from_user(&type, (void *)arg, sizeof(type))) {
+			pr_err_ratelimited(NE "Error in copy from user\n");
+
+			return -EFAULT;
+		}
+
+		mutex_lock(&ne_pci_dev->enclaves_list_mutex);
+
+		rc = ne_create_vm_ioctl(pdev, ne_pci_dev, type);
+
+		mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+		return rc;
+	}
 
 	default:
 		return -ENOTTY;
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

