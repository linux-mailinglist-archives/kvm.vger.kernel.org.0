Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250CE1C56D9
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 15:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgEEN3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 09:29:41 -0400
Received: from foss.arm.com ([217.140.110.172]:39892 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728934AbgEEN3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 09:29:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DD6530E;
        Tue,  5 May 2020 06:29:39 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14D073F68F;
        Tue,  5 May 2020 06:29:37 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 27/32] pci: Implement callbacks for toggling
 BAR emulation
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com,
        Alexandru Elisei <alexandru.elisei@gmail.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-28-alexandru.elisei@arm.com>
 <a04a7489-6660-aa7b-5391-2e49e6cabe0f@arm.com>
 <8e6b0d53-67c9-5341-0d88-a56e0d5bf759@arm.com>
 <49bb250c-2e50-f4da-d7a3-9d377cab180c@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <75dd7d3c-5ced-dc41-c4b1-ae1f72fe4096@arm.com>
Date:   Tue, 5 May 2020 14:30:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <49bb250c-2e50-f4da-d7a3-9d377cab180c@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/3/20 8:08 PM, André Przywara wrote:
> On 03/04/2020 19:14, Alexandru Elisei wrote:
>> Hi,
>>
>> On 4/3/20 12:57 PM, André Przywara wrote:
>>>> +	}
>>>> +
>>>> +	assert(has_bar_regions);
>>> Is assert() here really a good idea? I see that it makes sense for our
>>> emulated devices, but is that a valid check for VFIO?
>>> From briefly looking I can't find a requirement for having at least one
>>> valid BAR in general, and even if - I think we should rather return an
>>> error than aborting the guest here - or ignore it altogether.
>> The assert here is to discover coding errors with devices, not with the PCI
>> emulation. Calling pci__register_bar_regions and providing callbacks for when BAR
>> access is toggled, but *without* any valid BARs looks like a coding error in the
>> device emulation code to me.
> As I said, I totally see the point for our emulated devices, but it
> looks like we use this code also for VFIO? Where we are not in control
> of what the device exposes.
>
>> As for VFIO, I'm struggling to find a valid reason for someone to build a device
>> that uses PCI, but doesn't have any BARs. Isn't that the entire point of PCI? I'm
>> perfectly happy to remove the assert if you can provide an rationale for building
>> such a device.
> IIRC you have an AMD box, check the "Northbridge" PCI device there,
> devices 0:18.x. They provide chipset registers via (extended) config
> space only, they don't have any valid BARs. Also I found some SMBus
> device without BARs.
> Not the most prominent use case (especially for pass through), but
> apparently valid.
> I think the rationale for using this was to use a well established,
> supported and discoverable interface.

I see you point. I'll remove the assert.

