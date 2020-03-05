Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B7E17A5FE
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 14:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgCENGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 08:06:39 -0500
Received: from foss.arm.com ([217.140.110.172]:48346 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgCENGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 08:06:39 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AF271FB;
        Thu,  5 Mar 2020 05:06:38 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70A303F6CF;
        Thu,  5 Mar 2020 05:06:37 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 09/30] arm/pci: Fix PCI IO region
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org,
        Julien Thierry <julien.thierry@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-10-alexandru.elisei@arm.com>
 <20200129181624.5f723196@donnerap.cambridge.arm.com>
 <604f481f-217c-c75b-cfaa-1e7bc0ba3b04@arm.com>
Message-ID: <29e4bafd-7812-01cb-5286-9855329a0001@arm.com>
Date:   Thu, 5 Mar 2020 13:06:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <604f481f-217c-c75b-cfaa-1e7bc0ba3b04@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 3/4/20 4:20 PM, Alexandru Elisei wrote:
> Hi,
>
> On 1/29/20 6:16 PM, Andre Przywara wrote:
>> On Thu, 23 Jan 2020 13:47:44 +0000
>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>
>> Hi,
>>
>>> From: Julien Thierry <julien.thierry@arm.com>
>>>
>>> Current PCI IO region that is exposed through the DT contains ports that
>>> are reserved by non-PCI devices.
>>>
>>> Use the proper PCI IO start so that the region exposed through DT can
>>> actually be used to reassign device BARs.
>> I guess the majority of the patch is about that the current allocation starts at 0x6200, which is not 4K aligned?
>> It would be nice if we could mention this in the commit message.
>>
>> Actually, silly question: It seems like this 0x6200 is rather arbitrary, can't we just change that to a 4K aligned value and drop that patch here?
>> If something on the x86 side relies on that value, it should rather be explicit than by chance.
>> (Because while this patch here seems correct, it's also quite convoluted.)
> I've taken a closer look at this patch, and to be honest right now it seems at
> best redundant. I don't really understand why the start of the PCI ioport region
> must be aligned to 4K - a Linux guest has no problem assigning address 0x1100 for
> ioports without this patch, but with the rest of the series applied. On the
> kvmtool side, arm doesn't have any fixed I/O device addresses like x86 does, so
> it's safe to use to use the entire region starting at 0 for ioport allocation.
> Even without any of the patches from this series, I haven't encountered any
> instances of Linux complaining.
>
> I'll test this some more before posting v3, but right now it looks to me like the
> best course of action will be to drop the patch.

I spoke too soon, the problem is more subtle than that. I forgot about the uart,
which is accessible at addresses 0x{2,3}{e,f}8. In practice, having the uart
overlap the PCI ioports region works by chance because the uart driver claims the
memory resource before the PCI driver. My first idea was to have the PCI ioport
region start at 0x6200 (that's where the PCI code starts allocating ioports), but
I get this splat with a 5.5 Linux guest:

[    0.523407] ------------[ cut here ]------------
[    0.524059] kernel BUG at lib/ioremap.c:74!
[    0.524597] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[    0.525306] Modules linked in:
[    0.525706] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.5.0 #1
[    0.526456] Hardware name: linux,dummy-virt (DT)
[    0.527047] pstate: 80000005 (Nzcv daif -PAN -UAO)
[    0.527761] pc : ioremap_page_range+0x30c/0x3a0
[    0.528351] lr : pci_remap_iospace+0xb0/0x118
[    0.528913] sp : ffff800011ccf9b0
[    0.529334] x29: ffff800011ccf9b0 x28: ffff8000113701f8
[    0.530016] x27: ffffffdfffe00000 x26: 0400000000000001
[    0.530697] x25: ffff8000118dc8d8 x24: 0000000000000041
[    0.531423] x23: ffffffdffec09000 x22: ffffffdffec09000
[    0.532135] x21: ffffffdffec09000 x20: ffff000001acff00
[    0.532848] x19: 0000000000000001 x18: 0000000000000010
[    0.533561] x17: 00000000ab887d9b x16: 00000000f86b3432
[    0.534273] x15: ffffffffffffffff x14: 303530307830203e
[    0.534978] x13: 0000000020000000 x12: 0000000000007000
[    0.535704] x11: 3030303030303035 x10: 30307830204d454d
[    0.536407] x9 : 0000000000007000 x8 : ffff0000c13da500
[    0.537097] x7 : ffffffdffec00000 x6 : ffff000001abf7f8
[    0.537786] x5 : ffff8000118dc000 x4 : ffffffdffec00000
[    0.538506] x3 : 0068000000000f07 x2 : 0140000000000000
[    0.539243] x1 : 0000002001400000 x0 : 006800017ff20f13
[    0.539977] Call trace:
[    0.540304]  ioremap_page_range+0x30c/0x3a0
[    0.540854]  pci_remap_iospace+0xb0/0x118
[    0.541376]  devm_pci_remap_iospace+0x48/0x98
[    0.541946]  pci_parse_request_of_pci_ranges+0x148/0x1c0
[    0.542650]  pci_host_common_probe+0x68/0x1d0
[    0.543180]  gen_pci_probe+0x2c/0x38
[    0.543665]  platform_drv_probe+0x50/0xa0
[    0.544186]  really_probe+0xd4/0x308
[    0.544632]  driver_probe_device+0x54/0xe8
[    0.545138]  device_driver_attach+0x6c/0x78
[    0.545654]  __driver_attach+0x54/0xd0
[    0.546115]  bus_for_each_dev+0x70/0xc0
[    0.546588]  driver_attach+0x20/0x28
[    0.547029]  bus_add_driver+0x178/0x1d8
[    0.547554]  driver_register+0x60/0x110
[    0.548032]  __platform_driver_register+0x44/0x50
[    0.548612]  gen_pci_driver_init+0x18/0x20
[    0.549137]  do_one_initcall+0x74/0x1a8
[    0.549612]  kernel_init_freeable+0x190/0x1f4
[    0.550150]  kernel_init+0x10/0x100
[    0.550581]  ret_from_fork+0x10/0x18
[    0.551023] Code: a9446bf9 a94573fb a8cb7bfd d65f03c0 (d4210000)
[    0.551839] ---[ end trace c04d8b733115ba34 ]---
[    0.552411] note: swapper/0[1] exited with preempt_count 1
[    0.553088] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    0.554029] SMP: stopping secondary CPUs
[    0.554631] Kernel Offset: disabled
[    0.555063] CPU features: 0x00002,20802008
[    0.555587] Memory Limit: none
[    0.556147] ---[ end Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b ]---

The reason for that is that the address 0x6200 is not page aligned, and it is
already mapped because it happened to overlap with a previous page allocation. I
changed it to be 4k aligned to make sure it's not already mapped, and it worked.
However, even with the address aligned to 4k, a Linux guest which uses 64k pages
still gets the above splat. The ioports region is 64k, so we cannot get away with
simply rounding it up to the nearest 64k multiple. Instead, I'm going to try
moving the entire ioports region from [0, 64k) to [64k, 128k) and making
ARM_MMIO_AREA smaller by 64k. I'll send a new patch when I respin the series.

Thanks,
Alex
>
> Thanks,
> Alex
>> Cheers,
>> Andre.
>>
>>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>  arm/include/arm-common/pci.h |  1 +
>>>  arm/kvm.c                    |  3 +++
>>>  arm/pci.c                    | 21 ++++++++++++++++++---
>>>  3 files changed, 22 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arm/include/arm-common/pci.h b/arm/include/arm-common/pci.h
>>> index 9008a0ed072e..aea42b8895e9 100644
>>> --- a/arm/include/arm-common/pci.h
>>> +++ b/arm/include/arm-common/pci.h
>>> @@ -1,6 +1,7 @@
>>>  #ifndef ARM_COMMON__PCI_H
>>>  #define ARM_COMMON__PCI_H
>>>  
>>> +void pci__arm_init(struct kvm *kvm);
>>>  void pci__generate_fdt_nodes(void *fdt);
>>>  
>>>  #endif /* ARM_COMMON__PCI_H */
>>> diff --git a/arm/kvm.c b/arm/kvm.c
>>> index 1f85fc60588f..5c30ec1e0515 100644
>>> --- a/arm/kvm.c
>>> +++ b/arm/kvm.c
>>> @@ -6,6 +6,7 @@
>>>  #include "kvm/fdt.h"
>>>  
>>>  #include "arm-common/gic.h"
>>> +#include "arm-common/pci.h"
>>>  
>>>  #include <linux/kernel.h>
>>>  #include <linux/kvm.h>
>>> @@ -86,6 +87,8 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
>>>  	/* Create the virtual GIC. */
>>>  	if (gic__create(kvm, kvm->cfg.arch.irqchip))
>>>  		die("Failed to create virtual GIC");
>>> +
>>> +	pci__arm_init(kvm);
>>>  }
>>>  
>>>  #define FDT_ALIGN	SZ_2M
>>> diff --git a/arm/pci.c b/arm/pci.c
>>> index ed325fa4a811..1c0949a22408 100644
>>> --- a/arm/pci.c
>>> +++ b/arm/pci.c
>>> @@ -1,3 +1,5 @@
>>> +#include "linux/sizes.h"
>>> +
>>>  #include "kvm/devices.h"
>>>  #include "kvm/fdt.h"
>>>  #include "kvm/kvm.h"
>>> @@ -7,6 +9,11 @@
>>>  
>>>  #include "arm-common/pci.h"
>>>  
>>> +#define ARM_PCI_IO_START ALIGN(PCI_IOPORT_START, SZ_4K)
>>> +
>>> +/* Must be a multiple of 4k */
>>> +#define ARM_PCI_IO_SIZE ((ARM_MMIO_AREA - ARM_PCI_IO_START) & ~(SZ_4K - 1))
>>> +
>>>  /*
>>>   * An entry in the interrupt-map table looks like:
>>>   * <pci unit address> <pci interrupt pin> <gic phandle> <gic interrupt>
>>> @@ -24,6 +31,14 @@ struct of_interrupt_map_entry {
>>>  	struct of_gic_irq		gic_irq;
>>>  } __attribute__((packed));
>>>  
>>> +void pci__arm_init(struct kvm *kvm)
>>> +{
>>> +	u32 align_pad = ARM_PCI_IO_START - PCI_IOPORT_START;
>>> +
>>> +	/* Make PCI port allocation start at a properly aligned address */
>>> +	pci_get_io_port_block(align_pad);
>>> +}
>>> +
>>>  void pci__generate_fdt_nodes(void *fdt)
>>>  {
>>>  	struct device_header *dev_hdr;
>>> @@ -40,10 +55,10 @@ void pci__generate_fdt_nodes(void *fdt)
>>>  			.pci_addr = {
>>>  				.hi	= cpu_to_fdt32(of_pci_b_ss(OF_PCI_SS_IO)),
>>>  				.mid	= 0,
>>> -				.lo	= 0,
>>> +				.lo	= cpu_to_fdt32(ARM_PCI_IO_START),
>>>  			},
>>> -			.cpu_addr	= cpu_to_fdt64(KVM_IOPORT_AREA),
>>> -			.length		= cpu_to_fdt64(ARM_IOPORT_SIZE),
>>> +			.cpu_addr	= cpu_to_fdt64(ARM_PCI_IO_START),
>>> +			.length		= cpu_to_fdt64(ARM_PCI_IO_SIZE),
>>>  		},
>>>  		{
>>>  			.pci_addr = {
