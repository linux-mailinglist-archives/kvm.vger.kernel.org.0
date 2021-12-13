Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E960471FE5
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 05:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhLMERS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Dec 2021 23:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhLMERS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Dec 2021 23:17:18 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E627EC06173F
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:17:17 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id c4so24835620wrd.9
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BRcF4DfHIqBKfleTCwMXo7Eh2GKC1UVAwKmaROY7m7I=;
        b=gOf7znJnRp/h5O2fztIccS4KoXxriuRkiThU1N8MYSoL9PI/1oviF7q4UD265sEyMF
         eugDNLz6uXb28nQoKehYeaJgFE1nZred9DCYhsRDsUxKEEzrWWKirIOy6i3ZFOvvcSTz
         xkKZBAHuG0KAqSZy5jeNdvKwGF0HKouNX0TsDhiWTVTTRu5sVpAflcn/UOBMLJK4kXK8
         dguTLYt8sJeRsL2YCjkdhu3mrq595sYy7OGbxxuOJqM2MVMkap24c24az0daCH1Zl1UH
         UBR43OX312zJxpttPOJQYDo6OBCyLsZBJS/lXVPwoiaNukfnK2lzBDG7dmsLkE4QDGRF
         8mlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BRcF4DfHIqBKfleTCwMXo7Eh2GKC1UVAwKmaROY7m7I=;
        b=LHrqBe+hc9C+w+CZHUY9aexz0PkJVruMeLpR8NK+m2YWYkmSh3OGxAsJwbYuX82wrH
         653CMXxLuBZPE/csqYNKnEAjc4uidRmzMBkr/wTGFi3rFUgkP6K7XthtaEEk6CluuLeO
         DiZb0lGFsoyGKql+CIfBiKilC7oLNZ5Hq2g+WwSIR9nJaXizEXbBZc8fsZOP6lZWB1MW
         UjoWXYXqoLHPI1sBC2LBSddTR/GwKfW9CKhwsLA6jeXl4HkK7VwPDa66jUtBfYRhX3db
         5vqovcPoUsDFi+lN5eYoXlXf8i9a7jYN1XWej9AovRvfVA5/TIl7cd0DMGVFJug+eRqp
         hGZw==
X-Gm-Message-State: AOAM531ZFdOpxyTLli4hEAhgzemEATZqgaD1yhY/1v9t4iaDQigejsR7
        sFk3CqLOgelhkiGQAmnNsoiI3Djcp+2japzEXl0Keg==
X-Google-Smtp-Source: ABdhPJyrMlvAv+QC/NETimV1IGnrw4Sk4dxEyHVlUAtgjj2DIO55ZQ8nzuSGmUQRXlrveO21jWlOGUWxsL2jF/JGfVY=
X-Received: by 2002:adf:d082:: with SMTP id y2mr29944773wrh.214.1639369036422;
 Sun, 12 Dec 2021 20:17:16 -0800 (PST)
MIME-Version: 1.0
References: <20211210100732.1080-1-jiangyifei@huawei.com> <20211210100732.1080-6-jiangyifei@huawei.com>
In-Reply-To: <20211210100732.1080-6-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 13 Dec 2021 09:47:04 +0530
Message-ID: <CAAhSdy04riukdShAHxT4i0gvV5-Zt6fXLzCGS-aPZCcpxBq43g@mail.gmail.com>
Subject: Re: [PATCH v2 05/12] target/riscv: Implement kvm_arch_put_registers
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

On Fri, Dec 10, 2021 at 3:37 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Put GPR CSR and FP registers to kvm by KVM_SET_ONE_REG ioctl
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup

> ---
>  target/riscv/kvm.c | 104 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 103 insertions(+), 1 deletion(-)
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 6d4df0ef6d..e695b91dc7 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -73,6 +73,14 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
>          } \
>      } while(0)
>
> +#define KVM_RISCV_SET_CSR(cs, env, csr, reg) \
> +    do { \
> +        int ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, csr), &reg); \
> +        if (ret) { \
> +            return ret; \
> +        } \
> +    } while(0)
> +
>  static int kvm_riscv_get_regs_core(CPUState *cs)
>  {
>      int ret = 0;
> @@ -98,6 +106,31 @@ static int kvm_riscv_get_regs_core(CPUState *cs)
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
> @@ -115,6 +148,24 @@ static int kvm_riscv_get_regs_csr(CPUState *cs)
>      return ret;
>  }
>
> +static int kvm_riscv_put_regs_csr(CPUState *cs)
> +{
> +    int ret = 0;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    KVM_RISCV_SET_CSR(cs, env, sstatus, env->mstatus);
> +    KVM_RISCV_SET_CSR(cs, env, sie, env->mie);
> +    KVM_RISCV_SET_CSR(cs, env, stvec, env->stvec);
> +    KVM_RISCV_SET_CSR(cs, env, sscratch, env->sscratch);
> +    KVM_RISCV_SET_CSR(cs, env, sepc, env->sepc);
> +    KVM_RISCV_SET_CSR(cs, env, scause, env->scause);
> +    KVM_RISCV_SET_CSR(cs, env, stval, env->stval);
> +    KVM_RISCV_SET_CSR(cs, env, sip, env->mip);
> +    KVM_RISCV_SET_CSR(cs, env, satp, env->satp);
> +
> +    return ret;
> +}
> +
>  static int kvm_riscv_get_regs_fp(CPUState *cs)
>  {
>      int ret = 0;
> @@ -148,6 +199,40 @@ static int kvm_riscv_get_regs_fp(CPUState *cs)
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
> @@ -176,7 +261,24 @@ int kvm_arch_get_registers(CPUState *cs)
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
