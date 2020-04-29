Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991E11BD995
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 12:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgD2K1D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 29 Apr 2020 06:27:03 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46345 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbgD2K1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 06:27:01 -0400
Received: by mail-io1-f67.google.com with SMTP id i3so1588270ioo.13;
        Wed, 29 Apr 2020 03:27:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2zKkA6MUIuVcNMpBk/6qmWgfS+syEDBcJY9BPEIU8YU=;
        b=Z/Dd5XwQGQgwRNCdV8wxY/9twQOgn8V334nB8hgeJbPUFVVqK8qSfv0xLBtaxh9Og/
         xPYNQtoaJTpllWk/VKrwM4GQwQprpafFDz1XjR6a13HP8HCzAoNzUDf7H6438kyTNrct
         jJDJXBEQzNl+/cExH5noivdxOxjD+E5PUWOrxS7k/O5We3mhydQXwKTDoJTN5W5Dx3lM
         zDjx/vz5ho37vGjXXh4qqlNqA8IgboseB9N1LWPkLUz9PcxzUUmu9HONTUSFCEnbNCaR
         FqiAkW3f4+94UM05SoLKx6HbUM4J3lnIcvFR8lzaFDdjdr9GiKcTHheRKKq4ECVFE55F
         P8xg==
X-Gm-Message-State: AGi0PuZ4HlZ5TicbSPrd1Hf3iuoPj7Fy26rCLJCts8cL7SO1Csb7gZd6
        W83tTyZcGfK62/X12M1IdObGzzYZ1fykDhil87c=
X-Google-Smtp-Source: APiQypK77VLKMGcDPUhE0BI7GXVO/Zkre210jj1lxyvGQ3HtpRTGDCmiUTGiaNkMD0r8okF6xoWnpmymfEUnIOQUfkk=
X-Received: by 2002:a05:6638:401:: with SMTP id q1mr28866178jap.50.1588156020574;
 Wed, 29 Apr 2020 03:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
 <1587726933-31757-10-git-send-email-chenhc@lemote.com> <CAAdtpL7+M+j1JcSpopE+w_UdfBv3snxFPkVEqHNTC8_OC7REHQ@mail.gmail.com>
In-Reply-To: <CAAdtpL7+M+j1JcSpopE+w_UdfBv3snxFPkVEqHNTC8_OC7REHQ@mail.gmail.com>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Wed, 29 Apr 2020 18:34:31 +0800
Message-ID: <CAAhV-H6ykAMuC_XUFYkmLJgOQppPEGjxbfkdVaCE9A+BHFuK0g@mail.gmail.com>
Subject: Re: [PATCH V2 09/14] KVM: MIPS: Add more types of virtual interrupts
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Philippe,

On Wed, Apr 29, 2020 at 6:19 PM Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>
> Hi Huacai,
>
> On Fri, Apr 24, 2020 at 1:13 PM Huacai Chen <chenhc@lemote.com> wrote:
> >
> > In current implementation, MIPS KVM uses IP2, IP3, IP4 and IP7 for
> > external interrupt, two kinds of IPIs and timer interrupt respectively,
> > but Loongson-3 based machines prefer to use IP2, IP3, IP6 and IP7 for
> > two kinds of external interrupts, IPI and timer interrupt. So we define
> > two priority-irq mapping tables: kvm_loongson3_priority_to_irq[] for
> > Loongson-3, and kvm_default_priority_to_irq[] for others. The virtual
> > interrupt infrastructure is updated to deliver all types of interrupts
> > from IP2, IP3, IP4, IP6 and IP7.
> >
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > ---
> >  arch/mips/kvm/interrupt.c | 93 +++++++----------------------------------------
> >  arch/mips/kvm/interrupt.h | 14 ++++---
> >  arch/mips/kvm/mips.c      | 40 ++++++++++++++++++--
> >  arch/mips/kvm/vz.c        | 53 ++++-----------------------
> >  4 files changed, 67 insertions(+), 133 deletions(-)
> >
> > diff --git a/arch/mips/kvm/interrupt.c b/arch/mips/kvm/interrupt.c
> > index 7257e8b6..d28c2c9c 100644
> > --- a/arch/mips/kvm/interrupt.c
> > +++ b/arch/mips/kvm/interrupt.c
> > @@ -61,27 +61,8 @@ void kvm_mips_queue_io_int_cb(struct kvm_vcpu *vcpu,
> >          * the EXC code will be set when we are actually
> >          * delivering the interrupt:
> >          */
> > -       switch (intr) {
> > -       case 2:
> > -               kvm_set_c0_guest_cause(vcpu->arch.cop0, (C_IRQ0));
> > -               /* Queue up an INT exception for the core */
> > -               kvm_mips_queue_irq(vcpu, MIPS_EXC_INT_IO);
> > -               break;
> > -
> > -       case 3:
> > -               kvm_set_c0_guest_cause(vcpu->arch.cop0, (C_IRQ1));
> > -               kvm_mips_queue_irq(vcpu, MIPS_EXC_INT_IPI_1);
> > -               break;
> > -
> > -       case 4:
> > -               kvm_set_c0_guest_cause(vcpu->arch.cop0, (C_IRQ2));
> > -               kvm_mips_queue_irq(vcpu, MIPS_EXC_INT_IPI_2);
> > -               break;
> > -
> > -       default:
> > -               break;
> > -       }
> > -
> > +       kvm_set_c0_guest_cause(vcpu->arch.cop0, 1 << (intr + 8));
> > +       kvm_mips_queue_irq(vcpu, kvm_irq_to_priority(intr));
> >  }
> >
> >  void kvm_mips_dequeue_io_int_cb(struct kvm_vcpu *vcpu,
> > @@ -89,26 +70,8 @@ void kvm_mips_dequeue_io_int_cb(struct kvm_vcpu *vcpu,
> >  {
> >         int intr = (int)irq->irq;
> >
> > -       switch (intr) {
> > -       case -2:
> > -               kvm_clear_c0_guest_cause(vcpu->arch.cop0, (C_IRQ0));
> > -               kvm_mips_dequeue_irq(vcpu, MIPS_EXC_INT_IO);
> > -               break;
> > -
> > -       case -3:
> > -               kvm_clear_c0_guest_cause(vcpu->arch.cop0, (C_IRQ1));
> > -               kvm_mips_dequeue_irq(vcpu, MIPS_EXC_INT_IPI_1);
> > -               break;
> > -
> > -       case -4:
> > -               kvm_clear_c0_guest_cause(vcpu->arch.cop0, (C_IRQ2));
> > -               kvm_mips_dequeue_irq(vcpu, MIPS_EXC_INT_IPI_2);
> > -               break;
> > -
> > -       default:
> > -               break;
> > -       }
> > -
> > +       kvm_clear_c0_guest_cause(vcpu->arch.cop0, 1 << (-intr + 8));
> > +       kvm_mips_dequeue_irq(vcpu, kvm_irq_to_priority(-intr));
> >  }
> >
> >  /* Deliver the interrupt of the corresponding priority, if possible. */
> > @@ -116,50 +79,20 @@ int kvm_mips_irq_deliver_cb(struct kvm_vcpu *vcpu, unsigned int priority,
> >                             u32 cause)
> >  {
> >         int allowed = 0;
> > -       u32 exccode;
> > +       u32 exccode, ie;
> >
> >         struct kvm_vcpu_arch *arch = &vcpu->arch;
> >         struct mips_coproc *cop0 = vcpu->arch.cop0;
> >
> > -       switch (priority) {
> > -       case MIPS_EXC_INT_TIMER:
> > -               if ((kvm_read_c0_guest_status(cop0) & ST0_IE)
> > -                   && (!(kvm_read_c0_guest_status(cop0) & (ST0_EXL | ST0_ERL)))
> > -                   && (kvm_read_c0_guest_status(cop0) & IE_IRQ5)) {
> > -                       allowed = 1;
> > -                       exccode = EXCCODE_INT;
> > -               }
> > -               break;
> > -
> > -       case MIPS_EXC_INT_IO:
> > -               if ((kvm_read_c0_guest_status(cop0) & ST0_IE)
> > -                   && (!(kvm_read_c0_guest_status(cop0) & (ST0_EXL | ST0_ERL)))
> > -                   && (kvm_read_c0_guest_status(cop0) & IE_IRQ0)) {
> > -                       allowed = 1;
> > -                       exccode = EXCCODE_INT;
> > -               }
> > -               break;
> > -
> > -       case MIPS_EXC_INT_IPI_1:
> > -               if ((kvm_read_c0_guest_status(cop0) & ST0_IE)
> > -                   && (!(kvm_read_c0_guest_status(cop0) & (ST0_EXL | ST0_ERL)))
> > -                   && (kvm_read_c0_guest_status(cop0) & IE_IRQ1)) {
> > -                       allowed = 1;
> > -                       exccode = EXCCODE_INT;
> > -               }
> > -               break;
> > -
> > -       case MIPS_EXC_INT_IPI_2:
> > -               if ((kvm_read_c0_guest_status(cop0) & ST0_IE)
> > -                   && (!(kvm_read_c0_guest_status(cop0) & (ST0_EXL | ST0_ERL)))
> > -                   && (kvm_read_c0_guest_status(cop0) & IE_IRQ2)) {
> > -                       allowed = 1;
> > -                       exccode = EXCCODE_INT;
> > -               }
> > -               break;
> > +       if (priority == MIPS_EXC_MAX)
> > +               return 0;
> >
> > -       default:
> > -               break;
> > +       ie = 1 << (kvm_priority_to_irq[priority] + 8);
> > +       if ((kvm_read_c0_guest_status(cop0) & ST0_IE)
> > +           && (!(kvm_read_c0_guest_status(cop0) & (ST0_EXL | ST0_ERL)))
> > +           && (kvm_read_c0_guest_status(cop0) & ie)) {
> > +               allowed = 1;
> > +               exccode = EXCCODE_INT;
> >         }
> >
> >         /* Are we allowed to deliver the interrupt ??? */
> > diff --git a/arch/mips/kvm/interrupt.h b/arch/mips/kvm/interrupt.h
> > index 3bf0a49..c3e878c 100644
> > --- a/arch/mips/kvm/interrupt.h
> > +++ b/arch/mips/kvm/interrupt.h
> > @@ -21,11 +21,12 @@
> >  #define MIPS_EXC_NMI                5
> >  #define MIPS_EXC_MCHK               6
> >  #define MIPS_EXC_INT_TIMER          7
> > -#define MIPS_EXC_INT_IO             8
> > -#define MIPS_EXC_EXECUTE            9
> > -#define MIPS_EXC_INT_IPI_1          10
> > -#define MIPS_EXC_INT_IPI_2          11
> > -#define MIPS_EXC_MAX                12
> > +#define MIPS_EXC_INT_IO_1           8
> > +#define MIPS_EXC_INT_IO_2           9
> > +#define MIPS_EXC_EXECUTE            10
> > +#define MIPS_EXC_INT_IPI_1          11
> > +#define MIPS_EXC_INT_IPI_2          12
>
> Are you sure you can redefine these? It seems you are breaking the
> contract between host and guest.
> Maybe we don't care (because code never used in production) but then
> you should describe it in the commit description.
These definitions are just priorities, not IRQs, so I think
redifinition breaks nothing because I haven't change the delivered
IRQs (I use two mapping table, one for Loongson-3, one for others).

>
> > +#define MIPS_EXC_MAX                13
> >  /* XXXSL More to follow */
> >
> >  #define C_TI        (_ULCAST_(1) << 30)
> > @@ -38,6 +39,9 @@
> >  #define KVM_MIPS_IRQ_CLEAR_ALL_AT_ONCE   (0)
> >  #endif
> >
> > +extern u32 *kvm_priority_to_irq;
> > +u32 kvm_irq_to_priority(u32 irq);
> > +
> >  void kvm_mips_queue_irq(struct kvm_vcpu *vcpu, unsigned int priority);
> >  void kvm_mips_dequeue_irq(struct kvm_vcpu *vcpu, unsigned int priority);
> >  int kvm_mips_pending_timer(struct kvm_vcpu *vcpu);
> > diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> > index 8f05dd0..5ca122c 100644
> > --- a/arch/mips/kvm/mips.c
> > +++ b/arch/mips/kvm/mips.c
> > @@ -489,7 +489,10 @@ int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
> >         int intr = (int)irq->irq;
> >         struct kvm_vcpu *dvcpu = NULL;
> >
> > -       if (intr == 3 || intr == -3 || intr == 4 || intr == -4)
> > +       if (intr == kvm_priority_to_irq[MIPS_EXC_INT_IPI_1] ||
> > +           intr == kvm_priority_to_irq[MIPS_EXC_INT_IPI_2] ||
> > +           intr == (-kvm_priority_to_irq[MIPS_EXC_INT_IPI_1]) ||
> > +           intr == (-kvm_priority_to_irq[MIPS_EXC_INT_IPI_2]))
> >                 kvm_debug("%s: CPU: %d, INTR: %d\n", __func__, irq->cpu,
> >                           (int)intr);
> >
> > @@ -498,10 +501,10 @@ int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
> >         else
> >                 dvcpu = vcpu->kvm->vcpus[irq->cpu];
> >
> > -       if (intr == 2 || intr == 3 || intr == 4) {
> > +       if (intr == 2 || intr == 3 || intr == 4 || intr == 6) {
> >                 kvm_mips_callbacks->queue_io_int(dvcpu, irq);
> >
> > -       } else if (intr == -2 || intr == -3 || intr == -4) {
> > +       } else if (intr == -2 || intr == -3 || intr == -4 || intr == -6) {
> >                 kvm_mips_callbacks->dequeue_io_int(dvcpu, irq);
> >         } else {
> >                 kvm_err("%s: invalid interrupt ioctl (%d:%d)\n", __func__,
> > @@ -1620,6 +1623,34 @@ static struct notifier_block kvm_mips_csr_die_notifier = {
> >         .notifier_call = kvm_mips_csr_die_notify,
> >  };
> >
> > +static u32 kvm_default_priority_to_irq[MIPS_EXC_MAX] = {
> > +       [MIPS_EXC_INT_TIMER] = C_IRQ5,
> > +       [MIPS_EXC_INT_IO_1]  = C_IRQ0,
> > +       [MIPS_EXC_INT_IPI_1] = C_IRQ1,
> > +       [MIPS_EXC_INT_IPI_2] = C_IRQ2,
> > +};
> > +
> > +static u32 kvm_loongson3_priority_to_irq[MIPS_EXC_MAX] = {
> > +       [MIPS_EXC_INT_TIMER] = C_IRQ5,
> > +       [MIPS_EXC_INT_IO_1]  = C_IRQ0,
> > +       [MIPS_EXC_INT_IO_2]  = C_IRQ1,
> > +       [MIPS_EXC_INT_IPI_1] = C_IRQ4,
> > +};
> > +
> > +u32 *kvm_priority_to_irq = kvm_default_priority_to_irq;
> > +
> > +u32 kvm_irq_to_priority(u32 irq)
> > +{
> > +       int i;
> > +
> > +       for (i = MIPS_EXC_INT_TIMER; i < MIPS_EXC_MAX; i++) {
> > +               if (kvm_priority_to_irq[i] == (1 << (irq + 8)))
> > +                       return i;
> > +       }
> > +
> > +       return MIPS_EXC_MAX;
> > +}
> > +
> >  static int __init kvm_mips_init(void)
> >  {
> >         int ret;
> > @@ -1638,6 +1669,9 @@ static int __init kvm_mips_init(void)
> >         if (ret)
> >                 return ret;
> >
> > +       if (boot_cpu_type() == CPU_LOONGSON64)
> > +               kvm_priority_to_irq = kvm_loongson3_priority_to_irq;
> > +
> >         register_die_notifier(&kvm_mips_csr_die_notifier);
> >
> >         return 0;
> > diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> > index ab320f0..63d5b35 100644
> > --- a/arch/mips/kvm/vz.c
> > +++ b/arch/mips/kvm/vz.c
> > @@ -225,23 +225,7 @@ static void kvm_vz_queue_io_int_cb(struct kvm_vcpu *vcpu,
> >          * interrupts are asynchronous to vcpu execution therefore defer guest
> >          * cp0 accesses
> >          */
> > -       switch (intr) {
> > -       case 2:
> > -               kvm_vz_queue_irq(vcpu, MIPS_EXC_INT_IO);
> > -               break;
> > -
> > -       case 3:
> > -               kvm_vz_queue_irq(vcpu, MIPS_EXC_INT_IPI_1);
> > -               break;
> > -
> > -       case 4:
> > -               kvm_vz_queue_irq(vcpu, MIPS_EXC_INT_IPI_2);
> > -               break;
> > -
> > -       default:
> > -               break;
> > -       }
> > -
> > +       kvm_vz_queue_irq(vcpu, kvm_irq_to_priority(intr));
> >  }
> >
> >  static void kvm_vz_dequeue_io_int_cb(struct kvm_vcpu *vcpu,
> > @@ -253,44 +237,22 @@ static void kvm_vz_dequeue_io_int_cb(struct kvm_vcpu *vcpu,
> >          * interrupts are asynchronous to vcpu execution therefore defer guest
> >          * cp0 accesses
> >          */
> > -       switch (intr) {
> > -       case -2:
> > -               kvm_vz_dequeue_irq(vcpu, MIPS_EXC_INT_IO);
> > -               break;
> > -
> > -       case -3:
> > -               kvm_vz_dequeue_irq(vcpu, MIPS_EXC_INT_IPI_1);
> > -               break;
> > -
> > -       case -4:
> > -               kvm_vz_dequeue_irq(vcpu, MIPS_EXC_INT_IPI_2);
> > -               break;
> > -
> > -       default:
> > -               break;
> > -       }
> > -
> > +       kvm_vz_dequeue_irq(vcpu, kvm_irq_to_priority(-intr));
> >  }
> >
> > -static u32 kvm_vz_priority_to_irq[MIPS_EXC_MAX] = {
> > -       [MIPS_EXC_INT_TIMER] = C_IRQ5,
> > -       [MIPS_EXC_INT_IO]    = C_IRQ0,
> > -       [MIPS_EXC_INT_IPI_1] = C_IRQ1,
> > -       [MIPS_EXC_INT_IPI_2] = C_IRQ2,
> > -};
> > -
> >  static int kvm_vz_irq_deliver_cb(struct kvm_vcpu *vcpu, unsigned int priority,
> >                                  u32 cause)
> >  {
> >         u32 irq = (priority < MIPS_EXC_MAX) ?
> > -               kvm_vz_priority_to_irq[priority] : 0;
> > +               kvm_priority_to_irq[priority] : 0;
> >
> >         switch (priority) {
> >         case MIPS_EXC_INT_TIMER:
> >                 set_gc0_cause(C_TI);
> >                 break;
> >
> > -       case MIPS_EXC_INT_IO:
> > +       case MIPS_EXC_INT_IO_1:
> > +       case MIPS_EXC_INT_IO_2:
> >         case MIPS_EXC_INT_IPI_1:
> >         case MIPS_EXC_INT_IPI_2:
> >                 if (cpu_has_guestctl2)
> > @@ -311,7 +273,7 @@ static int kvm_vz_irq_clear_cb(struct kvm_vcpu *vcpu, unsigned int priority,
> >                                u32 cause)
> >  {
> >         u32 irq = (priority < MIPS_EXC_MAX) ?
> > -               kvm_vz_priority_to_irq[priority] : 0;
> > +               kvm_priority_to_irq[priority] : 0;
> >
> >         switch (priority) {
> >         case MIPS_EXC_INT_TIMER:
> > @@ -329,7 +291,8 @@ static int kvm_vz_irq_clear_cb(struct kvm_vcpu *vcpu, unsigned int priority,
> >                 }
> >                 break;
> >
> > -       case MIPS_EXC_INT_IO:
> > +       case MIPS_EXC_INT_IO_1:
> > +       case MIPS_EXC_INT_IO_2:
> >         case MIPS_EXC_INT_IPI_1:
> >         case MIPS_EXC_INT_IPI_2:
> >                 /* Clear GuestCtl2.VIP irq if not using Hardware Clear */
> > --
> > 2.7.0
> >
