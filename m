Return-Path: <kvm+bounces-32107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48E569D313C
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 01:00:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09042283FD2
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 00:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857231D12EA;
	Tue, 19 Nov 2024 23:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EPlIzDx3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E5A1D47A0
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 23:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732060682; cv=none; b=capO35kFON8zgq/xLmvVvvpuP/zp1DQkOVRx3Q5rlk5YjQHy3LRzn1NqywtACiTLXr/QRwg3n+QsMVNHQ+69UVTq91i9A2tpYggCe1MW/a7igCQkGwKIPPtLX7lB+WaKs2vQDpgBD5c7tP9Te6H1LcDuFk7uwU6iZuFyOJz4uAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732060682; c=relaxed/simple;
	bh=kxDxvOltSc2VtQhvhkj9Om7SUl1bo0eEoCaIOBzg6Ts=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q6EIwteAU4TMn9/77e8BmFvcw7EtXBs6un24brSLQk9d2yL6ik9/mxJYSeqodWGjIiXVqrU0w+0nDdUl1Pl4vqMIBvKEHe3e6+hd/dLCnKWxMFMHSGws61oQqnMo6kS9BUuAB2nMvPbNinqrgx+fuwtu5PaiT2hPJD9r1dHsuIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EPlIzDx3; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4315ee633dcso83825e9.1
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 15:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732060678; x=1732665478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v46uNHzeBNMnvjId38p1qwnI3AVVrl15Lw3UV9bi4wQ=;
        b=EPlIzDx3Cb+k++PEURiPWYzPGgQnw05WeHJAbfwE31bCLVMuA8UHexcFKsXdmIoNM6
         gRjoPp2tzg6YeQZ1uxMeY6NTY5ngOXEnCnNITua2jdjl7e6u0uwWpTSMCh/E1s+1y0B8
         ZHw+nsWqNfrhsfuugWm90l8VSDPIP6nt/HK9YEOr5zFbBX8L9ZBfYSSkbKkiyxaTbcR7
         8V6s+iwHyr5KP3n3uYmn9ymOWmpkAnJ4mcw4ywtfUhHhuSpzA9Mz5+7npYKpI18V7+Oz
         qS57+qXVFOlqPRXalJIbnPDwo05RUq+7xy53rKYG9TxV4MfrH2pMeBFv3PkOJDNLEie7
         RMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732060678; x=1732665478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v46uNHzeBNMnvjId38p1qwnI3AVVrl15Lw3UV9bi4wQ=;
        b=ckCb/D935veiBdZdZ/m0Yu5dmkYilr2bJPEojutjmSvms00hXNYk9Z2D3XqbJFHQGr
         wlIpSGmv5QSxIzH/3NBMP07PTCCZCJtMfevXKaU5n4nVcCBUAz5rxclAUM2iv8TvYU4o
         c9dm0DMmmZXK4j7zCN217ztEwCfwAj79w7b95+sEYOBVURB8+K9ySTs1m84Hxl0KQTBw
         ZjTPl48n5/AIPeJuGnqOT2bZlRbHhTeC7cdyBd8wltkK+cukdcQhTKLO5OEbJGSILpg+
         H1bbRPW3bRJgUGuUj65Z3goMsqZTFo8yUHju9JIWr5QVAz0A1JL5mVOXWTvbyp2b/p7O
         2mOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgpv4MICvHNRhM9fBixPjwrCSi0QafWiYHBSl1vDRVk2hG8wEAUorDq+oN+ZNghja5OMs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRYuvpN4LTtgFWKo7kTIQzA9qTZpLu6GfgXdinm186r7056E3e
	NEreCKg94MZRQyy6qPFhQjRb0Zk5GbmmWl+NBP+RtXC79x9e0+w/er6iHOJzxi3RKY2hACWlBRq
	EsaAxvo4xoE0eHy9NdFfT2kFHP5sQXJy6qTFc
