Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709933ED913
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 16:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhHPOnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 10:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbhHPOlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 10:41:20 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907C1C0613CF
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 07:40:30 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id c19-20020a9d6153000000b0051829acbfc7so6280738otk.9
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 07:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QBcYcSqcdNcpIp2giaoF7M3Ly7AuyhnDB1Pw04D25Rw=;
        b=siFKAANECq1GHq97zm8ie+x5ZoX9TiIe0DwDt8e13HMWjP5FL4PZy0cmvRmfzUquzT
         FiRKccOuLrUW9mnW3oeVB6XsI4tfBVnLgnkDttv0hbnS4zxEGEfeY5lsdzL+0co1ClCy
         7iTH/3WunTo0TGoWeU0nusm6fUrawR1Me9Q8256fD4arYNTV0l3ayp+50pAMQZYg0moo
         n8SDVz+vCTrOXTZC0rc+ezn5AtCek2jQ6+LKoef/yLTMlyVTCaffHQ+B3UQBYJ0W0lGe
         ePibt3zHC040cjcGv7DFFEYpXpO2pi5eI+OSDz1D2vg7/grezP0MO/pwoPp3FCqp9VL9
         Jyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QBcYcSqcdNcpIp2giaoF7M3Ly7AuyhnDB1Pw04D25Rw=;
        b=k9T/hx9flRri1Op17fFfropbWSt7fGSt1vhwYnobl+OgXBJu2phxhFHZG3xuezH0js
         Sha4cCPzkOmr91mqo98fvXlIoEjMAgNQ2xLc6e69zcVT9C65N3VL0n6e4yAnSNzAXiLe
         KGNwiiqOYwvCkO3Q8eQdF0WUBQ1Mz7EFaoFuQtGBwNe2L1jTnfK5gvGXHOu0k2MqXHRj
         jbVnCw0/bbe29OjQBLBdIYWhO9n1NwVrEWEattU8D1TuwieXWBLbPcszIa+Y6BADNRWj
         TZTEMdM2b4qGJQ7vQuFdeIuUzz4XnO7eaYyC71OZv5Q0VTNoYWfe5VMGbuoqniQLuHzA
         DekQ==
X-Gm-Message-State: AOAM531HD1HWSwirTCfv8EO72X/Fq+VGVaC/hU+EdU3as4xBOyxBOppS
        1LU9bE5Y8qR6zf2gClRf+wix/j0/tgL9ngtnyfsVLA==
X-Google-Smtp-Source: ABdhPJy3Bum9MoBdjM5b7boLFdDpAOrm0jAW07RQsLLqy/vUEekhINyh4Wf0Iw9N6Q9OYiuqLOz2svi1UDj3ATf5xBE=
X-Received: by 2002:a05:6830:1095:: with SMTP id y21mr12303246oto.144.1629124829634;
 Mon, 16 Aug 2021 07:40:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com> <20210719160346.609914-12-tabba@google.com>
 <20210812094554.GH5912@willie-the-truck>
