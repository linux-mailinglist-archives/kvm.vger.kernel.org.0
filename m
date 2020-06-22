Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830452040EA
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgFVUFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:05:00 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:3975 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgFVUE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1592856298; x=1624392298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hnzQILvNsGKP2NKN5oCqLiYW5V3qrk+qHhJj4PDBcxE=;
  b=ouhVflF2Gu+OM2h0OtOU7PRWVcWqzmkMhxgmgVEzu3GNqwCpsu/7ilHs
   JHRhMImpL5riynuEkVam1oMFFGcDgwMPIgs9T13O0/ctOs75DbD1jxilW
   dq9lBNese9ptXK+hUjHms7STCDBh5vGPWSr5V6sgUB65S/8O1tT7KSxx/
   4=;
IronPort-SDR: dQ8eQzlFi+cj6IYeKPuiA5VUdRKvBTKzlqdAT1qnHq+waUMr7YV5ujq1Q4SSEUH6c7AqeZ/Mv+
 eW+u2l/Y0akg==
X-IronPort-AV: E=Sophos;i="5.75,268,1589241600"; 
   d="scan'208";a="37804946"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 22 Jun 2020 20:04:57 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id BD1DFA1BEA;
        Mon, 22 Jun 2020 20:04:55 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:04:55 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:04:45 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        "Matt Wilson" <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v4 07/18] nitro_enclaves: Init misc device providing the ioctl interface
Date:   Mon, 22 Jun 2020 23:03:18 +0300
Message-ID: <20200622200329.52996-8-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200622200329.52996-1-andraprs@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D12UWC003.ant.amazon.com (10.43.162.12) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Nitro Enclaves driver provides an ioctl interface to the user space
for enclave lifetime management e.g. enclave creation / termination and
setting enclave resources such as memory and CPU.

This ioctl interface is mapped to a Nitro Enclaves misc device.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v3 -> v4

* Use dev_err instead of custom NE log pattern.
* Remove the NE CPU pool init during kernel module loading, as the CPU
  pool is now setup at runtime, via a sysfs file for the kernel
  parameter.
* Add minimum enclave memory size definition.

v2 -> v3

* Remove the GPL additional wording as SPDX-License-Identifier is
  already in place.
* Remove the WARN_ON calls.
* Remove linux/bug and linux/kvm_host includes that are not needed.
* Remove "ratelimited" from the logs that are not in the ioctl call
  paths.
* Remove file ops that do nothing for now - open and release.

v1 -> v2

* Add log pattern for NE.
* Update goto labels to match their purpose.
* Update ne_cpu_pool data structure to include the global mutex.
* Update NE misc device mode to 0660.
* Check if the CPU siblings are included in the NE CPU pool, as full CPU
  cores are given for the enclave(s).
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 133 ++++++++++++++++++++++
 drivers/virt/nitro_enclaves/ne_pci_dev.c  |  11 ++
 2 files changed, 144 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.c

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
new file mode 100644
index 000000000000..628fb10c2b36
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ */
+
+/**
+ * Enclave lifetime management driver for Nitro Enclaves (NE).
+ * Nitro is a hypervisor that has been developed by Amazon.
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/capability.h>
+#include <linux/cpu.h>
+#include <linux/device.h>
+#include <linux/file.h>
+#include <linux/hugetlb.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/nitro_enclaves.h>
+#include <linux/pci.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include "ne_misc_dev.h"
+#include "ne_pci_dev.h"
+
+#define NE_EIF_LOAD_OFFSET (8 * 1024UL * 1024UL)
+
+#define NE_MIN_ENCLAVE_MEM_SIZE (64 * 1024UL * 1024UL)
+
+#define NE_MIN_MEM_REGION_SIZE (2 * 1024UL * 1024UL)
+
+/*
+ * TODO: Update logic to create new sysfs entries instead of using
+ * a kernel parameter e.g. if multiple sysfs files needed.
+ */
+static const struct kernel_param_ops ne_cpu_pool_ops = {
+};
+
+static char ne_cpus[PAGE_SIZE];
+static struct kparam_string ne_cpus_arg = {
+	.maxlen = sizeof(ne_cpus),
+	.string = ne_cpus,
+};
+
+module_param_cb(ne_cpus, &ne_cpu_pool_ops, &ne_cpus_arg, 0644);
+MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclaves");
+
+/* CPU pool used for Nitro Enclaves. */
+struct ne_cpu_pool {
+	/* Available CPUs in the pool. */
+	cpumask_var_t avail;
+	struct mutex mutex;
+};
+
+static struct ne_cpu_pool ne_cpu_pool;
+
+static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case NE_GET_API_VERSION:
+		return NE_API_VERSION;
+
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static const struct file_operations ne_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= noop_llseek,
+	.unlocked_ioctl	= ne_ioctl,
+};
+
+struct miscdevice ne_misc_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "nitro_enclaves",
+	.fops	= &ne_fops,
+	.mode	= 0660,
+};
+
+static int __init ne_init(void)
+{
+	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_AMAZON,
+					      PCI_DEVICE_ID_NE, NULL);
+	int rc = -EINVAL;
+
+	if (!pdev)
+		return -ENODEV;
+
+	if (!zalloc_cpumask_var(&ne_cpu_pool.avail, GFP_KERNEL))
+		return -ENOMEM;
+
+	mutex_init(&ne_cpu_pool.mutex);
+
+	rc = pci_register_driver(&ne_pci_driver);
+	if (rc < 0) {
+		dev_err(&pdev->dev,
+			"Error in pci register driver [rc=%d]\n", rc);
+
+		goto free_cpumask;
+	}
+
+	return 0;
+
+free_cpumask:
+	free_cpumask_var(ne_cpu_pool.avail);
+
+	return rc;
+}
+
+static void __exit ne_exit(void)
+{
+	pci_unregister_driver(&ne_pci_driver);
+
+	free_cpumask_var(ne_cpu_pool.avail);
+}
+
+/* TODO: Handle actions such as reboot, kexec. */
+
+module_init(ne_init);
+module_exit(ne_exit);
+
+MODULE_AUTHOR("Amazon.com, Inc. or its affiliates");
+MODULE_DESCRIPTION("Nitro Enclaves Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 9a137862cade..c781cd0a50bf 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -557,6 +557,13 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto teardown_msix;
 	}
 
+	rc = misc_register(&ne_misc_dev);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error in misc dev register [rc=%d]\n", rc);
+
+		goto disable_ne_pci_dev;
+	}
+
 	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
 	init_waitqueue_head(&ne_pci_dev->cmd_reply_wait_q);
 	INIT_LIST_HEAD(&ne_pci_dev->enclaves_list);
@@ -566,6 +573,8 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+disable_ne_pci_dev:
+	ne_pci_dev_disable(pdev);
 teardown_msix:
 	ne_teardown_msix(pdev);
 iounmap_pci_bar:
@@ -588,6 +597,8 @@ static void ne_pci_remove(struct pci_dev *pdev)
 	if (!ne_pci_dev || !ne_pci_dev->iomem_base)
 		return;
 
+	misc_deregister(&ne_misc_dev);
+
 	ne_pci_dev_disable(pdev);
 
 	ne_teardown_msix(pdev);
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

