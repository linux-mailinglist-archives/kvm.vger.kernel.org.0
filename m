Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DA758ADF4
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 18:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241038AbiHEQRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 12:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbiHEQRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 12:17:47 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6418248E95
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 09:17:46 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-31f661b3f89so28515427b3.11
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 09:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=eU9F5KTyLXS6Ehm35W4ZJ4KkazoKzToP1yWNY4wU9Kg=;
        b=OTIMcxvVmtHvZYnx9w+o/IIVHMVnFTjtZpg0iBHBJF/Skq2sQZgscB+aLiUJLN0sfj
         ysp6VTKukTmrHLmujjUvOzPbY2bFxqoHBmuaRFR/pAJBoyv7X1Nu520OafIyx6Qr6bOV
         +R3D5siCAJFSmOozQy6OIy6w4KtvhRp01pfrA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=eU9F5KTyLXS6Ehm35W4ZJ4KkazoKzToP1yWNY4wU9Kg=;
        b=BccEsY+w+lpDP63Pg79PKnX3nfzSRptTXIdbiAov0J0qBYNyEWKFZtv50BLlFBY/P2
         4suqzgZyzUPJt3n5SjnCj4wQrQyKKv+3V+Yr9UB7SeP7LtMlDNnvYrpqSeTHqipJ+6Nb
         0HISMSZQo96R+cozsQ5rF23YT7TRrEPnQlyJ6Gr+vnLzewzoUJF5qm+ITIRkNPwAItnL
         /Ts59YBi2pI7ycjqCJP+C0G00xZRw9vL4DA0eqW8bgyKo3ZvmdwUuMJfWClrGzX0fXoy
         7bp3t4pRJjISOigX+81+HOeNmFTK6w5wLDkh+yexFS9foxEzF6loXlIY9VO3oC4pVh53
         GCcA==
X-Gm-Message-State: ACgBeo3rpiyRkNO8nIQ5VfRf5lzPddEtZKz/NsZN4TkutLgeHMofUxTD
        k0J10xPE9JyxdKWJzDpqgldJ77onar5FqCbrNTmN
X-Google-Smtp-Source: AA6agR62cKws3SRTlgdcM1pts0cZpN6r3mdMoI/TrJcr4NwaVIxxT+6rUb3vilx/LYfVks/NtNXlI1usDhozpgqRr64=
X-Received: by 2002:a81:5251:0:b0:31f:56c6:b69 with SMTP id
 g78-20020a815251000000b0031f56c60b69mr6801352ywb.75.1659716265625; Fri, 05
 Aug 2022 09:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220722165047.519994-1-atishp@rivosinc.com> <20220722165047.519994-4-atishp@rivosinc.com>
 <CAOnJCUK1JppQkZ+bv7mNpCm95i3gGZ5wHaRc2wiBGyp3zj2Dhw@mail.gmail.com>
In-Reply-To: <CAOnJCUK1JppQkZ+bv7mNpCm95i3gGZ5wHaRc2wiBGyp3zj2Dhw@mail.gmail.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Fri, 5 Aug 2022 09:17:35 -0700
Message-ID: <CAOnJCUJrwVim1c8BpLYrHUAhHc-jO8w_wV5EuBc_3DhSb8DjLQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] RISC-V: Prefer sstc extension if available
To:     Stephen Boyd <sboyd@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Atish Patra <atishp@rivosinc.com>,
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 25, 2022 at 10:49 PM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Fri, Jul 22, 2022 at 9:50 AM Atish Patra <atishp@rivosinc.com> wrote:
> >
> > RISC-V ISA has sstc extension which allows updating the next clock event
> > via a CSR (stimecmp) instead of an SBI call. This should happen dynamically
> > if sstc extension is available. Otherwise, it will fallback to SBI call
> > to maintain backward compatibility.
> >
> > Reviewed-by: Anup Patel <anup@brainfault.org>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  drivers/clocksource/timer-riscv.c | 25 ++++++++++++++++++++++++-
> >  1 file changed, 24 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
> > index 593d5a957b69..05f6cf067289 100644
> > --- a/drivers/clocksource/timer-riscv.c
> > +++ b/drivers/clocksource/timer-riscv.c
> > @@ -7,6 +7,9 @@
> >   * either be read from the "time" and "timeh" CSRs, and can use the SBI to
> >   * setup events, or directly accessed using MMIO registers.
> >   */
> > +
> > +#define pr_fmt(fmt) "riscv-timer: " fmt
> > +
> >  #include <linux/clocksource.h>
> >  #include <linux/clockchips.h>
> >  #include <linux/cpu.h>
> > @@ -20,14 +23,28 @@
> >  #include <linux/of_irq.h>
> >  #include <clocksource/timer-riscv.h>
> >  #include <asm/smp.h>
> > +#include <asm/hwcap.h>
> >  #include <asm/sbi.h>
> >  #include <asm/timex.h>
> >
> > +static DEFINE_STATIC_KEY_FALSE(riscv_sstc_available);
> > +
> >  static int riscv_clock_next_event(unsigned long delta,
> >                 struct clock_event_device *ce)
> >  {
> > +       u64 next_tval = get_cycles64() + delta;
> > +
> >         csr_set(CSR_IE, IE_TIE);
> > -       sbi_set_timer(get_cycles64() + delta);
> > +       if (static_branch_likely(&riscv_sstc_available)) {
> > +#if defined(CONFIG_32BIT)
> > +               csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
> > +               csr_write(CSR_STIMECMPH, next_tval >> 32);
> > +#else
> > +               csr_write(CSR_STIMECMP, next_tval);
> > +#endif
> > +       } else
> > +               sbi_set_timer(next_tval);
> > +
> >         return 0;
> >  }
> >
> > @@ -165,6 +182,12 @@ static int __init riscv_timer_init_dt(struct device_node *n)
> >         if (error)
> >                 pr_err("cpu hp setup state failed for RISCV timer [%d]\n",
> >                        error);
> > +
> > +       if (riscv_isa_extension_available(NULL, SSTC)) {
> > +               pr_info("Timer interrupt in S-mode is available via sstc extension\n");
> > +               static_branch_enable(&riscv_sstc_available);
> > +       }
> > +
> >         return error;
> >  }
> >
> > --
> > 2.25.1
> >
>
> Hi Stephen,
> Can you please review this whenever you get a chance ? We probably
> need an ACK at least :)
>

Ping ?

> --
> Regards,
> Atish



-- 
Regards,
Atish
