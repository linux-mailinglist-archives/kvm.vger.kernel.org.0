Return-Path: <kvm+bounces-61173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC8AC0E762
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 15:38:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5067019A5B14
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 14:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4799430E83C;
	Mon, 27 Oct 2025 14:33:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D305309EF8;
	Mon, 27 Oct 2025 14:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761575618; cv=none; b=d/6o567i72npiEzfB0hMZr5OS9Ll6Ctln7bobQ0dkcfPen18SnkX18t0QiJvuTxErE5HWNSRDUHuc5AIpqz7tVPNZx1a/4+2BAD3z6xwvDHRn8rXDLMUP190sDMMrUgehPJkwrLhGNwVHS2Ay68gDgQjwqfmaEiw0n3WKTStufc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761575618; c=relaxed/simple;
	bh=9W5s1Vb2PWXHQOEjCdLaw3nwTnmmwvf+0lsBPwGGKbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RliKVMXsy+4cN+/ZbTyxpPzs4M01sWKhlovzZEbFBGHXkbrMg/D/JfvCu3TXfewa6V1eO4YxJol3hLogv4YyX5FQqlqsviWnGirz3QTrVUdM7uhhA74sWkHCb/gmSy1j/Illx5ZzELRAzWCSes4fFGxsPRYadSO+sCs8bQdt4qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1947169E;
	Mon, 27 Oct 2025 07:33:26 -0700 (PDT)
Received: from [10.122.34.124] (unknown [10.122.34.124])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4915D3F63F;
	Mon, 27 Oct 2025 07:33:34 -0700 (PDT)
Message-ID: <4bf8ba8f-57c3-4af2-9f2a-f4313121be87@arm.com>
Date: Mon, 27 Oct 2025 09:33:33 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] vfio/pci: add PCIe TPH device ioctl
To: Jeremy Linton <jeremy.linton@arm.com>, alex.williamson@redhat.com,
 jgg@ziepe.ca, pstanner@redhat.com
Cc: kvm@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20251013163515.16565-1-wathsala.vithanage@arm.com>
 <9df72789-ab35-46a0-86cf-7b1eb3339ac7@arm.com>
