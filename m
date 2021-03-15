Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F4333B2BC
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 13:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhCOM15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 08:27:57 -0400
Received: from foss.arm.com ([217.140.110.172]:37192 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCOM1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 08:27:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3897D6E;
        Mon, 15 Mar 2021 05:27:24 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A81343F792;
        Mon, 15 Mar 2021 05:27:23 -0700 (PDT)
Date:   Mon, 15 Mar 2021 12:27:02 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: Re: [PATCH kvmtool v2 20/22] arm: Reorganise and document memory
 map
Message-ID: <20210315122702.5f5c629f@slackpad.fritz.box>
In-Reply-To: <deb3e029-e634-c28c-2a9a-e461041bb249@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
        <20210225005915.26423-21-andre.przywara@arm.com>
        <deb3e029-e634-c28c-2a9a-e461041bb249@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Mar 2021 15:46:29 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> Hi Andre,
> 
> This is a really good idea, thank you for implementing it!
> 
> Some comments below.
> 
> On 2/25/21 12:59 AM, Andre Przywara wrote:
> > The hardcoded memory map we expose to a guest is currently described
> > using a series of partially interconnected preprocessor constants,
> > which is hard to read and follow.
> >
> > In preparation for moving the UART and RTC to some different MMIO
> > region, document the current map with some ASCII art, and clean up the
> > definition of the sections.
> >
> > No functional change.
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arm/include/arm-common/kvm-arch.h | 41 ++++++++++++++++++++++---------
> >  1 file changed, 29 insertions(+), 12 deletions(-)
> >
> > diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> > index d84e50cd..b12255b0 100644
> > --- a/arm/include/arm-common/kvm-arch.h
> > +++ b/arm/include/arm-common/kvm-arch.h
> > @@ -7,14 +7,33 @@
> >  
> >  #include "arm-common/gic.h"
> >  
> > +/*
> > + * The memory map used for ARM guests (not to scale):
> > + *
> > + * 0      64K  16M     32M     48M            1GB       2GB
> > + * +-------+-..-+-------+-------+--....--+-----+--.....--+---......
> > + * | (PCI) |////| int.  |       |        |     |         |
> > + * |  I/O  |////| MMIO: | Flash | virtio | GIC |   PCI   |  DRAM
> > + * | ports |////| UART, |       |  MMIO  |     |  (AXI)  |
> > + * |       |////| RTC   |       |        |     |         |
> > + * +-------+-..-+-------+-------+--....--+-----+--.....--+---......
> > + */  
> 
> Nitpick: I searched the PCI Local Bus Specification revision 3.0 (which kvmtool
> currently implements) for the term I/O ports, and found one mention in a schematic
> for an add-in card. The I/O region is called in the spec I/O Space.

Right, will change that.
 
> I don't know what "int." means in the region for the UART and RTC.

It was meant to mean "internal", but this is really nonsensical, so I
will replace it with "plat MMIO".
 
> The comment says that the art is not to scale, so I don't think there's any need
> for the "..." between the corners of the regions. To my eyes, it makes the ASCII
> art look crooked.

fixed.
 
> The next patches add the UART and RTC outside the first 64K, I think the region
> should be documented in the patches where the changes are made, not here. Another
> alternative would be to move this patch to the end of the series instead of
> incrementally changing the memory ASCII art (which I imagine is time consuming).

You passed the scrutiny test ;-)
I noticed this last minute, but didn't feel like changing it then.
Have done it now.

> 
> Otherwise, the numbers look OK.
> 
> > +
> >  #define ARM_IOPORT_AREA		_AC(0x0000000000000000, UL)
> > -#define ARM_FLASH_AREA		_AC(0x0000000002000000, UL)
> > -#define ARM_MMIO_AREA		_AC(0x0000000003000000, UL)
> > +#define ARM_MMIO_AREA		_AC(0x0000000001000000, UL)  
> 
> The patch says it is *documenting* the memory layout, but here it is *changing*
> the layout. Other than that, I like the shuffling of definitions so the kvmtool
> global defines are closer to the arch values.

I amended the commit message to mention that I change the value of
ARM_MMIO_AREA, but that stays internal to that file and doesn't affect
the other definitions.
In fact I imported this header into a C file and printed all
externally used names, before and after: it didn't show any changes.

Cheers,
Andre

> >  #define ARM_AXI_AREA		_AC(0x0000000040000000, UL)
> >  #define ARM_MEMORY_AREA		_AC(0x0000000080000000, UL)
> >  
> > -#define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
> > -#define ARM_HIMAP_MAX_MEMORY	((1ULL << 40) - ARM_MEMORY_AREA)
> > +#define KVM_IOPORT_AREA		ARM_IOPORT_AREA
> > +#define ARM_IOPORT_SIZE		(1U << 16)
> > +
> > +
> > +#define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
> > +#define KVM_FLASH_MAX_SIZE	0x1000000
> > +
> > +#define KVM_VIRTIO_MMIO_AREA	(KVM_FLASH_MMIO_BASE + KVM_FLASH_MAX_SIZE)
> > +#define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - \
> > +				(KVM_VIRTIO_MMIO_AREA + ARM_GIC_SIZE))
> >  
> >  #define ARM_GIC_DIST_BASE	(ARM_AXI_AREA - ARM_GIC_DIST_SIZE)
> >  #define ARM_GIC_CPUI_BASE	(ARM_GIC_DIST_BASE - ARM_GIC_CPUI_SIZE)
> > @@ -22,19 +41,17 @@
> >  #define ARM_GIC_DIST_SIZE	0x10000
> >  #define ARM_GIC_CPUI_SIZE	0x20000
> >  
> > -#define KVM_FLASH_MMIO_BASE	ARM_FLASH_AREA
> > -#define KVM_FLASH_MAX_SIZE	(ARM_MMIO_AREA - ARM_FLASH_AREA)
> >  
> > -#define ARM_IOPORT_SIZE		(1U << 16)
> > -#define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - (ARM_MMIO_AREA + ARM_GIC_SIZE))
> > +#define KVM_PCI_CFG_AREA	ARM_AXI_AREA
> >  #define ARM_PCI_CFG_SIZE	(1ULL << 24)
> > +#define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
> >  #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
> >  				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
> >  
> > -#define KVM_IOPORT_AREA		ARM_IOPORT_AREA
> > -#define KVM_PCI_CFG_AREA	ARM_AXI_AREA
> > -#define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
> > -#define KVM_VIRTIO_MMIO_AREA	ARM_MMIO_AREA
> > +
> > +#define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
> > +#define ARM_HIMAP_MAX_MEMORY	((1ULL << 40) - ARM_MEMORY_AREA)
> > +
> >  
> >  #define KVM_IOEVENTFD_HAS_PIO	0
> >    

