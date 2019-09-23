Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD109BACEC
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 05:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404208AbfIWDm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Sep 2019 23:42:59 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35641 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403948AbfIWDm7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Sep 2019 23:42:59 -0400
Received: by mail-wr1-f65.google.com with SMTP id v8so12212625wrt.2
        for <kvm@vger.kernel.org>; Sun, 22 Sep 2019 20:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9+a8eglVXevMoD1Tojjjkc1G0+vejdfTstL86XSetKs=;
        b=F9c7YDGLKppYwwsO10SVV1YeQq5ZEYYdI62OYKCAhOa+toTWJ6kYNv0nqsaorBYGr2
         dp4eWslwO3T61yXcRpkfrRRzVr7kb1YQ3+rAJKbIKSNaRm4jKdQ8aH/RVVEthOFKVlXW
         zgZ/86JyOAfozgV6fiWop0ERJUW3LxnCROck9HggqoeRjPPLkZQSrhXBWyyFuyOcPRUd
         H0WB6DgDdJT48/l2lh1xOctmoFCHli56KZsWP2qiuL4S57WrkpN+OHD6v9vI9kyKb0B8
         PDnIImZni7wNOP3dMbhBdjiJwdhv0ZLdZ1IMub0OEGcUKdZAb7E02qhN66MZfsoE0usG
         2A8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9+a8eglVXevMoD1Tojjjkc1G0+vejdfTstL86XSetKs=;
        b=AcKbS5NcnTbTwFscVxSoU3823dF5TDhSLlCpoFDoWRJ/cWUvF+FKKyf14R6ZDtKzs1
         U+z/OEfEOgvW5qzLzj+W+KuCMcZXkdGvnmZIrcjKDhLjOiXCJS13joFB8IhGSOovUPzz
         KTuC+FNN/5eyQ0MhxJdiOSIZCeMqiSSY6edUOv44LLI6Gm28e1qOnmOO8pjA0BA2ZSKn
         z8M8DcqvRkNCjDjzu4FcI9/FyZzWgZWIF2wvj6bb76KI3YC7qwFKosSP5NP3haaY573m
         L1jcTYRNXLSU4boJWgSy8fcd6BY+R1y7TR8p3gyUEoZVcj1gMEF5EwHjb5xAWe+imr7R
         0Xng==
X-Gm-Message-State: APjAAAWrdTrt7GxQ0SjyOditLqnbhhqVZpbeefBP+JRWd7auXv2/7fkD
        H3KoZ20c0gCyhF2vsm/guq9jvWMnGHR1egUQqFZeMA==
X-Google-Smtp-Source: APXvYqyWRolAHgHGdPovHvXEiAmGNYIBinr5rhUDl+aZiuKKNYuD/A+wWAKUs+NuHxAEJOOnDLoKT8lRCjZ8qBOOfMc=
X-Received: by 2002:adf:f1d1:: with SMTP id z17mr20173583wro.330.1569210176021;
 Sun, 22 Sep 2019 20:42:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190904161245.111924-1-anup.patel@wdc.com> <20190904161245.111924-10-anup.patel@wdc.com>
In-Reply-To: <20190904161245.111924-10-anup.patel@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 23 Sep 2019 09:12:44 +0530
Message-ID: <CAAhSdy3ij--wR+=7gFQ03PFCiAA5OFBJfayU=Z7ODAwbP+pBaw@mail.gmail.com>
Subject: Re: [PATCH v7 08/21] RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG
 ioctls
To:     Anup Patel <Anup.Patel@wdc.com>, Alexander Graf <graf@amazon.com>
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

