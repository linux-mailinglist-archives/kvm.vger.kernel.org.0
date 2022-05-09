Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968B051F3E3
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 07:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiEIFhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 01:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiEIFhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 01:37:06 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB23211C087
        for <kvm@vger.kernel.org>; Sun,  8 May 2022 22:33:13 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v12so17769392wrv.10
        for <kvm@vger.kernel.org>; Sun, 08 May 2022 22:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SkPXW5lmSPh+NG4K64ixR14A+DlDrzDvKKkG5o320k0=;
        b=Pf1M9OhgBbwJMqNbuTEridBSW5LGYES2Xf7s9BXrF2+fPx68dmxiInsTwN00b47kQR
         ef0FJjci3GJxJkwDqeVO9Ed8u6dW9ly9IVM75+obFjx5rOQKPByXiFyt8p1mQhnvxAyA
         6u/lVKB+xFi4ykAX9DPMaNd0T4xQhm2/HkMcmWkBX8F5zCz95AEw4IwM5+cJnVmM7KJP
         ji5nJpQk8+EB0jESKEk3C/jSryY0jXk+3YbXcqXqw/iz+QJbt9PYSnwaGdRfnkTdUpVs
         deda5kMOD5YlY9UosVWDJKgDnbUMKITLON5Bdspb2hlBo64Jj0xcFHi1n1MELFerIBjI
         UkRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SkPXW5lmSPh+NG4K64ixR14A+DlDrzDvKKkG5o320k0=;
        b=FpLI/fBRqRqmbJ7A111avRozVECTh+prS93v5EuxqWxIoGpywUZf8JZRTncTU4Lay8
         2r6bbkBdILwyi2EzflSGDjGFzi5XbLBB2UkG0RrWh9EZVMiPEh2QEWGu/LsxkaMR0G5F
         zwt4/NLMBFH9yEwHQzBgJrRGDm7MA7XsXzH3pP7738juDA17pAbfCwtmm0AuPQ7wmvs5
         2Jjz0FKDb2Sx4wd7fA77nHAl+NX6FnQqIyYIEqCuarhSoF9AWdNEOGduRs4zmmZ82rla
         Q1VD9qcNku2LuWmXGRJRtWNALgv2unWzoMXN57r48ATcWitn8W7xTRALpg9t1J8+C4KK
         pPUA==
X-Gm-Message-State: AOAM531pjTIYg3ZUUqZ80EVL9g4StqAEm0wiHEuHm2jhSUt3d2k9imJO
        G78mPfBSKE+EU3n14IERb5fRiWB1LMtuLLMnikgnng==
X-Google-Smtp-Source: ABdhPJwu3jLvRcue6gSlHh3sU49e3LqIGASkxeczmSKM/Th9MiiERIe7vJcvHWig2AgHYp05KI3ZmQHjm2fj7qKSGys=
X-Received: by 2002:a5d:6483:0:b0:20c:5c21:5c8c with SMTP id
 o3-20020a5d6483000000b0020c5c215c8cmr12310033wri.86.1652074392064; Sun, 08
 May 2022 22:33:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220420112450.155624-1-apatel@ventanamicro.com>
 <20220420112450.155624-5-apatel@ventanamicro.com> <CAOnJCULvR3xwUY7LT1ALpnovujEM44aC2P4tcFDe0-18D=KENg@mail.gmail.com>
