Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9506AC103
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 14:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjCFNbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 08:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjCFNbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 08:31:36 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D722A993
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 05:31:35 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id o2so9081478vss.8
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 05:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1678109494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJ9Z+QjshNd3gtr/tqh4VVlvtOXWb9XUhmUt7dCXpH4=;
        b=LLU0A82e4APRGmZq6n8jT2pEtq2QFRtRtHA0tV2Wi5YPoYEMVSbQQceuUOrmo7lVTK
         a1K3CxJoSJCKayrGR48iuX+IeUWC6sKvaA/DZFkvS2YuHyGI1wxVc4ieUNgR7Efb6TQT
         ovozsUpHUaDJE69aNbjGEBX++PK5FwkqK5HxPJa0ahZi8G0CezLPkpz73/DbVxop92od
         FErJx66506N4C9tR6CrH2iASb6uQO+XtQJ8IvMPJw8+SO3P0OXvh+KxWomX+RYCJzdZX
         Pe44qLXdPaKXQkNWD1SsjkqbD5zX6WZlDq0YAVX2qDtX6MMU8syp413dKjFALs1fsIoX
         Nw8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678109494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YJ9Z+QjshNd3gtr/tqh4VVlvtOXWb9XUhmUt7dCXpH4=;
        b=HwCoRblUiUtfbU2DcnHYUszAxFOF47Flp/3jE0XgenPbGP5+1LHjoM8Gj8qe/LyV+m
         xSBasjUy3H7NthDbQKqwgzrTcU3/vSMIWpPIlBs/XOTD5TTtj62BkBZL0NKBzM8MrmCP
         KjWLBeboD3L0UHZSvSNjo4Mr3hJudOe6yWjHvR52jP+QztJhtCo86MpaEhClP1gGgf0k
         3Sn820yfSRIRqWtJsPsf6odbedwFZmr+bR0C11i1qBYOqy6qCpjckHkZgvBRgQh1UGjx
         rZVn1i/OdlEzTbvhM89QXmqK1PGXcxo/SPAfYWBHQeKAoXIOPVmzobtYCkUWWEoaT77n
         wjXw==
X-Gm-Message-State: AO0yUKXsbtmO+eg2RdopaFB11dxhIa6SUQo1wxyoFVi2lgkCOO1of9JB
        0Z45RkGcwC3elc+1FdIxSEizGeZ4zvwBOqh3zdkuQA==
X-Google-Smtp-Source: AK7set/QDiyJnrM1LDBNPHKMfvXJcktaeA5G3e7zGD4z1DlF6JSHVYAg8WIavFxvtBEf9defwaIUlyVloBmhCe1VTw4=
X-Received: by 2002:a67:b40b:0:b0:402:9b84:1bde with SMTP id
 x11-20020a67b40b000000b004029b841bdemr7115746vsl.0.1678109494025; Mon, 06 Mar
 2023 05:31:34 -0800 (PST)
MIME-Version: 1.0
References: <20230210142711.1177212-1-rkanwal@rivosinc.com>
In-Reply-To: <20230210142711.1177212-1-rkanwal@rivosinc.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Mon, 6 Mar 2023 19:01:23 +0530
Message-ID: <CAK9=C2XzTD95W-QfwF0px26DyDD9AAx_qX3we-zeMzOK7EHr4Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] riscv/kvm: Fix VM hang in case of timer delta
 being zero.
To:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023 at 7:57=E2=80=AFPM Rajnesh Kanwal <rkanwal@rivosinc.co=
m> wrote:
>
> In case when VCPU is blocked due to WFI, we schedule the timer
> from `kvm_riscv_vcpu_timer_blocking()` to keep timer interrupt
> ticking.
>
> But in case when delta_ns comes to be zero, we never schedule
> the timer and VCPU keeps sleeping indefinitely until any activity
> is done with VM console.
>
> This is easily reproduce-able using kvmtool.
> ./lkvm-static run -c1 --console virtio -p "earlycon root=3D/dev/vda" \
>          -k ./Image -d rootfs.ext4
>
> Also, just add a print in kvm_riscv_vcpu_vstimer_expired() to
> check the interrupt delivery and run `top` or similar auto-upating
> cmd from guest. Within sometime one can notice that print from
> timer expiry routine stops and the `top` cmd output will stop
> updating.
>
> This change fixes this by making sure we schedule the timer even
> with delta_ns being zero to bring the VCPU out of sleep immediately.
>
> Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
> Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>

Queued this patch for Linux-6.3 fixes.

Thanks,
Anup

> ---
> v2: Added Fixes tag in commit message.
>
> v1: https://lore.kernel.org/all/20230210135136.1115213-1-rkanwal@rivosinc=
.com/
>
>  arch/riscv/kvm/vcpu_timer.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> index ad34519c8a13..3ac2ff6a65da 100644
> --- a/arch/riscv/kvm/vcpu_timer.c
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -147,10 +147,8 @@ static void kvm_riscv_vcpu_timer_blocking(struct kvm=
_vcpu *vcpu)
>                 return;
>
>         delta_ns =3D kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t);
> -       if (delta_ns) {
> -               hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MO=
DE_REL);
> -               t->next_set =3D true;
> -       }
> +       hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
> +       t->next_set =3D true;
>  }
>
>  static void kvm_riscv_vcpu_timer_unblocking(struct kvm_vcpu *vcpu)
> --
> 2.25.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
