Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E011794E8
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 17:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388061AbgCDQVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 11:21:02 -0500
Received: from foss.arm.com ([217.140.110.172]:36462 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbgCDQVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 11:21:02 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AF7931B;
        Wed,  4 Mar 2020 08:21:01 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 817F23F6CF;
        Wed,  4 Mar 2020 08:21:00 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 09/30] arm/pci: Fix PCI IO region
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org,
        Julien Thierry <julien.thierry@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-10-alexandru.elisei@arm.com>
 <20200129181624.5f723196@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <604f481f-217c-c75b-cfaa-1e7bc0ba3b04@arm.com>
Date:   Wed, 4 Mar 2020 16:20:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200129181624.5f723196@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/29/20 6:16 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:47:44 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> From: Julien Thierry <julien.thierry@arm.com>
>>
>> Current PCI IO region that is exposed through the DT contains ports that
>> are reserved by non-PCI devices.
>>
>> Use the proper PCI IO start so that the region exposed through DT can
>> actually be used to reassign device BARs.
> I guess the majority of the patch is about that the current allocation starts at 0x6200, which is not 4K aligned?
> It would be nice if we could mention this in the commit message.
>
> Actually, silly question: It seems like this 0x6200 is rather arbitrary, can't we just change that to a 4K aligned value and drop that patch here?
> If something on the x86 side relies on that value, it should rather be explicit than by chance.
> (Because while this patch here seems correct, it's also quite convoluted.)

I've taken a closer look at this patch, and to be honest right now it seems at
best redundant. I don't really understand why the start of the PCI ioport region
must be aligned to 4K - a Linux guest has no problem assigning address 0x1100 for
ioports without this patch, but with the rest of the series applied. On the
kvmtool side, arm doesn't have any fixed I/O device addresses like x86 does, so
it's safe to use to use the entire region starting at 0 for ioport allocation.
Even without any of the patches from this series, I haven't encountered any
instances of Linux complaining.

I'll test this some more before posting v3, but right now it looks to me like the
best course of action will be to drop the patch.

Thanks,
Alex
>
> Cheers,
> Andre.
>
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/include/arm-common/pci.h |  1 +
>>  arm/kvm.c                    |  3 +++
>>  arm/pci.c                    | 21 ++++++++++++++++++---
>>  3 files changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/arm/include/arm-common/pci.h b/arm/include/arm-common/pci.h
>> index 9008a0ed072e..aea42b8895e9 100644
>> --- a/arm/include/arm-common/pci.h
>> +++ b/arm/include/arm-common/pci.h
>> @@ -1,6 +1,7 @@
>>  #ifndef ARM_COMMON__PCI_H
>>  #define ARM_COMMON__PCI_H
>>  
>> +void pci__arm_init(struct kvm *kvm);
>>  void pci__generate_fdt_nodes(void *fdt);
>>  
>>  #endif /* ARM_COMMON__PCI_H */
>> diff --git a/arm/kvm.c b/arm/kvm.c
>> index 1f85fc60588f..5c30ec1e0515 100644
>> --- a/arm/kvm.c
>> +++ b/arm/kvm.c
>> @@ -6,6 +6,7 @@
>>  #include "kvm/fdt.h"
>>  
>>  #include "arm-common/gic.h"
>> +#include "arm-common/pci.h"
>>  
>>  #include <linux/kernel.h>
>>  #include <linux/kvm.h>
>> @@ -86,6 +87,8 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
>>  	/* Create the virtual GIC. */
>>  	if (gic__create(kvm, kvm->cfg.arch.irqchip))
>>  		die("Failed to create virtual GIC");
>> +
>> +	pci__arm_init(kvm);
>>  }
>>  
>>  #define FDT_ALIGN	SZ_2M
>> diff --git a/arm/pci.c b/arm/pci.c
>> index ed325fa4a811..1c0949a22408 100644
>> --- a/arm/pci.c
>> +++ b/arm/pci.c
>> @@ -1,3 +1,5 @@
>> +#include "linux/sizes.h"
>> +
>>  #include "kvm/devices.h"
>>  #include "kvm/fdt.h"
>>  #include "kvm/kvm.h"
>> @@ -7,6 +9,11 @@
>>  
>>  #include "arm-common/pci.h"
>>  
>> +#define ARM_PCI_IO_START ALIGN(PCI_IOPORT_START, SZ_4K)
>> +
>> +/* Must be a multiple of 4k */
>> +#define ARM_PCI_IO_SIZE ((ARM_MMIO_AREA - ARM_PCI_IO_START) & ~(SZ_4K - 1))
>> +
>>  /*
>>   * An entry in the interrupt-map table looks like:
>>   * <pci unit address> <pci interrupt pin> <gic phandle> <gic interrupt>
>> @@ -24,6 +31,14 @@ struct of_interrupt_map_entry {
>>  	struct of_gic_irq		gic_irq;
>>  } __attribute__((packed));
>>  
>> +void pci__arm_init(struct kvm *kvm)
>> +{
>> +	u32 align_pad = ARM_PCI_IO_START - PCI_IOPORT_START;
>> +
>> +	/* Make PCI port allocation start at a properly aligned address */
>> +	pci_get_io_port_block(align_pad);
>> +}
>> +
>>  void pci__generate_fdt_nodes(void *fdt)
>>  {
>>  	struct device_header *dev_hdr;
>> @@ -40,10 +55,10 @@ void pci__generate_fdt_nodes(void *fdt)
>>  			.pci_addr = {
>>  				.hi	= cpu_to_fdt32(of_pci_b_ss(OF_PCI_SS_IO)),
>>  				.mid	= 0,
>> -				.lo	= 0,
>> +				.lo	= cpu_to_fdt32(ARM_PCI_IO_START),
>>  			},
>> -			.cpu_addr	= cpu_to_fdt64(KVM_IOPORT_AREA),
>> -			.length		= cpu_to_fdt64(ARM_IOPORT_SIZE),
>> +			.cpu_addr	= cpu_to_fdt64(ARM_PCI_IO_START),
>> +			.length		= cpu_to_fdt64(ARM_PCI_IO_SIZE),
>>  		},
>>  		{
>>  			.pci_addr = {
