Return-Path: <kvm+bounces-31329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A6D39C26F9
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 22:19:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00393284831
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 21:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF7D1E0092;
	Fri,  8 Nov 2024 21:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wieK3PD2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95CB194082
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 21:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731100749; cv=none; b=RoLkKq4+TMn1L9pYDcXiEVcTH3pr0Yf+PiGZMbrO42Yj5CfJiNQDO+lXYaKP+XnbFh2yxXv6e7b2mEneDBI1YBJP8IqDPm6Ady3IjjUrURajC0SjO7WK5ipL+duPYE/AapGQOSA+NWB1ZaeElvJ1t+AzF+am3BoEmceqa8FkY2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731100749; c=relaxed/simple;
	bh=tDljzpZuOvX3WTfGD+h82SFhJwpiJd8KBJMVLzbQIJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h/QF/3FtYwzUAYvVoFud/8UQxlUSWU2SbtZk5KEasTo1YtDspR2uJiB275jmO4deafvQoIUHb60CHMQAxqEvJzlyOGMGVedaNoEKlUSmA4giT3MKTeknmRyVIL/a//p8UvP5Izt3TCeAZex9tcQts+8U/1vt7vfgXr2PtAntxYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wieK3PD2; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539e617ef81so882e87.1
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 13:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731100746; x=1731705546; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3pNRoNs94iGgIkHYfrZaBo/v0//dX8R2dfahyIwZUoo=;
        b=wieK3PD2UEyDoUapfIjr+mBzc3Vz6SRNl2eC62iVmq3LxyQv5dT4tkkdBvgEpizYJI
         V8BagncAJeSlO9JEUvyp2p+LctrNb2jOeYurza8dVXfqDDukU+5nk4jdpdhEP4M0UD3B
         6ZcTDWkpxlwcde5FzJyMIybgldIopKGM3ASWilrrOmpbr/SQSS8iP2iTB8p9EvdAhZYP
         QawoxTKuHg6HDnl2oSilvNC+9TPzrPK8G54pG/7PRfzaNMEOpI+oLSzyLvtuX9N5ndm+
         o0+oyJp1VyRxZIAfjep+isfAo9g6ZhyXAZoczEISRd65poL/FpRNJFdU8ZjS3ail5R8A
         hiUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731100746; x=1731705546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3pNRoNs94iGgIkHYfrZaBo/v0//dX8R2dfahyIwZUoo=;
        b=CDGWfZuidlWMrd3SzDpbeeVTdPatd95yuvlbR+VQTgf799/8F+k3m5Pa6hMJc69JRG
         fgjbQdocj+jIgELMl4eMnoH+V6et/8oxF746YpFwo7RH2wdO/jL4Nc9xS/nafpRcFPS/
         3IJhjeYjCcDuaTJ87tdKG/7lq6Ih/ln9P6D7zGWZxBOdDmEkt0aACd0979HD2XOc2N6r
         lM2fYwVb/slhxqzS52Sn1RO1UgyJG6uLNZPBP0Nhc5jmVD14qKPH4QQ8hLAyPytutFC0
         Zr4Q/vRVWKAvoiJQomeBo+hi6V5DlgOPASLB+G91NuA2TWS4Y7nG3u2otXtJboaNerCc
         iZxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe0tPRL8qavkIDcYKmjkOVmQKXSdppQy2JQrqRJPL2ELZL842P3kHd08y/L446UXmIHM0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzREVFCXCWYaAwSlAp0SR8h+Cw9YDGlfpmYR4euRysFbsnFPfA
	LPMzMBpFUe4/2A9F2jpPZSQ85cO70N63SfN/QONM3SsfHL1dAZWw1ygUO/ZUG5iRJSuccQ3AyZc
	XS8qksO980lkX2f7vSUYVBCsEfURCtC7gVCPC
X-Gm-Gg: ASbGnctiD6vEBs5AJxSZgamb3XDUTLaHTQsicM+9WyPJzORwjR6MH4I97rA7yAQSOQz
	O/4suzwZ0JFHpLSOwbU31ERqs5qEDXy8tvmsOg7GoeBEmUu19DpJFfZyNstmdPw==
