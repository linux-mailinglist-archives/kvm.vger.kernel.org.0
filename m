Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F18472012
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 05:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhLMEmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Dec 2021 23:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhLMEmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Dec 2021 23:42:13 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E79C06173F
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:42:12 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso13192711wms.2
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/xqCJCFenZgSfOUl/R4/U5gUMa3ys+XwRbdFxwDxzVI=;
        b=v+4+5tDc+1I7MKA8DsmriXHI5GHQNcgvZkDy3QRlLzvN8Xyt2LOhd0jeygmuzoP35o
         AqWE+PkcZtfGODyckJ71I+X6J/y04K9zdKlkxzF1mw50sTuCW2gnqsn3IdfXAjv7QmwN
         CL9BT8dfmdIXMZoZjbenzI4xFEZTlyNM/2oyktf1Y12NybkdIGxXCOHTachQYkggQe/V
         +3spzsQBs/5d4iFGxfiw3NKxBIrPDAgYk1w9AzDy7BPXH2/ZREk5JFkr0H15t3Q5Exix
         jNMLcGdTwbLeRS4szddE1C0v+75SGngsCoOAbKv3co1AiZ7tAjT9E0D6d2FekoNC0LFd
         aCWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/xqCJCFenZgSfOUl/R4/U5gUMa3ys+XwRbdFxwDxzVI=;
        b=r8V21I1GSoAnKug+wkY+TyWqaExQPF1drw9lvoBFbFjfG/B0GMpVvR0sU5yS3aQXcx
         rYbNwcmc1U3jt9+BCXtxLhXhvSDJnJn9NyiA25/YdqrMFYF0R+TrnF6HNQLzhWMYwf4z
         c8qJ20PWsR3iH395kwueNa5U2TL22mOzPr40qBWEQ8YCCtMzVDTv58/SpApSy6K8t6yD
         1IAR4wQwBAFpKmMl1GOd3uCCLAhZ1CGSKe1UAGICFcJB4UYx3MCTTj7YpHCgxZZiL6LF
         2xczqkUvhTjiow6TxzR693RqdNN//I4J64wH66mX+UlRuzuekFGiMSS8Qdca5NLRv0HV
         Qk/w==
X-Gm-Message-State: AOAM5322cYhVlcXf+rz+bVZL+XEyj5NrN3r56EaMO8NiD+jgqzekfKhG
        N7A5RLtL6kGJm4X7bQR0HeDsGp7cMoRNrM7/AMQlZQ==
X-Google-Smtp-Source: ABdhPJzorqtXGn5jowXDbWdLBNKLpCk/IlBNYlbHqTEuTlQaxIoYUzbl/nmKUQFFbSTBgGYotftzdwkI6SaDQ5MVD+U=
X-Received: by 2002:a7b:c017:: with SMTP id c23mr34740152wmb.137.1639370531176;
 Sun, 12 Dec 2021 20:42:11 -0800 (PST)
MIME-Version: 1.0
References: <20211210100732.1080-1-jiangyifei@huawei.com> <20211210100732.1080-13-jiangyifei@huawei.com>
In-Reply-To: <20211210100732.1080-13-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 13 Dec 2021 10:12:00 +0530
Message-ID: <CAAhSdy34UorkvYVi7vUUifBh_TRvrQZW4c7uy1nQrj0UNMKGbg@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] target/riscv: Support virtual time context synchronization
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

On Fri, Dec 10, 2021 at 3:38 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Add virtual time context description to vmstate_kvmtimer. After cpu being
> loaded, virtual time context is updated to KVM.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> ---
>  target/riscv/machine.c | 37 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 35 insertions(+), 2 deletions(-)
>
> diff --git a/target/riscv/machine.c b/target/riscv/machine.c
> index ad8248ebfd..f46443c316 100644
> --- a/target/riscv/machine.c
> +++ b/target/riscv/machine.c
> @@ -164,10 +164,42 @@ static const VMStateDescription vmstate_pointermasking = {
>      }
>  };
>
> +static bool kvmtimer_needed(void *opaque)
> +{
> +    return kvm_enabled();
> +}
> +
> +

Remove extra newline from here.

> +static const VMStateDescription vmstate_kvmtimer = {
> +    .name = "cpu/kvmtimer",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = kvmtimer_needed,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_UINT64(env.kvm_timer_time, RISCVCPU),
> +        VMSTATE_UINT64(env.kvm_timer_compare, RISCVCPU),
> +        VMSTATE_UINT64(env.kvm_timer_state, RISCVCPU),
> +
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +static int cpu_post_load(void *opaque, int version_id)
> +{
> +    RISCVCPU *cpu = opaque;
> +    CPURISCVState *env = &cpu->env;
> +
> +    if (kvm_enabled()) {
> +        env->kvm_timer_dirty = true;
> +    }
> +    return 0;
> +}
> +
>  const VMStateDescription vmstate_riscv_cpu = {
>      .name = "cpu",
> -    .version_id = 3,
> -    .minimum_version_id = 3,
> +    .version_id = 4,
> +    .minimum_version_id = 4,
> +    .post_load = cpu_post_load,
>      .fields = (VMStateField[]) {
>          VMSTATE_UINTTL_ARRAY(env.gpr, RISCVCPU, 32),
>          VMSTATE_UINT64_ARRAY(env.fpr, RISCVCPU, 32),
> @@ -218,6 +250,7 @@ const VMStateDescription vmstate_riscv_cpu = {
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
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

Otherwise, it looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup
