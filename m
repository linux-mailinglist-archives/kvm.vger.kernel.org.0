Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5361535D1
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 18:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgBERCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 12:02:08 -0500
Received: from foss.arm.com ([217.140.110.172]:49742 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgBERCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 12:02:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58E221FB;
        Wed,  5 Feb 2020 09:02:07 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 633D63F52E;
        Wed,  5 Feb 2020 09:02:06 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 20/30] pci: Add helpers for BAR values and
 memory/IO space access
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-21-alexandru.elisei@arm.com>
 <20200205170056.3bfdf054@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d6744de5-8832-dac5-9e6e-f1fc5006edc0@arm.com>
Date:   Wed, 5 Feb 2020 17:02:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200205170056.3bfdf054@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/5/20 5:00 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:47:55 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> We're going to be checking the BAR type, the address written to it and
>> if access to memory or I/O space is enabled quite often when we add
>> support for reasignable BARs, add helpers for it.
> I am not a particular fan of these double underscores inside identifiers, but I guess that is too late now, since it's already all over the place. So:

Me neither, I was going for consistency.

Thanks,
Alex
>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
>
> Cheers,
> Andre.
>
>> ---
>>  include/kvm/pci.h | 48 +++++++++++++++++++++++++++++++++++++++++++++++
>>  pci.c             |  2 +-
>>  2 files changed, 49 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
>> index ccb155e3e8fe..235cd82fff3c 100644
>> --- a/include/kvm/pci.h
>> +++ b/include/kvm/pci.h
>> @@ -5,6 +5,7 @@
>>  #include <linux/kvm.h>
>>  #include <linux/pci_regs.h>
>>  #include <endian.h>
>> +#include <stdbool.h>
>>  
>>  #include "kvm/devices.h"
>>  #include "kvm/msi.h"
>> @@ -161,4 +162,51 @@ void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data,
>>  
>>  void *pci_find_cap(struct pci_device_header *hdr, u8 cap_type);
>>  
>> +static inline bool __pci__memory_space_enabled(u16 command)
>> +{
>> +	return command & PCI_COMMAND_MEMORY;
>> +}
>> +
>> +static inline bool pci__memory_space_enabled(struct pci_device_header *pci_hdr)
>> +{
>> +	return __pci__memory_space_enabled(pci_hdr->command);
>> +}
>> +
>> +static inline bool __pci__io_space_enabled(u16 command)
>> +{
>> +	return command & PCI_COMMAND_IO;
>> +}
>> +
>> +static inline bool pci__io_space_enabled(struct pci_device_header *pci_hdr)
>> +{
>> +	return __pci__io_space_enabled(pci_hdr->command);
>> +}
>> +
>> +static inline bool __pci__bar_is_io(u32 bar)
>> +{
>> +	return bar & PCI_BASE_ADDRESS_SPACE_IO;
>> +}
>> +
>> +static inline bool pci__bar_is_io(struct pci_device_header *pci_hdr, int bar_num)
>> +{
>> +	return __pci__bar_is_io(pci_hdr->bar[bar_num]);
>> +}
>> +
>> +static inline bool pci__bar_is_memory(struct pci_device_header *pci_hdr, int bar_num)
>> +{
>> +	return !pci__bar_is_io(pci_hdr, bar_num);
>> +}
>> +
>> +static inline u32 __pci__bar_address(u32 bar)
>> +{
>> +	if (__pci__bar_is_io(bar))
>> +		return bar & PCI_BASE_ADDRESS_IO_MASK;
>> +	return bar & PCI_BASE_ADDRESS_MEM_MASK;
>> +}
>> +
>> +static inline u32 pci__bar_address(struct pci_device_header *pci_hdr, int bar_num)
>> +{
>> +	return __pci__bar_address(pci_hdr->bar[bar_num]);
>> +}
>> +
>>  #endif /* KVM__PCI_H */
>> diff --git a/pci.c b/pci.c
>> index b6892d974c08..4f7b863298f6 100644
>> --- a/pci.c
>> +++ b/pci.c
>> @@ -185,7 +185,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>>  	 * size, it will write the address back.
>>  	 */
>>  	if (bar < 6) {
>> -		if (pci_hdr->bar[bar] & PCI_BASE_ADDRESS_SPACE_IO)
>> +		if (pci__bar_is_io(pci_hdr, bar))
>>  			mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
>>  		else
>>  			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
