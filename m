Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DA5485B6A
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 23:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244947AbiAEWMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 17:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245030AbiAEWLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 17:11:35 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAA2C033272
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 14:10:53 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id x6so795487iol.13
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 14:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KyuB6cgvbx47LTafWGeD98t194U7V3pi7OOl+mXsMkU=;
        b=HW8qzzmLZrWDmjiHRFwd1oh+9YLaimXzS3P5AZFYnDx/8doksy8ALEqVW/JXIe3Cy2
         BYhpPpnHI9JmdSM0Zh0d5dTaQeX8nqVLPBdDQZRQ5evdiwps8oXgoKc8o2WRFAq0Gi04
         jOe2mweTVWBXElnb6ZfgjGMHcE1qd116xRRYVIe3KEr5oaif1qbhgvKNAqBIoj3l8q2b
         jCsysHVX1pu41DkiolUC2xlrPxU1eGLz5e0yfRXiZxPQbbbKQfy2Pc5hGC/tE2U3TAHj
         q4VLcfDpPDDm7L6k0g5aQ+iXgREMbrVdR1+9L0UtMiBj01Jid/milNQ6/ZEI9MSQuvnq
         jPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KyuB6cgvbx47LTafWGeD98t194U7V3pi7OOl+mXsMkU=;
        b=5edaYifhk8574O6MK3bTOTqSdYSwId63zphUUhJC+l2XDR4+mljXMqwpFJSVae4945
         H+zkldqvEIfffcjjQu9SgRrdSdeIQOsk+GQiM/46++4pgiWHek1MkQWycWn4Rgc0gQwi
         ktjZNZeUdNj3eP8Y2j1nL173vPjOilk9zld2kDEh/lK3R6nPIw2+SS8Mw680cEZxiQFr
         lE55mYcFPOLxRPe2C/4Pm8yC9g47lj9Yk9lAlDRNW5mOQsTFcMw5EJ5Y8+NHdYVClCGE
         YoKWVBNcJgfWdhyYvQKk2UJhGT8T67UBrfRujnD2zF5tkYglVK+9Q1aytlAh856LD4lK
         ppjg==
X-Gm-Message-State: AOAM530m/RqCjsFvPVo7k5Qf+p0kfRxNy08QAq2V30OwAphU5Fof57BA
        x40QiLKKfUlFdGJuL3Js5VhjWrMmXwYUU2u7qMU=
X-Google-Smtp-Source: ABdhPJxjH3Zp0UKsJFtPiPHOb+NU7fdX3IdNXLI5VjGFAJUEOziruEeObtWqofCzvBBK5cY1pgMKmOxonVLFcNFYcfg=
X-Received: by 2002:a5d:8f88:: with SMTP id l8mr26717419iol.91.1641420652505;
 Wed, 05 Jan 2022 14:10:52 -0800 (PST)
MIME-Version: 1.0
References: <20211220130919.413-1-jiangyifei@huawei.com> <20211220130919.413-13-jiangyifei@huawei.com>
In-Reply-To: <20211220130919.413-13-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Thu, 6 Jan 2022 08:10:26 +1000
Message-ID: <CAKmqyKNq9WJbx2CWL8qPatg7Gc3BckU=v94p+HgKiJ1W5-YPNg@mail.gmail.com>
Subject: Re: [PATCH v3 12/12] target/riscv: Support virtual time context synchronization
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

On Tue, Dec 21, 2021 at 2:44 AM Yifei Jiang via <qemu-devel@nongnu.org> wrote:
>
> Add virtual time context description to vmstate_kvmtimer. After cpu being
> loaded, virtual time context is updated to KVM.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Anup Patel <anup.patel@wdc.com>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  target/riscv/machine.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/target/riscv/machine.c b/target/riscv/machine.c
> index ad8248ebfd..95eb82792a 100644
> --- a/target/riscv/machine.c
> +++ b/target/riscv/machine.c
> @@ -164,6 +164,35 @@ static const VMStateDescription vmstate_pointermasking = {
>      }
>  };
>
> +static bool kvmtimer_needed(void *opaque)
> +{
> +    return kvm_enabled();
> +}
> +
> +static int cpu_post_load(void *opaque, int version_id)
> +{
> +    RISCVCPU *cpu = opaque;
> +    CPURISCVState *env = &cpu->env;
> +
> +    env->kvm_timer_dirty = true;
> +    return 0;
> +}
> +
> +static const VMStateDescription vmstate_kvmtimer = {
> +    .name = "cpu/kvmtimer",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = kvmtimer_needed,
> +    .post_load = cpu_post_load,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_UINT64(env.kvm_timer_time, RISCVCPU),
> +        VMSTATE_UINT64(env.kvm_timer_compare, RISCVCPU),
> +        VMSTATE_UINT64(env.kvm_timer_state, RISCVCPU),
> +
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
>  const VMStateDescription vmstate_riscv_cpu = {
>      .name = "cpu",
>      .version_id = 3,
> @@ -218,6 +247,7 @@ const VMStateDescription vmstate_riscv_cpu = {
>          &vmstate_hyper,
>          &vmstate_vector,
>          &vmstate_pointermasking,
> +        &vmstate_kvmtimer,
>          NULL
>      }
>  };
> --
> 2.19.1
>
>
