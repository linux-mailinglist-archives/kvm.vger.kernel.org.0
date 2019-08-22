Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70F3C99436
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 14:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388061AbfHVMuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 08:50:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40692 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731556AbfHVMuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 08:50:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id c3so5297142wrd.7
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 05:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ROB4gx4OGB1CpDcKjvU71ET9FrwtUSFzAVqfUnfvjig=;
        b=Tjz6zp1luUYbfqgLHs8u1XU3r21rRiuHFjEEE445sTZjPTG1K1TbEO655UT3JDH3uL
         sC9vFssy7r4wfHsKKF/jvniljfpEfBFwOrQchEZDTPX3FFboKQyRluqtt46Kzkw0x8XG
         yKutR8H6zkflJqqRKMFoQNCPwDuLl5c3EUDnFRNxl1fIpcQ6/JjEJYLu2fsFzhRNkdkC
         T6RMZHoZAvxRZ25l7eXoVO73Em9ogqkTFCN2UVljQt/8eRLrTATgzUwrfpw6Zd6lqKRY
         g9WxpB32AOgs0olEMDJsyZyRztxQnxlRzFtFxz+8PJQyQWvuhTE7hN6yS2Wz9XivJaJq
         D+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ROB4gx4OGB1CpDcKjvU71ET9FrwtUSFzAVqfUnfvjig=;
        b=trCV7130Ffqhr1KjXwImjSe6YRO6Gnwuxx2MwNpQ47PaXLemwNkgeYG+tJq65J37RG
         7s5nKeBvzdoT6TUs2ICsoN81NOkFdj0RkYf72T4tukSJsfLYfdXiVwgsQoJWrqLWJt2l
         RvKfe2RbcBUtrqF8qcfCche+HAmU4P6T5vh5JJWwKdwPQbAUv27Nh1jYFmAXqAC7VE4r
         Shed1VOlmrqoBdZk9tP5zXOfNAOtO4C+TlrIv5ALfGZyVAoX2fFy8IEYPQzWYz6BqUs/
         LmxAzxW5CLrOSH0BNVko3x+2XTMiE9WUvemsSpld44WEDmelkkZqVAFhiFEzipZd8nut
         30/w==
X-Gm-Message-State: APjAAAXgHyoUdAzYB2ZN6cnvlNvmZxWwvoIEpVsojE1ekI+6iLZHJGuQ
        pARWXiwKewWmd+pjyvUK8ejY0Og32IAhJ41Nl3vqmg==
X-Google-Smtp-Source: APXvYqzQ1TjSFQOix3vHo2hOrSZgy2endTM2XhjVhF8ByOGg0ehcvHXulptQXEetr33hXvAwYdNbyFGI7JnPGcIt6sU=
X-Received: by 2002:a05:6000:104c:: with SMTP id c12mr42632777wrx.328.1566478213090;
 Thu, 22 Aug 2019 05:50:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190822084131.114764-1-anup.patel@wdc.com> <20190822084131.114764-12-anup.patel@wdc.com>
 <29b8f7c6-4b9d-91fc-61e7-82ecfd26ff88@amazon.com>
In-Reply-To: <29b8f7c6-4b9d-91fc-61e7-82ecfd26ff88@amazon.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 22 Aug 2019 18:20:01 +0530
Message-ID: <CAAhSdy2=6gC6fe_VtsnbQVXZnJMm_2Hc_qG3xS3nSnn5j8H1cQ@mail.gmail.com>
Subject: Re: [PATCH v5 11/20] RISC-V: KVM: Handle WFI exits for VCPU
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

