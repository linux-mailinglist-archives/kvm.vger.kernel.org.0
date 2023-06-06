Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BE97250AF
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 01:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240266AbjFFXUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 19:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240388AbjFFXT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 19:19:56 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7955D1BC8
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 16:19:54 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id 71dfb90a1353d-466021212d0so23532e0c.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 16:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1686093593; x=1688685593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2RCHT2COdWryPrMvHCz/MFwKiAgVKwlfn/HHVFCUMWo=;
        b=ffRYjN1zXrdkruM5LzNn01OVnuQwT4eUN3gBzFgkLdOIDro2vWjTt5lLbQvfhC35PS
         m4gZk6fu5f58XXt0FDg/2ib5aHZ8t/TmyYQWG/J8ei/fDHQJpneD+1MwpKUQH8/iLUKB
         uHUA8gjGEMxf05S4keqM27sXiYdvZzTivso7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686093593; x=1688685593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2RCHT2COdWryPrMvHCz/MFwKiAgVKwlfn/HHVFCUMWo=;
        b=B+/G7KHxbYuoIBKY+t7QmRmAzPQ1fXzj/gZ9hP2b0vb+T7Q5lOqKkT8R/0MIxm2Uay
         knQ1qNepbXqTyLq0uVjXg8CRW9RLmVlU/xooUhU0s02ZqYwxPmV4mhjx7Y92BdpM9hDM
         wiLNXSHlZJSuew+KpNBNSySpm2CDYyWMn8guqwYA1w4xiKi+EO7+A0YAxqoK9wzi7vFg
         HDgssUZTL5N8jtxfVUr0oDtC3nCx176k7N+n+zG3Q5tkhLmN+xdML9ghdrl68ZchiBBR
         GWpc2pUekdmb07raMKW2Gq6EOWXLrh2OH5zx+Bp1m1JzucZYbsdhKtFVssYCDtPGvV2y
         FPPw==
X-Gm-Message-State: AC+VfDwfjjBLJRDihKA6RjCrtahqUykfAMSd51sR5ajK2pwBPGI4Rxak
        omp7WLpYGUHijj2Ehp8PJ/UzgXHPG1R+cyqwwA5+
X-Google-Smtp-Source: ACHHUZ78qqmUyPtOom7yhG9SY8oaE0K7IyTy7B5bFGwtRoSGXOea+4P0D9FQhu+ep9LARCGJJiCyb4IT5bCpeFz0jhc=
X-Received: by 2002:a1f:7c02:0:b0:457:56a4:19e7 with SMTP id
 x2-20020a1f7c02000000b0045756a419e7mr7690188vkc.0.1686093593451; Tue, 06 Jun
 2023 16:19:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230517105135.1871868-1-apatel@ventanamicro.com> <20230517105135.1871868-6-apatel@ventanamicro.com>
