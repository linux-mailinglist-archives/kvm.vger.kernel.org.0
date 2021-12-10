Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B492C46FE4A
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239744AbhLJKBU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 10 Dec 2021 05:01:20 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16360 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239747AbhLJKBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 05:01:19 -0500
Received: from canpemm100005.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J9RC31fXNz92xw;
        Fri, 10 Dec 2021 17:57:03 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 canpemm100005.china.huawei.com (7.192.105.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 17:57:43 +0800
Received: from kwepemm600017.china.huawei.com ([7.193.23.234]) by
 kwepemm600017.china.huawei.com ([7.193.23.234]) with mapi id 15.01.2308.020;
 Fri, 10 Dec 2021 17:57:42 +0800
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
Subject: RE: [PATCH v1 04/12] target/riscv: Implement kvm_arch_get_registers
Thread-Topic: [PATCH v1 04/12] target/riscv: Implement kvm_arch_get_registers
Thread-Index: AQHX3eLLjNdjzYP2iE6AIP7NO6R7r6wf2ceAgAvDAxA=
Date:   Fri, 10 Dec 2021 09:57:42 +0000
Message-ID: <7d88cc865bcc4dada21cfe09d9665d73@huawei.com>
References: <20211120074644.729-1-jiangyifei@huawei.com>
 <20211120074644.729-5-jiangyifei@huawei.com>
 <CAAhSdy2gFufV4Xuu9Ewn2htLRB8SZ+xohbAnjYmnM1D_xMQP4A@mail.gmail.com>
In-Reply-To: <CAAhSdy2gFufV4Xuu9Ewn2htLRB8SZ+xohbAnjYmnM1D_xMQP4A@mail.gmail.com>
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
> Sent: Friday, December 3, 2021 2:20 PM
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
> Subject: Re: [PATCH v1 04/12] target/riscv: Implement kvm_arch_get_registers
> 
> On Sat, Nov 20, 2021 at 1:17 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
> >
> > Get GPR CSR and FP registers from kvm by KVM_GET_ONE_REG ioctl.
> >
> > Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> > Signed-off-by: Mingwang Li <limingwang@huawei.com>
> > Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
> > ---
> >  target/riscv/kvm.c | 150
> > ++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 149 insertions(+), 1 deletion(-)
> >
> > diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c index
> > 9f9692fb9e..b49c24be0a 100644
> > --- a/target/riscv/kvm.c
> > +++ b/target/riscv/kvm.c
> > @@ -55,13 +55,161 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState
> *env, uint64_t type, uint64_t idx
> >      return id;
> >  }
> >
> > +#define RISCV_CORE_REG(env, name)  kvm_riscv_reg_id(env,
> KVM_REG_RISCV_CORE, \
> > +                 KVM_REG_RISCV_CORE_REG(name))
> > +
> > +#define RISCV_CSR_REG(env, name)  kvm_riscv_reg_id(env,
> KVM_REG_RISCV_CSR, \
> > +                 KVM_REG_RISCV_CSR_REG(name))
> > +
> > +#define RISCV_FP_F_REG(env, idx)  kvm_riscv_reg_id(env,
> > +KVM_REG_RISCV_FP_F, idx)
> > +
> > +#define RISCV_FP_D_REG(env, idx)  kvm_riscv_reg_id(env,
> > +KVM_REG_RISCV_FP_D, idx)
> > +
> > +static int kvm_riscv_get_regs_core(CPUState *cs) {
> > +    int ret = 0;
> > +    int i;
> > +    target_ulong reg;
> > +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> > +
> > +    ret = kvm_get_one_reg(cs, RISCV_CORE_REG(env, regs.pc), &reg);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +    env->pc = reg;
> > +
> > +    for (i = 1; i < 32; i++) {
> > +        uint64_t id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CORE, i);
> > +        ret = kvm_get_one_reg(cs, id, &reg);
> > +        if (ret) {
> > +            return ret;
> > +        }
> > +        env->gpr[i] = reg;
> > +    }
> > +
> > +    return ret;
> > +}
> > +
> > +static int kvm_riscv_get_regs_csr(CPUState *cs) {
> > +    int ret = 0;
> > +    target_ulong reg;
> > +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> > +
> > +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sstatus), &reg);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +    env->mstatus = reg;
> > +
> > +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sie), &reg);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +    env->mie = reg;
> > +
> > +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, stvec), &reg);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +    env->stvec = reg;
> > +
> > +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sscratch), &reg);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +    env->sscratch = reg;
> > +
> > +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sepc), &reg);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +    env->sepc = reg;
> > +
> > +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, scause), &reg);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +    env->scause = reg;
> > +
> > +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, stval), &reg);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +    env->stval = reg;
> > +
> > +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sip), &reg);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +    env->mip = reg;
> > +
> > +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, satp), &reg);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +    env->satp = reg;
> 
> There is a common pattern in above kvm_get_one_reg() calls so I suggest
> creating a macro for repeating code patterns. This can help us to have one line
> for each CSR and in future it is easy to add more CSRs.
> 
> Regards,
> Anup
> 

Thanks, it will be modified in the next series.

Yifei

> > +
> > +    return ret;
> > +}
> > +
> > +static int kvm_riscv_get_regs_fp(CPUState *cs) {
> > +    int ret = 0;
> > +    int i;
> > +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> > +
> > +    if (riscv_has_ext(env, RVD)) {
> > +        uint64_t reg;
> > +        for (i = 0; i < 32; i++) {
> > +            ret = kvm_get_one_reg(cs, RISCV_FP_D_REG(env, i), &reg);
> > +            if (ret) {
> > +                return ret;
> > +            }
> > +            env->fpr[i] = reg;
> > +        }
> > +        return ret;
> > +    }
> > +
> > +    if (riscv_has_ext(env, RVF)) {
> > +        uint32_t reg;
> > +        for (i = 0; i < 32; i++) {
> > +            ret = kvm_get_one_reg(cs, RISCV_FP_F_REG(env, i), &reg);
> > +            if (ret) {
> > +                return ret;
> > +            }
> > +            env->fpr[i] = reg;
> > +        }
> > +        return ret;
> > +    }
> > +
> > +    return ret;
> > +}
> > +
> >  const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
> >      KVM_CAP_LAST_INFO
> >  };
> >
> >  int kvm_arch_get_registers(CPUState *cs)  {
> > -    return 0;
> > +    int ret = 0;
> > +
> > +    ret = kvm_riscv_get_regs_core(cs);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +
> > +    ret = kvm_riscv_get_regs_csr(cs);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +
> > +    ret = kvm_riscv_get_regs_fp(cs);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +
> > +    return ret;
> >  }
> >
> >  int kvm_arch_put_registers(CPUState *cs, int level)
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
