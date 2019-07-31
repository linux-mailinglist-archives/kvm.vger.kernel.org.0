Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13107BAA6
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 09:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbfGaHYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 03:24:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36649 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfGaHYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 03:24:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so68513527wrs.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 00:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2evDZYZurYJQbFSuSciK2TUoh0fXPuEDQACEld/aYOg=;
        b=A75tXU1odVHd2oqqipCCjQrkrK+gkBSiyV5g3p2eGuJLxhvTDMB7LZfPS25FJ6rxLw
         K1sYCoBGplsoVDFyP5m/AaR0wQqHdkVoqTeF5PUjJzkpUev3f1V8KC+teaciof3/4q9J
         eC2eHJreipGNgoQzyt5J7mNVbNZCfLP+l45JPeHfTCHIsJyOyOuys8lmOCwU1BqwwhpL
         1fZdUQY4APgMTlNqWvRv+FmO+1ElL6PQjEj3xbRidCfT3XQ43w+eP9KrFFE6NATFJmKF
         VhZCjgGmvz7G05AZ5fqiXLZyzHQrs45lgMF7sx7oy69fRDwtk9wFLndZeVUDw5JU6+CK
         bIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2evDZYZurYJQbFSuSciK2TUoh0fXPuEDQACEld/aYOg=;
        b=W85CpfVK+vebHJGNObTWLENTo2JvGh8QSLIv35t2Joi/2JAlnpxSysUzwEyLXCstJs
         CxQ8ZX28lllMLRXP8UDOP7NsVIGt0rNP5Ou27h/Jh3FDrG8h69i4vcRhyvb39Z8ByFB2
         f6CCArAUSgVn8NmUBGw4pNgJGyVZfhzwJzB+eXlip8+qLzTzACpZ8kdZtnvY7ZMHesgn
         PrZM7O33QzPVmgUDnm72X68y/C3ZYKPhFlGg6wPLReK674940Vjosa+FYXHF0OAV2LL7
         5Hs/jMCfS4OQQkrLHDNwP23uWCGqTpmGA/nn8WQC5+IX83kYiEkWRJp8hN62vkoLTMPI
         Mzag==
X-Gm-Message-State: APjAAAXJRWA1P0iEgWolMcPvAZjGymq0tm00vTZ26qP0glkU0W0EvNTJ
        oXZcK6HNfJ+IyyX+uOKnmuo10xwe35aEXsCuIGQ=
X-Google-Smtp-Source: APXvYqwuN6IBm0tVgx0DbJMkVlA5+z7xdtFRwEmr06AoaLDh/qCzFrlo7pERQF4wqinABZXnPNRDN2ZbRxDtrHkTMz4=
X-Received: by 2002:a5d:5448:: with SMTP id w8mr131770724wrv.180.1564557845356;
 Wed, 31 Jul 2019 00:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <20190729115544.17895-9-anup.patel@wdc.com>
 <05d41219-6c0c-8851-dab6-24f9c76aed57@redhat.com>
In-Reply-To: <05d41219-6c0c-8851-dab6-24f9c76aed57@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 31 Jul 2019 12:53:54 +0530
Message-ID: <CAAhSdy2ZiYYbg0oaNW_bnbdaHw+up9Ah0faoE5T+qr=-CTA3pw@mail.gmail.com>
Subject: Re: [RFC PATCH 08/16] RISC-V: KVM: Handle MMIO exits for VCPU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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

On Tue, Jul 30, 2019 at 4:50 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 29/07/19 13:57, Anup Patel wrote:
> > +static ulong get_insn(struct kvm_vcpu *vcpu)
> > +{
> > +     ulong __sepc = vcpu->arch.guest_context.sepc;
> > +     ulong __hstatus, __sstatus, __vsstatus;
> > +#ifdef CONFIG_RISCV_ISA_C
> > +     ulong rvc_mask = 3, tmp;
> > +#endif
> > +     ulong flags, val;
> > +
> > +     local_irq_save(flags);
> > +
> > +     __vsstatus = csr_read(CSR_VSSTATUS);
> > +     __sstatus = csr_read(CSR_SSTATUS);
> > +     __hstatus = csr_read(CSR_HSTATUS);
> > +
> > +     csr_write(CSR_VSSTATUS, __vsstatus | SR_MXR);
> > +     csr_write(CSR_SSTATUS, vcpu->arch.guest_context.sstatus | SR_MXR);
> > +     csr_write(CSR_HSTATUS, vcpu->arch.guest_context.hstatus | HSTATUS_SPRV);
> > +
> > +#ifndef CONFIG_RISCV_ISA_C
> > +     asm ("\n"
> > +#ifdef CONFIG_64BIT
> > +             STR(LWU) " %[insn], (%[addr])\n"
> > +#else
> > +             STR(LW) " %[insn], (%[addr])\n"
> > +#endif
> > +             : [insn] "=&r" (val) : [addr] "r" (__sepc));
> > +#else
> > +     asm ("and %[tmp], %[addr], 2\n"
> > +             "bnez %[tmp], 1f\n"
> > +#ifdef CONFIG_64BIT
> > +             STR(LWU) " %[insn], (%[addr])\n"
> > +#else
> > +             STR(LW) " %[insn], (%[addr])\n"
> > +#endif
> > +             "and %[tmp], %[insn], %[rvc_mask]\n"
> > +             "beq %[tmp], %[rvc_mask], 2f\n"
> > +             "sll %[insn], %[insn], %[xlen_minus_16]\n"
> > +             "srl %[insn], %[insn], %[xlen_minus_16]\n"
> > +             "j 2f\n"
> > +             "1:\n"
> > +             "lhu %[insn], (%[addr])\n"
> > +             "and %[tmp], %[insn], %[rvc_mask]\n"
> > +             "bne %[tmp], %[rvc_mask], 2f\n"
> > +             "lhu %[tmp], 2(%[addr])\n"
> > +             "sll %[tmp], %[tmp], 16\n"
> > +             "add %[insn], %[insn], %[tmp]\n"
> > +             "2:"
> > +     : [vsstatus] "+&r" (__vsstatus), [insn] "=&r" (val),
> > +       [tmp] "=&r" (tmp)
> > +     : [addr] "r" (__sepc), [rvc_mask] "r" (rvc_mask),
> > +       [xlen_minus_16] "i" (__riscv_xlen - 16));
> > +#endif
> > +
> > +     csr_write(CSR_HSTATUS, __hstatus);
> > +     csr_write(CSR_SSTATUS, __sstatus);
> > +     csr_write(CSR_VSSTATUS, __vsstatus);
> > +
> > +     local_irq_restore(flags);
> > +
> > +     return val;
> > +}
> > +
>
> This also needs fixups for exceptions, because the guest can race
> against the host and modify its page tables concurrently with the
> vmexit.  (How effective this is, of course, depends on how the TLB is
> implemented in hardware, but you need to do the safe thing anyway).

For Guest with single VCPU, we won't see any issue but we might
get an exception for Guest with multiple VCPUs. We have added this
in our TODO list.

In this context, I have proposed to have separate CSR holding trapped
instruction value so that we don't need to use unpriv load/store for figuring
out trapped instruction.

Refer, https://github.com/riscv/riscv-isa-manual/issues/394

The above Github issue and missing time delta CSR will be last
two unaddressed Github issues from RISC-V spec perspective.

Regards,
Anup
