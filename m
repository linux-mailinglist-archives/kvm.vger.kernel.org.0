Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC7C69207E
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 15:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjBJOHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 09:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjBJOHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 09:07:36 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3C31B570
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 06:07:32 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id d66so5740209vsd.9
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 06:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1676038051;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WjR5+rSVm40yBdy3S3lnrbU7QxgVcfkiS2VCusME+T0=;
        b=mPcVawWxhXA4BuhTsqIGEw3EfrHD833k9/H31X+W4r7L7CXRgS15V5Bln+vHE8BDUL
         3TSOHbcxanV72izBD4qDrRJ8v2DTVJ0NtnxSSbnDbPsJdxuOk3lAA5NGCTul03EP2KR8
         94P7Khy6LhMaeSBlGGoFNOIWjV23jT485P5zQlMX+nKsxX//qbZDFOsWgtFksntJLhBP
         rRi94LQaVpfPqgiSHOm0R1euiqDQwZJZt36c/cUlWNK5T6r9IHzB2vvNKaNO8TAaPvTk
         mkkloq2PbbX+/sf8885x99QmL4FzfLfdn3CJM8aVt9giirFrUFSviDDcnaBv9oauyf3x
         1SFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676038051;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WjR5+rSVm40yBdy3S3lnrbU7QxgVcfkiS2VCusME+T0=;
        b=fUf9vNFr5m/x7Nrq4immynNvpGmxa8xIt++Bv9qYqZYNoiQbJKlPU6VTyWTZu56GcE
         qsoDCLRDJ9IRGPLK98OQRswGTj5GF2ioC6E3Vr1It+6p9ZKAHMTmXC3ffURnZl1vJpiF
         CK3pDQDupArZYd170nNLc0O/T3zj7vcak1YNMqsbSeBxNV7/DgG4WqLOLoA3jP8DafOy
         gBKmcNqjP+wQi+iI9EmxnAw9psm4qEpadlxze9YmX+WlhlwNfOXLh9boZYm4C7YyKeTN
         7+wPCAeC5ZHYsHFe+ZJvjsaOfykomzTrw6PuAXeDlhe9UfuHBmCs6S2BXnLgxY4CkJBn
         ch3g==
X-Gm-Message-State: AO0yUKX6+jYgHR9Sz3OV3DBuNXA8CL0AiIQBEPRXxpUfpTQHRPMSoUzA
        4jFpJu5qic3Yk84pKRyzHFQpVG7RO7A4/ZHPevaVoUtskH66VA==
X-Google-Smtp-Source: AK7set/Jo4gKIUwff4a6qgDA1odVvZmmFwCFwWQuhamFYv7xiwh9EILqfVOSA248DAKI2DKihVdtP0iTlUy67PuZH6A=
X-Received: by 2002:a67:ab46:0:b0:3ff:d4df:3611 with SMTP id
 k6-20020a67ab46000000b003ffd4df3611mr3507671vsh.0.1676038051029; Fri, 10 Feb
 2023 06:07:31 -0800 (PST)
MIME-Version: 1.0
References: <20230210135136.1115213-1-rkanwal@rivosinc.com>
In-Reply-To: <20230210135136.1115213-1-rkanwal@rivosinc.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Fri, 10 Feb 2023 19:37:19 +0530
Message-ID: <CAK9=C2VzZZLqOd_4gok5QMwmwz9NKYyVmDCzmCA7spohbq_zXg@mail.gmail.com>
Subject: Re: [PATCH 1/1] riscv/kvm: Fix VM hang in case of timer delta being zero.
To:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023 at 7:21 PM Rajnesh Kanwal <rkanwal@rivosinc.com> wrote:
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
> ./lkvm-static run -c1 --console virtio -p "earlycon root=/dev/vda" \
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

Please add the Fixes tag here.

> Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu_timer.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> index ad34519c8a13..3ac2ff6a65da 100644
> --- a/arch/riscv/kvm/vcpu_timer.c
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -147,10 +147,8 @@ static void kvm_riscv_vcpu_timer_blocking(struct kvm_vcpu *vcpu)
>                 return;
>
>         delta_ns = kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t);
> -       if (delta_ns) {
> -               hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
> -               t->next_set = true;
> -       }
> +       hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
> +       t->next_set = true;
>  }
>
>  static void kvm_riscv_vcpu_timer_unblocking(struct kvm_vcpu *vcpu)
> --
> 2.25.1
>