X-Google-Smtp-Source: AGHT+IEMi/DABphVzpbJvjQ+ZrB+3B8mPU1lu0pbXGUcU4u7ccgLy0qoPb4tiNbEw0WxtpKAjdVL2oNIQVLlR7I6now=
X-Received: by 2002:ac2:518e:0:b0:536:88d0:420d with SMTP id
 2adb3069b0e04-53d8bdf9fb4mr93710e87.6.1731100741556; Fri, 08 Nov 2024
 13:19:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031212104.1429609-1-jiaqiyan@google.com> <86r07v1g2z.wl-maz@kernel.org>
 <CACw3F51FbzkkX_DcCVCieZ=408oP_Fy3sXYk5AjWRX3RJO2Fzg@mail.gmail.com>
In-Reply-To: <CACw3F51FbzkkX_DcCVCieZ=408oP_Fy3sXYk5AjWRX3RJO2Fzg@mail.gmail.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 8 Nov 2024 13:18:50 -0800
Message-ID: <CACw3F51B-RKE0OHGZwoQo1LPxygYc77VAbCHNfU25VVrpHc4-g@mail.gmail.com>
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

On Sun, Nov 3, 2024 at 9:02=E2=80=AFPM Jiaqi Yan <jiaqiyan@google.com> wrot=
e:
>
> Hi Marc, thanks for your quick response!
>
> On Fri, Nov 1, 2024 at 6:54=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
> >
> > On Thu, 31 Oct 2024 21:21:04 +0000,
> > Jiaqi Yan <jiaqiyan@google.com> wrote:
> > >
> > > Currently KVM handles SEA in guest by injecting async SError into
> > > guest directly, bypassing VMM, usually results in guest kernel panic.
> > >
> > > One major situation of guest SEA is when vCPU consumes uncorrectable
> > > memory error on the physical memory. Although SError and guest kernel
> > > panic effectively stops the propagation of corrupted memory, it is no=
t
> > > easy for VMM and guest to recover from memory error in a more gracefu=
l
> > > manner.
> > >
> > > Alternatively KVM can send a SIGBUS BUS_OBJERR to VMM/vCPU, just like
> > > how core kernel signals SIGBUS BUS_OBJERR to the poison consuming
> > > thread.
> >
> > Can you elaborate on why the delivery of a signal is preferable to
> > simply exiting back to userspace with a description of the error?
> > Signals are usually not generated by KVM, and are a pretty twisted way
> > to generate an exit.
>
> A couple of reasons. First, my intuition is that KVM and core kernel
> (do_sea) should have aligned behavior when APEI failed to claim the
> SEA. Second, if we only talk about SEA caused by memory poison
> consumption, both arm64 and x86 KVM already send SIGBUS to VMM/vCPU
> thread (kvm_send_hwpoison_signal) to signal hardware memory failure,
> although the situation is slightly different here, where we have a
> hardware event, versus a HWPoison flag check or VM_FAULT_HWPOISON
> returned. But from VMM/vCPU's perspective, hardware event or software
> level VM_FAULT_HWPOISON, it would be nice if it can react to just the
> same event, the SIGBUS signal.
>
> And there is another reason around your comment on arm64_notify_die.
>
> By "exiting back to userspace with a description of the error", are
> you suggesting KVM_EXIT_MEMORY_FAULT? If so, we may need to add a new
> flag to tell VMM the error is hardware memory poison, which could be
> KVM_MEMORY_EXIT_FLAG_USERFAULT[1] if we don't want a specific one (but
> I think a specific flag for hwpoison is probably clearer).
>
> >
> > > In addition to the benifit that KVM's handling for SEA becomes aligne=
d
> > > with core kernel behavior
> > > - The blast radius in VM can be limited to only the consuming thread
> > >   in guest, instead of entire guest kernel, unless the consumption is
> > >   from guest kernel.
> > > - VMM now has the chance to do its duties to stop the VM from repeate=
dly
> > >   consuming corrupted data. For example, VMM can unmap the guest page
> > >   from stage-2 table to intercept forseen memory poison consumption,
> >
> > Not quite. The VMM doesn't manage stage-2. It can remove the page from
> > the VMA if it has it mapped, but that's it. The kernel deals with S2.
>
> I should probably not mention the implementation, "unmap from S2".
> What is needed for preventing repeated consuming memory poison is
> simply preventing guest access to certain memory pages. There is a
> work in progress KVM API [1] by my colleague James.
>
> [1] https://lpc.events/event/18/contributions/1757/attachments/1442/3073/=
LPC_%20KVM%20Userfault.pdf
>
> >
> > Which brings me to the next subject: when the kernel unmaps the page
> > at S2, it is likely to use CMOs. Can these CMOs create RAS error
> > themselves?
>
> I assume CMO here means writing dirty cache lines to memory. Writing
> something new to a poisoned cacheline usually won't cause RAS error.
> Notifying memory poison usually is delayed to a memory load
> transaction.
>
> >
> > >   and for every consumption injects SEA to EL1 with synthetic memory
> > >   error CPER.
> >
> > Why do we need to involve ACPI here? I would expect the production of
> > an architected error record instead. Or at least be given the option.
>
> Sorry, I was just mentioning a specific VMM's implementation. There
> are definitely multiple options (Machine Check MSRs vs CPER for error
> description data, SEA vs SDEI vs SPI for notification mechanisms) for
> how VMM involves the guest to handle memory error. My preference is:
> VMM populates CPER in guest HEST when VMM instructs KVM to inject
> i/dabt to the guest.
>
> And a word about "be given the option": I think when VMM receives
> SIGBUS with si_addr=3Dfaulted/poisoned HVA, it's got all these options,
> like using the si_addr to construct CPER with poisoned guest physical
> address, or mci_address MSR.
>
> >
> > > Introduce a new KVM ARM capability KVM_CAP_ARM_SIGBUS_ON_SEA. VMM
> > > can opt in this new capability if it prefers SIGBUS than SError
> > > injection during VM init. Now SEA handling in KVM works as follows:
> > > 1. Delegate to APEI/GHES to see if SEA can be claimed by them.
> > > 2. If APEI failed to claim the SEA and KVM_CAP_ARM_SIGBUS_ON_SEA is
> > >    enabled for the VM, and the SEA is NOT about translation table,
> > >    send SIGBUS BUS_OBJERR signal with host virtual address.
> >
> > And what if it is? S1 PTs are backed by userspace memory, like
> > anything else. I don't think we should have a different treatment of
> > those, because the HW wouldn't treat them differently either.
>
> You are talking about ESR_ELx_FSC_SEA_TTW(1), or
> ESR_ELx_FSC_SEA_TTW(0), right? I think you are right, S1 is no
> difference.
>
> But I think we want to make an exception for SEA about S2 PTs.
>
> >
> > > 3. Otherwise directly inject async SError to guest.
> > >
> > > Tested on a machine running Siryn AmpereOne processor. A in-house VMM
> > > that opts in KVM_CAP_ARM_SIGBUS_ON_SEA started a VM. A dummy applicat=
ion
> > > in VM allocated some memory buffer. The test used EINJ to inject an
> > > uncorrectable recoverable memory error at a page in the allocated mem=
ory
> > > buffer. The dummy application then consumed the memory error. Some ha=
ck
> > > was done to make core kernel's memory_failure triggered by poison
> > > generation to fail, so KVM had to deal with the SEA guest abort due t=
o
> > > poison consumption. vCPU thread in VMM received SIGBUS BUS_OBJERR wit=
h
> > > valid host virtual address of the poisoned page. VMM then injected a =
SEA
> > > into guest using KVM_SET_VCPU_EVENTS with ext_dabt_pending=3D1. At la=
st
> > > the dummy application in guest was killed by SIGBUS BUS_OBJERR, while=
 the