In-Reply-To: <20210812094554.GH5912@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 16 Aug 2021 16:39:53 +0200
Message-ID: <CA+EHjTz2warTOJLYfdOMjybg65WiUZ+v9UT7rvSPDEMR35Gy8Q@mail.gmail.com>
Subject: Re: [PATCH v3 11/15] KVM: arm64: Add trap handlers for protected VMs
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Thu, Aug 12, 2021 at 11:46 AM Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jul 19, 2021 at 05:03:42PM +0100, Fuad Tabba wrote:
> > Add trap handlers for protected VMs. These are mainly for Sys64
> > and debug traps.
> >
> > No functional change intended as these are not hooked in yet to
> > the guest exit handlers introduced earlier. So even when trapping
> > is triggered, the exit handlers would let the host handle it, as
> > before.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_fixed_config.h | 178 +++++++++
> >  arch/arm64/include/asm/kvm_host.h         |   2 +
> >  arch/arm64/include/asm/kvm_hyp.h          |   3 +
> >  arch/arm64/kvm/Makefile                   |   2 +-
> >  arch/arm64/kvm/arm.c                      |  11 +
> >  arch/arm64/kvm/hyp/nvhe/Makefile          |   2 +-
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c        | 443 ++++++++++++++++++++++
> >  arch/arm64/kvm/pkvm.c                     | 183 +++++++++
> >  8 files changed, 822 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/arm64/include/asm/kvm_fixed_config.h
> >  create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
> >  create mode 100644 arch/arm64/kvm/pkvm.c
> >
> > diff --git a/arch/arm64/include/asm/kvm_fixed_config.h b/arch/arm64/include/asm/kvm_fixed_config.h
> > new file mode 100644
> > index 000000000000..b39a5de2c4b9
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/kvm_fixed_config.h
> > @@ -0,0 +1,178 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Copyright (C) 2021 Google LLC
> > + * Author: Fuad Tabba <tabba@google.com>
> > + */
> > +
> > +#ifndef __ARM64_KVM_FIXED_CONFIG_H__
> > +#define __ARM64_KVM_FIXED_CONFIG_H__
> > +
> > +#include <asm/sysreg.h>
> > +
> > +/*
> > + * This file contains definitions for features to be allowed or restricted for
> > + * guest virtual machines as a baseline, depending on what mode KVM is running
> > + * in and on the type of guest is running.
>
> s/is running/that is running/

Ack.

> > + *
> > + * The features are represented as the highest allowed value for a feature in
> > + * the feature id registers. If the field is set to all ones (i.e., 0b1111),
> > + * then it's only restricted by what the system allows. If the feature is set to
> > + * another value, then that value would be the maximum value allowed and
> > + * supported in pKVM, even if the system supports a higher value.
>
> Given that some fields are signed whereas others are unsigned, I think the
> wording could be a bit tighter here when it refers to "maximum".
>
> > + *
> > + * Some features are forced to a certain value, in which case a SET bitmap is
> > + * used to force these values.
> > + */
> > +
> > +
> > +/*
> > + * Allowed features for protected guests (Protected KVM)
> > + *
> > + * The approach taken here is to allow features that are:
> > + * - needed by common Linux distributions (e.g., flooating point)
>
> s/flooating/floating
Ack.

> > + * - are trivial, e.g., supporting the feature doesn't introduce or require the
> > + * tracking of additional state
> ... in KVM.

Ack.

> > + * - not trapable
>
> s/not trapable/cannot be trapped/
Ack

> > + */
> > +
> > +/*
> > + * - Floating-point and Advanced SIMD:
> > + *   Don't require much support other than maintaining the context, which KVM
> > + *   already has.
>
> I'd rework this sentence. We have to support fpsimd because Linux guests
> rely on it.

Ack

> > + * - AArch64 guests only (no support for AArch32 guests):
> > + *   Simplify support in case of asymmetric AArch32 systems.
>
> I don't think asymmetric systems come into this really; AArch32 on its
> own adds lots of complexity in trap handling, emulation, condition codes
> etc. Restricting guests to AArch64 means we don't have to worry about the
> AArch32 exception model or emulation of 32-bit instructions.

Ack

> > + * - RAS (v1)
> > + *   v1 doesn't require much additional support, but later versions do.
>
> Be more specific?

Ack

> > + * - Data Independent Timing
> > + *   Trivial
> > + * Remaining features are not supported either because they require too much
> > + * support from KVM, or risk leaking guest data.
>
> I think we should drop this sentence -- it makes it sounds like we can't
> be arsed :)

Ack.

> > + */
> > +#define PVM_ID_AA64PFR0_ALLOW (\
> > +     FEATURE(ID_AA64PFR0_FP) | \
> > +     FIELD_PREP(FEATURE(ID_AA64PFR0_EL0), ID_AA64PFR0_ELx_64BIT_ONLY) | \
> > +     FIELD_PREP(FEATURE(ID_AA64PFR0_EL1), ID_AA64PFR0_ELx_64BIT_ONLY) | \
> > +     FIELD_PREP(FEATURE(ID_AA64PFR0_EL2), ID_AA64PFR0_ELx_64BIT_ONLY) | \
> > +     FIELD_PREP(FEATURE(ID_AA64PFR0_EL3), ID_AA64PFR0_ELx_64BIT_ONLY) | \
> > +     FIELD_PREP(FEATURE(ID_AA64PFR0_RAS), ID_AA64PFR0_RAS_V1) | \
>
> I think having the FIELD_PREP entries in the ALLOW mask is quite confusing
> here -- naively you would expect to be able to bitwise-and the host register
> value with the ALLOW mask and get the sanitised version back, but with these
> here you have to go field-by-field to compute the common value.
>
> So perhaps move those into a PVM_ID_AA64PFR0_RESTRICT mask or something?
> Then pvm_access_id_aa64pfr0() will become a little easier to read, I think.

