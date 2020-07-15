Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA49E221564
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 21:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgGOTrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 15:47:25 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:55232 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgGOTrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 15:47:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594842443; x=1626378443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U7qhc+cCIE7nXxaFDz3uurlEalXOL/KeRl/89M+n4L0=;
  b=GEi1XJc/CHpGrsMthZTSklU6IuNHsL2r0k+t+ZEV+YwzOPOrp47vSQPy
   FIHjJTq3uHwp4Fs4dAPb+5ghDhbKAItzRrIU4xJ9pEghByk5KYg7qbHH8
   nQfqWSzHkDYzTGaFt/Ll56tQsWgZMc36kI7n0ztiYrNG9a8ZUl8o4wWmr
   k=;
IronPort-SDR: Iq2G3EMGxyS15XGwgXD6DtHRGio25T852zXpC3Ocn8buKv9ij1s+W6zWDoYnYNYd7NdUlQUKf5
 5yiQ5w2isU4Q==
X-IronPort-AV: E=Sophos;i="5.75,356,1589241600"; 
   d="scan'208";a="58897315"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 15 Jul 2020 19:47:23 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 88DDAA1A46;
        Wed, 15 Jul 2020 19:47:22 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:47:21 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.214) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:47:11 +0000
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
        Alexander Graf <graf@amazon.com>
Subject: [PATCH v5 08/18] nitro_enclaves: Add logic for creating an enclave VM
Date:   Wed, 15 Jul 2020 22:45:30 +0300
Message-ID: <20200715194540.45532-9-andraprs@amazon.com>
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
Reviewed-by: Alexander Graf <graf@amazon.com>
---
Changelog

v4 -> v5

* Release the reference to the NE PCI device on create VM error.
* Close enclave fd on copy_to_user() failure; rename fd to enclave fd
  while at it.
* Remove sanity checks for situations that shouldn't happen, only if
  buggy system or broken logic at all.
* Remove log on copy_to_user() failure.

v3 -> v4

