Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E975733F54F
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 17:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhCQQRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 12:17:52 -0400
Received: from foss.arm.com ([217.140.110.172]:37966 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232291AbhCQQRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 12:17:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2446ED6E;
        Wed, 17 Mar 2021 09:17:48 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 213503F792;
        Wed, 17 Mar 2021 09:17:47 -0700 (PDT)
Subject: Re: [PATCH kvmtool v3 21/22] hw/serial: ARM/arm64: Use MMIO at higher
 addresses
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
References: <20210315153350.19988-1-andre.przywara@arm.com>
 <20210315153350.19988-22-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <7ce22c90-bf5c-b976-5698-85a7605bc1b7@arm.com>
Date:   Wed, 17 Mar 2021 16:17:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315153350.19988-22-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 3/15/21 3:33 PM, Andre Przywara wrote:
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

Checked and that's indeed the address of the first UART.

>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/include/arm-common/kvm-arch.h |  7 ++--
>  hw/serial.c                       | 54 +++++++++++++++++++++----------
>  2 files changed, 42 insertions(+), 19 deletions(-)
>
> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> index a2e32953..bf34d742 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/arm-common/kvm-arch.h
> @@ -13,8 +13,8 @@
>   * 0      64K  16M     32M     48M            1GB       2GB
>   * +-------+----+-------+-------+--------+-----+---------+---......
>   * |  PCI  |////| plat  |       |        |     |         |
> - * |  I/O  |////| MMIO  | Flash | virtio | GIC |   PCI   |  DRAM
> - * | space |////|       |       |  MMIO  |     |  (AXI)  |
> + * |  I/O  |////| MMIO: | Flash | virtio | GIC |   PCI   |  DRAM
> + * | space |////| UART  |       |  MMIO  |     |  (AXI)  |
>   * |       |////|       |       |        |     |         |
>   * +-------+----+-------+-------+--------+-----+---------+---......
>   */
> @@ -28,6 +28,9 @@
>  #define ARM_IOPORT_SIZE		(1U << 16)
>  
>  
> +#define ARM_UART_MMIO_BASE	ARM_MMIO_AREA
> +#define ARM_UART_MMIO_SIZE	0x10000
> +
>  #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
>  #define KVM_FLASH_MAX_SIZE	0x1000000
>  
> diff --git a/hw/serial.c b/hw/serial.c
> index 16af493b..3d533623 100644
> --- a/hw/serial.c
> +++ b/hw/serial.c
> @@ -13,6 +13,24 @@
>  
>  #include <pthread.h>
>  
> +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> +#define serial_iobase(nr)	(ARM_UART_MMIO_BASE + (nr) * 0x1000)
> +#define serial_irq(nr)		(32 + (nr))
> +#define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
> +#else
> +#define serial_iobase_0		(KVM_IOPORT_AREA + 0x3f8)
> +#define serial_iobase_1		(KVM_IOPORT_AREA + 0x2f8)
> +#define serial_iobase_2		(KVM_IOPORT_AREA + 0x3e8)
> +#define serial_iobase_3		(KVM_IOPORT_AREA + 0x2e8)
> +#define serial_irq_0		4
> +#define serial_irq_1		3
> +#define serial_irq_2		4
> +#define serial_irq_3		3
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
> @@ -407,7 +425,7 @@ void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
>  						     struct serial8250_device,
>  						     dev_hdr);
>  
> -	u64 addr = KVM_IOPORT_AREA + dev->iobase;
> +	u64 addr = dev->iobase;
>  	u64 reg_prop[] = {
>  		cpu_to_fdt64(addr),
>  		cpu_to_fdt64(8),
> @@ -440,7 +458,8 @@ static int serial8250__device_init(struct kvm *kvm,
>  		return r;
>  
>  	ioport__map_irq(&dev->irq);
> -	r = kvm__register_pio(kvm, dev->iobase, 8, serial8250_mmio, dev);
> +	r = kvm__register_iotrap(kvm, dev->iobase, 8, serial8250_mmio, dev,
> +				 SERIAL8250_BUS_TYPE);
>  
>  	return r;
>  }
> @@ -463,7 +482,7 @@ cleanup:
>  	for (j = 0; j <= i; j++) {
>  		struct serial8250_device *dev = &devices[j];
>  
> -		kvm__deregister_pio(kvm, dev->iobase);
> +		kvm__deregister_iotrap(kvm, dev->iobase, SERIAL8250_BUS_TYPE);
>  		device__unregister(&dev->dev_hdr);
>  	}
>  
> @@ -479,7 +498,8 @@ int serial8250__exit(struct kvm *kvm)
>  	for (i = 0; i < ARRAY_SIZE(devices); i++) {
>  		struct serial8250_device *dev = &devices[i];
>  
> -		r = kvm__deregister_pio(kvm, dev->iobase);
> +		r = kvm__deregister_iotrap(kvm, dev->iobase,
> +					   SERIAL8250_BUS_TYPE);
>  		if (r < 0)
>  			return r;
>  		device__unregister(&dev->dev_hdr);

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

