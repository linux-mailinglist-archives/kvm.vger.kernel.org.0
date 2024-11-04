Return-Path: <kvm+bounces-30436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 625929BABF8
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 06:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83ABA1C2036F
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 05:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A58E18B499;
	Mon,  4 Nov 2024 05:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3lI4BH0Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FB0167296
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 05:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730696542; cv=none; b=NMrg7P00E65cqxYKBZVbknYE2uc6eSo0u84MsuZvU7VulHwx6XB0ZXErntGVKO9qSxpzt4PACwcVEmKI9vLMNi+gSUpYUhWJarJMH8pho+PaznkrpTjpxV++GJYSrgGZSbpnxfBzt46jzpz/JFtKX2+K/jTwd6qF3Pdlixok22Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730696542; c=relaxed/simple;
	bh=HAW046ESpGN8YWxoylIdPESdxozTuq5MgjTqE92R6gk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mcufk1EFvTq7roKxMFhSthj4Hg8+t8MsX2NoZoWmEe6mhFRbiD+NsbWmnkUsQVNID0zuQYY+5zeYE3+gsc68hx7gn5sKGE3IQRDHANKrUpKY44ihTf9Pc0YcWKE8Yqc9D98R6gCq+WQIK6wyOxqrTAAggtbTgnyq4ERBjNLNZlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3lI4BH0Z; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4315a8cff85so51505e9.0
        for <kvm@vger.kernel.org>; Sun, 03 Nov 2024 21:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730696538; x=1731301338; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EsI8QWv4e0MoWQOcIqSB3K6B/286Iaz+JHsS/rVhDho=;
        b=3lI4BH0ZrFoICH4AUR1pI1TpraGRsW44Wo6lZi2T3QYVdWsKHkGMTizuuFnrkCCQRS
         gTKX4ItibTmgsTyji9s17IAliY9ciWLqb/+xxsYh+21+RLw5UfWexS2suUdT3wuBJ8yu
         g+SxXltU+lvwyJXvYCCbLXzApKftxbpca3E/oGrzSLrWHKj4hbatVcE1VGYUs+6Ycwf9
         QxYq5LTImbGI5snt2ljdn8AWRbTjSw+jFu8BnOSXN3GOrql3JAhH6jT81PrBdMhbgscF
         ZzlnS/qNuA6A34GQ+vok35mq7T8kVwXApD87lNkEEigGOhQEQVzC+8tVH+fRJLptFM1h
         VaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730696538; x=1731301338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EsI8QWv4e0MoWQOcIqSB3K6B/286Iaz+JHsS/rVhDho=;
        b=ZbQCN41p8kms7rYalkbzOyOAHFeYgcqJrvHPIyE3NNdOTzuUSXCggp9uBDG26+Q18D
         jziO6b80DY8btjNYZ4tFvNJTangTaW47fFEzN9RyB1blcnArAvb+AGEcgdWUrQa86mrA
         fdWc++5jO3ZI7T2xztWF8ypMGLEjwcExlpr3PnHwzUBqhTrGwzdJikW21tLk/PVYgXfj
         5q/zftkcyB6b27Yorux0JKE8Xyh8KicQ9WSpY/yvcGB1xINO/KNLy2Lo3BAtveUsBKqk
         hWVNRXQuBqLwKjk1cbdGVZ9XMgIwypTN9GJTEuR6YcP3YHL8Tgk8kiLnGryTxex1+R11
         Mr/A==
X-Forwarded-Encrypted: i=1; AJvYcCWqTidbtB2dcFnQGPpJKulyBxl3LvZuB9dR4+axDIcaRqn4gga6M8JSwJ4s4LAuzZgsnqo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0dYOG7P0WTAcrRkXny+RvfgjFPskqTsPrIrGfk4VqV7DKCr8L
	U/zoOZv0jSNmv5Pnbss3EI5KCnq5TLYblAJhHRmJ8FgcBJYks0Y1U4AVfPV6U+dPpBF/dncjDzM
	/8c1ugokpB8b14X71i9SFPAGKcA5gu09kmnJn
