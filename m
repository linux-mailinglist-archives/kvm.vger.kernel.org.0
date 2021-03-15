Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2FC33B2BB
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 13:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhCOM16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 08:27:58 -0400
Received: from foss.arm.com ([217.140.110.172]:37236 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhCOM1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 08:27:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2B84D6E;
        Mon, 15 Mar 2021 05:27:48 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C727F3F792;
        Mon, 15 Mar 2021 05:27:47 -0700 (PDT)
Date:   Mon, 15 Mar 2021 12:27:34 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: Re: [PATCH kvmtool v2 21/22] hw/serial: ARM/arm64: Use MMIO at
 higher addresses
Message-ID: <20210315122734.6ae4063b@slackpad.fritz.box>
In-Reply-To: <cac73e1d-7240-695e-5769-78f191429621@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
        <20210225005915.26423-22-andre.przywara@arm.com>
        <cac73e1d-7240-695e-5769-78f191429621@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Mar 2021 16:02:20 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Hi Andre,
> 
> I think you forgot to change the way the address is generated in
> serial8250_generate_fdt_node, it's still KVM_IOPORT_AREA + dev->iobase. It's
> technically correct, as KVM_IOPORT_AREA == ARM_IOPORT_AREA == 0x0, but very
> confusing (and prone to breakage is something changes in the memory layout).

So I moved the addition of KVM_IOPORT_AREA into the definition of
serial_iobase() (at the beginning of the file). This means I can remove
it below, and just use dev->iobase as is.

> One more comment below.
> 
> On 2/25/21 12:59 AM, Andre Przywara wrote:
> > Using the UART devices at their legacy I/O addresses as set by IBM in
> > 1981 was a kludge we used for simplicity on ARM platforms as well.
> > However this imposes problems due to their missing alignment and overlap
> > with the PCI I/O address space.
> >
> > Now that we can switch a device easily between using ioports and MMIO,
> > let's move the UARTs out of the first 4K of memory on ARM platforms.
> >
> > That should be transparent for well behaved guests, since the change is
> > naturally reflected in the device tree. Even "earlycon" keeps working,
> > as the stdout-path property is adjusted automatically.
> >
> > People providing direct earlycon parameters via the command line need to
> > adjust it to: "earlycon=uart,mmio,0x1000000".
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arm/include/arm-common/kvm-arch.h |  3 +++
> >  hw/serial.c                       | 45 ++++++++++++++++++++-----------
> >  2 files changed, 32 insertions(+), 16 deletions(-)
> >
> > diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> > index b12255b0..633ea8fa 100644
> > --- a/arm/include/arm-common/kvm-arch.h
> > +++ b/arm/include/arm-common/kvm-arch.h
> > @@ -28,6 +28,9 @@
> >  #define ARM_IOPORT_SIZE		(1U << 16)
> >  
> >  
> > +#define ARM_UART_MMIO_BASE	ARM_MMIO_AREA
> > +#define ARM_UART_MMIO_SIZE	0x10000
> > +
> >  #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
> >  #define KVM_FLASH_MAX_SIZE	0x1000000
> >  
> > diff --git a/hw/serial.c b/hw/serial.c
> > index 4be188a1..1854add2 100644
> > --- a/hw/serial.c
> > +++ b/hw/serial.c
> > @@ -13,6 +13,17 @@
> >  
> >  #include <pthread.h>
> >  
> > +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> > +#define serial_iobase(nr)	(ARM_UART_MMIO_BASE + (nr) * 0x1000)
> > +#define serial_irq(nr)		(32 + (nr))
> > +#define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
> > +#else
> > +#define serial_iobase(nr)	((((nr) & 1) ? 0x200 : 0x300) +	\
> > +				 ((nr) >= 2 ? 0xe8 : 0xf8))
> > +#define serial_irq(nr)		(((nr) & 1) ? 3 : 4)  
> 
> Those two defines are hard to read, is there a reason for changing them from v1?
> They looked a lot more readable in v1.

Oh, good catch, must have been a rebase artefact, from the very first
draft version I had. Fixed that.

Cheers,
Andre

