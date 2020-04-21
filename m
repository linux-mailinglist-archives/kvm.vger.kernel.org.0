Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422881B2F60
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgDUSn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:43:28 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:62436 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729562AbgDUSn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:43:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494606; x=1619030606;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3HnYBZCPpA+K5LQ93akasa4zhaILbgx153AkIWoMXFg=;
  b=BPFAjdJeOPRnOqNlbWcsUgVveavAS4RPjYU6Uzz/zeRSRVty712Bkwuh
   ElBWGQ7Lq6EUdJFyrUapL9lsX4ZKK8t7rIJ1KeurrCgP+RBJCP2DjYkMU
   2ARCDaUx27wBWQQtGIeJA8vpwu1/ktOD1kbTNdvlxVBeSbVqcgtqRzBd1
   A=;
IronPort-SDR: KQLCPE4wIHrA2RmT9SQMuj1c8weUr9lG/uYzm3aJclaM5Vg4m0Q6ykEj/gn8Q8e/RDkfC3g3dI
 DwY07vFhlmJw==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="39978538"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Apr 2020 18:43:25 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 8FBAD226806;
        Tue, 21 Apr 2020 18:43:24 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:43:23 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:43:14 +0000
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
Subject: [PATCH v1 09/15] nitro_enclaves: Add logic for enclave vcpu creation
Date:   Tue, 21 Apr 2020 21:41:44 +0300
Message-ID: <20200421184150.68011-10-andraprs@amazon.com>
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

An enclave, before being started, has its resources set. One of its
resources is CPU.

Add ioctl command logic for enclave vCPU creation. Return as result a
file descriptor that is associated with the enclave vCPU.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 .../virt/amazon/nitro_enclaves/ne_misc_dev.c  | 210 ++++++++++++++++++
 1 file changed, 210 insertions(+)

diff --git a/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c b/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
index abbebc7718c2..c9acdfd63daf 100644
--- a/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
@@ -60,6 +60,179 @@ static struct ne_cpu_pool ne_cpu_pool;
 
 static struct mutex ne_cpu_pool_mutex;
 
