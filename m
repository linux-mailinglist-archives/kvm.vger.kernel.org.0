Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EB12723A9
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 14:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgIUMTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 08:19:46 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:41441 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbgIUMTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 08:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600690782; x=1632226782;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OjVovc7In2+HMaJzQDILvlU929dA+YP7jpxzBY/+Mlc=;
  b=cPuBroafn5CpvDVjRD6qVK/nvvrSFinMU9Macn9hObOKX129c6A+ELWt
   Ec+7R3v+DXg4v6QRWYdMFK+twptr7Xwd1wQSrhQL/LrIsmNvP1uU+h0Vm
   t82OtkQSCd/6CsBkaLJEYPLaFDh4/DJLcBiFys/eoNJ5xEJF8p6Iv8Xaz
   k=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="56709871"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Sep 2020 12:19:41 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id BD641A1D27;
        Mon, 21 Sep 2020 12:19:38 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.229) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 12:19:27 +0000
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
Subject: [PATCH v10 09/18] nitro_enclaves: Add logic for setting an enclave vCPU
Date:   Mon, 21 Sep 2020 15:17:23 +0300
Message-ID: <20200921121732.44291-10-andraprs@amazon.com>
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

Changelog

v9 -> v10

* Update commit message to include the changelog before the SoB tag(s).

v8 -> v9

* Use the ne_devs data structure to get the refs for the NE PCI device.

v7 -> v8

* No changes.

v6 -> v7

* Check for error return value when setting the kernel parameter string.
* Use the NE misc device parent field to get the NE PCI device.
* Update the naming and add more comments to make more clear the logic
  of handling full CPU cores and dedicating them to the enclave.
* Calculate the number of threads per core and not use smp_num_siblings
  that is x86 specific.

v5 -> v6

* Check CPUs are from the same NUMA node before going through CPU
  siblings during the NE CPU pool setup.
