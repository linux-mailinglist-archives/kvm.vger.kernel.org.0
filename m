Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636A824188E
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 10:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgHKIxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 04:53:16 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:7648 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbgHKIxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 04:53:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597135993; x=1628671993;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=FWbjcIIy9qAWHz0N9NIDChWuYfhn60RXzI91q5ZsV00=;
  b=OxNlOOM7ZtaWD7Fyor/VkZQD5YCpsQLGMq4+3+9h5joiAYl91eMTq4vX
   cwGRvX4CDKmIm9oQWgwXo1B6JQfTNaPYmzoGF5EIzEt4qgl59M4lKNK6y
   xxfxzZJ3O0xbzhnaKNx+rBVgN8RkU7FLfl25nuRc+cIDlHsWvm1f/9AZo
   E=;
IronPort-SDR: 5fHRMBgd32gqLJBJ4ktyTqAtYinZhL9bdwbr4uTUWZJN1GNp7bmkksfdt/kVYZ+GrV661gO/yV
 9hD4f/w60mxQ==
X-IronPort-AV: E=Sophos;i="5.75,460,1589241600"; 
   d="scan'208";a="47156287"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 11 Aug 2020 08:53:11 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id F2397A18C4;
        Tue, 11 Aug 2020 08:53:08 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 11 Aug 2020 08:53:08 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.85) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 11 Aug 2020 08:52:59 +0000
Subject: Re: [PATCH v6 09/18] nitro_enclaves: Add logic for setting an enclave
 vCPU
To:     Alexander Graf <graf@amazon.de>,
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
 <7adb6707-4101-8f47-6497-fe086dcc11f3@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <3e0b47e0-50b7-06c3-f9c4-7f7445c5d694@amazon.com>
Date:   Tue, 11 Aug 2020 11:52:54 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.0
MIME-Version: 1.0
In-Reply-To: <7adb6707-4101-8f47-6497-fe086dcc11f3@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D25UWB004.ant.amazon.com (10.43.161.180) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/08/2020 10:33, Alexander Graf wrote:
>
>
> On 05.08.20 11:10, Andra Paraschiv wrote:
>> An enclave, before being started, has its resources set. One of its
>> resources is CPU.
>>
>> A NE CPU pool is set and enclave CPUs are chosen from it. Offline the
>> CPUs from the NE CPU pool during the pool setup and online them back
>> during the NE CPU pool teardown. The CPU offline is necessary so that
>> there would not be more vCPUs than physical CPUs available to the
>> primary / parent VM. In that case the CPUs would be overcommitted and
>> would change the initial configuration of the primary / parent VM of
>> having dedicated vCPUs to physical CPUs.
>>
>> The enclave CPUs need to be full cores and from the same NUMA node. CPU
>> 0 and its siblings have to remain available to the primary / parent VM.
>>
>> Add ioctl command logic for setting an enclave vCPU.
>>
>> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> ---
>> Changelog
>>
>> v5 -> v6
>>
>> * Check CPUs are from the same NUMA node before going through CPU
>> =A0=A0 siblings during the NE CPU pool setup.
>> * Update documentation to kernel-doc format.
>>
>> v4 -> v5
>>
>> * Set empty string in case of invalid NE CPU pool.
>> * Clear NE CPU pool mask on pool setup failure.
>> * Setup NE CPU cores out of the NE CPU pool.
>> * Early exit on NE CPU pool setup if enclave(s) already running.
>> * Remove sanity checks for situations that shouldn't happen, only if
>> =A0=A0 buggy system or broken logic at all.
>> * Add check for maximum vCPU id possible before looking into the CPU
>> =A0=A0 pool.
>> * Remove log on copy_from_user() / copy_to_user() failure and on admin
>> =A0=A0 capability check for setting the NE CPU pool.
>> * Update the ioctl call to not create a file descriptor for the vCPU.
>> * Split the CPU pool usage logic in 2 separate functions - one to get a
>> =A0=A0 CPU from the pool and the other to check the given CPU is =

>> available in
>> =A0=A0 the pool.
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
>> * Check if enclave state is init when setting enclave vCPU.
>> ---
>> =A0 drivers/virt/nitro_enclaves/ne_misc_dev.c | 575 ++++++++++++++++++++=
++
>> =A0 1 file changed, 575 insertions(+)
>>
>> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

