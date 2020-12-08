Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBEE2D3617
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbgLHWUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgLHWUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:20:10 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD28C0613D6
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:19:30 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id v3so16986340ilo.5
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5n/UUXaHq0iBzNlfehRV+4jrAiMw9Uiq5jnerbk9+OM=;
        b=SjRoOBO+mbYBbbe490SytVD6BK6JX0Gt23O/SsNY8XDw6+wzS09GP8Pzlkq66xeLmk
         C0me7Wi85EePsIYyjL3DWtIG1nZkgM3HnulVJaCM3CDtcO14KFKLv5gEwdG0rrGN048W
         rn4aa8a/KaPL5vjNWDzhKOzNSvy4CuyIn+evRqEX7LtSSypC6DyNcqVh5ZGuVhda7n6o
         clMbIqiw167PYvmdcBwM/D/hpak5uliuZFOa5kc4asap0EgtvEayKNGXlJ0PwN8Z407z
         VyB4y279itvuu7+IEFvse+081gbcts5oUYwIAh+yIEpexsKYsNzMM3JIUoPrVAJwdxWc
         tMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5n/UUXaHq0iBzNlfehRV+4jrAiMw9Uiq5jnerbk9+OM=;
        b=huhvP3Q37Mmvr+0tleaW26rNTwkdIsM5WMa0ZluoKYOLNrQ0XfXRstKiuDB0X2cPuV
         rcJ37/JlpcwetWxFxnoIKgA9vxE7oLGq12wBcOL3jPrItHBzd8p38jysjbbMJFeJtD0z
         tpVgDf5lMsm1uj73TkkTyscuc4VkG0msatcMLbI+jSjLgMCa3uLls2QpeQT5jpAMmuA2
         E7x11ZzQQMpSmP/UiDALIxXPEmnUZCf7RHY9vf8cnR0hCD6xfIb0SY1tDbMIHh5BGKL2
         RgmoirzZaw6KOSl+zVSVGW6Rdo+jjF4mvB6hCtagaFSiD2fM5J/QdRoSladpjwRfgOQa
         j0bg==
X-Gm-Message-State: AOAM531SVX/XXkvI/9L4o9dEF/Aegri4zukNsxhItxJ/tq6sSNWDrcjJ
        fs8OJBvUvWEmAhBRcK4gQdGDxta06KLOZF9ShVY=
X-Google-Smtp-Source: ABdhPJzsf7ki9b9KRsWeMXsqH3tB0epnSqLCoxSPpu3ohd3vcIuIBpdHNER0NfoteEg9LS/zwaiePi5A7YNwQdxVL+M=
X-Received: by 2002:a92:490d:: with SMTP id w13mr3268ila.227.1607465970106;
 Tue, 08 Dec 2020 14:19:30 -0800 (PST)
MIME-Version: 1.0
References: <20201203124703.168-1-jiangyifei@huawei.com> <20201203124703.168-7-jiangyifei@huawei.com>
In-Reply-To: <20201203124703.168-7-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 8 Dec 2020 14:19:04 -0800
Message-ID: <CAKmqyKO4vsY90DnVVp6wgAvSquoW0auFRr3LLfSHrCqXV6vWcg@mail.gmail.com>
Subject: Re: [PATCH RFC v4 06/15] target/riscv: Support start kernel directly
 by KVM
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Anup Patel <anup.patel@wdc.com>,
        yinyipeng <yinyipeng1@huawei.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>,
        "dengkai (A)" <dengkai1@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 3, 2020 at 4:58 AM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Get kernel and fdt start address in virt.c, and pass them to KVM
> when cpu reset. In addition, add kvm_riscv.h to place riscv specific
> interface.

This doesn't seem right. Why do we need to do this? Other
architectures don't seem to do this.

Writing to the CPU from the board like this looks fishy and probably
breaks some QOM rules.

Alistair

