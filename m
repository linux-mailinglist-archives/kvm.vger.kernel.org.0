Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD9347DEE2
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 07:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346527AbhLWGFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 01:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242270AbhLWGFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 01:05:37 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C217CC061401
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 22:05:36 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id g7-20020a7bc4c7000000b00345c4bb365aso2300104wmk.4
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 22:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1XgeblNjyLRR0VJexdQ72YWUWRRoaoPGkJJML+2iIio=;
        b=2oS8G8wzk9dq8rZDZ5ZSer7XJ2oqA3CcpCnFYWtJMevQoz4ZztBfdqkuaMvYn5QGcP
         J2Bg9HPbWGzhtWmJUHZnsm3s3c7p9DSD7nELjVhb6qaNsTZxR0uzDYAxhzEXupovu6Gn
         mi0FjQQmiRhUd6LJMRn9HyRspMc3TXedNQpnGjr1GCtz8V8LmZzWmRIcFpOLIL4ZF7YW
         +7qxtnDKULC7pdiHSPMO3z99Ey5eJYSTeuDs5X+AIpc0TK6ILuGw2XvaqXS4QTQi1BLL
         vV7VmKlUtFkk6X7/0rp/2Rzmm+4naTO6UL8nAsZwbCkMy7j+iSyrBskPwP6ulWZa1Sjo
         kpVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1XgeblNjyLRR0VJexdQ72YWUWRRoaoPGkJJML+2iIio=;
        b=hiETZeuZj/OkJONt0HB8Zlm13BGHo6ejyjB7VbaBww4ilnndgWuOI8AONZOlbhuip2
         w0UJSHAiZqjlamUO0rpkCRj2Jg5fn21r8dwKTKgtkQG0UD8GjX+2vkV0CDw+zyYRdgPb
         7FMNIaG4/5FcBNRFZqT2pwsoyuIGduI3P6ha0+b0RQKBokUs/llxPaJ+sfO555gwhEMk
         x3pzvI1HTE0AupuSSoUdDsYb7DWCoJq51ynfwbqxuC4N5toqef4TgB9I9v34KTdcsJlu
         nKbwvwnqXRgbFCb9it8U4M4tTJJsjHOikvdMesrdM9h7n82fj6w3RvkZB/OpF6ROMGIh
         dwCQ==
X-Gm-Message-State: AOAM5305LchxPGYNMH6VleQSdRr/Uwt2QuBBtXiI4Wrwifm8I8usnzr0
        KHB+DrGgwk0bvZLeludhX4dlcDW2VW16Ni+DvU4TxL90Eh4=
X-Google-Smtp-Source: ABdhPJyqcT8DUVax4HxTlJfCZ8O3g/CTsOX2tmncos53JiwJ4I7hLYtfwBD3A1vas8TtRWuZsnZA/e2ydv2coAFrwhs=
X-Received: by 2002:a7b:c0c1:: with SMTP id s1mr617063wmh.176.1640239535261;
 Wed, 22 Dec 2021 22:05:35 -0800 (PST)
MIME-Version: 1.0
References: <20211220130919.413-1-jiangyifei@huawei.com> <20211220130919.413-8-jiangyifei@huawei.com>
In-Reply-To: <20211220130919.413-8-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 23 Dec 2021 11:35:23 +0530
Message-ID: <CAAhSdy1rsRKwwLu2n58U0Wk8FVG17c3md-gDVAipgEC1P=srSQ@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] target/riscv: Support setting external interrupt
 by KVM
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
> When KVM is enabled, set the S-mode external interrupt through
> kvm_riscv_set_irq function.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup

> ---
>  target/riscv/cpu.c       |  6 +++++-
>  target/riscv/kvm-stub.c  |  5 +++++
>  target/riscv/kvm.c       | 17 +++++++++++++++++
>  target/riscv/kvm_riscv.h |  1 +
>  4 files changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index 1c944872a3..3fc3a9c45b 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -603,7 +603,11 @@ static void riscv_cpu_set_irq(void *opaque, int irq, int level)
>      case IRQ_S_EXT:
>      case IRQ_VS_EXT:
>      case IRQ_M_EXT:
> -        riscv_cpu_update_mip(cpu, 1 << irq, BOOL_TO_MASK(level));
> +        if (kvm_enabled()) {
> +            kvm_riscv_set_irq(cpu, irq, level);
> +        } else {
> +            riscv_cpu_update_mip(cpu, 1 << irq, BOOL_TO_MASK(level));
> +        }
>          break;
>      default:
>          g_assert_not_reached();
> diff --git a/target/riscv/kvm-stub.c b/target/riscv/kvm-stub.c
> index 39b96fe3f4..4e8fc31a21 100644
> --- a/target/riscv/kvm-stub.c
> +++ b/target/riscv/kvm-stub.c
> @@ -23,3 +23,8 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
>  {
>      abort();
>  }
> +
> +void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level)
> +{
> +    abort();
> +}
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index db6d8a5b6e..0027f11f45 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -383,6 +383,23 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
>      env->satp = 0;
>  }
>
> +void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level)
> +{
> +    int ret;
> +    unsigned virq = level ? KVM_INTERRUPT_SET : KVM_INTERRUPT_UNSET;
> +
> +    if (irq != IRQ_S_EXT) {
> +        perror("kvm riscv set irq != IRQ_S_EXT\n");
> +        abort();
> +    }
> +
> +    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_INTERRUPT, &virq);
> +    if (ret < 0) {
> +        perror("Set irq failed");
> +        abort();
> +    }
> +}
> +
>  bool kvm_arch_cpu_check_are_resettable(void)
>  {
>      return true;
> diff --git a/target/riscv/kvm_riscv.h b/target/riscv/kvm_riscv.h
> index f38c82bf59..ed281bdce0 100644
> --- a/target/riscv/kvm_riscv.h
> +++ b/target/riscv/kvm_riscv.h
> @@ -20,5 +20,6 @@
>  #define QEMU_KVM_RISCV_H
>
>  void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
> +void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level);
>
>  #endif
> --
> 2.19.1
>
