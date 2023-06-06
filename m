Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5398725026
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 00:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240011AbjFFWto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 18:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbjFFWtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 18:49:39 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BC910FD
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 15:49:37 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2b1ba018d94so47435941fa.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 15:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1686091775; x=1688683775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3O84Kr2aCzlDWKopTTwNiejrO0oE+BpcM66RIGfp2cI=;
        b=DT2jRBXjDiC/DZ+R3kaPfYV13qblbKwBko0caM2iz4iRhtWyDEFbVqikFudP8DAJwq
         JD6sTPOqOOOEKYrI4oE7fvGTbP0E0K8pCsv41d9sxnJ7+l24SjJScKYbWXn8CXjbgb+a
         Nopv5uvz2lHX4NgczrG7pFoYxG56UaX9wLMWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686091775; x=1688683775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3O84Kr2aCzlDWKopTTwNiejrO0oE+BpcM66RIGfp2cI=;
        b=KXR5nCIftQXl1BRV1WKb7MdhqPFeUcZhU/E08sRPJIDPZHbMzIS3VP1YTlZIeiA4QP
         DMiDTpaywlDUIs+yFZnDFlb+1rsIzKqfSCTE4eXRDjB03etugLHr7lyxONzfEzLoJe34
         MIbBvzIhYePFTJbRYFoXCiBpWKhFqXfTBHdVPaWuSbz0aoybX6q0y6VWtF4xzS+f3S/q
         AXfWKMcbX/Q9DctMmYuoWmqKfjfteKZZfFG3PY2qjnEWoLqmH6a71h8yoITv3dKXvanU
         FhooK3dxz8v5UmDg7UNOuPPfUdSjTNSiNarPj/2DCaacHEu1e1vJqk3dOVQAZPbgDycV
         FXlg==
X-Gm-Message-State: AC+VfDwwFL/RB/QGyM9NE3SizZyVb0Q6PHwo+ZvH8Mq4ZLgRhaJ3q2F6
        6VHI48P7GDvwD2CE2c1cs0AJjyRgRId1UH+o4p17
X-Google-Smtp-Source: ACHHUZ5zUx1toihhCA0UeG0UtKQ+EQNtgBbRc85cMA5ctycEW/K/uX85ifPQebKC88uB0XbQqx86SAqUs8EfRXR0ywg=
X-Received: by 2002:a2e:9192:0:b0:2ac:7904:e38f with SMTP id
 f18-20020a2e9192000000b002ac7904e38fmr1815037ljg.12.1686091774943; Tue, 06
 Jun 2023 15:49:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230517105135.1871868-1-apatel@ventanamicro.com> <20230517105135.1871868-2-apatel@ventanamicro.com>
