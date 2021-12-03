Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7696A4671D5
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 07:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378565AbhLCGZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 01:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbhLCGZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 01:25:47 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D98FC06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 22:22:23 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d9so3519066wrw.4
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 22:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B8+b5xKsMUDKa+oyyXAeAYgzpjyhIiOxi8EOvVBsToo=;
        b=LbMIA80PU3ifmQ+azi/PlEUXfowc4V2sThUnp3xTk285Mt5ruRy4wVmn3G/+WKUZ2B
         zwpVRFPKHBEjeuvBH6I4+j6/2JNX0Od9FqmV7x9fOCcht5S/dSetRQ6pkA2m69zA07+h
         JFbKoRniDqDlQgemaywApcqiu0OQC3r0XWqbvsuw+rShLGnKDNVTAfueonRqLlevCQTv
         e8fMMMgj6k60rR9AzuJl2jAx/nxmXGTxB9tWDGRagT4VxTRy3AsShpfaaiUvVDikVTmf
         MDmsHSndJxnZIcwH1T3niAe2xGJzihn3K+LBSczQjIeuvAlJBismOr4ZM2Bw0OPm2lbE
         OCbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B8+b5xKsMUDKa+oyyXAeAYgzpjyhIiOxi8EOvVBsToo=;
        b=lCMobuI9ZiN3ZYptG9WisKurh1z0ZYHgR/S8ox+7NYZ2Nn/dNFEZCx0BZQl4Sg2W8s
         pGBWEk0iPZyMaC7Z+EgFw2+NymhM45zBPsYK7WZor4XjaTKldli8Y+YE2YpZt1JpLvfw
         nLQDW+e1ICTvQtxXMMdZ8DMVLsMS1eHUaDiNYf9Ddwd5A/PSj+bf4lpnHA+0Ho487lWL
         NQzca1ms3X9NNJUg2ph8E20AhIO2U2nA2wk5XYC7UDaYEXSd8N7DAq7nwWnsuQlTIy0r
         QP9lUC4TI9XPoV4lJmjcdE3/AndPlJ4RCArEtrJYv8LbqN+0b1NIzLPRfm0oGWoVfWyg
         v/Ew==
X-Gm-Message-State: AOAM5313Ed1x+tdYgU/RwudcwZplFBU7t0DmtN6GcWfrXPXb8ID7FJKH
        FPaNmzUHgX0JKuaRLyphx+Y3uaXMtXVF1o96bpphyA==
X-Google-Smtp-Source: ABdhPJwSNcxVh22LA/7Yu3Bp3kFje0KPPgiLoxo0vzQiabe0sG6w/Qr0bzx+Nf+eQjClm6k0UA4QyobGhfN/ay7nWKw=
X-Received: by 2002:a5d:4f8d:: with SMTP id d13mr18470362wru.89.1638512540993;
 Thu, 02 Dec 2021 22:22:20 -0800 (PST)
MIME-Version: 1.0
References: <20211120074644.729-1-jiangyifei@huawei.com> <20211120074644.729-6-jiangyifei@huawei.com>
In-Reply-To: <20211120074644.729-6-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 3 Dec 2021 11:52:09 +0530
Message-ID: <CAAhSdy0umeb2Qu=6hJZGy4g1FhW-bsYL=80Msao_pULsJ0+2mw@mail.gmail.com>
Subject: Re: [PATCH v1 05/12] target/riscv: Implement kvm_arch_put_registers
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
> Put GPR CSR and FP registers to kvm by KVM_SET_ONE_REG ioctl
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
> ---
>  target/riscv/kvm.c | 141 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 140 insertions(+), 1 deletion(-)
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index b49c24be0a..5fe5ca4434 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -90,6 +90,31 @@ static int kvm_riscv_get_regs_core(CPUState *cs)
>      return ret;
>  }
>
> +static int kvm_riscv_put_regs_core(CPUState *cs)
> +{
> +    int ret = 0;
> +    int i;
> +    target_ulong reg;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    reg = env->pc;
> +    ret = kvm_set_one_reg(cs, RISCV_CORE_REG(env, regs.pc), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    for (i = 1; i < 32; i++) {
> +        uint64_t id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CORE, i);
> +        reg = env->gpr[i];
> +        ret = kvm_set_one_reg(cs, id, &reg);
> +        if (ret) {
> +            return ret;
> +        }
> +    }
> +
> +    return ret;
> +}
> +
>  static int kvm_riscv_get_regs_csr(CPUState *cs)
>  {
>      int ret = 0;
> @@ -153,6 +178,69 @@ static int kvm_riscv_get_regs_csr(CPUState *cs)
>      return ret;
>  }
>
> +static int kvm_riscv_put_regs_csr(CPUState *cs)
> +{
> +    int ret = 0;
> +    target_ulong reg;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    reg = env->mstatus;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, sstatus), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->mie;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, sie), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->stvec;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, stvec), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->sscratch;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, sscratch), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->sepc;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, sepc), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->scause;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, scause), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->stval;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, stval), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->mip;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, sip), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->satp;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, satp), &reg);
> +    if (ret) {
> +        return ret;
> +    }

Same as the previous patch, there is a common pattern in above
kvm_set_one_reg() calls. Please use a macro to simplify.

Regards,
Anup

> +
> +    return ret;
> +}
> +
>  static int kvm_riscv_get_regs_fp(CPUState *cs)
>  {
>      int ret = 0;
> @@ -186,6 +274,40 @@ static int kvm_riscv_get_regs_fp(CPUState *cs)
>      return ret;
>  }
>
> +static int kvm_riscv_put_regs_fp(CPUState *cs)
> +{
> +    int ret = 0;
> +    int i;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    if (riscv_has_ext(env, RVD)) {
> +        uint64_t reg;
> +        for (i = 0; i < 32; i++) {
> +            reg = env->fpr[i];
> +            ret = kvm_set_one_reg(cs, RISCV_FP_D_REG(env, i), &reg);
> +            if (ret) {
> +                return ret;
> +            }
> +        }
> +        return ret;
> +    }
> +
> +    if (riscv_has_ext(env, RVF)) {
> +        uint32_t reg;
> +        for (i = 0; i < 32; i++) {
> +            reg = env->fpr[i];
> +            ret = kvm_set_one_reg(cs, RISCV_FP_F_REG(env, i), &reg);
> +            if (ret) {
> +                return ret;
> +            }
> +        }
> +        return ret;
> +    }
> +
> +    return ret;
> +}
> +
> +
>  const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>      KVM_CAP_LAST_INFO
>  };
> @@ -214,7 +336,24 @@ int kvm_arch_get_registers(CPUState *cs)
>
>  int kvm_arch_put_registers(CPUState *cs, int level)
>  {
> -    return 0;
> +    int ret = 0;
> +
> +    ret = kvm_riscv_put_regs_core(cs);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    ret = kvm_riscv_put_regs_csr(cs);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    ret = kvm_riscv_put_regs_fp(cs);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    return ret;
>  }
>
>  int kvm_arch_release_virq_post(int virq)
> --
> 2.19.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
