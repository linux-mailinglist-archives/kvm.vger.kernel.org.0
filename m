Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417AB36F530
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 06:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhD3Eym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 00:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhD3Eym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 00:54:42 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EF5C06174A
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 21:53:54 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 82-20020a1c01550000b0290142562ff7c9so920679wmb.3
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 21:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UGRVbFEa+O4nql4wL8JLwDHK88SuI1CttvKEIpPLdho=;
        b=tAZOlBWC/dpe7X4h3LVF4JPHUHPKhmGC5Jgq5flDvzlS3SEXGQc+S+M+lae8i5pcJC
         6NAUgtRCZwc3HQzDsVVo0m/tz+J3cZIZvocq8XlIVFfQt7aiiRAbNdWH3Ae6FpqwCtJu
         ILuQFcAgM/H2XmlV+JYAKfSMQtdgfdg62aDqg5pgLb8PcLaNUa6rmbG0wmUH3Re22mtf
         ywos2ak6Rr+c39ESQDCiWiffWvFwMVReNNkvrqMWszfAHiLk/YHsBuIEdiLC5Q/D2MCK
         PFcaX04lZdC+ZfZUmxdj5jGWROUUyT/cEtvmtnG1DGJ//x2Ja31TqsJVBM/7bGrG7v2e
         JZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UGRVbFEa+O4nql4wL8JLwDHK88SuI1CttvKEIpPLdho=;
        b=IELlV8OmwW2uOBr6EM7RqK6NCp0QZzUCFWjqtiVXjtzCSysDW7NN+jC4wtRGAAtUIo
         EnM8XBOvrWz/y810gpToP0IW3Ow20+kWrCLumtLGbEPW7dGyaHKcV94GUdvvxjANuujH
         keV64BX/WCR2KfUmeaBi/ciUzp8up8u158nqC/Lpn75d+iEeNXzFafh/Fwr+UGn6Tnea
         GALQ8EJKTVRGhGGq+0J9ruSmcSn+noGN3h+j5QpCYw6CCnBFyuVn4DmEW2uzlIqupqOu
         5MW4dftx9/l7fQVhapvrOeyt0/8lHrE/StL3nh/H0wrY3ShzMbrSoTwcGJ2LpjeFNU82
         isfg==
X-Gm-Message-State: AOAM532fBfykN4mbJx6wwyeuLH1eZWqxX1+QCKF3JX4who6cdmvKa5Or
        MWZrS5fMACUIHVf6UYW8LxZ8uSSYMnz3T8TxIJNOVg==
X-Google-Smtp-Source: ABdhPJz6ciYc399ey9eit4UZvScEpLv5uRf/WYCuteudvmF//NfaJHTVN7DyPq6zhLx3l7ORcT1VPGnVqp22VhrZSEo=
X-Received: by 2002:a7b:c348:: with SMTP id l8mr14781328wmj.152.1619758433260;
 Thu, 29 Apr 2021 21:53:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210412065246.1853-1-jiangyifei@huawei.com> <20210412065246.1853-8-jiangyifei@huawei.com>
In-Reply-To: <20210412065246.1853-8-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 30 Apr 2021 10:23:41 +0530
Message-ID: <CAAhSdy34aVwGEW-_Z=FkOkrAGrTsaS-11Ck6gJg77wwUSXe=zw@mail.gmail.com>
Subject: Re: [PATCH RFC v5 07/12] hw/riscv: PLIC update external interrupt by
 KVM when kvm enabled
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        libvir-list@redhat.com, Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Bin Meng <bin.meng@windriver.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>,
        yinyipeng <yinyipeng1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 12:24 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Only support supervisor external interrupt currently.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
> ---
>  hw/intc/sifive_plic.c    | 29 ++++++++++++++++++++---------
>  target/riscv/kvm-stub.c  |  5 +++++
>  target/riscv/kvm.c       | 20 ++++++++++++++++++++
>  target/riscv/kvm_riscv.h |  1 +
>  4 files changed, 46 insertions(+), 9 deletions(-)
>
> diff --git a/hw/intc/sifive_plic.c b/hw/intc/sifive_plic.c
> index 97a1a27a9a..2746eb7a05 100644
> --- a/hw/intc/sifive_plic.c
> +++ b/hw/intc/sifive_plic.c
> @@ -31,6 +31,8 @@
>  #include "target/riscv/cpu.h"
>  #include "sysemu/sysemu.h"
>  #include "migration/vmstate.h"
> +#include "sysemu/kvm.h"
> +#include "kvm_riscv.h"
>
>  #define RISCV_DEBUG_PLIC 0
>
> @@ -147,15 +149,24 @@ static void sifive_plic_update(SiFivePLICState *plic)
>              continue;
>          }
>          int level = sifive_plic_irqs_pending(plic, addrid);
> -        switch (mode) {
> -        case PLICMode_M:
> -            riscv_cpu_update_mip(RISCV_CPU(cpu), MIP_MEIP, BOOL_TO_MASK(level));
> -            break;
> -        case PLICMode_S:
> -            riscv_cpu_update_mip(RISCV_CPU(cpu), MIP_SEIP, BOOL_TO_MASK(level));
> -            break;
> -        default:
> -            break;
> +        if (kvm_enabled()) {
> +            if (mode == PLICMode_M) {
> +                continue;
> +            }
> +            kvm_riscv_set_irq(RISCV_CPU(cpu), IRQ_S_EXT, level);
> +        } else {
> +            switch (mode) {
> +            case PLICMode_M:
> +                riscv_cpu_update_mip(RISCV_CPU(cpu),
> +                                     MIP_MEIP, BOOL_TO_MASK(level));
> +                break;
> +            case PLICMode_S:
> +                riscv_cpu_update_mip(RISCV_CPU(cpu),
> +                                     MIP_SEIP, BOOL_TO_MASK(level));
> +                break;
> +            default:
> +                break;
> +            }

I am not comfortable with this patch.

This way we will endup calling kvm_riscv_set_irq() from various
places in hw/intc and hw/riscv.

I suggest to extend riscv_cpu_update_mip() such that when kvm is
enabled riscv_cpu_update_mip() will:
1) Consider only MIP_SEIP bit in "mask" parameter and all other
    bits in "mask" parameter will be ignored probably with warning
2) When the MIP_SEIP bit is set in "mask" call kvm_riscv_set_irq()
to change the IRQ state in the KVM module.

Regards,
Anup

>          }
>      }
>
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
> index 79c931acb4..da63535812 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -453,6 +453,26 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
>      env->gpr[11] = cpu->env.fdt_addr;          /* a1 */
>  }
>
> +void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level)
> +{
> +    int ret;
> +    unsigned virq = level ? KVM_INTERRUPT_SET : KVM_INTERRUPT_UNSET;
> +
> +    if (irq != IRQ_S_EXT) {
> +        return;
> +    }
> +
> +    if (!kvm_enabled()) {
> +        return;
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
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
