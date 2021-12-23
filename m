Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC84847DEE5
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 07:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346540AbhLWGGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 01:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346535AbhLWGGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 01:06:35 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7496AC061756
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 22:06:35 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id p1-20020a1c7401000000b00345c2d068bdso2517232wmc.3
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 22:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lIDWMXVYjagUikqY8QLUz6S+mofwYNJD/geltT+qmeA=;
        b=f8c9RZdF2MGLPY8z8x2QdEW7TeIwEYNq3QLxPYytxiNiaV6glUR0LkW4OpAgQB7ggQ
         Hp5KebmyG3B915AROpjEGGIUhTtoTViPLWKhWyjAVdO7qkC7gScltGCbwQW8USJsrTUl
         sJNqP2j7Je9KObcATN/LcACCDfLRQgzM959YVG8FLwVEAq2RfjcoEvCPc+ptBZYpb3f/
         BalSxzbXxmNRYDAzpvKMaJ6ApNicyMsnNG2irAF0RXSYjaDFqKSuANAsH49KxydHZqMJ
         ydW2f1RwwjLVr6AHozwGrn6tlcwJioZcUdmBF5rT2twhjqbtE4J9/3oLMdoMw6eNrWbH
         5NbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lIDWMXVYjagUikqY8QLUz6S+mofwYNJD/geltT+qmeA=;
        b=uP9QmD16IaTvLfaAYs12wC1Qodv1Vu8+Zk1k5d9xD/ed2kePX+uXrNhx104ZMhcHZl
         gVzL6hb4wzm7cYRGSA4DgR3XmraM4nU6QS+RN8LilTmu4EnJfAmrQIUz4GxT4g4Psv6S
         PpKz4kPR/Q50YjyVTSJy7fGGwwZ+M5N5vKk0sY+njh9AF0vEtWd64sJXhZ8gCAe4IxPE
         ofAXZASkFts4KZSe4C/MdmukSN/mwGvv1w0IXZMpEvSK+mWfwc9g7AtvyBOlVezknyKW
         UQiZmTAW26/fMolwP140mVcSO+7gdNiDLtWmQ86xn6pwiZ5+juFtIiha4paZXgoSys39
         N7jQ==
X-Gm-Message-State: AOAM531ab0I8pW9xN2Bkcp65qfGUWceKmhIYQf+el0BtZA1+XGD9BV/s
        YtcS1c2cKwOtZqBGfrV9OqLrrfQfu/8MVNWqrBhbJA==
X-Google-Smtp-Source: ABdhPJy8287dzKlpQv4wyG7RfB3z4+sRrSFiyj3eP1TRgOS/u7nt+xVe+PhV2vV4g/fhUdPcNHArgJKqAEsgTB3mpwA=
X-Received: by 2002:a05:600c:1da5:: with SMTP id p37mr643254wms.59.1640239593920;
 Wed, 22 Dec 2021 22:06:33 -0800 (PST)
MIME-Version: 1.0
References: <20211220130919.413-1-jiangyifei@huawei.com> <20211220130919.413-11-jiangyifei@huawei.com>
In-Reply-To: <20211220130919.413-11-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 23 Dec 2021 11:36:22 +0530
Message-ID: <CAAhSdy3Sod2=M5jhbevbyq9=OzQR5-MNL9bqMMkKUatA3MMJew@mail.gmail.com>
Subject: Re: [PATCH v3 10/12] target/riscv: Add kvm_riscv_get/put_regs_timer
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

On Mon, Dec 20, 2021 at 6:39 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Add kvm_riscv_get/put_regs_timer to synchronize virtual time context
> from KVM.
>
> To set register of RISCV_TIMER_REG(state) will occur a error from KVM
> on kvm_timer_state == 0. It's better to adapt in KVM, but it doesn't matter
> that adaping in QEMU.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>

Looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup

