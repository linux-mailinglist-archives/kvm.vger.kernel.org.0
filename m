Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E65485B43
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 23:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244713AbiAEWEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 17:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244736AbiAEWEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 17:04:47 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EAEC061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 14:04:47 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id e128so855453iof.1
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 14:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zm6hq7hdTHha4uq0ZX23dBVJPJI05eLjkVtrtmDeGKU=;
        b=D7AjArZ1OD/OfOcakflZMiChjBF78hJMhN5Kz+SdMcORQM5kz4ZH43poi++XRmaYfw
         34EzVTrBD3G3SGOQnSpXJrgl9Wruuh6Aa43Gq7qjUk6bukIPukXmNCGNh9JIhiBHRcTN
         UFkBgzMawNH4RI3PFBieMGyiBF2cLLg04ucgFNM+INos1XN6EfxvHaEYI+pQRQRwVeLQ
         hXO++Rqf2gF7NFMKrZLwYDiF8dAmzJSPfq8Psj4FM73toA11ch9ioBDP3AG44kKepmtX
         hjp8+ipHnMrvfabURMhmcKTfFf6dWnHatnjiYiBnoNYq2eNaVEW57HkN2JS0zfJsf0lA
         xTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zm6hq7hdTHha4uq0ZX23dBVJPJI05eLjkVtrtmDeGKU=;
        b=OOs/yVgDIE9Q1ShtXzEwlfQJ3Svtf9JMdF9i50ET5qbLZv0DN05XocWVbjQEVF/heF
         5R/o5iPZQ7v4DisGq6cBwO2pKReD3mlv/y3qT9OrzsIfBNRDOpDJmVjXz7QNhGNglL4d
         4lHjMCaxFUERFpXIBmlPtBuS4ed9Xs0/6mXyfIl5IlsjivyA1S01wjpuw7zwPigctqBl
         NaYHuvltOkXm283bWFjvuHSQu25pOPtGEPjimioNBgxztV7dC2dxhApNROkJMiswSCaK
         h0Og1T8eltUmfmh2B6AhmJQKvwYqTB/76GfipjR9YHGsuuBl8+qVdwDqjsA+22L0JfCh
         BV3A==
X-Gm-Message-State: AOAM531P+78d10zOqsAxNjXFkZ5zQ/60f0d4WXHmzgYM8mFwmCK9cxFC
        g5YSca0SzxGKxPk8ylikcXJh4Nc/CfAmvOsCAdc=
X-Google-Smtp-Source: ABdhPJy3d/D66OUGPIk5j3YmZLVa9IC9mu9NfLTOqB44PEuZ0wOMV0+yv9NdUxR2M1BgfOgxXzK53qfgK02BQrW6XzI=
X-Received: by 2002:a05:6602:1487:: with SMTP id a7mr26307777iow.57.1641420286640;
 Wed, 05 Jan 2022 14:04:46 -0800 (PST)
MIME-Version: 1.0
References: <20211220130919.413-1-jiangyifei@huawei.com> <20211220130919.413-12-jiangyifei@huawei.com>
In-Reply-To: <20211220130919.413-12-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Thu, 6 Jan 2022 08:04:20 +1000
Message-ID: <CAKmqyKO8qvAY=jPC1BnjXqy5=Lakxg7+OkznGQqBhLAJr4r9FA@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] target/riscv: Implement virtual time adjusting
 with vm state changing
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        kvm-riscv@lists.infradead.org,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>, wanghaibin.wang@huawei.com,
        wanbo13@huawei.com, Mingwang Li <limingwang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 21, 2021 at 3:45 AM Yifei Jiang via <qemu-devel@nongnu.org> wrote:
>
> We hope that virtual time adjusts with vm state changing. When a vm
> is stopped, guest virtual time should stop counting and kvm_timer
> should be stopped. When the vm is resumed, guest virtual time should
> continue to count and kvm_timer should be restored.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Anup Patel <anup.patel@wdc.com>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  target/riscv/kvm.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 3c20ec5ad3..6c0306bd2b 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -42,6 +42,7 @@
>  #include "chardev/char-fe.h"
>  #include "semihosting/console.h"
>  #include "migration/migration.h"
> +#include "sysemu/runstate.h"
>
>  static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
>  {
> @@ -378,6 +379,17 @@ unsigned long kvm_arch_vcpu_id(CPUState *cpu)
>      return cpu->cpu_index;
>  }
>
> +static void kvm_riscv_vm_state_change(void *opaque, bool running, RunState state)
> +{
> +    CPUState *cs = opaque;
> +
> +    if (running) {
> +        kvm_riscv_put_regs_timer(cs);
> +    } else {
> +        kvm_riscv_get_regs_timer(cs);
> +    }
> +}
> +
>  void kvm_arch_init_irq_routing(KVMState *s)
>  {
>  }
> @@ -390,6 +402,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      CPURISCVState *env = &cpu->env;
>      uint64_t id;
>
> +    qemu_add_vm_change_state_handler(kvm_riscv_vm_state_change, cs);
> +
>      id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CONFIG, KVM_REG_RISCV_CONFIG_REG(isa));
>      ret = kvm_get_one_reg(cs, id, &isa);
>      if (ret) {
> --
> 2.19.1
>
>