> > > guest survived and continued to run.
> > >
> > > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h |  2 +
> > >  arch/arm64/include/asm/kvm_ras.h  | 20 ++++----
> > >  arch/arm64/kvm/Makefile           |  2 +-
> > >  arch/arm64/kvm/arm.c              |  5 ++
> > >  arch/arm64/kvm/kvm_ras.c          | 77 +++++++++++++++++++++++++++++=
++
> > >  arch/arm64/kvm/mmu.c              |  8 +---
> > >  include/uapi/linux/kvm.h          |  1 +
> > >  7 files changed, 98 insertions(+), 17 deletions(-)
> > >  create mode 100644 arch/arm64/kvm/kvm_ras.c
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> > > index bf64fed9820ea..eb37a2489411a 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -334,6 +334,8 @@ struct kvm_arch {
> > >       /* Fine-Grained UNDEF initialised */
> > >  #define KVM_ARCH_FLAG_FGU_INITIALIZED                        8
> > >       unsigned long flags;
> > > +     /* Instead of injecting SError into guest, SIGBUS VMM */
> > > +#define KVM_ARCH_FLAG_SIGBUS_ON_SEA                  9
> >
> > nit: why do you put this definition out of sequence (below 'flags')?
>
> Ah, I will move it on top of flags.
>
> >
> > >
> > >       /* VM-wide vCPU feature set */
> > >       DECLARE_BITMAP(vcpu_features, KVM_VCPU_MAX_FEATURES);
> > > diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/as=
m/kvm_ras.h
> > > index 87e10d9a635b5..4bb7a424e3f6c 100644
> > > --- a/arch/arm64/include/asm/kvm_ras.h
> > > +++ b/arch/arm64/include/asm/kvm_ras.h
> > > @@ -11,15 +11,17 @@
> > >  #include <asm/acpi.h>
> > >
> > >  /*
> > > - * Was this synchronous external abort a RAS notification?
> > > - * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
> > > + * Handle synchronous external abort (SEA) in the following order:
> > > + * 1. Delegate to APEI/GHES to see if SEA can be claimed by them. If=
 so, we
> > > + *    are all done.
> > > + * 2. If userspace opts in KVM_CAP_ARM_SIGBUS_ON_SEA, and if the SEA=
 is NOT
> > > + *    about translation table, send SIGBUS
> > > + *    - si_code is BUS_OBJERR.
> > > + *    - si_addr will be 0 when accurate HVA is unavailable.
> > > + * 3. Otherwise, directly inject an async SError to guest.
> > > + *
> > > + * Note this applies to both ESR_ELx_EC_IABT_* and ESR_ELx_EC_DABT_*=
.
> > >   */
> > > -static inline int kvm_handle_guest_sea(phys_addr_t addr, u64 esr)
> > > -{
> > > -     /* apei_claim_sea(NULL) expects to mask interrupts itself */
> > > -     lockdep_assert_irqs_enabled();
> > > -
> > > -     return apei_claim_sea(NULL);
> > > -}
> > > +void kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
> > >
> > >  #endif /* __ARM64_KVM_RAS_H__ */
> > > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > > index 3cf7adb2b5038..c4a3a6d4870e6 100644
> > > --- a/arch/arm64/kvm/Makefile
> > > +++ b/arch/arm64/kvm/Makefile
> > > @@ -23,7 +23,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o p=
vtime.o \
> > >        vgic/vgic-v3.o vgic/vgic-v4.o \
> > >        vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
> > >        vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
> > > -      vgic/vgic-its.o vgic/vgic-debug.o
> > > +      vgic/vgic-its.o vgic/vgic-debug.o kvm_ras.o
> > >
> > >  kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
> > >  kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 48cafb65d6acf..bb97ad678dbec 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -151,6 +151,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > >               }
> > >               mutex_unlock(&kvm->slots_lock);
> > >               break;
> > > +     case KVM_CAP_ARM_SIGBUS_ON_SEA:
> > > +             r =3D 0;
> > > +             set_bit(KVM_ARCH_FLAG_SIGBUS_ON_SEA, &kvm->arch.flags);
> >
> > Shouldn't this be somehow gated on the VM being RAS aware?
>
> Do you mean a CAP that VMM can tell KVM the VM guest has RAS ability?
> I don't know if there is one for arm64. On x86 there is
> KVM_X86_SETUP_MCE. KVM_CAP_ARM_INJECT_EXT_DABT maybe a revelant one
> but I don't think it is exactly the one for "RAS ability".

