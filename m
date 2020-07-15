Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D57221567
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 21:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgGOTrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 15:47:37 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:55288 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbgGOTrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 15:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594842454; x=1626378454;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x5ThQqUzprGQ+2q74WXaPlTDCBK6TIPR3AgTZspEkDE=;
  b=bEIl1tCwRSFqxdBm8iME42ofu3F3RsqomDaVf63ORBqwXBCAviOAtPnR
   KIAW9wpntMqrhzxiX7ufAoQMo11Cnme+36AiYMep+h0D3YlOgrzznr6P1
   KVS6nrePvlTPioP0PujS9HMIF91k6x5nvtl/kPYLdHfO07EbiBJeAHDBs
   Q=;
IronPort-SDR: svKd5ZM+rGH1tWr4ML6eSuOW93xwin0iQn8QlDUjn4lYWmmsjo2FN397e4qydSqv9jR2DqGqec
 0e7+usWdyx7g==
X-IronPort-AV: E=Sophos;i="5.75,356,1589241600"; 
   d="scan'208";a="58897363"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 15 Jul 2020 19:47:34 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 690FCA17E0;
        Wed, 15 Jul 2020 19:47:32 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:47:31 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.214) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:47:21 +0000
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
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v5 09/18] nitro_enclaves: Add logic for setting an enclave vCPU
Date:   Wed, 15 Jul 2020 22:45:31 +0300
Message-ID: <20200715194540.45532-10-andraprs@amazon.com>
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

An enclave, before being started, has its resources set. One of its
resources is CPU.

A NE CPU pool is set and enclave CPUs are chosen from it. Offline the
CPUs from the NE CPU pool during the pool setup and online them back
during the NE CPU pool teardown. The CPU offline is necessary so that
there would not be more vCPUs than physical CPUs available to the
primary / parent VM. In that case the CPUs would be overcommitted and
would change the initial configuration of the primary / parent VM of
having dedicated vCPUs to physical CPUs.

The enclave CPUs need to be full cores and from the same NUMA node. CPU
0 and its siblings have to remain available to the primary / parent VM.

Add ioctl command logic for setting an enclave vCPU.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v4 -> v5

* Set empty string in case of invalid NE CPU pool.
* Clear NE CPU pool mask on pool setup failure.
* Setup NE CPU cores out of the NE CPU pool.
* Early exit on NE CPU pool setup if enclave(s) already running.
* Remove sanity checks for situations that shouldn't happen, only if
  buggy system or broken logic at all.
* Add check for maximum vCPU id possible before looking into the CPU
  pool.
* Remove log on copy_from_user() / copy_to_user() failure and on admin
  capability check for setting the NE CPU pool.
* Update the ioctl call to not create a file descriptor for the vCPU.
* Split the CPU pool usage logic in 2 separate functions - one to get a
  CPU from the pool and the other to check the given CPU is available in
  the pool.

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
* Check if enclave state is init when setting enclave vCPU.
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 543 ++++++++++++++++++++++
 1 file changed, 543 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 6a113099ea0e..08a842a1fad7 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -45,8 +45,11 @@
  * TODO: Update logic to create new sysfs entries instead of using
  * a kernel parameter e.g. if multiple sysfs files needed.
  */
+static int ne_set_kernel_param(const char *val, const struct kernel_param *kp);
+
 static const struct kernel_param_ops ne_cpu_pool_ops = {
 	.get = param_get_string,
+	.set = ne_set_kernel_param,
 };
 
 static char ne_cpus[NE_CPUS_SIZE];