In-Reply-To: <20230517105135.1871868-2-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 6 Jun 2023 15:49:23 -0700
Message-ID: <CAOnJCUKftuqtKhmzaHjV5FbdszYoASPRuaU4ZER4e-tNsmcuzw@mail.gmail.com>
Subject: Re: [PATCH 01/10] RISC-V: KVM: Implement guest external interrupt
 line management
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 17, 2023 at 3:51=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> The RISC-V host will have one guest external interrupt line for each
> VS-level IMSICs associated with a HART. The guest external interrupt
> lines are per-HART resources and hypervisor can use HGEIE, HGEIP, and
> HIE CSRs to manage these guest external interrupt lines.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia.h |  10 ++
>  arch/riscv/kvm/aia.c             | 244 +++++++++++++++++++++++++++++++
>  arch/riscv/kvm/main.c            |   3 +-
>  arch/riscv/kvm/vcpu.c            |   2 +
>  4 files changed, 258 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kv=
m_aia.h
> index 1de0717112e5..0938e0cadf80 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -44,10 +44,15 @@ struct kvm_vcpu_aia {
>
>  #define irqchip_in_kernel(k)           ((k)->arch.aia.in_kernel)
>
> +extern unsigned int kvm_riscv_aia_nr_hgei;
>  DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
>  #define kvm_riscv_aia_available() \
>         static_branch_unlikely(&kvm_riscv_aia_available)
>
> +static inline void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcp=
u)
> +{
> +}
> +
>  #define KVM_RISCV_AIA_IMSIC_TOPEI      (ISELECT_MASK + 1)
>  static inline int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu,
>                                                unsigned long isel,
> @@ -119,6 +124,11 @@ static inline void kvm_riscv_aia_destroy_vm(struct k=
vm *kvm)
>  {
>  }
>
> +int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
> +                            void __iomem **hgei_va, phys_addr_t *hgei_pa=
);
> +void kvm_riscv_aia_free_hgei(int cpu, int hgei);
> +void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable);
> +
>  void kvm_riscv_aia_enable(void);
>  void kvm_riscv_aia_disable(void);
>  int kvm_riscv_aia_init(void);
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index 4f1286fc7f17..1cee75a8c883 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -8,11 +8,47 @@
>   */
>
>  #include <linux/kernel.h>
> +#include <linux/bitops.h>
> +#include <linux/irq.h>
> +#include <linux/irqdomain.h>
>  #include <linux/kvm_host.h>
> +#include <linux/percpu.h>
> +#include <linux/spinlock.h>
>  #include <asm/hwcap.h>
>
> +struct aia_hgei_control {
> +       raw_spinlock_t lock;
> +       unsigned long free_bitmap;
> +       struct kvm_vcpu *owners[BITS_PER_LONG];
> +};
> +static DEFINE_PER_CPU(struct aia_hgei_control, aia_hgei);
> +static int hgei_parent_irq;
> +
> +unsigned int kvm_riscv_aia_nr_hgei;
>  DEFINE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
>
> +static int aia_find_hgei(struct kvm_vcpu *owner)
> +{
> +       int i, hgei;
> +       unsigned long flags;
> +       struct aia_hgei_control *hgctrl =3D get_cpu_ptr(&aia_hgei);
> +
> +       raw_spin_lock_irqsave(&hgctrl->lock, flags);
> +
> +       hgei =3D -1;
> +       for (i =3D 1; i <=3D kvm_riscv_aia_nr_hgei; i++) {
> +               if (hgctrl->owners[i] =3D=3D owner) {
> +                       hgei =3D i;
> +                       break;
> +               }
> +       }
> +
> +       raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> +
> +       put_cpu_ptr(&aia_hgei);
> +       return hgei;
> +}
> +
>  static void aia_set_hvictl(bool ext_irq_pending)
>  {
>         unsigned long hvictl;
> @@ -56,6 +92,7 @@ void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu=
 *vcpu)