Content-Language: en-US
From: Wathsala Vithanage <wathsala.vithanage@arm.com>
In-Reply-To: <9df72789-ab35-46a0-86cf-7b1eb3339ac7@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 10/16/25 16:41, Jeremy Linton wrote:
> Hi,
>
> On 10/13/25 11:35 AM, Wathsala Vithanage wrote:
>> TLP Processing Hints (TPH) let a requester provide steering hints that
>> can enable direct cache injection on supported platforms and PCIe
>> devices. The PCIe core already exposes TPH handling to kernel drivers.
>>
>> This change adds the VFIO_DEVICE_PCI_TPH ioctl and exposes TPH control
>> to user space to reduce memory latency and improve throughput for
>> polling drivers (e.g., DPDK poll-mode drivers). Through this interface,
>> user-space drivers can:
>>    - enable or disable TPH for the device function
>>    - program steering tags in device-specific mode
>>
>> The ioctl is available only when the device advertises the TPH
>> Capability. Invalid modes or tags are rejected. No functional change
>> occurs unless the ioctl is used.
>>
>> Signed-off-by: Wathsala Vithanage <wathsala.vithanage@arm.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_core.c | 74 ++++++++++++++++++++++++++++++++
>>   include/uapi/linux/vfio.h        | 36 ++++++++++++++++
>>   2 files changed, 110 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c 
>> b/drivers/vfio/pci/vfio_pci_core.c
>> index 7dcf5439dedc..0646d9a483fb 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -28,6 +28,7 @@
>>   #include <linux/nospec.h>
>>   #include <linux/sched/mm.h>
>>   #include <linux/iommufd.h>
>> +#include <linux/pci-tph.h>
>>   #if IS_ENABLED(CONFIG_EEH)
>>   #include <asm/eeh.h>
>>   #endif
>> @@ -1443,6 +1444,77 @@ static int vfio_pci_ioctl_ioeventfd(struct 
>> vfio_pci_core_device *vdev,
>>                     ioeventfd.fd);
>>   }
>>   +static int vfio_pci_tph_set_st(struct vfio_pci_core_device *vdev,
>> +                   const struct vfio_pci_tph_entry *ent)
>> +{
>> +    int ret, mem_type;
>> +    u16 st;
>> +    u32 cpu_id = ent->cpu_id;
>> +
>> +    if (cpu_id >= nr_cpu_ids || !cpu_present(cpu_id))
>> +        return -EINVAL;
>> +
>> +    if (!cpumask_test_cpu(cpu_id, current->cpus_ptr))
>> +        return -EINVAL;
>> +
>> +    switch (ent->mem_type) {
>> +    case VFIO_TPH_MEM_TYPE_VMEM:
>> +        mem_type = TPH_MEM_TYPE_VM;
>> +        break;
>> +    case VFIO_TPH_MEM_TYPE_PMEM:
>> +        mem_type = TPH_MEM_TYPE_PM;
>> +        break;
>> +    default:
>> +        return -EINVAL;
>> +    }
>> +    ret = pcie_tph_get_cpu_st(vdev->pdev, mem_type, 
>> topology_core_id(cpu_id),
>> +                  &st);
>> +    if (ret)
>> +        return ret;
>> +    /*
>> +     * PCI core enforces table bounds and disables TPH on error.
>> +     */
>> +    return pcie_tph_set_st_entry(vdev->pdev, ent->index, st);
>> +}
>> +
>> +static int vfio_pci_tph_enable(struct vfio_pci_core_device *vdev, 
>> int mode)
>> +{
>> +    /* IV mode is not supported. */
>> +    if (mode == PCI_TPH_ST_IV_MODE)
>> +        return -EINVAL;
>> +    /* PCI core validates 'mode' and returns -EINVAL on bad values. */
>> +    return pcie_enable_tph(vdev->pdev, mode);
>> +}
>> +
>> +static int vfio_pci_tph_disable(struct vfio_pci_core_device *vdev)
>> +{
>> +    pcie_disable_tph(vdev->pdev);
>> +    return 0;
>> +}
>> +
>> +static int vfio_pci_ioctl_tph(struct vfio_pci_core_device *vdev,
>> +                  void __user *uarg)
>> +{
>> +    struct vfio_pci_tph tph;
>> +
>> +    if (copy_from_user(&tph, uarg, sizeof(struct vfio_pci_tph)))
>> +        return -EFAULT;
>> +
>> +    if (tph.argsz != sizeof(struct vfio_pci_tph))
>> +        return -EINVAL;
>> +
>> +    switch (tph.op) {
>> +    case VFIO_DEVICE_TPH_ENABLE:
>> +        return vfio_pci_tph_enable(vdev, tph.mode);
>> +    case VFIO_DEVICE_TPH_DISABLE:
>> +        return vfio_pci_tph_disable(vdev);
>> +    case VFIO_DEVICE_TPH_SET_ST:
>> +        return vfio_pci_tph_set_st(vdev, &tph.ent);
>> +    default:
>> +        return -EINVAL;
>> +    }
>> +}
>> +
>>   long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned 
>> int cmd,
>>                unsigned long arg)
>>   {
>> @@ -1467,6 +1539,8 @@ long vfio_pci_core_ioctl(struct vfio_device 
>> *core_vdev, unsigned int cmd,
>>           return vfio_pci_ioctl_reset(vdev, uarg);
>>       case VFIO_DEVICE_SET_IRQS:
>>           return vfio_pci_ioctl_set_irqs(vdev, uarg);
>> +    case VFIO_DEVICE_PCI_TPH:
>> +        return vfio_pci_ioctl_tph(vdev, uarg);
>>       default:
>>           return -ENOTTY;
>>       }
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 75100bf009ba..cfdee851031e 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -873,6 +873,42 @@ struct vfio_device_ioeventfd {
>>     #define VFIO_DEVICE_IOEVENTFD        _IO(VFIO_TYPE, VFIO_BASE + 16)
>>   +/**
>> + * VFIO_DEVICE_PCI_TPH - _IO(VFIO_TYPE, VFIO_BASE + 22)
>> + *
>> + * Control PCIe TLP Processing Hints (TPH) on a PCIe device.
>> + *
>> + * Supported operations:
>> + * - VFIO_DEVICE_TPH_ENABLE: enable TPH in no-steering-tag (NS) or
>> + *   device-specific (DS) mode. IV mode is not supported via this ioctl
>> + *   and returns -EINVAL.
>> + * - VFIO_DEVICE_TPH_DISABLE: disable TPH on the device.
>> + * - VFIO_DEVICE_TPH_SET_ST: program an entry in the device TPH 
>> Steering-Tag
>> + *   (ST) table. The kernel derives the ST from cpu_id and mem_type; 
>> the
>> + *   value is not returned to userspace.
>> + */
>> +struct vfio_pci_tph_entry {
>> +    __u32 cpu_id;            /* CPU logical ID */
>> +    __u8  mem_type;
>> +#define VFIO_TPH_MEM_TYPE_VMEM        0   /* Request volatile memory 
>> ST */
>> +#define VFIO_TPH_MEM_TYPE_PMEM        1   /* Request persistent 
>> memory ST */
>> +    __u8  rsvd[1];
>> +    __u16 index;            /* ST-table index */
>> +};
>> +
>> +struct vfio_pci_tph {
>> +    __u32 argsz;            /* Size of vfio_pci_tph */
>> +    __u32 mode;            /* NS and DS modes; IV not supported */
>> +    __u32 op;
>> +#define VFIO_DEVICE_TPH_ENABLE        0
>> +#define VFIO_DEVICE_TPH_DISABLE        1
>> +#define VFIO_DEVICE_TPH_SET_ST        2
>> +    struct vfio_pci_tph_entry ent;
>> +};
>> +
>> +#define VFIO_DEVICE_PCI_TPH    _IO(VFIO_TYPE, VFIO_BASE + 22)
>
> A quick look at this, it seems its following the way the existing vfio 
> IOCTls are defined, yet two of them (ENABLE and DISABLE) won't likely 
> really change their structure, or don't need a structure in the case 
> of disable. Why not use IOW() and let the kernel error handling deal 
> with those two as independent ioctls?
>
>
> Thanks,


It will require two IOCTLs. I’m ok with having two IOCTLs for this 
feature if the maintainers are fine with it.

Thanks,

>
>> +
>> +
>>   /**
>>    * VFIO_DEVICE_FEATURE - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
>>    *                   struct vfio_device_feature)
>

