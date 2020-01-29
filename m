Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3B714D039
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 19:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgA2SQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 13:16:29 -0500
Received: from foss.arm.com ([217.140.110.172]:44496 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgA2SQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 13:16:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA24E328;
        Wed, 29 Jan 2020 10:16:28 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8572A3F67D;
        Wed, 29 Jan 2020 10:16:27 -0800 (PST)
Date:   Wed, 29 Jan 2020 18:16:24 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org,
        Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v2 kvmtool 09/30] arm/pci: Fix PCI IO region
Message-ID: <20200129181624.5f723196@donnerap.cambridge.arm.com>
In-Reply-To: <20200123134805.1993-10-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-10-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:47:44 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> From: Julien Thierry <julien.thierry@arm.com>
> 
> Current PCI IO region that is exposed through the DT contains ports that
> are reserved by non-PCI devices.
> 
> Use the proper PCI IO start so that the region exposed through DT can
> actually be used to reassign device BARs.

I guess the majority of the patch is about that the current allocation starts at 0x6200, which is not 4K aligned?
It would be nice if we could mention this in the commit message.

Actually, silly question: It seems like this 0x6200 is rather arbitrary, can't we just change that to a 4K aligned value and drop that patch here?
If something on the x86 side relies on that value, it should rather be explicit than by chance.
(Because while this patch here seems correct, it's also quite convoluted.)

Cheers,
Andre.

> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/include/arm-common/pci.h |  1 +
>  arm/kvm.c                    |  3 +++
>  arm/pci.c                    | 21 ++++++++++++++++++---
>  3 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/include/arm-common/pci.h b/arm/include/arm-common/pci.h
> index 9008a0ed072e..aea42b8895e9 100644
> --- a/arm/include/arm-common/pci.h
> +++ b/arm/include/arm-common/pci.h
> @@ -1,6 +1,7 @@
>  #ifndef ARM_COMMON__PCI_H
>  #define ARM_COMMON__PCI_H
>  
> +void pci__arm_init(struct kvm *kvm);
>  void pci__generate_fdt_nodes(void *fdt);
>  
>  #endif /* ARM_COMMON__PCI_H */
> diff --git a/arm/kvm.c b/arm/kvm.c
> index 1f85fc60588f..5c30ec1e0515 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -6,6 +6,7 @@
>  #include "kvm/fdt.h"
>  
>  #include "arm-common/gic.h"
> +#include "arm-common/pci.h"
>  
>  #include <linux/kernel.h>
>  #include <linux/kvm.h>
> @@ -86,6 +87,8 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
>  	/* Create the virtual GIC. */
>  	if (gic__create(kvm, kvm->cfg.arch.irqchip))
>  		die("Failed to create virtual GIC");
> +
> +	pci__arm_init(kvm);
>  }
>  
>  #define FDT_ALIGN	SZ_2M
> diff --git a/arm/pci.c b/arm/pci.c
> index ed325fa4a811..1c0949a22408 100644
> --- a/arm/pci.c
> +++ b/arm/pci.c
> @@ -1,3 +1,5 @@
> +#include "linux/sizes.h"
> +
>  #include "kvm/devices.h"
>  #include "kvm/fdt.h"
>  #include "kvm/kvm.h"
> @@ -7,6 +9,11 @@
>  
>  #include "arm-common/pci.h"
>  
> +#define ARM_PCI_IO_START ALIGN(PCI_IOPORT_START, SZ_4K)
> +
> +/* Must be a multiple of 4k */
> +#define ARM_PCI_IO_SIZE ((ARM_MMIO_AREA - ARM_PCI_IO_START) & ~(SZ_4K - 1))
> +
>  /*
>   * An entry in the interrupt-map table looks like:
>   * <pci unit address> <pci interrupt pin> <gic phandle> <gic interrupt>
> @@ -24,6 +31,14 @@ struct of_interrupt_map_entry {
>  	struct of_gic_irq		gic_irq;
>  } __attribute__((packed));
>  
> +void pci__arm_init(struct kvm *kvm)
> +{
> +	u32 align_pad = ARM_PCI_IO_START - PCI_IOPORT_START;
> +
> +	/* Make PCI port allocation start at a properly aligned address */
> +	pci_get_io_port_block(align_pad);
> +}
> +
>  void pci__generate_fdt_nodes(void *fdt)
>  {
>  	struct device_header *dev_hdr;
> @@ -40,10 +55,10 @@ void pci__generate_fdt_nodes(void *fdt)
>  			.pci_addr = {
>  				.hi	= cpu_to_fdt32(of_pci_b_ss(OF_PCI_SS_IO)),
>  				.mid	= 0,
> -				.lo	= 0,
> +				.lo	= cpu_to_fdt32(ARM_PCI_IO_START),
>  			},
> -			.cpu_addr	= cpu_to_fdt64(KVM_IOPORT_AREA),
> -			.length		= cpu_to_fdt64(ARM_IOPORT_SIZE),
> +			.cpu_addr	= cpu_to_fdt64(ARM_PCI_IO_START),
> +			.length		= cpu_to_fdt64(ARM_PCI_IO_SIZE),
>  		},
>  		{
>  			.pci_addr = {

