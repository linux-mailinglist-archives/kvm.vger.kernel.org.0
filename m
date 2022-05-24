Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3733D532909
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 13:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbiEXLai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 07:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236644AbiEXLaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 07:30:30 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB72880C6
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:30:28 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j25so835364wrb.6
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N2TjPYBfTxyr+DNrjNs2M1CQcfw6+WY+gUO3SgZbUV8=;
        b=CQm5UAeg1hkuSSsutDNG5mlSigGV02SDoqjU1pCYNr5ah4YevJSWr4AlQwCQwgTADA
         Rzxq6t0CYWD0MFIzFIMr8eEcThDGPSsKmJB+J43x5VewBMw0wOPN2v2sStD1uD0CcV+5
         lMhPO2CuOIiIyfabVPzeLQkFQw3i4iUfhB6CvZq0HgMiLGJ9R+khlNSwcUZoVI1v6JQR
         fTaGOLJvyrOqKxqeBpyObRLnv8m9iFNcnorpjp5Mljh3Ks4i8eq6kH09cHJ7FGZCKoAC
         lcYTWNKaE1FjnBW/gzO2bfzncP4dWIxk6CQQa0GO/H2gXyL+cEaFFy6ge2aJgxMRwU0h
         e4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N2TjPYBfTxyr+DNrjNs2M1CQcfw6+WY+gUO3SgZbUV8=;
        b=WR8ibcZDfBLzCz9fwcMrEmfKVxt/2RUMSghbvNoK5eog46cf4xrUGKlHeJRb3wfenX
         k7opr0al0valzCu6FZrkq5h4x+BqbzdfwTLEUHvZqcwcL/wSYjZRD1QlO/kzEY6ARf1b
         UuW1c1zKVI+dtzaSLRR9ONHGaFNhOQ30IsxkDhoxojDSg5FYoF0tdFOFYFmKdGRDb61A
         3YI5xo0ZnpRlqWS/Bg+KuZT39+BhVaRWdyuMgr1vbAugwaTKVsLzB15M+safH3a+KZ3B
         gLICf1TOS6YvGZdqLBXvR0C7WSErYdZHOt6HZl5Hr6SBShGuXnZXtuymVbUVJ8KnMQ1E
         0bOw==
X-Gm-Message-State: AOAM530xTY2MSF2Oa4/txqKmegyeCoKsGZ15jEFRSziEQCN/xUI8M24e
        /MSYujUd3bFEnB5wB6dQirB35s6Xug5xzyEvdjQIOQ==
X-Google-Smtp-Source: ABdhPJws54/M5QyP1Iw/wARcBHxmm+RAXDaP8SIQZviMCw/5pFWp7jBzGSkS9YpnQFEjlgFR7cqirFzWu6hfZyEmRI8=
X-Received: by 2002:adf:f001:0:b0:20d:22b:183c with SMTP id
 j1-20020adff001000000b0020d022b183cmr22457285wro.313.1653391826736; Tue, 24
 May 2022 04:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220426185245.281182-1-atishp@rivosinc.com> <20220426185245.281182-4-atishp@rivosinc.com>
In-Reply-To: <20220426185245.281182-4-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 24 May 2022 17:00:15 +0530
Message-ID: <CAAhSdy0wbokRNZrXYcARKx=DpGfQ5gFGJ_1K26U0W99-jZcM5g@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] RISC-V: Prefer sstc extension if available
To:     Atish Patra <atishp@rivosinc.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Atish Patra <atishp@atishpatra.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        DTML <devicetree@vger.kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 27, 2022 at 12:23 AM Atish Patra <atishp@rivosinc.com> wrote:
>
> RISC-V ISA has sstc extension which allows updating the next clock event
> via a CSR (stimecmp) instead of an SBI call. This should happen dynamically
> if sstc extension is available. Otherwise, it will fallback to SBI call
> to maintain backward compatibility.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/clocksource/timer-riscv.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
> index 1767f8bf2013..d9398ae84a20 100644
> --- a/drivers/clocksource/timer-riscv.c
> +++ b/drivers/clocksource/timer-riscv.c
> @@ -23,11 +23,24 @@

Add "#define pr_fmt(fmt)" here since you are using pr_info(...)

>  #include <asm/sbi.h>
>  #include <asm/timex.h>
>
> +static DEFINE_STATIC_KEY_FALSE(riscv_sstc_available);
> +
>  static int riscv_clock_next_event(unsigned long delta,
>                 struct clock_event_device *ce)
>  {
> +       uint64_t next_tval = get_cycles64() + delta;

Use "u64" here to be consistent with other parts of the kernel.

> +
>         csr_set(CSR_IE, IE_TIE);
> -       sbi_set_timer(get_cycles64() + delta);
> +       if (static_branch_likely(&riscv_sstc_available)) {
> +#if __riscv_xlen == 32

Use CONFIG_32BIT here.

> +               csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
> +               csr_write(CSR_STIMECMPH, next_tval >> 32);
> +#else
> +               csr_write(CSR_STIMECMP, next_tval);
> +#endif
> +       } else
> +               sbi_set_timer(next_tval);
> +
>         return 0;
>  }
>
> @@ -165,6 +178,12 @@ static int __init riscv_timer_init_dt(struct device_node *n)
>         if (error)
>                 pr_err("cpu hp setup state failed for RISCV timer [%d]\n",
>                        error);
> +
> +       if (riscv_isa_extension_available(NULL, SSTC)) {
> +               pr_info("Timer interrupt in S-mode is available via sstc extension\n");
> +               static_branch_enable(&riscv_sstc_available);
> +       }
> +
>         return error;
>  }
>
> --
> 2.25.1
>

Regards,
Anup
