Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6880F31DDA8
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 17:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbhBQQt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 11:49:56 -0500
Received: from foss.arm.com ([217.140.110.172]:34154 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234013AbhBQQtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 11:49:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B6EDED1;
        Wed, 17 Feb 2021 08:49:09 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 771273F73B;
        Wed, 17 Feb 2021 08:49:08 -0800 (PST)
Subject: Re: [PATCH kvmtool 20/21] hw/serial: ARM/arm64: Use MMIO at higher
 addresses
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-21-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <bce317a9-2c8e-2254-57c3-e0bea9a13760@arm.com>
Date:   Wed, 17 Feb 2021 16:48:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-21-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 12/10/20 2:29 PM, Andre Przywara wrote:
> Using the UART devices at their legacy I/O addresses as set by IBM in
> 1981 was a kludge we used for simplicity on ARM platforms as well.
> However this imposes problems due to their missing alignment and overlap
> with the PCI I/O address space.
>
> Now that we can switch a device easily between using ioports and MMIO,
> let's move the UARTs out of the first 4K of memory on ARM platforms.
>
> That should be transparent for well behaved guests, since the change is
> naturally reflected in the device tree. Even "earlycon" keeps working,
> as the stdout-path property is adjusted automatically.
>
> People providing direct earlycon parameters via the command line need to
> adjust it to: "earlycon=uart,mmio,0x1000000".
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/serial.c | 52 ++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 36 insertions(+), 16 deletions(-)
>
> diff --git a/hw/serial.c b/hw/serial.c
> index d840eebc..00fb3aa8 100644
> --- a/hw/serial.c
> +++ b/hw/serial.c
> @@ -13,6 +13,24 @@
>  
>  #include <pthread.h>
>  
> +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> +#define serial_iobase(nr)	(0x1000000 + (nr) * 0x1000)
> +#define serial_irq(nr)		(32 + (nr))
> +#define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
> +#else
> +#define serial_iobase_0		0x3f8
> +#define serial_iobase_1		0x2f8
> +#define serial_iobase_2		0x3e8
> +#define serial_iobase_3		0x2e8
> +#define serial_irq_0		4
> +#define serial_irq_1		3
> +#define serial_irq_2		4
> +#define serial_irq_3		3

Nitpick: serial_iobase_* and serial_irq_* could be changed to have two leading
underscores, to stress the fact that they are helpers for serial_iobase() and
serial_irq() and are not meant to be used by themselves. But that's just personal
preference, otherwise the patch looks really nice and clean:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

> +#define serial_iobase(nr)	serial_iobase_##nr
> +#define serial_irq(nr)		serial_irq_##nr
> +#define SERIAL8250_BUS_TYPE	DEVICE_BUS_IOPORT
> +#endif
> +
>  /*
>   * This fakes a U6_16550A. The fifo len needs to be 64 as the kernel
>   * expects that for autodetection.
> @@ -27,7 +45,7 @@ struct serial8250_device {
>  	struct mutex		mutex;
>  	u8			id;
>  
> -	u16			iobase;
> +	u32			iobase;
>  	u8			irq;
>  	u8			irq_state;
>  	int			txcnt;
> @@ -65,56 +83,56 @@ static struct serial8250_device devices[] = {
>  	/* ttyS0 */
>  	[0]	= {
>  		.dev_hdr = {
> -			.bus_type	= DEVICE_BUS_IOPORT,
> +			.bus_type	= SERIAL8250_BUS_TYPE,
>  			.data		= serial8250_generate_fdt_node,
>  		},
>  		.mutex			= MUTEX_INITIALIZER,
>  
>  		.id			= 0,
> -		.iobase			= 0x3f8,
> -		.irq			= 4,
> +		.iobase			= serial_iobase(0),
> +		.irq			= serial_irq(0),
>  
>  		SERIAL_REGS_SETTING
>  	},
>  	/* ttyS1 */
>  	[1]	= {
>  		.dev_hdr = {
> -			.bus_type	= DEVICE_BUS_IOPORT,
> +			.bus_type	= SERIAL8250_BUS_TYPE,
>  			.data		= serial8250_generate_fdt_node,
>  		},
>  		.mutex			= MUTEX_INITIALIZER,
>  
>  		.id			= 1,
> -		.iobase			= 0x2f8,
> -		.irq			= 3,
> +		.iobase			= serial_iobase(1),
> +		.irq			= serial_irq(1),
>  
>  		SERIAL_REGS_SETTING
>  	},
>  	/* ttyS2 */
>  	[2]	= {
>  		.dev_hdr = {
> -			.bus_type	= DEVICE_BUS_IOPORT,
> +			.bus_type	= SERIAL8250_BUS_TYPE,
>  			.data		= serial8250_generate_fdt_node,
>  		},
>  		.mutex			= MUTEX_INITIALIZER,
>  
>  		.id			= 2,
> -		.iobase			= 0x3e8,
> -		.irq			= 4,
> +		.iobase			= serial_iobase(2),
> +		.irq			= serial_irq(2),
>  
>  		SERIAL_REGS_SETTING
>  	},
>  	/* ttyS3 */
>  	[3]	= {
>  		.dev_hdr = {
> -			.bus_type	= DEVICE_BUS_IOPORT,
> +			.bus_type	= SERIAL8250_BUS_TYPE,
>  			.data		= serial8250_generate_fdt_node,
>  		},
>  		.mutex			= MUTEX_INITIALIZER,
>  
>  		.id			= 3,
> -		.iobase			= 0x2e8,
> -		.irq			= 3,
> +		.iobase			= serial_iobase(3),
> +		.irq			= serial_irq(3),
>  
>  		SERIAL_REGS_SETTING
>  	},
> @@ -444,7 +462,8 @@ static int serial8250__device_init(struct kvm *kvm,
>  		return r;
>  
>  	ioport__map_irq(&dev->irq);
> -	r = kvm__register_pio(kvm, dev->iobase, 8, serial8250_mmio, dev);
> +	r = kvm__register_iotrap(kvm, dev->iobase, 8, serial8250_mmio, dev,
> +				 SERIAL8250_BUS_TYPE);
>  
>  	return r;
>  }
> @@ -467,7 +486,7 @@ cleanup:
>  	for (j = 0; j <= i; j++) {
>  		struct serial8250_device *dev = &devices[j];
>  
> -		kvm__deregister_pio(kvm, dev->iobase);
> +		kvm__deregister_iotrap(kvm, dev->iobase, SERIAL8250_BUS_TYPE);
>  		device__unregister(&dev->dev_hdr);
>  	}
>  
> @@ -483,7 +502,8 @@ int serial8250__exit(struct kvm *kvm)
>  	for (i = 0; i < ARRAY_SIZE(devices); i++) {
>  		struct serial8250_device *dev = &devices[i];
>  
> -		r = kvm__deregister_pio(kvm, dev->iobase);
> +		r = kvm__deregister_iotrap(kvm, dev->iobase,
> +					   SERIAL8250_BUS_TYPE);
>  		if (r < 0)
>  			return r;
>  		device__unregister(&dev->dev_hdr);
