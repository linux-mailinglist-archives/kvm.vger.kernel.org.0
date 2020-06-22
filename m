Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83E42040ED
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgFVUFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:05:20 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:28289 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728421AbgFVUFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:05:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1592856318; x=1624392318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zJ/mpS1KNYBbpHt+fXmoUl0xoEJ53iFERx3+rx1Ejgw=;
  b=i/dL+Wi/NaihNaSe/ekxJjK4u+L3kznHDgqOB0Nb2qWk3cpRIwYAXy3f
   HgYQef5KxgWclas+kyDk1jUJfGqKpSlGicM24km7+RX5IXwIf0qYpVaIi
   lONsFqYY98wCvJeY6NMv+HCNdH6jae0BEn7DSqek/QQIXzqt1RUByd8xE
   U=;
IronPort-SDR: AbS/av5pGX0GQjmEAr6+PUI8BS3066d821w92zGtHSZqG+Z3TzTAKb+tKyXpRJoWSVYUIXrZmV
 thvfI5qxXr6g==
X-IronPort-AV: E=Sophos;i="5.75,268,1589241600"; 
   d="scan'208";a="39151190"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 22 Jun 2020 20:05:16 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 1FE36A2375;
        Mon, 22 Jun 2020 20:05:15 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:05:14 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:05:04 +0000
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
Subject: [PATCH v4 09/18] nitro_enclaves: Add logic for enclave vcpu creation
Date:   Mon, 22 Jun 2020 23:03:20 +0300
Message-ID: <20200622200329.52996-10-andraprs@amazon.com>
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

An enclave, before being started, has its resources set. One of its
resources is CPU.

The NE CPU pool is set for choosing CPUs for enclaves from it. Offline
the CPUs from the NE CPU pool during the pool setup and online them back
during the NE CPU pool teardown.

The enclave CPUs need to be full cores and from the same NUMA node. CPU
0 and its siblings have to remain available to the primary / parent VM.

Add ioctl command logic for enclave vCPU creation. Return as result a
file descriptor that is associated with the enclave vCPU.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v3 -> v4

* Setup the NE CPU pool at runtime via a sysfs file for the kernel
  parameter.
* Check enclave CPUs to be from the same NUMA node.
* Use dev_err instead of custom NE log pattern.
* Update the NE ioctl call to match the decoupling from the KVM API.

v2 -> v3

* Remove the WARN_ON calls.
* Update static calls sanity checks.
* Update kzfree() calls to kfree().
* Remove file ops that do nothing for now - open, ioctl and release.

v1 -> v2

* Add log pattern for NE.
* Update goto labels to match their purpose.
* Remove the BUG_ON calls.
* Check if enclave state is init when setting enclave vcpu.
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 491 ++++++++++++++++++++++
 1 file changed, 491 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index f70496813033..d6777008f685 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -39,7 +39,11 @@
  * TODO: Update logic to create new sysfs entries instead of using
  * a kernel parameter e.g. if multiple sysfs files needed.
  */
+static int ne_set_kernel_param(const char *val, const struct kernel_param *kp);
+
 static const struct kernel_param_ops ne_cpu_pool_ops = {
+	.get = param_get_string,
+	.set = ne_set_kernel_param,
 };
 
 static char ne_cpus[PAGE_SIZE];