X-Gm-Gg: ASbGnctS2gCD16HkKh29M7ScTuaWjWU8httmu0VmeiJMQQlxh7K/nt0eamo0A3t9gs8
	A936yiCYBguDwi2zJZ8k3YU15nljWp1l1ybd3Wb+CSl4yNvjgtPayMnYh+tLKbQ==
X-Google-Smtp-Source: AGHT+IERPcks7GP3YYAzBxXg6rE6Ocb65bd0Mv8n9QIxyCaQiZczXPtv+rcuNFzWNZia0WKnqqyIAEqOFfM+O+vwwGY=
X-Received: by 2002:a05:600c:510b:b0:431:43a1:4cac with SMTP id
 5b1f17b1804b1-4339ec6049emr120925e9.3.1732060678202; Tue, 19 Nov 2024
 15:57:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031212104.1429609-1-jiaqiyan@google.com> <86r07v1g2z.wl-maz@kernel.org>
 <CACw3F51FbzkkX_DcCVCieZ=408oP_Fy3sXYk5AjWRX3RJO2Fzg@mail.gmail.com> <878qtou96b.wl-maz@kernel.org>
In-Reply-To: <878qtou96b.wl-maz@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 19 Nov 2024 15:57:46 -0800
Message-ID: <CACw3F50gB40dqQ4CZ7f4X4aRkxHQhjiYunAhqbmVtcGnd5g3bA@mail.gmail.com>
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

Thanks for your comments, Marc.

While continuing the discussion here, I think it may make sense I sent
out a V2 with 2 major updates:
- add documentation for new SIGBUS feature
- remove KVM_CAP_ARM_SIGBUS_ON_SEA

On Tue, Nov 12, 2024 at 12:51=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Mon, 04 Nov 2024 05:02:03 +0000,
> Jiaqi Yan <jiaqiyan@google.com> wrote:
> >
> > Hi Marc, thanks for your quick response!
> >
> > On Fri, Nov 1, 2024 at 6:54=E2=80=AFAM Marc Zyngier <maz@kernel.org> wr=
ote:
> > >
> > > On Thu, 31 Oct 2024 21:21:04 +0000,
> > > Jiaqi Yan <jiaqiyan@google.com> wrote:
> > > >
> > > > Currently KVM handles SEA in guest by injecting async SError into
> > > > guest directly, bypassing VMM, usually results in guest kernel pani=
c.
> > > >
> > > > One major situation of guest SEA is when vCPU consumes uncorrectabl=
e
> > > > memory error on the physical memory. Although SError and guest kern=
el
> > > > panic effectively stops the propagation of corrupted memory, it is =
not
> > > > easy for VMM and guest to recover from memory error in a more grace=
ful
> > > > manner.
> > > >
> > > > Alternatively KVM can send a SIGBUS BUS_OBJERR to VMM/vCPU, just li=
ke
> > > > how core kernel signals SIGBUS BUS_OBJERR to the poison consuming
> > > > thread.
> > >
> > > Can you elaborate on why the delivery of a signal is preferable to
> > > simply exiting back to userspace with a description of the error?
> > > Signals are usually not generated by KVM, and are a pretty twisted wa=
y
> > > to generate an exit.
> >
> > A couple of reasons. First, my intuition is that KVM and core kernel
> > (do_sea) should have aligned behavior when APEI failed to claim the
> > SEA. Second, if we only talk about SEA caused by memory poison
> > consumption, both arm64 and x86 KVM already send SIGBUS to VMM/vCPU
> > thread (kvm_send_hwpoison_signal) to signal hardware memory failure,
> > although the situation is slightly different here, where we have a
> > hardware event, versus a HWPoison flag check or VM_FAULT_HWPOISON
> > returned. But from VMM/vCPU's perspective, hardware event or software
> > level VM_FAULT_HWPOISON, it would be nice if it can react to just the
> > same event, the SIGBUS signal.
> >
> > And there is another reason around your comment on arm64_notify_die.
> >
> > By "exiting back to userspace with a description of the error", are
> > you suggesting KVM_EXIT_MEMORY_FAULT? If so, we may need to add a new
> > flag to tell VMM the error is hardware memory poison, which could be
> > KVM_MEMORY_EXIT_FLAG_USERFAULT[1] if we don't want a specific one (but
> > I think a specific flag for hwpoison is probably clearer).
>
> KVM_MEMORY_EXIT_FLAG_USERFAULT is not upstream, and it isn't clear to
> me if or when it will make it there. But the idea is indeed to treat a
> RAS error as an exit reason.

