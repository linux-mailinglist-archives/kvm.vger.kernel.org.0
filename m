Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 543BFD3C06
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 11:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfJKJMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 05:12:52 -0400
Received: from foss.arm.com ([217.140.110.172]:54074 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbfJKJMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 05:12:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A26FD337;
        Fri, 11 Oct 2019 02:12:51 -0700 (PDT)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C3573F703;
        Fri, 11 Oct 2019 02:12:50 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/3] pci: use uint64_t for unsigned long
 values
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     jmattson@google.com
References: <20191010183506.129921-1-morbo@google.com>
 <20191010183506.129921-3-morbo@google.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <81990077-23b0-b150-1373-2bb5734d4f23@arm.com>
Date:   Fri, 11 Oct 2019 10:12:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191010183506.129921-3-morbo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 10/10/19 7:35 PM, Bill Wendling wrote:
> The "pci_bar_*" functions work with unsigned long values, but were using
> uint32_t for the data types. Clang complains about this. So we bump up
> the type to uint64_t.

Your patch might fix the warning, but the bar functions were returning 32 bits 
because the bars are 32 bits and because they are being read using functions 
that return 32 bit values.

>
>    lib/pci.c:110:3: error: implicit conversion from 'unsigned long' to 'uint32_t' (aka 'unsigned int') changes value from 18446744073709551612 to 4294967292 [-Werror,-Wconstant-conversion]
>                    PCI_BASE_ADDRESS_IO_MASK : PCI_BASE_ADDRESS_MEM_MASK;
>                  ^~~~~~~~~~~~~~~~~~~~~~~~
>    /usr/local/google/home/morbo/kvm-unit-tests/lib/linux/pci_regs.h:100:36: note: expanded from macro 'PCI_BASE_ADDRESS_IO_MASK'
>    #define  PCI_BASE_ADDRESS_IO_MASK       (~0x03UL)
>                                             ^~~~~~~
>    lib/pci.c:110:30: error: implicit conversion from 'unsigned long' to 'uint32_t' (aka 'unsigned int') changes value from 18446744073709551600 to 4294967280 [-Werror,-Wconstant-conversion]
>                    PCI_BASE_ADDRESS_IO_MASK : PCI_BASE_ADDRESS_MEM_MASK;
>                                             ^~~~~~~~~~~~~~~~~~~~~~~~~
>    /usr/local/google/home/morbo/kvm-unit-tests/lib/linux/pci_regs.h:99:37: note: expanded from macro 'PCI_BASE_ADDRESS_MEM_MASK'
>    #define  PCI_BASE_ADDRESS_MEM_MASK      (~0x0fUL)

I think the issue is that the mask should be 32 bits, but unsigned long is 64 
bits on your architecture. I think it's safe to use ~0x0fU here, because we're 
only interested in the least significant 4 bits.

