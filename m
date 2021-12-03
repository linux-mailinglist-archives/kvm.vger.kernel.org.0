Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CAF4671E5
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 07:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378585AbhLCGem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 01:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378580AbhLCGem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 01:34:42 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EF1C06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 22:31:18 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o19-20020a1c7513000000b0033a93202467so1433083wmc.2
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 22:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NUeDWeVKMCgJuLKXF06ITqHnLEW5KX5WSXXCDwgBX18=;
        b=If/gm/2gXH9mxzZrpsN7cIzTzRVyO7nRlOKN4W6WKMDH8J8PS/jEs/GBGhOz2GYFpQ
         OWQnqOtSh2KF5Uk4XF/IdN62ZaVNiRshRCJhnDyLaw0Ze4WFJrXY3j69ZTj41G3u/xoz
         CMcvdntzrLISdby30V20KVXkxoFpl+VUuHjaTqXyqb8ufrXMwuS5rl32ejyIw/rTbsCN
         aCDMA2HA/CT1XaaFoPAVQfwItu9DyOgTuk47bz/49xnHrhy5cCfl5j5oybBPm3+rCIYI
         UOjv1R4SINZG5k7XLRfUjYGeTeN9cfZOHuVGXBMAncWuliBrAJ27fTM2noSSb3ntUW5W
         117Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NUeDWeVKMCgJuLKXF06ITqHnLEW5KX5WSXXCDwgBX18=;
        b=EXx+8HiBQz1LYNvle8FuqrkpUQGfaO2cfQHPNmRGvgjS41Tcigd2U2gAguhwc66ZsJ
         3lC2m72lUcxYCOCWZ3oOViK5DAXuat5BAbVMnovVrqI4eNynQ7RVEeTjjcXZFMaSrF+K
         pMOgtnGZm0NzCx2iBkvmtfZ4hKeaBnJuV5MkglFn64oGlNuciaaNdCrUzsvGGo+X8voQ
         Rf41GAo5PM535COoyQxAF1FEmkr2giWEBCWLl0MD4zsd+k/2bzXBB31PTsBn41pu0ejM
         07bpHNVaGygvP73nD3/tXwG3hb7AMYuIpjyD3OkD3zgv1q7hYR4GvTCT+67kHep++4bN
         VK1w==
X-Gm-Message-State: AOAM530L98K2uMR9NgoSsgEMewY1CukkTwkB6JNiu1PkXqbSxfrgo+AB
        C7NxVsiFv7CinlQA+L2/6e5f9gHHE2B9RL0iayC5SA==
X-Google-Smtp-Source: ABdhPJzuo/qfQ8FYuF2CVUsouuLpfzY4nRbEFbIOAxKArRkMugn1287YbUgbu3iu5x/8vAbf4clHGIN/8vr26dXNGZ4=
X-Received: by 2002:a7b:c017:: with SMTP id c23mr12428573wmb.137.1638513076499;
 Thu, 02 Dec 2021 22:31:16 -0800 (PST)
MIME-Version: 1.0
References: <20211120074644.729-1-jiangyifei@huawei.com> <20211120074644.729-7-jiangyifei@huawei.com>
In-Reply-To: <20211120074644.729-7-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 3 Dec 2021 12:01:05 +0530
Message-ID: <CAAhSdy2Og53cfF6=ae1kLycLgj9O_2FnYp=BExEGYs7uQeSxow@mail.gmail.com>
Subject: Re: [PATCH v1 06/12] target/riscv: Support start kernel directly by KVM
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        libvir-list@redhat.com, Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>, wanghaibin.wang@huawei.com,
        wanbo13@huawei.com, Mingwang Li <limingwang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 20, 2021 at 1:17 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Get kernel and fdt start address in virt.c, and pass them to KVM
> when cpu reset. In addition, add kvm_riscv.h to place riscv specific
> interface.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
> ---
>  hw/riscv/boot.c          | 11 +++++++++++
>  hw/riscv/virt.c          |  7 +++++++
>  include/hw/riscv/boot.h  |  1 +
>  target/riscv/cpu.c       |  8 ++++++++
>  target/riscv/cpu.h       |  3 +++
>  target/riscv/kvm-stub.c  | 25 +++++++++++++++++++++++++
>  target/riscv/kvm.c       | 14 ++++++++++++++
>  target/riscv/kvm_riscv.h | 24 ++++++++++++++++++++++++
>  target/riscv/meson.build |  2 +-
>  9 files changed, 94 insertions(+), 1 deletion(-)
>  create mode 100644 target/riscv/kvm-stub.c
>  create mode 100644 target/riscv/kvm_riscv.h
>
> diff --git a/hw/riscv/boot.c b/hw/riscv/boot.c
> index 519fa455a1..00df6d7810 100644
> --- a/hw/riscv/boot.c
> +++ b/hw/riscv/boot.c
> @@ -317,3 +317,14 @@ void riscv_setup_rom_reset_vec(MachineState *machine, RISCVHartArrayState *harts
>
>      return;
>  }
> +
> +void riscv_setup_direct_kernel(hwaddr kernel_addr, hwaddr fdt_addr)
> +{
> +    CPUState *cs;
> +
> +    for (cs = first_cpu; cs; cs = CPU_NEXT(cs)) {
> +        RISCVCPU *riscv_cpu = RISCV_CPU(cs);
> +        riscv_cpu->env.kernel_addr = kernel_addr;
> +        riscv_cpu->env.fdt_addr = fdt_addr;
> +    }
> +}
> diff --git a/hw/riscv/virt.c b/hw/riscv/virt.c
> index 3af074148e..e3452b25e8 100644
> --- a/hw/riscv/virt.c
> +++ b/hw/riscv/virt.c
> @@ -941,6 +941,13 @@ static void virt_machine_init(MachineState *machine)
>                                virt_memmap[VIRT_MROM].size, kernel_entry,
>                                fdt_load_addr, machine->fdt);
>
> +    /*
> +     * Only direct boot kernel is currently supported for KVM VM,
> +     * So here setup kernel start address and fdt address.
> +     * TODO:Support firmware loading and integrate to TCG start
> +     */
> +    riscv_setup_direct_kernel(kernel_entry, fdt_load_addr);

