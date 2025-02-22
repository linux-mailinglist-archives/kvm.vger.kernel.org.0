Return-Path: <kvm+bounces-38955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1D5BA405DF
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 07:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB1E6420DFA
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 06:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573D81FFC65;
	Sat, 22 Feb 2025 06:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BBogUow+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254831FAC37
	for <kvm@vger.kernel.org>; Sat, 22 Feb 2025 06:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740205389; cv=none; b=n9Rdm/EUxYQugTEy0RQgVL3aCl+tNDHlRzuGeUlO2skJM5rpm0Ir5HtVj2cOJRKlkWTLiZs7DE7O4Vv2u4auvLwpgZdUSuRrjGODS4XGd7hMd5YCeUiZOr2YWAAzDys42FVacbdINAWyhBPp+0xHpgtYw+yjWCSjPBXtePfFOZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740205389; c=relaxed/simple;
	bh=wbiaZRpwaWJ44Jicim7xoy+Vjvv7qLuMezkTNxblgz8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T+WtkeZFMdaXM1p904adX1ff/7f7fKQlAeNPcP4SErisc+5fOBdPsy8UCCR1aEKLfJW4wbD6H80feg4CkztHX+hhh8uNk/t7zPNvBgT9LucFC6X9pU9XLXNwy9TNMQWHOsD1Ex6avTSYEgfPw5+50yMoj1TS4wkIj4Y5Wdb1Iyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BBogUow+; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4393ee912e1so16185e9.1
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 22:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740205385; x=1740810185; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQehfqZJH0xfwBZeev2OghFV36YVYjSCy706riWxgiI=;
        b=BBogUow+nk52X7Sm8mpQ0p1fFOHixG+EVPUFTLwEAZYjcoQX86sicFbUzW/Mm4c/0D
         dGz/QLK5KxCFeOGCnYxz2vsYd+t2dI/bDfaBcIfwrwabHzIQmpUZUmYGizA+cYURd9yF
         8g9WitScJXx+Hu8uFad/zV7ufSiGgXMlXnmHVh7Ydkfvdya4DFPJKeemVGeKWdxhi1DL
         WgRqpvRTk/tqoMzcWjPINTILElZQC7YfjO/ne42DiEGNmk3uUqw3HAAF792rn6t5qHGF
         uDnb44d3JAUeJgC6kfrlFYEFkoxdDNw82DMYPhAtgTz2BywAgy2nlWQUhEwau3cmS6CF
         upHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740205385; x=1740810185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vQehfqZJH0xfwBZeev2OghFV36YVYjSCy706riWxgiI=;
        b=WcD4LUevY2qcPDWNZ90wXLJ0Q4EjJYZKnzFa7kH1YqPPGryNtbjQShupFC7BpT5m1g
         UzwVMO6BJxKSvE+L6Ovhb8Y7SzCOZROHecyVCiG6c+PcldofB+4ZrBLpD5j5fJU+iGAs
         pFp9WRqnz+pI76tQC32h2EFju2+V99k1czc/wYwynw6qmzNfwQ8jFyJ9hPVzZdJS/6iZ
         Cvhvfcv4I9/SylZU1YFPalNJF4EnErgwkhcD0ekDU2wm/RjdWHL/CYACTyXRNVfZGvNF
         eJMvJ1V9kXNoPB+xUATBH2Vc6RvD10Rz1f/NBH52bWfS1+vB5vqx9fki+LFatZpamU+X
         vL9g==
X-Forwarded-Encrypted: i=1; AJvYcCX3cUOGwqBwXj2R82I1GaGYyK4S/UuATQWYoUM1FkXkvjLndUJ++8QwNb07P+kixuhbCwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRBLHlnkLuKroiLBaxz0O+vvdkFyScGQJQfH8jr8BvsQNXSGme
	dfI0YEnAo2Tiwhsi09MSSyfbblLG+KxN9KXpBw3HfeoSjALOe3r2fNcy66uuUlGe3U4/kszm0lx
	oshjZYVIlPJA+I1RQRYMzEnqfUB35QE0GAfwJ
X-Gm-Gg: ASbGncuYpNBFPXYFZt4CUeY/DB137msxw8Wm+wwV0gMbNDqhvoF+Pa5A4LhipTO4U/9
	adrc3KoMCXEP+nurOZgb+zz9Qb6YuFjGeqe87jRXishKLFxaZykDy3ZoNNAG2WL1j4qC/gegWdP
	Br4YkbE8JkSlDdXiE2Y1jRd9O39LKAA62Afg337jsX