>
>  bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
>  {
> +       int hgei;
>         unsigned long seip;
>
>         if (!kvm_riscv_aia_available())
> @@ -74,6 +111,10 @@ bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcp=
u *vcpu, u64 mask)
>         if (!kvm_riscv_aia_initialized(vcpu->kvm) || !seip)
>                 return false;
>
> +       hgei =3D aia_find_hgei(vcpu);
> +       if (hgei > 0)
> +               return !!(csr_read(CSR_HGEIP) & BIT(hgei));
> +
>         return false;
>  }
>
> @@ -348,6 +389,143 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vc=
pu, unsigned int csr_num,
>         return KVM_INSN_EXIT_TO_USER_SPACE;
>  }
>
> +int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
> +                            void __iomem **hgei_va, phys_addr_t *hgei_pa=
)
> +{
> +       int ret =3D -ENOENT;
> +       unsigned long flags;
> +       struct aia_hgei_control *hgctrl =3D per_cpu_ptr(&aia_hgei, cpu);
> +
> +       if (!kvm_riscv_aia_available() || !hgctrl)
> +               return -ENODEV;
> +
> +       raw_spin_lock_irqsave(&hgctrl->lock, flags);
> +
> +       if (hgctrl->free_bitmap) {
> +               ret =3D __ffs(hgctrl->free_bitmap);
> +               hgctrl->free_bitmap &=3D ~BIT(ret);
> +               hgctrl->owners[ret] =3D owner;
> +       }
> +
> +       raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> +
> +       /* TODO: To be updated later by AIA in-kernel irqchip support */
> +       if (hgei_va)
> +               *hgei_va =3D NULL;
> +       if (hgei_pa)
> +               *hgei_pa =3D 0;
> +
> +       return ret;
> +}
> +
> +void kvm_riscv_aia_free_hgei(int cpu, int hgei)
> +{
> +       unsigned long flags;
> +       struct aia_hgei_control *hgctrl =3D per_cpu_ptr(&aia_hgei, cpu);
> +
> +       if (!kvm_riscv_aia_available() || !hgctrl)
> +               return;
> +
> +       raw_spin_lock_irqsave(&hgctrl->lock, flags);
> +
> +       if (hgei > 0 && hgei <=3D kvm_riscv_aia_nr_hgei) {
> +               if (!(hgctrl->free_bitmap & BIT(hgei))) {
> +                       hgctrl->free_bitmap |=3D BIT(hgei);
> +                       hgctrl->owners[hgei] =3D NULL;
> +               }
> +       }
> +
> +       raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> +}
> +
> +void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable)
> +{
> +       int hgei;
> +
> +       if (!kvm_riscv_aia_available())
> +               return;
> +
> +       hgei =3D aia_find_hgei(owner);
> +       if (hgei > 0) {
> +               if (enable)
> +                       csr_set(CSR_HGEIE, BIT(hgei));
> +               else
> +                       csr_clear(CSR_HGEIE, BIT(hgei));
> +       }
> +}
> +
> +static irqreturn_t hgei_interrupt(int irq, void *dev_id)
> +{
> +       int i;
> +       unsigned long hgei_mask, flags;
> +       struct aia_hgei_control *hgctrl =3D get_cpu_ptr(&aia_hgei);
> +
> +       hgei_mask =3D csr_read(CSR_HGEIP) & csr_read(CSR_HGEIE);
> +       csr_clear(CSR_HGEIE, hgei_mask);
> +
> +       raw_spin_lock_irqsave(&hgctrl->lock, flags);
> +
> +       for_each_set_bit(i, &hgei_mask, BITS_PER_LONG) {
> +               if (hgctrl->owners[i])
> +                       kvm_vcpu_kick(hgctrl->owners[i]);
> +       }
> +
> +       raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> +
> +       put_cpu_ptr(&aia_hgei);
> +       return IRQ_HANDLED;
> +}
> +
> +static int aia_hgei_init(void)
> +{
> +       int cpu, rc;
> +       struct irq_domain *domain;
> +       struct aia_hgei_control *hgctrl;
> +
> +       /* Initialize per-CPU guest external interrupt line management */
> +       for_each_possible_cpu(cpu) {
> +               hgctrl =3D per_cpu_ptr(&aia_hgei, cpu);
> +               raw_spin_lock_init(&hgctrl->lock);
> +               if (kvm_riscv_aia_nr_hgei) {
> +                       hgctrl->free_bitmap =3D
> +                               BIT(kvm_riscv_aia_nr_hgei + 1) - 1;
> +                       hgctrl->free_bitmap &=3D ~BIT(0);
> +               } else
> +                       hgctrl->free_bitmap =3D 0;
> +       }
> +
> +       /* Find INTC irq domain */
> +       domain =3D irq_find_matching_fwnode(riscv_get_intc_hwnode(),
> +                                         DOMAIN_BUS_ANY);
> +       if (!domain) {
> +               kvm_err("unable to find INTC domain\n");
> +               return -ENOENT;
> +       }
> +
> +       /* Map per-CPU SGEI interrupt from INTC domain */
> +       hgei_parent_irq =3D irq_create_mapping(domain, IRQ_S_GEXT);
> +       if (!hgei_parent_irq) {
> +               kvm_err("unable to map SGEI IRQ\n");
> +               return -ENOMEM;
> +       }
> +
> +       /* Request per-CPU SGEI interrupt */
> +       rc =3D request_percpu_irq(hgei_parent_irq, hgei_interrupt,
> +                               "riscv-kvm", &aia_hgei);
> +       if (rc) {
> +               kvm_err("failed to request SGEI IRQ\n");
> +               return rc;
> +       }
> +
> +       return 0;
> +}
> +
> +static void aia_hgei_exit(void)
> +{
> +       /* Free per-CPU SGEI interrupt */
> +       free_percpu_irq(hgei_parent_irq, &aia_hgei);
> +}
> +
>  void kvm_riscv_aia_enable(void)
>  {
>         if (!kvm_riscv_aia_available())
> @@ -362,21 +540,82 @@ void kvm_riscv_aia_enable(void)
>         csr_write(CSR_HVIPRIO1H, 0x0);
>         csr_write(CSR_HVIPRIO2H, 0x0);
>  #endif
> +
> +       /* Enable per-CPU SGEI interrupt */
> +       enable_percpu_irq(hgei_parent_irq,
> +                         irq_get_trigger_type(hgei_parent_irq));
> +       csr_set(CSR_HIE, BIT(IRQ_S_GEXT));
>  }
>
>  void kvm_riscv_aia_disable(void)
>  {
> +       int i;
> +       unsigned long flags;
> +       struct kvm_vcpu *vcpu;
> +       struct aia_hgei_control *hgctrl;
> +
>         if (!kvm_riscv_aia_available())
>                 return;
> +       hgctrl =3D get_cpu_ptr(&aia_hgei);
> +
> +       /* Disable per-CPU SGEI interrupt */
> +       csr_clear(CSR_HIE, BIT(IRQ_S_GEXT));
> +       disable_percpu_irq(hgei_parent_irq);
>
>         aia_set_hvictl(false);
> +
> +       raw_spin_lock_irqsave(&hgctrl->lock, flags);
> +
> +       for (i =3D 0; i <=3D kvm_riscv_aia_nr_hgei; i++) {
> +               vcpu =3D hgctrl->owners[i];
> +               if (!vcpu)
> +                       continue;
> +
> +               /*
> +                * We release hgctrl->lock before notifying IMSIC
> +                * so that we don't have lock ordering issues.
> +                */
> +               raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> +
> +               /* Notify IMSIC */
> +               kvm_riscv_vcpu_aia_imsic_release(vcpu);
> +
> +               /*
> +                * Wakeup VCPU if it was blocked so that it can
> +                * run on other HARTs
> +                */
> +               if (csr_read(CSR_HGEIE) & BIT(i)) {
> +                       csr_clear(CSR_HGEIE, BIT(i));
> +                       kvm_vcpu_kick(vcpu);
> +               }
> +
> +               raw_spin_lock_irqsave(&hgctrl->lock, flags);
> +       }
> +
> +       raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> +
> +       put_cpu_ptr(&aia_hgei);
>  }
>
>  int kvm_riscv_aia_init(void)
>  {
> +       int rc;
> +
>         if (!riscv_isa_extension_available(NULL, SxAIA))
>                 return -ENODEV;
>
> +       /* Figure-out number of bits in HGEIE */
> +       csr_write(CSR_HGEIE, -1UL);
> +       kvm_riscv_aia_nr_hgei =3D fls_long(csr_read(CSR_HGEIE));
> +       csr_write(CSR_HGEIE, 0);
> +       if (kvm_riscv_aia_nr_hgei)
> +               kvm_riscv_aia_nr_hgei--;
> +
> +       /* Initialize guest external interrupt line management */
> +       rc =3D aia_hgei_init();
> +       if (rc)
> +               return rc;
> +
>         /* Enable KVM AIA support */
>         static_branch_enable(&kvm_riscv_aia_available);
>
> @@ -385,4 +624,9 @@ int kvm_riscv_aia_init(void)
>
>  void kvm_riscv_aia_exit(void)
>  {
> +       if (!kvm_riscv_aia_available())
> +               return;
> +
> +       /* Cleanup the HGEI state */
> +       aia_hgei_exit();
>  }
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index a7112d583637..48ae0d4b3932 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -116,7 +116,8 @@ static int __init riscv_kvm_init(void)
>         kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits(=
));
>
>         if (kvm_riscv_aia_available())
> -               kvm_info("AIA available\n");
> +               kvm_info("AIA available with %d guest external interrupts=
\n",
> +                        kvm_riscv_aia_nr_hgei);
>
>         rc =3D kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
>         if (rc) {
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 8bd9f2a8a0b9..2db62c6c0d3e 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -250,10 +250,12 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu=
)
>
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
>  {
> +       kvm_riscv_aia_wakeon_hgei(vcpu, true);
>  }
>
>  void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  {
> +       kvm_riscv_aia_wakeon_hgei(vcpu, false);
>  }
>
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
> --
> 2.34.1
>



Reviewed-by: Atish Patra <atishp@rivosinc.com>

--=20
Regards,
Atish
