Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B23686BD6
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 17:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjBAQfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 11:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjBAQfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 11:35:17 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3753462276
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 08:35:13 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 129884B3;
        Wed,  1 Feb 2023 08:35:55 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DB543F64C;
        Wed,  1 Feb 2023 08:35:12 -0800 (PST)
Date:   Wed, 1 Feb 2023 16:35:09 +0000
From:   Andre Przywara <andre.przywara@foss.arm.com>
To:     Rajnesh Kanwal <rkanwal@rivosinc.com>, apatel@ventanamicro.com,
        atishp@rivosinc.com
Cc:     alexandru.elisei@arm.com, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 kvmtool] riscv: Move serial and rtc from IO port
 space to MMIO area.
Message-ID: <20230201163509.7fb82d7e@donnerap.cambridge.arm.com>
In-Reply-To: <20230201160137.486622-1-rkanwal@rivosinc.com>
References: <20230201160137.486622-1-rkanwal@rivosinc.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  1 Feb 2023 16:01:37 +0000
Rajnesh Kanwal <rkanwal@rivosinc.com> wrote:

Hi,

> The default serial and rtc IO region overlaps with PCI IO bar
> region leading bar 0 activation to fail. Moving these devices
> to MMIO region similar to ARM.
> 
> Given serial has been moved from 0x3f8 to 0x10000000, this
> requires us to now pass earlycon=uart8250,mmio,0x10000000
> from cmdline rather than earlycon=uart8250,mmio,0x3f8.

Doesn't it work either way with just "earlycon"? At least on the ARM side
it then finds the UART type and base address by following the DT's
stdout-path property. This would not only make this more robust, but also
more VMM agnostic.

Also, Atish, Anup: can one of you please provide a Reviewed-by: or
Tested-by: for this patch?

Cheers,
Andre

> 
> Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> ---
> v2: Added further details in the commit message regarding the
>     UART address change required in kernel cmdline parameter.
> 
> v1: https://www.spinics.net/lists/kvm/msg301835.html
> 
>  hw/rtc.c                     |  3 +++
>  hw/serial.c                  |  4 ++++
>  riscv/include/kvm/kvm-arch.h | 10 ++++++++--
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/rtc.c b/hw/rtc.c
> index 9b8785a..da696e1 100644
> --- a/hw/rtc.c
> +++ b/hw/rtc.c
> @@ -9,6 +9,9 @@
>  #if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
>  #define RTC_BUS_TYPE		DEVICE_BUS_MMIO
>  #define RTC_BASE_ADDRESS	ARM_RTC_MMIO_BASE
> +#elif defined(CONFIG_RISCV)
> +#define RTC_BUS_TYPE		DEVICE_BUS_MMIO
> +#define RTC_BASE_ADDRESS	RISCV_RTC_MMIO_BASE
>  #else
>  /* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
>  #define RTC_BUS_TYPE		DEVICE_BUS_IOPORT
> diff --git a/hw/serial.c b/hw/serial.c
> index 3d53362..b6263a0 100644
> --- a/hw/serial.c
> +++ b/hw/serial.c
> @@ -17,6 +17,10 @@
>  #define serial_iobase(nr)	(ARM_UART_MMIO_BASE + (nr) * 0x1000)
>  #define serial_irq(nr)		(32 + (nr))
>  #define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
> +#elif defined(CONFIG_RISCV)
> +#define serial_iobase(nr)	(RISCV_UART_MMIO_BASE + (nr) * 0x1000)
> +#define serial_irq(nr)		(1 + (nr))
> +#define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
>  #else
>  #define serial_iobase_0		(KVM_IOPORT_AREA + 0x3f8)
>  #define serial_iobase_1		(KVM_IOPORT_AREA + 0x2f8)
> diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> index 3f96d00..620c796 100644
> --- a/riscv/include/kvm/kvm-arch.h
> +++ b/riscv/include/kvm/kvm-arch.h
> @@ -11,7 +11,7 @@
>  #define RISCV_IOPORT		0x00000000ULL
>  #define RISCV_IOPORT_SIZE	SZ_64K
>  #define RISCV_IRQCHIP		0x08000000ULL
> -#define RISCV_IRQCHIP_SIZE		SZ_128M
> +#define RISCV_IRQCHIP_SIZE	SZ_128M
>  #define RISCV_MMIO		0x10000000ULL
>  #define RISCV_MMIO_SIZE		SZ_512M
>  #define RISCV_PCI		0x30000000ULL
> @@ -35,10 +35,16 @@
>  #define RISCV_MAX_MEMORY(kvm)	RISCV_LOMAP_MAX_MEMORY
>  #endif
>  
> +#define RISCV_UART_MMIO_BASE	RISCV_MMIO
> +#define RISCV_UART_MMIO_SIZE	0x10000
> +
> +#define RISCV_RTC_MMIO_BASE	(RISCV_UART_MMIO_BASE + RISCV_UART_MMIO_SIZE)
> +#define RISCV_RTC_MMIO_SIZE	0x10000
> +
>  #define KVM_IOPORT_AREA		RISCV_IOPORT
>  #define KVM_PCI_CFG_AREA	RISCV_PCI
>  #define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + RISCV_PCI_CFG_SIZE)
> -#define KVM_VIRTIO_MMIO_AREA	RISCV_MMIO
> +#define KVM_VIRTIO_MMIO_AREA	(RISCV_RTC_MMIO_BASE + RISCV_UART_MMIO_SIZE)
>  
>  #define KVM_IOEVENTFD_HAS_PIO	0
>  

