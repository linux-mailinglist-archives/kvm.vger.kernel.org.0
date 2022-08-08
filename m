Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C88D58C523
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 10:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238111AbiHHI5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 04:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiHHI5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 04:57:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F805D90;
        Mon,  8 Aug 2022 01:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5059B80E2F;
        Mon,  8 Aug 2022 08:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7477AC43140;
        Mon,  8 Aug 2022 08:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659949040;
        bh=41hkDjozTj/9771T7sIgIeayf3FHl7toj5PGFhaQaig=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dRlv8aBv9gmYQMMRysynhf3+XtHFgW0vc2MSDpq11XWpjmVBBFePhsFad6FIRSf1W
         tImr2wyVSdaBHT8jVVAQfiaytLde2W87xEJx4Df/laMM9224zInWE82a7NLGZrryuz
         2wtKizJOrLfkkMgUUNaO5tYKddjmEvijmG1/FbwM2BnXNXDpxjskwo5n3/RjUvHFUa
         N1me2DWIpOScQhDCo0zH5e7U0XnO0jGzxHrsiS6a1R4zmDmoyc7a/Brr4kPuG3cuWd
         JyqqkVDXHpjQsGSR+u4fr2n0qySMsY4Shs9RB6DPIJ/nF5UlzHVA7hUX3zJDEOAfCc
         qAg4YUBkDJpVQ==
Received: by mail-ot1-f52.google.com with SMTP id m22-20020a0568301e7600b006369227f745so6053488otr.7;
        Mon, 08 Aug 2022 01:57:20 -0700 (PDT)
X-Gm-Message-State: ACgBeo2BKF0Lmw9t2IJMiiXC6DdzkaiQUI+In5GVCrNP6R/Jx13/xEtr
        tRmDWI0/vP2V6EAOewUkAB6Bcb+64XgBJ9hV2T0=
X-Google-Smtp-Source: AA6agR5Ts3sAfj1MljLE3v8RoF3iPVaZ/RVb7hUbopz7S2rwzd3IMWydqeAW1PpniXu8oQ28JweXQ0oxg2FizGG4Lyk=
X-Received: by 2002:a05:6830:928:b0:636:aaa7:813b with SMTP id
 v40-20020a056830092800b00636aaa7813bmr5058008ott.140.1659949039556; Mon, 08
 Aug 2022 01:57:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220722165047.519994-1-atishp@rivosinc.com> <20220722165047.519994-4-atishp@rivosinc.com>
In-Reply-To: <20220722165047.519994-4-atishp@rivosinc.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Mon, 8 Aug 2022 16:57:07 +0800
X-Gmail-Original-Message-ID: <CAJF2gTR8yOwHNJBvq07eNTBAHansRhDq57HYrUYLnRV+WuSD_g@mail.gmail.com>
Message-ID: <CAJF2gTR8yOwHNJBvq07eNTBAHansRhDq57HYrUYLnRV+WuSD_g@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] RISC-V: Prefer sstc extension if available
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good to me. The patch is concise, and static_branch is properly used.

Reviewed-by: Guo Ren <guoren@kernel.org>

On Sat, Jul 23, 2022 at 12:51 AM Atish Patra <atishp@rivosinc.com> wrote:
>
> RISC-V ISA has sstc extension which allows updating the next clock event
> via a CSR (stimecmp) instead of an SBI call. This should happen dynamically
> if sstc extension is available. Otherwise, it will fallback to SBI call
> to maintain backward compatibility.
>
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/clocksource/timer-riscv.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
> index 593d5a957b69..05f6cf067289 100644
> --- a/drivers/clocksource/timer-riscv.c
> +++ b/drivers/clocksource/timer-riscv.c
> @@ -7,6 +7,9 @@
>   * either be read from the "time" and "timeh" CSRs, and can use the SBI to
>   * setup events, or directly accessed using MMIO registers.
>   */
> +
> +#define pr_fmt(fmt) "riscv-timer: " fmt
> +
>  #include <linux/clocksource.h>
>  #include <linux/clockchips.h>
>  #include <linux/cpu.h>
> @@ -20,14 +23,28 @@
>  #include <linux/of_irq.h>
>  #include <clocksource/timer-riscv.h>
>  #include <asm/smp.h>
> +#include <asm/hwcap.h>
>  #include <asm/sbi.h>
>  #include <asm/timex.h>
>
> +static DEFINE_STATIC_KEY_FALSE(riscv_sstc_available);
> +
>  static int riscv_clock_next_event(unsigned long delta,
>                 struct clock_event_device *ce)
>  {
> +       u64 next_tval = get_cycles64() + delta;
> +
>         csr_set(CSR_IE, IE_TIE);
> -       sbi_set_timer(get_cycles64() + delta);
> +       if (static_branch_likely(&riscv_sstc_available)) {
> +#if defined(CONFIG_32BIT)
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
> @@ -165,6 +182,12 @@ static int __init riscv_timer_init_dt(struct device_node *n)
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


-- 
Best Regards
 Guo Ren