X-Google-Smtp-Source: AGHT+IE4V8nCHq0twugbfwGnXNOG4jskFknQCwFJiFQBLsePbooNcAVV3KNpm4hL68xRVn/yBJSAg5GZ2rwqg328LGA=
X-Received: by 2002:a05:600c:3149:b0:439:8202:b942 with SMTP id
 5b1f17b1804b1-439ba1a5f13mr362555e9.1.1740205385121; Fri, 21 Feb 2025
 22:23:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250220232959.247600-1-jiaqiyan@google.com> <86pljbqqh0.wl-maz@kernel.org>
In-Reply-To: <86pljbqqh0.wl-maz@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 21 Feb 2025 22:22:52 -0800
X-Gm-Features: AWEUYZnVranek0VQdBj-Cs66mVahQ9Zorf9E_2c7AtUktgNRjlkRd_kNI5WViY4
Message-ID: <CACw3F51AbkgbjR0Dw-=JOco76P7kab_w0kexVpkTaax3a33itA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/3] KVM: arm64: SIGBUS VMM for SEA guest abort
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, duenwen@google.com, 
	rananta@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for your feedback, Marc!

On Fri, Feb 21, 2025 at 7:15=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Honestly, please drop this RFC thing.  At v3, either you think this is
> in a good enough shape to be merged, or you simply don't post it. I
> assume you're in the former camp.

I may have to stick with RFC in V4 (or start a new RFC V1?), for the
"big" turning around from signal to VM exit.

>
> On Thu, 20 Feb 2025 23:29:57 +0000,
> Jiaqi Yan <jiaqiyan@google.com> wrote:
> >
> > When APEI is unable claim or handles synchronous external abort (SEA)
> > today KVM handles SEA for guest by injecting an async SError into the
> > guest directly, bypassing VMM, usually results in guest kernel panic.
> >
> > One major situation of guest SEA is when vCPU consumes uncorrectable
> > memory error on the physical memory. Although SError and guest kernel
> > panic effectively stops the propagation of corrupted memory, it is not
> > easy for VMM and guest to recover from memory error in a more graceful
> > manner.
> >
> > This patch teaches KVM to send a SIGBUS BUS_OBJERR to VMM/vCPU, like
>
> https://elixir.bootlin.com/linux/v6.13/source/Documentation/process/submi=
tting-patches.rst#L95

Noted, "Make KVM".

>
> > how core kernel signals SIGBUS BUS_OBJERR to a gernal poison consuming
> > userspace thread when APEI is unable to claim the SEA. In addition to
> > the benifit that KVM's handling for SEA becomes aligned with core
> > kernel's behavior:
> > - VMM can inject SEA to guest. Compared to SError, the blast radius in
> >   VM is possible to be limited to only the consuming thread in guest,
> >   instead of the entire guest kernel (unless the poison consumption is
> >   from guest kernel).
>
> But that would be equally possible for this SEA to be delivered from
> the host kernel, without involving userspace at all, right? Why
> mandate a userspace round trip?

A couple of reasons to involve userspace VMM:
- VMM can create telemetry for this important VM event. Some VM
customer usually don't know what happened to their killed application,
so VMM keeping the SEA event can help cloud providers to explain the
exception to customer.
- VMM can set up the KVM userfault to the poisoned guest physical page.

Of course both VM exit and SIGBUS would work.

>
> > - VMM usually tracks the poisoned guest pages. Together with [1], if
> >   guest consumes again the already poisoned guest pages, VMM can protec=
t
> >   itself and the host by stopping the consumption at software level, by
> >   intercepting guest's access to poisoned pages, and again injecting
> >   SEA to guest.
>
> How does this interact with the userfault thingy? I'd expect the VMM
> to simply removing the poisoned page from the memslot, which doesn't
> require anything on top of what we have today.

Removing poisoned pages from memslot (one memslot will become two
IIUC) can work, but to my best understanding, changing memslot is
expensive and not ideal for an already running VM.
KVM userfault on the other hand introduces a bitmap for each memslot,
which describes if a guest-fault should result in
KVM_EXIT_MEMORY_FAULT exit.
Another way to look at KVM userfault is, it only removes the poisoned
GFN from stage-2 page table, so no need to operate a memslot.

>
> Overall, most of the above belongs to a cover letter, which is
> crucially missing in this series.