I agree. I've reworked it, and it simplifies the code and makes it
easier to read.

> > +     FEATURE(ID_AA64PFR0_ASIMD) | \
> > +     FEATURE(ID_AA64PFR0_DIT) \
> > +     )
> > +
> > +/*
> > + * - Branch Target Identification
> > + * - Speculative Store Bypassing
> > + *   These features are trivial to support
> > + */
> > +#define PVM_ID_AA64PFR1_ALLOW (\
> > +     FEATURE(ID_AA64PFR1_BT) | \
> > +     FEATURE(ID_AA64PFR1_SSBS) \
> > +     )
> > +
> > +/*
> > + * No support for Scalable Vectors:
> > + *   Requires additional support from KVM
>
> Perhaps expand on "support" here? E.g. "context-switching and trapping
> support at EL2".

Ack.

> > + */
> > +#define PVM_ID_AA64ZFR0_ALLOW (0ULL)
> > +
> > +/*
> > + * No support for debug, including breakpoints, and watchpoints:
> > + *   Reduce complexity and avoid exposing/leaking guest data
> > + *
> > + * NOTE: The Arm architecture mandates support for at least the Armv8 debug
> > + * architecture, which would include at least 2 hardware breakpoints and
> > + * watchpoints. Providing that support to protected guests adds considerable
> > + * state and complexity, and risks leaking guest data. Therefore, the reserved
> > + * value of 0 is used for debug-related fields.
> > + */
>
> I think the complexity of the debug architecture is a good reason to avoid
> exposing it here, but I don't understand how providing breakpoints or
> watchpoints to a guest could risk leaking guest data. What is the specific
> threat here?

I mixed up the various debug and trace features here. Will fix the comment.

> > +#define PVM_ID_AA64DFR0_ALLOW (0ULL)
> > +
> > +/*
> > + * These features are chosen because they are supported by KVM and to limit the
> > + * confiruation state space and make it more deterministic.
>
> s/confiruation/configuration/
>
> However, I don't agree that this provides determinism since we're not
> forcing any particular values, but rather filtering the values from the
> host.

Ack

> > + * - 40-bit IPA
>
> This seems more about not supporting KVM_CAP_ARM_VM_IPA_SIZE for now.
>
> > + * - 16-bit ASID
> > + * - Mixed-endian
> > + * - Distinction between Secure and Non-secure Memory
> > + * - Mixed-endian at EL0 only
> > + * - Non-context synchronizing exception entry and exit
>
> These all seem to fall into the "cannot trap" category, so we just advertise
> whatever we've got.

Ack.


>
> > + */
> > +#define PVM_ID_AA64MMFR0_ALLOW (\
> > +     FIELD_PREP(FEATURE(ID_AA64MMFR0_PARANGE), ID_AA64MMFR0_PARANGE_40) | \
> > +     FIELD_PREP(FEATURE(ID_AA64MMFR0_ASID), ID_AA64MMFR0_ASID_16) | \
> > +     FEATURE(ID_AA64MMFR0_BIGENDEL) | \
> > +     FEATURE(ID_AA64MMFR0_SNSMEM) | \
> > +     FEATURE(ID_AA64MMFR0_BIGENDEL0) | \
> > +     FEATURE(ID_AA64MMFR0_EXS) \
> > +     )
> > +
> > +/*
> > + * - 64KB granule not supported
> > + */
> > +#define PVM_ID_AA64MMFR0_SET (\
> > +     FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN64), ID_AA64MMFR0_TGRAN64_NI) \
> > +     )
>
> Why not, and can we actually prevent the guest from doing that?

We cannot prevent the guest from doing it. Initial reasoning was that
there isn't a clear use case for it, but since we cannot prevent the
guest from doing that, I'll unhide it.

