Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F70448A46B
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 01:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242941AbiAKA2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 19:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238567AbiAKA2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 19:28:16 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1932C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 16:28:15 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id u8so20162885iol.5
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 16:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E9QwF6qfbbBsLwk0HIc1LhZmmT0WD4pHRqAeINZ/i8Q=;
        b=fjCh7TrZx16ZiypyHHodVJVPsJ2jgD8/mvaV5e8oBpD6/Wa7JjEOE0SLaWm9/zpcfZ
         R8EoyBVkmSHVlgG+BqN/4ie0bLFzTrkCMnypPHLnNSXJjPCn6q3LwGO0YU0+77La+m3B
         pYk3L3N7ULgCl4jlVfe6bgSxljoel7Nu1Ivbbqv0YCRZrR6AGuvtzLeHK/lupstjnp7S
         r4mkB3I/iytZI728xXO2qoG5qI/Uag1BY4FK5QXRhVq86nNvMYyFg0Ir8/2iss0j6Sph
         eMVgh+gzBKUG193fzHPuVi1b0zkGSa4PmxAbF8no3hh6fuhUdHDSmOGys7tsE/2D8f8c
         5/2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E9QwF6qfbbBsLwk0HIc1LhZmmT0WD4pHRqAeINZ/i8Q=;
        b=6xU+0HgLOvg6Dn+FbMoLWPMngk7LW2UjN/8MUdjKKG1frUTsbAZ1K2vMwHRg1hRkqY
         pKk7UbCziTPzBbHC8x/LX51CxWI89HLmKrWmhni1xz5rSZu+Jsxvm3NOncb3+JDjkYyw
         FsKoI+dvhl53DVWHymbu3fhAkvEIM9E+DSWTlWb0Pu1oH4nMZCdGU5Y40yC174t0/f/S
         3Z9nLO6W5uikbh9VxU2SyfC4p07kuTkd8TgLmpgrnoOk3PMyb/V9Ps7GZdpjFvRi8Y1W
         DaPR626ZaaFXXMziWDQhlIHyRUYOVD1MPoFPt1/IJXt9gf9ecirVPVtUXtDcQRRpkf48
         OWgw==
X-Gm-Message-State: AOAM532R8lkjldATRJNLl3PF7GYT7gvKa/+CvCzrC9MnaCsLp6tErBFQ
        NGd3J90kTPR8VRBPRr9RfHe5D6uq9fmVuoiU6Zk=
X-Google-Smtp-Source: ABdhPJx8xGI8yzoRmTjSqW1KfvFV4tyMFckEePCJm0jc9I5pVLgcl0vg9ZTbhMlYk7Q0E/q65AB4BTyV7XQhx2e9I8Q=
X-Received: by 2002:a5d:8f88:: with SMTP id l8mr1026913iol.91.1641860895091;
 Mon, 10 Jan 2022 16:28:15 -0800 (PST)
MIME-Version: 1.0
References: <20220110013831.1594-1-jiangyifei@huawei.com> <20220110013831.1594-7-jiangyifei@huawei.com>
In-Reply-To: <20220110013831.1594-7-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 11 Jan 2022 10:27:48 +1000
Message-ID: <CAKmqyKPNLSiLP_FGgod=1fa=kUnnkagYBOQD0Bx5O=96AAkhmQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/12] target/riscv: Support start kernel directly by KVM
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        kvm-riscv@lists.infradead.org,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>, wanghaibin.wang@huawei.com,
        wanbo13@huawei.com, Mingwang Li <limingwang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 11:52 AM Yifei Jiang via <qemu-devel@nongnu.org> wrote:
