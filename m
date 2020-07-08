Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2A42187F6
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 14:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgGHMrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 08:47:20 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:42513 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbgGHMrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 08:47:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594212432; x=1625748432;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=btrDV7aPAqvlElbvwAkFQmMKkQBqBqJee/b+p+KItns=;
  b=BTMibEBM7clfhfQcE58lc2X15T8a/0DnAHxuwxqvfdImA9EubWQF3DkV
   8+baYGBwfakQUMoJvZgxMD5pApWEd5ATnr7QWIXgH5dZIaGYqchWfz09u
   0T5Q7sidcfA0D/QLalOjvvKI3S/38jJZ4FCmr9P9z8tNaW0z469k5VY8p
   s=;
IronPort-SDR: WJyvA9mxqWowPK4+4DsGJk+1HdBnbhVPJuiWD4G58/KQ3uZWq44DaSP03TEWT9MJZ1FAOshrG9
 c/fx7KUis/nw==
X-IronPort-AV: E=Sophos;i="5.75,327,1589241600"; 
   d="scan'208";a="40844025"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 08 Jul 2020 12:47:11 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 0DDCDA26D6;
        Wed,  8 Jul 2020 12:47:09 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 8 Jul 2020 12:47:08 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.65) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 8 Jul 2020 12:46:58 +0000
Subject: Re: [PATCH v4 09/18] nitro_enclaves: Add logic for enclave vcpu
 creation
To:     Alexander Graf <graf@amazon.de>, <linux-kernel@vger.kernel.org>
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
 <52e916fc-8fe3-f9bc-009e-ca84ab7dd650@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <c56a653f-31ab-6c7f-6b30-6651e4c23d77@amazon.com>
Date:   Wed, 8 Jul 2020 15:46:44 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <52e916fc-8fe3-f9bc-009e-ca84ab7dd650@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D28UWC004.ant.amazon.com (10.43.162.24) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/07/2020 13:12, Alexander Graf wrote:
>
>
> On 22.06.20 22:03, Andra Paraschiv wrote:
>> An enclave, before being started, has its resources set. One of its
>> resources is CPU.
>>
>> The NE CPU pool is set for choosing CPUs for enclaves from it. Offline
>> the CPUs from the NE CPU pool during the pool setup and online them back
>> during the NE CPU pool teardown.
>>
>> The enclave CPUs need to be full cores and from the same NUMA node. CPU
>> 0 and its siblings have to remain available to the primary / parent VM.
>>
>> Add ioctl command logic for enclave vCPU creation. Return as result a
>> file descriptor that is associated with the enclave vCPU.
>>
>> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> ---
>> Changelog
>>
>> v3 -> v4
>>
>> * Setup the NE CPU pool at runtime via a sysfs file for the kernel
>> =A0=A0 parameter.
>> * Check enclave CPUs to be from the same NUMA node.
>> * Use dev_err instead of custom NE log pattern.
>> * Update the NE ioctl call to match the decoupling from the KVM API.
>>
>> v2 -> v3
>>
>> * Remove the WARN_ON calls.
>> * Update static calls sanity checks.
>> * Update kzfree() calls to kfree().
>> * Remove file ops that do nothing for now - open, ioctl and release.
>>
>> v1 -> v2
>>
>> * Add log pattern for NE.
>> * Update goto labels to match their purpose.
>> * Remove the BUG_ON calls.
>> * Check if enclave state is init when setting enclave vcpu.
>> ---
>> =A0 drivers/virt/nitro_enclaves/ne_misc_dev.c | 491 ++++++++++++++++++++=
++
>> =A0 1 file changed, 491 insertions(+)
>>
>> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

