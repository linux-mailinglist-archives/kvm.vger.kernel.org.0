Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C52635FE09
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 00:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbhDNWtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 18:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbhDNWtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 18:49:35 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D363C061574
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 15:49:13 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id z5so470247ioc.13
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 15:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v0pJYLlF6YOApix+n8s7zuXLZ2kGFaoH1PWZh72T0Ac=;
        b=aqnzhNIT/ZTSxS9BeISJ8upD/Rm+4jMEDKClNsH5dJ3xTaC38bVX/edw3umL3SUYj0
         vP/DfrsddoJMQowXhBSldiwAQioicapnG6zz4gCOLvKx0Rz0XTeSuTxZFvKYJLICWNEV
         wUMCqfliAl+DcBYGoz3L2kxwGewiSPmdEguf+rAXpzinO4un4zMYyBfY7tX0x5kid7hK
         kTIcW9g0Mh+ZRJFSSYy89XKAOsbWu2B5KNw8SF3VDXVAEvXlm1dI0tc1GXW6VJrCIjCH
         4AodO27hftRlwH6v7a847ptgNpQuifsQO8mP//3ztC409I+xKBSG0hqdf+gTL4uIgjvK
         YNgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v0pJYLlF6YOApix+n8s7zuXLZ2kGFaoH1PWZh72T0Ac=;
        b=QoVnFWOrNzAIUUBMxLvL0ywLZCuUx2cXCjZTpSa83RNHAoxAjbWzXjdZP0SCNqpxnc
         NXxqv9K/g5XDuEnOhxC2RGOwCYHPUJ5eDMYKVjJw8UnsT7oi4xQu5tDPw0aBtHMkbLvL
         v23u9bRL5yWH0NpMZ9sZsuiASwIKWzShru3BJKSdo/popwdkY4IAWUzVA8c0C6vKeugc
         iUOcpRrhjITJ6t0N8tzxB8JdTRs6cphErRsk1hma6qZjPpQesl/1lhwBmFQZ++WalSYD
         otKsxB40lLmqTnJb+re9n2W5j04TpKE04rH/ljON9DgQWmY0cs55LL/5dBL8E2B3jJma
         VMnw==
X-Gm-Message-State: AOAM5301fZoKM6iRiMkzbce+6k1xP1r7Bx/nt2of6QqgMfBkiWxOWYDF
        XJcbMP3906ZsLxPyZFOehtNxSnEd+Ln3Ai0Gcec=
X-Google-Smtp-Source: ABdhPJxo0HaTopqlwC5lqitFLLkshowO4Cdd8NCv0HWVdQVRDT7YFncYC0PcZG2bA+9t8zZ0T56oJy1XJui3JN7NZGs=
X-Received: by 2002:a5d:878e:: with SMTP id f14mr310687ion.176.1618440552997;
 Wed, 14 Apr 2021 15:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210412065246.1853-1-jiangyifei@huawei.com> <20210412065246.1853-7-jiangyifei@huawei.com>
In-Reply-To: <20210412065246.1853-7-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Thu, 15 Apr 2021 08:48:46 +1000
Message-ID: <CAKmqyKOJ1GSNbDV_6ybBCfkUKRVcs1TFwDr6L63g3ZacV6iRmg@mail.gmail.com>
Subject: Re: [PATCH RFC v5 06/12] target/riscv: Support start kernel directly
 by KVM
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        Bin Meng <bin.meng@windriver.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Anup Patel <anup.patel@wdc.com>,
        yinyipeng <yinyipeng1@huawei.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>,
        fanliang@huawei.com, "Wubin (H)" <wu.wubin@huawei.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 4:56 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Get kernel and fdt start address in virt.c, and pass them to KVM
> when cpu reset. In addition, add kvm_riscv.h to place riscv specific
> interface.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  hw/riscv/boot.c          | 11 +++++++++++
>  hw/riscv/virt.c          |  7 +++++++
>  include/hw/riscv/boot.h  |  1 +
>  target/riscv/cpu.c       |  8 ++++++++
>  target/riscv/cpu.h       |  3 +++
>  target/riscv/kvm-stub.c  | 25 +++++++++++++++++++++++++
>  target/riscv/kvm.c       | 13 +++++++++++++
>  target/riscv/kvm_riscv.h | 24 ++++++++++++++++++++++++
>  target/riscv/meson.build |  2 +-
>  9 files changed, 93 insertions(+), 1 deletion(-)
>  create mode 100644 target/riscv/kvm-stub.c
>  create mode 100644 target/riscv/kvm_riscv.h
>
> diff --git a/hw/riscv/boot.c b/hw/riscv/boot.c
> index 0d38bb7426..b9741a647d 100644
> --- a/hw/riscv/boot.c
> +++ b/hw/riscv/boot.c
> @@ -290,3 +290,14 @@ void riscv_setup_rom_reset_vec(MachineState *machine, RISCVHartArrayState *harts
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
> index c0dc69ff33..4a1fca139c 100644
> --- a/hw/riscv/virt.c
> +++ b/hw/riscv/virt.c
> @@ -728,6 +728,13 @@ static void virt_machine_init(MachineState *machine)
>                                virt_memmap[VIRT_MROM].size, kernel_entry,
>                                fdt_load_addr, machine->fdt);
>
> +    /*
> +     * Only direct boot kernel is currently supported for KVM VM,
> +     * So here setup kernel start address and fdt address.
> +     * TODO:Support firmware loading and integrate to TCG start
> +     */
> +    riscv_setup_direct_kernel(kernel_entry, fdt_load_addr);
> +
>      /* SiFive Test MMIO device */
>      sifive_test_create(memmap[VIRT_TEST].base);
>
> diff --git a/include/hw/riscv/boot.h b/include/hw/riscv/boot.h
> index 11a21dd584..28d838cc29 100644
> --- a/include/hw/riscv/boot.h
> +++ b/include/hw/riscv/boot.h
> @@ -51,5 +51,6 @@ void riscv_rom_copy_firmware_info(MachineState *machine, hwaddr rom_base,
>                                    hwaddr rom_size,
>                                    uint32_t reset_vec_size,
>                                    uint64_t kernel_entry);
> +void riscv_setup_direct_kernel(hwaddr kernel_addr, hwaddr fdt_addr);
>
>  #endif /* RISCV_BOOT_H */
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index 7d6ed80f6b..dd34ab4978 100644
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
> @@ -361,6 +363,12 @@ static void riscv_cpu_reset(DeviceState *dev)
>      cs->exception_index = EXCP_NONE;
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
> index 0a33d387ba..a489d94187 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -243,6 +243,9 @@ struct CPURISCVState {
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
> index 9d1441952a..79c931acb4 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -37,6 +37,7 @@
>  #include "hw/irq.h"
>  #include "qemu/log.h"
>  #include "hw/loader.h"
> +#include "kvm_riscv.h"
>
>  static __u64 kvm_riscv_reg_id(CPURISCVState *env, __u64 type, __u64 idx)
>  {
> @@ -440,6 +441,18 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
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
> index 32afd6e882..0f63e3824d 100644
> --- a/target/riscv/meson.build
> +++ b/target/riscv/meson.build
> @@ -23,7 +23,7 @@ riscv_ss.add(files(
>    'vector_helper.c',
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