>
> Get kernel and fdt start address in virt.c, and pass them to KVM
> when cpu reset. Add kvm_riscv.h to place riscv specific interface.
>
> In addition, PLIC is created without M-mode PLIC contexts when KVM
> is enabled.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
> ---
>  hw/intc/sifive_plic.c    | 21 +++++++---
>  hw/riscv/boot.c          | 16 +++++++-
>  hw/riscv/virt.c          | 83 ++++++++++++++++++++++++++++------------
>  include/hw/riscv/boot.h  |  1 +
>  target/riscv/cpu.c       |  8 ++++
>  target/riscv/cpu.h       |  3 ++
>  target/riscv/kvm-stub.c  | 25 ++++++++++++
>  target/riscv/kvm.c       | 14 +++++++
>  target/riscv/kvm_riscv.h | 24 ++++++++++++
>  target/riscv/meson.build |  2 +-
>  10 files changed, 164 insertions(+), 33 deletions(-)
>  create mode 100644 target/riscv/kvm-stub.c
>  create mode 100644 target/riscv/kvm_riscv.h
>
> diff --git a/hw/intc/sifive_plic.c b/hw/intc/sifive_plic.c
> index 877e76877c..58c16881cb 100644
> --- a/hw/intc/sifive_plic.c
> +++ b/hw/intc/sifive_plic.c
> @@ -30,6 +30,7 @@
>  #include "target/riscv/cpu.h"
>  #include "migration/vmstate.h"
>  #include "hw/irq.h"
> +#include "sysemu/kvm.h"
>
>  #define RISCV_DEBUG_PLIC 0
>
> @@ -533,6 +534,8 @@ DeviceState *sifive_plic_create(hwaddr addr, char *hart_config,
>  {
>      DeviceState *dev = qdev_new(TYPE_SIFIVE_PLIC);
>      int i;
> +    SiFivePLICState *plic;
> +    int s_count = 0, m_count = 0;
>
>      assert(enable_stride == (enable_stride & -enable_stride));
>      assert(context_stride == (context_stride & -context_stride));
> @@ -550,13 +553,19 @@ DeviceState *sifive_plic_create(hwaddr addr, char *hart_config,
>      sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
>      sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, addr);
>
> -    for (i = 0; i < num_harts; i++) {
> -        CPUState *cpu = qemu_get_cpu(hartid_base + i);
> +    plic = SIFIVE_PLIC(dev);
> +    for (i = 0; i < plic->num_addrs; i++) {
> +        CPUState *cpu = qemu_get_cpu(plic->addr_config[i].hartid);
>
> -        qdev_connect_gpio_out(dev, i,
> -                              qdev_get_gpio_in(DEVICE(cpu), IRQ_S_EXT));
> -        qdev_connect_gpio_out(dev, num_harts + i,
> -                              qdev_get_gpio_in(DEVICE(cpu), IRQ_M_EXT));
> +        if (plic->addr_config[i].mode == PLICMode_S) {
> +            qdev_connect_gpio_out(dev, s_count++,
> +                                  qdev_get_gpio_in(DEVICE(cpu), IRQ_S_EXT));
> +        }
> +
> +        if (plic->addr_config[i].mode == PLICMode_M) {
> +            qdev_connect_gpio_out(dev, num_harts + m_count++,
> +                                  qdev_get_gpio_in(DEVICE(cpu), IRQ_M_EXT));
> +        }
>      }

This PLIC change breaks my 5.11.0 buildroot test case on the SiFive U board

The boot process just hangs at:

[    0.542798] usbcore: registered new interface driver usbhid
[    0.543021] usbhid: USB HID core driver
[    0.544584] NET: Registered protocol family 10
[    4.054768] Segment Routing with IPv6
[    4.055325] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    4.057956] NET: Registered protocol family 17
[    4.059327] 9pnet: Installing 9P2000 support
[    4.059787] Key type dns_resolver registered
[    4.060515] debug_vm_pgtable: [debug_vm_pgtable         ]:
Validating architecture page table helpers
[    4.078710] macb 10090000.ethernet eth0: PHY
[10090000.ethernet-ffffffff:00] driver [Generic PHY] (irq=POLL)
[    4.079454] macb 10090000.ethernet eth0: configuring for phy/gmii link mode
[    4.087031] macb 10090000.ethernet eth0: Link is Up - 1Gbps/Full -
flow control tx
[    4.094634] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

Alistair