X-Gm-Gg: ASbGncs+i1yKDWU+tqUh2/k3b/mf+TBE6CA+iXgbBsvdkarMGKmRzsLvB6Hf2pUtRfq
	0COI8Kn64K1F2sYyaPN2DsDKPD9kzELai/JfJdGpAX3Ng9HxeR9U2zeotiQU2cYc=
X-Google-Smtp-Source: AGHT+IEjRuwYNFSQ2YIxZvVeAEQHZ04rTPgHjYCyrGK55VxsW50YYmc9HWkP1YWdE3I5kimXvyb1o2IahKOaQPEcCvE=
X-Received: by 2002:a05:600c:63d9:b0:42b:8ff7:bee2 with SMTP id
 5b1f17b1804b1-4328dc076b0mr1470075e9.5.1730696537538; Sun, 03 Nov 2024
 21:02:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031212104.1429609-1-jiaqiyan@google.com> <86r07v1g2z.wl-maz@kernel.org>
In-Reply-To: <86r07v1g2z.wl-maz@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 3 Nov 2024 21:02:03 -0800
Message-ID: <CACw3F51FbzkkX_DcCVCieZ=408oP_Fy3sXYk5AjWRX3RJO2Fzg@mail.gmail.com>
Subject: Re: [RFC PATCH v1] KVM: arm64: Introduce KVM_CAP_ARM_SIGBUS_ON_SEA
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, duenwen@google.com, 
	rananta@google.com, James Houghton <jthoughton@google.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc, thanks for your quick response!

On Fri, Nov 1, 2024 at 6:54=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 31 Oct 2024 21:21:04 +0000,
> Jiaqi Yan <jiaqiyan@google.com> wrote:
> >
> > Currently KVM handles SEA in guest by injecting async SError into
> > guest directly, bypassing VMM, usually results in guest kernel panic.
> >
> > One major situation of guest SEA is when vCPU consumes uncorrectable
> > memory error on the physical memory. Although SError and guest kernel
> > panic effectively stops the propagation of corrupted memory, it is not
> > easy for VMM and guest to recover from memory error in a more graceful
> > manner.
> >
> > Alternatively KVM can send a SIGBUS BUS_OBJERR to VMM/vCPU, just like
> > how core kernel signals SIGBUS BUS_OBJERR to the poison consuming
> > thread.
>
> Can you elaborate on why the delivery of a signal is preferable to
> simply exiting back to userspace with a description of the error?
> Signals are usually not generated by KVM, and are a pretty twisted way
> to generate an exit.

A couple of reasons. First, my intuition is that KVM and core kernel
(do_sea) should have aligned behavior when APEI failed to claim the
SEA. Second, if we only talk about SEA caused by memory poison
consumption, both arm64 and x86 KVM already send SIGBUS to VMM/vCPU
thread (kvm_send_hwpoison_signal) to signal hardware memory failure,
although the situation is slightly different here, where we have a
hardware event, versus a HWPoison flag check or VM_FAULT_HWPOISON
returned. But from VMM/vCPU's perspective, hardware event or software
level VM_FAULT_HWPOISON, it would be nice if it can react to just the
same event, the SIGBUS signal.

And there is another reason around your comment on arm64_notify_die.

By "exiting back to userspace with a description of the error", are
you suggesting KVM_EXIT_MEMORY_FAULT? If so, we may need to add a new
flag to tell VMM the error is hardware memory poison, which could be
KVM_MEMORY_EXIT_FLAG_USERFAULT[1] if we don't want a specific one (but
I think a specific flag for hwpoison is probably clearer).

>
> > In addition to the benifit that KVM's handling for SEA becomes aligned
> > with core kernel behavior
> > - The blast radius in VM can be limited to only the consuming thread
> >   in guest, instead of entire guest kernel, unless the consumption is
> >   from guest kernel.
> > - VMM now has the chance to do its duties to stop the VM from repeatedl=
y
> >   consuming corrupted data. For example, VMM can unmap the guest page
> >   from stage-2 table to intercept forseen memory poison consumption,
>
> Not quite. The VMM doesn't manage stage-2. It can remove the page from
> the VMA if it has it mapped, but that's it. The kernel deals with S2.

