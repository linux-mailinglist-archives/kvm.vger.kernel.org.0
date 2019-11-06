Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94E0BF1BA1
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 17:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732212AbfKFQto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 11:49:44 -0500
Received: from foss.arm.com ([217.140.110.172]:43080 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729085AbfKFQto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 11:49:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E03C846A;
        Wed,  6 Nov 2019 08:49:43 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD3873F719;
        Wed,  6 Nov 2019 08:49:42 -0800 (PST)
Date:   Wed, 6 Nov 2019 16:49:40 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        Julien Grall <julien.grall.oss@gmail.com>
Subject: Re: [PATCH kvmtool 07/16] arm: Remove redundant define
 ARM_PCI_CFG_SIZE
Message-ID: <20191106164940.7d60104b@donnerap.cambridge.arm.com>
In-Reply-To: <1569245722-23375-8-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
        <1569245722-23375-8-git-send-email-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Sep 2019 14:35:13 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> ARM_PCI_CFG_SIZE has the same value as PCI_CFG_SIZE. The pci driver uses
> PCI_CFG_SIZE and arm uses ARM_PCI_CFG_SIZE when generating the pci DT node.
> Having two defines with the same value is confusing, and can lead to bugs
> if one define is changed and the other isn't. So replace all instances of
> ARM_PCI_CFG_SIZE with PCI_CFG_SIZE.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  arm/include/arm-common/kvm-arch.h | 7 ++++---
>  arm/pci.c                         | 2 +-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> index 965978d7cfb5..f8f6b8f98c96 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/arm-common/kvm-arch.h
> @@ -5,6 +5,8 @@
>  #include <linux/const.h>
>  #include <linux/types.h>
>  
> +#include "kvm/pci.h"
> +
>  #include "arm-common/gic.h"
>  
>  #define ARM_IOPORT_AREA		_AC(0x0000000000000000, UL)
> @@ -23,13 +25,12 @@
>  
>  #define ARM_IOPORT_SIZE		(ARM_MMIO_AREA - ARM_IOPORT_AREA)
>  #define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - (ARM_MMIO_AREA + ARM_GIC_SIZE))
> -#define ARM_PCI_CFG_SIZE	(1ULL << 24)
>  #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
> -				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
> +				(ARM_AXI_AREA + PCI_CFG_SIZE))
>  
>  #define KVM_IOPORT_AREA		ARM_IOPORT_AREA
>  #define KVM_PCI_CFG_AREA	ARM_AXI_AREA
> -#define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
> +#define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + PCI_CFG_SIZE)
>  #define KVM_VIRTIO_MMIO_AREA	ARM_MMIO_AREA
>  
>  #define KVM_IOEVENTFD_HAS_PIO	0
> diff --git a/arm/pci.c b/arm/pci.c
> index 557cfa98938d..1a2fc2688c9e 100644
> --- a/arm/pci.c
> +++ b/arm/pci.c
> @@ -33,7 +33,7 @@ void pci__generate_fdt_nodes(void *fdt)
>  	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(1), };
>  	/* Configuration Space */
>  	u64 cfg_reg_prop[] = { cpu_to_fdt64(KVM_PCI_CFG_AREA),
> -			       cpu_to_fdt64(ARM_PCI_CFG_SIZE), };
> +			       cpu_to_fdt64(PCI_CFG_SIZE), };
>  	/* Describe the memory ranges */
>  	struct of_pci_ranges_entry ranges[] = {
>  		{

