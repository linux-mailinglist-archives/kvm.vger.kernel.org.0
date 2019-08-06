Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51FAC829F4
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 05:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbfHFDSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 23:18:42 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50426 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731350AbfHFDSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 23:18:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so76618363wml.0
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 20:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9WdX0XMG2S7fDcfkCJTHw9xGBvKSmDVfdtRc7QiEtGY=;
        b=bp9/uA6ssbL8dEE2OdPmV9H3xwB3PRdKoQQ+p67oKkdVACmRigPzjKTj4gQTj8i0ix
         6TDmTPXSbe1/UlD2PYIlTAIsLy+9RLD5aTN8WZ/76mTtnruX8ON6SUYI84fGBQECahlr
         tQxixOWmy7PALDpww5naUIzWUp/UIKX8MXGCiY/624SEUmGA/BupUAo5njomjfKdlHMV
         LeY6XbqSpiKlGZ3OOyWrMaDiiEp1BNrGav+q5hEpzZg1t5rF6XG2jdvb/nYTd0JSLm9D
         cEtjbw3JPeLV+ESYo/HcI3TPvXBZ6zY42dkwAKRqNSD28+tG6NCPG7m+AixB3gRah6yo
         xOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9WdX0XMG2S7fDcfkCJTHw9xGBvKSmDVfdtRc7QiEtGY=;
        b=Sl6H6fKT1KAmdruW0mGatldgug0GzDR9BDBKjl/zEtlRwciks0qx5Mv2IGh4Pgf1Ct
         KYVo6tzuyzVbvoKFzq0oru1A6Ex1DecW7ZBHl0A7yf0mpHCZ4yvRBh2A62luZiFFWqwP
         TjTwMTmTeXBJKxZwOpKb+QcQk3zsmF3VD+t/MdKqb3bIIMw8vq5KyCSzykvRvgqXIspC
         mw5jlxx2kPWHWgq7U+EUY9Fiv5okPXzSL1XJW/c+bY5Eoe5sOTV5r7wdjOiQ+3naGnK2
         fa0x9LcM9ERmc4IOHqfk0QnGj2y9fPXSpDhRzWzx9KqUAuRM391CczJRRxKqikQHncJu
         V8mQ==
X-Gm-Message-State: APjAAAUg/KR3TqWeCG25mpwk2QWO3EGiEv+V0aWuORpDjWeclM8X3uDc
        42its5m0On6mnypgZokwlfVCxvIu1lflO3NzHIaF6w==
X-Google-Smtp-Source: APXvYqz1dyWEhdZkssF2bQXdfUVDniOoOYNHMIsKON13LS/Q/uh/jxaOfyi41copyAtKoTwNtR8VZR6/qV5ZQP7ztcE=
X-Received: by 2002:a1c:cfc5:: with SMTP id f188mr1329437wmg.24.1565061518244;
 Mon, 05 Aug 2019 20:18:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190805134201.2814-1-anup.patel@wdc.com> <20190805134201.2814-7-anup.patel@wdc.com>
In-Reply-To: <20190805134201.2814-7-anup.patel@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 6 Aug 2019 08:48:27 +0530
Message-ID: <CAAhSdy0mcxWJ=-vKYnKR+MfqDL-Mdc8Bg+=qpLp40Kb0zGwmQA@mail.gmail.com>
Subject: Re: [PATCH v3 06/19] RISC-V: KVM: Implement VCPU interrupts and
 requests handling
To:     Anup Patel <Anup.Patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@sifive.com>,
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

