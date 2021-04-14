Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA39C35FDF7
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 00:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbhDNWki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 18:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbhDNWkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 18:40:37 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008CDC061574
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 15:40:15 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id c18so18508698iln.7
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 15:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n7d5Pcc0VNYj7xJiDh9xXCDiQUNA26uEPx/UGxLUN40=;
        b=ua6Sag9BHfyRiKrYpjN1/P7tMimT7WvVKQ1INLqttw5yMrRxxFJIIX6wCCYdvzk33b
         jKrglZ0aHu52HZSuSH3xtYVaSjmmEmvjXSFSX5r0vcY2Lrhy8r2o6J9oK+tvAoPe0eks
         H3W0LenlTtoCoUYa9QpnS6tOda+y30lRJevL1BAwXxFKqhC8R4azUnSJKpFy06dskhhV
         5WELmDUCJp5NV+ocMRQlkha0UvLSsrGJJAhvqI8v/3EzuCg5VQiMu0VAudIy0FEEJ8Fg
         q1OmikIADtLWQDDMzDf7jF1JAs52pKgcFx9+zVs8cFfoaHZ4i6OX2o0kkGO+bXOvE6qE
         WaXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n7d5Pcc0VNYj7xJiDh9xXCDiQUNA26uEPx/UGxLUN40=;
        b=legcRezb6VkJmeOuByvY1pdQj8deIpmOsHyMYBMyFDxLcFrWw1qsWZph8f7R2F9aHz
         Wu+kK92TtI2n40tI0Me0/13j7ea0KPcBWlyeNznEGb/cJy1wvkA3h4KzGg7qRa2s8qEm
         U2mmFFD3CHy6XMatOY5cK+JfzWImTIzStR3aH+FMs9XU7TpAl2u6nvp9djElZhYraxIl
         CV+dhYmFGAKWC/x/i+sa6wjVYCs0+bBuMkpM5dUSXSl5cRt8vofVOArW21ZdLXo2DUGg
         pb3W4zx0dkPPfDeRSQ5oW2AdHNFk2D+bTaPnB5rBrJJZtx9cKHROKJUdXgqIM6zIXXGC
         C5aw==
X-Gm-Message-State: AOAM533odlccZhAG0jb0hr+tICHaxIzIb/7WFOSW/YRa8K7qQlx3H1IF
        lOjPjzQpNWgfnSVCu3QFCE7JpFoUuHbx/h9P+SE=
X-Google-Smtp-Source: ABdhPJz0bHcyFH6loQKbB7SM4wJ2UxXqwZ4IQTDo24LsulLKqareNjVZld6J05qf/+twje9vI0eg82HjMRHuvoPSVkU=
X-Received: by 2002:a92:d90f:: with SMTP id s15mr408088iln.227.1618440015373;
 Wed, 14 Apr 2021 15:40:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210412065246.1853-1-jiangyifei@huawei.com> <20210412065246.1853-5-jiangyifei@huawei.com>
In-Reply-To: <20210412065246.1853-5-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Thu, 15 Apr 2021 08:39:49 +1000
Message-ID: <CAKmqyKPnrhC9c2ek5ZetoHaDHir52ihEKzRCXHioOqMNvnVknQ@mail.gmail.com>
Subject: Re: [PATCH RFC v5 04/12] target/riscv: Implement kvm_arch_get_registers
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

On Mon, Apr 12, 2021 at 4:58 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Get GPR CSR and FP registers from kvm by KVM_GET_ONE_REG ioctl.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  target/riscv/kvm.c | 150 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 149 insertions(+), 1 deletion(-)
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 0d924be33f..63485d7b65 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -50,13 +50,161 @@ static __u64 kvm_riscv_reg_id(CPURISCVState *env, __u64 type, __u64 idx)
>      return id;
>  }
>
> +#define RISCV_CORE_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_CORE, \
> +                 KVM_REG_RISCV_CORE_REG(name))
> +
> +#define RISCV_CSR_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_CSR, \
> +                 KVM_REG_RISCV_CSR_REG(name))
> +
> +#define RISCV_FP_F_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_F, idx)
> +
> +#define RISCV_FP_D_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_D, idx)
> +
> +static int kvm_riscv_get_regs_core(CPUState *cs)
> +{
> +    int ret = 0;
> +    int i;
> +    target_ulong reg;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    ret = kvm_get_one_reg(cs, RISCV_CORE_REG(env, regs.pc), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->pc = reg;
> +
> +    for (i = 1; i < 32; i++) {
> +        __u64 id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CORE, i);
> +        ret = kvm_get_one_reg(cs, id, &reg);
> +        if (ret) {
> +            return ret;
> +        }
> +        env->gpr[i] = reg;
> +    }
> +
> +    return ret;
> +}
> +
> +static int kvm_riscv_get_regs_csr(CPUState *cs)
> +{
> +    int ret = 0;
> +    target_ulong reg;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sstatus), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->mstatus = reg;
> +
> +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sie), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->mie = reg;
> +
> +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, stvec), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->stvec = reg;
> +
> +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sscratch), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->sscratch = reg;
> +
> +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sepc), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->sepc = reg;
> +
> +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, scause), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->scause = reg;
> +
> +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, stval), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->sbadaddr = reg;
> +
> +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sip), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->mip = reg;
> +
> +    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, satp), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->satp = reg;
> +
> +    return ret;
> +}
> +
> +static int kvm_riscv_get_regs_fp(CPUState *cs)
> +{
> +    int ret = 0;
> +    int i;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    if (riscv_has_ext(env, RVD)) {
> +        uint64_t reg;
> +        for (i = 0; i < 32; i++) {
> +            ret = kvm_get_one_reg(cs, RISCV_FP_D_REG(env, i), &reg);
> +            if (ret) {
> +                return ret;
> +            }
> +            env->fpr[i] = reg;
> +        }
> +        return ret;
> +    }
> +
> +    if (riscv_has_ext(env, RVF)) {
> +        uint32_t reg;
> +        for (i = 0; i < 32; i++) {
> +            ret = kvm_get_one_reg(cs, RISCV_FP_F_REG(env, i), &reg);
> +            if (ret) {
> +                return ret;
> +            }
> +            env->fpr[i] = reg;
> +        }
> +        return ret;
> +    }
> +
> +    return ret;
> +}
> +
>  const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>      KVM_CAP_LAST_INFO
>  };
>
>  int kvm_arch_get_registers(CPUState *cs)
>  {
> -    return 0;
> +    int ret = 0;
> +
> +    ret = kvm_riscv_get_regs_core(cs);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    ret = kvm_riscv_get_regs_csr(cs);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    ret = kvm_riscv_get_regs_fp(cs);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    return ret;
>  }
>
>  int kvm_arch_put_registers(CPUState *cs, int level)
> --
> 2.19.1
>
>
