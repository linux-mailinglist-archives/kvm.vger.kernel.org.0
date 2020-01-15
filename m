Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3213C682
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 15:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgAOOtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 09:49:11 -0500
Received: from foss.arm.com ([217.140.110.172]:38498 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgAOOtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 09:49:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4F3B31B;
        Wed, 15 Jan 2020 06:49:10 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B4433F718;
        Wed, 15 Jan 2020 06:49:09 -0800 (PST)
Subject: Re: [PATCH kvmtool 05/16] arm: pci.c: Advertise only PCI bus 0 in the
 DT
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
 <20191125103033.22694-6-alexandru.elisei@arm.com>
 <20191128174315.26208e51@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <63dbad4e-a6c8-f609-53d0-e3df018feb08@arm.com>
Date:   Wed, 15 Jan 2020 14:49:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191128174315.26208e51@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/28/19 5:43 PM, Andre Przywara wrote:
> On Mon, 25 Nov 2019 10:30:22 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
>> The "bus-range" property encodes the first and last bus number. kvmtool
>> uses bus 0 for PCI and bus 1 for MMIO. 
> Mmmh, but this DT setting is about (guest visible) PCI busses, not kvmtool busses, isn't it?

You are correct, this setting is about guest visible PCI busses, not kvmtool
buses, I got the two confused.

> So for the PCI devices we *emulate* that's probably correct, since we don't have any PCI bridge functionality among them, but wouldn't forwarding a PCI device with a bridge require more than one bus? And the guest OS' enumeration code would try to create a new bus, but fails, because there is only one?
>
> So I agree that the [0, 1] looks somewhat arbitrary, but shouldn't we set it to [0, 255] instead, to not limit things?
> I think this setting should correspond to the PCIe config space size we provide, which should be: 4096 bytes * 8 fns * 32 devs * nr_busses (for PCIe).

kvmtool emulates a single bus, bus 0. Whenever the PCI code searches for a device,
it searches using the device number, not a tuple (bus_number, device_number) (take
a look at pci__config_{rd,wr}). Also, in pci_device_exists, it compares the bus
number and function number against 0, the default values from
pci_config_address_bits. On the other hand, kvmtool doesn't emulate any bridges,
so after probing bus 0, Linux won't try to probe any other buses. So regardless of
the bus-range property, Linux will only probe bus 0.

From a correctness point of view, I think <0,0> is the right value here as it
matches what kvmtool emulates. What do you think?

Thanks,
Alex
>
> At least that's my understanding of these things, please correct me if I am wrong.
>
> Cheers,
> Andre.
>
>> Advertise only the PCI bus in
>> the PCI DT node by setting "bus-range" to <0, 0>.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/pci.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arm/pci.c b/arm/pci.c
>> index 557cfa98938d..ed325fa4a811 100644
>> --- a/arm/pci.c
>> +++ b/arm/pci.c
>> @@ -30,7 +30,7 @@ void pci__generate_fdt_nodes(void *fdt)
>>  	struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
>>  	unsigned nentries = 0;
>>  	/* Bus range */
>> -	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(1), };
>> +	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(0), };
>>  	/* Configuration Space */
>>  	u64 cfg_reg_prop[] = { cpu_to_fdt64(KVM_PCI_CFG_AREA),
>>  			       cpu_to_fdt64(ARM_PCI_CFG_SIZE), };
