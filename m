Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACCC10B5A0
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfK0SYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:24:24 -0500
Received: from foss.arm.com ([217.140.110.172]:51460 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbfK0SYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 13:24:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3398631B;
        Wed, 27 Nov 2019 10:24:23 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4ED013F6C4;
        Wed, 27 Nov 2019 10:24:22 -0800 (PST)
Date:   Wed, 27 Nov 2019 18:24:19 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: Re: [PATCH kvmtool 02/16] pci: Fix BAR resource sizing arbitration
Message-ID: <20191127182419.4b91b887@donnerap.cambridge.arm.com>
In-Reply-To: <20191125103033.22694-3-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
        <20191125103033.22694-3-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Nov 2019 10:30:19 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> From: Sami Mujawar <sami.mujawar@arm.com>
> 
> According to the 'PCI Local Bus Specification, Revision 3.0,
> February 3, 2004, Section 6.2.5.1, Implementation Notes, page 227'
> 
>     "Software saves the original value of the Base Address register,
>     writes 0 FFFF FFFFh to the register, then reads it back. Size
>     calculation can be done from the 32-bit value read by first
>     clearing encoding information bits (bit 0 for I/O, bits 0-3 for
>     memory), inverting all 32 bits (logical NOT), then incrementing
>     by 1. The resultant 32-bit value is the memory/I/O range size
>     decoded by the register. Note that the upper 16 bits of the result
>     is ignored if the Base Address register is for I/O and bits 16-31
>     returned zero upon read."
> 
> kvmtool was returning the actual BAR resource size which would be
> incorrect as the software software drivers would invert all 32 bits
> (logical NOT), then incrementing by 1. This ends up with a very large
> resource size (in some cases more than 4GB) due to which drivers
> assert/fail to work.
> 
> e.g if the BAR resource size was 0x1000, kvmtool would return 0x1000
> instead of 0xFFFFF00x.
> 
> Fixed pci__config_wr() to return the size of the BAR in accordance with
> the PCI Local Bus specification, Implementation Notes.
> 
> Cc: julien.thierry.kdev@gmail.com
> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> [Reworked algorithm, removed power-of-two check]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  pci.c | 42 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/pci.c b/pci.c
> index 689869cb79a3..e1b57325bdeb 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -149,6 +149,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>  	u8 bar, offset;
>  	struct pci_device_header *pci_hdr;
>  	u8 dev_num = addr.device_number;
> +	u32 value = 0;
>  
>  	if (!pci_device_exists(addr.bus_number, dev_num, 0))
>  		return;
> @@ -169,13 +170,42 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>  	bar = (offset - PCI_BAR_OFFSET(0)) / sizeof(u32);
>  
>  	/*
> -	 * If the kernel masks the BAR it would expect to find the size of the
> -	 * BAR there next time it reads from it. When the kernel got the size it
> -	 * would write the address back.
> +	 * If the kernel masks the BAR, it will expect to find the size of the
> +	 * BAR there next time it reads from it. After the kernel reads the
> +	 * size, it will write the address back.
>  	 */
> -	if (bar < 6 && ioport__read32(data) == 0xFFFFFFFF) {
> -		u32 sz = pci_hdr->bar_size[bar];
> -		memcpy(base + offset, &sz, sizeof(sz));
> +	if (bar < 6) {
> +		memcpy(&value, data, size);
> +		if (value == 0xffffffff)
> +			/*
> +			 * According to the PCI local bus specification REV 3.0:

So this whole comment breaks 80 columns. Can we just move it one level up/left, putting it before the if statement? This also fixes the confusing indentation below.

> +			 * The number of upper bits that a device actually implements
> +			 * depends on how much of the address space the device will
> +			 * respond to. A device that wants a 1 MB memory address space
> +			 * (using a 32-bit base address register) would build the top
> +			 * 12 bits of the address register, hardwiring the other bits
> +			 * to 0.
> +			 *
> +			 * Furthermore, software can determine how much address space
> +			 * the device requires by writing a value of all 1's to the
> +			 * register and then reading the value back. The device will
> +			 * return 0's in all don't-care address bits, effectively
> +			 * specifying the address space required.
> +			 *
> +			 * Software computes the size of the address space with the
> +			 * formula S = ~B + 1, where S is the memory size and B is the
> +			 * value read from the BAR. This means that the BAR value that
> +			 * kvmtool should return is B = ~(S - 1).
> +			 */
> +			value = ~(pci_hdr->bar_size[bar] - 1);
> +		if (pci_hdr->bar[bar] & 0x1)

Should this be PCI_BASE_ADDRESS_SPACE_IO, for clarity?

> +			value = (value & PCI_BASE_ADDRESS_IO_MASK) | \

backslash not needed

> +				PCI_BASE_ADDRESS_SPACE_IO;
> +		else
> +			/* Memory Space BAR, preserve the first 4 bits. */
> +			value = (value & PCI_BASE_ADDRESS_MEM_MASK) | \

same here.

> +				(pci_hdr->bar[bar] & ~PCI_BASE_ADDRESS_MEM_MASK);
> +		memcpy(base + offset, &value, size);
>  	} else {
>  		memcpy(base + offset, data, size);
>  	}

Cheers,
Andre.
