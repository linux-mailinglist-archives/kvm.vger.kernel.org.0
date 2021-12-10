Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF6646FE51
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 11:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbhLJKEG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 10 Dec 2021 05:04:06 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29117 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhLJKEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 05:04:05 -0500
Received: from canpemm100008.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J9RCh2tcvz1DK8V;
        Fri, 10 Dec 2021 17:57:36 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 canpemm100008.china.huawei.com (7.192.104.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 18:00:29 +0800
Received: from kwepemm600017.china.huawei.com ([7.193.23.234]) by
 kwepemm600017.china.huawei.com ([7.193.23.234]) with mapi id 15.01.2308.020;
 Fri, 10 Dec 2021 18:00:29 +0800
From:   Jiangyifei <jiangyifei@huawei.com>
To:     Anup Patel <anup@brainfault.org>
CC:     QEMU Developers <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        KVM General <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        "Fanliang (EulerOS)" <fanliang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>,
        "wanbo (G)" <wanbo13@huawei.com>,
        "limingwang (A)" <limingwang@huawei.com>
Subject: RE: [PATCH v1 06/12] target/riscv: Support start kernel directly by
 KVM
Thread-Topic: [PATCH v1 06/12] target/riscv: Support start kernel directly by
 KVM
Thread-Index: AQHX3eLNsKdHnPfBGEyf744y/i/qHawf3NCAgAvAilA=
Date:   Fri, 10 Dec 2021 10:00:28 +0000
Message-ID: <f399e2a21c574cfaab27275fbfdc0915@huawei.com>
References: <20211120074644.729-1-jiangyifei@huawei.com>
 <20211120074644.729-7-jiangyifei@huawei.com>
 <CAAhSdy2Og53cfF6=ae1kLycLgj9O_2FnYp=BExEGYs7uQeSxow@mail.gmail.com>
In-Reply-To: <CAAhSdy2Og53cfF6=ae1kLycLgj9O_2FnYp=BExEGYs7uQeSxow@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.186.236]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> -----Original Message-----
> From: kvm-riscv [mailto:kvm-riscv-bounces@lists.infradead.org] On Behalf Of
> Anup Patel
> Sent: Friday, December 3, 2021 2:31 PM
> To: Jiangyifei <jiangyifei@huawei.com>
> Cc: QEMU Developers <qemu-devel@nongnu.org>; open list:RISC-V
> <qemu-riscv@nongnu.org>; kvm-riscv@lists.infradead.org; KVM General
> <kvm@vger.kernel.org>; libvir-list@redhat.com; Anup Patel
> <anup.patel@wdc.com>; Palmer Dabbelt <palmer@dabbelt.com>; Alistair
> Francis <Alistair.Francis@wdc.com>; Bin Meng <bin.meng@windriver.com>;
> Fanliang (EulerOS) <fanliang@huawei.com>; Wubin (H)
> <wu.wubin@huawei.com>; Wanghaibin (D) <wanghaibin.wang@huawei.com>;
> wanbo (G) <wanbo13@huawei.com>; limingwang (A)
> <limingwang@huawei.com>
> Subject: Re: [PATCH v1 06/12] target/riscv: Support start kernel directly by KVM
> 
> On Sat, Nov 20, 2021 at 1:17 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
> >
> > Get kernel and fdt start address in virt.c, and pass them to KVM when
> > cpu reset. In addition, add kvm_riscv.h to place riscv specific
> > interface.
> >
> > Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> > Signed-off-by: Mingwang Li <limingwang@huawei.com>
> > Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
> > ---
> >  hw/riscv/boot.c          | 11 +++++++++++
> >  hw/riscv/virt.c          |  7 +++++++
> >  include/hw/riscv/boot.h  |  1 +
> >  target/riscv/cpu.c       |  8 ++++++++
> >  target/riscv/cpu.h       |  3 +++
> >  target/riscv/kvm-stub.c  | 25 +++++++++++++++++++++++++
> >  target/riscv/kvm.c       | 14 ++++++++++++++
> >  target/riscv/kvm_riscv.h | 24 ++++++++++++++++++++++++
> > target/riscv/meson.build |  2 +-
> >  9 files changed, 94 insertions(+), 1 deletion(-)  create mode 100644
> > target/riscv/kvm-stub.c  create mode 100644 target/riscv/kvm_riscv.h
> >
> > diff --git a/hw/riscv/boot.c b/hw/riscv/boot.c index
> > 519fa455a1..00df6d7810 100644
> > --- a/hw/riscv/boot.c
> > +++ b/hw/riscv/boot.c
> > @@ -317,3 +317,14 @@ void riscv_setup_rom_reset_vec(MachineState
> > *machine, RISCVHartArrayState *harts
> >
> >      return;
> >  }
> > +
> > +void riscv_setup_direct_kernel(hwaddr kernel_addr, hwaddr fdt_addr) {
> > +    CPUState *cs;
> > +
> > +    for (cs = first_cpu; cs; cs = CPU_NEXT(cs)) {
> > +        RISCVCPU *riscv_cpu = RISCV_CPU(cs);
> > +        riscv_cpu->env.kernel_addr = kernel_addr;
> > +        riscv_cpu->env.fdt_addr = fdt_addr;
> > +    }
> > +}
> > diff --git a/hw/riscv/virt.c b/hw/riscv/virt.c index
> > 3af074148e..e3452b25e8 100644
> > --- a/hw/riscv/virt.c
> > +++ b/hw/riscv/virt.c
> > @@ -941,6 +941,13 @@ static void virt_machine_init(MachineState
> *machine)
> >                                virt_memmap[VIRT_MROM].size,
> kernel_entry,
> >                                fdt_load_addr, machine->fdt);
> >
> > +    /*
> > +     * Only direct boot kernel is currently supported for KVM VM,
> > +     * So here setup kernel start address and fdt address.
> > +     * TODO:Support firmware loading and integrate to TCG start
> > +     */
> > +    riscv_setup_direct_kernel(kernel_entry, fdt_load_addr);
> 
> This should be under "if (kvm_enabled()) {".
> 
> Also, update virt machine such that the "-bios" parameter is ignored and
> treated like "-bios none" when KVM is enabled.
> 

