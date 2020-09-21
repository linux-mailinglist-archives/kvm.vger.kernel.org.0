Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6F22723A6
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 14:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgIUMT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 08:19:26 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:41346 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgIUMTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 08:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600690764; x=1632226764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WQJ7ydttENM8Nf5/a6VXKvt3S6C7ISsRFXGMjgUaukY=;
  b=ikEBM9GOxi+dFsB057RgUBetRTusKAoIoyvy2MW83vYXlNF4uBjO7kEF
   x6jdwxy8m08LtFmyNv/kBNIDtiYhBRcjIGm9S95z3wSzBgnzOe3HWmAQm
   ITgxkfW3dXOBn2ZO150fXs2YDKsk3ZO81MgGKS6+hWUHa+dKOnUN52jAp
   g=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="56709772"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Sep 2020 12:19:20 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 9B808A1E2A;
        Mon, 21 Sep 2020 12:19:17 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.229) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 12:19:07 +0000
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
Subject: [PATCH v10 07/18] nitro_enclaves: Init misc device providing the ioctl interface
Date:   Mon, 21 Sep 2020 15:17:21 +0300
Message-ID: <20200921121732.44291-8-andraprs@amazon.com>
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

The Nitro Enclaves driver provides an ioctl interface to the user space
for enclave lifetime management e.g. enclave creation / termination and
setting enclave resources such as memory and CPU.

This ioctl interface is mapped to a Nitro Enclaves misc device.

Changelog

v9 -> v10

* Update commit message to include the changelog before the SoB tag(s).

v8 -> v9

* Use the ne_devs data structure to get the refs for the NE misc device
  in the NE PCI device driver logic.

v7 -> v8

* Add define for the CID of the primary / parent VM.
* Update the NE PCI driver shutdown logic to include misc device
  deregister.

v6 -> v7

* Set the NE PCI device the parent of the NE misc device to be able to
  use it in the ioctl logic.
* Update the naming and add more comments to make more clear the logic
  of handling full CPU cores and dedicating them to the enclave.

v5 -> v6

* Remove the ioctl to query API version.
* Update documentation to kernel-doc format.

v4 -> v5