In-Reply-To: <CAOnJCULvR3xwUY7LT1ALpnovujEM44aC2P4tcFDe0-18D=KENg@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 9 May 2022 11:03:00 +0530
Message-ID: <CAAhSdy3pkcDw7OH-bu5xRLriN9MsxSreie1sk7Vra2XNPWz3RQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] RISC-V: KVM: Introduce range based local HFENCE functions
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 6, 2022 at 12:19 PM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Wed, Apr 20, 2022 at 4:25 AM Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > Various  __kvm_riscv_hfence_xyz() functions implemented in the
> > kvm/tlb.S are equivalent to corresponding HFENCE.GVMA instructions
> > and we don't have range based local HFENCE functions.
> >
> > This patch provides complete set of local HFENCE functions which
> > supports range based TLB invalidation and supports HFENCE.VVMA
> > based functions. This is also a preparatory patch for upcoming
> > Svinval support in KVM RISC-V.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/kvm_host.h |  25 +++-
> >  arch/riscv/kvm/mmu.c              |   4 +-
> >  arch/riscv/kvm/tlb.S              |  74 -----------
> >  arch/riscv/kvm/tlb.c              | 213 ++++++++++++++++++++++++++++++
> >  arch/riscv/kvm/vcpu.c             |   2 +-
> >  arch/riscv/kvm/vmid.c             |   2 +-
> >  6 files changed, 237 insertions(+), 83 deletions(-)
> >  delete mode 100644 arch/riscv/kvm/tlb.S
> >  create mode 100644 arch/riscv/kvm/tlb.c
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > index 3e2cbbd7d1c9..806f74dc0bfc 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -204,11 +204,26 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> >
> >  #define KVM_ARCH_WANT_MMU_NOTIFIER
> >
> > -void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long gpa_divby_4,
> > -                                     unsigned long vmid);
> > -void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
> > -void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa_divby_4);
> > -void __kvm_riscv_hfence_gvma_all(void);
> > +#define KVM_RISCV_GSTAGE_TLB_MIN_ORDER         12
> > +
> > +void kvm_riscv_local_hfence_gvma_vmid_gpa(unsigned long vmid,
> > +                                         gpa_t gpa, gpa_t gpsz,
> > +                                         unsigned long order);
> > +void kvm_riscv_local_hfence_gvma_vmid_all(unsigned long vmid);
> > +void kvm_riscv_local_hfence_gvma_gpa(gpa_t gpa, gpa_t gpsz,
> > +                                    unsigned long order);
> > +void kvm_riscv_local_hfence_gvma_all(void);
> > +void kvm_riscv_local_hfence_vvma_asid_gva(unsigned long vmid,
> > +                                         unsigned long asid,
> > +                                         unsigned long gva,
> > +                                         unsigned long gvsz,
> > +                                         unsigned long order);
> > +void kvm_riscv_local_hfence_vvma_asid_all(unsigned long vmid,
> > +                                         unsigned long asid);
> > +void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
> > +                                    unsigned long gva, unsigned long gvsz,
> > +                                    unsigned long order);
> > +void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
> >
> >  int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
> >                          struct kvm_memory_slot *memslot,
> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > index 8823eb32dcde..1e07603c905b 100644
> > --- a/arch/riscv/kvm/mmu.c
> > +++ b/arch/riscv/kvm/mmu.c
> > @@ -745,7 +745,7 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
> >         csr_write(CSR_HGATP, hgatp);
> >
> >         if (!kvm_riscv_gstage_vmid_bits())
> > -               __kvm_riscv_hfence_gvma_all();
> > +               kvm_riscv_local_hfence_gvma_all();
> >  }
> >
> >  void kvm_riscv_gstage_mode_detect(void)
> > @@ -768,7 +768,7 @@ void kvm_riscv_gstage_mode_detect(void)
> >  skip_sv48x4_test:
> >
> >         csr_write(CSR_HGATP, 0);
> > -       __kvm_riscv_hfence_gvma_all();
> > +       kvm_riscv_local_hfence_gvma_all();
> >  #endif
> >  }
> >
> > diff --git a/arch/riscv/kvm/tlb.S b/arch/riscv/kvm/tlb.S
> > deleted file mode 100644
> > index 899f75d60bad..000000000000
> > --- a/arch/riscv/kvm/tlb.S
> > +++ /dev/null
> > @@ -1,74 +0,0 @@
> > -/* SPDX-License-Identifier: GPL-2.0 */
> > -/*
> > - * Copyright (C) 2019 Western Digital Corporation or its affiliates.
> > - *
> > - * Authors:
> > - *     Anup Patel <anup.patel@wdc.com>
> > - */
> > -
> > -#include <linux/linkage.h>
> > -#include <asm/asm.h>
> > -
> > -       .text
> > -       .altmacro
> > -       .option norelax
> > -
> > -       /*
> > -        * Instruction encoding of hfence.gvma is:
> > -        * HFENCE.GVMA rs1, rs2
> > -        * HFENCE.GVMA zero, rs2
> > -        * HFENCE.GVMA rs1
> > -        * HFENCE.GVMA
> > -        *
> > -        * rs1!=zero and rs2!=zero ==> HFENCE.GVMA rs1, rs2
> > -        * rs1==zero and rs2!=zero ==> HFENCE.GVMA zero, rs2
> > -        * rs1!=zero and rs2==zero ==> HFENCE.GVMA rs1
> > -        * rs1==zero and rs2==zero ==> HFENCE.GVMA
> > -        *
> > -        * Instruction encoding of HFENCE.GVMA is:
> > -        * 0110001 rs2(5) rs1(5) 000 00000 1110011
> > -        */
> > -
> > -ENTRY(__kvm_riscv_hfence_gvma_vmid_gpa)
> > -       /*
> > -        * rs1 = a0 (GPA >> 2)
> > -        * rs2 = a1 (VMID)
> > -        * HFENCE.GVMA a0, a1
> > -        * 0110001 01011 01010 000 00000 1110011
> > -        */
> > -       .word 0x62b50073
> > -       ret
> > -ENDPROC(__kvm_riscv_hfence_gvma_vmid_gpa)
> > -
> > -ENTRY(__kvm_riscv_hfence_gvma_vmid)
> > -       /*
> > -        * rs1 = zero
> > -        * rs2 = a0 (VMID)
> > -        * HFENCE.GVMA zero, a0
> > -        * 0110001 01010 00000 000 00000 1110011
> > -        */
> > -       .word 0x62a00073
> > -       ret
> > -ENDPROC(__kvm_riscv_hfence_gvma_vmid)
> > -
> > -ENTRY(__kvm_riscv_hfence_gvma_gpa)
> > -       /*
> > -        * rs1 = a0 (GPA >> 2)
> > -        * rs2 = zero
> > -        * HFENCE.GVMA a0
> > -        * 0110001 00000 01010 000 00000 1110011
> > -        */
> > -       .word 0x62050073
> > -       ret
> > -ENDPROC(__kvm_riscv_hfence_gvma_gpa)
> > -
> > -ENTRY(__kvm_riscv_hfence_gvma_all)
> > -       /*
> > -        * rs1 = zero
> > -        * rs2 = zero
> > -        * HFENCE.GVMA
> > -        * 0110001 00000 00000 000 00000 1110011
> > -        */
> > -       .word 0x62000073
> > -       ret
> > -ENDPROC(__kvm_riscv_hfence_gvma_all)
> > diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> > new file mode 100644
> > index 000000000000..e2d4fd610745
> > --- /dev/null
> > +++ b/arch/riscv/kvm/tlb.c
> > @@ -0,0 +1,213 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2022 Ventana Micro Systems Inc.
> > + */
> > +
> > +#include <linux/bitops.h>
> > +#include <linux/errno.h>
> > +#include <linux/err.h>
> > +#include <linux/module.h>
> > +#include <linux/kvm_host.h>
> > +#include <asm/csr.h>
> > +
> > +/*
> > + * Instruction encoding of hfence.gvma is:
> > + * HFENCE.GVMA rs1, rs2
> > + * HFENCE.GVMA zero, rs2
> > + * HFENCE.GVMA rs1
> > + * HFENCE.GVMA
> > + *
> > + * rs1!=zero and rs2!=zero ==> HFENCE.GVMA rs1, rs2
> > + * rs1==zero and rs2!=zero ==> HFENCE.GVMA zero, rs2
> > + * rs1!=zero and rs2==zero ==> HFENCE.GVMA rs1
> > + * rs1==zero and rs2==zero ==> HFENCE.GVMA
> > + *
> > + * Instruction encoding of HFENCE.GVMA is:
> > + * 0110001 rs2(5) rs1(5) 000 00000 1110011
> > + */
> > +
> > +void kvm_riscv_local_hfence_gvma_vmid_gpa(unsigned long vmid,
> > +                                         gpa_t gpa, gpa_t gpsz,
> > +                                         unsigned long order)
> > +{
> > +       gpa_t pos;
> > +
> > +       if (PTRS_PER_PTE < (gpsz >> order)) {
> > +               kvm_riscv_local_hfence_gvma_vmid_all(vmid);
> > +               return;
> > +       }
> > +
> > +       for (pos = gpa; pos < (gpa + gpsz); pos += BIT(order)) {
> > +               /*
> > +                * rs1 = a0 (GPA >> 2)
> > +                * rs2 = a1 (VMID)
> > +                * HFENCE.GVMA a0, a1
> > +                * 0110001 01011 01010 000 00000 1110011
> > +                */
> > +               asm volatile ("srli a0, %0, 2\n"
> > +                             "add a1, %1, zero\n"
> > +                             ".word 0x62b50073\n"
> > +                             :: "r" (pos), "r" (vmid)
> > +                             : "a0", "a1", "memory");
> > +       }
> > +}
> > +
> > +void kvm_riscv_local_hfence_gvma_vmid_all(unsigned long vmid)
> > +{
> > +       /*
> > +        * rs1 = zero
> > +        * rs2 = a0 (VMID)
> > +        * HFENCE.GVMA zero, a0
> > +        * 0110001 01010 00000 000 00000 1110011
> > +        */
> > +       asm volatile ("add a0, %0, zero\n"
> > +                     ".word 0x62a00073\n"
> > +                     :: "r" (vmid) : "a0", "memory");
> > +}
> > +
> > +void kvm_riscv_local_hfence_gvma_gpa(gpa_t gpa, gpa_t gpsz,
> > +                                    unsigned long order)
> > +{
> > +       gpa_t pos;
> > +
> > +       if (PTRS_PER_PTE < (gpsz >> order)) {
> > +               kvm_riscv_local_hfence_gvma_all();
> > +               return;
> > +       }
> > +
> > +       for (pos = gpa; pos < (gpa + gpsz); pos += BIT(order)) {
> > +               /*
> > +                * rs1 = a0 (GPA >> 2)
> > +                * rs2 = zero
> > +                * HFENCE.GVMA a0
> > +                * 0110001 00000 01010 000 00000 1110011
> > +                */
> > +               asm volatile ("srli a0, %0, 2\n"
> > +                             ".word 0x62050073\n"
> > +                             :: "r" (pos) : "a0", "memory");
> > +       }
> > +}
> > +
> > +void kvm_riscv_local_hfence_gvma_all(void)
> > +{
> > +       /*
> > +        * rs1 = zero
> > +        * rs2 = zero
> > +        * HFENCE.GVMA
> > +        * 0110001 00000 00000 000 00000 1110011
> > +        */
> > +       asm volatile (".word 0x62000073" ::: "memory");
> > +}
> > +
> > +/*
> > + * Instruction encoding of hfence.gvma is:
> > + * HFENCE.VVMA rs1, rs2
> > + * HFENCE.VVMA zero, rs2
> > + * HFENCE.VVMA rs1
> > + * HFENCE.VVMA
> > + *
> > + * rs1!=zero and rs2!=zero ==> HFENCE.VVMA rs1, rs2
> > + * rs1==zero and rs2!=zero ==> HFENCE.VVMA zero, rs2
> > + * rs1!=zero and rs2==zero ==> HFENCE.VVMA rs1
> > + * rs1==zero and rs2==zero ==> HFENCE.VVMA
> > + *
> > + * Instruction encoding of HFENCE.VVMA is:
> > + * 0010001 rs2(5) rs1(5) 000 00000 1110011
> > + */
> > +
> > +void kvm_riscv_local_hfence_vvma_asid_gva(unsigned long vmid,
> > +                                         unsigned long asid,
> > +                                         unsigned long gva,
> > +                                         unsigned long gvsz,
> > +                                         unsigned long order)
> > +{
> > +       unsigned long pos, hgatp;
> > +
> > +       if (PTRS_PER_PTE < (gvsz >> order)) {
> > +               kvm_riscv_local_hfence_vvma_asid_all(vmid, asid);
> > +               return;
> > +       }
> > +
> > +       hgatp = csr_swap(CSR_HGATP, vmid << HGATP_VMID_SHIFT);
> > +
> > +       for (pos = gva; pos < (gva + gvsz); pos += BIT(order)) {
> > +               /*
> > +                * rs1 = a0 (GVA)
> > +                * rs2 = a1 (ASID)
> > +                * HFENCE.VVMA a0, a1
> > +                * 0010001 01011 01010 000 00000 1110011
> > +                */
> > +               asm volatile ("add a0, %0, zero\n"
> > +                             "add a1, %1, zero\n"
> > +                             ".word 0x22b50073\n"
> > +                             :: "r" (pos), "r" (asid)
> > +                             : "a0", "a1", "memory");
> > +       }
> > +
> > +       csr_write(CSR_HGATP, hgatp);
> > +}
> > +
> > +void kvm_riscv_local_hfence_vvma_asid_all(unsigned long vmid,
> > +                                         unsigned long asid)
> > +{
> > +       unsigned long hgatp;
> > +
> > +       hgatp = csr_swap(CSR_HGATP, vmid << HGATP_VMID_SHIFT);
> > +
> > +       /*
> > +        * rs1 = zero
> > +        * rs2 = a0 (ASID)
> > +        * HFENCE.VVMA zero, a0
> > +        * 0010001 01010 00000 000 00000 1110011
> > +        */
> > +       asm volatile ("add a0, %0, zero\n"
> > +                     ".word 0x22a00073\n"
> > +                     :: "r" (asid) : "a0", "memory");
> > +
> > +       csr_write(CSR_HGATP, hgatp);
> > +}
> > +
> > +void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
> > +                                    unsigned long gva, unsigned long gvsz,
> > +                                    unsigned long order)
> > +{
> > +       unsigned long pos, hgatp;
> > +
> > +       if (PTRS_PER_PTE < (gvsz >> order)) {
> > +               kvm_riscv_local_hfence_vvma_all(vmid);
> > +               return;
> > +       }
> > +
> > +       hgatp = csr_swap(CSR_HGATP, vmid << HGATP_VMID_SHIFT);
> > +
> > +       for (pos = gva; pos < (gva + gvsz); pos += BIT(order)) {
> > +               /*
> > +                * rs1 = a0 (GVA)
> > +                * rs2 = zero
> > +                * HFENCE.VVMA a0
> > +                * 0010001 00000 01010 000 00000 1110011
> > +                */
> > +               asm volatile ("add a0, %0, zero\n"
> > +                             ".word 0x22050073\n"
> > +                             :: "r" (pos) : "a0", "memory");
> > +       }
> > +
> > +       csr_write(CSR_HGATP, hgatp);
> > +}
> > +
> > +void kvm_riscv_local_hfence_vvma_all(unsigned long vmid)
> > +{
> > +       unsigned long hgatp;
> > +
> > +       hgatp = csr_swap(CSR_HGATP, vmid << HGATP_VMID_SHIFT);
> > +
> > +       /*
> > +        * rs1 = zero
> > +        * rs2 = zero
> > +        * HFENCE.VVMA
> > +        * 0010001 00000 00000 000 00000 1110011
> > +        */
> > +       asm volatile (".word 0x22000073" ::: "memory");
> > +
> > +       csr_write(CSR_HGATP, hgatp);
> > +}
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index e87af6480dfd..2b7e27bc946c 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -693,7 +693,7 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
> >                         kvm_riscv_gstage_update_hgatp(vcpu);
> >
> >                 if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
> > -                       __kvm_riscv_hfence_gvma_all();
> > +                       kvm_riscv_local_hfence_gvma_all();
> >         }
> >  }
> >
> > diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> > index 01fdc342ad76..8987e76aa6db 100644
> > --- a/arch/riscv/kvm/vmid.c
> > +++ b/arch/riscv/kvm/vmid.c
> > @@ -33,7 +33,7 @@ void kvm_riscv_gstage_vmid_detect(void)
> >         csr_write(CSR_HGATP, old);
> >
> >         /* We polluted local TLB so flush all guest TLB */
> > -       __kvm_riscv_hfence_gvma_all();
> > +       kvm_riscv_local_hfence_gvma_all();
> >
> >         /* We don't use VMID bits if they are not sufficient */
> >         if ((1UL << vmid_bits) < num_possible_cpus())
> > --
> > 2.25.1
> >
>
> LGTM.
> Reviewed-by: Atish Patra <atishp@rivosinc.com>

Queued this patch for 5.19

Thanks,
Anup

>
> --
> Regards,
> Atish
