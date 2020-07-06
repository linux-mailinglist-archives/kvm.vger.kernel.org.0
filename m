Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8945C215539
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 12:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgGFKMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 06:12:49 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:14102 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728299AbgGFKMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 06:12:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1594030365; x=1625566365;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Cv7VO8jxzC5X+chjycuJAmTFm+/W878z6FB5k0MIIJI=;
  b=RTXliFND7KoQ3SPk5h5+1a/Gt3PsYgJ1mjheCgnLwK6hnxuK4FfAz5Dv
   JVvlxhf3t0TWrw+wGNTlIH6ZfQI4iYaBeQNrP3buHxxDLARl/zMBHU3Gr
   dYXCiGhOiD60cizcAJXkCrSj0ht3Vc//PPljdDD88s17vIapyXMU4y8Yu
   M=;
IronPort-SDR: ZyIw+qsWHPGUK+RVK1h3O8vO9PQaE2B7uEy+69GGCLml2aR/A59lPGt+b+Qx4usL0FVawR4ppO
 /PHFeoN3JTTw==
X-IronPort-AV: E=Sophos;i="5.75,318,1589241600"; 
   d="scan'208";a="40182012"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 06 Jul 2020 10:12:43 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id DE119A1E0B;
        Mon,  6 Jul 2020 10:12:42 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 10:12:42 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.156) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 10:12:34 +0000
Subject: Re: [PATCH v4 09/18] nitro_enclaves: Add logic for enclave vcpu
 creation
To:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-10-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <52e916fc-8fe3-f9bc-009e-ca84ab7dd650@amazon.de>
Date:   Mon, 6 Jul 2020 12:12:31 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-10-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.156]
X-ClientProxiedBy: EX13D23UWC004.ant.amazon.com (10.43.162.219) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
> An enclave, before being started, has its resources set. One of its
> resources is CPU.
> =

> The NE CPU pool is set for choosing CPUs for enclaves from it. Offline
> the CPUs from the NE CPU pool during the pool setup and online them back
> during the NE CPU pool teardown.
> =

> The enclave CPUs need to be full cores and from the same NUMA node. CPU
> 0 and its siblings have to remain available to the primary / parent VM.
> =

> Add ioctl command logic for enclave vCPU creation. Return as result a
> file descriptor that is associated with the enclave vCPU.
> =

> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
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
> * Check if enclave state is init when setting enclave vcpu.
> ---
>   drivers/virt/nitro_enclaves/ne_misc_dev.c | 491 ++++++++++++++++++++++
>   1 file changed, 491 insertions(+)
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nit=
ro_enclaves/ne_misc_dev.c
> index f70496813033..d6777008f685 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -39,7 +39,11 @@
>    * TODO: Update logic to create new sysfs entries instead of using
>    * a kernel parameter e.g. if multiple sysfs files needed.
>    */
> +static int ne_set_kernel_param(const char *val, const struct kernel_para=
m *kp);
> +
>   static const struct kernel_param_ops ne_cpu_pool_ops =3D {
> +	.get =3D param_get_string,
> +	.set =3D ne_set_kernel_param,
>   };
>   =

