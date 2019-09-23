Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C109BB4FE
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405137AbfIWNKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:10:00 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56300 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404787AbfIWNJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:09:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id a6so9877078wma.5
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 06:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=POQzEF32pJw+JcJGYwatIQLE1EclVL51HgsgtLA7Qmw=;
        b=BX0d9fUZ89UyQbARi+EIiuQz7/skB03FkmvzPaRZR3ZECUUjvMHRyuchQCs+a9LAea
         2G+PIK23wzO+ITkoV9HFRLsgbyKRheMT1vim2zYSLgpWoWWc768/w/OGIxA96QWxNPvq
         SJEKRVfFuMmfOJ4unliQJ5+TqqUvYFiIxrGMrgtRcVF3bmfjsXCvhjEXGeLH1u++HYAe
         qbVfRinf3ErfTk1H3EIgzb+9pP38kcbHr+3YQCq6Js11GuGfHHbjTYGjPwlL63q3Y4/U
         SKvhbtyKQWs8UXSHYGStv9Jl55kLNR8viy0MdL8sHCwy11YhD12ccd5rFMgoUxtK2ykE
         sItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=POQzEF32pJw+JcJGYwatIQLE1EclVL51HgsgtLA7Qmw=;
        b=Vdaju+9tVIVXRDJU6RfT1GiXZ37dw7i63mEvsTIVbW5/ZdDsRl5tB6XHU2PT5a0nVY
         R9Cg4rBH8YeWpAbdA1cf2966VMNDe+gpJ/SEMmvUlnXs2wGn+YI0vn7E8BOZQOMp3vDA
         BGfzlIg3UK0Kdqfwu5PfQHOXQ4JXx28Suzex5/dKzuSIHNvTo1S5iUsTBK4lgRuV2zsp
         b+NWl2M0rjY/4c5zCBnFsBuoYFtznindwdUrSaGHgp4kuSpwBifzf2AtvJMrAl2L7msL
         eZz/lIZJzpnJ873Po3lM/laWE5p/6Wh4ZmxZqKs0u/u0ovvLhOl13+ansD3fsAxPvLyi
         MpCQ==
X-Gm-Message-State: APjAAAXaKkwovwH56H+PGa9wWx4Q9gZQPbeOxqR7+CPhUTdK8Bo0LwB0
        a8Tk1UnnLlJfcEnbl1uzhJEDYkGoEe6lvjs2jpuoCw==
X-Google-Smtp-Source: APXvYqxmSBlwd2lVkFWxE9RTK2LVohXpZcBHo1U2r2gpRoUOnN9IsM4d5615+AEz4vMLdLGhar/FgZSJ+9bVZz2tU3M=
X-Received: by 2002:a7b:c84f:: with SMTP id c15mr12094316wml.52.1569244194712;
 Mon, 23 Sep 2019 06:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190904161245.111924-1-anup.patel@wdc.com> <20190904161245.111924-12-anup.patel@wdc.com>
 <8c44ac8a-3fdc-b9dd-1815-06e86cb73047@redhat.com>
In-Reply-To: <8c44ac8a-3fdc-b9dd-1815-06e86cb73047@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 23 Sep 2019 18:39:43 +0530
Message-ID: <CAAhSdy1-1yxMnjzppmUBxtSOAuwWaPtNZwW+QH1O7LAnEVP8pg@mail.gmail.com>
Subject: Re: [PATCH v7 10/21] RISC-V: KVM: Handle MMIO exits for VCPU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 4:42 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/09/19 18:15, Anup Patel wrote:
> > +     unsigned long guest_sstatus =
> > +                     vcpu->arch.guest_context.sstatus | SR_MXR;
> > +     unsigned long guest_hstatus =
> > +                     vcpu->arch.guest_context.hstatus | HSTATUS_SPRV;
> > +     unsigned long guest_vsstatus, old_stvec, tmp;
> > +
> > +     guest_sstatus = csr_swap(CSR_SSTATUS, guest_sstatus);
> > +     old_stvec = csr_swap(CSR_STVEC, (ulong)&__kvm_riscv_unpriv_trap);
> > +
> > +     if (read_insn) {
> > +             guest_vsstatus = csr_read_set(CSR_VSSTATUS, SR_MXR);
>
> Is this needed?  IIUC SSTATUS.MXR encompasses a wider set of permissions:
>
>   The HS-level MXR bit makes any executable page readable.  {\tt
>   vsstatus}.MXR makes readable those pages marked executable at the VS
>   translation level, but only if readable at the guest-physical
>   translation level.
>
> So it should be enough to set SSTATUS.MXR=1 I think.  But you also
> shouldn't set SSTATUS.MXR=1 in the !read_insn case.

I was being overly cautious here. Initially, I thought SSTATUS.MXR
applies only to Stage2 and VSSTATUS.MXR applies only to Stage1.

I agree with you. The HS-mode should only need to set SSTATUS.MXR.

>
> Also, you can drop the irq save/restore (which is already a save/restore
> of SSTATUS) since you already write 0 to SSTATUS.SIE in your csr_swap.
> Perhaps add a BUG_ON(guest_sstatus & SR_SIE) before the csr_swap?

I had already dropped irq save/restore in v7 series and having BUG_ON()
on guest_sstatus here would be better.

>
> > +             asm volatile ("\n"
> > +                     "csrrw %[hstatus], " STR(CSR_HSTATUS) ", %[hstatus]\n"
> > +                     "li %[tilen], 4\n"
> > +                     "li %[tscause], 0\n"
> > +                     "lhu %[val], (%[addr])\n"
> > +                     "andi %[tmp], %[val], 3\n"
> > +                     "addi %[tmp], %[tmp], -3\n"
> > +                     "bne %[tmp], zero, 2f\n"
> > +                     "lhu %[tmp], 2(%[addr])\n"
> > +                     "sll %[tmp], %[tmp], 16\n"
> > +                     "add %[val], %[val], %[tmp]\n"
> > +                     "2: csrw " STR(CSR_HSTATUS) ", %[hstatus]"
> > +             : [hstatus] "+&r"(guest_hstatus), [val] "=&r" (val),
> > +               [tmp] "=&r" (tmp), [tilen] "+&r" (tilen),
> > +               [tscause] "+&r" (tscause)
> > +             : [addr] "r" (addr));
> > +             csr_write(CSR_VSSTATUS, guest_vsstatus);
>
> >
> > +#ifndef CONFIG_RISCV_ISA_C
> > +                     "li %[tilen], 4\n"
> > +#else
> > +                     "li %[tilen], 2\n"
> > +#endif
>
> Can you use an assembler directive to force using a non-compressed
> format for ld and lw?  This would get rid of tilen, which is costing 6
> bytes (if I did the RVC math right) in order to save two. :)

I tried looking for it but could not find any assembler directive
to selectively turn-off instruction compression.

>
> Paolo
>
> > +                     "li %[tscause], 0\n"
> > +#ifdef CONFIG_64BIT
> > +                     "ld %[val], (%[addr])\n"
> > +#else
> > +                     "lw %[val], (%[addr])\n"
> > +#endif

Regards,
Anup