Thanks, it will be modified in the next series.

> Further, virt machine should not create an ACLINT (or SiFive CLINT) instance
> when KVM is enabled. Event the PLIC should be created without M-mode PLIC
> contexts when KVM is enabled.
> 
> Regards,
> Anup
> 

Yes, you are right. But in order to reuse the PLIC, it is not planned to modify the PLIC at this time.

Yifei

> > +
> >      /* SiFive Test MMIO device */
> >      sifive_test_create(memmap[VIRT_TEST].base);
> >
> > diff --git a/include/hw/riscv/boot.h b/include/hw/riscv/boot.h index
> > baff11dd8a..5834c234aa 100644
> > --- a/include/hw/riscv/boot.h
> > +++ b/include/hw/riscv/boot.h
> > @@ -58,5 +58,6 @@ void riscv_rom_copy_firmware_info(MachineState
> *machine, hwaddr rom_base,
> >                                    hwaddr rom_size,
> >                                    uint32_t reset_vec_size,
> >                                    uint64_t kernel_entry);
> > +void riscv_setup_direct_kernel(hwaddr kernel_addr, hwaddr fdt_addr);
> >
> >  #endif /* RISCV_BOOT_H */
> > diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c index
> > f812998123..1c944872a3 100644
> > --- a/target/riscv/cpu.c
> > +++ b/target/riscv/cpu.c
> > @@ -29,6 +29,8 @@
> >  #include "hw/qdev-properties.h"
> >  #include "migration/vmstate.h"
> >  #include "fpu/softfloat-helpers.h"
> > +#include "sysemu/kvm.h"
> > +#include "kvm_riscv.h"
> >
> >  /* RISC-V CPU definitions */
> >
> > @@ -380,6 +382,12 @@ static void riscv_cpu_reset(DeviceState *dev)
> >      cs->exception_index = RISCV_EXCP_NONE;
> >      env->load_res = -1;
> >      set_default_nan_mode(1, &env->fp_status);
> > +
> > +#ifndef CONFIG_USER_ONLY
> > +    if (kvm_enabled()) {
> > +        kvm_riscv_reset_vcpu(cpu);
> > +    }
> > +#endif
> >  }
> >
> >  static void riscv_cpu_disas_set_info(CPUState *s, disassemble_info
> > *info) diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h index
> > 0760c0af93..2807eb1bcb 100644
> > --- a/target/riscv/cpu.h
> > +++ b/target/riscv/cpu.h
> > @@ -255,6 +255,9 @@ struct CPURISCVState {
> >
> >      /* Fields from here on are preserved across CPU reset. */
> >      QEMUTimer *timer; /* Internal timer */
> > +
> > +    hwaddr kernel_addr;
> > +    hwaddr fdt_addr;
> >  };
> >
> >  OBJECT_DECLARE_TYPE(RISCVCPU, RISCVCPUClass, diff --git
> > a/target/riscv/kvm-stub.c b/target/riscv/kvm-stub.c new file mode
> > 100644 index 0000000000..39b96fe3f4
> > --- /dev/null
> > +++ b/target/riscv/kvm-stub.c
> > @@ -0,0 +1,25 @@
> > +/*
> > + * QEMU KVM RISC-V specific function stubs
> > + *
> > + * Copyright (c) 2020 Huawei Technologies Co., Ltd
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2 or later, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but
> > +WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY
> > +or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
> > +License for
> > + * more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > +along with
> > + * this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +#include "qemu/osdep.h"
> > +#include "cpu.h"
> > +#include "kvm_riscv.h"
> > +
> > +void kvm_riscv_reset_vcpu(RISCVCPU *cpu) {
> > +    abort();
> > +}
> > diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c index
> > 5fe5ca4434..7f3ffcc2b4 100644
> > --- a/target/riscv/kvm.c
> > +++ b/target/riscv/kvm.c
> > @@ -37,6 +37,7 @@
> >  #include "hw/irq.h"
> >  #include "qemu/log.h"
> >  #include "hw/loader.h"
> > +#include "kvm_riscv.h"
> >
> >  static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type,
> > uint64_t idx)  { @@ -444,6 +445,19 @@ int
> > kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
> >      return 0;
> >  }
> >
> > +void kvm_riscv_reset_vcpu(RISCVCPU *cpu) {
> > +    CPURISCVState *env = &cpu->env;
> > +
> > +    if (!kvm_enabled()) {
> > +        return;
> > +    }
> > +    env->pc = cpu->env.kernel_addr;
> > +    env->gpr[10] = kvm_arch_vcpu_id(CPU(cpu)); /* a0 */
> > +    env->gpr[11] = cpu->env.fdt_addr;          /* a1 */
> > +    env->satp = 0;
> > +}
> > +
> >  bool kvm_arch_cpu_check_are_resettable(void)
> >  {
> >      return true;
> > diff --git a/target/riscv/kvm_riscv.h b/target/riscv/kvm_riscv.h new
> > file mode 100644 index 0000000000..f38c82bf59
> > --- /dev/null
> > +++ b/target/riscv/kvm_riscv.h
> > @@ -0,0 +1,24 @@
> > +/*
> > + * QEMU KVM support -- RISC-V specific functions.
> > + *
> > + * Copyright (c) 2020 Huawei Technologies Co., Ltd
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2 or later, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but
> > +WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY
> > +or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
> > +License for
> > + * more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > +along with
> > + * this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#ifndef QEMU_KVM_RISCV_H
> > +#define QEMU_KVM_RISCV_H
> > +
> > +void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
> > +
> > +#endif
> > diff --git a/target/riscv/meson.build b/target/riscv/meson.build index
> > 2faf08a941..fe41cc5805 100644
> > --- a/target/riscv/meson.build
> > +++ b/target/riscv/meson.build
> > @@ -19,7 +19,7 @@ riscv_ss.add(files(
> >    'bitmanip_helper.c',
> >    'translate.c',
> >  ))
> > -riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
> > +riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false:
> > +files('kvm-stub.c'))
> >
> >  riscv_softmmu_ss = ss.source_set()
> >  riscv_softmmu_ss.add(files(
> > --
> > 2.19.1
> >
> >
> > --
> > kvm-riscv mailing list
> > kvm-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kvm-riscv
> 
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
