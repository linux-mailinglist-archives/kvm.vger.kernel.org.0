Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B7031EE45
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhBRS2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:28:32 -0500
Received: from foss.arm.com ([217.140.110.172]:53246 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231993AbhBRQkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 11:40:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54398113E;
        Thu, 18 Feb 2021 08:39:30 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24AA83F73D;
        Thu, 18 Feb 2021 08:39:28 -0800 (PST)
Date:   Thu, 18 Feb 2021 16:38:31 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 20/21] hw/serial: ARM/arm64: Use MMIO at higher
 addresses
Message-ID: <20210218163831.476c0f35@slackpad.fritz.box>
In-Reply-To: <f16f89dc-78fd-1046-eefc-1dccd468fba8@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
        <20201210142908.169597-21-andre.przywara@arm.com>
        <bce317a9-2c8e-2254-57c3-e0bea9a13760@arm.com>
        <f16f89dc-78fd-1046-eefc-1dccd468fba8@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Feb 2021 12:18:38 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Hi Andre,
> 
> On 2/17/21 4:48 PM, Alexandru Elisei wrote:
> > Hi Andre,
> >
> > On 12/10/20 2:29 PM, Andre Przywara wrote:  
> >> Using the UART devices at their legacy I/O addresses as set by IBM in
> >> 1981 was a kludge we used for simplicity on ARM platforms as well.
> >> However this imposes problems due to their missing alignment and overlap
> >> with the PCI I/O address space.
> >>
> >> Now that we can switch a device easily between using ioports and MMIO,
> >> let's move the UARTs out of the first 4K of memory on ARM platforms.
> >>
> >> That should be transparent for well behaved guests, since the change is
> >> naturally reflected in the device tree. Even "earlycon" keeps working,
> >> as the stdout-path property is adjusted automatically.
> >>
> >> People providing direct earlycon parameters via the command line need to
> >> adjust it to: "earlycon=uart,mmio,0x1000000".
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >>  hw/serial.c | 52 ++++++++++++++++++++++++++++++++++++----------------
> >>  1 file changed, 36 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/hw/serial.c b/hw/serial.c
> >> index d840eebc..00fb3aa8 100644
> >> --- a/hw/serial.c
> >> +++ b/hw/serial.c
> >> @@ -13,6 +13,24 @@
> >>  
> >>  #include <pthread.h>
> >>  
> >> +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> >> +#define serial_iobase(nr)	(0x1000000 + (nr) * 0x1000)
> >> +#define serial_irq(nr)		(32 + (nr))
> >> +#define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
> >> +#else
> >> +#define serial_iobase_0		0x3f8
> >> +#define serial_iobase_1		0x2f8
> >> +#define serial_iobase_2		0x3e8
> >> +#define serial_iobase_3		0x2e8
> >> +#define serial_irq_0		4
> >> +#define serial_irq_1		3
> >> +#define serial_irq_2		4
> >> +#define serial_irq_3		3  
> > Nitpick: serial_iobase_* and serial_irq_* could be changed to have two leading
> > underscores, to stress the fact that they are helpers for serial_iobase() and
> > serial_irq() and are not meant to be used by themselves. But that's just personal
> > preference, otherwise the patch looks really nice and clean:
> >
> > Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>  
> 
> I gave it more thought and I think I spoke too soon. I think it would be good to
> document in the commit message how you came to the base MMIO address and size
> (even if it was just a nice looking number). Also, the CFI flash device has its
> memory range described in the memory layout for the architecture, in
> arm/include/arm-common/kvm-arch.h. I think it would be a good idea to put the
> serial region there, to prevent regressions in the future.

Yes, that's very true, the memory map should be described in one place
only. Will try to do that.


