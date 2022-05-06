Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A531451D1A4
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 08:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386459AbiEFGxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 02:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239392AbiEFGxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 02:53:08 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0251466C90
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 23:49:26 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id w17so11307045ybh.9
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 23:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=weHGg5UCU8E3S0rXn0FmJqBvYZnpJng/4vwpZ6z6tgw=;
        b=V1BclOkuFKbUOjIDISvHG3QiN40ycpMYleJAtaCckYJH2XbP0BwjaY0vwYLMnehqk2
         dXXtMGHoy/FzIxANpNLeScoWO8oUW2zezQM8VdAi+9JJmqq3GGA652292/eqBDaH6gb2
         JgdLQCxw72KbtOKi8iAd/Md9KyaLi8AhNceWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=weHGg5UCU8E3S0rXn0FmJqBvYZnpJng/4vwpZ6z6tgw=;
        b=nGPsjIZp1l7z5kXb6A7J42cLhd1vhvwtxJzoRPU4J3I5V+T+XRpfuPbjLcCHAms3CK
         NJjBL9hISHKGfz1BT2UI0RwGbXwUlJr5kx3+/FCjoZPMeBPI5nT1MDUoT9tSikjvB4t5
         okBCTft1z8f1DUPNW8oFDxBVzGYiF4skZdIa8Mrp63ntLt8x2jzbOb0TfYx4soQFd0/x
         p3GHkdikpubKPewBI/tapU2u5iFQQAp2yk7Hh+doNaxKQ8R3zJ5k/9U5PXIGrLJcu4Cq
         YrQMaI/rUTQomg6e1X+XQ/ki4qQ8dJUbC9EInvhwJPeWK/AWHpjDYqOI1uBQrpaP002x
         IEQQ==
X-Gm-Message-State: AOAM531Sjf2AMsli0XYA/1aiwy+wRwyzIZ6C6gCtHOjiAuUiwfe2zCjc
        aWyC/69XVw6H2+lSZ5jGBWRFFOAWo2P1ya8wXM38
X-Google-Smtp-Source: ABdhPJzWNfCWXn+zGDITWtxh8FfQCoFMhyExrdDlozXPFr8ol8Vo2gbl9KwQHNcX/9OmL2PV2PXLR7j4J6fnxCkitaY=
X-Received: by 2002:a25:9247:0:b0:645:ddd5:a182 with SMTP id
 e7-20020a259247000000b00645ddd5a182mr1246046ybo.289.1651819765188; Thu, 05
 May 2022 23:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220420112450.155624-1-apatel@ventanamicro.com> <20220420112450.155624-5-apatel@ventanamicro.com>