Yes, it looks like the motivation and usecases are getting longer. I
will extract them into a cover letter in the next revision.

>
> >
> > KVM now handles SEA as follows:
> > 1. Delegate to APEI and GHES to see if SEA can be claimed by them.
> > 2. If APEI failed to claim the SEA, send current thread (i.e. VMM in EL=
0)
> >    a si_code=3DBUS_OBJERR SIGBUS signal. If the DIMM error's physical
> >    address is available from FAR_EL2, si_addr will be the DIMM error's
> >    host virtual address in VMM/vCPU's memory space.
>
> VMM *or* vcpu? The vcpu address space is the guest's. The VMM address
> space is the in userspace.

The VMM's address space, who mmap-ed the host memory and gives KVM to
set up memslots for the VM. By "vCPU" I actually mean the current
thread (which should be a thread in VMM process) that runs KVN_RUN for
the vCPU who consumed memory error.

>
> Also, I'm still not fond of the signal horror. I still feel this is a
> broken abstraction, at odds with the rest of the KVM API which relies
> on vcpu exit codes. Signals are the perfect recipe to trigger subtle,
> potentially exploitable VMM bugs. I'm sure your VMM is perfect (Ah!),
> but think of the children! ;-)

Let me give VM exit a try. For VMM setting up the SIGBUS handler can
also be tricky, and exiting directly to the thread running the KVM_RUN
sounds simpler than having to run the SIGBUS handler first then back
to KVM_RUN thread.

What's in my mind is to use KVM_EXIT_MEMORY_FAULT:

/* KVM_EXIT_MEMORY_FAULT */
struct {
#define KVM_MEMORY_EXIT_FLAG_PRIVATE (1ULL << 3)
#define KVM_MEMORY_EXIT_FLAG_EXT_ABORT (1ULL << 4)
#define KVM_MEMORY_EXIT_FLAG_EXT_ABORT_ADDR_VALID (1ULL << 5)
__u64 flags;  // will set KVM_MEMORY_EXIT_FLAG_EXT_ABORT
__u64 gpa; // if available, will set EXT_ABORT_ADDR_VALID  in flags
will be the poisoned or fault gpa; otherwise, will clear
EXT_ABORT_ADDR_VALID in flags
__u64 size; // PAGE_SIZE
} memory_fault;

and KVM_RUN returns -1, errno will be
- EFAULT for ESR_ELx_FSC_EXTABT and ESR_ELx_FSC_SEA_TTW(x), since KVM
cannot be sure the fault is caused by memory error
- EHWPOISON for ESR_ELx_FSC_SECC and ESR_ELx_FSC_SECC_TTW(x), since
this fault is definitely about memory error

Such changes will be visible to x86 as well.

I wonder how you like the existing SIGBUSes sent from KVM
(kvm_send_hwpoison_signal in both x86 and arm64 mmu's user_mem_abort)?
would you like them to become KVM_EXIT_MEMORY_FAULT? It seems
virt/kvm/api.rst doesn't mention that interrupted by SIGBUS is the
uAPI for KVM_RUN when running into new memory error or kernel poison
page (page marked with PG_HWPoison).

>
> >
> > Tested on a machine running Siryn AmpereOne processor. A dummy applicat=
ion
> > in VM allocated some memory buffer. The test used EINJ to inject an
>
> How? Do we allow error injection from a guest?

Sorry the text is confusing. Error is injected at a host physical
address, translated from the guest memory buffer's virtual address (a
guest virtual address), i.e. GVA =3D> GPA =3D> HVA =3D> HPA. The main
purpose is to make the dummy application in VM (KVM_RUN) consume the
error.

>
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
>
> This has nothing to do in this patch's commit message. But it would
> have its place for a selftest doing exactly what you describe.

I will try to convert my integration test into a selftest next time.
The selftest may not be able to run on a normal host, as EINJ is
usually only available after debug firmware is installed. However,
assuming EINJ BIOS is installed (otherwise skip the test), writing
such a selftest sounds feasible.

