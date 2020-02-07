Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2672315555E
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 11:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgBGKMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 05:12:40 -0500
Received: from foss.arm.com ([217.140.110.172]:38448 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgBGKMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 05:12:40 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11DD830E;
        Fri,  7 Feb 2020 02:12:39 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05F263F52E;
        Fri,  7 Feb 2020 02:12:37 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 25/30] pci: Implement callbacks for toggling
 BAR emulation
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-26-alexandru.elisei@arm.com>
 <20200206182128.536565a6@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <47624fb3-dbab-734a-0126-caa30e9f7ab0@arm.com>
Date:   Fri, 7 Feb 2020 10:12:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200206182128.536565a6@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/6/20 6:21 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:48:00 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> Implement callbacks for activating and deactivating emulation for a BAR
>> region. This is in preparation for allowing a guest operating system to
>> enable and disable access to I/O or memory space, or to reassign the
>> BARs.
>>
>> The emulated vesa device has been refactored in the process and the static
>> variables were removed in order to make using the callbacks less painful.
>> The framebuffer isn't designed to allow stopping and restarting at
>> arbitrary points in the guest execution. Furthermore, on x86, the kernel
>> will not change the BAR addresses, which on bare metal are programmed by
>> the firmware, so take the easy way out and refuse to deactivate emulation
>> for the BAR regions.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  hw/vesa.c         | 120 ++++++++++++++++++++++++++++++++--------------
>>  include/kvm/pci.h |  19 +++++++-
>>  pci.c             |  44 +++++++++++++++++
>>  vfio/pci.c        | 100 +++++++++++++++++++++++++++++++-------
>>  virtio/pci.c      |  90 ++++++++++++++++++++++++----------
>>  5 files changed, 294 insertions(+), 79 deletions(-)
>>
>> diff --git a/hw/vesa.c b/hw/vesa.c
>> index e988c0425946..74ebebbefa6b 100644
>> --- a/hw/vesa.c
>> +++ b/hw/vesa.c
>> @@ -18,6 +18,12 @@
>>  #include <inttypes.h>
>>  #include <unistd.h>
>>  
>> +struct vesa_dev {
>> +	struct pci_device_header	pci_hdr;
>> +	struct device_header		dev_hdr;
>> +	struct framebuffer		fb;
>> +};
>> +
>>  static bool vesa_pci_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>>  {
>>  	return true;
>> @@ -33,29 +39,52 @@ static struct ioport_operations vesa_io_ops = {
>>  	.io_out			= vesa_pci_io_out,
>>  };
>>  
>> -static struct pci_device_header vesa_pci_device = {
>> -	.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
>> -	.device_id		= cpu_to_le16(PCI_DEVICE_ID_VESA),
>> -	.header_type		= PCI_HEADER_TYPE_NORMAL,
>> -	.revision_id		= 0,
>> -	.class[2]		= 0x03,
>> -	.subsys_vendor_id	= cpu_to_le16(PCI_SUBSYSTEM_VENDOR_ID_REDHAT_QUMRANET),
>> -	.subsys_id		= cpu_to_le16(PCI_SUBSYSTEM_ID_VESA),
>> -	.bar[1]			= cpu_to_le32(VESA_MEM_ADDR | PCI_BASE_ADDRESS_SPACE_MEMORY),
>> -	.bar_size[1]		= VESA_MEM_SIZE,
>> -};
>> +static int vesa__bar_activate(struct kvm *kvm,
>> +			      struct pci_device_header *pci_hdr,
>> +			      int bar_num, void *data)
>> +{
>> +	struct vesa_dev *vdev = data;
>> +	u32 bar_addr, bar_size;
>> +	char *mem;
>> +	int r;
>>  
>> -static struct device_header vesa_device = {
>> -	.bus_type	= DEVICE_BUS_PCI,
>> -	.data		= &vesa_pci_device,
>> -};
>> +	bar_addr = pci__bar_address(pci_hdr, bar_num);
>> +	bar_size = pci_hdr->bar_size[bar_num];
>>  
>> -static struct framebuffer vesafb;
>> +	switch (bar_num) {
>> +	case 0:
>> +		r = ioport__register(kvm, bar_addr, &vesa_io_ops, bar_size,
>> +				     NULL);
>> +		break;
>> +	case 1:
>> +		mem = mmap(NULL, bar_size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
>> +		if (mem == MAP_FAILED) {
>> +			r = -errno;
>> +			break;
>> +		}
>> +		r = kvm__register_dev_mem(kvm, bar_addr, bar_size, mem);
>> +		if (r < 0)
>> +			break;
>> +		vdev->fb.mem = mem;
>> +		break;
>> +	default:
>> +		r = -EINVAL;
>> +	}
>> +
>> +	return r;
>> +}
>> +
>> +static int vesa__bar_deactivate(struct kvm *kvm,
>> +				struct pci_device_header *pci_hdr,
>> +				int bar_num, void *data)
>> +{
>> +	return -EINVAL;
>> +}
>>  
>>  struct framebuffer *vesa__init(struct kvm *kvm)
>>  {
>> -	u16 vesa_base_addr;
>> -	char *mem;
>> +	struct vesa_dev *vdev;
>> +	u16 port_addr;
>>  	int r;
>>  
>>  	BUILD_BUG_ON(!is_power_of_two(VESA_MEM_SIZE));
>> @@ -63,34 +92,51 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>>  
>>  	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
>>  		return NULL;
>> -	r = pci_get_io_port_block(PCI_IO_SIZE);
>> -	r = ioport__register(kvm, r, &vesa_io_ops, PCI_IO_SIZE, NULL);
>> -	if (r < 0)
>> -		return ERR_PTR(r);
>>  
>> -	vesa_base_addr			= (u16)r;
>> -	vesa_pci_device.bar[0]		= cpu_to_le32(vesa_base_addr | PCI_BASE_ADDRESS_SPACE_IO);
>> -	vesa_pci_device.bar_size[0]	= PCI_IO_SIZE;
>> -	r = device__register(&vesa_device);
>> -	if (r < 0)
>> -		return ERR_PTR(r);
>> +	vdev = calloc(1, sizeof(*vdev));
>> +	if (vdev == NULL)
>> +		return ERR_PTR(-ENOMEM);
> Is it really necessary to allocate this here? You never free this, and I don't see how you could actually do this. AFAICS conceptually there can be only one VESA device? So maybe have a static variable above and use that instead of passing the pointer around? Or use &vdev if you need a pointer argument for the callbacks.

As far as I can tell, there can be only one VESA device, yes. I was following the
same pattern from virtio/{net,blk,rng,scsi,9p}.c, which I prefer because it's
explicit what function can access the device. What's wrong with passing the
pointer around? The entire PCI emulation code works like that.

>
>>  
>> -	mem = mmap(NULL, VESA_MEM_SIZE, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
>> -	if (mem == MAP_FAILED)
>> -		return ERR_PTR(-errno);
>> +	port_addr = pci_get_io_port_block(PCI_IO_SIZE);
>>  
>> -	r = kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
>> -	if (r < 0)
>> -		return ERR_PTR(r);
>> +	vdev->pci_hdr = (struct pci_device_header) {
>> +		.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
>> +		.device_id		= cpu_to_le16(PCI_DEVICE_ID_VESA),
>> +		.command		= PCI_COMMAND_IO | PCI_COMMAND_MEMORY,
>> +		.header_type		= PCI_HEADER_TYPE_NORMAL,
>> +		.revision_id		= 0,
>> +		.class[2]		= 0x03,
>> +		.subsys_vendor_id	= cpu_to_le16(PCI_SUBSYSTEM_VENDOR_ID_REDHAT_QUMRANET),
>> +		.subsys_id		= cpu_to_le16(PCI_SUBSYSTEM_ID_VESA),
>> +		.bar[0]			= cpu_to_le32(port_addr | PCI_BASE_ADDRESS_SPACE_IO),
>> +		.bar_size[0]		= PCI_IO_SIZE,
>> +		.bar[1]			= cpu_to_le32(VESA_MEM_ADDR | PCI_BASE_ADDRESS_SPACE_MEMORY),
>> +		.bar_size[1]		= VESA_MEM_SIZE,
>> +	};
>>  
>> -	vesafb = (struct framebuffer) {
>> +	vdev->fb = (struct framebuffer) {
>>  		.width			= VESA_WIDTH,
>>  		.height			= VESA_HEIGHT,
>>  		.depth			= VESA_BPP,
>> -		.mem			= mem,
>> +		.mem			= NULL,
>>  		.mem_addr		= VESA_MEM_ADDR,
>>  		.mem_size		= VESA_MEM_SIZE,
>>  		.kvm			= kvm,
>>  	};
>> -	return fb__register(&vesafb);
>> +
>> +	r = pci__register_bar_regions(kvm, &vdev->pci_hdr, vesa__bar_activate,
>> +				      vesa__bar_deactivate, vdev);
>> +	if (r < 0)
>> +		return ERR_PTR(r);
>> +
>> +	vdev->dev_hdr = (struct device_header) {
>> +		.bus_type       = DEVICE_BUS_PCI,
>> +		.data           = &vdev->pci_hdr,
>> +	};
>> +
>> +	r = device__register(&vdev->dev_hdr);
>> +	if (r < 0)
>> +		return ERR_PTR(r);
>> +
>> +	return fb__register(&vdev->fb);
>>  }
>> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
>> index 235cd82fff3c..bf42f497168f 100644
>> --- a/include/kvm/pci.h
>> +++ b/include/kvm/pci.h
>> @@ -89,12 +89,19 @@ struct pci_cap_hdr {
>>  	u8	next;
>>  };
>>  
>> +struct pci_device_header;
>> +
>> +typedef int (*bar_activate_fn_t)(struct kvm *kvm,
>> +				 struct pci_device_header *pci_hdr,
>> +				 int bar_num, void *data);
>> +typedef int (*bar_deactivate_fn_t)(struct kvm *kvm,
>> +				   struct pci_device_header *pci_hdr,
>> +				   int bar_num, void *data);
>> +
>>  #define PCI_BAR_OFFSET(b)	(offsetof(struct pci_device_header, bar[b]))
>>  #define PCI_DEV_CFG_SIZE	256
>>  #define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
>>  
>> -struct pci_device_header;
>> -
>>  struct pci_config_operations {
>>  	void (*write)(struct kvm *kvm, struct pci_device_header *pci_hdr,
>>  		      u8 offset, void *data, int sz);
>> @@ -136,6 +143,9 @@ struct pci_device_header {
>>  
>>  	/* Private to lkvm */
>>  	u32		bar_size[6];
>> +	bar_activate_fn_t	bar_activate_fn;
>> +	bar_deactivate_fn_t	bar_deactivate_fn;
>> +	void *data;
>>  	struct pci_config_operations	cfg_ops;
>>  	/*
>>  	 * PCI INTx# are level-triggered, but virtual device often feature
>> @@ -160,8 +170,13 @@ void pci__assign_irq(struct device_header *dev_hdr);
>>  void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size);
>>  void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size);
>>  
>> +
> Stray empty line?

Indeed, will get rid of it.

Thanks,
Alex
>
> Cheers,
> Andre
>
>>  void *pci_find_cap(struct pci_device_header *hdr, u8 cap_type);
>>  
>> +int pci__register_bar_regions(struct kvm *kvm, struct pci_device_header *pci_hdr,
>> +			      bar_activate_fn_t bar_activate_fn,
>> +			      bar_deactivate_fn_t bar_deactivate_fn, void *data);
>> +
>>  static inline bool __pci__memory_space_enabled(u16 command)
>>  {
>>  	return command & PCI_COMMAND_MEMORY;
>> diff --git a/pci.c b/pci.c
>> index 4f7b863298f6..5412f2defa2e 100644
>> --- a/pci.c
>> +++ b/pci.c
>> @@ -66,6 +66,11 @@ void pci__assign_irq(struct device_header *dev_hdr)
>>  		pci_hdr->irq_type = IRQ_TYPE_EDGE_RISING;
>>  }
>>  
>> +static bool pci_bar_is_implemented(struct pci_device_header *pci_hdr, int bar_num)
>> +{
>> +	return  bar_num < 6 && pci_hdr->bar_size[bar_num];
>> +}
>> +
>>  static void *pci_config_address_ptr(u16 port)
>>  {
>>  	unsigned long offset;
>> @@ -264,6 +269,45 @@ struct pci_device_header *pci__find_dev(u8 dev_num)
>>  	return hdr->data;
>>  }
>>  
>> +int pci__register_bar_regions(struct kvm *kvm, struct pci_device_header *pci_hdr,
>> +			      bar_activate_fn_t bar_activate_fn,
>> +			      bar_deactivate_fn_t bar_deactivate_fn, void *data)
>> +{
>> +	int i, r;
>> +	bool has_bar_regions = false;
>> +
>> +	assert(bar_activate_fn && bar_deactivate_fn);
>> +
>> +	pci_hdr->bar_activate_fn = bar_activate_fn;
>> +	pci_hdr->bar_deactivate_fn = bar_deactivate_fn;
>> +	pci_hdr->data = data;
>> +
>> +	for (i = 0; i < 6; i++) {
>> +		if (!pci_bar_is_implemented(pci_hdr, i))
>> +			continue;
>> +
>> +		has_bar_regions = true;
>> +
>> +		if (pci__bar_is_io(pci_hdr, i) &&
>> +		    pci__io_space_enabled(pci_hdr)) {
>> +				r = bar_activate_fn(kvm, pci_hdr, i, data);
>> +				if (r < 0)
>> +					return r;
>> +			}
>> +
>> +		if (pci__bar_is_memory(pci_hdr, i) &&
>> +		    pci__memory_space_enabled(pci_hdr)) {
>> +				r = bar_activate_fn(kvm, pci_hdr, i, data);
>> +				if (r < 0)
>> +					return r;
>> +			}
>> +	}
>> +
>> +	assert(has_bar_regions);
>> +
>> +	return 0;
>> +}
>> +
>>  int pci__init(struct kvm *kvm)
>>  {
>>  	int r;
>> diff --git a/vfio/pci.c b/vfio/pci.c
>> index 8a775a4a4a54..9e595562180b 100644
>> --- a/vfio/pci.c
>> +++ b/vfio/pci.c
>> @@ -446,6 +446,83 @@ out_unlock:
>>  	mutex_unlock(&pdev->msi.mutex);
>>  }
>>  
>> +static int vfio_pci_bar_activate(struct kvm *kvm,
>> +				 struct pci_device_header *pci_hdr,
>> +				 int bar_num, void *data)
>> +{
>> +	struct vfio_device *vdev = data;
>> +	struct vfio_pci_device *pdev = &vdev->pci;
>> +	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
>> +	struct vfio_pci_msix_table *table = &pdev->msix_table;
>> +	struct vfio_region *region = &vdev->regions[bar_num];
>> +	int ret;
>> +
>> +	if (!region->info.size) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	if ((pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX) &&
>> +	    (u32)bar_num == table->bar) {
>> +		ret = kvm__register_mmio(kvm, table->guest_phys_addr,
>> +					 table->size, false,
>> +					 vfio_pci_msix_table_access, pdev);
>> +		if (ret < 0 || table->bar!= pba->bar)
>> +			goto out;
>> +	}
>> +
>> +	if ((pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX) &&
>> +	    (u32)bar_num == pba->bar) {
>> +		ret = kvm__register_mmio(kvm, pba->guest_phys_addr,
>> +					 pba->size, false,
>> +					 vfio_pci_msix_pba_access, pdev);
>> +		goto out;
>> +	}
>> +
>> +	ret = vfio_map_region(kvm, vdev, region);
>> +out:
>> +	return ret;
>> +}
>> +
>> +static int vfio_pci_bar_deactivate(struct kvm *kvm,
>> +				   struct pci_device_header *pci_hdr,
>> +				   int bar_num, void *data)
>> +{
>> +	struct vfio_device *vdev = data;
>> +	struct vfio_pci_device *pdev = &vdev->pci;
>> +	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
>> +	struct vfio_pci_msix_table *table = &pdev->msix_table;
>> +	struct vfio_region *region = &vdev->regions[bar_num];
>> +	int ret;
>> +	bool success;
>> +
>> +	if (!region->info.size) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	if ((pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX) &&
>> +	    (u32)bar_num == table->bar) {
>> +		success = kvm__deregister_mmio(kvm, table->guest_phys_addr);
>> +		ret = (success ? 0 : -EINVAL);
>> +		if (ret < 0 || table->bar!= pba->bar)
>> +			goto out;
>> +	}
>> +
>> +	if ((pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX) &&
>> +	    (u32)bar_num == pba->bar) {
>> +		success = kvm__deregister_mmio(kvm, pba->guest_phys_addr);
>> +		ret = (success ? 0 : -EINVAL);
>> +		goto out;
>> +	}
>> +
>> +	vfio_unmap_region(kvm, region);
>> +	ret = 0;
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>>  static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr,
>>  			      u8 offset, void *data, int sz)
>>  {
>> @@ -804,12 +881,6 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
>>  		ret = -ENOMEM;
>>  		goto out_free;
>>  	}
>> -	pba->guest_phys_addr = table->guest_phys_addr + table->size;
>> -
>> -	ret = kvm__register_mmio(kvm, table->guest_phys_addr, table->size,
>> -				 false, vfio_pci_msix_table_access, pdev);
>> -	if (ret < 0)
>> -		goto out_free;
>>  
>>  	/*
>>  	 * We could map the physical PBA directly into the guest, but it's
>> @@ -819,10 +890,7 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
>>  	 * between MSI-X table and PBA. For the sake of isolation, create a
>>  	 * virtual PBA.
>>  	 */
>> -	ret = kvm__register_mmio(kvm, pba->guest_phys_addr, pba->size, false,
>> -				 vfio_pci_msix_pba_access, pdev);
>> -	if (ret < 0)
>> -		goto out_free;
>> +	pba->guest_phys_addr = table->guest_phys_addr + table->size;
>>  
>>  	pdev->msix.entries = entries;
>>  	pdev->msix.nr_entries = nr_entries;
>> @@ -893,11 +961,6 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
>>  		region->guest_phys_addr = pci_get_mmio_block(map_size);
>>  	}
>>  
>> -	/* Map the BARs into the guest or setup a trap region. */
>> -	ret = vfio_map_region(kvm, vdev, region);
>> -	if (ret)
>> -		return ret;
>> -
>>  	return 0;
>>  }
>>  
>> @@ -944,7 +1007,12 @@ static int vfio_pci_configure_dev_regions(struct kvm *kvm,
>>  	}
>>  
>>  	/* We've configured the BARs, fake up a Configuration Space */
>> -	return vfio_pci_fixup_cfg_space(vdev);
>> +	ret = vfio_pci_fixup_cfg_space(vdev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return pci__register_bar_regions(kvm, &pdev->hdr, vfio_pci_bar_activate,
>> +					 vfio_pci_bar_deactivate, vdev);
>>  }
>>  
>>  /*
>> diff --git a/virtio/pci.c b/virtio/pci.c
>> index c4822514856c..5a3cc6f1e943 100644
>> --- a/virtio/pci.c
>> +++ b/virtio/pci.c
>> @@ -474,6 +474,65 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
>>  		virtio_pci__data_out(vcpu, vdev, addr - mmio_addr, data, len);
>>  }
>>  
>> +static int virtio_pci__bar_activate(struct kvm *kvm,
>> +				    struct pci_device_header *pci_hdr,
>> +				    int bar_num, void *data)
>> +{
>> +	struct virtio_device *vdev = data;
>> +	u32 bar_addr, bar_size;
>> +	int r;
>> +
>> +	bar_addr = pci__bar_address(pci_hdr, bar_num);
>> +	bar_size = pci_hdr->bar_size[bar_num];
>> +
>> +	switch (bar_num) {
>> +	case 0:
>> +		r = ioport__register(kvm, bar_addr, &virtio_pci__io_ops,
>> +				     bar_size, vdev);
>> +		if (r > 0)
>> +			r = 0;
>> +		break;
>> +	case 1:
>> +		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
>> +					virtio_pci__io_mmio_callback, vdev);
>> +		break;
>> +	case 2:
>> +		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
>> +					virtio_pci__msix_mmio_callback, vdev);
>> +		break;
>> +	default:
>> +		r = -EINVAL;
>> +	}
>> +
>> +	return r;
>> +}
>> +
>> +static int virtio_pci__bar_deactivate(struct kvm *kvm,
>> +				      struct pci_device_header *pci_hdr,
>> +				      int bar_num, void *data)
>> +{
>> +	u32 bar_addr;
>> +	bool success;
>> +	int r;
>> +
>> +	bar_addr = pci__bar_address(pci_hdr, bar_num);
>> +
>> +	switch (bar_num) {
>> +	case 0:
>> +		r = ioport__unregister(kvm, bar_addr);
>> +		break;
>> +	case 1:
>> +	case 2:
>> +		success = kvm__deregister_mmio(kvm, bar_addr);
>> +		r = (success ? 0 : -EINVAL);
>> +		break;
>> +	default:
>> +		r = -EINVAL;
>> +	}
>> +
>> +	return r;
>> +}
>> +
>>  int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>  		     int device_id, int subsys_id, int class)
>>  {
>> @@ -488,23 +547,8 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>  	BUILD_BUG_ON(!is_power_of_two(PCI_IO_SIZE));
>>  
>>  	port_addr = pci_get_io_port_block(PCI_IO_SIZE);
>> -	r = ioport__register(kvm, port_addr, &virtio_pci__io_ops, PCI_IO_SIZE,
>> -			     vdev);
>> -	if (r < 0)
>> -		return r;
>> -	port_addr = (u16)r;
>> -
>>  	mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
>> -	r = kvm__register_mmio(kvm, mmio_addr, PCI_IO_SIZE, false,
>> -			       virtio_pci__io_mmio_callback, vdev);
>> -	if (r < 0)
>> -		goto free_ioport;
>> -
>>  	msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
>> -	r = kvm__register_mmio(kvm, msix_io_block, PCI_IO_SIZE * 2, false,
>> -			       virtio_pci__msix_mmio_callback, vdev);
>> -	if (r < 0)
>> -		goto free_mmio;
>>  
>>  	vpci->pci_hdr = (struct pci_device_header) {
>>  		.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
>> @@ -530,6 +574,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>  		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
>>  	};
>>  
>> +	r = pci__register_bar_regions(kvm, &vpci->pci_hdr,
>> +				      virtio_pci__bar_activate,
>> +				      virtio_pci__bar_deactivate, vdev);
>> +	if (r < 0)
>> +		return r;
>> +
>>  	vpci->dev_hdr = (struct device_header) {
>>  		.bus_type		= DEVICE_BUS_PCI,
>>  		.data			= &vpci->pci_hdr,
>> @@ -560,20 +610,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>  
>>  	r = device__register(&vpci->dev_hdr);
>>  	if (r < 0)
>> -		goto free_msix_mmio;
>> +		return r;
>>  
>>  	/* save the IRQ that device__register() has allocated */
>>  	vpci->legacy_irq_line = vpci->pci_hdr.irq_line;
>>  
>>  	return 0;
>> -
>> -free_msix_mmio:
>> -	kvm__deregister_mmio(kvm, msix_io_block);
>> -free_mmio:
>> -	kvm__deregister_mmio(kvm, mmio_addr);
>> -free_ioport:
>> -	ioport__unregister(kvm, port_addr);
>> -	return r;
>>  }
>>  
>>  int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