>> b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> index 6c8c12f65666..4787bc59d39d 100644
>> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> @@ -57,8 +57,11 @@
>> =A0=A0 * TODO: Update logic to create new sysfs entries instead of using
>> =A0=A0 * a kernel parameter e.g. if multiple sysfs files needed.
>> =A0=A0 */
>> +static int ne_set_kernel_param(const char *val, const struct =

>> kernel_param *kp);
>> +
>> =A0 static const struct kernel_param_ops ne_cpu_pool_ops =3D {
>> =A0=A0=A0=A0=A0 .get=A0=A0=A0 =3D param_get_string,
>> +=A0=A0=A0 .set=A0=A0=A0 =3D ne_set_kernel_param,
>> =A0 };
>> =A0 =A0 static char ne_cpus[NE_CPUS_SIZE];
>> @@ -87,6 +90,575 @@ struct ne_cpu_pool {
>> =A0 =A0 static struct ne_cpu_pool ne_cpu_pool;
>> =A0 +/**
>> + * ne_check_enclaves_created() - Verify if at least one enclave has =

>> been created.
>> + * @void:=A0=A0=A0 No parameters provided.
>> + *
>> + * Context: Process context.
>> + * Return:
>> + * * True if at least one enclave is created.
>> + * * False otherwise.
>> + */
>> +static bool ne_check_enclaves_created(void)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D NULL;
>> +=A0=A0=A0 /* TODO: Find another way to get the NE PCI device reference.=
 */
>> +=A0=A0=A0 struct pci_dev *pdev =3D pci_get_device(PCI_VENDOR_ID_AMAZON, =

>> PCI_DEVICE_ID_NE, NULL);
>
> Can we just make this a global ref count instead?

I think we can use here as well the misc dev parent approach mentioned =

in the previous patches in this series. If no parent dev set, early exit.

>
>> +=A0=A0=A0 bool ret =3D false;
>> +
>> +=A0=A0=A0 if (!pdev)
>> +=A0=A0=A0=A0=A0=A0=A0 return ret;
>> +
>> +=A0=A0=A0 ne_pci_dev =3D pci_get_drvdata(pdev);
>> +=A0=A0=A0 if (!ne_pci_dev) {
>> +=A0=A0=A0=A0=A0=A0=A0 pci_dev_put(pdev);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return ret;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 mutex_lock(&ne_pci_dev->enclaves_list_mutex);
>> +
>> +=A0=A0=A0 if (!list_empty(&ne_pci_dev->enclaves_list))
>> +=A0=A0=A0=A0=A0=A0=A0 ret =3D true;
>> +
>> +=A0=A0=A0 mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
>> +
>> +=A0=A0=A0 pci_dev_put(pdev);
>> +
>> +=A0=A0=A0 return ret;
>> +}
>> +
>> +/**
>> + * ne_setup_cpu_pool() - Set the NE CPU pool after handling sanity =

>> checks such
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 as not sharing CPU cores with th=
e primary / parent VM
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 or not using CPU 0, which should=
 remain available for
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 the primary / parent VM. Offline=
 the CPUs from the
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pool after the checks passed.
>> + * @ne_cpu_list:=A0=A0=A0 The CPU list used for setting NE CPU pool.
>> + *
>> + * Context: Process context.
>> + * Return:
>> + * * 0 on success.
>> + * * Negative return value on failure.
>> + */
>> +static int ne_setup_cpu_pool(const char *ne_cpu_list)
>> +{
>> +=A0=A0=A0 int core_id =3D -1;
>> +=A0=A0=A0 unsigned int cpu =3D 0;
>> +=A0=A0=A0 cpumask_var_t cpu_pool =3D NULL;
>> +=A0=A0=A0 unsigned int cpu_sibling =3D 0;
>> +=A0=A0=A0 unsigned int i =3D 0;
>> +=A0=A0=A0 int numa_node =3D -1;
>> +=A0=A0=A0 int rc =3D -EINVAL;
>> +
>> +=A0=A0=A0 if (!ne_cpu_list)
>> +=A0=A0=A0=A0=A0=A0=A0 return 0;
>> +
>> +=A0=A0=A0 if (!zalloc_cpumask_var(&cpu_pool, GFP_KERNEL))
>> +=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
>> +
>> +=A0=A0=A0 mutex_lock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0 rc =3D cpulist_parse(ne_cpu_list, cpu_pool);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 pr_err("%s: Error in cpulist parse [rc=3D%d]\n", =

>> ne_misc_dev.name, rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto free_pool_cpumask;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 cpu =3D cpumask_any(cpu_pool);
>> +=A0=A0=A0 if (cpu >=3D nr_cpu_ids) {
>> +=A0=A0=A0=A0=A0=A0=A0 pr_err("%s: No CPUs available in CPU pool\n", =

>> ne_misc_dev.name);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto free_pool_cpumask;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * Check if the CPUs from the NE CPU pool are from the same=
 NUMA =

>> node.
>> +=A0=A0=A0=A0 */
>> +=A0=A0=A0 for_each_cpu(cpu, cpu_pool) {
>> +=A0=A0=A0=A0=A0=A0=A0 if (numa_node < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 numa_node =3D cpu_to_node(cpu);
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (numa_node < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pr_err("%s: Invalid NUMA =
node %d\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_m=
isc_dev.name, numa_node);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto free_pool_cpumask;
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0=A0=A0=A0=A0 } else {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (numa_node !=3D cpu_to_node(cpu)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pr_err("%s: CPUs with dif=
ferent NUMA nodes\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_m=
isc_dev.name);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto free_pool_cpumask;
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * Check if CPU 0 and its siblings are included in the prov=
ided =

>> CPU pool
>> +=A0=A0=A0=A0 * They should remain available for the primary / parent VM.
>> +=A0=A0=A0=A0 */
>> +=A0=A0=A0 if (cpumask_test_cpu(0, cpu_pool)) {
>> +=A0=A0=A0=A0=A0=A0=A0 pr_err("%s: CPU 0 has to remain available\n", =

>> ne_misc_dev.name);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto free_pool_cpumask;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 for_each_cpu(cpu_sibling, topology_sibling_cpumask(0)) {
>> +=A0=A0=A0=A0=A0=A0=A0 if (cpumask_test_cpu(cpu_sibling, cpu_pool)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pr_err("%s: CPU sibling %d for CPU 0 =
is in CPU pool\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_misc_dev.name=
, cpu_sibling);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto free_pool_cpumask;
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
>> +=A0=A0=A0 for_each_cpu(cpu, cpu_pool) {
>> +=A0=A0=A0=A0=A0=A0=A0 for_each_cpu(cpu_sibling, topology_sibling_cpumas=
k(cpu)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!cpumask_test_cpu(cpu_sibling, cp=
u_pool)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pr_err("%s: CPU %d is not=
 in CPU pool\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_m=
isc_dev.name, cpu_sibling);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto free_pool_cpumask;
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 ne_cpu_pool.avail_cores_size =3D nr_cpu_ids / smp_num_sibling=
s;
>> +
>> +=A0=A0=A0 ne_cpu_pool.avail_cores =3D kcalloc(ne_cpu_pool.avail_cores_s=
ize,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(=
*ne_cpu_pool.avail_cores),
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 GFP_KER=
NEL);
>> +=A0=A0=A0 if (!ne_cpu_pool.avail_cores) {
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D -ENOMEM;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto free_pool_cpumask;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 for (i =3D 0; i < ne_cpu_pool.avail_cores_size; i++)
>> +=A0=A0=A0=A0=A0=A0=A0 if (!zalloc_cpumask_var(&ne_cpu_pool.avail_cores[=
i], =

>> GFP_KERNEL)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -ENOMEM;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto free_cores_cpumask;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0 /* Split the NE CPU pool in CPU cores. */
>> +=A0=A0=A0 for_each_cpu(cpu, cpu_pool) {
>> +=A0=A0=A0=A0=A0=A0=A0 core_id =3D topology_core_id(cpu);
>> +=A0=A0=A0=A0=A0=A0=A0 if (core_id < 0 || core_id >=3D ne_cpu_pool.avail=
_cores_size) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pr_err("%s: Invalid core id=A0 %d\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_misc_dev.name=
, core_id);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto clear_cpumask;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 cpumask_set_cpu(cpu, ne_cpu_pool.avail_cores[core=
_id]);
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * CPUs that are given to enclave(s) should not be consider=
ed =

>> online
>> +=A0=A0=A0=A0 * by Linux anymore, as the hypervisor will degrade them to =

>> floating.
>> +=A0=A0=A0=A0 * The physical CPUs (full cores) are carved out of the pri=
mary =

>> / parent
>> +=A0=A0=A0=A0 * VM and given to the enclave VM. The same number of vCPUs =

>> would run
>> +=A0=A0=A0=A0 * on less pCPUs for the primary / parent VM.
>> +=A0=A0=A0=A0 *
>> +=A0=A0=A0=A0 * We offline them here, to not degrade performance and exp=
ose =

>> correct
>> +=A0=A0=A0=A0 * topology to Linux and user space.
>> +=A0=A0=A0=A0 */
>> +=A0=A0=A0 for_each_cpu(cpu, cpu_pool) {
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D remove_cpu(cpu);
>> +=A0=A0=A0=A0=A0=A0=A0 if (rc !=3D 0) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pr_err("%s: CPU %d is not offlined [r=
c=3D%d]\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_misc_dev.name=
, cpu, rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto online_cpus;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 free_cpumask_var(cpu_pool);
>> +
>> +=A0=A0=A0 ne_cpu_pool.numa_node =3D numa_node;
>> +
>> +=A0=A0=A0 mutex_unlock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0 return 0;
>> +
>> +online_cpus:
>> +=A0=A0=A0 for_each_cpu(cpu, cpu_pool)
>> +=A0=A0=A0=A0=A0=A0=A0 add_cpu(cpu);
>> +clear_cpumask:
>> +=A0=A0=A0 for (i =3D 0; i < ne_cpu_pool.avail_cores_size; i++)
>> +=A0=A0=A0=A0=A0=A0=A0 cpumask_clear(ne_cpu_pool.avail_cores[i]);
>> +free_cores_cpumask:
>> +=A0=A0=A0 for (i =3D 0; i < ne_cpu_pool.avail_cores_size; i++)
>> +=A0=A0=A0=A0=A0=A0=A0 free_cpumask_var(ne_cpu_pool.avail_cores[i]);
>> +=A0=A0=A0 kfree(ne_cpu_pool.avail_cores);
>> +=A0=A0=A0 ne_cpu_pool.avail_cores_size =3D 0;
>> +free_pool_cpumask:
>> +=A0=A0=A0 free_cpumask_var(cpu_pool);
>> +=A0=A0=A0 mutex_unlock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0 return rc;
>> +}
>> +
>> +/**
>> + * ne_teardown_cpu_pool() - Online the CPUs from the NE CPU pool and =

>> cleanup the
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 CPU pool.
>> + * @void:=A0=A0=A0 No parameters provided.
>> + *
>> + * Context: Process context.
>> + */
>> +static void ne_teardown_cpu_pool(void)
>> +{
>> +=A0=A0=A0 unsigned int cpu =3D 0;
>> +=A0=A0=A0 unsigned int i =3D 0;
>> +=A0=A0=A0 int rc =3D -EINVAL;
>> +
>> +=A0=A0=A0 mutex_lock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0 if (!ne_cpu_pool.avail_cores_size) {
>> +=A0=A0=A0=A0=A0=A0=A0 mutex_unlock(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 for (i =3D 0; i < ne_cpu_pool.avail_cores_size; i++) {
>> +=A0=A0=A0=A0=A0=A0=A0 for_each_cpu(cpu, ne_cpu_pool.avail_cores[i]) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D add_cpu(cpu);
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (rc !=3D 0)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pr_err("%s: CPU %d is not=
 onlined [rc=3D%d]\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_m=
isc_dev.name, cpu, rc);
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 cpumask_clear(ne_cpu_pool.avail_cores[i]);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 free_cpumask_var(ne_cpu_pool.avail_cores[i]);
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 kfree(ne_cpu_pool.avail_cores);
>> +=A0=A0=A0 ne_cpu_pool.avail_cores_size =3D 0;
>> +
>> +=A0=A0=A0 mutex_unlock(&ne_cpu_pool.mutex);
>> +}
>> +
>> +/**
>> + * ne_set_kernel_param() - Set the NE CPU pool value via the NE =

>> kernel parameter.
>> + * @val:=A0=A0=A0 NE CPU pool string value.
>> + * @kp :=A0=A0=A0 NE kernel parameter associated with the NE CPU pool.
>> + *
>> + * Context: Process context.
>> + * Return:
>> + * * 0 on success.
>> + * * Negative return value on failure.
>> + */
>> +static int ne_set_kernel_param(const char *val, const struct =

>> kernel_param *kp)
>> +{
>> +=A0=A0=A0 char error_val[] =3D "";
>> +=A0=A0=A0 int rc =3D -EINVAL;
>> +
>> +=A0=A0=A0 if (!capable(CAP_SYS_ADMIN))
>> +=A0=A0=A0=A0=A0=A0=A0 return -EPERM;
>> +
>> +=A0=A0=A0 if (ne_check_enclaves_created()) {
>> +=A0=A0=A0=A0=A0=A0=A0 pr_err("%s: The CPU pool is used by enclave(s)\n"=
, =

>> ne_misc_dev.name);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return -EPERM;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 ne_teardown_cpu_pool();
>> +
>> +=A0=A0=A0 rc =3D ne_setup_cpu_pool(val);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 pr_err("%s: Error in setup CPU pool [rc=3D%d]\n", =

>> ne_misc_dev.name, rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 param_set_copystring(error_val, kp);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return rc;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 return param_set_copystring(val, kp);
>> +}
>> +
>> +/**
>> + * ne_get_cpu_from_cpu_pool() - Get a CPU from the NE CPU pool, =

>> either from the
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 remaining sibling(s) of=
 a CPU core or the first
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sibling of a new CPU co=
re.
>> + * @ne_enclave :=A0=A0=A0 Private data associated with the current encl=
ave.
>> + *
>> + * Context: Process context. This function is called with the =

>> ne_enclave mutex held.
>> + * Return:
>> + * * vCPU id.
>> + * * 0, if no CPU available in the pool.
>> + */
>> +static unsigned int ne_get_cpu_from_cpu_pool(struct ne_enclave =

>> *ne_enclave)
>> +{
>> +=A0=A0=A0 int core_id =3D -1;
>> +=A0=A0=A0 unsigned int cpu =3D 0;
>> +=A0=A0=A0 unsigned int i =3D 0;
>> +=A0=A0=A0 unsigned int vcpu_id =3D 0;
>> +
>> +=A0=A0=A0 /* There are CPU siblings available to choose from. */
>> +=A0=A0=A0 for (i =3D 0; i < ne_enclave->avail_cpu_cores_size; i++)
>> +=A0=A0=A0=A0=A0=A0=A0 for_each_cpu(cpu, ne_enclave->avail_cpu_cores[i])
>
> This is really hard to read. I think what you want to say here is =

> something along these lines:
>
> /*
> =A0* If previously allocated a thread of a core to this enclave, we first
> =A0* return its sibling(s) for new allocations, so that we can donate a
> =A0* full core.
> =A0*/
> for (i =3D 0; i < ne_enclave->nr_parent_cores; i++) {
> =A0=A0=A0 for_each_cpu(cpu, ne->enclave->parent_cores[i].reserved_sibling=
s) {
> =A0=A0=A0=A0=A0=A0=A0 if (!ne_cpu_donated(cpu)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 [...]
> =A0=A0=A0=A0=A0=A0=A0 }
> =A0=A0=A0 }
> }
>
> Similarly for other places in this file where you do cpu mask logic. =

> It always needs to be very obvious what the respective mask is for, =

> because you have ~3 semantically different ones.

That's true, the motivation for all this logic is to split the NE CPU =

pool in threads / siblings per core and give to an enclave either the =

first sibling of a core or the remaining ones, till full core(s) is =

(are) given.

I'll update the naming, codebase logic and comments to make it more =

clear, this deserves it, indeed.

Thanks,
Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