In-Reply-To: <20230517105135.1871868-6-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 6 Jun 2023 16:19:40 -0700
Message-ID: <CAOnJCULb03KPmdqz+JwTZe5T96+cyqDrydbq4VbZMwXobktg3Q@mail.gmail.com>
Subject: Re: [PATCH 05/10] RISC-V: KVM: Skeletal in-kernel AIA irqchip support
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 17, 2023 at 3:52=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> To incrementally implement in-kernel AIA irqchip support, we first
> add minimal skeletal support which only compiles but does not provide
> any functionality.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia.h  |  20 ++++++
>  arch/riscv/include/asm/kvm_host.h |   4 ++
>  arch/riscv/include/uapi/asm/kvm.h |   4 ++
>  arch/riscv/kvm/Kconfig            |   4 ++
>  arch/riscv/kvm/aia.c              |   8 +++
>  arch/riscv/kvm/vm.c               | 115 ++++++++++++++++++++++++++++++
>  6 files changed, 155 insertions(+)
>
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kv=
m_aia.h
> index 0938e0cadf80..3bc0a0e47a15 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -45,6 +45,7 @@ struct kvm_vcpu_aia {
>  #define irqchip_in_kernel(k)           ((k)->arch.aia.in_kernel)
>
>  extern unsigned int kvm_riscv_aia_nr_hgei;
> +extern unsigned int kvm_riscv_aia_max_ids;
>  DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
>  #define kvm_riscv_aia_available() \
>         static_branch_unlikely(&kvm_riscv_aia_available)
> @@ -116,6 +117,25 @@ static inline void kvm_riscv_vcpu_aia_deinit(struct =
kvm_vcpu *vcpu)
>  {
>  }
>
> +static inline int kvm_riscv_aia_inject_msi_by_id(struct kvm *kvm,
> +                                                u32 hart_index,
> +                                                u32 guest_index, u32 iid=
)
> +{
> +       return 0;
> +}
> +
> +static inline int kvm_riscv_aia_inject_msi(struct kvm *kvm,
> +                                          struct kvm_msi *msi)
> +{
> +       return 0;
> +}
> +
> +static inline int kvm_riscv_aia_inject_irq(struct kvm *kvm,
> +                                          unsigned int irq, bool level)
> +{
> +       return 0;
> +}
> +
>  static inline void kvm_riscv_aia_init_vm(struct kvm *kvm)
>  {
>  }
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index ee0acccb1d3b..871432586a63 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -27,6 +27,8 @@
>
>  #define KVM_VCPU_MAX_FEATURES          0
>
> +#define KVM_IRQCHIP_NUM_PINS           1024
> +
>  #define KVM_REQ_SLEEP \
>         KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_VCPU_RESET             KVM_ARCH_REQ(1)
> @@ -318,6 +320,8 @@ int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
>  bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
>  void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
>
> +int kvm_riscv_setup_default_irq_routing(struct kvm *kvm, u32 lines);
> +
>  void __kvm_riscv_unpriv_trap(void);
>
>  unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index f92790c9481a..332d4a274891 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -15,6 +15,7 @@
>  #include <asm/bitsperlong.h>
>  #include <asm/ptrace.h>
>
> +#define __KVM_HAVE_IRQ_LINE
>  #define __KVM_HAVE_READONLY_MEM
>
>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> @@ -203,6 +204,9 @@ enum KVM_RISCV_SBI_EXT_ID {
>  #define KVM_REG_RISCV_SBI_MULTI_REG_LAST       \
>                 KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
>
> +/* One single KVM irqchip, ie. the AIA */
> +#define KVM_NR_IRQCHIPS                        1
> +
>  #endif
>
>  #endif /* __LINUX_KVM_RISCV_H */
> diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
> index 28891e583259..dfc237d7875b 100644
> --- a/arch/riscv/kvm/Kconfig
> +++ b/arch/riscv/kvm/Kconfig
> @@ -21,6 +21,10 @@ config KVM
>         tristate "Kernel-based Virtual Machine (KVM) support (EXPERIMENTA=
L)"
>         depends on RISCV_SBI && MMU
>         select HAVE_KVM_EVENTFD
> +       select HAVE_KVM_IRQCHIP
> +       select HAVE_KVM_IRQFD
> +       select HAVE_KVM_IRQ_ROUTING
> +       select HAVE_KVM_MSI
>         select HAVE_KVM_VCPU_ASYNC_IOCTL
>         select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>         select KVM_GENERIC_HARDWARE_ENABLING
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index 3f97575707eb..18c442c15ff2 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -26,6 +26,7 @@ static DEFINE_PER_CPU(struct aia_hgei_control, aia_hgei=
);
>  static int hgei_parent_irq;
>
>  unsigned int kvm_riscv_aia_nr_hgei;
> +unsigned int kvm_riscv_aia_max_ids;
>  DEFINE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
>
>  static int aia_find_hgei(struct kvm_vcpu *owner)
> @@ -618,6 +619,13 @@ int kvm_riscv_aia_init(void)
>          */
>         kvm_riscv_aia_nr_hgei =3D 0;
>
> +       /*
> +        * Find number of guest MSI IDs
> +        *
> +        * TODO: To be updated later by AIA IMSIC HW guest file support
> +        */
> +       kvm_riscv_aia_max_ids =3D IMSIC_MAX_ID;
> +
>         /* Initialize guest external interrupt line management */
>         rc =3D aia_hgei_init();
>         if (rc)
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index 6ef15f78e80f..d2349326b2ce 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -55,6 +55,121 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>         kvm_riscv_aia_destroy_vm(kvm);
>  }
>
> +int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irql,
> +                         bool line_status)
> +{
> +       if (!irqchip_in_kernel(kvm))
> +               return -ENXIO;
> +
> +       return kvm_riscv_aia_inject_irq(kvm, irql->irq, irql->level);
> +}
> +
> +int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> +               struct kvm *kvm, int irq_source_id,
> +               int level, bool line_status)
> +{
> +       struct kvm_msi msi;
> +
> +       if (!level)
> +               return -1;
> +
> +       msi.address_lo =3D e->msi.address_lo;
> +       msi.address_hi =3D e->msi.address_hi;
> +       msi.data =3D e->msi.data;
> +       msi.flags =3D e->msi.flags;
> +       msi.devid =3D e->msi.devid;
> +
> +       return kvm_riscv_aia_inject_msi(kvm, &msi);
> +}
> +
> +static int kvm_riscv_set_irq(struct kvm_kernel_irq_routing_entry *e,
> +                            struct kvm *kvm, int irq_source_id,
> +                            int level, bool line_status)
> +{
> +       return kvm_riscv_aia_inject_irq(kvm, e->irqchip.pin, level);
> +}
> +
> +int kvm_riscv_setup_default_irq_routing(struct kvm *kvm, u32 lines)
> +{
> +       struct kvm_irq_routing_entry *ents;
> +       int i, rc;
> +
> +       ents =3D kcalloc(lines, sizeof(*ents), GFP_KERNEL);
> +       if (!ents)
> +               return -ENOMEM;
> +
> +       for (i =3D 0; i < lines; i++) {
> +               ents[i].gsi =3D i;
> +               ents[i].type =3D KVM_IRQ_ROUTING_IRQCHIP;
> +               ents[i].u.irqchip.irqchip =3D 0;
> +               ents[i].u.irqchip.pin =3D i;
> +       }
> +       rc =3D kvm_set_irq_routing(kvm, ents, lines, 0);
> +       kfree(ents);
> +
> +       return rc;
> +}
> +
> +bool kvm_arch_can_set_irq_routing(struct kvm *kvm)
> +{
> +       return irqchip_in_kernel(kvm);
> +}
> +
> +int kvm_set_routing_entry(struct kvm *kvm,
> +                         struct kvm_kernel_irq_routing_entry *e,
> +                         const struct kvm_irq_routing_entry *ue)
> +{
> +       int r =3D -EINVAL;
> +
> +       switch (ue->type) {
> +       case KVM_IRQ_ROUTING_IRQCHIP:
> +               e->set =3D kvm_riscv_set_irq;
> +               e->irqchip.irqchip =3D ue->u.irqchip.irqchip;
> +               e->irqchip.pin =3D ue->u.irqchip.pin;
> +               if ((e->irqchip.pin >=3D KVM_IRQCHIP_NUM_PINS) ||
> +                   (e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS))
> +                       goto out;
> +               break;
> +       case KVM_IRQ_ROUTING_MSI:
> +               e->set =3D kvm_set_msi;
> +               e->msi.address_lo =3D ue->u.msi.address_lo;
> +               e->msi.address_hi =3D ue->u.msi.address_hi;
> +               e->msi.data =3D ue->u.msi.data;
> +               e->msi.flags =3D ue->flags;
> +               e->msi.devid =3D ue->u.msi.devid;
> +               break;
> +       default:
> +               goto out;
> +       }
> +       r =3D 0;
> +out:
> +       return r;
> +}
> +
> +int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
> +                             struct kvm *kvm, int irq_source_id, int lev=
el,
> +                             bool line_status)
> +{
> +       if (!level)
> +               return -EWOULDBLOCK;
> +
> +       switch (e->type) {
> +       case KVM_IRQ_ROUTING_MSI:
> +               return kvm_set_msi(e, kvm, irq_source_id, level, line_sta=
tus);
> +
> +       case KVM_IRQ_ROUTING_IRQCHIP:
> +               return kvm_riscv_set_irq(e, kvm, irq_source_id,
> +                                        level, line_status);
> +       }
> +
> +       return -EWOULDBLOCK;
> +}
> +
> +bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
> +{
> +       return irqchip_in_kernel(kvm);
> +}
> +
>  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  {
>         int r;
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

--=20
Regards,
Atish