+static int ne_enclave_vcpu_open(struct inode *node, struct file *file)
+{
+	return 0;
+}
+
+static long ne_enclave_vcpu_ioctl(struct file *file, unsigned int cmd,
+				  unsigned long arg)
+{
+	switch (cmd) {
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static int ne_enclave_vcpu_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static const struct file_operations ne_enclave_vcpu_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= noop_llseek,
+	.unlocked_ioctl	= ne_enclave_vcpu_ioctl,
+	.open		= ne_enclave_vcpu_open,
+	.release	= ne_enclave_vcpu_release,
+};
+
+/**
+ * ne_get_cpu_from_cpu_pool - Get a CPU from the CPU pool, if it is set.
+ *
+ * This function gets called with the ne_enclave mutex held.
+ *
+ * @ne_enclave: private data associated with the current enclave.
+ * @vcpu_id: id of the CPU to be associated with the given slot, apic id on x86.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_get_cpu_from_cpu_pool(struct ne_enclave *ne_enclave, u32 *vcpu_id)
+{
+	unsigned int cpu = 0;
+	unsigned int cpu_sibling = 0;
+
+	BUG_ON(!ne_enclave);
+
+	if (WARN_ON(!vcpu_id))
+		return -EINVAL;
+
+	/* There are CPU siblings available to choose from. */
+	cpu = cpumask_any(ne_enclave->cpu_siblings);
+	if (cpu < nr_cpu_ids) {
+		cpumask_clear_cpu(cpu, ne_enclave->cpu_siblings);
+
+		*vcpu_id = cpu;
+
+		return 0;
+	}
+
+	mutex_lock(&ne_cpu_pool_mutex);
+
+	/* Choose any CPU from the available CPU pool. */
+	cpu = cpumask_any(ne_cpu_pool.avail);
+	if (cpu >= nr_cpu_ids) {
+		pr_err_ratelimited("No CPUs available in CPU pool\n");
+
+		mutex_unlock(&ne_cpu_pool_mutex);
+
+		return -EINVAL;
+	}
+
+	cpumask_clear_cpu(cpu, ne_cpu_pool.avail);
+
+	/*
+	 * Make sure the CPU siblings are not marked as
+	 * available anymore.
+	 */
+	for_each_cpu(cpu_sibling, topology_sibling_cpumask(cpu)) {
+		if (cpu_sibling != cpu) {
+			cpumask_clear_cpu(cpu_sibling, ne_cpu_pool.avail);
+
+			cpumask_set_cpu(cpu_sibling, ne_enclave->cpu_siblings);
+		}
+	}
+
+	mutex_unlock(&ne_cpu_pool_mutex);
+
+	*vcpu_id = cpu;
+
+	return 0;
+}
+
+/**
+ * ne_create_vcpu_ioctl - Add vCPU to the slot associated with the current
+ * enclave. Create vCPU file descriptor to be further used for CPU handling.
+ *
+ * This function gets called with the ne_enclave mutex held.
+ *
+ * @ne_enclave: private data associated with the current enclave.
+ * @vcpu_id: id of the CPU to be associated with the given slot, apic id on x86.
+ *
+ * @returns: vCPU fd on success, negative return value on failure.
+ */
+static int ne_create_vcpu_ioctl(struct ne_enclave *ne_enclave, u32 vcpu_id)
+{
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	int fd = 0;
+	struct file *file = NULL;
+	struct ne_vcpu_id *ne_vcpu_id = NULL;
+	int rc = -EINVAL;
+	struct slot_add_vcpu_req slot_add_vcpu_req = {};
+
+	BUG_ON(!ne_enclave);
+	BUG_ON(!ne_enclave->pdev);
+
+	if (ne_enclave->mm != current->mm)
+		return -EIO;
+
+	ne_vcpu_id = kzalloc(sizeof(*ne_vcpu_id), GFP_KERNEL);
+	if (!ne_vcpu_id)
+		return -ENOMEM;
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0) {
+		rc = fd;
+
+		pr_err_ratelimited("Failure in getting unused fd [rc=%d]\n",
+				   rc);
+
+		goto err_get_unused_fd;
+	}
+
+	/* TODO: Include (vcpu) id in the ne-vm-vcpu naming. */
+	file = anon_inode_getfile("ne-vm-vcpu", &ne_enclave_vcpu_fops,
+				  ne_enclave, O_RDWR);
+	if (IS_ERR(file)) {
+		rc = PTR_ERR(file);
+
+		pr_err_ratelimited("Failure in anon inode get file [rc=%d]\n",
+				   rc);
+
+		goto err_anon_inode_getfile;
+	}
+
+	slot_add_vcpu_req.slot_uid = ne_enclave->slot_uid;
+	slot_add_vcpu_req.vcpu_id = vcpu_id;
+
+	rc = ne_do_request(ne_enclave->pdev, SLOT_ADD_VCPU, &slot_add_vcpu_req,
+			   sizeof(slot_add_vcpu_req), &cmd_reply,
+			   sizeof(cmd_reply));
+	if (rc < 0) {
+		pr_err_ratelimited("Failure in slot add vcpu [rc=%d]\n", rc);
+
+		goto err_slot_add_vcpu;
+	}
+
+	ne_vcpu_id->vcpu_id = vcpu_id;
+
+	list_add(&ne_vcpu_id->vcpu_id_list_entry, &ne_enclave->vcpu_ids_list);
+
+	fd_install(fd, file);
+
+	return fd;
+
+err_slot_add_vcpu:
+	fput(file);
+err_anon_inode_getfile:
+	put_unused_fd(fd);
+err_get_unused_fd:
+	kzfree(ne_vcpu_id);
+	return rc;
+}
+
 static int ne_enclave_open(struct inode *node, struct file *file)
 {
 	return 0;
@@ -68,7 +241,44 @@ static int ne_enclave_open(struct inode *node, struct file *file)
 static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
 			     unsigned long arg)
 {
+	struct ne_enclave *ne_enclave = file->private_data;
+
+	BUG_ON(!ne_enclave);
+
 	switch (cmd) {
+	case KVM_CREATE_VCPU: {
+		int rc = -EINVAL;
+		u32 vcpu_id = 0;
+
+		if (copy_from_user(&vcpu_id, (void *)arg, sizeof(vcpu_id))) {
+			pr_err_ratelimited("Failure in copy from user\n");
+
+			return -EFAULT;
+		}
+
+		mutex_lock(&ne_enclave->enclave_info_mutex);
+
+		/* Use the CPU pool for choosing a CPU for the enclave. */
+		rc = ne_get_cpu_from_cpu_pool(ne_enclave, &vcpu_id);
+		if (rc < 0) {
+			pr_err_ratelimited("Failure in get CPU from pool\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -EINVAL;
+		}
+
+		rc = ne_create_vcpu_ioctl(ne_enclave, vcpu_id);
+
+		/* Put back the CPU in enclave cpu pool, if add vcpu error. */
+		if (rc < 0)
+			cpumask_set_cpu(vcpu_id, ne_enclave->cpu_siblings);
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		return rc;
+	}
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

