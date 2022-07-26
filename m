Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB36580AE2
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 07:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiGZFtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 01:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiGZFts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 01:49:48 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C081FCFB
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 22:49:45 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-31d85f82f0bso131324277b3.7
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 22:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wC2AgKCkoa/FuALgKTQYRYYG1SVq93t6JSMuNrwiiVQ=;
        b=F4isfSDJdigZd5IbUyJaKZkLsqKJ0djQ5AJsNPp5sk3hO0Srpfu02Gd+HPjkgrz5wo
         O+PaCOQyaFPTLB4WTUB8yVUUezS7JlUl8/ZSoHLcV6jckZwGIHBJ1tZepFRTGIu7NQS5
         H6jeRvyaDzVzWFxtir2ln7IMoyaT6NHB+P+ew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wC2AgKCkoa/FuALgKTQYRYYG1SVq93t6JSMuNrwiiVQ=;
        b=YK/T+L4achpV52rF+ne1u7MBSXT0EDKdVSEJMlTxUHVMjL5Lm9vJK9Nkeo+hizuPMH
         rB9K4a5F5RyIyKBx1ig3VzP6wsXtgehRTOYwA5RSdtFubLBQPUPfhIEm2MPJ41Yq3XcE
         Q+QOvzj1GRekofb0gj/pXxiLJXfexbQDVz1irjlqV7svCVmgyQXs3ux/55EWhZlzoeDJ
         GqYCDnzDTwQJ0nVzNV3hDvx0EEzVw9jVdgsPwLmN4Y1dJr+cgboypZ5NGMPNebqt7lHn
         jE/GnAqncxmrOlG6XjZ04KEnBHN+q2RJLXjKvp2guhs+mxhoaKDFH13Q7h/Pcs6Zwmxk
         hkpQ==
X-Gm-Message-State: AJIora8Dr7TXEMio8ZCEnq6S2eLKRk29Pd4XDW9QJfAXwf0mZbQuEen/
        jkfB7tNp56/3V+U6X+FnGEyBAp0YMoek5/a04fKK
X-Google-Smtp-Source: AGRyM1ui8146ZmRckyLg9qtt9W1JTT+gVnn4Uua002pEWROvnIjWvUOUDn+8rcpNk56CG05r6u+sWklRBNPaopmmcSU=
X-Received: by 2002:a81:7589:0:b0:31e:620b:e75 with SMTP id
 q131-20020a817589000000b0031e620b0e75mr12770978ywc.482.1658814584983; Mon, 25
 Jul 2022 22:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220722165047.519994-1-atishp@rivosinc.com> <20220722165047.519994-4-atishp@rivosinc.com>
In-Reply-To: <20220722165047.519994-4-atishp@rivosinc.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 25 Jul 2022 22:49:34 -0700
Message-ID: <CAOnJCUK1JppQkZ+bv7mNpCm95i3gGZ5wHaRc2wiBGyp3zj2Dhw@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] RISC-V: Prefer sstc extension if available
To:     Atish Patra <atishp@rivosinc.com>, Stephen Boyd <sboyd@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Hi Stephen,
Can you please review this whenever you get a chance ? We probably
need an ACK at least :)

-- 
Regards,
Atish