This should be under "if (kvm_enabled()) {".

Also, update virt machine such that the "-bios" parameter is ignored
and treated like "-bios none" when KVM is enabled.

Further, virt machine should not create an ACLINT (or SiFive CLINT)
instance when KVM is enabled. Event the PLIC should be created
without M-mode PLIC contexts when KVM is enabled.

Regards,
Anup

> +
>      /* SiFive Test MMIO device */
>      sifive_test_create(memmap[VIRT_TEST].base);
>
> diff --git a/include/hw/riscv/boot.h b/include/hw/riscv/boot.h
> index baff11dd8a..5834c234aa 100644
> --- a/include/hw/riscv/boot.h
> +++ b/include/hw/riscv/boot.h
> @@ -58,5 +58,6 @@ void riscv_rom_copy_firmware_info(MachineState *machine, hwaddr rom_base,
>                                    hwaddr rom_size,
>                                    uint32_t reset_vec_size,
>                                    uint64_t kernel_entry);
> +void riscv_setup_direct_kernel(hwaddr kernel_addr, hwaddr fdt_addr);
>
>  #endif /* RISCV_BOOT_H */
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index f812998123..1c944872a3 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -29,6 +29,8 @@
>  #include "hw/qdev-properties.h"
>  #include "migration/vmstate.h"
>  #include "fpu/softfloat-helpers.h"
> +#include "sysemu/kvm.h"
> +#include "kvm_riscv.h"
>
>  /* RISC-V CPU definitions */
>
> @@ -380,6 +382,12 @@ static void riscv_cpu_reset(DeviceState *dev)
>      cs->exception_index = RISCV_EXCP_NONE;
>      env->load_res = -1;
>      set_default_nan_mode(1, &env->fp_status);
> +
> +#ifndef CONFIG_USER_ONLY
> +    if (kvm_enabled()) {
> +        kvm_riscv_reset_vcpu(cpu);
> +    }
> +#endif
>  }
>
>  static void riscv_cpu_disas_set_info(CPUState *s, disassemble_info *info)
> diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
> index 0760c0af93..2807eb1bcb 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -255,6 +255,9 @@ struct CPURISCVState {
>
>      /* Fields from here on are preserved across CPU reset. */
>      QEMUTimer *timer; /* Internal timer */
> +
> +    hwaddr kernel_addr;
> +    hwaddr fdt_addr;
>  };
>
>  OBJECT_DECLARE_TYPE(RISCVCPU, RISCVCPUClass,
> diff --git a/target/riscv/kvm-stub.c b/target/riscv/kvm-stub.c
> new file mode 100644
> index 0000000000..39b96fe3f4
> --- /dev/null
> +++ b/target/riscv/kvm-stub.c
> @@ -0,0 +1,25 @@
> +/*
> + * QEMU KVM RISC-V specific function stubs
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
> +#include "qemu/osdep.h"
> +#include "cpu.h"
> +#include "kvm_riscv.h"
> +
> +void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
> +{
> +    abort();
> +}
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 5fe5ca4434..7f3ffcc2b4 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -37,6 +37,7 @@
>  #include "hw/irq.h"
>  #include "qemu/log.h"
>  #include "hw/loader.h"
> +#include "kvm_riscv.h"
>
>  static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
>  {
> @@ -444,6 +445,19 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>      return 0;
>  }
>
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
>  bool kvm_arch_cpu_check_are_resettable(void)
>  {
>      return true;
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
> diff --git a/target/riscv/meson.build b/target/riscv/meson.build
> index 2faf08a941..fe41cc5805 100644
> --- a/target/riscv/meson.build
> +++ b/target/riscv/meson.build
> @@ -19,7 +19,7 @@ riscv_ss.add(files(
>    'bitmanip_helper.c',
>    'translate.c',
>  ))
> -riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
> +riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
>
>  riscv_softmmu_ss = ss.source_set()
>  riscv_softmmu_ss.add(files(
> --
> 2.19.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
