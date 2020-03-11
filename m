Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0395E181D8F
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 17:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbgCKQQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 12:16:20 -0400
Received: from foss.arm.com ([217.140.110.172]:51442 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730099AbgCKQQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 12:16:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BEA0F31B;
        Wed, 11 Mar 2020 09:16:19 -0700 (PDT)
Received: from [192.168.0.106] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D2EE23F6CF;
        Wed, 11 Mar 2020 09:16:18 -0700 (PDT)
Subject: Re: [PATCH v2 kvmtool 25/30] pci: Implement callbacks for toggling
 BAR emulation
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-26-alexandru.elisei@arm.com>
 <20200206182128.536565a6@donnerap.cambridge.arm.com>
 <47624fb3-dbab-734a-0126-caa30e9f7ab0@arm.com>
Message-ID: <07e65719-20ee-6f63-e0c2-f98d482b6355@arm.com>
Date:   Wed, 11 Mar 2020 16:16:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <47624fb3-dbab-734a-0126-caa30e9f7ab0@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/7/20 10:12 AM, Alexandru Elisei wrote:
> Hi,
>
> On 2/6/20 6:21 PM, Andre Przywara wrote:
>> On Thu, 23 Jan 2020 13:48:00 +0000
>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>
>> Hi,
>>
>>> Implement callbacks for activating and deactivating emulation for a BAR
>>> region. This is in preparation for allowing a guest operating system to
>>> enable and disable access to I/O or memory space, or to reassign the
>>> BARs.
>>>
>>> The emulated vesa device has been refactored in the process and the static
>>> variables were removed in order to make using the callbacks less painful.
>>> The framebuffer isn't designed to allow stopping and restarting at
>>> arbitrary points in the guest execution. Furthermore, on x86, the kernel
>>> will not change the BAR addresses, which on bare metal are programmed by
>>> the firmware, so take the easy way out and refuse to deactivate emulation
>>> for the BAR regions.
>>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>  hw/vesa.c         | 120 ++++++++++++++++++++++++++++++++--------------
>>>  include/kvm/pci.h |  19 +++++++-
>>>  pci.c             |  44 +++++++++++++++++
>>>  vfio/pci.c        | 100 +++++++++++++++++++++++++++++++-------
>>>  virtio/pci.c      |  90 ++++++++++++++++++++++++----------
>>>  5 files changed, 294 insertions(+), 79 deletions(-)
>>>
>>> diff --git a/hw/vesa.c b/hw/vesa.c
>>> index e988c0425946..74ebebbefa6b 100644
>>> --- a/hw/vesa.c
>>> +++ b/hw/vesa.c
>>> @@ -18,6 +18,12 @@
>>>  #include <inttypes.h>
>>>  #include <unistd.h>
>>>  
>>> +struct vesa_dev {
>>> +	struct pci_device_header	pci_hdr;
>>> +	struct device_header		dev_hdr;
>>> +	struct framebuffer		fb;
>>> +};
>>> +
>>>  static bool vesa_pci_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>>>  {
>>>  	return true;
>>> @@ -33,29 +39,52 @@ static struct ioport_operations vesa_io_ops = {
>>>  	.io_out			= vesa_pci_io_out,
>>>  };
>>>  
>>> -static struct pci_device_header vesa_pci_device = {
>>> -	.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
>>> -	.device_id		= cpu_to_le16(PCI_DEVICE_ID_VESA),
>>> -	.header_type		= PCI_HEADER_TYPE_NORMAL,
>>> -	.revision_id		= 0,
>>> -	.class[2]		= 0x03,
>>> -	.subsys_vendor_id	= cpu_to_le16(PCI_SUBSYSTEM_VENDOR_ID_REDHAT_QUMRANET),
>>> -	.subsys_id		= cpu_to_le16(PCI_SUBSYSTEM_ID_VESA),
>>> -	.bar[1]			= cpu_to_le32(VESA_MEM_ADDR | PCI_BASE_ADDRESS_SPACE_MEMORY),
>>> -	.bar_size[1]		= VESA_MEM_SIZE,
>>> -};
>>> +static int vesa__bar_activate(struct kvm *kvm,
>>> +			      struct pci_device_header *pci_hdr,
>>> +			      int bar_num, void *data)
>>> +{
>>> +	struct vesa_dev *vdev = data;
>>> +	u32 bar_addr, bar_size;
>>> +	char *mem;
>>> +	int r;
>>>  
>>> -static struct device_header vesa_device = {
>>> -	.bus_type	= DEVICE_BUS_PCI,
>>> -	.data		= &vesa_pci_device,
>>> -};
>>> +	bar_addr = pci__bar_address(pci_hdr, bar_num);
>>> +	bar_size = pci_hdr->bar_size[bar_num];
>>>  
>>> -static struct framebuffer vesafb;
>>> +	switch (bar_num) {
>>> +	case 0:
>>> +		r = ioport__register(kvm, bar_addr, &vesa_io_ops, bar_size,
>>> +				     NULL);
>>> +		break;
>>> +	case 1:
>>> +		mem = mmap(NULL, bar_size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
>>> +		if (mem == MAP_FAILED) {
>>> +			r = -errno;
>>> +			break;
>>> +		}
>>> +		r = kvm__register_dev_mem(kvm, bar_addr, bar_size, mem);
>>> +		if (r < 0)
>>> +			break;
>>> +		vdev->fb.mem = mem;
>>> +		break;
>>> +	default:
>>> +		r = -EINVAL;
>>> +	}
>>> +
>>> +	return r;
>>> +}
>>> +
>>> +static int vesa__bar_deactivate(struct kvm *kvm,
>>> +				struct pci_device_header *pci_hdr,
>>> +				int bar_num, void *data)
>>> +{
>>> +	return -EINVAL;
>>> +}
>>>  
>>>  struct framebuffer *vesa__init(struct kvm *kvm)
>>>  {
>>> -	u16 vesa_base_addr;
>>> -	char *mem;
>>> +	struct vesa_dev *vdev;
>>> +	u16 port_addr;
>>>  	int r;
>>>  
>>>  	BUILD_BUG_ON(!is_power_of_two(VESA_MEM_SIZE));
>>> @@ -63,34 +92,51 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>>>  
>>>  	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
>>>  		return NULL;
>>> -	r = pci_get_io_port_block(PCI_IO_SIZE);
>>> -	r = ioport__register(kvm, r, &vesa_io_ops, PCI_IO_SIZE, NULL);
>>> -	if (r < 0)
>>> -		return ERR_PTR(r);
>>>  
>>> -	vesa_base_addr			= (u16)r;
>>> -	vesa_pci_device.bar[0]		= cpu_to_le32(vesa_base_addr | PCI_BASE_ADDRESS_SPACE_IO);
>>> -	vesa_pci_device.bar_size[0]	= PCI_IO_SIZE;
>>> -	r = device__register(&vesa_device);
>>> -	if (r < 0)
>>> -		return ERR_PTR(r);
>>> +	vdev = calloc(1, sizeof(*vdev));
>>> +	if (vdev == NULL)
>>> +		return ERR_PTR(-ENOMEM);
>> Is it really necessary to allocate this here? You never free this, and I don't see how you could actually do this. AFAICS conceptually there can be only one VESA device? So maybe have a static variable above and use that instead of passing the pointer around? Or use &vdev if you need a pointer argument for the callbacks.
> As far as I can tell, there can be only one VESA device, yes. I was following the
> same pattern from virtio/{net,blk,rng,scsi,9p}.c, which I prefer because it's
> explicit what function can access the device. What's wrong with passing the
> pointer around? The entire PCI emulation code works like that.
>
I took a closer look at this patch and it turns out that vesa__bar_activate is
called exactly once, at initialization, because vesa__bar_deactivate doesn't
actually deactivate emulation (and returns an error to let the PCI emulation code
know that). I will drop the changes to hw/vesa.c and keep the vesa device static
and framebuffer creation in vesa__init.

Thanks,
Alex