In-Reply-To: <20220420112450.155624-5-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Thu, 5 May 2022 23:49:14 -0700
Message-ID: <CAOnJCULvR3xwUY7LT1ALpnovujEM44aC2P4tcFDe0-18D=KENg@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] RISC-V: KVM: Introduce range based local HFENCE functions
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 4:25 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> Various  __kvm_riscv_hfence_xyz() functions implemented in the
> kvm/tlb.S are equivalent to corresponding HFENCE.GVMA instructions
> and we don't have range based local HFENCE functions.
>
> This patch provides complete set of local HFENCE functions which
> supports range based TLB invalidation and supports HFENCE.VVMA
> based functions. This is also a preparatory patch for upcoming
> Svinval support in KVM RISC-V.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |  25 +++-
>  arch/riscv/kvm/mmu.c              |   4 +-
>  arch/riscv/kvm/tlb.S              |  74 -----------
>  arch/riscv/kvm/tlb.c              | 213 ++++++++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu.c             |   2 +-
>  arch/riscv/kvm/vmid.c             |   2 +-
>  6 files changed, 237 insertions(+), 83 deletions(-)
>  delete mode 100644 arch/riscv/kvm/tlb.S
>  create mode 100644 arch/riscv/kvm/tlb.c
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 3e2cbbd7d1c9..806f74dc0bfc 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -204,11 +204,26 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
>
> -void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long gpa_divby_4,
> -                                     unsigned long vmid);
> -void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
> -void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa_divby_4);
> -void __kvm_riscv_hfence_gvma_all(void);
> +#define KVM_RISCV_GSTAGE_TLB_MIN_ORDER         12
> +
> +void kvm_riscv_local_hfence_gvma_vmid_gpa(unsigned long vmid,
> +                                         gpa_t gpa, gpa_t gpsz,
> +                                         unsigned long order);
> +void kvm_riscv_local_hfence_gvma_vmid_all(unsigned long vmid);
> +void kvm_riscv_local_hfence_gvma_gpa(gpa_t gpa, gpa_t gpsz,
> +                                    unsigned long order);
> +void kvm_riscv_local_hfence_gvma_all(void);
> +void kvm_riscv_local_hfence_vvma_asid_gva(unsigned long vmid,
> +                                         unsigned long asid,
> +                                         unsigned long gva,
> +                                         unsigned long gvsz,
> +                                         unsigned long order);
> +void kvm_riscv_local_hfence_vvma_asid_all(unsigned long vmid,
> +                                         unsigned long asid);
> +void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
> +                                    unsigned long gva, unsigned long gvsz,
> +                                    unsigned long order);
> +void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
>
>  int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                          struct kvm_memory_slot *memslot,
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 8823eb32dcde..1e07603c905b 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -745,7 +745,7 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
>         csr_write(CSR_HGATP, hgatp);
>
>         if (!kvm_riscv_gstage_vmid_bits())
> -               __kvm_riscv_hfence_gvma_all();
> +               kvm_riscv_local_hfence_gvma_all();
>  }
>
>  void kvm_riscv_gstage_mode_detect(void)
> @@ -768,7 +768,7 @@ void kvm_riscv_gstage_mode_detect(void)
>  skip_sv48x4_test:
>
>         csr_write(CSR_HGATP, 0);
> -       __kvm_riscv_hfence_gvma_all();
> +       kvm_riscv_local_hfence_gvma_all();
>  #endif
>  }
>
> diff --git a/arch/riscv/kvm/tlb.S b/arch/riscv/kvm/tlb.S
> deleted file mode 100644
> index 899f75d60bad..000000000000
> --- a/arch/riscv/kvm/tlb.S
> +++ /dev/null
> @@ -1,74 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -/*
> - * Copyright (C) 2019 Western Digital Corporation or its affiliates.
> - *
> - * Authors:
> - *     Anup Patel <anup.patel@wdc.com>
> - */
> -
> -#include <linux/linkage.h>
> -#include <asm/asm.h>
> -
> -       .text
> -       .altmacro
> -       .option norelax
> -
> -       /*
> -        * Instruction encoding of hfence.gvma is:
> -        * HFENCE.GVMA rs1, rs2
> -        * HFENCE.GVMA zero, rs2
> -        * HFENCE.GVMA rs1
> -        * HFENCE.GVMA
> -        *
> -        * rs1!=zero and rs2!=zero ==> HFENCE.GVMA rs1, rs2
> -        * rs1==zero and rs2!=zero ==> HFENCE.GVMA zero, rs2
> -        * rs1!=zero and rs2==zero ==> HFENCE.GVMA rs1
> -        * rs1==zero and rs2==zero ==> HFENCE.GVMA
> -        *
> -        * Instruction encoding of HFENCE.GVMA is:
> -        * 0110001 rs2(5) rs1(5) 000 00000 1110011
> -        */
> -
> -ENTRY(__kvm_riscv_hfence_gvma_vmid_gpa)
> -       /*
> -        * rs1 = a0 (GPA >> 2)
> -        * rs2 = a1 (VMID)
> -        * HFENCE.GVMA a0, a1
> -        * 0110001 01011 01010 000 00000 1110011
> -        */
> -       .word 0x62b50073
> -       ret
> -ENDPROC(__kvm_riscv_hfence_gvma_vmid_gpa)
> -
> -ENTRY(__kvm_riscv_hfence_gvma_vmid)
> -       /*
> -        * rs1 = zero
> -        * rs2 = a0 (VMID)
> -        * HFENCE.GVMA zero, a0
> -        * 0110001 01010 00000 000 00000 1110011
> -        */
> -       .word 0x62a00073
> -       ret
> -ENDPROC(__kvm_riscv_hfence_gvma_vmid)
> -
> -ENTRY(__kvm_riscv_hfence_gvma_gpa)
> -       /*
> -        * rs1 = a0 (GPA >> 2)
> -        * rs2 = zero
> -        * HFENCE.GVMA a0
> -        * 0110001 00000 01010 000 00000 1110011
> -        */
> -       .word 0x62050073
> -       ret
> -ENDPROC(__kvm_riscv_hfence_gvma_gpa)
> -
> -ENTRY(__kvm_riscv_hfence_gvma_all)
> -       /*
> -        * rs1 = zero
> -        * rs2 = zero
> -        * HFENCE.GVMA
> -        * 0110001 00000 00000 000 00000 1110011
> -        */
> -       .word 0x62000073
> -       ret
> -ENDPROC(__kvm_riscv_hfence_gvma_all)
> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> new file mode 100644
> index 000000000000..e2d4fd610745
> --- /dev/null
> +++ b/arch/riscv/kvm/tlb.c
> @@ -0,0 +1,213 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2022 Ventana Micro Systems Inc.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/kvm_host.h>
> +#include <asm/csr.h>
> +
> +/*
> + * Instruction encoding of hfence.gvma is:
> + * HFENCE.GVMA rs1, rs2
> + * HFENCE.GVMA zero, rs2
> + * HFENCE.GVMA rs1
> + * HFENCE.GVMA
> + *
> + * rs1!=zero and rs2!=zero ==> HFENCE.GVMA rs1, rs2
> + * rs1==zero and rs2!=zero ==> HFENCE.GVMA zero, rs2
> + * rs1!=zero and rs2==zero ==> HFENCE.GVMA rs1
> + * rs1==zero and rs2==zero ==> HFENCE.GVMA
> + *
> + * Instruction encoding of HFENCE.GVMA is:
> + * 0110001 rs2(5) rs1(5) 000 00000 1110011
> + */
> +
> +void kvm_riscv_local_hfence_gvma_vmid_gpa(unsigned long vmid,
> +                                         gpa_t gpa, gpa_t gpsz,
> +                                         unsigned long order)
> +{
> +       gpa_t pos;
> +
> +       if (PTRS_PER_PTE < (gpsz >> order)) {
> +               kvm_riscv_local_hfence_gvma_vmid_all(vmid);
> +               return;
> +       }
> +
> +       for (pos = gpa; pos < (gpa + gpsz); pos += BIT(order)) {
> +               /*
> +                * rs1 = a0 (GPA >> 2)
> +                * rs2 = a1 (VMID)
> +                * HFENCE.GVMA a0, a1
> +                * 0110001 01011 01010 000 00000 1110011
> +                */
> +               asm volatile ("srli a0, %0, 2\n"
> +                             "add a1, %1, zero\n"
> +                             ".word 0x62b50073\n"
> +                             :: "r" (pos), "r" (vmid)
> +                             : "a0", "a1", "memory");
> +       }
> +}
> +
> +void kvm_riscv_local_hfence_gvma_vmid_all(unsigned long vmid)
> +{
> +       /*
> +        * rs1 = zero
> +        * rs2 = a0 (VMID)
> +        * HFENCE.GVMA zero, a0
> +        * 0110001 01010 00000 000 00000 1110011
> +        */
> +       asm volatile ("add a0, %0, zero\n"
> +                     ".word 0x62a00073\n"
> +                     :: "r" (vmid) : "a0", "memory");
> +}
> +
> +void kvm_riscv_local_hfence_gvma_gpa(gpa_t gpa, gpa_t gpsz,
> +                                    unsigned long order)
> +{
> +       gpa_t pos;
> +
> +       if (PTRS_PER_PTE < (gpsz >> order)) {
> +               kvm_riscv_local_hfence_gvma_all();
> +               return;
> +       }
> +
> +       for (pos = gpa; pos < (gpa + gpsz); pos += BIT(order)) {
> +               /*
> +                * rs1 = a0 (GPA >> 2)
> +                * rs2 = zero
> +                * HFENCE.GVMA a0
> +                * 0110001 00000 01010 000 00000 1110011
> +                */
> +               asm volatile ("srli a0, %0, 2\n"
> +                             ".word 0x62050073\n"
> +                             :: "r" (pos) : "a0", "memory");
> +       }
> +}
> +
> +void kvm_riscv_local_hfence_gvma_all(void)
> +{
> +       /*
> +        * rs1 = zero
> +        * rs2 = zero
> +        * HFENCE.GVMA
> +        * 0110001 00000 00000 000 00000 1110011
> +        */
> +       asm volatile (".word 0x62000073" ::: "memory");
> +}
> +
> +/*
> + * Instruction encoding of hfence.gvma is:
> + * HFENCE.VVMA rs1, rs2
> + * HFENCE.VVMA zero, rs2
> + * HFENCE.VVMA rs1
> + * HFENCE.VVMA
> + *
> + * rs1!=zero and rs2!=zero ==> HFENCE.VVMA rs1, rs2
> + * rs1==zero and rs2!=zero ==> HFENCE.VVMA zero, rs2
> + * rs1!=zero and rs2==zero ==> HFENCE.VVMA rs1
> + * rs1==zero and rs2==zero ==> HFENCE.VVMA
> + *
> + * Instruction encoding of HFENCE.VVMA is:
> + * 0010001 rs2(5) rs1(5) 000 00000 1110011
> + */
> +
> +void kvm_riscv_local_hfence_vvma_asid_gva(unsigned long vmid,
> +                                         unsigned long asid,
> +                                         unsigned long gva,
> +                                         unsigned long gvsz,
> +                                         unsigned long order)
> +{
> +       unsigned long pos, hgatp;
> +
> +       if (PTRS_PER_PTE < (gvsz >> order)) {
> +               kvm_riscv_local_hfence_vvma_asid_all(vmid, asid);
> +               return;
> +       }
> +
> +       hgatp = csr_swap(CSR_HGATP, vmid << HGATP_VMID_SHIFT);
> +
> +       for (pos = gva; pos < (gva + gvsz); pos += BIT(order)) {
> +               /*
> +                * rs1 = a0 (GVA)
> +                * rs2 = a1 (ASID)
> +                * HFENCE.VVMA a0, a1
> +                * 0010001 01011 01010 000 00000 1110011
> +                */
> +               asm volatile ("add a0, %0, zero\n"
> +                             "add a1, %1, zero\n"
> +                             ".word 0x22b50073\n"
> +                             :: "r" (pos), "r" (asid)
> +                             : "a0", "a1", "memory");
> +       }
> +
> +       csr_write(CSR_HGATP, hgatp);
> +}
> +
> +void kvm_riscv_local_hfence_vvma_asid_all(unsigned long vmid,
> +                                         unsigned long asid)
> +{
> +       unsigned long hgatp;
> +
> +       hgatp = csr_swap(CSR_HGATP, vmid << HGATP_VMID_SHIFT);
> +
> +       /*
> +        * rs1 = zero
> +        * rs2 = a0 (ASID)
> +        * HFENCE.VVMA zero, a0
> +        * 0010001 01010 00000 000 00000 1110011
> +        */
> +       asm volatile ("add a0, %0, zero\n"
> +                     ".word 0x22a00073\n"
> +                     :: "r" (asid) : "a0", "memory");
> +
> +       csr_write(CSR_HGATP, hgatp);
> +}
> +
> +void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
> +                                    unsigned long gva, unsigned long gvsz,
> +                                    unsigned long order)
> +{
> +       unsigned long pos, hgatp;
> +
> +       if (PTRS_PER_PTE < (gvsz >> order)) {
> +               kvm_riscv_local_hfence_vvma_all(vmid);
> +               return;
> +       }
> +
> +       hgatp = csr_swap(CSR_HGATP, vmid << HGATP_VMID_SHIFT);
> +
> +       for (pos = gva; pos < (gva + gvsz); pos += BIT(order)) {
> +               /*
> +                * rs1 = a0 (GVA)
> +                * rs2 = zero
> +                * HFENCE.VVMA a0
> +                * 0010001 00000 01010 000 00000 1110011
> +                */
> +               asm volatile ("add a0, %0, zero\n"
> +                             ".word 0x22050073\n"
> +                             :: "r" (pos) : "a0", "memory");
> +       }
> +
> +       csr_write(CSR_HGATP, hgatp);
> +}
> +
> +void kvm_riscv_local_hfence_vvma_all(unsigned long vmid)
> +{
> +       unsigned long hgatp;
> +
> +       hgatp = csr_swap(CSR_HGATP, vmid << HGATP_VMID_SHIFT);
> +
> +       /*
> +        * rs1 = zero
> +        * rs2 = zero
> +        * HFENCE.VVMA
> +        * 0010001 00000 00000 000 00000 1110011
> +        */
> +       asm volatile (".word 0x22000073" ::: "memory");
> +
> +       csr_write(CSR_HGATP, hgatp);
> +}
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index e87af6480dfd..2b7e27bc946c 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -693,7 +693,7 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
>                         kvm_riscv_gstage_update_hgatp(vcpu);
>
>                 if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
> -                       __kvm_riscv_hfence_gvma_all();
> +                       kvm_riscv_local_hfence_gvma_all();
>         }
>  }
>
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 01fdc342ad76..8987e76aa6db 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -33,7 +33,7 @@ void kvm_riscv_gstage_vmid_detect(void)
>         csr_write(CSR_HGATP, old);
>
>         /* We polluted local TLB so flush all guest TLB */
> -       __kvm_riscv_hfence_gvma_all();
> +       kvm_riscv_local_hfence_gvma_all();
>
>         /* We don't use VMID bits if they are not sufficient */
>         if ((1UL << vmid_bits) < num_possible_cpus())
> --
> 2.25.1
>

LGTM.
Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