I should probably not mention the implementation, "unmap from S2".
What is needed for preventing repeated consuming memory poison is
simply preventing guest access to certain memory pages. There is a
work in progress KVM API [1] by my colleague James.

[1] https://lpc.events/event/18/contributions/1757/attachments/1442/3073/LP=
C_%20KVM%20Userfault.pdf

>
> Which brings me to the next subject: when the kernel unmaps the page
> at S2, it is likely to use CMOs. Can these CMOs create RAS error
> themselves?

I assume CMO here means writing dirty cache lines to memory. Writing
something new to a poisoned cacheline usually won't cause RAS error.
Notifying memory poison usually is delayed to a memory load
transaction.

>
> >   and for every consumption injects SEA to EL1 with synthetic memory
> >   error CPER.
>
> Why do we need to involve ACPI here? I would expect the production of
> an architected error record instead. Or at least be given the option.

Sorry, I was just mentioning a specific VMM's implementation. There
are definitely multiple options (Machine Check MSRs vs CPER for error
description data, SEA vs SDEI vs SPI for notification mechanisms) for
how VMM involves the guest to handle memory error. My preference is:
VMM populates CPER in guest HEST when VMM instructs KVM to inject
i/dabt to the guest.

And a word about "be given the option": I think when VMM receives
SIGBUS with si_addr=3Dfaulted/poisoned HVA, it's got all these options,
like using the si_addr to construct CPER with poisoned guest physical
address, or mci_address MSR.

>
> > Introduce a new KVM ARM capability KVM_CAP_ARM_SIGBUS_ON_SEA. VMM
> > can opt in this new capability if it prefers SIGBUS than SError
> > injection during VM init. Now SEA handling in KVM works as follows:
> > 1. Delegate to APEI/GHES to see if SEA can be claimed by them.
> > 2. If APEI failed to claim the SEA and KVM_CAP_ARM_SIGBUS_ON_SEA is
> >    enabled for the VM, and the SEA is NOT about translation table,
> >    send SIGBUS BUS_OBJERR signal with host virtual address.
>
> And what if it is? S1 PTs are backed by userspace memory, like
> anything else. I don't think we should have a different treatment of
> those, because the HW wouldn't treat them differently either.

You are talking about ESR_ELx_FSC_SEA_TTW(1), or
ESR_ELx_FSC_SEA_TTW(0), right? I think you are right, S1 is no
difference.

But I think we want to make an exception for SEA about S2 PTs.

