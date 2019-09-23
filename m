Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8BA1BB479
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 14:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439709AbfIWMyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 08:54:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41383 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439698AbfIWMyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 08:54:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id h7so13804964wrw.8
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 05:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AovsfvrkVC8KgehdY4+Z592P7dBIQY37LqoSTZ8Zeho=;
        b=HYeBM2QpSXqbmldBl/VrqKVlCePEW918eFcjyJyHTWUNdbLCTZvsYKhdc8gAKYhMQ3
         onS/RCKaAqam1IA/rnrzUrG+d7bZJr2jWsdDZkfh4si4j5R5w4HYXf0LAGhhfEQta0VH
         kOBETSMUfxF4BbeVChawSoHw5c/AqsVpt+ZYrtYpzU7nRnQBVA20F3pvTns/+ea10zfQ
         3lBnqyOgUJHfGIr8j6LZs4YD/QrIBGZVH71lwS4eH1TSI15nbdNFNbGMZDcU0+pPHYDb
         fKiRaH3Q7y7oQ6BZr9K95rEDYWpXA3J7EJA9gsU8++gi2Mp8u0O7xXR4hJuREj8UxXok
         ifZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AovsfvrkVC8KgehdY4+Z592P7dBIQY37LqoSTZ8Zeho=;
        b=Kd8+q0u2msw7S2/40NOn2MCKDEyGoY67CxLs4zZYTEawoYQm4KYD1V8W2GB4rQBpCy
         2mqm/67M53JNiJCOdvVFgNSQLvkrYNJBmKd99zhzDBnxo+8calfRMy9P+pxX3zxh6mvk
         iNq4Ux78z6IAEajh1PW+zwzJhD8fQAlvx01u5oddUKl5R/IXBPuG/tn3GG8WZqOjYpor
         x+F2GhAdlSO58XART1fpO88dtfzYiZEPC0PNULGmBZRc/lXcp7jeRPs6YHkgWeTs5tXT
         wimKHKlYJ5bDR92lFh2xiBsoCFY5Exx2ubWfcgHyrOHwEqyL9oAv6F4xSlxrNFBGMRTW
         wz+w==
X-Gm-Message-State: APjAAAX8KBnYudezplKKKKWQ/1UNTW7uOK3goI8tKXYQXQVOlS8VsmZ9
        NMCXCMvMOzmk0aqlUv2617Yf0lr7EO5xsND+F1pdHw==
X-Google-Smtp-Source: APXvYqwsHYbO+9L86VnJoBwoB8mk7eZ22lokkO725a1cKAw31Hv4kO0LqdHgIV0+Yju7xAlyzJlQVzY0aMbR9OJm2Ec=
X-Received: by 2002:a05:6000:2:: with SMTP id h2mr20587928wrx.309.1569243255021;
 Mon, 23 Sep 2019 05:54:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190904161245.111924-1-anup.patel@wdc.com> <20190904161245.111924-13-anup.patel@wdc.com>
 <3c149ec4-38df-9073-2880-b28148d3c059@amazon.com>
In-Reply-To: <3c149ec4-38df-9073-2880-b28148d3c059@amazon.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 23 Sep 2019 18:24:02 +0530
Message-ID: <CAAhSdy1A-FZJ5DeyzFzZn8h-Vs4QR16uFgeeCNpJi2KMQMbPmQ@mail.gmail.com>
Subject: Re: [PATCH v7 11/21] RISC-V: KVM: Handle WFI exits for VCPU
To:     Alexander Graf <graf@amazon.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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

On Mon, Sep 23, 2019 at 12:24 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 04.09.19 18:15, Anup Patel wrote:
> > We get illegal instruction trap whenever Guest/VM executes WFI
> > instruction.
> >
> > This patch handles WFI trap by blocking the trapped VCPU using
> > kvm_vcpu_block() API. The blocked VCPU will be automatically
> > resumed whenever a VCPU interrupt is injected from user-space
> > or from in-kernel IRQCHIP emulation.
> >
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >   arch/riscv/kvm/vcpu_exit.c | 72 ++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 72 insertions(+)
> >
> > diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> > index d75a6c35b6c7..39469f67b241 100644
> > --- a/arch/riscv/kvm/vcpu_exit.c
> > +++ b/arch/riscv/kvm/vcpu_exit.c
> > @@ -12,6 +12,13 @@
> >   #include <linux/kvm_host.h>
> >   #include <asm/csr.h>
> >
> > +#define INSN_OPCODE_MASK     0x007c
> > +#define INSN_OPCODE_SHIFT    2
> > +#define INSN_OPCODE_SYSTEM   28
> > +
> > +#define INSN_MASK_WFI                0xffffff00
> > +#define INSN_MATCH_WFI               0x10500000
> > +
> >   #define INSN_MATCH_LB               0x3
> >   #define INSN_MASK_LB                0x707f
> >   #define INSN_MATCH_LH               0x1003
> > @@ -112,6 +119,67 @@
> >                                (s32)(((insn) >> 7) & 0x1f))
> >   #define MASK_FUNCT3         0x7000
> >
> > +static int truly_illegal_insn(struct kvm_vcpu *vcpu,
> > +                           struct kvm_run *run,
> > +                           ulong insn)
> > +{
> > +     /* Redirect trap to Guest VCPU */
> > +     kvm_riscv_vcpu_trap_redirect(vcpu, EXC_INST_ILLEGAL, insn);
> > +
> > +     return 1;
> > +}
> > +
> > +static int system_opcode_insn(struct kvm_vcpu *vcpu,
> > +                           struct kvm_run *run,
> > +                           ulong insn)
> > +{
> > +     if ((insn & INSN_MASK_WFI) == INSN_MATCH_WFI) {
> > +             vcpu->stat.wfi_exit_stat++;
> > +             if (!kvm_arch_vcpu_runnable(vcpu)) {
> > +                     srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
> > +                     kvm_vcpu_block(vcpu);
> > +                     vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> > +                     kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> > +             }
> > +             vcpu->arch.guest_context.sepc += INSN_LEN(insn);
> > +             return 1;
> > +     }
> > +
> > +     return truly_illegal_insn(vcpu, run, insn);
> > +}
> > +
> > +static int illegal_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > +                           unsigned long insn)
> > +{
> > +     unsigned long ut_scause = 0;
> > +     struct kvm_cpu_context *ct;
> > +
> > +     if (unlikely((insn & 3) != 3)) {
>
> What do the low 2 bits mean here? Maybe you can use a define instead?

These bits are for instruction length (16bit or 32bit).

I will add appropriate defines for these bits.

Regards,
Anup

>
>
> Alex
>
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