Let me try again on preferring SIGBUS to KVM_EXIT. At least for memory erro=
r.

Let's say we should really use some KVM_EXIT to describe RAS error
(e.g. KVM_EXIT_MEMORY_FAULT for memory error). Does that mean we need
to change these existing SIGBUSes [1,2] in KVM into KVM_EXIT? Doesn't
it break VMM [3,4] that expects SIGBUS for memory errors?

The difference between [1,2] and the scenario dealt by this patch is
just whether APEI/GHES/memory_failure succeeded in recovering a memory
error or not. Is the idea that the uAPI will be different depending on
successful recovery or not?

[1] https://elixir.bootlin.com/linux/v6.12-rc7/source/arch/arm64/kvm/mmu.c#=
L1576
[2] https://elixir.bootlin.com/linux/v6.12-rc7/source/arch/x86/kvm/mmu/mmu.=
c#L3301
[3] https://github.com/qemu/qemu/blob/master/target/i386/kvm/kvm.c#L738
[4] https://github.com/qemu/qemu/blob/master/target/arm/kvm.c#L2365

>
> >
> > >
> > > > In addition to the benifit that KVM's handling for SEA becomes alig=
ned
> > > > with core kernel behavior
> > > > - The blast radius in VM can be limited to only the consuming threa=
d
> > > >   in guest, instead of entire guest kernel, unless the consumption =
is
> > > >   from guest kernel.
> > > > - VMM now has the chance to do its duties to stop the VM from repea=
tedly
> > > >   consuming corrupted data. For example, VMM can unmap the guest pa=
ge
> > > >   from stage-2 table to intercept forseen memory poison consumption=
,
> > >
> > > Not quite. The VMM doesn't manage stage-2. It can remove the page fro=
m
> > > the VMA if it has it mapped, but that's it. The kernel deals with S2.
> >
> > I should probably not mention the implementation, "unmap from S2".
> > What is needed for preventing repeated consuming memory poison is
> > simply preventing guest access to certain memory pages. There is a
> > work in progress KVM API [1] by my colleague James.
> >
> > [1] https://lpc.events/event/18/contributions/1757/attachments/1442/307=
3/LPC_%20KVM%20Userfault.pdf
> >
> > >
> > > Which brings me to the next subject: when the kernel unmaps the page
> > > at S2, it is likely to use CMOs. Can these CMOs create RAS error
> > > themselves?
> >
> > I assume CMO here means writing dirty cache lines to memory. Writing
> > something new to a poisoned cacheline usually won't cause RAS error.
> > Notifying memory poison usually is delayed to a memory load
> > transaction.
>
> I don't see anything of the sort in the spec. At least R_VGXBJ calls
> out that:
>
> <quote>
> An error is propagated by the PE by one or more of the following
> occurring that would not have been permitted to occur had the fault
> not been activated:
>
> * Consumption of the corrupt value by any instruction, propagating the
> error to the target(s) of the instruction.  This includes:
>
>   - A store of a corrupt value.
> [...]
> </quote>
>
> So while implementations /may/ only act and deliver an error on a
> load, that's only an implementation detail.

Thanks for finding out from the spec, lesson learned. Back to your
original question and assume error will be propagated by the PE, is
your concern that "unmap from S2" will cause a SEA on TTW or hardware
update of translation table level 2 (i.e. DFSC=3D0b010110), which
renders the system into a worse fault state?