>
> > 3. Otherwise directly inject async SError to guest.
> >
> > Tested on a machine running Siryn AmpereOne processor. A in-house VMM
> > that opts in KVM_CAP_ARM_SIGBUS_ON_SEA started a VM. A dummy applicatio=
n
> > in VM allocated some memory buffer. The test used EINJ to inject an
> > uncorrectable recoverable memory error at a page in the allocated memor=
y
> > buffer. The dummy application then consumed the memory error. Some hack
> > was done to make core kernel's memory_failure triggered by poison
> > generation to fail, so KVM had to deal with the SEA guest abort due to
> > poison consumption. vCPU thread in VMM received SIGBUS BUS_OBJERR with
> > valid host virtual address of the poisoned page. VMM then injected a SE=
A
> > into guest using KVM_SET_VCPU_EVENTS with ext_dabt_pending=3D1. At last
> > the dummy application in guest was killed by SIGBUS BUS_OBJERR, while t=
he
> > guest survived and continued to run.
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 +
> >  arch/arm64/include/asm/kvm_ras.h  | 20 ++++----
> >  arch/arm64/kvm/Makefile           |  2 +-
> >  arch/arm64/kvm/arm.c              |  5 ++
> >  arch/arm64/kvm/kvm_ras.c          | 77 +++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/mmu.c              |  8 +---
> >  include/uapi/linux/kvm.h          |  1 +
> >  7 files changed, 98 insertions(+), 17 deletions(-)
> >  create mode 100644 arch/arm64/kvm/kvm_ras.c
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index bf64fed9820ea..eb37a2489411a 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -334,6 +334,8 @@ struct kvm_arch {
> >       /* Fine-Grained UNDEF initialised */
> >  #define KVM_ARCH_FLAG_FGU_INITIALIZED                        8
> >       unsigned long flags;
> > +     /* Instead of injecting SError into guest, SIGBUS VMM */
> > +#define KVM_ARCH_FLAG_SIGBUS_ON_SEA                  9
>
> nit: why do you put this definition out of sequence (below 'flags')?

Ah, I will move it on top of flags.

>
> >
> >       /* VM-wide vCPU feature set */
> >       DECLARE_BITMAP(vcpu_features, KVM_VCPU_MAX_FEATURES);
> > diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/=
kvm_ras.h
> > index 87e10d9a635b5..4bb7a424e3f6c 100644
> > --- a/arch/arm64/include/asm/kvm_ras.h
> > +++ b/arch/arm64/include/asm/kvm_ras.h
> > @@ -11,15 +11,17 @@
> >  #include <asm/acpi.h>
> >
> >  /*
> > - * Was this synchronous external abort a RAS notification?
> > - * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
> > + * Handle synchronous external abort (SEA) in the following order:
> > + * 1. Delegate to APEI/GHES to see if SEA can be claimed by them. If s=
o, we
> > + *    are all done.
> > + * 2. If userspace opts in KVM_CAP_ARM_SIGBUS_ON_SEA, and if the SEA i=
s NOT
> > + *    about translation table, send SIGBUS
> > + *    - si_code is BUS_OBJERR.
> > + *    - si_addr will be 0 when accurate HVA is unavailable.
> > + * 3. Otherwise, directly inject an async SError to guest.
> > + *
> > + * Note this applies to both ESR_ELx_EC_IABT_* and ESR_ELx_EC_DABT_*.
> >   */
> > -static inline int kvm_handle_guest_sea(phys_addr_t addr, u64 esr)
> > -{
> > -     /* apei_claim_sea(NULL) expects to mask interrupts itself */
> > -     lockdep_assert_irqs_enabled();
> > -
> > -     return apei_claim_sea(NULL);
> > -}
> > +void kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
> >
> >  #endif /* __ARM64_KVM_RAS_H__ */
> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > index 3cf7adb2b5038..c4a3a6d4870e6 100644
> > --- a/arch/arm64/kvm/Makefile
> > +++ b/arch/arm64/kvm/Makefile
> > @@ -23,7 +23,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvt=
ime.o \
> >        vgic/vgic-v3.o vgic/vgic-v4.o \
> >        vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
> >        vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
> > -      vgic/vgic-its.o vgic/vgic-debug.o
> > +      vgic/vgic-its.o vgic/vgic-debug.o kvm_ras.o
> >
> >  kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
> >  kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 48cafb65d6acf..bb97ad678dbec 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -151,6 +151,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >               }
> >               mutex_unlock(&kvm->slots_lock);
> >               break;
> > +     case KVM_CAP_ARM_SIGBUS_ON_SEA:
> > +             r =3D 0;
> > +             set_bit(KVM_ARCH_FLAG_SIGBUS_ON_SEA, &kvm->arch.flags);
>
> Shouldn't this be somehow gated on the VM being RAS aware?

Do you mean a CAP that VMM can tell KVM the VM guest has RAS ability?
I don't know if there is one for arm64. On x86 there is
KVM_X86_SETUP_MCE. KVM_CAP_ARM_INJECT_EXT_DABT maybe a revelant one
but I don't think it is exactly the one for "RAS ability".