* Use dev_err instead of custom NE log pattern.
* Update the NE ioctl call to match the decoupling from the KVM API.
* Add metadata for the NUMA node for the enclave memory and CPUs.

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
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 197 ++++++++++++++++++++++
 1 file changed, 197 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 62c9a70c5cf3..6a113099ea0e 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -75,12 +75,209 @@ struct ne_cpu_pool {
 
 static struct ne_cpu_pool ne_cpu_pool;
 
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
+ * @slot_uid: generated unique slot id associated with an enclave.
+ *
+ * @returns: enclave fd on success, negative return value on failure.
+ */
+static int ne_create_vm_ioctl(struct pci_dev *pdev, struct ne_pci_dev *ne_pci_dev,
+			      u64 *slot_uid)
+{
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	int enclave_fd = -1;
+	struct file *enclave_file = NULL;
+	unsigned int i = 0;
+	struct ne_enclave *ne_enclave = NULL;
+	int rc = -EINVAL;
+	struct slot_alloc_req slot_alloc_req = {};
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	for (i = 0; i < ne_cpu_pool.avail_cores_size; i++)
+		if (!cpumask_empty(ne_cpu_pool.avail_cores[i]))
+			break;
+
+	if (i == ne_cpu_pool.avail_cores_size) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "No CPUs available in CPU pool\n");
+
+		mutex_unlock(&ne_cpu_pool.mutex);
+
+		return -NE_ERR_NO_CPUS_AVAIL_IN_POOL;
+	}
+
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	ne_enclave = kzalloc(sizeof(*ne_enclave), GFP_KERNEL);
+	if (!ne_enclave)
+		return -ENOMEM;
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	ne_enclave->avail_cpu_cores_size = ne_cpu_pool.avail_cores_size;
+	ne_enclave->numa_node = ne_cpu_pool.numa_node;
+
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	ne_enclave->avail_cpu_cores = kcalloc(ne_enclave->avail_cpu_cores_size,
+		sizeof(*ne_enclave->avail_cpu_cores), GFP_KERNEL);
+	if (!ne_enclave->avail_cpu_cores) {
+		rc = -ENOMEM;
+
+		goto free_ne_enclave;
+	}
+
+	for (i = 0; i < ne_enclave->avail_cpu_cores_size; i++)
+		if (!zalloc_cpumask_var(&ne_enclave->avail_cpu_cores[i], GFP_KERNEL)) {
+			rc = -ENOMEM;
+
+			goto free_cpumask;
+		}
+
+	if (!zalloc_cpumask_var(&ne_enclave->vcpu_ids, GFP_KERNEL)) {
+		rc = -ENOMEM;
+
+		goto free_cpumask;
+	}
+
+	ne_enclave->pdev = pdev;
+
+	enclave_fd = get_unused_fd_flags(O_CLOEXEC);
+	if (enclave_fd < 0) {
+		rc = enclave_fd;
+
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Error in getting unused fd [rc=%d]\n", rc);
+
+		goto free_cpumask;
+	}
+
+	enclave_file = anon_inode_getfile("ne-vm", &ne_enclave_fops, ne_enclave, O_RDWR);
+	if (IS_ERR(enclave_file)) {
+		rc = PTR_ERR(enclave_file);
+
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Error in anon inode get file [rc=%d]\n", rc);
+
+		goto put_fd;
+	}
+
+	rc = ne_do_request(ne_enclave->pdev, SLOT_ALLOC, &slot_alloc_req, sizeof(slot_alloc_req),
+			   &cmd_reply, sizeof(cmd_reply));
+	if (rc < 0) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Error in slot alloc [rc=%d]\n", rc);
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
+
+	list_add(&ne_enclave->enclave_list_entry, &ne_pci_dev->enclaves_list);
+
+	*slot_uid = ne_enclave->slot_uid;
+
+	fd_install(enclave_fd, enclave_file);
+
+	return enclave_fd;
+
+put_file:
+	fput(enclave_file);
+put_fd:
+	put_unused_fd(enclave_fd);
+free_cpumask:
+	free_cpumask_var(ne_enclave->vcpu_ids);
+	for (i = 0; i < ne_enclave->avail_cpu_cores_size; i++)
+		free_cpumask_var(ne_enclave->avail_cpu_cores[i]);
+	kfree(ne_enclave->avail_cpu_cores);
+free_ne_enclave:
+	kfree(ne_enclave);
+
+	return rc;
+}
+
 static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case NE_GET_API_VERSION:
 		return NE_API_VERSION;
 
+	case NE_CREATE_VM: {
+		int enclave_fd = -1;
+		struct file *enclave_file = NULL;
+		struct ne_pci_dev *ne_pci_dev = NULL;
+		/* TODO: Find another way to get the NE PCI device reference. */
+		struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_AMAZON,
+						      PCI_DEVICE_ID_NE, NULL);
+		int rc = -EINVAL;
+		u64 slot_uid = 0;
+
+		ne_pci_dev = pci_get_drvdata(pdev);
+
+		mutex_lock(&ne_pci_dev->enclaves_list_mutex);
+
+		enclave_fd = ne_create_vm_ioctl(pdev, ne_pci_dev, &slot_uid);
+		if (enclave_fd < 0) {
+			rc = enclave_fd;
+
+			mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+			pci_dev_put(pdev);
+
+			return rc;
+		}
+
+		mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+		if (copy_to_user((void __user *)arg, &slot_uid, sizeof(slot_uid))) {
+			enclave_file = fget(enclave_fd);
+			/* Decrement file refs to have release() called. */
+			fput(enclave_file);
+			fput(enclave_file);
+			put_unused_fd(enclave_fd);
+
+			return -EFAULT;
+		}
+
+		return enclave_fd;
+	}
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