Regards,
Alex
>                                           ^~~~~~~
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>   lib/pci.c | 18 +++++++++---------
>   lib/pci.h |  4 ++--
>   2 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/lib/pci.c b/lib/pci.c
> index daa33e1..e554209 100644
> --- a/lib/pci.c
> +++ b/lib/pci.c
> @@ -104,13 +104,13 @@ pcidevaddr_t pci_find_dev(uint16_t vendor_id, uint16_t device_id)
>   	return PCIDEVADDR_INVALID;
>   }
>   
> -uint32_t pci_bar_mask(uint32_t bar)
> +uint64_t pci_bar_mask(uint32_t bar)
>   {
>   	return (bar & PCI_BASE_ADDRESS_SPACE_IO) ?
>   		PCI_BASE_ADDRESS_IO_MASK : PCI_BASE_ADDRESS_MEM_MASK;
>   }
>   
> -uint32_t pci_bar_get(struct pci_dev *dev, int bar_num)
> +uint64_t pci_bar_get(struct pci_dev *dev, int bar_num)
>   {
>   	ASSERT_BAR_NUM(bar_num);
>   
> @@ -120,13 +120,13 @@ uint32_t pci_bar_get(struct pci_dev *dev, int bar_num)
>   
>   static phys_addr_t __pci_bar_get_addr(struct pci_dev *dev, int bar_num)
>   {
> -	uint32_t bar = pci_bar_get(dev, bar_num);
> -	uint32_t mask = pci_bar_mask(bar);
> +	uint64_t bar = pci_bar_get(dev, bar_num);
> +	uint64_t mask = pci_bar_mask(bar);
>   	uint64_t addr = bar & mask;
>   	phys_addr_t phys_addr;
>   
>   	if (pci_bar_is64(dev, bar_num))
> -		addr |= (uint64_t)pci_bar_get(dev, bar_num + 1) << 32;
> +		addr |= pci_bar_get(dev, bar_num + 1) << 32;
>   
>   	phys_addr = pci_translate_addr(dev->bdf, addr);
>   	assert(phys_addr != INVALID_PHYS_ADDR);
> @@ -189,7 +189,7 @@ static uint32_t pci_bar_size_helper(struct pci_dev *dev, int bar_num)
>   
>   phys_addr_t pci_bar_size(struct pci_dev *dev, int bar_num)
>   {
> -	uint32_t bar, size;
> +	uint64_t bar, size;
>   
>   	size = pci_bar_size_helper(dev, bar_num);
>   	if (!size)
> @@ -210,7 +210,7 @@ phys_addr_t pci_bar_size(struct pci_dev *dev, int bar_num)
>   
>   bool pci_bar_is_memory(struct pci_dev *dev, int bar_num)
>   {
> -	uint32_t bar = pci_bar_get(dev, bar_num);
> +	uint64_t bar = pci_bar_get(dev, bar_num);
>   
>   	return !(bar & PCI_BASE_ADDRESS_SPACE_IO);
>   }
> @@ -222,7 +222,7 @@ bool pci_bar_is_valid(struct pci_dev *dev, int bar_num)
>   
>   bool pci_bar_is64(struct pci_dev *dev, int bar_num)
>   {
> -	uint32_t bar = pci_bar_get(dev, bar_num);
> +	uint64_t bar = pci_bar_get(dev, bar_num);
>   
>   	if (bar & PCI_BASE_ADDRESS_SPACE_IO)
>   		return false;
> @@ -234,7 +234,7 @@ bool pci_bar_is64(struct pci_dev *dev, int bar_num)
>   void pci_bar_print(struct pci_dev *dev, int bar_num)
>   {
>   	phys_addr_t size, start, end;
> -	uint32_t bar;
> +	uint64_t bar;
>   
>   	if (!pci_bar_is_valid(dev, bar_num))
>   		return;
> diff --git a/lib/pci.h b/lib/pci.h
> index 689f03c..cd12938 100644
> --- a/lib/pci.h
> +++ b/lib/pci.h
> @@ -60,8 +60,8 @@ extern pcidevaddr_t pci_find_dev(uint16_t vendor_id, uint16_t device_id);
>   extern phys_addr_t pci_bar_get_addr(struct pci_dev *dev, int bar_num);
>   extern void pci_bar_set_addr(struct pci_dev *dev, int bar_num, phys_addr_t addr);
>   extern phys_addr_t pci_bar_size(struct pci_dev *dev, int bar_num);
> -extern uint32_t pci_bar_get(struct pci_dev *dev, int bar_num);
> -extern uint32_t pci_bar_mask(uint32_t bar);
> +extern uint64_t pci_bar_get(struct pci_dev *dev, int bar_num);
> +extern uint64_t pci_bar_mask(uint32_t bar);
>   extern bool pci_bar_is64(struct pci_dev *dev, int bar_num);
>   extern bool pci_bar_is_memory(struct pci_dev *dev, int bar_num);
>   extern bool pci_bar_is_valid(struct pci_dev *dev, int bar_num);
