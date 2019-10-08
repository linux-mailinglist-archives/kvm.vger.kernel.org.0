Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3634CF14C
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 05:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbfJHDdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 23:33:04 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38548 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729832AbfJHDdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 23:33:04 -0400
Received: by mail-ot1-f66.google.com with SMTP id e11so12906627otl.5
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 20:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yuW76c0/ER82/tkCBIRalTq4scViyGLhE1Z95m1TAug=;
        b=Fts0c2I0YcUgXi30eEOJd03JfJk6nxgfrygQ6EDM9HGxGTsxumuUVaPrG7pqctWpij
         JnUFC8o1SSj8dBi0BPFspg8NitgFBbd1UaTO3rxCH5/sAUPj9IhVZX1EH+VDa9RH30kX
         IyeM2VMxe22rlwo+kNj+1QfQgZC0IhgXYeZMblAr1+UeqjjteX70t12nshIDflRtikB0
         JpMfCZUupsdJLVOTO9Mojv63SxT2V03O5CrYWs/cr6L+bg+uxu2pAB7tVJ+t5LnmZLlZ
         udeV4hv6NTtTuuI3RTvEaqXIK3zmyYNrjcScPB15AFzMoJz2zErjlqh4UhAEb/uMnfzU
         iHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yuW76c0/ER82/tkCBIRalTq4scViyGLhE1Z95m1TAug=;
        b=UZof1ZyJks6OO0djK9K8eH02cFT7dgsSR4Hp0H3rRnHJfKkjMTp9RGsRkMzsLIfaWM
         JnYy1Sn1r0WGEU4fKzSXBoKXPFZIeCE8n1YIfByPkUKqBUw6SNiPL4P38WFvuOh5rtjR
         Usybp/V4BvJHaiVQHZc5hjge+7muob0YsfFGX6GKMg+zRV+aVgJJbhtOjoS4RaJkPawY
         Eshh1xGFx8Fwtb5emGfdYbHUokZY9WUzpRPByLM47aH3TEfspU2N/IyT8LbWtjizfEa6
         16UWsqAl/HawXUjdDpL9VGsNdYRaTEFWnu+pR19ReIaluTB1c48n8Hn0/Hh+mDu+eacT
         f7Eg==
X-Gm-Message-State: APjAAAUzPqkB4GYVdvKx1ZSzROZvd64/7dfU6yCH+Ltl5kE9DRHQLrj9
        +4bmQU1BXZbNIJORxJeZsS/hrg0bGKXKwlMhkYg=
X-Google-Smtp-Source: APXvYqxcseVvFihJAVHaeLfdiZl4VG1tx23O5Rsl8W0LPCtopQzHtzPQURCefwalFKTD/MvV5LM0wfU3rffjUjG5ig8=
X-Received: by 2002:a9d:aa8:: with SMTP id 37mr22785406otq.56.1570505583446;
 Mon, 07 Oct 2019 20:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <1570116271-8038-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1570116271-8038-1-git-send-email-pbonzini@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 8 Oct 2019 11:32:52 +0800
Message-ID: <CANRm+Cz21QqUjoDMtj5Os0s63gJqL2LtCwVPdEsqGhuX=9Am7A@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] vmexit: measure IPI and EOI cost
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Oct 2019 at 00:00, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/vmexit.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/x86/vmexit.c b/x86/vmexit.c
> index 66d3458..81b743b 100644
> --- a/x86/vmexit.c
> +++ b/x86/vmexit.c
> @@ -65,22 +65,30 @@ static void nop(void *junk)
>  }
>
>  volatile int x = 0;
> +volatile uint64_t tsc_eoi = 0;
> +volatile uint64_t tsc_ipi = 0;
>
>  static void self_ipi_isr(isr_regs_t *regs)
>  {
>         x++;
> +       uint64_t start = rdtsc();
>         eoi();
> +       tsc_eoi += rdtsc() - start;
>  }
>
>  static void x2apic_self_ipi(int vec)
>  {
> +       uint64_t start = rdtsc();
>         wrmsr(0x83f, vec);
> +       tsc_ipi += rdtsc() - start;
>  }
>
>  static void apic_self_ipi(int vec)
>  {
> +       uint64_t start = rdtsc();
>          apic_icr_write(APIC_INT_ASSERT | APIC_DEST_SELF | APIC_DEST_PHYSICAL |
>                        APIC_DM_FIXED | IPI_TEST_VECTOR, vec);
> +       tsc_ipi += rdtsc() - start;
>  }
>
>  static void self_ipi_sti_nop(void)
> @@ -180,7 +188,9 @@ static void x2apic_self_ipi_tpr_sti_hlt(void)
>
>  static void ipi(void)
>  {
> +       uint64_t start = rdtsc();
>         on_cpu(1, nop, 0);
> +       tsc_ipi += rdtsc() - start;
>  }
>
>  static void ipi_halt(void)
> @@ -511,6 +521,7 @@ static bool do_test(struct test *test)
>         }
>
>         do {
> +               tsc_eoi = tsc_ipi = 0;
>                 iterations *= 2;
>                 t1 = rdtsc();
>
> @@ -523,6 +534,11 @@ static bool do_test(struct test *test)
>                 t2 = rdtsc();
>         } while ((t2 - t1) < GOAL);
>         printf("%s %d\n", test->name, (int)((t2 - t1) / iterations));
> +       if (tsc_ipi)
> +               printf("  ipi %s %d\n", test->name, (int)(tsc_ipi / iterations));
> +       if (tsc_eoi)
> +               printf("  eoi %s %d\n", test->name, (int)(tsc_eoi / iterations));
> +
>         return test->next;
>  }

Thanks for this, do you have more idea to optimize the virtual ipi latency?

    Wanpeng