On Thu, Aug 22, 2019 at 5:49 PM Alexander Graf <graf@amazon.com> wrote:
>
> On 22.08.19 10:45, Anup Patel wrote:
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
> >   arch/riscv/kvm/vcpu_exit.c | 88 ++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 88 insertions(+)
> >
> > diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> > index efc06198c259..fbc04fe335ad 100644
> > --- a/arch/riscv/kvm/vcpu_exit.c
> > +++ b/arch/riscv/kvm/vcpu_exit.c
> > @@ -12,6 +12,9 @@
> >   #include <linux/kvm_host.h>
> >   #include <asm/csr.h>
> >
> > +#define INSN_MASK_WFI                0xffffff00
> > +#define INSN_MATCH_WFI               0x10500000
> > +
> >   #define INSN_MATCH_LB               0x3
> >   #define INSN_MASK_LB                0x707f
> >   #define INSN_MATCH_LH               0x1003
> > @@ -179,6 +182,87 @@ static ulong get_insn(struct kvm_vcpu *vcpu)
> >       return val;
> >   }
> >
> > +typedef int (*illegal_insn_func)(struct kvm_vcpu *vcpu,
> > +                              struct kvm_run *run,
> > +                              ulong insn);
> > +
> > +static int truly_illegal_insn(struct kvm_vcpu *vcpu,
> > +                           struct kvm_run *run,
> > +                           ulong insn)
> > +{
> > +     /* TODO: Redirect trap to Guest VCPU */
> > +     return -ENOTSUPP;
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
> > +static illegal_insn_func illegal_insn_table[32] = {
>
> Every time I did experiments on PowerPC with indirect tables like this
> over switch() in C, the switch() code won. CPUs are pretty good at
> predicting branches. Predicting indirect jumps however, they are
> terrible at.
>
> So unless you consider the jump table more readable / maintainable, I
> would suggest to use a simple switch() statement. It will be faster and
> smaller.

Yes, readability was the reason why we choose jump table but
I see your point. Most of the entries in jump table point to
truly_illegal_insn() so I guess switch case will be quite simple
here.

I will update this in next revision.

Regards,
Anup

>
>
> Alex
>
>
> > +     truly_illegal_insn, /* 0 */
> > +     truly_illegal_insn, /* 1 */
> > +     truly_illegal_insn, /* 2 */
> > +     truly_illegal_insn, /* 3 */
> > +     truly_illegal_insn, /* 4 */
> > +     truly_illegal_insn, /* 5 */
> > +     truly_illegal_insn, /* 6 */
> > +     truly_illegal_insn, /* 7 */
> > +     truly_illegal_insn, /* 8 */
> > +     truly_illegal_insn, /* 9 */
> > +     truly_illegal_insn, /* 10 */
> > +     truly_illegal_insn, /* 11 */
> > +     truly_illegal_insn, /* 12 */
> > +     truly_illegal_insn, /* 13 */
> > +     truly_illegal_insn, /* 14 */
> > +     truly_illegal_insn, /* 15 */
> > +     truly_illegal_insn, /* 16 */
> > +     truly_illegal_insn, /* 17 */
> > +     truly_illegal_insn, /* 18 */
> > +     truly_illegal_insn, /* 19 */
> > +     truly_illegal_insn, /* 20 */
> > +     truly_illegal_insn, /* 21 */
> > +     truly_illegal_insn, /* 22 */
> > +     truly_illegal_insn, /* 23 */
> > +     truly_illegal_insn, /* 24 */
> > +     truly_illegal_insn, /* 25 */
> > +     truly_illegal_insn, /* 26 */
> > +     truly_illegal_insn, /* 27 */
> > +     system_opcode_insn, /* 28 */
> > +     truly_illegal_insn, /* 29 */
> > +     truly_illegal_insn, /* 30 */
> > +     truly_illegal_insn  /* 31 */
> > +};
> > +
> > +static int illegal_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > +                           unsigned long stval)
> > +{
> > +     ulong insn = stval;
> > +
> > +     if (unlikely((insn & 3) != 3)) {
> > +             if (insn == 0)
> > +                     insn = get_insn(vcpu);
> > +             if ((insn & 3) != 3)
> > +                     return truly_illegal_insn(vcpu, run, insn);
> > +     }
> > +
> > +     return illegal_insn_table[(insn & 0x7c) >> 2](vcpu, run, insn);
> > +}
> > +
> >   static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >                       unsigned long fault_addr)
> >   {
> > @@ -439,6 +523,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >       ret = -EFAULT;
> >       run->exit_reason = KVM_EXIT_UNKNOWN;
> >       switch (scause) {
> > +     case EXC_INST_ILLEGAL:
> > +             if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
> > +                     ret = illegal_inst_fault(vcpu, run, stval);
> > +             break;
> >       case EXC_INST_PAGE_FAULT:
> >       case EXC_LOAD_PAGE_FAULT:
> >       case EXC_STORE_PAGE_FAULT:
> >
>