>
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  int pci__init(struct kvm *kvm)
>>>>  {
>>>>  	int r;
>>>> diff --git a/vfio/pci.c b/vfio/pci.c
>>>> index 8b2a0c8dbac3..18e22a8c5320 100644
>>>> --- a/vfio/pci.c
>>>> +++ b/vfio/pci.c
>>>> @@ -8,6 +8,8 @@
>>>>  #include <sys/resource.h>
>>>>  #include <sys/time.h>
>>>>  
>>>> +#include <assert.h>
>>>> +
>>>>  /* Wrapper around UAPI vfio_irq_set */
>>>>  union vfio_irq_eventfd {
>>>>  	struct vfio_irq_set	irq;
>>>> @@ -446,6 +448,81 @@ out_unlock:
>>>>  	mutex_unlock(&pdev->msi.mutex);
>>>>  }
>>>>  
>>>> +static int vfio_pci_bar_activate(struct kvm *kvm,
>>>> +				 struct pci_device_header *pci_hdr,
>>>> +				 int bar_num, void *data)
>>>> +{
>>>> +	struct vfio_device *vdev = data;
>>>> +	struct vfio_pci_device *pdev = &vdev->pci;
>>>> +	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
>>>> +	struct vfio_pci_msix_table *table = &pdev->msix_table;
>>>> +	struct vfio_region *region;
>>>> +	bool has_msix;
>>>> +	int ret;
>>>> +
>>>> +	assert((u32)bar_num < vdev->info.num_regions);
>>>> +
>>>> +	region = &vdev->regions[bar_num];
>>>> +	has_msix = pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX;
>>>> +
>>>> +	if (has_msix && (u32)bar_num == table->bar) {
>>>> +		ret = kvm__register_mmio(kvm, table->guest_phys_addr,
>>>> +					 table->size, false,
>>>> +					 vfio_pci_msix_table_access, pdev);
>>>> +		if (ret < 0 || table->bar != pba->bar)
>>> I think this second expression deserves some comment.
>>> If I understand correctly, this would register the PBA trap handler
>>> separetely below if both the MSIX table and the PBA share a BAR?
>> The MSIX table and the PBA structure can share the same BAR for the base address
>> (that's why the MSIX capability has an offset field for both of them), but we
>> register different regions for mmio emulation because we don't want to have a
>> generic handler and always check if the mmio access was to the MSIX table of the
>> PBA structure. I can add a comment stating that, sure.
> Yes, thanks for the explanation!
>
>>>> +			goto out;
>>> Is there any particular reason you are using goto here? I find it more
>>> confusing if the "out:" label has just a return statement, without any
>>> cleanup or lock dropping. Just a "return ret;" here would be much
>>> cleaner I think. Same for other occassions in this function and
>>> elsewhere in this patch.
>>>
>>> Or do you plan on adding some code here later? I don't see it in this
>>> series though.
>> The reason I'm doing this is because I prefer one exit point from the function,
>> instead of return statements at arbitrary points in the function body. As a point
>> of reference, the pattern is recommended in the MISRA C standard for safety, in
>> section 17.4 "No more than one return statement", and is also used in the Linux
>> kernel. I think it comes down to personal preference, so unless Will of Julien
>> have a strong preference against it, I would rather keep it.
> Fair enough, your decision. Just to point out that I can't find this
> practice in the kernel, also:
>
> Documentation/process/coding-style.rst, section "7) Centralized exiting
> of functions":
> "The goto statement comes in handy when a function exits from multiple
> locations and some common work such as cleanup has to be done.  If there
> is no cleanup needed then just return directly."
>
>
> Thanks!
> Andre.
>
>>>> +	}
>>>> +
>>>> +	if (has_msix && (u32)bar_num == pba->bar) {
>>>> +		ret = kvm__register_mmio(kvm, pba->guest_phys_addr,
>>>> +					 pba->size, false,
>>>> +					 vfio_pci_msix_pba_access, pdev);
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	ret = vfio_map_region(kvm, vdev, region);
>>>> +out:
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int vfio_pci_bar_deactivate(struct kvm *kvm,
>>>> +				   struct pci_device_header *pci_hdr,
>>>> +				   int bar_num, void *data)
>>>> +{
>>>> +	struct vfio_device *vdev = data;
>>>> +	struct vfio_pci_device *pdev = &vdev->pci;
>>>> +	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
>>>> +	struct vfio_pci_msix_table *table = &pdev->msix_table;
>>>> +	struct vfio_region *region;
>>>> +	bool has_msix, success;
>>>> +	int ret;
>>>> +
>>>> +	assert((u32)bar_num < vdev->info.num_regions);
>>>> +
>>>> +	region = &vdev->regions[bar_num];
>>>> +	has_msix = pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX;
>>>> +
>>>> +	if (has_msix && (u32)bar_num == table->bar) {
>>>> +		success = kvm__deregister_mmio(kvm, table->guest_phys_addr);
>>>> +		/* kvm__deregister_mmio fails when the region is not found. */
>>>> +		ret = (success ? 0 : -ENOENT);
>>>> +		if (ret < 0 || table->bar!= pba->bar)
>>>> +			goto out;
>>>> +	}
>>>> +
>>>> +	if (has_msix && (u32)bar_num == pba->bar) {
>>>> +		success = kvm__deregister_mmio(kvm, pba->guest_phys_addr);
>>>> +		ret = (success ? 0 : -ENOENT);
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	vfio_unmap_region(kvm, region);
>>>> +	ret = 0;
>>>> +
>>>> +out:
>>>> +	return ret;
>>>> +}
>>>> +
>>>>  static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr,
>>>>  			      u8 offset, void *data, int sz)
>>>>  {
>>>> @@ -805,12 +882,6 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
>>>>  		ret = -ENOMEM;
>>>>  		goto out_free;
>>>>  	}
>>>> -	pba->guest_phys_addr = table->guest_phys_addr + table->size;
>>>> -
>>>> -	ret = kvm__register_mmio(kvm, table->guest_phys_addr, table->size,
>>>> -				 false, vfio_pci_msix_table_access, pdev);
>>>> -	if (ret < 0)
>>>> -		goto out_free;
>>>>  
>>>>  	/*
>>>>  	 * We could map the physical PBA directly into the guest, but it's
>>>> @@ -820,10 +891,7 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
>>>>  	 * between MSI-X table and PBA. For the sake of isolation, create a
>>>>  	 * virtual PBA.
>>>>  	 */
>>>> -	ret = kvm__register_mmio(kvm, pba->guest_phys_addr, pba->size, false,
>>>> -				 vfio_pci_msix_pba_access, pdev);
>>>> -	if (ret < 0)
>>>> -		goto out_free;
>>>> +	pba->guest_phys_addr = table->guest_phys_addr + table->size;
>>>>  
>>>>  	pdev->msix.entries = entries;
>>>>  	pdev->msix.nr_entries = nr_entries;
>>>> @@ -894,11 +962,6 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
>>>>  		region->guest_phys_addr = pci_get_mmio_block(map_size);
>>>>  	}
>>>>  
>>>> -	/* Map the BARs into the guest or setup a trap region. */
>>>> -	ret = vfio_map_region(kvm, vdev, region);
>>>> -	if (ret)
>>>> -		return ret;
>>>> -
>>>>  	return 0;
>>>>  }
>>>>  
>>>> @@ -945,7 +1008,12 @@ static int vfio_pci_configure_dev_regions(struct kvm *kvm,
>>>>  	}
>>>>  
>>>>  	/* We've configured the BARs, fake up a Configuration Space */
>>>> -	return vfio_pci_fixup_cfg_space(vdev);
>>>> +	ret = vfio_pci_fixup_cfg_space(vdev);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	return pci__register_bar_regions(kvm, &pdev->hdr, vfio_pci_bar_activate,
>>>> +					 vfio_pci_bar_deactivate, vdev);
>>>>  }
>>>>  
>>>>  /*
>>>> diff --git a/virtio/pci.c b/virtio/pci.c
>>>> index d111dc499f5e..598da699c241 100644
>>>> --- a/virtio/pci.c
>>>> +++ b/virtio/pci.c
>>>> @@ -11,6 +11,7 @@
>>>>  #include <sys/ioctl.h>
>>>>  #include <linux/virtio_pci.h>
>>>>  #include <linux/byteorder.h>
>>>> +#include <assert.h>
>>>>  #include <string.h>
>>>>  
>>>>  static u16 virtio_pci__port_addr(struct virtio_pci *vpci)
>>>> @@ -462,6 +463,64 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
>>>>  		virtio_pci__data_out(vcpu, vdev, addr - mmio_addr, data, len);
>>>>  }
>>>>  
>>>> +static int virtio_pci__bar_activate(struct kvm *kvm,
>>>> +				    struct pci_device_header *pci_hdr,
>>>> +				    int bar_num, void *data)
>>>> +{
>>>> +	struct virtio_device *vdev = data;
>>>> +	u32 bar_addr, bar_size;
>>>> +	int r = -EINVAL;
>>>> +
>>>> +	assert(bar_num <= 2);
>>>> +
>>>> +	bar_addr = pci__bar_address(pci_hdr, bar_num);
>>>> +	bar_size = pci__bar_size(pci_hdr, bar_num);
>>>> +
>>>> +	switch (bar_num) {
>>>> +	case 0:
>>>> +		r = ioport__register(kvm, bar_addr, &virtio_pci__io_ops,
>>>> +				     bar_size, vdev);
>>>> +		if (r > 0)
>>>> +			r = 0;
>>>> +		break;
>>>> +	case 1:
>>>> +		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
>>>> +					virtio_pci__io_mmio_callback, vdev);
>>>> +		break;
>>>> +	case 2:
>>>> +		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
>>>> +					virtio_pci__msix_mmio_callback, vdev);
>>> I think adding a break; here looks nicer.
>> Sure, it will make the function look more consistent.
>>
>> Thanks,
>> Alex
>>> Cheers,
>>> Andre
>>>
>>>
>>>> +	}
>>>> +
>>>> +	return r;
>>>> +}
>>>> +
>>>> +static int virtio_pci__bar_deactivate(struct kvm *kvm,
>>>> +				      struct pci_device_header *pci_hdr,
>>>> +				      int bar_num, void *data)
>>>> +{
>>>> +	u32 bar_addr;
>>>> +	bool success;
>>>> +	int r = -EINVAL;
>>>> +
>>>> +	assert(bar_num <= 2);
>>>> +
>>>> +	bar_addr = pci__bar_address(pci_hdr, bar_num);
>>>> +
>>>> +	switch (bar_num) {
>>>> +	case 0:
>>>> +		r = ioport__unregister(kvm, bar_addr);
>>>> +		break;
>>>> +	case 1:
>>>> +	case 2:
>>>> +		success = kvm__deregister_mmio(kvm, bar_addr);
>>>> +		/* kvm__deregister_mmio fails when the region is not found. */
>>>> +		r = (success ? 0 : -ENOENT);
>>>> +	}
>>>> +
>>>> +	return r;
>>>> +}
>>>> +
>>>>  int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>>>  		     int device_id, int subsys_id, int class)
>>>>  {
>>>> @@ -476,23 +535,8 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>>>  	BUILD_BUG_ON(!is_power_of_two(PCI_IO_SIZE));
>>>>  
>>>>  	port_addr = pci_get_io_port_block(PCI_IO_SIZE);
>>>> -	r = ioport__register(kvm, port_addr, &virtio_pci__io_ops, PCI_IO_SIZE,
>>>> -			     vdev);
>>>> -	if (r < 0)
>>>> -		return r;
>>>> -	port_addr = (u16)r;
>>>> -
>>>>  	mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
>>>> -	r = kvm__register_mmio(kvm, mmio_addr, PCI_IO_SIZE, false,
>>>> -			       virtio_pci__io_mmio_callback, vdev);
>>>> -	if (r < 0)
>>>> -		goto free_ioport;
>>>> -
>>>>  	msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
>>>> -	r = kvm__register_mmio(kvm, msix_io_block, PCI_IO_SIZE * 2, false,
>>>> -			       virtio_pci__msix_mmio_callback, vdev);
>>>> -	if (r < 0)
>>>> -		goto free_mmio;
>>>>  
>>>>  	vpci->pci_hdr = (struct pci_device_header) {
>>>>  		.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
>>>> @@ -518,6 +562,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>>>  		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
>>>>  	};
>>>>  
>>>> +	r = pci__register_bar_regions(kvm, &vpci->pci_hdr,
>>>> +				      virtio_pci__bar_activate,
>>>> +				      virtio_pci__bar_deactivate, vdev);
>>>> +	if (r < 0)
>>>> +		return r;
>>>> +
>>>>  	vpci->dev_hdr = (struct device_header) {
>>>>  		.bus_type		= DEVICE_BUS_PCI,
>>>>  		.data			= &vpci->pci_hdr,
>>>> @@ -548,20 +598,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>>>  
>>>>  	r = device__register(&vpci->dev_hdr);
>>>>  	if (r < 0)
>>>> -		goto free_msix_mmio;
>>>> +		return r;
>>>>  
>>>>  	/* save the IRQ that device__register() has allocated */
>>>>  	vpci->legacy_irq_line = vpci->pci_hdr.irq_line;
>>>>  
>>>>  	return 0;
>>>> -
>>>> -free_msix_mmio:
>>>> -	kvm__deregister_mmio(kvm, msix_io_block);
>>>> -free_mmio:
>>>> -	kvm__deregister_mmio(kvm, mmio_addr);
>>>> -free_ioport:
>>>> -	ioport__unregister(kvm, port_addr);
>>>> -	return r;
>>>>  }
>>>>  
>>>>  int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
>>>>