>
> >
> > [1] https://lpc.events/event/18/contributions/1757/attachments/1442/307=
3/LPC_%20KVM%20Userfault.pdf
> >
> > Changelog
> >
> > RFC V3 -> RFC v2
> > - SEA or ECC error at all levels of TTW can be handled by SIGBUS EL0,
> >   and no case to inject SError to guest anymore.
> > - move #include from kvm_ras.h to kvm_ras.c.
> >
> > RFC v2 -> RFC v1
> > - reword commit msg
> > - drop unused parameters from kvm_delegate_guest_sea
> > - remove KVM_CAP_ARM_SIGBUS_ON_SEA and its opt in code
> > - set FnV bit in vcpu's ESR_ELx if host ESR_EL2's FnV is set
> > - add documentation for this new SIGBUS feature
>
> Please talk to your colleagues on how to write a cover letter. None of
> that should be here.
>
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_ras.h | 29 +++++++-------
> >  arch/arm64/kvm/Makefile          |  2 +-
> >  arch/arm64/kvm/kvm_ras.c         | 65 ++++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/mmu.c             |  8 +---
> >  4 files changed, 83 insertions(+), 21 deletions(-)
> >  create mode 100644 arch/arm64/kvm/kvm_ras.c
> >
> > diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/=
kvm_ras.h
> > index 87e10d9a635b5..bacae54013b4e 100644
> > --- a/arch/arm64/include/asm/kvm_ras.h
> > +++ b/arch/arm64/include/asm/kvm_ras.h
> > @@ -4,22 +4,25 @@
> >  #ifndef __ARM64_KVM_RAS_H__
> >  #define __ARM64_KVM_RAS_H__
> >
> > -#include <linux/acpi.h>
> > -#include <linux/errno.h>
> > -#include <linux/types.h>
> > -
> > -#include <asm/acpi.h>
> > +#include <linux/kvm_host.h>
> >
> >  /*
> > - * Was this synchronous external abort a RAS notification?
> > - * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
> > + * For synchrnous external abort taken to KVM at EL2, not on translati=
on
>
> synchronous
>
> > + * table walk or hardware update of translation table, is FAR_EL2 vali=
d?
>
> Do we need all these conditions spelled out? Isn't the goal of such a
> helper to *abstract* the complexity of the architecture?

Will simplify the comment.

>
> >   */
> > -static inline int kvm_handle_guest_sea(phys_addr_t addr, u64 esr)
> > -{
> > -     /* apei_claim_sea(NULL) expects to mask interrupts itself */
> > -     lockdep_assert_irqs_enabled();
> > +bool kvm_vcpu_sea_far_valid(const struct kvm_vcpu *vcpu);
> >
> > -     return apei_claim_sea(NULL);
> > -}
> > +/*
> > + * Handle synchronous external abort (SEA) in the following order:
> > + * 1. Delegate to APEI/GHES to see if they can claim SEA. If so, all d=
one.
> > + * 2. Send SIGBUS to current with si_code=3DBUS_OBJERR and si_addr set=
 to
> > + *    the poisoned host virtual address. When accurate HVA is unavaila=
ble,
> > + *    si_addr will be 0.
>
> How do you disambiguate this with 0 being a valid address? See vm.mmap_mi=
n_addr.

HVA unavailable should probably result in a SIGKILL, similar to when
memory_failure failed to look up the HVA from PFN. But I expect two
possible signals will receive more nack from you, so I think exit with
KVM_MEMORY_EXIT_FLAG_EXT_ABORT_ADDR_VALID is probably a better way to
deal with this case.

>
> > + *
> > + * Note this applies to both instruction and data abort (ESR_ELx_EC_IA=
BT_*
> > + * and ESR_ELx_EC_DABT_*). As the name suggests, KVM must be taking th=
e SEA
> > + * when calling into this function, e.g. kvm_vcpu_abt_issea =3D=3D tru=
e.
>
> Again, this is pointlessly verbose. I'd rather we keep the original
> comment here.

Ack.

>
> > + */
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
> > diff --git a/arch/arm64/kvm/kvm_ras.c b/arch/arm64/kvm/kvm_ras.c
> > new file mode 100644
> > index 0000000000000..47531ed378910
> > --- /dev/null
> > +++ b/arch/arm64/kvm/kvm_ras.c
> > @@ -0,0 +1,65 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +#include <linux/acpi.h>
> > +#include <linux/types.h>
> > +
> > +#include <asm/acpi.h>
> > +#include <asm/kvm_emulate.h>
> > +#include <asm/kvm_ras.h>
> > +#include <asm/system_misc.h>
> > +
> > +bool kvm_vcpu_sea_far_valid(const struct kvm_vcpu *vcpu)
> > +{
> > +     /*
> > +      * FnV is valid only for Data/Instruction aborts and if DFSC/IFSC
> > +      * is ESR_ELx_FSC_EXTABT(0b010000).
>
> This is a terrible sentence. FnV stands for "FAR not Valid". Do you
> see the problem? Yes, the same verbiage exists in the spec, but I
> don't think we need to sink that low...
>
> > +      */
> > +     if (kvm_vcpu_trap_get_fault(vcpu) =3D=3D ESR_ELx_FSC_EXTABT)
> > +             return !(vcpu->arch.fault.esr_el2 & ESR_ELx_FnV);
> > +
> > +     /* Other exception classes or aborts don't care about FnV field. =
*/
>
> They absolutely do care. But FnV is RES0 in this case. So the real
> question is why don't you simply return the negated bit in all cases?

For both here and the one above: would changing the comment to "Note:
FnV is RES0 for all aborts other than ESR_ELx_FSC_EXTABT(0b010000)"
look better? and simply return !(vcpu->arch.fault.esr_el2 &
ESR_ELx_FnV);

>
> > +     return true;
> > +}
> > +
> > +/*
> > + * Was this synchronous external abort a RAS notification?
> > + * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
> > + */
> > +static int kvm_delegate_guest_sea(void)
> > +{
> > +     /* apei_claim_sea(NULL) expects to mask interrupts itself */
> > +     lockdep_assert_irqs_enabled();
> > +     return apei_claim_sea(NULL);
> > +}
> > +
> > +void kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
> > +{
> > +     int idx;
> > +     u64 vcpu_esr =3D kvm_vcpu_get_esr(vcpu);
> > +     phys_addr_t fault_ipa =3D kvm_vcpu_get_fault_ipa(vcpu);
> > +     gfn_t gfn =3D fault_ipa >> PAGE_SHIFT;
> > +     unsigned long hva =3D 0UL;
> > +
> > +     /*
> > +      * For RAS the host kernel may handle this abort.
> > +      * There is no need to SIGBUS VMM, or pass the error into the gue=
st.
> > +      */
> > +     if (kvm_delegate_guest_sea() =3D=3D 0)
> > +             return;
> > +
> > +     if (kvm_vcpu_sea_far_valid(vcpu)) {
> > +             idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> > +             hva =3D gfn_to_hva(vcpu->kvm, gfn);
> > +             srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > +     }
> > +
> > +     /*
> > +      * When FAR is not valid, or GFN to HVA translation failed, send =
0
> > +      * as si_addr like what do_sea() does.
> > +      */
> > +     if (kvm_is_error_hva(hva))
> > +             hva =3D 0UL;
>
> See my earlier comment about 0 being a valid VA.
>
> > +
> > +     arm64_notify_die("synchronous external abort",
> > +                      current_pt_regs(), SIGBUS, BUS_OBJERR, hva, vcpu=
_esr);
> > +}
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 1f55b0c7b11d9..ef6127d0bf24f 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1808,13 +1808,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu=
)
> >
> >       /* Synchronous External Abort? */
> >       if (kvm_vcpu_abt_issea(vcpu)) {
> > -             /*
> > -              * For RAS the host kernel may handle this abort.
> > -              * There is no need to pass the error into the guest.
> > -              */
> > -             if (kvm_handle_guest_sea(fault_ipa, kvm_vcpu_get_esr(vcpu=
)))
> > -                     kvm_inject_vabt(vcpu);
> > -
> > +             kvm_handle_guest_sea(vcpu);
>
> But this is an ABI change. My userspace is not ready, willing nor able
> to handle this, and yet you're forcing it on me?

Now if we consider KVM_EXIT_MEMORY_FAULT approach instead of signal,
can I say KVM_EXIT_MEMORY_FAULT is always better than injecting SError
to guest, even if VMM is not ready, will nor able to handle
KVM_EXIT_MEMORY_FAULT?

I expect a sensible VMM will probably die after dumping the unhandled
KVM_EXIT_MEMORY_FAULT. If someone bothers to debug the dumped exit,
they will know about memory error or SEA and hopefully start to handle
this new KVM_EXIT_MEMORY_FAULT. On the other hand, if KVM injects
SError to the guest for a memory error, the guest kernel will panic
and the guest probably auto rebooted. This guest will still be exposed
to the same memory error, and run into kernel panic in an unknown
future time, and there is no clue at all, in guest or in VMM, for
anyone willing to debug the guest panics.

I think KVM_EXIT_MEMORY_FAULT is a little better than injecting SError.

But if there is such a case that SError is absolutely better, I can
keep it by putting the new vm exit after an userspace opt in.

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