@@ -75,6 +78,543 @@ struct ne_cpu_pool {
 
 static struct ne_cpu_pool ne_cpu_pool;
 
+/**
+ * ne_check_enclaves_created - Verify if at least one enclave has been created.
+ *
+ * @returns: true if at least one enclave is created, false otherwise.
+ */
+static bool ne_check_enclaves_created(void)
+{
+	struct ne_pci_dev *ne_pci_dev = NULL;
+	/* TODO: Find another way to get the NE PCI device reference. */
+	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_AMAZON, PCI_DEVICE_ID_NE, NULL);
+	bool ret = false;
+
+	if (!pdev)
+		return ret;
+
+	ne_pci_dev = pci_get_drvdata(pdev);
+	if (!ne_pci_dev) {
+		pci_dev_put(pdev);
+
+		return ret;
+	}
+
+	mutex_lock(&ne_pci_dev->enclaves_list_mutex);
+
+	if (!list_empty(&ne_pci_dev->enclaves_list))
+		ret = true;
+
+	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+	pci_dev_put(pdev);
+
+	return ret;
+}
+
+/**
+ * ne_setup_cpu_pool - Set the NE CPU pool after handling sanity checks such as
+ * not sharing CPU cores with the primary / parent VM or not using CPU 0, which
+ * should remain available for the primary / parent VM. Offline the CPUs from
+ * the pool after the checks passed.
+ *
+ * @ne_cpu_list: the CPU list used for setting NE CPU pool.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_setup_cpu_pool(const char *ne_cpu_list)
+{
+	int core_id = -1;
+	unsigned int cpu = 0;
+	cpumask_var_t cpu_pool = NULL;
+	unsigned int cpu_sibling = 0;
+	unsigned int i = 0;
+	int numa_node = -1;
+	int rc = -EINVAL;
+
+	if (!ne_cpu_list)
+		return 0;
+
+	if (!zalloc_cpumask_var(&cpu_pool, GFP_KERNEL))
+		return -ENOMEM;
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	rc = cpulist_parse(ne_cpu_list, cpu_pool);
+	if (rc < 0) {
+		pr_err("%s: Error in cpulist parse [rc=%d]\n", ne_misc_dev.name, rc);
+
+		goto free_pool_cpumask;
+	}
+
+	cpu = cpumask_any(cpu_pool);
+	if (cpu >= nr_cpu_ids) {
+		pr_err("%s: No CPUs available in CPU pool\n", ne_misc_dev.name);
+
+		rc = -EINVAL;
+
+		goto free_pool_cpumask;
+	}
+
+	/*
+	 * Check if CPU 0 and its siblings are included in the provided CPU pool
+	 * They should remain available for the primary / parent VM.
+	 */
+	if (cpumask_test_cpu(0, cpu_pool)) {
+		pr_err("%s: CPU 0 has to remain available\n", ne_misc_dev.name);
+
+		rc = -EINVAL;
+
+		goto free_pool_cpumask;
+	}
+
+	for_each_cpu(cpu_sibling, topology_sibling_cpumask(0)) {
+		if (cpumask_test_cpu(cpu_sibling, cpu_pool)) {
+			pr_err("%s: CPU sibling %d for CPU 0 is in CPU pool\n",
+			       ne_misc_dev.name, cpu_sibling);
+
+			rc = -EINVAL;
+
+			goto free_pool_cpumask;
+		}
+	}
+
+	/*
+	 * Check if CPU siblings are included in the provided CPU pool. The
+	 * expectation is that CPU cores are made available in the CPU pool for
+	 * enclaves.
+	 */
+	for_each_cpu(cpu, cpu_pool) {
+		for_each_cpu(cpu_sibling, topology_sibling_cpumask(cpu)) {
+			if (!cpumask_test_cpu(cpu_sibling, cpu_pool)) {
+				pr_err("%s: CPU %d is not in CPU pool\n",
+				       ne_misc_dev.name, cpu_sibling);
+
+				rc = -EINVAL;
+
+				goto free_pool_cpumask;
+			}
+		}
+	}
+
+	/*
+	 * Check if the CPUs from the NE CPU pool are from the same NUMA node.
+	 */
+	for_each_cpu(cpu, cpu_pool) {
+		if (numa_node < 0) {
+			numa_node = cpu_to_node(cpu);
+			if (numa_node < 0) {
+				pr_err("%s: Invalid NUMA node %d\n",
+				       ne_misc_dev.name, numa_node);
+
+				rc = -EINVAL;
+
+				goto free_pool_cpumask;
+			}
+		} else {
+			if (numa_node != cpu_to_node(cpu)) {
+				pr_err("%s: CPUs with different NUMA nodes\n",
+				       ne_misc_dev.name);
+
+				rc = -EINVAL;
+
+				goto free_pool_cpumask;
+			}
+		}
+	}
+
+	ne_cpu_pool.avail_cores_size = nr_cpu_ids / smp_num_siblings;
+
+	ne_cpu_pool.avail_cores = kcalloc(ne_cpu_pool.avail_cores_size,
+					  sizeof(*ne_cpu_pool.avail_cores),
+					  GFP_KERNEL);
+	if (!ne_cpu_pool.avail_cores) {
+		rc = -ENOMEM;
+
+		goto free_pool_cpumask;
+	}
+
+	for (i = 0; i < ne_cpu_pool.avail_cores_size; i++)
+		if (!zalloc_cpumask_var(&ne_cpu_pool.avail_cores[i], GFP_KERNEL)) {
+			rc = -ENOMEM;
+
+			goto free_cores_cpumask;
+		}
+
+	ne_cpu_pool.numa_node = numa_node;
+
+	/* Split the NE CPU pool in CPU cores. */
+	for_each_cpu(cpu, cpu_pool) {
+		core_id = topology_core_id(cpu);
+		if (core_id < 0 || core_id >= ne_cpu_pool.avail_cores_size) {
+			pr_err("%s: Invalid core id  %d\n",
+			       ne_misc_dev.name, core_id);
+
+			rc = -EINVAL;
+
+			goto clear_cpumask;
+		}
+
+		cpumask_set_cpu(cpu, ne_cpu_pool.avail_cores[core_id]);
+	}
+
+	/*
+	 * CPUs that are donated to enclave(s) should not be considered online
+	 * by Linux anymore, as the hypervisor will degrade them to floating.
+	 * The physical CPUs (full cores) are carved out of the primary / parent
+	 * VM and given to the enclave VM. The same number of vCPUs would run
+	 * on less pCPUs for the primary / parent VM.
+	 *
+	 * We offline them here, to not degrade performance and expose correct
+	 * topology to Linux and user space.
+	 */
+	for_each_cpu(cpu, cpu_pool) {
+		rc = remove_cpu(cpu);
+		if (rc != 0) {
+			pr_err("%s: CPU %d is not offlined [rc=%d]\n",
+			       ne_misc_dev.name, cpu, rc);
+
+			goto online_cpus;
+		}
+	}
+
+	free_cpumask_var(cpu_pool);
+
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	return 0;
+
+online_cpus:
+	for_each_cpu(cpu, cpu_pool)
+		add_cpu(cpu);
+clear_cpumask:
+	for (i = 0; i < ne_cpu_pool.avail_cores_size; i++)
+		cpumask_clear(ne_cpu_pool.avail_cores[i]);
+free_cores_cpumask:
+	for (i = 0; i < ne_cpu_pool.avail_cores_size; i++)
+		free_cpumask_var(ne_cpu_pool.avail_cores[i]);
+	kfree(ne_cpu_pool.avail_cores);
+	ne_cpu_pool.avail_cores_size = 0;
+free_pool_cpumask:
+	free_cpumask_var(cpu_pool);
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	return rc;
+}
+
+/**
+ * ne_teardown_cpu_pool - Online the CPUs from the NE CPU pool and cleanup the
+ * CPU pool.
+ */
+static void ne_teardown_cpu_pool(void)
+{
+	unsigned int cpu = 0;
+	unsigned int i = 0;
+	int rc = -EINVAL;
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	if (!ne_cpu_pool.avail_cores_size) {
+		mutex_unlock(&ne_cpu_pool.mutex);
+
+		return;
+	}
+
+	for (i = 0; i < ne_cpu_pool.avail_cores_size; i++) {
+		for_each_cpu(cpu, ne_cpu_pool.avail_cores[i]) {
+			rc = add_cpu(cpu);
+			if (rc != 0)
+				pr_err("%s: CPU %d is not onlined [rc=%d]\n",
+				       ne_misc_dev.name, cpu, rc);
+		}
+
+		cpumask_clear(ne_cpu_pool.avail_cores[i]);
+
+		free_cpumask_var(ne_cpu_pool.avail_cores[i]);
+	}
+
+	kfree(ne_cpu_pool.avail_cores);
+	ne_cpu_pool.avail_cores_size = 0;
+
+	mutex_unlock(&ne_cpu_pool.mutex);
+}
+
+static int ne_set_kernel_param(const char *val, const struct kernel_param *kp)
+{
+	char error_val[] = "";
+	int rc = -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (ne_check_enclaves_created()) {
+		pr_err("%s: The CPU pool is used by enclave(s)\n", ne_misc_dev.name);
+
+		return -EPERM;
+	}
+
+	ne_teardown_cpu_pool();
+
+	rc = ne_setup_cpu_pool(val);
+	if (rc < 0) {
+		pr_err("%s: Error in setup CPU pool [rc=%d]\n", ne_misc_dev.name, rc);
+
+		param_set_copystring(error_val, kp);
+
+		return rc;
+	}
+
+	return param_set_copystring(val, kp);
+}
+
+/**
+ * ne_get_cpu_from_cpu_pool - Get a CPU from the NE CPU pool, either from the
+ * remaining sibling(s) of a CPU core or the first sibling of a new CPU core.
+ *
+ * This function gets called with the ne_enclave mutex held.
+ *
+ * @ne_enclave: private data associated with the current enclave.
+ * @vcpu_id: id of the chosen CPU from the NE CPU pool.
+ *
+ * @returns: vCPU id or 0, if no CPU available in the pool.
+ */
+static unsigned int ne_get_cpu_from_cpu_pool(struct ne_enclave *ne_enclave)
+{
+	int core_id = -1;
+	unsigned int cpu = 0;
+	unsigned int i = 0;
+	unsigned int vcpu_id = 0;
+
+	/* There are CPU siblings available to choose from. */
+	for (i = 0; i < ne_enclave->avail_cpu_cores_size; i++)
+		for_each_cpu(cpu, ne_enclave->avail_cpu_cores[i])
+			if (!cpumask_test_cpu(cpu, ne_enclave->vcpu_ids)) {
+				vcpu_id = cpu;
+
+				goto out;
+			}
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	/* Choose a CPU from the available NE CPU pool. */
+	for (i = 0; i < ne_cpu_pool.avail_cores_size; i++)
+		if (!cpumask_empty(ne_cpu_pool.avail_cores[i])) {
+			core_id = i;
+
+			break;
+		}
+
+	if (core_id < 0) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "No CPUs available in NE CPU pool\n");
+
+		goto unlock_mutex;
+	}
+
+	if (core_id >= ne_enclave->avail_cpu_cores_size) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Invalid core id %d - ne_enclave\n", core_id);
+
+		goto unlock_mutex;
+	}
+
+	vcpu_id = cpumask_any(ne_cpu_pool.avail_cores[core_id]);
+
+	for_each_cpu(cpu, ne_cpu_pool.avail_cores[core_id])
+		cpumask_set_cpu(cpu, ne_enclave->avail_cpu_cores[core_id]);
+
+	cpumask_clear(ne_cpu_pool.avail_cores[core_id]);
+
+unlock_mutex:
+	mutex_unlock(&ne_cpu_pool.mutex);
+out:
+	return vcpu_id;
+}
+
+/**
+ * ne_check_cpu_in_cpu_pool - Check if the given vCPU is in the available CPUs
+ * from the pool.
+ *
+ * This function gets called with the ne_enclave mutex held.
+ *
+ * @ne_enclave: private data associated with the current enclave.
+ * @vcpu_id: id of the vCPU to check if available in the NE CPU pool.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_check_cpu_in_cpu_pool(struct ne_enclave *ne_enclave, u32 vcpu_id)
+{
+	int core_id = -1;
+	unsigned int cpu = 0;
+	unsigned int i = 0;
+
+	if (cpumask_test_cpu(vcpu_id, ne_enclave->vcpu_ids)) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "CPU %d already used\n", vcpu_id);
+
+		return -NE_ERR_VCPU_ALREADY_USED;
+	}
+
+	for (i = 0; i < ne_enclave->avail_cpu_cores_size; i++)
+		if (cpumask_test_cpu(vcpu_id, ne_enclave->avail_cpu_cores[i]))
+			return 0;
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	for (i = 0; i < ne_cpu_pool.avail_cores_size; i++)
+		if (cpumask_test_cpu(vcpu_id, ne_cpu_pool.avail_cores[i])) {
+			core_id = i;
+
+			break;
+	}
+
+	if (core_id < 0) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "CPU %d is not in NE CPU pool\n", vcpu_id);
+
+		mutex_unlock(&ne_cpu_pool.mutex);
+
+		return -NE_ERR_VCPU_NOT_IN_POOL;
+	}
+
+	if (core_id >= ne_enclave->avail_cpu_cores_size) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Invalid core id %d - ne_enclave\n", core_id);
+
+		mutex_unlock(&ne_cpu_pool.mutex);
+
+		return -NE_ERR_INVALID_CPU_CORE;
+	}
+
+	for_each_cpu(cpu, ne_cpu_pool.avail_cores[core_id])
+		cpumask_set_cpu(cpu, ne_enclave->avail_cpu_cores[core_id]);
+
+	cpumask_clear(ne_cpu_pool.avail_cores[core_id]);
+
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	return 0;
+}
+
+/**
+ * ne_add_vcpu_ioctl - Add a vCPU to the slot associated with the current
+ * enclave.
+ *
+ * This function gets called with the ne_enclave mutex held.
+ *
+ * @ne_enclave: private data associated with the current enclave.
+ * @vcpu_id: id of the CPU to be associated with the given slot, apic id on x86.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_add_vcpu_ioctl(struct ne_enclave *ne_enclave, u32 vcpu_id)
+{
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	int rc = -EINVAL;
+	struct slot_add_vcpu_req slot_add_vcpu_req = {};
+
+	if (ne_enclave->mm != current->mm)
+		return -EIO;
+
+	slot_add_vcpu_req.slot_uid = ne_enclave->slot_uid;
+	slot_add_vcpu_req.vcpu_id = vcpu_id;
+
+	rc = ne_do_request(ne_enclave->pdev, SLOT_ADD_VCPU, &slot_add_vcpu_req,
+			   sizeof(slot_add_vcpu_req), &cmd_reply, sizeof(cmd_reply));
+	if (rc < 0) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Error in slot add vCPU [rc=%d]\n", rc);
+
+		return rc;
+	}
+
+	cpumask_set_cpu(vcpu_id, ne_enclave->vcpu_ids);
+
+	ne_enclave->nr_vcpus++;
+
+	return 0;
+}
+
+static long ne_enclave_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct ne_enclave *ne_enclave = file->private_data;
+
+	switch (cmd) {
+	case NE_ADD_VCPU: {
+		int rc = -EINVAL;
+		u32 vcpu_id = 0;
+
+		if (copy_from_user(&vcpu_id, (void __user *)arg, sizeof(vcpu_id)))
+			return -EFAULT;
+
+		mutex_lock(&ne_enclave->enclave_info_mutex);
+
+		if (ne_enclave->state != NE_STATE_INIT) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Enclave is not in init state\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -NE_ERR_NOT_IN_INIT_STATE;
+		}
+
+		if (vcpu_id >= (ne_enclave->avail_cpu_cores_size * smp_num_siblings)) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "vCPU id higher than max CPU id\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -NE_ERR_INVALID_VCPU;
+		}
+
+		if (!vcpu_id) {
+			/* Use the CPU pool for choosing a CPU for the enclave. */
+			vcpu_id = ne_get_cpu_from_cpu_pool(ne_enclave);
+			if (!vcpu_id) {
+				dev_err_ratelimited(ne_misc_dev.this_device,
+						    "Error in getting CPU from pool\n");
+
+				mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+				return -NE_ERR_NO_CPUS_AVAIL_IN_POOL;
+			}
+		} else {
+			/* Check if the vCPU is available in the NE CPU pool. */
+			rc = ne_check_cpu_in_cpu_pool(ne_enclave, vcpu_id);
+			if (rc < 0) {
+				dev_err_ratelimited(ne_misc_dev.this_device,
+						    "Error in checking if CPU is in pool\n");
+
+				mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+				return rc;
+			}
+		}
+
+		rc = ne_add_vcpu_ioctl(ne_enclave, vcpu_id);
+		if (rc < 0) {
+			cpumask_clear_cpu(vcpu_id, ne_enclave->vcpu_ids);
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return rc;
+		}
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		if (copy_to_user((void __user *)arg, &vcpu_id, sizeof(vcpu_id)))
+			return -EFAULT;
+
+		return 0;
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
@@ -94,6 +634,7 @@ static const struct file_operations ne_enclave_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= noop_llseek,
 	.poll		= ne_enclave_poll,
+	.unlocked_ioctl	= ne_enclave_ioctl,
 };
 
 /**
@@ -308,6 +849,8 @@ static int __init ne_init(void)
 static void __exit ne_exit(void)
 {
 	pci_unregister_driver(&ne_pci_driver);
+
+	ne_teardown_cpu_pool();
 }
 
 /* TODO: Handle actions such as reboot, kexec. */
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