>   static char ne_cpus[PAGE_SIZE];
> @@ -60,6 +64,485 @@ struct ne_cpu_pool {
>   =

>   static struct ne_cpu_pool ne_cpu_pool;
>   =

> +static const struct file_operations ne_enclave_vcpu_fops =3D {
> +	.owner		=3D THIS_MODULE,
> +	.llseek		=3D noop_llseek,
> +};

Do we really need an fd for an object without operations? I think the =

general flow to add CPUs from the pool to the VM is very sensible. But I =

don't think we really need an fd as return value from that operation.

> +
> +/**
> + * ne_check_enclaves_created - Verify if at least one enclave has been c=
reated.
> + *
> + * @pdev: PCI device used for enclave lifetime management.
> + *
> + * @returns: true if at least one enclave is created, false otherwise.
> + */
> +static bool ne_check_enclaves_created(struct pci_dev *pdev)
> +{
> +	struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
> +
> +	if (!ne_pci_dev)
> +		return false;

Please pass in the ne_pci_dev into this function directly.

> +
> +	mutex_lock(&ne_pci_dev->enclaves_list_mutex);
> +
> +	if (list_empty(&ne_pci_dev->enclaves_list)) {
> +		mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
> +
> +		return false;

If you make this a return variable, you save on the unlock duplication.

> +	}
> +
> +	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
> +
> +	return true;
> +}
> +
> +/**
> + * ne_setup_cpu_pool - Set the NE CPU pool after handling sanity checks =
such as
> + * not sharing CPU cores with the primary / parent VM or not using CPU 0=
, which
> + * should remain available for the primary / parent VM. Offline the CPUs=
 from
> + * the pool after the checks passed.
> + *
> + * @pdev: PCI device used for enclave lifetime management.
> + * @ne_cpu_list: the CPU list used for setting NE CPU pool.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_setup_cpu_pool(struct pci_dev *pdev, const char *ne_cpu_li=
st)
> +{
> +	unsigned int cpu =3D 0;
> +	unsigned int cpu_sibling =3D 0;
> +	int numa_node =3D -1;
> +	int rc =3D -EINVAL;
> +
> +	if (!capable(CAP_SYS_ADMIN)) {
> +		dev_err(&pdev->dev, "No admin capability for CPU pool setup\n");

No need to print anything here. It only gives non-admin users a chance =

to spill the kernel log. If non-admin users can write at all? Can they?

Also, isn't this at the wrong abstraction level? I would expect such a =

check to happen on the file write function, not here.

> +
> +		return -EPERM;
> +	}
> +
> +	if (!ne_cpu_list)
> +		return 0;
> +
> +	if (ne_check_enclaves_created(pdev)) {
> +		dev_err(&pdev->dev, "The CPU pool is used, enclaves created\n");
> +
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&ne_cpu_pool.mutex);
> +
> +	rc =3D cpulist_parse(ne_cpu_list, ne_cpu_pool.avail);
> +	if (rc < 0) {
> +		dev_err(&pdev->dev,
> +			"Error in cpulist parse [rc=3D%d]\n", rc);
> +
> +		goto unlock_mutex;
> +	}
> +
> +	/*
> +	 * Check if CPU 0 and its siblings are included in the provided CPU pool
> +	 * They should remain available for the primary / parent VM.
> +	 */
> +	if (cpumask_test_cpu(0, ne_cpu_pool.avail)) {
> +
> +		dev_err(&pdev->dev,
> +			"CPU 0 has to remain available for the primary VM\n");

Shouldn't this also change the read value of the sysfs file?

> +
> +		rc =3D -EINVAL;
> +
> +		goto unlock_mutex;
> +	}
> +
> +	for_each_cpu(cpu_sibling, topology_sibling_cpumask(0)) {
> +		if (cpumask_test_cpu(cpu_sibling, ne_cpu_pool.avail)) {
> +			dev_err(&pdev->dev,
> +				"CPU sibling %d of CPU 0 is in the CPU pool\n",
> +				cpu_sibling);

Same here. I would expect the sysfs file to reflect either the previous =

state or <empty> because failures mean no CPUs are donated anymore.

Can we somehow implement the get function of the param as something that =

gets generated dynamically?

> +
> +			rc =3D -EINVAL;
> +
> +			goto unlock_mutex;
> +		}
> +	}
> +
> +	/*
> +	 * Check if CPU siblings are included in the provided CPU pool. The
> +	 * expectation is that CPU cores are made available in the CPU pool for
> +	 * enclaves.
> +	 */
> +	for_each_cpu(cpu, ne_cpu_pool.avail) {
> +		for_each_cpu(cpu_sibling, topology_sibling_cpumask(cpu)) {
> +			if (!cpumask_test_cpu(cpu_sibling, ne_cpu_pool.avail)) {
> +				dev_err(&pdev->dev,
> +					"CPU %d is not in the CPU pool\n",
> +					cpu_sibling);
> +
> +				rc =3D -EINVAL;
> +
> +				goto unlock_mutex;
> +			}
> +		}
> +	}
> +
> +	/*
> +	 * Check if the CPUs from the NE CPU pool are from the same NUMA node.
> +	 */
> +	for_each_cpu(cpu, ne_cpu_pool.avail) {
> +		if (numa_node < 0) {
> +			numa_node =3D cpu_to_node(cpu);
> +
> +			if (numa_node < 0) {
> +				dev_err(&pdev->dev,
> +					"Invalid NUMA node %d\n", numa_node);
> +
> +				rc =3D -EINVAL;
> +
> +				goto unlock_mutex;
> +			}
> +		} else {
> +			if (numa_node !=3D cpu_to_node(cpu)) {
> +				dev_err(&pdev->dev,
> +					"CPUs are from different NUMA nodes\n");
> +
> +				rc =3D -EINVAL;
> +
> +				goto unlock_mutex;
> +			}
> +		}
> +	}
> +

There should be a comment here that describes the why:

/*
  * CPUs that are donated to enclaves should not be considered online
  * by Linux anymore, as the hypervisor will degrade them to floating.
  *
  * We offline them here, to not degrade performance and expose correct
  * topology to Linux and user space.
  */

> +	for_each_cpu(cpu, ne_cpu_pool.avail) {
> +		rc =3D remove_cpu(cpu);
> +		if (rc !=3D 0) {
> +			dev_err(&pdev->dev,
> +				"CPU %d is not offlined [rc=3D%d]\n", cpu, rc);
> +
> +			goto online_cpus;
> +		}
> +	}
> +
> +	mutex_unlock(&ne_cpu_pool.mutex);
> +
> +	return 0;
> +
> +online_cpus:
> +	for_each_cpu(cpu, ne_cpu_pool.avail)
> +		add_cpu(cpu);
> +unlock_mutex:
> +	mutex_unlock(&ne_cpu_pool.mutex);
> +
> +	return rc;
> +}
> +
> +/**
> + * ne_teardown_cpu_pool - Online the CPUs from the NE CPU pool and clean=
up the
> + * CPU pool.
> + *
> + * @pdev: PCI device used for enclave lifetime management.
> + */
> +static void ne_teardown_cpu_pool(struct pci_dev *pdev)
> +{
> +	unsigned int cpu =3D 0;
> +	int rc =3D -EINVAL;
> +
> +	if (!capable(CAP_SYS_ADMIN)) {
> +		dev_err(&pdev->dev, "No admin capability for CPU pool setup\n");
> +
> +		return;
> +	}
> +
> +	if (!ne_cpu_pool.avail)
> +		return;
> +
> +	if (ne_check_enclaves_created(pdev)) {
> +		dev_err(&pdev->dev, "The CPU pool is used, enclaves created\n");
> +
> +		return;
> +	}
> +
> +	mutex_lock(&ne_cpu_pool.mutex);
> +
> +	for_each_cpu(cpu, ne_cpu_pool.avail) {
> +		rc =3D add_cpu(cpu);
> +		if (rc !=3D 0)
> +			dev_err(&pdev->dev,
> +				"CPU %d is not onlined [rc=3D%d]\n", cpu, rc);
> +	}
> +
> +	cpumask_clear(ne_cpu_pool.avail);
> +
> +	mutex_unlock(&ne_cpu_pool.mutex);
> +}
> +
> +static int ne_set_kernel_param(const char *val, const struct kernel_para=
m *kp)
> +{
> +	const char *ne_cpu_list =3D val;
> +	struct pci_dev *pdev =3D pci_get_device(PCI_VENDOR_ID_AMAZON,
> +					      PCI_DEVICE_ID_NE, NULL);

Isn't there a better way?

> +	int rc =3D -EINVAL;
> +
> +	if (!pdev)
> +		return -ENODEV;
> +
> +	ne_teardown_cpu_pool(pdev);
> +
> +	rc =3D ne_setup_cpu_pool(pdev, ne_cpu_list);
> +	if (rc < 0) {
> +		dev_err(&pdev->dev, "Error in setup CPU pool [rc=3D%d]\n", rc);
> +
> +		return rc;
> +	}
> +
> +	return param_set_copystring(val, kp);
> +}
> +
> +/**
> + * ne_get_cpu_from_cpu_pool - Get a CPU from the CPU pool. If the vCPU i=
d is 0,
> + * the CPU is autogenerated and chosen from the NE CPU pool.
> + *
> + * This function gets called with the ne_enclave mutex held.
> + *
> + * @ne_enclave: private data associated with the current enclave.
> + * @vcpu_id: id of the CPU to be associated with the given slot, apic id=
 on x86.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_get_cpu_from_cpu_pool(struct ne_enclave *ne_enclave, u32 *=
vcpu_id)

That's a very awkward API. Can you instead just pass by-value and return =

the resulting CPU ID?

> +{
> +	unsigned int cpu =3D 0;
> +	unsigned int cpu_sibling =3D 0;
> +
> +	if (*vcpu_id !=3D 0) {
> +		if (cpumask_test_cpu(*vcpu_id, ne_enclave->cpu_siblings)) {
> +			cpumask_clear_cpu(*vcpu_id, ne_enclave->cpu_siblings);
> +
> +			return 0;
> +		}
> +
> +		mutex_lock(&ne_cpu_pool.mutex);
> +
> +		if (!cpumask_test_cpu(*vcpu_id, ne_cpu_pool.avail)) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "CPU %d is not in NE CPU pool\n",
> +					    *vcpu_id);
> +
> +			mutex_unlock(&ne_cpu_pool.mutex);
> +
> +			return -EINVAL;

I think you're better off making the return value explicit for the =

error, so that user space can print the error message rather than us.

> +		}
> +
> +		cpumask_clear_cpu(*vcpu_id, ne_cpu_pool.avail);
> +
> +		/*
> +		 * Make sure the CPU siblings are not marked as available
> +		 * anymore.
> +		 */
> +		for_each_cpu(cpu_sibling, topology_sibling_cpumask(*vcpu_id)) {
> +			if (cpu_sibling !=3D *vcpu_id) {
> +				cpumask_clear_cpu(cpu_sibling,
> +						  ne_cpu_pool.avail);
> +
> +				cpumask_set_cpu(cpu_sibling,
> +						ne_enclave->cpu_siblings);
> +			}
> +		}
> +
> +		mutex_unlock(&ne_cpu_pool.mutex);
> +
> +		return 0;
> +	}
> +
> +	/* There are CPU siblings available to choose from. */
> +	cpu =3D cpumask_any(ne_enclave->cpu_siblings);
> +	if (cpu < nr_cpu_ids) {
> +		cpumask_clear_cpu(cpu, ne_enclave->cpu_siblings);
> +
> +		*vcpu_id =3D cpu;
> +
> +		return 0;
> +	}
> +
> +	mutex_lock(&ne_cpu_pool.mutex);
> +
> +	/* Choose any CPU from the available CPU pool. */
> +	cpu =3D cpumask_any(ne_cpu_pool.avail);
> +	if (cpu >=3D nr_cpu_ids) {
> +		dev_err_ratelimited(ne_misc_dev.this_device,
> +				    "No CPUs available in CPU pool\n");
> +
> +		mutex_unlock(&ne_cpu_pool.mutex);
> +
> +		return -EINVAL;

I think you're better off making the return value explicit for the =

error, so that user space can print the error message rather than us.

> +	}
> +
> +	cpumask_clear_cpu(cpu, ne_cpu_pool.avail);
> +
> +	/* Make sure the CPU siblings are not marked as available anymore. */
> +	for_each_cpu(cpu_sibling, topology_sibling_cpumask(cpu)) {
> +		if (cpu_sibling !=3D cpu) {
> +			cpumask_clear_cpu(cpu_sibling, ne_cpu_pool.avail);
> +
> +			cpumask_set_cpu(cpu_sibling, ne_enclave->cpu_siblings);
> +		}
> +	}
> +
> +	mutex_unlock(&ne_cpu_pool.mutex);