Hi Marc,

There is also a kernel config called ARM64_RAS_EXTN but I believe it
is for the host CPU, not about VM's RAS.

But taking Oliver's opinion into account, I think we want to remove
KVM_CAP_ARM_SIGBUS_ON_SEA. Wonder what your thoughts are.

Thanks,
Jiaqi

>
> >
> > > +             break;
> > >       default:
> > >               break;
> > >       }
> > > @@ -339,6 +343,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
 long ext)
> > >       case KVM_CAP_ARM_SYSTEM_SUSPEND:
> > >       case KVM_CAP_IRQFD_RESAMPLE:
> > >       case KVM_CAP_COUNTER_OFFSET:
> > > +     case KVM_CAP_ARM_SIGBUS_ON_SEA:
> > >               r =3D 1;
> > >               break;
> > >       case KVM_CAP_SET_GUEST_DEBUG2:
> > > diff --git a/arch/arm64/kvm/kvm_ras.c b/arch/arm64/kvm/kvm_ras.c
> > > new file mode 100644
> > > index 0000000000000..3225462bcbcda
> > > --- /dev/null
> > > +++ b/arch/arm64/kvm/kvm_ras.c
> > > @@ -0,0 +1,77 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +
> > > +#include <linux/bitops.h>
> > > +#include <linux/kvm_host.h>
> > > +
> > > +#include <asm/kvm_emulate.h>
> > > +#include <asm/kvm_ras.h>
> > > +#include <asm/system_misc.h>
> > > +
> > > +/*
> > > + * For synchrnous external instruction or data abort, not on transla=
tion
> > > + * table walk or hardware update of translation table, is FAR_EL2 va=
lid?
> > > + */
> > > +static inline bool kvm_vcpu_sea_far_valid(const struct kvm_vcpu *vcp=
u)
> > > +{
> > > +     return !(vcpu->arch.fault.esr_el2 & ESR_ELx_FnV);
> > > +}
> > > +
> > > +/*
> > > + * Was this synchronous external abort a RAS notification?
> > > + * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
> > > + */
> > > +static int kvm_delegate_guest_sea(phys_addr_t addr, u64 esr)
> > > +{
> > > +     /* apei_claim_sea(NULL) expects to mask interrupts itself */
> > > +     lockdep_assert_irqs_enabled();
> > > +     return apei_claim_sea(NULL);
> > > +}
> > > +
> > > +void kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
> > > +{
> > > +     bool sigbus_on_sea;
> > > +     int idx;
> > > +     u64 vcpu_esr =3D kvm_vcpu_get_esr(vcpu);
> > > +     u8 fsc =3D kvm_vcpu_trap_get_fault(vcpu);
> > > +     phys_addr_t fault_ipa =3D kvm_vcpu_get_fault_ipa(vcpu);
> > > +     gfn_t gfn =3D fault_ipa >> PAGE_SHIFT;
> > > +     /* When FnV is set, send 0 as si_addr like what do_sea() does. =
*/
> > > +     unsigned long hva =3D 0UL;
> > > +
> > > +     /*
> > > +      * For RAS the host kernel may handle this abort.
> > > +      * There is no need to SIGBUS VMM, or pass the error into the g=
uest.
> > > +      */
> > > +     if (kvm_delegate_guest_sea(fault_ipa, vcpu_esr) =3D=3D 0)
> > > +             return;
> > > +
> > > +     sigbus_on_sea =3D test_bit(KVM_ARCH_FLAG_SIGBUS_ON_SEA,
> > > +                              &(vcpu->kvm->arch.flags));
> > > +
> > > +     /*
> > > +      * In addition to userspace opt-in, SIGBUS only makes sense if =
the
> > > +      * abort is NOT about translation table walk and NOT about hard=
ware
> > > +      * update of translation table.
> > > +      */
> > > +     sigbus_on_sea &=3D (fsc =3D=3D ESR_ELx_FSC_EXTABT || fsc =3D=3D=
 ESR_ELx_FSC_SECC);
> > > +
> > > +     /* Pass the error directly into the guest. */
> > > +     if (!sigbus_on_sea) {
> > > +             kvm_inject_vabt(vcpu);
> > > +             return;
> > > +     }
> > > +
> > > +     if (kvm_vcpu_sea_far_valid(vcpu)) {
> > > +             idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> > > +             hva =3D gfn_to_hva(vcpu->kvm, gfn);
> > > +             srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > > +     }
> > > +
> > > +     /*
> > > +      * Send a SIGBUS BUS_OBJERR to vCPU thread (the userspace threa=
d that
> > > +      * runs KVM_RUN) or VMM, which aligns with what host kernel do_=
sea()
> > > +      * does if apei_claim_sea() fails.
> > > +      */
> > > +     arm64_notify_die("synchronous external abort",
> > > +                      current_pt_regs(), SIGBUS, BUS_OBJERR, hva, vc=
pu_esr);
> >
> > This is the point where I really think we should simply trigger an
> > exit with all that syndrome information stashed in kvm_run, like any
> > other event requiring userspace help.
>
> Ah, there is another reason SIGBUS is better than kvm exit: "It is a
> programming error to set ext_dabt_pending after an exit which was not
> either KVM_EXIT_MMIO or KVM_EXIT_ARM_NISV", from
> Documentation/virt/kvm/api.rst. So if VMM is allowed to inject data
> abort to guest, at least current documentation doesn't suggest kvm
> exit is feasible.
>
> >
> > Also: where is the documentation?
>
> Once I get more positive feedback and send out PATCH instead of RFC, I
> can add to Documentation/virt/kvm/api.rst.
>
> >
> > Thanks,
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.