* Update documentation to kernel-doc format.

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

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 695 ++++++++++++++++++++++
 1 file changed, 695 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 3515b163ad0e..24e4270d181d 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -83,8 +83,11 @@ struct ne_devs ne_devs = {
  * TODO: Update logic to create new sysfs entries instead of using
  * a kernel parameter e.g. if multiple sysfs files needed.
  */
+static int ne_set_kernel_param(const char *val, const struct kernel_param *kp);
+
 static const struct kernel_param_ops ne_cpu_pool_ops = {
 	.get	= param_get_string,
+	.set	= ne_set_kernel_param,
 };
 
 static char ne_cpus[NE_CPUS_SIZE];
@@ -122,6 +125,695 @@ struct ne_cpu_pool {
 
 static struct ne_cpu_pool ne_cpu_pool;
 
+/**
+ * ne_check_enclaves_created() - Verify if at least one enclave has been created.
+ * @void:	No parameters provided.
+ *
+ * Context: Process context.
+ * Return:
+ * * True if at least one enclave is created.
+ * * False otherwise.
+ */
+static bool ne_check_enclaves_created(void)
+{
+	struct ne_pci_dev *ne_pci_dev = ne_devs.ne_pci_dev;
+	bool ret = false;
+
+	if (!ne_pci_dev)
+		return ret;
+
+	mutex_lock(&ne_pci_dev->enclaves_list_mutex);
+
+	if (!list_empty(&ne_pci_dev->enclaves_list))
+		ret = true;
+
+	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+	return ret;
+}
+
+/**
+ * ne_setup_cpu_pool() - Set the NE CPU pool after handling sanity checks such
+ *			 as not sharing CPU cores with the primary / parent VM
+ *			 or not using CPU 0, which should remain available for
+ *			 the primary / parent VM. Offline the CPUs from the
+ *			 pool after the checks passed.
+ * @ne_cpu_list:	The CPU list used for setting NE CPU pool.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_setup_cpu_pool(const char *ne_cpu_list)
+{
+	int core_id = -1;
+	unsigned int cpu = 0;
+	cpumask_var_t cpu_pool;
+	unsigned int cpu_sibling = 0;
+	unsigned int i = 0;
+	int numa_node = -1;
+	int rc = -EINVAL;
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
+	 * Check if the CPUs are online, to further get info about them
+	 * e.g. numa node, core id, siblings.
+	 */
+	for_each_cpu(cpu, cpu_pool)
+		if (cpu_is_offline(cpu)) {
+			pr_err("%s: CPU %d is offline, has to be online to get its metadata\n",
+			       ne_misc_dev.name, cpu);
+
+			rc = -EINVAL;
+
+			goto free_pool_cpumask;
+		}
+
+	/*
+	 * Check if the CPUs from the NE CPU pool are from the same NUMA node.
+	 */
+	for_each_cpu(cpu, cpu_pool)
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
+	 * expectation is that full CPU cores are made available in the CPU pool
+	 * for enclaves.
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
+	/* Calculate the number of threads from a full CPU core. */
+	cpu = cpumask_any(cpu_pool);
+	for_each_cpu(cpu_sibling, topology_sibling_cpumask(cpu))
+		ne_cpu_pool.nr_threads_per_core++;
+
+	ne_cpu_pool.nr_parent_vm_cores = nr_cpu_ids / ne_cpu_pool.nr_threads_per_core;
+
+	ne_cpu_pool.avail_threads_per_core = kcalloc(ne_cpu_pool.nr_parent_vm_cores,
+					     sizeof(*ne_cpu_pool.avail_threads_per_core),
+					     GFP_KERNEL);
+	if (!ne_cpu_pool.avail_threads_per_core) {
+		rc = -ENOMEM;
+
+		goto free_pool_cpumask;
+	}
+
+	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
+		if (!zalloc_cpumask_var(&ne_cpu_pool.avail_threads_per_core[i], GFP_KERNEL)) {
+			rc = -ENOMEM;
+
+			goto free_cores_cpumask;
+		}
+
+	/*
+	 * Split the NE CPU pool in threads per core to keep the CPU topology
+	 * after offlining the CPUs.
+	 */
+	for_each_cpu(cpu, cpu_pool) {
+		core_id = topology_core_id(cpu);
+		if (core_id < 0 || core_id >= ne_cpu_pool.nr_parent_vm_cores) {
+			pr_err("%s: Invalid core id  %d for CPU %d\n",
+			       ne_misc_dev.name, core_id, cpu);
+
+			rc = -EINVAL;
+
+			goto clear_cpumask;
+		}
+
+		cpumask_set_cpu(cpu, ne_cpu_pool.avail_threads_per_core[core_id]);
+	}
+
+	/*
+	 * CPUs that are given to enclave(s) should not be considered online
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
+	ne_cpu_pool.numa_node = numa_node;
+
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	return 0;
+
+online_cpus:
+	for_each_cpu(cpu, cpu_pool)
+		add_cpu(cpu);
+clear_cpumask:
+	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
+		cpumask_clear(ne_cpu_pool.avail_threads_per_core[i]);
+free_cores_cpumask:
+	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
+		free_cpumask_var(ne_cpu_pool.avail_threads_per_core[i]);
+	kfree(ne_cpu_pool.avail_threads_per_core);
+free_pool_cpumask:
+	free_cpumask_var(cpu_pool);
+	ne_cpu_pool.nr_parent_vm_cores = 0;
+	ne_cpu_pool.nr_threads_per_core = 0;
+	ne_cpu_pool.numa_node = -1;
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	return rc;
+}
+
+/**
+ * ne_teardown_cpu_pool() - Online the CPUs from the NE CPU pool and cleanup the
+ *			    CPU pool.
+ * @void:	No parameters provided.
+ *
+ * Context: Process context.
+ */
+static void ne_teardown_cpu_pool(void)
+{
+	unsigned int cpu = 0;
+	unsigned int i = 0;
+	int rc = -EINVAL;
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	if (!ne_cpu_pool.nr_parent_vm_cores) {
+		mutex_unlock(&ne_cpu_pool.mutex);
+
+		return;
+	}
+
+	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++) {
+		for_each_cpu(cpu, ne_cpu_pool.avail_threads_per_core[i]) {
+			rc = add_cpu(cpu);
+			if (rc != 0)
+				pr_err("%s: CPU %d is not onlined [rc=%d]\n",
+				       ne_misc_dev.name, cpu, rc);
+		}
+
+		cpumask_clear(ne_cpu_pool.avail_threads_per_core[i]);
+
+		free_cpumask_var(ne_cpu_pool.avail_threads_per_core[i]);
+	}
+
+	kfree(ne_cpu_pool.avail_threads_per_core);
+	ne_cpu_pool.nr_parent_vm_cores = 0;
+	ne_cpu_pool.nr_threads_per_core = 0;
+	ne_cpu_pool.numa_node = -1;
+
+	mutex_unlock(&ne_cpu_pool.mutex);
+}
+
+/**
+ * ne_set_kernel_param() - Set the NE CPU pool value via the NE kernel parameter.
+ * @val:	NE CPU pool string value.
+ * @kp :	NE kernel parameter associated with the NE CPU pool.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
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
+	rc = param_set_copystring(val, kp);
+	if (rc < 0) {
+		pr_err("%s: Error in param set copystring [rc=%d]\n", ne_misc_dev.name, rc);
+
+		ne_teardown_cpu_pool();
+
+		param_set_copystring(error_val, kp);
+
+		return rc;
+	}
+
+	return 0;
+}
+
+/**
+ * ne_donated_cpu() - Check if the provided CPU is already used by the enclave.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @cpu:		CPU to check if already used.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ * Return:
+ * * True if the provided CPU is already used by the enclave.
+ * * False otherwise.
+ */
+static bool ne_donated_cpu(struct ne_enclave *ne_enclave, unsigned int cpu)
+{
+	if (cpumask_test_cpu(cpu, ne_enclave->vcpu_ids))
+		return true;
+
+	return false;
+}
+
+/**
+ * ne_get_unused_core_from_cpu_pool() - Get the id of a full core from the
+ *					NE CPU pool.
+ * @void:	No parameters provided.
+ *
+ * Context: Process context. This function is called with the ne_enclave and
+ *	    ne_cpu_pool mutexes held.
+ * Return:
+ * * Core id.
+ * * -1 if no CPU core available in the pool.
+ */
+static int ne_get_unused_core_from_cpu_pool(void)
+{
+	int core_id = -1;
+	unsigned int i = 0;
+
+	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
+		if (!cpumask_empty(ne_cpu_pool.avail_threads_per_core[i])) {
+			core_id = i;
+
+			break;
+		}
+
+	return core_id;
+}
+
+/**
+ * ne_set_enclave_threads_per_core() - Set the threads of the provided core in
+ *				       the enclave data structure.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @core_id:		Core id to get its threads from the NE CPU pool.
+ * @vcpu_id:		vCPU id part of the provided core.
+ *
+ * Context: Process context. This function is called with the ne_enclave and
+ *	    ne_cpu_pool mutexes held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_set_enclave_threads_per_core(struct ne_enclave *ne_enclave,
+					   int core_id, u32 vcpu_id)
+{
+	unsigned int cpu = 0;
+
+	if (core_id < 0 && vcpu_id == 0) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "No CPUs available in NE CPU pool\n");
+
+		return -NE_ERR_NO_CPUS_AVAIL_IN_POOL;
+	}
+
+	if (core_id < 0) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "CPU %d is not in NE CPU pool\n", vcpu_id);
+
+		return -NE_ERR_VCPU_NOT_IN_CPU_POOL;
+	}
+
+	if (core_id >= ne_enclave->nr_parent_vm_cores) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Invalid core id %d - ne_enclave\n", core_id);
+
+		return -NE_ERR_VCPU_INVALID_CPU_CORE;
+	}
+
+	for_each_cpu(cpu, ne_cpu_pool.avail_threads_per_core[core_id])
+		cpumask_set_cpu(cpu, ne_enclave->threads_per_core[core_id]);
+
+	cpumask_clear(ne_cpu_pool.avail_threads_per_core[core_id]);
+
+	return 0;
+}
+
+/**
+ * ne_get_cpu_from_cpu_pool() - Get a CPU from the NE CPU pool, either from the
+ *				remaining sibling(s) of a CPU core or the first
+ *				sibling of a new CPU core.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @vcpu_id:		vCPU to get from the NE CPU pool.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_get_cpu_from_cpu_pool(struct ne_enclave *ne_enclave, u32 *vcpu_id)
+{
+	int core_id = -1;
+	unsigned int cpu = 0;
+	unsigned int i = 0;
+	int rc = -EINVAL;
+
+	/*
+	 * If previously allocated a thread of a core to this enclave, first
+	 * check remaining sibling(s) for new CPU allocations, so that full
+	 * CPU cores are used for the enclave.
+	 */
+	for (i = 0; i < ne_enclave->nr_parent_vm_cores; i++)
+		for_each_cpu(cpu, ne_enclave->threads_per_core[i])
+			if (!ne_donated_cpu(ne_enclave, cpu)) {
+				*vcpu_id = cpu;
+
+				return 0;
+			}
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	/*
+	 * If no remaining siblings, get a core from the NE CPU pool and keep
+	 * track of all the threads in the enclave threads per core data structure.
+	 */
+	core_id = ne_get_unused_core_from_cpu_pool();
+
+	rc = ne_set_enclave_threads_per_core(ne_enclave, core_id, *vcpu_id);
+	if (rc < 0)
+		goto unlock_mutex;
+
+	*vcpu_id = cpumask_any(ne_enclave->threads_per_core[core_id]);
+
+	rc = 0;
+
+unlock_mutex:
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	return rc;
+}
+
+/**
+ * ne_get_vcpu_core_from_cpu_pool() - Get from the NE CPU pool the id of the
+ *				      core associated with the provided vCPU.
+ * @vcpu_id:	Provided vCPU id to get its associated core id.
+ *
+ * Context: Process context. This function is called with the ne_enclave and
+ *	    ne_cpu_pool mutexes held.
+ * Return:
+ * * Core id.
+ * * -1 if the provided vCPU is not in the pool.
+ */
+static int ne_get_vcpu_core_from_cpu_pool(u32 vcpu_id)
+{
+	int core_id = -1;
+	unsigned int i = 0;
+
+	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
+		if (cpumask_test_cpu(vcpu_id, ne_cpu_pool.avail_threads_per_core[i])) {
+			core_id = i;
+
+			break;
+	}
+
+	return core_id;
+}
+
+/**
+ * ne_check_cpu_in_cpu_pool() - Check if the given vCPU is in the available CPUs
+ *				from the pool.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @vcpu_id:		ID of the vCPU to check if available in the NE CPU pool.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_check_cpu_in_cpu_pool(struct ne_enclave *ne_enclave, u32 vcpu_id)
+{
+	int core_id = -1;
+	unsigned int i = 0;
+	int rc = -EINVAL;
+
+	if (ne_donated_cpu(ne_enclave, vcpu_id)) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "CPU %d already used\n", vcpu_id);
+
+		return -NE_ERR_VCPU_ALREADY_USED;
+	}
+
+	/*
+	 * If previously allocated a thread of a core to this enclave, but not
+	 * the full core, first check remaining sibling(s).
+	 */
+	for (i = 0; i < ne_enclave->nr_parent_vm_cores; i++)
+		if (cpumask_test_cpu(vcpu_id, ne_enclave->threads_per_core[i]))
+			return 0;
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	/*
+	 * If no remaining siblings, get from the NE CPU pool the core
+	 * associated with the vCPU and keep track of all the threads in the
+	 * enclave threads per core data structure.
+	 */
+	core_id = ne_get_vcpu_core_from_cpu_pool(vcpu_id);
+
+	rc = ne_set_enclave_threads_per_core(ne_enclave, core_id, vcpu_id);
+	if (rc < 0)
+		goto unlock_mutex;
+
+	rc = 0;
+
+unlock_mutex:
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	return rc;
+}
+
+/**
+ * ne_add_vcpu_ioctl() - Add a vCPU to the slot associated with the current
+ *			 enclave.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @vcpu_id:		ID of the CPU to be associated with the given slot,
+ *			apic id on x86.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_add_vcpu_ioctl(struct ne_enclave *ne_enclave, u32 vcpu_id)
+{
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	struct pci_dev *pdev = ne_devs.ne_pci_dev->pdev;
+	int rc = -EINVAL;
+	struct slot_add_vcpu_req slot_add_vcpu_req = {};
+
+	if (ne_enclave->mm != current->mm)
+		return -EIO;
+
+	slot_add_vcpu_req.slot_uid = ne_enclave->slot_uid;
+	slot_add_vcpu_req.vcpu_id = vcpu_id;
+
+	rc = ne_do_request(pdev, SLOT_ADD_VCPU,
+			   &slot_add_vcpu_req, sizeof(slot_add_vcpu_req),
+			   &cmd_reply, sizeof(cmd_reply));
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
+/**
+ * ne_enclave_ioctl() - Ioctl function provided by the enclave file.
+ * @file:	File associated with this ioctl function.
+ * @cmd:	The command that is set for the ioctl call.
+ * @arg:	The argument that is provided for the ioctl call.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
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
+		if (vcpu_id >= (ne_enclave->nr_parent_vm_cores *
+		    ne_enclave->nr_threads_per_core)) {
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
+			rc = ne_get_cpu_from_cpu_pool(ne_enclave, &vcpu_id);
+			if (rc < 0) {
+				dev_err_ratelimited(ne_misc_dev.this_device,
+						    "Error in get CPU from pool [rc=%d]\n",
+						    rc);
+
+				mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+				return rc;
+			}
+		} else {
+			/* Check if the provided vCPU is available in the NE CPU pool. */
+			rc = ne_check_cpu_in_cpu_pool(ne_enclave, vcpu_id);
+			if (rc < 0) {
+				dev_err_ratelimited(ne_misc_dev.this_device,
+						    "Error in check CPU %d in pool [rc=%d]\n",
+						    vcpu_id, rc);
+
+				mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+				return rc;
+			}
+		}
+
+		rc = ne_add_vcpu_ioctl(ne_enclave, vcpu_id);
+		if (rc < 0) {
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
 /**
  * ne_enclave_poll() - Poll functionality used for enclave out-of-band events.
  * @file:	File associated with this poll function.
@@ -150,6 +842,7 @@ static const struct file_operations ne_enclave_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= noop_llseek,
 	.poll		= ne_enclave_poll,
+	.unlocked_ioctl	= ne_enclave_ioctl,
 };
 
 /**
@@ -352,6 +1045,8 @@ static int __init ne_init(void)
 static void __exit ne_exit(void)
 {
 	pci_unregister_driver(&ne_pci_driver);
+
+	ne_teardown_cpu_pool();
 }
 
 module_init(ne_init);
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