> 
> > +#define SERIAL8250_BUS_TYPE	DEVICE_BUS_IOPORT
> > +#endif
> > +
> >  /*
> >   * This fakes a U6_16550A. The fifo len needs to be 64 as the kernel
> >   * expects that for autodetection.
> > @@ -27,7 +38,7 @@ struct serial8250_device {
> >  	struct mutex		mutex;
> >  	u8			id;
> >  
> > -	u16			iobase;
> > +	u32			iobase;
> >  	u8			irq;
> >  	u8			irq_state;
> >  	int			txcnt;
> > @@ -65,56 +76,56 @@ static struct serial8250_device devices[] = {
> >  	/* ttyS0 */
> >  	[0]	= {
> >  		.dev_hdr = {
> > -			.bus_type	= DEVICE_BUS_IOPORT,
> > +			.bus_type	= SERIAL8250_BUS_TYPE,
> >  			.data		= serial8250_generate_fdt_node,
> >  		},
> >  		.mutex			= MUTEX_INITIALIZER,
> >  
> >  		.id			= 0,
> > -		.iobase			= 0x3f8,
> > -		.irq			= 4,
> > +		.iobase			= serial_iobase(0),
> > +		.irq			= serial_irq(0),
> >  
> >  		SERIAL_REGS_SETTING
> >  	},
> >  	/* ttyS1 */
> >  	[1]	= {
> >  		.dev_hdr = {
> > -			.bus_type	= DEVICE_BUS_IOPORT,
> > +			.bus_type	= SERIAL8250_BUS_TYPE,
> >  			.data		= serial8250_generate_fdt_node,
> >  		},
> >  		.mutex			= MUTEX_INITIALIZER,
> >  
> >  		.id			= 1,
> > -		.iobase			= 0x2f8,
> > -		.irq			= 3,
> > +		.iobase			= serial_iobase(1),
> > +		.irq			= serial_irq(1),
> >  
> >  		SERIAL_REGS_SETTING
> >  	},
> >  	/* ttyS2 */
> >  	[2]	= {
> >  		.dev_hdr = {
> > -			.bus_type	= DEVICE_BUS_IOPORT,
> > +			.bus_type	= SERIAL8250_BUS_TYPE,
> >  			.data		= serial8250_generate_fdt_node,
> >  		},
> >  		.mutex			= MUTEX_INITIALIZER,
> >  
> >  		.id			= 2,
> > -		.iobase			= 0x3e8,
> > -		.irq			= 4,
> > +		.iobase			= serial_iobase(2),
> > +		.irq			= serial_irq(2),
> >  
> >  		SERIAL_REGS_SETTING
> >  	},
> >  	/* ttyS3 */
> >  	[3]	= {
> >  		.dev_hdr = {
> > -			.bus_type	= DEVICE_BUS_IOPORT,
> > +			.bus_type	= SERIAL8250_BUS_TYPE,
> >  			.data		= serial8250_generate_fdt_node,
> >  		},
> >  		.mutex			= MUTEX_INITIALIZER,
> >  
> >  		.id			= 3,
> > -		.iobase			= 0x2e8,
> > -		.irq			= 3,
> > +		.iobase			= serial_iobase(3),
> > +		.irq			= serial_irq(3),
> >  
> >  		SERIAL_REGS_SETTING
> >  	},
> > @@ -439,7 +450,8 @@ static int serial8250__device_init(struct kvm *kvm,
> >  		return r;
> >  
> >  	ioport__map_irq(&dev->irq);
> > -	r = kvm__register_pio(kvm, dev->iobase, 8, serial8250_mmio, dev);
> > +	r = kvm__register_iotrap(kvm, dev->iobase, 8, serial8250_mmio, dev,
> > +				 SERIAL8250_BUS_TYPE);
> >  
> >  	return r;
> >  }
> > @@ -462,7 +474,7 @@ cleanup:
> >  	for (j = 0; j <= i; j++) {
> >  		struct serial8250_device *dev = &devices[j];
> >  
> > -		kvm__deregister_pio(kvm, dev->iobase);
> > +		kvm__deregister_iotrap(kvm, dev->iobase, SERIAL8250_BUS_TYPE);
> >  		device__unregister(&dev->dev_hdr);
> >  	}
> >  
> > @@ -478,7 +490,8 @@ int serial8250__exit(struct kvm *kvm)
> >  	for (i = 0; i < ARRAY_SIZE(devices); i++) {
> >  		struct serial8250_device *dev = &devices[i];
> >  
> > -		r = kvm__deregister_pio(kvm, dev->iobase);
> > +		r = kvm__deregister_iotrap(kvm, dev->iobase,
> > +					   SERIAL8250_BUS_TYPE);
> >  		if (r < 0)
> >  			return r;
> >  		device__unregister(&dev->dev_hdr);  

