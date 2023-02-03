Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACDA689486
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 11:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbjBCJ7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 04:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjBCJ7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 04:59:01 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 136B47B40B
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 01:58:59 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF12CC14;
        Fri,  3 Feb 2023 01:59:40 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E8093F8D6;
        Fri,  3 Feb 2023 01:58:57 -0800 (PST)
Date:   Fri, 3 Feb 2023 09:58:46 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Cc:     apatel@ventanamicro.com, atishp@rivosinc.com,
        andre.przywara@arm.com, kvm@vger.kernel.org
Subject: Re: [PATCH v3 kvmtool 1/1] riscv: Move serial and rtc from IO port
 space to MMIO area.
Message-ID: <Y9za1tUnQR8jpZoA@monolith.localdoman>
References: <20230202191301.588804-1-rkanwal@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202191301.588804-1-rkanwal@rivosinc.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Feb 02, 2023 at 07:13:01PM +0000, Rajnesh Kanwal wrote:
> The default serial and rtc IO region overlaps with PCI IO bar
> region leading bar 0 activation to fail. Moving these devices
> to MMIO region similar to ARM.
> 
> Given serial has been moved from 0x3f8 to 0x10000000, this
> requires us to now pass earlycon=uart8250,mmio,0x10000000
> from cmdline rather than earlycon=uart8250,mmio,0x3f8.
> 
> To avoid the need to change the address every time the tool
> is updated, we can also just pass "earlycon" from cmdline
> and guest then finds the type and base address by following
> the Device Tree's stdout-path property.
> 
> Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> Tested-by: Atish Patra <atishp@rivosinc.com>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
> ---
> v3: https://lore.kernel.org/all/20230201160137.486622-1-rkanwal@rivosinc.com/
>     Incorporated feedback from Andre Przywara and Alexandru Elisei.
>       Mainly updated the commit message to specify that we can simply pass
>       just "earlycon" from cmdline and avoid the need to specify uart address.
>     Also added Tested-by and Reviewed-by tags by Atish Patra.
> 
> v2: https://lore.kernel.org/all/20230201160137.486622-1-rkanwal@rivosinc.com/
>     Added further details in the commit message regarding the
>     UART address change required in kernel cmdline parameter.
> 
> v1: https://lore.kernel.org/all/20230124155251.1417682-1-rkanwal@rivosinc.com/
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

That's strange, for me the latest upstream commit is e17d182ad3f7 ("riscv: Add
--disable-<xyz> options to allow user disable extensions"), and I can't seem to
find those defines in the file. In fact, grep -r IRQCHIP riscv doesn't find
anything. Does this patch depend on another patch which hasn't been merged yet?

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

That should be RISCV_RTC_MMIO_SIZE, not RISCV_**UART**_MMIO_SIZE.

Thanks,
Alex

>  
>  #define KVM_IOEVENTFD_HAS_PIO	0
>  
> -- 
> 2.25.1
> 
