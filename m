Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9424671D2
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 07:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378558AbhLCGX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 01:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbhLCGXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 01:23:49 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC573C06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 22:20:25 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id i8-20020a7bc948000000b0030db7b70b6bso4030459wml.1
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 22:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/3va/pCm2+lgIP7wgFl0KWgrsAldqC5qmmGmCVaaa0s=;
        b=JnV91t9CzVZNp+7ARVQtVb+rHXUwELdxD7AfULeML9AGRKu2COE6kzcQHCuQ93OXKB
         Cw1RF2tp/WbX2/mwkKeyJJZJEMrFOGrkuIEnGynwlXONMdt3pqQhUXPwjdw27V+BYrTp
         2PmEvR/yt65VGKFR62l7EJm0m9RsAurfnWHOOFVEcCA45Unj7FmtDOStwP02k02WzDpY
         pLI9DIDwJQzeC35DcLrfY1wJcrL1kQ+V8cFnWsutKON8xFWR9QbUatJqHbpGMdfduETw
         YLHFwZtRo23pGJHg7OI6RaIIpaC5AA7As97ob2s7zannHlQ/UnV+p/8ARR3oaDqE3STn
         mklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/3va/pCm2+lgIP7wgFl0KWgrsAldqC5qmmGmCVaaa0s=;
        b=n7tfpWCYw/+6qfwS9uSbncchQSxEsP2jn5y/780jo2Earc3waO5VCQcyApGK/+9jP2
         rE0zHqKF0TIFXCc+mXbrS9uIIEuAGB/QqzAgqWd66AWa3WIGi0959zFzUIYeGbRlQceG
         sMVkta2mAP7lo3NhOo4KdDzWHsXIDioCRTO9y5xB4Y+n2jfQh2ICrRUGFskEW0oUy7hl
         Q4LGcpF8DquCoPdIjQENt5BPYgsvvulyPg8ND6EVu3YdE1FXxywwyF1JNtPxyMJBYxz5
         ymZa04N7Qb/GHiRJRd0EXs1E8YqsV6/g7oItgi5MvI9da2DKIP2iYnbz8LRhxJAEdmId
         X1Qw==
X-Gm-Message-State: AOAM53136d7Um3igjFx7BAse+unsAdzSuNtEz+IcxPlAI0S+ursDg6c3
        zdBgReLUWRLOGlzaf2z9xb7TEM6d2SNjP6B8OwucAw==
X-Google-Smtp-Source: ABdhPJz9y1XCwJi9YPIQOYXvTyTFvwc6jUzGcaWbytAXXTrxY6JpkwRLyEwMi7rK2sjwI8sZz+QFIFyB5+yGqcbLSh4=
X-Received: by 2002:a7b:c017:: with SMTP id c23mr12379673wmb.137.1638512424299;
 Thu, 02 Dec 2021 22:20:24 -0800 (PST)
MIME-Version: 1.0
References: <20211120074644.729-1-jiangyifei@huawei.com> <20211120074644.729-5-jiangyifei@huawei.com>
In-Reply-To: <20211120074644.729-5-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 3 Dec 2021 11:50:13 +0530
Message-ID: <CAAhSdy2gFufV4Xuu9Ewn2htLRB8SZ+xohbAnjYmnM1D_xMQP4A@mail.gmail.com>
Subject: Re: [PATCH v1 04/12] target/riscv: Implement kvm_arch_get_registers
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
> Get GPR CSR and FP registers from kvm by KVM_GET_ONE_REG ioctl.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
> ---
>  target/riscv/kvm.c | 150 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 149 insertions(+), 1 deletion(-)
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 9f9692fb9e..b49c24be0a 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -55,13 +55,161 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
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
> +        uint64_t id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CORE, i);
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
> +    env->stval = reg;
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

There is a common pattern in above kvm_get_one_reg() calls so I suggest
creating a macro for repeating code patterns. This can help us to have one
line for each CSR and in future it is easy to add more CSRs.

Regards,
Anup

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
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
