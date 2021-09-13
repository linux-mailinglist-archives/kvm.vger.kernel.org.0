Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A86A40838E
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 06:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhIMEc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 00:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhIMEcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 00:32:24 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BB8C061574
        for <kvm@vger.kernel.org>; Sun, 12 Sep 2021 21:31:09 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x7so7609233pfa.8
        for <kvm@vger.kernel.org>; Sun, 12 Sep 2021 21:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r9TIudJWfEm4ijxsiXSuSQMNgskF5z8KmTKQe0Dm7Wo=;
        b=ePT1AN+21sy8tnHJoRvGRMNr0bqhdfZajhffHE9mJaCb2O33WMb0iaQd8wdRokGdKN
         A2ZO6e9E0mzeTR5hqsJGlR0oeYHLDf36W7ufWMwmhTDGM0+vOc8p0zSAeFf+DITiRCqm
         /rNg8gt5UOLd7O2nHqDRwwWFG4/ibU6jPYYu3OMUAhv+UFGpI456/ZEbKq3wOOoDy7pF
         +gczQx7PK9p1vI65W4SQjvWCewP9ohZFZOC9/g3yiXVi/5AemqL6/AtYq1Xxm/6II4Gw
         T/jJBRxMhyVeDZnvZr9n9HzWEyRheZo9dhoFgQxj0fI/Wn+WmTVu61WbCEXtlo3s8hHz
         LnjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r9TIudJWfEm4ijxsiXSuSQMNgskF5z8KmTKQe0Dm7Wo=;
        b=Vad0bnoD8u51QPCyVwrmEezgLkW3V0sVM3o11ZndH2+ITz10hidaoyY6vMnogc5Cl2
         nP3+TqtNsSQrh7qr+RcZuHkxvihbYW4JYzQHioNrmNe8CUv70exoK/MzsCHgPFnfS8G0
         36Ahy/XgV4lHcNYpceBaUC9OpW4Wn5FtENHvQXMPtfDzd5gN8sFHS24gc4/F9trGCZ9p
         GmBj7H2t7r+wmhF6wXbBFkPdoLp4X76SAJ4WT51g32KSB4Aw3RYBbMP3NbOkjg1SBgwD
         ACGqO1uY6sWlGxabH5ATjAJfW44oIJqN8h7rM8zp9kNfja3cn5ZFTljvhmfrp1PyqGFx
         WH2g==
X-Gm-Message-State: AOAM5312ZNVGOdqfsP+5xm4gxxm+KJkmJKNIsQbACGiQVTkPoQ2nCEby
        mnZcwpVYo0XP+bwxIPw0RmLoMc13CQH4dvKgsqnXNQ+lp2tAdg==
X-Google-Smtp-Source: ABdhPJxKRfBd2rDzGKGwZqtlm7RcCOpE/TsmNcQkxCLfAxekE1rQfNKsXXCzcvsrL+6EnSpb3BGigjmIs3vd1nrBLd0=
X-Received: by 2002:a65:6398:: with SMTP id h24mr9290166pgv.367.1631507468710;
 Sun, 12 Sep 2021 21:31:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210727055450.2742868-1-anup.patel@wdc.com> <20210727055450.2742868-14-anup.patel@wdc.com>