>
> >
> > >
> > > >   and for every consumption injects SEA to EL1 with synthetic memor=
y
> > > >   error CPER.
> > >
> > > Why do we need to involve ACPI here? I would expect the production of
> > > an architected error record instead. Or at least be given the option.
> >
> > Sorry, I was just mentioning a specific VMM's implementation. There
> > are definitely multiple options (Machine Check MSRs vs CPER for error
> > description data, SEA vs SDEI vs SPI for notification mechanisms) for
> > how VMM involves the guest to handle memory error. My preference is:
> > VMM populates CPER in guest HEST when VMM instructs KVM to inject
> > i/dabt to the guest.
> >
> > And a word about "be given the option": I think when VMM receives
> > SIGBUS with si_addr=3Dfaulted/poisoned HVA, it's got all these options,
> > like using the si_addr to construct CPER with poisoned guest physical
> > address, or mci_address MSR.
> >
> > >
> > > > Introduce a new KVM ARM capability KVM_CAP_ARM_SIGBUS_ON_SEA. VMM
> > > > can opt in this new capability if it prefers SIGBUS than SError
> > > > injection during VM init. Now SEA handling in KVM works as follows:
> > > > 1. Delegate to APEI/GHES to see if SEA can be claimed by them.
> > > > 2. If APEI failed to claim the SEA and KVM_CAP_ARM_SIGBUS_ON_SEA is
> > > >    enabled for the VM, and the SEA is NOT about translation table,
> > > >    send SIGBUS BUS_OBJERR signal with host virtual address.
> > >
> > > And what if it is? S1 PTs are backed by userspace memory, like
> > > anything else. I don't think we should have a different treatment of
> > > those, because the HW wouldn't treat them differently either.
> >
> > You are talking about ESR_ELx_FSC_SEA_TTW(1), or
> > ESR_ELx_FSC_SEA_TTW(0), right? I think you are right, S1 is no
> > difference.
> >
> > But I think we want to make an exception for SEA about S2 PTs.
>
> S2 PTs are owned by the hypervisor, not by userspace, so I'm fine not
> reporting those through this mechanism.

Ack, will update in the v2.

>
> >
> > >
> > > > 3. Otherwise directly inject async SError to guest.
> > > >
> > > > Tested on a machine running Siryn AmpereOne processor. A in-house V=
MM
> > > > that opts in KVM_CAP_ARM_SIGBUS_ON_SEA started a VM. A dummy applic=
ation
> > > > in VM allocated some memory buffer. The test used EINJ to inject an
> > > > uncorrectable recoverable memory error at a page in the allocated m=
emory
> > > > buffer. The dummy application then consumed the memory error. Some =
hack
> > > > was done to make core kernel's memory_failure triggered by poison
> > > > generation to fail, so KVM had to deal with the SEA guest abort due=
 to
