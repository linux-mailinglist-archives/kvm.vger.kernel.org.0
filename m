Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A788A15571B
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 12:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgBGLo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 06:44:27 -0500
Received: from foss.arm.com ([217.140.110.172]:39416 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgBGLo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 06:44:27 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3843F328;
        Fri,  7 Feb 2020 03:44:26 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45F9E3F68E;
        Fri,  7 Feb 2020 03:44:25 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 26/30] pci: Toggle BAR I/O and memory space
 emulation
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-27-alexandru.elisei@arm.com>
 <20200206182137.48894a54@donnerap.cambridge.arm.com>
 <2d14a067-7d7c-d7b4-90f3-72f5778a2fec@arm.com>
 <20200207113619.26c11a24@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <8096b1b0-d903-896c-f8f6-60088a50342e@arm.com>
Date:   Fri, 7 Feb 2020 11:44:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113619.26c11a24@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/7/20 11:36 AM, Andre Przywara wrote:
> On Fri, 7 Feb 2020 11:08:19 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> On 2/6/20 6:21 PM, Andre Przywara wrote:
>>> On Thu, 23 Jan 2020 13:48:01 +0000
>>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>>
>>> Hi,
>>>  
>>>> During configuration of the BAR addresses, a Linux guest disables and
>>>> enables access to I/O and memory space. When access is disabled, we don't
>>>> stop emulating the memory regions described by the BARs. Now that we have
>>>> callbacks for activating and deactivating emulation for a BAR region,
>>>> let's use that to stop emulation when access is disabled, and
>>>> re-activate it when access is re-enabled.
>>>>
>>>> The vesa emulation hasn't been designed with toggling on and off in
>>>> mind, so refuse writes to the PCI command register that disable memory
>>>> or IO access.
>>>>
>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>> ---
>>>>  hw/vesa.c | 16 ++++++++++++++++
>>>>  pci.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
>>>>  2 files changed, 58 insertions(+)
>>>>
>>>> diff --git a/hw/vesa.c b/hw/vesa.c
>>>> index 74ebebbefa6b..3044a86078fb 100644
>>>> --- a/hw/vesa.c
>>>> +++ b/hw/vesa.c
>>>> @@ -81,6 +81,18 @@ static int vesa__bar_deactivate(struct kvm *kvm,
>>>>  	return -EINVAL;
>>>>  }
>>>>  
>>>> +static void vesa__pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hdr,
>>>> +				u8 offset, void *data, int sz)
>>>> +{
>>>> +	u32 value;  
>>> I guess the same comment as on the other patch applies: using u64 looks safer to me. Also you should clear it, to avoid nasty surprises in case of a short write (1 or 2 bytes only).  
>> I was under the impression that the maximum size for a write to the PCI CAM or
>> ECAM space is 32 bits. This is certainly what I've seen when running Linux, and
>> the assumption in the PCI emulation code which has been working since 2010. I'm
>> trying to dig out more information about this.
>>
>> If it's not, then we have a bigger problem because the PCI emulation code doesn't
>> support it, and to account for it we would need to add a certain amount of logic
>> to the code to deal with it: what if a write hits the command register and another
>> adjacent register? what if a write hits two BARs? A BAR and a regular register
>> before/after it? Part of a BAR and two registers before/after? You can see where
>> this is going.
>>
>> Until we find exactly where in a PCI spec says that 64 bit writes to the
>> configuration space are allowed, I would rather avoid all this complexity and
>> assume that the guest is sane and will only write 32 bit values.
> I don't think it's allowed, but that's not the point here:
> If a (malicious?) guest does a 64-bit write, it will overwrite kvmtool's stack. We should not allow that. We don't need to behave correctly, but the guest should not be able to affect the host (VMM). All it should take is to have "u64 value = 0;" to fix that.
>
> Another possibility would be to filter for legal MMIO lengths earlier.

I would rather respond to accesses to the PCI config space which are longer than
32 bits with a MASTER ABORT. I think this would be more robust.

Thanks,
Alex
>
> Cheers,
> Andre.
>
>> Thanks,
>> Alex
>>> The rest looks alright.
>>>
>>> Cheers,
>>> Andre
>>>  
>>>> +
>>>> +	if (offset == PCI_COMMAND) {
>>>> +		memcpy(&value, data, sz);
>>>> +		value |= (PCI_COMMAND_IO | PCI_COMMAND_MEMORY);
>>>> +		memcpy(data, &value, sz);
>>>> +	}
>>>> +}
>>>> +
>>>>  struct framebuffer *vesa__init(struct kvm *kvm)
>>>>  {
>>>>  	struct vesa_dev *vdev;
>>>> @@ -114,6 +126,10 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>>>>  		.bar_size[1]		= VESA_MEM_SIZE,
>>>>  	};
>>>>  
>>>> +	vdev->pci_hdr.cfg_ops = (struct pci_config_operations) {
>>>> +		.write	= vesa__pci_cfg_write,
>>>> +	};
>>>> +
>>>>  	vdev->fb = (struct framebuffer) {
>>>>  		.width			= VESA_WIDTH,
>>>>  		.height			= VESA_HEIGHT,
>>>> diff --git a/pci.c b/pci.c
>>>> index 5412f2defa2e..98331a1fc205 100644
>>>> --- a/pci.c
>>>> +++ b/pci.c
>>>> @@ -157,6 +157,42 @@ static struct ioport_operations pci_config_data_ops = {
>>>>  	.io_out	= pci_config_data_out,
>>>>  };
>>>>  
>>>> +static void pci_config_command_wr(struct kvm *kvm,
>>>> +				  struct pci_device_header *pci_hdr,
>>>> +				  u16 new_command)
>>>> +{
>>>> +	int i;
>>>> +	bool toggle_io, toggle_mem;
>>>> +
>>>> +	toggle_io = (pci_hdr->command ^ new_command) & PCI_COMMAND_IO;
>>>> +	toggle_mem = (pci_hdr->command ^ new_command) & PCI_COMMAND_MEMORY;
>>>> +
>>>> +	for (i = 0; i < 6; i++) {
>>>> +		if (!pci_bar_is_implemented(pci_hdr, i))
>>>> +			continue;
>>>> +
>>>> +		if (toggle_io && pci__bar_is_io(pci_hdr, i)) {
>>>> +			if (__pci__io_space_enabled(new_command))
>>>> +				pci_hdr->bar_activate_fn(kvm, pci_hdr, i,
>>>> +							 pci_hdr->data);
>>>> +			else
>>>> +				pci_hdr->bar_deactivate_fn(kvm, pci_hdr, i,
>>>> +							   pci_hdr->data);
>>>> +		}
>>>> +
>>>> +		if (toggle_mem && pci__bar_is_memory(pci_hdr, i)) {
>>>> +			if (__pci__memory_space_enabled(new_command))
>>>> +				pci_hdr->bar_activate_fn(kvm, pci_hdr, i,
>>>> +							 pci_hdr->data);
>>>> +			else
>>>> +				pci_hdr->bar_deactivate_fn(kvm, pci_hdr, i,
>>>> +							   pci_hdr->data);
>>>> +		}
>>>> +	}
>>>> +
>>>> +	pci_hdr->command = new_command;
>>>> +}
>>>> +
>>>>  void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
>>>>  {
>>>>  	void *base;
>>>> @@ -182,6 +218,12 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>>>>  	if (*(u32 *)(base + offset) == 0)
>>>>  		return;
>>>>  
>>>> +	if (offset == PCI_COMMAND) {
>>>> +		memcpy(&value, data, size);
>>>> +		pci_config_command_wr(kvm, pci_hdr, (u16)value);
>>>> +		return;
>>>> +	}
>>>> +
>>>>  	bar = (offset - PCI_BAR_OFFSET(0)) / sizeof(u32);
>>>>  
>>>>  	/*  
