Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08A1117FFFE
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 15:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgCJOR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 10:17:58 -0400
Received: from foss.arm.com ([217.140.110.172]:37660 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgCJOR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 10:17:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F16D30E;
        Tue, 10 Mar 2020 07:17:56 -0700 (PDT)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8917D3F6CF;
        Tue, 10 Mar 2020 07:17:55 -0700 (PDT)
Subject: Re: [PATCH v2 kvmtool 27/30] pci: Implement reassignable BARs
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-28-alexandru.elisei@arm.com>
 <20200207165055.18686892@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1e767685-dde9-6f8c-e3e4-7c368c14ee63@arm.com>
Date:   Tue, 10 Mar 2020 14:17:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207165055.18686892@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/7/20 4:50 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:48:02 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> BARs are used by the guest to configure the access to the PCI device by
>> writing the address to which the device will respond. The basic idea for
>> adding support for reassignable BARs is straightforward: deactivate
>> emulation for the memory region described by the old BAR value, and
>> activate emulation for the new region.
>>
>> BAR reassignement can be done while device access is enabled and memory
>> regions for different devices can overlap as long as no access is made
>> to the overlapping memory regions. This means that it is legal for the
>> BARs of two distinct devices to point to an overlapping memory region,
>> and indeed, this is how Linux does resource assignment at boot. To
>> account for this situation, the simple algorithm described above is
>> enhanced to scan for all devices and:
>>
>> - Deactivate emulation for any BARs that might overlap with the new BAR
>>   value.
>>
>> - Enable emulation for any BARs that were overlapping with the old value
>>   after the BAR has been updated.
>>
>> Activating/deactivating emulation of a memory region has side effects.
>> In order to prevent the execution of the same callback twice we now keep
>> track of the state of the region emulation. For example, this can happen
>> if we program a BAR with an address that overlaps a second BAR, thus
>> deactivating emulation for the second BAR, and then we disable all
>> region accesses to the second BAR by writing to the command register.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  hw/vesa.c           |   6 +-
>>  include/kvm/pci.h   |  23 +++-
>>  pci.c               | 274 +++++++++++++++++++++++++++++++++++---------
>>  powerpc/spapr_pci.c |   2 +-
>>  vfio/pci.c          |  15 ++-
>>  virtio/pci.c        |   8 +-
>>  6 files changed, 261 insertions(+), 67 deletions(-)
>>
>> diff --git a/hw/vesa.c b/hw/vesa.c
>> index 3044a86078fb..aca938f79c82 100644
>> --- a/hw/vesa.c
>> +++ b/hw/vesa.c
>> @@ -49,7 +49,7 @@ static int vesa__bar_activate(struct kvm *kvm,
>>  	int r;
>>  
>>  	bar_addr = pci__bar_address(pci_hdr, bar_num);
>> -	bar_size = pci_hdr->bar_size[bar_num];
>> +	bar_size = pci__bar_size(pci_hdr, bar_num);
>>  
>>  	switch (bar_num) {
>>  	case 0:
>> @@ -121,9 +121,9 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>>  		.subsys_vendor_id	= cpu_to_le16(PCI_SUBSYSTEM_VENDOR_ID_REDHAT_QUMRANET),
>>  		.subsys_id		= cpu_to_le16(PCI_SUBSYSTEM_ID_VESA),
>>  		.bar[0]			= cpu_to_le32(port_addr | PCI_BASE_ADDRESS_SPACE_IO),
>> -		.bar_size[0]		= PCI_IO_SIZE,
>> +		.bar_info[0]		= (struct pci_bar_info) {.size = PCI_IO_SIZE},
>>  		.bar[1]			= cpu_to_le32(VESA_MEM_ADDR | PCI_BASE_ADDRESS_SPACE_MEMORY),
>> -		.bar_size[1]		= VESA_MEM_SIZE,
>> +		.bar_info[1]		= (struct pci_bar_info) {.size = VESA_MEM_SIZE},
>>  	};
>>  
>>  	vdev->pci_hdr.cfg_ops = (struct pci_config_operations) {
>> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
>> index bf42f497168f..ae71ef33237c 100644
>> --- a/include/kvm/pci.h
>> +++ b/include/kvm/pci.h
>> @@ -11,6 +11,17 @@
>>  #include "kvm/msi.h"
>>  #include "kvm/fdt.h"
>>  
>> +#define pci_dev_err(pci_hdr, fmt, ...) \
>> +	pr_err("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
>> +#define pci_dev_warn(pci_hdr, fmt, ...) \
>> +	pr_warning("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
>> +#define pci_dev_info(pci_hdr, fmt, ...) \
>> +	pr_info("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
>> +#define pci_dev_dbg(pci_hdr, fmt, ...) \
>> +	pr_debug("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
>> +#define pci_dev_die(pci_hdr, fmt, ...) \
>> +	die("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
>> +
>>  /*
>>   * PCI Configuration Mechanism #1 I/O ports. See Section 3.7.4.1.
>>   * ("Configuration Mechanism #1") of the PCI Local Bus Specification 2.1 for
>> @@ -89,6 +100,11 @@ struct pci_cap_hdr {
>>  	u8	next;
>>  };
>>  
>> +struct pci_bar_info {
>> +	u32 size;
>> +	bool active;
>> +};
> Do we really need this data structure above?
> There is this "32-bit plus 1-bit" annoyance, but also a lot of changes in this patch are about this, making the code less pretty.
> So what about we introduce a bitmap, below in struct pci_device_header? I think we inherited the neat set_bit/test_bit functions from the kernel, so can we use that by just adding something like an "unsigned long bar_enabled;" below?

I think I understand what you are saying. I don't want to use a bitmap, because I
think that's even uglier. I'll try and see how adding an array of bools to struct
pci_device_header and keeping the bar_size member would look like.

>
>> +
>>  struct pci_device_header;
>>  
>>  typedef int (*bar_activate_fn_t)(struct kvm *kvm,
>> @@ -142,7 +158,7 @@ struct pci_device_header {
>>  	};
>>  
>>  	/* Private to lkvm */
>> -	u32		bar_size[6];
>> +	struct pci_bar_info	bar_info[6];
>>  	bar_activate_fn_t	bar_activate_fn;
>>  	bar_deactivate_fn_t	bar_deactivate_fn;
>>  	void *data;
>> @@ -224,4 +240,9 @@ static inline u32 pci__bar_address(struct pci_device_header *pci_hdr, int bar_nu
>>  	return __pci__bar_address(pci_hdr->bar[bar_num]);
>>  }
>>  
>> +static inline u32 pci__bar_size(struct pci_device_header *pci_hdr, int bar_num)
>> +{
>> +	return pci_hdr->bar_info[bar_num].size;
>> +}
>> +
>>  #endif /* KVM__PCI_H */
>> diff --git a/pci.c b/pci.c
>> index 98331a1fc205..1e9791250bc3 100644
>> --- a/pci.c
>> +++ b/pci.c
>> @@ -68,7 +68,7 @@ void pci__assign_irq(struct device_header *dev_hdr)
>>  
>>  static bool pci_bar_is_implemented(struct pci_device_header *pci_hdr, int bar_num)
>>  {
>> -	return  bar_num < 6 && pci_hdr->bar_size[bar_num];
>> +	return  bar_num < 6 && pci__bar_size(pci_hdr, bar_num);
>>  }
>>  
>>  static void *pci_config_address_ptr(u16 port)
>> @@ -157,6 +157,46 @@ static struct ioport_operations pci_config_data_ops = {
>>  	.io_out	= pci_config_data_out,
>>  };
>>  
>> +static int pci_activate_bar(struct kvm *kvm, struct pci_device_header *pci_hdr,
>> +			    int bar_num)
>> +{
>> +	int r = 0;
>> +
>> +	if (pci_hdr->bar_info[bar_num].active)
>> +		goto out;
>> +
>> +	r = pci_hdr->bar_activate_fn(kvm, pci_hdr, bar_num, pci_hdr->data);
>> +	if (r < 0) {
>> +		pci_dev_err(pci_hdr, "Error activating emulation for BAR %d",
>> +			    bar_num);
>> +		goto out;
>> +	}
>> +	pci_hdr->bar_info[bar_num].active = true;
>> +
>> +out:
>> +	return r;
>> +}
>> +
>> +static int pci_deactivate_bar(struct kvm *kvm, struct pci_device_header *pci_hdr,
>> +			      int bar_num)
>> +{
>> +	int r = 0;
>> +
>> +	if (!pci_hdr->bar_info[bar_num].active)
>> +		goto out;
>> +
>> +	r = pci_hdr->bar_deactivate_fn(kvm, pci_hdr, bar_num, pci_hdr->data);
>> +	if (r < 0) {
>> +		pci_dev_err(pci_hdr, "Error deactivating emulation for BAR %d",
>> +			    bar_num);
>> +		goto out;
>> +	}
>> +	pci_hdr->bar_info[bar_num].active = false;
>> +
>> +out:
>> +	return r;
>> +}
>> +
>>  static void pci_config_command_wr(struct kvm *kvm,
>>  				  struct pci_device_header *pci_hdr,
>>  				  u16 new_command)
>> @@ -173,26 +213,179 @@ static void pci_config_command_wr(struct kvm *kvm,
>>  
>>  		if (toggle_io && pci__bar_is_io(pci_hdr, i)) {
>>  			if (__pci__io_space_enabled(new_command))
>> -				pci_hdr->bar_activate_fn(kvm, pci_hdr, i,
>> -							 pci_hdr->data);
>> -			else
>> -				pci_hdr->bar_deactivate_fn(kvm, pci_hdr, i,
>> -							   pci_hdr->data);
>> +				pci_activate_bar(kvm, pci_hdr, i);
>> +			if (!__pci__io_space_enabled(new_command))
> Isn't that just "else", as before?
>
>> +				pci_deactivate_bar(kvm, pci_hdr, i);
>>  		}
>>  
>>  		if (toggle_mem && pci__bar_is_memory(pci_hdr, i)) {
>>  			if (__pci__memory_space_enabled(new_command))
>> -				pci_hdr->bar_activate_fn(kvm, pci_hdr, i,
>> -							 pci_hdr->data);
>> -			else
>> -				pci_hdr->bar_deactivate_fn(kvm, pci_hdr, i,
>> -							   pci_hdr->data);
>> +				pci_activate_bar(kvm, pci_hdr, i);
>> +			if (!__pci__memory_space_enabled(new_command))
> Same here?

You're right (same as above).

>
>> +				pci_deactivate_bar(kvm, pci_hdr, i);
>>  		}
>>  	}
>>  
>>  	pci_hdr->command = new_command;
>>  }
>>  
>> +static int pci_deactivate_bar_regions(struct kvm *kvm,
>> +				      struct pci_device_header *pci_hdr,
>> +				      u32 start, u32 size)
>> +{
>> +	struct device_header *dev_hdr;
>> +	struct pci_device_header *tmp_hdr;
>> +	u32 tmp_addr, tmp_size;
>> +	int i, r;
>> +
>> +	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
>> +	while (dev_hdr) {
>> +		tmp_hdr = dev_hdr->data;
>> +		for (i = 0; i < 6; i++) {
>> +			if (!pci_bar_is_implemented(tmp_hdr, i))
>> +				continue;
>> +
>> +			tmp_addr = pci__bar_address(tmp_hdr, i);
>> +			tmp_size = pci__bar_size(tmp_hdr, i);
>> +
>> +			if (tmp_addr + tmp_size <= start ||
>> +			    tmp_addr >= start + size)
>> +				continue;
>> +
>> +			r = pci_deactivate_bar(kvm, tmp_hdr, i);
>> +			if (r < 0)
>> +				return r;
>> +		}
>> +		dev_hdr = device__next_dev(dev_hdr);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int pci_activate_bar_regions(struct kvm *kvm,
>> +				    struct pci_device_header *pci_hdr,
>> +				    u32 start, u32 size)
>> +{
>> +	struct device_header *dev_hdr;
>> +	struct pci_device_header *tmp_hdr;
>> +	u32 tmp_addr, tmp_size;
>> +	int i, r;
>> +
>> +	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
>> +	while (dev_hdr) {
>> +		tmp_hdr = dev_hdr->data;
>> +		for (i = 0; i < 6; i++) {
>> +			if (!pci_bar_is_implemented(tmp_hdr, i))
>> +				continue;
>> +
>> +			tmp_addr = pci__bar_address(tmp_hdr, i);
>> +			tmp_size = pci__bar_size(tmp_hdr, i);
>> +
>> +			if (tmp_addr + tmp_size <= start ||
>> +			    tmp_addr >= start + size)
>> +				continue;
>> +
>> +			r = pci_activate_bar(kvm, tmp_hdr, i);
>> +			if (r < 0)
>> +				return r;
>> +		}
>> +		dev_hdr = device__next_dev(dev_hdr);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void pci_config_bar_wr(struct kvm *kvm,
>> +			      struct pci_device_header *pci_hdr, int bar_num,
>> +			      u32 value)
>> +{
>> +	u32 old_addr, new_addr, bar_size;
>> +	u32 mask;
>> +	int r;
>> +
>> +	if (pci__bar_is_io(pci_hdr, bar_num))
>> +		mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
>> +	else
>> +		mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
>> +
>> +	/*
>> +	 * If the kernel masks the BAR, it will expect to find the size of the
>> +	 * BAR there next time it reads from it. After the kernel reads the
>> +	 * size, it will write the address back.
>> +	 *
>> +	 * According to the PCI local bus specification REV 3.0: The number of
>> +	 * upper bits that a device actually implements depends on how much of
>> +	 * the address space the device will respond to. A device that wants a 1
>> +	 * MB memory address space (using a 32-bit base address register) would
>> +	 * build the top 12 bits of the address register, hardwiring the other
>> +	 * bits to 0.
>> +	 *
>> +	 * Furthermore, software can determine how much address space the device
>> +	 * requires by writing a value of all 1's to the register and then
>> +	 * reading the value back. The device will return 0's in all don't-care
>> +	 * address bits, effectively specifying the address space required.
>> +	 *
>> +	 * Software computes the size of the address space with the formula
>> +	 * S =  ~B + 1, where S is the memory size and B is the value read from
>> +	 * the BAR. This means that the BAR value that kvmtool should return is
>> +	 * B = ~(S - 1).
>> +	 */
>> +	if (value == 0xffffffff) {
>> +		value = ~(pci__bar_size(pci_hdr, bar_num) - 1);
>> +		/* Preserve the special bits. */
>> +		value = (value & mask) | (pci_hdr->bar[bar_num] & ~mask);
>> +		pci_hdr->bar[bar_num] = value;
>> +		return;
>> +	}
>> +
>> +	value = (value & mask) | (pci_hdr->bar[bar_num] & ~mask);
>> +
>> +	/* Don't toggle emulation when region type access is disbled. */
>> +	if (pci__bar_is_io(pci_hdr, bar_num) &&
>> +	    !pci__io_space_enabled(pci_hdr)) {
>> +		pci_hdr->bar[bar_num] = value;
>> +		return;
>> +	}
>> +
>> +	if (pci__bar_is_memory(pci_hdr, bar_num) &&
>> +	    !pci__memory_space_enabled(pci_hdr)) {
>> +		pci_hdr->bar[bar_num] = value;
>> +		return;
>> +	}
>> +
>> +	old_addr = pci__bar_address(pci_hdr, bar_num);
>> +	new_addr = __pci__bar_address(value);
>> +	bar_size = pci__bar_size(pci_hdr, bar_num);
>> +
>> +	r = pci_deactivate_bar(kvm, pci_hdr, bar_num);
>> +	if (r < 0)
>> +		return;
>> +
>> +	r = pci_deactivate_bar_regions(kvm, pci_hdr, new_addr, bar_size);
>> +	if (r < 0) {
>> +		/*
>> +		 * We cannot update the BAR because of an overlapping region
>> +		 * that failed to deactivate emulation, so keep the old BAR
>> +		 * value and re-activate emulation for it.
>> +		 */
>> +		pci_activate_bar(kvm, pci_hdr, bar_num);
>> +		return;
>> +	}
>> +
>> +	pci_hdr->bar[bar_num] = value;
>> +	r = pci_activate_bar(kvm, pci_hdr, bar_num);
>> +	if (r < 0) {
>> +		/*
>> +		 * New region cannot be emulated, re-enable the regions that
>> +		 * were overlapping.
>> +		 */
>> +		pci_activate_bar_regions(kvm, pci_hdr, new_addr, bar_size);
>> +		return;
>> +	}
>> +
>> +	pci_activate_bar_regions(kvm, pci_hdr, old_addr, bar_size);
>> +}
>> +
>>  void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
>>  {
>>  	void *base;
>> @@ -200,7 +393,6 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>>  	struct pci_device_header *pci_hdr;
>>  	u8 dev_num = addr.device_number;
>>  	u32 value = 0;
>> -	u32 mask;
>>  
>>  	if (!pci_device_exists(addr.bus_number, dev_num, 0))
>>  		return;
>> @@ -225,46 +417,13 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>>  	}
>>  
>>  	bar = (offset - PCI_BAR_OFFSET(0)) / sizeof(u32);
>> -
>> -	/*
>> -	 * If the kernel masks the BAR, it will expect to find the size of the
>> -	 * BAR there next time it reads from it. After the kernel reads the
>> -	 * size, it will write the address back.
>> -	 */
>>  	if (bar < 6) {
>> -		if (pci__bar_is_io(pci_hdr, bar))
>> -			mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
>> -		else
>> -			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
>> -		/*
>> -		 * According to the PCI local bus specification REV 3.0:
>> -		 * The number of upper bits that a device actually implements
>> -		 * depends on how much of the address space the device will
>> -		 * respond to. A device that wants a 1 MB memory address space
>> -		 * (using a 32-bit base address register) would build the top
>> -		 * 12 bits of the address register, hardwiring the other bits
>> -		 * to 0.
>> -		 *
>> -		 * Furthermore, software can determine how much address space
>> -		 * the device requires by writing a value of all 1's to the
>> -		 * register and then reading the value back. The device will
>> -		 * return 0's in all don't-care address bits, effectively
>> -		 * specifying the address space required.
>> -		 *
>> -		 * Software computes the size of the address space with the
>> -		 * formula S = ~B + 1, where S is the memory size and B is the
>> -		 * value read from the BAR. This means that the BAR value that
>> -		 * kvmtool should return is B = ~(S - 1).
>> -		 */
>>  		memcpy(&value, data, size);
>> -		if (value == 0xffffffff)
>> -			value = ~(pci_hdr->bar_size[bar] - 1);
>> -		/* Preserve the special bits. */
>> -		value = (value & mask) | (pci_hdr->bar[bar] & ~mask);
>> -		memcpy(base + offset, &value, size);
>> -	} else {
>> -		memcpy(base + offset, data, size);
>> +		pci_config_bar_wr(kvm, pci_hdr, bar, value);
>> +		return;
>>  	}
>> +
>> +	memcpy(base + offset, data, size);
>>  }
>>  
>>  void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size)
>> @@ -329,20 +488,21 @@ int pci__register_bar_regions(struct kvm *kvm, struct pci_device_header *pci_hdr
>>  			continue;
>>  
>>  		has_bar_regions = true;
>> +		assert(!pci_hdr->bar_info[i].active);
>>  
>>  		if (pci__bar_is_io(pci_hdr, i) &&
>>  		    pci__io_space_enabled(pci_hdr)) {
>> -				r = bar_activate_fn(kvm, pci_hdr, i, data);
>> -				if (r < 0)
>> -					return r;
>> -			}
>> +			r = pci_activate_bar(kvm, pci_hdr, i);
>> +			if (r < 0)
>> +				return r;
>> +		}
>>  
>>  		if (pci__bar_is_memory(pci_hdr, i) &&
>>  		    pci__memory_space_enabled(pci_hdr)) {
>> -				r = bar_activate_fn(kvm, pci_hdr, i, data);
>> -				if (r < 0)
>> -					return r;
>> -			}
>> +			r = pci_activate_bar(kvm, pci_hdr, i);
>> +			if (r < 0)
>> +				return r;
>> +		}
>>  	}
>>  
>>  	assert(has_bar_regions);
>> diff --git a/powerpc/spapr_pci.c b/powerpc/spapr_pci.c
>> index a15f7d895a46..7be44d950acb 100644
>> --- a/powerpc/spapr_pci.c
>> +++ b/powerpc/spapr_pci.c
>> @@ -369,7 +369,7 @@ int spapr_populate_pci_devices(struct kvm *kvm,
>>  				of_pci_b_ddddd(devid) |
>>  				of_pci_b_fff(fn) |
>>  				of_pci_b_rrrrrrrr(bars[i]));
>> -			reg[n+1].size = cpu_to_be64(hdr->bar_size[i]);
>> +			reg[n+1].size = cpu_to_be64(pci__bar_size(hdr, i));
>>  			reg[n+1].addr = 0;
>>  
>>  			assigned_addresses[n].phys_hi = cpu_to_be32(
>> diff --git a/vfio/pci.c b/vfio/pci.c
>> index 9e595562180b..3a641e72e574 100644
>> --- a/vfio/pci.c
>> +++ b/vfio/pci.c
>> @@ -455,6 +455,7 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
>>  	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
>>  	struct vfio_pci_msix_table *table = &pdev->msix_table;
>>  	struct vfio_region *region = &vdev->regions[bar_num];
>> +	u32 bar_addr;
>>  	int ret;
>>  
>>  	if (!region->info.size) {
>> @@ -462,8 +463,11 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
>>  		goto out;
>>  	}
>>  
>> +	bar_addr = pci__bar_address(pci_hdr, bar_num);
>> +
>>  	if ((pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX) &&
>>  	    (u32)bar_num == table->bar) {
>> +		table->guest_phys_addr = region->guest_phys_addr = bar_addr;
> I think those double assignments are a bit frowned upon, at least in Linux coding style. It would probably be cleaner to assign the region member after the error check.
>
>>  		ret = kvm__register_mmio(kvm, table->guest_phys_addr,
>>  					 table->size, false,
>>  					 vfio_pci_msix_table_access, pdev);
>> @@ -473,13 +477,22 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
>>  
>>  	if ((pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX) &&
>>  	    (u32)bar_num == pba->bar) {
>> +		if (pba->bar == table->bar)
>> +			pba->guest_phys_addr = table->guest_phys_addr + table->size;
>> +		else
>> +			pba->guest_phys_addr = region->guest_phys_addr = bar_addr;
> same here with the double assignment

Ok, I'll split it.

>
>>  		ret = kvm__register_mmio(kvm, pba->guest_phys_addr,
>>  					 pba->size, false,
>>  					 vfio_pci_msix_pba_access, pdev);
>>  		goto out;
>>  	}
>>  
>> +	if (pci__bar_is_io(pci_hdr, bar_num))
>> +		region->port_base = bar_addr;
>> +	else
>> +		region->guest_phys_addr = bar_addr;
> Isn't that redundant with those double assignments above? Maybe you can get rid of those altogether?

I don't think it's redundant, because the double assignments above only happen
when specific conditions are met.

Thanks,
Alex