> > > > poison consumption. vCPU thread in VMM received SIGBUS BUS_OBJERR w=
ith
> > > > valid host virtual address of the poisoned page. VMM then injected =
a SEA
> > > > into guest using KVM_SET_VCPU_EVENTS with ext_dabt_pending=3D1. At =
last
> > > > the dummy application in guest was killed by SIGBUS BUS_OBJERR, whi=
le the
> > > > guest survived and continued to run.
> > > >
> > > > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h |  2 +
> > > >  arch/arm64/include/asm/kvm_ras.h  | 20 ++++----
> > > >  arch/arm64/kvm/Makefile           |  2 +-
> > > >  arch/arm64/kvm/arm.c              |  5 ++
> > > >  arch/arm64/kvm/kvm_ras.c          | 77 +++++++++++++++++++++++++++=
++++
> > > >  arch/arm64/kvm/mmu.c              |  8 +---
> > > >  include/uapi/linux/kvm.h          |  1 +
> > > >  7 files changed, 98 insertions(+), 17 deletions(-)
> > > >  create mode 100644 arch/arm64/kvm/kvm_ras.c
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include=
/asm/kvm_host.h
> > > > index bf64fed9820ea..eb37a2489411a 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -334,6 +334,8 @@ struct kvm_arch {
> > > >       /* Fine-Grained UNDEF initialised */
> > > >  #define KVM_ARCH_FLAG_FGU_INITIALIZED                        8
> > > >       unsigned long flags;
> > > > +     /* Instead of injecting SError into guest, SIGBUS VMM */
> > > > +#define KVM_ARCH_FLAG_SIGBUS_ON_SEA                  9
> > >
> > > nit: why do you put this definition out of sequence (below 'flags')?
> >
> > Ah, I will move it on top of flags.
> >
> > >
> > > >
> > > >       /* VM-wide vCPU feature set */
> > > >       DECLARE_BITMAP(vcpu_features, KVM_VCPU_MAX_FEATURES);
> > > > diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/=
asm/kvm_ras.h
> > > > index 87e10d9a635b5..4bb7a424e3f6c 100644
> > > > --- a/arch/arm64/include/asm/kvm_ras.h
> > > > +++ b/arch/arm64/include/asm/kvm_ras.h
> > > > @@ -11,15 +11,17 @@
> > > >  #include <asm/acpi.h>
> > > >
> > > >  /*
> > > > - * Was this synchronous external abort a RAS notification?
> > > > - * Returns '0' for errors handled by some RAS subsystem, or -ENOEN=
T.
> > > > + * Handle synchronous external abort (SEA) in the following order:
> > > > + * 1. Delegate to APEI/GHES to see if SEA can be claimed by them. =
If so, we
> > > > + *    are all done.
> > > > + * 2. If userspace opts in KVM_CAP_ARM_SIGBUS_ON_SEA, and if the S=
EA is NOT
> > > > + *    about translation table, send SIGBUS
> > > > + *    - si_code is BUS_OBJERR.
> > > > + *    - si_addr will be 0 when accurate HVA is unavailable.
> > > > + * 3. Otherwise, directly inject an async SError to guest.
> > > > + *
> > > > + * Note this applies to both ESR_ELx_EC_IABT_* and ESR_ELx_EC_DABT=
_*.
> > > >   */
> > > > -static inline int kvm_handle_guest_sea(phys_addr_t addr, u64 esr)
> > > > -{
> > > > -     /* apei_claim_sea(NULL) expects to mask interrupts itself */
> > > > -     lockdep_assert_irqs_enabled();
> > > > -
> > > > -     return apei_claim_sea(NULL);
> > > > -}
> > > > +void kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
> > > >
> > > >  #endif /* __ARM64_KVM_RAS_H__ */
> > > > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > > > index 3cf7adb2b5038..c4a3a6d4870e6 100644
> > > > --- a/arch/arm64/kvm/Makefile
> > > > +++ b/arch/arm64/kvm/Makefile
> > > > @@ -23,7 +23,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o=
 pvtime.o \
> > > >        vgic/vgic-v3.o vgic/vgic-v4.o \
> > > >        vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
> > > >        vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
> > > > -      vgic/vgic-its.o vgic/vgic-debug.o
> > > > +      vgic/vgic-its.o vgic/vgic-debug.o kvm_ras.o
> > > >
> > > >  kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
> > > >  kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
> > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > index 48cafb65d6acf..bb97ad678dbec 100644
> > > > --- a/arch/arm64/kvm/arm.c
> > > > +++ b/arch/arm64/kvm/arm.c
> > > > @@ -151,6 +151,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > > >               }
> > > >               mutex_unlock(&kvm->slots_lock);
> > > >               break;
> > > > +     case KVM_CAP_ARM_SIGBUS_ON_SEA:
> > > > +             r =3D 0;
> > > > +             set_bit(KVM_ARCH_FLAG_SIGBUS_ON_SEA, &kvm->arch.flags=
);
> > >
> > > Shouldn't this be somehow gated on the VM being RAS aware?
> >
> > Do you mean a CAP that VMM can tell KVM the VM guest has RAS ability?
> > I don't know if there is one for arm64. On x86 there is
> > KVM_X86_SETUP_MCE. KVM_CAP_ARM_INJECT_EXT_DABT maybe a revelant one
> > but I don't think it is exactly the one for "RAS ability".
>
> Having though about this a bit more, I now think this is independent
> of the guest supporting RAS. This really is about the VMM asking to be
> made aware of RAS errors affecting the guest, and it is the signalling
> back to the guest that needs to be gated by ID_AA64PFR0_EL1.RAS.

