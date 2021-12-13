Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E86471FFF
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 05:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhLMEcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Dec 2021 23:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbhLMEcv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Dec 2021 23:32:51 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C946CC06173F
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:32:50 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id r9-20020a7bc089000000b00332f4abf43fso10228433wmh.0
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y6ULSPcKlV9Vt0GLH7sDZM7VOzSC0N6caPzZeQCOwq8=;
        b=RlylBlpiukPincecpuULwmLaQ9HDGWFLnsQEV/EqGK7EgB6AHwLUDVUTIgbIoncJ89
         1+x9HDDvvromaZd8ayp9Ky4ES3V82lPnnPbOBaEcuOeKdgIbekDlfbwFY3urS/r/KIK7
         RC7jAc6h/qAuiM8jdGlVNIKX8Cpta/eoCIy+hhPAyxHY8xYIsjo4kmxsT2v0vPnqlxH1
         zP+Pvs/5wAhCzCpdaS4xMxub30RHpf0H0Xl1pSrOeULgLbfduFgue61iofNiX5n0+DbS
         3WdwawKOpz5ErDXbcf1CBf0Lv0Vf5Eb+tLsae0xb0LeNDW+p0xhDhUzAWHjrcIAveInu
         G2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y6ULSPcKlV9Vt0GLH7sDZM7VOzSC0N6caPzZeQCOwq8=;
        b=WNukb01/PXaKT6yCg89mNPArMom5T/tXbR3Y4/bClgemJy3udDiXWFM1+n/bbLpIbM
         qielB8Jc5ug8iOGNwImsuR7dDzU1JxyryBuDacnNlYlTGC4mcEykUA9yPjNg/vftkQvL
         FCDYDNQOTbJo9FndFZ1v3KjtbSWvMqnUGvUsWzwhaFjeo168dwqZzv2/sOeE5NQ5GtzS
         dj5SeLMrDr7QdJlczjhWU4TNhvKbzH54kFcs4rm86aYuqVzZ8j9lNOzrlOSYC1FMGKcB
         /bJ8AapwByqEi2glH35ZJJphl++LmSOakhQKmXGGkA2OvQR5rPlzS1XRtG8tFpKU8XTX
         1w8g==
X-Gm-Message-State: AOAM530ujk1tAa1YXqZp0ZDG1j+enW1iorupLhFmrpPGVq/l/39K49vw
        uClyFYMNsVQ+i+P+Py/im8c80U+4u0kQvVCIEmiRpg==
X-Google-Smtp-Source: ABdhPJzKPc1NNbqbPPvupXHUy/7zUdyE70MX0jImhbJ8IDBzf7DLlIKNR6s7hBZjpZLvwIoPOu/QThZWCSbRFYTbfGg=
X-Received: by 2002:a7b:c017:: with SMTP id c23mr34700828wmb.137.1639369969288;
 Sun, 12 Dec 2021 20:32:49 -0800 (PST)
MIME-Version: 1.0
References: <20211210100732.1080-1-jiangyifei@huawei.com> <20211210100732.1080-8-jiangyifei@huawei.com>
In-Reply-To: <20211210100732.1080-8-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 13 Dec 2021 10:02:38 +0530
Message-ID: <CAAhSdy0q3iuURMcW9+wV4oyB1O=Mj19UaT9P31fLHAYZ_wU3pg@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] target/riscv: Support setting external interrupt
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

On Fri, Dec 10, 2021 at 3:37 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> When KVM is enabled, set the S-mode external interrupt through
> kvm_riscv_set_irq function.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
> ---
>  target/riscv/cpu.c       |  6 +++++-
>  target/riscv/kvm-stub.c  |  5 +++++
>  target/riscv/kvm.c       | 17 +++++++++++++++++
>  target/riscv/kvm_riscv.h |  1 +
>  4 files changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index 1c944872a3..71a7ac6831 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -603,7 +603,11 @@ static void riscv_cpu_set_irq(void *opaque, int irq, int level)
>      case IRQ_S_EXT:
>      case IRQ_VS_EXT:
>      case IRQ_M_EXT:
> -        riscv_cpu_update_mip(cpu, 1 << irq, BOOL_TO_MASK(level));
> +        if (kvm_enabled() && (irq & IRQ_M_EXT) ) {
> +            kvm_riscv_set_irq(cpu, IRQ_S_EXT, level);
> +        } else {
> +            riscv_cpu_update_mip(cpu, 1 << irq, BOOL_TO_MASK(level));
> +        }

This does not look right.

I suggest the following:

if (kvm_enabled()) {
    kvm_riscv_set_irq(cpu, irq, level);
} else {
   riscv_cpu_update_mip(cpu, 1 << irq, BOOL_TO_MASK(level));
}

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

Regards,
Anup