On Mon, Aug 5, 2019 at 7:13 PM Anup Patel <Anup.Patel@wdc.com> wrote:
>
> This patch implements VCPU interrupts and requests which are both
> asynchronous events.
>
> The VCPU interrupts can be set/unset using KVM_INTERRUPT ioctl from
> user-space. In future, the in-kernel IRQCHIP emulation will use
> kvm_riscv_vcpu_set_interrupt() and kvm_riscv_vcpu_unset_interrupt()
> functions to set/unset VCPU interrupts.
>
> Important VCPU requests implemented by this patch are:
> KVM_REQ_SLEEP       - set whenever VCPU itself goes to sleep state
> KVM_REQ_VCPU_RESET  - set whenever VCPU reset is requested
>
> The WFI trap-n-emulate (added later) will use KVM_REQ_SLEEP request
> and kvm_riscv_vcpu_has_interrupt() function.
>
> The KVM_REQ_VCPU_RESET request will be used by SBI emulation (added
> later) to power-up a VCPU in power-off state. The user-space can use
> the GET_MPSTATE/SET_MPSTATE ioctls to get/set power state of a VCPU.
>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |  23 ++++
>  arch/riscv/include/uapi/asm/kvm.h |   3 +
>  arch/riscv/kvm/main.c             |   2 +
>  arch/riscv/kvm/vcpu.c             | 169 +++++++++++++++++++++++++++---
>  4 files changed, 184 insertions(+), 13 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index dab32c9c3470..04804f14f760 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -122,6 +122,21 @@ struct kvm_vcpu_arch {
>         /* CPU CSR context upon Guest VCPU reset */
>         struct kvm_vcpu_csr guest_reset_csr;
>
> +       /*
> +        * VCPU interrupts
> +        *
> +        * We have a lockless approach for tracking pending VCPU interrupts
> +        * implemented using atomic bitops. The irqs_pending bitmap represent
> +        * pending interrupts whereas irqs_pending_mask represent bits changed
> +        * in irqs_pending. Our approach is modeled around multiple producer
> +        * and single consumer problem where the consumer is the VCPU itself.
> +        */
> +       unsigned long irqs_pending;
> +       unsigned long irqs_pending_mask;
> +
> +       /* VCPU power-off state */
> +       bool power_off;
> +
>         /* Don't run the VCPU (blocked) */
>         bool pause;
>
> @@ -146,4 +161,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>
>  static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) {}
>
> +int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
> +int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
> +void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu);
> +bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
> +
>  #endif /* __RISCV_KVM_HOST_H__ */
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index d15875818b6e..6dbc056d58ba 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -18,6 +18,9 @@
>
>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>
> +#define KVM_INTERRUPT_SET      -1U
> +#define KVM_INTERRUPT_UNSET    -2U
> +
>  /* for KVM_GET_REGS and KVM_SET_REGS */
>  struct kvm_regs {
>  };
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index a26a68df7cfc..f4a7a3c67f8e 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -48,6 +48,8 @@ int kvm_arch_hardware_enable(void)
>         hideleg |= SIE_SEIE;
>         csr_write(CSR_HIDELEG, hideleg);
>
> +       csr_write(CSR_VSIP, 0);
> +
>         return 0;
>  }
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index ff08d138f7c3..455b0f40832b 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -40,6 +40,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>                                  RISCV_ISA_EXT_s | \
>                                  RISCV_ISA_EXT_u)
>
> +static DEFINE_PER_CPU(unsigned long, vsip_shadow);
> +

With introduction of compile-time percpu variable here, the insmod
fails to insert KVM RISC-V as loadable module. This looks like some
issue with arch/riscv/kernel/module.c.

I tried run-time percpu variables using alloc_percpu() API and it
works perfectly fine with it. I will make vsip_shadow as run-time
percpu variable instead of compile-time in v4 series.