>
> > +             break;
> >       default:
> >               break;
> >       }
> > @@ -339,6 +343,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
> >       case KVM_CAP_ARM_SYSTEM_SUSPEND:
> >       case KVM_CAP_IRQFD_RESAMPLE:
> >       case KVM_CAP_COUNTER_OFFSET:
> > +     case KVM_CAP_ARM_SIGBUS_ON_SEA:
> >               r =3D 1;
> >               break;
> >       case KVM_CAP_SET_GUEST_DEBUG2:
> > diff --git a/arch/arm64/kvm/kvm_ras.c b/arch/arm64/kvm/kvm_ras.c
> > new file mode 100644
> > index 0000000000000..3225462bcbcda
> > --- /dev/null
> > +++ b/arch/arm64/kvm/kvm_ras.c
> > @@ -0,0 +1,77 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +#include <linux/bitops.h>
> > +#include <linux/kvm_host.h>
> > +
> > +#include <asm/kvm_emulate.h>
> > +#include <asm/kvm_ras.h>
> > +#include <asm/system_misc.h>
> > +
> > +/*
> > + * For synchrnous external instruction or data abort, not on translati=
on
> > + * table walk or hardware update of translation table, is FAR_EL2 vali=
d?
> > + */
> > +static inline bool kvm_vcpu_sea_far_valid(const struct kvm_vcpu *vcpu)
> > +{
> > +     return !(vcpu->arch.fault.esr_el2 & ESR_ELx_FnV);
> > +}
> > +
> > +/*
> > + * Was this synchronous external abort a RAS notification?
> > + * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
> > + */
> > +static int kvm_delegate_guest_sea(phys_addr_t addr, u64 esr)
> > +{
> > +     /* apei_claim_sea(NULL) expects to mask interrupts itself */
> > +     lockdep_assert_irqs_enabled();
> > +     return apei_claim_sea(NULL);
> > +}
> > +
> > +void kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
> > +{
> > +     bool sigbus_on_sea;
> > +     int idx;
> > +     u64 vcpu_esr =3D kvm_vcpu_get_esr(vcpu);
> > +     u8 fsc =3D kvm_vcpu_trap_get_fault(vcpu);
> > +     phys_addr_t fault_ipa =3D kvm_vcpu_get_fault_ipa(vcpu);
> > +     gfn_t gfn =3D fault_ipa >> PAGE_SHIFT;
> > +     /* When FnV is set, send 0 as si_addr like what do_sea() does. */
> > +     unsigned long hva =3D 0UL;
> > +
> > +     /*
> > +      * For RAS the host kernel may handle this abort.
> > +      * There is no need to SIGBUS VMM, or pass the error into the gue=
st.
> > +      */
> > +     if (kvm_delegate_guest_sea(fault_ipa, vcpu_esr) =3D=3D 0)
> > +             return;
> > +
> > +     sigbus_on_sea =3D test_bit(KVM_ARCH_FLAG_SIGBUS_ON_SEA,
> > +                              &(vcpu->kvm->arch.flags));
> > +
> > +     /*
> > +      * In addition to userspace opt-in, SIGBUS only makes sense if th=
e
> > +      * abort is NOT about translation table walk and NOT about hardwa=
re
> > +      * update of translation table.
> > +      */
> > +     sigbus_on_sea &=3D (fsc =3D=3D ESR_ELx_FSC_EXTABT || fsc =3D=3D E=
SR_ELx_FSC_SECC);
> > +
> > +     /* Pass the error directly into the guest. */
> > +     if (!sigbus_on_sea) {
> > +             kvm_inject_vabt(vcpu);
> > +             return;
> > +     }
> > +
> > +     if (kvm_vcpu_sea_far_valid(vcpu)) {
> > +             idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> > +             hva =3D gfn_to_hva(vcpu->kvm, gfn);
> > +             srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > +     }
> > +
> > +     /*
> > +      * Send a SIGBUS BUS_OBJERR to vCPU thread (the userspace thread =
that
> > +      * runs KVM_RUN) or VMM, which aligns with what host kernel do_se=
a()
> > +      * does if apei_claim_sea() fails.
> > +      */
> > +     arm64_notify_die("synchronous external abort",
> > +                      current_pt_regs(), SIGBUS, BUS_OBJERR, hva, vcpu=
_esr);
>
> This is the point where I really think we should simply trigger an
> exit with all that syndrome information stashed in kvm_run, like any
> other event requiring userspace help.

Ah, there is another reason SIGBUS is better than kvm exit: "It is a
programming error to set ext_dabt_pending after an exit which was not
either KVM_EXIT_MMIO or KVM_EXIT_ARM_NISV", from
Documentation/virt/kvm/api.rst. So if VMM is allowed to inject data
abort to guest, at least current documentation doesn't suggest kvm
exit is feasible.

>
> Also: where is the documentation?

Once I get more positive feedback and send out PATCH instead of RFC, I
can add to Documentation/virt/kvm/api.rst.

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

