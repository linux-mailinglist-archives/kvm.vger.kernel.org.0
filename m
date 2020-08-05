Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FE923C8DB
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 11:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgHEJNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 05:13:42 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:58766 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728462AbgHEJMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 05:12:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596618758; x=1628154758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ERLX5ZNwbYxR2PurfdnQYY2uOEAclEHLZKUIYKkOkc0=;
  b=jj1fqKirSr+9W6Ubx+sepmeF5uWhp/v6VP+OoqShWoJf53S2MVc/UQJt
   dwPc1SwzCerBtcG1/5ggGwZrCblMa8UfW2ob1ISknl/8RQUirKQFsPXmB
   /KoZrtgjhWCCpaqjIPoxwAao6T/rEd0D5mNIOuJgyIDCYnPdWchPq+43i
   U=;
IronPort-SDR: Ow6oXeCjLy2NllvwDyArRbM/jybvGSjgRx8l+N9cd/ijlf9r71enulJ3CexY8EREdWGEQkJnBP
 ClsA8k8GkILg==
X-IronPort-AV: E=Sophos;i="5.75,436,1589241600"; 
   d="scan'208";a="64480789"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 05 Aug 2020 09:11:57 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id C02A2A1FDF;
        Wed,  5 Aug 2020 09:11:55 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:11:55 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.100) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:11:45 +0000
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
Subject: [PATCH v6 08/18] nitro_enclaves: Add logic for creating an enclave VM
Date:   Wed, 5 Aug 2020 12:10:07 +0300
Message-ID: <20200805091017.86203-9-andraprs@amazon.com>
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

v5 -> v6

* Update the code base to init the ioctl function in this patch.
* Update documentation to kernel-doc format.

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
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 229 ++++++++++++++++++++++
 1 file changed, 229 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 472850250220..6c8c12f65666 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -87,9 +87,238 @@ struct ne_cpu_pool {
 
 static struct ne_cpu_pool ne_cpu_pool;
 
+/**
+ * ne_enclave_poll() - Poll functionality used for enclave out-of-band events.
+ * @file:	File associated with this poll function.
+ * @wait:	Poll table data structure.
+ *
+ * Context: Process context.
+ * Return:
+ * * Poll mask.
+ */
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
+ * ne_create_vm_ioctl() - Alloc slot to be associated with an enclave. Create
+ *			  enclave file descriptor to be further used for enclave
+ *			  resources handling e.g. memory regions and CPUs.
+ * @pdev:		PCI device used for enclave lifetime management.
+ * @ne_pci_dev :	Private data associated with the PCI device.
+ * @slot_uid:		Generated unique slot id associated with an enclave.
+ *
+ * Context: Process context. This function is called with the ne_pci_dev enclave
+ *	    mutex held.
+ * Return:
+ * * Enclave fd on success.
+ * * Negative return value on failure.
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
+/**
+ * ne_ioctl() - Ioctl function provided by the NE misc device.
+ * @file:	File associated with this ioctl function.
+ * @cmd:	The command that is set for the ioctl call.
+ * @arg:	The argument that is provided for the ioctl call.
+ *
+ * Context: Process context.
+ * Return:
+ * * Ioctl result (e.g. enclave file descriptor) on success.
+ * * Negative return value on failure.
+ */
+static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
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
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
 static const struct file_operations ne_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= noop_llseek,
+	.unlocked_ioctl	= ne_ioctl,
 };
 
 struct miscdevice ne_misc_dev = {
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

