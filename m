Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F33E2402A3
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 09:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgHJHd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 03:33:56 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:47495 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgHJHdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 03:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1597044833; x=1628580833;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=eCgB2W22TGCZO9ooLJBWNFJ+E1VjpX14MX4RdY4mJkM=;
  b=SMTUZ1+303m2UjjjTwPFrtR6MaDcPkETNVLS43kam13iRxz6q507qa/3
   TLtl5y77woTkBtKe+wyFsK91gTit9Y9SnaRw9q+CPyeip/wkZRJUVSsA+
   RW1b1vZXpAdWTr58oGPyyHbiomKYMRtHrmPi0i+YF7Mi13XyWUzzLEoc+
   8=;
IronPort-SDR: 8Qri4v2os+FFIH4e35fZx2ODaSShAXVXkTV/UQwQghlNQy+WjyaSBGjnCSI5Nlpa1s0Rvs5evf
 v49gVO9O5ezA==
X-IronPort-AV: E=Sophos;i="5.75,456,1589241600"; 
   d="scan'208";a="47010645"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 10 Aug 2020 07:33:51 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 43885A1FB9;
        Mon, 10 Aug 2020 07:33:50 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 07:33:49 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.140) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 07:33:43 +0000
Subject: Re: [PATCH v6 09/18] nitro_enclaves: Add logic for setting an enclave
 vCPU
To:     Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Karen Noel <knoel@redhat.com>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20200805091017.86203-1-andraprs@amazon.com>
 <20200805091017.86203-10-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <7adb6707-4101-8f47-6497-fe086dcc11f3@amazon.de>
Date:   Mon, 10 Aug 2020 09:33:42 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200805091017.86203-10-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D18UWA002.ant.amazon.com (10.43.160.199) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.08.20 11:10, Andra Paraschiv wrote:
> An enclave, before being started, has its resources set. One of its
> resources is CPU.
> =

> A NE CPU pool is set and enclave CPUs are chosen from it. Offline the
> CPUs from the NE CPU pool during the pool setup and online them back
> during the NE CPU pool teardown. The CPU offline is necessary so that
> there would not be more vCPUs than physical CPUs available to the
> primary / parent VM. In that case the CPUs would be overcommitted and
> would change the initial configuration of the primary / parent VM of
> having dedicated vCPUs to physical CPUs.
> =

> The enclave CPUs need to be full cores and from the same NUMA node. CPU
> 0 and its siblings have to remain available to the primary / parent VM.
> =

> Add ioctl command logic for setting an enclave vCPU.
> =

> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> =

> v5 -> v6
> =

> * Check CPUs are from the same NUMA node before going through CPU
>    siblings during the NE CPU pool setup.
> * Update documentation to kernel-doc format.
> =

> v4 -> v5
> =

> * Set empty string in case of invalid NE CPU pool.
> * Clear NE CPU pool mask on pool setup failure.
> * Setup NE CPU cores out of the NE CPU pool.
> * Early exit on NE CPU pool setup if enclave(s) already running.
> * Remove sanity checks for situations that shouldn't happen, only if
>    buggy system or broken logic at all.
> * Add check for maximum vCPU id possible before looking into the CPU
>    pool.
> * Remove log on copy_from_user() / copy_to_user() failure and on admin
>    capability check for setting the NE CPU pool.
> * Update the ioctl call to not create a file descriptor for the vCPU.
> * Split the CPU pool usage logic in 2 separate functions - one to get a
>    CPU from the pool and the other to check the given CPU is available in
>    the pool.
> =

> v3 -> v4
> =

> * Setup the NE CPU pool at runtime via a sysfs file for the kernel
>    parameter.
> * Check enclave CPUs to be from the same NUMA node.
> * Use dev_err instead of custom NE log pattern.
> * Update the NE ioctl call to match the decoupling from the KVM API.
> =

> v2 -> v3
> =

> * Remove the WARN_ON calls.
> * Update static calls sanity checks.
> * Update kzfree() calls to kfree().
> * Remove file ops that do nothing for now - open, ioctl and release.
> =

> v1 -> v2
> =

> * Add log pattern for NE.
> * Update goto labels to match their purpose.
> * Remove the BUG_ON calls.
> * Check if enclave state is init when setting enclave vCPU.
> ---
>   drivers/virt/nitro_enclaves/ne_misc_dev.c | 575 ++++++++++++++++++++++
>   1 file changed, 575 insertions(+)
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nit=
ro_enclaves/ne_misc_dev.c
> index 6c8c12f65666..4787bc59d39d 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -57,8 +57,11 @@
>    * TODO: Update logic to create new sysfs entries instead of using
>    * a kernel parameter e.g. if multiple sysfs files needed.
>    */
> +static int ne_set_kernel_param(const char *val, const struct kernel_para=
m *kp);
> +
>   static const struct kernel_param_ops ne_cpu_pool_ops =3D {
>   	.get	=3D param_get_string,
> +	.set	=3D ne_set_kernel_param,
>   };
>   =

