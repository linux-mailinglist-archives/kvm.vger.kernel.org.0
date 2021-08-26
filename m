Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF753F8CB7
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 19:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhHZRIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 13:08:47 -0400
Received: from foss.arm.com ([217.140.110.172]:50598 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243152AbhHZRIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 13:08:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D36BD31B;
        Thu, 26 Aug 2021 10:07:58 -0700 (PDT)
Received: from [10.1.25.18] (e110479.cambridge.arm.com [10.1.25.18])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B5A83F5A1;
        Thu, 26 Aug 2021 10:07:57 -0700 (PDT)
Subject: Re: [PATCH][kvmtool] virtio/pci: Correctly handle MSI-X masking while
 MSI-X is disabled
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        kernel-team@android.com,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
References: <20210821120742.855712-1-maz@kernel.org>
 <20210823174833.05adee5d@slackpad.fritz.box> <87tujeq5ey.wl-maz@kernel.org>
 <87a6l5pmim.wl-maz@kernel.org> <878s0ppgff.wl-maz@kernel.org>
From:   Andre Przywara <andre.przywara@arm.com>
Message-ID: <7c2abc6a-164a-b07e-a39e-756b83a98f0c@arm.com>
Date:   Thu, 26 Aug 2021 18:07:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <878s0ppgff.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/21 6:44 PM, Marc Zyngier wrote:

Hi Marc,

> On Wed, 25 Aug 2021 16:33:21 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
>>
>> On Tue, 24 Aug 2021 15:32:53 +0100,
>> Marc Zyngier <maz@kernel.org> wrote:
>>>
>>> Hi Andre,
>>>
>>> On Mon, 23 Aug 2021 17:48:33 +0100,
>>> Andre Przywara <andre.przywara@arm.com> wrote:
>>>>
>>>> On Sat, 21 Aug 2021 13:07:42 +0100
>>>> Marc Zyngier <maz@kernel.org> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>>> Since Linux commit 7d5ec3d36123 ("PCI/MSI: Mask all unused MSI-X
>>>>> entries"), kvmtool segfaults when the guest boots and tries to
>>>>> disable all the MSI-X entries of a virtio device while MSI-X itself
>>>>> is disabled.
>>>>>
>>>>> What Linux does is seems perfectly correct. However, kvmtool uses
>>>>> a different decoding depending on whether MSI-X is enabled for
>>>>> this device or not. Which seems pretty wrong.
>>>>
>>>> While I really wish this would be wrong, I think this is
>>>> indeed how this is supposed to work: The Virtio legacy spec makes the
>>>> existence of those two virtio config fields dependent on the
>>>> (dynamic!) enablement status of MSI-X. This is reflected in:
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/virtio_pci.h#n72
>>>> and explicitly mentioned as a footnote in the virtio 0.9.5 spec[1]:
>>>> "3) ie. once you enable MSI-X on the device, the other fields move. If
>>>> you turn it off again, they move back!"
>>>
>>> Madness! What was Rusty on at the time? I really hope the bitcoin
>>> thing is buying him better stuff...
>>>
>>>> I agree that this looks like a bad idea, but I am afraid we are stuck
>>>> with this. It looks like the Linux driver is at fault here, it should
>>>> not issue the config access when MSIs are disabled. Something like this
>>>> (untested):
>>>>
>>>> --- a/drivers/virtio/virtio_pci_legacy.c
>>>> +++ b/drivers/virtio/virtio_pci_legacy.c
>>>> @@ -103,6 +103,9 @@ static void vp_reset(struct virtio_device *vdev)
>>>>   
>>>>   static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
>>>>   {
>>>> +       if (!vp_dev->msix_enabled)
>>>> +               return VIRTIO_MSI_NO_VECTOR;
>>>> +
>>>>          /* Setup the vector used for configuration events */
>>>>          iowrite16(vector, vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
>>>>          /* Verify we had enough resources to assign the vector */
>>>>
>>>> This is just my first idea after looking at this, happy to stand
>>>> corrected or hear about a better solution.
>>>
>>> I don't think this works. It instead completely disables MSI-X, which
>>> is a total bore. I think the only way to deal with it is to quirk it
>>> to prevent the bulk masking to take effect before MSI-X is enabled.
>>
>> Actually, let me correct myself. I tested the wrong configuration (why
>> isn't --force-pci the bloody default in kvmtool?).

I guess because there is no --force-mmio, and PCI on ARM was kind of 
daunting back then ;-)


>> This patch doesn't
>> fix anything at all, and kvmtool just explodes.
>>
>> Having dug further, it isn't the config space that causes problems,
>> but the programming of the MSI-X vectors. I'm starting to suspect the
>> layout of the MSI-X bar in kvmtool.
> 
> OK, this is hilarious. Sort of. The MSI-X bar sizing is bonkers: you
> can't fit 33 MSIs there (33 being the number of MSI-X that kvmtool
> advertises), and you will have notionally overwritten the PBA as
> well. Amusingly, the last write ends up being misdecoded as a config
> space access...

Ah, very good find indeed, many thanks for the debugging!

I am only halfway through the code by now, but wouldn't you need to 
adjust the PBA offset in the MSIX capability as well? This is still 
stuck at that (misnamed) PCI_IO_SIZE, in 
virtio/pci.c:virtio_pci__init(): vpci->pci_hdr.msix.pba_offset =
And IIUC this has to match the decoding in virtio_pci__msix_mmio_callback().

Cheers,
Andre

> 
> "works for me".
> 
> 	M.
> 
>  From a2b3a338aab535a1683cc5b424455ed7fd3a500a Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Wed, 25 Aug 2021 18:19:27 +0100
> Subject: [PATCH] virtio/pci: Size the MSI-X bar according to the number of
>   MSI-X
> 
> Since 45d3b59e8c45 ("kvm tools: Increase amount of possible interrupts
> per PCI device"), the number of MSI-S has gone from 4 to 33.
> 
> However, the corresponding storage hasn't been upgraded, and writing
> to the MSI-X table is a pretty risky business. Now that the Linux
> kernel writes to *all* MSI-X entries before doing anything else
> with the device, kvmtool dies a horrible death.
> 
> Fix it by properly defining the size of the MSI-X bar, and make
> Linux great again.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   virtio/pci.c | 29 +++++++++++++++++++++--------
>   1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/virtio/pci.c b/virtio/pci.c
> index eb91f512..726146fc 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -7,6 +7,7 @@
>   #include "kvm/irq.h"
>   #include "kvm/virtio.h"
>   #include "kvm/ioeventfd.h"
> +#include "kvm/util.h"
>   
>   #include <sys/ioctl.h>
>   #include <linux/virtio_pci.h>
> @@ -14,6 +15,13 @@
>   #include <assert.h>
>   #include <string.h>
>   
> +#define ALIGN_UP(x, s)		ALIGN((x) + (s) - 1, (s))
> +#define VIRTIO_NR_MSIX		(VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG)
> +#define VIRTIO_MSIX_TABLE_SIZE	(VIRTIO_NR_MSIX * 16)
> +#define VIRTIO_MSIX_PBA_SIZE	(ALIGN_UP(VIRTIO_MSIX_TABLE_SIZE, 64) / 8)
> +#define VIRTIO_MSIX_BAR_SIZE	(1UL << fls_long(VIRTIO_MSIX_TABLE_SIZE + \
> +						 VIRTIO_MSIX_PBA_SIZE))
> +
>   static u16 virtio_pci__port_addr(struct virtio_pci *vpci)
>   {
>   	return pci__bar_address(&vpci->pci_hdr, 0);
> @@ -336,15 +344,20 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
>   	int vecnum;
>   	size_t offset;
>   
> -	if (addr > msix_io_addr + PCI_IO_SIZE) {
> +	if (addr > msix_io_addr + VIRTIO_MSIX_TABLE_SIZE) {
> +		/* Read access to PBA */
>   		if (is_write)
>   			return;
> -		table  = (struct msix_table *)&vpci->msix_pba;
> -		offset = addr - (msix_io_addr + PCI_IO_SIZE);
> -	} else {
> -		table  = vpci->msix_table;
> -		offset = addr - msix_io_addr;
> +		offset = addr - (msix_io_addr + VIRTIO_MSIX_TABLE_SIZE);
> +		if ((offset + len) > sizeof (vpci->msix_pba))
> +			return;
> +		memcpy(data, (void *)&vpci->msix_pba + offset, len);
> +		return;
>   	}
> +
> +	table  = vpci->msix_table;
> +	offset = addr - msix_io_addr;
> +
>   	vecnum = offset / sizeof(struct msix_table);
>   	offset = offset % sizeof(struct msix_table);
>   
> @@ -520,7 +533,7 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>   
>   	port_addr = pci_get_io_port_block(PCI_IO_SIZE);
>   	mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
> -	msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
> +	msix_io_block = pci_get_mmio_block(VIRTIO_MSIX_BAR_SIZE);
>   
>   	vpci->pci_hdr = (struct pci_device_header) {
>   		.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
> @@ -543,7 +556,7 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>   		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
>   		.bar_size[0]		= cpu_to_le32(PCI_IO_SIZE),
>   		.bar_size[1]		= cpu_to_le32(PCI_IO_SIZE),
> -		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
> +		.bar_size[2]		= cpu_to_le32(VIRTIO_MSIX_BAR_SIZE),
>   	};
>   
>   	r = pci__register_bar_regions(kvm, &vpci->pci_hdr,
> 