>> b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> index f70496813033..d6777008f685 100644
>> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> @@ -39,7 +39,11 @@
>> =A0=A0 * TODO: Update logic to create new sysfs entries instead of using
>> =A0=A0 * a kernel parameter e.g. if multiple sysfs files needed.
>> =A0=A0 */
>> +static int ne_set_kernel_param(const char *val, const struct =

>> kernel_param *kp);
>> +
>> =A0 static const struct kernel_param_ops ne_cpu_pool_ops =3D {
>> +=A0=A0=A0 .get =3D param_get_string,
>> +=A0=A0=A0 .set =3D ne_set_kernel_param,
>> =A0 };
>> =A0 =A0 static char ne_cpus[PAGE_SIZE];
>> @@ -60,6 +64,485 @@ struct ne_cpu_pool {
>> =A0 =A0 static struct ne_cpu_pool ne_cpu_pool;
>> =A0 +static const struct file_operations ne_enclave_vcpu_fops =3D {
>> +=A0=A0=A0 .owner=A0=A0=A0=A0=A0=A0=A0 =3D THIS_MODULE,
>> +=A0=A0=A0 .llseek=A0=A0=A0=A0=A0=A0=A0 =3D noop_llseek,
>> +};
>
> Do we really need an fd for an object without operations? I think the =

> general flow to add CPUs from the pool to the VM is very sensible. But =

> I don't think we really need an fd as return value from that operation.

Not particularly now, I kept it here for any potential further use cases =

where will need one and to make sure we take into account a stable =

interface and possibility for extensions.

As we've discussed that we can have as option for further extensions to =

add another ioctl which returns an fd, will update the current ioctl to =

keep the logic of adding a vCPU w/o generating an fd.

>
>> +
>> +/**
>> + * ne_check_enclaves_created - Verify if at least one enclave has =

>> been created.
>> + *
>> + * @pdev: PCI device used for enclave lifetime management.
>> + *
>> + * @returns: true if at least one enclave is created, false otherwise.
>> + */
>> +static bool ne_check_enclaves_created(struct pci_dev *pdev)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
>> +
>> +=A0=A0=A0 if (!ne_pci_dev)
>> +=A0=A0=A0=A0=A0=A0=A0 return false;
>
> Please pass in the ne_pci_dev into this function directly.

Updated the function signature.

>
>
>> +
>> +=A0=A0=A0 mutex_lock(&ne_pci_dev->enclaves_list_mutex);
>> +
>> +=A0=A0=A0 if (list_empty(&ne_pci_dev->enclaves_list)) {
>> +=A0=A0=A0=A0=A0=A0=A0 mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return false;
>
> If you make this a return variable, you save on the unlock duplication.

Updated the logic to use a ret var.

>
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
>> +
>> +=A0=A0=A0 return true;
>> +}
>> +
>> +/**
>> + * ne_setup_cpu_pool - Set the NE CPU pool after handling sanity =

>> checks such as
>> + * not sharing CPU cores with the primary / parent VM or not using =

>> CPU 0, which
>> + * should remain available for the primary / parent VM. Offline the =

>> CPUs from
>> + * the pool after the checks passed.
>> + *
>> + * @pdev: PCI device used for enclave lifetime management.
>> + * @ne_cpu_list: the CPU list used for setting NE CPU pool.
>> + *
>> + * @returns: 0 on success, negative return value on failure.
>> + */
>> +static int ne_setup_cpu_pool(struct pci_dev *pdev, const char =

>> *ne_cpu_list)
>> +{
>> +=A0=A0=A0 unsigned int cpu =3D 0;
>> +=A0=A0=A0 unsigned int cpu_sibling =3D 0;
>> +=A0=A0=A0 int numa_node =3D -1;
>> +=A0=A0=A0 int rc =3D -EINVAL;
>> +
>> +=A0=A0=A0 if (!capable(CAP_SYS_ADMIN)) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "No admin capability for CPU =
pool =

>> setup\n");
>
> No need to print anything here. It only gives non-admin users a chance =

> to spill the kernel log. If non-admin users can write at all? Can they?
>
> Also, isn't this at the wrong abstraction level? I would expect such a =

> check to happen on the file write function, not here.

Removed the log. Non-admin users don't have the permission to write, =

that's the default file permission set. I wanted to guard the offline / =

online of the CPUs anyway with this check.

True, I already moved the check when writing (setting) the cpu list in =

the file when I started to work on v5.

>
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return -EPERM;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 if (!ne_cpu_list)
>> +=A0=A0=A0=A0=A0=A0=A0 return 0;
>> +
>> +=A0=A0=A0 if (ne_check_enclaves_created(pdev)) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "The CPU pool is used, enclav=
es =

>> created\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 mutex_lock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0 rc =3D cpulist_parse(ne_cpu_list, ne_cpu_pool.avail);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Error in cpulist parse [rc=3D%d]\n",=
 rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto unlock_mutex;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * Check if CPU 0 and its siblings are included in the prov=
ided =

>> CPU pool
>> +=A0=A0=A0=A0 * They should remain available for the primary / parent VM.
>> +=A0=A0=A0=A0 */
>> +=A0=A0=A0 if (cpumask_test_cpu(0, ne_cpu_pool.avail)) {
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "CPU 0 has to remain available for th=
e primary VM\n");
>
> Shouldn't this also change the read value of the sysfs file?

Yes, I already updated the logic in v5 to set an empty string for sysfs =

file value when there are failures in setting the CPU pool.

>
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto unlock_mutex;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 for_each_cpu(cpu_sibling, topology_sibling_cpumask(0)) {
>> +=A0=A0=A0=A0=A0=A0=A0 if (cpumask_test_cpu(cpu_sibling, ne_cpu_pool.ava=
il)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "CPU sibling %d of CPU 0 =
is in the CPU pool\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpu_sibling);
>
> Same here. I would expect the sysfs file to reflect either the =

> previous state or <empty> because failures mean no CPUs are donated =

> anymore.
>
> Can we somehow implement the get function of the param as something =

> that gets generated dynamically?

I already updated the logic to set the string value of the CPU pool to =

an empty string and clear our internal data structure, the cpumask. This =

way, an empty sysfs file means no CPUs are set and all the CPUs are =

onlined back.

The CPU pool sysfs file value setup in v5 includes an early exit check - =

if enclaves are available, the CPU pool cannot be changed anymore.

Sure, we could have a custom get function, but I just haven't seen for =

now a need to have one replacing the current (default) implementation =

provided by the kernel.

>
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto unlock_mutex;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * Check if CPU siblings are included in the provided CPU p=
ool. The
>> +=A0=A0=A0=A0 * expectation is that CPU cores are made available in the =
CPU =

>> pool for
>> +=A0=A0=A0=A0 * enclaves.
>> +=A0=A0=A0=A0 */
>> +=A0=A0=A0 for_each_cpu(cpu, ne_cpu_pool.avail) {
>> +=A0=A0=A0=A0=A0=A0=A0 for_each_cpu(cpu_sibling, topology_sibling_cpumas=
k(cpu)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!cpumask_test_cpu(cpu_sibling, ne=
_cpu_pool.avail)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "CPU %d is no=
t in the CPU pool\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpu_sibling);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto unlock_mutex;
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * Check if the CPUs from the NE CPU pool are from the same=
 NUMA =

>> node.
>> +=A0=A0=A0=A0 */
>> +=A0=A0=A0 for_each_cpu(cpu, ne_cpu_pool.avail) {
>> +=A0=A0=A0=A0=A0=A0=A0 if (numa_node < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 numa_node =3D cpu_to_node(cpu);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (numa_node < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Invalid NUMA=
 node %d\n", numa_node);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto unlock_mutex;
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0=A0=A0=A0=A0 } else {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (numa_node !=3D cpu_to_node(cpu)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "CPUs are fro=
m different NUMA nodes\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto unlock_mutex;
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0 }
>> +
>
> There should be a comment here that describes the why:
>
> /*
> =A0* CPUs that are donated to enclaves should not be considered online
> =A0* by Linux anymore, as the hypervisor will degrade them to floating.
> =A0*
> =A0* We offline them here, to not degrade performance and expose correct
> =A0* topology to Linux and user space.
> =A0*/

Good point. Added here and also included in the commit message the =

motivation for offlining / onlining the CPUs from the pool.

>
>> +=A0=A0=A0 for_each_cpu(cpu, ne_cpu_pool.avail) {
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D remove_cpu(cpu);
>> +=A0=A0=A0=A0=A0=A0=A0 if (rc !=3D 0) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "CPU %d is not offlined [=
rc=3D%d]\n", cpu, rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto online_cpus;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 mutex_unlock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0 return 0;
>> +
>> +online_cpus:
>> +=A0=A0=A0 for_each_cpu(cpu, ne_cpu_pool.avail)
>> +=A0=A0=A0=A0=A0=A0=A0 add_cpu(cpu);
>> +unlock_mutex:
>> +=A0=A0=A0 mutex_unlock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0 return rc;
>> +}
>> +
>> +/**
>> + * ne_teardown_cpu_pool - Online the CPUs from the NE CPU pool and =

>> cleanup the
>> + * CPU pool.
>> + *
>> + * @pdev: PCI device used for enclave lifetime management.
>> + */
>> +static void ne_teardown_cpu_pool(struct pci_dev *pdev)
>> +{
>> +=A0=A0=A0 unsigned int cpu =3D 0;
>> +=A0=A0=A0 int rc =3D -EINVAL;
>> +
>> +=A0=A0=A0 if (!capable(CAP_SYS_ADMIN)) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "No admin capability for CPU =
pool =

>> setup\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 if (!ne_cpu_pool.avail)
>> +=A0=A0=A0=A0=A0=A0=A0 return;
>> +
>> +=A0=A0=A0 if (ne_check_enclaves_created(pdev)) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "The CPU pool is used, enclav=
es =

>> created\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 mutex_lock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0 for_each_cpu(cpu, ne_cpu_pool.avail) {
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D add_cpu(cpu);
>> +=A0=A0=A0=A0=A0=A0=A0 if (rc !=3D 0)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "CPU %d is not onlined [r=
c=3D%d]\n", cpu, rc);
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 cpumask_clear(ne_cpu_pool.avail);
>> +
>> +=A0=A0=A0 mutex_unlock(&ne_cpu_pool.mutex);
>> +}
>> +
>> +static int ne_set_kernel_param(const char *val, const struct =

>> kernel_param *kp)
>> +{
>> +=A0=A0=A0 const char *ne_cpu_list =3D val;
>> +=A0=A0=A0 struct pci_dev *pdev =3D pci_get_device(PCI_VENDOR_ID_AMAZON,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 PCI_DEVICE_ID_NE, NULL);
>
> Isn't there a better way?

Yeah, I'm looking for options to update the logic to not use the =

pci_get_device() call where it appears in the patch series. Also pointed =

out in the discussion I've had before with Greg on a patch from the =

current version.

>
>> +=A0=A0=A0 int rc =3D -EINVAL;
>> +
>> +=A0=A0=A0 if (!pdev)
>> +=A0=A0=A0=A0=A0=A0=A0 return -ENODEV;
>> +
>> +=A0=A0=A0 ne_teardown_cpu_pool(pdev);
>> +
>> +=A0=A0=A0 rc =3D ne_setup_cpu_pool(pdev, ne_cpu_list);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "Error in setup CPU pool [rc=
=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return rc;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 return param_set_copystring(val, kp);
>> +}
>> +
>> +/**
>> + * ne_get_cpu_from_cpu_pool - Get a CPU from the CPU pool. If the =

>> vCPU id is 0,
>> + * the CPU is autogenerated and chosen from the NE CPU pool.
>> + *
>> + * This function gets called with the ne_enclave mutex held.
>> + *
>> + * @ne_enclave: private data associated with the current enclave.
>> + * @vcpu_id: id of the CPU to be associated with the given slot, =

>> apic id on x86.
>> + *
>> + * @returns: 0 on success, negative return value on failure.
>> + */
>> +static int ne_get_cpu_from_cpu_pool(struct ne_enclave *ne_enclave, =

>> u32 *vcpu_id)
>
> That's a very awkward API. Can you instead just pass by-value and =

> return the resulting CPU ID?

I separated the whole logic in 2 functions, one for getting a CPU from =

the pool and one for checking a given CPU is in the pool.

>
>> +{
>> +=A0=A0=A0 unsigned int cpu =3D 0;
>> +=A0=A0=A0 unsigned int cpu_sibling =3D 0;
>> +
>> +=A0=A0=A0 if (*vcpu_id !=3D 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 if (cpumask_test_cpu(*vcpu_id, ne_enclave->cpu_si=
blings)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpumask_clear_cpu(*vcpu_id, ne_enclav=
e->cpu_siblings);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 mutex_lock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (!cpumask_test_cpu(*vcpu_id, ne_cpu_pool.avail=
)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
CPU %d is not in NE CPU pool\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=
vcpu_id);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mutex_unlock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>
> I think you're better off making the return value explicit for the =

> error, so that user space can print the error message rather than us.

Yup, will update the patch series to use NE specific errors in cases =

where necessary like this one.

>
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 cpumask_clear_cpu(*vcpu_id, ne_cpu_pool.avail);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 /*
>> +=A0=A0=A0=A0=A0=A0=A0=A0 * Make sure the CPU siblings are not marked as=
 available
>> +=A0=A0=A0=A0=A0=A0=A0=A0 * anymore.
>> +=A0=A0=A0=A0=A0=A0=A0=A0 */
>> +=A0=A0=A0=A0=A0=A0=A0 for_each_cpu(cpu_sibling, topology_sibling_cpumas=
k(*vcpu_id)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (cpu_sibling !=3D *vcpu_id) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpumask_clear_cpu(cpu_sib=
ling,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 ne_cpu_pool.avail);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpumask_set_cpu(cpu_sibli=
ng,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 n=
e_enclave->cpu_siblings);
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 mutex_unlock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return 0;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 /* There are CPU siblings available to choose from. */
>> +=A0=A0=A0 cpu =3D cpumask_any(ne_enclave->cpu_siblings);
>> +=A0=A0=A0 if (cpu < nr_cpu_ids) {
>> +=A0=A0=A0=A0=A0=A0=A0 cpumask_clear_cpu(cpu, ne_enclave->cpu_siblings);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 *vcpu_id =3D cpu;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return 0;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 mutex_lock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0 /* Choose any CPU from the available CPU pool. */
>> +=A0=A0=A0 cpu =3D cpumask_any(ne_cpu_pool.avail);
>> +=A0=A0=A0 if (cpu >=3D nr_cpu_ids) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "No CPUs avai=
lable in CPU pool\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 mutex_unlock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>
> I think you're better off making the return value explicit for the =

> error, so that user space can print the error message rather than us.
>
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 cpumask_clear_cpu(cpu, ne_cpu_pool.avail);
>> +
>> +=A0=A0=A0 /* Make sure the CPU siblings are not marked as available =

>> anymore. */
>> +=A0=A0=A0 for_each_cpu(cpu_sibling, topology_sibling_cpumask(cpu)) {
>> +=A0=A0=A0=A0=A0=A0=A0 if (cpu_sibling !=3D cpu) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpumask_clear_cpu(cpu_sibling, ne_cpu=
_pool.avail);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpumask_set_cpu(cpu_sibling, ne_encla=
ve->cpu_siblings);
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 mutex_unlock(&ne_cpu_pool.mutex);
>
> I find the function slightly confusingly structured. Why can't we do =

> something like
>
>
> =A0 if (!vcpu_id) {
> =A0=A0=A0 vcpu_id =3D find_next_free_vcpu_id();
> =A0=A0=A0 if (vcpu_id < 0)
> =A0=A0=A0=A0=A0=A0=A0 return -ENOSPC;
> =A0 }
>
> =A0 [logic to handle an explicit vcpu id]
>
> I think that would be much more readable.

The logic is now separated in 2 functions, one for checking the CPU is =

in the pool and one for getting a CPU from the pool.

>
>> +
>> +=A0=A0=A0 *vcpu_id =3D cpu;
>> +
>> +=A0=A0=A0 return 0;
>> +}
>> +
>> +/**
>> + * ne_create_vcpu_ioctl - Add vCPU to the slot associated with the =

>> current
>> + * enclave. Create vCPU file descriptor to be further used for CPU =

>> handling.
>> + *
>> + * This function gets called with the ne_enclave mutex held.
>> + *
>> + * @ne_enclave: private data associated with the current enclave.
>> + * @vcpu_id: id of the CPU to be associated with the given slot, =

>> apic id on x86.
>> + *
>> + * @returns: vCPU fd on success, negative return value on failure.
>> + */
>> +static int ne_create_vcpu_ioctl(struct ne_enclave *ne_enclave, u32 =

>> vcpu_id)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev_cmd_reply cmd_reply =3D {};
>> +=A0=A0=A0 int fd =3D 0;
>> +=A0=A0=A0 struct file *file =3D NULL;
>> +=A0=A0=A0 struct ne_vcpu_id *ne_vcpu_id =3D NULL;
>> +=A0=A0=A0 int rc =3D -EINVAL;
>> +=A0=A0=A0 struct slot_add_vcpu_req slot_add_vcpu_req =3D {};
>> +
>> +=A0=A0=A0 if (ne_enclave->mm !=3D current->mm)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EIO;
>> +
>> +=A0=A0=A0 ne_vcpu_id =3D kzalloc(sizeof(*ne_vcpu_id), GFP_KERNEL);
>> +=A0=A0=A0 if (!ne_vcpu_id)
>> +=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
>> +
>> +=A0=A0=A0 fd =3D get_unused_fd_flags(O_CLOEXEC);
>> +=A0=A0=A0 if (fd < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D fd;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Error in get=
ting unused fd [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto free_ne_vcpu_id;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 /* TODO: Include (vcpu) id in the ne-vm-vcpu naming. */
>> +=A0=A0=A0 file =3D anon_inode_getfile("ne-vm-vcpu", &ne_enclave_vcpu_fo=
ps,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_enclave, O_RDWR);
>> +=A0=A0=A0 if (IS_ERR(file)) {
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D PTR_ERR(file);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Error in ano=
n inode get file [rc=3D%d]\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto put_fd;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 slot_add_vcpu_req.slot_uid =3D ne_enclave->slot_uid;
>> +=A0=A0=A0 slot_add_vcpu_req.vcpu_id =3D vcpu_id;
>> +
>> +=A0=A0=A0 rc =3D ne_do_request(ne_enclave->pdev, SLOT_ADD_VCPU, =

>> &slot_add_vcpu_req,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(slot_add_vcpu_req), &=
cmd_reply,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(cmd_reply));
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Error in slo=
t add vcpu [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto put_file;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 ne_vcpu_id->vcpu_id =3D vcpu_id;
>> +
>> +=A0=A0=A0 list_add(&ne_vcpu_id->vcpu_id_list_entry, =

>> &ne_enclave->vcpu_ids_list);
>> +
>> +=A0=A0=A0 ne_enclave->nr_vcpus++;
>> +
>> +=A0=A0=A0 fd_install(fd, file);
>> +
>> +=A0=A0=A0 return fd;
>> +
>> +put_file:
>> +=A0=A0=A0 fput(file);
>> +put_fd:
>> +=A0=A0=A0 put_unused_fd(fd);
>> +free_ne_vcpu_id:
>> +=A0=A0=A0 kfree(ne_vcpu_id);
>> +
>> +=A0=A0=A0 return rc;
>> +}
>> +
>> +static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long arg)
>> +{
>> +=A0=A0=A0 struct ne_enclave *ne_enclave =3D file->private_data;
>> +
>> +=A0=A0=A0 if (!ne_enclave || !ne_enclave->pdev)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +
>> +=A0=A0=A0 switch (cmd) {
>> +=A0=A0=A0 case NE_CREATE_VCPU: {
>
> Can this be an ADD_VCPU rather than CREATE? We don't really need a =

> vcpu fd after all ...

I updated the ioctl call.

Thanks for review.

Andra

>
>> +=A0=A0=A0=A0=A0=A0=A0 int rc =3D -EINVAL;
>> +=A0=A0=A0=A0=A0=A0=A0 u32 vcpu_id =3D 0;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (copy_from_user(&vcpu_id, (void *)arg, sizeof(=
vcpu_id))) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
Error in copy from user\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EFAULT;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 mutex_lock(&ne_enclave->enclave_info_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (ne_enclave->state !=3D NE_STATE_INIT) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
Enclave isn't in init state\n");
>> +
>> + mutex_unlock(&ne_enclave->enclave_info_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 /* Use the CPU pool for choosing a CPU for the en=
clave. */
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D ne_get_cpu_from_cpu_pool(ne_enclave, &vcpu=
_id);
>> +=A0=A0=A0=A0=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
Error in get CPU from pool\n");
>> +
>> + mutex_unlock(&ne_enclave->enclave_info_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D ne_create_vcpu_ioctl(ne_enclave, vcpu_id);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 /* Put back the CPU in enclave cpu pool, if add v=
cpu error. */
>> +=A0=A0=A0=A0=A0=A0=A0 if (rc < 0)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpumask_set_cpu(vcpu_id, ne_enclave->=
cpu_siblings);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 mutex_unlock(&ne_enclave->enclave_info_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (copy_to_user((void *)arg, &vcpu_id, sizeof(vc=
pu_id))) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
Error in copy to user\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EFAULT;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return rc;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 default:
>> +=A0=A0=A0=A0=A0=A0=A0 return -ENOTTY;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 return 0;
>> +}
>> +
>> =A0 static __poll_t ne_enclave_poll(struct file *file, poll_table *wait)
>> =A0 {
>> =A0=A0=A0=A0=A0 __poll_t mask =3D 0;
>> @@ -79,6 +562,7 @@ static const struct file_operations =

>> ne_enclave_fops =3D {
>> =A0=A0=A0=A0=A0 .owner=A0=A0=A0=A0=A0=A0=A0 =3D THIS_MODULE,
>> =A0=A0=A0=A0=A0 .llseek=A0=A0=A0=A0=A0=A0=A0 =3D noop_llseek,
>> =A0=A0=A0=A0=A0 .poll=A0=A0=A0=A0=A0=A0=A0 =3D ne_enclave_poll,
>> +=A0=A0=A0 .unlocked_ioctl=A0=A0=A0 =3D ne_enclave_ioctl,
>> =A0 };
>> =A0 =A0 /**
>> @@ -286,8 +770,15 @@ static int __init ne_init(void)
>> =A0 =A0 static void __exit ne_exit(void)
>> =A0 {
>> +=A0=A0=A0 struct pci_dev *pdev =3D pci_get_device(PCI_VENDOR_ID_AMAZON,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 PCI_DEVICE_ID_NE, NULL);
>> +=A0=A0=A0 if (!pdev)
>> +=A0=A0=A0=A0=A0=A0=A0 return;
>> +
>> =A0=A0=A0=A0=A0 pci_unregister_driver(&ne_pci_driver);
>> =A0 +=A0=A0=A0 ne_teardown_cpu_pool(pdev);
>> +
>> =A0=A0=A0=A0=A0 free_cpumask_var(ne_cpu_pool.avail);
>> =A0 }
>>




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