> 
> I did the math to make sure there's no overlap with the ioport region (16M >> 16K)
> or the flash region (16M + 0x4000 < 32M). I also tested the changes with a kernel
> with 4K and 64K pages (I can't access any hardware with 16K pages at the moment),
> and everything worked as expected.

Thanks!
Andre

> >> +#define serial_iobase(nr)	serial_iobase_##nr
> >> +#define serial_irq(nr)		serial_irq_##nr
> >> +#define SERIAL8250_BUS_TYPE	DEVICE_BUS_IOPORT
> >> +#endif
> >> +
> >>  /*
> >>   * This fakes a U6_16550A. The fifo len needs to be 64 as the kernel
> >>   * expects that for autodetection.
> >> @@ -27,7 +45,7 @@ struct serial8250_device {
> >>  	struct mutex		mutex;
> >>  	u8			id;
> >>  
> >> -	u16			iobase;
> >> +	u32			iobase;
> >>  	u8			irq;
> >>  	u8			irq_state;
> >>  	int			txcnt;
> >> @@ -65,56 +83,56 @@ static struct serial8250_device devices[] = {
> >>  	/* ttyS0 */
> >>  	[0]	= {
> >>  		.dev_hdr = {
> >> -			.bus_type	= DEVICE_BUS_IOPORT,
> >> +			.bus_type	= SERIAL8250_BUS_TYPE,
> >>  			.data		= serial8250_generate_fdt_node,
> >>  		},
> >>  		.mutex			= MUTEX_INITIALIZER,
> >>  
> >>  		.id			= 0,
> >> -		.iobase			= 0x3f8,
> >> -		.irq			= 4,
> >> +		.iobase			= serial_iobase(0),
> >> +		.irq			= serial_irq(0),
> >>  
> >>  		SERIAL_REGS_SETTING
> >>  	},
> >>  	/* ttyS1 */
> >>  	[1]	= {
> >>  		.dev_hdr = {
> >> -			.bus_type	= DEVICE_BUS_IOPORT,
> >> +			.bus_type	= SERIAL8250_BUS_TYPE,
> >>  			.data		= serial8250_generate_fdt_node,
> >>  		},
> >>  		.mutex			= MUTEX_INITIALIZER,
> >>  
> >>  		.id			= 1,
> >> -		.iobase			= 0x2f8,
> >> -		.irq			= 3,
> >> +		.iobase			= serial_iobase(1),
> >> +		.irq			= serial_irq(1),
> >>  
> >>  		SERIAL_REGS_SETTING
> >>  	},
> >>  	/* ttyS2 */
> >>  	[2]	= {
> >>  		.dev_hdr = {
> >> -			.bus_type	= DEVICE_BUS_IOPORT,
> >> +			.bus_type	= SERIAL8250_BUS_TYPE,
> >>  			.data		= serial8250_generate_fdt_node,
> >>  		},
> >>  		.mutex			= MUTEX_INITIALIZER,
> >>  
> >>  		.id			= 2,
> >> -		.iobase			= 0x3e8,
> >> -		.irq			= 4,
> >> +		.iobase			= serial_iobase(2),
> >> +		.irq			= serial_irq(2),
> >>  
> >>  		SERIAL_REGS_SETTING
> >>  	},
> >>  	/* ttyS3 */
> >>  	[3]	= {
> >>  		.dev_hdr = {
> >> -			.bus_type	= DEVICE_BUS_IOPORT,
> >> +			.bus_type	= SERIAL8250_BUS_TYPE,
> >>  			.data		= serial8250_generate_fdt_node,
> >>  		},
> >>  		.mutex			= MUTEX_INITIALIZER,
> >>  
> >>  		.id			= 3,
> >> -		.iobase			= 0x2e8,
> >> -		.irq			= 3,
> >> +		.iobase			= serial_iobase(3),
> >> +		.irq			= serial_irq(3),
> >>  
> >>  		SERIAL_REGS_SETTING
> >>  	},
> >> @@ -444,7 +462,8 @@ static int serial8250__device_init(struct kvm *kvm,
> >>  		return r;
> >>  
> >>  	ioport__map_irq(&dev->irq);
> >> -	r = kvm__register_pio(kvm, dev->iobase, 8, serial8250_mmio, dev);
> >> +	r = kvm__register_iotrap(kvm, dev->iobase, 8, serial8250_mmio, dev,
> >> +				 SERIAL8250_BUS_TYPE);
> >>  
> >>  	return r;
> >>  }
> >> @@ -467,7 +486,7 @@ cleanup:
> >>  	for (j = 0; j <= i; j++) {
> >>  		struct serial8250_device *dev = &devices[j];
> >>  
> >> -		kvm__deregister_pio(kvm, dev->iobase);
> >> +		kvm__deregister_iotrap(kvm, dev->iobase, SERIAL8250_BUS_TYPE);
> >>  		device__unregister(&dev->dev_hdr);
> >>  	}
> >>  
> >> @@ -483,7 +502,8 @@ int serial8250__exit(struct kvm *kvm)
> >>  	for (i = 0; i < ARRAY_SIZE(devices); i++) {
> >>  		struct serial8250_device *dev = &devices[i];
> >>  
> >> -		r = kvm__deregister_pio(kvm, dev->iobase);
> >> +		r = kvm__deregister_iotrap(kvm, dev->iobase,
> >> +					   SERIAL8250_BUS_TYPE);
> >>  		if (r < 0)
> >>  			return r;
> >>  		device__unregister(&dev->dev_hdr);  
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm  

