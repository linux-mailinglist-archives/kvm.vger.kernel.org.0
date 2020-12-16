Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81922DC064
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 13:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbgLPMhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 07:37:12 -0500
Received: from foss.arm.com ([217.140.110.172]:50510 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPMhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 07:37:12 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48FDB1FB;
        Wed, 16 Dec 2020 04:36:26 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD8383F66E;
        Wed, 16 Dec 2020 04:36:25 -0800 (PST)
Subject: Re: [PATCH kvmtool] pci: Deactivate BARs before reactivating
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sergey Temerkhanov <s.temerkhanov@gmail.com>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20201215143512.559367-1-s.temerkhanov@gmail.com>
 <ac8de7f6-392c-509b-26a5-f34f8cbe1173@arm.com>
Message-ID: <8c1102d0-1908-5f2d-71f3-9a635fc82cfa@arm.com>
Date:   Wed, 16 Dec 2020 12:36:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <ac8de7f6-392c-509b-26a5-f34f8cbe1173@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sergey,

On 12/16/20 12:24 PM, Alexandru Elisei wrote:
> Hi Sergey,
>
> On 12/15/20 2:35 PM, Sergey Temerkhanov wrote:
>> Deactivate BARs before reactivating them to avoid breakage.
>> Some firmware components do not check whether the COMMAND
>> register contains any values before writing BARs which leads
>> to kvmtool errors during subsequent BAR deactivation
>>
>> Signed-off-by: Sergey Temerkhanov <s.temerkhanov@gmail.com>
>> ---
>>  pci.c | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/pci.c b/pci.c
>> index 2e2c027..515d9dc 100644
>> --- a/pci.c
>> +++ b/pci.c
>> @@ -320,10 +320,6 @@ static void pci_config_bar_wr(struct kvm *kvm,
>>  	 */
>>  	if (value == 0xffffffff) {
>>  		value = ~(pci__bar_size(pci_hdr, bar_num) - 1);
>> -		/* Preserve the special bits. */
>> -		value = (value & mask) | (pci_hdr->bar[bar_num] & ~mask);
>> -		pci_hdr->bar[bar_num] = value;
>> -		return;
> I think the PCI spec is clear what should happen when software writes all 1's to
> the BAR (PCI LOCAL BUS SPECIFICATION, REV. 3.0, page 226):
>
> "Power-up software can determine how much address space the device requires by
> writing a value of all 1's to the register and then reading the value back. The
> device will return 0's in all don't-care address bits, effectively specifying the
> address space required."
>
> Your patch breaks this mechanism for sizing a BAR.

Sorry, it doesn't break it, you can still read the size from the bar afterwards.
What your patch does is enable emulation for the memory region starting at
~(bar_size - 1), which is definitely not expected. What if we were on real
hardware and ~(bar_size - 1) falls outside the controller's address range? What if
for kvmtool it overlaps with an existing MMIO region?

Here's what should happen according the the PCI spec:

"Software saves the original value of the Base Address register, writes 0 FFFF
FFFFh to the register, then reads it back. Size calculation can be done from the
32-bit value read by first clearing encoding information bits (bit 0 for I/O, bits
0-3 for memory), inverting all 32 bits (logical NOT), then incrementing by 1. The
resultant 32-bit value is the memory/I/O range size decoded by the register. Note
that the upper 16 bits of the result is ignored if the Base Address register is
for I/O and bits 16-31 returned zero upon read. The original value in the Base
Address register is restored before re-enabling decode in the command register of
the device."

If you're getting errors when access is disabled, I suspect it's because the
firmware doesn't restore the previous BAR value.

Thanks,
Alex
>
> It also looks to me like the firmware is doing something very strange: it writes
> all 1's to a BAR, which with your patch enables emulation for the memory region
> [~(bar_size-1), ~(bar_size-1)+bar_size]. How does the firmware know the value of
> bar_size? It reads it back and confuses it with the address instead of the region
> size?
>
> Would you mind posting more details about the error you are seeing? Maybe we can
> find a different solution.
>
> Thanks,
>
> Alex
>