* Update the size of the NE CPU pool string from 4096 to 512 chars.

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

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 139 ++++++++++++++++++++++
 drivers/virt/nitro_enclaves/ne_pci_dev.c  |  14 +++
 2 files changed, 153 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.c

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
new file mode 100644
index 000000000000..c06825070313
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ */
+
+/**
+ * DOC: Enclave lifetime management driver for Nitro Enclaves (NE).
+ * Nitro is a hypervisor that has been developed by Amazon.
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/capability.h>
+#include <linux/cpu.h>
+#include <linux/device.h>
+#include <linux/file.h>
+#include <linux/hugetlb.h>
+#include <linux/limits.h>
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
+#include <uapi/linux/vm_sockets.h>
+
+#include "ne_misc_dev.h"
+#include "ne_pci_dev.h"
+
+/**
+ * NE_CPUS_SIZE - Size for max 128 CPUs, for now, in a cpu-list string, comma
+ *		  separated. The NE CPU pool includes CPUs from a single NUMA
+ *		  node.
+ */
+#define NE_CPUS_SIZE		(512)
+
+/**
+ * NE_EIF_LOAD_OFFSET - The offset where to copy the Enclave Image Format (EIF)
+ *			image in enclave memory.
+ */
+#define NE_EIF_LOAD_OFFSET	(8 * 1024UL * 1024UL)
+
+/**
+ * NE_MIN_ENCLAVE_MEM_SIZE - The minimum memory size an enclave can be launched
+ *			     with.
+ */
+#define NE_MIN_ENCLAVE_MEM_SIZE	(64 * 1024UL * 1024UL)
+
+/**
+ * NE_MIN_MEM_REGION_SIZE - The minimum size of an enclave memory region.
+ */
+#define NE_MIN_MEM_REGION_SIZE	(2 * 1024UL * 1024UL)
+
+/**
+ * NE_PARENT_VM_CID - The CID for the vsock device of the primary / parent VM.
+ */
+#define NE_PARENT_VM_CID	(3)
+
+static const struct file_operations ne_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= noop_llseek,
+};
+
+static struct miscdevice ne_misc_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "nitro_enclaves",
+	.fops	= &ne_fops,
+	.mode	= 0660,
+};
+
+struct ne_devs ne_devs = {
+	.ne_misc_dev	= &ne_misc_dev,
+};
+
+/*
+ * TODO: Update logic to create new sysfs entries instead of using
+ * a kernel parameter e.g. if multiple sysfs files needed.
+ */
+static const struct kernel_param_ops ne_cpu_pool_ops = {
+	.get	= param_get_string,
+};
+
+static char ne_cpus[NE_CPUS_SIZE];
+static struct kparam_string ne_cpus_arg = {
+	.maxlen	= sizeof(ne_cpus),
+	.string	= ne_cpus,
+};
+
+module_param_cb(ne_cpus, &ne_cpu_pool_ops, &ne_cpus_arg, 0644);
+/* https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html#cpu-lists */
+MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclaves");
+
+/**
+ * struct ne_cpu_pool - CPU pool used for Nitro Enclaves.
+ * @avail_threads_per_core:	Available full CPU cores to be dedicated to
+ *				enclave(s). The cpumasks from the array, indexed
+ *				by core id, contain all the threads from the
+ *				available cores, that are not set for created
+ *				enclave(s). The full CPU cores are part of the
+ *				NE CPU pool.
+ * @mutex:			Mutex for the access to the NE CPU pool.
+ * @nr_parent_vm_cores :	The size of the available threads per core array.
+ *				The total number of CPU cores available on the
+ *				primary / parent VM.
+ * @nr_threads_per_core:	The number of threads that a full CPU core has.
+ * @numa_node:			NUMA node of the CPUs in the pool.
+ */
+struct ne_cpu_pool {
+	cpumask_var_t	*avail_threads_per_core;
+	struct mutex	mutex;
+	unsigned int	nr_parent_vm_cores;
+	unsigned int	nr_threads_per_core;
+	int		numa_node;
+};
+
+static struct ne_cpu_pool ne_cpu_pool;
+
+static int __init ne_init(void)
+{
+	mutex_init(&ne_cpu_pool.mutex);
+
+	return pci_register_driver(&ne_pci_driver);
+}
+
+static void __exit ne_exit(void)
+{
+	pci_unregister_driver(&ne_pci_driver);
+}
+
+module_init(ne_init);
+module_exit(ne_exit);
+
+MODULE_AUTHOR("Amazon.com, Inc. or its affiliates");
+MODULE_DESCRIPTION("Nitro Enclaves Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 6654cc8a1bc3..b9c1de41e300 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -523,8 +523,18 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ne_devs.ne_pci_dev = ne_pci_dev;
 
+	rc = misc_register(ne_devs.ne_misc_dev);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error in misc dev register [rc=%d]\n", rc);
+
+		goto disable_ne_pci_dev;
+	}
+
 	return 0;
 
+disable_ne_pci_dev:
+	ne_devs.ne_pci_dev = NULL;
+	ne_pci_dev_disable(pdev);
 teardown_msix:
 	ne_teardown_msix(pdev);
 iounmap_pci_bar:
@@ -550,6 +560,8 @@ static void ne_pci_remove(struct pci_dev *pdev)
 {
 	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
 
+	misc_deregister(ne_devs.ne_misc_dev);
+
 	ne_devs.ne_pci_dev = NULL;
 
 	ne_pci_dev_disable(pdev);
@@ -580,6 +592,8 @@ static void ne_pci_shutdown(struct pci_dev *pdev)
 	if (!ne_pci_dev)
 		return;
 
+	misc_deregister(ne_devs.ne_misc_dev);
+
 	ne_devs.ne_pci_dev = NULL;
 
 	ne_pci_dev_disable(pdev);
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