>  static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> @@ -50,6 +52,9 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>         memcpy(csr, reset_csr, sizeof(*csr));
>
>         memcpy(cntx, reset_cntx, sizeof(*cntx));
> +
> +       WRITE_ONCE(vcpu->arch.irqs_pending, 0);
> +       WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
>  }
>
>  struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
> @@ -116,8 +121,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>  {
> -       /* TODO: */
> -       return 0;
> +       return READ_ONCE(vcpu->arch.irqs_pending) & (1UL << IRQ_S_TIMER);
>  }
>
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> @@ -130,20 +134,18 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>  {
> -       /* TODO: */
> -       return 0;
> +       return (kvm_riscv_vcpu_has_interrupt(vcpu) &&
> +               !vcpu->arch.power_off && !vcpu->arch.pause);
>  }
>
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>  {
> -       /* TODO: */
> -       return 0;
> +       return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>  }
>
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
>  {
> -       /* TODO: */
> -       return false;
> +       return (vcpu->arch.guest_context.sstatus & SR_SPP) ? true : false;
>  }
>
>  bool kvm_arch_has_vcpu_debugfs(void)
> @@ -164,7 +166,21 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>  long kvm_arch_vcpu_async_ioctl(struct file *filp,
>                                unsigned int ioctl, unsigned long arg)
>  {
> -       /* TODO; */
> +       struct kvm_vcpu *vcpu = filp->private_data;
> +       void __user *argp = (void __user *)arg;
> +
> +       if (ioctl == KVM_INTERRUPT) {
> +               struct kvm_interrupt irq;
> +
> +               if (copy_from_user(&irq, argp, sizeof(irq)))
> +                       return -EFAULT;
> +
> +               if (irq.irq == KVM_INTERRUPT_SET)
> +                       return kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_S_EXT);
> +               else
> +                       return kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_EXT);
> +       }
> +
>         return -ENOIOCTLCMD;
>  }
>
> @@ -213,18 +229,103 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>         return -EINVAL;
>  }
>
> +void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +       unsigned long mask, val;
> +
> +       if (READ_ONCE(vcpu->arch.irqs_pending_mask)) {
> +               mask = xchg_acquire(&vcpu->arch.irqs_pending_mask, 0);
> +               val = READ_ONCE(vcpu->arch.irqs_pending) & mask;
> +
> +               csr->vsip &= ~mask;
> +               csr->vsip |= val;
> +       }
> +}
> +
> +void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
> +{
> +       vcpu->arch.guest_csr.vsip = csr_read(CSR_VSIP);
> +       vcpu->arch.guest_csr.vsie = csr_read(CSR_VSIE);
> +}
> +
> +int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
> +{
> +       if (irq != IRQ_S_SOFT &&
> +           irq != IRQ_S_TIMER &&
> +           irq != IRQ_S_EXT)
> +               return -EINVAL;
> +
> +       set_bit(irq, &vcpu->arch.irqs_pending);
> +       smp_mb__before_atomic();
> +       set_bit(irq, &vcpu->arch.irqs_pending_mask);
> +
> +       kvm_vcpu_kick(vcpu);
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
> +{
> +       if (irq != IRQ_S_SOFT &&
> +           irq != IRQ_S_TIMER &&
> +           irq != IRQ_S_EXT)
> +               return -EINVAL;
> +
> +       clear_bit(irq, &vcpu->arch.irqs_pending);
> +       smp_mb__before_atomic();
> +       set_bit(irq, &vcpu->arch.irqs_pending_mask);
> +
> +       return 0;
> +}
> +
> +bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *vcpu)
> +{
> +       return (READ_ONCE(vcpu->arch.irqs_pending) &
> +               vcpu->arch.guest_csr.vsie) ? true : false;
> +}
> +
> +void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
> +{
> +       vcpu->arch.power_off = true;
> +       kvm_make_request(KVM_REQ_SLEEP, vcpu);
> +       kvm_vcpu_kick(vcpu);
> +}
> +
> +void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
> +{
> +       vcpu->arch.power_off = false;
> +       kvm_vcpu_wake_up(vcpu);
> +}
> +
>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>                                     struct kvm_mp_state *mp_state)
>  {
> -       /* TODO: */
> +       if (vcpu->arch.power_off)
> +               mp_state->mp_state = KVM_MP_STATE_STOPPED;
> +       else
> +               mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
> +
>         return 0;
>  }
>
>  int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>                                     struct kvm_mp_state *mp_state)
>  {
> -       /* TODO: */
> -       return 0;
> +       int ret = 0;
> +
> +       switch (mp_state->mp_state) {
> +       case KVM_MP_STATE_RUNNABLE:
> +               vcpu->arch.power_off = false;
> +               break;
> +       case KVM_MP_STATE_STOPPED:
> +               kvm_riscv_vcpu_power_off(vcpu);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       return ret;
>  }
>
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> @@ -248,7 +349,37 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>
>  static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
>  {
> -       /* TODO: */
> +       struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
> +
> +       if (kvm_request_pending(vcpu)) {
> +               if (kvm_check_request(KVM_REQ_SLEEP, vcpu)) {
> +                       swait_event_interruptible_exclusive(*wq,
> +                                               ((!vcpu->arch.power_off) &&
> +                                               (!vcpu->arch.pause)));
> +
> +                       if (vcpu->arch.power_off || vcpu->arch.pause) {
> +                               /*
> +                                * Awaken to handle a signal, request to
> +                                * sleep again later.
> +                                */
> +                               kvm_make_request(KVM_REQ_SLEEP, vcpu);
> +                       }
> +               }
> +
> +               if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
> +                       kvm_riscv_reset_vcpu(vcpu);
> +       }
> +}
> +
> +static void kvm_riscv_update_vsip(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +       unsigned long *vsip = this_cpu_ptr(&vsip_shadow);
> +
> +       if (*vsip != csr->vsip) {
> +               csr_write(CSR_VSIP, csr->vsip);
> +               *vsip = csr->vsip;
> +       }
>  }
>
>  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> @@ -311,6 +442,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>                 srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
>                 smp_mb__after_srcu_read_unlock();
>
> +               /*
> +                * We might have got VCPU interrupts updated asynchronously
> +                * so update it in HW.
> +                */
> +               kvm_riscv_vcpu_flush_interrupts(vcpu);
> +
> +               /* Update VSIP CSR for current CPU */
> +               kvm_riscv_update_vsip(vcpu);
> +
>                 if (ret <= 0 ||
>                     kvm_request_pending(vcpu)) {
>                         vcpu->mode = OUTSIDE_GUEST_MODE;
> @@ -334,6 +474,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>                 scause = csr_read(CSR_SCAUSE);
>                 stval = csr_read(CSR_STVAL);
>
> +               /* Syncup interrupts state with HW */
> +               kvm_riscv_vcpu_sync_interrupts(vcpu);
> +
>                 /*
>                  * We may have taken a host interrupt in VS/VU-mode (i.e.
>                  * while executing the guest). This interrupt is still
> --
> 2.17.1
>

Regards,
Anup
