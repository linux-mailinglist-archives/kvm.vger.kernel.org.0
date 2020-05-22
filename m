Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4AE1DDFE4
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 08:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgEVGba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 02:31:30 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:8296 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbgEVGb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 02:31:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590129088; x=1621665088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1DHL97KDrr4JedjALnLaMkYmTHR9Yl9qB1A7Hs79j1Y=;
  b=IqMJn2O9AC9sps5L3a4dbfvxIwiXdnYxggiZLZQcjrXpnDiQaD2lAm1n
   h1BWxTm0aMeSqsf51LuaxTV6r6skerIiVBJbg757WaFlbq9kaRgw/m1VZ
   nswS4VKJZ55bQyQXlwRDmCLCBoSeNKGsDxHsGI2xEKfNFCnGKG/3Itnw+
   Q=;
IronPort-SDR: 2EF+aUzhiiGEW/6TzHcybXWTbTQ59RmANHWpsZL4ZK9OpdPTP3zVpSIQiuOzcFsY4NaoG4lyN4
 81hW7UQipCYA==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="46675022"
Received: from sea32-co-svc-lb4-vlan2.sea.corp.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.47.23.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 22 May 2020 06:31:28 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id 17BC4A2587;
        Fri, 22 May 2020 06:31:26 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:31:25 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.50) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:31:15 +0000
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
Subject: [PATCH v2 09/18] nitro_enclaves: Add logic for enclave vcpu creation
Date:   Fri, 22 May 2020 09:29:37 +0300
Message-ID: <20200522062946.28973-10-andraprs@amazon.com>
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

An enclave, before being started, has its resources set. One of its
resources is CPU.

Add ioctl command logic for enclave vCPU creation. Return as result a
file descriptor that is associated with the enclave vCPU.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 223 ++++++++++++++++++++++
 1 file changed, 223 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 1036221238f4..8cf262ac1bbc 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -63,6 +63,183 @@ struct ne_cpu_pool {
 
 static struct ne_cpu_pool ne_cpu_pool;
 
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
+	if (WARN_ON(!ne_enclave))
+		return -EINVAL;
+
+	if (!vcpu_id)
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
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	/* Choose any CPU from the available CPU pool. */
+	cpu = cpumask_any(ne_cpu_pool.avail);
+	if (cpu >= nr_cpu_ids) {
+		pr_err_ratelimited(NE "No CPUs available in CPU pool\n");
+
+		mutex_unlock(&ne_cpu_pool.mutex);
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
+	mutex_unlock(&ne_cpu_pool.mutex);
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
+	if (WARN_ON(!ne_enclave) || WARN_ON(!ne_enclave->pdev))
+		return -EINVAL;
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
+		pr_err_ratelimited(NE "Error in getting unused fd [rc=%d]\n",
+				   rc);
+
+		goto free_ne_vcpu_id;
+	}
+
+	/* TODO: Include (vcpu) id in the ne-vm-vcpu naming. */
+	file = anon_inode_getfile("ne-vm-vcpu", &ne_enclave_vcpu_fops,
+				  ne_enclave, O_RDWR);
+	if (IS_ERR(file)) {
+		rc = PTR_ERR(file);
+
+		pr_err_ratelimited(NE "Error in anon inode get file [rc=%d]\n",
+				   rc);
+
+		goto put_fd;
+	}
+
+	slot_add_vcpu_req.slot_uid = ne_enclave->slot_uid;
+	slot_add_vcpu_req.vcpu_id = vcpu_id;
+
+	rc = ne_do_request(ne_enclave->pdev, SLOT_ADD_VCPU, &slot_add_vcpu_req,
+			   sizeof(slot_add_vcpu_req), &cmd_reply,
+			   sizeof(cmd_reply));
+	if (rc < 0) {
+		pr_err_ratelimited(NE "Error in slot add vcpu [rc=%d]\n", rc);
+
+		goto put_file;
+	}
+
+	ne_vcpu_id->vcpu_id = vcpu_id;
+
+	list_add(&ne_vcpu_id->vcpu_id_list_entry, &ne_enclave->vcpu_ids_list);
+
+	ne_enclave->nr_vcpus++;
+
+	fd_install(fd, file);
+
+	return fd;
+
+put_file:
+	fput(file);
+put_fd:
+	put_unused_fd(fd);
+free_ne_vcpu_id:
+	kzfree(ne_vcpu_id);
+
+	return rc;
+}
+
 static int ne_enclave_open(struct inode *node, struct file *file)
 {
 	return 0;
@@ -71,7 +248,53 @@ static int ne_enclave_open(struct inode *node, struct file *file)
 static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
 			     unsigned long arg)
 {
+	struct ne_enclave *ne_enclave = file->private_data;
+
+	if (WARN_ON(!ne_enclave))
+		return -EINVAL;
+
 	switch (cmd) {
+	case KVM_CREATE_VCPU: {
+		int rc = -EINVAL;
+		u32 vcpu_id = 0;
+
+		if (copy_from_user(&vcpu_id, (void *)arg, sizeof(vcpu_id))) {
+			pr_err_ratelimited(NE "Error in copy from user\n");
+
+			return -EFAULT;
+		}
+
+		mutex_lock(&ne_enclave->enclave_info_mutex);
+
+		if (ne_enclave->state != NE_STATE_INIT) {
+			pr_err_ratelimited(NE "Enclave isn't in init state\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -EINVAL;
+		}
+
+		/* Use the CPU pool for choosing a CPU for the enclave. */
+		rc = ne_get_cpu_from_cpu_pool(ne_enclave, &vcpu_id);
+		if (rc < 0) {
+			pr_err_ratelimited(NE "Error in get CPU from pool\n");
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

