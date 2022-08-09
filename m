Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F384158DCD1
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 19:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245284AbiHIRIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 13:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245144AbiHIRIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 13:08:10 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC6D20BD1
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 10:08:08 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 7so19403545ybw.0
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 10:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=bepKw/LEtAGRfDcwveDu9uQHog0KI2Ak5eWQ5Bh1L6c=;
        b=Bu0RWS8B/pKGZqeXil99Hd+xifsOSY94tVAatqvQ956DT2XUBDWf3L62iEJ1nlLRHN
         +VHNyGHI0svtzTTu7HCgURdaKyzT0hZXkZVuqi1s+wuPcZjt9G+Y7VuW69jux1R8FZD0
         Wux70e6GEJi+E2bj5AtDlHhxNdQG2ZpisvYdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=bepKw/LEtAGRfDcwveDu9uQHog0KI2Ak5eWQ5Bh1L6c=;
        b=5lD2HhXjFkyHoir2NQ/maY7tbglUAAt3Mt+ENC8VzWRL3RYc/cXm+CsXKpeqBFu34r
         ieE2i3WQ1hunESp45rjZAqjsLaJF77iEbPatkGzpbJ77YXubmjug4w4MtNM2HnjjbYtQ
         quoWKm1jaUMmpc8CTM2yFvOsk6OJVDoQKo8ZG2Q5hn8cYM1wJgJeHgkzZOrysY7Ke3F9
         ORY9FJiaDyw/q250vUhaL6V5RFI/0wuf2reUuGQF1r2r9XSQAUMK+PgEgOhP+YYj/oQ+
         l3+CmeCX97v2TY+6L7NkIY7Wn+zHhHaRBQDCa4v43FzjFaOV3qnGsa/aSBbLnVevmLsc
         NtWQ==
X-Gm-Message-State: ACgBeo0Kfgyu+DHqDutySXJ9WMHOlxQzJ9vNIkyJzI/KGgwuvmJBH9uz
        CMIakg4VI5sbFUB+tzmsogSnMM/aaQIFjob/72+6
X-Google-Smtp-Source: AA6agR4sATcRkB2d0u/CrgxX/HJwI6/I9eM5hDsVMbdUeC4uqpTwesM5LXawIa2GRbCVrUAjXoWrtTDWp300zVQ0g10=
X-Received: by 2002:a5b:40a:0:b0:670:ee95:c8f1 with SMTP id
 m10-20020a5b040a000000b00670ee95c8f1mr21385580ybp.121.1660064887851; Tue, 09
 Aug 2022 10:08:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220722165047.519994-1-atishp@rivosinc.com> <20220722165047.519994-4-atishp@rivosinc.com>
In-Reply-To: <20220722165047.519994-4-atishp@rivosinc.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 9 Aug 2022 10:07:56 -0700
Message-ID: <CAOnJCUJ246giiHpSFSe_B1wjwxrYGpKJF-VeGLL_QBmBO7Zfvw@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] RISC-V: Prefer sstc extension if available
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Palmer Dabbelt <palmer@dabbelt.com>
Cc:     linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022 at 9:50 AM Atish Patra <atishp@rivosinc.com> wrote:
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

Hi Daniel,
Can you please review/ack this patch whenever you get a chance ?


-- 
Regards,
Atish