I find the function slightly confusingly structured. Why can't we do =

something like


   if (!vcpu_id) {
     vcpu_id =3D find_next_free_vcpu_id();
     if (vcpu_id < 0)
         return -ENOSPC;
   }

   [logic to handle an explicit vcpu id]

I think that would be much more readable.

> +
> +	*vcpu_id =3D cpu;
> +
> +	return 0;
> +}
> +
> +/**
> + * ne_create_vcpu_ioctl - Add vCPU to the slot associated with the curre=
nt
> + * enclave. Create vCPU file descriptor to be further used for CPU handl=
ing.
> + *
> + * This function gets called with the ne_enclave mutex held.
> + *
> + * @ne_enclave: private data associated with the current enclave.
> + * @vcpu_id: id of the CPU to be associated with the given slot, apic id=
 on x86.
> + *
> + * @returns: vCPU fd on success, negative return value on failure.
> + */
> +static int ne_create_vcpu_ioctl(struct ne_enclave *ne_enclave, u32 vcpu_=
id)
> +{
> +	struct ne_pci_dev_cmd_reply cmd_reply =3D {};
> +	int fd =3D 0;
> +	struct file *file =3D NULL;
> +	struct ne_vcpu_id *ne_vcpu_id =3D NULL;
> +	int rc =3D -EINVAL;
> +	struct slot_add_vcpu_req slot_add_vcpu_req =3D {};
> +
> +	if (ne_enclave->mm !=3D current->mm)
> +		return -EIO;
> +
> +	ne_vcpu_id =3D kzalloc(sizeof(*ne_vcpu_id), GFP_KERNEL);
> +	if (!ne_vcpu_id)
> +		return -ENOMEM;
> +
> +	fd =3D get_unused_fd_flags(O_CLOEXEC);
> +	if (fd < 0) {
> +		rc =3D fd;
> +
> +		dev_err_ratelimited(ne_misc_dev.this_device,
> +				    "Error in getting unused fd [rc=3D%d]\n", rc);
> +
> +		goto free_ne_vcpu_id;
> +	}
> +
> +	/* TODO: Include (vcpu) id in the ne-vm-vcpu naming. */
> +	file =3D anon_inode_getfile("ne-vm-vcpu", &ne_enclave_vcpu_fops,
> +				  ne_enclave, O_RDWR);
> +	if (IS_ERR(file)) {
> +		rc =3D PTR_ERR(file);
> +
> +		dev_err_ratelimited(ne_misc_dev.this_device,
> +				    "Error in anon inode get file [rc=3D%d]\n",
> +				    rc);
> +
> +		goto put_fd;
> +	}
> +
> +	slot_add_vcpu_req.slot_uid =3D ne_enclave->slot_uid;
> +	slot_add_vcpu_req.vcpu_id =3D vcpu_id;
> +
> +	rc =3D ne_do_request(ne_enclave->pdev, SLOT_ADD_VCPU, &slot_add_vcpu_re=
q,
> +			   sizeof(slot_add_vcpu_req), &cmd_reply,
> +			   sizeof(cmd_reply));
> +	if (rc < 0) {
> +		dev_err_ratelimited(ne_misc_dev.this_device,
> +				    "Error in slot add vcpu [rc=3D%d]\n", rc);
> +
> +		goto put_file;
> +	}
> +
> +	ne_vcpu_id->vcpu_id =3D vcpu_id;
> +
> +	list_add(&ne_vcpu_id->vcpu_id_list_entry, &ne_enclave->vcpu_ids_list);
> +
> +	ne_enclave->nr_vcpus++;
> +
> +	fd_install(fd, file);
> +
> +	return fd;
> +
> +put_file:
> +	fput(file);
> +put_fd:
> +	put_unused_fd(fd);
> +free_ne_vcpu_id:
> +	kfree(ne_vcpu_id);
> +
> +	return rc;
> +}
> +
> +static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
> +			     unsigned long arg)
> +{
> +	struct ne_enclave *ne_enclave =3D file->private_data;
> +
> +	if (!ne_enclave || !ne_enclave->pdev)
> +		return -EINVAL;
> +
> +	switch (cmd) {
> +	case NE_CREATE_VCPU: {

Can this be an ADD_VCPU rather than CREATE? We don't really need a vcpu =

fd after all ...


Alex

> +		int rc =3D -EINVAL;
> +		u32 vcpu_id =3D 0;
> +
> +		if (copy_from_user(&vcpu_id, (void *)arg, sizeof(vcpu_id))) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Error in copy from user\n");
> +
> +			return -EFAULT;
> +		}
> +
> +		mutex_lock(&ne_enclave->enclave_info_mutex);
> +
> +		if (ne_enclave->state !=3D NE_STATE_INIT) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Enclave isn't in init state\n");
> +
> +			mutex_unlock(&ne_enclave->enclave_info_mutex);
> +
> +			return -EINVAL;
> +		}
> +
> +		/* Use the CPU pool for choosing a CPU for the enclave. */
> +		rc =3D ne_get_cpu_from_cpu_pool(ne_enclave, &vcpu_id);
> +		if (rc < 0) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Error in get CPU from pool\n");
> +
> +			mutex_unlock(&ne_enclave->enclave_info_mutex);
> +
> +			return -EINVAL;
> +		}
> +
> +		rc =3D ne_create_vcpu_ioctl(ne_enclave, vcpu_id);
> +
> +		/* Put back the CPU in enclave cpu pool, if add vcpu error. */
> +		if (rc < 0)
> +			cpumask_set_cpu(vcpu_id, ne_enclave->cpu_siblings);
> +
> +		mutex_unlock(&ne_enclave->enclave_info_mutex);
> +
> +		if (copy_to_user((void *)arg, &vcpu_id, sizeof(vcpu_id))) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Error in copy to user\n");
> +
> +			return -EFAULT;
> +		}
> +
> +		return rc;
> +	}
> +
> +	default:
> +		return -ENOTTY;
> +	}
> +
> +	return 0;
> +}
> +
>   static __poll_t ne_enclave_poll(struct file *file, poll_table *wait)
>   {
>   	__poll_t mask =3D 0;
> @@ -79,6 +562,7 @@ static const struct file_operations ne_enclave_fops =
=3D {
>   	.owner		=3D THIS_MODULE,
>   	.llseek		=3D noop_llseek,
>   	.poll		=3D ne_enclave_poll,
> +	.unlocked_ioctl	=3D ne_enclave_ioctl,
>   };
>   =

>   /**
> @@ -286,8 +770,15 @@ static int __init ne_init(void)
>   =

>   static void __exit ne_exit(void)
>   {
> +	struct pci_dev *pdev =3D pci_get_device(PCI_VENDOR_ID_AMAZON,
> +					      PCI_DEVICE_ID_NE, NULL);
> +	if (!pdev)
> +		return;
> +
>   	pci_unregister_driver(&ne_pci_driver);
>   =

> +	ne_teardown_cpu_pool(pdev);
> +
>   	free_cpumask_var(ne_cpu_pool.avail);
>   }
>   =

> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



