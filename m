Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E7E1DDFDF
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 08:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgEVGbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 02:31:14 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:20657 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728439AbgEVGbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 02:31:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590129070; x=1621665070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kUqB74ao4cKMBkg75oPcYgcRcd1MtSxGoDTgZYPITEc=;
  b=IGhRcXvcG6mGftJAezLfuSm4ruiNTvvH4HGsYWmQ1Weo0ErwDBYQZ8oG
   FYGWfWcp0Oj8Qa4mDoI0DX7vI8IMKtxCY8HPsVsU078ga7TZtekfngSwP
   MO8cSSffth3490yybtohMoaSpNFS0Zdw3W5JVg1ceBLOsN9B+XXbKmSfR
   A=;
IronPort-SDR: B2vOXkIoQT6uiv4Iv7pzn8SU2LmPombwHceIx/pk4IJrtgBCl/ntiML5tTKNWYf8l71QwbuWVh
 37Fl7/3P5fIw==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="31775418"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 May 2020 06:31:10 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id EC775A26AC;
        Fri, 22 May 2020 06:31:07 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:31:07 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.50) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:30:58 +0000
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
Subject: [PATCH v2 07/18] nitro_enclaves: Init misc device providing the ioctl interface
Date:   Fri, 22 May 2020 09:29:35 +0300
Message-ID: <20200522062946.28973-8-andraprs@amazon.com>
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

The Nitro Enclaves driver provides an ioctl interface to the user space
for enclave lifetime management e.g. enclave creation / termination and
setting enclave resources such as memory and CPU.

This ioctl interface is mapped to a Nitro Enclaves misc device.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 196 ++++++++++++++++++++++
 drivers/virt/nitro_enclaves/ne_pci_dev.c  |  13 ++
 2 files changed, 209 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.c

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
new file mode 100644
index 000000000000..e1866fac8220
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+/**
+ * Enclave lifetime management driver for Nitro Enclaves (NE).
+ * Nitro is a hypervisor that has been developed by Amazon.
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/bug.h>
+#include <linux/cpu.h>
+#include <linux/device.h>
+#include <linux/file.h>
+#include <linux/hugetlb.h>
+#include <linux/kvm_host.h>
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
+#define MIN_MEM_REGION_SIZE (2 * 1024UL * 1024UL)
+
+#define NE "nitro_enclaves: "
+
+#define NE_DEV_NAME "nitro_enclaves"
+
+#define NE_IMAGE_LOAD_OFFSET (8 * 1024UL * 1024UL)
+
+static char *ne_cpus;
+module_param(ne_cpus, charp, 0644);
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
+static int ne_open(struct inode *node, struct file *file)
+{
+	return 0;
+}
+
+static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static int ne_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static const struct file_operations ne_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= noop_llseek,
+	.unlocked_ioctl	= ne_ioctl,
+	.open		= ne_open,
+	.release	= ne_release,
+};
+
+struct miscdevice ne_miscdevice = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= NE_DEV_NAME,
+	.fops	= &ne_fops,
+	.mode	= 0660,
+};
+
+static int __init ne_init(void)
+{
+	unsigned int cpu = 0;
+	unsigned int cpu_sibling = 0;
+	int rc = -EINVAL;
+
+	memset(&ne_cpu_pool, 0, sizeof(ne_cpu_pool));
+
+	if (!zalloc_cpumask_var(&ne_cpu_pool.avail, GFP_KERNEL))
+		return -ENOMEM;
+
+	mutex_init(&ne_cpu_pool.mutex);
+
+	rc = cpulist_parse(ne_cpus, ne_cpu_pool.avail);
+	if (rc < 0) {
+		pr_err_ratelimited(NE "Error in cpulist parse [rc=%d]\n", rc);
+
+		goto free_cpumask;
+	}
+
+	/*
+	 * Check if CPU siblings are included in the provided CPU pool. The
+	 * expectation is that CPU cores are made available in the CPU pool for
+	 * enclaves.
+	 */
+	for_each_cpu(cpu, ne_cpu_pool.avail) {
+		for_each_cpu(cpu_sibling, topology_sibling_cpumask(cpu)) {
+			if (!cpumask_test_cpu(cpu_sibling, ne_cpu_pool.avail)) {
+				pr_err_ratelimited(NE "CPU %d is not in pool\n",
+						   cpu_sibling);
+
+				rc = -EINVAL;
+
+				goto free_cpumask;
+			}
+		}
+	}
+
+	for_each_cpu(cpu, ne_cpu_pool.avail) {
+		rc = remove_cpu(cpu);
+		if (rc != 0) {
+			pr_err_ratelimited(NE "CPU %d not offlined [rc=%d]\n",
+					   cpu, rc);
+
+			goto online_cpus;
+		}
+	}
+
+	rc = pci_register_driver(&ne_pci_driver);
+	if (rc < 0) {
+		pr_err_ratelimited(NE "Error in pci register driver [rc=%d]\n",
+				   rc);
+
+		goto online_cpus;
+	}
+
+	return 0;
+
+online_cpus:
+	for_each_cpu(cpu, ne_cpu_pool.avail)
+		add_cpu(cpu);
+free_cpumask:
+	free_cpumask_var(ne_cpu_pool.avail);
+
+	return rc;
+}
+
+static void __exit ne_exit(void)
+{
+	unsigned int cpu = 0;
+	int rc = -EINVAL;
+
+	pci_unregister_driver(&ne_pci_driver);
+
+	if (!ne_cpu_pool.avail)
+		return;
+
+	for_each_cpu(cpu, ne_cpu_pool.avail) {
+		rc = add_cpu(cpu);
+		if (rc != 0)
+			pr_err_ratelimited(NE "CPU %d not onlined [rc=%d]\n",
+					   cpu, rc);
+	}
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
index cd2012d9b365..7b23262f8c35 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -647,6 +647,15 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto teardown_msix;
 	}
 
+	rc = misc_register(&ne_miscdevice);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    NE "Error in misc dev register [rc=%d]\n",
+				    rc);
+
+		goto disable_ne_pci_dev;
+	}
+
 	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
 	init_waitqueue_head(&ne_pci_dev->cmd_reply_wait_q);
 	INIT_LIST_HEAD(&ne_pci_dev->enclaves_list);
@@ -655,6 +664,8 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+disable_ne_pci_dev:
+	ne_pci_dev_disable(pdev);
 teardown_msix:
 	ne_teardown_msix(pdev);
 iounmap_pci_bar:
@@ -677,6 +688,8 @@ static void ne_pci_remove(struct pci_dev *pdev)
 	if (!ne_pci_dev || !ne_pci_dev->iomem_base)
 		return;
 
+	misc_deregister(&ne_miscdevice);
+
 	ne_pci_dev_disable(pdev);
 
 	ne_teardown_msix(pdev);
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