>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
> ---
>  hw/riscv/virt.c          |  8 ++++++++
>  target/riscv/cpu.c       |  4 ++++
>  target/riscv/cpu.h       |  3 +++
>  target/riscv/kvm.c       | 15 +++++++++++++++
>  target/riscv/kvm_riscv.h | 24 ++++++++++++++++++++++++
>  5 files changed, 54 insertions(+)
>  create mode 100644 target/riscv/kvm_riscv.h
>
> diff --git a/hw/riscv/virt.c b/hw/riscv/virt.c
> index 25cea7aa67..47b7018193 100644
> --- a/hw/riscv/virt.c
> +++ b/hw/riscv/virt.c
> @@ -42,6 +42,7 @@
>  #include "sysemu/sysemu.h"
>  #include "hw/pci/pci.h"
>  #include "hw/pci-host/gpex.h"
> +#include "sysemu/kvm.h"
>
>  #if defined(TARGET_RISCV32)
>  # define BIOS_FILENAME "opensbi-riscv32-generic-fw_dynamic.bin"
> @@ -511,6 +512,7 @@ static void virt_machine_init(MachineState *machine)
>      uint64_t kernel_entry;
>      DeviceState *mmio_plic, *virtio_plic, *pcie_plic;
>      int i, j, base_hartid, hart_count;
> +    CPUState *cs;
>
>      /* Check socket count limit */
>      if (VIRT_SOCKETS_MAX < riscv_socket_count(machine)) {
> @@ -660,6 +662,12 @@ static void virt_machine_init(MachineState *machine)
>                                virt_memmap[VIRT_MROM].size, kernel_entry,
>                                fdt_load_addr, s->fdt);
>
> +    for (cs = first_cpu; cs; cs = CPU_NEXT(cs)) {
> +        RISCVCPU *riscv_cpu = RISCV_CPU(cs);
> +        riscv_cpu->env.kernel_addr = kernel_entry;
> +        riscv_cpu->env.fdt_addr = fdt_load_addr;
> +    }
> +
>      /* SiFive Test MMIO device */
>      sifive_test_create(memmap[VIRT_TEST].base);
>
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index 6a0264fc6b..faee98a58c 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -29,6 +29,7 @@
>  #include "hw/qdev-properties.h"
>  #include "migration/vmstate.h"
>  #include "fpu/softfloat-helpers.h"
> +#include "kvm_riscv.h"
>
>  /* RISC-V CPU definitions */
>
> @@ -330,6 +331,9 @@ static void riscv_cpu_reset(DeviceState *dev)
>      cs->exception_index = EXCP_NONE;
>      env->load_res = -1;
>      set_default_nan_mode(1, &env->fp_status);
> +#ifdef CONFIG_KVM
> +    kvm_riscv_reset_vcpu(cpu);
> +#endif
>  }
>
>  static void riscv_cpu_disas_set_info(CPUState *s, disassemble_info *info)
> diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
> index c0a326c843..ad1c90f798 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -233,6 +233,9 @@ struct CPURISCVState {
>
>      /* Fields from here on are preserved across CPU reset. */
>      QEMUTimer *timer; /* Internal timer */
> +
> +    hwaddr kernel_addr;
> +    hwaddr fdt_addr;
>  };
>
>  OBJECT_DECLARE_TYPE(RISCVCPU, RISCVCPUClass,
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 8b206ce99c..6250ca0c7d 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -37,6 +37,7 @@
>  #include "hw/irq.h"
>  #include "qemu/log.h"
>  #include "hw/loader.h"
> +#include "kvm_riscv.h"
>
>  static __u64 kvm_riscv_reg_id(__u64 type, __u64 idx)
>  {
> @@ -439,3 +440,17 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>  {
>      return 0;
>  }
> +
> +void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
> +{
> +    CPURISCVState *env = &cpu->env;
> +
> +    if (!kvm_enabled()) {
> +        return;
> +    }
> +    env->pc = cpu->env.kernel_addr;
> +    env->gpr[10] = kvm_arch_vcpu_id(CPU(cpu)); /* a0 */
> +    env->gpr[11] = cpu->env.fdt_addr;          /* a1 */
> +    env->satp = 0;
> +}
> +
> diff --git a/target/riscv/kvm_riscv.h b/target/riscv/kvm_riscv.h
> new file mode 100644
> index 0000000000..f38c82bf59
> --- /dev/null
> +++ b/target/riscv/kvm_riscv.h
> @@ -0,0 +1,24 @@
> +/*
> + * QEMU KVM support -- RISC-V specific functions.
> + *
> + * Copyright (c) 2020 Huawei Technologies Co., Ltd
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2 or later, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef QEMU_KVM_RISCV_H
> +#define QEMU_KVM_RISCV_H
> +
> +void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
> +
> +#endif
> --
> 2.19.1
>
>