In-Reply-To: <20210727055450.2742868-14-anup.patel@wdc.com>
From:   Vincent Chen <vincent.chen@sifive.com>
Date:   Mon, 13 Sep 2021 12:30:57 +0800
Message-ID: <CABvJ_xgyn0yeYnbqN=xA60xmuWL6vwFtLt_b60BF_tnfd8r5cQ@mail.gmail.com>
Subject: Re: [PATCH v19 13/17] RISC-V: KVM: FP lazy save/restore
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 3:30 PM Anup Patel <anup.patel@wdc.com> wrote:
>
> From: Atish Patra <atish.patra@wdc.com>
>
> This patch adds floating point (F and D extension) context save/restore
> for guest VCPUs. The FP context is saved and restored lazily only when
> kernel enter/exits the in-kernel run loop and not during the KVM world
> switch. This way FP save/restore has minimal impact on KVM performance.
>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |   5 +
>  arch/riscv/kernel/asm-offsets.c   |  72 +++++++++++++
>  arch/riscv/kvm/vcpu.c             |  91 ++++++++++++++++
>  arch/riscv/kvm/vcpu_switch.S      | 174 ++++++++++++++++++++++++++++++
>  4 files changed, 342 insertions(+)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 18b4ec1b5105..99b43229fe7a 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -125,6 +125,7 @@ struct kvm_cpu_context {
>         unsigned long sepc;
>         unsigned long sstatus;
>         unsigned long hstatus;
> +       union __riscv_fp_state fp;
>  };
>
>  struct kvm_vcpu_csr {
> @@ -239,6 +240,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                         struct kvm_cpu_trap *trap);
>
>  void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
> +void __kvm_riscv_fp_f_save(struct kvm_cpu_context *context);
> +void __kvm_riscv_fp_f_restore(struct kvm_cpu_context *context);
> +void __kvm_riscv_fp_d_save(struct kvm_cpu_context *context);
> +void __kvm_riscv_fp_d_restore(struct kvm_cpu_context *context);
>
>  int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
>  int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
> diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
> index 91c77555d914..24d3827e4837 100644
> --- a/arch/riscv/kernel/asm-offsets.c
> +++ b/arch/riscv/kernel/asm-offsets.c
> @@ -195,6 +195,78 @@ void asm_offsets(void)
>         OFFSET(KVM_ARCH_TRAP_HTVAL, kvm_cpu_trap, htval);
>         OFFSET(KVM_ARCH_TRAP_HTINST, kvm_cpu_trap, htinst);
>
> +       /* F extension */
> +
> +       OFFSET(KVM_ARCH_FP_F_F0, kvm_cpu_context, fp.f.f[0]);
> +       OFFSET(KVM_ARCH_FP_F_F1, kvm_cpu_context, fp.f.f[1]);
> +       OFFSET(KVM_ARCH_FP_F_F2, kvm_cpu_context, fp.f.f[2]);
> +       OFFSET(KVM_ARCH_FP_F_F3, kvm_cpu_context, fp.f.f[3]);
> +       OFFSET(KVM_ARCH_FP_F_F4, kvm_cpu_context, fp.f.f[4]);
> +       OFFSET(KVM_ARCH_FP_F_F5, kvm_cpu_context, fp.f.f[5]);
> +       OFFSET(KVM_ARCH_FP_F_F6, kvm_cpu_context, fp.f.f[6]);
> +       OFFSET(KVM_ARCH_FP_F_F7, kvm_cpu_context, fp.f.f[7]);
> +       OFFSET(KVM_ARCH_FP_F_F8, kvm_cpu_context, fp.f.f[8]);
> +       OFFSET(KVM_ARCH_FP_F_F9, kvm_cpu_context, fp.f.f[9]);
> +       OFFSET(KVM_ARCH_FP_F_F10, kvm_cpu_context, fp.f.f[10]);
> +       OFFSET(KVM_ARCH_FP_F_F11, kvm_cpu_context, fp.f.f[11]);
> +       OFFSET(KVM_ARCH_FP_F_F12, kvm_cpu_context, fp.f.f[12]);
> +       OFFSET(KVM_ARCH_FP_F_F13, kvm_cpu_context, fp.f.f[13]);
> +       OFFSET(KVM_ARCH_FP_F_F14, kvm_cpu_context, fp.f.f[14]);
> +       OFFSET(KVM_ARCH_FP_F_F15, kvm_cpu_context, fp.f.f[15]);
> +       OFFSET(KVM_ARCH_FP_F_F16, kvm_cpu_context, fp.f.f[16]);
> +       OFFSET(KVM_ARCH_FP_F_F17, kvm_cpu_context, fp.f.f[17]);
> +       OFFSET(KVM_ARCH_FP_F_F18, kvm_cpu_context, fp.f.f[18]);
> +       OFFSET(KVM_ARCH_FP_F_F19, kvm_cpu_context, fp.f.f[19]);
> +       OFFSET(KVM_ARCH_FP_F_F20, kvm_cpu_context, fp.f.f[20]);
> +       OFFSET(KVM_ARCH_FP_F_F21, kvm_cpu_context, fp.f.f[21]);
> +       OFFSET(KVM_ARCH_FP_F_F22, kvm_cpu_context, fp.f.f[22]);
> +       OFFSET(KVM_ARCH_FP_F_F23, kvm_cpu_context, fp.f.f[23]);
> +       OFFSET(KVM_ARCH_FP_F_F24, kvm_cpu_context, fp.f.f[24]);
> +       OFFSET(KVM_ARCH_FP_F_F25, kvm_cpu_context, fp.f.f[25]);
> +       OFFSET(KVM_ARCH_FP_F_F26, kvm_cpu_context, fp.f.f[26]);
> +       OFFSET(KVM_ARCH_FP_F_F27, kvm_cpu_context, fp.f.f[27]);
> +       OFFSET(KVM_ARCH_FP_F_F28, kvm_cpu_context, fp.f.f[28]);
> +       OFFSET(KVM_ARCH_FP_F_F29, kvm_cpu_context, fp.f.f[29]);
> +       OFFSET(KVM_ARCH_FP_F_F30, kvm_cpu_context, fp.f.f[30]);
> +       OFFSET(KVM_ARCH_FP_F_F31, kvm_cpu_context, fp.f.f[31]);
> +       OFFSET(KVM_ARCH_FP_F_FCSR, kvm_cpu_context, fp.f.fcsr);
> +
> +       /* D extension */
> +
> +       OFFSET(KVM_ARCH_FP_D_F0, kvm_cpu_context, fp.d.f[0]);
> +       OFFSET(KVM_ARCH_FP_D_F1, kvm_cpu_context, fp.d.f[1]);
> +       OFFSET(KVM_ARCH_FP_D_F2, kvm_cpu_context, fp.d.f[2]);
> +       OFFSET(KVM_ARCH_FP_D_F3, kvm_cpu_context, fp.d.f[3]);
> +       OFFSET(KVM_ARCH_FP_D_F4, kvm_cpu_context, fp.d.f[4]);
> +       OFFSET(KVM_ARCH_FP_D_F5, kvm_cpu_context, fp.d.f[5]);
> +       OFFSET(KVM_ARCH_FP_D_F6, kvm_cpu_context, fp.d.f[6]);
> +       OFFSET(KVM_ARCH_FP_D_F7, kvm_cpu_context, fp.d.f[7]);
> +       OFFSET(KVM_ARCH_FP_D_F8, kvm_cpu_context, fp.d.f[8]);
> +       OFFSET(KVM_ARCH_FP_D_F9, kvm_cpu_context, fp.d.f[9]);
> +       OFFSET(KVM_ARCH_FP_D_F10, kvm_cpu_context, fp.d.f[10]);
> +       OFFSET(KVM_ARCH_FP_D_F11, kvm_cpu_context, fp.d.f[11]);
> +       OFFSET(KVM_ARCH_FP_D_F12, kvm_cpu_context, fp.d.f[12]);
> +       OFFSET(KVM_ARCH_FP_D_F13, kvm_cpu_context, fp.d.f[13]);
> +       OFFSET(KVM_ARCH_FP_D_F14, kvm_cpu_context, fp.d.f[14]);
> +       OFFSET(KVM_ARCH_FP_D_F15, kvm_cpu_context, fp.d.f[15]);
> +       OFFSET(KVM_ARCH_FP_D_F16, kvm_cpu_context, fp.d.f[16]);
> +       OFFSET(KVM_ARCH_FP_D_F17, kvm_cpu_context, fp.d.f[17]);
> +       OFFSET(KVM_ARCH_FP_D_F18, kvm_cpu_context, fp.d.f[18]);
> +       OFFSET(KVM_ARCH_FP_D_F19, kvm_cpu_context, fp.d.f[19]);
> +       OFFSET(KVM_ARCH_FP_D_F20, kvm_cpu_context, fp.d.f[20]);
> +       OFFSET(KVM_ARCH_FP_D_F21, kvm_cpu_context, fp.d.f[21]);
> +       OFFSET(KVM_ARCH_FP_D_F22, kvm_cpu_context, fp.d.f[22]);
> +       OFFSET(KVM_ARCH_FP_D_F23, kvm_cpu_context, fp.d.f[23]);
> +       OFFSET(KVM_ARCH_FP_D_F24, kvm_cpu_context, fp.d.f[24]);
> +       OFFSET(KVM_ARCH_FP_D_F25, kvm_cpu_context, fp.d.f[25]);
> +       OFFSET(KVM_ARCH_FP_D_F26, kvm_cpu_context, fp.d.f[26]);
> +       OFFSET(KVM_ARCH_FP_D_F27, kvm_cpu_context, fp.d.f[27]);
> +       OFFSET(KVM_ARCH_FP_D_F28, kvm_cpu_context, fp.d.f[28]);
> +       OFFSET(KVM_ARCH_FP_D_F29, kvm_cpu_context, fp.d.f[29]);
> +       OFFSET(KVM_ARCH_FP_D_F30, kvm_cpu_context, fp.d.f[30]);
> +       OFFSET(KVM_ARCH_FP_D_F31, kvm_cpu_context, fp.d.f[31]);
> +       OFFSET(KVM_ARCH_FP_D_FCSR, kvm_cpu_context, fp.d.fcsr);
> +
>         /*
>          * THREAD_{F,X}* might be larger than a S-type offset can handle, but
>          * these are used in performance-sensitive assembly so we can't resort
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index f26b249eae8e..024f2c6e7582 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -40,6 +40,86 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
>                        sizeof(kvm_vcpu_stats_desc),
>  };
>
> +#ifdef CONFIG_FPU
> +static void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long isa = vcpu->arch.isa;
> +       struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
> +
> +       cntx->sstatus &= ~SR_FS;
> +       if (riscv_isa_extension_available(&isa, f) ||
> +           riscv_isa_extension_available(&isa, d))
> +               cntx->sstatus |= SR_FS_INITIAL;
> +       else
> +               cntx->sstatus |= SR_FS_OFF;
> +}
> +
> +static void kvm_riscv_vcpu_fp_clean(struct kvm_cpu_context *cntx)
> +{
> +       cntx->sstatus &= ~SR_FS;
> +       cntx->sstatus |= SR_FS_CLEAN;
> +}
> +
> +static void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
> +                                        unsigned long isa)
> +{
> +       if ((cntx->sstatus & SR_FS) == SR_FS_DIRTY) {
> +               if (riscv_isa_extension_available(&isa, d))
> +                       __kvm_riscv_fp_d_save(cntx);
> +               else if (riscv_isa_extension_available(&isa, f))
> +                       __kvm_riscv_fp_f_save(cntx);
> +               kvm_riscv_vcpu_fp_clean(cntx);

Hi Anup and Atish,
First of all, thank you very much for contributing this patch set to
add H extension support to the Linux kernel.

I tried to do some development based on this patchset and encountered
some strange behaviors related to FPU registers. After diagnosis, I
suspect the root cause of these behaviors is in the
kvm_riscv_vcpu_fp_clean().
In the kvm_riscv_vcpu_fp_clean(), the sstatus.FS field of guest OS
will be set to clean. It will cause the guest kernel to mistakenly
believe the status of the FPU register is clean so that the guest OS
will not save the value of FPU registers to the process context before
this process is scheduled out. However, here the host OS only saves
the FPU register to the guest OS context instead of the process
context. In this case, for the process in the guest OS, the data in
FPU registers may be lost due to the lack of context saving before
scheduling out. Therefore, IMHO, the kvm_riscv_vcpu_fp_clean() might
be unnecessary and could be removed.

> +       }
> +}
> +
> +static void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
> +                                           unsigned long isa)
> +{
> +       if ((cntx->sstatus & SR_FS) != SR_FS_OFF) {
> +               if (riscv_isa_extension_available(&isa, d))
> +                       __kvm_riscv_fp_d_restore(cntx);
> +               else if (riscv_isa_extension_available(&isa, f))
> +                       __kvm_riscv_fp_f_restore(cntx);
> +               kvm_riscv_vcpu_fp_clean(cntx);

The reason is the same as above. Here the kvm_riscv_vcpu_fp_clean()
might be unnecessary and could be removed.

> +}
> +
> +static void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx)
> +{
> +       /* No need to check host sstatus as it can be modified outside */
> +       if (riscv_isa_extension_available(NULL, d))
> +               __kvm_riscv_fp_d_save(cntx);
> +       else if (riscv_isa_extension_available(NULL, f))
> +               __kvm_riscv_fp_f_save(cntx);
> +}
> +
> +static void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx)
> +{
> +       if (riscv_isa_extension_available(NULL, d))
> +               __kvm_riscv_fp_d_restore(cntx);
> +       else if (riscv_isa_extension_available(NULL, f))
> +               __kvm_riscv_fp_f_restore(cntx);
> +}
> +#else
> +static void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
> +{
> +}
> +static void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
> +                                        unsigned long isa)
> +{
> +}
> +static void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
> +                                           unsigned long isa)
> +{
> +}
> +static void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx)
> +{
> +}
> +static void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx)
> +{
> +}
> +#endif
> +
>  #define KVM_RISCV_ISA_ALLOWED  (riscv_isa_extension_mask(a) | \
>                                  riscv_isa_extension_mask(c) | \
>                                  riscv_isa_extension_mask(d) | \
> @@ -60,6 +140,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>
>         memcpy(cntx, reset_cntx, sizeof(*cntx));
>
> +       kvm_riscv_vcpu_fp_reset(vcpu);
> +
>         kvm_riscv_vcpu_timer_reset(vcpu);
>
>         WRITE_ONCE(vcpu->arch.irqs_pending, 0);
> @@ -194,6 +276,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>                         vcpu->arch.isa = reg_val;
>                         vcpu->arch.isa &= riscv_isa_extension_base(NULL);
>                         vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
> +                       kvm_riscv_vcpu_fp_reset(vcpu);
>                 } else {
>                         return -EOPNOTSUPP;
>                 }
> @@ -598,6 +681,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>
>         kvm_riscv_vcpu_timer_restore(vcpu);
>
> +       kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
> +       kvm_riscv_vcpu_guest_fp_restore(&vcpu->arch.guest_context,
> +                                       vcpu->arch.isa);
> +
>         vcpu->cpu = cpu;
>  }
>
> @@ -607,6 +694,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>
>         vcpu->cpu = -1;
>
> +       kvm_riscv_vcpu_guest_fp_save(&vcpu->arch.guest_context,
> +                                    vcpu->arch.isa);
> +       kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
> +
>         csr_write(CSR_HGATP, 0);
>
>         csr->vsstatus = csr_read(CSR_VSSTATUS);
> diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
> index e22721e1b892..029a28a195c6 100644
> --- a/arch/riscv/kvm/vcpu_switch.S
> +++ b/arch/riscv/kvm/vcpu_switch.S
> @@ -224,3 +224,177 @@ ENTRY(__kvm_riscv_unpriv_trap)
>         REG_S   a1, (KVM_ARCH_TRAP_HTINST)(a0)
>         sret
>  ENDPROC(__kvm_riscv_unpriv_trap)
> +
> +#ifdef CONFIG_FPU
> +       .align 3
> +       .global __kvm_riscv_fp_f_save
> +__kvm_riscv_fp_f_save:
> +       csrr t2, CSR_SSTATUS
> +       li t1, SR_FS
> +       csrs CSR_SSTATUS, t1
> +       frcsr t0
> +       fsw f0,  KVM_ARCH_FP_F_F0(a0)
> +       fsw f1,  KVM_ARCH_FP_F_F1(a0)
> +       fsw f2,  KVM_ARCH_FP_F_F2(a0)
> +       fsw f3,  KVM_ARCH_FP_F_F3(a0)
> +       fsw f4,  KVM_ARCH_FP_F_F4(a0)
> +       fsw f5,  KVM_ARCH_FP_F_F5(a0)
> +       fsw f6,  KVM_ARCH_FP_F_F6(a0)
> +       fsw f7,  KVM_ARCH_FP_F_F7(a0)
> +       fsw f8,  KVM_ARCH_FP_F_F8(a0)
> +       fsw f9,  KVM_ARCH_FP_F_F9(a0)
> +       fsw f10, KVM_ARCH_FP_F_F10(a0)
> +       fsw f11, KVM_ARCH_FP_F_F11(a0)
> +       fsw f12, KVM_ARCH_FP_F_F12(a0)
> +       fsw f13, KVM_ARCH_FP_F_F13(a0)
> +       fsw f14, KVM_ARCH_FP_F_F14(a0)
> +       fsw f15, KVM_ARCH_FP_F_F15(a0)
> +       fsw f16, KVM_ARCH_FP_F_F16(a0)
> +       fsw f17, KVM_ARCH_FP_F_F17(a0)
> +       fsw f18, KVM_ARCH_FP_F_F18(a0)
> +       fsw f19, KVM_ARCH_FP_F_F19(a0)
> +       fsw f20, KVM_ARCH_FP_F_F20(a0)
> +       fsw f21, KVM_ARCH_FP_F_F21(a0)
> +       fsw f22, KVM_ARCH_FP_F_F22(a0)
> +       fsw f23, KVM_ARCH_FP_F_F23(a0)
> +       fsw f24, KVM_ARCH_FP_F_F24(a0)
> +       fsw f25, KVM_ARCH_FP_F_F25(a0)
> +       fsw f26, KVM_ARCH_FP_F_F26(a0)
> +       fsw f27, KVM_ARCH_FP_F_F27(a0)
> +       fsw f28, KVM_ARCH_FP_F_F28(a0)
> +       fsw f29, KVM_ARCH_FP_F_F29(a0)
> +       fsw f30, KVM_ARCH_FP_F_F30(a0)
> +       fsw f31, KVM_ARCH_FP_F_F31(a0)
> +       sw t0, KVM_ARCH_FP_F_FCSR(a0)
> +       csrw CSR_SSTATUS, t2
> +       ret
> +
> +       .align 3
> +       .global __kvm_riscv_fp_d_save
> +__kvm_riscv_fp_d_save:
> +       csrr t2, CSR_SSTATUS
> +       li t1, SR_FS
> +       csrs CSR_SSTATUS, t1
> +       frcsr t0
> +       fsd f0,  KVM_ARCH_FP_D_F0(a0)
> +       fsd f1,  KVM_ARCH_FP_D_F1(a0)
> +       fsd f2,  KVM_ARCH_FP_D_F2(a0)
> +       fsd f3,  KVM_ARCH_FP_D_F3(a0)
> +       fsd f4,  KVM_ARCH_FP_D_F4(a0)
> +       fsd f5,  KVM_ARCH_FP_D_F5(a0)
> +       fsd f6,  KVM_ARCH_FP_D_F6(a0)
> +       fsd f7,  KVM_ARCH_FP_D_F7(a0)
> +       fsd f8,  KVM_ARCH_FP_D_F8(a0)
> +       fsd f9,  KVM_ARCH_FP_D_F9(a0)
> +       fsd f10, KVM_ARCH_FP_D_F10(a0)
> +       fsd f11, KVM_ARCH_FP_D_F11(a0)
> +       fsd f12, KVM_ARCH_FP_D_F12(a0)
> +       fsd f13, KVM_ARCH_FP_D_F13(a0)
> +       fsd f14, KVM_ARCH_FP_D_F14(a0)
> +       fsd f15, KVM_ARCH_FP_D_F15(a0)
> +       fsd f16, KVM_ARCH_FP_D_F16(a0)
> +       fsd f17, KVM_ARCH_FP_D_F17(a0)
> +       fsd f18, KVM_ARCH_FP_D_F18(a0)
> +       fsd f19, KVM_ARCH_FP_D_F19(a0)
> +       fsd f20, KVM_ARCH_FP_D_F20(a0)
> +       fsd f21, KVM_ARCH_FP_D_F21(a0)
> +       fsd f22, KVM_ARCH_FP_D_F22(a0)
> +       fsd f23, KVM_ARCH_FP_D_F23(a0)
> +       fsd f24, KVM_ARCH_FP_D_F24(a0)
> +       fsd f25, KVM_ARCH_FP_D_F25(a0)
> +       fsd f26, KVM_ARCH_FP_D_F26(a0)
> +       fsd f27, KVM_ARCH_FP_D_F27(a0)
> +       fsd f28, KVM_ARCH_FP_D_F28(a0)
> +       fsd f29, KVM_ARCH_FP_D_F29(a0)
> +       fsd f30, KVM_ARCH_FP_D_F30(a0)
> +       fsd f31, KVM_ARCH_FP_D_F31(a0)
> +       sw t0, KVM_ARCH_FP_D_FCSR(a0)
> +       csrw CSR_SSTATUS, t2
> +       ret
> +
> +       .align 3
> +       .global __kvm_riscv_fp_f_restore
> +__kvm_riscv_fp_f_restore:
> +       csrr t2, CSR_SSTATUS
> +       li t1, SR_FS
> +       lw t0, KVM_ARCH_FP_F_FCSR(a0)
> +       csrs CSR_SSTATUS, t1
> +       flw f0,  KVM_ARCH_FP_F_F0(a0)
> +       flw f1,  KVM_ARCH_FP_F_F1(a0)
> +       flw f2,  KVM_ARCH_FP_F_F2(a0)
> +       flw f3,  KVM_ARCH_FP_F_F3(a0)
> +       flw f4,  KVM_ARCH_FP_F_F4(a0)
> +       flw f5,  KVM_ARCH_FP_F_F5(a0)
> +       flw f6,  KVM_ARCH_FP_F_F6(a0)
> +       flw f7,  KVM_ARCH_FP_F_F7(a0)
> +       flw f8,  KVM_ARCH_FP_F_F8(a0)
> +       flw f9,  KVM_ARCH_FP_F_F9(a0)
> +       flw f10, KVM_ARCH_FP_F_F10(a0)
> +       flw f11, KVM_ARCH_FP_F_F11(a0)
> +       flw f12, KVM_ARCH_FP_F_F12(a0)
> +       flw f13, KVM_ARCH_FP_F_F13(a0)
> +       flw f14, KVM_ARCH_FP_F_F14(a0)
> +       flw f15, KVM_ARCH_FP_F_F15(a0)
> +       flw f16, KVM_ARCH_FP_F_F16(a0)
> +       flw f17, KVM_ARCH_FP_F_F17(a0)
> +       flw f18, KVM_ARCH_FP_F_F18(a0)
> +       flw f19, KVM_ARCH_FP_F_F19(a0)
> +       flw f20, KVM_ARCH_FP_F_F20(a0)
> +       flw f21, KVM_ARCH_FP_F_F21(a0)
> +       flw f22, KVM_ARCH_FP_F_F22(a0)
> +       flw f23, KVM_ARCH_FP_F_F23(a0)
> +       flw f24, KVM_ARCH_FP_F_F24(a0)
> +       flw f25, KVM_ARCH_FP_F_F25(a0)
> +       flw f26, KVM_ARCH_FP_F_F26(a0)
> +       flw f27, KVM_ARCH_FP_F_F27(a0)
> +       flw f28, KVM_ARCH_FP_F_F28(a0)
> +       flw f29, KVM_ARCH_FP_F_F29(a0)
> +       flw f30, KVM_ARCH_FP_F_F30(a0)
> +       flw f31, KVM_ARCH_FP_F_F31(a0)
> +       fscsr t0
> +       csrw CSR_SSTATUS, t2
> +       ret
> +
> +       .align 3
> +       .global __kvm_riscv_fp_d_restore
> +__kvm_riscv_fp_d_restore:
> +       csrr t2, CSR_SSTATUS
> +       li t1, SR_FS
> +       lw t0, KVM_ARCH_FP_D_FCSR(a0)
> +       csrs CSR_SSTATUS, t1
> +       fld f0,  KVM_ARCH_FP_D_F0(a0)
> +       fld f1,  KVM_ARCH_FP_D_F1(a0)
> +       fld f2,  KVM_ARCH_FP_D_F2(a0)
> +       fld f3,  KVM_ARCH_FP_D_F3(a0)
> +       fld f4,  KVM_ARCH_FP_D_F4(a0)
> +       fld f5,  KVM_ARCH_FP_D_F5(a0)
> +       fld f6,  KVM_ARCH_FP_D_F6(a0)
> +       fld f7,  KVM_ARCH_FP_D_F7(a0)
> +       fld f8,  KVM_ARCH_FP_D_F8(a0)
> +       fld f9,  KVM_ARCH_FP_D_F9(a0)
> +       fld f10, KVM_ARCH_FP_D_F10(a0)
> +       fld f11, KVM_ARCH_FP_D_F11(a0)
> +       fld f12, KVM_ARCH_FP_D_F12(a0)
> +       fld f13, KVM_ARCH_FP_D_F13(a0)
> +       fld f14, KVM_ARCH_FP_D_F14(a0)
> +       fld f15, KVM_ARCH_FP_D_F15(a0)
> +       fld f16, KVM_ARCH_FP_D_F16(a0)
> +       fld f17, KVM_ARCH_FP_D_F17(a0)
> +       fld f18, KVM_ARCH_FP_D_F18(a0)
> +       fld f19, KVM_ARCH_FP_D_F19(a0)
> +       fld f20, KVM_ARCH_FP_D_F20(a0)
> +       fld f21, KVM_ARCH_FP_D_F21(a0)
> +       fld f22, KVM_ARCH_FP_D_F22(a0)
> +       fld f23, KVM_ARCH_FP_D_F23(a0)
> +       fld f24, KVM_ARCH_FP_D_F24(a0)
> +       fld f25, KVM_ARCH_FP_D_F25(a0)
> +       fld f26, KVM_ARCH_FP_D_F26(a0)
> +       fld f27, KVM_ARCH_FP_D_F27(a0)
> +       fld f28, KVM_ARCH_FP_D_F28(a0)
> +       fld f29, KVM_ARCH_FP_D_F29(a0)
> +       fld f30, KVM_ARCH_FP_D_F30(a0)
> +       fld f31, KVM_ARCH_FP_D_F31(a0)
> +       fscsr t0
> +       csrw CSR_SSTATUS, t2
> +       ret
> +#endif
> --
> 2.25.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