>   static char ne_cpus[NE_CPUS_SIZE];
> @@ -87,6 +90,575 @@ struct ne_cpu_pool {
>   =

>   static struct ne_cpu_pool ne_cpu_pool;
>   =

> +/**
> + * ne_check_enclaves_created() - Verify if at least one enclave has been=
 created.
> + * @void:	No parameters provided.
> + *
> + * Context: Process context.
> + * Return:
> + * * True if at least one enclave is created.
> + * * False otherwise.
> + */
> +static bool ne_check_enclaves_created(void)
> +{
> +	struct ne_pci_dev *ne_pci_dev =3D NULL;
> +	/* TODO: Find another way to get the NE PCI device reference. */
> +	struct pci_dev *pdev =3D pci_get_device(PCI_VENDOR_ID_AMAZON, PCI_DEVIC=
E_ID_NE, NULL);

Can we just make this a global ref count instead?

> +	bool ret =3D false;
> +
> +	if (!pdev)
> +		return ret;
> +
> +	ne_pci_dev =3D pci_get_drvdata(pdev);
> +	if (!ne_pci_dev) {
> +		pci_dev_put(pdev);
> +
> +		return ret;
> +	}
> +
> +	mutex_lock(&ne_pci_dev->enclaves_list_mutex);
> +
> +	if (!list_empty(&ne_pci_dev->enclaves_list))
> +		ret =3D true;
> +
> +	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
> +
> +	pci_dev_put(pdev);
> +
> +	return ret;
> +}
> +
> +/**
> + * ne_setup_cpu_pool() - Set the NE CPU pool after handling sanity check=
s such
> + *			 as not sharing CPU cores with the primary / parent VM
> + *			 or not using CPU 0, which should remain available for
> + *			 the primary / parent VM. Offline the CPUs from the
> + *			 pool after the checks passed.
> + * @ne_cpu_list:	The CPU list used for setting NE CPU pool.
> + *
> + * Context: Process context.
> + * Return:
> + * * 0 on success.
> + * * Negative return value on failure.
> + */
> +static int ne_setup_cpu_pool(const char *ne_cpu_list)
> +{
> +	int core_id =3D -1;
> +	unsigned int cpu =3D 0;
> +	cpumask_var_t cpu_pool =3D NULL;
> +	unsigned int cpu_sibling =3D 0;
> +	unsigned int i =3D 0;
> +	int numa_node =3D -1;
> +	int rc =3D -EINVAL;
> +
> +	if (!ne_cpu_list)
> +		return 0;
> +
> +	if (!zalloc_cpumask_var(&cpu_pool, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	mutex_lock(&ne_cpu_pool.mutex);
> +
> +	rc =3D cpulist_parse(ne_cpu_list, cpu_pool);
> +	if (rc < 0) {
> +		pr_err("%s: Error in cpulist parse [rc=3D%d]\n", ne_misc_dev.name, rc);
> +
> +		goto free_pool_cpumask;
> +	}
> +
> +	cpu =3D cpumask_any(cpu_pool);
> +	if (cpu >=3D nr_cpu_ids) {
> +		pr_err("%s: No CPUs available in CPU pool\n", ne_misc_dev.name);
> +
> +		rc =3D -EINVAL;
> +
> +		goto free_pool_cpumask;
> +	}
> +
> +	/*
> +	 * Check if the CPUs from the NE CPU pool are from the same NUMA node.
> +	 */
> +	for_each_cpu(cpu, cpu_pool) {
> +		if (numa_node < 0) {
> +			numa_node =3D cpu_to_node(cpu);
> +			if (numa_node < 0) {
> +				pr_err("%s: Invalid NUMA node %d\n",
> +				       ne_misc_dev.name, numa_node);
> +
> +				rc =3D -EINVAL;
> +
> +				goto free_pool_cpumask;
> +			}
> +		} else {
> +			if (numa_node !=3D cpu_to_node(cpu)) {
> +				pr_err("%s: CPUs with different NUMA nodes\n",
> +				       ne_misc_dev.name);
> +
> +				rc =3D -EINVAL;
> +
> +				goto free_pool_cpumask;
> +			}
> +		}
> +	}
> +
> +	/*
> +	 * Check if CPU 0 and its siblings are included in the provided CPU pool
> +	 * They should remain available for the primary / parent VM.
> +	 */
> +	if (cpumask_test_cpu(0, cpu_pool)) {
> +		pr_err("%s: CPU 0 has to remain available\n", ne_misc_dev.name);
> +
> +		rc =3D -EINVAL;
> +
> +		goto free_pool_cpumask;
> +	}
> +
> +	for_each_cpu(cpu_sibling, topology_sibling_cpumask(0)) {
> +		if (cpumask_test_cpu(cpu_sibling, cpu_pool)) {
> +			pr_err("%s: CPU sibling %d for CPU 0 is in CPU pool\n",
> +			       ne_misc_dev.name, cpu_sibling);
> +
> +			rc =3D -EINVAL;
> +
> +			goto free_pool_cpumask;
> +		}
> +	}
> +
> +	/*
> +	 * Check if CPU siblings are included in the provided CPU pool. The
> +	 * expectation is that CPU cores are made available in the CPU pool for
> +	 * enclaves.
> +	 */
> +	for_each_cpu(cpu, cpu_pool) {
> +		for_each_cpu(cpu_sibling, topology_sibling_cpumask(cpu)) {
> +			if (!cpumask_test_cpu(cpu_sibling, cpu_pool)) {
> +				pr_err("%s: CPU %d is not in CPU pool\n",
> +				       ne_misc_dev.name, cpu_sibling);
> +
> +				rc =3D -EINVAL;
> +
> +				goto free_pool_cpumask;
> +			}
> +		}
> +	}
> +
> +	ne_cpu_pool.avail_cores_size =3D nr_cpu_ids / smp_num_siblings;
> +
> +	ne_cpu_pool.avail_cores =3D kcalloc(ne_cpu_pool.avail_cores_size,
> +					  sizeof(*ne_cpu_pool.avail_cores),
> +					  GFP_KERNEL);
> +	if (!ne_cpu_pool.avail_cores) {
> +		rc =3D -ENOMEM;
> +
> +		goto free_pool_cpumask;
> +	}
> +
> +	for (i =3D 0; i < ne_cpu_pool.avail_cores_size; i++)
> +		if (!zalloc_cpumask_var(&ne_cpu_pool.avail_cores[i], GFP_KERNEL)) {
> +			rc =3D -ENOMEM;
> +
> +			goto free_cores_cpumask;
> +		}
> +
> +	/* Split the NE CPU pool in CPU cores. */
> +	for_each_cpu(cpu, cpu_pool) {
> +		core_id =3D topology_core_id(cpu);
> +		if (core_id < 0 || core_id >=3D ne_cpu_pool.avail_cores_size) {
> +			pr_err("%s: Invalid core id  %d\n",
> +			       ne_misc_dev.name, core_id);
> +
> +			rc =3D -EINVAL;
> +
> +			goto clear_cpumask;
> +		}
> +
> +		cpumask_set_cpu(cpu, ne_cpu_pool.avail_cores[core_id]);
> +	}
> +
> +	/*
> +	 * CPUs that are given to enclave(s) should not be considered online
> +	 * by Linux anymore, as the hypervisor will degrade them to floating.
> +	 * The physical CPUs (full cores) are carved out of the primary / parent
> +	 * VM and given to the enclave VM. The same number of vCPUs would run
> +	 * on less pCPUs for the primary / parent VM.
> +	 *
> +	 * We offline them here, to not degrade performance and expose correct
> +	 * topology to Linux and user space.
> +	 */
> +	for_each_cpu(cpu, cpu_pool) {
> +		rc =3D remove_cpu(cpu);
> +		if (rc !=3D 0) {
> +			pr_err("%s: CPU %d is not offlined [rc=3D%d]\n",
> +			       ne_misc_dev.name, cpu, rc);
> +
> +			goto online_cpus;
> +		}
> +	}
> +
> +	free_cpumask_var(cpu_pool);
> +
> +	ne_cpu_pool.numa_node =3D numa_node;
> +
> +	mutex_unlock(&ne_cpu_pool.mutex);
> +
> +	return 0;
> +
> +online_cpus:
> +	for_each_cpu(cpu, cpu_pool)
> +		add_cpu(cpu);
> +clear_cpumask:
> +	for (i =3D 0; i < ne_cpu_pool.avail_cores_size; i++)
> +		cpumask_clear(ne_cpu_pool.avail_cores[i]);
> +free_cores_cpumask:
> +	for (i =3D 0; i < ne_cpu_pool.avail_cores_size; i++)
> +		free_cpumask_var(ne_cpu_pool.avail_cores[i]);
> +	kfree(ne_cpu_pool.avail_cores);
> +	ne_cpu_pool.avail_cores_size =3D 0;
> +free_pool_cpumask:
> +	free_cpumask_var(cpu_pool);
> +	mutex_unlock(&ne_cpu_pool.mutex);
> +
> +	return rc;
> +}
> +
> +/**
> + * ne_teardown_cpu_pool() - Online the CPUs from the NE CPU pool and cle=
anup the
> + *			    CPU pool.
> + * @void:	No parameters provided.
> + *
> + * Context: Process context.
> + */
> +static void ne_teardown_cpu_pool(void)
> +{
> +	unsigned int cpu =3D 0;
> +	unsigned int i =3D 0;
> +	int rc =3D -EINVAL;
> +
> +	mutex_lock(&ne_cpu_pool.mutex);
> +
> +	if (!ne_cpu_pool.avail_cores_size) {
> +		mutex_unlock(&ne_cpu_pool.mutex);
> +
> +		return;
> +	}
> +
> +	for (i =3D 0; i < ne_cpu_pool.avail_cores_size; i++) {
> +		for_each_cpu(cpu, ne_cpu_pool.avail_cores[i]) {
> +			rc =3D add_cpu(cpu);
> +			if (rc !=3D 0)
> +				pr_err("%s: CPU %d is not onlined [rc=3D%d]\n",
> +				       ne_misc_dev.name, cpu, rc);
> +		}
> +
> +		cpumask_clear(ne_cpu_pool.avail_cores[i]);
> +
> +		free_cpumask_var(ne_cpu_pool.avail_cores[i]);
> +	}
> +
> +	kfree(ne_cpu_pool.avail_cores);
> +	ne_cpu_pool.avail_cores_size =3D 0;
> +
> +	mutex_unlock(&ne_cpu_pool.mutex);
> +}
> +
> +/**
> + * ne_set_kernel_param() - Set the NE CPU pool value via the NE kernel p=
arameter.
> + * @val:	NE CPU pool string value.
> + * @kp :	NE kernel parameter associated with the NE CPU pool.
> + *
> + * Context: Process context.
> + * Return:
> + * * 0 on success.
> + * * Negative return value on failure.
> + */
> +static int ne_set_kernel_param(const char *val, const struct kernel_para=
m *kp)
> +{
> +	char error_val[] =3D "";
> +	int rc =3D -EINVAL;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (ne_check_enclaves_created()) {
> +		pr_err("%s: The CPU pool is used by enclave(s)\n", ne_misc_dev.name);
> +
> +		return -EPERM;
> +	}
> +
> +	ne_teardown_cpu_pool();
> +
> +	rc =3D ne_setup_cpu_pool(val);
> +	if (rc < 0) {
> +		pr_err("%s: Error in setup CPU pool [rc=3D%d]\n", ne_misc_dev.name, rc=
);
> +
> +		param_set_copystring(error_val, kp);
> +
> +		return rc;
> +	}
> +
> +	return param_set_copystring(val, kp);
> +}
> +
> +/**
> + * ne_get_cpu_from_cpu_pool() - Get a CPU from the NE CPU pool, either f=
rom the
> + *				remaining sibling(s) of a CPU core or the first
> + *				sibling of a new CPU core.
> + * @ne_enclave :	Private data associated with the current enclave.
> + *
> + * Context: Process context. This function is called with the ne_enclave=
 mutex held.
> + * Return:
> + * * vCPU id.
> + * * 0, if no CPU available in the pool.
> + */
> +static unsigned int ne_get_cpu_from_cpu_pool(struct ne_enclave *ne_encla=
ve)
> +{
> +	int core_id =3D -1;
> +	unsigned int cpu =3D 0;
> +	unsigned int i =3D 0;
> +	unsigned int vcpu_id =3D 0;
> +
> +	/* There are CPU siblings available to choose from. */
> +	for (i =3D 0; i < ne_enclave->avail_cpu_cores_size; i++)
> +		for_each_cpu(cpu, ne_enclave->avail_cpu_cores[i])

This is really hard to read. I think what you want to say here is =

something along these lines:

/*
  * If previously allocated a thread of a core to this enclave, we first
  * return its sibling(s) for new allocations, so that we can donate a
  * full core.
  */
for (i =3D 0; i < ne_enclave->nr_parent_cores; i++) {
     for_each_cpu(cpu, ne->enclave->parent_cores[i].reserved_siblings) {
         if (!ne_cpu_donated(cpu)) {
             [...]
         }
     }
}

Similarly for other places in this file where you do cpu mask logic. It =

always needs to be very obvious what the respective mask is for, because =

you have ~3 semantically different ones.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