Just to make sure I fully catch you. I think ID_AA64PFR0_EL1.RAS
translates to ARM64_HAS_RAS_EXTN in the kernel. If VMM signals RAS
error back to the guest with SEA, are you suggesting
__kvm_arm_vcpu_set_events should check
cpus_have_final_cap(ARM64_HAS_RAS_EXTN) before it
kvm_inject_dabt(vcpu)?

If so, how could __kvm_arm_vcpu_set_events know if the error is about
RAS (e.g. memory error) vs about accessing memory not in a memslot
(i.e. KVM_EXIT_ARM_NISV)? I guess KVM needs to look at ESR_EL2 again
(e.g. kvm_vcpu_abt_issea vs kvm_vcpu_dabt_isvalid)?

>
> >
> > >
> > > > +             break;
> > > >       default:
> > > >               break;
> > > >       }
> > > > @@ -339,6 +343,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kv=
m, long ext)
> > > >       case KVM_CAP_ARM_SYSTEM_SUSPEND:
> > > >       case KVM_CAP_IRQFD_RESAMPLE:
> > > >       case KVM_CAP_COUNTER_OFFSET:
> > > > +     case KVM_CAP_ARM_SIGBUS_ON_SEA:
> > > >               r =3D 1;
> > > >               break;
> > > >       case KVM_CAP_SET_GUEST_DEBUG2:
> > > > diff --git a/arch/arm64/kvm/kvm_ras.c b/arch/arm64/kvm/kvm_ras.c
> > > > new file mode 100644
> > > > index 0000000000000..3225462bcbcda
> > > > --- /dev/null
> > > > +++ b/arch/arm64/kvm/kvm_ras.c
> > > > @@ -0,0 +1,77 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > +
> > > > +#include <linux/bitops.h>
> > > > +#include <linux/kvm_host.h>
> > > > +
> > > > +#include <asm/kvm_emulate.h>
> > > > +#include <asm/kvm_ras.h>
> > > > +#include <asm/system_misc.h>
> > > > +
> > > > +/*
> > > > + * For synchrnous external instruction or data abort, not on trans=
lation
> > > > + * table walk or hardware update of translation table, is FAR_EL2 =
valid?
> > > > + */
> > > > +static inline bool kvm_vcpu_sea_far_valid(const struct kvm_vcpu *v=
cpu)
> > > > +{
> > > > +     return !(vcpu->arch.fault.esr_el2 & ESR_ELx_FnV);
> > > > +}
> > > > +
> > > > +/*
> > > > + * Was this synchronous external abort a RAS notification?
> > > > + * Returns '0' for errors handled by some RAS subsystem, or -ENOEN=
T.
> > > > + */
> > > > +static int kvm_delegate_guest_sea(phys_addr_t addr, u64 esr)
> > > > +{
> > > > +     /* apei_claim_sea(NULL) expects to mask interrupts itself */
> > > > +     lockdep_assert_irqs_enabled();
> > > > +     return apei_claim_sea(NULL);
> > > > +}
> > > > +
> > > > +void kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +     bool sigbus_on_sea;
> > > > +     int idx;
> > > > +     u64 vcpu_esr =3D kvm_vcpu_get_esr(vcpu);
> > > > +     u8 fsc =3D kvm_vcpu_trap_get_fault(vcpu);
> > > > +     phys_addr_t fault_ipa =3D kvm_vcpu_get_fault_ipa(vcpu);
> > > > +     gfn_t gfn =3D fault_ipa >> PAGE_SHIFT;
> > > > +     /* When FnV is set, send 0 as si_addr like what do_sea() does=
. */
> > > > +     unsigned long hva =3D 0UL;
> > > > +
> > > > +     /*
> > > > +      * For RAS the host kernel may handle this abort.
> > > > +      * There is no need to SIGBUS VMM, or pass the error into the=
 guest.
> > > > +      */
> > > > +     if (kvm_delegate_guest_sea(fault_ipa, vcpu_esr) =3D=3D 0)
> > > > +             return;
> > > > +
> > > > +     sigbus_on_sea =3D test_bit(KVM_ARCH_FLAG_SIGBUS_ON_SEA,
> > > > +                              &(vcpu->kvm->arch.flags));
> > > > +
> > > > +     /*
> > > > +      * In addition to userspace opt-in, SIGBUS only makes sense i=
f the
> > > > +      * abort is NOT about translation table walk and NOT about ha=
rdware
> > > > +      * update of translation table.
> > > > +      */
> > > > +     sigbus_on_sea &=3D (fsc =3D=3D ESR_ELx_FSC_EXTABT || fsc =3D=
=3D ESR_ELx_FSC_SECC);
> > > > +
> > > > +     /* Pass the error directly into the guest. */
> > > > +     if (!sigbus_on_sea) {
> > > > +             kvm_inject_vabt(vcpu);
> > > > +             return;
> > > > +     }
> > > > +
> > > > +     if (kvm_vcpu_sea_far_valid(vcpu)) {
> > > > +             idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> > > > +             hva =3D gfn_to_hva(vcpu->kvm, gfn);
> > > > +             srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > > > +     }
> > > > +
> > > > +     /*
> > > > +      * Send a SIGBUS BUS_OBJERR to vCPU thread (the userspace thr=
ead that
> > > > +      * runs KVM_RUN) or VMM, which aligns with what host kernel d=
o_sea()
> > > > +      * does if apei_claim_sea() fails.
> > > > +      */
> > > > +     arm64_notify_die("synchronous external abort",
> > > > +                      current_pt_regs(), SIGBUS, BUS_OBJERR, hva, =
vcpu_esr);
> > >
> > > This is the point where I really think we should simply trigger an
> > > exit with all that syndrome information stashed in kvm_run, like any
> > > other event requiring userspace help.
> >
> > Ah, there is another reason SIGBUS is better than kvm exit: "It is a
> > programming error to set ext_dabt_pending after an exit which was not
> > either KVM_EXIT_MMIO or KVM_EXIT_ARM_NISV", from
> > Documentation/virt/kvm/api.rst. So if VMM is allowed to inject data
> > abort to guest, at least current documentation doesn't suggest kvm
> > exit is feasible.
>
> I really can't make the link between the two. If you take this to the
> letter, then you can't inject an external abort on the back of a
> signal handler either.

Sorry for the confusion, I think my understanding of the doc and what
I said were both wrong. It seems to me that what the doc is suggesting
is, the use case of ext_dabt_pending (injecting SEA into guest) for
now is only to enable VMM to handle KVM_EXIT_MMIO and
KVM_EXIT_ARM_NISV.

With the new SIGBUS for memory error, is it fair to update the doc to
say another use case of ext_dabt_pending is to enable VMM to signal
guest of RAS error?

>
> Also, you're obviously changing the UAPI, so everything is fair game
> provided that you don't break backward compatibility.
>
> >
> > >
> > > Also: where is the documentation?
> >
> > Once I get more positive feedback and send out PATCH instead of RFC, I
> > can add to Documentation/virt/kvm/api.rst.
>
> Sorry, but that's a key point for reviewing a UAPI change.

Let me include the doc for the SIGBUS feature in v2.

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