> ---
>  target/riscv/cpu.h |  7 +++++
>  target/riscv/kvm.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 79 insertions(+)
>
> diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
> index e7dba35acb..c892a2c8b7 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -259,6 +259,13 @@ struct CPURISCVState {
>
>      hwaddr kernel_addr;
>      hwaddr fdt_addr;
> +
> +    /* kvm timer */
> +    bool kvm_timer_dirty;
> +    uint64_t kvm_timer_time;
> +    uint64_t kvm_timer_compare;
> +    uint64_t kvm_timer_state;
> +    uint64_t kvm_timer_frequency;
>  };
>
>  OBJECT_DECLARE_TYPE(RISCVCPU, RISCVCPUClass,
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 4d08669c81..3c20ec5ad3 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -41,6 +41,7 @@
>  #include "sbi_ecall_interface.h"
>  #include "chardev/char-fe.h"
>  #include "semihosting/console.h"
> +#include "migration/migration.h"
>
>  static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
>  {
> @@ -65,6 +66,9 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
>  #define RISCV_CSR_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_CSR, \
>                   KVM_REG_RISCV_CSR_REG(name))
>
> +#define RISCV_TIMER_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_TIMER, \
> +                 KVM_REG_RISCV_TIMER_REG(name))
> +
>  #define RISCV_FP_F_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_F, idx)
>
>  #define RISCV_FP_D_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_D, idx)
> @@ -85,6 +89,22 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
>          } \
>      } while(0)
>
> +#define KVM_RISCV_GET_TIMER(cs, env, name, reg) \
> +    do { \
> +        int ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(env, name), &reg); \
> +        if (ret) { \
> +            abort(); \
> +        } \
> +    } while(0)
> +
> +#define KVM_RISCV_SET_TIMER(cs, env, name, reg) \
> +    do { \
> +        int ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, time), &reg); \
> +        if (ret) { \
> +            abort(); \
> +        } \
> +    } while (0)
> +
>  static int kvm_riscv_get_regs_core(CPUState *cs)
>  {
>      int ret = 0;
> @@ -236,6 +256,58 @@ static int kvm_riscv_put_regs_fp(CPUState *cs)
>      return ret;
>  }
>
> +static void kvm_riscv_get_regs_timer(CPUState *cs)
> +{
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    if (env->kvm_timer_dirty) {
> +        return;
> +    }
> +
> +    KVM_RISCV_GET_TIMER(cs, env, time, env->kvm_timer_time);
> +    KVM_RISCV_GET_TIMER(cs, env, compare, env->kvm_timer_compare);
> +    KVM_RISCV_GET_TIMER(cs, env, state, env->kvm_timer_state);
> +    KVM_RISCV_GET_TIMER(cs, env, frequency, env->kvm_timer_frequency);
> +
> +    env->kvm_timer_dirty = true;
> +}
> +
> +static void kvm_riscv_put_regs_timer(CPUState *cs)
> +{
> +    uint64_t reg;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    if (!env->kvm_timer_dirty) {
> +        return;
> +    }
> +
> +    KVM_RISCV_SET_TIMER(cs, env, time, env->kvm_timer_time);
> +    KVM_RISCV_SET_TIMER(cs, env, compare, env->kvm_timer_compare);
> +
> +    /*
> +     * To set register of RISCV_TIMER_REG(state) will occur a error from KVM
> +     * on env->kvm_timer_state == 0, It's better to adapt in KVM, but it
> +     * doesn't matter that adaping in QEMU now.
> +     * TODO If KVM changes, adapt here.
> +     */
> +    if (env->kvm_timer_state) {
> +        KVM_RISCV_SET_TIMER(cs, env, state, env->kvm_timer_state);
> +    }
> +
> +    /*
> +     * For now, migration will not work between Hosts with different timer
> +     * frequency. Therefore, we should check whether they are the same here
> +     * during the migration.
> +     */
> +    if (migration_is_running(migrate_get_current()->state)) {
> +        KVM_RISCV_GET_TIMER(cs, env, frequency, reg);
> +        if (reg != env->kvm_timer_frequency) {
> +            error_report("Dst Hosts timer frequency != Src Hosts");
> +        }
> +    }
> +
> +    env->kvm_timer_dirty = false;
> +}
>
>  const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>      KVM_CAP_LAST_INFO
> --
> 2.19.1
>