On Wed, Sep 4, 2019 at 9:44 PM Anup Patel <Anup.Patel@wdc.com> wrote:
>
> For KVM RISC-V, we use KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls to access
> VCPU config and registers from user-space.
>
> We have three types of VCPU registers:
> 1. CONFIG - these are VCPU config and capabilities
> 2. CORE   - these are VCPU general purpose registers
> 3. CSR    - these are VCPU control and status registers
>
> The CONFIG registers available to user-space are ISA and TIMEBASE. Out
> of these, TIMEBASE is a read-only register which inform user-space about
> VCPU timer base frequency. The ISA register is a read and write register
> where user-space can only write the desired VCPU ISA capabilities before
> running the VCPU.
>
> The CORE registers available to user-space are PC, RA, SP, GP, TP, A0-A7,
> T0-T6, S0-S11 and MODE. Most of these are RISC-V general registers except
> PC and MODE. The PC register represents program counter whereas the MODE
> register represent VCPU privilege mode (i.e. S/U-mode).
>
> The CSRs available to user-space are SSTATUS, SIE, STVEC, SSCRATCH, SEPC,
> SCAUSE, STVAL, SIP, and SATP. All of these are read/write registers.
>
> In future, more VCPU register types will be added (such as FP) for the
> KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls.
>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h |  46 +++++-
>  arch/riscv/kvm/vcpu.c             | 235 +++++++++++++++++++++++++++++-
>  2 files changed, 278 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 6dbc056d58ba..08c4515ad71b 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -23,8 +23,15 @@
>
>  /* for KVM_GET_REGS and KVM_SET_REGS */
>  struct kvm_regs {
> +       /* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
> +       struct user_regs_struct regs;
> +       unsigned long mode;
>  };

As discussed in LPC 2019 with Alex Graf, I will add separate
struct for CORE registers instead of re-using "struct kvm_regs".

>
> +/* Possible privilege modes for kvm_regs */
> +#define KVM_RISCV_MODE_S       1
> +#define KVM_RISCV_MODE_U       0
> +
>  /* for KVM_GET_FPU and KVM_SET_FPU */
>  struct kvm_fpu {
>  };
> @@ -41,10 +48,47 @@ struct kvm_guest_debug_arch {
>  struct kvm_sync_regs {
>  };
>
> -/* dummy definition */
> +/* for KVM_GET_SREGS and KVM_SET_SREGS */
>  struct kvm_sregs {
> +       unsigned long sstatus;
> +       unsigned long sie;
> +       unsigned long stvec;
> +       unsigned long sscratch;
> +       unsigned long sepc;
> +       unsigned long scause;
> +       unsigned long stval;
> +       unsigned long sip;
> +       unsigned long satp;
> +};

Same as above, I will add separate struct for CSR registers instead
of re-using "struct kvm_sregs".

> +
> +/* for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> +struct kvm_riscv_config {
> +       unsigned long isa;
> +       unsigned long tbfreq;
>  };
>
> +#define KVM_REG_SIZE(id)               \
> +       (1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
> +
> +/* If you need to interpret the index values, here is the key: */
> +#define KVM_REG_RISCV_TYPE_MASK                0x00000000FF000000
> +#define KVM_REG_RISCV_TYPE_SHIFT       24
> +
> +/* Config registers are mapped as type 1 */
> +#define KVM_REG_RISCV_CONFIG           (0x01 << KVM_REG_RISCV_TYPE_SHIFT)
> +#define KVM_REG_RISCV_CONFIG_REG(name) \
> +       (offsetof(struct kvm_riscv_config, name) / sizeof(unsigned long))
> +
> +/* Core registers are mapped as type 2 */
> +#define KVM_REG_RISCV_CORE             (0x02 << KVM_REG_RISCV_TYPE_SHIFT)
> +#define KVM_REG_RISCV_CORE_REG(name)   \
> +               (offsetof(struct kvm_regs, name) / sizeof(unsigned long))
> +
> +/* Control and status registers are mapped as type 3 */
> +#define KVM_REG_RISCV_CSR              (0x03 << KVM_REG_RISCV_TYPE_SHIFT)
> +#define KVM_REG_RISCV_CSR_REG(name)    \
> +               (offsetof(struct kvm_sregs, name) / sizeof(unsigned long))
> +
>  #endif
>
>  #endif /* __LINUX_KVM_RISCV_H */
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 3223f723f79e..b95dfc959009 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -165,6 +165,215 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>         return VM_FAULT_SIGBUS;
>  }
>
> +static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
> +                                        const struct kvm_one_reg *reg)
> +{
> +       unsigned long __user *uaddr =
> +                       (unsigned long __user *)(unsigned long)reg->addr;
> +       unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> +                                           KVM_REG_SIZE_MASK |
> +                                           KVM_REG_RISCV_CONFIG);
> +       unsigned long reg_val;
> +
> +       if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> +               return -EINVAL;
> +
> +       switch (reg_num) {
> +       case KVM_REG_RISCV_CONFIG_REG(isa):
> +               reg_val = vcpu->arch.isa;
> +               break;
> +       case KVM_REG_RISCV_CONFIG_REG(tbfreq):
> +               reg_val = riscv_timebase;
> +               break;
> +       default:
> +               return -EINVAL;
> +       };
> +
> +       if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +
> +static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
> +                                        const struct kvm_one_reg *reg)
> +{
> +       unsigned long __user *uaddr =
> +                       (unsigned long __user *)(unsigned long)reg->addr;
> +       unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> +                                           KVM_REG_SIZE_MASK |
> +                                           KVM_REG_RISCV_CONFIG);
> +       unsigned long reg_val;
> +
> +       if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> +               return -EINVAL;
> +
> +       if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> +               return -EFAULT;
> +
> +       switch (reg_num) {
> +       case KVM_REG_RISCV_CONFIG_REG(isa):
> +               if (!vcpu->arch.ran_atleast_once) {
> +                       vcpu->arch.isa = reg_val;
> +                       vcpu->arch.isa &= riscv_isa_extension_base(NULL);
> +                       vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
> +               } else {
> +                       return -ENOTSUPP;
> +               }
> +               break;
> +       case KVM_REG_RISCV_CONFIG_REG(tbfreq):
> +               return -ENOTSUPP;
> +       default:
> +               return -EINVAL;
> +       };
> +
> +       return 0;
> +}
> +
> +static int kvm_riscv_vcpu_get_reg_core(struct kvm_vcpu *vcpu,
> +                                      const struct kvm_one_reg *reg)
> +{
> +       struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
> +       unsigned long __user *uaddr =
> +                       (unsigned long __user *)(unsigned long)reg->addr;
> +       unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> +                                           KVM_REG_SIZE_MASK |
> +                                           KVM_REG_RISCV_CORE);
> +       unsigned long reg_val;
> +
> +       if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> +               return -EINVAL;
> +
> +       if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
> +               reg_val = cntx->sepc;
> +       else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
> +                reg_num <= KVM_REG_RISCV_CORE_REG(regs.t6))
> +               reg_val = ((unsigned long *)cntx)[reg_num];
> +       else if (reg_num == KVM_REG_RISCV_CORE_REG(mode))
> +               reg_val = (cntx->sstatus & SR_SPP) ?
> +                               KVM_RISCV_MODE_S : KVM_RISCV_MODE_U;
> +       else
> +               return -EINVAL;
> +
> +       if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +
> +static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
> +                                      const struct kvm_one_reg *reg)
> +{
> +       struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
> +       unsigned long __user *uaddr =
> +                       (unsigned long __user *)(unsigned long)reg->addr;
> +       unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> +                                           KVM_REG_SIZE_MASK |
> +                                           KVM_REG_RISCV_CORE);
> +       unsigned long reg_val;
> +
> +       if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> +               return -EINVAL;
> +
> +       if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> +               return -EFAULT;
> +
> +       if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
> +               cntx->sepc = reg_val;
> +       else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
> +                reg_num <= KVM_REG_RISCV_CORE_REG(regs.t6))
> +               ((unsigned long *)cntx)[reg_num] = reg_val;
> +       else if (reg_num == KVM_REG_RISCV_CORE_REG(mode)) {
> +               if (reg_val == KVM_RISCV_MODE_S)
> +                       cntx->sstatus |= SR_SPP;
> +               else
> +                       cntx->sstatus &= ~SR_SPP;
> +       } else
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
> +static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
> +                                     const struct kvm_one_reg *reg)
> +{
> +       struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +       unsigned long __user *uaddr =
> +                       (unsigned long __user *)(unsigned long)reg->addr;
> +       unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> +                                           KVM_REG_SIZE_MASK |
> +                                           KVM_REG_RISCV_CSR);
> +       unsigned long reg_val;
> +
> +       if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> +               return -EINVAL;
> +       if (reg_num >= sizeof(struct kvm_sregs) / sizeof(unsigned long))
> +               return -EINVAL;
> +
> +       if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
> +               kvm_riscv_vcpu_flush_interrupts(vcpu);
> +
> +       reg_val = ((unsigned long *)csr)[reg_num];
> +
> +       if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +
> +static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
> +                                     const struct kvm_one_reg *reg)
> +{
> +       struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +       unsigned long __user *uaddr =
> +                       (unsigned long __user *)(unsigned long)reg->addr;
> +       unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> +                                           KVM_REG_SIZE_MASK |
> +                                           KVM_REG_RISCV_CSR);
> +       unsigned long reg_val;
> +
> +       if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> +               return -EINVAL;
> +       if (reg_num >= sizeof(struct kvm_sregs) / sizeof(unsigned long))
> +               return -EINVAL;
> +
> +       if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> +               return -EFAULT;
> +
> +       ((unsigned long *)csr)[reg_num] = reg_val;
> +
> +       if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
> +               WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> +
> +       return 0;
> +}
> +
> +static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
> +                                 const struct kvm_one_reg *reg)
> +{
> +       if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CONFIG)
> +               return kvm_riscv_vcpu_set_reg_config(vcpu, reg);
> +       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CORE)
> +               return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
> +       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
> +               return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
> +
> +       return -EINVAL;
> +}
> +
> +static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
> +                                 const struct kvm_one_reg *reg)
> +{
> +       if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CONFIG)
> +               return kvm_riscv_vcpu_get_reg_config(vcpu, reg);
> +       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CORE)
> +               return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
> +       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
> +               return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
> +
> +       return -EINVAL;
> +}
> +
>  long kvm_arch_vcpu_async_ioctl(struct file *filp,
>                                unsigned int ioctl, unsigned long arg)
>  {
> @@ -189,8 +398,30 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>                          unsigned int ioctl, unsigned long arg)
>  {
> -       /* TODO: */
> -       return -EINVAL;
> +       struct kvm_vcpu *vcpu = filp->private_data;
> +       void __user *argp = (void __user *)arg;
> +       long r = -EINVAL;
> +
> +       switch (ioctl) {
> +       case KVM_SET_ONE_REG:
> +       case KVM_GET_ONE_REG: {
> +               struct kvm_one_reg reg;
> +
> +               r = -EFAULT;
> +               if (copy_from_user(&reg, argp, sizeof(reg)))
> +                       break;
> +
> +               if (ioctl == KVM_SET_ONE_REG)
> +                       r = kvm_riscv_vcpu_set_reg(vcpu, &reg);
> +               else
> +                       r = kvm_riscv_vcpu_get_reg(vcpu, &reg);
> +               break;
> +       }
> +       default:
> +               break;
> +       }
> +
> +       return r;
>  }
>
>  int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
> --
> 2.17.1
>

Regards,
Anup