@@ -60,6 +64,485 @@ struct ne_cpu_pool {
 
 static struct ne_cpu_pool ne_cpu_pool;
 
+static const struct file_operations ne_enclave_vcpu_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= noop_llseek,
+};
+
+/**
+ * ne_check_enclaves_created - Verify if at least one enclave has been created.
+ *
+ * @pdev: PCI device used for enclave lifetime management.
+ *
+ * @returns: true if at least one enclave is created, false otherwise.
+ */
+static bool ne_check_enclaves_created(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+
+	if (!ne_pci_dev)
+		return false;
+
+	mutex_lock(&ne_pci_dev->enclaves_list_mutex);
+
+	if (list_empty(&ne_pci_dev->enclaves_list)) {
+		mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+		return false;
+	}
+
+	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+	return true;
+}
+
+/**
+ * ne_setup_cpu_pool - Set the NE CPU pool after handling sanity checks such as
+ * not sharing CPU cores with the primary / parent VM or not using CPU 0, which
+ * should remain available for the primary / parent VM. Offline the CPUs from
+ * the pool after the checks passed.
+ *
+ * @pdev: PCI device used for enclave lifetime management.
+ * @ne_cpu_list: the CPU list used for setting NE CPU pool.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_setup_cpu_pool(struct pci_dev *pdev, const char *ne_cpu_list)
+{
+	unsigned int cpu = 0;
+	unsigned int cpu_sibling = 0;
+	int numa_node = -1;
+	int rc = -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		dev_err(&pdev->dev, "No admin capability for CPU pool setup\n");
+
+		return -EPERM;
+	}
+
+	if (!ne_cpu_list)
+		return 0;
+
+	if (ne_check_enclaves_created(pdev)) {
+		dev_err(&pdev->dev, "The CPU pool is used, enclaves created\n");
+
+		return -EINVAL;
+	}
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	rc = cpulist_parse(ne_cpu_list, ne_cpu_pool.avail);
+	if (rc < 0) {
+		dev_err(&pdev->dev,
+			"Error in cpulist parse [rc=%d]\n", rc);
+
+		goto unlock_mutex;
+	}
+
+	/*
+	 * Check if CPU 0 and its siblings are included in the provided CPU pool
+	 * They should remain available for the primary / parent VM.
+	 */
+	if (cpumask_test_cpu(0, ne_cpu_pool.avail)) {
+
+		dev_err(&pdev->dev,
+			"CPU 0 has to remain available for the primary VM\n");
+
+		rc = -EINVAL;
+
+		goto unlock_mutex;
+	}
+
+	for_each_cpu(cpu_sibling, topology_sibling_cpumask(0)) {
+		if (cpumask_test_cpu(cpu_sibling, ne_cpu_pool.avail)) {
+			dev_err(&pdev->dev,
+				"CPU sibling %d of CPU 0 is in the CPU pool\n",
+				cpu_sibling);
+
+			rc = -EINVAL;
+
+			goto unlock_mutex;
+		}
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
+				dev_err(&pdev->dev,
+					"CPU %d is not in the CPU pool\n",
+					cpu_sibling);
+
+				rc = -EINVAL;
+
+				goto unlock_mutex;
+			}
+		}
+	}
+
+	/*
+	 * Check if the CPUs from the NE CPU pool are from the same NUMA node.
+	 */
+	for_each_cpu(cpu, ne_cpu_pool.avail) {
+		if (numa_node < 0) {
+			numa_node = cpu_to_node(cpu);
+
+			if (numa_node < 0) {
+				dev_err(&pdev->dev,
+					"Invalid NUMA node %d\n", numa_node);
+
+				rc = -EINVAL;
+
+				goto unlock_mutex;
+			}
+		} else {
+			if (numa_node != cpu_to_node(cpu)) {
+				dev_err(&pdev->dev,
+					"CPUs are from different NUMA nodes\n");
+
+				rc = -EINVAL;
+
+				goto unlock_mutex;
+			}
+		}
+	}
+
+	for_each_cpu(cpu, ne_cpu_pool.avail) {
+		rc = remove_cpu(cpu);
+		if (rc != 0) {
+			dev_err(&pdev->dev,
+				"CPU %d is not offlined [rc=%d]\n", cpu, rc);
+
+			goto online_cpus;
+		}
+	}
+
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	return 0;
+
+online_cpus:
+	for_each_cpu(cpu, ne_cpu_pool.avail)
+		add_cpu(cpu);
+unlock_mutex:
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	return rc;
+}
+
+/**
+ * ne_teardown_cpu_pool - Online the CPUs from the NE CPU pool and cleanup the
+ * CPU pool.
+ *
+ * @pdev: PCI device used for enclave lifetime management.
+ */
+static void ne_teardown_cpu_pool(struct pci_dev *pdev)
+{
+	unsigned int cpu = 0;
+	int rc = -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		dev_err(&pdev->dev, "No admin capability for CPU pool setup\n");
+
+		return;
+	}
+
+	if (!ne_cpu_pool.avail)
+		return;
+
+	if (ne_check_enclaves_created(pdev)) {
+		dev_err(&pdev->dev, "The CPU pool is used, enclaves created\n");
+
+		return;
+	}
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	for_each_cpu(cpu, ne_cpu_pool.avail) {
+		rc = add_cpu(cpu);
+		if (rc != 0)
+			dev_err(&pdev->dev,
+				"CPU %d is not onlined [rc=%d]\n", cpu, rc);
+	}
+
+	cpumask_clear(ne_cpu_pool.avail);
+
+	mutex_unlock(&ne_cpu_pool.mutex);
+}
+
+static int ne_set_kernel_param(const char *val, const struct kernel_param *kp)
+{
+	const char *ne_cpu_list = val;
+	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_AMAZON,
+					      PCI_DEVICE_ID_NE, NULL);
+	int rc = -EINVAL;
+
+	if (!pdev)
+		return -ENODEV;
+
+	ne_teardown_cpu_pool(pdev);
+
+	rc = ne_setup_cpu_pool(pdev, ne_cpu_list);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error in setup CPU pool [rc=%d]\n", rc);
+
+		return rc;
+	}
+
+	return param_set_copystring(val, kp);
+}
+
+/**
+ * ne_get_cpu_from_cpu_pool - Get a CPU from the CPU pool. If the vCPU id is 0,
+ * the CPU is autogenerated and chosen from the NE CPU pool.
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
+	if (*vcpu_id != 0) {
+		if (cpumask_test_cpu(*vcpu_id, ne_enclave->cpu_siblings)) {
+			cpumask_clear_cpu(*vcpu_id, ne_enclave->cpu_siblings);
+
+			return 0;
+		}
+
+		mutex_lock(&ne_cpu_pool.mutex);
+
+		if (!cpumask_test_cpu(*vcpu_id, ne_cpu_pool.avail)) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "CPU %d is not in NE CPU pool\n",
+					    *vcpu_id);
+
+			mutex_unlock(&ne_cpu_pool.mutex);
+
+			return -EINVAL;
+		}
+
+		cpumask_clear_cpu(*vcpu_id, ne_cpu_pool.avail);
+
+		/*
+		 * Make sure the CPU siblings are not marked as available
+		 * anymore.
+		 */
+		for_each_cpu(cpu_sibling, topology_sibling_cpumask(*vcpu_id)) {
+			if (cpu_sibling != *vcpu_id) {
+				cpumask_clear_cpu(cpu_sibling,
+						  ne_cpu_pool.avail);
+
+				cpumask_set_cpu(cpu_sibling,
+						ne_enclave->cpu_siblings);
+			}
+		}
+
+		mutex_unlock(&ne_cpu_pool.mutex);
+
+		return 0;
+	}
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
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "No CPUs available in CPU pool\n");
+
+		mutex_unlock(&ne_cpu_pool.mutex);
+
+		return -EINVAL;
+	}
+
+	cpumask_clear_cpu(cpu, ne_cpu_pool.avail);
+
+	/* Make sure the CPU siblings are not marked as available anymore. */
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
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Error in getting unused fd [rc=%d]\n", rc);
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
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Error in anon inode get file [rc=%d]\n",
+				    rc);
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
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Error in slot add vcpu [rc=%d]\n", rc);
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
+	kfree(ne_vcpu_id);
+
+	return rc;
+}
+
+static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	struct ne_enclave *ne_enclave = file->private_data;
+
+	if (!ne_enclave || !ne_enclave->pdev)
+		return -EINVAL;
+
+	switch (cmd) {
+	case NE_CREATE_VCPU: {
+		int rc = -EINVAL;
+		u32 vcpu_id = 0;
+
+		if (copy_from_user(&vcpu_id, (void *)arg, sizeof(vcpu_id))) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Error in copy from user\n");
+
+			return -EFAULT;
+		}
+
+		mutex_lock(&ne_enclave->enclave_info_mutex);
+
+		if (ne_enclave->state != NE_STATE_INIT) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Enclave isn't in init state\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -EINVAL;
+		}
+
+		/* Use the CPU pool for choosing a CPU for the enclave. */
+		rc = ne_get_cpu_from_cpu_pool(ne_enclave, &vcpu_id);
+		if (rc < 0) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Error in get CPU from pool\n");
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
+		if (copy_to_user((void *)arg, &vcpu_id, sizeof(vcpu_id))) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Error in copy to user\n");
+
+			return -EFAULT;
+		}
+
+		return rc;
+	}
+
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
 static __poll_t ne_enclave_poll(struct file *file, poll_table *wait)
 {
 	__poll_t mask = 0;
@@ -79,6 +562,7 @@ static const struct file_operations ne_enclave_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= noop_llseek,
 	.poll		= ne_enclave_poll,
+	.unlocked_ioctl	= ne_enclave_ioctl,
 };
 
 /**
@@ -286,8 +770,15 @@ static int __init ne_init(void)
 
 static void __exit ne_exit(void)
 {
+	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_AMAZON,
+					      PCI_DEVICE_ID_NE, NULL);
+	if (!pdev)
+		return;
+
 	pci_unregister_driver(&ne_pci_driver);
 
+	ne_teardown_cpu_pool(pdev);
+
 	free_cpumask_var(ne_cpu_pool.avail);
 }
 
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