> > +/*
> > + * These features are chosen because they are supported by KVM and to limit the
> > + * confiruation state space and make it more deterministic.
>
> It's that typo again ;) But my comment from before still applies -- I don't
> think an ALLOW mask adds hugely to the determinism.

Ack

> > + * - Hardware translation table updates to Access flag and Dirty state
> > + * - Number of VMID bits from CPU
> > + * - Hierarchical Permission Disables
> > + * - Privileged Access Never
> > + * - SError interrupt exceptions from speculative reads
> > + * - Enhanced Translation Synchronization
>
> As before, I think this is a mixture of "trivial" and "cannot trap"
> features.

Ack

> > + */
> > +#define PVM_ID_AA64MMFR1_ALLOW (\
> > +     FEATURE(ID_AA64MMFR1_HADBS) | \
> > +     FEATURE(ID_AA64MMFR1_VMIDBITS) | \
> > +     FEATURE(ID_AA64MMFR1_HPD) | \
> > +     FEATURE(ID_AA64MMFR1_PAN) | \
> > +     FEATURE(ID_AA64MMFR1_SPECSEI) | \
> > +     FEATURE(ID_AA64MMFR1_ETS) \
> > +     )
> > +
> > +/*
> > + * These features are chosen because they are supported by KVM and to limit the
> > + * confiruation state space and make it more deterministic.
>
> <same comment>

Ack
> > + * - Common not Private translations
> > + * - User Access Override
> > + * - IESB bit in the SCTLR_ELx registers
> > + * - Unaligned single-copy atomicity and atomic functions
> > + * - ESR_ELx.EC value on an exception by read access to feature ID space
> > + * - TTL field in address operations.
> > + * - Break-before-make sequences when changing translation block size
> > + * - E0PDx mechanism
> > + */
> > +#define PVM_ID_AA64MMFR2_ALLOW (\
> > +     FEATURE(ID_AA64MMFR2_CNP) | \
> > +     FEATURE(ID_AA64MMFR2_UAO) | \
> > +     FEATURE(ID_AA64MMFR2_IESB) | \
> > +     FEATURE(ID_AA64MMFR2_AT) | \
> > +     FEATURE(ID_AA64MMFR2_IDS) | \
> > +     FEATURE(ID_AA64MMFR2_TTL) | \
> > +     FEATURE(ID_AA64MMFR2_BBM) | \
> > +     FEATURE(ID_AA64MMFR2_E0PD) \
> > +     )
> > +
> > +/*
> > + * Allow all features in this register because they are trivial to support, or
> > + * are already supported by KVM:
> > + * - LS64
> > + * - XS
> > + * - I8MM
> > + * - DGB
> > + * - BF16
> > + * - SPECRES
> > + * - SB
> > + * - FRINTTS
> > + * - PAuth
> > + * - FPAC
> > + * - LRCPC
> > + * - FCMA
> > + * - JSCVT
> > + * - DPB
> > + */
> > +#define PVM_ID_AA64ISAR1_ALLOW (~0ULL)
> > +
> > +#endif /* __ARM64_KVM_FIXED_CONFIG_H__ */
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index ac67d5699c68..e1ceadd69575 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -780,6 +780,8 @@ static inline bool kvm_vm_is_protected(struct kvm *kvm)
> >       return false;
> >  }
> >
> > +void kvm_init_protected_traps(struct kvm_vcpu *vcpu);
> > +
> >  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
> >  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
> >
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > index 657d0c94cf82..3f4866322f85 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -115,7 +115,10 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
> >  void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
> >  #endif
> >
> > +extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
> > +extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
> >  extern u64 kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val);
> >  extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
> > +extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
> >
> >  #endif /* __ARM64_KVM_HYP_H__ */
> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > index 989bb5dad2c8..0be63f5c495f 100644
> > --- a/arch/arm64/kvm/Makefile
> > +++ b/arch/arm64/kvm/Makefile
> > @@ -14,7 +14,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
> >        $(KVM)/vfio.o $(KVM)/irqchip.o $(KVM)/binary_stats.o \
> >        arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
> >        inject_fault.o va_layout.o handle_exit.o \
> > -      guest.o debug.o reset.o sys_regs.o \
> > +      guest.o debug.o pkvm.o reset.o sys_regs.o \
> >        vgic-sys-reg-v3.o fpsimd.o pmu.o \
> >        arch_timer.o trng.o\
> >        vgic/vgic.o vgic/vgic-init.o \
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 14b12f2c08c0..3f28549aff0d 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -618,6 +618,14 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> >
> >       ret = kvm_arm_pmu_v3_enable(vcpu);
> >
> > +     /*
> > +      * Initialize traps for protected VMs.
> > +      * NOTE: Move  trap initialization to EL2 once the code is in place for
> > +      * maintaining protected VM state at EL2 instead of the host.
> > +      */
> > +     if (kvm_vm_is_protected(kvm))
> > +             kvm_init_protected_traps(vcpu);
> > +
> >       return ret;
> >  }
> >
> > @@ -1781,8 +1789,11 @@ static int kvm_hyp_init_protection(u32 hyp_va_bits)
> >       void *addr = phys_to_virt(hyp_mem_base);
> >       int ret;
> >
> > +     kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > +     kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
> >       kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
> >       kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > +     kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
> >
> >       ret = create_hyp_mappings(addr, addr + hyp_mem_size, PAGE_HYP);
> >       if (ret)
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index 5df6193fc430..a23f417a0c20 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -14,7 +14,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
> >
> >  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
> >        hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
> > -      cache.o setup.o mm.o mem_protect.o
> > +      cache.o setup.o mm.o mem_protect.o sys_regs.o
> >  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
> >        ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
> >  obj-y += $(lib-objs)
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > new file mode 100644
> > index 000000000000..6c7230aa70e9
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -0,0 +1,443 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2021 Google LLC
> > + * Author: Fuad Tabba <tabba@google.com>
> > + */
> > +
> > +#include <linux/kvm_host.h>
> > +
> > +#include <asm/kvm_asm.h>
> > +#include <asm/kvm_emulate.h>
> > +#include <asm/kvm_fixed_config.h>
> > +#include <asm/kvm_mmu.h>
> > +
> > +#include <hyp/adjust_pc.h>
> > +
> > +#include "../../sys_regs.h"
> > +
> > +/*
> > + * Copies of the host's CPU features registers holding sanitized values.
> > + */
> > +u64 id_aa64pfr0_el1_sys_val;
> > +u64 id_aa64pfr1_el1_sys_val;
> > +u64 id_aa64mmfr2_el1_sys_val;
> > +
> > +/*
> > + * Inject an unknown/undefined exception to the guest.
> > + */
> > +static void inject_undef(struct kvm_vcpu *vcpu)
> > +{
> > +     u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
> > +
> > +     vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1 |
> > +                          KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
> > +                          KVM_ARM64_PENDING_EXCEPTION);
> > +
> > +     __kvm_adjust_pc(vcpu);
> > +
> > +     write_sysreg_el1(esr, SYS_ESR);
> > +     write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
> > +}
> > +
> > +/*
> > + * Accessor for undefined accesses.
> > + */
> > +static bool undef_access(struct kvm_vcpu *vcpu,
> > +                      struct sys_reg_params *p,
> > +                      const struct sys_reg_desc *r)
> > +{
> > +     inject_undef(vcpu);
> > +     return false;
> > +}
> > +
> > +/*
> > + * Accessors for feature registers.
> > + *
> > + * If access is allowed, set the regval to the protected VM's view of the
> > + * register and return true.
> > + * Otherwise, inject an undefined exception and return false.
> > + */
> > +
> > +/*
> > + * Returns the minimum feature supported and allowed.
> > + */
> > +static u64 get_min_feature(u64 feature, u64 allowed_features,
> > +                        u64 supported_features)
"> > +{
> > +     const u64 allowed_feature = FIELD_GET(feature, allowed_features);
> > +     const u64 supported_feature = FIELD_GET(feature, supported_features);
> > +
> > +     return min(allowed_feature, supported_feature);
>
> Careful here: this is an unsigned comparison, yet some fields are signed.
> cpufeature.c uses the S_ARM64_FTR_BITS and ARM64_FTR_BITS to declare signed
> and unsigned fields respectively.

I completely missed that! It's described in "D13.1.3 Principles of the
ID scheme for fields in ID registers" or the Arm Architecture
Reference Manual. Fortunately, all of the features I'm working with
are unsigned. However, I will fix it in v4 to ensure that should we
add a signed feature we can clearly see that it needs to be handled
differently.

Thanks!

/fuad

> Will
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
