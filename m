Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184D71B2F59
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgDUSnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:43:10 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:62367 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729542AbgDUSnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:43:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494588; x=1619030588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dnaTm1aF+1cLi/7DGn/IqxJTYcFCqrkiSr63xiWSCiw=;
  b=g7G4nI2lIREJhnV7emZuBPoEw/KX/UDwbE9Uoqx2O7DLChbRKQO8X1F9
   lgVDqE5/O6H/Osd3YX4WGWhgmBw1Occhq/+9P96ckM7r7BNhSiu+B6toB
   /7NnBr/79CmMi97TogLZGqBDyUB91fu76K2BRyUFteUNKswsmV5lkRYwM
   Y=;
IronPort-SDR: QdqEgfSxVuT0T2BMhPVvqLkO1BJBGznv7qxXLC50KC3eSOnm1hiYsqM0GSlwiHQT7QRSEE5hqn
 wjZ9YR5e2J7Q==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="39978497"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Apr 2020 18:43:08 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id A704DA06EE;
        Tue, 21 Apr 2020 18:43:07 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:43:07 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:42:58 +0000
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
Subject: [PATCH v1 07/15] nitro_enclaves: Init misc device providing the ioctl interface
Date:   Tue, 21 Apr 2020 21:41:42 +0300
Message-ID: <20200421184150.68011-8-andraprs@amazon.com>
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

The Nitro Enclaves driver provides an ioctl interface to the user space
for enclave lifetime management e.g. enclave creation / termination and
setting enclave resources such as memory and CPU.

This ioctl interface is mapped to a Nitro Enclaves misc device.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 .../virt/amazon/nitro_enclaves/ne_misc_dev.c  | 174 ++++++++++++++++++
 .../virt/amazon/nitro_enclaves/ne_pci_dev.c   |  13 ++
 2 files changed, 187 insertions(+)
 create mode 100644 drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c

diff --git a/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c b/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
new file mode 100644
index 000000000000..d22a76ed07e5
--- /dev/null
+++ b/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
@@ -0,0 +1,174 @@
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
+#define NE_DEV_NAME "nitro_enclaves"
+
+#define MIN_MEM_REGION_SIZE (2 * 1024UL * 1024UL)
+
+static char *ne_cpus;
+module_param(ne_cpus, charp, 0644);
+MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclaves");
+
+/* CPU pool used for Nitro Enclaves. */
+struct ne_cpu_pool {
+	/* Available CPUs in the pool. */
+	cpumask_var_t avail;
+};
+
+static struct ne_cpu_pool ne_cpu_pool;
+
+static struct mutex ne_cpu_pool_mutex;
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
+	.mode	= 0664,
+};
+
+static int __init ne_init(void)
+{
+	unsigned int cpu = 0;
+	int rc = -EINVAL;
+
+	memset(&ne_cpu_pool, 0, sizeof(ne_cpu_pool));
+
+	if (!zalloc_cpumask_var(&ne_cpu_pool.avail, GFP_KERNEL))
+		return -ENOMEM;
+
+	mutex_init(&ne_cpu_pool_mutex);
+
+	rc = cpulist_parse(ne_cpus, ne_cpu_pool.avail);
+	if (rc < 0) {
+		pr_err_ratelimited("Failure in cpulist parse [rc=%d]\n", rc);
+
+		goto err_cpulist_parse;
+	}
+
+	for_each_cpu(cpu, ne_cpu_pool.avail) {
+		rc = remove_cpu(cpu);
+		if (rc != 0) {
+			pr_err_ratelimited("Failure in cpu=%d remove [rc=%d]\n",
+					   cpu, rc);
+
+			goto err_remove_cpu;
+		}
+	}
+
+	rc = pci_register_driver(&ne_pci_driver);
+	if (rc < 0) {
+		pr_err_ratelimited("Failure in pci register driver [rc=%d]\n",
+				   rc);
+
+		goto err_pci_register_driver;
+	}
+
+	return 0;
+
+err_pci_register_driver:
+err_remove_cpu:
+	for_each_cpu(cpu, ne_cpu_pool.avail)
+		add_cpu(cpu);
+err_cpulist_parse:
+	free_cpumask_var(ne_cpu_pool.avail);
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
+		if (WARN_ON(rc != 0))
+			pr_err_ratelimited("Failure in cpu=%d add [rc=%d]\n",
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
diff --git a/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c b/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
index 884acbb92305..19b3836b08f4 100644
--- a/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
@@ -593,6 +593,15 @@ static int ne_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_ne_pci_dev_enable;
 	}
 
+	rc = misc_register(&ne_miscdevice);
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Failure in misc dev register [rc=%d]\n",
+				    rc);
+
+		goto err_misc_register;
+	}
+
 	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
 	init_waitqueue_head(&ne_pci_dev->cmd_reply_wait_q);
 	INIT_LIST_HEAD(&ne_pci_dev->enclaves_list);
@@ -603,6 +612,8 @@ static int ne_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+err_misc_register:
+	ne_pci_dev_disable(pdev, ne_pci_dev);
 err_ne_pci_dev_enable:
 err_ne_pci_dev_disable:
 	free_irq(pci_irq_vector(pdev, NE_VEC_EVENT), ne_pci_dev);
@@ -627,6 +638,8 @@ static void ne_remove(struct pci_dev *pdev)
 	if (!ne_pci_dev || !ne_pci_dev->iomem_base)
 		return;
 
+	misc_deregister(&ne_miscdevice);
+
 	ne_pci_dev_disable(pdev, ne_pci_dev);
 
 	pci_set_drvdata(pdev, NULL);
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

